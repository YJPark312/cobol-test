package com.deepagents.cli.handlers;

import com.deepagents.cli.views.DeepAgentsView;
import org.eclipse.core.commands.*;
import org.eclipse.ui.*;

public class OpenViewHandler extends AbstractHandler {

    @Override
    public Object execute(ExecutionEvent event) throws ExecutionException {
        try {
            IWorkbenchPage page = PlatformUI.getWorkbench()
                    .getActiveWorkbenchWindow().getActivePage();
            page.showView(DeepAgentsView.ID);
        } catch (PartInitException e) {
            throw new ExecutionException("Cannot open DeepAgents view", e);
        }
        return null;
    }
}
