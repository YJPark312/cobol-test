package com.deepagents.cli.views;

import com.deepagents.cli.Activator;
import com.deepagents.cli.model.ConversionRequest;
import com.deepagents.cli.preferences.PreferenceConstants;
import com.deepagents.cli.util.ApiClient;
import com.deepagents.cli.util.ApiClient.ActionRequest;
import com.deepagents.cli.util.ApiClient.GeneratedFile;
import com.deepagents.cli.util.ApiClient.ProgramInfo;
import com.deepagents.cli.util.ApiClient.SessionStreamCallback;
import com.deepagents.cli.util.ApiClient.UserFileInfo;
import com.deepagents.cli.util.HtmlRenderer;

import org.eclipse.core.resources.*;
import org.eclipse.core.runtime.Path;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.swt.SWT;
import org.eclipse.swt.browser.Browser;
import org.eclipse.swt.custom.SashForm;
import org.eclipse.swt.events.*;
import org.eclipse.swt.layout.*;
import org.eclipse.swt.widgets.*;
import org.eclipse.ui.*;
import org.eclipse.ui.ide.IDE;
import org.eclipse.ui.part.ViewPart;

import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * C2J Pipeline Eclipse View — Claude Code 스타일 Browser UI
 *
 * ┌─────────────────────────────────────────────────────┐
 * │ [Auto-approve] [Refresh] [Clear] [Stop] [New Session]│
 * │                              status: ● Session Active │
 * ├──────────────┬──────────────────────────────────────┤
 * │ Workspace 탭 │  ┌─ Claude ─────────────────────┐    │
 * │  📁 source/  │  │ markdown 렌더링된 응답        │    │
 * │              │  │ ▶ tool_name          ✓  접기  │    │
 * │ Programs 탭  │  │ ```java 구문강조```           │    │
 * │  AIPBA30 512 │  │ ✅ 완료 — 생성 파일 3개       │    │
 * │              │  └──────────────────────────────┘    │
 * ├──────────────┴──────────────────────────────────────┤
 * │ [입력창___________________________] [Send]          │
 * └─────────────────────────────────────────────────────┘
 */
public class DeepAgentsView extends ViewPart {

    public static final String ID = "com.deepagents.cli.views.DeepAgentsView";

    // ── UI 컴포넌트 ───────────────────────────────────────────────────────────
    private Browser     browser;          // ★ StyledText → Browser
    private Text        inputText;
    private Text        searchText;
    private Table       programTable;
    private Tree        workspaceTree;
    private Button      sendButton;
    private Button      convertButton;
    private Button      stopButton;
    private Button      autoApproveCheck;
    private Label       statusLabel;
    private Label       toolCountLabel;
    private Composite   interruptPanel;
    private Composite   bottomArea;

    // ── 상태 ─────────────────────────────────────────────────────────────────
    private ApiClient        apiClient;
    private volatile String  currentSessionId    = null;
    private volatile String  userId              = null;
    private volatile boolean sessionInitializing = false;
    private volatile boolean running             = false;
    private volatile int     toolCallCount       = 0;
    private volatile boolean inAssistantTurn     = false;
    private volatile boolean inToolGroup        = false;  // 현재 툴 그룹 진행 중
    private volatile List<ActionRequest> pendingActions = null;

    // ─────────────────────────────────────────────────────────────────────────
    // 뷰 생성
    // ─────────────────────────────────────────────────────────────────────────

    @Override
    public void createPartControl(Composite parent) {
        apiClient = new ApiClient();

        parent.setLayout(new GridLayout(1, false));

        buildToolbar(parent);
        buildMainArea(parent);

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
        refreshBtn.addListener(SWT.Selection, e -> {
            loadProgramList("");
            loadWorkspaceFiles();
        });

        Button clearBtn = new Button(toolbar, SWT.PUSH);
        clearBtn.setText("Clear");
        clearBtn.addListener(SWT.Selection, e -> clearOutput());

        stopButton = new Button(toolbar, SWT.PUSH);
        stopButton.setText("Stop");
        stopButton.setEnabled(false);
        stopButton.addListener(SWT.Selection, e -> cancelRunning());

        Button newSessionBtn = new Button(toolbar, SWT.PUSH);
        newSessionBtn.setText("New Session");
        newSessionBtn.addListener(SWT.Selection, e -> initSession());

        statusLabel = new Label(toolbar, SWT.NONE);
        statusLabel.setText("● Ready");

        toolCountLabel = new Label(toolbar, SWT.NONE);
        toolCountLabel.setText("tools: 0");
        toolCountLabel.setForeground(parent.getDisplay().getSystemColor(SWT.COLOR_DARK_GRAY));
    }

    // ── 메인 영역 (좌: 탭 패널 / 우: Browser 출력) ──────────────────────────

    private void buildMainArea(Composite parent) {
        SashForm sash = new SashForm(parent, SWT.HORIZONTAL);
        sash.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true));

        buildLeftPanel(sash);
        buildBrowserArea(sash);    // ★ Browser 영역

        sash.setWeights(new int[]{25, 75});
    }

    // ── 좌측: TabFolder (Workspace / Programs) ──────────────────────────────

    private void buildLeftPanel(Composite parent) {
        TabFolder tabFolder = new TabFolder(parent, SWT.TOP);

        // Tab 1: Workspace
        TabItem workspaceTab = new TabItem(tabFolder, SWT.NONE);
        workspaceTab.setText("Workspace");
        Composite workspacePanel = new Composite(tabFolder, SWT.NONE);
        workspacePanel.setLayout(new GridLayout(1, false));
        buildWorkspaceContent(workspacePanel);
        workspaceTab.setControl(workspacePanel);

        // Tab 2: Programs
        TabItem programTab = new TabItem(tabFolder, SWT.NONE);
        programTab.setText("Programs");
        Composite programPanel = new Composite(tabFolder, SWT.NONE);
        programPanel.setLayout(new GridLayout(1, false));
        buildProgramContent(programPanel);
        programTab.setControl(programPanel);
    }

    private void buildProgramContent(Composite panel) {
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
        searchBtn.setText("검색");
        searchBtn.addListener(SWT.Selection, e -> loadProgramList(searchText.getText().trim()));

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

        programTable.addListener(SWT.DefaultSelection, e -> {
            String prog = getSelectedProgramName();
            if (prog != null) startConversion(prog);
        });

        convertButton = new Button(panel, SWT.PUSH);
        convertButton.setText("▶ C2J 전환");
        convertButton.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
        convertButton.addListener(SWT.Selection, e -> {
            String prog = getSelectedProgramName();
            if (prog != null) startConversion(prog);
            else execJs(HtmlRenderer.warningMessage("목록에서 프로그램을 선택하세요."));
        });
    }

    private void buildWorkspaceContent(Composite panel) {
        Label label = new Label(panel, SWT.NONE);
        label.setText("서버 파일 (더블클릭으로 열기)");
        label.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));

        workspaceTree = new Tree(panel, SWT.BORDER | SWT.SINGLE | SWT.V_SCROLL);
        workspaceTree.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true));

        workspaceTree.addListener(SWT.DefaultSelection, e -> {
            TreeItem[] sel = workspaceTree.getSelection();
            if (sel.length == 0) return;
            TreeItem item = sel[0];
            Boolean isDir = (Boolean) item.getData("isDir");
            if (isDir != null && isDir) return;
            String path = (String) item.getData("path");
            if (path != null) openWorkspaceFile(path);
        });

        Button refreshBtn = new Button(panel, SWT.PUSH);
        refreshBtn.setText("새로고침");
        refreshBtn.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
        refreshBtn.addListener(SWT.Selection, e -> loadWorkspaceFiles());
    }

    // ── 우측: Browser 출력 영역 ★ ────────────────────────────────────────────

    private void buildBrowserArea(Composite parent) {
        browser = new Browser(parent, SWT.NONE);
        browser.setText(HtmlRenderer.buildShell());
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
    // Browser JS 실행 헬퍼
    // ─────────────────────────────────────────────────────────────────────────

    /** UI 스레드에서 Browser에 JavaScript 실행 */
    private void execJs(String js) {
        Display display = getSite().getShell().getDisplay();
        display.asyncExec(() -> {
            if (browser != null && !browser.isDisposed()) {
                browser.execute(js);
            }
        });
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
                    execJs(HtmlRenderer.systemMessage("C2J API 서버 연결됨"));
                    initSession();
                    loadProgramList("");
                } else {
                    setStatus("● Disconnected", SWT.COLOR_RED);
                    execJs(HtmlRenderer.errorMessage("API 서버에 연결할 수 없습니다."));
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

        IPreferenceStore prefs = Activator.getDefault().getPreferenceStore();
        String uid = prefs.getString(PreferenceConstants.USER_ID).trim();
        if (uid.isEmpty()) uid = System.getProperty("user.name", "eclipse-user");
        userId = uid;

        final String finalUserId = uid;
        new Thread(() -> {
            try {
                String sessionId = apiClient.createSession(finalUserId);
                currentSessionId = sessionId;
                toolCallCount    = 0;
                execJs(HtmlRenderer.systemMessage(
                    "세션 시작: " + sessionId.substring(0, 8) + "... user=" + finalUserId));
                loadWorkspaceFiles();
                getSite().getShell().getDisplay().asyncExec(() -> {
                    setStatus("● Session Active", SWT.COLOR_DARK_GREEN);
                    updateToolCount(0);
                });
            } catch (Exception e) {
                execJs(HtmlRenderer.errorMessage("세션 생성 실패: " + e.getMessage()));
            } finally {
                sessionInitializing = false;
            }
        }, "c2j-init").start();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Workspace 파일 트리 로드 / 열기
    // ─────────────────────────────────────────────────────────────────────────

    private void loadWorkspaceFiles() {
        if (userId == null) return;
        final String uid = userId;
        new Thread(() -> {
            try {
                List<UserFileInfo> files = apiClient.listUserFiles(uid);
                getSite().getShell().getDisplay().asyncExec(() -> {
                    if (workspaceTree.isDisposed()) return;
                    buildFileTree(files);
                });
                // Workspace 로드 메시지 생략 — 트리만 갱신
            } catch (Exception e) {
                execJs(HtmlRenderer.errorMessage("Workspace 로드 실패: " + e.getMessage()));
            }
        }, "c2j-workspace").start();
    }

    private void buildFileTree(List<UserFileInfo> files) {
        workspaceTree.removeAll();
        Map<String, TreeItem> folderMap = new HashMap<>();

        for (UserFileInfo f : files) {
            String[] parts = f.path.split("/");
            TreeItem parent = null;
            StringBuilder pathBuilder = new StringBuilder();

            for (int i = 0; i < parts.length; i++) {
                if (pathBuilder.length() > 0) pathBuilder.append("/");
                pathBuilder.append(parts[i]);
                String currentPath = pathBuilder.toString();

                if (i < parts.length - 1) {
                    if (!folderMap.containsKey(currentPath)) {
                        TreeItem folder = parent == null
                                ? new TreeItem(workspaceTree, SWT.NONE)
                                : new TreeItem(parent, SWT.NONE);
                        folder.setText(parts[i]);
                        folder.setData("isDir", true);
                        folder.setExpanded(true);
                        folderMap.put(currentPath, folder);
                        parent = folder;
                    } else {
                        parent = folderMap.get(currentPath);
                    }
                } else {
                    TreeItem fileItem = parent == null
                            ? new TreeItem(workspaceTree, SWT.NONE)
                            : new TreeItem(parent, SWT.NONE);
                    String sizeStr = f.size < 1024 ? f.size + "B"
                            : String.format("%.1fKB", f.size / 1024.0);
                    fileItem.setText(parts[i] + "  (" + sizeStr + ")");
                    fileItem.setData("path", f.path);
                    fileItem.setData("isDir", false);
                }
            }
        }

        for (TreeItem item : workspaceTree.getItems()) {
            item.setExpanded(true);
        }
    }

    private void openWorkspaceFile(String relativePath) {
        if (currentSessionId == null) {
            execJs(HtmlRenderer.warningMessage("세션이 없습니다."));
            return;
        }
        String sessionId = currentSessionId;
        new Thread(() -> {
            try {
                String content = apiClient.getGeneratedFileContent(sessionId, relativePath);
                if (content == null || content.isEmpty()) {
                    execJs(HtmlRenderer.warningMessage("파일 내용이 비어있습니다: " + relativePath));
                    return;
                }

                IProject project = getActiveProject();
                if (project == null) {
                    execJs(HtmlRenderer.warningMessage("열린 프로젝트가 없습니다."));
                    return;
                }

                String eclipsePath = "c2j-workdir/" + relativePath;
                IFile iFile = project.getFile(new Path(eclipsePath));
                ensureFolderExists(iFile.getParent());

                byte[] bytes = content.getBytes(StandardCharsets.UTF_8);
                if (iFile.exists()) {
                    iFile.setContents(new ByteArrayInputStream(bytes), IResource.FORCE, null);
                } else {
                    iFile.create(new ByteArrayInputStream(bytes), true, null);
                }

                getSite().getShell().getDisplay().asyncExec(() -> {
                    try { IDE.openEditor(getSite().getPage(), iFile); }
                    catch (Exception ex) {
                        execJs(HtmlRenderer.errorMessage("에디터 열기 실패: " + ex.getMessage()));
                    }
                });
            } catch (Exception ex) {
                execJs(HtmlRenderer.errorMessage("파일 조회 실패: " + ex.getMessage()));
            }
        }, "c2j-open-file").start();
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
                        item.setData(p);
                    }
                });
                execJs(HtmlRenderer.systemMessage(
                    "프로그램 " + programs.size() + "개 로드됨"
                    + (keyword.isEmpty() ? "" : " (필터: " + keyword + ")")));
            } catch (Exception e) {
                execJs(HtmlRenderer.errorMessage("프로그램 목록 로드 실패: " + e.getMessage()));
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

    public void startConversion(String programName) {
        if (running) { execJs(HtmlRenderer.warningMessage("이미 실행 중입니다.")); return; }
        if (currentSessionId == null) { execJs(HtmlRenderer.warningMessage("세션이 없습니다.")); return; }

        execJs(HtmlRenderer.userTurn("COBOL→Java 전환: " + programName));
        execJs(HtmlRenderer.assistantTurnStart());
        inAssistantTurn = true;
        setRunning(true);

        String sessionId = currentSessionId;
        ConversionRequest req = new ConversionRequest(programName);

        new Thread(() ->
            apiClient.startConversion(sessionId, req, makeCallback(sessionId)),
        "c2j-convert").start();
    }

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
            execJs(HtmlRenderer.warningMessage("변환할 COBOL 파일을 에디터에서 열어주세요."));
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
        if (running) { execJs(HtmlRenderer.warningMessage("이미 실행 중입니다.")); return; }
        String msg = inputText.getText().trim();
        if (msg.isEmpty()) return;
        inputText.setText("");

        execJs(HtmlRenderer.userTurn(msg));
        execJs(HtmlRenderer.assistantTurnStart());
        inAssistantTurn = true;

        if (currentSessionId == null) {
            execJs(HtmlRenderer.warningMessage("세션이 없습니다."));
            return;
        }
        setRunning(true);
        String sessionId = currentSessionId;
        new Thread(() ->
            apiClient.sendSessionMessage(sessionId, msg, makeCallback(sessionId)),
        "c2j-message").start();
    }

    public void sendTextFromEditor(String text) {
        getSite().getShell().getDisplay().asyncExec(() -> {
            inputText.setText(text);
            sendMessage();
        });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // SSE 콜백 — Claude Code 스타일 렌더링
    // ─────────────────────────────────────────────────────────────────────────

    private SessionStreamCallback makeCallback(String sessionId) {
        return new SessionStreamCallback() {

            @Override public void onToken(String text) {
                // 툴 그룹 진행 중이었으면 그룹 닫고 새 텍스트 영역 생성
                if (inToolGroup) {
                    execJs(HtmlRenderer.closeToolGroup());
                    inToolGroup = false;
                }
                execJs(HtmlRenderer.appendToken(text));
            }

            @Override public void onToolStart(String tool, int count) {
                toolCallCount = count;
                inToolGroup = true;
                // 어시스턴트 턴이 없으면 시작 (턴 안에 툴 그룹이 들어감)
                if (!inAssistantTurn) {
                    execJs(HtmlRenderer.assistantTurnStart());
                    inAssistantTurn = true;
                }
                execJs(HtmlRenderer.toolStart(tool, count));
                getSite().getShell().getDisplay().asyncExec(() -> updateToolCount(count));
            }

            @Override public void onToolEnd(String tool) {
                execJs(HtmlRenderer.toolEnd(tool, toolCallCount));
                // 턴은 유지 — 다음 토큰이 오면 closeToolGroup으로 새 텍스트 영역 생성
            }

            @Override public void onInterrupt(List<ActionRequest> actions) {
                finishTurn();
                pendingActions = actions;

                StringBuilder sb = new StringBuilder();
                for (ActionRequest a : actions) {
                    sb.append("[").append(a.index).append("] ").append(a.tool);
                    if (a.argsJson.length() > 2) {
                        String args = a.argsJson.length() > 100
                                ? a.argsJson.substring(0, 100) + "..." : a.argsJson;
                        sb.append("  ").append(args);
                    }
                    sb.append("\n");
                }
                execJs(HtmlRenderer.interruptBlock(sb.toString()));
                getSite().getShell().getDisplay().asyncExec(() -> showInterruptPanel(actions));
            }

            @Override public void onBudgetExceeded(String tool, int count, int budget) {
                finishTurn();
                execJs(HtmlRenderer.budgetExceeded(tool, count, budget));
                setRunning(false);
            }

            @Override public void onDone(String stopReason, List<GeneratedFile> generatedFiles) {
                finishTurn();

                int count = generatedFiles != null ? generatedFiles.size() : 0;

                if (count > 0) {
                    // 전환 완료 — 파일 목록 표시 + 저장
                    execJs(HtmlRenderer.doneMessage(stopReason, count));
                    execJs(HtmlRenderer.filesListStart(count));
                    for (GeneratedFile gf : generatedFiles) {
                        execJs(HtmlRenderer.fileEntry(gf.getFileName(), gf.path));
                    }
                    saveGeneratedFiles(sessionId, generatedFiles);
                } else if (!"end_turn".equals(stopReason)) {
                    // 취소, 에러, 예산 초과 등 비정상 종료만 표시
                    execJs(HtmlRenderer.doneMessage(stopReason, 0));
                }
                // end_turn + 파일 없음 = 일반 대화 응답 → 완료 메시지 생략

                loadWorkspaceFiles();
                setRunning(false);
            }

            @Override public void onError(Exception e) {
                finishTurn();
                execJs(HtmlRenderer.errorMessage(e.getMessage()));
                setRunning(false);
            }

            private void finishTurn() {
                if (inAssistantTurn) {
                    execJs(HtmlRenderer.assistantTurnEnd());
                    inAssistantTurn = false;
                }
                inToolGroup = false;
            }
        };
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 변환 결과 파일 → Eclipse 프로젝트에 자동 저장
    // ─────────────────────────────────────────────────────────────────────────

    private void saveGeneratedFiles(String sessionId, List<GeneratedFile> files) {
        new Thread(() -> {
            IProject project = getActiveProject();
            if (project == null) {
                execJs(HtmlRenderer.warningMessage("열린 프로젝트가 없습니다. 파일을 저장할 수 없습니다."));
                return;
            }

            IFile firstFile = null;
            int savedCount = 0;
            for (GeneratedFile gf : files) {
                try {
                    String content = apiClient.getGeneratedFileContent(sessionId, gf.path);
                    if (content == null || content.isEmpty()) continue;

                    String relativePath = gf.path.startsWith("source/")
                            ? "generated/" + gf.path.substring("source/".length())
                            : "generated/" + gf.path;

                    IFile iFile = project.getFile(new Path(relativePath));
                    ensureFolderExists(iFile.getParent());

                    byte[] bytes = content.getBytes(StandardCharsets.UTF_8);
                    if (iFile.exists()) {
                        iFile.setContents(new ByteArrayInputStream(bytes), IResource.FORCE, null);
                    } else {
                        iFile.create(new ByteArrayInputStream(bytes), true, null);
                    }

                    if (firstFile == null) firstFile = iFile;
                    savedCount++;

                } catch (Exception e) {
                    execJs(HtmlRenderer.errorMessage(gf.getFileName() + " 저장 실패: " + e.getMessage()));
                }
            }

            // 저장 결과를 한 줄 요약으로 표시
            if (savedCount > 0) {
                execJs(HtmlRenderer.filesSavedSummary(savedCount, "generated/"));
            }

            if (firstFile != null) {
                final IFile fileToOpen = firstFile;
                getSite().getShell().getDisplay().asyncExec(() -> {
                    try { IDE.openEditor(getSite().getPage(), fileToOpen); }
                    catch (Exception e) { /* 파일은 저장됨 */ }
                });
            }
        }, "c2j-save-files").start();
    }

    private void ensureFolderExists(IContainer container) throws Exception {
        if (container instanceof IProject || container.exists()) return;
        ensureFolderExists(container.getParent());
        ((IFolder) container).create(true, true, null);
    }

    private IProject getActiveProject() {
        final IProject[] result = {null};
        getSite().getShell().getDisplay().syncExec(() -> {
            IEditorPart editor = getSite().getPage().getActiveEditor();
            if (editor != null && editor.getEditorInput() instanceof IFileEditorInput) {
                result[0] = ((IFileEditorInput) editor.getEditorInput())
                        .getFile().getProject();
            }
        });
        if (result[0] != null) return result[0];

        IProject[] projects = ResourcesPlugin.getWorkspace().getRoot().getProjects();
        for (IProject p : projects) {
            if (p.isOpen()) return p;
        }
        return null;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Interrupt 승인 패널 (SWT 인라인)
    // ─────────────────────────────────────────────────────────────────────────

    private void showInterruptPanel(List<ActionRequest> actions) {
        if (interruptPanel != null && !interruptPanel.isDisposed()) interruptPanel.dispose();

        setRunning(false);

        Display display = getSite().getShell().getDisplay();

        interruptPanel = new Composite(bottomArea, SWT.BORDER);
        interruptPanel.setLayout(new GridLayout(1, false));
        interruptPanel.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
        interruptPanel.setBackground(display.getSystemColor(SWT.COLOR_DARK_GRAY));

        StringBuilder sb = new StringBuilder("승인 필요:\n");
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
        infoLabel.setForeground(display.getSystemColor(SWT.COLOR_YELLOW));
        infoLabel.setBackground(display.getSystemColor(SWT.COLOR_DARK_GRAY));
        infoLabel.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));

        Composite btnRow = new Composite(interruptPanel, SWT.NONE);
        btnRow.setLayout(new RowLayout(SWT.HORIZONTAL));
        btnRow.setBackground(display.getSystemColor(SWT.COLOR_DARK_GRAY));

        Button approveBtn = new Button(btnRow, SWT.PUSH);
        approveBtn.setText("Approve");
        approveBtn.addListener(SWT.Selection, e -> resumeWithDecision("approve"));

        Button rejectBtn = new Button(btnRow, SWT.PUSH);
        rejectBtn.setText("Reject");
        rejectBtn.addListener(SWT.Selection, e -> resumeWithDecision("reject"));

        bottomArea.layout(true, true);
        bottomArea.getParent().layout(true, true);
    }

    private void resumeWithDecision(String decision) {
        if (interruptPanel != null && !interruptPanel.isDisposed()) {
            interruptPanel.dispose();
            interruptPanel = null;
            bottomArea.layout(true, true);
            bottomArea.getParent().layout(true, true);
        }
        pendingActions = null;
        String sessionId = currentSessionId;
        if (sessionId == null) return;

        execJs(HtmlRenderer.systemMessage(decision + " — 재개 중..."));
        execJs(HtmlRenderer.assistantTurnStart());
        inAssistantTurn = true;
        inToolGroup = false;
        setRunning(true);

        new Thread(() ->
            apiClient.resumeSession(sessionId, decision, makeCallback(sessionId)),
        "c2j-resume").start();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 유틸
    // ─────────────────────────────────────────────────────────────────────────

    private void clearOutput() {
        execJs("document.getElementById('content').innerHTML='';window._buf='';");
    }

    private void setRunning(boolean r) {
        running = r;
        Display display = getSite().getShell().getDisplay();
        display.asyncExec(() -> {
            if (sendButton.isDisposed()) return;
            sendButton.setEnabled(!r);
            convertButton.setEnabled(!r);
            stopButton.setEnabled(r);
        });
    }

    private void cancelRunning() {
        String sessionId = currentSessionId;
        if (sessionId == null || !running) return;
        execJs(HtmlRenderer.warningMessage("중지 요청 중..."));
        new Thread(() -> {
            try {
                apiClient.cancelSession(sessionId);
                if (inAssistantTurn) {
                    execJs(HtmlRenderer.assistantTurnEnd());
                    inAssistantTurn = false;
                }
                execJs(HtmlRenderer.systemMessage("중지 완료"));
            } catch (Exception e) {
                execJs(HtmlRenderer.errorMessage("중지 실패: " + e.getMessage()));
            }
            setRunning(false);
        }, "c2j-cancel").start();
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
        if (currentSessionId != null) {
            String sid = currentSessionId;
            new Thread(() -> apiClient.closeSession(sid), "c2j-dispose").start();
        }
        super.dispose();
    }
}
