package com.deepagents.cli.views;

import com.deepagents.cli.Activator;
import com.deepagents.cli.model.ConversionRequest;
import com.deepagents.cli.preferences.PreferenceConstants;
import com.deepagents.cli.util.ApiClient;
import com.deepagents.cli.util.ApiClient.ActionRequest;
import com.deepagents.cli.util.ApiClient.GeneratedFile;
import com.deepagents.cli.util.ApiClient.ProgramInfo;
import com.deepagents.cli.util.ApiClient.SessionStreamCallback;

import org.eclipse.core.resources.*;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.StyleRange;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.events.*;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.layout.*;
import org.eclipse.swt.widgets.*;
import org.eclipse.ui.*;
import org.eclipse.ui.ide.IDE;
import org.eclipse.ui.part.ViewPart;

import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.List;

/**
 * C2J Pipeline Eclipse View
 *
 * ┌─────────────────────────────────────────────────────┐
 * │ [Auto-approve] [Refresh] [Clear] [New Session]      │
 * │ 검색: [________] [🔍]   status: ● Session Active    │
 * ├──────────────┬──────────────────────────────────────┤
 * │ AIPBA30  512 │                                      │
 * │ AIPBA31  320 │  ▶ COBOL→Java 전환 시작: AIPBA30      │
 * │ BIPBA10  210 │  🔧 [12] analysis-agent 호출 중... ✓  │
 * │ ...          │  ✅ 완료 — 생성 파일 3개              │
 * │              │  → AIPBA30PU.java (저장됨)            │
 * ├──────────────┴──────────────────────────────────────┤
 * │ [입력창_______________________] [C2J 전환] [Send]   │
 * └─────────────────────────────────────────────────────┘
 *
 * 동작:
 * 1. 뷰 열기 → GraphDB에서 CobolProgram 목록 자동 로드
 * 2. 목록에서 프로그램 더블클릭 or 선택 후 "C2J 전환" → /convert 호출
 * 3. SSE 스트리밍 실시간 출력
 * 4. done 이벤트 → generated_files 목록 수신 → /files/{path}로 내용 조회
 *    → Eclipse IFile.create()로 프로젝트에 자동 저장
 * 5. interrupt → 뷰 하단 승인/거부 버튼 표시
 */
public class DeepAgentsView extends ViewPart {

    public static final String ID = "com.deepagents.cli.views.DeepAgentsView";

    // ── UI 컴포넌트 ───────────────────────────────────────────────────────────
    private StyledText  outputText;
    private Text        inputText;
    private Text        searchText;
    private Table       programTable;
    private Button      sendButton;
    private Button      convertButton;
    private Button      autoApproveCheck;
    private Label       statusLabel;
    private Label       toolCountLabel;
    private Composite   interruptPanel;
    private Composite   bottomArea;

    // ── 상태 ─────────────────────────────────────────────────────────────────
    private ApiClient        apiClient;
    private volatile String  currentSessionId    = null;
    private volatile boolean sessionInitializing = false;
    private volatile boolean running             = false;
    private volatile int     toolCallCount       = 0;
    private volatile List<ActionRequest> pendingActions = null;

    // ── 색상 ─────────────────────────────────────────────────────────────────
    private Color colorGreen, colorCyan, colorYellow, colorRed, colorGray, colorOrange;

    // ─────────────────────────────────────────────────────────────────────────
    // 뷰 생성
    // ─────────────────────────────────────────────────────────────────────────

    @Override
    public void createPartControl(Composite parent) {
        apiClient = new ApiClient();
        Display display = parent.getDisplay();

        colorGreen  = display.getSystemColor(SWT.COLOR_GREEN);
        colorCyan   = display.getSystemColor(SWT.COLOR_CYAN);
        colorYellow = display.getSystemColor(SWT.COLOR_YELLOW);
        colorRed    = display.getSystemColor(SWT.COLOR_RED);
        colorGray   = display.getSystemColor(SWT.COLOR_DARK_GRAY);
        colorOrange = new Color(display, 255, 165, 0);

        parent.setLayout(new GridLayout(1, false));

        buildToolbar(parent);
        buildMainArea(parent);   // 좌: 프로그램 목록 / 우: 출력 영역

        bottomArea = new Composite(parent, SWT.NONE);
        bottomArea.setLayout(new GridLayout(1, false));
        bottomArea.setLayoutData(new GridData(SWT.FILL, SWT.BOTTOM, true, false));

        buildInputBar(bottomArea);

        checkServerAndInitSession();
    }

    // ── 툴바 ─────────────────────────────────────────────────────────────────

    private void buildToolbar(Composite parent) {
        Composite toolbar = new Composite(parent, SWT.NONE);
        toolbar.setLayout(new RowLayout(SWT.HORIZONTAL));
        toolbar.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));

        autoApproveCheck = new Button(toolbar, SWT.CHECK);
        autoApproveCheck.setText("Auto-approve");
        autoApproveCheck.setSelection(
                Activator.getDefault().getPreferenceStore()
                        .getBoolean(PreferenceConstants.AUTO_APPROVE));

        Button refreshBtn = new Button(toolbar, SWT.PUSH);
        refreshBtn.setText("Refresh");
        refreshBtn.addListener(SWT.Selection, e -> loadProgramList(""));

        Button clearBtn = new Button(toolbar, SWT.PUSH);
        clearBtn.setText("Clear");
        clearBtn.addListener(SWT.Selection, e -> clearOutput());

        Button newSessionBtn = new Button(toolbar, SWT.PUSH);
        newSessionBtn.setText("New Session");
        newSessionBtn.addListener(SWT.Selection, e -> initSession());

        statusLabel = new Label(toolbar, SWT.NONE);
        statusLabel.setText("● Ready");

        toolCountLabel = new Label(toolbar, SWT.NONE);
        toolCountLabel.setText("tools: 0");
        toolCountLabel.setForeground(parent.getDisplay().getSystemColor(SWT.COLOR_DARK_GRAY));
    }

    // ── 메인 영역 (좌: 프로그램 목록 / 우: 출력) ─────────────────────────────

    private void buildMainArea(Composite parent) {
        SashForm sash = new SashForm(parent, SWT.HORIZONTAL);
        sash.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true));

        buildProgramPanel(sash);
        buildOutputArea(sash);

        sash.setWeights(new int[]{25, 75});
    }

    // ── 좌측: 프로그램 목록 패널 ─────────────────────────────────────────────

    private void buildProgramPanel(Composite parent) {
        Composite panel = new Composite(parent, SWT.NONE);
        panel.setLayout(new GridLayout(1, false));

        // 검색 바
        Composite searchBar = new Composite(panel, SWT.NONE);
        searchBar.setLayout(new GridLayout(2, false));
        searchBar.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));

        searchText = new Text(searchBar, SWT.BORDER | SWT.SINGLE);
        searchText.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
        searchText.setMessage("프로그램 검색...");
        searchText.addKeyListener(new KeyAdapter() {
            @Override public void keyPressed(KeyEvent e) {
                if (e.keyCode == SWT.CR || e.keyCode == SWT.KEYPAD_CR) {
                    loadProgramList(searchText.getText().trim());
                }
            }
        });

        Button searchBtn = new Button(searchBar, SWT.PUSH);
        searchBtn.setText("🔍");
        searchBtn.addListener(SWT.Selection, e -> loadProgramList(searchText.getText().trim()));

        // 프로그램 테이블
        programTable = new Table(panel, SWT.BORDER | SWT.FULL_SELECTION | SWT.SINGLE | SWT.V_SCROLL);
        programTable.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true));
        programTable.setHeaderVisible(true);

        TableColumn colName = new TableColumn(programTable, SWT.LEFT);
        colName.setText("프로그램");
        colName.setWidth(110);

        TableColumn colLoc = new TableColumn(programTable, SWT.RIGHT);
        colLoc.setText("LOC");
        colLoc.setWidth(50);

        TableColumn colType = new TableColumn(programTable, SWT.LEFT);
        colType.setText("유형");
        colType.setWidth(55);

        // 더블클릭 → 바로 전환 시작
        programTable.addListener(SWT.DefaultSelection, e -> {
            String prog = getSelectedProgramName();
            if (prog != null) startConversion(prog);
        });

        // C2J 전환 버튼 (선택 후 클릭)
        convertButton = new Button(panel, SWT.PUSH);
        convertButton.setText("▶ C2J 전환");
        convertButton.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
        convertButton.addListener(SWT.Selection, e -> {
            String prog = getSelectedProgramName();
            if (prog != null) startConversion(prog);
            else appendOutput("[!] 목록에서 프로그램을 선택하세요.\n", colorYellow);
        });
    }

    // ── 우측: 출력 영역 ───────────────────────────────────────────────────────

    private void buildOutputArea(Composite parent) {
        outputText = new StyledText(parent,
                SWT.MULTI | SWT.BORDER | SWT.V_SCROLL | SWT.H_SCROLL | SWT.READ_ONLY | SWT.WRAP);
        outputText.setFont(new org.eclipse.swt.graphics.Font(
                parent.getDisplay(), "Monospace", 10, SWT.NORMAL));
        outputText.setBackground(parent.getDisplay().getSystemColor(SWT.COLOR_BLACK));
        outputText.setForeground(parent.getDisplay().getSystemColor(SWT.COLOR_GREEN));
    }

    // ── 하단 입력 바 ─────────────────────────────────────────────────────────

    private void buildInputBar(Composite parent) {
        Composite inputBar = new Composite(parent, SWT.NONE);
        inputBar.setLayout(new GridLayout(2, false));
        inputBar.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));

        inputText = new Text(inputBar, SWT.BORDER | SWT.SINGLE);
        inputText.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
        inputText.setMessage("자유 메시지 입력...");
        inputText.addKeyListener(new KeyAdapter() {
            @Override public void keyPressed(KeyEvent e) {
                if ((e.keyCode == SWT.CR || e.keyCode == SWT.KEYPAD_CR)
                        && (e.stateMask & SWT.SHIFT) == 0) {
                    sendMessage();
                }
            }
        });

        sendButton = new Button(inputBar, SWT.PUSH);
        sendButton.setText("Send");
        sendButton.addListener(SWT.Selection, e -> sendMessage());
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 서버 연결 & 세션 초기화
    // ─────────────────────────────────────────────────────────────────────────

    private void checkServerAndInitSession() {
        new Thread(() -> {
            boolean alive = apiClient.isServerAlive();
            Display display = getSite().getShell().getDisplay();
            display.asyncExec(() -> {
                if (alive) {
                    setStatus("● Connected", SWT.COLOR_DARK_GREEN);
                    appendOutput("[C2J API 서버 연결됨]\n", colorGreen);
                    initSession();
                    loadProgramList("");   // 프로그램 목록 초기 로드
                } else {
                    setStatus("● Disconnected", SWT.COLOR_RED);
                    appendOutput("[!] API 서버에 연결할 수 없습니다.\n", colorRed);
                }
            });
        }, "c2j-health").start();
    }

    private void initSession() {
        if (sessionInitializing) return;
        sessionInitializing = true;

        if (currentSessionId != null) {
            String old = currentSessionId;
            currentSessionId = null;
            new Thread(() -> apiClient.closeSession(old), "c2j-close").start();
        }

        IPreferenceStore prefs  = Activator.getDefault().getPreferenceStore();
        String userId = prefs.getString(PreferenceConstants.USER_ID).trim();
        if (userId.isEmpty()) userId = System.getProperty("user.name", "eclipse-user");

        final String finalUserId = userId;
        new Thread(() -> {
            try {
                String sessionId = apiClient.createSession(finalUserId);
                currentSessionId = sessionId;
                toolCallCount    = 0;
                appendOutput("[세션 시작: " + sessionId.substring(0, 8) + "... user=" + finalUserId + "]\n", colorGreen);
                getSite().getShell().getDisplay().asyncExec(() -> {
                    setStatus("● Session Active", SWT.COLOR_DARK_GREEN);
                    updateToolCount(0);
                });
            } catch (Exception e) {
                appendOutput("[세션 생성 실패: " + e.getMessage() + "]\n", colorRed);
            } finally {
                sessionInitializing = false;
            }
        }, "c2j-init").start();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GraphDB 프로그램 목록 로드
    // ─────────────────────────────────────────────────────────────────────────

    private void loadProgramList(String keyword) {
        new Thread(() -> {
            try {
                List<ProgramInfo> programs = apiClient.listPrograms(keyword, 200);
                getSite().getShell().getDisplay().asyncExec(() -> {
                    if (programTable.isDisposed()) return;
                    programTable.removeAll();
                    for (ProgramInfo p : programs) {
                        TableItem item = new TableItem(programTable, SWT.NONE);
                        item.setText(0, p.name);
                        item.setText(1, p.linesOfCode > 0 ? String.valueOf(p.linesOfCode) : "-");
                        item.setText(2, p.programType != null ? p.programType : "");
                        item.setData(p);  // ProgramInfo 보관
                    }
                    appendOutput("[프로그램 " + programs.size() + "개 로드됨"
                            + (keyword.isEmpty() ? "" : " (필터: " + keyword + ")") + "]\n", colorGray);
                });
            } catch (Exception e) {
                appendOutput("[!] 프로그램 목록 로드 실패: " + e.getMessage() + "\n", colorRed);
            }
        }, "c2j-programs").start();
    }

    private String getSelectedProgramName() {
        if (programTable.isDisposed()) return null;
        TableItem[] sel = programTable.getSelection();
        if (sel.length == 0) return null;
        return sel[0].getText(0);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // COBOL 전환
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * 프로그램명으로 /convert 호출.
     * 목록 더블클릭, "C2J 전환" 버튼, RunSelectionHandler에서 호출.
     */
    public void startConversion(String programName) {
        if (running) { appendOutput("[!] 이미 실행 중입니다.\n", colorYellow); return; }
        if (currentSessionId == null) { appendOutput("[!] 세션이 없습니다.\n", colorYellow); return; }

        appendOutput("\n▶ COBOL→Java 전환 시작: " + programName + "\n", colorCyan);
        setRunning(true);

        String sessionId = currentSessionId;
        ConversionRequest req = new ConversionRequest(programName);

        new Thread(() ->
            apiClient.startConversion(sessionId, req, makeCallback(sessionId)),
        "c2j-convert").start();
    }

    /**
     * 현재 에디터에서 파일명을 추출해 전환.
     * 우클릭 핸들러에서 COBOL 파일을 감지하지 못했을 때 fallback.
     */
    public void convertActiveFile() {
        final String[] filePath = {null};
        getSite().getShell().getDisplay().syncExec(() -> {
            IEditorPart editor = getSite().getPage().getActiveEditor();
            if (editor != null && editor.getEditorInput() instanceof IFileEditorInput) {
                filePath[0] = ((IFileEditorInput) editor.getEditorInput())
                        .getFile().getLocation().toOSString();
            }
        });
        if (filePath[0] == null) {
            appendOutput("[!] 변환할 COBOL 파일을 에디터에서 열어주세요.\n", colorYellow);
            return;
        }
        String programName = Paths.get(filePath[0]).getFileName().toString()
                .replaceAll("\\.[^.]+$", "").toUpperCase();
        startConversion(programName);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 자유 메시지 전송
    // ─────────────────────────────────────────────────────────────────────────

    private void sendMessage() {
        if (running) { appendOutput("[!] 이미 실행 중입니다.\n", colorYellow); return; }
        String msg = inputText.getText().trim();
        if (msg.isEmpty()) return;
        inputText.setText("");
        appendOutput("\n> " + msg + "\n", colorCyan);
        if (currentSessionId == null) { appendOutput("[!] 세션이 없습니다.\n", colorYellow); return; }
        setRunning(true);
        String sessionId = currentSessionId;
        new Thread(() ->
            apiClient.sendSessionMessage(sessionId, msg, makeCallback(sessionId)),
        "c2j-message").start();
    }

    /** RunSelectionHandler에서 선택 텍스트를 전송할 때 사용 */
    public void sendTextFromEditor(String text) {
        getSite().getShell().getDisplay().asyncExec(() -> {
            inputText.setText(text);
            sendMessage();
        });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // SSE 콜백 — 공통
    // ─────────────────────────────────────────────────────────────────────────

    private SessionStreamCallback makeCallback(String sessionId) {
        return new SessionStreamCallback() {

            @Override public void onToken(String text) {
                appendOutput(text, colorGreen);
            }

            @Override public void onToolStart(String tool, int count) {
                toolCallCount = count;
                appendOutput("\n  🔧 [" + count + "] " + tool + " 호출 중...", colorCyan);
                getSite().getShell().getDisplay().asyncExec(() -> updateToolCount(count));
            }

            @Override public void onToolEnd(String tool) {
                appendOutput(" ✓\n", colorGray);
            }

            @Override public void onInterrupt(List<ActionRequest> actions) {
                pendingActions = actions;
                getSite().getShell().getDisplay().asyncExec(() -> showInterruptPanel(actions));
            }

            @Override public void onBudgetExceeded(String tool, int count, int budget) {
                appendOutput("\n🚫 툴 예산 초과: " + count + "/" + budget + "\n", colorOrange);
                setRunning(false);
            }

            @Override public void onDone(String stopReason, List<GeneratedFile> generatedFiles) {
                int count = generatedFiles != null ? generatedFiles.size() : 0;
                appendOutput("\n✅ 완료 (" + stopReason + ")"
                        + (count > 0 ? " — 생성 파일 " + count + "개" : "") + "\n", colorGreen);

                // 생성된 Java 파일을 Eclipse 프로젝트에 자동 저장
                if (generatedFiles != null && !generatedFiles.isEmpty()) {
                    saveGeneratedFiles(sessionId, generatedFiles);
                }
                setRunning(false);
            }

            @Override public void onError(Exception e) {
                appendOutput("\n[ERROR] " + e.getMessage() + "\n", colorRed);
                setRunning(false);
            }
        };
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 변환 결과 파일 → Eclipse 프로젝트에 자동 저장
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * done 이벤트의 generated_files 목록을 순회하며:
     * 1. GET /session/{id}/files/{path} 로 파일 내용 조회
     * 2. Eclipse 워크스페이스의 현재 프로젝트 아래에 IFile.create/setContents
     * 3. Package Explorer에 즉시 반영
     * 4. 첫 번째 파일을 에디터로 자동 오픈
     */
    private void saveGeneratedFiles(String sessionId, List<GeneratedFile> files) {
        new Thread(() -> {
            IProject project = getActiveProject();
            if (project == null) {
                appendOutput("[!] 열린 프로젝트가 없습니다. 파일을 저장할 수 없습니다.\n", colorYellow);
                return;
            }

            IFile firstFile = null;
            for (GeneratedFile gf : files) {
                try {
                    // 서버에서 파일 내용 조회
                    String content = apiClient.getGeneratedFileContent(sessionId, gf.path);
                    if (content == null || content.isEmpty()) continue;

                    // source/com/example/AIPBA30PU.java → generated/com/example/AIPBA30PU.java
                    // source/ 접두사를 제거하고 generated/ 아래에 저장
                    String relativePath = gf.path.startsWith("source/")
                            ? "generated/" + gf.path.substring("source/".length())
                            : "generated/" + gf.path;

                    IFile iFile = project.getFile(new Path(relativePath));

                    // 중간 폴더 자동 생성
                    ensureFolderExists(iFile.getParent());

                    byte[] bytes = content.getBytes(StandardCharsets.UTF_8);
                    if (iFile.exists()) {
                        iFile.setContents(
                                new ByteArrayInputStream(bytes),
                                IResource.FORCE, null);
                    } else {
                        iFile.create(
                                new ByteArrayInputStream(bytes),
                                true, null);
                    }

                    if (firstFile == null) firstFile = iFile;
                    appendOutput("  → " + gf.getFileName() + " (저장됨: " + relativePath + ")\n", colorCyan);

                } catch (Exception e) {
                    appendOutput("  [!] " + gf.getFileName() + " 저장 실패: " + e.getMessage() + "\n", colorRed);
                }
            }

            // 첫 번째 생성 파일을 에디터로 자동 오픈
            if (firstFile != null) {
                final IFile fileToOpen = firstFile;
                getSite().getShell().getDisplay().asyncExec(() -> {
                    try {
                        IDE.openEditor(getSite().getPage(), fileToOpen);
                    } catch (Exception e) {
                        // 오픈 실패는 무시 (파일은 저장됨)
                    }
                });
            }
        }, "c2j-save-files").start();
    }

    /** IContainer 하위 폴더가 없으면 재귀적으로 생성 */
    private void ensureFolderExists(IContainer container) throws Exception {
        if (container instanceof IProject || container.exists()) return;
        ensureFolderExists(container.getParent());
        ((IFolder) container).create(true, true, null);
    }

    /** 현재 워크스페이스에서 열린 프로젝트 반환 (첫 번째) */
    private IProject getActiveProject() {
        // 현재 에디터의 프로젝트 우선
        final IProject[] result = {null};
        getSite().getShell().getDisplay().syncExec(() -> {
            IEditorPart editor = getSite().getPage().getActiveEditor();
            if (editor != null && editor.getEditorInput() instanceof IFileEditorInput) {
                result[0] = ((IFileEditorInput) editor.getEditorInput())
                        .getFile().getProject();
            }
        });
        if (result[0] != null) return result[0];

        // fallback: 열린 프로젝트 중 첫 번째
        IProject[] projects = ResourcesPlugin.getWorkspace().getRoot().getProjects();
        for (IProject p : projects) {
            if (p.isOpen()) return p;
        }
        return null;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Interrupt 승인 패널 (인라인)
    // ─────────────────────────────────────────────────────────────────────────

    private void showInterruptPanel(List<ActionRequest> actions) {
        if (interruptPanel != null && !interruptPanel.isDisposed()) interruptPanel.dispose();

        interruptPanel = new Composite(bottomArea, SWT.BORDER);
        interruptPanel.setLayout(new GridLayout(1, false));
        interruptPanel.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
        interruptPanel.setBackground(getSite().getShell().getDisplay()
                .getSystemColor(SWT.COLOR_DARK_GRAY));

        StringBuilder sb = new StringBuilder("⏸  승인 필요:\n");
        for (ActionRequest a : actions) {
            sb.append("  [").append(a.index).append("] ").append(a.tool);
            if (a.argsJson.length() > 2) {
                String args = a.argsJson.length() > 100
                        ? a.argsJson.substring(0, 100) + "..." : a.argsJson;
                sb.append("  ").append(args);
            }
            sb.append("\n");
        }

        Label infoLabel = new Label(interruptPanel, SWT.WRAP);
        infoLabel.setText(sb.toString());
        infoLabel.setForeground(getSite().getShell().getDisplay().getSystemColor(SWT.COLOR_YELLOW));
        infoLabel.setBackground(getSite().getShell().getDisplay().getSystemColor(SWT.COLOR_DARK_GRAY));
        infoLabel.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));

        Composite btnRow = new Composite(interruptPanel, SWT.NONE);
        btnRow.setLayout(new RowLayout(SWT.HORIZONTAL));
        btnRow.setBackground(getSite().getShell().getDisplay().getSystemColor(SWT.COLOR_DARK_GRAY));

        Button approveBtn = new Button(btnRow, SWT.PUSH);
        approveBtn.setText("✓ 승인");
        approveBtn.setBackground(getSite().getShell().getDisplay().getSystemColor(SWT.COLOR_DARK_GREEN));
        approveBtn.setForeground(getSite().getShell().getDisplay().getSystemColor(SWT.COLOR_WHITE));
        approveBtn.addListener(SWT.Selection, e -> resumeWithDecision("approve"));

        Button rejectBtn = new Button(btnRow, SWT.PUSH);
        rejectBtn.setText("✗ 거부");
        rejectBtn.setBackground(getSite().getShell().getDisplay().getSystemColor(SWT.COLOR_DARK_RED));
        rejectBtn.setForeground(getSite().getShell().getDisplay().getSystemColor(SWT.COLOR_WHITE));
        rejectBtn.addListener(SWT.Selection, e -> resumeWithDecision("reject"));

        bottomArea.layout(true, true);
        appendOutput("\n⏸  승인 대기 중...\n", colorYellow);
    }

    private void resumeWithDecision(String decision) {
        if (interruptPanel != null && !interruptPanel.isDisposed()) {
            interruptPanel.dispose();
            interruptPanel = null;
            bottomArea.layout(true, true);
        }
        pendingActions = null;
        String sessionId = currentSessionId;
        if (sessionId == null) return;
        appendOutput("[" + decision + "] 재개 중...\n", colorGray);
        setRunning(true);
        new Thread(() ->
            apiClient.resumeSession(sessionId, decision, makeCallback(sessionId)),
        "c2j-resume").start();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 유틸
    // ─────────────────────────────────────────────────────────────────────────

    private void clearOutput() {
        getSite().getShell().getDisplay().asyncExec(() -> outputText.setText(""));
    }

    private void appendOutput(String text, Color color) {
        Display display = getSite().getShell().getDisplay();
        display.asyncExec(() -> {
            if (outputText.isDisposed()) return;
            int start = outputText.getCharCount();
            outputText.append(text);
            StyleRange style = new StyleRange();
            style.start      = start;
            style.length     = text.length();
            style.foreground = color;
            outputText.setStyleRange(style);
            outputText.setTopIndex(outputText.getLineCount() - 1);
        });
    }

    private void setRunning(boolean r) {
        running = r;
        Display display = getSite().getShell().getDisplay();
        display.asyncExec(() -> {
            if (sendButton.isDisposed()) return;
            sendButton.setEnabled(!r);
            convertButton.setEnabled(!r);
        });
    }

    private void setStatus(String text, int colorId) {
        Display display = getSite().getShell().getDisplay();
        display.asyncExec(() -> {
            if (statusLabel.isDisposed()) return;
            statusLabel.setText(text);
            statusLabel.setForeground(display.getSystemColor(colorId));
        });
    }

    private void updateToolCount(int count) {
        if (!toolCountLabel.isDisposed())
            toolCountLabel.setText("tools: " + count);
    }

    @Override public void setFocus() { inputText.setFocus(); }

    @Override
    public void dispose() {
        if (colorOrange != null) colorOrange.dispose();
        if (currentSessionId != null) {
            String sid = currentSessionId;
            new Thread(() -> apiClient.closeSession(sid), "c2j-dispose").start();
        }
        super.dispose();
    }
}
