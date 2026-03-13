package com.kbstar.sqc.framework.log;

public interface ILog {
    void debug(String msg, Object... args);
    void info(String msg, Object... args);
    void warn(String msg, Object... args);
    void error(String msg, Object... args);
}
