# 03. 배치 프로세싱 매핑



---

## z-KESA → n-KESA Batch Processing Framework Mapping (Complete)

---

### [01] Program Structure - Batch Main Program Unit

- z-KESA: `Batch Main PGM` (COBOL program, PROGRAM-ID: `BXX****`)
- n-KESA: `BatchUnit` (`com.kbstar.sqc.batch.base.BatchUnit` 상속 클래스, `@BizBatch("설명")` 애너테이션)
- z-KESA Detail:
  - IDENTIFICATION DIVISION / PROGRAM-ID 선언으로 메인 배치 프로그램 정의
  - 처리유형 주석을 `BATCH`로 기술
  - PROCEDURE DIVISION에서 S0000-MAIN-RTN → S1000-INITIALIZE-RTN → S2000-VALIDATION-RTN → S3000-PROCESS-RTN → S9000-FINAL-RTN 순서로 PERFORM 호출
  - 프로그램 명명규칙: `B` + 어플리케이션코드(2) + 프로그램식별번호(4) → `BXX@@@@`
- n-KESA Detail:
  - `BatchUnit` 클래스를 상속하여 Java 클래스로 작성
  - 메소드 구조: `beforeExecute()` (선처리/초기화) → `execute()` (본처리) → `afterExecute()` (후처리, 에러 여부 무관하게 항상 실행)
  - 프로그램 명명규칙: `BU` + [명사형] (예: `BUAcnInqury`)
  - `@BizBatch("배치 한글명")` 애너테이션 필수
- Mapping Rule:
  - COBOL `S0000-MAIN-RTN` → Java `execute()` 메소드
  - COBOL `S1000-INITIALIZE-RTN` → Java `beforeExecute()` 메소드
  - COBOL `S9000-FINAL-RTN` / `#OKEXIT CO-STAT-OK` → Java `execute()` 정상 리턴 (exit code 0)
  - COBOL `S8000-ERROR-RTN` / `#OKEXIT CO-STAT-ERROR` → Java `throw new BusinessException(...)` (execute()에서 Exception throw → End Fail 처리)
  - `S2000-VALIDATION-RTN` (입력 검증) → `beforeExecute()` 내 검증 로직으로 이동 (여기서 Exception 발생 시 execute()는 실행되지 않음)

---

### [02] Program Structure - Batch Sub Program

- z-KESA: `Batch Sub PGM` (COBOL program, 처리유형 `BATCHSUB`, 명명규칙 `Batch Main PGM과 동일`)
- n-KESA: 공유 FM(`FU****`) 또는 별도 `BatchStep` 클래스
- z-KESA Detail:
  - 2개 이상의 Batch Main 프로그램에서 공통으로 사용하는 기능만 분리 작성
  - 단순 편의를 위한 분리 금지 (Size 등)
  - 인터페이스 카피북 명명: `XB`로 시작 (`XB******-CA`)
  - `#DYCALL B******* YCCOMMON-CA XB******-CA` 로 호출
  - 결과 상태: `COND-XB******-OK` 조건 체크
- n-KESA Detail:
  - 온라인에서 작성한 공유 FM을 배치에서 재사용: `callSharedMethodByDirect("컴포넌트ID", "FU**.메소드명", dsReq)`
  - 배치 전용 공유 로직은 `BatchStep` 클래스로 분리 가능 (`BatchStep` 명명: `BS` + [명사형])
  - 배치 JVM 내에서 모듈 형태로 직접 호출(WAS 통신 아님)
- Mapping Rule:
  - COBOL `#DYCALL B******* YCCOMMON-CA XB******-CA` → Java `callSharedMethodByDirect(componentId, unitMethodId, dsReq)`
  - COBOL `IF NOT COND-XB******-OK` 에러체크 → Java try-catch로 BusinessException 처리
  - COBOL Sub PGM 인터페이스 카피북(XB-IN/XB-OUT) → Java `IDataSet` 요청/응답 객체
  - 온라인 공유 가능 공통 기능은 z-KESA의 Batch Sub PGM보다 n-KESA의 공유 FM 패턴이 더 우선

---

### [03] Program Structure - Batch Program Types

- z-KESA: OS Batch / 단순 Batch / Framework Batch (3종류)
- n-KESA: 단일 BatchUnit (단순/Framework 구분 없음, 프레임워크 기능 자동 제공)
- z-KESA Detail:
  - **OS Batch**: z-KESA 매크로/유틸리티 미사용, 순수 COBOL+OS 기능, SAM File 단순 처리
  - **단순 Batch**: z-KESA 매크로/유틸리티 사용, DB 갱신 없음(Select Only), Commit 관리 불필요
  - **Framework Batch**: Batch Framework 관리기능 필수 사용, DB 갱신 수반, Restart/Commit 관리 필요. ZUGBTIN(초기화 유틸), ZUGBTCN(진행정보 유틸) 호출 필수
- n-KESA Detail:
  - 단일 `BatchUnit` 패턴으로 통합. 배치 프로파일(BatchProfile)에 커밋주기, 로그레벨 등 속성 등록
  - DB 갱신 시: `txBegin()` / `txCommit()` / `txRollback()` 명시적 호출
  - Restart/중간값 저장: `saveValue()` / `loadValue()` API 사용 (프레임워크 내부 테이블에 자동 관리)
  - 진행률 모니터링: `context.setProgressTotal()` / `context.setProgressCurrent()` API
- Mapping Rule:
  - z-KESA OS Batch → n-KESA 단순 BatchUnit (파일 처리만, DB 없음)
  - z-KESA 단순 Batch → n-KESA BatchUnit (Select + 파일, txBegin/Commit 없이)
  - z-KESA Framework Batch → n-KESA BatchUnit + `AutoCommitRecordHandler` + `saveValue/loadValue` + `context.setProgress***`
  - z-KESA ZUGBTIN 초기화 유틸 호출 → n-KESA `beforeExecute()` + `context.getBatchProfile()` (프레임워크가 자동 처리)
  - z-KESA ZUGBTCN 진행정보 유틸 호출(COMMIT) → n-KESA `txCommit()` 또는 `AutoCommitRecordHandler.setCommitCount()`

---

### [04] Execution Environment - Batch JCL

- z-KESA: JCL (Job Control Language) - `//Txxxxxxx JOB ... //STEP1 EXEC JZBDEXEC,MBR=Bxxxxxx`
- n-KESA: Shell Script (`.sh` 파일) + Control-M Job 등록
- z-KESA Detail:
  - 표준 실행 JCL Procedure: `JZBDEXEC` (일반), `JZBDEXED` (디버그, IP 인자 추가)
  - JCL 구조: JOB 문 → STEP(EXEC) 문 → DD 문(INFILE, OUTF, SYSIN)
  - 다단계 STEP 조건: `COND=(4,LT,STEP1.RC)` 형태로 앞 단계 리턴코드 조건 체크
  - 컴파일 JCL Procedure: `JZBDBATC` (일반), `JZBDBATD` (디버그 모드)
  - JCL ID 명명규칙: 구분자(M/T) + 어플리케이션코드(3) + 작업주기구분자(1) + User Defined(3)
- n-KESA Detail:
  - 배치 실행 쉘 파일: `{배치ID}.sh` (예: `tedu0001.sh`). 배치 ID는 8자리, .sh 제외
  - 쉘 파일 내 `NC_PARAM1=KEY=VALUE` 형태로 파라미터 설정
  - 쉘 파일 내 `NC_BATCH_CLASS1=패키지.클래스명[쓰레드수]` 로 배치 프로그램 클래스 지정
  - Control-M에 Job 등록, PARM1/PARM2/... 형태로 argument 전달
  - 멀티 프로세스: 쉘 파일 복제 후 각각 Control-M Job 등록
- Mapping Rule:
  - JCL `//STEP1 EXEC JZBDEXEC,MBR=Bxxxxxx` → Shell `.sh` 파일 실행 (`NC_BATCH_CLASS1=패키지.클래스명`)
  - JCL `COND=(4,LT,STEP1.RC)` 다단계 STEP 조건 → Control-M Job 선후행 조건 설정
  - JCL `//SYSIN DD *` SYSIN 카드 → Shell 파라미터 (`NC_PARAM1=KEY=VALUE`) 또는 Control-M argument
  - JCL `//INFILE DD DSN=xxx` → Shell `NC_PARAM1=INPUT_FILE=/fsfile/xxx/파일명` 파라미터
  - JCL `//OUTF DD DSN=xxx` → Shell `NC_PARAM1=OUTPUT_FILE=/fsfile/xxx/파일명` 파라미터
  - JZBDBATC/JZBDBATD Compile JCL → IDE(개발도구) "로컬배포" 또는 형상관리 반입 후 자동 빌드/배포

---

### [05] Batch Execution Registration - 기본정보 등록

- z-KESA: BMS(BTM) 화면을 통한 Batch 기본정보 등록 (적용일자, 단위완료건수, 건수명, 항목명 등)
- n-KESA: 관리콘솔(배치 프로파일 등록)
- z-KESA Detail:
  - 적용일자: 해당 프로그램 수행 가능한 최초일자
  - 단위완료건수: Commit 처리 건수 (몇 건당 Commit할지)
  - 건수명(최대 20개), 항목명(최대 20개): 집계용 건수/금액 명칭 등록
  - Framework Batch 프로그램에만 해당
- n-KESA Detail:
  - 관리콘솔 → [배치] → [배치 프로파일] 에서 배치 ID 단위로 등록
  - 배치 ID: 쉘 파일명(8자리, .sh 제외) = Control-M JobName
  - 배치 프로파일 속성: 로그레벨, 담당자, 커밋주기(`getCommitCount()`), 건수금액기록여부 등
  - 로컬 테스트 시 배치 프로파일 없으면 null → null 체크 필수
  - `context.getBatchProfile().getCommitCount()` 로 조회
- Mapping Rule:
  - z-KESA 단위완료건수 → n-KESA `BatchProfile.getCommitCount()` → `AutoCommitRecordHandler.setCommitCount()`
  - z-KESA 건수명/항목명 → n-KESA `context.addSuccessCountAmount(count, amount)` / `context.addErrorCountAmount(count, amount)` API
  - z-KESA BMS 화면 등록 → n-KESA 관리콘솔 배치 프로파일 등록 (서버 배치 실행 전 필수)

---

### [06] Parameter Handling - SYSIN 파라미터

- z-KESA: JCL `//SYSIN DD *` 카드 + `ACCEPT WK-SYSIN FROM SYSIN`
- n-KESA: Shell 파일 `NC_PARAMn=KEY=VALUE` + `context.getInParameter("KEY")`
- z-KESA Detail:
  - WORKING-STORAGE SECTION에 `01 WK-SYSIN` 구조체 선언
  - 필수 항목: `WK-SYSIN-ORG-CD`(그룹회사코드), `WK-SYSIN-WORK-BSD`(작업수행기준일자), `WK-SYSIN-JOB-NAME`(작업명), `WK-SYSIN-DL-TN`(처리회차), `WK-SYSIN-BTCH-KN`(배치작업구분: NORBAT/ONLBAT), `WK-SYSIN-EMP-NO`(작업자 ID)
  - `ACCEPT WK-SYSIN FROM SYSIN` 으로 입력값 취득
  - Framework Batch는 위 항목들을 ZUGBTIN 유틸리티에 MOVE하여 전달 필수
- n-KESA Detail:
  - 개별 파라미터: Shell 파일 `NC_PARAM1=MY_KEY=value1` → `context.getInParameter("MY_KEY")`
  - Command Line Argument: Control-M PARM1/PARM2 → `context.getInParameter("ARG1")` / `context.getInParameter("ARG2")`
  - 내장 파라미터(프레임워크 자동 설정): `DATE`(YYYYMMDD), `TIME`(HHMMSS), `DATETIME`, `PROC_DATE`(Control-M ODATE), `JOB_ID`, `JOB_INS_ID`, `JOB_EXE_ID`, `THREAD_NO`, `THREAD_COUNT`, `NEXCORE_HOME`, `DATA_ROOT`, `EXE_SEQ`(실행횟수)
  - 전역 파라미터: 관리콘솔에서 전체 배치에 공통 설정 (예: `CHGLOG_ROOT`, `DATA_ROOT`)
  - 파라미터 치환: `${변수명}` (Shell 환경변수), `\${변수명}` (프레임워크 내장 파라미터 지연 치환)
- Mapping Rule:
  - `WK-SYSIN-WORK-BSD` (작업수행기준일자) → `context.getInParameter("PROC_DATE")` (Control-M ODATE) 또는 별도 Shell 파라미터
  - `WK-SYSIN-JOB-NAME` (작업명/JOB NAME) → `context.getInParameter("JOB_ID")` (Control-M JobName)
  - `WK-SYSIN-DL-TN` (처리회차) → `context.getInParameter("EXE_SEQ")` (실행횟수, 2이상이면 재처리)
  - `WK-SYSIN-BTCH-KN` (NORBAT/ONLBAT) → `context.getInParameter("OPER_TYPE")` ("OND"이면 온디맨드 배치)
  - `WK-SYSIN-ORG-CD` (그룹회사코드) → 자동 바인드 변수 `groupCoCd` (프레임워크 자동 처리) 또는 Shell 파라미터
  - `WK-SYSIN-EMP-NO` (작업자 ID) → 자동 바인드 변수 `sysLastUno` 또는 CommonArea 설정

---

### [07] Parameter Handling - Return Code / 종료처리

- z-KESA: `#OKEXIT 리턴코드` 매크로
- n-KESA: `execute()` 메소드의 Exception throw 여부 / `context.setReturnCode(int)`
- z-KESA Detail:
  - `#OKEXIT CO-STAT-OK` ('00'): 정상종료
  - `#OKEXIT CO-STAT-08` ('08'): 다음 STEP 처리 불가, Restart 불가한 심각한 에러
  - `#OKEXIT CO-STAT-ERROR` ('01'~'08'): 에러종료, Rollback 처리 (`04` 초과 시)
  - `#OKEXIT CO-STAT-STOP` ('16'): 오퍼레이터에 의한 일시 정지 중단
  - `MOVE '00' TO RETURN-CODE. GOBACK.` (OS Batch 정상종료)
- n-KESA Detail:
  - 정상종료: `execute()` 메소드 정상 리턴 → JVM exit 0
  - 에러종료: `execute()` 에서 `throw new BusinessException(...)` → JVM exit 1 (기본값)
  - 임의 리턴코드: `context.setReturnCode(int exit)` (운영 환경에서 임의 사용 금지)
  - Control-M/JAS에서 exit 값에 따라 성공/실패 판단
- Mapping Rule:
  - `#OKEXIT CO-STAT-OK` → `execute()` 메소드 정상 리턴
  - `#OKEXIT CO-STAT-ERROR` / `CO-STAT-08` → `throw new BusinessException("에러코드", "조치코드", "메시지", e)`
  - `#OKEXIT CO-STAT-STOP` → 루프 배치 종료 처리 (while 루프 break 또는 정상 리턴)

---

### [08] Variable Declaration - WORKING-STORAGE

- z-KESA: `WORKING-STORAGE SECTION` (COBOL DATA DIVISION)
- n-KESA: Java 클래스 멤버 필드 선언
- z-KESA Detail:
  - 상수형 변수: `CO-` prefix
  - Work 변수: `WK-` prefix
  - 파일 상태 변수: `IN-FILE-ST PIC X(002)`
  - PIC 절로 데이터 타입과 길이 정의: `PIC X(008)`, `PIC 9(005)`, `PIC S9(005) LEADING SEPARATE`
  - `01 CO-AREA`, `01 WK-AREA` 구조체로 관리
- n-KESA Detail:
  - Java 클래스 필드: `private Log log;`, `private BatchProfile profile;`, `private int commitCount;`
  - 파일 관련 필드: `private String inFilename;`, `private InputStream fileInStream;`, `private IFileTool fileToolRead;`
  - 초기화: `beforeExecute()` 메소드 내에서 `context.getLogger()`, `context.getBatchProfile()` 등으로 초기화
- Mapping Rule:
  - COBOL `PIC X(n)` String 변수 → Java `String`
  - COBOL `PIC 9(n)` 숫자 변수 → Java `int` / `long`
  - COBOL `PIC S9(n)V9(m)` 소수 변수 → Java `double` / `BigDecimal`
  - COBOL `01 WK-AREA` 구조체 → Java 클래스 멤버 필드들로 분리
  - COBOL `INITIALIZE WK-AREA` → Java 멤버 필드 초기값 설정 (`beforeExecute()` 내)

---

### [09] File I/O - File Definition (파일 정의)

- z-KESA: `ENVIRONMENT DIVISION / FILE-CONTROL` + `DATA DIVISION / FILE SECTION / FD`
- n-KESA: FIO 파일(`.fio`) 레이아웃 정의 + `IFileTool`
- z-KESA Detail:
  - `FILE-CONTROL` 에서 `SELECT IN-FILE ASSIGN TO INFILE ORGANIZATION IS SEQUENTIAL ACCESS MODE IS SEQUENTIAL STATUS IS IN-FILE-ST`
  - `FILE SECTION` 에서 `FD IN-FILE RECORD VARYING ... RECORDING MODE V`
  - 레코드 구조: `01 IN-FILE-REC PIC X(1020)` 또는 카피북 COPY
  - SAM 파일용 카피북: BMS-BIM 카피북 관리 기능으로 생성
  - 파일 상태코드: 00(성공), 10(EOF), 35(파일없음), 22(키 중복) 등
- n-KESA Detail:
  - 개발도구 NEXCORE 탐색기 → FIO 노드 → "파일IO 생성"으로 `.fio` 파일 생성
  - FIO 파일에서: 파일 타입(고정길이/구분자-CSV), 인코딩(MS949/UTF-8), 필드명/타입/길이 정의
  - 고정길이: String 좌정렬+space 패딩, 숫자 우정렬+"0" 패딩
  - 구분자(CSV): Microsoft Excel CSV 규칙 준수, 기본 구분자 `,`, Wrapper `"`
  - EBCDIC 파일: `EBCDICFixedLenFileTool.from(getFileTool("FIO ID"))` 로 변환
  - 다중 레이아웃: 여러 개의 `IFileTool` 객체 생성, 하나의 `OutputStream` 공유
- Mapping Rule:
  - COBOL `FILE-CONTROL SELECT ... ASSIGN TO INFILE` → FIO 파일 생성 + `getFileTool("FIO ID")`
  - COBOL `FD IN-FILE RECORD VARYING` (가변길이) → FIO 파일 타입 "고정길이" + "뉴라인 사용 = true"
  - COBOL `RECORDING MODE V` → 레코드 간 개행문자 구분
  - COBOL `RECORDING MODE F` (고정길이) → FIO 파일 타입 "고정길이" + 고정 레코드 길이 설정
  - COBOL SAM 파일 카피북 (`Sxxxxxxx`) → FIO 파일의 컬럼 정의로 변환
  - COBOL 파일 상태코드 `10` (EOF) → Java 파일 스트림 EOF 자동 처리 (`readRecordSetFromInputStream` 내부)
  - COBOL EBCDIC SAM 파일 → n-KESA `EBCDICFixedLenFileTool` + NDM 바이너리 전송

---

### [10] File I/O - File Open/Close

- z-KESA: `OPEN INPUT IN-FILE` / `CLOSE IN-FILE` + 파일 상태 체크
- n-KESA: `fileOpenInputStream(filename)` / `fileOpenOutputStream(filename)` + 자동 close
- z-KESA Detail:
  - `OPEN INPUT IN-FILE`
  - `IF IN-FILE-ST NOT = CO-STAT-OK → #ERROR → PERFORM S8000-ERROR-RTN`
  - `CLOSE IN-FILE` (종료처리 루틴에서)
  - 파일 경로: JCL DD 문의 DSN으로 지정
- n-KESA Detail:
  - `this.fileInStream = fileOpenInputStream(this.inFilename)` → `beforeExecute()` 에서 수행
  - `this.fileOutStream = fileOpenOutputStream(this.outFilename)` → `beforeExecute()` 에서 수행
  - 이 메소드로 생성된 Stream은 프로그램 종료 시 자동 `close()` (명시적 close 권장은 `afterExecute()`에서)
  - 파일 경로: `context.getInParameter("INPUT_FILE")` 또는 `context.getInParameter("DATA_ROOT") + "/하위디렉토리/파일명"`
  - 표준 파일 경로: `/fsfile/어플리케이션코드` (`DATA_ROOT` 전역 파라미터)
  - `IFileTool.setInputStream(stream)` + `IFileTool.initialize()` 필수 호출
- Mapping Rule:
  - COBOL `OPEN INPUT IN-FILE` → Java `fileOpenInputStream(filename)` + `fileToolRead.setInputStream()` + `fileToolRead.initialize()`
  - COBOL `OPEN OUTPUT OUT-FILE` → Java `fileOpenOutputStream(filename)` + `fileToolWrite.setOutputStream()` + `fileToolWrite.initialize()`
  - COBOL 파일 DSN 경로(JCL DD 문) → Java 파라미터 `INPUT_FILE` / `OUTPUT_FILE` 또는 `makeDataFileName()` 메소드로 생성
  - COBOL `CLOSE` → Java `afterExecute()` 에서 명시적 `stream.close()` (또는 자동 close)

---

### [11] File I/O - File Read

- z-KESA: `READ IN-FILE INTO WK-REC AT END SET EOF-Y TO TRUE END-READ`
- n-KESA: `fileToolRead.readRecordSetFromInputStream(recordHandler)` (RecordHandler 콜백 방식)
- z-KESA Detail:
  - `READ 파일명 INTO 레코드변수 AT END SET EOF-Y TO TRUE END-READ`
  - EOF 체크 후 `PERFORM UNTIL EOF-Y` 반복 루프
  - 읽은 레코드를 WK 변수에 MOVE하여 가공
- n-KESA Detail:
  - `fileToolRead.readRecordSetFromInputStream(recordHandler)` → 매 레코드마다 `handleRecord(IRecord record)` 콜백
  - 건수 확인용: `DummyRecordHandler` 사용 후 `dummyHandler.getCalledCount()`로 전체 건수 파악
  - 단, DummyRecordHandler 실행 후 파일 재오픈 필요 (close → `fileOpenInputStream` → `initialize`)
  - 다중 레이아웃: `SAMFileTool.readToEol(bis, buffer)` 로 한 줄씩 읽어 구분자 판별 후 `fileToolRead.readRecordFromBytes(rs, buffer)` 로 파싱
- Mapping Rule:
  - COBOL `PERFORM ... UNTIL EOF-Y` 반복 READ 루프 → Java `readRecordSetFromInputStream(handler)` 내부에서 자동 반복
  - COBOL `READ ... AT END SET EOF-Y TO TRUE` → Java EOF 자동 처리 (스트림 종료 시 handler 완료)
  - COBOL 레코드 구조 REDEFINE으로 다중 레이아웃 → Java `SAMFileTool.readToEol()` + 구분자 분기 + 레이아웃별 `IFileTool`

---

### [12] File I/O - File Write

- z-KESA: `WRITE OUT-FILE-REC FROM WK-REC`
- n-KESA: `fileToolWrite.writeRecordToOut(record)` / `fileToolWrite.writeMapToOut(map)` / `fileToolWrite.writeRecordSetToOut(rs)`
- z-KESA Detail:
  - `WRITE 파일레코드명 FROM 변수` 로 1건씩 쓰기
  - 파일 버퍼 개념 없음(레코드 단위 즉시 쓰기)
  - 헤더/본문/트레일러 분리: 별도 FD로 파일 구조 정의 후 각각 WRITE
- n-KESA Detail:
  - `fileToolWrite.writeRecordToOut(record)` : IRecord 1건 쓰기 (대량 처리 시 이 메소드 사용)
  - `fileToolWrite.writeRecordSetToOut(rs)` : IRecordSet 전체 쓰기
  - `fileToolWrite.writeMapToOut(map)` : Map 객체 쓰기 (IRecord에 추가 컬럼 필요 시)
  - 단순 1:1 매핑(가공 없음): `SimpleFileWriteRecordHandler` 사용 → `dbSelect("select", sqlIn, new SimpleFileWriteRecordHandler(context, fileToolWrite), readSession)`
  - 다중 레이아웃 Write: 여러 `IFileTool` 객체 → 하나의 `fileOutStream`에 연결 → 레이아웃별 `writeRecordToOut()` 호출
- Mapping Rule:
  - COBOL `WRITE 레코드명 FROM 변수` (1건) → Java `fileToolWrite.writeRecordToOut(record)`
  - COBOL 헤더 레코드 WRITE → Java `fileToolWrite1.writeMapToOut(headerMap)` (`beforeExecute()` 또는 `execute()` 초반)
  - COBOL 트레일러 레코드 WRITE → Java `fileToolWrite3.writeMapToOut(trailerMap)` (handleRecord 완료 후)
  - COBOL 본문 반복 WRITE → Java handleRecord() 내 `fileToolWrite2.writeRecordToOut(record)`

---

### [13] DB Access - SQL 직접 사용

- z-KESA: `EXEC SQL ... END-EXEC` + `EVALUATE SQLCODE`
- n-KESA: XSQL 파일에 SQL 작성 + `dbInsert()` / `dbUpdate()` / `dbDelete()` / `dbSelect()` / `dbSelectSingle()` / `dbSelectMulti()`
- z-KESA Detail:
  - WORKING-STORAGE에 `EXEC SQL INCLUDE SQLCA END-EXEC` 선언
  - 테이블 카피북 `COPY THxxx0001` 로 호스트 변수 선언
  - `EXEC SQL SELECT ... INTO :변수 FROM ... WHERE ... END-EXEC`
  - `EVALUATE SQLCODE WHEN CO-OK ... WHEN CO-NOT-FOUND ... WHEN OTHER ... END-EVALUATE` 로 결과 체크
  - INSERT/UPDATE/DELETE 후 SQLCODE 체크 필수
  - Read-Only(SELECT Only)인 경우 직접 SQL 허용, CUD의 경우 원칙적으로 DBIO/SQLIO 사용
- n-KESA Detail:
  - 배치 프로그램 XSQL 노드에 SQL 작성 (배치 전체 SQL을 1개 XSQL 파일에 통합)
  - INSERT: `int cnt = dbInsert("sqlId", param)` (처리건수 리턴)
  - UPDATE: `int cnt = dbUpdate("sqlId", param)` (처리건수 리턴)
  - DELETE: `int cnt = dbDelete("sqlId", param)` (처리건수 리턴)
  - SELECT(대량): `dbSelect("sqlId", param, recordHandler)` 또는 `dbSelect("sqlId", param, handler, readSession)`
  - SELECT(단건): `IRecord rec = dbSelectSingle("sqlId", param)` (2건 이상 → Exception)
  - SELECT(소량): `IRecordSet rs = dbSelectMulti("sqlId", param)`
  - 자동 바인드 변수: `sysLastPrcssYMS`, `sysLastUno`, `groupCoCd` (프레임워크 자동 처리)
  - SQL fetch size: 대량 처리 시 100~1000으로 설정 권장
- Mapping Rule:
  - COBOL `EXEC SQL SELECT ... INTO :HOST_VAR END-EXEC` → Java `dbSelectSingle("sqlId", sqlIn)` + `rec.getString("컬럼명")`
  - COBOL `EXEC SQL INSERT INTO ... VALUES (:...) END-EXEC` → Java `dbInsert("sqlId", record)` 또는 `dbInsert("sqlId", map)`
  - COBOL `EVALUATE SQLCODE WHEN CO-NOT-FOUND` → Java `IRecord` null 체크 또는 `dbSelectMulti` 결과 건수 체크
  - COBOL `EVALUATE SQLCODE WHEN OTHER → #ERROR` → Java try-catch `DataException` / `BusinessException` throw
  - COBOL 호스트 변수 (`MOVE 값 TO :KJA201-GROUP-CO-CD`) → Java `sqlIn.put("컬럼명", 값)` Map에 put
  - COBOL `WITH UR` (Uncommitted Read) → XSQL 옵션 또는 DB 세션 분리로 대응

---

### [14] DB Access - DBIO/SQLIO 사용

- z-KESA: `DBIO` (DB Access Object, C/U/D), `SQLIO` (SQL 직접, R)
- n-KESA: 온라인 공유 FM/DM 호출 또는 배치 자체 XSQL
- z-KESA Detail:
  - CUD(Create/Update/Delete) 포함 시: `#DYCALL DBIO모듈 YCCOMMON-CA DBIO-CA`
  - 타 어플리케이션 테이블 CUD: 해당팀의 CUD용 모듈(DC/IC) 제공받아 사용
  - Read Only: 직접 SQL 또는 SQLIO 사용 가능
- n-KESA Detail:
  - 동일 어플리케이션 내 CUD: 배치 XSQL에서 직접 `dbInsert/dbUpdate/dbDelete`
  - 타 어플리케이션 테이블 CUD: 해당팀의 공유 FM 호출 → `callSharedMethodByDirect(...)`
  - `AutoCommitRecordHandlerWithDBIO`: RecordHandler 내부에서 DBIO(FM) 호출 시 동일 트랜잭션으로 Array 처리 가능
- Mapping Rule:
  - COBOL `#DYCALL DBIO모듈 YCCOMMON-CA DBIO-CA` → Java `callSharedMethodByDirect("컴포넌트", "DM.메소드", dsReq)` 또는 배치 직접 `dbInsert/dbUpdate/dbDelete`
  - COBOL DBIO 사용 패턴 → n-KESA `AutoCommitRecordHandlerWithDBIO` 사용 (DBIO 호출 포함 Array/Commit 처리)

---

### [15] DB Access - Select 대량 처리 (RecordHandler 패턴)

- z-KESA: `PERFORM UNTIL EOF-Y`: CURSOR OPEN → FETCH 루프 → CLOSE
- n-KESA: `dbSelect("sqlId", param, recordHandler)` + `AbsRecordHandler.handleRecord(IRecord)` 콜백
- z-KESA Detail:
  - `EXEC SQL DECLARE CURSOR FOR SELECT ... END-EXEC`
  - `EXEC SQL OPEN CURSOR END-EXEC`
  - `EXEC SQL FETCH CURSOR INTO :변수 END-EXEC` → `SQLCODE = +100`이면 EOF
  - `EXEC SQL CLOSE CURSOR END-EXEC`
  - 각 FETCH된 레코드를 WK 변수에 MOVE 후 처리
- n-KESA Detail:
  - `dbSelect("sqlId", sqlIn, makeHandler(), readSession)` 로 대량 조회
  - `AbsRecordHandler` 구현: `handleRecord(IRecord record)` 에서 레코드 처리
  - `preStartFetch()`: 첫 레코드 전 1회 호출
  - `postEndFetch()`: 전체 정상 완료 후 호출
  - `onFinally()`: 에러 여부 무관 항상 호출
  - handleRecord 내에서 IRecord를 List/Map에 저장 금지 (OutOfMemoryError 방지)
  - SELECT SQL의 출력 클래스: `hmap`(HashMap, 컬럼 순서 미보장) 또는 `java.util.LinkedHashMap`(순서 보장)
- Mapping Rule:
  - COBOL CURSOR DECLARE/OPEN/FETCH/CLOSE 구조 → Java `dbSelect()` + `AbsRecordHandler` (프레임워크가 JDBC Cursor 처리 내부화)
  - COBOL `FETCH → SQLCODE +100 (EOF)` → Java handler 자동 종료 (더 이상 fetch 없으면 `postEndFetch()` 호출)
  - COBOL `MOVE CURSOR-COL TO WK-변수` → Java `record.getString("컬럼명")` / `record.getLong("컬럼명")` 등
  - COBOL 중간 정지(`GO TO S3000-PROCESS-EXT`) → Java `stopImmediately()` 호출

---

### [16] DB Access - Transaction Commit Pattern (중간 Commit)

- z-KESA: `EXEC SQL COMMIT END-EXEC` 직접 발행 (단순 Batch) 또는 ZUGBTCN 유틸 호출 (`XZUGBTCN-COMMIT`, Framework Batch)
- n-KESA: `txBegin()` / `txCommit()` / `txRollback()` 명시적 호출 또는 `AutoCommitRecordHandler.setCommitCount()`
- z-KESA Detail:
  - 단순 Batch: `EXEC SQL COMMIT END-EXEC` + `EVALUATE SQLCODE WHEN ZERO CONTINUE WHEN OTHER → #ERROR`
  - Framework Batch: `SET XZUGBTCN-COMMIT TO TRUE` → `#DYCALL ZUGBTCN YCCOMMON-CA XZUGBTCN-CA`
    - Commit 발행 주기: 프레임워크 기본정보의 `단위완료건수` 기준으로 자동 판단
    - ZUGBTCN 매건 호출해도 단위완료건수 충족 시에만 실제 Commit 발행
  - 권장 Commit 주기: 1,000~2,000건당 1회
  - DB SELECT Only인 경우 Commit 불필요
  - Framework Batch에서 직접 `EXEC SQL COMMIT` 발행 금지 (ZUGBTCN을 통해서만)
- n-KESA Detail:
  - 수동 Commit 패턴: `txBegin()` → 처리 → `txCommit()` (pair로 작성 필수)
  - 중간 Commit 패턴: handleRecord 내 `if (getCurrentSize() % commitCount == 0)` → `dbExecuteBatch()` → `txCommit()` → `dbStartBatch()`
  - AutoCommitRecordHandler 자동 Commit: `handler.setCommitCount(commitCount)` 설정으로 프레임워크 자동 관리
  - `txBegin/txCommit` 없이 DML 수행 시 트랜잭션 처리 안됨 (주의)
  - `AutoCommitRecordHandler.handleRecord()` 내부에서는 `txBegin/txCommit` 사용 금지 (프레임워크 내부 관리)
- Mapping Rule:
  - z-KESA `EXEC SQL COMMIT END-EXEC` (단순) → n-KESA `txCommit()`
  - z-KESA ZUGBTCN `XZUGBTCN-COMMIT` 호출 → n-KESA `AutoCommitRecordHandler.setCommitCount(n)` (프레임워크 자동)
  - z-KESA `단위완료건수` (BMS 등록) → n-KESA `BatchProfile.getCommitCount()` → `handler.setCommitCount()`
  - z-KESA ZUGBTCN `XZUGBTCN-COMMITALL` (최종 Commit) → n-KESA `txCommit()` 또는 `postEndFetch()`에서의 최종 commit
  - z-KESA ZUGBTCN `XZUGBTCN-STOP` (중단 Commit) → n-KESA `txCommit()` 후 루프 break

---

### [17] DB Access - Array Processing (대량 DML)

- z-KESA: DB2의 Array 처리 (명시적 기술 없음, DBIO 내부에서 처리)
- n-KESA: `dbStartBatch()` / `dbInsert("sqlId", param)` 반복 / `dbExecuteBatch()` + `txCommit()`; `AutoCommitRecordHandler.setAddBatchMode(true)`
- z-KESA Detail:
  - z-KESA Framework에서는 DBIO를 통한 일괄처리로 성능 향상
  - 명시적인 Array insert 패턴은 COBOL 레벨에서 직접 노출되지 않고 DBIO 내부에서 처리
- n-KESA Detail:
  - `dbStartBatch()` ~ `dbExecuteBatch()` 구간이 PreparedStatement.addBatch() 처리 구간
  - `dbInsert()` 호출 시 메모리에 bind 변수 적재, `dbExecuteBatch()` 호출 시 일괄 실행
  - 권장 array 크기: 1,000건 이하 (JVM Heap 메모리 고려)
  - `AutoCommitRecordHandler.setAddBatchMode(true)`: 자동으로 addBatch 방식 처리
  - addBatch 중 handleRecord 내 `dbInsert` 후 `dbSelect` 불가 (미실행 상태이므로 조회 불가)
  - addBatch 중 FM/DM 호출 시 array 처리 미적용 → 직접 `dbInsert/dbUpdate` 호출 필요
  - 동일 PK에 대해 delete + insert 시 addBatch 사용 금지 (PK 중복 에러 가능)
- Mapping Rule:
  - z-KESA 대량 DBIO CUD → n-KESA `dbStartBatch()` + 반복 `dbInsert()` + `dbExecuteBatch()` + `txCommit()`
  - z-KESA DBIO 일괄처리 → n-KESA `AutoCommitRecordHandler.setAddBatchMode(true)` + `setCommitCount(n)`

---

### [18] Restart/Checkpoint Processing (재처리)

- z-KESA: Batch 초기화 유틸리티 `ZUGBTIN` + 최종처리 Key `WK-LSDL-KEY` + SKIP 로직
- n-KESA: `saveValue("KEY", value)` / `loadValue("KEY")` + `isRetryMode()` + `handler.setTargetRecordRange(start, end)`
- z-KESA Detail:
  - Framework Batch만 해당 (단순 Batch는 자체 구현 또는 입력 데이터 재생성)
  - `XZUGBTIN-O-LSDL-KEY`: 최종 처리 Key (ZUGBTIN 초기화 유틸 출력, 최대 200byte)
  - `WK-LSDL-KEY REDEFINES`로 세부 구조 정의 (예: `WK-START-C PIC 9(012)`)
  - ZUGBTCN 호출 시 `XZUGBTCN-I-LST-DL-KEY`에 현재 처리 Key SET → 내부적으로 저장
  - 재처리 시: `WK-LSDL-KEY = CO-CHA-SPACE` → 최초 실행, 값 있으면 → 이전 처리분 SKIP
  - SKIP 예시: `PERFORM READ-RTN UNTIL WK-C > WK-LSDL-C`
- n-KESA Detail:
  - `saveValue("SUCC_POSITION", currentIdx+"")`: 중간 commit 시점마다 위치 저장 (프레임워크 내부 테이블)
  - `loadValue("SUCC_POSITION")`: 이전 실행에서 저장된 위치 조회
  - `isRetryMode()`: `EXE_SEQ >= 2` 이면 true (Control-M rerun 시)
  - `handler.setTargetRecordRange(startPosition, Long.MAX_VALUE)`: 재처리 시작 위치 설정
  - `AutoCommitRecordHandler.setSaveValueKey("SUCC_POSITION")`: 중간 commit마다 자동 saveValue
  - 값 유효 범위: Job Instance 단위 (동일 Order rerun 공유, 새 Order는 별도)
  - 재처리 전제: 원본 데이터(SELECT 결과 또는 파일)가 두 실행 간 동일해야 함
- Mapping Rule:
  - z-KESA `ZUGBTIN` 초기화 후 `XZUGBTIN-O-LSDL-KEY` 취득 → n-KESA `loadValue("KEY")`
  - z-KESA `ZUGBTCN` 호출 시 `XZUGBTCN-I-LST-DL-KEY` SET → n-KESA `saveValue("KEY", value)` 또는 `setSaveValueKey()` 자동
  - z-KESA `WK-LSDL-KEY = SPACE` (최초) 분기 → n-KESA `isRetryMode()` false 분기
  - z-KESA SKIP 루프(`PERFORM READ UNTIL WK-C > WK-LSDL-C`) → n-KESA `handler.setTargetRecordRange(startPos, Long.MAX_VALUE)` (내부적으로 skip 처리)
  - z-KESA `WK-LSDL-KEY`의 200byte 구조 → n-KESA `saveValue("KEY", String값)` (String 자유 형식)
  - z-KESA 처리회차(`WK-SYSIN-DL-TN`) → n-KESA `context.getInParameter("EXE_SEQ")`

---

### [19] Error Handling in Batch

- z-KESA: `#ERROR 에러코드 조치코드 리턴코드` 매크로 + `S8000-ERROR-RTN` 공통 에러처리 루틴 + `ZUGBTCN ERROR` 호출
- n-KESA: `throw new BusinessException(에러코드, 조치코드, 메시지, e)` + `log.error(...)` + `AutoCommitRecordHandler.handleErrorRecord()` / `handleErrorRecordBlock()`
- z-KESA Detail:
  - `#ERROR 에러코드 조치코드 리턴코드` 발행 → ZUGEROR 프로그램 호출 → `XZUGEROR-I-MSG` 에 메시지 조립 후 SYSOUT 출력
  - 에러코드 체계: `E`/`U` + `BM`(Main)/`BS`(Sub) + 오류루틴번호(01~92) + 식별번호(3자리)
    - 01: 초기화처리, 02: INPUT File/DB 입력, 03: 내부 본처리, 04: OUTPUT File/DB 출력, 05: 종료처리, 91: ZUGBTIN 호출, 92: ZUGBTCN 호출
  - Batch Main에서 #ERROR 발행해도 프레임워크가 GOBACK하지 않고 다음 STEP 수행
  - 반드시 `#OKEXIT 리턴코드`로 명시적 종료 처리
  - Framework Batch: `SET XZUGBTCN-ERROR TO TRUE` → ZUGBTCN 호출하여 에러 정보 축적 및 오류종료 요구
  - DISPLAY 메시지 형식: 에러 = `UKB09001E JOBNAME-PGMNAME-에러코드-내용`, 정상 = `UKB00001I JOBNAME-PGMNAME-고유번호-내용`
- n-KESA Detail:
  - `throw new BusinessException("에러코드", "조치코드", "메시지", e)` → `execute()` 에서 throw 시 배치 End Fail
  - 전행공통 메시지 관리에 에러코드 등록 후 사용
  - `log.error("에러 로그", e)`: log API로 에러 로깅
  - `AutoCommitRecordHandler.setStopWhenException(true)`: 에러 시 즉시 중단 (해당 블록 Rollback)
  - `AutoCommitRecordHandler.setStopWhenException(false)`: 에러 발생해도 계속 진행 (해당 블록 Rollback 후 다음 블록)
  - `handleErrorRecord(IRecord record, long position, Throwable e)`: `retryForDetailPosition=true` 시 에러 레코드 단건 콜백 (자동 begin/commit)
  - `handleErrorRecordBlock(List<IRecord> block, long start, long end, Throwable e)`: `retryForDetailPosition=false` 시 에러 블록 콜백 (수동 트랜잭션)
  - 에러 발생 블록 조회: `handler.getErrorBlockIdxList()` (long[] 배열 리스트: [시작인덱스, 끝인덱스])
  - addBatch 에러 상세: `SQLExceptionUtils.getBaseSQLException(e)` + `se.getNextException()` 반복으로 상세 에러 조회
- Mapping Rule:
  - z-KESA `#ERROR EBM01001 UBM010001 CO-STAT-ERROR` → n-KESA `throw new BusinessException("EBM01001", "UBM010001", "메시지", e)`
  - z-KESA `PERFORM S8000-ERROR-RTN` 공통 에러처리 루틴 → n-KESA `catch(Exception e) { log.error(...); throw new BusinessException(...); }`
  - z-KESA ZUGBTCN `XZUGBTCN-ERROR` 호출 → n-KESA `BusinessException` throw (프레임워크가 배치 End Fail 처리)
  - z-KESA `DISPLAY 'UKB09001E JOBNAME-PGMNAME-에러코드'` → n-KESA `log.error(...)` (로그 파일에 기록)
  - z-KESA 리턴코드 '04'~'16' 범위 → n-KESA `context.setReturnCode(int)` (운영 환경에서 임의 변경 금지)

---

### [20] Error Handling - retryForDetailPosition 패턴

- z-KESA: ZUGBTCN의 재처리(Restart) 로직으로 에러 레코드 Skip 후 재처리
- n-KESA: `AutoCommitRecordHandler.setRetryForDetailPosition(true)` + `handleErrorRecord()` 또는 `handleErrorRecordBlock()`
- z-KESA Detail:
  - 에러 발생 블록의 레코드를 건건이 재시도하는 개념은 없음
  - 에러 발생 시 해당 JOB STEP 종료 후 다음 JOB에서 Restart Key로 재시작
- n-KESA Detail:
  - `retryForDetailPosition=true`: 에러 블록 Rollback 후 블록 내 레코드를 건건이 재실행하여 정상 건 commit, 에러 건만 `handleErrorRecord()` 콜백
  - `retryForDetailPosition=false`: 에러 블록 Rollback 후 `handleErrorRecordBlock()` 콜백 (수동 처리)
  - 이 기능 사용 시 `handleRecord()`가 중복 호출됨에 주의 (파일 Write 등 비DB 작업 중복 위험)
- Mapping Rule:
  - z-KESA 에러 후 다음 JOB에서 재처리(Restart) → n-KESA `setRetryForDetailPosition(true)` + 동일 JOB 내 에러 블록 자동 재시도
  - z-KESA 에러 레코드 별도 에러 파일 기록 → n-KESA `handleErrorRecord()` 내에서 별도 에러 테이블 INSERT 또는 파일 write

---

### [21] Batch Initialization - 배치 기본정보 초기화

- z-KESA: `ZUGBTIN` (Batch 초기화 유틸리티) 호출: `#DYCALL ZUGBTIN YCCOMMON-CA XZUGBTIN-CA`
- n-KESA: `beforeExecute()` 내에서 `context.getBatchProfile()`, `context.getLogger()` 등 프레임워크 자동 초기화
- z-KESA Detail:
  - `COPY XZUGBTIN` 카피북 선언 → `INITIALIZE XZUGBTIN-CA` → 입력 SET → `#DYCALL ZUGBTIN`
  - 입력: `XZUGBTIN-I-PGID`(프로그램ID), `XZUGBTIN-I-GR-CO-CD`(그룹회사코드), `XZUGBTIN-I-WORK-BSD`(작업기준일), `XZUGBTIN-I-JOB-NAME`(작업명), `XZUGBTIN-I-DL-TN`(처리회차), `XZUGBTIN-I-BTCH-KN`(배치작업구분)
  - 출력: `XZUGBTIN-O-LSDL-KEY`(최종처리 KEY), `XZUGBTIN-O-RE-DL-TN`(재처리 작업회차)
  - 리턴코드: 00(정상), 11~35(입력오류/산출오류), 19(이미처리완료), 21(TABLE ACCESS ERROR), 99(PROCESS오류)
  - 기능: 배치실행정보 INSERT, 재처리 시 최종처리 KEY 제공, 작업기준일 관련 일자정보 제공
- n-KESA Detail:
  - `beforeExecute()` 내에서: `this.log = context.getLogger()`, `this.profile = context.getBatchProfile()`
  - 배치 프로파일 조회: `profile.getCommitCount()`, null 체크 필수 (로컬 테스트 시 null)
  - 프레임워크가 자동으로 배치실행로그 INSERT, Job Instance ID 생성, 파라미터 설정 등 처리
  - 일자 관련: `context.getInParameter("PROC_DATE")` (Control-M ODATE), `context.getInParameter("DATE")`
- Mapping Rule:
  - z-KESA `#DYCALL ZUGBTIN ...` → n-KESA `beforeExecute()` 내 `context.getBatchProfile()` (프레임워크가 자동 초기화)
  - z-KESA `XZUGBTIN-I-WORK-BSD` → n-KESA `context.getInParameter("PROC_DATE")`
  - z-KESA `XZUGBTIN-I-JOB-NAME` → n-KESA `context.getInParameter("JOB_ID")`
  - z-KESA `XZUGBTIN-O-LSDL-KEY` (최종처리 KEY 출력) → n-KESA `loadValue("KEY")`
  - z-KESA ZUGBTIN 리턴코드 에러처리 → n-KESA `beforeExecute()` 에서 `throw new BusinessException()` (프레임워크가 배치 중단 처리)

---

### [22] Batch Progress Management - 진행정보 유틸리티

- z-KESA: `ZUGBTCN` (Batch 진행정보 유틸리티): `XZUGBTCN-COMMIT` / `XZUGBTCN-COMMITALL` / `XZUGBTCN-STOP` / `XZUGBTCN-ERROR`
- n-KESA: `txCommit()` / `AutoCommitRecordHandler` / `saveValue()` / `context.setProgressCurrent()` / `context.addSuccessCountAmount()`
- z-KESA Detail:
  - `COPY XZUGBTCN` 카피북 + `#DYCALL ZUGBTCN YCCOMMON-CA XZUGBTCN-CA`
  - `FUNC-CD = 'COMMIT'`: 진행정보 갱신 + Commit (단위완료건수 충족 시만 실제 Commit)
  - `FUNC-CD = 'COMMITALL'`: 전체 완료 후 일괄 Commit
  - `FUNC-CD = 'STOP'`: 중단 요청에 의한 중간 Commit
  - `FUNC-CD = 'ERROR'`: 에러정보 축적 + 오류종료 요구 (즉시 Rollback)
  - 입력: `XZUGBTCN-I-LST-DL-KEY`(현재처리KEY), `XZUGBTCN-I-DL-C(1~20)`(각종처리건수), `XZUGBTCN-I-DL-A(1~20)`(각종처리금액), `XZUGBTCN-I-DAT-ICL-YN`(자료포함여부)
  - 출력: `XZUGBTCN-O-RETURN-CD = '01'` → 오퍼레이터 종료요구 발생 (`SET STOP-Y TO TRUE`)
- n-KESA Detail:
  - 진행률: `context.setProgressTotal(totalCnt)` + `context.setProgressCurrent(getCurrentSize())`
  - 건수/금액: `context.addSuccessCountAmount(count, amount)` + `context.addErrorCountAmount(count, amount)`
  - 전체 건수/금액 기록: `updateTotalTargetCountAmountWithCommit(count, amount)` (내부 txBegin/txCommit 포함)
  - Commit 시 건수/금액 → 배치실행로그 테이블 UPDATE (관리콘솔에서 조회 가능)
  - 오퍼레이터 종료요구 → 없음 (Control-M에서 Job kill 또는 루프배치의 `checkLoopTimeAndSleep()` 종료)
- Mapping Rule:
  - z-KESA ZUGBTCN `XZUGBTCN-COMMIT` → n-KESA `txCommit()` 또는 `AutoCommitRecordHandler` 자동 Commit
  - z-KESA `XZUGBTCN-I-DL-C(1)` 처리건수 → n-KESA `context.addSuccessCountAmount(1, 금액)`
  - z-KESA `XZUGBTCN-I-LST-DL-KEY` 현재처리KEY → n-KESA `saveValue("SUCC_POSITION", currentIdx+"")` 또는 `setSaveValueKey()`
  - z-KESA `XZUGBTCN-O-RETURN-CD = '01'` (종료요구) → n-KESA 루프배치에서 `checkLoopTimeAndSleep()` false 리턴 시 루프 종료

---

### [23] User Stop Request Processing - 사용자 종료요구 처리

- z-KESA: `STOP-Y` 플래그 + ZUGBTCN `XZUGBTCN-STOP` 호출 + `#OKEXIT CO-STAT-STOP`
- n-KESA: 루프배치 `checkLoopTimeAndSleep()` 종료 조건 / while 루프 break
- z-KESA Detail:
  - BMS(Batch 실행정보 관리화면)에서 종료요구
  - ZUGBTCN 호출 결과 `XZUGBTCN-O-RETURN-CD = '01'` → `SET STOP-Y TO TRUE` → 루프 종료 분기
  - `EVALUATE TRUE WHEN STOP-Y → SET XZUGBTCN-STOP TO TRUE` → ZUGBTCN 호출(중간 Commit) → `DISPLAY '...STOPPED BY OPERATOR'` → `#OKEXIT CO-STAT-STOP`
  - 재개시: 다음 JOB 실행 시 ZUGBTIN에서 Restart Key 제공
- n-KESA Detail:
  - Control-M에서 Job을 강제 kill 하는 방식 (Java process 종료)
  - 루프배치에서 종료 시각 체크: `checkLoopTimeAndSleep(sleepSec, "2359")` → false이면 while 종료
  - 종료 후 재처리: `isRetryMode()` + `loadValue()` + `setTargetRecordRange()` 패턴
- Mapping Rule:
  - z-KESA BMS 화면 종료요구 + STOP-Y 플래그 처리 → n-KESA Control-M Job kill (프로세스 종료)
  - z-KESA `#OKEXIT CO-STAT-STOP` ('16') → n-KESA JVM 비정상 종료 (exit code 1)
  - z-KESA STOP 후 재개 → n-KESA `isRetryMode()` + `loadValue()` 활용 재처리

---

### [24] Common Area (공통정보 영역)

- z-KESA: `YCCOMMON-CA` (Common Area 카피북) + 수동 조립 (`MOVE ... TO BICOM-GROUP-CO-CD`, `BICOM-TRAN-BASE-YMD`, `BICOM-USER-EMPID` 등)
- n-KESA: `getCommonArea()` 메소드 + 자동 초기화
- z-KESA Detail:
  - `COPY YCCOMMON` → `01 YCCOMMON-CA` 선언
  - 프레임워크가 Common Area 획득/초기화 수행 (BICOM-TRAN-BASE-YMS = 시스템일시로 자동 조립)
  - 배치에서 필요한 항목은 Main PGM에서 수동 조립 필수: 그룹회사코드, 사용자직원번호, 거래기준일자(SYSIN 기준일과 다를 경우)
  - 온라인 프로그램 호출 시 이 Common Area를 파라미터로 전달: `#DYCALL 프로그램명 YCCOMMON-CA ...`
- n-KESA Detail:
  - `getCommonArea()`: CommonArea 객체 취득 (한번 생성 후 재사용)
  - `getCommonArea(true)`: CommonArea 재생성 (GUID 재채번, 시간 정보 재설정) - 데몬 배치 루프마다 필요 시
  - EAI 전문 전송 시 매건 `getCommonArea(true)` 호출로 GUID 재채번
- Mapping Rule:
  - z-KESA `MOVE WK-SYSIN-ORG-CD TO BICOM-GROUP-CO-CD` → n-KESA 자동 바인드 변수 `groupCoCd` 또는 `getCommonArea().setGroupCoCd(...)`
  - z-KESA `MOVE WK-SYSIN-WORK-BSD TO BICOM-TRAN-BASE-YMD` → n-KESA `context.getInParameter("PROC_DATE")` 활용
  - z-KESA `MOVE WK-SYSIN-EMP-NO TO BICOM-USER-EMPID` → n-KESA 자동 바인드 변수 `sysLastUno` (프레임워크 자동)

---

### [25] Batch Logging

- z-KESA: `DISPLAY '메시지'` (SYSOUT/CONSOLE), 형식 `UKB09001E JOBNAME-PGMNAME-에러코드-내용`
- n-KESA: `log.info()` / `log.debug()` / `log.warn()` / `log.error()` (commons-logging)
- z-KESA Detail:
  - SYSOUT: 처리도중 오류 또는 최종 완료 정보 출력에 한해 사용
  - CONSOLE: 작업자동화 시스템/ITSM 연계 요건 시에만 사용, 시스템 운영 지침에 따른 메시지 형식 준수
  - 반복 구간에서 DISPLAY 사용 금지 (성능/안정성 영향)
  - 에러 메시지: `UKB09001E JOBNAME(8)-PGMNAME(8)-에러코드(8)-내용(60자이내)`
  - 정상 메시지: `UKB00001I JOBNAME(8)-PGMNAME(8)-고유번호(8)-내용(60자이내)`
  - 2줄 이상: `'*** START ***'` / 내용 / `'*** END ***'` 형식
- n-KESA Detail:
  - `context.getLogger()` → `ILog log` 객체 취득 (`beforeExecute()`에서)
  - 로그 레벨: DEBUG / INFO / WARN / ERROR (개발서버 기본 DEBUG, 운영서버 기본 ERROR)
  - DEBUG 로그: `if (log.isDebugEnabled()) { log.debug(...); }` 필수 체크 (String 연산 낭비 방지)
  - 로그 파일 위치: `/fslog/xxxx_dev/sqc/runtime/batch/YYYYMMDD/bat-JobInstanceId-ThreadId.log`
  - Job Instance 별 로그 파일 분리, 멀티 스레드 별 별도 로그 파일
  - 배치 프로파일에서 로그레벨 관리콘솔 설정 가능
  - 프레임워크 자동 Start/End 로그: `BATCH START INFORMATION`, `BATCH RESULT` 헤더로 자동 출력
  - DB Report: 실행된 SQL ID별 실행횟수/처리건수 자동 로깅
- Mapping Rule:
  - z-KESA `DISPLAY 'UKB00001I JOBNAME PGMNAME ... '*** START ***''` → n-KESA 프레임워크 자동 `BATCH START INFORMATION` 로그
  - z-KESA `DISPLAY 'UKB09001E JOBNAME-PGMNAME-에러코드-내용'` → n-KESA `log.error("에러 내용", e)`
  - z-KESA `DISPLAY 'UKB00001I ... *** END ***'` → n-KESA 프레임워크 자동 `BATCH RESULT` 로그
  - z-KESA `DISPLAY` 처리완료 건수/금액 → n-KESA `context.addSuccessCountAmount()` → 관리콘솔 배치실행로그 자동 기록

---

### [26] Performance - Memory Loading (메모리 적재)

- z-KESA: Working Storage 배열(OCCURS) 또는 Indexed Table로 기준 정보 사전 적재
- n-KESA: `StringTypeValueMapReturnRecordHandler` / `IRecordTypeValueMapReturnRecordHandler` / `SharedMap`
- z-KESA Detail:
  - `01 WK-TABLE. 05 WK-ITEM OCCURS n TIMES INDEXED BY WK-IDX.` 구조로 기준정보 배열 적재
  - SELECT 후 PERFORM VARYING으로 배열에 MOVE
  - 이후 본처리에서 배열 인덱스로 참조 (DB 건건 조회 불필요)
- n-KESA Detail:
  - `StringTypeValueMapReturnRecordHandler`: key-value(String-String) Map으로 코드성 데이터 적재
    - `setKeyColumn("컬럼명")`, `setValueColumn("컬럼명")`, `setPermitDuplicatedKey(false)`
    - `dbSelect("SQL", param, handler)` → `handler.getMap()` → `Map<String, String>`
  - `IRecordTypeValueMapReturnRecordHandler`: key-IRecord Map으로 전체 Row 적재
    - `setKeyList(new String[]{"KEY컬럼"})`, `setKeyDelimiterChar("_")`
    - `Map<String, IRecord>` 리턴
  - 최대 크기 제한 필수: `new StringTypeValueMapReturnRecordHandler(context, 1000)` (초과 시 에러)
  - 멀티 스레드 공유: `SharedMap` + `SharedMapAccessor` (별도 클래스로더로 인해 멤버 필드 공유 불가)
- Mapping Rule:
  - z-KESA `OCCURS n TIMES` 배열 기준정보 테이블 → n-KESA `StringTypeValueMapReturnRecordHandler` 또는 `IRecordTypeValueMapReturnRecordHandler`
  - z-KESA PERFORM VARYING으로 배열 적재 → n-KESA `dbSelect("SQL", param, handler)` + `handler.getMap()`
  - z-KESA 배열 인덱스 참조 → n-KESA `map.get("키값")`
  - z-KESA 멀티 프로세스 간 공유 없음 → n-KESA 멀티 스레드 간 `SharedMap` + `SharedMapAccessor`

---

### [27] Parallel Processing - Multi-Process

- z-KESA: 동일 JCL을 여러 STEP으로 병렬 실행 또는 여러 JOB 등록, `WK-SYSIN-JOB-NAME` (작업명)으로 처리 범위 구분
- n-KESA: 쉘 파일 복제 + Control-M Job 복수 등록, 파라미터로 처리 범위 전달
- z-KESA Detail:
  - 동일 Batch Main PGM을 여러 작업명(JOB NAME)으로 분할 실행: `WK-SYSIN-JOB-NAME`에 분할 작업명 입력
  - JCL에서 COND 문으로 병렬 STEP 의존성 제어
- n-KESA Detail:
  - Java 프로그램 1개 작성 → 쉘 파일 복제 (처리 범위 파라미터만 다르게)
  - Control-M Job 개수만큼 등록, 선후행 관계 설정
  - Shell 파라미터: `NC_PARAM1=THREAD_NO=1` 형태로 처리 범위 전달
  - 각 프로세스가 `context.getInParameter("ARG1")` 등으로 처리 범위 구분
  - 여러 서버에 분산 실행 가능한 유일한 방식
- Mapping Rule:
  - z-KESA 분할 작업명(`WK-SYSIN-JOB-NAME`) → n-KESA Shell 파라미터로 처리 범위 전달 (예: `RANGE_START`, `RANGE_END`)
  - z-KESA JCL 병렬 STEP → n-KESA Control-M 병렬 Job 등록

---

### [28] Parallel Processing - Multi-Thread (BatchStep 방식)

- z-KESA: 별도 병렬 처리 프레임워크 없음 (단일 스레드 COBOL 프로세스)
- n-KESA: `BatchStep` 클래스 + `runBatchStepSync()` / `runBatchStepAsync()` 메소드
- z-KESA Detail: COBOL 자체는 멀티 스레드 지원 없음
- n-KESA Detail:
  - `BatchStep` 클래스 상속: 멀티 스레드로 실행될 단위 프로그램
  - `runBatchStepSync(BSStep.class, stepCount, threadPool, ErrorPolicy, mergeLogger)`: 동기 실행 (완료까지 대기)
  - `runBatchStepAsync(BSStep.class, stepCount, threadPool, mergeLogger)`: 비동기 실행 (즉시 리턴, afterExecute에서 결과 처리)
  - `createBatchStepThreadPool(n)`: 동시 실행 스레드풀 개수
  - 스레드 ID: `"P" + 숫자1 + 클래스명 + "T" + 일련번호`
  - 각 스레드 별도 객체/클래스로더 → 멤버 필드 공유 불가 → `SharedMap` 활용
  - 트랜잭션 각 스레드 개별 처리
  - `getThreadId()` 메소드로 현재 스레드 처리 범위 산출
- Mapping Rule:
  - z-KESA 동일 COBOL 프로그램을 여러 작업명으로 분할 실행 → n-KESA `BatchStep` + `runBatchStepSync` (동일 JVM 내 멀티스레드)
  - z-KESA JCL 단계적 STEP 의존성 → n-KESA `runBatchStepSync` (동기, 완료 후 다음 로직) vs `runBatchStepAsync` (비동기)

---

### [29] Parallel Processing - Multi-Thread (nKESA1.0 Shell 방식)

- z-KESA: 해당 없음
- n-KESA: Shell 파일 `NC_BATCH_CLASS1=패키지.클래스명[스레드수]`
- z-KESA Detail: 해당 없음
- n-KESA Detail:
  - Shell 파일: `NC_BATCH_CLASS1=com.kbstar.edu.banking.batch.BUAcnInqury[5]` → 5개 스레드로 실행
  - 스레드 수 변수화: `NC_BATCH_CLASS1=...BUBatch[${THREADNO}]`
  - 파라미터: `THREAD_COUNT`(전체 스레드수), `THREAD_NO`(현재 스레드번호, 1부터)
  - 스레드 ID: `클래스명 + "T" + 일련번호(3자리)` → 스레드별 별도 로그 파일
  - 한 쓰레드라도 Exception 발생 시 JVM exit 에러 리턴
- Mapping Rule:
  - z-KESA JCL 분할 작업명 → n-KESA `THREAD_NO`/`THREAD_COUNT` 파라미터로 처리 범위 산출
  - 스레드당 처리 범위: `THREAD_NO` 기반으로 BETWEEN 조건 또는 모듈 연산으로 범위 분할

---

### [30] Parallel Processing - Role-Separated Multi-Thread (역할 분리)

- z-KESA: 해당 없음 (단순 순차 처리)
- n-KESA: Reader + Processor 역할 분리 + `SharedQueue` (단일큐/멀티큐)
- z-KESA Detail: 해당 없음
- n-KESA Detail:
  - Reader: DB/File 읽어 `SharedQueue`에 `send(record, timeout)`
  - Processor: `SharedQueue`에서 `receive(recordHandler)` → `AutoCommitRecordHandler`로 처리
  - 단일큐: 큐 1개, Processor 여러 스레드가 동일 큐에서 receive (구현 간단, 재처리 어려움)
  - 멀티큐: 스레드 수만큼 큐 생성, Reader가 규칙에 따라 분산 send → 재처리 가능
  - `createSharedQueue(id, desc)`: Reader에서 큐 생성
  - `getSharedQueue(id, timeoutSec)`: Processor에서 큐 lookup
  - `sharedQueueSender.send(record, 10000)`: 10초 timeout으로 전송
  - `sharedQueueReceiver.receive(handler)`: 데이터 수신 + 핸들러 실행
  - `sharedQueueSender.finish()`: send 완료 신호 (onFinally에서 필수 호출)
  - `sharedQueue.waitForAllReceiveEnd()`: Reader afterExecute에서 모든 Processor 완료 대기
  - 멀티큐 재처리: `THREAD_NO` → 자신의 큐 lookup → `isRetryMode()` + `loadValue` + `setTargetRecordRange`
- Mapping Rule:
  - z-KESA 해당 없음 → n-KESA Reader(BU) + Processor(BU 또는 BS) + SharedQueue 패턴 (새로운 아키텍처)
  - Shell 파일: `NC_BATCH_CLASS1=Reader클래스` + `NC_BATCH_CLASS2=Processor클래스[3]`

---

### [31] Loop Batch / Daemon Batch (상주배치 / 루프배치)

- z-KESA: 별도 Daemon 처리 없음 (JCL 주기 실행으로 대응) 또는 COBOL `PERFORM UNTIL` 루프
- n-KESA: `execute()` 내 `while(checkLoopTimeAndSleep(sleepSec, endTimeHHMM))` 루프
- z-KESA Detail:
  - 반복 수행: JCL을 일정 주기로 스케줄 실행 (동일 프로그램 반복 기동)
  - COBOL 내 무한루프는 PERFORM 사용 가능하나 Framework에서 특별한 지원 없음
  - 종료요구: ZUGBTCN `RETURN-CD='01'` → `STOP-Y` → 루프 종료
- n-KESA Detail:
  - `checkLoopTimeAndSleep(sleepTimeSec, endTimeHHMM)`: 종료시각 미도래 시 sleepTime sleep 후 true 리턴, 종료시각 도래 시 false 리턴
  - 24시간 루프: `checkLoopTimeAndSleep(30, "2359")` → 23:59까지 실행
  - 새벽 03시까지: `checkLoopTimeAndSleep(10, "0300")`
  - 시작시각 > endTime: 익일 endTime까지 실행
  - while 내 Exception: 루프 종료 → 배치 End Fail
  - 에러에도 계속 실행: while 내부 `try-catch` 로 에러 로깅 후 continue
  - 데몬 배치 건수/금액 초기화: `context.resetCountAmount(0,0,0,0)` (루프마다 초기화 시)
  - 데몬 배치 CommonArea GUID 재채번: `getCommonArea(true)`
- Mapping Rule:
  - z-KESA JCL 주기 실행 (매시간 JOB 기동) → n-KESA `checkLoopTimeAndSleep()` 루프 (단일 JOB이 내부에서 반복)
  - z-KESA STOP-Y → n-KESA `checkLoopTimeAndSleep()` false 리턴 시 while 종료
  - z-KESA 프로그램 재기동 → n-KESA 다음 날 Control-M이 새 JOB으로 Order

---

### [32] Online-to-Batch Integration - 온디맨드 배치

- z-KESA: `WK-SYSIN-BTCH-KN = 'ONLBAT'` (온라인기동 배치 구분)
- n-KESA: `callBatchNow(jobId, inParamMap, onlineCtx)` / `callBatchAfterCommit(...)` (온라인 BizUnit에서 호출)
- z-KESA Detail:
  - SYSIN 카드의 배치작업구분 `ONLBAT`으로 온라인 기동 구분
  - 온라인 거래 중 배치 기동은 제한적 사용
- n-KESA Detail:
  - `callBatchNow(jobId, inParamMap, ctx)`: 즉시 배치 기동
  - `callBatchAfterCommit(jobId, inParamMap, ctx)`: 온라인 PM commit 후 기동
  - 파라미터: `inParamMap.put("PARM1", "100")` → 배치에서 `context.getInParameter("ARG1")`
  - 온라인 거래당 1번만 호출 가능
  - JAS에 등록된 배치만 실행 가능
  - 배치 배치에서 온디맨드 구분: `context.getInParameter("OPER_TYPE") == "OND"`
  - 온디맨드 추가 파라미터: `OND_TRAN_CD`, `OND_GUID_NO`, `OND_CHNL_DSTCD`, `OND_BRNCD`, `OND_USER_EMPID` 등
  - 결과 PUSH: `sendResultMessageToIntgraTerml(header, outDS, txid, ctx)` → 단말로 BID 메시지 전송
- Mapping Rule:
  - z-KESA `SYSIN BTCH-KN = 'ONLBAT'` 체크 → n-KESA `"OND".equals(context.getInParameter("OPER_TYPE"))` 체크
  - z-KESA 온라인 기동 Batch 처리회차 `'000'` → n-KESA `EXE_SEQ = 1` (최초 실행)

---

### [33] DB Session Separation - DB 세션 분리

- z-KESA: DB to DB 패턴에서 별도 처리 없음 (단일 DB 연결)
- n-KESA: `dbNewSession("READ")` + `dbNewSession("MCN")` 등 별도 DBSession 생성
- z-KESA Detail:
  - COBOL Batch는 단일 DB2 연결
  - SELECT와 INSERT/UPDATE를 동일 연결에서 수행 (중간 Commit 시 Cursor 유지 문제 가능)
- n-KESA Detail:
  - `DBSession readSession = dbNewSession("READ")`: 조회 전용 세션 (중간 Commit 영향 없는 별도 세션)
  - `dbSelect("select", param, handler, readSession)`: readSession으로 SELECT
  - `dbInsert/dbUpdate("SQL", param)`: 주 세션(트랜잭션)으로 CUD
  - DB to DB 패턴: 중간 Commit 시 SELECT 세션 분리 필수
  - 타 DB: `dbNewSession("MCN")` → `txBegin(mcnSession)` / `txCommit(mcnSession)` 분리
  - `isXA=false` (XA DataSource 미사용 - 본 프로젝트 기준)
- Mapping Rule:
  - z-KESA 단일 DB2 연결 → n-KESA SELECT는 `readSession`, CUD는 기본 주 세션 분리
  - z-KESA 타 DB 처리(별도 CONNECT 또는 3-part name) → n-KESA `dbNewSession("타DB키")` + 별도 트랜잭션 관리

---

### [34] Procedure Call (프로시저 사용)

- z-KESA: `EXEC SQL CALL 프로시저명 (:파라미터...) END-EXEC`
- n-KESA: XSQL에 ParameterMap 정의 + `dbProcedure("sqlId", sqlin)` 호출
- z-KESA Detail:
  - `EXEC SQL CALL 프로시저명 (IN파라미터, :OUT파라미터) END-EXEC`
  - 호스트 변수로 IN/OUT 파라미터 처리
  - DBA 협의 후 성능 이슈 시에만 사용
- n-KESA Detail:
  - XSQL 노드에서 ParameterMap 생성 (ID: `SQL ID + _Param`, class: `java.util.Map`)
  - In/Out 파라미터 정의
  - SQL 작업구분: PROCEDURE, SQL 형식: `{ call 프로시저명(?, ?) }`
  - `Map sqlin = new HashMap()` → In 파라미터 put → `dbProcedure("sqlId", sqlin)` → Out 파라미터 `sqlin.get()`
  - `AutoCommitRecordHandlerWithDBIO`: DBIO 유닛(프로시저 포함) 동일 트랜잭션 + Array 처리 가능
- Mapping Rule:
  - z-KESA `EXEC SQL CALL 프로시저(IN, :OUT) END-EXEC` → n-KESA `dbProcedure("sqlId", sqlinMap)` + `sqlinMap.get("OUT파라미터명")`

---

### [35] Naming Conventions - 배치 명명규칙 비교

- z-KESA:
  - Batch Main PGM: `B` + 어플리케이션코드(2) + 식별번호(4) → `BXX@@@@`
  - Batch Sub PGM: `Batch Main PGM과 동일`
  - JCL ID: `M`/`T` + 어플리케이션코드(3) + 작업주기구분자(1) + UserDefined(3) → `MXXX@@@@`
  - SAM 파일 카피북: `S` + 식별자 (예: `Sxxxxxxx`)
  - 인터페이스 카피북: `XB` + 식별자 (Batch Sub 호출용)
  - SYSIN 유틸리티 인터페이스: `XZUGBTIN`, `XZUGBTCN`
- n-KESA:
  - BatchUnit: `BU` + [명사형] → `BUAcnInqury`
  - BatchStep: `BS` + [명사형] (또는 `BU` + [명사형] + `BSStep` + 번호) → `BUAcnInqury BSStep1`
  - 실행 쉘 파일명: 8자리 소문자 → `tedu0001.sh`
  - 배치 ID(관리콘솔): 쉘 파일명(.sh 제외) = Control-M JobName → `tedu0001`
  - FIO 파일 ID: `FIO` + 배치클래스명 + 순번 → `FIOBUAcnInqury01`
  - XSQL SQL ID: 동사+명사형 → `selectAcno`, `insertAcno`, `executeProcedure`
- Mapping Rule:
  - z-KESA `BXX@@@@` → n-KESA `BU명사형`
  - z-KESA JCL ID `MXXX@@@@` → n-KESA 쉘 파일명/배치 ID (Control-M JobName)
  - z-KESA SAM 파일 카피북 `Sxxxxxxx` → n-KESA FIO 파일 `FIOxxx...`
  - z-KESA `XZUGBTIN`/`XZUGBTCN` 카피북 → 해당 없음 (프레임워크 자동 처리)

---

### [36] File Layout - Multiple Layout Processing (다중 레이아웃)

- z-KESA: `REDEFINES`로 레코드 구조 재정의하여 동일 파일에서 다중 레이아웃 처리
- n-KESA: 여러 `IFileTool` 객체 + `SAMFileTool.readToEol()` + 구분자 기반 레이아웃 선택 + `RecordHandlerExecutor`
- z-KESA Detail:
  - `01 IN-FILE-REC PIC X(1020)` → `05 REC-TYPE PIC X(1)` + 조건별 레이아웃 카피북 REDEFINE
  - `EVALUATE REC-TYPE WHEN 'A' ... WHEN 'B' ...` 로 레이아웃 분기
- n-KESA Detail:
  - Write: 여러 `IFileTool` 객체 → 하나의 `fileOutStream` 공유 → `writeRecordToOut()` 선택 호출
  - Read: `SAMFileTool.readToEol(bis, buffer)` 로 1줄 읽기 → 구분자 판별 → `fileToolRead.readRecordFromBytes(rs, buffer)` 로 해당 레이아웃 파싱
  - `RecordHandlerExecutor`: 수동으로 읽은 IRecord를 AutoCommitRecordHandler에 투입
    - `rhe.start()` → `rhe.execute(record)` 반복 → `rhe.end(errorFlag)`
    - 내부적으로 `preStartFetch()`, `handleRecord()`, `postEndFetch()`, `onFinally()` 호출 보장
- Mapping Rule:
  - z-KESA `REDEFINES` 다중 레이아웃 → n-KESA 레이아웃 수만큼 FIO 파일 + `IFileTool` 객체 생성
  - z-KESA `EVALUATE REC-TYPE` 분기 → n-KESA `SAMFileTool.readToEol()` + `readLineBuffer[idx]` 구분자 체크
  - z-KESA `READ` / `WRITE` 다중 레이아웃 → n-KESA `readRecordFromBytes()` / `writeRecordToOut()` 레이아웃별 호출
  - z-KESA 처리 루프 내 CUD → n-KESA `RecordHandlerExecutor` + `AutoCommitRecordHandler` (중간 Commit/Array 처리 포함)

---

### [37] File Naming Standards (파일명 표준)

- z-KESA: 차세대 표준 SAM File 명명규칙 (`KLA.DSAMPLE.SORC(BLA0011)` 형식의 PDS 데이터셋)
- n-KESA: `/fsfile/어플리케이션코드` 하위 표준 + `makeDataFileName()` 메소드
- z-KESA Detail:
  - MVS 데이터셋 형식: `HLQ.MLQ.LLQ` (최상위.중간.하위 한정자)
  - JCL DD 문의 `DSN=xxx.yyyyyy.zzzzzz`로 지정
- n-KESA Detail:
  - 표준 루트 디렉토리: `/fsfile/어플리케이션코드(3)` (전역 파라미터 `DATA_ROOT`)
  - `makeDataFileName(appCode, period, userDefinName, fromOrTo, seq, date, extension)`:
    - period: D(일), W(주), M(월), Q(분기), H(반기), Y(년), T(임시)
    - extension: TXT, CSV, DEL, DAT 등
  - `getDataFileMaxSeq(dir, appCode, period, userDefinedNm, fromOrTo, date, extension)`: 최대 일련번호 조회
  - Write 디렉토리 생성: `FileUtils.forceMkdir(new File(outDir))`
  - 파일명은 Shell 파라미터(`INPUT_FILE`/`OUTPUT_FILE`)로 받거나 `makeDataFileName()`으로 생성 권장
- Mapping Rule:
  - z-KESA JCL `DSN=xxx.yyyyyy.zzzzzz` → n-KESA Shell 파라미터 `INPUT_FILE=/fsfile/app/파일명` 또는 `makeDataFileName()` 생성
  - z-KESA PDS 멤버 형식 → n-KESA Unix 디렉토리/파일 경로 형식

---

### [38] EBCDIC File Processing

- z-KESA: 기본 EBCDIC 인코딩 환경 (메인프레임 고유)
- n-KESA: `EBCDICFixedLenFileTool.from(getFileTool("FIO ID"))` + NDM 바이너리 전송
- z-KESA Detail:
  - 메인프레임 특성상 모든 파일이 EBCDIC(cp930/cp933)
  - 파일 전송 시 NDM(Connect:Direct) 또는 FTP ASCII 변환
- n-KESA Detail:
  - 일반 파일: FIO 파일 인코딩 속성에 `MS949`, `UTF-8` 등 지정
  - EBCDIC 고정길이 파일 쓰기: `EBCDICFixedLenFileTool.from(getFileTool("FIO ID"))` → 원본 `IFileTool` 객체를 EBCDIC 기능객체로 Wrapping
  - M/F로 전송 시: NDM 바이너리 방식 전송 필수 (문자 변환 없이)
- Mapping Rule:
  - z-KESA EBCDIC SAM 파일 처리 → n-KESA `EBCDICFixedLenFileTool` + FIO 파일 EBCDIC 인코딩 설정
  - z-KESA 파일 전송(NDM ASCII 변환) → n-KESA NDM 바이너리 방식 전송

---

**Summary of Key Class/Method Mapping Table:**

| z-KESA 개념 | n-KESA 클래스/메소드 |
|---|---|
| `Batch Main PGM` | `BatchUnit` (`extends com.kbstar.sqc.batch.base.BatchUnit`) |
| `Batch Sub PGM` | 공유 FM (`callSharedMethodByDirect()`) 또는 `BatchStep` |
| `S1000-INITIALIZE-RTN` | `beforeExecute()` |
| `S3000-PROCESS-RTN` | `execute()` |
| `S9000-FINAL-RTN` | `execute()` 정상 리턴 + `afterExecute()` |
| `S8000-ERROR-RTN` + `#ERROR` | `throw new BusinessException()` |
| `#OKEXIT CO-STAT-OK` | `execute()` 정상 리턴 |
| `#OKEXIT CO-STAT-ERROR` | `throw new BusinessException()` |
| `ZUGBTIN` (초기화 유틸) | `beforeExecute()` + `context.getBatchProfile()` |
| `ZUGBTCN` (진행정보 유틸) | `txCommit()` / `AutoCommitRecordHandler` / `saveValue()` |
| `ACCEPT WK-SYSIN FROM SYSIN` | `context.getInParameter("KEY")` |
| `EXEC SQL COMMIT` | `txCommit()` |
| `EXEC SQL ROLLBACK` | `txRollback()` |
| `EXEC SQL SELECT ... FETCH` | `dbSelect() + AbsRecordHandler.handleRecord()` |
| `EXEC SQL INSERT/UPDATE/DELETE` | `dbInsert()` / `dbUpdate()` / `dbDelete()` |
| `EXEC SQL SELECT ... INTO :단건` | `dbSelectSingle()` |
| `FILE-CONTROL SELECT ... ASSIGN` | FIO 파일 정의 + `getFileTool("FIO ID")` |
| `OPEN INPUT` + `READ ... AT END` | `fileOpenInputStream()` + `readRecordSetFromInputStream()` |
| `OPEN OUTPUT` + `WRITE` | `fileOpenOutputStream()` + `writeRecordToOut()` |
| `WK-LSDL-KEY` (최종처리 KEY) | `saveValue()` / `loadValue()` |
| Restart SKIP 로직 | `isRetryMode()` + `handler.setTargetRecordRange()` |
| `DISPLAY '메시지'` | `log.info()` / `log.error()` |
| JCL `//SYSIN DD *` | Shell `NC_PARAMn=KEY=VALUE` |
| JCL `//STEP1 EXEC JZBDEXEC` | Shell 파일 `NC_BATCH_CLASS1=클래스명` |
| 분할 작업명 (멀티 프로세스) | 쉘 파일 복제 + Control-M Job 복수 등록 |
| `PERFORM UNTIL EOF-Y` 루프 | `readRecordSetFromInputStream()` 내부 자동 반복 |
| DB Array 처리 | `dbStartBatch()` + `dbExecuteBatch()` 또는 `setAddBatchMode(true)` |
| 루프배치 (PERFORM 무한) | `while(checkLoopTimeAndSleep(sleepSec, "HHMM"))` |
| 기준정보 배열 적재 (`OCCURS`) | `StringTypeValueMapReturnRecordHandler` / `IRecordTypeValueMapReturnRecordHandler` |
| 멀티스레드 없음 | `BatchStep` + `runBatchStepSync/Async()` / Shell `[스레드수]` |
| 역할분리 없음 | Reader + Processor + `SharedQueue` |
| 공유 메모리 없음 | `SharedMap` + `SharedMapAccessor` |