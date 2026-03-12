# zKESA → nKESA 기능 매핑 가이드

> COBOL(zKESA) 프로그램을 Java(nKESA)로 변환할 때 참조하는 1:1 기능 매핑 문서.
> 변환 에이전트는 이 문서를 기준으로 COBOL 매크로/유틸리티/구조를 Java 프레임워크 패턴으로 치환한다.

---

## 1. 프레임워크 아키텍처 매핑

### 1.1 프로그램 계층 구조

| zKESA (COBOL) | nKESA (Java) | 설명 |
|---|---|---|
| AS (Application Service) | **ProcessUnit (PU)** - PM 메소드 | 거래 진입점, 입력검증/업무호출/출력조립 |
| PC (Process Component) | **ProcessUnit (PU)** - PM 또는 FM 메소드 | 프로세스 제어 |
| DC (Data Component) | **FunctionUnit (FU)** - FM 메소드 | 단위 비즈니스 로직 |
| IC (Interface Component) | **FunctionUnit (FU)** - FM 공유메소드 | 공통 인터페이스 로직 |
| FC (Function Component) | **FunctionUnit (FU)** - FM 메소드 | 기능 단위 로직 |
| BC (Batch Component) | **FunctionUnit (FU)** - FM 메소드 (배치) | 배치 로직 |
| DBIO / SQLIO | **DataUnit (DU)** - DM 메소드 | DB 접근 (MyBatis SQL 실행) |

### 1.2 프로그램 구조 매핑 (PARAGRAPH → 메소드)

| zKESA PARAGRAPH | nKESA 메소드 영역 | 변환 패턴 |
|---|---|---|
| `S0000-MAIN-RTN` | PM 메소드 본체 | `public IDataSet pmXxx(IDataSet requestData, IOnlineContext onlineCtx)` |
| `S1000-INITIALIZE-RTN` | PM 메소드 상단 초기화 | `IDataSet responseData = new DataSet();` / `CommonArea ca = getCommonArea(onlineCtx);` |
| `S2000-VALIDATION-RTN` | try 블록 내 입력값 검증 | `if (requestData.getString("field") == null || "".equals(...))` → `throw new BusinessException(...)` |
| `S3000-PROCESS-RTN` | try 블록 내 업무 로직 | FM/DM 호출, callSharedMethod 등 |
| `S9000-FINAL-RTN` | `return responseData;` | 정상 종료 시 responseData 반환 |

### 1.3 데이터 인터페이스 매핑

| zKESA | nKESA | 설명 |
|---|---|---|
| `YCCOMMON-CA` (COPY YCCOMMON) | `IOnlineContext onlineCtx` / `CommonArea ca` | 공통 영역. `getCommonArea(onlineCtx)`로 접근 |
| `YNxxxxxx-CA` (AS 입력 카피북) | `IDataSet requestData` | PM의 입력 파라미터 |
| `YPxxxxxx-CA` (AS 출력 카피북) | `IDataSet responseData` | PM의 출력 반환값 |
| `XDxxxxxx-CA` / `XPxxxxxx-CA` (모듈 인터페이스) | `IDataSet` (FM 호출용 requestData/responseData) | FM간 데이터 전달 |
| `XQxxxxxx-CA` (SQLIO 인터페이스) | MyBatis 파라미터 `Map` / DTO | SQL 실행 파라미터 |
| `TRxxxxxx-REC` (테이블 레코드) | MyBatis 결과 DTO / `IDataSet` | 테이블 조회 결과 |
| `TKxxxxxx-PK` (테이블 키) | MyBatis 파라미터 DTO / `Map` | 테이블 키 조건 |
| `WK-AREA` (Working Area) | 로컬 변수 | 메소드 내 임시 변수 |
| `CO-AREA` (상수 영역) | `static final` 상수 또는 Enum | 프로그램 상수 정의 |

---

## 2. 매크로 → Java API 매핑

### 2.1 핵심 매크로 매핑

| zKESA 매크로 | nKESA Java 패턴 | 변환 예시 |
|---|---|---|
| **`#ERROR errCd treatCd stat`** | `throw new BusinessException(errCd, treatCd)` | `#ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR` → `throw new BusinessException("B3800004", "UKIF0072")` |
| **`#MULERR`** (멀티에러) | `addBusinessException(errCd, treatCd, onlineCtx)` | PM에서만 사용. 최대 10건 |
| **`#OKEXIT stat`** | `return responseData;` | 정상 종료. 별도 상태코드 세팅 불필요 |
| **`#DYCALL pgm YCCOMMON-CA interface-CA`** | 동일 컴포넌트: 직접 메소드 호출 / 타 컴포넌트: `callSharedMethodByDirect(compId, "FUxxx.method", reqDs, onlineCtx)` | `#DYCALL DIPA301 YCCOMMON-CA XDIPA301-CA` → `IDataSet res = callSharedMethodByDirect("com.kbstar.kip.xxx", "FUxxx.method", reqDs, onlineCtx)` |
| **`#STCALL pgm ...`** | 직접 메소드 호출 (static) | 동일 컴포넌트 내 호출 |
| **`#DYDBIO cmd key rec`** | DM 메소드 호출 (MyBatis) | `#DYDBIO SELECT-CMD-Y TKFACO13-PK TRFACO13-REC` → `IDataSet result = duXxx.dmSelectXxx(paramDs, onlineCtx)` |
| **`#DYSQLA sqlioId interface-CA`** | DM 메소드 호출 (MyBatis 복합 SQL) | `#DYSQLA QFA0308 XQFA0308-CA` → `IDataSet result = duXxx.dmXxx(paramDs, onlineCtx)` |
| **`#GETOUT YPxxxxxx-CA`** | `IDataSet responseData = new DataSet();` | 출력영역 할당. Java에서는 DataSet 생성으로 대체 |
| **`#BOFMID formId`** | 화면 폼 ID 설정 (프레임워크 자동 처리) | 대부분 변환 불필요. 필요시 `responseData.put("formId", value)` |
| **`#SCRENO screenNo`** | 화면번호 지정 (프레임워크 자동 처리) | 변환 불필요 |
| **`#USRLOG msg field`** | `log.debug(msg + field)` | `#USRLOG "★[S2000]"` → `log.debug("★[S2000]")` |
| **`#SYSLOG msg`** | `log.info(msg)` | 운영 로그 |
| **`#GETNCS params`** | 채번 공통 유틸리티 FM 호출 | NCS 채번 관련 |
| **`#DSCNTR`** | 중단거래 API 호출 | 중단거래 요청 |
| **`#GETINP`** | 연동거래 입력편집 영역 확보 | 연동제어 프로그램용 |
| **`#CRYPTO`** / **`#SECCVT`** | 암복호화 API 호출 | 보안모듈 |
| **`#LOGCHK`** | 후처리 로그 체크 | 로그 관련 |
| **`#FMDUMP`** | 덤프 출력 | 디버깅용 |
| **`#CSTMSG`** | 사용자 맞춤메시지 설정 | `BusinessException` 생성자의 맞춤메시지 파라미터 활용 |
| **`#ERAFPG`** | 호출요청 프로그램명 설정 | 에러 발생 시 호출 프로그램 정보 |
| **`#TRMMSG`** | 에러메시지 출력 | 프레임워크 자동 처리 |

### 2.2 DBIO/SQLIO 상태코드 → Java 예외 매핑

| zKESA 상태코드 | 88 조건명 | nKESA Java 처리 |
|---|---|---|
| `'00'` | `COND-xxx-OK` | 정상 처리 (예외 없음) |
| `'01'` | `COND-xxx-KEYDUP` | `DataException` (Insert 중복) |
| `'02'` | `COND-xxx-NOTFOUND` / `COND-DBIO-MRNF` | 조회 결과 null 또는 빈 리스트 체크 |
| `'09'` | `COND-xxx-ERROR` | `throw new BusinessException(errCd, treatCd)` |
| `'98'` | `COND-xxx-ABNORMAL` | 프레임워크 자동 처리 (시스템 예외) |
| `'99'` | `COND-xxx-SYSERROR` | 프레임워크 자동 처리 (시스템 예외) |

### 2.3 호출 결과 체크 패턴 변환

**zKESA (COBOL):**
```cobol
#DYCALL DFA9202 YCCOMMON-CA XDFA9202-CA

IF XDFA9202-R-STAT NOT = CO-STAT-OK
   #ERROR CO-B1050011 CO-UKFA5022 CO-STAT-ERROR
END-IF
```

**nKESA (Java):**
```java
IDataSet reqDs = new DataSet();
reqDs.put("inputField", requestData.getString("inputField"));

// FM 호출 (타 컴포넌트 공유메소드)
IDataSet resDs = callSharedMethodByDirect(
    "com.kbstar.xxx.yyy",
    "FUXxx.methodName",
    reqDs, onlineCtx);

// 에러 처리는 FM 내부에서 BusinessException throw → 자동 전파
// NOTFOUND 등 업무 판단이 필요한 경우만 결과값 체크
```

### 2.4 DBIO 호출 패턴 변환

**zKESA (COBOL):**
```cobol
INITIALIZE TKFACO13-PK
MOVE value TO TKFACO13-ACNO
#DYDBIO SELECT-CMD-Y TKFACO13-PK TRFACO13-REC

EVALUATE TRUE
   WHEN COND-DBIO-OK
      CONTINUE
   WHEN COND-DBIO-MRNF
      업무로직
   WHEN OTHER
      #ERROR CO-B0100099 CO-UKLA0099 CO-STATUS-ERROR
END-EVALUATE
```

**nKESA (Java) - DU/DM:**
```java
// DataUnit (DU) 내 DM 메소드
@BizMethod("테이블조회")
public IDataSet dmSelectXxx(IDataSet requestData, IOnlineContext onlineCtx) {
    IDataSet responseData = new DataSet();
    Map<String, Object> param = requestData.toMap();
    // MyBatis 호출
    Map<String, Object> result = sqlMap.queryForObject("namespace.selectXxx", param);
    if (result != null) {
        responseData.putAll(result);
    }
    return responseData;
}
```

---

## 3. 공통 유틸리티 매핑 (133건)

> zKESA COBOL 프로그램 ID → nKESA Java 클래스.메소드()
> `N/A` 표기: nKESA에서 미구현 (별도 구현 필요)

### 3.1 채번 (Numbering)

| # | 기능명 | zKESA (COBOL) | nKESA (Java) |
|---|---|---|---|
| 1.1 | 계좌번호 채번 | `CJICN01` | `FUBcNumbering.getAcnoNumbering()` |
| 1.2 | 관리번호 채번 | `CJICN03` | `FUBcNumbering.getMgtNoNumbering()` |
| 1.70 | 고객지정계좌 채번 및 취소 | `CJICN04` | N/A |
| 1.85 | 전표번호 채번-유/무전표 자동판단 | `CJICN05` | N/A |
| 1.108 | 전자공용전표 판단규칙 | `CJICN06` | N/A |
| 1.109 | 전표구분 조회-유/무전표 자동판단 | `CJICN07` | N/A |
| 1.110 | 카드인터페이스용 전표채번 | `CJICN08` | N/A |
| 1.121 | 내맘대로계좌등록 | `CJICN15` | `FUBcNumbering.manageDIYAcno()` |

### 3.2 검증 (Validation)

| # | 기능명 | zKESA (COBOL) | nKESA (Java) |
|---|---|---|---|
| 1.3 | 비밀번호사용제한 체크 | `CJISN01` | `FUBcValidation.validationPassword()` |
| 1.59 | 계좌번호 체크디지트 산출 및 검증 | `CJIDG01` | `FUBcValidation.validationAccountNumber()` |
| 1.60 | M/S계좌번호 체크디지트 산출 및 검증 | `CJIDG02` | `FUBcValidation.validationMSAccountNumber()` |
| 1.61 | 일반 체크디지트 검증 | `CJIDG03` | `FUBcValidation.validationCheckDigit()` |
| 1.62 | 관리번호 체크디지트 산출 및 검증 | `CJIDG04` | `FUBcValidation.validationMgtNo()` |
| 1.63 | M/S 유효성 검증 (ISO 3 TYPE) | `CJIDG05` | N/A |
| 1.68 | 거래 파라미터 유효성검증 | `CJITR03` | `FUBcValidation.validationTranParm()` |
| 1.111 | 고객지정계좌 체크디짓 산출 및 검증 | `CJIDG06` | N/A |
| 1.117 | 고객유형체크 | `CJIDG07` | `FUBcValidation.validationCustomerPattern()` |
| 1.129 | 고유식별정보 검출 | `CJIDG10` | `FUBcValidation.validationUniqIdnfiInfo()` |
| 1.133 | 고유식별정보 검출 II | `CJIDG11` | `FUBcValidation.validationUniqIdnfiInfo()` |

### 3.3 코드/인스턴스 조회 (Code)

| # | 기능명 | zKESA (COBOL) | nKESA (Java) |
|---|---|---|---|
| 1.4 | 통화코드 조회 | `CJICU01` | `FUBcCode.getCurrencyCode()` |
| 1.20 | 전행 인스턴스코드 내용 조회 | `CJIUI01` | `FUBcCode.getEnbnIncdContent()` |
| 1.21 | 전행 인스턴스코드 복수 조회 | `CJIUI02` | `FUBcCode.getEnbnInstanceCode()` |
| 1.64 | 국가목록 조회 | `CJINA01` | `FUBcCode.getNationalCatalogue()` |
| 1.65 | 은행목록 조회 | `CJIBK01` | `FUBcCode.getBankCatalogue()` |
| 1.66 | 타행환은행공동코드 조회 | `CJIBK02` | `FUBcCode.getOtrbnkCatalogue()` |
| 1.96 | 전행 인스턴스코드 존재여부 조회 | `CJIUI03` | `FUBcCode.getEnbnIncdExstYn()` |
| 1.97 | 전행 인스턴스코드 내용 조회 II | `CJIUI04` | `FUBcCode.getEnbnIncdContent2()` |
| 1.101 | 전행 인스턴스코드 내용 조회 III | `CJIUI05` | `FUBcCode.getEnbnIncdContent3()` |
| 1.104 | 전행 인스턴스코드 내용 조회 IV | `CJIUI06` | `FUBcCode.getEnbnIncdContent4()` |

### 3.4 환율/세율 조회 (Rate)

| # | 기능명 | zKESA (COBOL) | nKESA (Java) |
|---|---|---|---|
| 1.5 | 기준환율 조회 | `CJIEX01` | `FUBcRate.getBaseExchangeRate()` |
| 1.6 | 시장환율 조회 | `CJIEX02` | `FUBcRate.getMarketExchangeRate()` |
| 1.7 | 평균기준환율 조회 | `CJIEX03` | `FUBcRate.getAvgExchangeRate()` |
| 1.8 | 상품선물환율 조회 | `CJIEX04` | `FUBcRate.getPrdctExchangeRate()` |
| 1.51 | 세율기본 조회 | `CJITX01` | `FUBcRate.getTaxRates()` |
| 1.113 | 실버바판매환율정보조회 | `CJIEX05` | N/A |
| 1.131 | 기준환율 조회 II | `CJIEX11` | `FUBcRate.getBaseExchangeRate2()` |

### 3.5 부점 조회 (Branch)

| # | 기능명 | zKESA (COBOL) | nKESA (Java) |
|---|---|---|---|
| 1.10 | 부점기본 조회 | `CJIBR01` | `FUBcBranch.getBranchBasic()` |
| 1.11 | 외국환부점변환 조회 | `CJIBR02` | `FUBcBranch.getFXBrnChng()` |
| 1.12 | 관할/대출실행팀 소속부점코드 조회 | `CJIBR03` | `FUBcBranch.getJrsdLnExeTeamBrnCd()` |
| 1.13 | 부점 폐쇄에 의한 통합부점 조회 | `CJIBR04` | `FUBcBranch.getIntegrationBranch()` |
| 1.14 | 통합부점코드에 속한 통폐합된 부점 전체조회 | `CJIBR05` | `FUBcBranch.getMrabBrnWhol()` |
| 1.15 | 인수합병 부점의 통합부점코드 조회 | `CJIBR06` | `FUBcBranch.getIntgraGiroCd()` |
| 1.16 | 부점운영지원내역 조회 | `CJIBR07` | `FUBcBranch.getBranchOperSportHist()` |
| 1.17 | 부점주소, 전화번호 조회 | `CJIBR08` | `FUBcBranch.getBranchAddrTelno()` |
| 1.19 | 우편번호 3자리로 지역별 소속부점코드 조회 | `CJIBR10` | `FUBcBranch.getAreaBranchCode()` |
| 1.103 | 부점한글명조회 | `CJIBR11` | `FUBcBranch.getBrnHanglName()` |
| 1.114 | 대기업금융센터 관리부점 조회 | `CJIBR12` | `FUBcBranch.getCnglFinacCnterMgtt()` |
| 1.116 | 대기업금융센터 및 관리부점조회 | N/A | `FUBcBranch.getCnglFinacCnterMgtbrn()` |
| 1.122 | 부점운영정보 조회 | `CJIBR13` | `FUBcBranch.getBranchOperationTime()` |
| 1.126 | 부점유형정보 조회 | `CJIBR17` | `FUBcBranch.getBrnPtrnInfo()` |
| 1.128 | 부점영업시간정보 조회 | `CJIBR18` | `FUBcBranch.getBranchBizOperationTime()` |
| 1.130 | 지역본부장,부점장,내부통제자 조회 | `CJIBR22` | `FUBcBranch.getBrnAreahqBrnmgrCpsn()` |
| 1.132 | 부점점심시간정보 조회 | `CJIBR23` | `FUBcBranch.getLnchTtmCntzWrkBrn()` |

### 3.6 직원 조회 (Employee)

| # | 기능명 | zKESA (COBOL) | nKESA (Java) |
|---|---|---|---|
| 1.23 | 직원기본 조회 | `CJIHR01` | `FUBcEmployee.getPafiarEmpInfo()` |
| 1.24 | IT직원기본 조회 | `CJIHR02` | `FUBcEmployee.getITEmpInfo()` |
| 1.25 | 다양한 조건의 전체직원 조회 | `CJIHR03` | `FUBcEmployee.getWholPafiarEmpInfo()` |
| 1.26 | 다양한 조건의 전체IT직원 조회 | `CJIHR04` | `FUBcEmployee.getWholITEmpInfo()` |
| 1.69 | 사용자 권한 및 Sales/OP 정보 조회 | `CJIHR05` | `FUBcEmployee.getEmpidAthInfo()` |
| 1.99 | 직원 존재여부 다건 조회 | `CJIHR06` | `FUBcEmployee.getEmpExstYn()` |
| 1.100 | 직원별 담당APP코드 및 처리권한 여부 확인 | `CJIHR07` | `FUBcEmployee.getEmpPerUapplCdPrcssAthYn()` |
| 1.112 | 직원권한 및 종료고객조회 | N/A | `FUBcEmployee.getEmpAthEndCust()` |
| 1.118 | 직원 KB-PIN 정보 조회 | `CJIHR12` | `FUBcEmployee.getEmpKBPinInfo()` |
| 1.119 | KB-PIN조회 및 생성 | N/A | `FUBcEmployee.getKBPin()` |
| 1.120 | 기타대체번호조회 및 생성 | N/A | `FUBcEmployee.getEtcAltrNo()` |
| 1.125 | 지주직원기본 조회 | `CJIHR11` | `FUBcEmployee.getGroupEmpInfo()` |
| 1.127 | 직원기타정보 조회 | `CJIHR15` | `FUBcEmployee.getEmpEtcInfo()` |

### 3.7 일자/영업일 (Date)

| # | 기능명 | zKESA (COBOL) | nKESA (Java) |
|---|---|---|---|
| 1.28 | 일수/월수/영업일수/공휴일수 산출 | `CJIIL01` | `FUBcDate.calculateNumberOfDays()` |
| 1.29 | 입력월수 차감후의 일수산출 | `CJIIL02` | `FUBcDate.calculateSubtractionNumberOfDays()` |
| 1.30 | 만기일/역만기일 산출 | `CJIIL03` | `FUBcDate.calculateExpirDd()` |
| 1.31 | 양일자간 차이(년/월/일수) 산출 | `CJIIL04` | `FUBcDate.calculateDteBtnDfrn()` |
| 1.32 | 월별 주기값 산출 | `CJIIL05` | `FUBcDate.calculatePerMnCyclVal()` |
| 1.33 | 시분초 연산 | `CJIIL06` | `FUBcDate.calculateHHMMSS()` |
| 1.34 | 해외기관 코드별 일수/영업일수 산출 | `CJIIL07` | `FUBcDate.calculateOvsesNoday()` |
| 1.35 | 해외기관 코드별 만기일/역만기일 산출 | `CJIIL08` | `FUBcDate.calculateOvsesExpirDd()` |
| 1.36 | 가산/감산월 이용 월초/월말영업일 산출 | `CJIIL09` | `FUBcDate.calculateBaseYmdBzoprDd()` |
| 1.37 | 연령계산 산출 | `CJIAG01` | `FUBcDate.calculateAge()` |
| 1.46 | 요일 산출 | `CJIDT09` | `FUBcDate.calculateDwk()` |
| 1.40 | 영업일 산출 I | `CJIDT03` | `FUBcDate.calculateBzoprDd()` |
| 1.41 | 일자 산출 I | `CJIDT04` | `FUBcDate.calculateDate()` |
| 1.42 | 월초/월말영업일/월말일 산출 | `CJIDT05` | `FUBcDate.calculateEnmnBzoprDay()` |
| 1.48 | 해외기관 코드별 영업일 산출 | `CJIDT11` | `FUBcDate.calculateOvsesBzoprDd()` |
| 1.49 | 해외기관 코드별 월초/월말영업일 산출 | `CJIDT12` | `FUBcDate.calculateOvsesEnmnBzoprDay()` |
| 1.73 | 양편넣기-일수/영업일수/공휴일수 산출 | `CJIIL11` | `FUBcDate.calculateNumberOfBsdeDays()` |
| 1.74 | 양편넣기-입력월수 차감후 일수산출 | `CJIIL12` | `FUBcDate.calculateSubtractionNumberOfBsdeDays()` |
| 1.75 | 양편넣기-만기일/역만기일 산출 | `CJIIL13` | `FUBcDate.calculateBsdeExpirDd()` |
| 1.87 | 월말 년월일 산출 | `CJIDT15` | `FUBcDate.calculateEnmnYmd()` |
| 1.89 | 영업일 산출 II | `CJIDT16` | `FUBcDate.calculateBzoprDd2()` |
| 1.90 | 일자 산출 II | `CJIDT17` | `FUBcDate.calculateDate2()` |
| 1.91 | 거래소휴장일 만기일/역만기일 산출 | `CJIIL14` | `FUBcDate.calculateExchHoldyExpirDd()` |
| 1.92 | 거래소휴장일 양편넣기-만기일/역만기일 산출 | `CJIIL15` | `FUBcDate.calculateBsdeExchHoldyExpirDd()` |
| 1.95 | 만기일 산출 II | `CJIIL16` | N/A |

### 3.8 일자 체크/변환 (DateCheck / DateChange)

| # | 기능명 | zKESA (COBOL) | nKESA (Java) |
|---|---|---|---|
| 1.38 | 윤년 체크 | `CJIDT01` | `FUBcDateCheck.checkLpyrChk()` |
| 1.39 | 휴일 체크 | `CJIDT02` | `FUBcDateCheck.checkHoldyChk()` |
| 1.45 | 일자 유효성 체크 | `CJIDT08` | `FUBcDateCheck.checkDateValidity()` |
| 1.47 | 해외기관 코드별 휴일 체크 | `CJIDT10` | `FUBcDateCheck.checkOvsesHoldyChk()` |
| 1.94 | 거래소휴장일 체크 | `CJIDT22` | `FUBcDateCheck.checkExchHoldyChk()` |
| 1.102 | 휴일 Check-휴일테이블 사용안함 | `CJIDT23` | N/A |
| 1.43 | 줄리안↔그레고리안 일자변환 | `CJIDT06` | `FUBcDateChange.changeJulTOGreg()` |
| 1.44 | 양력/음력일자 변환 | `CJIDT07` | `FUBcDateChange.changeSlcl()` |
| 1.50 | 일자변환(년월 몇주차 요일→일자) | `CJIDT13` | `FUBcDateChange.changeDteChng()` |
| 1.93 | 일자변환2(요청차수 요일→일자) | `CJIDT18` | `FUBcDateChange.changeDteChng2()` |

### 3.9 데이터 변환 (Change)

| # | 기능명 | zKESA (COBOL) | nKESA (Java) |
|---|---|---|---|
| 1.55 | 문자열 길이 변환 | `CJIOT01` | `FUBcChange.changeLettersLineLength()` |
| 1.56 | 금액 한글/영문 변환 | `CJIOT02` | `FUBcChange.changeAmountHanglEng()` |
| 1.57 | 가변길이 데이터 변환 | `CJIOT03` | `FUBcChange.changeChangeableData()` |
| 1.58 | 개인정보 보호를 위한 변환 | `CJIOT05` | `FUBcChange.changePrivatePersonInfo()` |
| 1.71 | 공통출력 데이터 조립 | `CJIOT04` | `FUBcChange.setSlipShetCommon()` |
| 1.82 | 분리된 데이터(TEXT) 결합 | `CJIOT06` | N/A |
| 1.84 | 데이터 공백(Space) 제거 | `CJIOT07` | N/A |

### 3.10 계좌 변환 (AccountChange)

| # | 기능명 | zKESA (COBOL) | nKESA (Java) |
|---|---|---|---|
| 1.52 | 통합 구계좌 변환 | `CJIAC01` | `FUBcAccountChange.changeIntgraAcnChng()` |
| 1.53 | 로직으로 계좌변환(요구불) | `CJIAC02` | `FUBcAccountChange.changeAcnChngByLogic()` |
| 1.54 | 합병은행 통합계좌간 변환 | `CJIAC03` | N/A |

### 3.11 메시지 (Message)

| # | 기능명 | zKESA (COBOL) | nKESA (Java) |
|---|---|---|---|
| 1.22 | 에러메시지/책임자승인사유/조치메시지 조회 | `CJIER01` | `FUBcMessage.getMessageCode()` |
| 1.67 | 센터컷 중단/중요에러 체크 | `CJIER02` | `FUBcMessage.getMsgCdOfCmnArea()` |
| 1.83 | 대외기관에러메시지코드별 표준에러/조치 조회 | `CJIER03` | `FUBcMessage.getTermlEcptnlChnlMsgCd()` |

### 3.12 기타

| # | 기능명 | zKESA (COBOL) | nKESA (Java) |
|---|---|---|---|
| 1.9 | 어음교환결제시각 조회 | `CJIBT01` | N/A |
| 1.18 | 업무마감통제내용 변경 | `CJIBR09` | N/A |
| 1.27 | KB 영업일정보 조회/변경 | `CJIKB01` | `FUBcBase.prcssKBBaseInfo()` |
| 1.72 | 거래제어 정보 조회 | `CJITR01` | `FUBcTransaction.getTranCtrlInfo()` |
| 1.76 | ECC 암호화 | `CJIECC1` | `FUBcEcc.getEncodeStringCode1()` / `getEncodeStringCode2()` |
| 1.77 | ECC 복호화 | `CJIECC2` | `FUBcEcc.getDecodeStringCode1()` / `getDecodeStringCode2()` |
| 1.80 | 책임자승인사유 판단 | `CJISUP1` | `FUBcAuthorization.prcssSpvsrAthorPtrn()` |
| 1.81 | EBCDIC 한글코드 검증 | `CJIKS01` | N/A |
| 1.86 | KSC5601 한글코드 검증 | `CJIKS04` | N/A |
| 1.88 | 공통영역 기준일자 SET | `BJISTDT` | N/A |
| 1.98 | VIP라운지 여부 조회 | `CJIVI01` | N/A |
| 1.105 | 신분증이미지Key 조립 | `CJIIM01` | N/A |
| 1.106 | 실명증표 이미지키 저장 및 조회 | `CJIIM02` | N/A |
| 1.107 | 실명증표 이미지키 복원저장 | `CJIIM03` | N/A |
| 1.115 | 태블릿방문접수일정 조회 | `CJITB01` | N/A |
| 1.123 | 주민번호검색 | `CJIDG08` | N/A |
| 1.124 | 주민번호 존재여부 확인 | `CJIDG09` | N/A |

---

## 4. 호출 패턴 변환 규칙

### 4.1 동일 컴포넌트 내 호출

**zKESA:** `#DYCALL` 로 동일 어플리케이션 내 프로그램 호출
**nKESA:** `@BizUnitBind` 어노테이션으로 FU/DU 주입 후 직접 메소드 호출

```java
@BizUnitBind
private FUXxxLogic fuXxxLogic;

// FM 직접 호출
IDataSet result = fuXxxLogic.fmMethodName(reqDs, onlineCtx);
```

### 4.2 타 컴포넌트 호출 (공유메소드)

**zKESA:** `#DYCALL` 로 타 어플리케이션 프로그램 호출
**nKESA:** `callSharedMethodByDirect` 또는 `callSharedMethodByRequiresNew`

```java
IDataSet reqDs = new DataSet();
reqDs.put("inField1", value1);

IDataSet resDs = callSharedMethodByDirect(
    "com.kbstar.xxx.yyy",        // 컴포넌트 ID
    "FUClassName.methodName",     // 유닛.메소드명
    reqDs, onlineCtx);

String outField = resDs.getString("outField1");
```

### 4.3 공통 유틸리티 호출

**zKESA:** `#DYCALL CJIxxx YCCOMMON-CA XCJIxxx-CA`
**nKESA:** `callSharedMethodByDirect("com.kbstar.kji.enbncmn", "FUBcXxx.methodName", reqDs, onlineCtx)`

```java
// 예: 계좌번호 채번
IDataSet nbringReq = new DataSet();
nbringReq.put("inGroupCoCd", ca.getGroupCoCd());
nbringReq.put("inDmndNSbjctCd", requestData.getString("sbjctCd"));
nbringReq.put("inBrncd", requestData.getString("brncd"));

IDataSet nbringRes = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcNumbering.getAcnoNumbering",
    nbringReq, onlineCtx);

String acno = nbringRes.getString("outAcno");
```

### 4.4 연동거래 (PM → PM)

**zKESA:** 연동스케줄 기반 거래 호출
**nKESA:** `callService` API (동기/비동기/지연비동기)

```java
// 동기 연동거래
IDataSet linkReq = new DataSet();
linkReq.put("field1", value1);
IDataSet linkRes = callService("거래코드", linkReq, onlineCtx);
```

---

## 5. DB 접근 패턴 변환

### 5.1 DBIO → MyBatis DM

| zKESA DBIO 명령 | MyBatis DM 패턴 |
|---|---|
| `#DYDBIO SELECT-CMD-Y key rec` | `sqlMap.queryForObject(namespace + ".selectXxx", param)` |
| `#DYDBIO SELECT-CMD-N key rec` (다건) | `sqlMap.queryForList(namespace + ".selectListXxx", param)` |
| `#DYDBIO INSERT-CMD key rec` | `sqlMap.insert(namespace + ".insertXxx", param)` |
| `#DYDBIO UPDATE-CMD key rec` | `sqlMap.update(namespace + ".updateXxx", param)` |
| `#DYDBIO DELETE-CMD key rec` | `sqlMap.delete(namespace + ".deleteXxx", param)` |

### 5.2 SQLIO → MyBatis DM (복합 SQL)

| zKESA SQLIO | MyBatis DM 패턴 |
|---|---|
| `#DYSQLA QxxxxXX XQxxxxXX-CA` | 복합 쿼리를 MyBatis XML에 정의 후 DM 메소드에서 호출 |
| Multi-Row Fetch | `sqlMap.queryForList(...)` + `IRecordSet` 으로 변환 |

---

## 6. 사용금지 명령어 → Java 대체

| zKESA 금지 명령어 | 이유 | nKESA 대체 |
|---|---|---|
| `EXEC CICS` | 프레임워크 매크로 사용 | 프레임워크 API |
| `EXEC SQL` | DBIO/SQLIO 사용 | MyBatis DM |
| `GOBACK` | 프레임워크 종료 처리 | `return responseData` / `throw BusinessException` |
| `DISPLAY` | 로그 매크로 사용 | `log.debug()` / `log.info()` |
| `CALL` | 동적호출 매크로 사용 | `callSharedMethod***` / 직접 메소드 호출 |
| `GO TO` | 구조화 프로그래밍 위반 | Java 제어문 (if/switch/for) |

---

## 7. N/A 항목 처리 가이드

nKESA에 대응 API가 없는 (`N/A`) 항목은 다음과 같이 처리:

1. **EBCDIC/KSC5601 관련** (1.81, 1.86): Java는 UTF-8 기반이므로 변환 불필요. 필요시 `java.nio.charset` 활용
2. **전표 관련** (1.85, 1.108~1.110): 전표 채번 로직은 업무별 별도 구현 필요
3. **이미지키 관련** (1.105~1.107): 이미지 처리 시스템 연계 방식이 다름. 별도 설계 필요
4. **공통영역 기준일자 SET** (1.88): `CommonArea` 에서 직접 접근
5. **데이터 공백 제거** (1.84): `String.trim()` 또는 `StringUtils.strip()` 사용
6. **분리된 데이터 결합** (1.82): `String.join()` 또는 `StringBuilder` 사용
7. **합병은행 통합계좌간 변환** (1.54): 업무 요건에 따라 별도 구현

---

## 8. COPY 카피북 명명규칙 → Java 클래스 명명 매핑

| COBOL 접두어 | 용도 | Java 대응 |
|---|---|---|
| `YN` | AS 입력 카피북 | PM 메소드의 `IDataSet requestData` 필드 |
| `YP` | AS 출력 카피북 | PM 메소드의 `IDataSet responseData` 필드 |
| `XD`, `XP` | DC/PC 인터페이스 | FM 메소드의 `IDataSet` 파라미터/리턴 필드 |
| `XQ` | SQLIO 인터페이스 | DM 메소드의 `IDataSet` 파라미터 + MyBatis XML |
| `TR` | 테이블 레코드 | MyBatis 결과 DTO / `Map<String, Object>` |
| `TK` | 테이블 키 | MyBatis 파라미터 DTO / `Map<String, Object>` |
| `YC` | 공통 유틸리티 | `IOnlineContext` / `CommonArea` |
| `XC` | 공통유틸리티 인터페이스 | 공유메소드 호출용 `IDataSet` |
| `CO-` | 상수 정의 | `static final String` 상수 또는 Enum |
| `WK-` | Working Area | 메소드 로컬 변수 |
