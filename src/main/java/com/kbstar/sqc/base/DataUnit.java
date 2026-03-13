package com.kbstar.sqc.base;

import com.kbstar.sqc.framework.context.IOnlineContext;
import com.kbstar.sqc.framework.data.IDataSet;
import com.kbstar.sqc.framework.data.IRecordSet;
import com.kbstar.sqc.framework.log.ILog;

public abstract class DataUnit {

    protected ILog getLog(IOnlineContext onlineCtx) {
        return new ILog() {
            @Override public void debug(String msg, Object... args) {}
            @Override public void info(String msg, Object... args) {}
            @Override public void warn(String msg, Object... args) {}
            @Override public void error(String msg, Object... args) {}
        };
    }

    protected int dbInsert(String sqlId, IDataSet param) { return 1; }
    protected IDataSet dbSelect(String sqlId, IDataSet param) { return null; }
    protected IRecordSet dbSelectMulti(String sqlId, IDataSet param) {
        return new IRecordSet() {
            @Override public int getRecordCount() { return 0; }
            @Override public com.kbstar.sqc.framework.data.IRecord getRecord(int index) { return null; }
        };
    }
    protected int dbDelete(String sqlId, IDataSet param) { return 0; }
    protected int dbUpdate(String sqlId, IDataSet param) { return 0; }
}
