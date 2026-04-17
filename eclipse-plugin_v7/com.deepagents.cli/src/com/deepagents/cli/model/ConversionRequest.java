package com.deepagents.cli.model;

/**
 * POST /session/{id}/convert 요청 바디 — main_v4.py ConversionRequest 대응
 */
public class ConversionRequest {

    private final String  programName;
    private final String  mode;         // "pipeline" | "direct"
    private final boolean autoApprove;  // true: 이 요청에 한해 interrupt 없이 실행

    public ConversionRequest(String programName, boolean autoApprove) {
        this.programName = programName;
        this.mode        = "pipeline";
        this.autoApprove = autoApprove;
    }

    public String  getProgramName() { return programName; }
    public String  getMode()        { return mode; }
    public boolean isAutoApprove()  { return autoApprove; }

    public String toJson() {
        return "{"
            + "\"program_name\":" + jsonStr(programName) + ","
            + "\"mode\":"         + jsonStr(mode) + ","
            + "\"auto_approve\":" + autoApprove
            + "}";
    }

    private String jsonStr(String s) {
        return "\"" + s.replace("\\", "\\\\")
                       .replace("\"", "\\\"")
                       .replace("\n", "\\n")
                       .replace("\r", "\\r") + "\"";
    }
}
