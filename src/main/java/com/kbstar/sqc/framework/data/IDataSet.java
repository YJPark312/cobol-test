package com.kbstar.sqc.framework.data;

public interface IDataSet {
    String getString(String key);
    int getInt(String key);
    void put(String key, Object value);
}
