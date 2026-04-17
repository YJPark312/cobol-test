package com.deepagents.cli.preferences;

import com.deepagents.cli.Activator;
import org.eclipse.jface.preference.*;
import org.eclipse.ui.*;

public class DeepAgentsPreferencePage extends FieldEditorPreferencePage
        implements IWorkbenchPreferencePage {

    public DeepAgentsPreferencePage() {
        super(GRID);
        setPreferenceStore(Activator.getDefault().getPreferenceStore());
        setDescription("DeepAgents API 서버 설정");
    }

    @Override
    protected void createFieldEditors() {
        addField(new StringFieldEditor(
                PreferenceConstants.API_URL,
                "C2J API Server URL:",
                getFieldEditorParent()));

        addField(new StringFieldEditor(
                PreferenceConstants.USER_ID,
                "User ID (사용자 격리 키):",
                getFieldEditorParent()));

        addField(new BooleanFieldEditor(
                PreferenceConstants.AUTO_APPROVE,
                "Auto-approve (interrupt 없이 자동 승인)",
                getFieldEditorParent()));
    }

    @Override
    public void init(IWorkbench workbench) {}
}
