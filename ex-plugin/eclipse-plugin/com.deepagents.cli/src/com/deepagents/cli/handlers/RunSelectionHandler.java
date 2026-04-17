package com.deepagents.cli.handlers;

import com.deepagents.cli.views.DeepAgentsView;
import org.eclipse.core.commands.*;
import org.eclipse.jface.text.ITextSelection;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.ui.*;
import org.eclipse.ui.handlers.HandlerUtil;

/**
 * 에디터에서 텍스트를 선택한 뒤 우클릭 → "Send to DeepAgents" 실행 시 호출됨.
 * 선택된 텍스트를 DeepAgents 뷰의 입력창에 전달하고 실행.
 */
public class RunSelectionHandler extends AbstractHandler {

    @Override
    public Object execute(ExecutionEvent event) throws ExecutionException {
        ISelection selection = HandlerUtil.getCurrentSelection(event);
        if (!(selection instanceof ITextSelection)) return null;

        String selectedText = ((ITextSelection) selection).getText().trim();
        if (selectedText.isEmpty()) return null;

        try {
            IWorkbenchPage page = HandlerUtil.getActiveWorkbenchWindow(event).getActivePage();
            DeepAgentsView view = (DeepAgentsView) page.showView(DeepAgentsView.ID);
            view.sendTextFromEditor(selectedText);
        } catch (PartInitException e) {
            throw new ExecutionException("Cannot open DeepAgents view", e);
        }
        return null;
    }
}
