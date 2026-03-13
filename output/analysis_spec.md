# COBOL 정적 분석 보고서

**분석 일시**: 2026-03-13
**분석 대상**: AIPBA30.cbl, DIPA301.cbl 및 연관 copybook
**분석 에이전트**: analysis-agent

---

## 1. 프로그램 개요

### 1.1 프로그램 식별 정보

| 항목 | AIPBA30 | DIPA301 |
|------|---------|---------|
| 업무명 | KIP (기업집단신용평가) | KIP (기업집단신용평가) |
| 프로그램명 | AIPBA30 (AS기업집단신용평가이력관리) | DIPA301 (DC기업집단신용평가이력관리) |
| 처리유형 | AS (Application Service) | DC (Data Component) |
| 처리개요 | 기업신용평가이력을 조회하는 거래 진입점 | 기업집단의 이력을 조회/생성/삭제하는 데이터 접근 모듈 |
| 작성자 | 이현지 | 이현지 |
| 작성일 | 2019-12-10 | 2019-11-28 |
| 소스컴퓨터 | IBM-Z10 | IBM-Z10 |

### 1.2 소스 파일 목록

| 파일 경로 | 종류 | 비고 |
|-----------|------|------|
| `cobol/KIP.DONLINE.SORC/AIPBA30.cbl` | COBOL 소스 | AS 프로그램 (정규 위치) |
| `cobol/AIPBA30.cbl` | COBOL 소스 | AS 프로그램 (중복 존재, 내용 동일) |
| `cobol/KIP.DONLINE.SORC/DIPA301.cbl` | COBOL 소스 | DC 프로그램 |
| `cobol/KIP.DCOMMON.COPY/XDIPA301.cpy` | Copybook | DC 인터페이스 (96 bytes) |
| `cobol/KIP.DCOMMON.COPY/YNIPBA30.cpy` | Copybook | AS 입력 (96 bytes) |
| `cobol/KIP.DCOMMON.COPY/YPIPBA30.cpy` | Copybook | AS 출력 (10 bytes) |
| `cobol/KIP.DCOMMON.COPY/V1IPBA30.cpy` | Copybook | 화면 전용 출력 (10 bytes) |

### 1.3 COBOL 구조 개요

- z-KESA 프레임워크 기반 온라인 거래 프로그램
- AS → DC 2계층 구조: AIPBA30(AS)이 DIPA301(DC)을 #DYCALL로 호출
- DIPA301은 11개 DB 테이블에 접근 (INSERT 1건, SELECT/DELETE 다수)
- 처리구분 코드('01'/'02'/'03')로 업무 분기: 신규평가/확정취소/삭제
- 직접 EXEC SQL 없음 — 모든 DB 접근은 DBIO 매크로(#DYDBIO) 또는 SQLIO 매크로(#DYSQLA)로 추상화

---

## 2. COBOL 구조 분석

### 2.1 DIVISION 구조

#### AIPBA30.cbl (255행)

| DIVISION | SECTION | 주요 내용 |
|----------|---------|----------|
| IDENTIFICATION | - | PROGRAM-ID: AIPBA30, AUTHOR: 이현지, DATE-WRITTEN: 09/01/31 |
| ENVIRONMENT | CONFIGURATION | SOURCE/OBJECT-COMPUTER: IBM-Z10 |
| DATA | WORKING-STORAGE | CO-AREA, CO-ERROR-AREA, WK-AREA, XZUGOTMY-CA, XIJICOMM-CA, XDIPA301-CA, YCDBSQLA |
| DATA | LINKAGE | YCCOMMON-CA (COPY YCCOMMON), YNIPBA30-CA (COPY YNIPBA30), YPIPBA30-CA (COPY YPIPBA30) |
| PROCEDURE | - | USING YCCOMMON-CA, YNIPBA30-CA |

#### DIPA301.cbl (1985행)

| DIVISION | SECTION | 주요 내용 |
|----------|---------|----------|
| IDENTIFICATION | - | PROGRAM-ID: DIPA301, AUTHOR: 이현지, DATE-WRITTEN: 19/11/28 |
| ENVIRONMENT | CONFIGURATION | SOURCE-COMPUTER/OBJECT-COMPUTER: IBM-Z10. CBL ARITH(EXTEND) 옵션 |
| DATA | WORKING-STORAGE | CO-ERROR-AREA, CO-AREA, WK-AREA, 테이블 카피북 12종, YCDBIOCA, YCDBSQLA, SQLIO 인터페이스 8종 |
| DATA | LINKAGE | YCCOMMON-CA (COPY YCCOMMON), XDIPA301-CA (COPY XDIPA301) |
| PROCEDURE | - | USING YCCOMMON-CA, XDIPA301-CA |

### 2.2 SECTION/PARAGRAPH 맵

#### AIPBA30.cbl PROCEDURE DIVISION

| Paragraph | 범위 (행) | 역할 |
|-----------|----------|------|
| S0000-MAIN-RTN | 110-128 | 메인 처리 흐름 제어 (PERFORM 4회) |
| S0000-MAIN-EXT | 127-128 | EXIT |
| S1000-INITIALIZE-RTN | 132-172 | 초기화: WK-AREA, XIJICOMM-IN, XZUGOTMY-IN, #GETOUT, BICOM SET, IJICOMM 호출 |
| S1000-INITIALIZE-EXT | 171-172 | EXIT |
| S2000-VALIDATION-RTN | 176-207 | 입력값 검증: 4개 필수항목 SPACE 체크 |
| S2000-VALIDATION-EXT | 206-207 | EXIT |
| S3000-PROCESS-RTN | 212-245 | 업무처리: DIPA301 DC 호출, 출력조립, 폼ID 설정 |
| S3000-PROCESS-EXT | 244-245 | EXIT |
| S9000-FINAL-RTN | 250-254 | 정상종료: #OKEXIT CO-STAT-OK |
| S9000-FINAL-EXT | 254-255 | EXIT |

#### DIPA301.cbl PROCEDURE DIVISION

| Paragraph | 범위 (행) | 역할 |
|-----------|----------|------|
| S0000-MAIN-RTN | 226-255 | 메인: 초기화→검증→EVALUATE 처리구분분기→종료 |
| S1000-INITIALIZE-RTN | 259-273 | WK-AREA, YCDBSQLA-CA 초기화, XDIPA301-OUT/RETURN 초기화, 결과코드 OK세팅 |
| S2000-VALIDATION-RTN | 277-329 | 입력값 검증: 처리구분/그룹코드/평가기준일/평가일/등록코드 체크 |
| S3000-PROCESS-RTN | 334-352 | 신규평가(01): 기존재 확인→없으면 THKIPB110 INSERT |
| S3100-QIPA301-CALL-RTN | 357-411 | SQLIO QIPA301: 기존재 여부 조회 |
| S3200-THKIPB110-INS-RTN | 416-446 | THKIPB110 INSERT 총괄 |
| S3210-THKIPB110-PK-RTN | 452-475 | TKIPB110 PK 세팅 |
| S3220-THKIPB110-REC-RTN | 480-605 | TRIPB110 레코드 세팅 (직원명조회, 주채무계열조회 포함) |
| S3221-QIPA307-CALL-RTN | 610-651 | SQLIO QIPA307: 신규평가 기업집단 주채무계열여부 조회 |
| S4000-PROCESS-RTN | 702-717 | 확정취소(02)/삭제(03) 처리 분기 |
| S4200-PSHIST-DEL-RTN | 722-776 | 삭제(03): 11개 테이블 순차 DELETE |
| S4210-THKIPB110-DEL-RTN | 781-819 | THKIPB110 SELECT(LOCK)→DELETE |
| S4220-THKIPB111-DEL-RTN | 824-930 | THKIPB111 OPEN→FETCH LOOP→SELECT(LOCK)→DELETE |
| S4230-THKIPB116-DEL-RTN | 935-1047 | THKIPB116 OPEN→FETCH LOOP→SELECT(LOCK)→DELETE |
| S4240-THKIPB113-DEL-RTN | 1052-1100 | SQLIO QIPA303 조회→건수만큼 S4241 PERFORM |
| S4241-THKIPB113-DEL-RTN | 1105-1166 | THKIPB113 SELECT(LOCK)→DELETE |
| S4250-THKIPB112-DEL-RTN | 1171-1219 | SQLIO QIPA304 조회→건수만큼 S4251 PERFORM |
| S4251-THKIPB112-DEL-RTN | 1224-1285 | THKIPB112 SELECT(LOCK)→DELETE |
| S4260-THKIPB114-DEL-RTN | 1290-1402 | THKIPB114 OPEN→FETCH LOOP→SELECT(LOCK)→DELETE |
| S4290-THKIPB118-DEL-RTN | 1407-1459 | THKIPB118 SELECT(LOCK)→DELETE |
| S42A0-THKIPB130-DEL-RTN | 1464-1511 | SQLIO QIPA305 조회→건수만큼 S42A1 PERFORM |
| S42A1-THKIPB130-DEL-RTN | 1516-1574 | THKIPB130 SELECT(LOCK)→DELETE |
| S42B0-THKIPB131-DEL-RTN | 1579-1631 | THKIPB131 SELECT(LOCK)→DELETE |
| S42C0-THKIPB132-DEL-RTN | 1636-1746 | THKIPB132 OPEN→FETCH LOOP→SELECT(LOCK)→DELETE |
| S42D0-THKIPB133-DEL-RTN | 1751-1799 | SQLIO QIPA306 조회→건수만큼 S42D1 PERFORM |
| S42D1-THKIPB133-DEL-RTN | 1804-1861 | THKIPB133 SELECT(LOCK)→DELETE |
| S42E0-THKIPB119-DEL-RTN | 1866-1913 | SQLIO QIPA308 조회→건수만큼 S42E1 PERFORM |
| S42E1-THKIPB119-DEL-RTN | 1918-1975 | THKIPB119 SELECT(LOCK)→DELETE |
| S5000-QIPA302-CALL-RTN | 656-697 | SQLIO QIPA302: 직원기본 조회 (직원한글명, 소속부점코드) |
| S9000-FINAL-RTN | 1980-1985 | 정상종료: #OKEXIT XDIPA301-R-STAT |

### 2.3 호출 흐름도 (Call Flow)

```
[프레임워크]
    |
    | USING YCCOMMON-CA, YNIPBA30-CA
    v
AIPBA30 (AS)
  S0000-MAIN-RTN
    |
    |-- PERFORM S1000-INITIALIZE-RTN
    |     |-- INITIALIZE WK-AREA, XIJICOMM-IN, XZUGOTMY-IN
    |     |-- #GETOUT YPIPBA30-CA
    |     |-- MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD  [하드코딩]
    |     |-- #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA  --> [공통IC]
    |     |     |-- 결과 확인 (COND-XIJICOMM-OK)
    |     |     \-- 오류시: #ERROR (XIJICOMM-R-ERRCD, XIJICOMM-R-TREAT-CD, XIJICOMM-R-STAT)
    |
    |-- PERFORM S2000-VALIDATION-RTN
    |     |-- YNIPBA30-PRCSS-DSTCD = SPACE? -> #ERROR B3800004/UKIF0072
    |     |-- YNIPBA30-CORP-CLCT-GROUP-CD = SPACE? -> #ERROR B3800004/UKIF0072
    |     |-- YNIPBA30-VALUA-YMD = SPACE? -> #ERROR B3800004/UKIF0072
    |     \-- YNIPBA30-CORP-CLCT-REGI-CD = SPACE? -> #ERROR B3800004/UKIF0072
    |
    |-- PERFORM S3000-PROCESS-RTN
    |     |-- INITIALIZE XDIPA301-IN
    |     |-- MOVE YNIPBA30-CA TO XDIPA301-IN  [전체 입력복사]
    |     |-- #DYCALL DIPA301 YCCOMMON-CA XDIPA301-CA  --> [DIPA301 DC]
    |     |     |-- 오류시: #ERROR (XDIPA301-R-ERRCD, XDIPA301-R-TREAT-CD, XDIPA301-R-STAT)
    |     |     |  (단, COND-XDIPA301-NOTFOUND는 정상처리)
    |     |-- MOVE XDIPA301-OUT TO YPIPBA30-CA  [출력복사]
    |     |-- MOVE 'V1' TO WK-FMID(1:2)
    |     |-- MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
    |     \-- #BOFMID WK-FMID
    |
    \-- PERFORM S9000-FINAL-RTN
          \-- #OKEXIT CO-STAT-OK

DIPA301 (DC) [USING YCCOMMON-CA XDIPA301-CA]
  S0000-MAIN-RTN
    |-- PERFORM S1000-INITIALIZE-RTN
    |-- PERFORM S2000-VALIDATION-RTN
    |-- EVALUATE XDIPA301-I-PRCSS-DSTCD
    |     WHEN '01' --> PERFORM S3000-PROCESS-RTN (신규평가)
    |     |              |-- S3100: SQLIO QIPA301 (기존재조회)
    |     |              |-- WK-DATA-YN='N'이면 S3200 (THKIPB110 INSERT)
    |     |                    |-- S3210: PK 세팅
    |     |                    |-- S3220: RECORD 세팅
    |     |                    |     |-- S3221: SQLIO QIPA307 (주채무계열여부)
    |     |                    |     \-- S5000: SQLIO QIPA302 (직원기본조회)
    |     |                    \-- #DYDBIO INSERT-CMD-Y TKIPB110-PK TRIPB110-REC
    |     WHEN '02' --> PERFORM S4000-PROCESS-RTN (확정취소 - 실질 처리 없음)
    |     WHEN '03' --> PERFORM S4000-PROCESS-RTN
    |                    \-- S4200: 11개 테이블 순차 DELETE
    |                          |-- S4210: THKIPB110 DELETE
    |                          |-- S4220: THKIPB111 DELETE (OPEN-FETCH-DELETE LOOP)
    |                          |-- S4230: THKIPB116 DELETE (OPEN-FETCH-DELETE LOOP)
    |                          |-- S4240: SQLIO QIPA303 -> S4241: THKIPB113 DELETE
    |                          |-- S4250: SQLIO QIPA304 -> S4251: THKIPB112 DELETE
    |                          |-- S4260: THKIPB114 DELETE (OPEN-FETCH-DELETE LOOP)
    |                          |-- S4290: THKIPB118 DELETE
    |                          |-- S42A0: SQLIO QIPA305 -> S42A1: THKIPB130 DELETE
    |                          |-- S42B0: THKIPB131 DELETE
    |                          |-- S42C0: THKIPB132 DELETE (OPEN-FETCH-DELETE LOOP)
    |                          |-- S42D0: SQLIO QIPA306 -> S42D1: THKIPB133 DELETE
    |                          \-- S42E0: SQLIO QIPA308 -> S42E1: THKIPB119 DELETE
    \-- PERFORM S9000-FINAL-RTN -> #OKEXIT XDIPA301-R-STAT
```

### 2.4 COPY 멤버 목록

#### AIPBA30.cbl 참조 Copybook

| Copybook명 | 선언위치 | 파일 존재여부 | 역할 |
|------------|---------|------------|------|
| XZUGOTMY | WORKING-STORAGE (01 XZUGOTMY-CA) | **미해결** | 출력영역 확보용 (#GETOUT 대상) |
| XIJICOMM | WORKING-STORAGE (01 XIJICOMM-CA) | **미해결** | IJICOMM(공통IC) 인터페이스 |
| XDIPA301 | WORKING-STORAGE (01 XDIPA301-CA) | 존재 (XDIPA301.cpy) | DC DIPA301 인터페이스 |
| YCDBSQLA | WORKING-STORAGE (독립) | **미해결** | SQLIO 공통 처리부품 |
| YCCOMMON | LINKAGE (01 YCCOMMON-CA) | **미해결** | 프레임워크 공통영역 |
| YNIPBA30 | LINKAGE (01 YNIPBA30-CA) | 존재 (YNIPBA30.cpy) | AS 입력 카피북 |
| YPIPBA30 | LINKAGE (01 YPIPBA30-CA) | 존재 (YPIPBA30.cpy) | AS 출력 카피북 |

#### DIPA301.cbl 참조 Copybook

| Copybook명 | 선언위치 | 파일 존재여부 | 역할 |
|------------|---------|------------|------|
| TRIPB110 | WORKING-STORAGE (01 TRIPB110-REC) | **미해결** | THKIPB110 테이블 레코드 |
| TKIPB110 | WORKING-STORAGE (01 TKIPB110-KEY) | **미해결** | THKIPB110 테이블 키 |
| TRIPB111 | WORKING-STORAGE (01 TRIPB111-REC) | **미해결** | THKIPB111 테이블 레코드 |
| TKIPB111 | WORKING-STORAGE (01 TKIPB111-KEY) | **미해결** | THKIPB111 테이블 키 |
| TRIPB116 | WORKING-STORAGE (01 TRIPB116-REC) | **미해결** | THKIPB116 테이블 레코드 |
| TKIPB116 | WORKING-STORAGE (01 TKIPB116-KEY) | **미해결** | THKIPB116 테이블 키 |
| TRIPB113 | WORKING-STORAGE (01 TRIPB113-REC) | **미해결** | THKIPB113 테이블 레코드 |
| TKIPB113 | WORKING-STORAGE (01 TKIPB113-KEY) | **미해결** | THKIPB113 테이블 키 |
| TRIPB112 | WORKING-STORAGE (01 TRIPB112-REC) | **미해결** | THKIPB112 테이블 레코드 |
| TKIPB112 | WORKING-STORAGE (01 TKIPB112-KEY) | **미해결** | THKIPB112 테이블 키 |
| TRIPB114 | WORKING-STORAGE (01 TRIPB114-REC) | **미해결** | THKIPB114 테이블 레코드 |
| TKIPB114 | WORKING-STORAGE (01 TKIPB114-KEY) | **미해결** | THKIPB114 테이블 키 |
| TRIPB118 | WORKING-STORAGE (01 TRIPB118-REC) | **미해결** | THKIPB118 테이블 레코드 |
| TKIPB118 | WORKING-STORAGE (01 TKIPB118-KEY) | **미해결** | THKIPB118 테이블 키 |
| TRIPB130 | WORKING-STORAGE (01 TRIPB130-REC) | **미해결** | THKIPB130 테이블 레코드 |
| TKIPB130 | WORKING-STORAGE (01 TKIPB130-KEY) | **미해결** | THKIPB130 테이블 키 |
| TRIPB131 | WORKING-STORAGE (01 TRIPB131-REC) | **미해결** | THKIPB131 테이블 레코드 |
| TKIPB131 | WORKING-STORAGE (01 TKIPB131-KEY) | **미해결** | THKIPB131 테이블 키 |
| TRIPB132 | WORKING-STORAGE (01 TRIPB132-REC) | **미해결** | THKIPB132 테이블 레코드 |
| TKIPB132 | WORKING-STORAGE (01 TKIPB132-KEY) | **미해결** | THKIPB132 테이블 키 |
| TRIPB133 | WORKING-STORAGE (01 TRIPB133-REC) | **미해결** | THKIPB133 테이블 레코드 |
| TKIPB133 | WORKING-STORAGE (01 TKIPB133-KEY) | **미해결** | THKIPB133 테이블 키 |
| TRIPB119 | WORKING-STORAGE (01 TRIPB119-REC) | **미해결** | THKIPB119 테이블 레코드 |
| TKIPB119 | WORKING-STORAGE (01 TKIPB119-KEY) | **미해결** | THKIPB119 테이블 키 |
| YCDBIOCA | WORKING-STORAGE (독립) | **미해결** | DBIO 공통 처리부품 |
| YCDBSQLA | WORKING-STORAGE (독립) | **미해결** | SQLIO 공통 처리부품 |
| XQIPA301 | WORKING-STORAGE (01 XQIPA301-CA) | **미해결** | SQLIO QIPA301 인터페이스 |
| XQIPA302 | WORKING-STORAGE (01 XQIPA302-CA) | **미해결** | SQLIO QIPA302 인터페이스 |
| XQIPA303 | WORKING-STORAGE (01 XQIPA303-CA) | **미해결** | SQLIO QIPA303 인터페이스 |
| XQIPA304 | WORKING-STORAGE (01 XQIPA304-CA) | **미해결** | SQLIO QIPA304 인터페이스 |
| XQIPA305 | WORKING-STORAGE (01 XQIPA305-CA) | **미해결** | SQLIO QIPA305 인터페이스 |
| XQIPA306 | WORKING-STORAGE (01 XQIPA306-CA) | **미해결** | SQLIO QIPA306 인터페이스 |
| XQIPA307 | WORKING-STORAGE (01 XQIPA307-CA) | **미해결** | SQLIO QIPA307 인터페이스 |
| XQIPA308 | WORKING-STORAGE (01 XQIPA308-CA) | **미해결** | SQLIO QIPA308 인터페이스 |
| YCCOMMON | LINKAGE (01 YCCOMMON-CA) | **미해결** | 프레임워크 공통영역 |
| XDIPA301 | LINKAGE (01 XDIPA301-CA) | 존재 (XDIPA301.cpy) | DC 인터페이스 |

---

## 3. DB 연동 구문 분석

### 3.1 SQL 구문 목록

직접 EXEC SQL 없음. 모든 DB 접근은 z-KESA DBIO/SQLIO 매크로로 추상화됨.

#### DIPA301.cbl - DBIO 구문 (#DYDBIO)

| # | Paragraph | 매크로 | 커맨드 | 테이블 | 조작 |
|---|-----------|--------|--------|--------|------|
| 1 | S3200-THKIPB110-INS-RTN (행 429) | #DYDBIO | INSERT-CMD-Y | THKIPB110 (기업집단평가기본) | INSERT (잠금) |
| 2 | S4210-THKIPB110-DEL-RTN (행 790) | #DYDBIO | SELECT-CMD-Y | THKIPB110 | SELECT (잠금) |
| 3 | S4210-THKIPB110-DEL-RTN (행 804) | #DYDBIO | DELETE-CMD-Y | THKIPB110 | DELETE (잠금) |
| 4 | S4220-THKIPB111-DEL-RTN (행 850) | #DYDBIO | OPEN-CMD-1 | THKIPB111 (기업집단연혁명세) | CURSOR OPEN |
| 5 | S4220-THKIPB111-DEL-RTN (행 864) | #DYDBIO | FETCH-CMD-1 | THKIPB111 | CURSOR FETCH |
| 6 | S4220-THKIPB111-DEL-RTN (행 894) | #DYDBIO | SELECT-CMD-Y | THKIPB111 | SELECT (잠금) |
| 7 | S4220-THKIPB111-DEL-RTN (행 903) | #DYDBIO | DELETE-CMD-Y | THKIPB111 | DELETE (잠금) |
| 8 | S4220-THKIPB111-DEL-RTN (행 918) | #DYDBIO | CLOSE-CMD-1 | THKIPB111 | CURSOR CLOSE |
| 9 | S4230-THKIPB116-DEL-RTN (행 961) | #DYDBIO | OPEN-CMD-1 | THKIPB116 (기업집단계열사명세) | CURSOR OPEN |
| 10 | S4230-THKIPB116-DEL-RTN (행 977) | #DYDBIO | FETCH-CMD-1 | THKIPB116 | CURSOR FETCH |
| 11 | S4230-THKIPB116-DEL-RTN (행 1011) | #DYDBIO | SELECT-CMD-Y | THKIPB116 | SELECT (잠금) |
| 12 | S4230-THKIPB116-DEL-RTN (행 1020) | #DYDBIO | DELETE-CMD-Y | THKIPB116 | DELETE (잠금) |
| 13 | S4230-THKIPB116-DEL-RTN (행 1035) | #DYDBIO | CLOSE-CMD-1 | THKIPB116 | CURSOR CLOSE |
| 14 | S4241-THKIPB113-DEL-RTN (행 1136) | #DYDBIO | SELECT-CMD-Y | THKIPB113 (기업집단사업부분구조분석명세) | SELECT (잠금) |
| 15 | S4241-THKIPB113-DEL-RTN (행 1150) | #DYDBIO | DELETE-CMD-Y | THKIPB113 | DELETE (잠금) |
| 16 | S4251-THKIPB112-DEL-RTN (행 1255) | #DYDBIO | SELECT-CMD-Y | THKIPB112 (기업집단재무분석목록) | SELECT (잠금) |
| 17 | S4251-THKIPB112-DEL-RTN (행 1269) | #DYDBIO | DELETE-CMD-Y | THKIPB112 | DELETE (잠금) |
| 18 | S4260-THKIPB114-DEL-RTN (행 1316) | #DYDBIO | OPEN-CMD-1 | THKIPB114 (기업집단항목별평가목록) | CURSOR OPEN |
| 19 | S4260-THKIPB114-DEL-RTN (행 1330) | #DYDBIO | FETCH-CMD-1 | THKIPB114 | CURSOR FETCH |
| 20 | S4260-THKIPB114-DEL-RTN (행 1364) | #DYDBIO | SELECT-CMD-Y | THKIPB114 | SELECT (잠금) |
| 21 | S4260-THKIPB114-DEL-RTN (행 1375) | #DYDBIO | DELETE-CMD-Y | THKIPB114 | DELETE (잠금) |
| 22 | S4260-THKIPB114-DEL-RTN (행 1392) | #DYDBIO | CLOSE-CMD-1 | THKIPB114 | CURSOR CLOSE |
| 23 | S4290-THKIPB118-DEL-RTN (행 1429) | #DYDBIO | SELECT-CMD-Y | THKIPB118 (기업집단평가등급조정사유목록) | SELECT (잠금) |
| 24 | S4290-THKIPB118-DEL-RTN (행 1443) | #DYDBIO | DELETE-CMD-Y | THKIPB118 | DELETE (잠금) |
| 25 | S42A1-THKIPB130-DEL-RTN (행 1544) | #DYDBIO | SELECT-CMD-Y | THKIPB130 (기업집단주석명세) | SELECT (잠금) |
| 26 | S42A1-THKIPB130-DEL-RTN (행 1558) | #DYDBIO | DELETE-CMD-Y | THKIPB130 | DELETE (잠금) |
| 27 | S42B0-THKIPB131-DEL-RTN (행 1601) | #DYDBIO | SELECT-CMD-Y | THKIPB131 (기업집단승인결의록명세) | SELECT (잠금) |
| 28 | S42B0-THKIPB131-DEL-RTN (행 1615) | #DYDBIO | DELETE-CMD-Y | THKIPB131 | DELETE (잠금) |
| 29 | S42C0-THKIPB132-DEL-RTN (행 1662) | #DYDBIO | OPEN-CMD-1 | THKIPB132 (기업집단승인결의록위원명세) | CURSOR OPEN |
| 30 | S42C0-THKIPB132-DEL-RTN (행 1676) | #DYDBIO | FETCH-CMD-1 | THKIPB132 | CURSOR FETCH |
| 31 | S42C0-THKIPB132-DEL-RTN (행 1706) | #DYDBIO | SELECT-CMD-Y | THKIPB132 | SELECT (잠금) |
| 32 | S42C0-THKIPB132-DEL-RTN (행 1717) | #DYDBIO | DELETE-CMD-Y | THKIPB132 | DELETE (잠금) |
| 33 | S42C0-THKIPB132-DEL-RTN (행 1734) | #DYDBIO | CLOSE-CMD-1 | THKIPB132 | CURSOR CLOSE |
| 34 | S42D1-THKIPB133-DEL-RTN (행 1832) | #DYDBIO | SELECT-CMD-Y | THKIPB133 (기업집단승인결의록의견명세) | SELECT (잠금) |
| 35 | S42D1-THKIPB133-DEL-RTN (행 1846) | #DYDBIO | DELETE-CMD-Y | THKIPB133 | DELETE (잠금) |
| 36 | S42E1-THKIPB119-DEL-RTN (행 1946) | #DYDBIO | SELECT-CMD-Y | THKIPB119 (기업집단재무평점단계별목록) | SELECT (잠금) |
| 37 | S42E1-THKIPB119-DEL-RTN (행 1960) | #DYDBIO | DELETE-CMD-Y | THKIPB119 | DELETE (잠금) |

#### DIPA301.cbl - SQLIO 구문 (#DYSQLA)

| # | Paragraph | SQLIO ID | 조작 | 대상 테이블 | 역할 |
|---|-----------|----------|------|------------|------|
| 1 | S3100-QIPA301-CALL-RTN (행 383) | QIPA301 | SELECT | THKIPB110 | 기존재 여부 확인 (처리단계구분 '6':확정) |
| 2 | S3221-QIPA307-CALL-RTN (행 633) | QIPA307 | SELECT | 미상 | 신규평가 기업집단 주채무계열여부 조회 |
| 3 | S5000-QIPA302-CALL-RTN (행 674) | QIPA302 | SELECT | 직원테이블(미상) | 직원기본 조회 (한글명, 소속부점코드) |
| 4 | S4240-THKIPB113-DEL-RTN (행 1073) | QIPA303 | SELECT | THKIPB113 | 삭제 대상 PKs 조회 |
| 5 | S4250-THKIPB112-DEL-RTN (행 1192) | QIPA304 | SELECT | THKIPB112 | 삭제 대상 PKs 조회 |
| 6 | S42A0-THKIPB130-DEL-RTN (행 1485) | QIPA305 | SELECT | THKIPB130 | 삭제 대상 PKs 조회 |
| 7 | S42D0-THKIPB133-DEL-RTN (행 1772) | QIPA306 | SELECT | THKIPB133 | 삭제 대상 PKs 조회 |
| 8 | S42E0-THKIPB119-DEL-RTN (행 1887) | QIPA308 | SELECT | THKIPB119 | 삭제 대상 PKs 조회 |

### 3.2 파일 I/O 구문 목록

VSAM/Sequential 파일 I/O 없음. 전체 DB 접근은 DBIO/SQLIO 매크로 사용.

### 3.3 테이블/파일 접근 패턴

| 테이블 | 한글명 | SELECT | INSERT | UPDATE | DELETE | 접근 프로그램 |
|--------|--------|--------|--------|--------|--------|--------------|
| THKIPB110 | 기업집단평가기본 | DBIO(LOCK)+SQLIO | DBIO(LOCK) | - | DBIO(LOCK) | DIPA301 |
| THKIPB111 | 기업집단연혁명세 | DBIO(CURSOR+LOCK) | - | - | DBIO(LOCK) | DIPA301 |
| THKIPB112 | 기업집단재무분석목록 | SQLIO+DBIO(LOCK) | - | - | DBIO(LOCK) | DIPA301 |
| THKIPB113 | 기업집단사업부분구조분석명세 | SQLIO+DBIO(LOCK) | - | - | DBIO(LOCK) | DIPA301 |
| THKIPB114 | 기업집단항목별평가목록 | DBIO(CURSOR+LOCK) | - | - | DBIO(LOCK) | DIPA301 |
| THKIPB116 | 기업집단계열사명세 | DBIO(CURSOR+LOCK) | - | - | DBIO(LOCK) | DIPA301 |
| THKIPB118 | 기업집단평가등급조정사유목록 | DBIO(LOCK) | - | - | DBIO(LOCK) | DIPA301 |
| THKIPB119 | 기업집단재무평점단계별목록 | SQLIO+DBIO(LOCK) | - | - | DBIO(LOCK) | DIPA301 |
| THKIPB130 | 기업집단주석명세 | SQLIO+DBIO(LOCK) | - | - | DBIO(LOCK) | DIPA301 |
| THKIPB131 | 기업집단승인결의록명세 | DBIO(LOCK) | - | - | DBIO(LOCK) | DIPA301 |
| THKIPB132 | 기업집단승인결의록위원명세 | DBIO(CURSOR+LOCK) | - | - | DBIO(LOCK) | DIPA301 |
| THKIPB133 | 기업집단승인결의록의견명세 | SQLIO+DBIO(LOCK) | - | - | DBIO(LOCK) | DIPA301 |
| 직원테이블 (SQLIO QIPA302) | 직원기본 | SQLIO | - | - | - | DIPA301 |
| 주채무계열 테이블 (SQLIO QIPA307) | 주채무계열여부 | SQLIO | - | - | - | DIPA301 |

**패턴 특이사항**:
- 처리구분 '02'(확정취소)는 EVALUATE에 WHEN '02' WHEN '03' 으로 묶여 있으나 S4000 내부에서 '03'만 처리 — '02'는 실질적으로 아무 처리 없이 종료됨 (잠재적 버그 또는 미구현)
- 삭제 패턴: SQLIO로 PK 목록 조회 후 DBIO SELECT(LOCK) + DELETE로 개별 삭제 (낙관적 잠금 방식)

---

## 4. 비즈니스 로직 분석

### 4.1 조건부 로직

#### AIPBA30.cbl

| 위치 (행) | 구조 | 조건 | 처리 |
|----------|------|------|------|
| 163-169 | IF/ELSE | COND-XIJICOMM-OK | IJICOMM 호출 결과: 실패시 #ERROR |
| 187-189 | IF | YNIPBA30-PRCSS-DSTCD = SPACE | 처리구분 미입력: #ERROR B3800004/UKIF0072 |
| 192-194 | IF | YNIPBA30-CORP-CLCT-GROUP-CD = SPACE | 기업집단그룹코드 미입력: #ERROR |
| 197-199 | IF | YNIPBA30-VALUA-YMD = SPACE | 평가년월일 미입력: #ERROR |
| 202-204 | IF | YNIPBA30-CORP-CLCT-REGI-CD = SPACE | 기업집단등록코드 미입력: #ERROR |
| 226-231 | IF | NOT COND-XDIPA301-OK AND NOT COND-XDIPA301-NOTFOUND | DIPA301 호출 오류전파: #ERROR |

#### DIPA301.cbl

| 위치 (행) | 구조 | 조건 | 처리 |
|----------|------|------|------|
| 240-248 | EVALUATE | XDIPA301-I-PRCSS-DSTCD | '01':신규평가, '02'/'03':확정취소/삭제 |
| 289-293 | IF | XDIPA301-I-PRCSS-DSTCD = SPACE | 처리구분 미입력 오류 |
| 296-300 | IF | XDIPA301-I-CORP-CLCT-GROUP-CD = SPACE | 그룹코드 미입력 오류 |
| 303-311 | IF/IF | PRCSS-DSTCD = '01' AND VALUA-BASE-YMD = SPACE | 신규평가인 경우 평가기준일 필수 |
| 314-318 | IF | XDIPA301-I-VALUA-YMD = SPACE | 평가년월일 미입력 오류 |
| 321-325 | IF | XDIPA301-I-CORP-CLCT-REGI-CD = SPACE | 등록코드 미입력 오류 |
| 343-347 | IF | WK-DATA-YN = 'N' | 기존재 없는 경우만 INSERT |
| 386-404 | EVALUATE | COND-DBSQL-OK/MRNF/OTHER | SQLIO 결과 3분기 처리 |
| 708-713 | EVALUATE | XDIPA301-I-PRCSS-DSTCD | '03'만 삭제 실행 (S4200) |
| 793-798 | IF | NOT COND-DBIO-OK AND NOT COND-DBIO-MRNF | DBIO 오류 처리 |
| 801-815 | IF | COND-DBIO-OK | 조회 결과 있는 경우만 DELETE |

### 4.2 산술 연산

산술 COMPUTE 구문 없음.
WK-I는 `PERFORM VARYING WK-I FROM 1 BY 1 UNTIL COND-DBIO-MRNF` 패턴에서 반복 카운터로 사용됨. (DIPA301, 행 861, 972, 1086, 1205, 1326, 1498, 1673, 1785, 1900)

### 4.3 유효성 검사 규칙

#### AIPBA30.cbl (입력검증 계층)

| 검증항목 | 규칙 | 에러코드 | 조치코드 |
|---------|------|---------|---------|
| YNIPBA30-PRCSS-DSTCD | SPACE 불허 (필수) | B3800004 | UKIF0072 |
| YNIPBA30-CORP-CLCT-GROUP-CD | SPACE 불허 (필수) | B3800004 | UKIF0072 |
| YNIPBA30-VALUA-YMD | SPACE 불허 (필수) | B3800004 | UKIF0072 |
| YNIPBA30-CORP-CLCT-REGI-CD | SPACE 불허 (필수) | B3800004 | UKIF0072 |

#### DIPA301.cbl (DC 계층 재검증)

| 검증항목 | 규칙 | 에러코드 | 조치코드 |
|---------|------|---------|---------|
| XDIPA301-I-PRCSS-DSTCD | SPACE 불허 | B3800004 | UKIP0007 |
| XDIPA301-I-CORP-CLCT-GROUP-CD | SPACE 불허 | B3800004 | UKIP0001 |
| XDIPA301-I-VALUA-BASE-YMD | PRCSS-DSTCD='01'일 때 SPACE 불허 | B3800004 | UKIP0008 |
| XDIPA301-I-VALUA-YMD | SPACE 불허 | B3800004 | UKIP0003 |
| XDIPA301-I-CORP-CLCT-REGI-CD | SPACE 불허 | B3800004 | UKIP0002 |

#### 비즈니스 규칙

- 신규평가(처리구분 '01') 시: THKIPB110에 동일 기업집단/등록코드/평가일의 확정(처리단계='6') 데이터가 이미 존재하면 중복 오류 (CO-B4200023/UKII0182)
- 주채무계열여부(WK-MAIN-DEBT-AFFLT-YN)는 SQLIO QIPA307로 조회하여 THKIPB110 레코드에 반영
- 직원명 및 소속부점코드는 SQLIO QIPA302로 조회하여 평가직원정보로 저장

### 4.4 오류 처리

#### 오류 처리 패턴

모든 오류는 `#ERROR 에러코드 조치코드 상태코드` 매크로로 처리됨. 직접 ROLLBACK/COMMIT 없음 (프레임워크 위임).

| 프로그램 | 오류 유형 | 에러코드 | 조치코드 | 상태코드 | 비고 |
|---------|---------|---------|---------|---------|------|
| AIPBA30 | IJICOMM 호출 실패 | XIJICOMM-R-ERRCD (동적) | XIJICOMM-R-TREAT-CD (동적) | XIJICOMM-R-STAT (동적) | IC 에러 재발행 |
| AIPBA30 | 필수항목 누락 | B3800004 | UKIF0072 | CO-STAT-ERROR('09') | 4개 항목 동일 코드 |
| AIPBA30 | DIPA301 호출 오류 | XDIPA301-R-ERRCD (동적) | XDIPA301-R-TREAT-CD (동적) | XDIPA301-R-STAT (동적) | DC 에러 재발행 |
| DIPA301 | 필수항목 누락 | B3800004 | UKIP0001~UKIP0008 (항목별) | CO-STAT-ERROR('09') | 항목별 조치코드 구분 |
| DIPA301 | DB 중복 (신규평가 기존재) | B4200023 | UKII0182 | CO-STAT-ERROR('09') | SQLIO 결과 OK |
| DIPA301 | DB 조회/삭제 오류 | B3900009 | UKII0182 | CO-STAT-ERROR('09') | DBIO/SQLIO 오류 |
| DIPA301 | 데이터 삭제 오류 | B4200219 | UKII0182 | CO-STAT-ERROR('09') | DELETE 실패 |

#### NOTFOUND 처리

- AIPBA30: `NOT COND-XDIPA301-NOTFOUND` 조건 → NOTFOUND('02')는 정상처리로 간주
- DIPA301 S3100: `COND-DBSQL-MRNF` → WK-DATA-YN='N' 세팅 (INSERT 진행)
- DIPA301 삭제 절차: DBIO SELECT 결과 NOTFOUND인 경우 DELETE 스킵 (정상)

### 4.5 비즈니스 상수

| 상수명 | 값 | 소스 | 의미 |
|--------|-----|------|------|
| CO-PGM-ID | 'AIPBA30' | AIPBA30 행 37 | 프로그램ID |
| CO-STAT-OK | '00' | AIPBA30 행 38 | 정상 상태코드 |
| CO-STAT-ERROR | '09' | AIPBA30 행 39 | 오류 상태코드 |
| CO-STAT-ABNORMAL | '98' | AIPBA30 행 40 | 비정상 상태코드 |
| CO-STAT-SYSERROR | '99' | AIPBA30 행 41 | 시스템오류 상태코드 |
| CO-B3800004 | 'B3800004' | AIPBA30 행 49 | 에러메시지: 필수항목 오류 |
| CO-B3900002 | 'B3900002' | AIPBA30 행 51 | 에러메시지: DB에러(SQLIO) |
| CO-UKIF0072 | 'UKIF0072' | AIPBA30 행 55 | 조치메시지: 필수입력항목 확인 |
| CO-UKII0182 | 'UKII0182' | AIPBA30 행 57 | 조치메시지: DB오류 |
| '060' | - | AIPBA30 행 143,157 | 비계약업무구분코드 (신용평가 도메인 상수) |
| 'V1' | - | AIPBA30 행 239 | 출력 폼 ID 접두어 |
| '6' | - | DIPA301 행 377 | 기업집단처리단계구분 (확정) |
| CO-MAX-100 | 100 | DIPA301 행 71 | 최대 건수 (현재 미사용) |
| CO-B3900009 | 'B3900009' | DIPA301 행 47 | 에러메시지: DB 오류 |
| CO-B4200023 | 'B4200023' | DIPA301 행 48 | 에러메시지: 이미 등록된 정보 |
| CO-B4200219 | 'B4200219' | DIPA301 행 49 | 에러메시지: 삭제 불가 |

---

## 5. 데이터 타입 매핑

### 5.1 Working Storage 항목

#### AIPBA30.cbl

| COBOL 항목명 | PIC 절 | COBOL 타입 | 매핑 Java 타입 | 비고 |
|-------------|--------|-----------|--------------|------|
| CO-PGM-ID | PIC X(008) | Alphanumeric | String (8) | 프로그램ID 상수 |
| CO-STAT-OK | PIC X(002) | Alphanumeric | static final String | 값: '00' |
| CO-STAT-ERROR | PIC X(002) | Alphanumeric | static final String | 값: '09' |
| CO-STAT-ABNORMAL | PIC X(002) | Alphanumeric | static final String | 값: '98' |
| CO-STAT-SYSERROR | PIC X(002) | Alphanumeric | static final String | 값: '99' |
| CO-B3800004 | PIC X(008) | Alphanumeric | static final String | 에러코드 상수 |
| CO-B3900002 | PIC X(008) | Alphanumeric | static final String | 에러코드 상수 |
| CO-UKIF0072 | PIC X(008) | Alphanumeric | static final String | 조치코드 상수 |
| CO-UKII0182 | PIC X(008) | Alphanumeric | static final String | 조치코드 상수 |
| WK-FMID | PIC X(013) | Alphanumeric | String (13) | 출력 폼ID 조립용 작업영역 |

#### DIPA301.cbl

| COBOL 항목명 | PIC 절 | COBOL 타입 | 매핑 Java 타입 | 비고 |
|-------------|--------|-----------|--------------|------|
| CO-PGM-ID | PIC X(008) | Alphanumeric | static final String | 'DIPA301' |
| CO-STAT-OK | PIC X(002) | Alphanumeric | static final String | '00' |
| CO-STAT-NOTFND | PIC X(002) | Alphanumeric | static final String | '02' |
| CO-STAT-ERROR | PIC X(002) | Alphanumeric | static final String | '09' |
| CO-STAT-ABNORMAL | PIC X(002) | Alphanumeric | static final String | '98' |
| CO-STAT-SYSERROR | PIC X(002) | Alphanumeric | static final String | '99' |
| CO-MAX-100 | PIC 9(003) | Numeric (Unsigned) | int | VALUE 100 (현재 미사용) |
| WK-DATA-YN | PIC X(001) | Alphanumeric | String (1) / boolean | 'Y'/'N' 플래그 |
| WK-EMP-HANGL-FNAME | PIC X(042) | Alphanumeric | String (42) | 직원한글명 |
| WK-BELNG-BRNCD | PIC X(004) | Alphanumeric | String (4) | 소속부점코드 |
| WK-I | PIC 9(004) COMP | Binary (2 bytes) | int | 루프 카운터 |
| WK-MAIN-DEBT-AFFLT-YN | PIC X(001) | Alphanumeric | String (1) / boolean | 주채무계열여부 |
| CO-B3800004 | PIC X(008) | Alphanumeric | static final String | |
| CO-B3900009 | PIC X(008) | Alphanumeric | static final String | |
| CO-B4200023 | PIC X(008) | Alphanumeric | static final String | |
| CO-B4200219 | PIC X(008) | Alphanumeric | static final String | |
| CO-UKIF0072 | PIC X(008) | Alphanumeric | static final String | |
| CO-UKII0182 | PIC X(008) | Alphanumeric | static final String | |
| CO-UKIP0001~UKIP0008 | PIC X(008) 각각 | Alphanumeric | static final String | 항목별 조치코드 |

### 5.2 File Section 항목

File Section 없음 (온라인 프로그램, VSAM 미사용).

### 5.3 Linkage Section 항목

#### AIPBA30.cbl

| COBOL 항목명 | Copybook | 방향 | 매핑 Java 타입 | 비고 |
|-------------|---------|------|--------------|------|
| YCCOMMON-CA | YCCOMMON | IN | IOnlineContext / CommonArea | 프레임워크 공통영역 (미해결) |
| YNIPBA30-CA | YNIPBA30 | IN | IDataSet requestData | AS 입력 파라미터 |
| YPIPBA30-CA | YPIPBA30 | OUT | IDataSet responseData | AS 출력 (96 bytes 이므로 일치) |

#### DIPA301.cbl

| COBOL 항목명 | Copybook | 방향 | 매핑 Java 타입 | 비고 |
|-------------|---------|------|--------------|------|
| YCCOMMON-CA | YCCOMMON | IN | IOnlineContext / CommonArea | 프레임워크 공통영역 (미해결) |
| XDIPA301-CA | XDIPA301 | IN/OUT | IDataSet (request+response) | DC 인터페이스 96 bytes |

### 5.4 타입 매핑 테이블

#### XDIPA301.cpy (96 bytes 총)

| COBOL 항목명 | PIC 절 | COBOL 타입 | 매핑 Java 타입 | 비고 |
|-------------|--------|-----------|--------------|------|
| XDIPA301-R-STAT | PIC X(002) | Alphanumeric | String (2) | 88레벨 조건명 5개 |
| COND-XDIPA301-OK | 88 VALUE '00' | Condition Name | - | → null check 또는 "00".equals() |
| COND-XDIPA301-KEYDUP | 88 VALUE '01' | Condition Name | - | DataException |
| COND-XDIPA301-NOTFOUND | 88 VALUE '02' | Condition Name | - | 결과 null 체크 |
| COND-XDIPA301-SPVSTOP | 88 VALUE '05' | Condition Name | - | 별도 처리 필요 |
| COND-XDIPA301-ERROR | 88 VALUE '09' | Condition Name | - | BusinessException |
| COND-XDIPA301-ABNORMAL | 88 VALUE '98' | Condition Name | - | 프레임워크 처리 |
| COND-XDIPA301-SYSERROR | 88 VALUE '99' | Condition Name | - | 프레임워크 처리 |
| XDIPA301-R-LINE | PIC 9(006) | Numeric Unsigned | int | 오류위치 |
| XDIPA301-R-ERRCD | PIC X(008) | Alphanumeric | String (8) | 에러메시지코드 |
| XDIPA301-R-TREAT-CD | PIC X(008) | Alphanumeric | String (8) | 조치메시지코드 |
| XDIPA301-R-SQL-CD | PIC S9(005) LEADING SEPARATE | Signed Numeric (signed decimal, 6 bytes) | int | SQLCODE |
| XDIPA301-I-PRCSS-DSTCD | PIC X(002) | Alphanumeric | String (2) | 처리구분: '01'/'02'/'03' |
| XDIPA301-I-CORP-CLCT-GROUP-CD | PIC X(003) | Alphanumeric | String (3) | 기업집단그룹코드 |
| XDIPA301-I-CORP-CLCT-NAME | PIC X(072) | Alphanumeric | String (72) | 기업집단명 |
| XDIPA301-I-VALUA-YMD | PIC X(008) | Alphanumeric | String (8) / LocalDate | 평가년월일 (YYYYMMDD) |
| XDIPA301-I-VALUA-BASE-YMD | PIC X(008) | Alphanumeric | String (8) / LocalDate | 평가기준년월일 (YYYYMMDD) |
| XDIPA301-I-CORP-CLCT-REGI-CD | PIC X(003) | Alphanumeric | String (3) | 기업집단등록코드 |
| XDIPA301-O-TOTAL-NOITM | PIC 9(005) | Numeric Unsigned | int | 총건수 |
| XDIPA301-O-PRSNT-NOITM | PIC 9(005) | Numeric Unsigned | int | 현재건수 |

#### YNIPBA30.cpy (AS 입력, 96 bytes)

| COBOL 항목명 | PIC 절 | COBOL 타입 | 매핑 Java 타입 | 비고 |
|-------------|--------|-----------|--------------|------|
| YNIPBA30-PRCSS-DSTCD | PIC X(002) | Alphanumeric | String (2) | 처리구분 |
| YNIPBA30-CORP-CLCT-GROUP-CD | PIC X(003) | Alphanumeric | String (3) | 기업집단그룹코드 |
| YNIPBA30-CORP-CLCT-NAME | PIC X(072) | Alphanumeric | String (72) | 기업집단명 |
| YNIPBA30-VALUA-YMD | PIC X(008) | Alphanumeric | String (8) | 평가년월일 |
| YNIPBA30-VALUA-BASE-YMD | PIC X(008) | Alphanumeric | String (8) | 평가기준년월일 |
| YNIPBA30-CORP-CLCT-REGI-CD | PIC X(003) | Alphanumeric | String (3) | 기업집단등록코드 |

**주목**: YNIPBA30-CA (96 bytes) = XDIPA301-IN 영역과 필드 구조/순서가 동일. `MOVE YNIPBA30-CA TO XDIPA301-IN` 이 유효한 이유.

#### YPIPBA30.cpy (AS 출력, 10 bytes)

| COBOL 항목명 | PIC 절 | COBOL 타입 | 매핑 Java 타입 | 비고 |
|-------------|--------|-----------|--------------|------|
| YPIPBA30-TOTAL-NOITM | PIC 9(005) | Numeric Unsigned | int | 총건수 |
| YPIPBA30-PRSNT-NOITM | PIC 9(005) | Numeric Unsigned | int | 현재건수 |

#### DIPA301.cbl WK-AREA 주요 항목

| COBOL 항목명 | PIC 절 | COBOL 타입 | 매핑 Java 타입 | 비고 |
|-------------|--------|-----------|--------------|------|
| WK-DATA-YN | PIC X(001) | Alphanumeric (1) | String / boolean | 'Y'기존재/'N'없음 |
| WK-EMP-HANGL-FNAME | PIC X(042) | Alphanumeric | String (42) | 직원한글명 |
| WK-BELNG-BRNCD | PIC X(004) | Alphanumeric | String (4) | 소속부점코드 |
| WK-I | PIC 9(004) COMP | Binary (COMP=COMP-4) | int | 2바이트 이진정수 루프카운터 |
| WK-MAIN-DEBT-AFFLT-YN | PIC X(001) | Alphanumeric | String / boolean | 주채무계열여부 |

---

## 6. 변환 위험도 분류

### 6.1 위험도 요약

| 위험도 | 건수 | 주요 항목 |
|--------|------|---------|
| 상 (HIGH) | 4 | 복잡 삭제 트랜잭션, MOVE 전체복사, 처리구분 '02' 무동작, 미해결 Copybook |
| 중 (MEDIUM) | 5 | DBIO 커서 패턴, SQLIO 다중호출, 이중 검증, 폼ID 로직, BICOM 필드 참조 |
| 하 (LOW) | 6 | 단순 IF 검증, 상수 정의, 로그 출력, 정상종료, IJICOMM 패턴, XDIPA301 인터페이스 |

### 6.2 위험도 상 항목

#### [HIGH-01] 11개 테이블 연계 삭제 트랜잭션 (DIPA301, 처리구분 '03')
- **위치**: DIPA301 S4200-PSHIST-DEL-RTN (행 722-776), 하위 11개 Paragraph
- **위험 근거**: THKIPB110~THKIPB133 11개 테이블을 순차 삭제하는 복잡 트랜잭션. 각 테이블마다 SELECT(LOCK) → DELETE 패턴을 반복하며, CURSOR 패턴(OPEN-FETCH-CLOSE)을 사용하는 테이블은 루프 중 개별 LOCK SELECT 후 DELETE. Java 변환 시 트랜잭션 일관성 보장 필요. 일부 테이블은 SQLIO로 PK 목록 조회 후 개별 DBIO 삭제 — 두 가지 삭제 방식 혼재
- **권고**: 단일 @Transactional 메서드로 감싸고, MyBatis의 foreach delete 또는 bulk delete SQL로 최적화 검토

#### [HIGH-02] MOVE YNIPBA30-CA TO XDIPA301-IN 전체 구조 복사 (AIPBA30, 행 219-220)
- **위치**: AIPBA30 S3000-PROCESS-RTN (행 219-220)
- **위험 근거**: AS 입력 카피북 전체(YNIPBA30-CA 96 bytes)를 DC 입력 영역(XDIPA301-IN)에 직접 MOVE. 두 영역이 동일한 필드 순서/크기임을 전제. YNIPBA30의 07레벨 항목이 01레벨 YNIPBA30-CA 안에 포함되어 있으므로 Java에서는 필드별 명시적 복사(setField())로 변환해야 함. 은묵적 구조 일치에 의존하는 취약한 패턴
- **권고**: Java DTO 변환 시 필드별 명시적 매핑. AS 입력 DTO와 DC 입력 DTO는 동일 구조이므로 공통 인터페이스나 복사 생성자 적용

#### [HIGH-03] 처리구분 '02'(확정취소) 무동작 (DIPA301, 행 240-248)
- **위치**: DIPA301 S0000-MAIN-RTN EVALUATE (행 240-248) 및 S4000-PROCESS-RTN (행 702-716)
- **위험 근거**: EVALUATE에서 WHEN '02' WHEN '03' → S4000 호출. S4000 내부에서는 EVALUATE WHEN '03'만 처리. 즉 처리구분 '02'(확정취소)가 입력되어도 실질적인 DB 처리가 전혀 없음. 의도적 설계인지 미구현인지 코드만으로 판단 불가 — 업무담당자 확인 필요
- **권고**: 마이그레이션 전 업무팀 확인 필수. '02'가 의도적 무동작이면 주석 명시, 미구현이면 별도 구현 범위 정의

#### [HIGH-04] 다수 미해결 Copybook (XZUGOTMY, XIJICOMM, YCCOMMON, YCDBSQLA, YCDBIOCA, 12개 테이블 TR/TK, 8개 XQIPA)
- **위치**: AIPBA30 행 70, 74; DIPA301 행 97-204
- **위험 근거**: 프레임워크 공통 카피북(YCCOMMON, YCDBSQLA, YCDBIOCA)과 모든 테이블 인터페이스 카피북(12쌍 TR+TK), SQLIO 인터페이스 카피북(8개 XQ)이 `cobol/KIP.DCOMMON.COPY/`에 없음. 테이블 컬럼 PIC 정의, DBIO 키 구조를 확인할 수 없어 Java DTO 생성 시 추가 분석 필요
- **권고**: 실제 메인프레임 라이브러리에서 해당 카피북 수집 후 재분석. DB 스키마(xls 파일 존재: THKIPA110 계열)에서 보완 가능

### 6.3 위험도 중 항목

#### [MEDIUM-01] DBIO 커서(OPEN-FETCH-CLOSE) 패턴 (DIPA301, 4개 테이블)
- **위치**: S4220(THKIPB111), S4230(THKIPB116), S4260(THKIPB114), S42C0(THKIPB132)
- **위험 근거**: `PERFORM VARYING WK-I FROM 1 BY 1 UNTIL COND-DBIO-MRNF` 루프에서 FETCH-DELETE를 반복하는 커서 기반 처리. Java 변환 시 `List<Map>` 조회 후 반복 삭제로 대응 가능하나, 대용량 데이터 시 메모리/성능 이슈 발생 가능
- **권고**: MyBatis의 bulk delete (IN 절 또는 foreach) 사용 검토. 대용량 데이터 여부 확인 필요

#### [MEDIUM-02] SQLIO 다중 호출 패턴 (DIPA301, 8종)
- **위치**: QIPA301~QIPA308 (각 SQLIO 프로그램 호출)
- **위험 근거**: SQLIO 프로그램(QIPA301~308)의 실제 SQL은 별도 SQLIO 소스에 정의되며 분석 범위에 없음. 복합 WHERE 조건이 포함될 수 있어 MyBatis XML 작성 시 재현 오류 위험
- **권고**: SQLIO 프로그램 소스 별도 수집 후 SQL 재현. XQIPA301~308 카피북 구조 확인 필수

#### [MEDIUM-03] 이중 입력 검증 (AIPBA30 + DIPA301 동일 필드 검증)
- **위치**: AIPBA30 S2000 (행 186-204), DIPA301 S2000 (행 288-327)
- **위험 근거**: AS와 DC 양쪽에서 동일 필드를 검증하나 조치코드가 상이함. Java 변환 시 검증 계층 통합 여부 결정 필요
- **권고**: nKESA 아키텍처상 PU(PM)에서 검증, DU(DM)에서는 생략 가능. 단, 오류코드 매핑 확인 필요

#### [MEDIUM-04] BICOM 공통영역 직접 참조 (DIPA301 다수)
- **위치**: DIPA301 행 367, 461, 488, 584, 597, 621, 667 등
- **위험 근거**: `BICOM-GROUP-CO-CD`, `BICOM-USER-EMPID`, `BICOM-BRNCD` 등 YCCOMMON의 BICOM 영역 항목을 DC 프로그램에서 직접 참조. Java 변환 시 CommonArea 또는 IOnlineContext에서 동일 값을 가져와야 하는데 YCCOMMON 카피북이 미해결 상태
- **권고**: YCCOMMON 카피북 확보 후 CommonArea Java 클래스의 필드명과 1:1 매핑 확인

#### [MEDIUM-05] 초기화 후 재설정 이중 패턴 (AIPBA30 S1000)
- **위치**: AIPBA30 S1000-INITIALIZE-RTN (행 141-160)
- **위험 근거**: IJICOMM 호출 전/후에 동일한 MOVE 구문이 중복 실행됨 (행 143-147, 156-160). 의도적 설계인지 코드 복사 오류인지 불명. IJICOMM이 JICOM 영역을 초기화할 가능성이 있어 호출 후 재세팅하는 방어적 코드일 수 있음
- **권고**: 실제 IJICOMM 동작 확인 후 중복 제거 여부 결정

### 6.4 위험도 하 항목

#### [LOW-01] AS 입력값 단순 SPACE 검증 (AIPBA30 S2000)
- 4개 필수항목 단순 검증. Java `StringUtils.isBlank()` 또는 `requestData.getString().isBlank()` 로 직접 대응

#### [LOW-02] 정상 종료 처리 (#OKEXIT)
- AIPBA30 `#OKEXIT CO-STAT-OK` → `return responseData`
- DIPA301 `#OKEXIT XDIPA301-R-STAT` → DM 메서드 정상 return

#### [LOW-03] #USRLOG 디버그 로그
- `#USRLOG "★[구간명]"` → `log.debug("★[구간명]")`
- AIPBA30 1회, DIPA301 다수 — 직접 대응 가능

#### [LOW-04] IJICOMM 공통IC 호출 패턴 (AIPBA30 S1000)
- `#DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA` → `CommonContextService.buildContext()`
- z-KESA 공통 패턴으로 변환 방법 확립됨

#### [LOW-05] 비계약업무구분코드 하드코딩 상수 ('060')
- `MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD` → `static final String NON_CTRC_BZWK_DSTCD = "060"`
- 신용평가 도메인 상수. 단순 상수 치환

#### [LOW-06] XDIPA301 인터페이스 구조 (RETURN/IN/OUT 영역)
- 88레벨 조건명 → Java enum 또는 상수 처리
- XDIPA301-R-SQL-CD의 LEADING SEPARATE 부호 → int 직접 변환 (SQL 에러코드는 int 범위)

### 6.5 마이그레이션 권고사항

1. **미해결 Copybook 우선 확보**: YCCOMMON, YCDBSQLA, YCDBIOCA, 12쌍 테이블 TR/TK 카피북, 8종 XQIPA 카피북 수집 없이는 정확한 타입 매핑 불가. DB xls 파일(THKIPA110 계열)로 일부 보완 가능

2. **SQLIO 프로그램 소스 확보**: QIPA301~QIPA308 SQLIO 소스의 실제 SQL 분석 필요. 복합 WHERE/JOIN 조건 포함 여부에 따라 MyBatis XML 복잡도 결정됨

3. **처리구분 '02' 업무 확인**: DIPA301에서 확정취소('02')가 실질 처리 없이 종료되는 것이 의도적인지 업무팀 확인 필수. 미구현이면 마이그레이션 범위에서 별도 처리

4. **트랜잭션 설계**: 처리구분 '03' 삭제 시 11개 테이블 연쇄 삭제가 단일 트랜잭션으로 처리되어야 함. Java에서는 @Transactional(rollbackFor = Exception.class) 적용 필수

5. **AIPBA30 중복 파일 정리**: `cobol/AIPBA30.cbl`과 `cobol/KIP.DONLINE.SORC/AIPBA30.cbl`이 중복 존재하며 내용 동일. 정규 위치는 `KIP.DONLINE.SORC/`이므로 해당 파일 기준으로 분석

6. **DB 스키마 매핑 확인**: db/ 디렉토리에 THKIPA110~THKIPA121 xls 파일 존재. 이 파일로 THKIPB110~THKIPB133 테이블의 실제 컬럼 정의 보완 필요 (명명규칙: THKIPA = 관련 업무 모듈, THKIPB = 기업집단 특정 테이블)

7. **nKESA 아키텍처 매핑**:
   - AIPBA30 → ProcessUnit(PU) `pmAipba30` 메서드
   - DIPA301 → DataUnit(DU) `dmDipa301` 메서드 (처리구분별 분기)
   - IJICOMM → `callSharedMethodByDirect("com.kbstar.kji.enbncmn", "FUBcXxx.buildContext", ...)` 또는 공통 Context 초기화
   - 11개 테이블 삭제 → DU 내 단일 DM 메서드 또는 처리구분별 DM 분리

---

## 7. 부록

### 7.1 전체 변수 목록

#### AIPBA30.cbl - Working Storage 전체

| 레벨 | 항목명 | PIC | VALUE | 비고 |
|------|--------|-----|-------|------|
| 01 | CO-AREA | GROUP | - | 상수 영역 |
| 03 | CO-PGM-ID | X(008) | 'AIPBA30' | |
| 03 | CO-STAT-OK | X(002) | '00' | |
| 03 | CO-STAT-ERROR | X(002) | '09' | |
| 03 | CO-STAT-ABNORMAL | X(002) | '98' | |
| 03 | CO-STAT-SYSERROR | X(002) | '99' | |
| 01 | CO-ERROR-AREA | GROUP | - | 에러코드 상수 영역 |
| 03 | CO-B3800004 | X(008) | 'B3800004' | |
| 03 | CO-B3900002 | X(008) | 'B3900002' | |
| 03 | CO-UKIF0072 | X(008) | 'UKIF0072' | |
| 03 | CO-UKII0182 | X(008) | 'UKII0182' | |
| 01 | WK-AREA | GROUP | - | 작업영역 |
| 03 | WK-FMID | X(013) | - | 폼ID 조립 |
| 01 | XZUGOTMY-CA | COPY | - | 미해결 |
| 01 | XIJICOMM-CA | COPY | - | 미해결 |
| 01 | XDIPA301-CA | COPY XDIPA301 | - | DC 인터페이스 (96 bytes) |
| (독립) | YCDBSQLA | COPY | - | 미해결 |

#### AIPBA30.cbl - Linkage Section 전체

| 레벨 | 항목명 | COPY | 비고 |
|------|--------|------|------|
| 01 | YCCOMMON-CA | YCCOMMON | 미해결 |
| 01 | YNIPBA30-CA | YNIPBA30 | 96 bytes |
| 01 | YPIPBA30-CA | YPIPBA30 | 10 bytes |

#### DIPA301.cbl - Working Storage 전체 (주요 항목)

| 레벨 | 항목명 | PIC | VALUE | 비고 |
|------|--------|-----|-------|------|
| 01 | CO-ERROR-AREA | GROUP | - | |
| 03 | CO-B3800004 | X(008) | 'B3800004' | |
| 03 | CO-B3900009 | X(008) | 'B3900009' | |
| 03 | CO-B4200023 | X(008) | 'B4200023' | |
| 03 | CO-B4200219 | X(008) | 'B4200219' | |
| 03 | CO-UKIF0072 | X(008) | 'UKIF0072' | |
| 03 | CO-UKII0182 | X(008) | 'UKII0182' | |
| 03 | CO-UKIP0001 | X(008) | 'UKIP0001' | |
| 03 | CO-UKIP0002 | X(008) | 'UKIP0002' | |
| 03 | CO-UKIP0003 | X(008) | 'UKIP0003' | |
| 03 | CO-UKIP0007 | X(008) | 'UKIP0007' | |
| 03 | CO-UKIP0008 | X(008) | 'UKIP0008' | |
| 01 | CO-AREA | GROUP | - | |
| 03 | CO-PGM-ID | X(008) | 'DIPA301' | |
| 03 | CO-STAT-OK | X(002) | '00' | |
| 03 | CO-STAT-NOTFND | X(002) | '02' | |
| 03 | CO-STAT-ERROR | X(002) | '09' | |
| 03 | CO-STAT-ABNORMAL | X(002) | '98' | |
| 03 | CO-STAT-SYSERROR | X(002) | '99' | |
| 03 | CO-MAX-100 | 9(003) | 100 | 미사용 |
| 01 | WK-AREA | GROUP | - | |
| 03 | WK-DATA-YN | X(001) | - | 기존재여부 플래그 |
| 03 | WK-EMP-HANGL-FNAME | X(042) | - | 직원한글명 |
| 03 | WK-BELNG-BRNCD | X(004) | - | 소속부점코드 |
| 03 | WK-I | 9(004) COMP | - | 루프카운터 |
| 03 | WK-MAIN-DEBT-AFFLT-YN | X(001) | - | 주채무계열여부 |
| 01 | TRIPB110-REC | COPY TRIPB110 | - | 미해결 |
| 01 | TKIPB110-KEY | COPY TKIPB110 | - | 미해결 |
| ... (TRIPB111~TRIPB119, TKIPB111~TKIPB119 동일 패턴) | | | | |
| (독립) | YCDBIOCA | COPY | - | 미해결 |
| (독립) | YCDBSQLA | COPY | - | 미해결 |
| 01 | XQIPA301-CA | COPY XQIPA301 | - | 미해결 |
| ... (XQIPA302~XQIPA308 동일) | | | | |

### 7.2 전체 SQL 구문

직접 EXEC SQL 구문 없음. DBIO/SQLIO 매크로 목록은 섹션 3.1 참조.

#### 매크로 기반 DB 접근 요약

| 접근 방식 | 건수 | 비고 |
|----------|------|------|
| #DYDBIO INSERT-CMD-Y | 1건 | THKIPB110 신규 INSERT |
| #DYDBIO SELECT-CMD-Y | 12건 | 잠금 SELECT (삭제 전 확인) |
| #DYDBIO DELETE-CMD-Y | 12건 | 잠금 DELETE |
| #DYDBIO OPEN-CMD-1 | 4건 | 커서 OPEN (THKIPB111, 116, 114, 132) |
| #DYDBIO FETCH-CMD-1 | 4건 | 커서 FETCH |
| #DYDBIO CLOSE-CMD-1 | 4건 | 커서 CLOSE |
| #DYSQLA SELECT | 8건 | QIPA301~308 복합 SELECT |
| 합계 | 45건 | DIPA301 전체 |

### 7.3 미해결 참조 목록

| Copybook명 | 참조 프로그램 | 용도 | 대안 |
|-----------|------------|------|------|
| XZUGOTMY | AIPBA30 | #GETOUT 출력영역 확보 | 프레임워크 공통 — 메인프레임 라이브러리 확보 필요 |
| XIJICOMM | AIPBA30 | IJICOMM IC 인터페이스 | 프레임워크 공통 — COND-XIJICOMM-OK, XIJICOMM-R-* 필드 확인 필요 |
| YCCOMMON | AIPBA30, DIPA301 | 공통영역 (BICOM, JICOM 등) | 필수 — BICOM-GROUP-CO-CD, BICOM-USER-EMPID, BICOM-BRNCD, BICOM-SCREN-NO, JICOM-NON-CTRC-BZWK-DSTCD, JICOM-NON-CTRC-APLCN-NO 사용 |
| YCDBSQLA | AIPBA30, DIPA301 | SQLIO 공통 인터페이스 | 필수 — COND-DBSQL-OK, COND-DBSQL-MRNF, DBSQL-SELECT-CNT 사용 |
| YCDBIOCA | DIPA301 | DBIO 공통 인터페이스 | 필수 — COND-DBIO-OK, COND-DBIO-MRNF, COND-DBIO-DUPM 사용 |
| TRIPB110 / TKIPB110 | DIPA301 | THKIPB110 기업집단평가기본 테이블 | db/ 폴더 xls에서 보완 검토 |
| TRIPB111 / TKIPB111 | DIPA301 | THKIPB111 기업집단연혁명세 | db/ 폴더 xls에서 보완 검토 |
| TRIPB112 / TKIPB112 | DIPA301 | THKIPB112 기업집단재무분석목록 | db/ 폴더 xls에서 보완 검토 |
| TRIPB113 / TKIPB113 | DIPA301 | THKIPB113 기업집단사업부분구조분석명세 | db/ 폴더 xls에서 보완 검토 |
| TRIPB114 / TKIPB114 | DIPA301 | THKIPB114 기업집단항목별평가목록 | db/ 폴더 xls에서 보완 검토 |
| TRIPB116 / TKIPB116 | DIPA301 | THKIPB116 기업집단계열사명세 | db/ 폴더 xls에서 보완 검토 |
| TRIPB118 / TKIPB118 | DIPA301 | THKIPB118 기업집단평가등급조정사유목록 | db/ 폴더 xls에서 보완 검토 |
| TRIPB119 / TKIPB119 | DIPA301 | THKIPB119 기업집단재무평점단계별목록 | db/ 폴더 xls에서 보완 검토 |
| TRIPB130 / TKIPB130 | DIPA301 | THKIPB130 기업집단주석명세 | db/ 폴더 xls에서 보완 검토 |
| TRIPB131 / TKIPB131 | DIPA301 | THKIPB131 기업집단승인결의록명세 | db/ 폴더 xls에서 보완 검토 |
| TRIPB132 / TKIPB132 | DIPA301 | THKIPB132 기업집단승인결의록위원명세 | db/ 폴더 xls에서 보완 검토 |
| TRIPB133 / TKIPB133 | DIPA301 | THKIPB133 기업집단승인결의록의견명세 | db/ 폴더 xls에서 보완 검토 |
| XQIPA301 | DIPA301 | SQLIO QIPA301 인터페이스 | SQLIO 소스 확보 필요 |
| XQIPA302 | DIPA301 | SQLIO QIPA302 인터페이스 | SQLIO 소스 확보 필요 |
| XQIPA303 | DIPA301 | SQLIO QIPA303 인터페이스 | SQLIO 소스 확보 필요 |
| XQIPA304 | DIPA301 | SQLIO QIPA304 인터페이스 | SQLIO 소스 확보 필요 |
| XQIPA305 | DIPA301 | SQLIO QIPA305 인터페이스 | SQLIO 소스 확보 필요 |
| XQIPA306 | DIPA301 | SQLIO QIPA306 인터페이스 | SQLIO 소스 확보 필요 |
| XQIPA307 | DIPA301 | SQLIO QIPA307 인터페이스 | SQLIO 소스 확보 필요 |
| XQIPA308 | DIPA301 | SQLIO QIPA308 인터페이스 | SQLIO 소스 확보 필요 |

---

*본 분석 보고서는 제공된 COBOL 소스와 카피북만을 기반으로 작성되었습니다. 미해결 참조 항목은 플래닝 단계에서 추가 자료 수집 후 보완이 필요합니다.*
