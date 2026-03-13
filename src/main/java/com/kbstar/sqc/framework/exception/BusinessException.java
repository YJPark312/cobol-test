package com.kbstar.sqc.framework.exception;

public class BusinessException extends RuntimeException {
    private final String errorCode;
    private final String actionCode;

    public BusinessException(String errorCode, String actionCode, String message) {
        super(message);
        this.errorCode = errorCode;
        this.actionCode = actionCode;
    }

    public BusinessException(String errorCode, String actionCode, String message, Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
        this.actionCode = actionCode;
    }

    public String getErrorCode() { return errorCode; }
    public String getActionCode() { return actionCode; }
}
