package com.deepagents.cli.util;

import org.eclipse.core.resources.*;
import org.eclipse.core.runtime.IPath;
import org.eclipse.ui.*;
import org.eclipse.ui.ide.IFileEditorInput;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.*;

/**
 * Eclipse 워크스페이스를 MCP 서버로 노출하기 위한 릴레이 클라이언트.
 *
 * 동작 방식:
 *  1. API 서버의 SSE 엔드포인트(GET /mcp-relay/{relayId})에 아웃바운드 연결
 *  2. SSE 스트림으로 MCP JSON-RPC 요청 수신
 *  3. Eclipse 워크스페이스 도구 실행
 *  4. POST /mcp-relay/{relayId}/response 로 결과 전송
 *
 * 지원 도구:
 *  - read_file        : 파일 읽기
 *  - write_file       : 파일 쓰기 (Eclipse 리소스 갱신 포함)
 *  - list_directory   : 디렉토리 목록
 *  - search_files     : glob 패턴으로 파일 검색
 *  - get_workspace_root : 워크스페이스 루트 경로
 *  - get_open_files   : 현재 열린 에디터 파일 목록
 */
public class McpRelayClient {

    /** 상태 변경 콜백 */
    public interface StatusCallback {
        void onStatus(String message);
    }

    private final String baseUrl;
    private final String relayId;
    private volatile boolean running = false;
    private Thread relayThread;
    private StatusCallback statusCallback;

    public McpRelayClient(String baseUrl, String relayId) {
        this.baseUrl = baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
        this.relayId = relayId;
    }

    public void setStatusCallback(StatusCallback cb) {
        this.statusCallback = cb;
    }

    public String getRelayId() {
        return relayId;
    }

    // ── 시작 / 중지 ──────────────────────────────────────────────────────────

    public void start() {
        if (running) return;
        running = true;
        relayThread = new Thread(this::runLoop, "deepagents-mcp-relay");
        relayThread.setDaemon(true);
        relayThread.start();
    }

    public void stop() {
        running = false;
        if (relayThread != null) relayThread.interrupt();
    }

    // ── 재연결 루프 ───────────────────────────────────────────────────────────

    private void runLoop() {
        while (running) {
            try {
                connectAndStream();
            } catch (InterruptedException e) {
                break;
            } catch (Exception e) {
                if (!running) break;
                updateStatus("● MCP 재연결 중...");
                try { Thread.sleep(5_000); } catch (InterruptedException ie) { break; }
            }
        }
        updateStatus("● MCP Stopped");
    }

    private void connectAndStream() throws Exception {
        URL url = new URL(baseUrl + "/mcp-relay/" + relayId);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "text/event-stream");
        conn.setRequestProperty("Cache-Control", "no-cache");
        conn.setConnectTimeout(10_000);
        conn.setReadTimeout(0); // 무한 대기 (서버 종료 시까지)

        if (conn.getResponseCode() != 200) {
            conn.disconnect();
            throw new IOException("HTTP " + conn.getResponseCode());
        }

        updateStatus("● MCP Connected");

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while (running && (line = reader.readLine()) != null) {
                if (!line.startsWith("data: ")) continue;
                String json = line.substring(6).trim();
                if (json.isEmpty()) continue;
                final String request = json;
                Thread t = new Thread(() -> handleRequest(request), "deepagents-mcp-handler");
                t.setDaemon(true);
                t.start();
            }
        } finally {
            conn.disconnect();
            updateStatus("● MCP Disconnected");
        }
    }

    // ── MCP 요청 처리 ────────────────────────────────────────────────────────

    private void handleRequest(String requestJson) {
        String id     = extractJsonString(requestJson, "id");
        String method = extractJsonString(requestJson, "method");

        String response;
        try {
            if ("initialize".equals(method)) {
                response = buildInitializeResponse(id);
            } else if ("tools/list".equals(method)) {
                response = buildToolsListResponse(id);
            } else if ("tools/call".equals(method)) {
                response = handleToolCall(id, requestJson);
            } else {
                response = buildError(id, -32601, "Method not found: " + method);
            }
        } catch (Exception e) {
            response = buildError(id, -32603, "Internal error: " + e.getMessage());
        }

        postResponse(response);
    }

    // ── MCP 응답 빌더 ────────────────────────────────────────────────────────

    private String buildInitializeResponse(String id) {
        return "{\"jsonrpc\":\"2.0\",\"id\":" + jsonStr(id) + ",\"result\":{"
             + "\"protocolVersion\":\"2024-11-05\","
             + "\"capabilities\":{\"tools\":{}},"
             + "\"serverInfo\":{\"name\":\"eclipse-workspace\",\"version\":\"1.0.0\"}}}";
    }

    private String buildToolsListResponse(String id) {
        return "{\"jsonrpc\":\"2.0\",\"id\":" + jsonStr(id) + ",\"result\":{\"tools\":["
            + tool("read_file",
                "Eclipse 워크스페이스의 파일 내용을 읽습니다.",
                "{\"type\":\"object\",\"properties\":{\"path\":{\"type\":\"string\",\"description\":\"워크스페이스 상대경로 또는 절대경로\"}},\"required\":[\"path\"]}")
            + "," + tool("write_file",
                "Eclipse 워크스페이스에 파일을 씁니다. (리소스 자동 갱신)",
                "{\"type\":\"object\",\"properties\":{\"path\":{\"type\":\"string\"},\"content\":{\"type\":\"string\"}},\"required\":[\"path\",\"content\"]}")
            + "," + tool("list_directory",
                "디렉토리 내 파일/폴더 목록을 반환합니다.",
                "{\"type\":\"object\",\"properties\":{\"path\":{\"type\":\"string\",\"description\":\"빈 문자열이면 워크스페이스 루트\",\"default\":\"\"}}}")
            + "," + tool("search_files",
                "워크스페이스에서 glob 패턴으로 파일을 검색합니다. (예: *.java, src/**/*.xml)",
                "{\"type\":\"object\",\"properties\":{\"pattern\":{\"type\":\"string\",\"description\":\"glob 패턴\"}},\"required\":[\"pattern\"]}")
            + "," + tool("get_workspace_root",
                "Eclipse 워크스페이스 루트 절대 경로를 반환합니다.",
                "{\"type\":\"object\",\"properties\":{}}")
            + "," + tool("get_open_files",
                "현재 Eclipse 에디터에서 열려 있는 파일 경로 목록을 반환합니다.",
                "{\"type\":\"object\",\"properties\":{}}")
            + "]}}";
    }

    private String tool(String name, String description, String schema) {
        return "{\"name\":" + jsonStr(name)
             + ",\"description\":" + jsonStr(description)
             + ",\"inputSchema\":" + schema + "}";
    }

    // ── 도구 디스패치 ────────────────────────────────────────────────────────

    private String handleToolCall(String id, String requestJson) {
        String paramsJson = extractJsonObject(requestJson, "params");
        if (paramsJson == null) return buildError(id, -32602, "params 없음");

        String toolName = extractJsonString(paramsJson, "name");
        String argsJson = extractJsonObject(paramsJson, "arguments");

        try {
            String result;
            switch (toolName != null ? toolName : "") {
                case "read_file":        result = toolReadFile(argsJson);        break;
                case "write_file":       result = toolWriteFile(argsJson);       break;
                case "list_directory":   result = toolListDirectory(argsJson);   break;
                case "search_files":     result = toolSearchFiles(argsJson);     break;
                case "get_workspace_root": result = toolGetWorkspaceRoot();      break;
                case "get_open_files":   result = toolGetOpenFiles();            break;
                default:
                    return buildError(id, -32601, "Unknown tool: " + toolName);
            }
            return buildToolResult(id, result, false);
        } catch (Exception e) {
            return buildToolResult(id, "Error: " + e.getMessage(), true);
        }
    }

    // ── 워크스페이스 도구 구현 ────────────────────────────────────────────────

    private String toolReadFile(String argsJson) throws Exception {
        String path = extractJsonString(argsJson, "path");
        if (path == null || path.isEmpty()) throw new IllegalArgumentException("path 필요");
        Path filePath = resolveWsPath(path);
        byte[] bytes = Files.readAllBytes(filePath);
        return new String(bytes, StandardCharsets.UTF_8);
    }

    private String toolWriteFile(String argsJson) throws Exception {
        String path    = extractJsonString(argsJson, "path");
        String content = extractJsonString(argsJson, "content");
        if (path == null || content == null) throw new IllegalArgumentException("path, content 필요");

        Path filePath = resolveWsPath(path);
        Files.createDirectories(filePath.getParent());
        Files.write(filePath, content.getBytes(StandardCharsets.UTF_8));
        refreshEclipseResource(filePath);
        return "OK: " + path + " 저장됨";
    }

    private String toolListDirectory(String argsJson) throws Exception {
        String path = argsJson != null ? extractJsonString(argsJson, "path") : null;
        Path dirPath = (path == null || path.isEmpty()) ? getWsRoot() : resolveWsPath(path);
        if (!Files.isDirectory(dirPath)) throw new IllegalArgumentException("디렉토리가 아님: " + path);

        StringBuilder sb = new StringBuilder("[");
        boolean first = true;
        try (DirectoryStream<Path> stream = Files.newDirectoryStream(dirPath)) {
            for (Path entry : stream) {
                if (!first) sb.append(",");
                boolean isDir = Files.isDirectory(entry);
                sb.append("{\"name\":").append(jsonStr(entry.getFileName().toString()))
                  .append(",\"type\":\"").append(isDir ? "dir" : "file").append("\"")
                  .append(",\"path\":").append(jsonStr(dirPath.relativize(entry).toString()))
                  .append(",\"size\":").append(isDir ? 0 : Files.size(entry))
                  .append("}");
                first = false;
            }
        }
        return sb.append("]").toString();
    }

    private String toolSearchFiles(String argsJson) throws Exception {
        String pattern = extractJsonString(argsJson, "pattern");
        if (pattern == null || pattern.isEmpty()) throw new IllegalArgumentException("pattern 필요");

        Path root = getWsRoot();
        List<String> matches = new ArrayList<>();
        PathMatcher matcher = FileSystems.getDefault().getPathMatcher("glob:**/" + pattern);

        Files.walkFileTree(root, new SimpleFileVisitor<Path>() {
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) {
                if (matcher.matches(file)) matches.add(root.relativize(file).toString());
                return FileVisitResult.CONTINUE;
            }
            @Override
            public FileVisitResult visitFileFailed(Path file, IOException exc) {
                return FileVisitResult.CONTINUE;
            }
        });

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < matches.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(jsonStr(matches.get(i)));
        }
        return sb.append("]").toString();
    }

    private String toolGetWorkspaceRoot() {
        return getWsRoot().toString();
    }

    private String toolGetOpenFiles() {
        final List<String> result = new ArrayList<>();
        PlatformUI.getWorkbench().getDisplay().syncExec(() -> {
            try {
                IWorkbenchWindow window = PlatformUI.getWorkbench().getActiveWorkbenchWindow();
                if (window == null) return;
                for (IEditorReference ref : window.getActivePage().getEditorReferences()) {
                    IEditorInput input = ref.getEditorInput();
                    if (input instanceof IFileEditorInput) {
                        IFile file = ((IFileEditorInput) input).getFile();
                        result.add(file.getLocation().toOSString());
                    }
                }
            } catch (Exception ignored) {}
        });

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < result.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(jsonStr(result.get(i)));
        }
        return sb.append("]").toString();
    }

    // ── 헬퍼 ─────────────────────────────────────────────────────────────────

    private Path getWsRoot() {
        return Paths.get(ResourcesPlugin.getWorkspace().getRoot().getLocation().toOSString());
    }

    private Path resolveWsPath(String path) {
        Path p = Paths.get(path);
        return p.isAbsolute() ? p : getWsRoot().resolve(path);
    }

    private void refreshEclipseResource(Path filePath) {
        try {
            IFile[] files = ResourcesPlugin.getWorkspace().getRoot()
                    .findFilesForLocationURI(filePath.toUri());
            for (IFile file : files) file.refreshLocal(IResource.DEPTH_ZERO, null);
        } catch (Exception ignored) {}
    }

    private void postResponse(String responseJson) {
        try {
            URL url = new URL(baseUrl + "/mcp-relay/" + relayId + "/response");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setConnectTimeout(5_000);
            conn.setReadTimeout(10_000);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            byte[] body = responseJson.getBytes(StandardCharsets.UTF_8);
            try (OutputStream os = conn.getOutputStream()) { os.write(body); }
            conn.getResponseCode();
            conn.disconnect();
        } catch (Exception ignored) {}
    }

    private void updateStatus(String msg) {
        if (statusCallback != null) statusCallback.onStatus(msg);
    }

    // ── JSON 응답 빌더 ────────────────────────────────────────────────────────

    private String buildToolResult(String id, String text, boolean isError) {
        return "{\"jsonrpc\":\"2.0\",\"id\":" + jsonStr(id) + ",\"result\":{"
             + "\"content\":[{\"type\":\"text\",\"text\":" + jsonStr(text) + "}],"
             + "\"isError\":" + isError + "}}";
    }

    private String buildError(String id, int code, String message) {
        return "{\"jsonrpc\":\"2.0\",\"id\":" + (id != null ? jsonStr(id) : "null")
             + ",\"error\":{\"code\":" + code + ",\"message\":" + jsonStr(message) + "}}";
    }

    // ── JSON 파서 (표준 라이브러리만 사용) ────────────────────────────────────

    private String extractJsonString(String json, String key) {
        if (json == null) return null;
        String searchStr = "\"" + key + "\":";
        int idx = json.indexOf(searchStr);
        if (idx < 0) return null;
        int start = idx + searchStr.length();
        while (start < json.length() && json.charAt(start) == ' ') start++;
        if (start >= json.length()) return null;
        char first = json.charAt(start);
        if (first == '"') {
            StringBuilder result = new StringBuilder();
            int i = start + 1;
            while (i < json.length()) {
                char c = json.charAt(i);
                if (c == '\\' && i + 1 < json.length()) {
                    char next = json.charAt(++i);
                    switch (next) {
                        case 'n': result.append('\n'); break;
                        case 'r': result.append('\r'); break;
                        case 't': result.append('\t'); break;
                        default:  result.append(next); break;
                    }
                    i++;
                } else if (c == '"') {
                    break;
                } else {
                    result.append(c);
                    i++;
                }
            }
            return result.toString();
        } else {
            int end = start;
            while (end < json.length() && json.charAt(end) != ',' && json.charAt(end) != '}') end++;
            return json.substring(start, end).trim();
        }
    }

    private String extractJsonObject(String json, String key) {
        if (json == null) return null;
        String searchStr = "\"" + key + "\":";
        int idx = json.indexOf(searchStr);
        if (idx < 0) return null;
        int start = idx + searchStr.length();
        while (start < json.length() && json.charAt(start) == ' ') start++;
        if (start >= json.length()) return null;
        char c = json.charAt(start);
        if (c == '{') return extractBalanced(json, start, '{', '}');
        if (c == '[') return extractBalanced(json, start, '[', ']');
        return null;
    }

    private String extractBalanced(String json, int start, char open, char close) {
        int depth = 0;
        boolean inStr = false;
        for (int i = start; i < json.length(); i++) {
            char c = json.charAt(i);
            if (c == '\\' && inStr) { i++; continue; }
            if (c == '"') { inStr = !inStr; continue; }
            if (inStr) continue;
            if (c == open) depth++;
            else if (c == close && --depth == 0) return json.substring(start, i + 1);
        }
        return null;
    }

    private String jsonStr(String s) {
        if (s == null) return "null";
        return "\"" + s.replace("\\", "\\\\")
                       .replace("\"", "\\\"")
                       .replace("\n", "\\n")
                       .replace("\r", "\\r")
                       .replace("\t", "\\t") + "\"";
    }
}
