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
import org.eclipse.core.runtime.CoreException;
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

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * C2J Pipeline Eclipse View v5
 *
 * v4 대비 추가: Project 탭
 *  - Eclipse 워크스페이스의 프로젝트 파일을 체크박스 트리로 표시
 *  - 체크한 파일의 내용이 메시지 전송 시 컨텍스트로 자동 첨부
 *
 * ┌─────────────────────────────────────────────────────┐
 * │ [Auto-approve] [Refresh] [Clear] [Stop] [New Session]│
 * ├──────────────┬──────────────────────────────────────┤
 * │ Project 탭   │                                      │
 * │  ☑ src/      │  $ 이 파일 분석해줘                   │
 * │   ☑ Main.java│  > [Main.java, Util.java 첨부됨]     │
 * │   ☐ Test.java│    분석 결과...                       │
 * │              │                                      │
 * │ Workspace 탭 │                                      │
 * │ Programs 탭  │                                      │
 * ├──────────────┴──────────────────────────────────────┤
 * │ 📎 2개 파일 첨부됨                        [해제]    │
 * │ [입력창___________________________] [Send]          │
 * └─────────────────────────────────────────────────────┘
 */
public class DeepAgentsView extends ViewPart {

    public static final String ID = "com.deepagents.cli.views.DeepAgentsView";

    // ── UI ────────────────────────────────────────────────────────────────────
    private Browser     browser;
    private Text        inputText;
    private Text        searchText;
    private Table       programTable;
    private Tree        workspaceTree;
    private Tree        projectTree;       // ★ v5: Eclipse 프로젝트 파일 체크박스 트리
    private Button      sendButton;
    private Button      convertButton;
    private Button      stopButton;
    private Button      autoApproveCheck;
    private Label       statusLabel;
    private Label       toolCountLabel;
    private Label       attachLabel;       // ★ v5: 첨부 파일 표시
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
    private volatile boolean inToolGroup         = false;
    private volatile boolean isConversionMode   = false;  // 전환 모드 여부
    private volatile List<ActionRequest> pendingActions = null;

    // ── 파일 확장자 필터 (텍스트 파일만) ──────────────────────────────────────
    private static final String[] TEXT_EXTS = {
        ".java", ".cbl", ".cob", ".cobol", ".xml", ".json", ".yaml", ".yml",
        ".properties", ".md", ".txt", ".sql", ".html", ".css", ".js",
        ".py", ".sh", ".bat", ".gradle", ".cfg", ".ini", ".csv", ".log"
    };

    private static final long MAX_FILE_SIZE = 100 * 1024; // 100KB 제한

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

        buildAttachBar(bottomArea);    // ★ v5: 첨부 표시 바
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
            loadProjectTree();          // ★ v5
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

    // ── 메인 영역 ────────────────────────────────────────────────────────────

    private void buildMainArea(Composite parent) {
        SashForm sash = new SashForm(parent, SWT.HORIZONTAL);
        sash.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true));

        buildLeftPanel(sash);
        buildBrowserArea(sash);

        sash.setWeights(new int[]{25, 75});
    }

    // ── 좌측: TabFolder (Project / Workspace / Programs) ────────────────────

    private void buildLeftPanel(Composite parent) {
        TabFolder tabFolder = new TabFolder(parent, SWT.TOP);

        // ★ Tab 1: Project (Eclipse 로컬 파일)
        TabItem projectTab = new TabItem(tabFolder, SWT.NONE);
        projectTab.setText("Project");
        Composite projectPanel = new Composite(tabFolder, SWT.NONE);
        projectPanel.setLayout(new GridLayout(1, false));
        buildProjectContent(projectPanel);
        projectTab.setControl(projectPanel);

        // Tab 2: Workspace (서버 파일)
        TabItem workspaceTab = new TabItem(tabFolder, SWT.NONE);
        workspaceTab.setText("Workspace");
        Composite workspacePanel = new Composite(tabFolder, SWT.NONE);
        workspacePanel.setLayout(new GridLayout(1, false));
        buildWorkspaceContent(workspacePanel);
        workspaceTab.setControl(workspacePanel);

        // Tab 3: Programs
        TabItem programTab = new TabItem(tabFolder, SWT.NONE);
        programTab.setText("Programs");
        Composite programPanel = new Composite(tabFolder, SWT.NONE);
        programPanel.setLayout(new GridLayout(1, false));
        buildProgramContent(programPanel);
        programTab.setControl(programPanel);
    }

    // ── ★ v5: Project 탭 — Eclipse 프로젝트 체크박스 트리 ───────────────────

    private void buildProjectContent(Composite panel) {
        Label label = new Label(panel, SWT.NONE);
        label.setText("체크한 파일이 질문에 첨부됩니다");
        label.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));

        projectTree = new Tree(panel, SWT.BORDER | SWT.CHECK | SWT.V_SCROLL | SWT.H_SCROLL);
        projectTree.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true));

        // 체크 이벤트: 폴더 체크 시 하위 전체 토글 + 첨부 라벨 업데이트
        projectTree.addListener(SWT.Selection, e -> {
            if (e.detail == SWT.CHECK && e.item instanceof TreeItem) {
                TreeItem item = (TreeItem) e.item;
                boolean checked = item.getChecked();
                checkChildren(item, checked);
                checkParents(item);
                updateAttachLabel();
            }
        });

        // 더블클릭 → 에디터로 열기
        projectTree.addListener(SWT.DefaultSelection, e -> {
            TreeItem[] sel = projectTree.getSelection();
            if (sel.length == 0) return;
            IFile file = (IFile) sel[0].getData("ifile");
            if (file != null && file.exists()) {
                try { IDE.openEditor(getSite().getPage(), file); }
                catch (Exception ex) { /* ignore */ }
            }
        });

        Composite btnBar = new Composite(panel, SWT.NONE);
        btnBar.setLayout(new GridLayout(2, true));
        btnBar.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));

        Button refreshBtn = new Button(btnBar, SWT.PUSH);
        refreshBtn.setText("새로고침");
        refreshBtn.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
        refreshBtn.addListener(SWT.Selection, e -> loadProjectTree());

        Button clearCheckBtn = new Button(btnBar, SWT.PUSH);
        clearCheckBtn.setText("선택 해제");
        clearCheckBtn.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
        clearCheckBtn.addListener(SWT.Selection, e -> {
            uncheckAll(projectTree.getItems());
            updateAttachLabel();
        });

        // 초기 로드
        loadProjectTree();
    }

    /** Eclipse 워크스페이스의 열린 프로젝트 파일을 트리에 로드 */
    private void loadProjectTree() {
        if (projectTree == null || projectTree.isDisposed()) return;
        projectTree.removeAll();

        IProject[] projects = ResourcesPlugin.getWorkspace().getRoot().getProjects();
        for (IProject project : projects) {
            if (!project.isOpen()) continue;
            TreeItem projItem = new TreeItem(projectTree, SWT.NONE);
            projItem.setText(project.getName());
            projItem.setData("iresource", project);
            try {
                addMembers(projItem, project);
            } catch (CoreException e) {
                // 로드 실패 시 무시
            }
            projItem.setExpanded(true);
        }
        updateAttachLabel();
    }

    /** 재귀적으로 IContainer의 멤버를 트리에 추가 */
    private void addMembers(TreeItem parentItem, IContainer container) throws CoreException {
        for (IResource member : container.members()) {
            if (member.getName().startsWith(".")) continue; // 숨김파일 제외

            if (member instanceof IContainer) {
                // bin, target, node_modules 등 제외
                String name = member.getName();
                if ("bin".equals(name) || "target".equals(name) || "node_modules".equals(name)
                        || "build".equals(name) || ".settings".equals(name)) continue;

                TreeItem folderItem = new TreeItem(parentItem, SWT.NONE);
                folderItem.setText(name);
                folderItem.setData("iresource", member);
                addMembers(folderItem, (IContainer) member);
            } else if (member instanceof IFile) {
                if (!isTextFile(member.getName())) continue;

                TreeItem fileItem = new TreeItem(parentItem, SWT.NONE);
                long size = member.getLocation() != null
                        ? member.getLocation().toFile().length() : 0;
                String sizeStr = size < 1024 ? size + "B"
                        : String.format("%.1fKB", size / 1024.0);
                fileItem.setText(member.getName() + "  (" + sizeStr + ")");
                fileItem.setData("ifile", member);
                fileItem.setData("iresource", member);
            }
        }
    }

    /** 텍스트 파일인지 확인 */
    private boolean isTextFile(String name) {
        String lower = name.toLowerCase();
        for (String ext : TEXT_EXTS) {
            if (lower.endsWith(ext)) return true;
        }
        return false;
    }

    /** 체크된 파일 목록 수집 */
    private List<IFile> getCheckedFiles() {
        List<IFile> files = new ArrayList<>();
        if (projectTree != null && !projectTree.isDisposed()) {
            collectCheckedFiles(projectTree.getItems(), files);
        }
        return files;
    }

    private void collectCheckedFiles(TreeItem[] items, List<IFile> result) {
        for (TreeItem item : items) {
            if (item.getChecked()) {
                IFile file = (IFile) item.getData("ifile");
                if (file != null && file.exists()) {
                    result.add(file);
                }
            }
            collectCheckedFiles(item.getItems(), result);
        }
    }

    /** 체크된 파일의 내용을 읽어 컨텍스트 문자열 생성 */
    private String buildFileContext() {
        List<IFile> files = getCheckedFiles();
        if (files.isEmpty()) return "";

        StringBuilder sb = new StringBuilder();
        sb.append("\n\n--- 첨부 파일 ---\n");
        for (IFile file : files) {
            try {
                long size = file.getLocation() != null
                        ? file.getLocation().toFile().length() : 0;
                if (size > MAX_FILE_SIZE) {
                    sb.append("\n[").append(file.getProjectRelativePath()).append("] (크기 초과, 생략)\n");
                    continue;
                }

                sb.append("\n[").append(file.getProjectRelativePath()).append("]\n");
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(file.getContents(), StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line).append("\n");
                    }
                }
            } catch (Exception e) {
                sb.append("\n[").append(file.getName()).append("] (읽기 실패)\n");
            }
        }
        return sb.toString();
    }

    /** 하위 아이템 체크 상태 전파 */
    private void checkChildren(TreeItem item, boolean checked) {
        for (TreeItem child : item.getItems()) {
            child.setChecked(checked);
            checkChildren(child, checked);
        }
    }

    /** 부모 체크 상태 업데이트 (자식 일부 체크 → 부모 grayed) */
    private void checkParents(TreeItem item) {
        TreeItem parent = item.getParentItem();
        if (parent == null) return;
        boolean allChecked = true, anyChecked = false;
        for (TreeItem child : parent.getItems()) {
            if (child.getChecked()) anyChecked = true;
            else allChecked = false;
        }
        parent.setChecked(anyChecked);
        parent.setGrayed(anyChecked && !allChecked);
        checkParents(parent);
    }

    private void uncheckAll(TreeItem[] items) {
        for (TreeItem item : items) {
            item.setChecked(false);
            item.setGrayed(false);
            uncheckAll(item.getItems());
        }
    }

    // ── ★ v5: 첨부 표시 바 ──────────────────────────────────────────────────

    private void buildAttachBar(Composite parent) {
        Composite bar = new Composite(parent, SWT.NONE);
        bar.setLayout(new GridLayout(2, false));
        bar.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));

        attachLabel = new Label(bar, SWT.NONE);
        attachLabel.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
        attachLabel.setText("");

        Button clearBtn = new Button(bar, SWT.PUSH);
        clearBtn.setText("첨부 해제");
        clearBtn.addListener(SWT.Selection, e -> {
            if (projectTree != null && !projectTree.isDisposed()) {
                uncheckAll(projectTree.getItems());
                updateAttachLabel();
            }
        });
    }

    private void updateAttachLabel() {
        if (attachLabel == null || attachLabel.isDisposed()) return;
        List<IFile> files = getCheckedFiles();
        if (files.isEmpty()) {
            attachLabel.setText("");
        } else {
            StringBuilder sb = new StringBuilder("📎 " + files.size() + "개 파일: ");
            for (int i = 0; i < files.size() && i < 5; i++) {
                if (i > 0) sb.append(", ");
                sb.append(files.get(i).getName());
            }
            if (files.size() > 5) sb.append(" 외 " + (files.size() - 5) + "개");
            attachLabel.setText(sb.toString());
        }
        attachLabel.getParent().layout(true);
    }

    // ── 기존 탭들 ────────────────────────────────────────────────────────────

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

        // 더블클릭 → 파일 열기
        workspaceTree.addListener(SWT.DefaultSelection, e -> {
            TreeItem[] sel = workspaceTree.getSelection();
            if (sel.length == 0) return;
            TreeItem item = sel[0];
            Boolean isDir = (Boolean) item.getData("isDir");
            if (isDir != null && isDir) return;
            String path = (String) item.getData("path");
            if (path != null) openWorkspaceFile(path);
        });

        // 우클릭 컨텍스트 메뉴 → 삭제
        Menu contextMenu = new Menu(workspaceTree);
        MenuItem deleteItem = new MenuItem(contextMenu, SWT.PUSH);
        deleteItem.setText("삭제");
        deleteItem.addListener(SWT.Selection, e -> {
            TreeItem[] sel = workspaceTree.getSelection();
            if (sel.length == 0) return;
            TreeItem item = sel[0];
            String path = (String) item.getData("path");
            Boolean isDir = (Boolean) item.getData("isDir");
            if (path != null) deleteWorkspaceItem(path, isDir != null && isDir);
        });
        workspaceTree.setMenu(contextMenu);

        Button refreshBtn = new Button(panel, SWT.PUSH);
        refreshBtn.setText("새로고침");
        refreshBtn.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
        refreshBtn.addListener(SWT.Selection, e -> loadWorkspaceFiles());
    }

    /** 경고 다이얼로그 표시 후 서버에서 파일/폴더를 삭제한다. */
    private void deleteWorkspaceItem(String path, boolean isDir) {
        if (userId == null) return;

        String typeLabel = isDir ? "폴더" : "파일";
        MessageBox confirm = new MessageBox(
                getSite().getShell(), SWT.ICON_WARNING | SWT.YES | SWT.NO);
        confirm.setText(typeLabel + " 삭제");
        confirm.setMessage("다음 " + typeLabel + "을(를) 삭제하시겠습니까?\n\n"
                + path + "\n\n이 작업은 되돌릴 수 없습니다.");

        if (confirm.open() != SWT.YES) return;

        final String uid = userId;
        new Thread(() -> {
            try {
                boolean ok = apiClient.deleteUserFile(uid, path);
                if (ok) {
                    execJs(HtmlRenderer.systemMessage(typeLabel + " 삭제됨: " + path));
                    loadWorkspaceFiles();  // 트리 갱신
                } else {
                    execJs(HtmlRenderer.errorMessage(typeLabel + " 삭제 실패: " + path));
                }
            } catch (Exception ex) {
                execJs(HtmlRenderer.errorMessage("삭제 오류: " + ex.getMessage()));
            }
        }, "c2j-delete").start();
    }

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
        inputText.setMessage("자유 메시지 입력... (체크한 파일이 자동 첨부됩니다)");
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

    // ── Browser JS 헬퍼 ──────────────────────────────────────────────────────

    private void execJs(String js) {
        Display display = getSite().getShell().getDisplay();
        display.asyncExec(() -> {
            if (browser != null && !browser.isDisposed()) {
                browser.execute(js);
            }
        });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 서버 연결 & 세션
    // ─────────────────────────────────────────────────────────────────────────

    private void checkServerAndInitSession() {
        new Thread(() -> {
            boolean alive = apiClient.isServerAlive();
            Display display = getSite().getShell().getDisplay();
            display.asyncExec(() -> {
                if (alive) {
                    setStatus("● Connected", SWT.COLOR_DARK_GREEN);
                    execJs(HtmlRenderer.banner());
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

                // workspace 파일 수 + 프로그램 수 조회 (connectionInfo용)
                int wsCount = 0;
                try {
                    List<UserFileInfo> wsFiles = apiClient.listUserFiles(finalUserId);
                    wsCount = wsFiles.size();
                    final List<UserFileInfo> files = wsFiles;
                    getSite().getShell().getDisplay().asyncExec(() -> {
                        if (workspaceTree != null && !workspaceTree.isDisposed()) {
                            buildServerFileTree(files);
                        }
                    });
                } catch (Exception ignored) {}

                int pgCount = 0;
                try {
                    List<ProgramInfo> progs = apiClient.listPrograms("", 200);
                    pgCount = progs.size();
                } catch (Exception ignored) {}

                execJs("document.getElementById('content').innerHTML='';window._buf='';");
                execJs(HtmlRenderer.banner());
                execJs(HtmlRenderer.connectionInfo(
                    sessionId.substring(0, 8) + "...",
                    finalUserId, wsCount, pgCount));

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
    // Workspace 파일 (서버)
    // ─────────────────────────────────────────────────────────────────────────

    private void loadWorkspaceFiles() {
        if (userId == null) return;
        final String uid = userId;
        new Thread(() -> {
            try {
                List<UserFileInfo> files = apiClient.listUserFiles(uid);
                getSite().getShell().getDisplay().asyncExec(() -> {
                    if (workspaceTree.isDisposed()) return;
                    buildServerFileTree(files);
                });
                // 새로고침 시 브라우저 출력 없음 — 트리만 갱신
            } catch (Exception e) {
                // Workspace 로드 실패는 조용히 무시 (서버 미연결 시 등)
            }
        }, "c2j-workspace").start();
    }

    private void buildServerFileTree(List<UserFileInfo> files) {
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
                        folder.setData("path", currentPath);
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
        for (TreeItem item : workspaceTree.getItems()) item.setExpanded(true);
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
    // GraphDB 프로그램 목록
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
                // 프로그램 목록 갱신은 트리만, 브라우저 출력 없음
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
        isConversionMode = true;
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
    // ★ v5: 자유 메시지 전송 (첨부 파일 포함)
    // ─────────────────────────────────────────────────────────────────────────

    private void sendMessage() {
        if (running) { execJs(HtmlRenderer.warningMessage("이미 실행 중입니다.")); return; }
        String msg = inputText.getText().trim();
        if (msg.isEmpty()) return;
        inputText.setText("");

        // ★ 체크된 파일 내용을 컨텍스트로 첨부
        String fileContext = buildFileContext();
        List<IFile> attachedFiles = getCheckedFiles();

        // UI에 표시: 사용자 메시지 + 첨부 정보
        if (!attachedFiles.isEmpty()) {
            StringBuilder attachInfo = new StringBuilder(msg);
            attachInfo.append("\n📎 ");
            for (int i = 0; i < attachedFiles.size() && i < 5; i++) {
                if (i > 0) attachInfo.append(", ");
                attachInfo.append(attachedFiles.get(i).getName());
            }
            if (attachedFiles.size() > 5)
                attachInfo.append(" 외 " + (attachedFiles.size() - 5) + "개");
            execJs(HtmlRenderer.userTurn(attachInfo.toString()));
        } else {
            execJs(HtmlRenderer.userTurn(msg));
        }

        execJs(HtmlRenderer.assistantTurnStart());
        inAssistantTurn = true;
        isConversionMode = false;

        if (currentSessionId == null) {
            execJs(HtmlRenderer.warningMessage("세션이 없습니다."));
            return;
        }
        setRunning(true);
        String sessionId = currentSessionId;
        String fullMessage = msg + fileContext;

        new Thread(() ->
            apiClient.sendSessionMessage(sessionId, fullMessage, makeCallback(sessionId)),
        "c2j-message").start();
    }

    public void sendTextFromEditor(String text) {
        getSite().getShell().getDisplay().asyncExec(() -> {
            inputText.setText(text);
            sendMessage();
        });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // SSE 콜백
    // ─────────────────────────────────────────────────────────────────────────

    private SessionStreamCallback makeCallback(String sessionId) {
        return new SessionStreamCallback() {

            @Override public void onToken(String text) {
                if (inToolGroup) {
                    execJs(HtmlRenderer.closeToolGroup());
                    inToolGroup = false;
                }
                execJs(HtmlRenderer.appendToken(text));
            }

            @Override public void onToolStart(String tool, int count) {
                toolCallCount = count;
                inToolGroup = true;
                if (!inAssistantTurn) {
                    execJs(HtmlRenderer.assistantTurnStart());
                    inAssistantTurn = true;
                }
                execJs(HtmlRenderer.toolStart(tool, count));
                getSite().getShell().getDisplay().asyncExec(() -> updateToolCount(count));
            }

            @Override public void onToolEnd(String tool) {
                execJs(HtmlRenderer.toolEnd(tool, toolCallCount));
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
                execJs(HtmlRenderer.doneMessage(stopReason, count, isConversionMode));
                if (generatedFiles != null && !generatedFiles.isEmpty()) {
                    execJs(HtmlRenderer.filesListStart(count));
                    for (GeneratedFile gf : generatedFiles) {
                        execJs(HtmlRenderer.fileEntry(gf.getFileName(), gf.path));
                    }
                    saveGeneratedFiles(sessionId, generatedFiles);
                }
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
    // 파일 저장
    // ─────────────────────────────────────────────────────────────────────────

    private void saveGeneratedFiles(String sessionId, List<GeneratedFile> files) {
        new Thread(() -> {
            IProject project = getActiveProject();
            if (project == null) {
                execJs(HtmlRenderer.warningMessage("열린 프로젝트가 없습니다."));
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
                result[0] = ((IFileEditorInput) editor.getEditorInput()).getFile().getProject();
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
    // Interrupt
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
        execJs(HtmlRenderer.banner());
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
