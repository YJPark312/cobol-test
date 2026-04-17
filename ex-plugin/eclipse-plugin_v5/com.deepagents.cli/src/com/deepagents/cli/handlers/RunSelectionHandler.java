package com.deepagents.cli.handlers;

import com.deepagents.cli.views.DeepAgentsView;
import org.eclipse.core.commands.*;
import org.eclipse.jface.text.ITextSelection;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.ui.*;
import org.eclipse.ui.handlers.HandlerUtil;

/**
 * 에디터에서 COBOL 파일을 우클릭 → "C2J 전환" 실행 시 호출됨.
 *
 * - 텍스트가 선택된 경우: 선택 텍스트를 자유 입력으로 전송
 * - 선택 없이 COBOL 파일(.cbl/.cob/.cobol)을 열고 있는 경우: 파일명에서 program_name 추출 후 /convert 호출
 */
public class RunSelectionHandler extends AbstractHandler {

    private static final String[] COBOL_EXTS = {".cbl", ".cob", ".cobol", ".CBL", ".COB"};

    @Override
    public Object execute(ExecutionEvent event) throws ExecutionException {
        IWorkbenchPage page = HandlerUtil.getActiveWorkbenchWindow(event).getActivePage();
        DeepAgentsView view;
        try {
            view = (DeepAgentsView) page.showView(DeepAgentsView.ID);
        } catch (PartInitException e) {
            throw new ExecutionException("Cannot open C2J view", e);
        }

        // 텍스트 선택이 있으면 자유 입력 전송
        ISelection selection = HandlerUtil.getCurrentSelection(event);
        if (selection instanceof ITextSelection) {
            String selectedText = ((ITextSelection) selection).getText().trim();
            if (!selectedText.isEmpty()) {
                view.sendTextFromEditor(selectedText);
                return null;
            }
        }

        // COBOL 파일이 열려 있으면 파일명으로 /convert 호출
        IEditorPart editor = page.getActiveEditor();
        if (editor != null && editor.getEditorInput() instanceof IFileEditorInput) {
            String filePath = ((IFileEditorInput) editor.getEditorInput())
                    .getFile().getLocation().toOSString();
            if (isCobolFile(filePath)) {
                // AIPBA30.cbl → AIPBA30
                String programName = java.nio.file.Paths.get(filePath)
                        .getFileName().toString()
                        .replaceAll("\\.[^.]+$", "")
                        .toUpperCase();
                view.startConversion(programName);
                return null;
            }
        }

        // 그 외: 현재 파일 전환 시도 (DeepAgentsView 내부에서 처리)
        view.convertActiveFile();
        return null;
    }

    private boolean isCobolFile(String path) {
        String lower = path.toLowerCase();
        for (String ext : COBOL_EXTS) {
            if (lower.endsWith(ext.toLowerCase())) return true;
        }
        return false;
    }
}
