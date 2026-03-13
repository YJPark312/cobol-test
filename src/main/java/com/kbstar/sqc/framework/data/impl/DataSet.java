package com.kbstar.sqc.framework.data.impl;

import com.kbstar.sqc.framework.data.IDataSet;
import java.util.HashMap;
import java.util.Map;

public class DataSet implements IDataSet {
    private final Map<String, Object> data = new HashMap<>();

    @Override
    public String getString(String key) {
        Object val = data.get(key);
        return val != null ? val.toString() : null;
    }

    @Override
    public int getInt(String key) {
        Object val = data.get(key);
        if (val instanceof Number) return ((Number) val).intValue();
        if (val instanceof String) return Integer.parseInt((String) val);
        return 0;
    }

    @Override
    public void put(String key, Object value) {
        data.put(key, value);
    }
}
