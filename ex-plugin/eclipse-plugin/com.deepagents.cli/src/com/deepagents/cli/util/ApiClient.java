package com.deepagents.cli.util;

import com.deepagents.cli.model.AgentRequest;
import com.deepagents.cli.preferences.PreferenceConstants;
import com.deepagents.cli.Activator;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * deepagents API 서버와 통신하는 HTTP 클라이언트
 * Java 표준 라이브러리만 사용 (외부 의존성 없음)
 */
public class ApiClient {

    // ── 콜백 인터페이스 ──────────────────────────────────────────────────────

    /** /run (one-shot) 스트리밍 콜백 */
    public interface StreamCallback {
        void onChunk(String text, String type);
        void onDone(int exitCode);
        void onError(Exception e);
    }

    /** 세션 permission 옵션 */
    public static class PermissionOption {
        public final String id;
        public final String name;
        public PermissionOption(String id, String name) {
            this.id = id;
            this.name = name;
        }
    }

    /** /session/{id}/message SSE 스트리밍 콜백 */
    public interface SessionStreamCallback {
        void onOutput(String text);
        void onTool(String text);
        void onPermission(String tool, List<PermissionOption> options);
        void onDone(String stopReason);
        void onError(Exception e);
    }

    // ── 필드 ─────────────────────────────────────────────────────────────────

    private final String baseUrl;

    public ApiClient() {
        String url = Activator.getDefault()
                .getPreferenceStore()
                .getString(PreferenceConstants.API_URL);
        this.baseUrl = url.endsWith("/") ? url.substring(0, url.length() - 1) : url;
    }

    public ApiClient(String baseUrl) {
        this.baseUrl = baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
    }

    // ── 헬스 체크 ─────────────────────────────────────────────────────────────

    public boolean isServerAlive() {
        try {
            HttpURLConnection conn = openGet("/health");
            int code = conn.getResponseCode();
            conn.disconnect();
            return code == 200;
        } catch (Exception e) {
            return false;
        }
    }

    // ── 기존 one-shot API ────────────────────────────────────────────────────

    public String listAgents() throws IOException {
        return readBody(openGet("/agents"));
    }

    public String listThreads() throws IOException {
        return readBody(openGet("/threads"));
    }

    public String getVersion() throws IOException {
        return readBody(openGet("/version"));
    }

    /** POST /run SSE 스트리밍 */
    public void runStreaming(AgentRequest request, StreamCallback callback) {
        request.setStream(true);
        try {
            HttpURLConnection conn = openPost("/run", request.toJson());
            int status = conn.getResponseCode();
            if (status != 200) {
                callback.onError(new IOException("HTTP " + status));
                return;
            }
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (!line.startsWith("data: ")) continue;
                    String json = line.substring(6).trim();
                    if (json.isEmpty()) continue;
                    String type    = extractJsonString(json, "type");
                    String text    = extractJsonString(json, "text");
                    String exitStr = extractJsonString(json, "exit_code");
                    if ("done".equals(type)) {
                        callback.onDone(exitStr != null ? Integer.parseInt(exitStr) : 0);
                        return;
                    }
                    callback.onChunk(text != null ? text : "", type);
                }
            }
            conn.disconnect();
        } catch (Exception e) {
            callback.onError(e);
        }
    }

    public String runBlocking(AgentRequest request) throws IOException {
        request.setStream(false);
        return readBody(openPost("/run", request.toJson()));
    }

    // ── 세션 API ─────────────────────────────────────────────────────────────

    /**
     * POST /session → 새 세션 생성, session_id 반환
     * @param workdir     작업 디렉토리 (null 이면 서버 기본값)
     * @param autoApprove true 면 서버가 tool 권한을 자동 승인
     * @param userId      사용자 격리 키 (null 이면 비격리 모드)
     */
    public String createSession(String workdir, boolean autoApprove, String userId, String relayId) throws IOException {
        StringBuilder body = new StringBuilder("{");
        body.append("\"auto_approve\":").append(autoApprove);
        if (workdir != null && !workdir.isEmpty()) {
            body.append(",\"workdir\":").append(jsonStr(workdir));
        }
        if (userId != null && !userId.isEmpty()) {
            body.append(",\"user_id\":").append(jsonStr(userId));
        }
        if (relayId != null && !relayId.isEmpty()) {
            body.append(",\"relay_id\":").append(jsonStr(relayId));
        }
        body.append("}");

        HttpURLConnection conn = openPost("/session", body.toString());
        int status = conn.getResponseCode();
        if (status != 200) throw new IOException("HTTP " + status);
        String resp = readBody(conn);
        String sessionId = extractJsonString(resp, "session_id");
        if (sessionId == null) throw new IOException("session_id 없음: " + resp);
        return sessionId;
    }

    /**
     * POST /users/{userId}/init → 사용자 디렉토리 초기화
     * 세션 생성 시 자동 처리되지만 미리 호출할 수도 있음
     */
    public void initUser(String userId) throws IOException {
        HttpURLConnection conn = openPost("/users/" + userId + "/init", "{}");
        int status = conn.getResponseCode();
        conn.disconnect();
        if (status != 200) throw new IOException("HTTP " + status);
    }

    /**
     * GET /users/{userId}/skills → 공용/개인 skills 목록 반환
     * Returns raw JSON string
     */
    public String listUserSkills(String userId) throws IOException {
        return readBody(openGet("/users/" + userId + "/skills"));
    }

    /**
     * POST /session/{id}/message → SSE 스트리밍
     * permission 이벤트가 오면 callback.onPermission() 호출 후 스트림 일시 중단.
     * 사용자가 replyPermission() 을 호출하면 스트림이 재개됨.
     * UI 스레드 밖에서 호출할 것.
     */
    public void sendSessionMessage(String sessionId, String message, SessionStreamCallback callback) {
        String body = "{\"message\":" + jsonStr(message) + "}";
        try {
            HttpURLConnection conn = openPost("/session/" + sessionId + "/message", body);
            int status = conn.getResponseCode();
            if (status != 200) {
                callback.onError(new IOException("HTTP " + status));
                return;
            }
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (!line.startsWith("data: ")) continue;
                    String json = line.substring(6).trim();
                    if (json.isEmpty()) continue;

                    String type = extractJsonString(json, "type");
                    if (type == null) continue;

                    switch (type) {
                        case "output": {
                            String data = extractJsonString(json, "data");
                            callback.onOutput(data != null ? data : "");
                            break;
                        }
                        case "tool": {
                            String data = extractJsonString(json, "data");
                            callback.onTool(data != null ? data : "");
                            break;
                        }
                        case "permission": {
                            String dataJson = extractJsonObject(json, "data");
                            if (dataJson != null) {
                                String tool = extractJsonString(dataJson, "tool");
                                List<PermissionOption> options = parsePermissionOptions(dataJson);
                                callback.onPermission(tool != null ? tool : "", options);
                            }
                            break;
                        }
                        case "done": {
                            String data = extractJsonString(json, "data");
                            callback.onDone(data != null ? data : "end_turn");
                            return;
                        }
                        case "error": {
                            String data = extractJsonString(json, "data");
                            callback.onError(new IOException(data != null ? data : "unknown error"));
                            break;
                        }
                    }
                }
            }
            conn.disconnect();
        } catch (Exception e) {
            callback.onError(e);
        }
    }

    /**
     * POST /session/{id}/reply → permission 이벤트에 응답
     * @param optionId 선택한 옵션 ID, 거부 시 "__deny__"
     */
    public void replyPermission(String sessionId, String optionId) throws IOException {
        String body = "{\"option_id\":" + jsonStr(optionId) + "}";
        HttpURLConnection conn = openPost("/session/" + sessionId + "/reply", body);
        int status = conn.getResponseCode();
        conn.disconnect();
        if (status != 200) throw new IOException("HTTP " + status);
    }

    /** DELETE /session/{id} → 세션 종료 */
    public void closeSession(String sessionId) {
        try {
            URL url = new URL(baseUrl + "/session/" + sessionId);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("DELETE");
            conn.setConnectTimeout(3_000);
            conn.setReadTimeout(3_000);
            conn.getResponseCode();
            conn.disconnect();
        } catch (Exception ignored) {}
    }

    // ── 내부 헬퍼 ─────────────────────────────────────────────────────────────

    private HttpURLConnection openGet(String path) throws IOException {
        URL url = new URL(baseUrl + path);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5_000);
        conn.setReadTimeout(120_000);
        conn.setRequestProperty("Accept", "application/json");
        return conn;
    }

    private HttpURLConnection openPost(String path, String jsonBody) throws IOException {
        URL url = new URL(baseUrl + path);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setConnectTimeout(5_000);
        conn.setReadTimeout(300_000);
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setRequestProperty("Accept", "text/event-stream, application/json");
        byte[] body = jsonBody.getBytes(StandardCharsets.UTF_8);
        try (OutputStream os = conn.getOutputStream()) {
            os.write(body);
        }
        return conn;
    }

    private String readBody(HttpURLConnection conn) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line).append("\n");
        }
        conn.disconnect();
        return sb.toString().trim();
    }

    /** "key":"value" 또는 "key":number 추출 */
    private String extractJsonString(String json, String key) {
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
                    char next = json.charAt(i + 1);
                    switch (next) {
                        case 'n':  result.append('\n'); i += 2; break;
                        case 'r':  result.append('\r'); i += 2; break;
                        case 't':  result.append('\t'); i += 2; break;
                        case '"':  result.append('"');  i += 2; break;
                        case '\\': result.append('\\'); i += 2; break;
                        default:   result.append(next); i += 2; break;
                    }
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

    /** "key":{...} 에서 중괄호 블록 추출 */
    private String extractJsonObject(String json, String key) {
        String searchStr = "\"" + key + "\":";
        int idx = json.indexOf(searchStr);
        if (idx < 0) return null;
        int start = idx + searchStr.length();
        while (start < json.length() && json.charAt(start) == ' ') start++;
        if (start >= json.length() || json.charAt(start) != '{') return null;
        return extractBalanced(json, start, '{', '}');
    }

    /** start 위치부터 open/close 괄호 쌍을 찾아 블록 반환 */
    private String extractBalanced(String json, int start, char open, char close) {
        int depth = 0;
        for (int i = start; i < json.length(); i++) {
            char c = json.charAt(i);
            if (c == open) depth++;
            else if (c == close) {
                depth--;
                if (depth == 0) return json.substring(start, i + 1);
            }
        }
        return null;
    }

    /** "options": [{...},{...}] 파싱 (공백 있는 경우도 처리) */
    private List<PermissionOption> parsePermissionOptions(String json) {
        List<PermissionOption> list = new ArrayList<>();
        String searchStr = "\"options\":";
        int idx = json.indexOf(searchStr);
        if (idx < 0) return list;
        int pos = idx + searchStr.length();
        // ':' 뒤 공백 스킵 후 '[' 확인
        while (pos < json.length() && json.charAt(pos) == ' ') pos++;
        if (pos >= json.length() || json.charAt(pos) != '[') return list;
        pos++; // skip '['

        while (pos < json.length()) {
            // 다음 { 찾기
            while (pos < json.length() && json.charAt(pos) != '{' && json.charAt(pos) != ']') pos++;
            if (pos >= json.length() || json.charAt(pos) == ']') break;

            String obj = extractBalanced(json, pos, '{', '}');
            if (obj == null) break;

            String id   = extractJsonString(obj, "id");
            String name = extractJsonString(obj, "name");
            if (id != null && name != null) list.add(new PermissionOption(id, name));

            pos += obj.length();
        }
        return list;
    }

    private String jsonStr(String s) {
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"")
                       .replace("\n", "\\n").replace("\r", "\\r") + "\"";
    }
}
