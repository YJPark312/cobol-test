# Java 변환 로그 (Conversion Log)

**작성 일시**: 2026-03-13
**작성 에이전트**: conversion-agent
**기반 문서**: output/conversion_plan.md, output/analysis_spec.md
**변환 대상**: AIPBA30.cbl, DIPA301.cbl

---

## 1. 변환 결과 요약

| 단계 | 파일 | 상태 | 비고 |
|------|------|------|------|
| Phase 1 | `src/main/java/com/kbstar/kip/enbipba/consts/CCorpEvalConsts.java` | 완료 | |
| Phase 2 | `src/main/java/com/kbstar/kip/enbipba/xsql/DUCorpEvalHistoryA.xml` | 완료 | SQLIO 역설계 포함 |
| Phase 2 | `src/main/java/com/kbstar/kip/enbipba/biz/DUCorpEvalHistoryA.java` | 완료 | |
| Phase 3 | `src/main/java/com/kbstar/kip/enbipba/biz/PUCorpEvalHistory.java` | 완료 | |

---

## 2. 생성 파일 목록

### 2.1 Phase 1 - 상수 클래스

| 파일 경로 | COBOL 대응 | 설명 |
|----------|-----------|------|
| `src/main/java/com/kbstar/kip/enbipba/consts/CCorpEvalConsts.java` | CO-AREA, CO-ERROR-AREA | 상태코드, 에러코드, 조치코드, 도메인 상수 |

**구현 내용**:
- 처리 결과 상태코드 5개 (STAT_OK, STAT_NOTFND, STAT_ERROR, STAT_ABNORMAL, STAT_SYSERROR)
- 에러메시지 코드 5개 (B3800004, B3900002, B3900009, B4200023, B4200219)
- 조치메시지 코드 7개 (UKIF0072, UKII0182, UKIP0001~0008)
- 도메인 상수 9개 (비계약업무구분코드, 처리단계구분, 처리구분, 폼ID 접두어 등)
- `final` 키워드 미사용 (핫 디플로이 요건 준수)

---

### 2.2 Phase 2 - DataUnit + XSQL

#### DUCorpEvalHistoryA.xml

| 파일 경로 | COBOL 대응 | 설명 |
|----------|-----------|------|
| `src/main/java/com/kbstar/kip/enbipba/xsql/DUCorpEvalHistoryA.xml` | DIPA301 DBIO/SQLIO 45건 | MyBatis SQL 매핑 XML |

**구현된 SQL ID (35개)**:

| SQL ID | 종류 | 대상 테이블 | COBOL 대응 | 비고 |
|--------|------|-----------|-----------|------|
| selectExistCheckQipa301 | select | THKIPB110 | SQLIO QIPA301 | 역설계 |
| selectMainDebtAffltYnQipa307 | select | 주채무계열 테이블 | SQLIO QIPA307 | 역설계 |
| selectEmployeeInfoQipa302 | select | 직원기본 테이블 | SQLIO QIPA302 | 역설계 |
| insertThkipb110 | insert | THKIPB110 | DBIO INSERT-CMD-Y | |
| selectThkipb110ForUpdate | select | THKIPB110 | DBIO SELECT-CMD-Y | FOR UPDATE |
| deleteThkipb110 | delete | THKIPB110 | DBIO DELETE-CMD-Y | |
| selectListThkipb111ForUpdate | select | THKIPB111 | DBIO OPEN/FETCH/CLOSE | CURSOR→다건 SELECT |
| deleteThkipb111 | delete | THKIPB111 | DBIO DELETE-CMD-Y | |
| selectListThkipb116ForUpdate | select | THKIPB116 | DBIO OPEN/FETCH/CLOSE | CURSOR→다건 SELECT |
| deleteThkipb116 | delete | THKIPB116 | DBIO DELETE-CMD-Y | |
| selectPksQipa303 | select | THKIPB113 | SQLIO QIPA303 | 역설계 |
| selectThkipb113ForUpdate | select | THKIPB113 | DBIO SELECT-CMD-Y | FOR UPDATE |
| deleteThkipb113 | delete | THKIPB113 | DBIO DELETE-CMD-Y | |
| selectPksQipa304 | select | THKIPB112 | SQLIO QIPA304 | 역설계 |
| selectThkipb112ForUpdate | select | THKIPB112 | DBIO SELECT-CMD-Y | FOR UPDATE |
| deleteThkipb112 | delete | THKIPB112 | DBIO DELETE-CMD-Y | |
| selectListThkipb114ForUpdate | select | THKIPB114 | DBIO OPEN/FETCH/CLOSE | CURSOR→다건 SELECT |
| deleteThkipb114 | delete | THKIPB114 | DBIO DELETE-CMD-Y | |
| selectThkipb118ForUpdate | select | THKIPB118 | DBIO SELECT-CMD-Y | FOR UPDATE |
| deleteThkipb118 | delete | THKIPB118 | DBIO DELETE-CMD-Y | |
| selectPksQipa305 | select | THKIPB130 | SQLIO QIPA305 | 역설계 |
| selectThkipb130ForUpdate | select | THKIPB130 | DBIO SELECT-CMD-Y | FOR UPDATE |
| deleteThkipb130 | delete | THKIPB130 | DBIO DELETE-CMD-Y | |
| selectThkipb131ForUpdate | select | THKIPB131 | DBIO SELECT-CMD-Y | FOR UPDATE |
| deleteThkipb131 | delete | THKIPB131 | DBIO DELETE-CMD-Y | |
| selectListThkipb132ForUpdate | select | THKIPB132 | DBIO OPEN/FETCH/CLOSE | CURSOR→다건 SELECT |
| deleteThkipb132 | delete | THKIPB132 | DBIO DELETE-CMD-Y | |
| selectPksQipa306 | select | THKIPB133 | SQLIO QIPA306 | 역설계 |
| selectThkipb133ForUpdate | select | THKIPB133 | DBIO SELECT-CMD-Y | FOR UPDATE |
| deleteThkipb133 | delete | THKIPB133 | DBIO DELETE-CMD-Y | |
| selectPksQipa308 | select | THKIPB119 | SQLIO QIPA308 | 역설계 |
| selectThkipb119ForUpdate | select | THKIPB119 | DBIO SELECT-CMD-Y | FOR UPDATE |
| deleteThkipb119 | delete | THKIPB119 | DBIO DELETE-CMD-Y | |

#### DUCorpEvalHistoryA.java

| 파일 경로 | COBOL 대응 | 설명 |
|----------|-----------|------|
| `src/main/java/com/kbstar/kip/enbipba/biz/DUCorpEvalHistoryA.java` | DIPA301.cbl (DC, 1985행) | DataUnit 본체 |

**구현된 메서드**:

| 메서드명 | 접근자 | COBOL 대응 | 설명 |
|---------|--------|-----------|------|
| manageCorpEvalHistory | public @BizMethod | S0000-MAIN-RTN | 처리구분 분기 메인 DM |
| _insertCorpEvalHistory | private | S3000~S3221 | 신규평가 처리 (처리구분 '01') |
| _selectExistCheck | private | S3100 (QIPA301) | 기존재 확인 조회 |
| _selectMainDebtAffltYn | private | S3221 (QIPA307) | 주채무계열여부 조회 |
| _selectEmployeeInfo | private | S5000 (QIPA302) | 직원기본정보 조회 |
| _deleteCorpEvalHistoryAll | private | S4200 | 전체 삭제 총괄 (처리구분 '03') |
| _deleteThkipb110 | private | S4210 | THKIPB110 DELETE |
| _deleteThkipb111Loop | private | S4220 | THKIPB111 CURSOR 루프 DELETE |
| _deleteThkipb116Loop | private | S4230 | THKIPB116 CURSOR 루프 DELETE |
| _deleteThkipb113 | private | S4240/S4241 | THKIPB113 SQLIO+DELETE |
| _deleteThkipb112 | private | S4250/S4251 | THKIPB112 SQLIO+DELETE |
| _deleteThkipb114Loop | private | S4260 | THKIPB114 CURSOR 루프 DELETE |
| _deleteThkipb118 | private | S4290 | THKIPB118 DELETE |
| _deleteThkipb130 | private | S42A0/S42A1 | THKIPB130 SQLIO+DELETE |
| _deleteThkipb131 | private | S42B0 | THKIPB131 DELETE |
| _deleteThkipb132Loop | private | S42C0 | THKIPB132 CURSOR 루프 DELETE |
| _deleteThkipb133 | private | S42D0/S42D1 | THKIPB133 SQLIO+DELETE |
| _deleteThkipb119 | private | S42E0/S42E1 | THKIPB119 SQLIO+DELETE |

---

### 2.3 Phase 3 - ProcessUnit

| 파일 경로 | COBOL 대응 | 설명 |
|----------|-----------|------|
| `src/main/java/com/kbstar/kip/enbipba/biz/PUCorpEvalHistory.java` | AIPBA30.cbl (AS, 255행) | ProcessUnit 본체 |

**구현 내용**:
- `@BizUnitBind DUCorpEvalHistoryA duCorpEvalHistoryA`: DU 의존성 주입
- `pmAipba30Xxxx01()`: PM 메서드 (거래코드 TBD, TODO 주석 포함)
  - S1000: CommonArea 취득, 출력영역 초기화
  - S2000: 4개 필수 입력값 검증 (처리구분/기업집단그룹코드/평가년월일/기업집단등록코드)
  - S3000: DU 호출, 응답 조립, formId 설정
  - S9000: responseData 반환

---

## 3. TODO 항목 (수동 검토 필요)

### 3.1 SQLIO 소스 미확보 항목 (고위험)

| 위치 | TODO 내용 | 위험도 |
|------|---------|--------|
| DUCorpEvalHistoryA.xml: selectExistCheckQipa301 | QIPA301 SQLIO 소스 미확보 - SQL 역설계 적용. 실제 쿼리 조건 검증 필요 | HIGH |
| DUCorpEvalHistoryA.xml: selectMainDebtAffltYnQipa307 | QIPA307 SQLIO 소스 미확보 - 주채무계열 조회 대상 테이블명/컬럼명 확인 필요 | HIGH |
| DUCorpEvalHistoryA.xml: selectEmployeeInfoQipa302 | QIPA302 SQLIO 소스 미확보 - 직원기본 조회 테이블 확인 필요 (FUBcEmployee 공통 유틸 대체 검토) | HIGH |
| DUCorpEvalHistoryA.xml: selectPksQipa303 | QIPA303 SQLIO 소스 미확보 - THKIPB113 PK 조회 컬럼 확인 필요 | HIGH |
| DUCorpEvalHistoryA.xml: selectPksQipa304 | QIPA304 SQLIO 소스 미확보 - THKIPB112 PK 조회 컬럼 확인 필요 | HIGH |
| DUCorpEvalHistoryA.xml: selectPksQipa305 | QIPA305 SQLIO 소스 미확보 - THKIPB130 PK 조회 컬럼 확인 필요 | HIGH |
| DUCorpEvalHistoryA.xml: selectPksQipa306 | QIPA306 SQLIO 소스 미확보 - THKIPB133 PK 조회 컬럼 확인 필요 | HIGH |
| DUCorpEvalHistoryA.xml: selectPksQipa308 | QIPA308 SQLIO 소스 미확보 - THKIPB119 PK 조회 컬럼 확인 필요 | HIGH |

### 3.2 처리구분 '02' 확정취소 (미정의)

| 위치 | TODO 내용 | 위험도 |
|------|---------|--------|
| DUCorpEvalHistoryA.java: manageCorpEvalHistory() | 처리구분 '02' 확정취소 로직 무동작으로 구현. 업무팀 확인 후 로직 추가 필요 | MEDIUM |

### 3.3 테이블 컬럼 역설계 항목 (중위험)

| 위치 | TODO 내용 | 위험도 |
|------|---------|--------|
| DUCorpEvalHistoryA.xml: insertThkipb110 | THKIPB110 테이블 카피북(TRIPB110) 미확보 - 컬럼명 역설계 적용. 실제 DDL과 대조 필요 | MEDIUM |
| DUCorpEvalHistoryA.xml: 전체 테이블 SQL | TRIPB110~TRIPB133 카피북 미확보 - 컬럼명 역설계 적용. 12개 테이블 DDL 전체 검증 필요 | MEDIUM |

### 3.4 거래코드 미확정

| 위치 | TODO 내용 | 위험도 |
|------|---------|--------|
| PUCorpEvalHistory.java: pmAipba30Xxxx01() | 거래코드 미확정으로 임시 메서드명 사용. 실제 거래코드 확보 후 메서드명 변경 필요 | LOW |

### 3.5 프레임워크 확인 필요 항목

| 위치 | TODO 내용 | 위험도 |
|------|---------|--------|
| PUCorpEvalHistory.java: pmAipba30Xxxx01() | CommonArea에 비계약업무구분코드('060') 세팅 API 확인 필요 | LOW |
| PUCorpEvalHistory.java: pmAipba30Xxxx01() | #BOFMID(폼ID 설정) 프레임워크 자동 처리 vs responseData.put 방식 확인 필요 | LOW |

---

## 4. 변환 시 주요 결정 사항

| 항목 | 결정 내용 | 근거 |
|------|---------|------|
| COBOL CURSOR 패턴 변환 | DBIO OPEN-FETCH-CLOSE → `dbSelectMulti()` + IRecordSet 루프 | conversion_plan.md 5.3 DB 접근 매핑 |
| COBOL SQLIO 패턴 변환 | `#DYSQLA QIPA30X` → `dbSelectMulti("selectPksQipa30X", ...)` | conversion_plan.md 5.3 DB 접근 매핑 |
| DU 내 WK-AREA 변수 | 모두 메서드 내 로컬 변수로 처리 (멤버 필드 선언 금지) | 싱글톤 스레드 안전성 요건 |
| #ERROR 변환 | `throw new BusinessException(errCd, treatCd, msg)` | PM까지 자동 전파 - re-throw 불필요 |
| 처리구분 '02' 처리 | 무동작 + TODO 주석 | 사용자 지시에 따른 TBD 처리 |
| THKIPB113/112/130/133/119 삭제 | SQLIO PK 조회 후 건별 LOCK SELECT + DELETE | COBOL S4240/S4250/S42A0/S42D0/S42E0 패턴 동일 |
| THKIPB111/116/114/132 삭제 | CURSOR 전체를 `dbSelectMulti` 다건 조회 후 루프 DELETE | COBOL DBIO OPEN-FETCH-CLOSE 커서 패턴 대응 |
| THKIPB110/118/131 삭제 | 단건 LOCK SELECT + DELETE | COBOL DBIO SELECT-CMD-Y + DELETE-CMD-Y 패턴 |
| 입력 파라미터 전달 방식 | requestData 직접 전달 금지 - 필드별 명시적 DataSet 생성 후 전달 | conversion_plan.md 5.2 매핑 테이블 |
| formId 조립 | `"V1"` + CommonArea.getScreenNo() | COBOL MOVE 'V1' TO WK-FMID(1:2), MOVE BICOM-SCREN-NO TO WK-FMID(3:11) 대응 |

---

## 5. 미생성 파일 (변환 범위 외)

| 파일 경로 | 사유 |
|----------|------|
| `src/main/java/com/kbstar/kip/enbipba/uio/PUCorpEvalHistory.xml` | PM/DM IO 정보 XML. conversion_plan.md에서 생성 대상으로 명시되었으나 YNIPBA30/YPIPBA30 카피북 상세 정보 필요. 수동 작성 필요 |
| `src/main/java/com/kbstar/kip/enbipba/uio/DUCorpEvalHistoryA.xml` | DM IO 정보 XML. XDIPA301 카피북 상세 정보 필요. 수동 작성 필요 |
