# 업무 명세서: 기업집단승인결의록조회 (Corporate Group Approval Resolution Inquiry)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-044
- **진입점:** AIP4A95
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용처리 도메인에서 포괄적인 온라인 기업집단 승인결의록 조회 시스템을 구현합니다. 이 시스템은 기업집단 승인위원회 결정, 위원 정보, 상세 승인의견에 대한 실시간 접근을 제공하여 기업집단 신용운영을 지원하는 신용평가 및 위험평가 프로세스를 지원합니다.

업무 목적은 다음과 같습니다:
- 신용결정 추적을 위한 기업집단 승인결의록 조회 및 표시 (Retrieve and display corporate group approval resolution records for credit decision tracking)
- 실시간 데이터 접근을 통한 포괄적 승인위원회 구성원 정보 및 투표 세부사항 제공 (Provide comprehensive approval committee member information and voting details with real-time data access)
- 구조화된 승인의견 조회 및 분석을 통한 신용위험 평가 지원 (Support credit risk assessment through structured approval opinion inquiry and analysis)
- 승인일자 및 위원회 결정을 포함한 기업집단 평가 데이터 무결성 유지 (Maintain corporate group evaluation data integrity including approval dates and committee decisions)
- 온라인 승인결의 관리를 위한 실시간 신용처리 데이터 접근 (Enable real-time credit processing data access for online approval resolution management)
- 기업집단 신용승인 운영의 감사추적 및 결정 일관성 제공 (Provide audit trail and decision consistency for corporate group credit approval operations)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIP4A95 → IJICOMM → YCCOMMON → XIJICOMM → DIPA951 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA953 → YCDBSQLA → XQIPA953 → QIPA951 → XQIPA951 → QIPA952 → XQIPA952 → XCJIBR01 → XCJIHR01 → TRIPB110 → TKIPB110 → TRIPB131 → TKIPB131 → TRIPB132 → TKIPB132 → TRIPB133 → TKIPB133 → XDIPA951 → XZUGOTMY → YNIP4A95 → YPIP4A95, 승인결의록 데이터 조회, 위원회 구성원 조회, 포괄적 승인의견 처리 작업을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 필수 필드 검증을 포함한 기업집단 승인결의록 데이터 검증 (Corporate group approval resolution data validation with mandatory field verification)
- 다단계 위원회 구성원 정보 조회 및 승인상태 추적 (Multi-level committee member information retrieval and approval status tracking)
- 구조화된 승인결의 데이터 접근을 통한 데이터베이스 무결성 관리 (Database integrity management through structured approval resolution data access)
- 포괄적 검증 규칙 및 내용 포맷팅을 적용한 승인의견 조회 (Approval opinion inquiry with comprehensive validation rules and content formatting)
- 다중 테이블 관계 처리를 포함한 기업집단 신용평가 데이터 관리 (Corporate group credit evaluation data management with multi-table relationship handling)
- 승인결정 일관성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for approval decision consistency)

## 2. 업무 엔티티

### BE-044-001: 기업집단승인결의록조회요청 (Corporate Group Approval Resolution Request)
- **설명:** 기업집단 승인결의록 조회 작업을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Classification Code) | String | 2 | NOT NULL | 처리 유형 분류 식별자 | YNIP4A95-PRCSS-DSTCD | prcssDstcd |
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | YNIP4A95-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIP4A95-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A95-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 승인결의를 위한 평가일자 | YNIP4A95-VALUA-YMD | valuaYmd |

- **검증 규칙:**
  - 처리구분코드는 필수이며 공백일 수 없음
  - 그룹회사코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함

### BE-044-002: 기업집단기본정보 (Corporate Group Basic Information)
- **설명:** 점수 및 등급을 포함한 기업집단 평가 기본 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단명 (Corporate Group Name) | String | 72 | NOT NULL | 기업집단명 | YPIP4A95-CORP-CLCT-NAME | corpClctName |
| 주채무계열여부 (Main Debt Affiliate Flag) | String | 1 | Y/N | 주채무계열 표시자 | YPIP4A95-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| 기업집단평가구분코드 (Corporate Group Evaluation Classification) | String | 1 | NOT NULL | 기업집단 평가 유형 | YPIP4A95-CORP-C-VALUA-DSTCD | corpCValuaDstcd |
| 평가확정년월일 (Evaluation Confirmation Date) | String | 8 | YYYYMMDD 형식 | 평가확정일자 | YPIP4A95-VALUA-DEFINS-YMD | valuaDefinsYmd |
| 평가기준년월일 (Evaluation Base Date) | String | 8 | YYYYMMDD 형식 | 평가기준일자 | YPIP4A95-VALUA-BASE-YMD | valuaBaseYmd |
| 기업집단처리단계구분코드 (Corporate Group Processing Stage Classification) | String | 1 | NOT NULL | 처리단계 분류 | YPIP4A95-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| 등급조정구분코드 (Grade Adjustment Classification) | String | 1 | NOT NULL | 등급조정 유형 | YPIP4A95-GRD-ADJS-DSTCD | grdAdjsDstcd |
| 조정단계번호구분코드 (Adjustment Stage Number Classification) | String | 2 | NOT NULL | 조정단계번호 유형 | YPIP4A95-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |
| 재무점수 (Financial Score) | Numeric | 7.2 | 부호있는 소수 | 재무평가 점수 | YPIP4A95-FNAF-SCOR | fnafScor |
| 비재무점수 (Non-Financial Score) | Numeric | 7.2 | 부호있는 소수 | 비재무평가 점수 | YPIP4A95-NON-FNAF-SCOR | nonFnafScor |
| 결합점수 (Combined Score) | Numeric | 9.5 | 부호있는 소수 | 결합평가 점수 | YPIP4A95-CHSN-SCOR | chsnScor |
| 예비집단등급구분코드 (Preliminary Group Grade Classification) | String | 3 | NOT NULL | 예비집단등급 | YPIP4A95-SPARE-C-GRD-DSTCD | spareCGrdDstcd |
| 신예비집단등급구분코드 (New Preliminary Group Grade Classification) | String | 3 | NOT NULL | 신예비집단등급 | YPIP4A95-NEW-SC-GRD-DSTCD | newScGrdDstcd |
| 최종집단등급구분코드 (Final Group Grade Classification) | String | 3 | NOT NULL | 최종집단등급 | YPIP4A95-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |
| 신최종집단등급구분코드 (New Final Group Grade Classification) | String | 3 | NOT NULL | 신최종집단등급 | YPIP4A95-NEW-LC-GRD-DSTCD | newLcGrdDstcd |
| 유효년월일 (Valid Date) | String | 8 | YYYYMMDD 형식 | 유효일자 | YPIP4A95-VALD-YMD | valdYmd |
| 평가직원번호 (Evaluation Employee ID) | String | 7 | NOT NULL | 평가직원 식별자 | YPIP4A95-VALUA-EMPID | valuaEmpid |
| 평가직원명 (Evaluation Employee Name) | String | 52 | NOT NULL | 평가직원명 | YPIP4A95-VALUA-EMNM | valuaEmnm |
| 평가부점코드 (Evaluation Branch Code) | String | 4 | NOT NULL | 평가부점코드 | YPIP4A95-VALUA-BRNCD | valuaBrncd |
| 관리부점코드 (Management Branch Code) | String | 4 | NOT NULL | 관리부점코드 | YPIP4A95-MGT-BRNCD | mgtBrncd |
| 시스템최종처리일시 (System Last Processing Date Time) | String | 20 | 타임스탬프 | 시스템 최종처리 타임스탬프 | YPIP4A95-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | Numeric | 7 | 부호없는 | 시스템 최종사용자번호 | YPIP4A95-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 기업집단명은 식별을 위해 필수
  - 주채무계열여부는 Y 또는 N이어야 함
  - 모든 일자 필드는 유효한 YYYYMMDD 형식이어야 함
  - 점수 필드는 유효한 부호있는 소수값이어야 함
  - 등급분류코드는 유효한 등급 식별자여야 함
  - 직원번호 및 이름은 평가추적을 위해 필수
  - 부점코드는 유효한 부점 식별자여야 함
### BE-044-003: 승인위원회요약정보 (Approval Committee Summary Information)
- **설명:** 승인위원회 구성 및 결정에 대한 요약 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수 (Total Count) | Numeric | 5 | 부호없는 | 승인 그리드의 총 레코드 수 | YPIP4A95-TOTAL-NOITM | totalNoitm |
| 현재건수 (Current Count) | Numeric | 5 | 부호없는 | 승인 그리드의 현재 레코드 수 | YPIP4A95-PRSNT-NOITM | prsntNoitm |
| 평가부점명 (Evaluation Branch Name) | String | 40 | NOT NULL | 평가부점명 | YPIP4A95-VALUA-BRN-NAME | valuaBrnName |
| 재적위원수 (Enrolled Committee Member Count) | Numeric | 5 | 부호있는 | 총 재적위원수 | YPIP4A95-ENRL-CMMB-CNT | enrlCmmbCnt |
| 출석위원수 (Attending Committee Member Count) | Numeric | 5 | 부호있는 | 출석위원수 | YPIP4A95-ATTND-CMMB-CNT | attndCmmbCnt |
| 승인위원수 (Approval Committee Member Count) | Numeric | 5 | 부호있는 | 승인위원수 | YPIP4A95-ATHOR-CMMB-CNT | athorCmmbCnt |
| 불승인위원수 (Non-Approval Committee Member Count) | Numeric | 5 | 부호있는 | 불승인위원수 | YPIP4A95-NOT-ATHOR-CMMB-CNT | notAthorCmmbCnt |
| 합의구분코드 (Agreement Classification) | String | 1 | NOT NULL | 합의구분 | YPIP4A95-MTAG-DSTCD | mtagDstcd |
| 종합승인구분코드 (Comprehensive Approval Classification) | String | 1 | NOT NULL | 종합승인구분 | YPIP4A95-CMPRE-ATHOR-DSTCD | cmpreAthorDstcd |
| 종전등급 (Previous Grade) | String | 3 | NOT NULL | 종전등급 | YPIP4A95-PREV-GRD | prevGrd |
| 승인부점명 (Approval Branch Name) | String | 40 | NOT NULL | 승인부점명 | YPIP4A95-ATHOR-BRN-NAME | athorBrnName |
| 승인년월일 (Approval Date) | String | 8 | YYYYMMDD 형식 | 승인일자 | YPIP4A95-ATHOR-YMD | athorYmd |
| 구등급매핑등급구분코드 (Old Grade Mapping Grade Classification) | String | 3 | NOT NULL | 구등급매핑분류 | YPIP4A95-OL-GM-GRD-DSTCD | olGmGrdDstcd |

- **검증 규칙:**
  - 총건수 및 현재건수는 음이 아닌 숫자값이어야 함
  - 위원회 구성원수는 유효한 부호있는 숫자값이어야 함
  - 부점명은 식별을 위해 필수
  - 합의 및 승인구분은 유효한 코드여야 함
  - 승인일자는 유효한 YYYYMMDD 형식이어야 함
  - 등급코드는 유효한 등급 식별자여야 함

### BE-044-004: 위원명세정보 (Committee Member Detail Information)
- **설명:** 개별 위원회 구성원 및 승인결정에 대한 상세 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 승인위원구분코드 (Approval Committee Member Classification) | String | 1 | NOT NULL | 위원회 구성원 유형 분류 | YPIP4A95-ATHOR-CMMB-DSTCD | athorCmmbDstcd |
| 승인위원직원번호 (Approval Committee Member Employee ID) | String | 7 | NOT NULL | 위원회 구성원 직원 식별자 | YPIP4A95-ATHOR-CMMB-EMPID | athorCmmbEmpid |
| 승인위원직원명 (Approval Committee Member Employee Name) | String | 52 | NOT NULL | 위원회 구성원 직원명 | YPIP4A95-ATHOR-CMMB-EMNM | athorCmmbEmnm |
| 승인구분코드 (Approval Classification) | String | 1 | NOT NULL | 승인결정 분류 | YPIP4A95-ATHOR-DSTCD | athorDstcd |
| 승인의견내용 (Approval Opinion Content) | String | 1002 | NOT NULL | 상세 승인의견 내용 | YPIP4A95-ATHOR-OPIN-CTNT | athorOpinCtnt |
| 일련번호 (Serial Number) | Numeric | 4 | 부호있는 | 의견 일련번호 | YPIP4A95-SERNO | serno |

- **검증 규칙:**
  - 위원회구성원구분은 구성원 분류를 위해 필수
  - 직원번호 및 이름은 구성원 식별을 위해 필수
  - 승인구분은 결정추적을 위해 필수
  - 승인의견내용은 필수이며 유효한 의견 텍스트를 포함해야 함
  - 일련번호는 순서를 위한 유효한 부호있는 숫자값이어야 함
  - 의견내용은 최대 길이 제한을 초과하지 않아야 함

## 3. 업무 규칙

### BR-044-001: 처리구분검증 (Processing Classification Validation)
- **규칙명:** 처리구분코드 검증 규칙
- **설명:** 처리구분코드가 제공되었는지 검증하고 승인결의록 조회를 위한 적절한 처리 경로를 결정
- **조건:** 처리구분코드가 제공되면 코드를 검증하고 적절한 조회 처리를 위해 공백이 아님을 보장
- **관련 엔티티:** BE-044-001
- **예외:** 처리구분코드는 공백이거나 유효하지 않을 수 없음

### BR-044-002: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단코드 및 등록코드 검증 규칙
- **설명:** 승인결의록 조회에서 적절한 기업집단 식별을 위해 기업집단코드와 등록코드가 모두 제공되었는지 검증
- **조건:** 기업집단 승인결의록 조회가 요청되면 그룹코드와 등록코드가 모두 제공되고 유효해야 함
- **관련 엔티티:** BE-044-001
- **예외:** 기업집단코드 또는 등록코드 중 하나라도 공백일 수 없음

### BR-044-003: 평가일자검증 (Evaluation Date Validation)
- **규칙명:** 평가일자 형식 검증 규칙
- **설명:** 승인결의 처리를 위해 평가일자가 올바른 형식으로 제공되었는지 검증
- **조건:** 승인결의록 조회가 요청되면 평가일자는 유효한 YYYYMMDD 형식이어야 함
- **관련 엔티티:** BE-044-001, BE-044-002
- **예외:** 일자 필드는 공백이거나 유효하지 않은 형식일 수 없음

### BR-044-004: 위원회구성원수검증 (Committee Member Count Validation)
- **규칙명:** 위원회 구성원수 일관성 검증 규칙
- **설명:** 승인결정 처리를 위해 위원회 구성원수가 일관되고 논리적인지 검증
- **조건:** 위원회 정보가 처리되면 재적수는 출석수보다 크거나 같아야 하고, 승인수와 불승인수의 합은 출석수와 같아야 함
- **관련 엔티티:** BE-044-003
- **예외:** 위원회 구성원수는 논리적으로 일관되어야 함

### BR-044-005: 승인결정분류 (Approval Decision Classification)
- **규칙명:** 승인결정 분류 규칙
- **설명:** 적절한 결정추적을 위해 승인결정을 승인, 불승인, 또는 기권 범주로 분류
- **조건:** 승인결정이 처리되면 각 구성원 결정을 분류하고 요약 승인상태를 계산
- **관련 엔티티:** BE-044-003, BE-044-004
- **예외:** 승인분류는 유효한 결정코드여야 함

### BR-044-006: 레코드수제한 (Record Count Limitation)
- **규칙명:** 그리드 레코드수 제한 규칙
- **설명:** 성능 최적화를 위해 그리드 표시에서 반환되는 레코드 수를 최대 100개로 제한
- **조건:** 쿼리 결과가 100개 레코드를 초과하면 참조용 총건수를 유지하면서 현재건수를 100으로 제한
- **관련 엔티티:** BE-044-003
- **예외:** 현재건수는 그리드당 100개 레코드를 초과할 수 없음

### BR-044-007: 의견내용검증 (Opinion Content Validation)
- **규칙명:** 승인의견 내용 검증 규칙
- **설명:** 승인의견 내용이 제공되고 표시를 위해 적절히 형식화되었는지 검증
- **조건:** 승인의견이 조회되면 내용이 공백이 아니고 길이 제한 내에 있는지 검증
- **관련 엔티티:** BE-044-004
- **예외:** 의견내용은 제공되어야 하고 최대 길이 내에 있어야 함

### BR-044-008: 등급분류일관성 (Grade Classification Consistency)
- **규칙명:** 등급분류 일관성 규칙
- **설명:** 예비 및 최종 등급분류가 평가결과와 일관되는지 보장
- **조건:** 등급정보가 처리되면 등급분류가 점수 및 평가기준과 일관되는지 검증
- **관련 엔티티:** BE-044-002
- **예외:** 등급분류는 평가데이터와 일관되어야 함

## 4. 업무 기능

### F-044-001: 입력파라미터검증 (Input Parameter Validation)
- **기능명:** 입력파라미터검증 (Input Parameter Validation)
- **설명:** 처리를 위한 기업집단 승인결의록 입력 파라미터 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리구분코드 | String | 처리 유형 식별자 |
| 그룹회사코드 | String | 그룹회사 분류 식별자 |
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | Date | 평가년월일 (YYYYMMDD 형식) |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과상태 | Boolean | 검증의 성공 또는 실패 상태 |
| 오류코드 | Array | 검증 오류코드 목록 (있는 경우) |
| 검증된파라미터 | Object | 검증되고 형식화된 입력 파라미터 |

**처리 로직:**
1. 모든 필수 입력 필드가 제공되었는지 검증
2. 일자 필드가 올바른 YYYYMMDD 형식인지 확인
3. 처리구분코드가 공백이 아닌지 확인
4. 기업집단코드가 공백이 아닌지 검증
5. 검증이 실패하면 오류코드와 함께 검증결과 반환

**적용된 업무 규칙:**
- BR-044-001: 처리구분검증
- BR-044-002: 기업집단식별검증
- BR-044-003: 평가일자검증

### F-044-002: 기업집단기본데이터조회 (Corporate Group Basic Data Retrieval)
- **기능명:** 기업집단기본데이터조회 (Corporate Group Basic Data Retrieval)
- **설명:** 표시를 위한 기업집단 기본 평가정보 조회 및 처리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 그룹회사코드 | String | 그룹회사 분류 식별자 |
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | Date | 데이터 조회를 위한 평가일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단기본정보 | Object | 완전한 기본 평가데이터 |
| 등급정보 | Object | 등급분류 및 점수 |
| 직원정보 | Object | 평가직원 세부사항 |

**처리 로직:**
1. THKIPB110 테이블에서 기업집단 기본데이터 조회
2. 표시를 위한 등급분류 및 점수 형식화
3. 직원 및 부점정보 조회
4. 데이터 일관성 및 완전성 검증
5. 구조화된 기본정보 데이터 반환

**적용된 업무 규칙:**
- BR-044-008: 등급분류일관성
- BR-044-003: 일자형식검증

### F-044-003: 승인위원회정보조회 (Approval Committee Information Inquiry)
- **기능명:** 승인위원회정보조회 (Approval Committee Information Inquiry)
- **설명:** 승인위원회 요약정보 및 구성원수 조회 및 형식화

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 그룹회사코드 | String | 그룹회사 분류 식별자 |
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | Date | 위원회 조회를 위한 평가일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 위원회요약정보 | Object | 위원회 구성 및 결정 요약 |
| 구성원수정보 | Object | 상세 구성원수 분석 |
| 승인상태 | Object | 전체 승인결정 상태 |

**처리 로직:**
1. THKIPB131 테이블에서 위원회 요약데이터 조회
2. 구성원수 일관성 계산 및 검증
3. 구성원 결정에 기반한 전체 승인상태 결정
4. 표시를 위한 위원회정보 형식화
5. 구조화된 위원회 요약데이터 반환

**적용된 업무 규칙:**
- BR-044-004: 위원회구성원수검증
- BR-044-005: 승인결정분류

### F-044-004: 위원명세조회 (Committee Member Detail Inquiry)
- **기능명:** 위원명세조회 (Committee Member Detail Inquiry)
- **설명:** 개별 위원회 구성원 및 결정에 대한 상세정보 조회

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 그룹회사코드 | String | 그룹회사 분류 식별자 |
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | Date | 구성원 조회를 위한 평가일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 위원회구성원그리드데이터 | Array | 상세 구성원정보 및 결정 |
| 구성원수 | Numeric | 조회된 위원회 구성원 수 |
| 결정요약 | Object | 구성원 결정 요약 |

**처리 로직:**
1. THKIPB132 테이블에서 위원회 구성원데이터 조회
2. XCJIHR01 인터페이스를 사용하여 직원정보 조회
3. 그리드 표시를 위한 구성원정보 형식화
4. 성능을 위한 레코드수 제한 적용
5. 구조화된 구성원 상세데이터 반환

**적용된 업무 규칙:**
- BR-044-006: 레코드수제한
- BR-044-005: 승인결정분류

### F-044-005: 승인의견조회 (Approval Opinion Inquiry)
- **기능명:** 승인의견조회 (Approval Opinion Inquiry)
- **설명:** 위원회 구성원의 상세 승인의견 및 코멘트 조회 및 형식화

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 그룹회사코드 | String | 그룹회사 분류 식별자 |
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가년월일 | Date | 의견 조회를 위한 평가일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 승인의견그리드데이터 | Array | 구성원별 상세 승인의견 |
| 의견수 | Numeric | 조회된 의견 수 |
| 의견요약 | Object | 의견내용 요약 |

**처리 로직:**
1. THKIPB133 테이블에서 승인의견 조회
2. 표시를 위한 의견내용 형식화
3. 일련번호 및 구성원별 의견 정렬
4. 의견내용 완전성 검증
5. 구조화된 의견데이터 반환

**적용된 업무 규칙:**
- BR-044-007: 의견내용검증
- BR-044-006: 레코드수제한

### F-044-006: 결과데이터포맷팅 (Result Data Formatting)
- **기능명:** 결과데이터포맷팅 (Result Data Formatting)
- **설명:** 표시를 위한 승인결의 결과데이터 형식화 및 구조화

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 원시기본데이터 | Object | 형식화되지 않은 기본 평가데이터 |
| 원시위원회데이터 | Array | 형식화되지 않은 위원회정보 |
| 원시의견데이터 | Array | 형식화되지 않은 의견정보 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 형식화된결과그리드 | Array | 표시 준비된 구조화 데이터 |
| 요약정보 | Object | 집계된 요약데이터 |
| 표시메타데이터 | Object | 형식화 및 표시 제어정보 |

**처리 로직:**
1. 기본 평가데이터에 형식화 규칙 적용
2. 그리드 표시를 위한 위원회 구성원정보 구조화
3. 표시를 위한 승인의견 형식화
4. 요약 및 집계정보 생성
5. 완전한 형식화된 결과세트 반환

**적용된 업무 규칙:**
- BR-044-006: 레코드수제한
- BR-044-007: 의견내용검증

## 5. 프로세스 흐름

### 기업집단승인결의록조회 프로세스 흐름
```
AIP4A95 (AS기업집단승인결의록조회)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── 출력영역 할당 (#GETOUT YPIP4A95-CA)
│   ├── 공통영역 설정 (JICOM 파라미터)
│   └── IJICOMM 프레임워크 초기화
│       └── XIJICOMM 공통 인터페이스 설정
│           └── YCCOMMON 프레임워크 처리
├── S2000-VALIDATION-RTN (입력값검증)
│   ├── 처리구분코드 검증
│   ├── 그룹회사코드 검증
│   ├── 기업집단그룹코드 검증
│   ├── 기업집단등록코드 검증
│   └── 평가년월일 검증
├── S3000-PROCESS-RTN (업무처리)
│   └── DIPA951 데이터베이스 컴포넌트 호출
│       ├── S1000-INITIALIZE-RTN (DC초기화)
│       ├── S2000-VALIDATION-RTN (DC입력값검증)
│       └── S3000-PROCESS-RTN (DC업무처리)
│           ├── RIPA110 기업집단 기본데이터 조회
│           │   ├── YCDBIOCA 데이터베이스 I/O 처리
│           │   ├── YCCSICOM 서비스 인터페이스 통신
│           │   └── YCCBICOM 비즈니스 인터페이스 통신
│           ├── QIPA953 승인위원회 요약 쿼리
│           │   ├── YCDBSQLA 데이터베이스 접근
│           │   └── XQIPA953 위원회 요약 쿼리 인터페이스
│           │       └── THKIPB131 (기업집단승인결의록명세) 접근
│           ├── QIPA951 위원회 구성원 상세 쿼리
│           │   ├── YCDBSQLA 데이터베이스 접근
│           │   └── XQIPA951 구성원 상세 쿼리 인터페이스
│           │       └── THKIPB132 (기업집단승인결의록위원명세) 접근
│           ├── QIPA952 승인의견 쿼리
│           │   ├── YCDBSQLA 데이터베이스 접근
│           │   └── XQIPA952 의견 쿼리 인터페이스
│           │       └── THKIPB133 (기업집단승인결의록의견명세) 접근
│           ├── XCJIBR01 부점정보 조회
│           │   └── 부점 마스터데이터 조회
│           └── XCJIHR01 직원정보 조회
│               └── 직원 마스터데이터 조회
├── 결과데이터 조립
│   ├── TRIPB110 기업집단 기본데이터 처리
│   │   └── TKIPB110 기본데이터 키 처리
│   ├── TRIPB131 위원회 요약데이터 처리
│   │   └── TKIPB131 요약 키 처리
│   ├── TRIPB132 구성원 상세데이터 처리
│   │   └── TKIPB132 구성원 키 처리
│   ├── TRIPB133 의견데이터 처리
│   │   └── TKIPB133 의견 키 처리
│   ├── XDIPA951 출력 파라미터 처리
│   └── XZUGOTMY 메모리 관리
└── S9000-FINAL-RTN (처리종료)
    ├── YNIP4A95 입력 구조 처리
    ├── YPIP4A95 출력 구조 조립
    │   ├── 기업집단 기본정보
    │   ├── 위원회 요약정보
    │   └── Grid1 위원회 구성원 및 의견데이터
    │       ├── 구성원 분류 및 세부사항
    │       ├── 승인결정 정보
    │       └── 의견내용 및 일련번호
    └── 트랜잭션 완료 처리
```
## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIP4A95.cbl**: 기업집단 승인결의록 조회 처리를 위한 메인 애플리케이션 서버 컴포넌트
- **DIPA951.cbl**: 승인결의 데이터베이스 작업 및 비즈니스 로직 처리를 위한 데이터 컴포넌트
- **RIPA110.cbl**: 기업집단 기본데이터 조회 및 처리를 위한 데이터베이스 컴포넌트
- **QIPA953.cbl**: THKIPB131 테이블에서 승인위원회 요약데이터 조회를 위한 SQL 컴포넌트
- **QIPA951.cbl**: THKIPB132 테이블에서 위원회 구성원 상세데이터 조회를 위한 SQL 컴포넌트
- **QIPA952.cbl**: THKIPB133 테이블에서 승인의견 데이터 조회를 위한 SQL 컴포넌트
- **IJICOMM.cbl**: 공통영역 설정 및 프레임워크 초기화 처리를 위한 인터페이스 컴포넌트
- **YCCOMMON.cpy**: 트랜잭션 처리 및 오류 처리를 위한 공통 프레임워크 카피북
- **XIJICOMM.cpy**: 공통영역 파라미터 정의 및 설정을 위한 인터페이스 카피북
- **YCDBSQLA.cpy**: SQL 실행 및 결과 처리를 위한 데이터베이스 SQL 접근 카피북
- **YCDBIOCA.cpy**: 데이터베이스 연결 및 트랜잭션 관리를 위한 데이터베이스 I/O 카피북
- **YCCSICOM.cpy**: 프레임워크 서비스를 위한 서비스 인터페이스 통신 카피북
- **YCCBICOM.cpy**: 비즈니스 로직 처리를 위한 비즈니스 인터페이스 통신 카피북
- **XZUGOTMY.cpy**: 출력영역 할당 및 메모리 관리를 위한 프레임워크 카피북
- **YNIP4A95.cpy**: 승인결의록 조회를 위한 요청 파라미터를 정의하는 입력 구조 카피북
- **YPIP4A95.cpy**: 승인결의록 그리드를 포함한 응답 데이터를 정의하는 출력 구조 카피북
- **XDIPA951.cpy**: 입력/출력 파라미터 정의를 위한 데이터 컴포넌트 인터페이스 카피북
- **XQIPA953.cpy**: 위원회 요약 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA951.cpy**: 구성원 상세 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XQIPA952.cpy**: 의견 쿼리 파라미터를 위한 SQL 인터페이스 카피북
- **XCJIBR01.cpy**: 부점 마스터데이터 접근을 위한 부점정보 조회 카피북
- **XCJIHR01.cpy**: 직원 마스터데이터 접근을 위한 직원정보 조회 카피북
- **TRIPB110.cpy**: THKIPB110 접근을 위한 기업집단 기본 테이블 구조 카피북
- **TKIPB110.cpy**: THKIPB110 키 처리를 위한 기업집단 기본 테이블 키 카피북
- **TRIPB131.cpy**: THKIPB131 접근을 위한 위원회 요약 테이블 구조 카피북
- **TKIPB131.cpy**: THKIPB131 키 처리를 위한 위원회 요약 테이블 키 카피북
- **TRIPB132.cpy**: THKIPB132 접근을 위한 구성원 상세 테이블 구조 카피북
- **TKIPB132.cpy**: THKIPB132 키 처리를 위한 구성원 상세 테이블 키 카피북
- **TRIPB133.cpy**: THKIPB133 접근을 위한 의견 테이블 구조 카피북
- **TKIPB133.cpy**: THKIPB133 키 처리를 위한 의견 테이블 키 카피북

### 6.2 업무 규칙 구현
- **BR-044-001:** AIP4A95.cbl 170-175행에 구현 (S2000-VALIDATION-RTN - 처리구분 검증)
  ```cobol
  IF YNIP4A95-PRCSS-DSTCD = SPACE
     #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```

- **BR-044-002:** AIP4A95.cbl 180-200행에 구현 (S2000-VALIDATION-RTN - 기업집단 식별 검증)
  ```cobol
  IF YNIP4A95-GROUP-CO-CD = SPACE
     #ERROR CO-B3800001 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  
  IF YNIP4A95-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800002 CO-UKIP0002 CO-STAT-ERROR
  END-IF
  
  IF YNIP4A95-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800003 CO-UKIP0003 CO-STAT-ERROR
  END-IF
  ```

- **BR-044-003:** AIP4A95.cbl 205-215행에 구현 (S2000-VALIDATION-RTN - 평가일자 검증)
  ```cobol
  IF YNIP4A95-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIP0004 CO-STAT-ERROR
  END-IF
  ```

- **BR-044-004:** DIPA951.cbl 350-380행에 구현 (위원회 구성원수 검증)
  ```cobol
  IF XDIPA951-O-ENRL-CMMB-CNT < XDIPA951-O-ATTND-CMMB-CNT
     #ERROR CO-B3100001 CO-UKIP0010 CO-STAT-ERROR
  END-IF
  
  COMPUTE WK-TOTAL-DECISION = XDIPA951-O-ATHOR-CMMB-CNT + XDIPA951-O-NOT-ATHOR-CMMB-CNT
  IF WK-TOTAL-DECISION NOT = XDIPA951-O-ATTND-CMMB-CNT
     #ERROR CO-B3100002 CO-UKIP0011 CO-STAT-ERROR
  END-IF
  ```

- **BR-044-005:** QIPA951.cbl 280-320행에 구현 (승인결정 분류)
  ```cobol
  EVALUATE XQIPA951-O-ATHOR-DSTCD(WK-I)
      WHEN '1'
           ADD 1 TO WK-APPROVAL-COUNT
      WHEN '2'
           ADD 1 TO WK-NON-APPROVAL-COUNT
      WHEN '3'
           ADD 1 TO WK-ABSTAIN-COUNT
  END-EVALUATE
  ```

- **BR-044-006:** DIPA951.cbl 420-435행에 구현 (레코드수 제한)
  ```cobol
  IF DBSQL-SELECT-CNT > CO-NUM-100 THEN
     MOVE CO-NUM-100 TO XDIPA951-O-PRSNT-NOITM
  ELSE
     MOVE DBSQL-SELECT-CNT TO XDIPA951-O-PRSNT-NOITM
  END-IF
  ```

- **BR-044-007:** QIPA952.cbl 250-270행에 구현 (의견내용 검증)
  ```cobol
  IF XQIPA952-O-ATHOR-OPIN-CTNT(WK-I) = SPACE
     #ERROR CO-B3200001 CO-UKIP0012 CO-STAT-ERROR
  END-IF
  
  IF LENGTH OF XQIPA952-O-ATHOR-OPIN-CTNT(WK-I) > CO-NUM-1002
     #ERROR CO-B3200002 CO-UKIP0013 CO-STAT-ERROR
  END-IF
  ```

- **BR-044-008:** RIPA110.cbl 300-330행에 구현 (등급분류 일관성)
  ```cobol
  IF XRIPA110-O-SPARE-C-GRD-DSTCD NOT = XRIPA110-O-LAST-CLCT-GRD-DSTCD
     IF XRIPA110-O-GRD-ADJS-DSTCD = SPACE
        #ERROR CO-B3300001 CO-UKIP0014 CO-STAT-ERROR
     END-IF
  END-IF
  ```

### 6.3 기능 구현
- **F-044-001:** AIP4A95.cbl 160-220행에 구현 (S2000-VALIDATION-RTN - 입력파라미터 검증)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIP4A95-PRCSS-DSTCD = SPACE
         #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
      END-IF
      
      IF YNIP4A95-GROUP-CO-CD = SPACE
         #ERROR CO-B3800001 CO-UKIP0001 CO-STAT-ERROR
      END-IF
      
      IF YNIP4A95-CORP-CLCT-GROUP-CD = SPACE
         #ERROR CO-B3800002 CO-UKIP0002 CO-STAT-ERROR
      END-IF
      
      IF YNIP4A95-CORP-CLCT-REGI-CD = SPACE
         #ERROR CO-B3800003 CO-UKIP0003 CO-STAT-ERROR
      END-IF
      
      IF YNIP4A95-VALUA-YMD = SPACE
         #ERROR CO-B3800004 CO-UKIP0004 CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-044-002:** DIPA951.cbl 240-320행에 구현 (기업집단 기본데이터 조회)
  ```cobol
  S3100-RIPA110-CALL-RTN.
      INITIALIZE YCDBIOCA-CA XRIPA110-IN
      
      MOVE BICOM-GROUP-CO-CD TO XRIPA110-I-GROUP-CO-CD
      MOVE XDIPA951-I-CORP-CLCT-GROUP-CD TO XRIPA110-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA951-I-CORP-CLCT-REGI-CD TO XRIPA110-I-CORP-CLCT-REGI-CD
      MOVE XDIPA951-I-VALUA-YMD TO XRIPA110-I-VALUA-YMD
      
      #DYCALL RIPA110 YCCOMMON-CA XRIPA110-CA
      
      IF COND-XRIPA110-OK
         MOVE XRIPA110-OUT TO XDIPA951-O-BASIC-INFO
      ELSE
         #ERROR XRIPA110-R-ERRCD XRIPA110-R-TREAT-CD XRIPA110-R-STAT
      END-IF
  S3100-RIPA110-CALL-EXT.
  ```

- **F-044-003:** DIPA951.cbl 330-400행에 구현 (승인위원회정보 조회)
  ```cobol
  S3200-QIPA953-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA953-IN
      
      MOVE BICOM-GROUP-CO-CD TO XQIPA953-I-GROUP-CO-CD
      MOVE XDIPA951-I-CORP-CLCT-GROUP-CD TO XQIPA953-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA951-I-CORP-CLCT-REGI-CD TO XQIPA953-I-CORP-CLCT-REGI-CD
      MOVE XDIPA951-I-VALUA-YMD TO XQIPA953-I-VALUA-YMD
      
      #DYSQLA QIPA953 SELECT XQIPA953-CA
      
      IF COND-YCDBSQLA-OK
         MOVE XQIPA953-O-ENRL-CMMB-CNT TO XDIPA951-O-ENRL-CMMB-CNT
         MOVE XQIPA953-O-ATTND-CMMB-CNT TO XDIPA951-O-ATTND-CMMB-CNT
         MOVE XQIPA953-O-ATHOR-CMMB-CNT TO XDIPA951-O-ATHOR-CMMB-CNT
         MOVE XQIPA953-O-NOT-ATHOR-CMMB-CNT TO XDIPA951-O-NOT-ATHOR-CMMB-CNT
         MOVE XQIPA953-O-MTAG-DSTCD TO XDIPA951-O-MTAG-DSTCD
         MOVE XQIPA953-O-CMPRE-ATHOR-DSTCD TO XDIPA951-O-CMPRE-ATHOR-DSTCD
         MOVE XQIPA953-O-ATHOR-YMD TO XDIPA951-O-ATHOR-YMD
         MOVE XQIPA953-O-ATHOR-BRNCD TO XDIPA951-O-ATHOR-BRNCD
      ELSE
         #ERROR YCDBSQLA-R-ERRCD YCDBSQLA-R-TREAT-CD YCDBSQLA-R-STAT
      END-IF
  S3200-QIPA953-CALL-EXT.
  ```

- **F-044-004:** DIPA951.cbl 410-480행에 구현 (위원회 구성원 상세 조회)
  ```cobol
  S3300-QIPA951-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA951-IN
      
      MOVE BICOM-GROUP-CO-CD TO XQIPA951-I-GROUP-CO-CD
      MOVE XDIPA951-I-CORP-CLCT-GROUP-CD TO XQIPA951-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA951-I-CORP-CLCT-REGI-CD TO XQIPA951-I-CORP-CLCT-REGI-CD
      MOVE XDIPA951-I-VALUA-YMD TO XQIPA951-I-VALUA-YMD
      
      #DYSQLA QIPA951 SELECT XQIPA951-CA
      
      MOVE DBSQL-SELECT-CNT TO XDIPA951-O-TOTAL-NOITM
      
      PERFORM VARYING WK-I FROM 1 BY 1
                UNTIL WK-I > XDIPA951-O-PRSNT-NOITM
          MOVE XQIPA951-O-ATHOR-CMMB-DSTCD(WK-I) TO XDIPA951-O-ATHOR-CMMB-DSTCD(WK-I)
          MOVE XQIPA951-O-ATHOR-CMMB-EMPID(WK-I) TO XDIPA951-O-ATHOR-CMMB-EMPID(WK-I)
          MOVE XQIPA951-O-ATHOR-DSTCD(WK-I) TO XDIPA951-O-ATHOR-DSTCD(WK-I)
          
          PERFORM S3310-XCJIHR01-CALL-RTN THRU S3310-XCJIHR01-CALL-EXT
          
          MOVE XCJIHR01-O-EMP-HANGL-FNAME TO XDIPA951-O-ATHOR-CMMB-EMNM(WK-I)
      END-PERFORM
  S3300-QIPA951-CALL-EXT.
  ```

- **F-044-005:** DIPA951.cbl 490-560행에 구현 (승인의견 조회)
  ```cobol
  S3400-QIPA952-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA952-IN
      
      MOVE BICOM-GROUP-CO-CD TO XQIPA952-I-GROUP-CO-CD
      MOVE XDIPA951-I-CORP-CLCT-GROUP-CD TO XQIPA952-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA951-I-CORP-CLCT-REGI-CD TO XQIPA952-I-CORP-CLCT-REGI-CD
      MOVE XDIPA951-I-VALUA-YMD TO XQIPA952-I-VALUA-YMD
      
      #DYSQLA QIPA952 SELECT XQIPA952-CA
      
      PERFORM VARYING WK-I FROM 1 BY 1
                UNTIL WK-I > XDIPA951-O-PRSNT-NOITM
          MOVE XQIPA952-O-ATHOR-OPIN-CTNT(WK-I) TO XDIPA951-O-ATHOR-OPIN-CTNT(WK-I)
          MOVE XQIPA952-O-SERNO(WK-I) TO XDIPA951-O-SERNO(WK-I)
      END-PERFORM
  S3400-QIPA952-CALL-EXT.
  ```

### 6.4 데이터베이스 테이블
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - 점수, 등급, 평가세부사항을 포함한 기업집단 평가 기본정보를 저장하는 주요 테이블
- **THKIPB131**: 기업집단승인결의록명세 (Corporate Group Approval Resolution Details) - 구성원수 및 전체 승인결정을 포함한 승인위원회 요약정보를 포함하는 테이블
- **THKIPB132**: 기업집단승인결의록위원명세 (Corporate Group Approval Committee Member Details) - 개별 위원회 구성원정보 및 승인결정을 저장하는 테이블
- **THKIPB133**: 기업집단승인결의록의견명세 (Corporate Group Approval Opinion Details) - 위원회 구성원의 상세 승인의견 및 코멘트를 포함하는 테이블

### 6.5 오류 코드

#### 6.5.1 입력 검증 오류
- **오류코드 B3000070**: 처리구분 검증 오류
  - **설명**: 처리구분코드 검증 실패
  - **원인**: 유효하지 않거나 누락된 처리구분코드
  - **처리코드 UKII0126**: 처리구분 문제에 대해 시스템 관리자에게 문의

- **오류코드 B3800001**: 그룹회사코드 검증 오류
  - **설명**: 그룹회사코드 검증 실패
  - **원인**: 누락되거나 유효하지 않은 그룹회사코드
  - **처리코드 UKIP0001**: 유효한 그룹회사코드를 입력하고 트랜잭션 재시도

- **오류코드 B3800002**: 기업집단코드 검증 오류
  - **설명**: 기업집단코드 검증 실패
  - **원인**: 누락되거나 유효하지 않은 기업집단코드
  - **처리코드 UKIP0002**: 유효한 기업집단코드를 입력하고 트랜잭션 재시도

- **오류코드 B3800003**: 기업집단등록코드 검증 오류
  - **설명**: 기업집단등록코드 검증 실패
  - **원인**: 누락되거나 유효하지 않은 기업집단등록코드
  - **처리코드 UKIP0003**: 유효한 기업집단등록코드를 입력하고 트랜잭션 재시도

- **오류코드 B3800004**: 평가일자 검증 오류
  - **설명**: 평가일자 검증 실패
  - **원인**: 누락되거나 유효하지 않은 평가일자 형식
  - **처리코드 UKIP0004**: YYYYMMDD 형식으로 평가일자를 입력하고 트랜잭션 재시도

#### 6.5.2 시스템 및 데이터베이스 오류
- **오류코드 B3900001**: 데이터베이스 SQL 실행 오류
  - **설명**: SQL 쿼리 실행 및 데이터베이스 접근 실패
  - **원인**: 데이터베이스 연결 문제, SQL 구문 오류, 테이블 접근 문제, 또는 데이터 무결성 제약조건
  - **처리코드 UKII0185**: 데이터베이스 연결 문제에 대해 시스템 관리자에게 문의

- **오류코드 B3900002**: 데이터베이스 연결 오류
  - **설명**: 데이터베이스 연결 설정 실패
  - **원인**: 네트워크 연결 문제, 데이터베이스 서버 사용불가, 또는 연결 풀 고갈
  - **처리코드 UKII0186**: 잠시 후 트랜잭션 재시도 또는 시스템 관리자에게 문의

- **오류코드 B3700001**: 인터페이스 통신 오류
  - **설명**: 인터페이스 컴포넌트 통신 실패
  - **원인**: 인터페이스 컴포넌트 사용불가, 파라미터 불일치, 또는 통신 타임아웃
  - **처리코드 UKII0292**: 트랜잭션 재시도 또는 인터페이스 문제에 대해 시스템 관리자에게 문의

- **오류코드 B3800005**: 직원정보 조회 오류
  - **설명**: 직원정보 조회 실패
  - **원인**: 유효하지 않은 직원번호, 직원데이터 미발견, 또는 직원 마스터 접근 문제
  - **처리코드 UKIP0016**: 직원정보를 확인하고 HR 관리자에게 문의

#### 6.5.3 업무 로직 오류
- **오류코드 B3100001**: 위원회 구성원수 불일치 오류
  - **설명**: 위원회 구성원수 검증 실패
  - **원인**: 재적위원수가 출석위원수보다 적거나 구성원수의 논리적 불일치
  - **처리코드 UKIP0010**: 위원회 구성원수 데이터를 확인하고 데이터 관리자에게 문의

- **오류코드 B3100002**: 승인결정수 불일치 오류
  - **설명**: 승인결정수 검증 실패
  - **원인**: 승인수와 불승인수의 합이 출석위원수와 일치하지 않음
  - **처리코드 UKIP0011**: 승인결정 데이터 일관성을 확인하고 데이터 관리자에게 문의

- **오류코드 B3200001**: 의견내용 검증 오류
  - **설명**: 승인의견 내용 검증 실패
  - **원인**: 누락된 의견내용 또는 빈 의견 텍스트
  - **처리코드 UKIP0012**: 모든 위원회 구성원에 대해 의견내용이 제공되었는지 확인

- **오류코드 B3200002**: 의견내용 길이 오류
  - **설명**: 의견내용이 최대 길이 제한을 초과
  - **원인**: 의견내용 길이가 1002자를 초과
  - **처리코드 UKIP0013**: 의견내용 길이를 최대 제한 내로 줄임

- **오류코드 B3300001**: 등급분류 일관성 오류
  - **설명**: 등급분류 일관성 검증 실패
  - **원인**: 적절한 조정분류 없이 예비 및 최종 등급분류가 일치하지 않음
  - **처리코드 UKIP0014**: 등급분류 일관성 및 조정코드 확인

- **오류코드 B3400001**: 기업집단 데이터 미발견 오류
  - **설명**: 지정된 파라미터에 대한 기업집단 데이터가 존재하지 않음
  - **원인**: 유효하지 않은 기업집단 식별 파라미터 또는 지정된 평가일자에 대한 데이터 없음
  - **처리코드 UKIP0015**: 기업집단 식별 파라미터 및 평가일자 확인

#### 6.5.4 데이터 일관성 오류
- **오류코드 B3300001**: 등급분류 일관성 오류
  - **설명**: 등급분류 일관성 검증 실패
  - **원인**: 적절한 조정분류 없이 예비 및 최종 등급분류가 일치하지 않음
  - **처리코드 UKIP0014**: 등급분류 일관성 및 조정코드 확인

- **오류코드 B3400001**: 기업집단 데이터 미발견 오류
  - **설명**: 지정된 파라미터에 대한 기업집단 데이터가 존재하지 않음
  - **원인**: 유효하지 않은 기업집단 식별 파라미터 또는 지정된 평가일자에 대한 데이터 없음
  - **처리코드 UKIP0015**: 기업집단 식별 파라미터 및 평가일자 확인

#### 6.5.5 처리 및 트랜잭션 오류
- **오류코드 B3500001**: 트랜잭션 처리 오류
  - **설명**: 일반적인 트랜잭션 처리 실패
  - **원인**: 시스템 자원 제약, 동시 접근 충돌, 또는 처리 타임아웃
  - **처리코드 UKII0290**: 잠시 후 트랜잭션 재시도 또는 시스템 관리자에게 문의

- **오류코드 B3600001**: 데이터 조회 오류
  - **설명**: 데이터 조회 작업 실패
  - **원인**: 데이터 접근 권한, 테이블 잠금 충돌, 또는 데이터 손상 문제
  - **처리코드 UKII0291**: 데이터 접근 문제 해결을 위해 시스템 관리자에게 문의

### 6.6 기술 아키텍처
- **AS 계층**: AIP4A95 - 기업집단 승인결의록 조회 처리를 위한 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM - 공통영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **DC 계층**: DIPA951 - 승인결의 데이터베이스 작업 및 비즈니스 로직을 위한 데이터 컴포넌트
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리를 위한 비즈니스 컴포넌트 프레임워크
- **SQLIO 계층**: RIPA110, QIPA953, QIPA951, QIPA952, YCDBSQLA - SQL 실행을 위한 데이터베이스 접근 컴포넌트
- **인터페이스 계층**: XCJIBR01, XCJIHR01 - 부점 및 직원정보를 위한 마스터데이터 조회 컴포넌트
- **프레임워크**: XZUGOTMY - 출력영역 할당 및 메모리 관리를 위한 프레임워크 컴포넌트
- **데이터베이스 계층**: 승인결의 데이터를 위한 THKIPB110, THKIPB131, THKIPB132, THKIPB133 테이블이 있는 DB2 데이터베이스

### 6.7 데이터 흐름 아키텍처
1. **입력 처리 흐름**: AIP4A95 → YNIP4A95 (입력 구조) → 파라미터 검증 → 처리 초기화
2. **프레임워크 설정 흐름**: AIP4A95 → IJICOMM → XIJICOMM → YCCOMMON → 공통영역 초기화
3. **데이터베이스 접근 흐름**: AIP4A95 → DIPA951 → RIPA110/QIPA953/QIPA951/QIPA952 → YCDBSQLA → 데이터베이스 작업
4. **서비스 통신 흐름**: AIP4A95 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스
5. **마스터데이터 흐름**: DIPA951 → XCJIBR01/XCJIHR01 → 부점/직원 마스터데이터 → 결과 통합
6. **출력 처리 흐름**: 데이터베이스 결과 → XDIPA951 → YPIP4A95 (출력 구조) → AIP4A95
7. **오류 처리 흐름**: 모든 계층 → 프레임워크 오류 처리 → XZUGOTMY → 사용자 오류 메시지
8. **트랜잭션 흐름**: 요청 → 검증 → 데이터베이스 쿼리 → 마스터데이터 조회 → 결과 처리 → 응답 → 트랜잭션 완료
9. **메모리 관리 흐름**: XZUGOTMY → 출력영역 할당 → 데이터 처리 → 메모리 정리 → 자원 해제
10. **테이블 접근 흐름**: TRIPB110/TRIPB131/TRIPB132/TRIPB133 → TKIPB110/TKIPB131/TKIPB132/TKIPB133 → 키 처리 → 데이터 조회
