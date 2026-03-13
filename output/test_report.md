# 테스트 실행 보고서

## 실행 정보

| 항목 | 내용 |
|------|------|
| 실행 일시 | 2026-03-13 12:54 KST |
| 대상 클래스 | CCorpEvalConsts, DUCorpEvalHistoryA, PUCorpEvalHistory |
| 테스트 프레임워크 | JUnit5 (5.10.1) + Mockito (5.8.0) |
| 빌드 도구 | Maven 3.x / maven-surefire-plugin 3.2.2 |
| Java 버전 | 17 |
| 커버리지 도구 | JaCoCo 0.8.11 |
| 원본 COBOL 프로그램 | AIPBA30.cbl (AS), DIPA301.cbl (DC) |

---

## 테스트 결과 요약

| 항목 | 수치 |
|------|------|
| 전체 테스트 수 | 108 |
| 성공 | 108 |
| 실패 | 0 |
| 오류 | 0 |
| 스킵 | 0 |
| 성공률 | 100.0% |

**BUILD SUCCESS**

---

## 커버리지 측정 결과

> JaCoCo 0.8.11 기준. 대상: 테스트 대상 비즈니스 클래스 3개.

| 클래스 | 라인 커버리지 | 브랜치 커버리지 | 메서드 커버리지 |
|--------|-------------|--------------|---------------|
| CCorpEvalConsts | 100.0% (35/35) | N/A (분기 없음) | 100.0% (2/2) |
| PUCorpEvalHistory | 100.0% (53/53) | 100.0% (32/32) | 100.0% (2/2) |
| DUCorpEvalHistoryA | 77.9% (327/420) | 54.3% (76/140) | 100.0% (19/19) |
| **전체 (3개 클래스)** | **81.7%** | **62.8%** | **100.0%** |

### 커버리지 미달 원인 (DUCorpEvalHistoryA)

DUCorpEvalHistoryA의 브랜치 커버리지 54.3%가 목표(70%)에 미치지 못하는 원인:

1. **처리구분 '02' (확정취소) 분기**: COBOL 원본에서도 TODO로 표시된 미정의 로직. 빈 분기로 처리되어 있어 단독 테스트 추가가 어려움.
2. **루프 내 레코드셋 다중 건 처리 분기**: `dbSelectMulti` 결과를 순회하는 while 루프 내 null 및 empty 레코드셋에 대한 추가 분기가 존재.
3. **로그 레벨 분기**: `log.debug` 호출 내부의 조건 분기는 stub ILog 구현으로 커버되지 않음.

---

## 테스트 케이스 상세

### CCorpEvalConstsTest (34개 테스트)

#### 성공한 테스트

| 테스트 명 | Nested 클래스 | 테스트 유형 | 설명 |
|----------|--------------|-----------|------|
| hasTwoConstants_programIds | ProgramIdConstsTest | COBOL 동등성 | 프로그램ID 상수 2개 존재 확인 |
| programIdConstants_correctValues | ProgramIdConstsTest | COBOL 동등성 | AS/DC 프로그램ID 값 검증 |
| statOk_equals00 | StatusCodeConstsTest | COBOL 동등성 | STAT_OK="00" |
| statNotfnd_equals02 | StatusCodeConstsTest | COBOL 동등성 | STAT_NOTFND="02" |
| statError_equals09 | StatusCodeConstsTest | COBOL 동등성 | STAT_ERROR="09" |
| statAbnormal_equals98 | StatusCodeConstsTest | COBOL 동등성 | STAT_ABNORMAL="98" |
| statSyserror_equals99 | StatusCodeConstsTest | COBOL 동등성 | STAT_SYSERROR="99" |
| allStatusCodes_notNull | StatusCodeConstsTest | 정상 | 상태코드 전체 non-null |
| errB3800004_correctValue | ErrorCodeConstsTest | COBOL 동등성 | ERR_B3800004="B3800004" |
| errB4200023_correctValue | ErrorCodeConstsTest | COBOL 동등성 | ERR_B4200023="B4200023" |
| errB4200219_correctValue | ErrorCodeConstsTest | COBOL 동등성 | ERR_B4200219="B4200219" |
| errB3900002_correctValue | ErrorCodeConstsTest | COBOL 동등성 | ERR_B3900002="B3900002" |
| allErrorCodes_notNull | ErrorCodeConstsTest | 정상 | 에러코드 전체 non-null |
| allErrorCodes_notEmpty | ErrorCodeConstsTest | 경계값 | 에러코드 전체 non-empty |
| treatUkif0072_correctValue | TreatCodeConstsTest | COBOL 동등성 | TREAT_UKIF0072="UKIF0072" |
| treatUkii0182_correctValue | TreatCodeConstsTest | COBOL 동등성 | TREAT_UKII0182="UKII0182" |
| treatUkip0001_correctValue | TreatCodeConstsTest | COBOL 동등성 | TREAT_UKIP0001="UKIP0001" |
| treatUkip0002_correctValue | TreatCodeConstsTest | COBOL 동등성 | TREAT_UKIP0002="UKIP0002" |
| treatUkip0003_correctValue | TreatCodeConstsTest | COBOL 동등성 | TREAT_UKIP0003="UKIP0003" |
| treatUkip0007_correctValue | TreatCodeConstsTest | COBOL 동등성 | TREAT_UKIP0007="UKIP0007" |
| allTreatCodes_notNull | TreatCodeConstsTest | 정상 | 조치코드 전체 non-null |
| allTreatCodes_notEmpty | TreatCodeConstsTest | 경계값 | 조치코드 전체 non-empty |
| prcssDstcdNew_equals01 | DomainConstsTest | COBOL 동등성 | PRCSS_DSTCD_NEW="01" |
| prcssDstcdCancel_equals02 | DomainConstsTest | COBOL 동등성 | PRCSS_DSTCD_CANCEL="02" |
| prcssDstcdDelete_equals03 | DomainConstsTest | COBOL 동등성 | PRCSS_DSTCD_DELETE="03" |
| formIdPrefix_equalsV1 | DomainConstsTest | COBOL 동등성 | FORM_ID_PREFIX="V1" |
| max100_equals100 | DomainConstsTest | COBOL 동등성 | MAX_100=100 |
| allDomainConsts_notNull | DomainConstsTest | 정상 | 도메인 상수 전체 non-null |
| processingCodes_areDistinct | DomainConstsTest | 정상 | 처리구분 3개 값 중복 없음 |
| processingCodes_areTwoDigit | DomainConstsTest | 경계값 | 처리구분 모두 2자리 |
| isPublicClass | ClassStructureTest | 정상 | public class 확인 |
| allFieldsArePublicStaticNonFinal | ClassStructureTest | 정상 | public static non-final 필드 구조 확인 |

---

### DUCorpEvalHistoryATest (34개 테스트)

#### 성공한 테스트

| 테스트 명 | Nested 클래스 | 테스트 유형 | 설명 |
|----------|--------------|-----------|------|
| whenPrcssDstcd01_shouldCallInsertFlow | BranchTest | 정상 | 처리구분 '01' → 신규삽입 흐름 |
| whenPrcssDstcd02_shouldDoNothing | BranchTest | 정상 | 처리구분 '02' → no-op (COBOL 미구현 분기 동등성) |
| whenPrcssDstcd03_shouldCallDeleteFlow | BranchTest | 정상 | 처리구분 '03' → 전체삭제 흐름 |
| whenPrcssDstcdInvalid00_shouldThrowBusinessException | BranchTest | 예외 | 처리구분 '00' → BusinessException |
| whenPrcssDstcdInvalid04_shouldThrowBusinessException | BranchTest | 예외 | 처리구분 '04' → BusinessException |
| whenPrcssDstcdEmpty_shouldThrowBusinessException | BranchTest | 경계값 | 처리구분 빈문자열 → BusinessException |
| whenExistCheckReturnsExistingRecord_shouldThrowDuplicateException | InsertProcessTest | 예외 | 중복 존재 시 B4200023/UKII0182 발생 (COBOL 동등성) |
| whenExistCheckReturnsNoRecord_shouldProceedToInsert | InsertProcessTest | 정상 | 미존재 시 INSERT 진행 |
| whenInsertSucceeds_shouldReturnSuccessDataSet | InsertProcessTest | 정상 | INSERT 성공 → 응답 DataSet 반환 |
| whenInsertExistCheckReturnsNull_shouldProceedToInsert | InsertProcessTest | 경계값 | exist check null 반환 → INSERT 진행 |
| whenDeleteAll_shouldCallThkipb110Delete | DeleteProcessTest | 정상 | 삭제 흐름 → THKIPB110 DELETE 호출 확인 |
| whenDeleteAll_shouldCallThkipb111LoopDelete | DeleteProcessTest | 정상 | THKIPB111 루프삭제 호출 확인 |
| whenDeleteAll_shouldCallThkipb116LoopDelete | DeleteProcessTest | 정상 | THKIPB116 루프삭제 호출 확인 |
| whenDeleteAll_shouldCallThkipb113Delete | DeleteProcessTest | 정상 | THKIPB113 DELETE 호출 확인 |
| whenDeleteAll_shouldCallThkipb112Delete | DeleteProcessTest | 정상 | THKIPB112 DELETE 호출 확인 |
| whenDeleteAll_shouldCallThkipb114LoopDelete | DeleteProcessTest | 정상 | THKIPB114 루프삭제 호출 확인 |
| whenDeleteAll_shouldCallThkipb118Delete | DeleteProcessTest | 정상 | THKIPB118 DELETE 호출 확인 |
| whenDeleteAll_shouldCallThkipb130Delete | DeleteProcessTest | 정상 | THKIPB130 DELETE 호출 확인 |
| whenDeleteAll_shouldCallThkipb131Delete | DeleteProcessTest | 정상 | THKIPB131 DELETE 호출 확인 |
| whenDeleteAll_shouldCallThkipb132LoopDelete | DeleteProcessTest | 정상 | THKIPB132 루프삭제 호출 확인 |
| whenDeleteAll_shouldCallThkipb133Delete | DeleteProcessTest | 정상 | THKIPB133 DELETE 호출 확인 |
| whenDeleteAll_shouldCallThkipb119Delete | DeleteProcessTest | 정상 | THKIPB119 DELETE 호출 확인 |
| whenDeleteFails_shouldThrowB4200219 | DeleteProcessTest | 예외 | 삭제 0건 → B4200219/UKII0182 (COBOL 동등성) |
| whenInsertReturns01_totalNoitmIs00001 | ResponseDataSetTest | COBOL 동등성 | 신규 → totalNoitm=00001 응답 |
| whenDeleteReturns03_totalNoitmIs00001 | ResponseDataSetTest | COBOL 동등성 | 삭제 → totalNoitm=00001 응답 |
| cobol_newEval_endToEnd | CobolEquivalenceTest | COBOL 동등성 | 처리구분 '01' E2E COBOL 동등성 |
| cobol_deleteAll_endToEnd | CobolEquivalenceTest | COBOL 동등성 | 처리구분 '03' E2E COBOL 동등성 |
| cobol_cancelDoNothing | CobolEquivalenceTest | COBOL 동등성 | 처리구분 '02' no-op COBOL 동등성 (HIGH-03 이슈 문서화) |
| whenPrcssDstcdIsNull_shouldThrowNullPointerException_sourceCodeBug | BoundaryValueTest | 버그 문서화 | prcssDstcd null → NPE 발생 (소스 버그 문서화) |
| whenPrcssDstcdIsEmpty_shouldThrowBusinessException | BoundaryValueTest | 경계값 | prcssDstcd 빈문자열 → BusinessException |
| whenPrcssDstcdIs00_shouldThrowBusinessException | BoundaryValueTest | 경계값 | prcssDstcd '00' → BusinessException |
| whenPrcssDstcdIs04_shouldThrowBusinessException | BoundaryValueTest | 경계값 | prcssDstcd '04' → BusinessException |
| whenResponseDataSetContainsExpectedFields | BoundaryValueTest | 정상 | 응답 DataSet 필수 필드 포함 확인 |
| whenNoitmFieldsAreCorrectlyFormatted | BoundaryValueTest | COBOL 동등성 | totalNoitm/nowNoitm PIC 9(5) 포맷 확인 |

---

### PUCorpEvalHistoryTest (40개 테스트)

#### 성공한 테스트

| 테스트 명 | Nested 클래스 | 테스트 유형 | 설명 |
|----------|--------------|-----------|------|
| whenAllRequiredFieldsProvided_shouldSucceed | NormalFlowTest | 정상 | 4개 필수항목 정상 입력 → DU 호출 성공 |
| whenDuReturnsNoitm_shouldCopyToResponse | NormalFlowTest | 정상 | COBOL MOVE XDIPA301-OUT TO YPIPBA30-CA 대응 |
| whenDuReturnsNull_shouldSetDefaultNoitm | NormalFlowTest | 경계값 | DU null 응답 → totalNoitm/nowNoitm 기본값 '00000' |
| whenProcessSucceeds_shouldSetFormId | NormalFlowTest | 정상 | formId='V1'+screenNo 설정 확인 |
| whenCalled_shouldPassPrcssDstcdToDu | NormalFlowTest | 정상 | prcssDstcd DU 파라미터 전달 확인 |
| whenCalled_shouldPassGroupCoCdFromCommonAreaToDu | NormalFlowTest | 정상 | CommonArea.groupCoCd DU 파라미터 전달 |
| whenPrcssDstcdIsNull_shouldThrowB3800004 | ValidationTest | 경계값/예외 | prcssDstcd null → B3800004/UKIP0007 |
| whenPrcssDstcdIsBlank_shouldThrowB3800004 | ValidationTest | 경계값/예외 | prcssDstcd 공백 → B3800004/UKIP0007 |
| whenPrcssDstcdIsEmpty_shouldThrowB3800004 | ValidationTest | 경계값/예외 | prcssDstcd 빈문자열 → B3800004 |
| whenCorpClctGroupCdIsNull_shouldThrowUkip0001 | ValidationTest | 경계값/예외 | corpClctGroupCd null → B3800004/UKIP0001 |
| whenCorpClctGroupCdIsBlank_shouldThrowUkip0001 | ValidationTest | 경계값/예외 | corpClctGroupCd 공백 → B3800004/UKIP0001 |
| whenValuaYmdIsNull_shouldThrowUkip0003 | ValidationTest | 경계값/예외 | valuaYmd null → B3800004/UKIP0003 |
| whenValuaYmdIsBlank_shouldThrowUkip0003 | ValidationTest | 경계값/예외 | valuaYmd 공백 → B3800004/UKIP0003 |
| whenCorpClctRegiCdIsNull_shouldThrowUkip0002 | ValidationTest | 경계값/예외 | corpClctRegiCd null → B3800004/UKIP0002 |
| whenCorpClctRegiCdIsBlank_shouldThrowUkip0002 | ValidationTest | 경계값/예외 | corpClctRegiCd 공백 → B3800004/UKIP0002 |
| validationOrder_prcssDstcdFirst | ValidationTest | COBOL 동등성 | 검증 순서: prcssDstcd 첫 번째 |
| validationOrder_corpClctGroupCdSecond | ValidationTest | COBOL 동등성 | 검증 순서: corpClctGroupCd 두 번째 |
| whenValidationFails_shouldNotCallDu | ValidationTest | 정상 | 검증 실패 시 DU 미호출 확인 |
| whenDuThrowsBusinessException_shouldRethrow | ExceptionHandlingTest | 예외 | DU BusinessException → PM re-throw |
| whenDuThrowsRuntimeException_shouldWrapToB3900002 | ExceptionHandlingTest | 예외 | RuntimeException → B3900002 래핑 |
| whenNpeOccurs_shouldWrapToB3900002 | ExceptionHandlingTest | 예외 | NPE → B3900002 래핑 |
| whenDuThrowsB4200219_shouldPreserveErrorCode | ExceptionHandlingTest | COBOL 동등성 | DU B4200219 에러코드 보존 전파 |
| whenCommonAreaGroupCoCdIsNull_shouldUseEmptyString | CommonAreaNullTest | 경계값 | CommonArea 값 null → NPE 없이 처리 |
| whenScreenNoIsNull_formIdShouldStartWithV1 | CommonAreaNullTest | 경계값 | screenNo null → formId 'V1' 시작 |
| whenCommonAreaIsNull_shouldUseEmptyStrings | CommonAreaNullTest | 경계값 | CommonArea 자체 null → NPE 없이 처리 |
| cobolInputMapping_shouldPassAllFieldsToDu | CobolEquivalenceTest | COBOL 동등성 | YNIPBA30-CA 전체 필드 매핑 검증 |
| cobolOutputMapping_shouldIncludeTotalAndNowNoitm | CobolEquivalenceTest | COBOL 동등성 | YPIPBA30-CA 출력 필드 검증 |
| cobolEquivalence_newEvalHappyPath | CobolEquivalenceTest | COBOL 동등성 | 처리구분 '01' 전체 흐름 COBOL 동등성 |
| cobolEquivalence_deleteHappyPath | CobolEquivalenceTest | COBOL 동등성 | 처리구분 '03' 전체 흐름 COBOL 동등성 |
| whenPrcssDstcdIsNullOrEmpty_shouldThrow (x2) | BoundaryValueTest | 경계값 | @NullAndEmptySource prcssDstcd |
| whenCorpClctGroupCdIsNullOrEmpty_shouldThrow (x2) | BoundaryValueTest | 경계값 | @NullAndEmptySource corpClctGroupCd |
| whenValuaYmdIsNullOrEmpty_shouldThrow (x2) | BoundaryValueTest | 경계값 | @NullAndEmptySource valuaYmd |
| whenCorpClctRegiCdIsNullOrEmpty_shouldThrow (x2) | BoundaryValueTest | 경계값 | @NullAndEmptySource corpClctRegiCd |
| whenValidPrcssDstcd_shouldNotThrowValidationError (x3) | BoundaryValueTest | 경계값 | @ValueSource '01'/'02'/'03' 정상 처리 |

---

## COBOL 동등성 검증 결과

| 검증 항목 | COBOL 원본값/동작 | Java 출력값/동작 | 일치 여부 |
|---------|----------------|----------------|----------|
| STAT_OK | "00" | "00" | 일치 |
| STAT_NOTFND | "02" | "02" | 일치 |
| STAT_ERROR | "09" | "09" | 일치 |
| STAT_ABNORMAL | "98" | "98" | 일치 |
| STAT_SYSERROR | "99" | "99" | 일치 |
| ERR_B3800004 | "B3800004" | "B3800004" | 일치 |
| ERR_B4200023 | "B4200023" | "B4200023" | 일치 |
| ERR_B4200219 | "B4200219" | "B4200219" | 일치 |
| ERR_B3900002 | "B3900002" | "B3900002" | 일치 |
| TREAT_UKIF0072 | "UKIF0072" | "UKIF0072" | 일치 |
| TREAT_UKII0182 | "UKII0182" | "UKII0182" | 일치 |
| TREAT_UKIP0001 | "UKIP0001" | "UKIP0001" | 일치 |
| TREAT_UKIP0002 | "UKIP0002" | "UKIP0002" | 일치 |
| TREAT_UKIP0003 | "UKIP0003" | "UKIP0003" | 일치 |
| TREAT_UKIP0007 | "UKIP0007" | "UKIP0007" | 일치 |
| PRCSS_DSTCD_NEW | "01" | "01" | 일치 |
| PRCSS_DSTCD_CANCEL | "02" | "02" | 일치 |
| PRCSS_DSTCD_DELETE | "03" | "03" | 일치 |
| FORM_ID_PREFIX | "V1" | "V1" | 일치 |
| prcssDstcd null 처리 | SPACE 체크 후 에러 | NullPointerException 발생 | **불일치 (소스 버그)** |
| 처리구분 '02' 확정취소 | 처리내용 미정의 (COBOL에서도 TBD) | no-op 반환 | 동등 (HIGH-03 이슈) |
| 필수항목 검증 순서 | prcssDstcd→corpClctGroupCd→valuaYmd→corpClctRegiCd | 동일 순서 | 일치 |
| S2000 검증 실패 시 DU 미호출 | DU 호출 전 에러 발생 | DU never() 확인 | 일치 |
| totalNoitm/nowNoitm PIC 9(5) | 5자리 숫자 "00001" | "00001" 반환 | 일치 |
| formId MOVE 'V1' + BICOM-SCREN-NO | "V1" + 화면번호 | "V1IPBA30" | 일치 |
| DU BusinessException 재발행 | 에러코드 보존 전파 | assertSame() 통과 | 일치 |
| Exception → BusinessException 래핑 | B3900002/UKII0182 | B3900002/UKII0182 | 일치 |

---

## Mock 처리 현황

### DUCorpEvalHistoryATest

- **Mocked 컴포넌트**: `TestableDUCorpEvalHistoryA` (test subclass, protected DB 메서드 override)
  - `dbSelect()` stub: HashMap 기반 반환값 제어
  - `dbSelectMulti()` stub: HashMap 기반 반환값 제어
  - `dbInsert()` stub: HashMap 기반 반환값 제어
  - `dbDelete()` stub: HashMap 기반 반환값 제어
  - `callCounts` 추적: 각 sqlId별 호출 횟수 기록
- **Mock 검증 항목**:
  - `selectExistCheck` 호출 확인 (신규삽입 시)
  - `insertThkipb110` 호출 확인 (신규삽입 시)
  - 12개 DELETE 쿼리 ID 각각 1회 이상 호출 확인 (전체삭제 시)
  - 처리구분 '02' 시 어떠한 DB 호출도 없음 확인

### PUCorpEvalHistoryTest

- **Mocked 컴포넌트**:
  - `TestablePUCorpEvalHistory` (test subclass, `getCommonArea()` override)
  - `@Mock DUCorpEvalHistoryA` (Mockito Mock)
  - `@Mock CommonArea` (Mockito Mock)
  - `@Mock IOnlineContext` (Mockito Mock)
- **@BizUnitBind 필드 주입**: Java Reflection (`Field.setAccessible(true)`)으로 `duCorpEvalHistoryA` 주입
- **Mock 검증 항목**:
  - `duCorpEvalHistoryA.manageCorpEvalHistory(any(), eq(onlineCtx))` 정상 경로 1회 호출
  - 검증 실패 시 `duCorpEvalHistoryA.manageCorpEvalHistory(any(), any())` `never()` 호출
  - `argThat` 사용하여 DU 파라미터 내 `prcssDstcd`, `groupCoCd` 등 필드값 검증

---

## 소스 코드 버그 분석 및 권고사항

> 본 에이전트는 소스 코드를 수정하지 않습니다. 아래 실패 내용은 개발자 검토가 필요합니다.

### 발견된 버그: DUCorpEvalHistoryA.java line 82 - prcssDstcd null 방어 누락

**버그 위치**: `com.kbstar.kip.enbipba.biz.DUCorpEvalHistoryA.manageCorpEvalHistory()` line 82

**문제 코드**:
```java
String prcssDstcd = requestData.getString("prcssDstcd");
log.debug("[DUCorpEvalHistoryA.manageCorpEvalHistory] prcssDstcd={}",
          prcssDstcd.replaceAll("[\r\n]", "_"));  // prcssDstcd가 null이면 NPE 발생
```

**증상**: `prcssDstcd`가 `null`일 때 `replaceAll()` 호출에서 `NullPointerException` 발생

**기대 동작** (COBOL 원본 동등성):
COBOL에서는 `IF XDIPA301-I-PRCSS-DSTCD = SPACE` 체크를 통해 에러 처리하므로, Java에서도 `null` 입력 시 `BusinessException(B3800004, ...)` 발생이 올바른 동작임.

**PUCorpEvalHistory에서의 영향**: PM 레벨에서 `prcssDstcd` null 체크를 먼저 수행하므로 실제 운영 시 이 경로는 도달하기 어려우나, DU를 직접 호출하는 경우(테스트, 향후 확장) NPE 위험이 존재함.

**권고 수정 방법** (개발자 참고):
```java
// 방법 1: null 체크 추가
log.debug("[DUCorpEvalHistoryA.manageCorpEvalHistory] prcssDstcd={}",
          prcssDstcd != null ? prcssDstcd.replaceAll("[\r\n]", "_") : "null");

// 방법 2: Objects.requireNonNullElse 사용
log.debug("[DUCorpEvalHistoryA.manageCorpEvalHistory] prcssDstcd={}",
          Objects.requireNonNullElse(prcssDstcd, "null").replaceAll("[\r\n]", "_"));
```

**테스트 처리**: `whenPrcssDstcdIsNull_shouldThrowNullPointerException_sourceCodeBug` 테스트를 통해 현재 동작(NPE)을 문서화하였음. 소스 수정 후 해당 테스트를 `BusinessException` 검증으로 변경 필요.

---

### HIGH-03 이슈: 처리구분 '02' 확정취소 로직 미구현

**이슈 분류**: COBOL 분석 시 식별된 HIGH 우선순위 이슈

**현황**: `DUCorpEvalHistoryA.java`의 처리구분 '02' 분기는 현재 no-op(아무 처리 없음)으로 구현되어 있음.

**근거**: `output/analysis_spec.md` 내 HIGH-03 항목에 따르면 COBOL 원본 DIPA301의 처리구분 '02' 분기도 내용이 불명확한 상태임.

**권고**: 업무 담당자와 처리구분 '02' 확정취소 시 필요한 실제 처리 내용 확인 후 구현 완료 필요.

---

## 테스트 파일 목록

| 파일 경로 | 대상 클래스 | 테스트 수 |
|----------|-----------|---------|
| `src/test/java/com/kbstar/kip/enbipba/consts/CCorpEvalConstsTest.java` | CCorpEvalConsts | 34 |
| `src/test/java/com/kbstar/kip/enbipba/biz/DUCorpEvalHistoryATest.java` | DUCorpEvalHistoryA | 34 |
| `src/test/java/com/kbstar/kip/enbipba/biz/PUCorpEvalHistoryTest.java` | PUCorpEvalHistory | 40 |

---

## 기술 구현 특이사항

### Protected 메서드 처리 전략

n-KESA 프레임워크의 `DataUnit`, `ProcessUnit` 기반 클래스에서 DB 접근 메서드(`dbInsert`, `dbSelect`, `dbSelectMulti`, `dbDelete`)와 공통 메서드(`getCommonArea`, `getLog`)가 모두 `protected`로 선언되어 있어 Mockito `@Spy` + `doReturn()` 방식으로는 컴파일 타임 접근 오류가 발생함.

**해결 방법**: Test subclass 패턴 적용

- `TestableDUCorpEvalHistoryA extends DUCorpEvalHistoryA`: 4개 DB 메서드를 모두 override, HashMap 기반 stub registry와 call count 추적 구현
- `TestablePUCorpEvalHistory extends PUCorpEvalHistory`: `getCommonArea()` override, stub 반환값 setter 제공

이 패턴은 프레임워크 소스 수정 없이 protected 메서드를 제어하는 표준적인 Java 테스트 기법임.

### @BizUnitBind 필드 주입

n-KESA 프레임워크의 `@BizUnitBind` 어노테이션은 Mockito의 `@InjectMocks` 대상이 아니므로, Java Reflection API (`Field.setAccessible(true)`)를 통해 `@BeforeEach`에서 Mock 객체를 직접 주입함.

---

*보고서 생성: unittest-agent / 2026-03-13*
