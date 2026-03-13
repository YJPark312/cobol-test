# Java 코드 정적 분석 보고서 (Validation Report)

**분석 일시**: 2026-03-13
**분석 대상**: com.kbstar.kip.enbipba 컴포넌트 (4개 파일)
**분석 도구**: 정적 검사 전용 (Read / Glob / Grep)
**총 파일 수**: 4개

---

## 종합 판정 (Overall Verdict)

| 항목 | 결과 |
|------|------|
| 사내 정적 분석 규칙 | ❌ FAIL |
| 코딩 컨벤션 | ❌ FAIL |
| 보안 취약점 | ❌ FAIL |
| DB 쿼리 정합성 | ❌ FAIL |
| **최종 판정** | ❌ **FAIL** |

> 최종 판정 기준: 모든 항목 PASS 시 PASS. 하나라도 FAIL 시 전체 FAIL.

---

## 1. 사내 정적 분석 규칙 준수 여부

### 결과: FAIL

#### 발견된 이슈

| 심각도 | 파일 | 라인 | 규칙 | 설명 |
|--------|------|------|------|------|
| HIGH | `biz/DUCorpEvalHistoryA.java` | L70 | BIZMETHOD_MISSING_ANNOTATION_PARAM | `@BizMethod` 어노테이션에 설명 문자열 누락 |
| HIGH | `biz/PUCorpEvalHistory.java` | L88 | BIZMETHOD_MISSING_ANNOTATION_PARAM | `@BizMethod` 어노테이션에 설명 문자열 누락 |
| HIGH | `biz/PUCorpEvalHistory.java` | L89 | PM_MISSING_TRY_CATCH | PM 메서드에 필수 `try-catch` 구조 누락 |
| MEDIUM | `biz/DUCorpEvalHistoryA.java` | L117-L118 | TERNARY_NULL_CHAIN | `requestData.getString("totalNoitm") != null` 체크 후 같은 라인에서 재호출 — 이중 getString 호출 발생 (null-safe 처리 미흡) |
| MEDIUM | `biz/PUCorpEvalHistory.java` | L100 | EMPTY_BRANCH | 처리구분 '02' 확정취소 분기: 유의미한 처리 없이 log.debug만 존재 (TBD 상태) |

#### 상세 내용

**[HIGH-1/2] @BizMethod 어노테이션 설명 누락**

n-KESA 가이드 §16에 따르면 `@BizMethod("PM 설명")`, `@BizMethod("DM 설명")` 형태로 설명 문자열을 반드시 지정해야 한다. 두 파일 모두 `@BizMethod` (설명 없음) 형태로 작성되어 있다.

```java
// DUCorpEvalHistoryA.java L70 - 현재 코드 (위반)
@BizMethod
public IDataSet manageCorpEvalHistory(...)

// PUCorpEvalHistory.java L88 - 현재 코드 (위반)
@BizMethod
public IDataSet pmAipba30Xxxx01(...)

// 올바른 형태
@BizMethod("기업집단신용평가이력 관리 DM")
@BizMethod("기업집단신용평가이력관리 PM")
```

**[HIGH-3] PM 메서드 try-catch 구조 누락**

n-KESA 가이드 §4.2 및 §11.2에서 PM 메서드에 `try-catch` 구조를 **필수**로 규정한다. `BusinessException`은 re-throw, 그 외 `Exception`은 `BusinessException`으로 wrap하는 구조가 없으면 예상치 못한 예외가 프레임워크로 전달되어 에러 처리가 불완전해진다.

```java
// PUCorpEvalHistory.java L89 - 현재 코드: try-catch 없음
public IDataSet pmAipba30Xxxx01(IDataSet requestData, IOnlineContext onlineCtx) {
    IDataSet responseData = new DataSet();
    // ... 업무 로직 직접 작성
    return responseData;
}

// 올바른 형태 (가이드 §11.2)
public IDataSet pmAipba30Xxxx01(IDataSet requestData, IOnlineContext onlineCtx) {
    IDataSet responseData = new DataSet();
    try {
        // 업무 로직
    } catch (BusinessException e) {
        throw e;
    } catch (Exception e) {
        throw new BusinessException("에러코드", "조치코드", "맞춤메시지", e);
    }
    return responseData;
}
```

**[MEDIUM-1] 이중 getString 호출 (null 체크 후 재호출)**

`DUCorpEvalHistoryA.java` L117-L118에서 `requestData.getString("totalNoitm") != null` 검사 후 같은 표현식 내에서 다시 `requestData.getString("totalNoitm")`을 호출하고 있다. 동일 키를 두 번 호출하는 불필요한 연산이며, null 안전성 측면에서도 변수 추출 후 사용하는 방식이 권고된다.

**[MEDIUM-2] 처리구분 '02' 미구현 빈 분기**

n-KESA 가이드 §6.2에 따르면 DM에서 무의미한 분기는 제거하거나 명시적 BusinessException으로 처리해야 한다. 현재 코드는 log.debug만 있는 사실상 빈 분기로, 거래가 정상 완료된 것처럼 처리되어 데이터 일관성 위험이 있다.

---

## 2. 코딩 컨벤션

### 결과: FAIL

#### 발견된 이슈

| 심각도 | 파일 | 라인 | 규칙 | 설명 |
|--------|------|------|------|------|
| HIGH | `biz/DUCorpEvalHistoryA.java` | L74, L82~L85 등 다수 | SENSITIVE_DATA_IN_LOG | `log.debug`에 입력 파라미터 원본 값 출력 (기업집단그룹코드 등 업무 식별자 노출) |
| HIGH | `biz/PUCorpEvalHistory.java` | L122 | SENSITIVE_DATA_IN_LOG | `log.debug`에 `userEmpid`(직원번호) 출력 |
| HIGH | `biz/DUCorpEvalHistoryA.java` | L184 | SENSITIVE_DATA_IN_LOG | `log.debug`에 `직원한글명(wkEmpHanglFname)` 출력 |
| MEDIUM | `biz/DUCorpEvalHistoryA.java` | 전체 | LOG_SPECIAL_CHAR | `log.debug` 메시지에 `★` 특수문자 사용 (운영 환경 로그 검색/파싱 혼란 유발) |
| MEDIUM | `biz/PUCorpEvalHistory.java` | 전체 | LOG_SPECIAL_CHAR | `log.debug` 메시지에 `★` 특수문자 사용 |
| LOW | `biz/PUCorpEvalHistory.java` | L89 | PM_NAMING | PM 메서드명 `pmAipba30Xxxx01`에 임시 문자열 `Xxxx` 포함 (거래코드 미확정 상태) |
| LOW | `consts/CCorpEvalConsts.java` | L133 | CONST_TYPE_INCONSISTENCY | 대부분의 상수가 `String` 타입이나 `MAX_100`만 `int` 타입으로 선언 — 타입 일관성 검토 필요 |

#### 상세 내용

**[HIGH] 로그에 민감정보 출력**

n-KESA 가이드 §12 "주의" 항목에서 **민감정보(계좌번호, 주민번호 등) 로그 출력을 명시적으로 금지**한다. 아래 항목들이 위반에 해당한다:

- `DUCorpEvalHistoryA.java` L82: `★[기업집단그룹코드]=` + 원본 입력값 출력
- `DUCorpEvalHistoryA.java` L84: `★[기업집단등록코드]=` + 원본 입력값 출력
- `DUCorpEvalHistoryA.java` L184: `직원한글명=` + 직원 실명 출력
- `PUCorpEvalHistory.java` L122: `userEmpid=` + 직원번호 출력

기업집단그룹코드, 기업집단등록코드는 내부 식별자로서 사내 보안 기준상 운영 로그에 노출 시 정보 보안 위반 가능성이 있으며, 직원번호와 직원 실명(한글명)은 개인정보에 해당하여 로그 출력이 금지된다.

**[MEDIUM] 로그 메시지 내 특수문자**

모든 log.debug 호출에 `★` 문자가 사용되고 있다. 운영 환경 ELK/Splunk 기반 로그 수집 시 인코딩 문제 및 정규식 파싱 오류를 유발할 수 있으며, 표준 로그 패턴과 다른 형태로 로그 검색 효율을 저하시킨다. `[DUCorpEvalHistoryA]` 와 같은 ASCII 형태로 변경을 권고한다.

**[LOW] PM 메서드명 임시 문자열 포함**

n-KESA 가이드 §17.1에서 PM명 규칙은 `pm` + 거래코드 10자리. 현재 `pmAipba30Xxxx01`은 거래코드 미확정으로 임시 명명된 상태이며, 실제 거래코드 확보 후 반드시 교체가 필요하다.

---

## 3. 보안 취약점 스캔

### 결과: FAIL

#### 발견된 이슈

| 심각도 | 파일 | 라인 | 취약점 유형 | 설명 | OWASP 분류 |
|--------|------|------|------------|------|------------|
| HIGH | `biz/DUCorpEvalHistoryA.java` | L122 | SENSITIVE_DATA_EXPOSURE | `userEmpid`(직원번호) 로그 출력 — 개인정보 노출 | A02:2021 - Cryptographic Failures |
| HIGH | `biz/DUCorpEvalHistoryA.java` | L184 | SENSITIVE_DATA_EXPOSURE | `wkEmpHanglFname`(직원한글명) 로그 출력 — 개인정보 노출 | A02:2021 - Cryptographic Failures |
| HIGH | `xsql/DUCorpEvalHistoryA.xml` | L62~L71 | UNVERIFIED_QUERY | `selectEmployeeInfoQipa302`: QIPA302 소스 미확보 상태에서 직원 테이블(`THKJIHR01`)을 직접 조회 — 접근권한 및 테이블 존재 미검증 | A05:2021 - Security Misconfiguration |
| HIGH | `xsql/DUCorpEvalHistoryA.xml` | L43~L51 | UNVERIFIED_QUERY | `selectMainDebtAffltYnQipa307`: 대상 테이블 미상으로 임의 추정하여 작성 (TODO 주석 명시) — 잘못된 테이블 조회 시 정보 유출 또는 에러 위험 | A05:2021 - Security Misconfiguration |
| MEDIUM | `biz/DUCorpEvalHistoryA.java` | L112 | LOG_INJECTION_RISK | `prcssDstcd` 외부 입력값을 로그 메시지에 직접 문자열 연결 — 로그 인젝션 가능성 | A09:2021 - Security Logging and Monitoring Failures |
| MEDIUM | `biz/DUCorpEvalHistoryA.java` | L82~L85 | LOG_INJECTION_RISK | `corpClctGroupCd`, `valuaYmd`, `corpClctRegiCd` 등 외부 입력값 로그 직접 출력 | A09:2021 - Security Logging and Monitoring Failures |

#### 상세 내용

**[HIGH] 개인정보 로그 노출**

`userEmpid`(직원번호)와 `wkEmpHanglFname`(직원한글명)이 `log.debug`로 출력된다. n-KESA 가이드 §12에서 민감정보 로그 출력을 금지하며, 금융권 개인정보보호법상 직원 정보는 개인정보에 해당한다. 운영 환경에서 debug 레벨이 OFF이더라도, 개발/검증 환경에서는 활성화될 수 있어 정보 노출 경로가 된다.

**[HIGH] 미검증 테이블 직접 조회 (selectEmployeeInfoQipa302)**

`THKJIHR01` 테이블을 직접 조회하는 SQL이 역설계로 작성되어 있다. n-KESA 공통모듈 가이드에서 직원 정보 조회는 `FUBcEmployee.getEmployeeInfo()` 공통 유틸 사용을 권고하며, conversion_log.md L139에서도 "FUBcEmployee 공통 유틸 대체 검토"를 명시하고 있다. 테이블명/컬럼명 미검증 상태에서 직원 테이블을 직접 조회하는 것은 권한 우회 가능성이 있다.

**[MEDIUM] 로그 인젝션 위험**

외부에서 전달받은 `prcssDstcd` 등의 입력값을 검증 없이 로그 메시지 문자열에 직접 연결하고 있다. 악의적인 입력값에 개행 문자(`\n`, `\r`)가 포함될 경우, 로그 파일에 가짜 로그 항목이 삽입되는 로그 인젝션(Log Injection)이 발생할 수 있다.

**권고사항**: 로그 출력 전 입력값에서 개행 문자 제거 또는 SLF4J의 파라미터화 로깅 사용:
```java
// 위험한 방식 (현재 코드)
log.debug("★[처리구분]=" + prcssDstcd);

// 안전한 방식
log.debug("[처리구분]={}", prcssDstcd.replaceAll("[\r\n]", "_"));
```

---

## 4. DB 쿼리 정합성

### 결과: FAIL

#### 발견된 이슈

| 심각도 | 파일 | 라인 | 이슈 유형 | 설명 |
|--------|------|------|----------|------|
| HIGH | `xsql/DUCorpEvalHistoryA.xml` L27 vs `biz/DUCorpEvalHistoryA.java` L279 | L27 / L279 | COLUMN_ALIAS_MISMATCH | XML: `COUNT(*) AS EXIST_CNT` 조회 — Java: `result.getString("cnt")` 키 불일치 |
| HIGH | `xsql/DUCorpEvalHistoryA.xml` L178~L192 vs `biz/DUCorpEvalHistoryA.java` L483 | L181 / L483 | MISSING_PK_COLUMN | `selectListThkipb111ForUpdate`: XML에 `CORP_HSTRY_DSTCD` 컬럼 미포함, Java에서 `corpHstryDstcd` 키로 접근 시도 — 항상 null 반환 |
| HIGH | `xsql/DUCorpEvalHistoryA.xml` L80~L139 | L80 | MISSING_PARAM_BINDING | `insertThkipb110`: `valuaDefinsYmd`, `valuaBaseYmd`, `stablIfCmptnVal1` 등 10개 이상 파라미터가 Java 코드에서 `insertParam`에 set되지 않음 |
| HIGH | `xsql/DUCorpEvalHistoryA.xml` L62~L71 | L69 | PARAM_NAME_MISMATCH | `selectEmployeeInfoQipa302`: XML의 바인드 변수명은 `#empId:VARCHAR#`, Java에서 전달하는 키명은 `userEmpid` — 불일치로 인한 null 파라미터 조회 |
| HIGH | `xsql/DUCorpEvalHistoryA.xml` L250~L263 vs `biz/DUCorpEvalHistoryA.java` L584~L587 | L255 / L585 | COLUMN_NAME_MISMATCH | `selectPksQipa303` 조회 컬럼 `BSNS_PART_SERNO`, `ANAL_STGE_SERNO` → Java에서 `fnafARptdocDstcd`, `fnafItemCd`, `bizSectNo` 키로 접근 — 컬럼명 완전 불일치 |
| HIGH | `xsql/DUCorpEvalHistoryA.xml` L308~L320 vs `biz/DUCorpEvalHistoryA.java` L644~L647 | L314 / L645 | COLUMN_NAME_MISMATCH | `selectPksQipa304` 조회 컬럼 `FNAF_ANAL_SERNO` → Java에서 `anlsIClsfiDstcd`, `fnafARptdocDstcd`, `fnafItemCd` 키로 접근 — 컬럼명 완전 불일치 |
| MEDIUM | `xsql/DUCorpEvalHistoryA.xml` | L178~L192 | N_PLUS_1_RISK | 다건 SELECT 후 건별 DELETE 루프 패턴 (총 6개 메서드): 대용량 데이터 처리 시 N+1 DB 호출 문제 발생 가능 |
| MEDIUM | `xsql/DUCorpEvalHistoryA.xml` | L43~L51 | MISSING_VALUA_YMD_IN_WHERE | `selectMainDebtAffltYnQipa307`: WHERE 절에 `VALUA_YMD` 조건 없음 — 동일 기업집단의 여러 평가년월일 중 어느 것을 조회하는지 불명확 |
| LOW | `xsql/DUCorpEvalHistoryA.xml` | L26~L33 | MISSING_VALUA_YMD_IN_EXIST_CHECK | `selectExistCheckQipa301`: WHERE 절에 `VALUA_YMD` 없음 — 기존재 확인 범위가 의도보다 넓을 수 있음 (역설계 특이사항) |

#### 상세 내용

**[HIGH-1] COUNT 컬럼 별칭 불일치 (EXIST_CNT vs cnt)**

`selectExistCheckQipa301` SQL에서 `COUNT(*) AS EXIST_CNT`로 컬럼 별칭을 지정하였으나, Java 코드 `DUCorpEvalHistoryA.java` L279에서는 `result.getString("cnt")`로 `cnt` 키를 조회한다. 두 이름이 다르므로 `cnt`는 항상 `null`이 반환되어 기존재 확인 로직이 항상 "미존재"로 판단된다. 결과적으로 중복 INSERT가 허용되는 치명적인 기능 오류이다.

```java
// DUCorpEvalHistoryA.java L279 - 현재 (버그)
String cnt = result.getString("cnt");           // 항상 null 반환

// 수정 필요
String cnt = result.getString("existCnt");      // XML의 EXIST_CNT에 대응하는 camelCase 키
// 또는 XML을 COUNT(*) AS CNT로 변경
```

**[HIGH-2] THKIPB111 SELECT 결과에서 누락 컬럼 참조 (corpHstryDstcd)**

`selectListThkipb111ForUpdate` XML은 `GROUP_CO_CD`, `CORP_CLCT_GROUP_CD`, `CORP_CLCT_REGI_CD`, `VALUA_YMD`, `SERNO` 5개 컬럼만 SELECT한다. 그러나 Java 코드 L483에서 `rec.getString("corpHstryDstcd")`로 접근하는데, 이 컬럼은 SELECT 목록에 없으므로 항상 null이 반환된다. DELETE 시 `corpHstryDstcd`가 null로 전달되면 deleteThkipb111 WHERE 조건이 의도와 달리 처리될 수 있다.

**[HIGH-3] insertThkipb110 파라미터 바인딩 미완성**

`insertThkipb110` XML은 27개 컬럼에 대한 INSERT를 수행하지만, Java의 `_insertCorpEvalHistory()` 메서드에서 `insertParam`에 put하는 키는 다음 항목들이 누락되어 있다:

| XML 바인드 변수명 | Java insertParam 에 set 여부 | 비고 |
|----------------|--------------------------|------|
| `#valuaDefinsYmd:VARCHAR#` | 미설정 | null 삽입 위험 |
| `#valuaBaseYmd:VARCHAR#` | 미설정 (`valuaStdYmd`로 이름 다름) | 파라미터명 불일치 |
| `#stablIfCmptnVal1:NUMERIC#` | 미설정 | null 삽입 |
| `#stablIfCmptnVal2:NUMERIC#` | 미설정 | null 삽입 |
| `#ernIfCmptnVal1:NUMERIC#` | 미설정 | null 삽입 |
| `#ernIfCmptnVal2:NUMERIC#` | 미설정 | null 삽입 |
| `#csfwFnafCmptnVal:NUMERIC#` | 미설정 | null 삽입 |
| `#fnafScor:NUMERIC#` | 미설정 | null 삽입 |
| `#nonFnafScor:NUMERIC#` | 미설정 | null 삽입 |
| `#chsnScor:NUMERIC#` | 미설정 | null 삽입 |
| `#valdYmd:VARCHAR#` | 미설정 | null 삽입 |
| `#valuaEmpid:VARCHAR#` | 미설정 (`regiEmpid`로 다른 키 사용) | 파라미터명 불일치 |
| `#valuaEmnm:VARCHAR#` | 미설정 (`empHanglFname`과 매핑 필요) | 파라미터명 불일치 |
| `#valuaBrncd:VARCHAR#` | 미설정 (`belngBrncd`와 매핑 필요) | 파라미터명 불일치 |
| `#mgtBrncd:VARCHAR#` | 미설정 | null 삽입 |

또한, Java에서 `insertParam.put("valuaStdYmd", ...)` 로 set하지만 XML 바인드 변수는 `#valuaBaseYmd:VARCHAR#`이므로 컬럼명 불일치이다.

**[HIGH-4] selectEmployeeInfoQipa302 파라미터명 불일치**

XML L69: `WHERE EMP_NO = #empId:VARCHAR#`
Java L336: `param.put("userEmpid", requestData.getString("userEmpid"))`

바인드 변수명 `empId`와 Java에서 put하는 키명 `userEmpid`가 불일치한다. 파라미터 바인딩 실패로 인해 NULL 조건으로 전체 테이블을 스캔하거나 에러가 발생한다.

**[HIGH-5/6] selectPksQipa303/Qipa304 컬럼명 완전 불일치**

`selectPksQipa303` (THKIPB113 조회)은 `BSNS_PART_SERNO`, `ANAL_STGE_SERNO` 컬럼을 반환하지만, Java L584~587에서는 `fnafARptdocDstcd`, `fnafItemCd`, `bizSectNo` 키로 접근한다. 반환 컬럼과 Java 접근 키가 완전히 다르다. conversion_log.md에서 COBOL `XQIPA303-O-FNAF-A-RPTDOC-DSTCD`, `XQIPA303-O-FNAF-ITEM-CD`, `XQIPA303-O-BIZ-SECT-NO`가 실제 컬럼이어야 하나, XML SQL에는 해당 컬럼이 없다.

마찬가지로 `selectPksQipa304`는 `FNAF_ANAL_SERNO` 1개 컬럼을 반환하지만, Java L645~647에서 `anlsIClsfiDstcd`, `fnafARptdocDstcd`, `fnafItemCd` 3개 키로 접근한다 — 모두 null이 된다.

**[MEDIUM] N+1 쿼리 패턴**

삭제 처리 메서드 6개(`_deleteThkipb111Loop`, `_deleteThkipb116Loop`, `_deleteThkipb113`, `_deleteThkipb112`, `_deleteThkipb114Loop`, `_deleteThkipb132Loop`, `_deleteThkipb130`, `_deleteThkipb133`, `_deleteThkipb119`)에서 SELECT 후 건별 루프 DELETE를 수행한다. 대상 건수가 많은 경우 (기업집단 평가 이력에 수백 건) N+1 DB 호출로 인한 성능 저하 위험이 있다. 가능한 경우 WHERE 절을 활용한 벌크 DELETE 검토를 권고한다.

---

## 5. 분석 요약

- **총 이슈 수**: 22개 (HIGH: 13, MEDIUM: 7, LOW: 2)
- **분석된 파일**: 4개
  - `src/main/java/com/kbstar/kip/enbipba/consts/CCorpEvalConsts.java`
  - `src/main/java/com/kbstar/kip/enbipba/biz/DUCorpEvalHistoryA.java`
  - `src/main/java/com/kbstar/kip/enbipba/biz/PUCorpEvalHistory.java`
  - `src/main/java/com/kbstar/kip/enbipba/xsql/DUCorpEvalHistoryA.xml`
- **이슈 없는 파일**: 없음 (전 파일에서 이슈 발견)

| 파일 | HIGH | MEDIUM | LOW |
|------|------|--------|-----|
| CCorpEvalConsts.java | 0 | 0 | 1 |
| DUCorpEvalHistoryA.java | 7 | 4 | 0 |
| PUCorpEvalHistory.java | 3 | 2 | 1 |
| DUCorpEvalHistoryA.xml | 3 | 1 | 1 |

---

## 6. 권고사항 (Recommendations)

### 우선순위 1 (즉시 수정 필요 — 기능 오류)

1. **[DB-CRITICAL] `selectExistCheckQipa301` 컬럼 별칭 통일**: XML의 `EXIST_CNT`와 Java의 `cnt` 불일치 수정. `COUNT(*) AS CNT`로 XML 변경 또는 Java 코드에서 `existCnt` 키 사용.

2. **[DB-CRITICAL] `insertThkipb110` 파라미터 바인딩 완성**: Java `_insertCorpEvalHistory()`에서 누락된 15개 파라미터 추가. 업무팀과 함께 TRIPB110 DDL 확보 후 컬럼 목록 전체 검증 필수.

3. **[DB-CRITICAL] `selectEmployeeInfoQipa302` 파라미터명 통일**: XML `#empId:VARCHAR#` → `#userEmpid:VARCHAR#` 변경 또는 Java `param.put("empId", ...)`로 변경.

4. **[DB-CRITICAL] `selectPksQipa303`, `selectPksQipa304` 컬럼명 정합성 확보**: 역설계 SQL의 반환 컬럼명과 Java 접근 키명을 COBOL 카피북 기반으로 재정렬. SQLIO 소스 확보가 최우선.

5. **[DB-CRITICAL] `selectListThkipb111ForUpdate`에 `CORP_HSTRY_DSTCD` 컬럼 추가**: Java L483에서 접근하는 `corpHstryDstcd`에 대응하는 컬럼을 SELECT 목록에 포함.

### 우선순위 2 (릴리즈 전 수정 필요 — 사내 규칙 위반)

6. **[RULE-CRITICAL] PM 메서드에 try-catch 구조 추가**: n-KESA 가이드 §11.2 필수 요건. `PUCorpEvalHistory.pmAipba30Xxxx01`에 `BusinessException` re-throw + `Exception` wrap 패턴 적용.

7. **[RULE] `@BizMethod` 어노테이션 설명 문자열 추가**: `DUCorpEvalHistoryA.java` L70, `PUCorpEvalHistory.java` L88 — `@BizMethod("설명 문자열")` 형태로 수정.

8. **[SECURITY] 개인정보 로그 출력 제거**: `userEmpid`, `wkEmpHanglFname`, 기업집단그룹코드/등록코드 등 업무 식별자의 log.debug 출력 제거 또는 마스킹 처리.

9. **[SECURITY] 직원 정보 조회를 `FUBcEmployee.getEmployeeInfo()` 공통 유틸로 대체**: 직원 테이블(`THKJIHR01`) 직접 조회 방식을 n-KESA 공통 유틸 `callSharedMethodByDirect("com.kbstar.kji.enbncmn", "FUBcEmployee.getEmployeeInfo", ...)` 호출로 교체.

### 우선순위 3 (개선 권고)

10. **로그 메시지 특수문자 제거**: `★` 문자 → ASCII 형태 브라켓(`[클래스명.메서드명]`) 으로 변경.

11. **처리구분 '02' 미구현 분기 처리 확정**: 업무팀 협의 후 실제 로직 구현 또는 명시적 `BusinessException("B3800004", "UKIP0007", "지원하지 않는 처리구분입니다.")` throw로 교체.

12. **PM 메서드명 거래코드 확정 후 교체**: `pmAipba30Xxxx01` → `pm[실제10자리거래코드]` 형태로 변경.

13. **SQLIO 소스 확보 및 역설계 SQL 전면 검증**: conversion_log.md에 HIGH 위험도로 기록된 8개 SQLIO 미확보 항목 (`selectExistCheckQipa301`, `selectMainDebtAffltYnQipa307`, `selectEmployeeInfoQipa302`, `selectPksQipa303~306`, `selectPksQipa308`)에 대해 원본 소스 확보 후 SQL 재작성.

---

*본 보고서는 정적 분석 전용 도구(Read/Glob/Grep)를 사용하여 코드를 실행하지 않고 생성되었습니다.*
*분석 기준: n-KESA 프레임워크 프로그램 작성 가이드, n-KESA 공통 유틸리티 가이드, conversion_log.md*
