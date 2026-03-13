# Java 변환 설계서 (Conversion Plan)

**작성 일시**: 2026-03-13
**작성 에이전트**: planning-agent
**기반 문서**: output/analysis_spec.md
**참조 가이드**: java-guide/n-KESA가이드.md, java-guide/n-KESA-공통모듈가이드.md, cobol-guide/z-KESA가이드.md, cobol-guide/z-KESA-공통모듈가이드.md, gap/zkesa-nkesa-mapping.md

---

## 1. 개요 (Overview)

### 1.1 변환 목적 및 범위

본 문서는 KB 기업집단신용평가이력관리 업무의 COBOL 소스코드를 n-KESA Java 프레임워크 기준으로 변환하기 위한 설계 지침을 정의한다.

**변환 목적**:
- z-KESA(메인프레임 COBOL) 기반 온라인 프로그램을 n-KESA(Java/WAS) 아키텍처로 전환
- IBM z/OS 메인프레임 의존성을 제거하고 개방형 Linux/AWS 환경에서 운영 가능한 구조로 전환
- DBIO/SQLIO 매크로 기반 DB 접근을 MyBatis XSQL 방식으로 전환

**변환 범위**:
- AIPBA30.cbl (AS 프로그램, 255행) → ProcessUnit (PU)
- DIPA301.cbl (DC 프로그램, 1985행) → DataUnit (DU)
- 연관 Copybook → IDataSet 필드 매핑 또는 상수 클래스로 변환
- DBIO 45건 (INSERT 1, SELECT 12, DELETE 12, CURSOR 12, SQLIO 8) → XSQL XML

**변환 외 범위**:
- SQLIO 프로그램(QIPA301~QIPA308) 소스 재현 — 소스 미확보로 SQL 역설계 필요 (리스크 항목)
- 12쌍 테이블 Copybook (TRIPB110~TRIPB133, TKIPB110~TKIPB133) — 미확보로 DB xls 기반 보완

---

### 1.2 대상 COBOL 프로그램 목록

| COBOL 프로그램 | 처리유형 | 행 수 | 역할 | Java 대응 |
|--------------|---------|-------|------|----------|
| AIPBA30.cbl | AS (Application Service) | 255행 | 기업집단신용평가이력관리 거래 진입점. 입력검증, DIPA301 DC 호출, 출력조립 | ProcessUnit: PUCorpEvalHistory |
| DIPA301.cbl | DC (Data Component) | 1985행 | 기업집단 이력 신규평가(01)/확정취소(02)/삭제(03) 처리. 11개 테이블 접근 | DataUnit: DUCorpEvalHistoryA |

---

### 1.3 변환 전략 요약

**핵심 전략: Bottom-Up 변환 (의존 관계 기반)**

```
[1단계] 공통 상수 클래스 → [2단계] DU + XSQL → [3단계] PU (PM 메서드)
```

- DIPA301(DC) → DUCorpEvalHistoryA를 먼저 구현하고, AIPBA30(AS) → PUCorpEvalHistory가 이를 호출하는 구조
- DU 내 11개 테이블별 DM 메서드 및 XSQL을 처리구분 기준으로 그룹화
- 처리구분 코드('01'/'02'/'03') 분기는 PU의 PM 메서드에서 처리구분 값을 DU에 전달하고, DU 내에서 분기
- 프레임워크 트랜잭션(Commit/Rollback) 규칙 준수 — 임의 트랜잭션 제어 금지

---

## 2. Java 클래스 구조 설계 (Java Class Structure Design)

### 2.1 각 COBOL 프로그램에 대응하는 Java 클래스 목록

| COBOL 프로그램 / 구조 | Java 클래스 | 타입 | 역할 |
|---------------------|-----------|------|------|
| AIPBA30 (AS 프로그램) | PUCorpEvalHistory | ProcessUnit (PU) | 기업집단신용평가이력 거래 진입점. 입력검증, DU 호출, 출력 조립 |
| DIPA301 (DC 프로그램) | DUCorpEvalHistoryA | DataUnit (DU) | 기업집단신용평가이력 DB 접근 전담. 처리구분별 INSERT/DELETE 처리 |
| CO-AREA / CO-ERROR-AREA (상수) | CCorpEvalConsts | 상수 클래스 | 상태코드, 에러코드, 조치코드, 도메인 상수 정의 |
| XDIPA301.cpy (DC 인터페이스) | IDataSet 필드 명세 | - | 별도 DTO 클래스 생성 없이 IDataSet 키 상수로 관리 |
| YNIPBA30.cpy (AS 입력) | IDataSet requestData 필드 | - | requestData.getString("prcssDstcd") 등으로 접근 |
| YPIPBA30.cpy (AS 출력) | IDataSet responseData 필드 | - | responseData.put("totalNoitm", ...) 으로 응답 조립 |

---

### 2.2 클래스 역할 및 책임 정의 (단일 책임 원칙)

#### PUCorpEvalHistory (ProcessUnit)
- **책임**: 기업집단신용평가이력 거래(AIPBA30)의 유일한 진입점
- **수행 업무**:
  1. 공통IC 컨텍스트 초기화 (IJICOMM → CommonArea 세팅)
  2. 4개 필수 입력값 검증 (처리구분, 기업집단그룹코드, 평가년월일, 기업집단등록코드)
  3. DUCorpEvalHistoryA 호출 (처리구분 코드 전달)
  4. DC 호출 결과(NOTFOUND 포함 정상) 판별 및 오류 전파
  5. 응답 IDataSet 조립 및 폼ID 설정
- **금지사항**: DB 직접 접근 금지, 트랜잭션 직접 제어 금지

#### DUCorpEvalHistoryA (DataUnit)
- **책임**: DIPA301에 해당하는 모든 DB 접근 처리
- **수행 업무**:
  1. 처리구분 '01': 기존재 확인(selectExistCheck) → INSERT(insertCorpEvalHistory)
  2. 처리구분 '02': 현행 COBOL 동일하게 무동작 처리 (주석으로 의도 명시, TBD)
  3. 처리구분 '03': 11개 테이블 순차 DELETE (deleteCorpEvalHistoryAll)
  4. 보조 조회: 직원기본정보 조회(selectEmployeeInfo), 주채무계열여부 조회(selectMainDebtAffltYn)
- **금지사항**: 다른 DU 호출 금지, 트랜잭션 직접 제어 금지, 비즈니스 결정 로직 금지

#### CCorpEvalConsts (상수 클래스)
- **책임**: COBOL CO-AREA 및 CO-ERROR-AREA에 해당하는 모든 상수 중앙 관리
- **수행 업무**: 상태코드, 에러코드, 조치코드, 도메인 상수 (비계약업무구분코드 '060', 처리단계구분 '6' 등) 정의

---

### 2.3 클래스 간 의존 관계 다이어그램

```
[n-KESA 프레임워크]
        |
        | IDataSet requestData + IOnlineContext
        v
+-------------------------+
|  PUCorpEvalHistory      |  (ProcessUnit)
|  - pmXxxxxxx()          |  거래 진입점
|    @BizUnitBind         |
|    DUCorpEvalHistoryA   |---->  참조 (동일 컴포넌트 내)
+-------------------------+
        |
        | @BizUnitBind 직접 호출
        | IDataSet (처리구분 포함 입력 파라미터)
        v
+-------------------------------+
|  DUCorpEvalHistoryA           |  (DataUnit)
|  - selectExistCheck()         |  THKIPB110 기존재 확인
|  - insertCorpEvalHistory()    |  THKIPB110 신규 INSERT
|  - selectEmployeeInfo()       |  직원기본 조회 (QIPA302)
|  - selectMainDebtAffltYn()   |  주채무계열여부 조회 (QIPA307)
|  - deleteCorpEvalHistoryAll() |  11개 테이블 연쇄 DELETE
|    + deleteThkipb110()        |
|    + deleteThkipb111Loop()    |
|    + deleteThkipb116Loop()    |
|    + deleteThkipb113()        |
|    + deleteThkipb112()        |
|    + deleteThkipb114Loop()    |
|    + deleteThkipb118()        |
|    + deleteThkipb130()        |
|    + deleteThkipb131()        |
|    + deleteThkipb132Loop()    |
|    + deleteThkipb133()        |
|    + deleteThkipb119()        |
+-------------------------------+
        |
        | dbSelect / dbSelectMulti / dbInsert / dbDelete
        v
+-------------------------------+
|  DUCorpEvalHistoryA.xml       |  (XSQL 파일)
|  (MyBatis SQL 매핑)           |
+-------------------------------+
        |
        v
    DB (11개 테이블)


+-------------------------+
|  CCorpEvalConsts        |  (상수 클래스)
|  - STAT_OK = "00"       |
|  - STAT_ERROR = "09"    |
|  - ERR_B3800004         |
|  - NON_CTRC_BZWK = "060"|
|  ...                    |
+-------------------------+
        ^
        | 참조
        |
+------------------+    +------------------+
| PUCorpEvalHistory|    |DUCorpEvalHistoryA|
+------------------+    +------------------+

[공통 컴포넌트 호출 (callSharedMethodByDirect)]
PUCorpEvalHistory --callSharedMethodByDirect--> com.kbstar.kji.enbncmn / FUBc* 클래스
  (IJICOMM 대응: CommonArea 초기화는 프레임워크 자동 처리 또는 공통 FU 호출)
```

---

### 2.4 인터페이스 및 추상 클래스 설계 계획

n-KESA 프레임워크는 `ProcessUnit`, `DataUnit` 추상 클래스를 프레임워크가 제공하므로 별도 인터페이스/추상 클래스 정의 불필요. 단, 아래 설계 지침을 준수한다.

| 설계 포인트 | 내용 |
|-----------|------|
| Unit 클래스 싱글톤 | PU/DU 모두 싱글톤 인스턴스. 멤버 필드(인스턴스 변수) 절대 사용 금지 |
| 허용 멤버 필드 | `@BizUnitBind` 어노테이션이 붙은 DU 참조 필드만 허용 |
| 메서드 내 로컬 변수 | COBOL WK-AREA 항목은 모두 메서드 내 로컬 변수로 처리 |
| 상수 클래스 | final 키워드 금지 (핫 디플로이를 위해 `public static`만 사용) |

---

## 3. 패키지 구조 정의 (Package Structure Definition)

### 3.1 최상위 패키지 네이밍 규칙

n-KESA 가이드 기준:
```
com.kbstar.[appCode3].[componentId]
```

- **appCode3**: `kip` (KIP 기업집단신용평가 업무 어플리케이션 코드)
- **componentId**: `enbipba` (기업집단신용평가이력관리 컴포넌트 ID, AIPBA30 기반 명명)

**최상위 패키지**:
```
com.kbstar.kip.enbipba
```

---

### 3.2 레이어별 패키지 구조

```
com.kbstar.kip.enbipba/
├── biz/          ← PU, DU 클래스 (비즈니스 로직 본체)
├── uio/          ← PM/DM의 IO 정보 XML 파일 (PU/DU와 1:1 생성)
├── xsql/         ← SQL XML 파일 (DU와 동일 이름으로 1:1 생성)
├── consts/       ← 상수 클래스 (CCorpEvalConsts)
└── util/         ← 컴포넌트 내 기타 POJO 유틸리티 (필요시)
```

---

### 3.3 각 패키지에 배치될 클래스 매핑표

| 패키지 | 클래스 / 파일명 | COBOL 대응 | 역할 |
|--------|--------------|-----------|------|
| `com.kbstar.kip.enbipba.biz` | `PUCorpEvalHistory.java` | AIPBA30.cbl (AS) | ProcessUnit 본체 |
| `com.kbstar.kip.enbipba.biz` | `DUCorpEvalHistoryA.java` | DIPA301.cbl (DC) | DataUnit 본체 |
| `com.kbstar.kip.enbipba.consts` | `CCorpEvalConsts.java` | CO-AREA, CO-ERROR-AREA | 상태/에러/조치 상수 |
| `com.kbstar.kip.enbipba.xsql` | `DUCorpEvalHistoryA.xml` | DBIO/SQLIO 45건 | MyBatis SQL 매핑 XML |
| `com.kbstar.kip.enbipba.uio` | `PUCorpEvalHistory.xml` | YNIPBA30 / YPIPBA30 | PM 입출력 IO 정보 XML |
| `com.kbstar.kip.enbipba.uio` | `DUCorpEvalHistoryA.xml` (uio) | XDIPA301 카피북 | DM 입출력 IO 정보 XML |

**공통 컴포넌트 (변환 대상 외, 참조만)**:

| 패키지 | 클래스 | 역할 |
|--------|--------|------|
| `com.kbstar.kji.enbncmn.biz` | `FUBcNumbering` | 채번 유틸리티 (공통 컴포넌트) |
| `com.kbstar.kji.enbncmn.biz` | `FUBcEmployee` | 직원기본 조회 (공통 컴포넌트) |
| `com.kbstar.kji.enbncmn.biz` | `FUBcBranch` | 부점기본 조회 (공통 컴포넌트) |
| `com.kbstar.kji.enbncmn.biz` | `FUBcMessage` | 에러메시지 조회 (공통 컴포넌트) |

---

## 4. 사내 프레임워크 패턴 적용 계획 (Internal Framework Pattern Application)

### 4.1 analysis_spec.md에서 식별된 사내 프레임워크 컴포넌트 목록

| COBOL 구조 / 매크로 | n-KESA 프레임워크 컴포넌트 | 적용 방법 |
|-------------------|------------------------|---------|
| AS 프로그램 (AIPBA30) | `ProcessUnit` (com.kbstar.sqc.base.ProcessUnit) | `PUCorpEvalHistory extends ProcessUnit` |
| DC 프로그램 (DIPA301) | `DataUnit` (com.kbstar.sqc.base.DataUnit) | `DUCorpEvalHistoryA extends DataUnit` |
| YCCOMMON (공통영역) | `IOnlineContext` + `CommonArea` | `getCommonArea(onlineCtx)` |
| IJICOMM (공통IC) | `CommonArea` 자동 세팅 또는 공통 FU 호출 | PM 시작 시 `getCommonArea(onlineCtx)` 활용 |
| #DYCALL DIPA301 | `@BizUnitBind` + 직접 메서드 호출 | 동일 컴포넌트 내이므로 `@BizUnitBind private DUCorpEvalHistoryA duCorpEvalHistoryA` |
| DBIO SELECT-CMD-N/Y | `DataUnit.dbSelect()` | `IDataSet result = dbSelect("sqlId", param)` |
| DBIO SELECT 다건 | `DataUnit.dbSelectMulti()` | `IRecordSet rs = dbSelectMulti("sqlId", param)` |
| DBIO INSERT-CMD-Y | `DataUnit.dbInsert()` | `int rows = dbInsert("sqlId", param)` |
| DBIO DELETE-CMD-Y | `DataUnit.dbDelete()` | `int rows = dbDelete("sqlId", param)` |
| DBIO CURSOR(OPEN-FETCH-CLOSE) | `dbSelectMulti()` → List 루프 처리 | 커서 전체를 List로 조회 후 반복 삭제 |
| #DYSQLA (SQLIO) | `DataUnit.dbSelectMulti()` + XSQL 복합 SQL | XSQL XML에 복합 SELECT 작성 |
| #ERROR | `throw new BusinessException(errCd, treatCd, msg)` | PM의 catch 블록 또는 DM 내 직접 throw |
| #OKEXIT | `return responseData` | PM/DM 정상 종료 |
| #USRLOG | `log.debug()` | ILog 획득 후 디버그 로그 |
| #BOFMID | `responseData.put("formId", formId)` | 응답 데이터에 폼ID 설정 (프레임워크 자동 처리 여부 확인 필요) |
| CJIER01 (에러메시지 조회) | `FUBcMessage.getErrorMessage()` | `callSharedMethodByDirect("com.kbstar.kji.enbncmn", "FUBcMessage.getErrorMessage", req, onlineCtx)` |
| CJIHR01 (직원기본 조회) | `FUBcEmployee.getPafiarEmpInfo()` | QIPA302 SQLIO 대응. callSharedMethodByDirect 활용 |

---

### 4.2 각 COBOL 구조에 적용할 프레임워크 패턴

#### AIPBA30 → PUCorpEvalHistory 패턴

| COBOL Paragraph | n-KESA PM 패턴 |
|----------------|--------------|
| S0000-MAIN-RTN (PERFORM 4회) | PM 메서드 본체. try-catch 구조로 4단계 처리 |
| S1000-INITIALIZE-RTN | PM 상단: `IDataSet responseData = new DataSet()`, `CommonArea ca = getCommonArea(onlineCtx)`, 비계약업무구분코드 상수 확인 |
| S2000-VALIDATION-RTN | try 블록 내 4개 필수 입력값 검증. blank 체크 후 `throw new BusinessException("B3800004", "UKIF0072", ...)` |
| S3000-PROCESS-RTN | DU 호출: `IDataSet param = new DataSet(); param.put(...); IDataSet duResult = duCorpEvalHistoryA.manageCorpEvalHistory(param, onlineCtx);` |
| S9000-FINAL-RTN | `return responseData;` |

**PM 메서드명 결정**:
- `pm` + 거래코드(10자리) 형식
- 거래코드 미확정 시 TBD: `pmAipba30Xxxx01` (실제 거래코드 확보 후 확정)

#### DIPA301 → DUCorpEvalHistoryA 패턴

처리구분 분기 방식:

```
DM: manageCorpEvalHistory(requestData, onlineCtx)
├── prcssDstcd = "01" → insertCorpEvalHistory(param, onlineCtx)
│     ├── selectExistCheck(param, onlineCtx)          ← QIPA301 SQLIO
│     ├── selectMainDebtAffltYn(param, onlineCtx)     ← QIPA307 SQLIO
│     ├── selectEmployeeInfo(param, onlineCtx)         ← QIPA302 SQLIO
│     └── dbInsert("insertThkipb110", param)           ← DBIO INSERT
├── prcssDstcd = "02" → 무동작 return (TBD: 업무팀 확인)
└── prcssDstcd = "03" → deleteCorpEvalHistoryAll(param, onlineCtx)
      ├── deleteThkipb110(param, onlineCtx)            ← SELECT(LOCK) + DELETE
      ├── deleteThkipb111Loop(param, onlineCtx)        ← selectList + DELETE loop
      ├── deleteThkipb116Loop(param, onlineCtx)        ← selectList + DELETE loop
      ├── deleteThkipb113(param, onlineCtx)            ← QIPA303 + DELETE loop
      ├── deleteThkipb112(param, onlineCtx)            ← QIPA304 + DELETE loop
      ├── deleteThkipb114Loop(param, onlineCtx)        ← selectList + DELETE loop
      ├── deleteThkipb118(param, onlineCtx)            ← SELECT(LOCK) + DELETE
      ├── deleteThkipb130(param, onlineCtx)            ← QIPA305 + DELETE loop
      ├── deleteThkipb131(param, onlineCtx)            ← SELECT(LOCK) + DELETE
      ├── deleteThkipb132Loop(param, onlineCtx)        ← selectList + DELETE loop
      ├── deleteThkipb133(param, onlineCtx)            ← QIPA306 + DELETE loop
      └── deleteThkipb119(param, onlineCtx)            ← QIPA308 + DELETE loop
```

**DM 메서드 설계 원칙**:
- `manageCorpEvalHistory`: 처리구분 분기 + 각 서브 DM 호출 (메인 진입 DM)
- private 헬퍼 메서드(`_deleteThkipb110`, `_selectExistCheck` 등)로 세부 처리 분리
- DU에서 다른 DU 호출 금지 — 모든 처리를 단일 DUCorpEvalHistoryA 내에서 완결

---

### 4.3 프레임워크 적용 시 주의사항 및 커스터마이징 포인트

| 항목 | 주의사항 |
|------|---------|
| 싱글톤 스레드 안전성 | DU/PU 클래스는 싱글톤. WK-AREA(WK-DATA-YN, WK-EMP-HANGL-FNAME, WK-I 등) 항목을 절대 멤버 필드로 선언하지 말 것 — 모두 메서드 내 로컬 변수로 처리 |
| 트랜잭션 경계 | 처리구분 '03' 삭제 시 11개 테이블 전체가 단일 트랜잭션 내에 있어야 함. 프레임워크가 관리하므로 임의 Commit/Rollback 금지. PM 레벨에서 트랜잭션 경계 자동 설정됨 |
| 에러 전파 패턴 | COBOL: DC의 #ERROR는 파라미터 Return 영역에만 조립 → AS에서 재발행 필요. Java: DM 내 `throw new BusinessException`은 PM의 catch에서 자동 전파 — 별도 재발행 불필요 |
| NOTFOUND 처리 | COND-XDIPA301-NOTFOUND('02')는 AIPBA30에서 정상 처리로 간주. PM에서 DM 결과가 null/empty인 경우 그대로 정상 응답 |
| DBIO 커서 → List 전환 | COBOL OPEN-FETCH-CLOSE 커서 패턴 → `dbSelectMulti` + `IRecordSet` 루프 삭제로 전환. 대용량 데이터 시 bulk delete 검토 필요 |
| 이중 입력 검증 | AS(AIPBA30)와 DC(DIPA301) 양쪽에서 동일 필드를 검증. Java 전환 시 PM(PU)에서만 검증하고 DM(DU)에서는 생략하는 방향 권고 (단, 에러코드/조치코드 차이 확인 필요) |
| BICOM 공통영역 직접 참조 | DIPA301에서 `BICOM-GROUP-CO-CD`, `BICOM-USER-EMPID`, `BICOM-BRNCD` 등을 직접 참조. Java에서는 `CommonArea ca = getCommonArea(onlineCtx)` → `ca.getGroupCoCd()`, `ca.getBranchCd()` 등으로 대응 |
| 상수 클래스 final 금지 | `CCorpEvalConsts`의 상수에 `final` 키워드 미사용. 핫 디플로이를 위해 `public static String STAT_OK = "00"` 형태로만 선언 |
| BigDecimal 사용 | 금액 관련 필드가 존재할 경우 반드시 `BigDecimal.valueOf()` 또는 `new BigDecimal("0.0")` 형태 사용. `new BigDecimal(0.1)` 형태 금지 |

---

### 4.4 의존성 주입(DI) 설계 방향

n-KESA 프레임워크는 `@BizUnitBind` 어노테이션으로 DI를 수행한다 (Spring DI가 아닌 프레임워크 자체 메커니즘).

```
PUCorpEvalHistory:
  @BizUnitBind private DUCorpEvalHistoryA duCorpEvalHistoryA;
  ← 동일 컴포넌트(com.kbstar.kip.enbipba) 내 DU이므로 직접 주입 가능
```

공통 컴포넌트(IJICOMM, CJIHR01 등) 호출은 `@BizUnitBind` 불가 (타 컴포넌트) → `callSharedMethodByDirect` API 사용:

```
callSharedMethodByDirect(
  "com.kbstar.kji.enbncmn",
  "FUBcEmployee.getPafiarEmpInfo",
  param, onlineCtx
)
```

**설계 원칙**: DU 내에서 공통 유틸리티 호출이 필요한 경우(QIPA302 직원조회 등), DU 자체에서 `callSharedMethodByDirect`를 직접 호출하거나 해당 조회 SQL을 XSQL에 포함하는 두 가지 방안 중 선택 필요 (권고: XSQL에 JOIN 또는 서브쿼리 형태로 포함하여 네트워크 호출 최소화).

---

## 5. COBOL→Java 변환 규칙 매핑 테이블

### 5.1 프레임워크 구조 매핑

| COBOL 구조/명령 | Java 대응 요소 | 변환 규칙 설명 | 비고 |
|---------------|-------------|--------------|------|
| AS 프로그램 (AIPBA30) | `ProcessUnit` + PM 메서드 | `PUCorpEvalHistory extends ProcessUnit` + `pmXxx(IDataSet, IOnlineContext)` | 거래 진입점 1:1 대응 |
| DC 프로그램 (DIPA301) | `DataUnit` + DM 메서드 | `DUCorpEvalHistoryA extends DataUnit` + DM 메서드 군 | DM 이름: `manageCorpEvalHistory`, `insertCorpEvalHistory`, `deleteCorpEvalHistoryAll` 등 |
| S0000-MAIN-RTN | PM 메서드 본체 | `public IDataSet pmXxx(IDataSet requestData, IOnlineContext onlineCtx)` 전체 구조 | try-catch 필수 |
| S1000-INITIALIZE-RTN | PM 메서드 상단 초기화 블록 | `IDataSet responseData = new DataSet(); CommonArea ca = getCommonArea(onlineCtx);` | #GETOUT → new DataSet() |
| S2000-VALIDATION-RTN | try 블록 내 입력값 검증 | `if (StringUtils.isBlank(prcssDstcd)) { throw new BusinessException("B3800004", "UKIF0072", ...); }` | 4개 필수항목 |
| S3000-PROCESS-RTN | try 블록 내 DU 호출 | `IDataSet param = new DataSet(); param.put(...); IDataSet duResult = duCorpEvalHistoryA.manageCorpEvalHistory(param, onlineCtx);` | 원본 requestData 직접 전달 금지 |
| S9000-FINAL-RTN | `return responseData` | PM 정상 종료 | #OKEXIT 대응 |
| EVALUATE XDIPA301-I-PRCSS-DSTCD | `if-else if` 또는 `switch-case` | 처리구분 '01'/'02'/'03' 분기 | COBOL EVALUATE → Java switch-case |
| PERFORM VARYING WK-I | `for` 루프 또는 `IRecordSet` 순회 | 커서 FETCH 루프 → dbSelectMulti 결과 IRecordSet 루프 | COND-DBIO-MRNF → 반복 종료 조건 |

---

### 5.2 COBOL 매크로 매핑

| COBOL 구조/명령 | Java 대응 요소 | 변환 규칙 설명 | 비고 |
|---------------|-------------|--------------|------|
| `#DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA` | `getCommonArea(onlineCtx)` | IJICOMM 호출은 공통 컨텍스트 초기화. 비계약업무구분코드('060') 세팅은 상수로 처리 | MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD 대응 |
| `#DYCALL DIPA301 YCCOMMON-CA XDIPA301-CA` | `duCorpEvalHistoryA.manageCorpEvalHistory(param, onlineCtx)` | @BizUnitBind 주입 후 직접 메서드 호출 | 동일 컴포넌트 내 호출 |
| `#ERROR errCd treatCd stat` | `throw new BusinessException(errCd, treatCd, customMsg)` | BusinessException은 PM까지 자동 전파됨. DM/FM에서도 직접 throw 가능 | re-throw 불필요 |
| `#ERROR XDIPA301-R-ERRCD XDIPA301-R-TREAT-CD XDIPA301-R-STAT` | DM 내 BusinessException throw → PM catch에서 re-throw | DM에서 throw한 BusinessException은 PM의 `catch(BusinessException e) { throw e; }`로 자동 처리 | 별도 재발행 불필요 |
| `#OKEXIT CO-STAT-OK` | `return responseData` | PM 정상 종료 | |
| `#GETOUT YPIPBA30-CA` | `IDataSet responseData = new DataSet()` | PM 출력영역 확보 | |
| `#USRLOG "★[구간명]"` | `log.debug("★[구간명]")` | ILog 획득: `ILog log = getLog(onlineCtx)` | 운영환경 debug OFF 주의 |
| `#BOFMID WK-FMID` | `responseData.put("formId", formId)` 또는 프레임워크 자동처리 | WK-FMID 조립: `"V1" + BICOM-SCREN-NO` | 프레임워크 처리 방식 확인 TBD |
| `INITIALIZE WK-AREA` | 각 로컬 변수 초기화 또는 생략 | Java 기본형/String은 null/0으로 초기화됨 | 명시적 초기화 필요 시 `String wkDataYn = null` |
| `MOVE YNIPBA30-CA TO XDIPA301-IN` | 필드별 명시적 `param.put("key", requestData.getString("key"))` | 구조 전체 복사 → 필드별 매핑으로 변환 (HIGH-02 위험항목) | IDataSet 키 명세 확보 후 1:1 매핑 |

---

### 5.3 DB 접근 매핑

| COBOL 구조/명령 | Java 대응 요소 | 변환 규칙 설명 | 비고 |
|---------------|-------------|--------------|------|
| `#DYDBIO SELECT-CMD-N TKIPB110-PK TRIPB110-REC` | `IDataSet result = dbSelect("selectThkipb110", param)` | 비잠금 단건 SELECT | NOTFOUND 시 result == null |
| `#DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC` | `IDataSet result = dbSelect("selectThkipb110ForUpdate", param)` | 잠금 SELECT (FOR UPDATE) | XSQL에 FOR UPDATE 명시 |
| `#DYDBIO INSERT-CMD-Y TKIPB110-PK TRIPB110-REC` | `int rows = dbInsert("insertThkipb110", param)` | 잠금 INSERT | 반환 rows == 0이면 오류 처리 |
| `#DYDBIO DELETE-CMD-Y TKIPB110-PK TRIPB110-REC` | `int rows = dbDelete("deleteThkipb110", param)` | 잠금 DELETE | |
| `#DYDBIO OPEN-CMD-1 TKIPB111-PK` | `IRecordSet rs = dbSelectMulti("selectListThkipb111ForUpdate", param)` | CURSOR OPEN-FETCH-CLOSE 패턴 전체를 다건 SELECT로 대체 | COBOL 커서 루프 → IRecordSet 루프 |
| `#DYDBIO FETCH-CMD-1 TRIPB111-REC` | `for (int i=0; i<rs.getRecordCount(); i++) { IRecord rec = rs.getRecord(i); ... }` | FETCH 루프 → IRecordSet 인덱스 루프 | |
| `#DYDBIO CLOSE-CMD-1` | 루프 종료 (자동) | Java IRecordSet 사용 후 별도 Close 불필요 | |
| `#DYSQLA QIPA301 SELECT XQIPA301-CA` | `IDataSet result = dbSelect("selectExistCheckQipa301", param)` | SQLIO 복합 SELECT → XSQL XML에 복합 쿼리 작성 | SQL 내용은 SQLIO 소스 확보 후 재현 |
| `#DYSQLA QIPA302 SELECT XQIPA302-CA` | `IDataSet result = dbSelect("selectEmployeeInfoQipa302", param)` | 직원기본 조회 SQLIO → XSQL 또는 FUBcEmployee 공통 유틸로 대체 | |
| `#DYSQLA QIPA303~QIPA308 SELECT` | `IRecordSet rs = dbSelectMulti("selectPksQipa30X", param)` | 삭제 대상 PK 목록 조회 → IRecordSet 반환 후 루프 삭제 | SQL 내용 SQLIO 소스 확보 후 재현 |
| `COPY YCDBSQLA` | `DataUnit` 상속으로 자동 제공 | SQLIO 공통 인터페이스 → dbSelect/dbSelectMulti/dbInsert/dbUpdate/dbDelete 메서드 내장 | 별도 선언 불필요 |
| `COPY YCDBIOCA` | `DataUnit` 상속으로 자동 제공 | DBIO 공통 인터페이스 → 동일 | 별도 선언 불필요 |
| `COND-DBIO-OK ('00')` | `result != null` / `rows > 0` | 정상 결과 확인 | |
| `COND-DBIO-MRNF ('02')` | `result == null` / `rs.getRecordCount() == 0` | Not Found 확인 | |
| `COND-DBIO-DUPM ('01')` | `DataException` catch 또는 rows 확인 | 중복 키 오류 | |

---

### 5.4 데이터 타입 매핑

| COBOL 구조/명령 | Java 대응 요소 | 변환 규칙 설명 | 비고 |
|---------------|-------------|--------------|------|
| `PIC X(n)` 문자열 | `String` | COBOL 알파뉴메릭 → Java String | 후행 공백은 `.trim()` 처리 |
| `PIC 9(n)` 양수 정수 | `int` (n<=9) / `long` (n>9) | COBOL 부호없는 정수 → Java int/long | |
| `PIC 9(n)V9(m)` 소수 | `BigDecimal` | 금액/비율 → BigDecimal 필수. `BigDecimal.valueOf()` 또는 `new BigDecimal("0")` 사용 | `new BigDecimal(double)` 금지 |
| `PIC S9(n)` 부호있는 정수 | `int` / `long` | SQLCODE 등 | |
| `PIC S9(n) LEADING SEPARATE` | `int` | XDIPA301-R-SQL-CD 대응 | 부호 처리 Java int 범위 내 |
| `PIC 9(n) COMP` (Binary) | `int` | WK-I 루프 카운터 대응 (2bytes binary → int) | |
| `PIC X(1) VALUE 'Y'/'N'` 플래그 | `String` 또는 `boolean` | WK-DATA-YN, WK-MAIN-DEBT-AFFLT-YN | 권고: "Y"/"N" String 유지 (DB 컬럼 타입 일치) |
| `OCCURS n TIMES` 배열 | `IRecordSet` + `IRecord` | COBOL 배열 → IRecordSet | `rs.getRecord(i).getString("fieldName")` |
| `88 CONDITION-NAME VALUE 'xx'` | `static final String` 상수 비교 | `CCorpEvalConsts.STAT_OK.equals(stat)` | 상수 클래스에 정의 |
| `WK-AREA` 변수 전체 | 메서드 내 로컬 변수 | 멤버 필드 절대 금지 | 메서드 시작 시 선언 |
| `CO-AREA` / `CO-ERROR-AREA` 상수 | `CCorpEvalConsts` 상수 클래스 | `CCorpEvalConsts.ERR_B3800004` 형태로 참조 | |

---

### 5.5 공통 유틸리티 매핑

| COBOL 유틸리티 | Java 대응 | 변환 규칙 설명 | 비고 |
|--------------|---------|--------------|------|
| IJICOMM (공통IC) | `getCommonArea(onlineCtx)` | 공통정보 초기화. 비계약업무구분코드('060') 세팅은 PM에서 상수 처리 | 프레임워크 자동 초기화 여부 확인 TBD |
| CJIHR01 (직원기본조회) | `FUBcEmployee.getPafiarEmpInfo()` | `callSharedMethodByDirect("com.kbstar.kji.enbncmn", "FUBcEmployee.getPafiarEmpInfo", req, onlineCtx)` | QIPA302 SQLIO 대응. XSQL JOIN 방식과 비교 검토 |
| CJIER01 (에러메시지조회) | `FUBcMessage.getMessageCode()` | `callSharedMethodByDirect("com.kbstar.kji.enbncmn", "FUBcMessage.getMessageCode", req, onlineCtx)` | |
| CJIBR01 (부점기본조회) | `FUBcBranch.getBranchBasic()` | BICOM-BRNCD 대응 부점 조회 시 활용 | |

---

### 5.6 XSQL 파일 SQL ID 명세

XSQL 파일명: `DUCorpEvalHistoryA.xml`
namespace: `DUCorpEvalHistoryA`

| SQL ID | 종류 | 대응 COBOL 구조 | 대상 테이블 |
|--------|------|----------------|-----------|
| `selectExistCheckQipa301` | select | SQLIO QIPA301 | THKIPB110 (처리단계='6' 확정 기존재 확인) |
| `selectMainDebtAffltYnQipa307` | select | SQLIO QIPA307 | 주채무계열 테이블 (미상, SQLIO 소스 확보 필요) |
| `selectEmployeeInfoQipa302` | select | SQLIO QIPA302 | 직원기본 테이블 (미상) |
| `insertThkipb110` | insert | DBIO INSERT-CMD-Y THKIPB110 | THKIPB110 기업집단평가기본 |
| `selectThkipb110ForUpdate` | select | DBIO SELECT-CMD-Y THKIPB110 | THKIPB110 (DELETE 전 LOCK) |
| `deleteThkipb110` | delete | DBIO DELETE-CMD-Y THKIPB110 | THKIPB110 |
| `selectListThkipb111ForUpdate` | select | DBIO OPEN/FETCH/CLOSE THKIPB111 | THKIPB111 기업집단연혁명세 |
| `deleteThkipb111` | delete | DBIO DELETE-CMD-Y THKIPB111 | THKIPB111 |
| `selectListThkipb116ForUpdate` | select | DBIO OPEN/FETCH/CLOSE THKIPB116 | THKIPB116 기업집단계열사명세 |
| `deleteThkipb116` | delete | DBIO DELETE-CMD-Y THKIPB116 | THKIPB116 |
| `selectPksQipa303` | select | SQLIO QIPA303 | THKIPB113 기업집단사업부분구조분석명세 |
| `selectThkipb113ForUpdate` | select | DBIO SELECT-CMD-Y THKIPB113 | THKIPB113 (DELETE 전 LOCK) |
| `deleteThkipb113` | delete | DBIO DELETE-CMD-Y THKIPB113 | THKIPB113 |
| `selectPksQipa304` | select | SQLIO QIPA304 | THKIPB112 기업집단재무분석목록 |
| `selectThkipb112ForUpdate` | select | DBIO SELECT-CMD-Y THKIPB112 | THKIPB112 (DELETE 전 LOCK) |
| `deleteThkipb112` | delete | DBIO DELETE-CMD-Y THKIPB112 | THKIPB112 |
| `selectListThkipb114ForUpdate` | select | DBIO OPEN/FETCH/CLOSE THKIPB114 | THKIPB114 기업집단항목별평가목록 |
| `deleteThkipb114` | delete | DBIO DELETE-CMD-Y THKIPB114 | THKIPB114 |
| `selectThkipb118ForUpdate` | select | DBIO SELECT-CMD-Y THKIPB118 | THKIPB118 기업집단평가등급조정사유목록 |
| `deleteThkipb118` | delete | DBIO DELETE-CMD-Y THKIPB118 | THKIPB118 |
| `selectPksQipa305` | select | SQLIO QIPA305 | THKIPB130 기업집단주석명세 |
| `selectThkipb130ForUpdate` | select | DBIO SELECT-CMD-Y THKIPB130 | THKIPB130 (DELETE 전 LOCK) |
| `deleteThkipb130` | delete | DBIO DELETE-CMD-Y THKIPB130 | THKIPB130 |
| `selectThkipb131ForUpdate` | select | DBIO SELECT-CMD-Y THKIPB131 | THKIPB131 기업집단승인결의록명세 |
| `deleteThkipb131` | delete | DBIO DELETE-CMD-Y THKIPB131 | THKIPB131 |
| `selectListThkipb132ForUpdate` | select | DBIO OPEN/FETCH/CLOSE THKIPB132 | THKIPB132 기업집단승인결의록위원명세 |
| `deleteThkipb132` | delete | DBIO DELETE-CMD-Y THKIPB132 | THKIPB132 |
| `selectPksQipa306` | select | SQLIO QIPA306 | THKIPB133 기업집단승인결의록의견명세 |
| `selectThkipb133ForUpdate` | select | DBIO SELECT-CMD-Y THKIPB133 | THKIPB133 (DELETE 전 LOCK) |
| `deleteThkipb133` | delete | DBIO DELETE-CMD-Y THKIPB133 | THKIPB133 |
| `selectPksQipa308` | select | SQLIO QIPA308 | THKIPB119 기업집단재무평점단계별목록 |
| `selectThkipb119ForUpdate` | select | DBIO SELECT-CMD-Y THKIPB119 | THKIPB119 (DELETE 전 LOCK) |
| `deleteThkipb119` | delete | DBIO DELETE-CMD-Y THKIPB119 | THKIPB119 |

**합계**: SELECT 13건, INSERT 1건, DELETE 11건 = 총 25개 SQL ID (CURSOR 패턴 통합 후 기준)

---

## 6. 예외 처리 전략 (Exception Handling Strategy)

### 6.1 COBOL 오류 처리 패턴 분석 결과 요약

analysis_spec.md 섹션 4.4 기반:

| 오류 유형 | COBOL 처리 | Java 변환 방향 |
|---------|-----------|--------------|
| 필수항목 누락 | `#ERROR B3800004 UKIF0072 CO-STAT-ERROR` | `throw new BusinessException("B3800004", "UKIF0072", "필수 입력 항목을 확인하세요")` |
| IJICOMM 호출 실패 | `#ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT` | 공통 컨텍스트 초기화 실패 시 BusinessException (동적 에러코드) |
| DC 호출 오류 전파 | `NOT COND-XDIPA301-OK AND NOT COND-XDIPA301-NOTFOUND` → `#ERROR` | DM에서 throw된 BusinessException이 PM catch로 전파 → re-throw |
| DB 중복 (신규평가 기존재) | `B4200023 UKII0182 CO-STAT-ERROR` | `throw new BusinessException("B4200023", "UKII0182", "이미 등록된 정보입니다")` |
| DB 조회/삭제 오류 | `B3900009 UKII0182 CO-STAT-ERROR` | `throw new BusinessException("B3900009", "UKII0182", "DB 처리 오류")` |
| 데이터 삭제 오류 | `B4200219 UKII0182 CO-STAT-ERROR` | `throw new BusinessException("B4200219", "UKII0182", "삭제 처리 오류")` |
| NOTFOUND (정상) | `COND-XDIPA301-NOTFOUND` → 정상 처리 | 예외 없이 null/empty 결과 반환 또는 responseData에 건수 0 설정 |

---

### 6.2 Java 예외 계층 구조 설계

n-KESA 프레임워크는 `BusinessException`을 표준 예외로 제공한다. 별도 커스텀 예외 클래스는 정의하지 않으며, 모든 업무 오류는 `BusinessException`으로 처리한다.

```
java.lang.RuntimeException
└── nexcore.framework.core.exception.BusinessException  [프레임워크 제공]
      ├── 생성자: BusinessException(errCd, treatCd, customMsg)
      └── 생성자: BusinessException(errCd, treatCd, customMsg, cause)
```

**커스텀 예외 클래스**: 현 변환 범위에서 별도 커스텀 예외 클래스 생성 불필요. 프레임워크의 BusinessException 활용.

---

### 6.3 Checked vs Unchecked 예외 사용 기준

| 구분 | 기준 | 예시 |
|------|------|------|
| Unchecked (BusinessException) | 모든 업무 오류 / DB 오류 / 입력 검증 실패 | 필수항목 누락, DB 중복, 조회 실패 |
| Checked Exception | 사용 금지 | n-KESA 표준상 checked exception 사용 지양 |
| Exception (범용) | PM의 catch(Exception e)에서만 처리 후 BusinessException으로 감싸서 re-throw | 예상치 못한 시스템 오류 |

---

### 6.4 공통 예외 핸들러 설계 방향

PM(ProcessUnit) 메서드의 예외 처리 패턴:

```
PM 메서드 구조:
try {
  // 1. 입력 검증
  // 2. DU 호출
  // 3. 출력 조립
} catch (BusinessException e) {
  throw e;                          // BusinessException은 그대로 re-throw
} catch (Exception e) {
  throw new BusinessException(      // 그 외 예외는 BusinessException으로 wrap
    CCorpEvalConsts.ERR_B3900009,
    CCorpEvalConsts.TREAT_UKII0182,
    "시스템 처리 오류가 발생하였습니다",
    e
  );
}
return responseData;
```

DM 메서드: try-catch 불필요. 업무 조건 오류 시 직접 `throw new BusinessException(...)` 가능.

---

### 6.5 로깅 전략

| 로그 레벨 | 사용 시점 | COBOL 대응 |
|---------|---------|-----------|
| `log.debug()` | 개발/검증용 진행 구간 로그, 입력값 확인 | `#USRLOG "★[구간명]"` 전체 |
| `log.info()` | 주요 업무 이벤트 (신규평가 완료, 삭제 완료) | `#SYSLOG` |
| `log.warn()` | NOTFOUND 등 비정상이나 오류가 아닌 케이스 | 해당 없음 (필요시 추가) |
| `log.error()` | BusinessException catch 직전 시스템 오류 | 예외 로그 `log.error("메시지", e)` |

**주의사항**:
- 운영환경에서는 debug 레벨 OFF → 성능 영향 최소화
- 계좌번호, 주민번호 등 민감정보 로그 출력 절대 금지
- `#USRLOG` 패턴(`"★[S2000-VALIDATION-RTN]"` 등) → `log.debug("★[S2000-VALIDATION-RTN]")` 1:1 대응

---

### 6.6 트랜잭션 롤백 정책

- **기본 원칙**: 프레임워크가 트랜잭션 Commit/Rollback을 자동 관리. 임의 호출 절대 금지
- **롤백 트리거**: PM에서 BusinessException 또는 Exception이 전파되면 프레임워크가 자동 Rollback
- **처리구분 '03' 삭제 트랜잭션**: 11개 테이블 연쇄 삭제는 단일 PM 거래 트랜잭션 내에서 처리됨. 중간 테이블 삭제 실패 시 전체 Rollback (프레임워크 자동)
- **NOTFOUND 정상 처리**: COND-XDIPA301-NOTFOUND('02')는 예외 발생 없이 정상 return → Rollback 없음

---

## 7. 변환 우선순위 및 단계별 계획 (Conversion Priority & Phased Plan)

### 7.1 모듈별 변환 복잡도 평가

| 모듈 | 복잡도 | 근거 |
|------|--------|------|
| CCorpEvalConsts (상수 클래스) | 하 | 단순 상수 정의. COBOL CO-AREA 직접 매핑 |
| PUCorpEvalHistory (ProcessUnit) | 하~중 | AS 프로그램 255행. 입력 검증 + DC 호출 + 출력조립. 표준 PM 패턴 |
| DUCorpEvalHistoryA - 처리구분 '01' (INSERT) | 중 | INSERT 1건 + SQLIO 2건(QIPA301, QIPA307). SQLIO 소스 미확보가 위험 |
| DUCorpEvalHistoryA - 처리구분 '02' (확정취소) | 하 | 현행 무동작. 주석 처리 후 TBD |
| DUCorpEvalHistoryA - 처리구분 '03' (삭제) | 상 | 11개 테이블 연쇄 DELETE. CURSOR 패턴 4개 + SQLIO 5건 포함. 가장 복잡 |
| DUCorpEvalHistoryA.xml (XSQL) | 상 | 25개 SQL ID. SQLIO 소스(8건) 미확보로 SQL 역설계 필요 |
| 직원조회 (QIPA302) | 중 | SQLIO 소스 미확보. FUBcEmployee 공통 유틸 또는 XSQL JOIN 방식 결정 필요 |

---

### 7.2 변환 순서 및 단계 정의

**변환 원칙**: Bottom-Up. 피의존 모듈 먼저 구현.

#### 1단계: 사전 준비 (선행 조건)

| 작업 | 내용 | 필요 자료 |
|------|------|---------|
| SQLIO 소스 확보 | QIPA301~QIPA308 SQL 역설계 | SQLIO 소스 파일 또는 DBA 지원 |
| 테이블 Copybook 보완 | TRIPB110~TRIPB133, TKIPB110~TKIPB133 컬럼 정의 | db/ 폴더 xls (THKIPA110~121) 활용 |
| 처리구분 '02' 업무 확인 | 확정취소 무동작이 의도적인지 확인 | 업무담당자 확인 |
| 거래코드 확인 | PM 메서드명에 사용할 10자리 거래코드 확보 | 거래코드 테이블 |

#### 2단계: 상수 및 공통 구조 구현

| 순서 | 대상 | 내용 |
|------|------|------|
| 2-1 | CCorpEvalConsts | 모든 상태/에러/조치 코드 상수 클래스 생성 |
| 2-2 | XSQL XML (조회용) | 상대적으로 단순한 SELECT SQL 먼저 작성 (THKIPB110 기존재 확인 등) |

#### 3단계: DU 구현 (처리구분 '01' 먼저)

| 순서 | 대상 | 내용 |
|------|------|------|
| 3-1 | selectExistCheck DM | QIPA301 SQLIO → selectExistCheckQipa301 XSQL + DM |
| 3-2 | selectMainDebtAffltYn DM | QIPA307 SQLIO → XSQL + DM |
| 3-3 | selectEmployeeInfo DM | QIPA302 SQLIO → XSQL 또는 FUBcEmployee 공통 유틸 |
| 3-4 | insertCorpEvalHistory DM | THKIPB110 INSERT → insertThkipb110 XSQL + DM |
| 3-5 | manageCorpEvalHistory DM (처리구분 '01') | 위 DM 조합. INSERT 분기 완성 |

#### 4단계: DU 구현 (처리구분 '03' 삭제)

| 순서 | 대상 | 내용 |
|------|------|------|
| 4-1 | deleteThkipb110 DM | SELECT(LOCK) + DELETE. 가장 단순한 삭제 패턴 |
| 4-2 | deleteThkipb111Loop DM | CURSOR 패턴 → selectList + 루프 DELETE |
| 4-3 | deleteThkipb116Loop DM | 동일 패턴 |
| 4-4 | deleteThkipb113 DM | QIPA303 + SELECT(LOCK) + DELETE |
| 4-5 | deleteThkipb112 DM | QIPA304 + SELECT(LOCK) + DELETE |
| 4-6 | deleteThkipb114Loop DM | CURSOR 패턴 |
| 4-7 | deleteThkipb118 DM | SELECT(LOCK) + DELETE |
| 4-8 | deleteThkipb130 DM | QIPA305 + SELECT(LOCK) + DELETE |
| 4-9 | deleteThkipb131 DM | SELECT(LOCK) + DELETE |
| 4-10 | deleteThkipb132Loop DM | CURSOR 패턴 |
| 4-11 | deleteThkipb133 DM | QIPA306 + SELECT(LOCK) + DELETE |
| 4-12 | deleteThkipb119 DM | QIPA308 + SELECT(LOCK) + DELETE |
| 4-13 | deleteCorpEvalHistoryAll DM | 위 12개 DM 호출 조합. 삭제 분기 완성 |
| 4-14 | manageCorpEvalHistory DM (전체) | 처리구분 '01'/'02'/'03' 분기 완성 |

#### 5단계: PU 구현

| 순서 | 대상 | 내용 |
|------|------|------|
| 5-1 | PUCorpEvalHistory (기본 구조) | 클래스 골격, @BizUnitBind, PM 메서드 서명 |
| 5-2 | PM 입력 검증 로직 | 4개 필수항목 SPACE 체크 |
| 5-3 | PM DU 호출 및 출력 조립 | DU manageCorpEvalHistory 호출, responseData 조립 |
| 5-4 | PM 폼ID 설정 | WK-FMID 조립 로직 |

#### 6단계: 통합 검증

| 순서 | 대상 | 내용 |
|------|------|------|
| 6-1 | 처리구분 '01' 통합 테스트 | 신규평가 신규/중복 케이스 |
| 6-2 | 처리구분 '03' 통합 테스트 | 11개 테이블 삭제 트랜잭션 검증 |
| 6-3 | 처리구분 '02' 검증 | 무동작 확인 |
| 6-4 | 에러 케이스 검증 | 필수항목 누락, DB 오류, Not Found |

---

### 7.3 각 단계별 산출물 목록

| 단계 | 산출물 | 비고 |
|------|--------|------|
| 1단계 | SQLIO SQL 역설계서, 테이블 컬럼 매핑표, 처리구분 '02' 업무 확인서 | conversion-agent 착수 전 필수 |
| 2단계 | CCorpEvalConsts.java, DUCorpEvalHistoryA.xml (조회 SQL) | |
| 3단계 | DUCorpEvalHistoryA.java (처리구분 '01' 완성), DUCorpEvalHistoryA.xml (INSERT+조회 SQL) | |
| 4단계 | DUCorpEvalHistoryA.java (처리구분 '03' 완성), DUCorpEvalHistoryA.xml (DELETE SQL 전체) | |
| 5단계 | PUCorpEvalHistory.java (완성), PUCorpEvalHistory.xml (uio) | |
| 6단계 | validation_report.md, test_report.md | validation-agent, unittest-agent |

---

## 8. 리스크 및 고려사항 (Risks & Considerations)

### 8.1 변환 시 예상되는 기술적 리스크

| 리스크 ID | 리스크 | 위험도 | 영향 | 대응 방안 |
|---------|--------|--------|------|---------|
| R-01 | SQLIO 소스 미확보 (QIPA301~QIPA308) | 상 | XSQL SQL 작성 불가. 기능 재현 불가 | DBA 또는 메인프레임 팀에서 SQLIO 소스 확보. 불가 시 테이블 스키마 + 업무 로직 기반 SQL 역설계 |
| R-02 | 테이블 Copybook 미확보 (12쌍 TR/TK) | 상 | INSERT 필드 목록, SELECT 결과 컬럼 불명확 | db/ 폴더 xls(THKIPA110~121) 보완. 실제 테이블 스키마 DESC 조회 |
| R-03 | 처리구분 '02' 확정취소 무동작 (HIGH-03) | 상 | 의도적이면 현행 유지, 미구현이면 추가 설계 필요 | 업무담당자 확인 필수. 계획서 작성 전 결정 권고 |
| R-04 | MOVE YNIPBA30-CA TO XDIPA301-IN 전체 복사 (HIGH-02) | 중 | 필드 순서 불일치 시 데이터 오류 | IDataSet 필드별 명시적 복사로 변환. YNIPBA30.cpy와 XDIPA301.cpy 필드 1:1 검증 |
| R-05 | BICOM 공통영역 직접 참조 (MEDIUM-04) | 중 | YCCOMMON 카피북 미확보로 CommonArea 매핑 불명확 | YCCOMMON 카피북 확보 또는 n-KESA CommonArea 클래스의 getter 메서드 목록으로 매핑 |
| R-06 | DBIO CURSOR 패턴 대용량 처리 (MEDIUM-01) | 중 | 대용량 데이터 시 메모리/성능 이슈 | 테이블별 최대 데이터 건수 확인 후 bulk delete 또는 페이징 처리 검토 |
| R-07 | 이중 입력 검증 처리 방향 (MEDIUM-03) | 하 | PU와 DU 양쪽 검증 시 코드 중복, 에러코드 불일치 가능 | PU(PM)에서만 검증, DU(DM)에서 생략 방향으로 합의. 에러코드/조치코드 확인 필요 |
| R-08 | IJICOMM 초기화 재설정 이중 패턴 (MEDIUM-05) | 하 | 중복 MOVE 제거 여부 불명확 | IJICOMM 동작 확인 후 결정. 안전을 위해 현행 유지 권고 |
| R-09 | 거래코드 미확정 | 하 | PM 메서드명 결정 불가 | 거래코드 확보 후 메서드명 확정. 임시로 `pmAipba30` 사용 |

---

### 8.2 성능 고려사항

| 항목 | 내용 | 권고 |
|------|------|------|
| 처리구분 '03' 삭제 성능 | 11개 테이블 순차 삭제 시 개별 SELECT(LOCK) + DELETE 반복 | 테이블별 최대 건수 파악. 건수가 많은 테이블(THKIPB111, THKIPB116 등)은 bulk delete(IN 절 또는 MyBatis foreach) 검토 |
| CURSOR 패턴 → List 전환 | COBOL OPEN-FETCH-CLOSE를 dbSelectMulti로 대체 시 전체 결과를 메모리에 로드 | 대용량 테이블 여부 확인 필수. 건수가 많을 경우 streaming/paging 방식 검토 |
| SQLIO → MyBatis 전환 | 복합 WHERE 조건의 SQLIO가 JOIN 또는 서브쿼리를 포함할 가능성 | SQLIO 소스 확보 후 SQL 실행 계획(EXPLAIN) 검토. 인덱스 활용 여부 확인 |
| 직원 정보 조회 방법 | QIPA302 SQLIO(직원조회)를 XSQL JOIN vs FUBcEmployee 공통 유틸 중 선택 | 네트워크 호출 최소화를 위해 XSQL JOIN 방식 우선 검토. 단, 캐싱 적용 가능 여부 확인 |

---

### 8.3 데이터 정합성 이슈

| 항목 | 내용 | 대응 |
|------|------|------|
| 처리구분 '03' 삭제 원자성 | 11개 테이블 삭제 중 중간 실패 시 일부만 삭제되는 현상 | 프레임워크 트랜잭션 자동 Rollback으로 원자성 보장됨. 임의 Commit/Rollback 호출 금지 |
| THKIPB110 신규평가 중복 체크 | QIPA301 조회 후 INSERT까지 시간 간격 동안 다른 세션이 INSERT할 가능성 | DBIO INSERT-CMD-Y의 잠금(Lock) 처리가 중복 방지 역할. INSERT 후 DuplicateKeyException 처리 추가 |
| BICOM-USER-EMPID 등 공통영역 필드 | DIPA301이 YCCOMMON의 BICOM 영역에서 직원번호 등을 직접 참조 | CommonArea getter 메서드와 1:1 매핑 확인 필수. YCCOMMON 카피북 확보 우선 |
| YNIPBA30 → XDIPA301-IN 구조 복사 | 두 카피북 필드 구조가 동일하다고 가정 후 전체 복사 | 필드별 명시적 매핑으로 전환하여 구조 의존성 제거 |

---

### 8.4 미결 사항 (TBD 항목)

| # | 항목 | 담당 | 기한 |
|---|------|------|------|
| TBD-01 | SQLIO 소스(QIPA301~QIPA308) 확보 | DBA / 메인프레임팀 | conversion-agent 착수 전 |
| TBD-02 | 12쌍 테이블 Copybook(TRIPB110~TRIPB133) 확보 또는 xls 보완 | DBA | conversion-agent 착수 전 |
| TBD-03 | 처리구분 '02'(확정취소) 무동작 업무 의도 확인 | 업무담당자 | 즉시 확인 권고 |
| TBD-04 | 거래코드 10자리 확보 (PM 메서드명 결정) | 업무/시스템 담당자 | 5단계 시작 전 |
| TBD-05 | YCCOMMON 카피북 확보 (CommonArea getter 매핑) | 메인프레임팀 | 3단계 시작 전 |
| TBD-06 | IJICOMM 이중 MOVE 패턴 업무 의도 확인 (MEDIUM-05) | 업무담당자 | 5단계 시작 전 |
| TBD-07 | BICOM-SCREN-NO 기반 폼ID(#BOFMID) 설정 방식 확인 | n-KESA 프레임워크팀 | 5단계 시작 전 |
| TBD-08 | 직원정보 조회 방식 결정 (XSQL JOIN vs FUBcEmployee 공통 유틸) | 아키텍처팀 | 3단계 시작 전 |
| TBD-09 | THKIPB111, THKIPB116, THKIPB114, THKIPB132 테이블 최대 데이터 건수 확인 (성능) | DBA | 4단계 시작 전 |
| TBD-10 | 컴포넌트 ID 및 어플리케이션 코드 확정 (`kip`, `enbipba`) | 아키텍처팀 | 2단계 시작 전 |

---

*본 변환 설계서는 output/analysis_spec.md의 분석 결과와 java-guide/n-KESA가이드.md, cobol-guide/z-KESA가이드.md, gap/zkesa-nkesa-mapping.md를 기반으로 작성되었습니다. 미결 사항(TBD) 해소 후 conversion-agent가 Java 소스 생성을 진행하십시오.*
