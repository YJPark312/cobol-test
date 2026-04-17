package com.deepagents.cli.preferences;

import com.deepagents.cli.Activator;
import org.eclipse.jface.preference.*;
import org.eclipse.ui.*;

public class DeepAgentsPreferencePage extends FieldEditorPreferencePage
        implements IWorkbenchPreferencePage {

    public DeepAgentsPreferencePage() {
        super(GRID);
        setPreferenceStore(Activator.getDefault().getPreferenceStore());
        setDescription("DeepAgents CLI API 서버 설정");
    }

    @Override
    protected void createFieldEditors() {
        addField(new StringFieldEditor(
                PreferenceConstants.API_URL,
                "API Server URL:",
                getFieldEditorParent()));

        addField(new StringFieldEditor(
                PreferenceConstants.USER_ID,
                "User ID (격리 키):",
                getFieldEditorParent()));

        addField(new StringFieldEditor(
                PreferenceConstants.DEFAULT_AGENT,
                "Default Agent (e.g. coder):",
                getFieldEditorParent()));

        addField(new BooleanFieldEditor(
                PreferenceConstants.AUTO_APPROVE,
                "Auto-approve tool calls",
                getFieldEditorParent()));

        addField(new ComboFieldEditor(
                PreferenceConstants.SHELL_ALLOW,
                "Shell Allow:",
                new String[][] {
                    { "Recommended (safe)", "recommended" },
                    { "All commands",       "all"         },
                    { "None",               ""            },
                },
                getFieldEditorParent()));
    }

    @Override
    public void init(IWorkbench workbench) {}
}
