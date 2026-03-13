package com.kbstar.sqc.framework.data;

public interface IRecordSet {
    int getRecordCount();
    IRecord getRecord(int index);
}
