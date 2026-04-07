# 02. DB 접근 패턴 매핑 (DBIO/SQLIO → XSQL/DBIO Unit)



---

# z-KESA → n-KESA Complete DB Access Pattern Mapping

---

## 1. DB Access Architecture Overview

### [Architecture] - DB Access Module Overview

- z-KESA: DBIO 프로그램 / SQLIO 프로그램
- n-KESA: DBIO Unit (DBM) / DataUnit (DM)
- z-KESA Detail: COBOL 자동생성 프로그램 (BPG 도구 사용). DBIO = 테이블별 PK/AK 기반 단건 CRUD 전용 COBOL 서브프로그램. SQLIO = 개발자 작성 SQL 기반 다건/조인 조회 COBOL 서브프로그램.
- n-KESA Detail: Java 자동생성 유닛 (NEXCORE IDE 위저드 사용). DBIO Unit = 테이블 단건 CRUD 전용 Java 클래스 (DBM 메소드 보유). DataUnit (DU) = SELECT 전용 Java 클래스 (DM 메소드, dbSelect* API 사용). 계정성 업무에서 DBIO Unit이 COBOL DBIO에 직접 대응. 일반 서버 업무에서는 DU가 CUD도 허용.
- Mapping Rule: z-KESA DBIO 프로그램 → n-KESA DBIO Unit (계정성 업무) 또는 DataUnit CUD 메소드 (일반서버). z-KESA SQLIO 프로그램 → n-KESA DataUnit의 DM 메소드 + XSQL 파일.

---

### [Architecture] - DB Access Tool / Generation Method

- z-KESA: BPG (BANCS Program Generator), BMS 도구
- n-KESA: NEXCORE IDE 위저드 (컴포넌트 우클릭 → [데이터 유닛 생성] 또는 [DBIO 유닛 생성])
- z-KESA Detail: BMS의 BPG를 통해 Table Index/컬럼 정보를 기반으로 DBIO 소스 및 카피북 자동생성. 생성 산출물: DBIO 프로그램(xxx.DDB2.DBSORC), TABLE KEY 카피북(TKxxyyyy), TABLE RECORD 카피북(TRxxyyyy).
- n-KESA Detail: NEXCORE 탐색기 → 컴포넌트 선택 → 우클릭 → [데이터 유닛 생성] 시 DataUnit Java 클래스 + 동명의 *.xsql 파일 자동 생성. [DBIO 유닛 생성] 시 DBIO Unit Java 클래스 + *.xsql 파일 생성. DBM 코드는 개발자 임의 수정 불가.
- Mapping Rule: BPG 자동생성 절차 → NEXCORE 위저드 자동생성 절차. 단, n-KESA에서 테이블 레이아웃 변경 시 DBIO 유닛 재생성 필수.

---

### [Architecture] - SQL 파일 구조

- z-KESA: SQLIO 카피북 내장 SQL (BMS에 SQL TEXT 등록, 최대 30,000 Bytes). SQL은 COBOL 소스 또는 BMS DB에 저장.
- n-KESA: XSQL 파일 (*.xsql, XML 형식). DataUnit 클래스와 1:1 대응. XSQL 파일명 = DataUnit 클래스명.
- z-KESA Detail: SQLIO 카피북명: XQxxyyyy (XQ + 애플리케이션코드 2자리 + 분류코드 4자리). SQL Text는 BMS의 SQLIO 관리화면에 등록 후 소스생성 버튼으로 COBOL 소스/카피북 생성.
- n-KESA Detail: 하나의 xsql 파일에 여러 SQL 작성 가능. NEXCORE 탐색기에서 XSQL 노드 선택 → 우클릭 → [SQL문 생성]으로 SQL 개별 등록. SQL ID 명명 규칙 준수 필수.
- Mapping Rule: SQLIO SQL TEXT → XSQL 파일 내 개별 SQL ID 블록으로 변환. SQLIO 카피북(XQxxyyyy) → XSQL 파일 내 SQL 선언으로 대체.

---

## 2. Copybook / Interface Structure

### [Copybook] - DBIO Interface Parameter Copybook

- z-KESA: YCDBIOCA (DBIO Interface Parameter 카피북)
- n-KESA: IDataSet requestData / IOnlineContext onlineCtx (메소드 파라미터로 자동 전달)
- z-KESA Detail: DATA DIVISION에 `COPY YCDBIOCA.` 선언 필수. 기능 Command(DBIO-CMD), Access Key 지정 및 실행결과 상태(DBIO-STAT), SQL Code(DBIO-SQLCODE) 등을 포함하는 공통 인터페이스 카피북.
- n-KESA Detail: 별도 파라미터 구조체 선언 불필요. DBIO Unit의 DBM 메소드 시그니처: `public IDataSet methodName(IDataSet requestData, IOnlineContext onlineCtx)`. 결과는 IDataSet으로 리턴. ROW_CNT 키로 처리 건수 확인.
- Mapping Rule: `COPY YCDBIOCA.` → 제거. DBIO-CMD, DBIO-STAT 등 개별 필드 참조 코드 → DBM 메소드 호출 결과 IDataSet의 `getInt("ROW_CNT")` 또는 예외 처리로 대체.

---

### [Copybook] - SQLIO Interface Common Copybook

- z-KESA: YCDBSQLA (SQLIO 인터페이스 공통 카피북)
- n-KESA: (해당 없음 — XSQL + dbSelect* API가 역할 대체)
- z-KESA Detail: DATA DIVISION에 `COPY YCDBSQLA.` 선언 필수. DBSQL-SQLCODE (SQL 리턴코드), DBSQL-SELECT-REQ (조회 요구 건수), DBSQL-SELECT-CNT (조회 실제 건수) 등의 공통 필드를 포함.
- n-KESA Detail: SQLIO 공통 카피북 개념 없음. 조회 결과는 IRecordSet 또는 IRecord 객체로 반환. 조회 건수는 IRecordSet.getRecordCount()로 확인. 최대 건수 초과 시 자동 에러 발생 (기본값 1만건).
- Mapping Rule: `COPY YCDBSQLA.` → 제거. DBSQL-SELECT-REQ/DBSQL-SELECT-CNT 필드 처리 로직 → dbSelectPage() 또는 IRecordSet API로 대체.

---

### [Copybook] - TABLE KEY Copybook

- z-KESA: TKxxyyyy (TABLE KEY 카피북, Access Key 구조체)
- n-KESA: IDataSet param (SQL 바인드 변수 값을 담는 Map/IDataSet)
- z-KESA Detail: 카피북명 = 'T' + 'K' + 애플리케이션코드(2자리) + 분류코드(4자리). PDS: xxx.DDB2.DBCOPY. 사용 예: `01 TKFACO13-KEY. COPY TKFACO13.` PK 및 Access Key 컬럼에 해당하는 COBOL 필드 구조체. DBIO 호출 전 해당 필드에 값을 MOVE하여 설정.
- n-KESA Detail: 별도 Key 구조체 없음. `IDataSet param`에 바인드 변수명(키)과 값을 put()하여 전달. 예: `requestData.put("acno", acnoValue);`
- Mapping Rule: `MOVE 값 TO TKxxyyyy-PK-필드명` → `param.put("필드명", 값)`. `COPY TKxxyyyy` 선언 → 제거.

---

### [Copybook] - TABLE RECORD Copybook

- z-KESA: TRxxyyyy (TABLE RECORD 카피북, 전체 컬럼 레코드 구조체)
- n-KESA: IRecord (단건 조회 결과) / IRecordSet (다건 조회 결과)
- z-KESA Detail: 카피북명 = 'T' + 'R' + 애플리케이션코드(2자리) + 분류코드(4자리). PDS: xxx.DDB2.DBCOPY. 사용 예: `01 TRFACO13-REC. COPY TRFACO13.` 테이블의 전체 컬럼에 대응하는 COBOL 필드 구조체. DBIO 수행 후 결과 레코드가 이 구조체에 채워짐. 반드시 PK 컬럼, 시스템최종처리일시(SYS-LAST-PRCSS-YMS), 시스템최종사용자번호(SYS-LAST-UNO) 컬럼 포함.
- n-KESA Detail: IRecord = Key-Value 맵 형태의 단건 레코드. 컬럼 접근: `record.getString("컬럼명")` 등. IRecordSet = IRecord의 리스트. `rs.getRecord(i)`로 개별 레코드 접근.
- Mapping Rule: `COPY TRxxyyyy` → 제거. `TRxxyyyy-컬럼명` 필드 참조 → `record.getString("컬럼명")` 또는 `rs.getRecord(i).getString("컬럼명")`으로 대체.

---

### [Copybook] - SQLIO Interface Parameter Copybook

- z-KESA: XQxxyyyy (SQLIO 인터페이스 파라미터 카피북)
- n-KESA: XSQL 파일 내 입출력 바인드 변수 / IDataSet param
- z-KESA Detail: 카피북명 = 'XQ' + 애플리케이션코드(2자리) + 분류코드(4자리). PDS: xxx.DDB2.DBCOPY. 사용 예: `01 XQFA0308-CA. COPY XQFA0308.` 입력(XQFA0308-I-xxx) 및 출력(XQFA0308-O-xxx) 필드를 포함한 SQLIO 프로그램의 인터페이스 구조체. SQL의 입력/출력 매핑 정보와 1:1 대응.
- n-KESA Detail: XSQL 파일에서 바인드 변수를 `#변수명#` 형식으로 직접 선언. 입력값은 IDataSet/Map/IRecord에 `put("변수명", 값)`으로 전달. 출력 컬럼은 `AS "서버변수명"` alias 형식으로 XSQL에 선언.
- Mapping Rule: `01 XQFA0308-CA. COPY XQFA0308.` → 제거. `MOVE 값 TO XQFA0308-I-필드명` → `param.put("필드명", 값)`. `XQFA0308-O-필드명` 출력 참조 → `record.getString("필드명")`.

---

## 3. DBIO Generation and Naming

### [DBIO] - DBIO Program Naming Convention

- z-KESA: R + 애플리케이션코드(2자리) + 분류코드(4자리) (예: RHC0014, RFA CO13)
- n-KESA: DBIO_T[테이블명]_[일련번호] (예: DBIO_TSXXX9001_00)
- z-KESA Detail: 기본 DBIO 프로그램명 = `R + 애플리케이션코드(2자리) + 분류코드(4자리)`. 컬럼그룹 정의 시 추가 일련번호: `R + 코드(6자리) + 컬럼그룹일련번호(1자리)`. 생성 PDS: xxx.DDB2.DBSORC.
- n-KESA Detail: DBIO Unit 클래스명 = `DBIO_T[테이블명]_[번호]`. IDE 위저드에서 테이블 선택 시 자동 생성. 동일 테이블에 여러 DU 생성 시 테이블명 끝에 A~Z 일련번호 부여.
- Mapping Rule: z-KESA DBIO 프로그램명(예: RHC0014) → n-KESA DBIO Unit 클래스명(예: DBIO_TKHC0014_00)으로 대응 매핑 테이블 작성. 호출 코드에서 프로그램명 문자열 → Java 클래스 인스턴스 참조로 전환.

---

### [DBIO] - DBIO Unit Binding in Calling Class

- z-KESA: `#DYDBIO [CMD] [KEY 카피북] [RECORD 카피북]` (Dynamic CALL 매크로)
- n-KESA: `@BizUnitBind private DBIO_TSXXX9001_00 dBIO_TSXXX9001_00;` + `dBIO_TSXXX9001_00.insert(requestData, onlineCtx)`
- z-KESA Detail: DBIO 프로그램 호출은 `#DYDBIO` 매크로 단일 구문으로 수행. 매크로 인수: [기능 Command] [테이블 키 카피북 변수명] [테이블 레코드 카피북 변수명]. 호출 전 KEY 카피북의 각 필드에 MOVE로 값 설정. 프레임워크가 Dynamic CALL로 실제 DBIO 서브프로그램을 호출.
- n-KESA Detail: 호출 클래스(PM, FM, DM)에서 `@BizUnitBind` 어노테이션으로 DBIO Unit 인스턴스 주입. 메소드 직접 호출: `dBIO.insert(requestData, onlineCtx)`, `dBIO.select(requestData, onlineCtx)`, `dBIO.update(requestData, onlineCtx)`, `dBIO.delete(requestData, onlineCtx)` 등.
- Mapping Rule: `#DYDBIO INSERT-CMD-Y TKxxyyyy-PK TRxxyyyy-REC` → `@BizUnitBind + dBIO.insert(requestData, onlineCtx)`. KEY 카피북 MOVE 코드 → `requestData.put(키명, 값)` 변환.

---

## 4. DBIO Command → n-KESA Method Mapping

### [DBIO Command] - SELECT (No Lock)

- z-KESA: `SELECT-CMD-N`
- n-KESA: DBIO Unit의 `select()` DBM 메소드 (또는 DataUnit의 `dbSelectSingle()`)
- z-KESA Detail: `#DYDBIO SELECT-CMD-N TKFACO13-PK TRFACO13-REC`. PK 또는 AK 컬럼에 값을 설정하여 단건 조회. 잠금(Lock) 없음. Access Key 조건(WORK-ACCESS-COND)으로 조건 그룹 선택.
- n-KESA Detail: DBIO Unit의 select DBM은 단건 조회(PK/AK 기반). DataUnit에서는 `IRecord record = dbSelectSingle("selectSqlId", param, onlineCtx)` 사용. 결과 0건 → null 반환, 1건 → IRecord 반환, 2건 이상 → 예외 발생.
- Mapping Rule: `SELECT-CMD-N` → DBIO Unit `select()` 또는 DataUnit `dbSelectSingle()`. 잠금 없는 단건 조회이므로 n-KESA 기본 select DBM으로 매핑.

---

### [DBIO Command] - SELECT (With Lock)

- z-KESA: `SELECT-CMD-Y`
- n-KESA: DBIO Unit의 `selectForUpdate()` 또는 `lockSelect()` DBM 메소드 (DBIO의 Lock R 기능)
- z-KESA Detail: `#DYDBIO SELECT-CMD-Y TKFACO13-PK TRFACO13-REC`. Locking = Yes. 갱신을 수반하는 SELECT(Lock Read)에만 사용. 온라인 수정/삭제거래에서 반드시 사용.
- n-KESA Detail: DBIO Unit의 단건 Lock R 조회 Operation. DBIO Unit 위저드에서 `단건 Lock R(조회) 작업` 항목으로 생성. DataUnit에서는 XSQL에 `FOR UPDATE WITH RS` 절을 추가한 SQL로 Lock SELECT 구현.
- Mapping Rule: `SELECT-CMD-Y` → DBIO Unit의 Lock 조회 DBM (selectForUpdate 계열). XSQL 기반 DU에서 직접 구현 시 `SELECT ... FOR UPDATE WITH RS` (DB2) 또는 `SELECT ... FOR UPDATE` (Oracle) 절 추가.

---

### [DBIO Command] - SELECT FIRST

- z-KESA: `SELFST-CMD-n`
- n-KESA: DataUnit `dbSelectSingle()` + XSQL에 `FETCH FIRST 1 ROW ONLY`
- z-KESA Detail: `#DYDBIO SELFST-CMD-n TKHC0014-A1 TRHC0014-REC`. 커서를 열어 첫 번째 행만 조회 후 즉시 커서 닫기. n은 접근조건 번호(1~4).
- n-KESA Detail: XSQL에서 `FETCH FIRST 1 ROW ONLY`를 SQL 끝에 명시. `dbSelectSingle()` 호출로 단건만 수신.
- Mapping Rule: `SELFST-CMD-n` → `dbSelectSingle()` + XSQL `FETCH FIRST 1 ROW ONLY`.

---

### [DBIO Command] - INSERT

- z-KESA: `INSERT-CMD-Y`
- n-KESA: DBIO Unit의 `insert()` DBM 메소드 (계정성 업무) 또는 DataUnit `dbInsert()` (일반서버)
- z-KESA Detail: `#DYDBIO INSERT-CMD-Y TKFACO13-PK TRFACO13-REC`. 삽입 전 TRxxyyyy-REC 카피북의 모든 컬럼 필드에 값 설정 필요. 시스템최종처리일시/사용자번호 포함.
- n-KESA Detail: 계정성: `IDataSet insertRes = dBIO.insert(requestData, onlineCtx); int rows = insertRes.getInt("ROW_CNT");`. 일반서버: `int rows = dbInsert("insertSqlId", requestData, onlineCtx);`.
- Mapping Rule: `INSERT-CMD-Y` → DBIO Unit `insert()` (계정성) 또는 `dbInsert()` (일반서버). 결과 코드 체크 → 반환된 ROW_CNT 또는 int rows 검증으로 대체.

---

### [DBIO Command] - UPDATE

- z-KESA: `UPDATE-CMD-Y`
- n-KESA: DBIO Unit의 `update()` DBM (계정성) 또는 DataUnit `dbUpdate()` (일반서버)
- z-KESA Detail: `#DYDBIO UPDATE-CMD-Y TKFACO13-PK TRFACO13-REC`. KEY 카피북에 PK 설정, RECORD 카피북에 갱신 값 설정. 복수 Row Update 불허(단건만).
- n-KESA Detail: 계정성: `dBIO.update(requestData, onlineCtx)`. 일반서버: `int rows = dbUpdate("updateSqlId", requestData, onlineCtx)`. UPDATE 처리 건수 검증 권장.
- Mapping Rule: `UPDATE-CMD-Y` → DBIO Unit `update()` 또는 `dbUpdate()`. DBIO-STAT 코드 체크 → try-catch (DataException) 또는 rows 검증으로 대체.

---

### [DBIO Command] - LKUPDT (Lock Update)

- z-KESA: `LKUPDT-CMD-Y`
- n-KESA: DataUnit XSQL `SELECT ... FOR UPDATE WITH RS` 후 `dbUpdate()` 순서 처리
- z-KESA Detail: `#DYDBIO LKUPDT-CMD-Y TKFACO13-PK TRFACO13-REC`. SELECT-CMD-Y + UPDATE-CMD-Y를 단일 호출로 수행. 조회와 갱신을 단일 atomic 오퍼레이션으로 처리.
- n-KESA Detail: 명시적 `SELECT ... FOR UPDATE`로 Lock 획득 후 별도 `dbUpdate()` 호출. 또는 DBIO Unit의 Lock조회 DBM 호출 후 update DBM 호출.
- Mapping Rule: `LKUPDT-CMD-Y` → `selectForUpdate DBM + update DBM` 순서 호출, 또는 XSQL `FOR UPDATE` + `dbUpdate()` 순서로 분리 구현.

---

### [DBIO Command] - DELETE

- z-KESA: `DELETE-CMD-Y`
- n-KESA: DBIO Unit의 `delete()` DBM (계정성) 또는 DataUnit `dbDelete()` (일반서버)
- z-KESA Detail: `#DYDBIO DELETE-CMD-Y TKFACO13-PK TRFACO13-REC`. PK 기반 단건 삭제. 시스템최종처리일시/사용자번호 검증 수행.
- n-KESA Detail: 계정성: `dBIO.delete(requestData, onlineCtx)`. 일반서버: `int rows = dbDelete("deleteSqlId", requestData, onlineCtx)`.
- Mapping Rule: `DELETE-CMD-Y` → DBIO Unit `delete()` 또는 `dbDelete()`.

---

### [DBIO Command] - DELFRC (Force Delete, 시스템컬럼 검증 생략)

- z-KESA: `DELFRC-CMD-Y`
- n-KESA: `dbDelete()` + XSQL에서 sysLastPrcssYMS/sysLastUno 조건 미포함
- z-KESA Detail: `#DYDBIO DELFRC-CMD-Y TKLAS010-PK`. 시스템최종처리일시, 시스템최종사용자번호를 검증하지 않고 삭제. 일반 `DELETE-CMD-Y`와의 차이: 검증 생략.
- n-KESA Detail: XSQL DELETE 문의 WHERE 절에서 sysLastPrcssYMS, sysLastUno 조건을 제외. 또는 DBIO Unit의 force delete DBM(있는 경우) 사용.
- Mapping Rule: `DELFRC-CMD-Y` → `dbDelete()` + XSQL WHERE 절에서 시스템컬럼 검증 조건 제거.

---

### [DBIO Command] - Column Group SELECT/UPDATE

- z-KESA: `SELECT-GRn-Y` / `UPDATE-GRn-Y` (n: 컬럼그룹 일련번호)
- n-KESA: 해당 컬럼 subset만 SELECT/UPDATE하는 별도 XSQL SQL ID
- z-KESA Detail: 컬럼그룹을 정의한 경우 `SELECT-GR1-Y`, `SELECT-GR2-Y` 등의 Command 사용. 컬럼그룹별 DBIO 프로그램이 별도 모듈로 생성: `R + 코드(6자리) + 컬럼그룹일련번호(1자리)`. KEY/RECORD 카피북은 동일한 것 공유. 컬럼그룹 등록 시 PK 컬럼, 시스템최종처리일시, 시스템최종사용자번호 반드시 포함.
- n-KESA Detail: 별도 컬럼그룹 Command 개념 없음. XSQL에서 필요한 컬럼만 SELECT 또는 UPDATE 대상 컬럼만 SET 절에 포함한 별도 SQL ID를 작성하여 사용.
- Mapping Rule: `SELECT-GRn-Y` → XSQL에 부분 컬럼 SELECT 별도 SQL ID 작성. `UPDATE-GRn-Y` → XSQL에 해당 컬럼 그룹만 SET하는 UPDATE SQL ID 작성.

---

## 5. Cursor (Multi-Row) Processing via DBIO

### [Cursor] - DBIO OPEN Cursor

- z-KESA: `OPEN-CMD-n` (n: 접근조건 번호 1~4)
- n-KESA: DataUnit `dbSelect()` (커서 개념 없음, 결과 전체를 IRecordSet으로 반환)
- z-KESA Detail: `#DYDBIO OPEN-CMD-2 TKHC0014-A1 TRHC0014-REC`. DBIO 내부에서 `EXEC SQL DECLARE CUR_MODE_KEY CURSOR FOR SELECT...` + `EXEC SQL OPEN CUR_MODE_KEY` 수행. n은 접근조건 번호로 AK(Access Key) 조건 그룹 수를 의미. CURSOR 접근조건 '0'은 사용 불가. `DECLARE ... FOR SELECT ... ORDER BY` 절 포함.
- n-KESA Detail: n-KESA에는 COBOL 커서와 1:1 대응 개념 없음. 다건 결과는 `IRecordSet rs = dbSelect("selectListSqlId", param, onlineCtx)` 로 한 번에 수신. 메모리 OOM 방지를 위해 최대 1만건 제한. 초과 시 자동 에러.
- Mapping Rule: `OPEN-CMD-n + FETCH-CMD-n 루프 + CLOSE-CMD-n` → `dbSelect()` 단일 호출로 대체. FETCH 루프 로직 → IRecordSet 순회 (`for int i=0; i<rs.getRecordCount(); i++`) 로 대체.

---

### [Cursor] - DBIO FETCH Cursor

- z-KESA: `FETCH-CMD-n`
- n-KESA: IRecordSet 순회 (`rs.getRecord(i)`)
- z-KESA Detail: `#DYDBIO FETCH-CMD-2 TKHC0014-A1 TRHC0014-REC`. DBIO 내부에서 `EXEC SQL FETCH CUR_MODE_KEY INTO :host-vars` 수행. FETCH 후 결과코드 체크 (COND-DBIO-MRNF = 더 이상 레코드 없음 = 루프 종료 조건). SQLIO에서 건수요청: `MOVE NUMBER-100 TO DBSQL-SELECT-REQ`.
- n-KESA Detail: dbSelect()가 반환한 IRecordSet 객체에 전체 결과가 담김. `rs.getRecordCount()` = 총 건수. `rs.getRecord(i)` = i번째 IRecord. 별도 FETCH 개념 없음.
- Mapping Rule: FETCH 루프 (`PERFORM UNTIL COND-DBIO-MRNF / #DYDBIO FETCH...`) → `for (int i=0; i<rs.getRecordCount(); i++) { IRecord r = rs.getRecord(i); ... }` 루프로 변환.

---

### [Cursor] - DBIO CLOSE Cursor

- z-KESA: `CLOSE-CMD-n`
- n-KESA: (해당 없음 — IRecordSet은 자동 관리)
- z-KESA Detail: `#DYDBIO CLOSE-CMD-2 TKHC0014-A1 TRHC0014-REC`. DBIO 내부에서 `EXEC SQL CLOSE CUR_MODE_KEY` 수행. SQLIO에서도 사용 후 커서 닫기 필수. 재호출 시 이미 OPEN된 커서(-502) 에러 처리: `CLOSE CUR_MODE_KEY` 후 재 `OPEN CUR_MODE_KEY`.
- n-KESA Detail: IRecordSet은 try-with-resources 또는 GC 자동 관리. 명시적 close 불필요.
- Mapping Rule: `CLOSE-CMD-n` 코드 → 제거. 커서 재오픈(-502 처리) 로직 → 제거 (n-KESA에서 불필요).

---

## 6. SQLIO → XSQL Mapping

### [SQLIO] - SQLIO 호출 매크로

- z-KESA: `#DYSQLA [SQLIO프로그램명] [인터페이스카피북]`
- n-KESA: `dbSelect("sqlId", param, onlineCtx)` 또는 `dbSelectSingle("sqlId", param, onlineCtx)`
- z-KESA Detail: `#DYSQLA QFA0308 XQFA0308-CA`. SQLIO 프로그램명(QFA0308), 인터페이스 카피북 변수명(XQFA0308-CA) 지정. 호출 전 카피북 입력 필드(XQFA0308-I-xxx)에 MOVE로 값 설정. 수행 후 COND-DBSQL-OK / COND-DBSQL-MRNF 조건 체크.
- n-KESA Detail: XSQL 파일에 SQL ID와 SQL 문장 등록. 호출 코드: `IRecordSet rs = dbSelect("selectList", requestData, onlineCtx)`. SQL ID는 XSQL 파일 내 선언된 ID 문자열 사용.
- Mapping Rule: `#DYSQLA QFA0308 XQFA0308-CA` → `dbSelect("해당SQL_ID", requestData, onlineCtx)`. SQLIO 프로그램명 → XSQL SQL ID로 매핑. 인터페이스 카피북 → param IDataSet으로 대체.

---

### [SQLIO] - SQLIO Multi-Row Fetch (건수 요청)

- z-KESA: `MOVE NUMBER-100 TO DBSQL-SELECT-REQ` (DBSQL-SELECT-REQ 필드로 최대 요청 건수 지정)
- n-KESA: `dbSelectPage(sqlId, param, pageNo, rowPerPage, onlineCtx)` 또는 `dbSelect()` (최대 1만건 자동 제한)
- z-KESA Detail: SQLIO에서 다건 SELECT 시 `DBSQL-SELECT-REQ` 필드에 요청 건수 설정 (최대 Array 수보다 작은 값 필수). 수행 후 `DBSQL-SELECT-CNT`에 실제 반환 건수 담김. `MOVE DBSQL-SELECT-CNT TO WK-DATA-CNT`로 건수 확인.
- n-KESA Detail: 페이징: `IRecordSet rs = dbSelectPage("selectList", param, pageNo, rowPerPage, onlineCtx)`. pageNo=페이지번호, rowPerPage=페이지당 건수. `param.put("PAGE_NUM", 2)`, `param.put("PAGE_SIZE", 30)` 으로 파라미터 전달. XSQL Fragment 활용하여 페이징 적용.
- Mapping Rule: `DBSQL-SELECT-REQ` 설정 → `dbSelectPage()` pageNo/rowPerPage 파라미터로 대체. `DBSQL-SELECT-CNT` 참조 → `rs.getRecordCount()` 로 대체.

---

## 7. Single Row SELECT

### [SELECT] - 단건 조회 (Single Row SELECT)

- z-KESA: `SELECT-CMD-N` / `SELECT-CMD-Y` (#DYDBIO), 또는 SQLIO에서 단건 결과 반환
- n-KESA: `IRecord record = dbSelectSingle("sqlId", param, onlineCtx)`
- z-KESA Detail: DBIO를 통한 PK 기반 단건 조회: KEY 카피북에 PK 값 MOVE 후 `#DYDBIO SELECT-CMD-N TKXXX-PK TRXXX-REC` 호출. 결과는 TRXXX-REC 카피북 필드에 채워짐. 결과코드 COND-DBIO-OK(정상), COND-DBIO-MRNF(0건), COND-DBIO-DUPM(중복-해당없음) 체크.
- n-KESA Detail: `IRecord record = dbSelectSingle("select", requestData, onlineCtx)`. 0건 → null 반환. 1건 → IRecord. 2건 이상 → 예외. 결과 처리: `if(record != null){ responseData.putAll(record); }`.
- Mapping Rule: DBIO SELECT-CMD-N + KEY MOVE + RECORD 필드 참조 → `dbSelectSingle()` + null 체크 + `record.getString("컬럼명")`. COND-DBIO-MRNF 처리 → `record == null` 조건으로 대체.

---

## 8. Multi-Row SELECT

### [SELECT] - 다건 조회 (Multi-Row SELECT / List)

- z-KESA: SQLIO `#DYSQLA` 또는 DBIO `OPEN/FETCH/CLOSE` 커서 루프
- n-KESA: `IRecordSet rs = dbSelect("sqlId", param, onlineCtx)`
- z-KESA Detail: SQLIO 다건 조회: 입력 카피북(XQFA0308-I-xxx) 조립 → `#DYSQLA QFA0308 XQFA0308-CA` → 출력 카피북(XQFA0308-O-xxx) 배열 필드에서 결과 참조. DBIO 커서: `#DYDBIO OPEN-CMD-2` → PERFORM 루프 (`#DYDBIO FETCH-CMD-2` + 처리 + COND-DBIO-MRNF 체크) → `#DYDBIO CLOSE-CMD-2`.
- n-KESA Detail: `IRecordSet rs = dbSelect("selectList", requestData, onlineCtx)`. 결과를 DataSet에 key로 담아 리턴: `responseData.put("histList", rs)`. 최대 1만건 제한. RecordSet을 DataSet 단일 값으로 변환 불가(key로 담아야 함).
- Mapping Rule: SQLIO/DBIO 커서 전체 패턴 → `dbSelect()` 단일 호출 + IRecordSet 순회로 대체. 출력 카피북 배열 참조 → `rs.getRecord(i).getString("컬럼명")`.

---

## 9. Paging

### [SELECT] - 페이지 조회 (Paging SELECT)

- z-KESA: SQLIO `DBSQL-SELECT-REQ` 건수 제한 + 이후 SQLIO 재호출 (다음 키 설정 방식) 또는 `FETCH FIRST n ROWS ONLY`
- n-KESA: `IRecordSet rs = dbSelectPage("sqlId", param, pageNo, rowPerPage, onlineCtx)`
- z-KESA Detail: SQLIO에서 화면 페이징: 이미 사용된 데이터는 다음 검색 범위에서 제외되도록 검색 시작점 조건값 변경. `MOVE 다음Key TO XQXXX-I-Key` 후 재 `#DYSQLA` 호출. 온라인 다음화면 처리: `OPTIMIZE FOR n ROWS` 사용 권장.
- n-KESA Detail: `dbSelectPage(stmtName, param, pageNo, rowPerPage, onlineCtx)`. pageNo=페이지번호(1부터), rowPerPage=페이지당 행 수. XSQL에 Fragment로 페이징 SQL 작성. DB2 예시: `param.put("PAGE_NUM",2); param.put("PAGE_SIZE",30);`.
- Mapping Rule: SQLIO 재호출 페이징 패턴 → `dbSelectPage()` 호출 + pageNo 파라미터로 대체. `OPTIMIZE FOR n ROWS` → XSQL Fragment의 페이징 절로 대체.

---

## 10. INSERT Processing

### [INSERT] - 단건 INSERT (계정성 업무)

- z-KESA: `#DYDBIO INSERT-CMD-Y TKxxyyyy-PK TRxxyyyy-REC`
- n-KESA: `IDataSet insertRes = dBIO_TSXXX9001_00.insert(requestData, onlineCtx); int rows = insertRes.getInt("ROW_CNT");`
- z-KESA Detail: RECORD 카피북(TRxxyyyy-REC)의 모든 필드에 MOVE로 값 설정 후 호출. 중복(COND-DBIO-DUPM=결과코드 01) 처리 필수. 정상(COND-DBIO-OK=결과코드 00) 확인.
- n-KESA Detail: 계정성 업무는 DBIO Unit의 `insert()` DBM만 사용 가능. `@BizUnitBind`로 DBIO Unit 주입. INSERT 중복 발생 시 DataException throw → catch 후 `SQLExceptionUtils.isDuplicateKey(de)` 확인.
- Mapping Rule: RECORD 카피북 MOVE 코드 → `requestData.put("컬럼명", 값)` 블록으로 변환. `COND-DBIO-DUPM` 처리 → `catch (DataException de) { if (SQLExceptionUtils.isDuplicateKey(de)) {...} }` 로 대체.

---

### [INSERT] - 단건 INSERT (일반서버 업무)

- z-KESA: `#DYDBIO INSERT-CMD-Y` 또는 SQLIO INSERT
- n-KESA: `int rows = dbInsert("insertSqlId", requestData, onlineCtx)`
- z-KESA Detail: 일반 INSERT는 SQLIO를 통해서도 가능.
- n-KESA Detail: 일반서버 업무 DataUnit에서 `dbInsert()` 직접 호출 허용. Oracle에서 빈문자열("") → NULL로 저장 주의. DB2 전용 모드에서 빈문자열 → 빈문자열로 저장 (IS NULL 조회 안됨, = '' 로 조회).
- Mapping Rule: SQLIO INSERT → XSQL `<insert id="insertSqlId">INSERT INTO ...</insert>` + `dbInsert()`.

---

### [INSERT] - INSERT + PK 반환 (일반서버 업무 전용)

- z-KESA: (해당 없음 — z-KESA에서는 별도 Sequence 취득 후 INSERT 분리 수행)
- n-KESA: `Object id = dbInsertAndReturnPK("insertSqlId", requestData, onlineCtx)`
- z-KESA Detail: 순번(일련번호) 취득 시 CURSOR를 이용한 FOR UPDATE OF 패턴: DECLARE CURSOR SELECT SEQNO FOR UPDATE OF → OPEN → FETCH → UPDATE SEQNO = SEQNO+1 → CLOSE.
- n-KESA Detail: XSQL에 `<selectKey>` 태그로 Sequence SELECT 선언, `type="pre"` 설정. `Object id = (Integer)dbInsertAndReturnPK("insert", requestData, onlineCtx)`. 주의: insert 태그 첫 문장이 주석일 경우 selectKey 우선 처리 문제 → `type="pre"` 필수.
- Mapping Rule: COBOL Sequence 취득 커서 패턴 → XSQL `<selectKey>` + `dbInsertAndReturnPK()` 패턴으로 대체.

---

## 11. UPDATE / DELETE Processing

### [UPDATE] - 단건 UPDATE

- z-KESA: `#DYDBIO UPDATE-CMD-Y TKxxyyyy-PK TRxxyyyy-REC`
- n-KESA: DBIO Unit `update()` (계정성) 또는 `int rows = dbUpdate("updateSqlId", param, onlineCtx)` (일반서버)
- z-KESA Detail: KEY 카피북에 PK 값, RECORD 카피북에 변경 값 설정 후 호출. 복수 Row Update 불허. 컬럼그룹 UPDATE: `UPDATE-GRn-Y`.
- n-KESA Detail: `int rows = dbUpdate("update", requestData, onlineCtx)`. 처리 건수(rows) 검증 권장. 데이터 갱신(Update/Delete)은 가능한 프로그램 종료 직전에 수행 권장 (Lock Duration 감소).
- Mapping Rule: `UPDATE-CMD-Y` → `dbUpdate()`. RECORD 카피북 MOVE 코드 → `param.put()` 블록.

---

### [DELETE] - 단건 DELETE

- z-KESA: `#DYDBIO DELETE-CMD-Y TKxxyyyy-PK`
- n-KESA: DBIO Unit `delete()` (계정성) 또는 `int rows = dbDelete("deleteSqlId", param, onlineCtx)` (일반서버)
- z-KESA Detail: KEY 카피북에 PK 값 설정 후 호출. 시스템최종처리일시/사용자번호 검증 포함.
- n-KESA Detail: `int rows = dbDelete("delete", requestData, onlineCtx)`.
- Mapping Rule: `DELETE-CMD-Y` → `dbDelete()`. `DELFRC-CMD-Y` → XSQL WHERE절에서 시스템컬럼 조건 제거한 `dbDelete()`.

---

## 12. SQL Parameter Binding

### [Binding] - SQL 입력 바인드 변수

- z-KESA: SQLIO 입력 카피북 필드에 MOVE로 값 설정 (`MOVE 값 TO XQFA0308-I-ACNO`)
- n-KESA: XSQL에서 `#변수명#` 형식 + IDataSet/Map에 `put("변수명", 값)` 설정
- z-KESA Detail: SQLIO 카피북의 입력 필드(XQFA0308-I-xxx) 각각에 MOVE로 값을 설정. 입력변수명 중복 시 BMS 입력매핑에서 1개만 표시되므로 주의. SQL 문에서 호스트 변수 형태: `:ACNOA1`.
- n-KESA Detail: XSQL SQL 문에서 `WHERE 계좌번호 = #acno#` 형식. DB2에서 null 가능 바인드 변수에는 타입 명시 필수: `#acno:VARCHAR#`. 주석은 `/* ... */` 사용, `--` 사용 금지. COMMIT/ROLLBACK 구문 XSQL 내 절대 사용 금지.
- Mapping Rule: `MOVE 값 TO XQXXX-I-필드명` → `param.put("필드명", 값)`. `:호스트변수` (COBOL 임베디드 SQL) → `#변수명#` (XSQL 바인드). DB2 null 가능 컬럼: `#변수명:VARCHAR#` (또는 적절한 타입 명시).

---

### [Binding] - SQL 출력 컬럼 매핑

- z-KESA: SQLIO 출력 카피북 필드 (XQFA0308-O-xxx) 직접 참조
- n-KESA: XSQL SELECT 컬럼에 `AS "서버변수명"` alias 선언 + `record.getString("서버변수명")`
- z-KESA Detail: SQLIO 출력매핑 정보에 컬럼명, 영문명, 타입, 길이 등록. 함수 사용 시 Alias 필수 (컬럼명 동일). 출력 카피북 배열 필드로 다건 결과 참조.
- n-KESA Detail: `SELECT 계좌번호 AS "acno", 계좌명 AS "acnName" FROM ...`. Alias는 대소문자 유지를 위해 반드시 큰따옴표 사용. 스키마명 `INST1.` 테이블명 앞에 필수. `SELECT *` 사용 금지.
- Mapping Rule: SQLIO 출력 카피북 필드명 → XSQL AS "alias" 선언. `XQXXX-O-필드명` 참조 코드 → `record.getString("alias명")` 또는 `rs.getRecord(i).getString("alias명")`.

---

### [Binding] - 자동 바인드 변수 (시스템 컬럼)

- z-KESA: DBIO 프로그램 내부에서 시스템최종처리일시/사용자번호 자동 설정
- n-KESA: 프레임워크 자동 바인드 변수 (`sysLastPrcssYMS`, `sysLastUno`, `groupCoCd`)
- z-KESA Detail: DBIO 모듈이 자동으로 `시스템최종처리일시(SYS-LAST-PRCSS-YMS)`, `시스템최종사용자번호(SYS-LAST-UNO)` 컬럼을 현재 시각 및 사용자 번호로 설정. 개발자가 이 값을 직접 설정할 필요 없음.
- n-KESA Detail: 프레임워크에서 모든 INSERT/UPDATE 문에 자동 바인드: `sysLastPrcssYMS` (매 쿼리 시점 시스템 시각, 동일 트랜잭션 내에서도 쿼리별 상이), `sysLastUno` (시스템최종사용자번호), `groupCoCd` (그룹회사코드, BICOM값 자동). SQL에서 `#sysLastPrcssYMS#`, `#sysLastUno#`로 참조. 어플리케이션에서 `param.put("groupCoCd","KB1")`로 오버라이드 가능.
- Mapping Rule: DBIO 내부 자동 설정 → n-KESA 프레임워크 자동 바인드로 동일 역할. 개발자가 직접 설정하지 않아도 되는 점은 동일. XSQL INSERT/UPDATE 문에서 `#sysLastPrcssYMS#`, `#sysLastUno#` 바인드 변수를 명시.

---

## 13. Performance Optimization SQL Guidelines

### [Performance] - 일반 SQL 작성 원칙

- z-KESA: 2.5.6 성능 최적화를 위한 SQL 작성 지침 (SQLIO 생성 시 또는 직접 SQL 작성 시 준수)
- n-KESA: SQL 표준 가이드 + XSQL 작성 원칙
- z-KESA Detail:
  - Dynamic SQL 사용 금지
  - `SELECT *` 사용 금지 (반드시 사용 컬럼만 기술)
  - Equal 조건 컬럼은 SELECT/ORDER BY/GROUP BY 절에 중복 기술 금지
  - 동일 데이터 중복 SQL 발행 금지 (1회 발행 후 재사용)
  - 데이터 존재 여부 확인 시 `COUNT(*)` 대신 `SELECT '1' FROM ... WHERE ... FETCH FIRST 1 ROW ONLY` 사용
  - 조건 술어에 Scalar Function(`SUBSTR`, `CONCATENATE` 등) 사용 자제 (인덱스 사용 방해)
  - `IN` 보다 `EXISTS` 우선 사용 (SUB-SELECT 존재여부 확인 시)
  - WHERE 조건에서 컬럼과 Host Variable의 데이터 타입/길이 일치
  - WHERE 조건에 계산식 사용 금지 (SQL 발행 전에 계산)
  - 온라인: 소수의 Row 처리 시 `OPTIMIZE FOR n ROWS` 사용
  - 대량 Batch: Insert/Update/Delete 시 주기적 Commit (WITH HOLD 옵션으로 커서 유지)
  - 유사 검색조건: OR 나열 대신 AND 조건 통합
  - SELECT 후 UPDATE/DELETE: 데이터 정합성을 위해 Cursor 사용 (`FOR UPDATE OF` 지정)
  - 단일 Row(Unique Key 조건) SELECT 시 Cursor 미사용
  - Lock 경합 최소화: Lock Avoidance 기능 활용, Bind 시 ISOLATION(UR | CS) 사용
  - 날짜/시간 취득: DB2 SQL Call 지양 (CICS, 프로그램 언어 기능 활용)
  - DB2 Multi-Row fetch/insert 기능 활용 (DB2 v8 이상)
  - 범위 술어(BETWEEN, LIKE) 시작/종료 범위 최적화 (예: 입출금내역 조회 기간 최대 10일)
  - Host 변수 값에 따라 검색조건이 결정되는 조건 술어 자제, SQL 분리 검토
- n-KESA Detail:
  - XSQL에서 `SELECT *` 사용 금지 (동일)
  - 주석: `/* ... */` 사용, `--` 금지
  - 테이블명에 스키마명 `INST1.` 필수
  - SELECT 결과 컬럼에 `AS "서버변수명"` alias 필수 (큰따옴표)
  - DB2 CHAR 타입 바인드: `CAST(#col1:CHAR# AS CHAR(10))` 패딩 처리
  - MySQL: 대소문자 구분 시 `BINARY` 연산자. `SUBSTRB` → `SUBSTRING/SUBSTR` 대체
  - SELECT 안에 바인드 변수 사용 시 `CAST(#조건4# AS VARCHAR(100))` 타입 명시
  - 거래별 SQL Timeout: 기본 150초, 필요 시 SQL 상세정보의 Timeout 설정
  - COMMIT/ROLLBACK 구문 XSQL 내 절대 금지 (프레임워크가 트랜잭션 관리)
- Mapping Rule: z-KESA 성능 지침의 원칙(SELECT 최소화, 컬럼 명시, 인덱스 활용, EXISTS 우선, 계산식 금지 등)은 n-KESA XSQL 작성 시에도 동일 적용. COBOL-특정 지침(CICS 기능, Bind ISOLATION 설정)은 n-KESA 환경 설정(READ_COMMITTED 기본 설정됨)으로 대체.

---

## 14. DB Lock / Isolation

### [Lock] - Isolation Level 기본 설정

- z-KESA: Bind 시 ISOLATION(UR | CS) 설정. CS=Cursor Stability 기본.
- n-KESA: 프레임워크 기본 `READ_COMMITTED` (온라인/배치 공통 적용)
- z-KESA Detail: SQL 발행 시 ISOLATION 설정: UR(Uncommitted Read) = 다른 사용자가 COMMIT 전 갱신 데이터도 SELECT 가능. CS(Cursor Stability) = COMMIT 후 데이터만 SELECT 가능. Lock Avoidance 기능 활용 권장.
- n-KESA Detail: 프로젝트 n-KESA 기반 온라인/배치의 Isolation Level = `READ_COMMITTED`로 설정. DB2에서 SELECT만 해도 Lock 걸리는 특성이 이미 해제됨 → `WITH UR` 없이도 멀티 세션 동시 SELECT 가능.
- Mapping Rule: z-KESA Bind ISOLATION(UR) 설정 → n-KESA에서는 이미 READ_COMMITTED 적용되므로 별도 설정 불필요. 단, 정합성 무결성 요구 시 명시적 `WITH UR` 또는 `FOR UPDATE` 사용.

---

### [Lock] - WITH UR (Uncommitted Read)

- z-KESA: Bind ISOLATION(UR) 설정 또는 SQL에 직접 기술
- n-KESA: XSQL SELECT 문 끝에 `WITH UR` 절 추가
- z-KESA Detail: UR: 다른 사용자에 의해 갱신된 데이터를 COMMIT 전에 SELECT 가능. 조회 성능 향상 목적. Lock Avoidance와 함께 사용.
- n-KESA Detail: 사용 조건: (1) SELECT에서만 사용 가능, (2) 변경이 거의 없거나 다른 세션 변경이 문제되지 않는 경우, (3) 미세한 성능 향상이라도 필요한 경우. 주의: `WITH UR`은 rollback될 수 있는 미완료 트랜잭션 데이터까지 조회 → 정합성 미보장. 꼭 필요한 경우에만 사용. n-KESA READ_COMMITTED 환경에서는 대부분 불필요.
- Mapping Rule: z-KESA UR Bind ISOLATION → n-KESA XSQL `WITH UR` 절(필요 시). 대부분의 경우 n-KESA 기본 READ_COMMITTED로 충분하므로 `WITH UR` 제거 검토.

---

### [Lock] - LOCK SELECT / FOR UPDATE

- z-KESA: `SELECT-CMD-Y` (DBIO Lock Read) / `SELFST-CMD-n` + `SELECT ... FOR UPDATE OF`
- n-KESA: XSQL `SELECT ... FOR UPDATE WITH RS USE` (DB2) 또는 `SELECT ... FOR UPDATE` (Oracle)
- z-KESA Detail: `LOCK SELECT는 반드시 갱신을 수반하는 경우에만 사용`. SELECT 후 UPDATE/DELETE 시 `FOR UPDATE OF` Cursor 사용. 단일 Row Unique Key 조건 SELECT 시 Cursor(FOR UPDATE) 미사용.
- n-KESA Detail: DB2 문법: `SELECT ... FROM .. WHERE ... FOR UPDATE WITH RS USE`. Oracle: `SELECT ... FOR UPDATE`. 사용 기준: (1) 단일 UPDATE: FOR UPDATE 금지 (UPDATE 순간 X-lock 획득됨), (2) SELECT 후 나중에 UPDATE (읽고-계산-쓰기): FOR UPDATE 사용, (3) 외부 호출 후 UPDATE: 가능하나 지양(긴 Lock 유지 위험), (4) 두 행 이상 순차 UPDATE: Lock 순서 표준화 및 데드락 방지 필요.
- Mapping Rule: z-KESA `SELECT-CMD-Y` → n-KESA DBIO Unit lockSelect DBM 또는 XSQL `FOR UPDATE WITH RS`. `SELFST-CMD-n` (단건 Lock SELECT) → XSQL `FETCH FIRST 1 ROW ONLY` + `FOR UPDATE WITH RS`. 데드락 방지: 다중 행 잠금 시 PK 오름차순으로 잠금 순서 표준화.

---

### [Lock] - 낙관적 Lock (Optimistic Lock)

- z-KESA: (지원하지 않음 — DBIO를 통한 비관적 Lock 방식만 사용)
- n-KESA: 일반서버 업무에서 허용. `UPDATE ... WHERE id = :id AND version = :currentVersion`. 계정성 업무에서는 사용 불가.
- z-KESA Detail: z-KESA 환경에서는 비관적 Lock(SELECT FOR UPDATE → CUD → COMMIT) 방식 사용. 낙관적 Lock 개념 없음.
- n-KESA Detail: 계정성 업무: DBIO를 통한 CUD 통제로 낙관적 Lock 사용 불가. 일반서버(단위 시스템): `version` 컬럼 등을 이용한 낙관적 Lock 허용. 충돌 감지 실패 시 재시도 또는 실패 처리.
- Mapping Rule: z-KESA 비관적 Lock 패턴 → n-KESA 계정성 업무에서는 동일하게 비관적 Lock(DBIO Unit For UPDATE DBM) 사용. 일반서버에서는 업무 요건에 따라 낙관적 Lock 선택 가능.

---

## 15. Error Handling in DB Operations

### [Error] - DBIO 결과 코드 체크

- z-KESA: `COND-DBIO-OK`, `COND-DBIO-MRNF`, `COND-DBIO-DUPM`, `COND-DBIO-ERROR` 조건 평가 / 결과코드(DBIO-STAT): 00=정상, 01=중복, 02=없음, 09=기타, 98/99=비정상
- n-KESA: try-catch (DataException, BusinessException) + rows 건수 검증
- z-KESA Detail:
  ```
  EVALUATE TRUE
    WHEN COND-DBIO-OK       → 정상 (결과코드 00)
    WHEN COND-DBIO-DUPM     → Key 중복 (결과코드 01)
    WHEN COND-DBIO-MRNF     → Record Not Found (결과코드 02)
    WHEN OTHER              → #ERROR CO-B0100099 CO-UKLA0099 CO-STATUS-ERROR
  END-EVALUATE
  ```
  DBIO 비정상 종료(98,99): FW 에러 처리로 DC 호출 프로그램으로 직접 Return. DBIO-SQLCODE, SQLIO의 DBSQL-SQLCODE 값으로 SQL 상세 에러 파악.
- n-KESA Detail:
  ```java
  try {
      int cnt = dbInsert("insert", requestData, onlineCtx);
  } catch (DataException de) {
      if (SQLExceptionUtils.isDuplicateKey(de)) {
          throw new BusinessException("Bxxxxxxx", "USQCxxxx", de);
      }
      throw de;
  }
  ```
  DataException: SQL 처리 중 프레임워크가 throw. SQLException을 cause로 포함. DBMS 오류 코드 조회: `SQLExceptionUtils.getSQLErrorCode(de)`. 0건: `dbSelectSingle()` → null 반환 (예외 아님). ROW_CNT 또는 rows 변수로 처리 건수 확인.
- Mapping Rule:
  - `COND-DBIO-OK` → `rows > 0` 또는 예외 미발생
  - `COND-DBIO-MRNF` → `record == null` (단건 조회) 또는 `rows == 0`
  - `COND-DBIO-DUPM` → `catch(DataException de) { SQLExceptionUtils.isDuplicateKey(de) }`
  - `WHEN OTHER / #ERROR ...` → `catch(DataException de) { throw de; }` 또는 `throw new BusinessException(...)`
  - `DBIO-SQLCODE` 참조 → `SQLExceptionUtils.getSQLErrorCode(de)` 로 대체

---

### [Error] - SQLIO 결과 코드 체크

- z-KESA: `COND-DBSQL-OK`, `COND-DBSQL-MRNF` 조건 평가 / DBSQL-SQLCODE
- n-KESA: 예외 미발생 = 정상, IRecordSet.getRecordCount() == 0 = 0건
- z-KESA Detail:
  ```
  IF COND-DBSQL-OK OR COND-DBSQL-MRNF
      CONTINUE
  ELSE
      #ERROR CO-B1250008 CO-UKFA5142 CO-STAT-ERROR
  END-IF
  ```
  DBSQL-SQLCODE: SQL 실행 후의 SQLCODE 값 참조. 상위 프로그램에 SQL CODE 전달: `MOVE DBSQL-SQLCODE TO Xpgmname-R-SQL-CD`.
- n-KESA Detail: `dbSelect()` 정상 완료 = 예외 없음. 0건 = IRecordSet.getRecordCount() == 0. 오류 = DataException throw (catch 필수). `SQLExceptionUtils.getSQLErrorCode(de)` = DBMS 오류 코드.
- Mapping Rule: `COND-DBSQL-OK` → 예외 미발생. `COND-DBSQL-MRNF` → `rs.getRecordCount() == 0` 또는 `record == null`. `DBSQL-SQLCODE` → `SQLExceptionUtils.getSQLErrorCode(de)`.

---

### [Error] - #ERROR 매크로 (단일 에러 처리)

- z-KESA: `#ERROR [에러메시지코드] [조치메시지코드] [RETURN STATUS CODE]`
- n-KESA: `throw new BusinessException("errorCode", "processCode")` 또는 `throw new BusinessException("errorCode", "processCode", "customMsg", cause)`
- z-KESA Detail: `#ERROR CO-B1234567 CO-U1234567 CO-STAT-ERROR`. #ERROR 발행 시 해당 프로그램 실행 종료 → 호출 프로그램으로 Return. AS 프로그램에서 #ERROR 발행 시 거래 비정상 종료(Rollback). 하위 프로그램(IC, DC, FC, BC)의 #ERROR는 호출 프로그램에서 처리하지 않으면 무시. 사용자 맞춤 메시지: `#CSTMSG CO-USRMSG` 매크로 후 `#ERROR` 발행. COMMIT 후 에러 메시지 발행: `#TRMMSG` 매크로.
- n-KESA Detail: `throw new BusinessException("B3800205", "UBNE0070", "사용자출력맞춤메시지", e)`. BusinessException 생성자: (errorCode, processCode), (errorCode, processCode, Throwable cause), (errorCode, processCode, String customMsg), (errorCode, processCode, String customMsg, Throwable cause). 예상한 BusinessException은 그대로 상위 계층 전달. 예상못한 Exception은 BusinessException으로 감싸서 전달. ReturnStatus: `ex.setReturnStatus("00")` → 상위에서 `be.getReturnStatus()`로 회피 처리 가능.
- Mapping Rule:
  - `#ERROR CO-B1234567 CO-U1234567 CO-STAT-ERROR` → `throw new BusinessException("B1234567", "U1234567")`
  - `#CSTMSG CO-USRMSG` → `new BusinessException("B1234567", "U1234567", customMsg, e)` 생성자의 customMsg 파라미터
  - `RETURN STATUS CODE (CO-STAT-MRNF=02 등)` → `ex.setReturnStatus("02")` + 상위에서 `be.getReturnStatus()` 처리
  - `#TRMMSG` (Commit 후 에러 메시지) → n-KESA에서 별도 처리 패턴 설계 필요 (직접 대응 없음)

---

### [Error] - #MULERR 멀티 에러 처리

- z-KESA: `#MULERR START ... #ERROR ... #MULERR END` (검증 PC에서만 사용, 최대 10건)
- n-KESA: `addBusinessException("errorCode", "processCode", onlineCtx)` (PM에서만 사용, 최대 10건)
- z-KESA Detail: `#MULERR START` ~ `#MULERR END` 구간에서 `#ERROR`는 즉시 종료하지 않고 최대 10개 오류 축적. 검증 PC 계층에서만 사용. 멀티에러 구간 내 호출 가능 프로그램: 전행공통 BC만 가능. 10건 초과 시 직전 10건 편집 후 거래 종료.
- n-KESA Detail: PM 계층에서만 사용 가능. `addBusinessException("B3800205","UBNE0070",onlineCtx)`. BusinessException과 함께 사용 불가, addBusinessException만 사용. 최대 10건. `addBusinessException(errorCode, processCode, "telgmItemName", onlineCtx)` 형식으로 단말 Highlight 처리 지원.
- Mapping Rule:
  - `#MULERR START` → 멀티 에러 모드 시작 (PM 메소드 내에서 addBusinessException 사용 시작)
  - `#ERROR` (멀티에러 구간 내) → `addBusinessException("errorCode","processCode",onlineCtx)`
  - `#MULERR END` → PM 메소드 종료 또는 `if(stop) return responseData;`
  - z-KESA 검증 PC 계층 → n-KESA PM 계층에서 처리

---

### [Error] - SQLCODE 직접 참조

- z-KESA: `IF SQLCODE = -803 ... ` (임베디드 SQL SQLCODE 직접 검사) / `DBIO-SQLCODE`, `DBSQL-SQLCODE`
- n-KESA: `SQLExceptionUtils.getSQLErrorCode(de)` / `SQLExceptionUtils.isDuplicateKey(de)`
- z-KESA Detail:
  ```cobol
  IF SQLCODE = -803
      (중복키 처리)
  END-IF
  IF SQLCODE NOT = ZERO
      PERFORM S9100-ERROR-END-RTN
  END-IF
  ```
  `MOVE SQLCODE TO XZUGEROR-I-SQL-CD` 로 에러 로그에 SQL CODE 기록.
- n-KESA Detail:
  ```java
  catch (DataException de) {
      if (SQLExceptionUtils.isDuplicateKey(de)) { // DB2 중복키(-803 등)
          throw new BusinessException("Bxxxxxxx","USQCxxxx",de);
      }
      if (SQLExceptionUtils.getSQLErrorCode(de) == -813) {
          // 특정 SQLCODE 처리
      }
  }
  ```
- Mapping Rule:
  - `IF SQLCODE = -803` → `SQLExceptionUtils.isDuplicateKey(de)` (DB2 중복키)
  - `IF SQLCODE = ZERO` (정상) → 예외 미발생으로 처리
  - `IF SQLCODE NOT = ZERO` (오류) → `catch(DataException de)` 블록
  - `MOVE DBIO-SQLCODE TO Xpgmname-R-SQL-CD` → `SQLExceptionUtils.getSQLErrorCode(de)` 반환값 활용

---

## 16. Array Processing

### [Array] - 대량 데이터 배치 INSERT (Array 처리)

- z-KESA: DB2 Multi-Row Insert 기능 활용 (SQLIO 또는 직접 임베디드 SQL)
- n-KESA: `dbExecuteBatch(new DbBatchModeExecutor(100) { execute() { addBatch("insert", record); } }, onlineCtx)` (일반서버 업무만 허용)
- z-KESA Detail: DB2 v8 이상의 Multi-Row Insert 기능 활용. 대량 Batch 작업에서 INSERT/UPDATE/DELETE 시 주기적 Commit (Lock Duration 감소, DB Recovery 시간 최소화). `WITH HOLD` 옵션으로 커서 위치 유지. 건수요청(`DBSQL-SELECT-REQ`)으로 SQLIO에서 배열 단위 처리.
- n-KESA Detail:
  ```java
  final IRecordSet recordSet = requestData.getRecordSet("LIST");
  long totalCount = dbExecuteBatch(new DbBatchModeExecutor(100) { // 100: array 크기
      protected void execute() {
          for(int i=0; i<recordSet.getRecordCount(); i++) {
              addBatch("insert", recordSet.getRecord(i));
          }
      }
  }, onlineCtx);
  ```
  `addBatch()`: JVM Heap에 데이터 누적 → `dbExecuteBatch()` 호출 시 DBMS로 일괄 전송. Array 크기 100 이하로 제한 권장 (OOM 방지). 계정성 업무에서는 Array 처리 미허용(DBIO Unit 통해 단건 CUD만 허용). 주의: 동일 PK 대상으로 delete+insert 배치 모드 사용 불가 (PK 중복 오류 발생 가능).
- Mapping Rule: SQLIO/임베디드 SQL Multi-Row Insert 루프 → `dbExecuteBatch() + addBatch()` 패턴으로 대체. 주기적 Commit(대량 Batch) → `DbBatchModeExecutor` array 크기로 단위 제어.

---

### [Array] - 배치 중간 Commit

- z-KESA: Batch 작업에서 INSERT/UPDATE/DELETE 시 주기적 Commit 직접 수행 (`EXEC SQL COMMIT END-EXEC` 등)
- n-KESA: `DbBatchModeExecutor(batchSize)` 의 array 크기로 자동 배치 단위 제어 + 프레임워크 트랜잭션 관리
- z-KESA Detail: 대량 Batch 작업에서 데이터 갱신 시 주기적으로 Commit 실시 → 동시 사용성 증대 및 DB Recovery 시간 최소화. Cursor 위치 유지를 위해 `WITH HOLD` 옵션 적용.
- n-KESA Detail: 프레임워크가 트랜잭션 관리. XSQL 내 COMMIT/ROLLBACK 절대 금지. 배치에서 중간 commit이 필요한 경우 프레임워크 팀과 협의. `dbExecuteBatch()` 사용 시 array 크기 단위로 DBMS 전송.
- Mapping Rule: z-KESA 명시적 COMMIT → n-KESA에서 프레임워크 트랜잭션으로 위임. 대량 배치 중간 Commit 요구 → `DbBatchModeExecutor` 크기 조절 + 프레임워크 팀 협의.

---

## 17. DB Access Pattern per Business Type

### [Business Type] - 계정성 업무 DB Access 기준

- z-KESA: CUD(INSERT/UPDATE/DELETE) + LOCK READ: 반드시 DBIO 사용. 조회(SELECT): DBIO 또는 SQLIO 허용. JOIN/BETWEEN이 필요한 경우: SQLIO 사용. BATCH: DBIO 원칙(부득이 시 SQLIO).
- n-KESA: CUD + Lock SELECT: DBIO Unit(DBM)만 허용. SELECT: DataUnit(DM) + XSQL 사용.
- z-KESA Detail: 원장 갱신 온라인업무/Batch 처리에서 갱신 수반 DB Access(Insert, Update, Delete, Lock Read)는 System 안정성을 위해 DBIO 사용 원칙. 조회거래(SELECT)만 DBIO 또는 SQLIO 선택 가능.
- n-KESA Detail: 계정성 업무: DU(DataUnit)은 SELECT 관련 연산만 처리 가능. DBIO Unit만 CUD 처리 가능. 이유: 24*365 처리 + D-1 시점 데이터 보정 지원을 위해 DBIO가 전/후 데이터 반영로그/보정로그 생성. 계정성 업무에서 DU의 INSERT/UPDATE/DELETE 금지.
- Mapping Rule: z-KESA 계정성 DBIO(CUD) → n-KESA DBIO Unit(DBM). z-KESA 계정성 DBIO/SQLIO(SELECT) → n-KESA DataUnit(DM) + dbSelectSingle/dbSelect.

---

### [Business Type] - 일반서버 업무 DB Access 기준

- z-KESA: DBIO 또는 SQLIO 선택 가능 (USER 편의에 따라). 일일 사용목적 DB 생성, 보고서 작성, Table 유지보수: SQL/DBIO 선택적 사용.
- n-KESA: DataUnit(DM)에서 SELECT/INSERT/UPDATE/DELETE 모두 허용. DBIO Unit 사용도 가능하나 필수 아님.
- z-KESA Detail: ONLINE 수정/삭제/등록거래에서도 일반서버는 SQLIO 허용. 보고서/환원자료 작성, 일일 사용목적 DB 생성 등은 SQL/DBIO 선택.
- n-KESA Detail: 일반서버(비계정성) 업무: DU에서 모든 연산(CRUD) 허용. 타 팀 테이블 DELETE/INSERT/UPDATE 금지. 타 DBIO에서 테이블 DELETE/INSERT/UPDATE 금지. 같은 컴포넌트 내 DBIO라도 테이블의 DML은 해당 테이블의 DBIO에서만 가능.
- Mapping Rule: z-KESA 일반서버 SQLIO INSERT → n-KESA `dbInsert()`. z-KESA SQLIO UPDATE → `dbUpdate()`. z-KESA SQLIO DELETE → `dbDelete()`. 교차 테이블 Access 제한은 z-KESA와 n-KESA 모두 동일.

---

## 18. DBIO Source Generation Constraints

### [Constraint] - DBIO/SQLIO 생성 제약사항

- z-KESA: 테이블 컬럼 수 350개 이하 / RECLENGTH 30,000 Byte 이하 / Access Key 컬럼 수 40개 이하 / SQLIO SQL TEXT 30,000 Bytes 이하
- n-KESA: LOB/Binary 타입 컬럼 사용 불가 / 타 DB 테이블 CUD 불가 (DBIO Unit에서)
- z-KESA Detail: 테이블 컬럼 갯수 350개 초과 불가 (초과 시 z-KESA 담당자와 협의). SYSIBM.SYSTABLES RECLENGTH 최대 30,000 Byte (24*365 반영로그/복원로그 저장 제약). Access Key 컬럼 40개 초과 불가. SQLIO SQL TEXT 30,000 Bytes 초과 불가.
- n-KESA Detail: DBIO Unit 사용 불가 케이스: LOB 데이터(blob, clob) 타입 컬럼 포함 테이블, 타 DB 테이블 CUD. 이 경우 DU를 통해 CUD 처리 (프레임워크 팀과 사전 협의). 단, DU를 통해 CUD 처리하는 경우 해당 테이블은 24*365 보정/반영 대상에서 제외.
- Mapping Rule: z-KESA 컬럼 수/크기 제약 → n-KESA 동일 테이블 사용 시 LOB 컬럼 유무 확인 후 DBIO Unit 또는 DU 선택. SQLIO SQL TEXT 크기 제약 → XSQL에서는 제약 없음.

---

## 19. DB Assist / SQL Test

### [Tooling] - DB Assist / SQL 자동생성 도구

- z-KESA: BMS의 SQLIO 관리화면 (SQL 직접 입력, SQL 키워드 자동입력, SQL 검증/IO 분석, 쿼리 실행 TAB)
- n-KESA: NEXCORE IDE의 DB Assist 메뉴 ([개발도구] → [NEXCORE] → [Java] → [DB Assist])
- z-KESA Detail: BMS SQLIO 관리화면: SQL 직접 입력 또는 키워드 탭에서 더블클릭 자동 입력. 테이블명 직접 입력 → 컬럼정보 조회 → 컬럼명/영문명 더블클릭 시 SQL 입력창 자동 입력. [SQL 검증/IO 분석]: SQL 문법 검증, 입/출력 매핑 정보 자동 분석, 출력 매핑 자동 입력. 한 라인 66 BYTE 초과 불가. 검증 완료 후 소스생성.
- n-KESA Detail: DB Assist: 테이블 선택 → 마우스 우클릭 → SQL 유형 선택 → 기본 SQL 클립보드 복사 → SQL 편집기에 Ctrl-V. JOIN: 여러 테이블 선택 후 JOIN SQL 자동 생성. Drag and Drop: SQL 편집기로 드래그 시 SQL 생성 선택. DB Assist는 DU의 SELECT(조회)에 한정. DBIO에 사용 불가. SQL 테스트: SQL 문장 정보의 테스트 버튼 → 바인드변수 입력 창 → SQL 수행 → 결과 표시. 실행계획(PLAN): db2expln 명령어 결과 표시. 입력/변경/삭제 쿼리 테스트 시 트랜잭션 커밋 여부 선택.
- Mapping Rule: z-KESA BMS SQLIO 관리화면 SQL 작성/검증 → n-KESA NEXCORE DB Assist + XSQL 편집기. IO 분석(입출력 매핑 자동) → XSQL AS "alias" 선언 + param.put() 패턴. 소스생성 버튼 → n-KESA IDE 저장 시 자동 적용.

---

## 20. Summary Quick-Reference Table

```
z-KESA 개념                    | n-KESA 대응
-------------------------------|------------------------------------------
DBIO 프로그램 (RHC0014 등)     | DBIO Unit 클래스 (DBIO_TKHC0014_00)
SQLIO 프로그램 (QFA0308 등)    | DataUnit + XSQL 파일 (*.xsql)
COPY YCDBIOCA.                 | (제거) — 메소드 파라미터로 대체
COPY YCDBSQLA.                 | (제거) — dbSelect* API로 대체
COPY TKxxyyyy. (KEY 카피북)    | (제거) — param.put("컬럼명", 값)
COPY TRxxyyyy. (RECORD 카피북) | (제거) — IRecord.getString("컬럼명")
COPY XQxxyyyy. (SQLIO 카피북)  | (제거) — XSQL #바인드변수# + AS "alias"
#DYDBIO SELECT-CMD-N ...       | dBIO.select() 또는 dbSelectSingle()
#DYDBIO SELECT-CMD-Y ...       | dBIO.lockSelect() / SELECT FOR UPDATE
#DYDBIO INSERT-CMD-Y ...       | dBIO.insert() 또는 dbInsert()
#DYDBIO UPDATE-CMD-Y ...       | dBIO.update() 또는 dbUpdate()
#DYDBIO DELETE-CMD-Y ...       | dBIO.delete() 또는 dbDelete()
#DYDBIO DELFRC-CMD-Y ...       | dbDelete() (시스템컬럼 조건 제외)
#DYDBIO OPEN-CMD-n ...         | (제거) — dbSelect() 한 번에 대체
#DYDBIO FETCH-CMD-n ...        | rs.getRecord(i) 순회
#DYDBIO CLOSE-CMD-n ...        | (제거) — IRecordSet 자동 관리
#DYSQLA QFA0308 XQFA0308-CA   | dbSelect("sqlId", param, onlineCtx)
DBSQL-SELECT-REQ               | dbSelectPage() pageNo/rowPerPage
DBSQL-SELECT-CNT               | rs.getRecordCount()
COND-DBIO-OK (결과코드 00)     | 예외 미발생 / rows > 0
COND-DBIO-MRNF (결과코드 02)   | record == null 또는 rows == 0
COND-DBIO-DUPM (결과코드 01)   | SQLExceptionUtils.isDuplicateKey(de)
DBIO-SQLCODE / DBSQL-SQLCODE   | SQLExceptionUtils.getSQLErrorCode(de)
#ERROR [errCd] [trtCd] [stat]  | throw new BusinessException(errCd, trtCd)
#MULERR START/#ERROR/#MULERR END | addBusinessException(errCd, trtCd, ctx)
#CSTMSG CO-USRMSG              | new BusinessException(..., customMsg, ...)
SQLCODE = -803 (중복)          | SQLExceptionUtils.isDuplicateKey(de)
SQLCODE = ZERO (정상)          | 예외 미발생
SELECT-GRn-Y / UPDATE-GRn-Y   | 부분 컬럼 XSQL SQL ID 별도 작성
SELFST-CMD-n                   | dbSelectSingle() + FETCH FIRST 1 ROW ONLY
LKUPDT-CMD-Y                   | lockSelect DBM + update DBM 순서
DELFRC-CMD-Y                   | dbDelete() (시스템컬럼 조건 미포함)
BPG 소스생성 (DBIO/SQLIO)      | NEXCORE 위저드 [DBIO/데이터유닛 생성]
ISOLATION(UR) Bind              | XSQL WITH UR (필요 시만 사용)
ISOLATION(CS) Bind              | 프레임워크 기본 READ_COMMITTED 적용
FOR UPDATE OF (COBOL Cursor)   | SELECT ... FOR UPDATE WITH RS (DB2 XSQL)
Multi-Row Batch INSERT (DB2)   | dbExecuteBatch() + addBatch()
주기적 COMMIT (Batch)          | DbBatchModeExecutor array 크기 제어
```