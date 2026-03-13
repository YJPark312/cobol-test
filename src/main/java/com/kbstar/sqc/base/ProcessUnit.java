package com.kbstar.sqc.base;

import com.kbstar.sqc.framework.context.CommonArea;
import com.kbstar.sqc.framework.context.IOnlineContext;
import com.kbstar.sqc.framework.log.ILog;

public abstract class ProcessUnit {

    protected ILog getLog(IOnlineContext onlineCtx) {
        return new ILog() {
            @Override public void debug(String msg, Object... args) {}
            @Override public void info(String msg, Object... args) {}
            @Override public void warn(String msg, Object... args) {}
            @Override public void error(String msg, Object... args) {}
        };
    }

    protected CommonArea getCommonArea(IOnlineContext onlineCtx) {
        return new CommonArea();
    }
}
