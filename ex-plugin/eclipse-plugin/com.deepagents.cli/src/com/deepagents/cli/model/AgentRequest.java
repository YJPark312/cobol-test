package com.deepagents.cli.model;

/**
 * POST /run 요청 바디
 */
public class AgentRequest {

    private String message;
    private String agent;
    private String model;
    private boolean autoApprove;
    private String shellAllow;
    private boolean stream;
    private boolean quiet;

    public AgentRequest(String message) {
        this.message = message;
        this.stream = true;
        this.autoApprove = false;
        this.quiet = true;
    }

    // ── Getters / Setters ──

    public String getMessage()              { return message; }
    public void setMessage(String m)        { this.message = m; }

    public String getAgent()                { return agent; }
    public void setAgent(String a)          { this.agent = a; }

    public String getModel()                { return model; }
    public void setModel(String m)          { this.model = m; }

    public boolean isAutoApprove()          { return autoApprove; }
    public void setAutoApprove(boolean v)   { this.autoApprove = v; }

    public String getShellAllow()           { return shellAllow; }
    public void setShellAllow(String s)     { this.shellAllow = s; }

    public boolean isStream()               { return stream; }
    public void setStream(boolean s)        { this.stream = s; }

    public boolean isQuiet()                { return quiet; }
    public void setQuiet(boolean q)         { this.quiet = q; }

    /** JSON 직렬화 (외부 라이브러리 없이 직접 구현) */
    public String toJson() {
        StringBuilder sb = new StringBuilder("{");
        sb.append("\"message\":").append(jsonStr(message));
        if (agent != null)      sb.append(",\"agent\":").append(jsonStr(agent));
        if (model != null)      sb.append(",\"model\":").append(jsonStr(model));
        if (shellAllow != null) sb.append(",\"shell_allow\":").append(jsonStr(shellAllow));
        sb.append(",\"auto_approve\":").append(autoApprove);
        sb.append(",\"stream\":").append(stream);
        sb.append(",\"quiet\":").append(quiet);
        sb.append("}");
        return sb.toString();
    }

    private String jsonStr(String s) {
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"")
                       .replace("\n", "\\n").replace("\r", "\\r") + "\"";
    }
}
