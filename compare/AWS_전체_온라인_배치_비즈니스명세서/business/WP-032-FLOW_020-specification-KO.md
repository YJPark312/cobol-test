# 업무 명세서: 기업집단신용평가요약조회 (Corporate Group Credit Evaluation Summary Inquiry)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-032
- **진입점:** AIP4A82
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용처리 도메인에서 포괄적인 온라인 기업집단 신용평가 요약 조회 시스템을 구현합니다. 이 시스템은 기업집단 신용평가 데이터에 대한 실시간 조회 기능을 제공하여 기업집단 재무분석을 위한 신용평가 및 위험관리 운영을 지원합니다.

업무 목적은 다음과 같습니다:
- 다년도 평가 데이터 접근을 통한 포괄적 기업집단 신용평가 요약 조회 제공 (Provide comprehensive corporate group credit evaluation summary inquiry with multi-year evaluation data access)
- 재무점수, 비재무점수, 결합점수를 포함한 신용평가 결과의 실시간 조회 지원 (Support real-time inquiry of credit evaluation results including financial scores, non-financial scores, and combined scores)
- 기업집단의 등급조정 상태 추적 및 평가완료 모니터링 지원 (Enable grade adjustment status tracking and evaluation completion monitoring for corporate groups)
- 포괄적 평가이력 관리를 통한 기업집단 신용평가 데이터 무결성 유지 (Maintain corporate group credit evaluation data integrity with comprehensive evaluation history management)
- 기업집단 신용평가 운영의 감사추적 및 평가상태 추적 제공 (Provide audit trail and evaluation status tracking for corporate group credit assessment operations)
- 구조화된 신용평가 데이터 제시를 통한 의사결정 프로세스 지원 (Support decision-making processes through structured credit evaluation data presentation)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIP4A82 → IJICOMM → YCCOMMON → XIJICOMM → DIPA821 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA130 → QIPA821 → YCDBSQLA → XQIPA821 → TRIPB110 → TKIPB110 → TRIPB130 → TKIPB130 → XDIPA821 → XZUGOTMY → YNIP4A82 → YPIP4A82, 신용평가 조회, 등급완료 상태 검증, 의견 검색, 포괄적 평가 데이터 처리 운영을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 필수 필드 검증을 포함한 기업집단 신용평가 파라미터 검증 (Corporate group credit evaluation parameter validation with mandatory field verification)
- 등급조정 상태 결정을 포함한 다년도 신용평가 데이터 검색 (Multi-year credit evaluation data retrieval with grade adjustment status determination)
- 구조화된 평가 데이터 접근 및 조작을 통한 데이터베이스 무결성 관리 (Database integrity management through structured evaluation data access and manipulation)
- 포괄적 검증 규칙을 적용한 신용평가 완료상태 검증 (Credit evaluation completion status verification with comprehensive validation rules)
- 다중 테이블 관계 처리를 포함한 기업집단 평가이력 관리 (Corporate group evaluation history management with multi-table relationship handling)
- 데이터 일관성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for data consistency)

## 2. 업무 엔티티

### BE-032-001: 기업집단신용평가요청 (Corporate Group Credit Evaluation Request)
- **설명:** 기업집단 신용평가 요약 조회 운영을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | YNIP4A82-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIP4A82-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A82-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 신용평가를 위한 평가일자 | YNIP4A82-VALUA-YMD | valuaYmd |

- **검증 규칙:**
  - 그룹회사코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 모든 입력 파라미터는 적절한 신용평가 조회를 위해 필요함

### BE-032-002: 신용평가요약정보 (Credit Evaluation Summary Information)
- **설명:** 점수 및 등급 정보를 포함한 기업집단 신용평가 요약 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 완료여부 (Completion Status) | String | 1 | Y/N 값 | 평가완료 상태 표시자 | YPIP4A82-FNSH-YN | fnshYn |
| 조정단계번호구분 (Adjustment Stage Number Classification) | String | 2 | NOT NULL | 등급조정 프로세스의 단계번호 | YPIP4A82-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |
| 주석내용 (Comment Content) | String | 4002 | 선택사항 | 등급조정 의견 내용 | YPIP4A82-COMT-CTNT | comtCtnt |
| 총건수 (Total Count) | Numeric | 5 | 양수 | 평가 레코드의 총 개수 | YPIP4A82-TOTAL-NOITM | totalNoitm |
| 현재건수 (Current Count) | Numeric | 5 | 양수 | 평가 레코드의 현재 개수 | YPIP4A82-PRSNT-NOITM | prsntNoitm |

- **검증 규칙:**
  - 완료여부는 'Y'(완료) 또는 'N'(미완료)이어야 함
  - 조정단계번호구분은 완료된 평가에 대해 필요함
  - 주석내용은 선택사항이지만 중요한 평가 맥락을 제공함
  - 건수 필드는 음이 아닌 숫자 값이어야 함
  - 총건수는 현재건수보다 크거나 같아야 함

### BE-032-003: 신용평가그리드데이터 (Credit Evaluation Grid Data)
- **설명:** 점수 및 등급을 포함한 각 평가 기간의 상세 신용평가 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 등급조정구분코드 (Grade Adjustment Classification Code) | String | 1 | NOT NULL | 등급조정 분류 식별자 | YPIP4A82-GRD-ADJS-DSTCD | grdAdjsDstcd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 레코드의 평가일자 | YPIP4A82-VALUA-YMD | valuaYmd |
| 평가기준년월일 (Evaluation Base Date) | String | 8 | YYYYMMDD 형식 | 평가 기준의 기준일자 | YPIP4A82-VALUA-BASE-YMD | valuaBaseYmd |
| 재무점수 (Financial Score) | Numeric | 7 | 99999.99 형식 | 재무평가 점수 | YPIP4A82-FNAF-SCOR | fnafScor |
| 비재무점수 (Non-Financial Score) | Numeric | 7 | 99999.99 형식 | 비재무평가 점수 | YPIP4A82-NON-FNAF-SCOR | nonFnafScor |
| 결합점수 (Combined Score) | Numeric | 9 | 9999.99999 형식 | 결합평가 점수 | YPIP4A82-CHSN-SCOR | chsnScor |
| 예비집단등급구분코드 (Preliminary Group Grade Classification Code) | String | 3 | NOT NULL | 예비 집단등급 분류 | YPIP4A82-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| 최종집단등급구분코드 (Final Group Grade Classification Code) | String | 3 | NOT NULL | 최종 집단등급 분류 | YPIP4A82-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |
| 신예비집단등급구분코드 (New Preliminary Group Grade Classification Code) | String | 3 | 선택사항 | 신규 예비 집단등급 분류 | YPIP4A82-NEW-SC-GRD-DSTCD | newScGrdDstcd |
| 신최종집단등급구분코드 (New Final Group Grade Classification Code) | String | 3 | 선택사항 | 신규 최종 집단등급 분류 | YPIP4A82-NEW-LC-GRD-DSTCD | newLcGrdDstcd |

- **검증 규칙:**
  - 등급조정구분코드는 각 평가 레코드에 대해 필수임
  - 평가일자는 유효한 YYYYMMDD 형식이어야 함
  - 재무 및 비재무 점수는 유효한 범위(0-99999.99) 내에 있어야 함
  - 결합점수는 유효한 범위(0-9999.99999) 내에 있어야 함
  - 등급분류코드는 신용평가 표준에 따라 유효해야 함
  - 신규 등급코드는 선택사항이며 등급조정 프로세스에 사용됨

### BE-032-004: 데이터베이스관리정보 (Database Management Information)
- **설명:** 기업집단 신용평가 데이터 관리를 위한 데이터베이스 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 시스템최종처리일시 (System Last Processing Date Time) | Timestamp | 20 | NOT NULL | 시스템 최종 처리 타임스탬프 | RIPB110-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | String | 7 | NOT NULL | 시스템 최종 사용자 식별 | RIPB110-SYS-LAST-UNO | sysLastUno |
| 기업집단처리단계구분 (Corporate Group Processing Stage Classification) | String | 1 | NOT NULL | 기업집단 평가의 처리단계 | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| 평가직원번호 (Evaluation Employee ID) | String | 7 | NOT NULL | 평가를 위한 직원 ID | RIPB110-VALUA-EMPID | valuaEmpid |
| 평가부점코드 (Evaluation Branch Code) | String | 4 | NOT NULL | 평가를 위한 부점코드 | RIPB110-VALUA-BRNCD | valuaBrncd |

- **검증 규칙:**
  - 시스템최종처리일시는 감사추적을 위해 필수임
  - 시스템최종사용자번호는 사용자 추적을 위해 필수임
  - 기업집단처리단계구분은 평가완료 상태를 결정함
  - 평가직원번호는 책임 추적을 위해 필수임
  - 모든 감사 필드는 데이터 무결성을 위해 적절히 유지되어야 함

## 3. 업무 규칙

### BR-032-001: 그룹회사코드검증 (Group Company Code Validation)
- **규칙명:** 그룹회사코드 검증 규칙
- **설명:** 그룹회사코드가 제공되고 신용평가 조회를 위한 적절한 처리 맥락을 결정하는지 검증
- **조건:** 신용평가 조회가 요청될 때 그룹회사코드가 제공되고 적절한 회사 식별을 위해 유효해야 함
- **관련 엔티티:** BE-032-001
- **예외사항:** 그룹회사코드는 공백이거나 유효하지 않을 수 없음

### BR-032-002: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단코드 및 등록코드 검증 규칙
- **설명:** 적절한 기업집단 식별을 위해 기업집단코드와 등록코드가 모두 제공되는지 검증
- **조건:** 기업집단 신용평가가 요청될 때 그룹코드와 등록코드가 모두 제공되고 유효해야 함
- **관련 엔티티:** BE-032-001
- **예외사항:** 기업집단코드 또는 등록코드 중 어느 것도 공백일 수 없음

### BR-032-003: 평가일자검증 (Evaluation Date Validation)
- **규칙명:** 평가일자 형식 및 값 검증 규칙
- **설명:** 신용평가 처리를 위해 평가일자가 올바른 형식으로 제공되는지 검증
- **조건:** 신용평가 조회가 요청될 때 평가일자는 유효한 YYYYMMDD 형식이어야 함
- **관련 엔티티:** BE-032-001
- **예외사항:** 평가일자는 공백이거나 유효하지 않은 형식일 수 없음

### BR-032-004: 평가완료상태결정 (Evaluation Completion Status Determination)
- **규칙명:** 신용평가 완료상태 결정 규칙
- **설명:** 기업집단 처리단계에 기반하여 평가완료 상태를 결정
- **조건:** 처리단계가 '5'(등급확정 완료) 또는 '6'(신용평가 확정)일 때 완료상태를 'Y'로 설정, 그렇지 않으면 'N'으로 설정
- **관련 엔티티:** BE-032-002, BE-032-004
- **예외사항:** 처리단계는 데이터베이스 레코드에서 결정 가능해야 함

### BR-032-005: 등급조정의견검색 (Grade Adjustment Comment Retrieval)
- **규칙명:** 등급조정 의견 주석 검색 규칙
- **설명:** 완료된 평가에 대한 등급조정 의견 주석을 검색
- **조건:** 평가가 완료되었을 때 주석분류 '27' 및 일련번호 1로 기업집단 주석명세 테이블에서 주석내용을 검색
- **관련 엔티티:** BE-032-002
- **예외사항:** 주석이 존재하지 않으면 주석 검색이 빈 내용을 반환할 수 있음

### BR-032-006: 다년도평가데이터검색 (Multi-Year Evaluation Data Retrieval)
- **규칙명:** 다년도 신용평가 데이터 검색 규칙
- **설명:** 기준년도별 최대 평가일자에 기반하여 여러 평가 기간의 신용평가 데이터를 검색
- **조건:** 신용평가 조회가 수행될 때 요청된 평가일자보다 작거나 같은 각 기준년도의 최대 평가일자로 평가 레코드를 검색
- **관련 엔티티:** BE-032-003
- **예외사항:** 요청된 기업집단 및 일자 범위에 대한 평가 데이터가 존재해야 함

### BR-032-007: 점수검증 (Score Validation)
- **규칙명:** 재무 및 비재무 점수 검증 규칙
- **설명:** 재무점수, 비재무점수, 결합점수가 허용 가능한 범위 내에 있는지 검증
- **조건:** 평가점수가 처리될 때 재무 및 비재무점수는 0-99999.99 범위 내에, 결합점수는 0-9999.99999 범위 내에 있어야 함
- **관련 엔티티:** BE-032-003
- **예외사항:** 유효 범위를 벗어난 점수는 검토를 위해 플래그되어야 함

### BR-032-008: 등급분류검증 (Grade Classification Validation)
- **규칙명:** 등급분류코드 검증 규칙
- **설명:** 등급분류코드가 신용평가 표준에 부합하는지 검증
- **조건:** 등급분류가 할당될 때 예비 및 최종 등급코드는 확립된 신용평가 등급 표준에 따라 유효해야 함
- **관련 엔티티:** BE-032-003
- **예외사항:** 유효하지 않은 등급분류코드는 거부되어야 함

### BR-032-009: 데이터무결성관리 (Data Integrity Management)
- **규칙명:** 기업집단 신용평가 데이터 무결성 규칙
- **설명:** 여러 테이블 간의 데이터 무결성을 보장하고 참조 일관성을 유지
- **조건:** 데이터 검색이 수행될 때 THKIPB110과 THKIPB130 테이블 간의 참조 무결성을 보장
- **관련 엔티티:** BE-032-002, BE-032-003, BE-032-004
- **예외사항:** 데이터 무결성 위반은 방지되고 보고되어야 함

### BR-032-010: 감사추적유지 (Audit Trail Maintenance)
- **규칙명:** 시스템 감사추적 및 사용자 추적 규칙
- **설명:** 모든 데이터 접근 및 사용자 활동에 대한 포괄적인 감사추적을 유지
- **조건:** 데이터 접근이 발생할 때 감사추적을 위해 시스템 최종처리일시 및 시스템 최종사용자번호를 추적
- **관련 엔티티:** BE-032-004
- **예외사항:** 감사추적 정보는 모든 트랜잭션에 대해 적절히 유지되어야 함

## 4. 업무 기능

### F-032-001: 입력파라미터검증 (Input Parameter Validation)
- **기능명:** 입력파라미터검증 (Input Parameter Validation)
- **설명:** 처리를 위한 기업집단 신용평가 조회 입력 파라미터를 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 그룹회사코드 | String | 그룹회사 분류 식별자 |
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | String | 평가일자 (YYYYMMDD 형식) |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과상태 | Boolean | 검증의 성공 또는 실패 상태 |
| 오류코드 | Array | 검증 오류코드 목록 (있는 경우) |
| 검증된파라미터 | Object | 검증되고 형식화된 입력 파라미터 |

**처리 로직:**
1. 모든 필수 입력 필드가 제공되었는지 검증
2. 그룹회사코드가 공백이 아닌지 확인
3. 기업집단코드들이 공백이 아닌지 확인
4. 평가일자가 유효한 YYYYMMDD 형식인지 확인
5. 검증 실패 시 오류코드와 함께 검증 결과 반환

**적용된 업무 규칙:**
- BR-032-001: 그룹회사코드검증
- BR-032-002: 기업집단식별검증
- BR-032-003: 평가일자검증

### F-032-002: 평가완료상태조회 (Evaluation Completion Status Inquiry)
- **기능명:** 평가완료상태조회 (Evaluation Completion Status Inquiry)
- **설명:** 기업집단 신용평가 완료상태를 검색하고 결정

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 그룹회사코드 | String | 그룹회사 분류 식별자 |
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | String | 상태 조회를 위한 평가일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 완료상태 | String | 평가완료 상태 (Y/N) |
| 조정단계번호 | String | 등급조정 프로세스의 단계번호 |
| 주석내용 | String | 등급조정 의견 내용 |

**처리 로직:**
1. 기업집단평가기본정보에 대해 THKIPB110 테이블 조회
2. 기업집단처리단계구분 확인
3. 처리단계에 기반하여 완료상태 결정 ('5' 또는 '6' = 완료)
4. 완료된 평가에 대한 조정단계번호 검색
5. THKIPB130 테이블에서 등급조정 의견 주석 가져오기

**적용된 업무 규칙:**
- BR-032-004: 평가완료상태결정
- BR-032-005: 등급조정의견검색

### F-032-003: 신용평가요약데이터검색 (Credit Evaluation Summary Data Retrieval)
- **기능명:** 신용평가요약데이터검색 (Credit Evaluation Summary Data Retrieval)
- **설명:** 기업집단에 대한 포괄적인 신용평가 요약 데이터를 검색

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 그룹회사코드 | String | 그룹회사 분류 식별자 |
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | String | 데이터 검색을 위한 최대 평가일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 평가그리드데이터 | Array | 다년도 신용평가 레코드 |
| 총레코드수 | Numeric | 평가 레코드의 총 개수 |
| 현재레코드수 | Numeric | 평가 레코드의 현재 개수 |

**처리 로직:**
1. 다년도 평가 데이터를 검색하기 위한 SQL 쿼리 실행
2. 일자 범위 내에서 각 기준년도의 최대 평가일자 선택
3. 재무점수, 비재무점수, 결합점수 검색
4. 등급분류코드 (예비 및 최종) 추출
5. 표시를 위한 결과 데이터 형식화 및 구성

**적용된 업무 규칙:**
- BR-032-006: 다년도평가데이터검색
- BR-032-007: 점수검증
- BR-032-008: 등급분류검증

### F-032-004: 데이터무결성검증 (Data Integrity Verification)
- **기능명:** 데이터무결성검증 (Data Integrity Verification)
- **설명:** 기업집단 신용평가 테이블 간의 데이터 무결성 및 일관성을 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단정보 | Object | 그룹코드 및 평가 파라미터 |
| 검색된데이터 | Array | 데이터베이스에서 가져온 신용평가 데이터 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 무결성상태 | Boolean | 데이터 무결성 검증 결과 |
| 일관성보고서 | Object | 데이터 일관성 검증 보고서 |
| 감사정보 | Object | 시스템 감사추적 데이터 |

**처리 로직:**
1. THKIPB110과 THKIPB130 테이블 간의 참조 무결성 검증
2. 평가 레코드 간의 데이터 일관성 검증
3. 감사추적 정보 완전성 확인
4. 점수 및 등급 데이터 유효성 확인
5. 무결성 검증 보고서 생성

**적용된 업무 규칙:**
- BR-032-009: 데이터무결성관리
- BR-032-010: 감사추적유지

## 5. 프로세스 흐름

```
기업집단 신용평가 요약 조회 프로세스 흐름
├── 입력 파라미터 수신
│   ├── 그룹회사코드 입력
│   ├── 기업집단그룹코드 입력
│   ├── 기업집단등록코드 입력
│   └── 평가년월일 입력
├── 입력 파라미터 검증
│   ├── 필수 필드 검증
│   ├── 형식 검증 (YYYYMMDD)
│   ├── 업무 규칙 적용
│   └── 유효하지 않은 입력에 대한 오류 처리
├── 프레임워크 초기화
│   ├── 공통 영역 설정 (IJICOMM)
│   ├── 인터페이스 컴포넌트 설정 (XIJICOMM)
│   ├── 업무 컴포넌트 프레임워크 (YCCOMMON)
│   └── 출력 영역 할당 (XZUGOTMY)
├── 평가완료상태 조회
│   ├── 기업집단기본정보 검색 (THKIPB110)
│   ├── 처리단계구분 확인
│   ├── 완료상태 결정 (Y/N)
│   ├── 조정단계번호 추출
│   └── 등급조정 주석 검색 (THKIPB130)
├── 신용평가 요약 데이터 검색
│   ├── 다년도 평가 데이터 쿼리 (QIPA821)
│   ├── 기준년도별 최대 평가일자 선택
│   ├── 재무점수 추출
│   ├── 비재무점수 추출
│   ├── 결합점수 계산
│   ├── 등급분류코드 검색
│   └── 평가 레코드 수 결정
├── 데이터 처리 및 형식화
│   ├── 점수 검증 및 범위 확인
│   ├── 등급분류 검증
│   ├── 데이터 무결성 검증
│   ├── 그리드 데이터 구조 형성
│   └── 출력 파라미터 조립
├── 응답 생성
│   ├── 완료상태 출력
│   ├── 주석내용 출력
│   ├── 평가그리드 데이터 출력
│   ├── 레코드 수 정보 출력
│   └── 성공상태 반환
└── 트랜잭션 완료
    ├── 리소스 정리
    ├── 메모리 관리
    ├── 감사추적 기록
    └── 정상 종료 처리
```
## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIP4A82.cbl**: 기업집단 신용평가 요약 조회 처리를 위한 애플리케이션 서버 컴포넌트
- **DIPA821.cbl**: 신용평가 데이터베이스 운영 및 업무 로직을 위한 데이터 컴포넌트
- **QIPA821.cbl**: 다년도 쿼리 처리를 통한 신용평가 데이터 검색을 위한 SQL I/O 컴포넌트
- **RIPA110.cbl**: 기업집단평가기본정보 테이블 운영을 위한 데이터베이스 I/O 컴포넌트
- **RIPA130.cbl**: 기업집단주석명세 테이블 운영을 위한 데이터베이스 I/O 컴포넌트
- **IJICOMM.cbl**: 공통 영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **YCCOMMON.cpy**: 트랜잭션 관리 및 공통 처리를 위한 업무 컴포넌트 프레임워크
- **XIJICOMM.cpy**: 프레임워크 통신을 위한 인터페이스 컴포넌트 카피북
- **YCDBIOCA.cpy**: 데이터베이스 트랜잭션 관리를 위한 데이터베이스 I/O 공통 영역
- **YCDBSQLA.cpy**: SQL 실행 및 결과 처리를 위한 SQL I/O 공통 영역
- **YCCSICOM.cpy**: 프레임워크 서비스를 위한 서비스 인터페이스 컴포넌트
- **YCCBICOM.cpy**: 업무 로직 프레임워크를 위한 업무 인터페이스 컴포넌트
- **XZUGOTMY.cpy**: 출력 영역 할당 및 메모리 관리를 위한 프레임워크 컴포넌트
- **YNIP4A82.cpy**: 신용평가 조회 파라미터를 위한 입력 구조 정의
- **YPIP4A82.cpy**: 신용평가 조회 결과를 위한 출력 구조 정의
- **XDIPA821.cpy**: 신용평가 처리를 위한 데이터 컴포넌트 인터페이스
- **XQIPA821.cpy**: 신용평가 데이터 검색을 위한 SQL 쿼리 인터페이스
- **TRIPB110.cpy**: 기업집단평가기본정보를 위한 테이블 레코드 구조
- **TKIPB110.cpy**: 기업집단평가기본정보를 위한 테이블 키 구조
- **TRIPB130.cpy**: 기업집단주석명세를 위한 테이블 레코드 구조
- **TKIPB130.cpy**: 기업집단주석명세를 위한 테이블 키 구조

### 6.2 업무 규칙 구현
- **BR-032-001:** AIP4A82.cbl 170-173행에 구현 (S2000-VALIDATION-RTN - 그룹회사코드 검증)
  ```cobol
  IF YNIP4A82-GROUP-CO-CD = SPACE
      #ERROR   CO-B3600003  CO-UKFH0208  CO-STAT-ERROR
  END-IF
  ```

- **BR-032-002:** AIP4A82.cbl 175-183행에 구현 (S2000-VALIDATION-RTN - 기업집단 식별 검증)
  ```cobol
  IF YNIP4A82-CORP-CLCT-GROUP-CD = SPACE
      #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
  END-IF
  
  IF YNIP4A82-CORP-CLCT-REGI-CD = SPACE
      #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
  END-IF
  ```

- **BR-032-003:** AIP4A82.cbl 185-188행에 구현 (S2000-VALIDATION-RTN - 평가일자 검증)
  ```cobol
  IF YNIP4A82-VALUA-YMD = SPACE
      #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
  END-IF
  ```

- **BR-032-004:** DIPA821.cbl 270-290행에 구현 (S3100-RIPB110-PROC-RTN - 평가완료상태 결정)
  ```cobol
  IF  RIPB110-CORP-CP-STGE-DSTCD = '5'
  OR  RIPB110-CORP-CP-STGE-DSTCD = '6'
      MOVE  CO-Y TO  XDIPA821-O-FNSH-YN
      MOVE  RIPB110-ADJS-STGE-NO-DSTCD TO  XDIPA821-O-ADJS-STGE-NO-DSTCD
  ELSE
      MOVE  CO-N TO  XDIPA821-O-FNSH-YN
  END-IF
  ```

- **BR-032-006:** QIPA821.cbl 200-230행에 구현 (Z9900-OPEN-RTN - 다년도 평가 데이터 검색)
  ```cobol
  SELECT 등급조정구분, 평가년월일, 평가기준년월일, 재무점수, 비재무점수, 결합점수,
         예비집단등급구분, 최종집단등급구분
  FROM THKIPB110
  WHERE 그룹회사코드 = :XQIPA821-I-GROUP-CO-CD
    AND 기업집단그룹코드 = :XQIPA821-I-CORP-CLCT-GROUP-CD
    AND 기업집단등록코드 = :XQIPA821-I-CORP-CLCT-REGI-CD
    AND 평가년월일 IN (
        SELECT MAX(평가년월일) AS 평가년월일
        FROM THKIPB110 B110
        WHERE B110.평가년월일 <= :XQIPA821-I-VALUA-YMD
        GROUP BY 평가기준년월일
    )
  ORDER BY 평가기준년월일 DESC
  ```

### 6.3 기능 구현
- **F-032-001:** AIP4A82.cbl 160-200행에 구현 (S2000-VALIDATION-RTN - 입력 파라미터 검증)
  ```cobol
  S2000-VALIDATION-RTN.
      #USRLOG "◈입력값검증 시작◈"
      
      IF YNIP4A82-GROUP-CO-CD = SPACE
          #ERROR   CO-B3600003  CO-UKFH0208  CO-STAT-ERROR
      END-IF
      
      IF YNIP4A82-CORP-CLCT-GROUP-CD = SPACE
          #ERROR   CO-B3600552  CO-UKIP0001  CO-STAT-ERROR
      END-IF
      
      IF YNIP4A82-CORP-CLCT-REGI-CD = SPACE
          #ERROR   CO-B3600552  CO-UKII0282  CO-STAT-ERROR
      END-IF
      
      IF YNIP4A82-VALUA-YMD = SPACE
          #ERROR   CO-B2701130  CO-UKII0244  CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-032-002:** DIPA821.cbl 230-320행에 구현 (S3100-RIPB110-PROC-RTN - 평가완료상태 조회)
  ```cobol
  S3100-RIPB110-PROC-RTN.
      INITIALIZE YCDBIOCA-CA TRIPB110-REC TKIPB110-KEY
      
      MOVE BICOM-GROUP-CO-CD TO KIPB110-PK-GROUP-CO-CD
      MOVE XDIPA821-I-CORP-CLCT-GROUP-CD TO KIPB110-PK-CORP-CLCT-GROUP-CD
      MOVE XDIPA821-I-CORP-CLCT-REGI-CD TO KIPB110-PK-CORP-CLCT-REGI-CD
      MOVE XDIPA821-I-VALUA-YMD TO KIPB110-PK-VALUA-YMD
      
      #DYDBIO SELECT-CMD-N TKIPB110-PK TRIPB110-REC
      
      IF NOT COND-DBIO-OK
         #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
      END-IF
      
      IF  RIPB110-CORP-CP-STGE-DSTCD = '5' OR RIPB110-CORP-CP-STGE-DSTCD = '6'
          MOVE  CO-Y TO  XDIPA821-O-FNSH-YN
          MOVE  RIPB110-ADJS-STGE-NO-DSTCD TO  XDIPA821-O-ADJS-STGE-NO-DSTCD
          PERFORM S3110-RIPB130-PROC-RTN THRU S3110-RIPB130-PROC-EXT
      ELSE
          MOVE  CO-N TO  XDIPA821-O-FNSH-YN
      END-IF
  S3100-RIPB110-PROC-EXT.
  ```

- **F-032-003:** DIPA821.cbl 380-450행에 구현 (S3200-QIPA821-PROC-RTN - 신용평가 요약 데이터 검색)
  ```cobol
  S3200-QIPA821-PROC-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA821-IN
      
      MOVE  XDIPA821-IN TO  XQIPA821-IN
      
      #DYSQLA QIPA821 SELECT XQIPA821-CA
      
      EVALUATE TRUE
          WHEN COND-DBSQL-OK
               MOVE DBSQL-SELECT-CNT TO WK-QIPA821-CNT
          WHEN COND-DBSQL-MRNF
               #ERROR CO-B3900009 CO-UBNA0048 CO-STAT-ERROR
          WHEN OTHER
               #ERROR CO-B3900009 CO-UBNA0048 CO-STAT-ERROR
      END-EVALUATE
      
      MOVE  WK-QIPA821-CNT TO  XDIPA821-O-TOTAL-NOITM
      MOVE  WK-QIPA821-CNT TO  XDIPA821-O-PRSNT-NOITM
      
      PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > WK-QIPA821-CNT
          MOVE  XQIPA821-O-GRD-ADJS-DSTCD(WK-I) TO  XDIPA821-O-GRD-ADJS-DSTCD(WK-I)
          MOVE  XQIPA821-O-VALUA-YMD(WK-I) TO  XDIPA821-O-VALUA-YMD(WK-I)
          MOVE  XQIPA821-O-VALUA-BASE-YMD(WK-I) TO  XDIPA821-O-VALUA-BASE-YMD(WK-I)
          MOVE  XQIPA821-O-FNAF-SCOR(WK-I) TO  XDIPA821-O-FNAF-SCOR(WK-I)
          MOVE  XQIPA821-O-NON-FNAF-SCOR(WK-I) TO  XDIPA821-O-NON-FNAF-SCOR(WK-I)
          MOVE  XQIPA821-O-CHSN-SCOR(WK-I) TO  XDIPA821-O-CHSN-SCOR(WK-I)
          MOVE  XQIPA821-O-SPARE-C-GRD-DSTCD(WK-I) TO  XDIPA821-O-SPARE-C-GRD-DSTCD(WK-I)
          MOVE  XQIPA821-O-LAST-CLCT-GRD-DSTCD(WK-I) TO  XDIPA821-O-LAST-CLCT-GRD-DSTCD(WK-I)
      END-PERFORM
  S3200-QIPA821-PROC-EXT.
  ```

### 6.4 데이터베이스 테이블
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic Information) - 점수, 등급, 처리상태를 포함한 기업집단 신용평가 데이터의 마스터 테이블
- **THKIPB130**: 기업집단주석명세 (Corporate Group Comment Specification) - 등급조정 의견 주석 및 평가 노트를 포함하는 테이블

### 6.5 오류 코드

#### 6.5.1 입력 검증 오류
- **오류코드 B3600003**: 필수 필드 검증 오류
  - **설명**: 그룹회사 식별을 위한 필수 입력 필드 검증 실패
  - **원인**: 그룹회사코드가 누락, 공백, 또는 유효하지 않은 데이터 포함
  - **처리코드 UKFH0208**: 유효한 그룹회사코드를 입력하고 트랜잭션을 재시도

- **오류코드 B3600552**: 기업집단 검증 오류
  - **설명**: 기업집단 식별 필드 검증 실패
  - **원인**: 기업집단코드 또는 등록코드가 누락, 공백, 또는 유효하지 않은 데이터 포함
  - **처리코드**:
    - **UKIP0001**: 기업집단코드를 입력하고 트랜잭션을 재시도
    - **UKII0282**: 기업집단등록코드를 입력하고 트랜잭션을 재시도

- **오류코드 B2701130**: 평가일자 검증 오류
  - **설명**: 평가일자 형식 또는 값 검증 실패
  - **원인**: 유효하지 않은 일자 형식(YYYYMMDD이어야 함), 평가일자 누락, 또는 허용 범위를 벗어난 일자
  - **처리코드 UKII0244**: YYYYMMDD 형식의 유효한 평가일자를 입력하고 트랜잭션을 재시도

#### 6.5.2 시스템 및 데이터베이스 오류
- **오류코드 B3900009**: 데이터베이스 SQL 실행 오류
  - **설명**: SQL 쿼리 실행 및 데이터베이스 접근 실패
  - **원인**: 데이터베이스 연결 문제, SQL 구문 오류, 테이블 접근 문제, 또는 데이터 무결성 제약조건
  - **처리코드 UBNA0048**: 데이터베이스 연결 문제에 대해 시스템 관리자에게 연락

- **오류코드 B4200223**: 데이터베이스 I/O 처리 오류
  - **설명**: 테이블 접근 중 데이터베이스 I/O 운영 실패
  - **원인**: 테이블 접근 권한 문제, 데이터베이스 잠금 충돌, 또는 데이터 검색 문제
  - **처리코드 UKII0182**: 데이터베이스 I/O 처리 문제에 대해 시스템 관리자에게 연락

#### 6.5.3 업무 로직 오류
- **오류코드 B3900010**: 데이터 처리 오류
  - **설명**: 신용평가 조회 중 업무 로직 처리 실패
  - **원인**: 유효하지 않은 업무 규칙 적용, 데이터 일관성 위반, 또는 처리 로직 오류
  - **처리코드 UKII0292**: 업무 로직 처리 문제에 대해 시스템 관리자에게 연락

#### 6.5.4 데이터 무결성 오류
- **오류코드 B4200099**: 데이터 무결성 위반 오류
  - **설명**: 데이터베이스 참조 무결성 또는 제약조건 위반
  - **원인**: 외래키 제약조건 위반, 고유 제약조건 위반, 또는 데이터 일관성 문제
  - **처리코드 UKII0126**: 데이터 무결성 문제 해결을 위해 데이터 관리자에게 연락

- **오류코드 B4200224**: 트랜잭션 처리 오류
  - **설명**: 데이터베이스 운영 중 일반적인 트랜잭션 처리 실패
  - **원인**: 시스템 리소스 제약, 동시 접근 충돌, 또는 처리 시간 초과
  - **처리코드 UKII0185**: 잠시 후 트랜잭션을 재시도하거나 시스템 관리자에게 연락

#### 6.5.5 시스템 리소스 오류
- **오류코드 B3800124**: 시스템 리소스 오류
  - **설명**: 시스템 리소스 할당 또는 관리 실패
  - **원인**: 메모리 할당 문제, 시스템 용량 제약, 또는 리소스 경합
  - **처리코드 UKII0185**: 리소스 관리 문제에 대해 시스템 관리자에게 연락

### 6.6 기술 아키텍처
- **AS 계층**: AIP4A82 - 기업집단 신용평가 요약 조회 처리를 위한 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM - 공통 영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **DC 계층**: DIPA821 - 신용평가 데이터베이스 운영 및 업무 로직을 위한 데이터 컴포넌트
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리를 위한 업무 컴포넌트 프레임워크
- **SQLIO 계층**: QIPA821, YCDBSQLA - SQL 실행 및 신용평가 데이터 검색을 위한 데이터베이스 접근 컴포넌트
- **DBIO 계층**: RIPA110, RIPA130, YCDBIOCA - 테이블 운영 및 트랜잭션 관리를 위한 데이터베이스 I/O 컴포넌트
- **프레임워크**: XZUGOTMY - 출력 영역 할당 및 메모리 관리를 위한 프레임워크 컴포넌트
- **데이터베이스 계층**: 기업집단 신용평가 데이터를 위한 THKIPB110, THKIPB130 테이블을 포함한 DB2 데이터베이스

### 6.7 데이터 흐름 아키텍처
1. **입력 처리 흐름**: AIP4A82 → YNIP4A82 (입력 구조) → 파라미터 검증 → 처리 초기화
2. **프레임워크 설정 흐름**: AIP4A82 → IJICOMM → XIJICOMM → YCCOMMON → 공통 영역 초기화
3. **데이터베이스 접근 흐름**: AIP4A82 → DIPA821 → QIPA821 → YCDBSQLA → 데이터베이스 운영
4. **데이터베이스 I/O 흐름**: DIPA821 → RIPA110/RIPA130 → YCDBIOCA → THKIPB110/THKIPB130 테이블 운영
5. **서비스 통신 흐름**: AIP4A82 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스
6. **출력 처리 흐름**: 데이터베이스 결과 → XDIPA821 → YPIP4A82 (출력 구조) → AIP4A82
7. **오류 처리 흐름**: 모든 계층 → 프레임워크 오류 처리 → XZUGOTMY → 사용자 오류 메시지
8. **트랜잭션 흐름**: 요청 → 검증 → 데이터베이스 쿼리 → 결과 처리 → 응답 → 트랜잭션 완료
9. **메모리 관리 흐름**: XZUGOTMY → 출력 영역 할당 → 데이터 처리 → 메모리 정리 → 리소스 해제
