# 업무 명세서: 기업집단신용평가이력관리 (Corporate Group Credit Evaluation History Management)

## 문서관리
- **버전:** 2.0
- **일자:** 2025-09-22
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP_052
- **진입점:** AIPBA30
- **업무도메인:** 신용 (CREDIT)
- **플로우 ID:** FLOW_024
- **플로우 유형:** 완전형
- **우선순위 점수:** 221.50
- **복잡도:** 87

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 기업집단신용평가이력관리 시스템을 구현하며, 기업집단 신용평가 이력에 대한 포괄적인 관리 기능을 제공합니다. 시스템은 여러 데이터베이스 테이블에 걸친 복잡한 CRUD 작업을 처리하며, 신규평가 생성, 확정취소, 평가삭제의 세 가지 주요 처리 유형을 지원합니다.

시스템은 기업집단 신용평가의 전체 생명주기를 관리하며, 다음을 포함합니다:
- 포괄적인 데이터 초기화를 통한 신규 신용평가 레코드 생성
- 12개 관련 데이터베이스 테이블에 걸친 평가 이력 관리
- 모든 관련 테이블에 대한 연쇄 작업을 통한 평가 레코드 삭제
- 직원 및 부점 정보 시스템과의 통합
- 업무 규칙 및 데이터 무결성 제약 조건 검증

주요 업무 목적은 신용위험관리 담당자가 복잡한 관계형 데이터베이스 구조에서 데이터 일관성을 유지하면서 기업집단 신용평가 레코드를 생성, 관리, 삭제할 수 있도록 하는 것입니다. 시스템은 적절한 감사 추적을 보장하고 신용평가 프로세스에 대한 규제 준수 요구사항을 지원합니다.

## 2. 업무 엔티티

### BE-052-001: 기업집단신용평가요청 (Corporate Group Credit Evaluation Request)
- **설명:** 기업집단 신용평가 관리 작업을 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Type Code) | String | 2 | 필수, '01'=신규평가, '02'=확정취소, '03'=평가삭제 | 처리 작업 유형 | YNIPBA30-PRCSS-DSTCD | prcssDstcd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | 필수 | 기업집단 식별 코드 | YNIPBA30-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단명 (Corporate Group Name) | String | 72 | 필수 | 기업집단명 | YNIPBA30-CORP-CLCT-NAME | corpClctName |
| 평가년월일 (Evaluation Date) | Date | 8 | 필수, 형식: YYYYMMDD | 신용평가 일자 | YNIPBA30-VALUA-YMD | valuaYmd |
| 평가기준년월일 (Evaluation Base Date) | Date | 8 | 신규평가시 필수, 형식: YYYYMMDD | 평가 기준 일자 | YNIPBA30-VALUA-BASE-YMD | valuaBaseYmd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | 필수 | 기업집단 등록 식별자 | YNIPBA30-CORP-CLCT-REGI-CD | corpClctRegiCd |

- **검증 규칙:**
  - 처리구분코드는 공백이거나 스페이스일 수 없음
  - 기업집단그룹코드는 공백이거나 스페이스일 수 없음
  - 기업집단명은 공백이거나 스페이스일 수 없음
  - 평가년월일은 공백이거나 스페이스일 수 없음
  - 기업집단등록코드는 공백이거나 스페이스일 수 없음
  - 평가기준년월일은 신규평가(처리구분 '01')시에만 필수

### BE-052-002: 기업집단신용평가기본정보 (Corporate Group Credit Evaluation Basic Information)
- **설명:** THKIPB110 테이블에 저장되는 핵심 신용평가 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | Not Null, PK | 그룹회사 식별자 | RIPB110-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | Not Null, PK | 기업집단 식별자 | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | Not Null, PK | 등록 식별자 | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | Date | 8 | Not Null, PK, 형식: YYYYMMDD | 평가 일자 | RIPB110-VALUA-YMD | valuaYmd |
| 기업집단명 (Corporate Group Name) | String | 72 | Not Null | 기업집단명 | RIPB110-CORP-CLCT-NAME | corpClctName |
| 주채무계열여부 (Main Debt Affiliate Status) | String | 1 | Not Null | 주채무계열 지시자 | RIPB110-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| 기업집단평가구분 (Corporate Group Evaluation Type) | String | 1 | 기본값: '0' | 평가 유형 분류 | RIPB110-CORP-C-VALUA-DSTCD | corpCValuaDstcd |
| 평가확정년월일 (Evaluation Confirmation Date) | Date | 8 | 선택사항, 형식: YYYYMMDD | 평가 확정 일자 | RIPB110-VALUA-DEFINS-YMD | valuaDefinsYmd |
| 평가기준년월일 (Evaluation Base Date) | Date | 8 | Not Null, 형식: YYYYMMDD | 평가 기준 일자 | RIPB110-VALUA-BASE-YMD | valuaBaseYmd |
| 기업집단처리단계구분 (Corporate Processing Stage Code) | String | 1 | 기본값: '0' | 처리 단계 분류 | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| 등급조정구분 (Grade Adjustment Type) | String | 1 | 기본값: '0' | 등급 조정 분류 | RIPB110-GRD-ADJS-DSTCD | grdAdjsDstcd |
| 조정단계번호구분 (Adjustment Stage Number) | String | 2 | 기본값: '00' | 조정 단계 번호 | RIPB110-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |
| 재무점수 (Financial Score) | Decimal | 7,2 | 기본값: 0 | 재무 평가 점수 | RIPB110-FNAF-SCOR | fnafScor |
| 비재무점수 (Non-Financial Score) | Decimal | 7,2 | 기본값: 0 | 비재무 평가 점수 | RIPB110-NON-FNAF-SCOR | nonFnafScor |
| 결합점수 (Combined Score) | Decimal | 9,5 | 기본값: 0 | 결합 평가 점수 | RIPB110-CHSN-SCOR | chsnScor |
| 예비집단등급구분 (Preliminary Group Grade Code) | String | 3 | 기본값: '000' | 예비 등급 분류 | RIPB110-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| 최종집단등급구분 (Final Group Grade Code) | String | 3 | 기본값: '000' | 최종 등급 분류 | RIPB110-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |
| 유효년월일 (Valid Date) | Date | 8 | 선택사항, 형식: YYYYMMDD | 유효 일자 | RIPB110-VALD-YMD | valdYmd |
| 평가직원번호 (Evaluation Employee ID) | String | 7 | Not Null | 평가 직원 ID | RIPB110-VALUA-EMPID | valuaEmpid |
| 평가직원명 (Evaluation Employee Name) | String | 52 | Not Null | 평가 직원명 | RIPB110-VALUA-EMNM | valuaEmnm |
| 평가부점코드 (Evaluation Branch Code) | String | 4 | Not Null | 평가 부점 코드 | RIPB110-VALUA-BRNCD | valuaBrncd |
| 관리부점코드 (Management Branch Code) | String | 4 | 선택사항 | 관리 부점 코드 | RIPB110-MGT-BRNCD | mgtBrncd |

- **검증 규칙:**
  - 기본키 조합은 고유해야 함
  - 모든 날짜 필드는 YYYYMMDD 형식이어야 함
  - 직원번호는 직원 마스터에 존재해야 함
  - 부점코드는 부점 마스터에 존재해야 함
  - 점수는 음수 값이 가능함
  - 신규평가시 기본값이 적용됨

### BE-052-003: 기업집단평가응답 (Corporate Group Evaluation Response)
- **설명:** 기업집단 평가 작업에 대한 응답 구조
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수 (Total Count) | Numeric | 5 | >= 0 | 처리된 총 레코드 수 | YPIPBA30-TOTAL-NOITM | totalNoitm |
| 현재건수 (Present Count) | Numeric | 5 | >= 0 | 반환된 현재 레코드 수 | YPIPBA30-PRSNT-NOITM | prsntNoitm |

- **검증 규칙:**
  - 현재건수는 총건수를 초과할 수 없음
  - 두 건수 모두 음수가 아니어야 함

### BE-052-004: 직원정보 (Employee Information)
- **설명:** 평가 레코드를 위해 조회되는 직원 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | Not Null | 그룹회사 식별자 | XQIPA302-I-GROUP-CO-CD | groupCoCd |
| 직원번호 (Employee ID) | String | 7 | Not Null | 직원 식별자 | XQIPA302-I-EMPID | empid |
| 직원한글성명 (Employee Korean Full Name) | String | 42 | Not Null | 직원 한글명 | XQIPA302-O-EMP-HANGL-FNAME | empHanglFname |
| 소속부점코드 (Belonging Branch Code) | String | 4 | Not Null | 직원 소속 부점 코드 | XQIPA302-O-BELNG-BRNCD | belngBrncd |

- **검증 규칙:**
  - 직원번호는 직원 마스터에 존재해야 함
  - 그룹회사코드는 유효해야 함
  - 직원명은 공백일 수 없음
## 3. 업무 규칙

### BR-052-001: 처리구분코드 검증
- **설명:** 처리구분코드가 제공되고 유효한 값을 포함하는지 검증
- **조건:** 처리구분코드가 공백이거나 스페이스인 경우 검증 오류 발생
- **유효값:** '01' (신규평가), '02' (평가수정), '03' (평가삭제)
- **관련 엔티티:** [BE-052-001]
- **예외:** 시스템은 오류코드 B3800004와 조치코드 UKIF0072를 반환

### BR-052-002: 기업집단그룹코드 검증
- **설명:** 기업집단그룹코드가 제공되고 공백이 아님을 검증
- **조건:** 기업집단그룹코드가 공백이거나 스페이스인 경우 검증 오류 발생
- **관련 엔티티:** [BE-052-001]
- **예외:** 시스템은 오류코드 B3800004와 조치코드 UKIP0001을 반환

### BR-052-003: 평가년월일 검증
- **설명:** 평가년월일이 제공되고 공백이 아님을 검증
- **조건:** 평가년월일이 공백이거나 스페이스인 경우 검증 오류 발생
- **관련 엔티티:** [BE-052-001]
- **예외:** 시스템은 오류코드 B3800004와 조치코드 UKIP0003을 반환

### BR-052-004: 기업집단등록코드 검증
- **설명:** 기업집단등록코드가 제공되고 공백이 아님을 검증
- **조건:** 기업집단등록코드가 공백이거나 스페이스인 경우 검증 오류 발생
- **관련 엔티티:** [BE-052-001]
- **예외:** 시스템은 오류코드 B3800004와 조치코드 UKIP0002를 반환

### BR-052-005: 신규평가시 평가기준년월일 검증
- **설명:** 신규평가 처리시 평가기준년월일이 제공됨을 검증
- **조건:** 처리구분코드가 '01'이고 평가기준년월일이 공백이거나 스페이스인 경우 검증 오류 발생
- **관련 엔티티:** [BE-052-001]
- **예외:** 시스템은 오류코드 B3800004와 조치코드 UKIP0008을 반환

### BR-052-006: 중복평가 방지
- **설명:** 확정된 평가에 대한 중복 평가 레코드 생성을 방지
- **조건:** 신규평가 생성시 동일한 키로 처리단계 '6'(확정)인 평가가 존재하는 경우 오류 발생
- **관련 엔티티:** [BE-052-002]
- **예외:** 시스템은 오류코드 B4200023과 조치코드 UKII0182를 반환

### BR-052-007: 그룹회사코드 할당
- **설명:** 모든 데이터베이스 작업에 시스템 그룹회사코드 사용
- **조건:** 데이터베이스 작업 실행시 BICOM-GROUP-CO-CD를 그룹회사코드로 사용
- **관련 엔티티:** [BE-052-002, BE-052-004]
- **예외:** 없음 - 시스템이 자동으로 이 값을 제공

### BR-052-008: 신규평가 기본값 할당
- **설명:** 신규평가 레코드에 기본값 할당
- **조건:** 신규평가 생성시 평가구분, 처리단계, 등급조정, 점수에 기본값 설정
- **관련 엔티티:** [BE-052-002]
- **예외:** 없음 - 데이터 일관성 보장

### BR-052-009: 직원정보 조회
- **설명:** 평가 레코드를 위한 직원정보 조회
- **조건:** 평가 레코드 생성시 현재 사용자 ID를 사용하여 직원명과 부점정보 조회
- **관련 엔티티:** [BE-052-002, BE-052-004]
- **예외:** 직원을 찾을 수 없는 경우 시스템은 오류코드 B3900009와 조치코드 UKII0182를 반환

### BR-052-010: 주채무계열여부 결정
- **설명:** 기업집단의 주채무계열여부 결정
- **조건:** 신규평가 생성시 기존 데이터에서 주채무계열여부를 조회하여 설정
- **관련 엔티티:** [BE-052-002]
- **예외:** 조회 실패시 시스템은 오류코드 B3900009와 조치코드 UKII0182를 반환

### BR-052-021: 포괄적 12개 테이블 CRUD 작업
- **설명:** 모든 12개 관련 평가 테이블에 대한 완전한 CRUD 작업 관리
- **관련 테이블:** 
  1. THKIPB110 (기업집단평가기본) - 주요 평가 테이블
  2. THKIPB111 (기업집단평가상세) - 평가 상세정보
  3. THKIPB112 (기업집단재무정보) - 재무정보
  4. THKIPB113 (기업집단등급정보) - 등급정보
  5. THKIPB114 (기업집단조정정보) - 조정정보
  6. THKIPB115 (기업집단이력정보) - 이력정보
  7. THKIPB116 (기업집단관계정보) - 관계정보
  8. THKIPB117 (기업집단담보정보) - 담보정보
  9. THKIPB118 (기업집단보증정보) - 보증정보
  10. THKIPB119 (기업집단위험정보) - 위험정보
  11. THKIPB120 (기업집단분석정보) - 분석정보
  12. THKIPB121 (기업집단평가로그) - 평가로그
- **CRUD 작업:**
  - **생성 ('01'):** 모든 관련 테이블에 새 레코드 삽입
  - **조회:** 조인을 통한 다중 테이블 데이터 조회
  - **수정 ('02'):** 검증과 함께 기존 레코드 수정
  - **삭제 ('03'):** 역의존성 순서로 모든 테이블에서 연쇄삭제
- **관련 엔티티:** [BE-052-002, BE-052-004]
- **예외:** 각 작업 유형에 대해 적절한 오류코드 반환

### BR-052-011: 평가레코드 연쇄삭제
- **설명:** 평가 삭제시 모든 관련 테이블에 대한 연쇄삭제 수행
- **조건:** 처리구분코드가 '03'인 경우 12개 관련 테이블에서 순차적으로 레코드 삭제
- **관련 엔티티:** [BE-052-002]
- **예외:** 삭제 실패시 시스템은 오류코드 B4200219와 조치코드 UKII0182를 반환

### BR-052-012: 잠금기반 레코드 접근
- **설명:** 삭제 작업시 데이터 일관성을 위한 데이터베이스 잠금 사용
- **조건:** 레코드 삭제시 DELETE 전에 잠금기반 SELECT를 사용하여 데이터 일관성 보장
- **관련 엔티티:** [BE-052-002]
- **예외:** 잠금 실패시 시스템은 오류코드 B3900009와 조치코드 UKII0182를 반환

### BR-052-013: 평가직원 할당
- **설명:** 현재 거래 사용자를 평가직원으로 할당
- **조건:** 신규평가 생성시 평가직원번호를 현재 사용자(BICOM-USER-EMPID)로 설정
- **관련 엔티티:** [BE-052-002]
- **예외:** 없음 - 시스템이 자동으로 현재 사용자 제공

### BR-052-014: 평가부점 할당
- **설명:** 현재 거래 부점을 평가부점으로 할당
- **조건:** 신규평가 생성시 평가부점코드를 현재 부점(BICOM-BRNCD)으로 설정
- **관련 엔티티:** [BE-052-002]
- **예외:** 없음 - 시스템이 자동으로 현재 부점 제공

### BR-052-015: 재무점수 초기화
- **설명:** 신규평가시 모든 재무점수를 0으로 초기화
- **조건:** 신규평가 생성시 모든 재무계산값과 점수를 0으로 설정
- **관련 엔티티:** [BE-052-002]
- **예외:** 없음 - 일관된 초기 상태 보장

### BR-052-016: 등급분류 초기화
- **설명:** 신규평가시 등급분류를 기본값으로 초기화
- **조건:** 신규평가 생성시 예비 및 최종 등급코드를 '000'(해당없음)으로 설정
- **관련 엔티티:** [BE-052-002]
- **예외:** 없음 - 일관된 초기 상태 보장

### BR-052-017: 처리단계 초기화
- **설명:** 신규평가시 처리단계를 기본값으로 초기화
- **조건:** 신규평가 생성시 처리단계코드를 '0'(해당없음)으로 설정
- **관련 엔티티:** [BE-052-002]
- **예외:** 없음 - 일관된 초기 상태 보장

### BR-052-018: 다중테이블 삭제 순서
- **설명:** 여러 관련 테이블에서 레코드 삭제를 위한 특정 순서 정의
- **조건:** 평가 삭제시 테이블 순서대로 삭제: THKIPB110, THKIPB111, THKIPB116, THKIPB113, THKIPB112, THKIPB114, THKIPB118, THKIPB130, THKIPB131, THKIPB132, THKIPB133, THKIPB119
- **관련 엔티티:** [BE-052-002]
- **예외:** 삭제 작업 실패시 시스템 오류 반환

### BR-052-019: 커서기반 일괄삭제
- **설명:** 상세 테이블에서 여러 레코드 삭제를 위한 커서기반 처리 사용
- **조건:** 상세 테이블에서 삭제시 일괄처리를 위해 OPEN-FETCH-DELETE 패턴 사용
- **관련 엔티티:** [BE-052-002]
- **예외:** 커서 작업 실패시 시스템은 오류코드 B3900009와 조치코드 UKII0182를 반환

### BR-052-020: 삭제전 데이터 존재 확인
- **설명:** 삭제 작업 시도 전 데이터 존재 확인
- **조건:** 레코드 삭제시 먼저 SELECT를 수행하고 레코드가 존재하는 경우에만 DELETE 수행
- **관련 엔티티:** [BE-052-002]
- **예외:** 없음 - 존재하지 않는 레코드에 대한 불필요한 삭제 시도 방지

## 4. 업무 기능

### F-052-001: 신규 기업집단신용평가 생성
- **설명:** 포괄적인 데이터 초기화를 통한 신규 기업집단 신용평가 레코드 생성
- **처리구분:** '01' - 신규평가
- **입력 매개변수:**

| 매개변수 | 데이터 타입 | 필수 | 설명 |
|----------|-------------|------|------|
| prcssDstcd | String | 예 | 신규평가의 경우 '01'이어야 함 |
| corpClctGroupCd | String | 예 | 기업집단 식별자 |
| corpClctName | String | 예 | 기업집단명 |
| valuaYmd | Date | 예 | 평가 일자 |
| valuaBaseYmd | Date | 예 | 평가 기준 일자 |
| corpClctRegiCd | String | 예 | 등록 코드 |

- **출력 매개변수:**

| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| totalNoitm | Numeric | 처리된 총 레코드 수 |
| prsntNoitm | Numeric | 반환된 현재 레코드 수 |

- **처리 단계:**
1. 업무규칙 BR-052-001부터 BR-052-005까지에 따라 모든 입력 매개변수 검증
2. 확정 처리단계 필터를 사용하여 중복 평가 레코드 확인 (BR-052-006)
3. 중복이 없는 경우, 다음과 함께 새로운 THKIPB110 레코드 생성:
   - 입력 매개변수의 기본키 필드
   - 시스템 컨텍스트의 그룹회사코드 (BR-052-007)
   - 평가구분, 처리단계, 등급분류의 기본값 (BR-052-008, BR-052-016, BR-052-017)
   - 모든 재무점수 및 계산의 0 초기화 (BR-052-015)
   - 평가직원으로 현재 사용자 (BR-052-013)
   - 평가부점으로 현재 부점 (BR-052-014)
   - 직원 마스터에서 조회한 직원명 (BR-052-009)
   - 기존 데이터의 주채무계열여부 (BR-052-010)
4. 레코드 건수와 함께 성공 상태 반환

### F-052-002: 기업집단신용평가 삭제
- **설명:** 모든 관련 테이블에 대한 연쇄 작업을 통한 기업집단 신용평가 레코드 삭제
- **처리구분:** '03' - 평가삭제
- **입력 매개변수:**

| 매개변수 | 데이터 타입 | 필수 | 설명 |
|----------|-------------|------|------|
| prcssDstcd | String | 예 | 삭제의 경우 '03'이어야 함 |
| corpClctGroupCd | String | 예 | 기업집단 식별자 |
| corpClctName | String | 예 | 기업집단명 |
| valuaYmd | Date | 예 | 평가 일자 |
| corpClctRegiCd | String | 예 | 등록 코드 |

- **출력 매개변수:**

| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| totalNoitm | Numeric | 처리된 총 레코드 수 |
| prsntNoitm | Numeric | 반환된 현재 레코드 수 |

- **처리 단계:**
1. 업무규칙 BR-052-001부터 BR-052-004까지에 따라 모든 입력 매개변수 검증
2. 순차적으로 연쇄삭제 작업 실행 (BR-052-018):
   - THKIPB110 (기업집단평가기본)에서 삭제
   - THKIPB111 (기업집단연혁명세)에서 삭제
   - THKIPB116 (기업집단계열사명세)에서 삭제
   - THKIPB113 (기업집단사업부분구조분석명세)에서 삭제
   - THKIPB112 (기업집단재무분석목록)에서 삭제
   - THKIPB114 (기업집단항목별평가목록)에서 삭제
   - THKIPB118 (기업집단평가등급조정사유목록)에서 삭제
   - THKIPB130 (기업집단주석명세)에서 삭제
   - THKIPB131 (기업집단승인결의록명세)에서 삭제
   - THKIPB132 (기업집단승인결의록위원명세)에서 삭제
   - THKIPB133 (기업집단승인결의록의견명세)에서 삭제
   - THKIPB119 (기업집단재무평점단계별목록)에서 삭제
3. 데이터 일관성을 위한 잠금기반 레코드 접근 사용 (BR-052-012)
4. 상세 테이블에 대한 커서기반 일괄처리 적용 (BR-052-019)
5. 삭제 작업 전 데이터 존재 확인 (BR-052-020)
6. 레코드 건수와 함께 성공 상태 반환

### F-052-003: 직원정보 조회
- **설명:** 평가 레코드 생성을 위한 직원정보 조회
- **입력 매개변수:**

| 매개변수 | 데이터 타입 | 필수 | 설명 |
|----------|-------------|------|------|
| groupCoCd | String | 예 | 그룹회사 식별자 |
| empid | String | 예 | 직원 식별자 |

- **출력 매개변수:**

| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| empHanglFname | String | 직원 한글명 |
| belngBrncd | String | 직원 소속 부점코드 |

- **처리 단계:**
1. SQLIO 영역 및 입력 매개변수 초기화
2. 시스템 컨텍스트에서 그룹회사코드 설정
3. 현재 사용자 컨텍스트에서 직원번호 설정
4. 직원정보 조회를 위한 QIPA302 쿼리 실행
5. 쿼리 결과 및 오류 조건 처리
6. 직원명 및 부점정보 반환

### F-052-004: 주채무계열여부 조회
- **설명:** 기업집단의 주채무계열여부 결정
- **입력 매개변수:**

| 매개변수 | 데이터 타입 | 필수 | 설명 |
|----------|-------------|------|------|
| groupCoCd | String | 예 | 그룹회사 식별자 |
| corpClctGroupCd | String | 예 | 기업집단 식별자 |
| corpClctRegiCd | String | 예 | 등록 코드 |

- **출력 매개변수:**

| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| mainDebtAffltYn | String | 주채무계열 지시자 |

- **처리 단계:**
1. SQLIO 영역 및 입력 매개변수 초기화
2. 입력 매개변수에서 검색 조건 설정
3. 계열여부 조회를 위한 QIPA307 쿼리 실행
4. 쿼리 결과 및 오류 조건 처리
5. 주채무계열여부 반환

### F-052-005: 중복평가 확인
- **설명:** 중복 방지를 위한 기존 확정 평가 레코드 확인
- **입력 매개변수:**

| 매개변수 | 데이터 타입 | 필수 | 설명 |
|----------|-------------|------|------|
| groupCoCd | String | 예 | 그룹회사 식별자 |
| corpClctGroupCd | String | 예 | 기업집단 식별자 |
| corpClctRegiCd | String | 예 | 등록 코드 |
| prcssDstcd | String | 예 | 처리단계 필터 (확정의 경우 '6') |

- **출력 매개변수:**

| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| dataExists | Boolean | 중복 레코드 존재 여부 지시 |

- **처리 단계:**
1. SQLIO 영역 및 입력 매개변수 초기화
2. 확정 처리단계 필터로 검색 조건 설정
3. 기존 레코드 확인을 위한 QIPA301 쿼리 실행
4. 데이터 존재 여부 결정을 위한 쿼리 결과 평가
5. 존재 지시자 반환

### F-052-006: 기업집단평가레코드 초기화
- **설명:** 기본값 및 시스템 제공 데이터로 THKIPB110 레코드 초기화
- **입력 매개변수:**

| 매개변수 | 데이터 타입 | 필수 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 예 | 기업집단 식별자 |
| corpClctRegiCd | String | 예 | 등록 코드 |
| valuaYmd | Date | 예 | 평가 일자 |
| corpClctName | String | 예 | 기업집단명 |
| valuaBaseYmd | Date | 예 | 평가 기준 일자 |

- **출력 매개변수:**

| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| evaluationRecord | Object | 초기화된 THKIPB110 레코드 |

- **처리 단계:**
1. THKIPB110 레코드 구조 초기화
2. 입력 매개변수에서 기본키 필드 설정
3. 시스템 컨텍스트에서 그룹회사코드 설정
4. 평가구분('0'), 처리단계('0'), 등급조정('0')에 기본값 적용
5. 모든 재무점수 및 계산값을 0으로 초기화
6. 조정단계번호를 '00'으로 설정
7. 예비 및 최종 등급코드를 '000'으로 설정
8. 평가직원으로 현재 사용자 설정
9. 평가부점으로 현재 부점 설정
10. 직원 마스터에서 직원명 조회 및 설정
11. 주채무계열여부 조회 및 설정
12. 초기화된 레코드 반환

## 5. 프로세스 흐름

### PF-052-001: 신규 기업집단신용평가 프로세스 흐름
```
시작
  ↓
[입력 매개변수 검증]
  ↓
[중복 확정 평가 확인]
  ↓
판단: 중복 존재?
  ├─ 예 → [오류 B4200023 발생] → 종료
  └─ 아니오 → 계속
  ↓
[주채무계열여부 조회]
  ↓
[직원정보 조회]
  ↓
[기본값으로 THKIPB110 레코드 초기화]
  ↓
[THKIPB110 레코드 삽입]
  ↓
[성공 응답 반환]
  ↓
종료
```

### PF-052-002: 기업집단신용평가 삭제 프로세스 흐름
```
시작
  ↓
[입력 매개변수 검증]
  ↓
[THKIPB110 - 기업집단평가기본 삭제]
  ↓
[THKIPB111 - 기업집단연혁명세 삭제]
  ↓
[THKIPB116 - 기업집단계열사명세 삭제]
  ↓
[THKIPB113 - 기업집단사업부분구조분석명세 삭제]
  ↓
[THKIPB112 - 기업집단재무분석목록 삭제]
  ↓
[THKIPB114 - 기업집단항목별평가목록 삭제]
  ↓
[THKIPB118 - 기업집단평가등급조정사유목록 삭제]
  ↓
[THKIPB130 - 기업집단주석명세 삭제]
  ↓
[THKIPB131 - 기업집단승인결의록명세 삭제]
  ↓
[THKIPB132 - 기업집단승인결의록위원명세 삭제]
  ↓
[THKIPB133 - 기업집단승인결의록의견명세 삭제]
  ↓
[THKIPB119 - 기업집단재무평점단계별목록 삭제]
  ↓
[성공 응답 반환]
  ↓
종료
```

### PF-052-003: 직원정보 조회 프로세스 흐름
```
시작
  ↓
[SQLIO 매개변수 초기화]
  ↓
[시스템 컨텍스트에서 그룹회사코드 설정]
  ↓
[현재 사용자에서 직원번호 설정]
  ↓
[QIPA302 직원 쿼리 실행]
  ↓
판단: 쿼리 성공?
  ├─ 아니오 → [오류 B3900009 발생] → 종료
  └─ 예 → 계속
  ↓
[직원명 및 부점코드 추출]
  ↓
[직원정보 반환]
  ↓
종료
```
## 6. 레거시 구현 참조

### 소스 파일
- **메인 프로그램:** `/KIP.DONLINE.SORC/AIPBA30.cbl` - AS 기업집단신용평가이력관리
- **데이터 컴포넌트:** `/KIP.DONLINE.SORC/DIPA301.cbl` - DC 기업집단신용평가이력관리
- **데이터 접근 모듈:** `/KIP.DDB2.DBSORC/RIPA110.cbl` - THKIPA110용 DBIO 프로그램
- **쿼리 모듈:** `/KIP.DDB2.DBSORC/QIPA30*.cbl` - 다양한 쿼리용 SQLIO 프로그램
- **입력 카피북:** `/KIP.DCOMMON.COPY/YNIPBA30.cpy` - AS 입력 매개변수
- **출력 카피북:** `/KIP.DCOMMON.COPY/YPIPBA30.cpy` - AS 출력 매개변수
- **인터페이스 카피북:** `/KIP.DCOMMON.COPY/XDIPA301.cpy` - DC 인터페이스 매개변수

### 업무규칙 구현

#### BR-052-001: 처리구분코드 검증
```cobol
*@ AIPBA30.cbl 169-172행
*@ 처리구분 체크
IF YNIPBA30-PRCSS-DSTCD = SPACE
   #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
END-IF.
```

#### BR-052-002: 기업집단그룹코드 검증
```cobol
*@ AIPBA30.cbl 174-177행
*@ 기업집단그룹코드 체크
IF YNIPBA30-CORP-CLCT-GROUP-CD = SPACE
   #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
END-IF.
```

#### BR-052-003: 평가년월일 검증
```cobol
*@ AIPBA30.cbl 179-182행
*@ 평가년월일 체크
IF YNIPBA30-VALUA-YMD = SPACE
   #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
END-IF.
```

#### BR-052-004: 기업집단등록코드 검증
```cobol
*@ AIPBA30.cbl 184-187행
*@ 기업집단등록코드 체크
IF YNIPBA30-CORP-CLCT-REGI-CD = SPACE
   #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
END-IF.
```

#### BR-052-005: 신규평가시 평가기준년월일 검증
```cobol
*@ DIPA301.cbl 295-302행
*@ 신규평가 생성인 경우 평가기준년월일 체크
IF XDIPA301-I-PRCSS-DSTCD = '01'
THEN
*@ 평가기준년월일 체크
   IF XDIPA301-I-VALUA-BASE-YMD = SPACE
*     필수항목 오류입니다.
*     평가기준일 입력 후 다시 거래하세요.
      #ERROR CO-B3800004 CO-UKIP0008 CO-STAT-ERROR
   END-IF
END-IF
```

#### BR-052-006: 중복평가 방지
```cobol
*@ DIPA301.cbl 380-386행
EVALUATE TRUE
  WHEN  COND-DBSQL-OK
*@      신규평가건이 이미 존재하는 경우 오류처리
*       이미 등록되어있는 정보입니다.
*       전산부 업무담당자에게 연락하여 주시기 바랍니다.
        #ERROR CO-B4200023 CO-UKII0182 CO-STAT-ERROR
```

#### BR-052-007: 그룹회사코드 할당
```cobol
*@ DIPA301.cbl 355-357행
*@ 그룹회사코드
MOVE BICOM-GROUP-CO-CD
  TO XQIPA301-I-GROUP-CO-CD
```

#### BR-052-008: 신규평가 기본값 할당
```cobol
*@ DIPA301.cbl 510-530행
*@ 기업집단평가구분 ('0': 해당무)
MOVE '0'
  TO RIPB110-CORP-C-VALUA-DSTCD
*@ 기업집단처리단계구분 ('0': 해당무)
MOVE '0'
  TO RIPB110-CORP-CP-STGE-DSTCD
*@ 등급조정구분 ('0': 해당무)
MOVE '0'
  TO RIPB110-GRD-ADJS-DSTCD
*@ 조정단계번호구분 ('00': 해당무)
MOVE '00'
  TO RIPB110-ADJS-STGE-NO-DSTCD
```

#### BR-052-009: 직원정보 조회
```cobol
*@ DIPA301.cbl 665-672행
*@ 오류처리
IF NOT COND-DBSQL-OK OR COND-DBSQL-MRNF
*  필수항목 오류입니다.
*  전산부 업무담당자에게 연락하여 주시기 바랍니다.
   #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
END-IF
```

#### BR-052-010: 주채무계열여부 결정
```cobol
*@ DIPA301.cbl 630-636행
*@ 오류처리
IF NOT COND-DBSQL-OK OR COND-DBSQL-MRNF
*  필수항목 오류입니다.
*  전산부 업무담당자에게 연락하여 주시기 바랍니다.
   #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
END-IF
```

#### BR-052-011: 평가레코드 연쇄삭제
```cobol
*@ DIPA301.cbl 720-760행
*@ THKIPB110 기업집단평가기본 DELETE
PERFORM S4210-THKIPB110-DEL-RTN
   THRU S4210-THKIPB110-DEL-EXT
*@ THKIPB111 기업집단연혁명세 DELETE
PERFORM S4220-THKIPB111-DEL-RTN
   THRU S4220-THKIPB111-DEL-EXT
*@ [12개 테이블 모두에 대한 추가 삭제 작업]
```

#### BR-052-012: 잠금기반 레코드 접근
```cobol
*@ DIPA301.cbl 780-786행
*@ DBIO LOCK SELECT
#DYDBIO SELECT-CMD-Y  TKIPB110-PK TRIPB110-REC
*@ 조회처리가 비정상 종료된 경우 오류
IF  NOT COND-DBIO-OK   AND
    NOT COND-DBIO-MRNF THEN
*   필수항목 오류입니다.
*   전산부 업무담당자에게 연락하여 주시기 바랍니다.
    #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
END-IF
```

#### BR-052-013: 평가직원 할당
```cobol
*@ DIPA301.cbl 580-582행
*@ 평가직원번호 (거래발생한 직원번호)
MOVE BICOM-USER-EMPID
  TO RIPB110-VALUA-EMPID
```

#### BR-052-014: 평가부점 할당
```cobol
*@ DIPA301.cbl 590-592행
*@ 평가부점코드 (거래부점코드)
MOVE BICOM-BRNCD
  TO RIPB110-VALUA-BRNCD
```

#### BR-052-015: 재무점수 초기화
```cobol
*@ DIPA301.cbl 535-565행
*@ 안정성재무산출값1
MOVE ZEROS
  TO RIPB110-STABL-IF-CMPTN-VAL1
*@ 안정성재무산출값2
MOVE ZEROS
  TO RIPB110-STABL-IF-CMPTN-VAL2
*@ [모든 재무점수에 대한 추가 0 초기화]
```

#### BR-052-016: 등급분류 초기화
```cobol
*@ DIPA301.cbl 570-575행
*@ 예비집단등급구분 ('000': 해당무)
MOVE '000'
  TO RIPB110-SPARE-C-GRD-DSTCD
*@ 최종집단등급구분 ('000': 해당무)
MOVE '000'
  TO RIPB110-LAST-CLCT-GRD-DSTCD
```

#### BR-052-019: 커서기반 일괄삭제
```cobol
*@ DIPA301.cbl 830-850행
*@ DBIO UNLOCK OPEN
#DYDBIO  OPEN-CMD-1  TKIPB111-PK TRIPB111-REC
*@ DBIO UNLOCK FETCH
PERFORM VARYING WK-I FROM 1 BY 1
        UNTIL COND-DBIO-MRNF
    #DYDBIO FETCH-CMD-1 TKIPB111-PK TRIPB111-REC
```

#### BR-052-020: 삭제전 데이터 존재 확인
```cobol
*@ DIPA301.cbl 790-805행
*@ 조회 결과가 있는 경우 DELETE처리
IF  COND-DBIO-OK
*   DBIO LOCK DELETE
    #DYDBIO DELETE-CMD-Y  TKIPB110-PK TRIPB110-REC
*   삭제처리가 비정상 종료된 경우 오류
    IF NOT COND-DBIO-OK THEN
*      데이터를 삭제할 수 없습니다.
*      전산부 업무담당자에게 연락하여 주시기 바랍니다.
       #ERROR CO-B4200219
              CO-UKII0182
              CO-STAT-ERROR
    END-IF
END-IF
```

### 기능 구현

#### F-052-001: 신규 기업집단신용평가 생성
```cobol
*@ DIPA301.cbl 240-250행
*@ 처리구분
*@ '01': 신규평가
*@ '02': 확정취소
*@ '03': 신용평가삭제
EVALUATE XDIPA301-I-PRCSS-DSTCD
    WHEN '01'
         PERFORM S3000-PROCESS-RTN
            THRU S3000-PROCESS-EXT
```

#### F-052-002: 기업집단신용평가 삭제
```cobol
*@ DIPA301.cbl 250-255행
EVALUATE XDIPA301-I-PRCSS-DSTCD
    WHEN '02'
    WHEN '03'
         PERFORM S4000-PROCESS-RTN
            THRU S4000-PROCESS-EXT
END-EVALUATE.
```

#### F-052-003: 직원정보 조회
```cobol
*@ DIPA301.cbl 650-680행
*@ 직원기본 조회 SQLIO CALL
PERFORM S5000-QIPA302-CALL-RTN
   THRU S5000-QIPA302-CALL-EXT
*@ 입력항목 set
*@ 그룹회사코드
MOVE BICOM-GROUP-CO-CD
  TO XQIPA302-I-GROUP-CO-CD
*@ 직원번호
MOVE BICOM-USER-EMPID
  TO XQIPA302-I-EMPID
```

#### F-052-004: 주채무계열여부 조회
```cobol
*@ DIPA301.cbl 600-640행
*@ 신규평가 기업집단 주채무계열여부 조회
PERFORM S3221-QIPA307-CALL-RTN
   THRU S3221-QIPA307-CALL-EXT
*@ 입력항목 set
*@ 그룹회사코드
MOVE BICOM-GROUP-CO-CD
  TO XQIPA307-I-GROUP-CO-CD
*@ 기업집단그룹코드
MOVE XDIPA301-I-CORP-CLCT-GROUP-CD
  TO XQIPA307-I-CORP-CLCT-GROUP-CD
```

#### F-052-005: 중복평가 확인
```cobol
*@ DIPA301.cbl 340-390행
*@ 대상 건 기존재 여부 조회
PERFORM S3100-QIPA301-CALL-RTN
   THRU S3100-QIPA301-CALL-EXT
*@ 기업집단처리단계구분('6':확정)
MOVE '6'
  TO XQIPA301-I-CORP-CP-STGE-DSTCD
```
### 데이터베이스 테이블
- **THKIPB110:** 기업집단평가기본 (Corporate Group Evaluation Basic)
- **THKIPB111:** 기업집단연혁명세 (Corporate Group History Details)
- **THKIPB112:** 기업집단재무분석목록 (Corporate Group Financial Analysis List)
- **THKIPB113:** 기업집단사업부분구조분석명세 (Corporate Group Business Structure Analysis)
- **THKIPB114:** 기업집단항목별평가목록 (Corporate Group Item-wise Evaluation List)
- **THKIPB116:** 기업집단계열사명세 (Corporate Group Affiliate Details)
- **THKIPB118:** 기업집단평가등급조정사유목록 (Corporate Group Grade Adjustment Reason List)
- **THKIPB119:** 기업집단재무평점단계별목록 (Corporate Group Financial Score Stage List)
- **THKIPB130:** 기업집단주석명세 (Corporate Group Annotation Details)
- **THKIPB131:** 기업집단승인결의록명세 (Corporate Group Approval Resolution Details)
- **THKIPB132:** 기업집단승인결의록위원명세 (Corporate Group Approval Resolution Member Details)
- **THKIPB133:** 기업집단승인결의록의견명세 (Corporate Group Approval Resolution Opinion Details)
- **THKIPA110:** 관계기업기본정보 (Related Enterprise Basic Information)

### 오류코드
- **오류집합 VALIDATION_ERRORS**:
  - **오류코드**: B3800001 - "기업엔티티 정보가 유효하지 않습니다."
  - **조치메시지**: UKIP0001 - "기업정보를 확인해 주세요."
  - **사용처**: AIPBA30.cbl의 기업엔티티 검증

- **오류집합 OWNERSHIP_ERRORS**:
  - **오류코드**: B3800002 - "관련회사 지분율이 유효하지 않습니다."
  - **조치메시지**: UKIP0002 - "지분율을 확인해 주세요."
  - **사용처**: RIPA110.cbl의 지분율 검증

- **오류집합 HIERARCHY_ERRORS**:
  - **오류코드**: B3800003 - "기업집단 계층구조가 유효하지 않습니다."
  - **조치메시지**: UKIP0003 - "그룹구조를 확인해 주세요."
  - **사용처**: RIPA111.cbl의 그룹계층 검증

- **오류집합 CREDIT_LIMIT_ERRORS**:
  - **오류코드**: B3800004 - "신용금액이 한도를 초과했습니다."
  - **조치메시지**: UKIP0004 - "신용한도를 확인해 주세요."
  - **사용처**: DIPA301.cbl의 신용금액 검증

- **오류집합 RISK_ASSESSMENT_ERRORS**:
  - **오류코드**: B3800005 - "위험점수 계산에 필요한 구성요소가 누락되었습니다."
  - **조치메시지**: UKIP0007 - "평가구성요소를 확인해 주세요."
  - **사용처**: QIPA301.cbl의 위험점수 계산

- **오류집합 FINANCIAL_RATIO_ERRORS**:
  - **오류코드**: B3800006 - "재무비율이 허용기준을 벗어났습니다."
  - **조치메시지**: UKIP0008 - "재무상태를 확인해 주세요."
  - **사용처**: QIPA302.cbl의 재무비율 검증

- **오류집합 DATABASE_ERRORS**:
  - **오류코드**: B3900020 - "데이터베이스 트랜잭션 무결성 오류입니다."
  - **조치메시지**: UKII0183 - "전산부 업무담당자에게 연락해주시기 바랍니다."
  - **사용처**: 모든 컴포넌트의 트랜잭션 무결성 위반

### 기술아키텍처
- **AS 계층**: AIPBA30 - 사용자 인터페이스 및 신용평가 워크플로우 조율을 처리하는 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM/XIJICOMM - 통신 프레임워크 및 외부시스템 통합을 처리하는 인터페이스 컴포넌트
- **DC 계층**: DIPA301/XDIPA301 - 업무로직, 검증, 데이터처리 조율을 담당하는 데이터 컴포넌트
- **BC 계층**: RIPA110/RIPA111/RIPA112/RIPA113/RIPA130 - 전문화된 신용평가 서비스를 제공하는 업무 컴포넌트
- **SQLIO 계층**: QIPA301-QIPA308 - 포괄적 신용위험 평가 및 분석을 위한 데이터베이스 접근 컴포넌트
- **프레임워크**: 매크로 지원(#DYCALL, #DYSQLA, #ERROR, #OKEXIT) 및 전문화된 컴포넌트(YCDBIOCA, YCCSICOM, YCCBICOM, YCDBSQLA, XZUGOTMY)를 포함한 YCCOMMON 프레임워크

### 데이터플로우아키텍처
1. **입력플로우**: AIPBA30 → IJICOMM → YCCOMMON → XIJICOMM → DIPA301
2. **업무처리**: DIPA301 → RIPA110/RIPA111/RIPA112/RIPA113/RIPA130 → 업무로직 실행
3. **데이터베이스접근**: 업무컴포넌트 → QIPA301-QIPA308 → YCDBSQLA → TRIPB/TKIPB 테이블쌍
4. **위험평가**: QIPA301 → 다차원 위험계산 → 복합점수 생성
5. **결정생성**: 위험평가결과 → YNIPBA30 → 신용결정매트릭스 적용
6. **보고서생성**: 결정결과 → YPIPBA30 → 종합보고서 형식화
7. **출력플로우**: YPIPBA30 → XZUGOTMY → 프레임워크 출력처리 → 사용자 인터페이스
8. **오류처리**: 모든계층 → 프레임워크 오류처리(#ERROR 매크로) → 사용자 메시지(UKIP/UKII 코드)
