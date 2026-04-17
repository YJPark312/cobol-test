package com.deepagents.cli.views;

import com.deepagents.cli.Activator;
import com.deepagents.cli.model.AgentRequest;
import com.deepagents.cli.preferences.PreferenceConstants;
import com.deepagents.cli.util.ApiClient;
import com.deepagents.cli.util.ApiClient.PermissionOption;
import com.deepagents.cli.util.ApiClient.SessionStreamCallback;
import com.deepagents.cli.util.McpRelayClient;

import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.preference.IPreferenceStore;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.events.KeyAdapter;
import org.eclipse.swt.events.KeyEvent;
import org.eclipse.swt.layout.*;
import org.eclipse.swt.widgets.*;
import org.eclipse.ui.part.ViewPart;

import java.util.List;
import java.util.UUID;

/**
 * Eclipse View: DeepAgents CLI Panel
 *
 * - 세션 기반 대화형 모드 (--acp)
 * - McpRelayClient: Eclipse 워크스페이스를 MCP 서버로 노출, deepagents와 연결
 *   - 뷰 오픈 시 API 서버에 아웃바운드 SSE 연결 (방화벽 무관)
 *   - 세션 생성 시 relay_id 전달 → deepagents가 워크스페이스 read/write 가능
 */
public class DeepAgentsView extends ViewPart {

    public static final String ID = "com.deepagents.cli.views.DeepAgentsView";

    private StyledText outputText;
    private Text       inputText;
    private Combo      agentCombo;
    private Button     autoApproveCheck;
    private Button     sendButton;
    private Label      statusLabel;
    private Label      mcpStatusLabel;

    private ApiClient      apiClient;
    private McpRelayClient mcpRelay;
    private volatile boolean running = false;

    /** 현재 사용자 세션 ID (null 이면 /run fallback) */
    private volatile String currentSessionId = null;

    // ──────────────────────────────────────────────
    // 뷰 생성
    // ──────────────────────────────────────────────

    @Override
    public void createPartControl(Composite parent) {
        apiClient = new ApiClient();

        parent.setLayout(new GridLayout(1, false));

        // ── 상단 툴바 ──────────────────────────────────
        Composite toolbar = new Composite(parent, SWT.NONE);
        toolbar.setLayout(new RowLayout(SWT.HORIZONTAL));
        toolbar.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));

        new Label(toolbar, SWT.NONE).setText("Agent:");
        agentCombo = new Combo(toolbar, SWT.DROP_DOWN);
        agentCombo.add("(default)");
        agentCombo.add("coder");
        agentCombo.add("researcher");
        agentCombo.select(0);

        autoApproveCheck = new Button(toolbar, SWT.CHECK);
        autoApproveCheck.setText("Auto-approve");
        IPreferenceStore prefs = Activator.getDefault().getPreferenceStore();
        autoApproveCheck.setSelection(prefs.getBoolean(PreferenceConstants.AUTO_APPROVE));

        Button refreshBtn = new Button(toolbar, SWT.PUSH);
        refreshBtn.setText("Refresh Agents");
        refreshBtn.addListener(SWT.Selection, e -> refreshAgents());

        Button mySkillsBtn = new Button(toolbar, SWT.PUSH);
        mySkillsBtn.setText("My Skills");
        mySkillsBtn.addListener(SWT.Selection, e -> showMySkills());

        Button clearBtn = new Button(toolbar, SWT.PUSH);
        clearBtn.setText("Clear");
        clearBtn.addListener(SWT.Selection, e -> clearOutput());

        Button newSessionBtn = new Button(toolbar, SWT.PUSH);
        newSessionBtn.setText("New Session");
        newSessionBtn.addListener(SWT.Selection, e -> initSession());

        statusLabel = new Label(toolbar, SWT.NONE);
        statusLabel.setText("● Ready");

        // MCP 릴레이 상태 표시
        mcpStatusLabel = new Label(toolbar, SWT.NONE);
        mcpStatusLabel.setText("◌ MCP");
        mcpStatusLabel.setToolTipText("워크스페이스 MCP 릴레이 상태");

        // ── 출력 영역 ──────────────────────────────────
        outputText = new StyledText(parent,
                SWT.MULTI | SWT.BORDER | SWT.V_SCROLL | SWT.H_SCROLL | SWT.READ_ONLY | SWT.WRAP);
        outputText.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true));
        outputText.setFont(new org.eclipse.swt.graphics.Font(
                parent.getDisplay(), "Monospace", 10, SWT.NORMAL));
        outputText.setBackground(parent.getDisplay().getSystemColor(SWT.COLOR_BLACK));
        outputText.setForeground(parent.getDisplay().getSystemColor(SWT.COLOR_GREEN));

        // ── 입력 영역 ──────────────────────────────────
        Composite inputBar = new Composite(parent, SWT.NONE);
        inputBar.setLayout(new GridLayout(2, false));
        inputBar.setLayoutData(new GridData(SWT.FILL, SWT.BOTTOM, true, false));

        inputText = new Text(inputBar, SWT.BORDER | SWT.SINGLE);
        inputText.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
        inputText.setMessage("메시지를 입력하세요... (Enter 또는 Send)");
        inputText.addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(KeyEvent e) {
                if (e.keyCode == SWT.CR || e.keyCode == SWT.KEYPAD_CR) {
                    if ((e.stateMask & SWT.SHIFT) != 0) return;
                    sendMessage();
                }
            }
        });

        sendButton = new Button(inputBar, SWT.PUSH);
        sendButton.setText("Send");
        sendButton.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false));
        sendButton.addListener(SWT.Selection, e -> sendMessage());

        // MCP 릴레이 시작 → 서버 연결 확인 → 세션 생성
        initMcpRelay();
        checkServerStatus();
    }

    // ──────────────────────────────────────────────
    // MCP 릴레이 초기화
    // ──────────────────────────────────────────────

    private void initMcpRelay() {
        IPreferenceStore prefs = Activator.getDefault().getPreferenceStore();

        // relay_id 가 없으면 최초 1회 생성 후 저장
        String relayId = prefs.getString(PreferenceConstants.RELAY_ID).trim();
        if (relayId.isEmpty()) {
            relayId = UUID.randomUUID().toString().replace("-", "");
            prefs.setValue(PreferenceConstants.RELAY_ID, relayId);
        }

        String apiUrl = prefs.getString(PreferenceConstants.API_URL);
        mcpRelay = new McpRelayClient(apiUrl, relayId);
        mcpRelay.setStatusCallback(msg -> {
            // UI 스레드에서 MCP 상태 라벨 업데이트
            Display display = getSite().getShell().getDisplay();
            display.asyncExec(() -> {
                if (mcpStatusLabel.isDisposed()) return;
                mcpStatusLabel.setText(msg);
                boolean connected = msg.contains("Connected");
                mcpStatusLabel.setForeground(display.getSystemColor(
                        connected ? SWT.COLOR_DARK_GREEN : SWT.COLOR_DARK_GRAY));
            });
        });
        mcpRelay.start();

        appendOutput("[MCP 릴레이 시작 — relay_id: " + relayId.substring(0, 8) + "...]\n",
                SWT.COLOR_DARK_GRAY);
    }

    // ──────────────────────────────────────────────
    // 세션 초기화
    // ──────────────────────────────────────────────

    private void initSession() {
        if (currentSessionId != null) {
            String old = currentSessionId;
            currentSessionId = null;
            new Thread(() -> apiClient.closeSession(old), "deepagents-close").start();
        }

        IPreferenceStore prefs = Activator.getDefault().getPreferenceStore();
        boolean autoApprove = autoApproveCheck.getSelection();
        String userId  = prefs.getString(PreferenceConstants.USER_ID).trim();
        String relayId = prefs.getString(PreferenceConstants.RELAY_ID).trim();

        new Thread(() -> {
            try {
                String sessionId = apiClient.createSession(
                        null,
                        autoApprove,
                        userId.isEmpty()  ? null : userId,
                        relayId.isEmpty() ? null : relayId);
                currentSessionId = sessionId;
                String userTag = userId.isEmpty() ? "" : " | user=" + userId;
                appendOutput("[세션 시작: " + sessionId.substring(0, 8) + "..." + userTag + "]\n",
                        SWT.COLOR_DARK_GREEN);
                getSite().getShell().getDisplay().asyncExec(() -> {
                    statusLabel.setText("● Session Active");
                    statusLabel.setForeground(
                            statusLabel.getDisplay().getSystemColor(SWT.COLOR_DARK_GREEN));
                });
            } catch (Exception e) {
                appendOutput("[세션 생성 실패 — /run 모드로 동작]\n", SWT.COLOR_YELLOW);
                appendOutput("  " + e.getMessage() + "\n", SWT.COLOR_YELLOW);
            }
        }, "deepagents-init").start();
    }

    // ──────────────────────────────────────────────
    // 메시지 전송
    // ──────────────────────────────────────────────

    private void sendMessage() {
        if (running) {
            appendOutput("[!] 이미 실행 중입니다.\n", SWT.COLOR_YELLOW);
            return;
        }
        String msg = inputText.getText().trim();
        if (msg.isEmpty()) return;

        inputText.setText("");
        appendOutput("\n> " + msg + "\n", SWT.COLOR_CYAN);
        setRunning(true);

        String sessionId = currentSessionId;

        if (sessionId != null) {
            Thread t = new Thread(() -> {
                apiClient.sendSessionMessage(sessionId, msg, new SessionStreamCallback() {
                    @Override public void onOutput(String text) {
                        appendOutput(text, SWT.COLOR_GREEN);
                    }
                    @Override public void onTool(String text) {
                        appendOutput(text + "\n", SWT.COLOR_CYAN);
                    }
                    @Override public void onPermission(String tool, List<PermissionOption> options) {
                        showPermissionDialog(sessionId, tool, options);
                    }
                    @Override public void onDone(String stopReason) {
                        appendOutput("\n[✓ " + stopReason + "]\n", SWT.COLOR_DARK_GREEN);
                        setRunning(false);
                    }
                    @Override public void onError(Exception e) {
                        appendOutput("\n[ERROR] " + e.getMessage() + "\n", SWT.COLOR_RED);
                        setRunning(false);
                    }
                });
            }, "deepagents-session-stream");
            t.setDaemon(true);
            t.start();

        } else {
            // Fallback: /run one-shot
            String selectedAgent = agentCombo.getSelectionIndex() == 0
                    ? null : agentCombo.getText();
            boolean autoApprove = autoApproveCheck.getSelection();
            IPreferenceStore prefs = Activator.getDefault().getPreferenceStore();
            String shellAllow = prefs.getString(PreferenceConstants.SHELL_ALLOW);

            AgentRequest req = new AgentRequest(msg);
            req.setAgent(selectedAgent);
            req.setAutoApprove(autoApprove);
            req.setShellAllow(shellAllow.isEmpty() ? null : shellAllow);

            Thread t = new Thread(() -> {
                apiClient.runStreaming(req, new ApiClient.StreamCallback() {
                    @Override public void onChunk(String text, String type) {
                        int color = "error".equals(type) ? SWT.COLOR_RED : SWT.COLOR_GREEN;
                        appendOutput(text + "\n", color);
                    }
                    @Override public void onDone(int exitCode) {
                        String m = exitCode == 0 ? "\n[✓ Done]\n" : "\n[✗ Exit: " + exitCode + "]\n";
                        appendOutput(m, exitCode == 0 ? SWT.COLOR_DARK_GREEN : SWT.COLOR_RED);
                        setRunning(false);
                    }
                    @Override public void onError(Exception e) {
                        appendOutput("\n[ERROR] " + e.getMessage() + "\n", SWT.COLOR_RED);
                        setRunning(false);
                    }
                });
            }, "deepagents-stream");
            t.setDaemon(true);
            t.start();
        }
    }

    // ──────────────────────────────────────────────
    // Permission 다이얼로그
    // ──────────────────────────────────────────────

    private void showPermissionDialog(String sessionId, String tool, List<PermissionOption> options) {
        Display display = getSite().getShell().getDisplay();
        display.asyncExec(() -> {
            if (outputText.isDisposed()) return;

            String[] btnLabels = new String[options.size() + 1];
            for (int i = 0; i < options.size(); i++) btnLabels[i] = options.get(i).name;
            btnLabels[options.size()] = "거부";

            MessageDialog dialog = new MessageDialog(
                    getSite().getShell(),
                    "DeepAgents — 권한 요청",
                    null,
                    "도구 실행 승인이 필요합니다:\n\n" + tool,
                    MessageDialog.QUESTION,
                    btnLabels,
                    0);

            int result = dialog.open();
            String optionId = (result < 0 || result >= options.size())
                    ? "__deny__" : options.get(result).id;

            final String selected = optionId;
            new Thread(() -> {
                try { apiClient.replyPermission(sessionId, selected); }
                catch (Exception e) {
                    appendOutput("[ERROR] reply 전송 실패: " + e.getMessage() + "\n", SWT.COLOR_RED);
                }
            }, "deepagents-reply").start();

            appendOutput("[선택: " + optionId + "]\n", SWT.COLOR_DARK_CYAN);
        });
    }

    // ──────────────────────────────────────────────
    // 기타 액션
    // ──────────────────────────────────────────────

    private void refreshAgents() {
        new Thread(() -> {
            try {
                String json = apiClient.listAgents();
                getSite().getShell().getDisplay().asyncExec(() ->
                        appendOutput("[Agents] " + json + "\n", SWT.COLOR_CYAN));
            } catch (Exception e) {
                appendOutput("[ERROR] 에이전트 목록 로딩 실패: " + e.getMessage() + "\n", SWT.COLOR_RED);
            }
        }, "deepagents-refresh").start();
    }

    private void showMySkills() {
        IPreferenceStore prefs = Activator.getDefault().getPreferenceStore();
        String userId = prefs.getString(PreferenceConstants.USER_ID).trim();
        if (userId.isEmpty()) {
            appendOutput("[My Skills] User ID가 설정되지 않았습니다. Preferences → DeepAgents에서 설정하세요.\n",
                    SWT.COLOR_YELLOW);
            return;
        }
        new Thread(() -> {
            try {
                String json = apiClient.listUserSkills(userId);
                getSite().getShell().getDisplay().asyncExec(() ->
                        appendOutput("[My Skills] " + json + "\n", SWT.COLOR_CYAN));
            } catch (Exception e) {
                appendOutput("[ERROR] skills 목록 로딩 실패: " + e.getMessage() + "\n", SWT.COLOR_RED);
            }
        }, "deepagents-skills").start();
    }

    private void checkServerStatus() {
        new Thread(() -> {
            boolean alive = apiClient.isServerAlive();
            getSite().getShell().getDisplay().asyncExec(() -> {
                if (alive) {
                    statusLabel.setText("● Connected");
                    statusLabel.setForeground(
                            statusLabel.getDisplay().getSystemColor(SWT.COLOR_DARK_GREEN));
                    appendOutput("[DeepAgents API 서버 연결됨]\n", SWT.COLOR_DARK_GREEN);
                    initSession();
                } else {
                    statusLabel.setText("● Disconnected");
                    statusLabel.setForeground(
                            statusLabel.getDisplay().getSystemColor(SWT.COLOR_RED));
                    appendOutput("[!] API 서버에 연결할 수 없습니다.\n", SWT.COLOR_RED);
                }
            });
        }, "deepagents-health").start();
    }

    // ──────────────────────────────────────────────
    // UI 헬퍼
    // ──────────────────────────────────────────────

    private void appendOutput(String text, int colorId) {
        Display display = getSite().getShell().getDisplay();
        display.asyncExec(() -> {
            if (outputText.isDisposed()) return;
            int start = outputText.getCharCount();
            outputText.append(text);
            org.eclipse.swt.custom.StyleRange style = new org.eclipse.swt.custom.StyleRange();
            style.start  = start;
            style.length = text.length();
            style.foreground = display.getSystemColor(colorId);
            outputText.setStyleRange(style);
            outputText.setTopIndex(outputText.getLineCount() - 1);
        });
    }

    private void clearOutput() { outputText.setText(""); }

    private void setRunning(boolean value) {
        running = value;
        getSite().getShell().getDisplay().asyncExec(() -> {
            if (sendButton.isDisposed()) return;
            sendButton.setEnabled(!value);
            inputText.setEnabled(!value);
            statusLabel.setText(value ? "● Running..." :
                    (currentSessionId != null ? "● Session Active" : "● Ready"));
        });
    }

    /** 에디터 선택 텍스트 전달 (RunSelectionHandler 에서 호출) */
    public void sendTextFromEditor(String text) {
        getSite().getShell().getDisplay().asyncExec(() -> {
            inputText.setText(text);
            sendMessage();
        });
    }

    // ──────────────────────────────────────────────
    // 뷰 종료 시 정리
    // ──────────────────────────────────────────────

    @Override
    public void dispose() {
        if (mcpRelay != null)           mcpRelay.stop();
        if (currentSessionId != null)   apiClient.closeSession(currentSessionId);
        super.dispose();
    }

    @Override
    public void setFocus() { inputText.setFocus(); }
}
