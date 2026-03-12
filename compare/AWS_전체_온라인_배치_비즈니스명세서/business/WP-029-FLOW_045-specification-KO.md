# 업무 명세서: 기업집단신용등급조정등록 (Corporate Group Credit Rating Adjustment Registration)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-25
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-029
- **진입점:** AIPBA83
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

이 워크패키지는 신용처리 도메인에서 포괄적인 온라인 기업집단 신용등급 조정 등록 시스템을 구현합니다. 시스템은 기업집단 신용평가 운영을 지원하는 주석 관리 및 처리단계 제어를 통한 실시간 신용등급 조정 기능을 제공하며, 기업집단 고객의 신용위험 관리 및 규제 준수 프로세스를 지원합니다.

업무 목적은 다음과 같습니다:
- 포괄적 검증을 통한 기업집단 신용등급 조정 등록 및 관리 (Register and manage corporate group credit rating adjustments with comprehensive validation)
- 감사추적 유지를 통한 실시간 신용등급 수정 기능 제공 (Provide real-time credit rating modification capabilities with audit trail maintenance)
- 구조화된 등급조정 워크플로를 통한 신용평가 프로세스 관리 지원 (Support credit evaluation process management through structured rating adjustment workflow)
- 처리단계 제어를 포함한 기업집단 평가 데이터 무결성 유지 (Maintain corporate group evaluation data integrity including processing stage control)
- 온라인 등급조정 운영을 위한 실시간 신용처리 데이터 접근 (Enable real-time credit processing data access for online rating adjustment operations)
- 기업집단 신용운영의 포괄적 주석관리 및 데이터 일관성 제공 (Provide comprehensive comment management and data consistency for corporate group credit operations)

시스템은 포괄적인 다중 모듈 온라인 플로우를 통해 데이터를 처리합니다: AIPBA83 → IJICOMM → YCCOMMON → XIJICOMM → DIPA831 → RIPA130 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA110 → TRIPB130 → TKIPB130 → TRIPB110 → TKIPB110 → YCDBSQLA → XDIPA831 → XZUGOTMY → YNIPBA83 → YPIPBA83, 신용등급 조정 등록, 주석 관리, 포괄적 데이터베이스 운영을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 필수 필드 검증을 포함한 기업집단 신용등급 조정 검증 (Corporate group credit rating adjustment validation with mandatory field verification)
- 평가 워크플로를 위한 신용등급 수정 및 처리단계 관리 (Credit rating modification and processing stage management for evaluation workflow)
- 구조화된 신용 데이터 접근을 통한 데이터베이스 무결성 관리 (Database integrity management through structured credit data access)
- 등급조정 문서화를 위한 포괄적 검증 규칙을 적용한 주석 관리 (Comment management with comprehensive validation rules for rating adjustment documentation)
- 다중 테이블 관계 처리를 포함한 기업집단 신용 데이터 관리 (Corporate group credit data management with multi-table relationship handling)
- 신용운영의 데이터 일관성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for data consistency in credit operations)

## 2. 업무 엔티티

### BE-029-001: 기업집단신용등급조정요청 (Corporate Group Credit Rating Adjustment Request)
- **설명:** 기업집단 신용등급 조정 등록 운영을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | YNIPBA83-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA83-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA83-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 신용등급 조정을 위한 평가일자 | YNIPBA83-VALUA-YMD | valuaYmd |
| 신최종집단등급구분코드 (New Final Group Rating Classification Code) | String | 3 | NOT NULL | 조정 후 신규 최종 집단등급 분류 | YNIPBA83-NEW-LC-GRD-DSTCD | newLcGrdDstcd |
| 조정단계번호구분코드 (Adjustment Stage Number Classification Code) | String | 2 | NOT NULL | 처리 제어를 위한 조정단계 번호 | YNIPBA83-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |
| 주석내용 (Comment Content) | String | 4002 | NOT NULL | 등급 조정을 위한 상세 주석 내용 | YNIPBA83-COMT-CTNT | comtCtnt |

- **검증 규칙:**
  - 그룹회사코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 신최종집단등급구분코드는 등급 조정을 위해 필수임
  - 조정단계번호구분코드는 처리 제어를 위해 필수임
  - 주석내용은 필수이며 유효한 조정 사유를 포함해야 함

### BE-029-002: 기업집단신용등급조정결과 (Corporate Group Credit Rating Adjustment Result)
- **설명:** 기업집단 신용등급 조정 등록을 위한 결과 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리결과구분코드 (Processing Result Classification Code) | String | 2 | NOT NULL | 처리 결과 상태 코드 | YPIPBA83-PRCSS-RSULT-DSTCD | prcssRsultDstcd |

- **검증 규칙:**
  - 처리결과구분코드는 결과 식별을 위해 필수임
  - 결과 코드는 성공적인 처리 완료를 나타내야 함

### BE-029-003: 기업집단주석관리정보 (Corporate Group Comment Management Information)
- **설명:** 기업집단 신용등급 조정을 위한 주석 관리 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB130-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 주석 연관을 위한 평가일자 | RIPB130-VALUA-YMD | valuaYmd |
| 기업집단주석구분 (Corporate Group Comment Classification) | String | 2 | NOT NULL | 주석 유형 분류 (고정값 '27') | RIPB130-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 일련번호 (Serial Number) | Numeric | 4 | NOT NULL | 주석 순서 번호 (고정값 1) | RIPB130-SERNO | serno |
| 주석내용 (Comment Content) | String | 4002 | NOT NULL | 등급 조정을 위한 상세 주석 내용 | RIPB130-COMT-CTNT | comtCtnt |
| 시스템최종처리일시 (System Last Processing Date Time) | String | 20 | NOT NULL | 최종 처리를 위한 시스템 타임스탬프 | RIPB130-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | String | 7 | NOT NULL | 최종 처리를 위한 시스템 사용자 식별자 | RIPB130-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 모든 기본키 필드는 주석 식별을 위해 필수임
  - 기업집단주석구분은 등급 조정 주석을 위해 '27'이어야 함
  - 일련번호는 기본 주석 레코드를 위해 1이어야 함
  - 주석내용은 필수이며 유효한 조정 사유를 포함해야 함
  - 시스템 필드는 처리 중 자동으로 채워짐

### BE-029-004: 기업집단평가기본정보 (Corporate Group Evaluation Basic Information)
- **설명:** 기업집단 신용등급 관리를 위한 기본 평가 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB110-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 기본 정보를 위한 평가일자 | RIPB110-VALUA-YMD | valuaYmd |
| 기업집단처리단계구분 (Corporate Group Processing Stage Classification) | String | 1 | NOT NULL | 처리단계 분류 (완료를 위해 '5'로 설정) | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| 최종집단등급구분 (Final Group Rating Classification) | String | 3 | NOT NULL | 조정 후 최종 집단등급 분류 | RIPB110-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |
| 조정단계번호구분 (Adjustment Stage Number Classification) | String | 2 | NOT NULL | 처리 제어를 위한 조정단계 번호 | RIPB110-ADJS-STGE-NO-DSTCD | adjsStgeNoDstcd |

- **검증 규칙:**
  - 모든 기본키 필드는 평가 식별을 위해 필수임
  - 기업집단처리단계구분은 등급 조정 완료를 위해 '5'로 설정되어야 함
  - 최종집단등급구분은 필수이며 유효한 등급 코드여야 함
  - 조정단계번호구분은 처리 제어를 위해 필수임
  - 업데이트 작업을 수행하기 전에 레코드가 존재해야 함
## 3. 업무 규칙

### BR-029-001: 그룹회사코드검증 (Group Company Code Validation)
- **규칙명:** 그룹회사코드 검증 규칙
- **설명:** 기업집단 신용등급 조정 운영을 위해 그룹회사코드가 제공되고 유효한지 검증
- **조건:** 신용등급 조정이 요청될 때 그룹회사코드가 제공되어야 하며 공백일 수 없음
- **관련 엔티티:** BE-029-001, BE-029-003, BE-029-004
- **예외사항:** 그룹회사코드는 공백이거나 유효하지 않을 수 없음

### BR-029-002: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단그룹코드 및 등록코드 검증 규칙
- **설명:** 적절한 기업집단 식별을 위해 기업집단그룹코드와 등록코드가 모두 제공되는지 검증
- **조건:** 기업집단 신용등급 조정이 요청될 때 그룹코드와 등록코드가 모두 제공되고 유효해야 함
- **관련 엔티티:** BE-029-001, BE-029-003, BE-029-004
- **예외사항:** 기업집단그룹코드 또는 등록코드 중 어느 것도 공백일 수 없음

### BR-029-003: 평가일자검증 (Evaluation Date Validation)
- **규칙명:** 평가일자 형식 및 존재 검증 규칙
- **설명:** 신용등급 조정 처리를 위해 평가일자가 올바른 형식으로 제공되는지 검증
- **조건:** 신용등급 조정이 요청될 때 평가일자는 유효한 YYYYMMDD 형식이어야 하며 공백일 수 없음
- **관련 엔티티:** BE-029-001, BE-029-003, BE-029-004
- **예외사항:** 평가일자는 공백이거나 유효하지 않은 형식일 수 없음

### BR-029-004: 신용등급조정검증 (Credit Rating Adjustment Validation)
- **규칙명:** 신최종집단등급구분 검증 규칙
- **설명:** 신용등급 조정을 위해 신최종집단등급구분코드가 제공되는지 검증
- **조건:** 신용등급 조정이 요청될 때 신최종집단등급구분코드가 제공되고 유효해야 함
- **관련 엔티티:** BE-029-001, BE-029-004
- **예외사항:** 신최종집단등급구분코드는 공백이거나 유효하지 않을 수 없음

### BR-029-005: 조정단계제어 (Adjustment Stage Control)
- **규칙명:** 조정단계번호구분 제어 규칙
- **설명:** 적절한 처리 워크플로 관리를 위해 조정단계번호구분을 제어
- **조건:** 신용등급 조정이 처리될 때 처리 제어를 위해 조정단계번호구분이 제공되어야 함
- **관련 엔티티:** BE-029-001, BE-029-004
- **예외사항:** 조정단계번호구분코드는 공백일 수 없음

### BR-029-006: 주석관리 (Comment Management)
- **규칙명:** 주석내용 검증 및 관리 규칙
- **설명:** 신용등급 조정 문서화를 위해 주석내용을 검증하고 관리
- **조건:** 신용등급 조정이 등록될 때 유효한 조정 사유와 함께 주석내용이 제공되어야 함
- **관련 엔티티:** BE-029-001, BE-029-003
- **예외사항:** 주석내용은 공백일 수 없으며 의미 있는 조정 정보를 포함해야 함

### BR-029-007: 주석분류제어 (Comment Classification Control)
- **규칙명:** 기업집단주석구분 제어 규칙
- **설명:** 신용등급 조정 주석을 위해 주석 분류 유형을 제어
- **조건:** 신용등급 조정을 위한 주석이 등록될 때 주석구분은 일련번호 1과 함께 '27'로 설정되어야 함
- **관련 엔티티:** BE-029-003
- **예외사항:** 주석구분은 등급 조정 주석을 위해 정확히 '27'이어야 함

### BR-029-008: 처리단계관리 (Processing Stage Management)
- **규칙명:** 기업집단처리단계 관리 규칙
- **설명:** 신용등급 조정 완료를 위해 처리단계구분을 관리
- **조건:** 신용등급 조정이 완료될 때 완료 상태를 위해 처리단계구분이 '5'로 설정되어야 함
- **관련 엔티티:** BE-029-004
- **예외사항:** 처리단계구분은 등급 조정 완료를 위해 '5'여야 함

### BR-029-009: 데이터베이스트랜잭션제어 (Database Transaction Control)
- **규칙명:** 주석 삭제 및 삽입 트랜잭션 제어 규칙
- **설명:** 등급 조정 중 주석 관리를 위한 트랜잭션 순서를 제어
- **조건:** 신용등급 조정 주석이 처리될 때 새 주석이 삽입되기 전에 기존 주석이 삭제되어야 함
- **관련 엔티티:** BE-029-003
- **예외사항:** 삽입 작업 전에 삭제 작업이 성공적으로 완료되어야 함

### BR-029-010: 평가레코드존재검증 (Evaluation Record Existence Validation)
- **규칙명:** 기업집단평가레코드 존재 검증 규칙
- **설명:** 등급 조정 업데이트 전에 기업집단평가레코드가 존재하는지 검증
- **조건:** 신용등급 조정 업데이트가 요청될 때 해당 평가레코드가 데이터베이스에 존재해야 함
- **관련 엔티티:** BE-029-004
- **예외사항:** 업데이트 작업을 수행하기 전에 평가레코드가 존재해야 함
## 4. 업무 기능

### F-029-001: 입력파라미터검증 (Input Parameter Validation)
- **기능명:** 입력파라미터검증 (Input Parameter Validation)
- **설명:** 처리를 위한 기업집단 신용등급 조정 입력 파라미터 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 그룹회사코드 | String | 그룹회사 분류 식별자 |
| 기업집단그룹코드 | String | 기업집단 분류 식별자 |
| 기업집단등록코드 | String | 기업집단 등록 식별자 |
| 평가일자 | Date | 평가일자 (YYYYMMDD 형식) |
| 신최종집단등급구분코드 | String | 조정 후 신규 최종 집단등급 |
| 조정단계번호구분코드 | String | 처리 제어를 위한 조정단계 번호 |
| 주석내용 | String | 등급 조정을 위한 상세 주석 내용 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과상태 | Boolean | 검증의 성공 또는 실패 상태 |
| 오류코드 | Array | 검증 오류 코드 목록 (있는 경우) |
| 검증된파라미터 | Object | 검증되고 형식화된 입력 파라미터 |

**처리 로직:**
1. 모든 필수 입력 필드가 제공되었는지 검증
2. 그룹회사코드가 공백이 아닌지 확인
3. 기업집단그룹코드와 등록코드가 제공되었는지 확인
4. 평가일자가 유효한 YYYYMMDD 형식인지 확인
5. 신최종집단등급구분코드가 제공되었는지 검증
6. 조정단계번호구분코드가 제공되었는지 확인
7. 주석내용이 의미 있는 정보와 함께 제공되었는지 확인
8. 검증 실패 시 오류 코드와 함께 검증 결과 반환

**적용된 업무 규칙:**
- BR-029-001: 그룹회사코드 검증
- BR-029-002: 기업집단 식별 검증
- BR-029-003: 평가일자 검증
- BR-029-004: 신용등급 조정 검증
- BR-029-005: 조정단계 제어
- BR-029-006: 주석 관리

### F-029-002: 주석관리처리 (Comment Management Processing)
- **기능명:** 주석관리처리 (Comment Management Processing)
- **설명:** 기업집단 신용등급 조정을 위한 주석 삭제 및 삽입 관리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단식별정보 | Object | 그룹회사, 그룹코드, 등록코드 |
| 평가일자 | Date | 주석 연관을 위한 평가일자 |
| 주석내용 | String | 등급 조정을 위한 상세 주석 내용 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 주석처리상태 | String | 주석 처리의 성공 또는 실패 상태 |
| 데이터베이스작업결과 | Object | 삭제 및 삽입 작업 결과 |
| 주석레코드정보 | Object | 생성된 주석 레코드 세부사항 |

**처리 로직:**
1. 주석 처리를 위한 데이터베이스 I/O 파라미터 초기화
2. 기존 주석 삭제를 위한 기본키 값 설정
3. 기존 주석 레코드 삭제 작업 실행 (주석구분 '27', 일련번호 1)
4. 삭제 작업 결과 처리 (성공, 찾을 수 없음, 또는 오류)
5. 입력 파라미터로 새 주석 레코드 초기화
6. 주석구분을 '27'로, 일련번호를 1로 설정
7. 새 주석 레코드 삽입 작업 실행
8. 삽입 작업 결과 처리 및 처리 상태 반환

**적용된 업무 규칙:**
- BR-029-007: 주석분류 제어
- BR-029-009: 데이터베이스 트랜잭션 제어
- BR-029-006: 주석 관리

### F-029-003: 신용등급업데이트처리 (Credit Rating Update Processing)
- **기능명:** 신용등급업데이트처리 (Credit Rating Update Processing)
- **설명:** 새로운 신용등급 및 처리단계로 기업집단평가레코드 업데이트

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단식별정보 | Object | 그룹회사, 그룹코드, 등록코드 |
| 평가일자 | Date | 레코드 식별을 위한 평가일자 |
| 신최종집단등급구분코드 | String | 조정 후 신규 최종 집단등급 |
| 조정단계번호구분코드 | String | 처리 제어를 위한 조정단계 번호 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 업데이트처리상태 | String | 업데이트 작업의 성공 또는 실패 상태 |
| 업데이트된레코드정보 | Object | 업데이트된 평가 레코드 세부사항 |
| 처리단계상태 | String | 최종 처리단계 상태 |

**처리 로직:**
1. 평가레코드 업데이트를 위한 데이터베이스 I/O 파라미터 초기화
2. 평가레코드 선택을 위한 기본키 값 설정
3. 레코드 존재를 확인하기 위한 선택 작업 실행
4. 업데이트 전 평가레코드가 존재하는지 검증
5. 등급 조정 완료를 위해 처리단계구분을 '5'로 설정
6. 새 등급으로 최종집단등급구분 업데이트
7. 조정단계번호구분 업데이트
8. 평가레코드 업데이트 작업 실행
9. 업데이트 작업 결과 처리 및 처리 상태 반환

**적용된 업무 규칙:**
- BR-029-008: 처리단계 관리
- BR-029-004: 신용등급 조정 검증
- BR-029-010: 평가레코드 존재 검증

### F-029-004: 데이터베이스트랜잭션관리 (Database Transaction Management)
- **기능명:** 데이터베이스트랜잭션관리 (Database Transaction Management)
- **설명:** 신용등급 조정 작업을 위한 데이터베이스 트랜잭션 관리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 트랜잭션유형 | String | 데이터베이스 작업 유형 (DELETE, INSERT, UPDATE) |
| 테이블식별자 | String | 데이터베이스 작업을 위한 대상 테이블 |
| 레코드데이터 | Object | 데이터베이스 작업을 위한 레코드 데이터 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 트랜잭션결과상태 | String | 데이터베이스 작업의 성공 또는 실패 상태 |
| 데이터베이스응답코드 | String | 데이터베이스 응답 코드 및 상태 |
| 오류정보 | Object | 작업 실패 시 오류 세부사항 |

**처리 로직:**
1. 트랜잭션을 위한 데이터베이스 I/O 공통 영역 초기화
2. 트랜잭션 유형 및 대상 테이블 결정
3. 적절한 데이터베이스 작업 실행 (DELETE, INSERT, UPDATE)
4. 데이터베이스 작업 결과 평가
5. 성공, 찾을 수 없음, 오류 조건 처리
6. 데이터베이스 실패에 대한 사용자 정의 오류 메시지 생성
7. 적절한 상태 코드와 함께 트랜잭션 결과 반환

**적용된 업무 규칙:**
- BR-029-009: 데이터베이스 트랜잭션 제어

### F-029-005: 처리결과조립 (Processing Result Assembly)
- **기능명:** 처리결과조립 (Processing Result Assembly)
- **설명:** 기업집단 신용등급 조정을 위한 최종 처리 결과 조립

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 주석처리결과 | Object | 주석 관리 작업 결과 |
| 등급업데이트결과 | Object | 신용등급 업데이트 작업 결과 |
| 검증결과 | Object | 입력 파라미터 검증 결과 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 최종처리상태 | String | 전체 성공 또는 실패 상태 |
| 처리결과구분코드 | String | 응답을 위한 결과 분류 코드 |
| 통합결과 | Object | 통합된 처리 결과 |

**처리 로직:**
1. 모든 처리 작업의 결과 평가
2. 결과에 따른 전체 처리 성공 또는 실패 상태 결정
3. 결과에 따른 처리결과구분코드 설정
4. 모든 작업 결과를 최종 응답으로 통합
5. 상태 정보와 함께 포괄적인 처리 결과 반환

**적용된 업무 규칙:**
- BR-029-008: 처리단계 관리
## 5. 프로세스 흐름

### 기업집단 신용등급 조정 등록 프로세스 흐름
```
AIPBA83 (AS기업집단신용등급조정등록)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── 출력영역 할당 (#GETOUT YPIPBA83-CA)
│   ├── 공통영역 설정 (JICOM 파라미터)
│   └── IJICOMM 프레임워크 초기화
│       └── XIJICOMM 공통 인터페이스 설정
│           └── YCCOMMON 프레임워크 처리
├── S2000-VALIDATION-RTN (입력값검증)
│   ├── 그룹회사코드 검증
│   ├── 기업집단그룹코드 검증
│   ├── 기업집단등록코드 검증
│   └── 평가년월일 검증
├── S3000-PROCESS-RTN (업무처리)
│   └── S3100-PROC-DIPA831-RTN (DC호출)
│       └── DIPA831 데이터 컴포넌트 호출
│           ├── S1000-INITIALIZE-RTN (DC초기화)
│           ├── S2000-VALIDATION-RTN (DC입력값검증)
│           │   ├── 그룹회사코드 검증
│           │   ├── 기업집단그룹코드 검증
│           │   ├── 기업집단등록코드 검증
│           │   └── 평가년월일 검증
│           └── S3000-PROCESS-RTN (DC업무처리)
│               ├── S3000-PROC-THKIPB130-RTN (기업집단주석명세 DELETE)
│               │   ├── YCDBIOCA 데이터베이스 I/O 초기화
│               │   ├── 기본키 설정 (그룹회사, 그룹코드, 등록코드, 평가일자)
│               │   ├── 주석구분 설정 ('27')
│               │   ├── 일련번호 설정 (1)
│               │   ├── RIPA130 DBIO 컴포넌트 호출
│               │   │   └── SELECT-CMD-Y 작업
│               │   └── DELETE-CMD-Y 작업
│               │       ├── COND-DBIO-OK: 처리 계속
│               │       ├── COND-DBIO-MRNF: 레코드 없음 (계속)
│               │       └── OTHER: 데이터베이스 오류 처리
│               ├── S3100-PROC-THKIPB130-RTN (기업집단주석명세 INSERT)
│               │   ├── YCDBIOCA 데이터베이스 I/O 초기화
│               │   ├── 레코드 데이터 설정
│               │   │   ├── 그룹회사코드 할당
│               │   │   ├── 기업집단그룹코드 할당
│               │   │   ├── 기업집단등록코드 할당
│               │   │   ├── 평가년월일 할당
│               │   │   ├── 주석구분 할당 ('27')
│               │   │   ├── 일련번호 할당 (1)
│               │   │   └── 주석내용 할당
│               │   ├── RIPA130 DBIO 컴포넌트 호출
│               │   │   └── INSERT-CMD-Y 작업
│               │   └── 데이터베이스 작업 결과 처리
│               │       ├── COND-DBIO-OK: 처리 계속
│               │       ├── COND-DBIO-MRNF: 처리 계속
│               │       └── OTHER: 데이터베이스 오류 처리
│               └── S3200-PROC-THKIPB110-RTN (기업집단평가기본 UPDATE)
│                   ├── YCDBIOCA 데이터베이스 I/O 초기화
│                   ├── 기본키 설정 (그룹회사, 그룹코드, 등록코드, 평가일자)
│                   ├── RIPA110 DBIO 컴포넌트 호출
│                   │   └── SELECT-CMD-Y 작업 (레코드 존재 검증)
│                   ├── 레코드 존재 검증
│                   ├── 업데이트 데이터 설정
│                   │   ├── 처리단계구분 ('5' - 등급조정 완료)
│                   │   ├── 최종집단등급구분 할당
│                   │   └── 조정단계번호구분 할당
│                   ├── RIPA110 DBIO 컴포넌트 호출
│                   │   └── UPDATE-CMD-Y 작업
│                   └── 데이터베이스 작업 결과 처리
│                       ├── COND-DBIO-OK: 처리 계속
│                       ├── COND-DBIO-MRNF: 처리 계속
│                       └── OTHER: 데이터베이스 오류 처리
├── 결과 데이터 조립
│   ├── XDIPA831 출력 파라미터 처리
│   └── XZUGOTMY 메모리 관리
│       └── 출력영역 관리
└── S9000-FINAL-RTN (처리종료)
    ├── YNIPBA83 입력 구조 처리
    ├── YPIPBA83 출력 구조 조립
    │   └── 처리결과구분코드 할당
    ├── YCCSICOM 서비스 인터페이스 통신
    ├── YCCBICOM 비즈니스 인터페이스 통신
    └── 트랜잭션 완료 처리
```

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIPBA83.cbl**: 기업집단 신용등급 조정 등록 처리를 위한 메인 애플리케이션 서버 컴포넌트
- **DIPA831.cbl**: 신용등급 조정 데이터베이스 작업 및 비즈니스 로직 처리를 위한 데이터 컴포넌트
- **RIPA130.cbl**: THKIPB130 (기업집단주석관리) 테이블 작업을 위한 데이터베이스 I/O 컴포넌트
- **RIPA110.cbl**: THKIPB110 (기업집단평가기본) 테이블 작업을 위한 데이터베이스 I/O 컴포넌트
- **IJICOMM.cbl**: 공통영역 설정 및 프레임워크 초기화 처리를 위한 인터페이스 컴포넌트
- **YCCOMMON.cpy**: 트랜잭션 처리 및 오류 처리를 위한 공통 프레임워크 카피북
- **XIJICOMM.cpy**: 공통영역 파라미터 정의 및 설정을 위한 인터페이스 카피북
- **YCDBIOCA.cpy**: 데이터베이스 연결 및 트랜잭션 관리를 위한 데이터베이스 I/O 카피북
- **YCCSICOM.cpy**: 프레임워크 서비스를 위한 서비스 인터페이스 통신 카피북
- **YCCBICOM.cpy**: 비즈니스 로직 처리를 위한 비즈니스 인터페이스 통신 카피북
- **XZUGOTMY.cpy**: 출력영역 할당 및 메모리 관리를 위한 프레임워크 카피북
- **YNIPBA83.cpy**: 신용등급 조정을 위한 요청 파라미터를 정의하는 입력 구조 카피북
- **YPIPBA83.cpy**: 처리 결과를 위한 응답 데이터를 정의하는 출력 구조 카피북
- **XDIPA831.cpy**: 입력/출력 파라미터 정의를 위한 데이터 컴포넌트 인터페이스 카피북
- **TRIPB130.cpy**: THKIPB130 (기업집단주석관리) 레코드 구조를 위한 데이터베이스 테이블 카피북
- **TKIPB130.cpy**: THKIPB130 기본키 구조를 위한 데이터베이스 테이블 카피북
- **TRIPB110.cpy**: THKIPB110 (기업집단평가기본) 레코드 구조를 위한 데이터베이스 테이블 카피북
- **TKIPB110.cpy**: THKIPB110 기본키 구조를 위한 데이터베이스 테이블 카피북

### 6.2 업무 규칙 구현
- **BR-029-001:** AIPBA83.cbl 170-175행 및 DIPA831.cbl 170-175행에 구현 (S2000-VALIDATION-RTN - 그룹회사코드 검증)
  ```cobol
  IF YNIPBA83-GROUP-CO-CD = SPACE
     #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF
  ```

- **BR-029-002:** AIPBA83.cbl 180-195행 및 DIPA831.cbl 180-195행에 구현 (S2000-VALIDATION-RTN - 기업집단 식별 검증)
  ```cobol
  IF YNIPBA83-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  
  IF YNIPBA83-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

- **BR-029-003:** AIPBA83.cbl 200-205행 및 DIPA831.cbl 200-205행에 구현 (S2000-VALIDATION-RTN - 평가일자 검증)
  ```cobol
  IF YNIPBA83-VALUA-YMD = SPACE
     #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF
  ```

- **BR-029-007:** DIPA831.cbl 250-260행에 구현 (S3000-PROC-THKIPB130-RTN - 주석분류 제어)
  ```cobol
  MOVE '27' TO KIPB130-PK-CORP-C-COMT-DSTCD
  MOVE 1 TO KIPB130-PK-SERNO
  ```

- **BR-029-008:** DIPA831.cbl 410-415행에 구현 (S3200-PROC-THKIPB110-RTN - 처리단계 관리)
  ```cobol
  MOVE '5' TO RIPB110-CORP-CP-STGE-DSTCD
  ```

- **BR-029-009:** DIPA831.cbl 220-350행에 구현 (S3000-PROC-THKIPB130-RTN 및 S3100-PROC-THKIPB130-RTN - 데이터베이스 트랜잭션 제어)
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC
  
  EVALUATE TRUE
      WHEN COND-DBIO-OK
           #DYDBIO DELETE-CMD-Y TKIPB130-PK TRIPB130-REC
      WHEN COND-DBIO-MRNF
           CONTINUE
  END-EVALUATE
  ```

- **BR-029-010:** DIPA831.cbl 380-390행에 구현 (S3200-PROC-THKIPB110-RTN - 평가레코드 존재 검증)
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC
  
  IF NOT COND-DBIO-OK
     #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
  END-IF
  ```

### 6.3 기능 구현
- **F-029-001:** AIPBA83.cbl 160-210행 및 DIPA831.cbl 160-210행에 구현 (S2000-VALIDATION-RTN - 입력 파라미터 검증)
  ```cobol
  S2000-VALIDATION-RTN.
      IF YNIPBA83-GROUP-CO-CD = SPACE
         #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA83-CORP-CLCT-GROUP-CD = SPACE
         #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA83-CORP-CLCT-REGI-CD = SPACE
         #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
      END-IF
      
      IF YNIPBA83-VALUA-YMD = SPACE
         #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-029-002:** DIPA831.cbl 220-370행에 구현 (S3000-PROC-THKIPB130-RTN 및 S3100-PROC-THKIPB130-RTN - 주석 관리 처리)
  ```cobol
  S3000-PROC-THKIPB130-RTN.
      INITIALIZE YCDBIOCA-CA TKIPB130-KEY TRIPB130-REC
      
      MOVE BICOM-GROUP-CO-CD TO KIPB130-PK-GROUP-CO-CD
      MOVE XDIPA831-I-CORP-CLCT-GROUP-CD TO KIPB130-PK-CORP-CLCT-GROUP-CD
      MOVE XDIPA831-I-CORP-CLCT-REGI-CD TO KIPB130-PK-CORP-CLCT-REGI-CD
      MOVE XDIPA831-I-VALUA-YMD TO KIPB130-PK-VALUA-YMD
      MOVE '27' TO KIPB130-PK-CORP-C-COMT-DSTCD
      MOVE 1 TO KIPB130-PK-SERNO
      
      #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC
      
      EVALUATE TRUE
          WHEN COND-DBIO-OK
               #DYDBIO DELETE-CMD-Y TKIPB130-PK TRIPB130-REC
          WHEN COND-DBIO-MRNF
               CONTINUE
          WHEN OTHER
               #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
      END-EVALUATE
  S3000-PROC-THKIPB130-EXT.
  
  S3100-PROC-THKIPB130-RTN.
      INITIALIZE YCDBIOCA-CA TRIPB130-REC
      
      MOVE BICOM-GROUP-CO-CD TO RIPB130-GROUP-CO-CD
      MOVE XDIPA831-I-CORP-CLCT-GROUP-CD TO RIPB130-CORP-CLCT-GROUP-CD
      MOVE XDIPA831-I-CORP-CLCT-REGI-CD TO RIPB130-CORP-CLCT-REGI-CD
      MOVE XDIPA831-I-VALUA-YMD TO RIPB130-VALUA-YMD
      MOVE '27' TO RIPB130-CORP-C-COMT-DSTCD
      MOVE 1 TO RIPB130-SERNO
      MOVE XDIPA831-I-COMT-CTNT TO RIPB130-COMT-CTNT
      
      #DYDBIO INSERT-CMD-Y TKIPB130-PK TRIPB130-REC
  S3100-PROC-THKIPB130-EXT.
  ```

- **F-029-003:** DIPA831.cbl 380-450행에 구현 (S3200-PROC-THKIPB110-RTN - 신용등급 업데이트 처리)
  ```cobol
  S3200-PROC-THKIPB110-RTN.
      INITIALIZE YCDBIOCA-CA TRIPB110-REC TKIPB110-KEY
      
      MOVE BICOM-GROUP-CO-CD TO KIPB110-PK-GROUP-CO-CD
      MOVE XDIPA831-I-CORP-CLCT-GROUP-CD TO KIPB110-PK-CORP-CLCT-GROUP-CD
      MOVE XDIPA831-I-CORP-CLCT-REGI-CD TO KIPB110-PK-CORP-CLCT-REGI-CD
      MOVE XDIPA831-I-VALUA-YMD TO KIPB110-PK-VALUA-YMD
      
      #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC
      
      IF NOT COND-DBIO-OK
         #ERROR CO-B4200223 CO-UKII0182 CO-STAT-ERROR
      END-IF
      
      MOVE '5' TO RIPB110-CORP-CP-STGE-DSTCD
      MOVE XDIPA831-I-NEW-LC-GRD-DSTCD TO RIPB110-LAST-CLCT-GRD-DSTCD
      MOVE XDIPA831-I-ADJS-STGE-NO-DSTCD TO RIPB110-ADJS-STGE-NO-DSTCD
      
      #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC
  S3200-PROC-THKIPB110-EXT.
  ```

### 6.4 데이터베이스 테이블
- **THKIPB130**: 기업집단주석명세 (Corporate Group Comment Management) - 주석구분 및 내용과 함께 기업집단 신용등급 조정을 위한 주석 정보를 저장하는 테이블
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic) - 신용등급, 처리단계, 조정 세부사항을 포함한 기업집단 평가 정보를 저장하는 기본 테이블

### 6.5 오류 코드

#### 6.5.1 입력 검증 오류
- **오류 코드 B3600003**: 그룹회사코드 검증 오류
  - **설명**: 그룹회사코드 검증 실패
  - **원인**: 그룹회사코드 누락 또는 유효하지 않음
  - **처리 코드 UKFH0208**: 유효한 그룹회사코드를 입력하고 트랜잭션을 재시도

- **오류 코드 B3600552**: 기업집단 식별 검증 오류
  - **설명**: 기업집단그룹코드 또는 등록코드 검증 실패
  - **원인**: 기업집단 식별 파라미터 누락 또는 유효하지 않음
  - **처리 코드**:
    - **UKIP0001**: 기업집단그룹코드를 입력하고 트랜잭션을 재시도
    - **UKII0282**: 기업집단등록코드를 입력하고 트랜잭션을 재시도

- **오류 코드 B2701130**: 평가일자 검증 오류
  - **설명**: 평가일자 형식 또는 존재 검증 실패
  - **원인**: 평가일자 누락 또는 유효하지 않은 형식
  - **처리 코드 UKII0244**: 평가일자를 YYYYMMDD 형식으로 입력하고 트랜잭션을 재시도

#### 6.5.2 데이터베이스 작업 오류
- **오류 코드 B4200095**: 데이터베이스 작업 오류
  - **설명**: 일반적인 데이터베이스 작업 실패
  - **원인**: 데이터베이스 연결 문제, SQL 실행 오류, 또는 데이터 무결성 제약조건
  - **처리 코드 UKIE0009**: 데이터베이스 작업 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B4200219**: 데이터베이스 삭제 작업 오류
  - **설명**: 데이터베이스 삭제 작업 실패
  - **원인**: 데이터베이스 제약조건 또는 연결 문제로 인해 기존 주석 레코드를 삭제할 수 없음
  - **처리 코드 UKII0182**: 데이터베이스 삭제 작업 문제에 대해 시스템 관리자에게 문의

- **오류 코드 B4200223**: 데이터베이스 레코드 없음 오류
  - **설명**: 업데이트 작업을 위해 필요한 데이터베이스 레코드를 찾을 수 없음
  - **원인**: 지정된 파라미터에 대한 기업집단평가레코드가 존재하지 않음
  - **처리 코드 UKII0182**: 기업집단평가레코드가 존재하는지 확인하고 트랜잭션을 재시도

#### 6.5.3 시스템 및 프레임워크 오류
- **오류 코드 B3900009**: 시스템 처리 오류
  - **설명**: 일반적인 시스템 처리 실패
  - **원인**: 시스템 리소스 제약, 프레임워크 오류, 또는 처리 시간 초과
  - **처리 코드 UBNA0036**: 잠시 후 트랜잭션을 재시도하거나 시스템 관리자에게 문의

### 6.6 기술 아키텍처
- **AS 계층**: AIPBA83 - 기업집단 신용등급 조정 등록 처리를 위한 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM - 공통영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **DC 계층**: DIPA831 - 신용등급 조정 데이터베이스 작업 및 비즈니스 로직을 위한 데이터 컴포넌트
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리를 위한 비즈니스 컴포넌트 프레임워크
- **DBIO 계층**: RIPA130, RIPA110, YCDBIOCA - 테이블 작업을 위한 데이터베이스 I/O 컴포넌트
- **프레임워크**: XZUGOTMY - 출력영역 할당 및 메모리 관리를 위한 프레임워크 컴포넌트
- **데이터베이스 계층**: 신용등급 조정 데이터를 위한 THKIPB130, THKIPB110 테이블이 있는 DB2 데이터베이스

### 6.7 데이터 흐름 아키텍처
1. **입력 처리 흐름**: AIPBA83 → YNIPBA83 (입력 구조) → 파라미터 검증 → 처리 초기화
2. **프레임워크 설정 흐름**: AIPBA83 → IJICOMM → XIJICOMM → YCCOMMON → 공통영역 초기화
3. **데이터베이스 접근 흐름**: AIPBA83 → DIPA831 → RIPA130/RIPA110 → YCDBIOCA → 데이터베이스 작업
4. **서비스 통신 흐름**: AIPBA83 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스
5. **출력 처리 흐름**: 데이터베이스 결과 → XDIPA831 → YPIPBA83 (출력 구조) → AIPBA83
6. **오류 처리 흐름**: 모든 계층 → 프레임워크 오류 처리 → XZUGOTMY → 사용자 오류 메시지
7. **트랜잭션 흐름**: 요청 → 검증 → 데이터베이스 작업 (DELETE/INSERT/UPDATE) → 결과 처리 → 응답 → 트랜잭션 완료
8. **메모리 관리 흐름**: XZUGOTMY → 출력영역 할당 → 데이터 처리 → 메모리 정리 → 리소스 해제
