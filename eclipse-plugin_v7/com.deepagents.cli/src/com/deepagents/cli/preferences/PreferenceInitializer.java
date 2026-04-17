package com.deepagents.cli.preferences;

import com.deepagents.cli.Activator;
import org.eclipse.core.runtime.preferences.AbstractPreferenceInitializer;
import org.eclipse.jface.preference.IPreferenceStore;

public class PreferenceInitializer extends AbstractPreferenceInitializer {

    @Override
    public void initializeDefaultPreferences() {
        IPreferenceStore store = Activator.getDefault().getPreferenceStore();
        store.setDefault(PreferenceConstants.API_URL,      "http://localhost:8123");
        store.setDefault(PreferenceConstants.USER_ID,      "");
        store.setDefault(PreferenceConstants.AUTO_APPROVE, false);
    }
}
