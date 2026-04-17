package com.deepagents.cli.util;

/**
 * DeepAgents 터미널 스타일 HTML 렌더링 엔진.
 * 터미널/CLI 느낌의 컴팩트한 출력.
 * 외부 라이브러리 없이 Java 표준만 사용 — 폐쇄망 호환.
 *
 * 출력 예시:
 *   ─── session: a1b2c3d4 ───
 *   $ COBOL→Java 전환: AIPBA30
 *   > pipeline_status.md 초기화 완료.
 *     Stage 1: Analysis 시작합니다.
 *     ⚡ write_todos ✓ | execute ✓ | search_cobol ✓ | read_file ⟳
 *   > GraphDB에서 프로그램 정보를 조회합니다.
 *   ✅ 완료 — 생성 파일 3개 (generated/ 에 저장됨)
 */
public class HtmlRenderer {

    public static String buildShell() {
        return "<!DOCTYPE html>\n"
            + "<html><head><meta charset='UTF-8'>\n"
            + "<style>\n" + CSS + "</style>\n"
            + "</head><body>\n"
            + "<div id='content'></div>\n"
            + "<script>\n" + JS + "</script>\n"
            + "</body></html>";
    }

    // ── 블록 생성 ─────────────────────────────────────────────────────────────

    /** 시스템 메시지 — 얇은 구분선 스타일 */
    public static String systemMessage(String text) {
        return jsAppend("<div class='sys'>─── " + esc(text) + " ───</div>");
    }

    /** 초기 접속 정보 — 접기 가능한 블록 (서버 연결 성공 + 상세는 접힌 상태) */
    public static String connectionInfo(String sessionId, String userId,
                                         int workspaceFiles, int programCount) {
        return jsAppend(
            "<div class='conn-ok'>● 서버 연결 성공</div>"
            + "<details class='conn-details'>"
            + "<summary class='conn-summary'>세션 정보 (클릭하여 펼치기)</summary>"
            + "<div class='conn-body'>"
            + "  세션: " + esc(sessionId) + "<br>"
            + "  사용자: " + esc(userId) + "<br>"
            + "  Workspace: " + workspaceFiles + "개 파일<br>"
            + "  프로그램: " + programCount + "개"
            + "</div></details>"
        );
    }

    /** 초기 배너 (세션 최초 시작 시 1회 표시) */
    public static String banner() {
        String art =
              "██████╗  ███████╗███████╗██████╗   ▄▓▓▄\n"
            + "██╔══██╗ ██╔════╝██╔════╝██╔══██╗ ▓•███▙\n"
            + "██║  ██║ █████╗  █████╗  ██████╔╝ ░▀▀████▙▖\n"
            + "██║  ██║ ██╔══╝  ██╔══╝  ██╔═══╝     █▓████▙▖\n"
            + "██████╔╝ ███████╗███████╗██║         ▝█▓█████▙\n"
            + "╚═════╝  ╚══════╝╚══════╝╚═╝          ░▜█▓████▙\n"
            + "                                       ░█▀█▛▀▀▜▙▄\n"
            + "                                     ░▀░▀▒▛░░  ▝▀▘\n"
            + " █████╗  ██████╗ ███████╗███╗   ██╗████████╗███████╗    ██████╗ ██████╗   ██████╗\n"
            + "██╔══██╗██╔════╝ ██╔════╝████╗  ██║╚══██╔══╝██╔════╝   ██╔════╝ ╚════██╗      ██║\n"
            + "███████║██║ ███╗ █████╗  ██╔██╗ ██║   ██║   ███████╗   ██║       █████╔╝      ██║\n"
            + "██╔══██║██║  ██║ ██╔══╝  ██║╚██╗██║   ██║   ╚════██║   ██║      ██╔═══╝  ██   ██║\n"
            + "██║  ██║╚██████╔╝███████╗██║ ╚████║   ██║   ███████║   ╚██████╗ ╚██████╗ ╚█████╔╝\n"
            + "╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝    ╚═════╝  ╚═════╝  ╚════╝\n"
            + "                                                                                ";
        return jsAppend("<pre class='banner'>" + esc(art).replace("<br>", "\n") + "</pre>");
    }

    /** 사용자 입력 */
    public static String userTurn(String text) {
        return jsAppend("<div class='user'><span class='prompt'>$</span> " + esc(text) + "</div>");
    }

    /**
     * 어시스턴트 응답 턴 시작.
     * response 컨테이너만 만들고, current-turn은 맨 끝에 추가.
     * 이후 텍스트/툴 모두 response 끝에 시간순으로 append 됨.
     */
    public static String assistantTurnStart() {
        return "if(!document.getElementById('current-response')){"
             + jsAppendRaw(
                "<div class='response' id='current-response'></div>"
             )
             + "}"
             // current-turn이 없으면 response 끝에 새로 생성
             + "ensureCurrentTurn();"
             + "window._buf='';"
             + "scrollBottom();";
    }

    /** 토큰 스트리밍 — current-turn(response 맨 끝)에 누적 */
    public static String appendToken(String text) {
        String escaped = jsStr(text);
        return "if(!window._buf)window._buf='';"
             + "window._buf+=" + escaped + ";"
             + "var el=document.getElementById('current-turn');"
             + "if(el){el.innerHTML=parseMd(window._buf);}"
             + "scrollBottom();";
    }

    /** 턴 종료 — 빈 텍스트 영역 제거, id 해제 */
    public static String assistantTurnEnd() {
        return "var el=document.getElementById('current-turn');"
             + "if(el){"
             + "  var txt=window._buf||'';"
             + "  if(txt.trim()){el.innerHTML=parseMd(txt);}else{el.remove();}"
             + "  el.removeAttribute('id');"
             + "}"
             + "var resp=document.getElementById('current-response');"
             + "if(resp){resp.removeAttribute('id');}"
             + "window._buf='';scrollBottom();";
    }

    /**
     * 툴 시작.
     * 1. current-turn이 있고 텍스트가 있으면 → 고정(id 해제)
     * 2. current-turn이 있고 비어있으면 → 제거
     * 3. response 끝에 tool-wrap 추가
     */
    public static String toolStart(String toolName, int count) {
        String chipId = "tool-" + count;
        String chipHtml = "<span class='chip' id='" + chipId + "'>"
            + esc(toolName) + " <span class='chip-s spin'>⟳</span></span>";

        return
             // response가 없으면 생성
             "var resp=document.getElementById('current-response');"
             + "if(!resp){"
             + jsAppendRaw("<div class='response' id='current-response'></div>")
             + "resp=document.getElementById('current-response');"
             + "}"
             // 현재 텍스트 영역이 있으면 고정 (시간순 유지)
             + "var ct=document.getElementById('current-turn');"
             + "if(ct){"
             + "  var txt=window._buf||'';"
             + "  if(txt.trim()){ct.innerHTML=parseMd(txt);}else{ct.remove();}"
             + "  if(ct.parentNode)ct.removeAttribute('id');"
             + "  window._buf='';"
             + "}"
             // tool-wrap: 마지막 자식이 열린 tool-wrap이면 재사용, 아니면 새로 생성
             + "var last=resp.lastElementChild;"
             + "var tw=(last&&last.classList.contains('tool-wrap')&&last.dataset.closed!=='1')?last:null;"
             + "if(!tw){"
             + "  tw=document.createElement('details');"
             + "  tw.className='tool-wrap';tw.open=true;"
             + "  tw.innerHTML=\"<summary class='tool-summary'><span class='tool-label'>⚡ tools</span>"
             + "<span class='tool-counter'>0/0</span></summary><div class='tool-bar'></div>\";"
             + "  tw.dataset.total='0';tw.dataset.done='0';"
             + "  resp.appendChild(tw);"
             + "}"
             + "var tb=tw.querySelector('.tool-bar');"
             + "tb.insertAdjacentHTML('beforeend'," + jsStr(chipHtml) + ");"
             + "tw.dataset.total=parseInt(tw.dataset.total||0)+1;"
             + "updateToolCounter(tw);"
             + "scrollBottom();";
    }

    /** 툴 완료 — 스피너→체크, 전부 완료 시 자동 접기 */
    public static String toolEnd(String toolName, int count) {
        String chipId = "tool-" + count;
        return "var chip=document.getElementById('" + chipId + "');"
             + "if(chip){"
             + "  var s=chip.querySelector('.chip-s');"
             + "  if(s){s.textContent='✓';s.className='chip-s ok';}"
             + "  var tw=chip.closest('.tool-wrap');"
             + "  if(tw){"
             + "    tw.dataset.done=parseInt(tw.dataset.done||0)+1;"
             + "    updateToolCounter(tw);"
             + "    if(tw.dataset.done===tw.dataset.total){tw.open=false;}"
             + "  }"
             + "}"
             + "scrollBottom();";
    }

    /**
     * 툴 그룹 닫기 + response 끝에 새 텍스트 영역 생성.
     * 다음 토큰은 이 새 텍스트 영역(response 맨 끝)에 들어감 → 시간순 보장.
     */
    public static String closeToolGroup() {
        return "var resp=document.getElementById('current-response');"
             + "if(resp){"
             + "  var last=resp.lastElementChild;"
             + "  if(last&&last.classList.contains('tool-wrap')){"
             + "    last.dataset.closed='1';"
             + "    if(last.dataset.done===last.dataset.total)last.open=false;"
             + "  }"
             + "}"
             + "ensureCurrentTurn();"
             + "window._buf='';";
    }

    /** 인터럽트 */
    public static String interruptBlock(String details) {
        return jsAppend("<div class='interrupt'>⏸ 승인 대기<br>" + esc(details) + "</div>");
    }

    /** 예산 초과 */
    public static String budgetExceeded(String tool, int count, int budget) {
        return jsAppend("<div class='warn'>🚫 툴 예산 초과: " + esc(tool) + " (" + count + "/" + budget + ")</div>");
    }

    /** 완료 — 상황에 따라 다른 메시지 */
    public static String doneMessage(String stopReason, int fileCount, boolean isConversion) {
        if (isConversion && fileCount > 0) {
            return jsAppend("<div class='done'>✅ 전환 완료 — 생성 파일 " + fileCount + "개</div>");
        } else if (fileCount > 0) {
            return jsAppend("<div class='done'>✅ 완료 — 생성 파일 " + fileCount + "개</div>");
        } else if ("error".equals(stopReason)) {
            return jsAppend("<div class='err'>❌ 오류로 종료됨</div>");
        } else if ("budget_exceeded".equals(stopReason)) {
            return jsAppend("<div class='warn'>⚠ 예산 초과로 종료됨</div>");
        } else if ("cancelled".equals(stopReason)) {
            return jsAppend("<div class='sys'>─── 중지됨 ───</div>");
        } else {
            // end_turn (일반 대화) → 아무것도 안 표시
            return "";
        }
    }

    /** 파일 저장 완료 요약 — 개별이 아닌 요약 한 줄 */
    public static String filesSavedSummary(int count, String targetDir) {
        return jsAppend("<div class='info'>   → " + count + "개 파일 " + esc(targetDir) + " 에 저장됨</div>");
    }

    /** 생성 파일 항목 (접기 가능한 목록 안에 표시) */
    public static String filesListStart(int count) {
        return jsAppend(
            "<details class='file-list'><summary class='file-summary'>📂 생성 파일 " + count + "개 (클릭하여 펼치기)</summary>"
            + "<div class='file-items' id='file-items'></div></details>"
        );
    }

    public static String fileEntry(String fileName, String path) {
        return "var fi=document.getElementById('file-items');"
             + "if(fi){fi.insertAdjacentHTML('beforeend',"
             + jsStr("<div class='file-item'>📄 " + esc(fileName) + " <span class='fpath'>" + esc(path) + "</span></div>")
             + ");}scrollBottom();";
    }

    /** 에러 */
    public static String errorMessage(String text) {
        return jsAppend("<div class='err'>❌ " + esc(text) + "</div>");
    }

    /** 경고 */
    public static String warningMessage(String text) {
        return jsAppend("<div class='warn'>⚠ " + esc(text) + "</div>");
    }

    // ── 내부 헬퍼 ─────────────────────────────────────────────────────────────

    private static String jsAppend(String html) {
        return "var c=document.getElementById('content');"
             + "c.insertAdjacentHTML('beforeend'," + jsStr(html) + ");"
             + "scrollBottom();";
    }

    private static String jsAppendRaw(String html) {
        return "var c=document.getElementById('content');"
             + "c.insertAdjacentHTML('beforeend'," + jsStr(html) + ");";
    }

    private static String jsStr(String s) {
        if (s == null) return "''";
        return "'" + s.replace("\\", "\\\\")
                      .replace("'", "\\'")
                      .replace("\n", "\\n")
                      .replace("\r", "\\r")
                      .replace("\t", "\\t")
             + "'";
    }

    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;")
                .replace("\n", "<br>");
    }

    // ── CSS — CLI 터미널 스타일 ──────────────────────────────────────────────

    private static final String CSS =
        "* { margin: 0; padding: 0; box-sizing: border-box; }\n"
        + "body {\n"
        + "  background: #0d1117; color: #c9d1d9;\n"
        + "  font-family: 'SF Mono', 'Consolas', 'D2Coding', 'Menlo', monospace;\n"
        + "  font-size: 13px; line-height: 1.5; padding: 8px 12px;\n"
        + "}\n"
        + "#content { max-width: 100%; }\n"
        + "\n"
        + "/* ── 배너 ── */\n"
        + ".banner {\n"
        + "  color: #3fb950; font-size: 8px; line-height: 1.1;\n"
        + "  margin: 8px 0; white-space: pre; overflow-x: auto;\n"
        + "  background: none; border: none; padding: 0;\n"
        + "}\n"
        + "\n"
        + "/* ── 시스템 ── */\n"
        + ".sys { color: #484f58; font-size: 12px; margin: 4px 0; }\n"
        + ".conn-ok { color: #3fb950; font-weight: 600; margin: 6px 0 2px 0; }\n"
        + ".conn-details { margin: 0 0 6px 0; }\n"
        + ".conn-summary { color: #484f58; font-size: 11px; cursor: pointer; padding: 2px 0; }\n"
        + ".conn-summary:hover { color: #8b949e; }\n"
        + ".conn-body { color: #484f58; font-size: 11px; padding: 4px 0 4px 16px; }\n"
        + "\n"
        + "/* ── 사용자 입력 ── */\n"
        + ".user {\n"
        + "  color: #58a6ff; margin: 8px 0 2px 0; font-weight: 600;\n"
        + "}\n"
        + ".prompt { color: #3fb950; margin-right: 6px; }\n"
        + "\n"
        + "/* ── 응답 블록 ── */\n"
        + ".response {\n"
        + "  margin: 2px 0 8px 0;\n"
        + "  padding-left: 16px;\n"
        + "  border-left: 2px solid #30363d;\n"
        + "}\n"
        + ".resp-text { margin: 2px 0; }\n"
        + ".resp-text p { margin: 1px 0; }\n"
        + "\n"
        + "/* ── 마크다운 ── */\n"
        + ".resp-text h1, .resp-text h2, .resp-text h3 {\n"
        + "  color: #e6edf3; margin: 6px 0 3px 0;\n"
        + "}\n"
        + ".resp-text h1 { font-size: 15px; }\n"
        + ".resp-text h2 { font-size: 14px; }\n"
        + ".resp-text h3 { font-size: 13px; }\n"
        + ".resp-text strong { color: #e6edf3; }\n"
        + ".resp-text em { color: #8b949e; }\n"
        + ".resp-text code {\n"
        + "  background: #161b22; padding: 1px 4px; border-radius: 3px;\n"
        + "  color: #f0883e; font-size: 12px;\n"
        + "}\n"
        + ".resp-text pre {\n"
        + "  background: #161b22; border: 1px solid #30363d; border-radius: 4px;\n"
        + "  padding: 8px; margin: 4px 0; overflow-x: auto;\n"
        + "  font-size: 12px; line-height: 1.4;\n"
        + "}\n"
        + ".resp-text pre code { background: none; padding: 0; color: #c9d1d9; }\n"
        + ".resp-text ul, .resp-text ol { margin: 3px 0 3px 18px; }\n"
        + ".resp-text li { margin: 1px 0; }\n"
        + "\n"
        + "/* 구문 강조 */\n"
        + ".kw { color: #ff7b72; }\n"
        + ".str { color: #a5d6ff; }\n"
        + ".cm { color: #8b949e; }\n"
        + ".ty { color: #79c0ff; }\n"
        + ".num { color: #f2cc60; }\n"
        + ".ann { color: #ffa657; }\n"
        + "\n"
        + "/* ── 툴 그룹 (접기/펼치기) ── */\n"
        + ".tool-wrap {\n"
        + "  margin: 4px 0; border: 1px solid #21262d; border-radius: 4px;\n"
        + "  background: #0d1117;\n"
        + "}\n"
        + ".tool-summary {\n"
        + "  padding: 3px 8px; cursor: pointer; font-size: 12px;\n"
        + "  color: #8b949e; display: flex; align-items: center; gap: 6px;\n"
        + "  list-style: none;\n"
        + "}\n"
        + ".tool-summary::-webkit-details-marker { display: none; }\n"
        + ".tool-summary::before { content: '▶'; font-size: 9px; transition: transform .15s; }\n"
        + ".tool-wrap[open] > .tool-summary::before { transform: rotate(90deg); }\n"
        + ".tool-label { flex: 1; }\n"
        + ".tool-counter { color: #58a6ff; font-size: 11px; }\n"
        + ".tool-counter.all-done { color: #3fb950; }\n"
        + ".tool-bar {\n"
        + "  display: flex; flex-wrap: wrap; gap: 4px;\n"
        + "  padding: 4px 8px 6px 8px;\n"
        + "}\n"
        + ".chip {\n"
        + "  display: inline-flex; align-items: center; gap: 3px;\n"
        + "  padding: 1px 8px; border-radius: 3px;\n"
        + "  background: #161b22; border: 1px solid #30363d;\n"
        + "  font-size: 11px; color: #8b949e;\n"
        + "}\n"
        + ".chip-s { font-size: 11px; }\n"
        + ".chip-s.spin { color: #58a6ff; display: inline-block; animation: spin .8s linear infinite; }\n"
        + ".chip-s.ok { color: #3fb950; }\n"
        + "@keyframes spin { from{transform:rotate(0deg)} to{transform:rotate(360deg)} }\n"
        + "\n"
        + "/* ── 상태 메시지 ── */\n"
        + ".done { color: #3fb950; margin: 6px 0; font-weight: 600; }\n"
        + ".err { color: #f85149; margin: 4px 0; }\n"
        + ".warn { color: #d29922; margin: 4px 0; }\n"
        + ".info { color: #484f58; margin: 1px 0; font-size: 12px; }\n"
        + ".interrupt {\n"
        + "  color: #d29922; margin: 6px 0; padding: 6px 10px;\n"
        + "  border: 1px solid #d29922; border-radius: 4px;\n"
        + "  background: #1c1500;\n"
        + "}\n"
        + "\n"
        + "/* ── 파일 목록 (접기) ── */\n"
        + ".file-list { margin: 4px 0; }\n"
        + ".file-summary {\n"
        + "  color: #8b949e; font-size: 12px; cursor: pointer;\n"
        + "  padding: 2px 0;\n"
        + "}\n"
        + ".file-summary:hover { color: #c9d1d9; }\n"
        + ".file-items { padding-left: 16px; }\n"
        + ".file-item { color: #484f58; font-size: 11px; padding: 1px 0; }\n"
        + ".file-item .fpath { color: #30363d; margin-left: 6px; }\n";

    // ── JavaScript ───────────────────────────────────────────────────────────

    private static final String JS =
        "function scrollBottom(){ window.scrollTo(0,document.body.scrollHeight); }\n"
        + "/* response 끝에 current-turn이 없으면 새로 추가 */\n"
        + "function ensureCurrentTurn(){\n"
        + "  if(document.getElementById('current-turn')) return;\n"
        + "  var resp=document.getElementById('current-response');\n"
        + "  if(!resp) return;\n"
        + "  var ta=document.createElement('div');\n"
        + "  ta.className='resp-text';ta.id='current-turn';\n"
        + "  resp.appendChild(ta);\n"
        + "}\n"
        + "function updateToolCounter(tw){\n"
        + "  var d=parseInt(tw.dataset.done||0),t=parseInt(tw.dataset.total||0);\n"
        + "  var tc=tw.querySelector('.tool-counter');\n"
        + "  if(tc){\n"
        + "    tc.textContent=d+'/'+t+(d===t?' ✓':'');\n"
        + "    tc.className=d===t?'tool-counter all-done':'tool-counter';\n"
        + "  }\n"
        + "  var lbl=tw.querySelector('.tool-label');\n"
        + "  if(lbl) lbl.textContent='⚡ tools'+(d<t?' (실행 중...)':'');\n"
        + "}\n"
        + "\n"
        + "function parseMd(src){\n"
        + "  if(!src) return '';\n"
        + "  var lines=src.split('\\n'), out=[], inCode=false, codeLang='', codeLines=[];\n"
        + "  for(var i=0;i<lines.length;i++){\n"
        + "    var line=lines[i];\n"
        + "    if(line.match(/^```/)){\n"
        + "      if(!inCode){inCode=true;codeLang=line.replace(/^```\\s*/,'').trim();codeLines=[];}\n"
        + "      else{out.push('<pre><code>'+hlCode(esc(codeLines.join('\\n')),codeLang)+'</code></pre>');inCode=false;codeLang='';codeLines=[];}\n"
        + "      continue;\n"
        + "    }\n"
        + "    if(inCode){codeLines.push(line);continue;}\n"
        + "    var hm=line.match(/^(#{1,3})\\s+(.*)/);\n"
        + "    if(hm){out.push('<h'+hm[1].length+'>'+inl(hm[2])+'</h'+hm[1].length+'>');continue;}\n"
        + "    if(line.match(/^\\s*[-*]\\s+/)){out.push('<li>'+inl(line.replace(/^\\s*[-*]\\s+/,''))+'</li>');continue;}\n"
        + "    if(line.match(/^\\s*\\d+\\.\\s+/)){out.push('<li>'+inl(line.replace(/^\\s*\\d+\\.\\s+/,''))+'</li>');continue;}\n"
        + "    if(line.match(/^\\s*\\|/)){out.push('<p class=\"tbl\">'+esc(line)+'</p>');continue;}\n"
        + "    if(line.match(/^---+$/)){out.push('<hr>');continue;}\n"
        + "    if(line.trim()===''){out.push('<br>');continue;}\n"
        + "    out.push('<p>'+inl(line)+'</p>');\n"
        + "  }\n"
        + "  if(inCode) out.push('<pre><code>'+hlCode(esc(codeLines.join('\\n')),codeLang)+'</code></pre>');\n"
        + "  return out.join('');\n"
        + "}\n"
        + "function inl(s){s=esc(s);s=s.replace(/`([^`]+)`/g,'<code>$1</code>');s=s.replace(/\\*\\*([^*]+)\\*\\*/g,'<strong>$1</strong>');s=s.replace(/\\*([^*]+)\\*/g,'<em>$1</em>');return s;}\n"
        + "function esc(s){return s?s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'):''}\n"
        + "\n"
        + "function hlCode(c,l){\n"
        + "  if(!l)return c;l=l.toLowerCase();\n"
        + "  if(l==='java'||l==='js'||l==='typescript'||l==='ts')return hlJava(c);\n"
        + "  if(l==='cobol'||l==='cob')return hlCobol(c);\n"
        + "  if(l==='sql')return hlSql(c);\n"
        + "  return c;\n"
        + "}\n"
        + "function hlJava(c){\n"
        + "  c=c.replace(/(\\/\\/[^\\n]*)/g,'<span class=\"cm\">$1</span>');\n"
        + "  c=c.replace(/(\\/\\*[\\s\\S]*?\\*\\/)/g,'<span class=\"cm\">$1</span>');\n"
        + "  c=c.replace(/(\"[^\"]*\")/g,'<span class=\"str\">$1</span>');\n"
        + "  c=c.replace(/(@\\w+)/g,'<span class=\"ann\">$1</span>');\n"
        + "  c=c.replace(/\\b(\\d+\\.?\\d*[fFdDlL]?)\\b/g,'<span class=\"num\">$1</span>');\n"
        + "  var kw='abstract|assert|boolean|break|byte|case|catch|char|class|const|continue|default|do|double|else|enum|extends|final|finally|float|for|if|implements|import|instanceof|int|interface|long|new|package|private|protected|public|return|short|static|super|switch|this|throw|throws|try|void|volatile|while|var|record';\n"
        + "  c=c.replace(new RegExp('\\\\b('+kw+')\\\\b','g'),'<span class=\"kw\">$1</span>');\n"
        + "  c=c.replace(/\\b([A-Z][A-Za-z0-9_]*)/g,'<span class=\"ty\">$1</span>');\n"
        + "  return c;\n"
        + "}\n"
        + "function hlCobol(c){\n"
        + "  c=c.replace(/(\\*&gt;[^\\n]*)/g,'<span class=\"cm\">$1</span>');\n"
        + "  var kw='IDENTIFICATION|ENVIRONMENT|DATA|PROCEDURE|DIVISION|SECTION|WORKING-STORAGE|LINKAGE|PERFORM|MOVE|IF|ELSE|END-IF|EVALUATE|WHEN|END-EVALUATE|CALL|USING|DISPLAY|COMPUTE|READ|WRITE|OPEN|CLOSE|STOP|RUN|PIC|VALUE|COPY|EXEC|END-EXEC|SQL|CICS';\n"
        + "  c=c.replace(new RegExp('\\\\b('+kw+')\\\\b','gi'),'<span class=\"kw\">$1</span>');\n"
        + "  c=c.replace(/(\"[^\"]*\")/g,'<span class=\"str\">$1</span>');\n"
        + "  c=c.replace(/('[^']*')/g,'<span class=\"str\">$1</span>');\n"
        + "  return c;\n"
        + "}\n"
        + "function hlSql(c){\n"
        + "  c=c.replace(/(--[^\\n]*)/g,'<span class=\"cm\">$1</span>');\n"
        + "  var kw='SELECT|FROM|WHERE|AND|OR|INSERT|INTO|VALUES|UPDATE|SET|DELETE|CREATE|ALTER|DROP|TABLE|JOIN|LEFT|RIGHT|INNER|ON|AS|ORDER|BY|GROUP|HAVING|LIMIT|UNION|DISTINCT|BETWEEN|LIKE|IS|NULL|CASE|WHEN|THEN|ELSE|END|COUNT|SUM|AVG|MAX|MIN';\n"
        + "  c=c.replace(new RegExp('\\\\b('+kw+')\\\\b','gi'),'<span class=\"kw\">$1</span>');\n"
        + "  c=c.replace(/(\"[^\"]*\")/g,'<span class=\"str\">$1</span>');\n"
        + "  c=c.replace(/('[^']*')/g,'<span class=\"str\">$1</span>');\n"
        + "  return c;\n"
        + "}\n";
}
