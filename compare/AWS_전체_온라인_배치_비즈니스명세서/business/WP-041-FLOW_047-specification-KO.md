# 업무 명세서: 기업집단재무분석저장시스템 (Corporate Group Financial Analysis Storage System)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-041
- **진입점:** AIPBA68
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 트랜잭션 처리 도메인에서 포괄적인 온라인 기업집단 재무분석 저장 시스템을 구현합니다. 시스템은 실시간 기업집단 재무분석 저장 기능을 제공하며, 자동화된 데이터베이스 운영 및 결과 처리 기능을 통한 다차원 재무비율 저장을 지원하여 기업집단 재무평가 및 분석 데이터 관리를 수행합니다.

업무 목적은 다음과 같습니다:
- 다차원 데이터 관리 지원을 통한 포괄적 기업집단 재무분석 저장 제공 (Provide comprehensive corporate group financial analysis storage with multi-dimensional data management support)
- 기업집단 평가를 위한 재무분석 데이터의 실시간 저장 및 관리 지원 (Support real-time storage and management of financial analysis data for corporate group evaluation)
- 안정성, 수익성, 성장성 분석 처리를 통한 구조화된 재무분석 데이터 저장 지원 (Enable structured financial analysis data storage with stability, profitability, and growth analysis processing)
- 자동 검증 및 트랜잭션 데이터베이스 운영을 통한 데이터 무결성 유지 (Maintain data integrity through automated validation and transactional database operations)
- 최적화된 데이터베이스 접근 및 배치 운영을 통한 확장 가능한 분석처리 제공 (Provide scalable analysis processing through optimized database access and batch operations)
- 구조화된 재무평가 문서화 및 감사추적 유지를 통한 규제 준수 지원 (Support regulatory compliance through structured financial evaluation documentation and audit trail maintenance)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIPBA68 → IJICOMM → YCCOMMON → XIJICOMM → DIPA681 → RIPA112 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA130 → RIPA110 → QIPA681 → YCDBSQLA → XQIPA681 → TRIPB112 → TKIPB112 → TRIPB130 → TKIPB130 → TRIPB110 → TKIPB110 → XDIPA681 → XZUGOTMY → YNIPBA68 → YPIPBA68, 기업집단 파라미터 검증, 재무분석 데이터 처리, 다중 테이블 데이터베이스 운영, 결과 저장 운영을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 필수필드 검증을 포함한 기업집단 파라미터 검증 (Corporate group parameter validation with mandatory field verification)
- 안정성, 수익성, 성장성 분석 처리 및 결합결과 저장을 포함한 다차원 재무분석 데이터 저장 (Multi-dimensional financial analysis data storage with stability, profitability, and growth analysis processing and combined result storage)
- 주석 처리 및 구조화된 문서화를 포함한 재무분석 평가의견 저장 (Financial analysis evaluation opinion storage with comment processing and structured documentation)
- 조정된 삽입, 업데이트, 삭제 처리를 통한 트랜잭션 데이터베이스 운영 (Transactional database operations through coordinated insert, update, and delete processing)
- 처리단계 관리를 포함한 재무평가 단계 추적 및 업데이트 (Financial evaluation stage tracking and update with processing stage management)
- 기업집단 재무평가 지원을 위한 처리결과 최적화 및 감사추적 유지 (Processing result optimization and audit trail maintenance for corporate group financial assessment support)

## 2. 업무 엔티티

### BE-041-001: 기업집단재무분석저장요청 (Corporate Group Financial Analysis Storage Request)
- **설명:** 다차원 데이터 관리 지원을 통한 기업집단 재무분석 저장 운영을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA68-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 평가확정년월일 (Evaluation Confirmation Date) | String | 8 | YYYYMMDD 형식 | 평가 확정 일자 | YNIPBA68-VALUA-DEFINS-YMD | valuaDefinsYmd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA68-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 평가 일자 | YNIPBA68-VALUA-YMD | valuaYmd |
| 총건수1 (Total Item Count 1) | Numeric | 5 | NOT NULL | 재무분석 항목 총 개수 | YNIPBA68-TOTAL-NOITM1 | totalNoitm1 |
| 현재건수1 (Current Item Count 1) | Numeric | 5 | NOT NULL | 재무분석 항목 현재 개수 | YNIPBA68-PRSNT-NOITM1 | prsntNoitm1 |
| 총건수2 (Total Item Count 2) | Numeric | 5 | NOT NULL | 평가의견 항목 총 개수 | YNIPBA68-TOTAL-NOITM2 | totalNoitm2 |
| 현재건수2 (Current Item Count 2) | Numeric | 5 | NOT NULL | 평가의견 항목 현재 개수 | YNIPBA68-PRSNT-NOITM2 | prsntNoitm2 |

- **검증 규칙:**
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가확정년월일은 필수이며 YYYYMMDD 형식이어야 함
  - 평가년월일은 필수이며 YYYYMMDD 형식이어야 함
  - 모든 건수 필드는 음이 아닌 숫자 값이어야 함
  - 총건수는 현재건수보다 크거나 같아야 함

### BE-041-002: 재무분석항목데이터 (Financial Analysis Item Data)
- **설명:** 상세한 비율 정보를 포함한 저장용 재무분석 항목 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 재무분석보고서구분 (Financial Analysis Report Classification) | String | 2 | NOT NULL | 재무분석 보고서 유형 | YNIPBA68-RPTDOC-DSTCD | rptdocDstcd |
| 재무항목코드 (Financial Item Code) | String | 4 | NOT NULL | 재무항목 분류 코드 | YNIPBA68-FNAF-ITEM-CD | fnafItemCd |
| 구분명 (Classification Name) | String | 10 | NOT NULL | 분류 설명 | YNIPBA68-DSTIC-NAME | dsticName |
| 재무항목명 (Financial Item Name) | String | 102 | NOT NULL | 재무항목 설명 | YNIPBA68-FNAF-ITEM-NAME | fnafItemName |
| 전전년비율 (Two Years Before Ratio) | Numeric | 7 | 5자리 + 소수점 2자리 | 전전년 재무비율 | YNIPBA68-N2-YR-BF-FNAF-RATO | n2YrBfFnafRato |
| 전년비율 (Previous Year Ratio) | Numeric | 7 | 5자리 + 소수점 2자리 | 전년 재무비율 | YNIPBA68-N-YR-BF-FNAF-RATO | nYrBfFnafRato |
| 기준년비율 (Base Year Ratio) | Numeric | 7 | 5자리 + 소수점 2자리 | 기준년 재무비율 | YNIPBA68-BASE-YR-FNAF-RATO | baseYrFnafRato |

- **검증 규칙:**
  - 재무분석보고서구분은 유효한 코드여야 함
  - 재무항목코드는 유효한 재무항목 식별자여야 함
  - 재무항목명은 공백일 수 없음
  - 모든 비율 값은 소수점 2자리를 가진 유효한 숫자 값이어야 함
  - 특정 재무지표의 경우 비율 값이 음수일 수 있음

### BE-041-003: 평가의견데이터 (Evaluation Opinion Data)
- **설명:** 기업집단 재무분석 주석을 위한 평가의견 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단주석구분 (Corporate Group Comment Classification) | String | 2 | NOT NULL | 기업집단 주석 유형 | YNIPBA68-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 주석내용 (Comment Content) | String | 2002 | NOT NULL | 주석 텍스트 내용 | YNIPBA68-COMT-CTNT | comtCtnt |

- **검증 규칙:**
  - 기업집단주석구분은 유효한 코드여야 함
  - 주석내용은 공백일 수 없음
  - 주석내용은 최대 길이 제한을 초과할 수 없음
  - 주석내용은 유효한 텍스트 문자를 포함해야 함

### BE-041-004: 재무분석저장결과 (Financial Analysis Storage Result)
- **설명:** 기업집단 재무분석 저장 운영의 출력 결과
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수1 (Total Item Count 1) | Numeric | 5 | NOT NULL | 처리된 재무항목 총 개수 | YPIPBA68-TOTAL-NOITM1 | totalNoitm1 |
| 현재건수1 (Current Item Count 1) | Numeric | 5 | NOT NULL | 처리된 재무항목 현재 개수 | YPIPBA68-PRSNT-NOITM1 | prsntNoitm1 |
| 총건수2 (Total Item Count 2) | Numeric | 5 | NOT NULL | 처리된 의견항목 총 개수 | YPIPBA68-TOTAL-NOITM2 | totalNoitm2 |
| 현재건수2 (Current Item Count 2) | Numeric | 5 | NOT NULL | 처리된 의견항목 현재 개수 | YPIPBA68-PRSNT-NOITM2 | prsntNoitm2 |

- **검증 규칙:**
  - 모든 건수 필드는 음이 아닌 숫자 값이어야 함
  - 현재건수는 총건수보다 작거나 같아야 함
  - 처리건수는 실제 수행된 데이터베이스 운영을 반영해야 함

### BE-041-005: 기업집단재무분석명세 (Corporate Group Financial Analysis Detail)
- **설명:** 포괄적인 비율 데이터를 포함한 기업집단 재무분석 상세 데이터베이스 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB112-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB112-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB112-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 평가 일자 | RIPB112-VALUA-YMD | valuaYmd |
| 분석지표분류구분 (Analysis Indicator Classification) | String | 2 | NOT NULL | 분석지표 유형 | RIPB112-ANLS-I-CLSFI-DSTCD | anlsIClsfiDstcd |
| 재무분석보고서구분 (Financial Analysis Report Classification) | String | 2 | NOT NULL | 재무분석 보고서 유형 | RIPB112-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| 재무항목코드 (Financial Item Code) | String | 4 | NOT NULL | 재무항목 분류 코드 | RIPB112-FNAF-ITEM-CD | fnafItemCd |
| 기준년재무비율 (Base Year Financial Ratio) | Numeric | 7 | 5자리 + 소수점 2자리 | 기준년 재무비율 | RIPB112-BASE-YR-FNAF-RATO | baseYrFnafRato |
| N1년전재무비율 (N1 Year Before Financial Ratio) | Numeric | 7 | 5자리 + 소수점 2자리 | N1년전 재무비율 | RIPB112-N1-YR-BF-FNAF-RATO | n1YrBfFnafRato |
| N2년전재무비율 (N2 Year Before Financial Ratio) | Numeric | 7 | 5자리 + 소수점 2자리 | N2년전 재무비율 | RIPB112-N2-YR-BF-FNAF-RATO | n2YrBfFnafRato |

- **검증 규칙:**
  - 모든 키 필드는 필수이며 공백일 수 없음
  - 평가년월일은 YYYYMMDD 형식이어야 함
  - 분석지표분류구분은 유효한 코드여야 함 (02=수익성, 03=안정성, 07=성장성)
  - 재무비율은 소수점 2자리를 가진 유효한 숫자 값이어야 함
  - 시스템 감사 필드는 자동으로 유지됨

### BE-041-006: 기업집단주석명세 (Corporate Group Comment Detail)
- **설명:** 구조화된 주석 관리를 포함한 기업집단 주석 상세 데이터베이스 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB130-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 평가 일자 | RIPB130-VALUA-YMD | valuaYmd |
| 기업집단주석구분 (Corporate Group Comment Classification) | String | 2 | NOT NULL | 기업집단 주석 유형 | RIPB130-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 일련번호 (Serial Number) | Numeric | 4 | NOT NULL | 주석 순서 번호 | RIPB130-SERNO | serno |
| 주석내용 (Comment Content) | String | 4002 | NOT NULL | 주석 텍스트 내용 | RIPB130-COMT-CTNT | comtCtnt |

- **검증 규칙:**
  - 모든 키 필드는 필수이며 공백일 수 없음
  - 평가년월일은 YYYYMMDD 형식이어야 함
  - 기업집단주석구분은 유효한 코드여야 함
  - 일련번호는 동일한 주석구분 내에서 유일해야 함
  - 주석내용은 공백일 수 없으며 최대 길이를 초과할 수 없음
  - 시스템 감사 필드는 자동으로 유지됨

## 3. 업무 규칙

### BR-041-001: 기업집단그룹코드검증 (Corporate Group Code Validation)
- **규칙명:** 기업집단그룹코드검증규칙 (Corporate Group Code Validation Rule)
- **설명:** 기업집단그룹코드가 제공되고 공백이 아님을 검증
- **조건:** 기업집단그룹코드가 처리될 때 공백이거나 스페이스가 아니어야 함
- **관련 엔티티:** BE-041-001
- **예외:** 없음 - 필수 검증임

### BR-041-002: 기업집단등록코드검증 (Corporate Group Registration Code Validation)
- **규칙명:** 기업집단등록코드검증규칙 (Corporate Group Registration Code Validation Rule)
- **설명:** 기업집단등록코드가 제공되고 공백이 아님을 검증
- **조건:** 기업집단등록코드가 처리될 때 공백이거나 스페이스가 아니어야 함
- **관련 엔티티:** BE-041-001
- **예외:** 없음 - 필수 검증임

### BR-041-003: 평가일자검증 (Evaluation Date Validation)
- **규칙명:** 평가일자검증규칙 (Evaluation Date Validation Rule)
- **설명:** 평가일자가 제공되고 올바른 형식임을 검증
- **조건:** 평가일자가 처리될 때 공백이 아니고 YYYYMMDD 형식이어야 함
- **관련 엔티티:** BE-041-001
- **예외:** 없음 - 필수 검증임

### BR-041-004: 평가확정일자검증 (Evaluation Confirmation Date Validation)
- **규칙명:** 평가확정일자검증규칙 (Evaluation Confirmation Date Validation Rule)
- **설명:** 평가확정일자가 제공되고 올바른 형식임을 검증
- **조건:** 평가확정일자가 처리될 때 공백이 아니고 YYYYMMDD 형식이어야 함
- **관련 엔티티:** BE-041-001
- **예외:** 없음 - 필수 검증임

### BR-041-005: 재무분석항목처리 (Financial Analysis Item Processing)
- **규칙명:** 재무분석항목처리규칙 (Financial Analysis Item Processing Rule)
- **설명:** 총건수가 0보다 클 때만 재무분석항목을 처리
- **조건:** 총건수1이 0보다 클 때 안정성, 수익성, 성장성 분석 저장을 처리
- **관련 엔티티:** BE-041-001, BE-041-002, BE-041-005
- **예외:** 총건수가 0일 때 처리 생략

### BR-041-006: 평가의견처리 (Evaluation Opinion Processing)
- **규칙명:** 평가의견처리규칙 (Evaluation Opinion Processing Rule)
- **설명:** 총건수가 0보다 클 때만 평가의견을 처리
- **조건:** 총건수2가 0보다 클 때 의견 삭제 및 삽입을 처리
- **관련 엔티티:** BE-041-001, BE-041-003, BE-041-006
- **예외:** 총건수가 0일 때 처리 생략

### BR-041-007: 안정성분석분류 (Stability Analysis Classification)
- **규칙명:** 안정성분석분류규칙 (Stability Analysis Classification Rule)
- **설명:** 안정성 분석 처리를 위한 재무항목 분류
- **조건:** 재무항목코드가 3020, 3060, 3090, 2322일 때 안정성분석(03)으로 분류
- **관련 엔티티:** BE-041-002, BE-041-005
- **예외:** 다른 재무항목코드는 안정성분석으로 처리되지 않음

### BR-041-008: 수익성분석분류 (Profitability Analysis Classification)
- **규칙명:** 수익성분석분류규칙 (Profitability Analysis Classification Rule)
- **설명:** 수익성 분석 처리를 위한 재무항목 분류
- **조건:** 재무항목코드가 2120, 2251, 2286일 때 수익성분석(02)으로 분류
- **관련 엔티티:** BE-041-002, BE-041-005
- **예외:** 다른 재무항목코드는 수익성분석으로 처리되지 않음

### BR-041-009: 성장성분석분류 (Growth Analysis Classification)
- **규칙명:** 성장성분석분류규칙 (Growth Analysis Classification Rule)
- **설명:** 성장성 및 활동성 분석 처리를 위한 재무항목 분류
- **조건:** 재무항목코드가 1010, 1060, 4010, 4120일 때 성장성분석(07)으로 분류
- **관련 엔티티:** BE-041-002, BE-041-005
- **예외:** 다른 재무항목코드는 성장성분석으로 처리되지 않음

### BR-041-010: 데이터베이스레코드교체 (Database Record Replacement)
- **규칙명:** 데이터베이스레코드교체규칙 (Database Record Replacement Rule)
- **설명:** 저장 운영 중 기존 데이터베이스 레코드를 새 데이터로 교체
- **조건:** 동일한 키에 대한 기존 레코드가 발견될 때 새 레코드 삽입 전에 기존 레코드 삭제
- **관련 엔티티:** BE-041-005, BE-041-006
- **예외:** 기존 레코드가 없을 때 직접 삽입

### BR-041-011: 처리단계업데이트 (Processing Stage Update)
- **규칙명:** 처리단계업데이트규칙 (Processing Stage Update Rule)
- **설명:** 성공적인 저장 운영 후 기업집단 처리단계 업데이트
- **조건:** 재무분석 저장이 완료될 때 기업집단 처리단계구분을 업데이트
- **관련 엔티티:** BE-041-001
- **예외:** 저장 운영이 실패하면 단계가 업데이트되지 않음

## 4. 업무 기능

### F-041-001: 기업집단파라미터검증 (Corporate Group Parameter Validation)
- **기능명:** 기업집단파라미터검증기능 (Corporate Group Parameter Validation Function)
- **설명:** 기업집단 재무분석 저장 운영을 위한 입력 파라미터 검증

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | 평가 일자 |
| valuaDefinsYmd | String | 8 | 평가 확정 일자 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| validationStatus | String | 2 | 검증 완료 상태 |
| errorCode | String | 8 | 검증 실패 시 오류 코드 |
| treatmentCode | String | 8 | 오류 처리를 위한 조치 코드 |

#### 처리 로직
1. 기업집단그룹코드가 공백이거나 스페이스가 아님을 검증
2. 기업집단등록코드가 공백이거나 스페이스가 아님을 검증
3. 평가일자가 공백이 아니고 YYYYMMDD 형식임을 검증
4. 평가확정일자가 공백이 아니고 YYYYMMDD 형식임을 검증
5. 적절한 오류 코드와 함께 검증 상태 반환
6. 오류 처리 및 사용자 안내를 위한 조치 코드 설정

### F-041-002: 안정성분석저장 (Stability Analysis Storage)
- **기능명:** 안정성분석저장기능 (Stability Analysis Storage Function)
- **설명:** 기업집단 평가를 위한 안정성 분석 재무비율 저장

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | 평가 일자 |
| financialItems | Array | Variable | 안정성을 위한 재무분석 항목 |
| currentItemCount | Numeric | 5 | 처리할 현재 항목 수 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| processedCount | Numeric | 5 | 성공적으로 처리된 항목 수 |
| processingStatus | String | 2 | 처리 완료 상태 |
| errorIndicator | String | 1 | 실패한 운영에 대한 오류 지시자 |

#### 처리 로직
1. THKIPB112 테이블에서 기존 안정성 분석 레코드 조회
2. 재무항목코드 3020, 3060, 3090, 2322에 대한 기존 레코드 삭제
3. 분류코드 03으로 새로운 안정성 분석 레코드 삽입
4. 유동비율, 부채비율, 차입금의존도, 부채상환계수 처리
5. 처리 타임스탬프 및 사용자 정보로 시스템 감사 필드 업데이트
6. 성공적으로 저장된 레코드 수와 함께 처리 상태 반환

### F-041-003: 수익성분석저장 (Profitability Analysis Storage)
- **기능명:** 수익성분석저장기능 (Profitability Analysis Storage Function)
- **설명:** 기업집단 평가를 위한 수익성 분석 재무비율 저장

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | 평가 일자 |
| financialItems | Array | Variable | 수익성을 위한 재무분석 항목 |
| currentItemCount | Numeric | 5 | 처리할 현재 항목 수 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| processedCount | Numeric | 5 | 성공적으로 처리된 항목 수 |
| processingStatus | String | 2 | 처리 완료 상태 |
| errorIndicator | String | 1 | 실패한 운영에 대한 오류 지시자 |

#### 처리 로직
1. THKIPB112 테이블에서 기존 수익성 분석 레코드 조회
2. 재무항목코드 2120, 2251, 2286에 대한 기존 레코드 삭제
3. 분류코드 02로 새로운 수익성 분석 레코드 삽입
4. 매출액영업이익율, 금융비용비율, 이자보상배율 처리
5. 처리 타임스탬프 및 사용자 정보로 시스템 감사 필드 업데이트
6. 성공적으로 저장된 레코드 수와 함께 처리 상태 반환

### F-041-004: 성장성분석저장 (Growth Analysis Storage)
- **기능명:** 성장성분석저장기능 (Growth Analysis Storage Function)
- **설명:** 기업집단 평가를 위한 성장성 및 활동성 분석 재무비율 저장

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | 평가 일자 |
| financialItems | Array | Variable | 성장성을 위한 재무분석 항목 |
| currentItemCount | Numeric | 5 | 처리할 현재 항목 수 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| processedCount | Numeric | 5 | 성공적으로 처리된 항목 수 |
| processingStatus | String | 2 | 처리 완료 상태 |
| errorIndicator | String | 1 | 실패한 운영에 대한 오류 지시자 |

#### 처리 로직
1. THKIPB112 테이블에서 기존 성장성 분석 레코드 조회
2. 재무항목코드 1010, 1060, 4010, 4120에 대한 기존 레코드 삭제
3. 분류코드 07로 새로운 성장성 분석 레코드 삽입
4. 총자산증가율, 매출액증가율, 총자본회전율, 매출채권회전율 처리
5. 처리 타임스탬프 및 사용자 정보로 시스템 감사 필드 업데이트
6. 성공적으로 저장된 레코드 수와 함께 처리 상태 반환

### F-041-005: 평가의견관리 (Evaluation Opinion Management)
- **기능명:** 평가의견관리기능 (Evaluation Opinion Management Function)
- **설명:** 기업집단 재무분석을 위한 평가의견 및 주석 관리

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | 평가 일자 |
| opinionItems | Array | Variable | 평가의견 항목 |
| totalOpinionCount | Numeric | 5 | 총 의견 항목 수 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| processedCount | Numeric | 5 | 성공적으로 처리된 의견 수 |
| processingStatus | String | 2 | 처리 완료 상태 |
| errorIndicator | String | 1 | 실패한 운영에 대한 오류 지시자 |

#### 처리 로직
1. THKIPB130 테이블에서 기존 평가의견 레코드 삭제
2. 순차적 일련번호로 새로운 평가의견 레코드 삽입
3. 기업집단 주석구분 및 내용 처리
4. 주석내용 길이 및 형식 요구사항 검증
5. 처리 타임스탬프 및 사용자 정보로 시스템 감사 필드 업데이트
6. 성공적으로 저장된 의견 수와 함께 처리 상태 반환

### F-041-006: 처리단계업데이트 (Processing Stage Update)
- **기능명:** 처리단계업데이트기능 (Processing Stage Update Function)
- **설명:** 성공적인 재무분석 저장 후 기업집단 처리단계 업데이트

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | 평가 일자 |
| newProcessingStage | String | 1 | 새로운 처리단계 분류 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| updateStatus | String | 2 | 업데이트 완료 상태 |
| previousStage | String | 1 | 이전 처리단계 |
| errorIndicator | String | 1 | 실패한 운영에 대한 오류 지시자 |

#### 처리 로직
1. THKIPB110 테이블에서 기존 기업집단 기본 레코드 조회
2. 기업집단 처리단계구분 필드 업데이트
3. 시스템 처리 타임스탬프로 감사 추적 유지
4. 처리단계 전환 규칙 검증
5. 처리 사용자 정보로 시스템 감사 필드 업데이트
6. 이전 및 새로운 단계 정보와 함께 업데이트 상태 반환

### F-041-007: 결과집계및출력 (Result Aggregation and Output)
- **기능명:** 결과집계및출력기능 (Result Aggregation and Output Function)
- **설명:** 처리 결과를 집계하고 기업집단 재무분석 저장을 위한 출력 준비

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| inputTotalCount1 | Numeric | 5 | 입력 총 재무분석 항목 |
| inputCurrentCount1 | Numeric | 5 | 입력 현재 재무분석 항목 |
| inputTotalCount2 | Numeric | 5 | 입력 총 평가의견 항목 |
| inputCurrentCount2 | Numeric | 5 | 입력 현재 평가의견 항목 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| outputTotalCount1 | Numeric | 5 | 출력 총 재무분석 항목 |
| outputCurrentCount1 | Numeric | 5 | 출력 현재 재무분석 항목 |
| outputTotalCount2 | Numeric | 5 | 출력 총 평가의견 항목 |
| outputCurrentCount2 | Numeric | 5 | 출력 현재 평가의견 항목 |

#### 처리 로직
1. 입력 총건수1을 출력 총건수1로 복사
2. 입력 현재건수1을 출력 현재건수1로 복사
3. 입력 총건수2를 출력 총건수2로 복사
4. 입력 현재건수2를 출력 현재건수2로 복사
5. 건수 일관성 및 처리 완료성 검증
6. 시스템 응답을 위한 집계된 결과 반환

## 5. 프로세스 흐름

### 기업집단 재무분석 저장 프로세스 흐름
```
AIPBA68 (AS기업집단재무분석저장)
├── S1000-INITIALIZE-RTN (초기화)
│   ├── IJICOMM (공통IC프로그램호출)
│   │   ├── YCCOMMON (공통영역)
│   │   └── XIJICOMM (공통IC인터페이스)
│   └── XZUGOTMY (출력영역확보)
├── S2000-VALIDATION-RTN (입력값검증)
│   ├── Corporate Group Code Validation (기업집단그룹코드검증)
│   ├── Corporate Group Registration Code Validation (기업집단등록코드검증)
│   ├── Evaluation Date Validation (평가일자검증)
│   └── Evaluation Confirmation Date Validation (평가확정일자검증)
└── S3000-PROCESS-RTN (업무처리)
    └── DIPA681 (DC기업집단재무분석저장)
        ├── S1000-INITIALIZE-RTN (초기화)
        ├── S2000-VALIDATION-RTN (입력값검증)
        ├── S3000-PROCESS-RTN (업무처리)
        │   ├── S3100-STABL-RTN (안정성저장)
        │   │   ├── QIPA681 (기업집단재무분석조회)
        │   │   │   ├── YCDBSQLA (SQL처리영역)
        │   │   │   ├── XQIPA681 (SQL인터페이스)
        │   │   │   └── TRIPB112 (기업집단재무명세테이블)
        │   │   ├── RIPA112 (기업집단재무명세DBIO)
        │   │   │   ├── YCDBIOCA (DBIO처리영역)
        │   │   │   ├── TKIPB112 (기업집단재무명세키)
        │   │   │   └── TRIPB112 (기업집단재무명세레코드)
        │   │   └── Financial Item Processing (재무항목처리)
        │   │       ├── 3020: 유동비율 (Liquidity Ratio)
        │   │       ├── 3060: 부채비율 (Debt Ratio)
        │   │       ├── 3090: 차입금의존도 (Borrowing Dependency)
        │   │       └── 2322: 부채상환계수 (Debt Service Ratio)
        │   ├── S3200-ERN-RTN (수익성저장)
        │   │   ├── QIPA681 (기업집단재무분석조회)
        │   │   ├── RIPA112 (기업집단재무명세DBIO)
        │   │   └── Financial Item Processing (재무항목처리)
        │   │       ├── 2120: 매출액영업이익율 (Operating Profit Margin)
        │   │       ├── 2251: 금융비용대매출액비율 (Financial Cost Ratio)
        │   │       └── 2286: 이자보상배율 (Interest Coverage Ratio)
        │   ├── S3300-GROTH-RTN (성장성저장)
        │   │   ├── QIPA681 (기업집단재무분석조회)
        │   │   ├── RIPA112 (기업집단재무명세DBIO)
        │   │   └── Financial Item Processing (재무항목처리)
        │   │       ├── 1010: 총자산증가율 (Total Asset Growth Rate)
        │   │       ├── 1060: 매출액증가율 (Sales Growth Rate)
        │   │       ├── 4010: 총자본회전율 (Total Capital Turnover)
        │   │       └── 4120: 매출채권회전율 (Accounts Receivable Turnover)
        │   ├── S3400-OPINI-DEL-RTN (평가의견삭제)
        │   │   └── RIPA130 (기업집단주석명세DBIO)
        │   │       ├── YCDBIOCA (DBIO처리영역)
        │   │       ├── TKIPB130 (기업집단주석명세키)
        │   │       └── TRIPB130 (기업집단주석명세레코드)
        │   ├── S3500-OPINI-INS-RTN (평가의견저장)
        │   │   └── RIPA130 (기업집단주석명세DBIO)
        │   ├── S3600-THKIPB110-UDT-RTN (기업집단평가기본업데이트)
        │   │   └── RIPA110 (기업집단평가기본DBIO)
        │   │       ├── YCDBIOCA (DBIO처리영역)
        │   │       ├── TKIPB110 (기업집단평가기본키)
        │   │       └── TRIPB110 (기업집단평가기본레코드)
        │   └── Result Assembly (결과조립)
        └── S9000-FINAL-RTN (처리종료)
```

## 6. 레거시 구현 참조

### 소스 파일
- **AIPBA68.cbl**: 기업집단 재무분석 저장을 위한 메인 AS 프로그램
- **DIPA681.cbl**: 기업집단 재무분석 저장 처리를 위한 DC 프로그램
- **IJICOMM.cbl**: 프레임워크 초기화를 위한 공통 IC 프로그램
- **RIPA112.cbl**: 기업집단 재무분석 상세 테이블 운영을 위한 DBIO 프로그램
- **RIPA130.cbl**: 기업집단 주석 상세 테이블 운영을 위한 DBIO 프로그램
- **RIPA110.cbl**: 기업집단 평가 기본 테이블 운영을 위한 DBIO 프로그램
- **QIPA681.cbl**: 기업집단 재무분석 조회를 위한 SQLIO 프로그램
- **YNIPBA68.cpy**: AS 기업집단 재무분석 저장을 위한 입력 카피북
- **YPIPBA68.cpy**: AS 기업집단 재무분석 저장을 위한 출력 카피북
- **XDIPA681.cpy**: DC 기업집단 재무분석 저장을 위한 인터페이스 카피북
- **XQIPA681.cpy**: SQL 기업집단 재무분석 조회를 위한 인터페이스 카피북
- **TRIPB112.cpy**: 기업집단 재무분석 상세를 위한 테이블 카피북
- **TRIPB130.cpy**: 기업집단 주석 상세를 위한 테이블 카피북
- **TRIPB110.cpy**: 기업집단 평가 기본을 위한 테이블 카피북
- **TKIPB112.cpy**: 기업집단 재무분석 상세를 위한 키 카피북
- **TKIPB130.cpy**: 기업집단 주석 상세를 위한 키 카피북
- **TKIPB110.cpy**: 기업집단 평가 기본을 위한 키 카피북
- **YCCOMMON.cpy**: 프레임워크 처리를 위한 공통 영역 카피북
- **XIJICOMM.cpy**: 공통 IC 인터페이스 카피북
- **YCDBIOCA.cpy**: DBIO 처리 영역 카피북
- **YCDBSQLA.cpy**: SQLIO 처리 영역 카피북
- **YCCSICOM.cpy**: 공통 시스템 인터페이스 카피북
- **YCCBICOM.cpy**: 공통 업무 인터페이스 카피북
- **XZUGOTMY.cpy**: 출력 영역 할당 카피북

### 업무 규칙 구현

#### BR-041-001: 기업집단그룹코드검증
- **파일**: AIPBA68.cbl, 라인 150-154
- **코드**: 
```cobol
IF YNIPBA68-CORP-CLCT-GROUP-CD = SPACE
   #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
END-IF
```

#### BR-041-002: 기업집단등록코드검증
- **파일**: AIPBA68.cbl, 라인 162-166
- **코드**:
```cobol
IF YNIPBA68-CORP-CLCT-REGI-CD = SPACE
   #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
END-IF
```

#### BR-041-003: 평가일자검증
- **파일**: AIPBA68.cbl, 라인 170-174
- **코드**:
```cobol
IF YNIPBA68-VALUA-YMD = SPACE
   #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
END-IF
```

#### BR-041-004: 평가확정일자검증
- **파일**: AIPBA68.cbl, 라인 178-182
- **코드**:
```cobol
IF YNIPBA68-VALUA-DEFINS-YMD = SPACE
   #ERROR CO-B3800004 CO-UKIP0004 CO-STAT-ERROR
END-IF
```

#### BR-041-005: 재무분석항목처리
- **파일**: DIPA681.cbl, 라인 260-270
- **코드**:
```cobol
IF XDIPA681-I-TOTAL-NOITM1 > 0
   PERFORM S3100-STABL-RTN THRU S3100-STABL-EXT
   PERFORM S3200-ERN-RTN THRU S3200-ERN-EXT  
   PERFORM S3300-GROTH-RTN THRU S3300-GROTH-EXT
END-IF
```

#### BR-041-007: 안정성분석분류
- **파일**: DIPA681.cbl, 라인 350-355
- **코드**:
```cobol
IF XQIPA681-O-FNAF-ITEM-CD(WK-I) = CO-CD-3020 OR
                                   CO-CD-3060 OR
                                   CO-CD-3090 OR
                                   CO-CD-2322
```

#### BR-041-008: 수익성분석분류
- **파일**: DIPA681.cbl, 라인 450-454
- **코드**:
```cobol
IF XQIPA681-O-FNAF-ITEM-CD(WK-I) = CO-CD-2120 OR
                                   CO-CD-2251 OR
                                   CO-CD-2286
```

#### BR-041-009: 성장성분석분류
- **파일**: DIPA681.cbl, 라인 550-555
- **코드**:
```cobol
IF XQIPA681-O-FNAF-ITEM-CD(WK-I) = CO-CD-1010 OR
                                   CO-CD-1060 OR
                                   CO-CD-4010 OR
                                   CO-CD-4120
```

### 6.3 업무 기능 구현

#### F-041-001: 기업집단파라미터검증
- **파일**: AIPBA68.cbl, 라인 140-190, DIPA681.cbl, 라인 200-240
- **코드**:
```cobol
PERFORM S2000-VALIDATION-RTN THRU S2000-VALIDATION-EXT
```

#### F-041-002: 안정성분석저장
- **파일**: DIPA681.cbl, 라인 300-410
- **코드**:
```cobol
PERFORM S3100-STABL-RTN THRU S3100-STABL-EXT
MOVE '03' TO WK-CLSFI-DSTCD
PERFORM S6000-QIPA681-INP-RTN THRU S6000-QIPA681-INP-EXT
#DYSQLA QIPA681 SELECT XQIPA681-CA
```

#### F-041-003: 수익성분석저장
- **파일**: DIPA681.cbl, 라인 420-530
- **코드**:
```cobol
PERFORM S3200-ERN-RTN THRU S3200-ERN-EXT
MOVE '02' TO WK-CLSFI-DSTCD
PERFORM S6000-QIPA681-INP-RTN THRU S6000-QIPA681-INP-EXT
#DYSQLA QIPA681 SELECT XQIPA681-CA
```

#### F-041-004: 성장성분석저장
- **파일**: DIPA681.cbl, 라인 540-650
- **코드**:
```cobol
PERFORM S3300-GROTH-RTN THRU S3300-GROTH-EXT
MOVE '07' TO WK-CLSFI-DSTCD
PERFORM S6000-QIPA681-INP-RTN THRU S6000-QIPA681-INP-EXT
#DYSQLA QIPA681 SELECT XQIPA681-CA
```

#### F-041-005: 평가의견관리
- **파일**: DIPA681.cbl, 라인 275-285
- **코드**:
```cobol
IF XDIPA681-I-TOTAL-NOITM2 > 0
   PERFORM S3400-OPINI-DEL-RTN THRU S3400-OPINI-DEL-EXT
   PERFORM S3500-OPINI-INS-RTN THRU S3500-OPINI-INS-EXT
   VARYING WK-I FROM 1 BY 1 UNTIL WK-I > XDIPA681-I-TOTAL-NOITM2
END-IF
```

#### F-041-006: 처리단계업데이트
- **파일**: DIPA681.cbl, 라인 290-295
- **코드**:
```cobol
PERFORM S3600-THKIPB110-UDT-RTN THRU S3600-THKIPB110-UDT-EXT
```

#### F-041-007: 결과집계및출력
- **파일**: DIPA681.cbl, 라인 300-315
- **코드**:
```cobol
MOVE XDIPA681-I-TOTAL-NOITM1 TO XDIPA681-O-TOTAL-NOITM1
MOVE XDIPA681-I-PRSNT-NOITM1 TO XDIPA681-O-PRSNT-NOITM1
MOVE XDIPA681-I-TOTAL-NOITM2 TO XDIPA681-O-TOTAL-NOITM2
MOVE XDIPA681-I-PRSNT-NOITM2 TO XDIPA681-O-PRSNT-NOITM2
```

### 데이터베이스 테이블
- **THKIPB112**: 기업집단재무분석명세 (Corporate Group Financial Analysis Detail)
- **THKIPB130**: 기업집단주석명세 (Corporate Group Comment Detail)
- **THKIPB110**: 기업집단평가기본 (Corporate Group Evaluation Basic)

### 오류 코드
- **Error Set 파라미터 검증**:
  - **에러코드**: [ERROR_CODE] - "[Error Message]"
  - **조치메시지**: [TREATMENT_CODE] - "[Treatment Message]"
  - **Usage**: 파라미터 검증 관련 컴포넌트

- **Error Set 데이터베이스 작업**:
  - **에러코드**: [ERROR_CODE] - "[Error Message]"
  - **조치메시지**: [TREATMENT_CODE] - "[Treatment Message]"
  - **Usage**: 데이터베이스 작업 관련 컴포넌트

- **Error Set 업무 로직**:
  - **에러코드**: [ERROR_CODE] - "[Error Message]"
  - **조치메시지**: [TREATMENT_CODE] - "[Treatment Message]"
  - **Usage**: 업무 로직 검증 관련 컴포넌트

### 기술 아키텍처
- **AS Layer**: AIPBA68 - 기업집단 재무분석 저장 처리를 위한 애플리케이션 서버 컴포넌트
- **IC Layer**: IJICOMM - 공통 프레임워크 서비스 및 시스템 초기화를 위한 인터페이스 컴포넌트
- **DC Layer**: DIPA681 - 재무분석 데이터 처리 및 데이터베이스 조정을 위한 데이터 컴포넌트
- **BC Layer**: RIPA112, RIPA130, RIPA110 - 데이터베이스 테이블 운영 및 데이터 관리를 위한 비즈니스 컴포넌트
- **SQLIO Layer**: QIPA681 - SQL 처리 및 쿼리 실행을 위한 데이터베이스 접근 컴포넌트
- **Framework**: 공유 서비스 및 매크로 사용을 위한 YCCOMMON, XIJICOMM 공통 프레임워크

### 데이터 흐름 아키텍처
1. **입력 흐름**: [Component] → [Component] → [Component]
2. **데이터베이스 접근**: [Component] → [Database Components] → [Database Tables]
3. **서비스 호출**: [Component] → [Service Components] → [Service Description]
4. **출력 흐름**: [Component] → [Component] → [Component]
5. **오류 처리**: 모든 레이어 → 프레임워크 오류 처리 → 사용자 메시지