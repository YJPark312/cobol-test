package com.deepagents.cli.model;

/**
 * POST /session/{id}/convert 요청 바디 — main_v4.py ConversionRequest 대응
 */
public class ConversionRequest {

    private final String programName;
    private final String mode;  // "pipeline" | "direct"

    public ConversionRequest(String programName) {
        this.programName = programName;
        this.mode        = "pipeline";
    }

    public String getProgramName() { return programName; }
    public String getMode()        { return mode; }

    public String toJson() {
        return "{"
            + "\"program_name\":" + jsonStr(programName) + ","
            + "\"mode\":"         + jsonStr(mode)
            + "}";
    }

    private String jsonStr(String s) {
        return "\"" + s.replace("\\", "\\\\")
                       .replace("\"", "\\\"")
                       .replace("\n", "\\n")
                       .replace("\r", "\\r") + "\"";
    }
}
