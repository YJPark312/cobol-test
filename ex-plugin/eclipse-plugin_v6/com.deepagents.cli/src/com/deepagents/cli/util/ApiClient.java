package com.deepagents.cli.util;

import com.deepagents.cli.model.ConversionRequest;
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
 * C2J Pipeline API v4 (main_v4.py) HTTP 클라이언트.
 * Java 표준 라이브러리만 사용 (외부 의존성 없음).
 *
 * SSE 이벤트 타입 (v4 기준):
 *   token           - LLM 텍스트 토큰
 *   tool_start      - 툴 호출 시작 (count 포함)
 *   tool_end        - 툴 호출 완료
 *   interrupt       - 승인 대기 (action_requests 배열 포함)
 *   budget_exceeded - 툴 호출 예산 초과
 *   error           - 에러
 *   done            - 완료 (stop_reason: end_turn | budget_exceeded | error)
 */
public class ApiClient {

    // ── 콜백 인터페이스 ──────────────────────────────────────────────────────

    /** interrupt 발생 시 승인 요청 액션 */
    public static class ActionRequest {
        public final int    index;
        public final String tool;
        public final String argsJson;

        public ActionRequest(int index, String tool, String argsJson) {
            this.index    = index;
            this.tool     = tool;
            this.argsJson = argsJson;
        }
    }

    /** GraphDB CobolProgram 항목 */
    public static class ProgramInfo {
        public final String name;
        public final String programType;
        public final int    linesOfCode;
        public final String description;

        public ProgramInfo(String name, String programType, int linesOfCode, String description) {
            this.name        = name;
            this.programType = programType;
            this.linesOfCode = linesOfCode;
            this.description = description;
        }
    }

    /** 변환 결과 파일 정보 */
    public static class GeneratedFile {
        public final String path;    // workdir 기준 상대 경로 (source/com/example/AIPBA30PU.java)
        public final int    size;
        public final String type;    // "java" | "artifact" (nullable for backward compat)

        public GeneratedFile(String path, int size) {
            this(path, size, null);
        }

        public GeneratedFile(String path, int size, String type) {
            this.path = path;
            this.size = size;
            this.type = type;
        }

        /** 파일명만 반환 (AIPBA30PU.java) */
        public String getFileName() {
            int idx = path.lastIndexOf('/');
            return idx >= 0 ? path.substring(idx + 1) : path;
        }
    }

    /** 사용자 workdir 파일 정보 */
    public static class UserFileInfo {
        public final String path;
        public final int    size;

        public UserFileInfo(String path, int size) {
            this.path = path;
            this.size = size;
        }
    }

    /** /session/{id}/message 또는 /convert SSE 스트리밍 콜백 */
    public interface SessionStreamCallback {
        void onToken(String text);
        void onToolStart(String tool, int count);
        void onToolEnd(String tool);
        void onInterrupt(List<ActionRequest> actions);
        void onBudgetExceeded(String tool, int count, int budget);
        /** stopReason 과 함께 변환 완료된 파일 목록을 전달. 로컬 저장이 필요 없을 때는 무시해도 됨. */
        void onDone(String stopReason, List<GeneratedFile> generatedFiles);
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

    // ── 에이전트 목록 ─────────────────────────────────────────────────────────

    public String listAgents() throws IOException {
        return readBody(openGet("/agents"));
    }

    // ── 세션 API ─────────────────────────────────────────────────────────────

    /**
     * POST /session → 새 세션 생성, session_id 반환.
     */
    public String createSession(String userId) throws IOException {
        String body = "{\"user_id\":" + jsonStr(userId) + "}";
        HttpURLConnection conn = openPost("/session", body);
        int status = conn.getResponseCode();
        if (status != 200) throw new IOException("HTTP " + status);
        String resp      = readBody(conn);
        String sessionId = extractJsonString(resp, "session_id");
        if (sessionId == null) throw new IOException("session_id 없음: " + resp);
        return sessionId;
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

    /** POST /session/{id}/cancel → 실행 중인 작업 중지 */
    public void cancelSession(String sessionId) throws IOException {
        HttpURLConnection conn = openPost("/session/" + sessionId + "/cancel", "{}");
        int status = conn.getResponseCode();
        conn.disconnect();
        if (status != 200 && status != 204) {
            throw new IOException("Cancel failed: HTTP " + status);
        }
    }

    // ── 메시지 전송 ───────────────────────────────────────────────────────────

    /**
     * POST /session/{id}/message → SSE 스트리밍.
     * 자유 텍스트 대화용. COBOL 전환은 startConversion() 사용.
     * UI 스레드 밖에서 호출할 것.
     */
    public void sendSessionMessage(String sessionId, String message, SessionStreamCallback cb) {
        String body = "{\"message\":" + jsonStr(message) + "}";
        streamSse("/session/" + sessionId + "/message", body, cb);
    }

    // ── COBOL 전환 ────────────────────────────────────────────────────────────

    /**
     * POST /session/{id}/convert → SSE 스트리밍.
     * program_name 을 구조화하여 전달 — LLM 텍스트 파싱 의존 없음.
     * UI 스레드 밖에서 호출할 것.
     */
    public void startConversion(String sessionId, ConversionRequest req, SessionStreamCallback cb) {
        streamSse("/session/" + sessionId + "/convert", req.toJson(), cb);
    }

    // ── Interrupt Resume ──────────────────────────────────────────────────────

    /**
     * POST /session/{id}/resume → interrupt 응답.
     * @param decision "approve" | "reject"
     */
    public void resumeSession(String sessionId, String decision, SessionStreamCallback cb) {
        String body = "{\"decisions\":[{\"type\":" + jsonStr(decision) + "}]}";
        streamSse("/session/" + sessionId + "/resume", body, cb);
    }

    // ── 세션 상태 ─────────────────────────────────────────────────────────────

    /** GET /session/{id} → 세션 상태 JSON 반환 */
    public String getSessionStatus(String sessionId) throws IOException {
        return readBody(openGet("/session/" + sessionId));
    }

    // ── GraphDB 프로그램 목록 ─────────────────────────────────────────────────

    /**
     * GET /programs?keyword={kw}&limit={n} → CobolProgram 목록 조회.
     * Eclipse Plugin 목록 UI에서 호출.
     * @param keyword 필터 키워드 (빈 문자열이면 전체)
     * @param limit   최대 반환 수
     */
    public List<ProgramInfo> listPrograms(String keyword, int limit) throws IOException {
        String path = "/programs?limit=" + limit;
        if (keyword != null && !keyword.isEmpty()) {
            path += "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8");
        }
        String json = readBody(openGet(path));
        return parseProgramList(json);
    }

    // ── 사용자 workdir 파일 목록 ─────────────────────────────────────────────

    /**
     * GET /users/{userId}/files → 사용자 workdir 전체 파일 목록 조회.
     * Workspace 탭에서 파일 트리를 구성할 때 사용.
     */
    public List<UserFileInfo> listUserFiles(String userId) throws IOException {
        String json = readBody(openGet("/users/" + java.net.URLEncoder.encode(userId, "UTF-8") + "/files"));
        return parseUserFileList(json);
    }

    /**
     * DELETE /users/{userId}/files/{filePath} → 사용자 workdir 파일/폴더 삭제.
     * @param filePath workdir 기준 상대 경로 (예: AIPBA30/output/analysis_spec.md)
     * @return true if deletion succeeded
     */
    public boolean deleteUserFile(String userId, String filePath) throws IOException {
        String encodedUser = java.net.URLEncoder.encode(userId, "UTF-8");
        String encodedPath = java.net.URLEncoder.encode(filePath, "UTF-8").replace("+", "%20");
        HttpURLConnection conn = openDelete("/users/" + encodedUser + "/files/" + encodedPath);
        int status = conn.getResponseCode();
        conn.disconnect();
        return status == 200;
    }

    // ── 변환 결과 파일 조회 ───────────────────────────────────────────────────

    /**
     * GET /session/{id}/files/{filePath} → 변환된 Java 파일 내용 조회.
     * done 이벤트의 generated_files 목록을 순회하며 각 파일 내용을 가져올 때 사용.
     * @param sessionId 세션 ID
     * @param filePath  workdir 기준 상대 경로 (source/com/example/AIPBA30PU.java)
     * @return 파일 내용 (UTF-8 텍스트)
     */
    public String getGeneratedFileContent(String sessionId, String filePath) throws IOException {
        String encoded = java.net.URLEncoder.encode(filePath, "UTF-8").replace("+", "%20");
        String json = readBody(openGet("/session/" + sessionId + "/files/" + encoded));
        String content = extractJsonString(json, "content");
        return content != null ? content : "";
    }

    /**
     * GET /session/{id}/files → 생성된 Java 파일 목록 조회 (폴링용).
     */
    public List<GeneratedFile> listGeneratedFiles(String sessionId) throws IOException {
        String json = readBody(openGet("/session/" + sessionId + "/files"));
        return parseGeneratedFiles(json);
    }

    // ── SSE 공통 스트리밍 ─────────────────────────────────────────────────────

    private void streamSse(String path, String jsonBody, SessionStreamCallback cb) {
        try {
            HttpURLConnection conn = openPost(path, jsonBody);
            int status = conn.getResponseCode();
            if (status != 200) {
                cb.onError(new IOException("HTTP " + status));
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
                        case "token": {
                            String text = extractJsonString(json, "text");
                            cb.onToken(text != null ? text : "");
                            break;
                        }
                        case "tool_start": {
                            String tool  = extractJsonString(json, "tool");
                            int    count = extractJsonInt(json, "count");
                            cb.onToolStart(tool != null ? tool : "", count);
                            break;
                        }
                        case "tool_end": {
                            String tool = extractJsonString(json, "tool");
                            cb.onToolEnd(tool != null ? tool : "");
                            break;
                        }
                        case "interrupt": {
                            String dataJson = extractJsonObject(json, "data");
                            cb.onInterrupt(parseActionRequests(dataJson));
                            return;
                        }
                        case "budget_exceeded": {
                            String tool   = extractJsonString(json, "tool");
                            int    count  = extractJsonInt(json, "count");
                            int    budget = extractJsonInt(json, "budget");
                            cb.onBudgetExceeded(tool != null ? tool : "", count, budget);
                            break;
                        }
                        case "done": {
                            String reason = extractJsonString(json, "stop_reason");
                            // generated_files 배열 파싱
                            List<GeneratedFile> files = parseGeneratedFiles(json);
                            cb.onDone(reason != null ? reason : "end_turn", files);
                            return;
                        }
                        case "error": {
                            String text = extractJsonString(json, "text");
                            cb.onError(new IOException(text != null ? text : "unknown error"));
                            return;
                        }
                    }
                }
            }
            conn.disconnect();
        } catch (Exception e) {
            cb.onError(e);
        }
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

    private HttpURLConnection openDelete(String path) throws IOException {
        URL url = new URL(baseUrl + path);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("DELETE");
        conn.setConnectTimeout(5_000);
        conn.setReadTimeout(10_000);
        conn.setRequestProperty("Accept", "application/json");
        return conn;
    }

    private HttpURLConnection openPost(String path, String jsonBody) throws IOException {
        URL url = new URL(baseUrl + path);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setConnectTimeout(5_000);
        conn.setReadTimeout(600_000);
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
        try (BufferedReader r = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = r.readLine()) != null) sb.append(line);
        }
        conn.disconnect();
        return sb.toString();
    }

    /** programs 배열 파싱 */
    private List<ProgramInfo> parseProgramList(String json) {
        List<ProgramInfo> list = new ArrayList<>();
        String arrJson = extractJsonArray(json, "programs");
        if (arrJson == null) return list;
        int depth = 0, start = -1;
        for (int i = 0; i < arrJson.length(); i++) {
            char c = arrJson.charAt(i);
            if (c == '{') { if (depth == 0) start = i; depth++; }
            else if (c == '}') {
                depth--;
                if (depth == 0 && start >= 0) {
                    String elem = arrJson.substring(start, i + 1);
                    String name = extractJsonString(elem, "name");
                    String type = extractJsonString(elem, "program_type");
                    int    loc  = extractJsonInt(elem, "lines_of_code");
                    String desc = extractJsonString(elem, "description");
                    if (name != null) {
                        list.add(new ProgramInfo(name,
                                type  != null ? type  : "",
                                loc,
                                desc  != null ? desc  : ""));
                    }
                    start = -1;
                }
            }
        }
        return list;
    }

    /** generated_files 배열 파싱 (done SSE 이벤트 또는 /files 응답) */
    private List<GeneratedFile> parseGeneratedFiles(String json) {
        List<GeneratedFile> list = new ArrayList<>();
        // done SSE: generated_files 키 / /files 응답: files 키 양쪽 시도
        String arrJson = extractJsonArray(json, "generated_files");
        if (arrJson == null) arrJson = extractJsonArray(json, "files");
        if (arrJson == null) return list;
        int depth = 0, start = -1;
        for (int i = 0; i < arrJson.length(); i++) {
            char c = arrJson.charAt(i);
            if (c == '{') { if (depth == 0) start = i; depth++; }
            else if (c == '}') {
                depth--;
                if (depth == 0 && start >= 0) {
                    String elem = arrJson.substring(start, i + 1);
                    String path = extractJsonString(elem, "path");
                    int    size = extractJsonInt(elem, "size");
                    if (path != null) list.add(new GeneratedFile(path, size));
                    start = -1;
                }
            }
        }
        return list;
    }

    private List<UserFileInfo> parseUserFileList(String json) {
        List<UserFileInfo> list = new ArrayList<>();
        String arrJson = extractJsonArray(json, "files");
        if (arrJson == null) return list;
        int depth = 0, start = -1;
        for (int i = 0; i < arrJson.length(); i++) {
            char c = arrJson.charAt(i);
            if (c == '{') { if (depth == 0) start = i; depth++; }
            else if (c == '}') {
                depth--;
                if (depth == 0 && start >= 0) {
                    String elem = arrJson.substring(start, i + 1);
                    String path = extractJsonString(elem, "path");
                    int    size = extractJsonInt(elem, "size");
                    if (path != null) list.add(new UserFileInfo(path, size));
                    start = -1;
                }
            }
        }
        return list;
    }

    private List<ActionRequest> parseActionRequests(String dataJson) {
        List<ActionRequest> list = new ArrayList<>();
        if (dataJson == null) return list;
        String arrJson = extractJsonArray(dataJson, "action_requests");
        if (arrJson == null) return list;
        int depth = 0, start = -1;
        for (int i = 0; i < arrJson.length(); i++) {
            char c = arrJson.charAt(i);
            if (c == '{') { if (depth == 0) start = i; depth++; }
            else if (c == '}') {
                depth--;
                if (depth == 0 && start >= 0) {
                    String elem  = arrJson.substring(start, i + 1);
                    int    index = extractJsonInt(elem, "index");
                    String tool  = extractJsonString(elem, "tool");
                    String args  = extractJsonObject(elem, "args");
                    list.add(new ActionRequest(index, tool != null ? tool : "", args != null ? args : "{}"));
                    start = -1;
                }
            }
        }
        return list;
    }

    private String extractJsonString(String json, String key) {
        String search = "\"" + key + "\"";
        int idx = json.indexOf(search);
        if (idx < 0) return null;
        int colon = json.indexOf(':', idx + search.length());
        if (colon < 0) return null;
        int q1 = json.indexOf('"', colon + 1);
        if (q1 < 0) return null;
        int q2 = q1 + 1;
        while (q2 < json.length()) {
            if (json.charAt(q2) == '"' && json.charAt(q2 - 1) != '\\') break;
            q2++;
        }
        return json.substring(q1 + 1, q2)
                   .replace("\\\"", "\"").replace("\\n", "\n")
                   .replace("\\r", "\r").replace("\\\\", "\\");
    }

    private int extractJsonInt(String json, String key) {
        String search = "\"" + key + "\"";
        int idx = json.indexOf(search);
        if (idx < 0) return 0;
        int colon = json.indexOf(':', idx + search.length());
        if (colon < 0) return 0;
        int start = colon + 1;
        while (start < json.length() && json.charAt(start) == ' ') start++;
        int end = start;
        while (end < json.length() && (Character.isDigit(json.charAt(end)) || json.charAt(end) == '-')) end++;
        try { return Integer.parseInt(json.substring(start, end)); } catch (Exception e) { return 0; }
    }

    private String extractJsonObject(String json, String key) {
        String search = "\"" + key + "\"";
        int idx = json.indexOf(search);
        if (idx < 0) return null;
        int colon = json.indexOf(':', idx + search.length());
        if (colon < 0) return null;
        int start = json.indexOf('{', colon);
        if (start < 0) return null;
        int depth = 0, i = start;
        while (i < json.length()) {
            char c = json.charAt(i);
            if (c == '{') depth++;
            else if (c == '}') { depth--; if (depth == 0) return json.substring(start, i + 1); }
            i++;
        }
        return null;
    }

    private String extractJsonArray(String json, String key) {
        String search = "\"" + key + "\"";
        int idx = json.indexOf(search);
        if (idx < 0) return null;
        int colon = json.indexOf(':', idx + search.length());
        if (colon < 0) return null;
        int start = json.indexOf('[', colon);
        if (start < 0) return null;
        int depth = 0, i = start;
        while (i < json.length()) {
            char c = json.charAt(i);
            if (c == '[') depth++;
            else if (c == ']') { depth--; if (depth == 0) return json.substring(start + 1, i); }
            i++;
        }
        return null;
    }

    private String jsonStr(String s) {
        if (s == null) return "null";
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"")
                       .replace("\n", "\\n").replace("\r", "\\r") + "\"";
    }
}
