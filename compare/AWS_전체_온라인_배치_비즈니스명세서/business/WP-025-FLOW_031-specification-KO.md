# 업무 명세서: 기업집단사업구조분석조회 (Corporate Group Business Structure Analysis Inquiry)

## 문서 관리
- **버전:** 1.0
- **날짜:** 2025-09-25
- **표준:** IEEE 830-1998
- **작업패키지 ID:** WP-025
- **진입점:** AIP4A65
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 작업패키지는 트랜잭션 처리 도메인에서 기업집단 사업구조분석 정보를 관리하는 포괄적인 온라인 조회 시스템을 구현합니다. 이 시스템은 기업집단 고객의 신용평가 및 위험평가 프로세스를 지원하여 기업집단 사업평가를 위한 상세한 재무분석 데이터와 주석 정보에 대한 실시간 접근을 제공합니다.

업무 목적은 다음과 같습니다:
- 기업집단 평가를 위한 포괄적인 사업구조분석 정보 조회 (Retrieve comprehensive business structure analysis information for corporate group evaluation)
- 다년도 비교를 포함한 상세 재무분석 데이터 실시간 접근 제공 (Provide real-time access to detailed financial analysis data with multi-year comparison)
- 구조화된 재무 데이터 조회를 통한 트랜잭션 일관성 지원 (Support transaction consistency through structured financial data retrieval)
- 재무비율 및 주석을 포함한 상세 기업집단 사업 프로필 유지 (Maintain detailed corporate group business profiles including financial ratios and commentary)
- 온라인 트랜잭션 처리를 위한 실시간 사업분석 데이터 접근 활성화 (Enable real-time business analysis data access for online transaction processing)
- 기업집단 사업평가 프로세스의 감사추적 및 데이터 무결성 제공 (Provide audit trail and data integrity for corporate group business evaluation processes)

시스템은 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIP4A65 → IJICOMM → YCCOMMON → XIJICOMM → DIPA651 → QIPA651 → YCDBSQLA → XQIPA651 → YCCSICOM → YCCBICOM → QIPA652 → XQIPA652 → QIPA653 → XQIPA653 → YCDBIOCA → XDIPA651 → XZUGOTMY → YNIP4A65 → YPIP4A65, 기업집단 식별 검증, 사업구조분석 데이터 조회, 포괄적인 조회 작업을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 사업분석 조회를 위한 기업집단 식별 및 검증 (Corporate group identification and validation for business analysis inquiry)
- 다년도 이력 비교를 포함한 종합 재무분석 데이터 조회 (Comprehensive financial analysis data retrieval with multi-year historical comparison)
- 구조화된 데이터 접근을 통한 트랜잭션 일관성 관리 (Transaction consistency management through structured data access)
- 정확한 평가 표시를 위한 재무비율 정밀도 처리 (Financial ratio precision handling for accurate evaluation display)
- 포괄적 재무분석 정보를 포함한 기업집단 사업 프로필 관리 (Corporate group business profile management with comprehensive financial analysis information)
- 데이터 무결성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for data integrity)

## 2. 업무 엔티티

### BE-025-001: 기업집단사업분석조회요청 (Corporate Group Business Analysis Inquiry Request)
- **설명:** 기업집단 사업구조분석 조회 작업을 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Classification Code) | String | 2 | NOT NULL | 처리 유형 분류 식별자 | YNIP4A65-PRCSS-DSTCD | prcssDistcd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIP4A65-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A65-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 사업분석 조회를 위한 평가 날짜 | YNIP4A65-VALUA-YMD | valuaYmd |

- **검증 규칙:**
  - 처리구분코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함

### BE-025-002: 기업집단재무분석정보 (Corporate Group Financial Analysis Information)
- **설명:** 다년도 비교 및 사업부문 분석을 포함한 포괄적인 기업집단 재무분석 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 재무분석보고서구분코드 (Financial Analysis Report Classification Code) | String | 2 | NOT NULL | 재무분석 보고서 유형 분류 | XDIPA651-O-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| 재무항목코드 (Financial Item Code) | String | 4 | NOT NULL | 재무항목 분류 코드 | XDIPA651-O-FNAF-ITEM-CD | fnafItemCd |
| 사업부문번호 (Business Sector Number) | String | 4 | NOT NULL | 사업부문 식별 번호 | XDIPA651-O-BIZ-SECT-NO | bizSectNo |
| 사업부문구분명 (Business Sector Classification Name) | String | 32 | NOT NULL | 사업부문 분류명 | XDIPA651-O-BIZ-SECT-DSTIC-NAME | bizSectDsticName |
| 기준년항목금액 (Base Year Item Amount) | Numeric | 15 | 부호있음 | 기준년 재무항목 금액 | XDIPA651-O-BASE-YR-ITEM-AMT | baseYrItemAmt |
| 기준년비율 (Base Year Ratio) | Numeric | 7,2 | 부호있음 | 기준년 재무비율 | XDIPA651-O-BASE-YR-RATO | baseYrRato |
| 기준년업체수 (Base Year Company Count) | Numeric | 5 | 부호있음 | 기준년 업체수 | XDIPA651-O-BASE-YR-ENTP-CNT | baseYrEntpCnt |
| N1년전항목금액 (N1 Year Before Item Amount) | Numeric | 15 | 부호있음 | N1년전 재무항목 금액 | XDIPA651-O-N1-YR-BF-ITEM-AMT | n1YrBfItemAmt |
| N1년전비율 (N1 Year Before Ratio) | Numeric | 7,2 | 부호있음 | N1년전 재무비율 | XDIPA651-O-N1-YR-BF-RATO | n1YrBfRato |
| N1년전업체수 (N1 Year Before Company Count) | Numeric | 5 | 부호있음 | N1년전 업체수 | XDIPA651-O-N1-YR-BF-ENTP-CNT | n1YrBfEntpCnt |
| N2년전항목금액 (N2 Year Before Item Amount) | Numeric | 15 | 부호있음 | N2년전 재무항목 금액 | XDIPA651-O-N2-YR-BF-ITEM-AMT | n2YrBfItemAmt |
| N2년전비율 (N2 Year Before Ratio) | Numeric | 7,2 | 부호있음 | N2년전 재무비율 | XDIPA651-O-N2-YR-BF-RATO | n2YrBfRato |
| N2년전업체수 (N2 Year Before Company Count) | Numeric | 5 | 부호있음 | N2년전 업체수 | XDIPA651-O-N2-YR-BF-ENTP-CNT | n2YrBfEntpCnt |

- **검증 규칙:**
  - 재무분석보고서구분코드는 보고서 분류를 위해 필수
  - 재무항목코드는 유효한 재무항목 분류를 참조해야 함
  - 사업부문번호는 부문 식별을 위해 필수
  - 재무금액은 기업 수준 거래를 위한 대용량 숫자 값 지원
  - 비율은 정확한 재무분석을 위한 소수점 정밀도 지원
  - 부호있는 숫자 값은 양수 및 음수 재무 포지션 모두 지원

### BE-025-003: 기업집단주석정보 (Corporate Group Commentary Information)
- **설명:** 기업집단 사업분석을 위한 상세한 주석 및 설명 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단주석구분 (Corporate Group Commentary Classification) | String | 2 | NOT NULL | 주석 분류 유형 | XDIPA651-O-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 주석내용 (Commentary Content) | String | 2002 | 선택사항 | 상세한 주석 내용 | XDIPA651-O-COMT-CTNT | comtCtnt |

- **검증 규칙:**
  - 기업집단주석구분은 주석 분류를 위해 필수
  - 주석내용은 상세한 사업분석 노트를 위한 대용량 텍스트 필드 지원
  - 주석 분류는 유효한 주석 유형을 참조해야 함

### BE-025-004: 사업분석처리제어 (Business Analysis Processing Control)
- **설명:** 사업분석 조회 작업을 위한 처리 제어 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 현재건수1 (Current Count 1) | Numeric | 5 | NOT NULL | 재무분석 레코드의 현재 건수 | XDIPA651-O-PRSNT-NOITM1 | prsntNoitm1 |
| 총건수1 (Total Count 1) | Numeric | 5 | NOT NULL | 재무분석 레코드의 총 건수 | XDIPA651-O-TOTAL-NOITM1 | totalNoitm1 |
| 현재건수2 (Current Count 2) | Numeric | 5 | NOT NULL | 주석 레코드의 현재 건수 | XDIPA651-O-PRSNT-NOITM2 | prsntNoitm2 |
| 총건수2 (Total Count 2) | Numeric | 5 | NOT NULL | 주석 레코드의 총 건수 | XDIPA651-O-TOTAL-NOITM2 | totalNoitm2 |

- **검증 규칙:**
  - 현재건수는 총건수를 초과할 수 없음
  - 모든 건수는 음수가 아닌 값이어야 함
  - 현재건수는 최대 표시 용량으로 제한됨 (100개 레코드)
## 3. 업무 규칙

### BR-025-001: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단식별검증 (Corporate Group Identification Validation)
- **설명:** 사업분석 조회 작업을 위한 기업집단 식별 매개변수를 검증
- **조건:** 사업분석 조회가 요청될 때 모든 식별 매개변수를 검증해야 함
- **관련 엔티티:** BE-025-001
- **예외사항:** 필수 식별 매개변수가 누락되거나 유효하지 않으면 처리 실패

### BR-025-002: 처리구분검증 (Processing Classification Validation)
- **규칙명:** 처리구분검증 (Processing Classification Validation)
- **설명:** 적절한 조회 라우팅을 위한 처리구분코드를 검증
- **조건:** 조회 요청이 수신될 때 처리구분코드는 공백이 아니어야 함
- **관련 엔티티:** BE-025-001
- **예외사항:** 처리구분코드가 누락되면 시스템에서 오류 반환

### BR-025-003: 평가일자검증 (Evaluation Date Validation)
- **규칙명:** 평가일자검증 (Evaluation Date Validation)
- **설명:** 평가일자 형식 및 업무 로직을 검증
- **조건:** 평가일자가 제공될 때 유효한 YYYYMMDD 형식이어야 함
- **관련 엔티티:** BE-025-001
- **예외사항:** 유효하지 않은 날짜 형식은 검증 실패 결과

### BR-025-004: 처리유형라우팅 (Processing Type Routing)
- **규칙명:** 처리유형라우팅 (Processing Type Routing)
- **설명:** 처리구분코드에 따른 조회 처리 라우팅
- **조건:** 처리구분이 '20'이면 신규평가 프로세스 실행, '40'이면 기존평가 프로세스 실행
- **관련 엔티티:** BE-025-001, BE-025-003
- **예외사항:** 유효하지 않은 처리구분은 라우팅 실패 결과

### BR-025-005: 재무데이터일관성 (Financial Data Consistency)
- **규칙명:** 재무데이터일관성 (Financial Data Consistency)
- **설명:** 다년도에 걸친 재무금액 및 비율의 일관성을 보장
- **조건:** 재무데이터가 조회될 때 모든 금액과 비율이 일관되고 유효해야 함
- **관련 엔티티:** BE-025-002
- **예외사항:** 일관되지 않은 재무데이터는 검증 경고 발생

### BR-025-006: 레코드수제한 (Record Count Limitation)
- **규칙명:** 레코드수제한 (Record Count Limitation)
- **설명:** 시스템 과부하 방지를 위한 반환 레코드 수 제한
- **조건:** 조회 결과가 100개 레코드를 초과하면 표시를 100개 레코드로 제한
- **관련 엔티티:** BE-025-004
- **예외사항:** 대용량 결과 집합은 적절한 건수 표시와 함께 잘림

### BR-025-007: 주석구분필터링 (Commentary Classification Filtering)
- **규칙명:** 주석구분필터링 (Commentary Classification Filtering)
- **설명:** 사업구조분석 분류에 따른 주석 데이터 필터링
- **조건:** 주석 데이터가 요청될 때 사업구조분석을 위한 분류코드 '05'로 필터링
- **관련 엔티티:** BE-025-003
- **예외사항:** 분류가 누락되면 주석 데이터 조회 없음

## 4. 업무 기능

### F-025-001: 기업집단사업분석조회 (Corporate Group Business Analysis Inquiry)
- **기능명:** 기업집단사업분석조회 (Corporate Group Business Analysis Inquiry)
- **설명:** 평가를 위한 포괄적인 기업집단 사업구조분석 정보를 조회

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단키 | Object | 기업집단 식별을 위한 기본키 |
| 처리구분 | String | 신규 또는 기존 평가 유형 표시자 |
| 평가일자 | String | 사업분석 평가를 위한 날짜 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 재무분석목록 | Array | 다년도 비교를 포함한 재무분석 데이터 목록 |
| 주석목록 | Array | 사업분석을 위한 주석 정보 목록 |
| 레코드건수 | Object | 두 데이터 유형의 현재 및 총 건수 |
| 처리상태 | String | 조회 작업의 성공 또는 실패 상태 |

**처리 로직:**
1. 기업집단 식별 매개변수 검증
2. 분류코드에 따른 처리 유형 결정
3. THKIPB113에서 재무분석 데이터 조회 실행
4. 처리 유형에 따른 적절한 주석 데이터 조회
5. 레코드 건수 제한 및 데이터 형식화 적용
6. 상태와 함께 구조화된 사업분석 정보 반환

**적용된 업무 규칙:**
- BR-025-001: 기업집단식별검증
- BR-025-002: 처리구분검증
- BR-025-003: 평가일자검증
- BR-025-004: 처리유형라우팅

### F-025-002: 재무분석데이터조회 (Financial Analysis Data Retrieval)
- **기능명:** 재무분석데이터조회 (Financial Analysis Data Retrieval)
- **설명:** 기업집단을 위한 다년도 비교를 포함한 상세한 재무분석 데이터를 조회

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 그룹회사코드 | String | 그룹회사 식별 코드 |
| 기업집단키 | Object | 기업집단 식별 매개변수 |
| 평가일자 | String | 재무분석 평가를 위한 날짜 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 재무데이터 | Array | 비율을 포함한 상세한 재무분석 데이터 |
| 다년도비교 | Object | N1 및 N2년도의 이력 비교 데이터 |
| 사업부문분석 | Array | 사업부문별로 분석된 재무데이터 |

**처리 로직:**
1. 기업집단 매개변수로 THKIPB113 테이블 조회
2. 지정된 평가일자의 재무분석 데이터 조회
3. 다년도 비교 데이터 추출 (기준년, N1, N2)
4. 적절한 정밀도로 재무금액 및 비율 형식화
5. 구조화된 재무분석 정보 반환

**적용된 업무 규칙:**
- BR-025-005: 재무데이터일관성
- BR-025-006: 레코드수제한

### F-025-003: 주석데이터관리 (Commentary Data Management)
- **기능명:** 주석데이터관리 (Commentary Data Management)
- **설명:** 기업집단 사업분석을 위한 주석 및 설명 데이터를 관리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단키 | Object | 기업집단 식별 매개변수 |
| 처리유형 | String | 신규 또는 기존 평가 유형 |
| 주석분류 | String | 주석 유형 분류 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 주석데이터 | Array | 상세한 주석 정보 |
| 분류정보 | Object | 주석 분류 세부사항 |
| 처리상태 | String | 성공 또는 실패 상태 |

**처리 로직:**
1. 처리 유형에 따른 주석 조회 방법 결정
2. 신규평가: 그룹 및 분류별 최신 주석 조회
3. 기존평가: 날짜 및 매개변수별 특정 주석 조회
4. 주석 분류 필터링 적용 (사업구조를 위한 코드 '05')
5. 분류 정보와 함께 형식화된 주석 데이터 반환

**적용된 업무 규칙:**
- BR-025-004: 처리유형라우팅
- BR-025-007: 주석구분필터링

### F-025-004: 데이터집계및포맷팅 (Data Aggregation and Formatting)
- **기능명:** 데이터집계및포맷팅 (Data Aggregation and Formatting)
- **설명:** 표시를 위한 사업분석 데이터를 집계하고 형식화

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 원시재무데이터 | Array | 형식화되지 않은 재무분석 데이터 |
| 원시주석데이터 | Array | 형식화되지 않은 주석 데이터 |
| 표시제한 | Object | 레코드 건수 및 표시 제약조건 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 형식화출력 | Object | 적절한 형식화를 포함한 구조화된 출력 |
| 건수정보 | Object | 현재 및 총 레코드 건수 |
| 상태정보 | String | 처리 완료 상태 |

**처리 로직:**
1. 두 데이터 유형에 레코드 건수 제한 적용
2. 적절한 부호 처리로 재무금액 형식화
3. 소수점 정밀도로 비율 형식화
4. 표시를 위한 그리드 형식으로 데이터 구조화
5. 현재 및 총 건수 표시자 계산 및 설정
6. 표시 준비가 완료된 형식화된 데이터 반환

**적용된 업무 규칙:**
- BR-025-005: 재무데이터일관성
- BR-025-006: 레코드수제한

## 5. 프로세스 흐름

### 기업집단사업분석조회 프로세스 흐름
```
기업집단사업분석조회 (Corporate Group Business Analysis Inquiry)
├── 입력 검증
│   ├── 처리구분코드 검증
│   ├── 기업집단 식별 검증
│   └── 평가일자 매개변수 검증
├── 처리 유형 결정
│   ├── 신규평가 프로세스 (처리코드 = '20')
│   │   ├── 재무분석 데이터 조회 (THKIPB113)
│   │   └── 최신 주석 조회 (THKIPB130 - 그룹별 최신)
│   └── 기존평가 프로세스 (처리코드 = '40')
│       ├── 재무분석 데이터 조회 (THKIPB113)
│       └── 특정 주석 조회 (THKIPB130 - 날짜 및 매개변수별)
├── 데이터 처리
│   ├── 재무분석 데이터 형식화
│   ├── 다년도 비교 처리
│   ├── 주석 분류 필터링
│   └── 레코드 건수 관리
├── 결과 컴파일
│   ├── 재무분석 그리드 조립
│   ├── 주석 그리드 조립
│   ├── 건수 정보 계산
│   └── 사업부문 분석 통합
└── 출력 생성
    ├── 그리드 데이터 형식화
    ├── 레코드 건수 설정
    └── 응답 구조 조립
```
## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIP4A65.cbl**: 기업집단 사업구조분석 조회를 위한 메인 온라인 프로그램
- **DIPA651.cbl**: 사업분석 데이터 조회를 위한 데이터베이스 코디네이터 프로그램
- **QIPA651.cbl**: THKIPB113에서 재무분석 데이터 조회를 위한 SQL 프로그램
- **QIPA652.cbl**: THKIPB130에서 최신 주석 데이터 조회를 위한 SQL 프로그램
- **QIPA653.cbl**: THKIPB130에서 특정 주석 데이터 조회를 위한 SQL 프로그램
- **YNIP4A65.cpy**: 조회 매개변수를 위한 입력 카피북
- **YPIP4A65.cpy**: 사업분석 결과를 위한 출력 카피북
- **XDIPA651.cpy**: 데이터베이스 코디네이터 인터페이스 카피북
- **XQIPA651.cpy**: 재무분석 조회 인터페이스 카피북
- **XQIPA652.cpy**: 최신 주석 조회 인터페이스 카피북
- **XQIPA653.cpy**: 특정 주석 조회 인터페이스 카피북

### 6.2 업무 규칙 구현

- **BR-025-001:** AIP4A65.cbl 160-180행에 구현 (기업집단 식별 검증)
  ```cobol
  IF YNIP4A65-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  IF YNIP4A65-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF
  ```

- **BR-025-002:** AIP4A65.cbl 150-160행에 구현 (처리구분 검증)
  ```cobol
  IF YNIP4A65-PRCSS-DSTCD = SPACE
      #ERROR CO-B3000070 CO-UKII0183 CO-STAT-ERROR
  END-IF
  ```

- **BR-025-003:** AIP4A65.cbl 180-190행에 구현 (평가일자 검증)
  ```cobol
  IF YNIP4A65-VALUA-YMD = SPACE
      #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF
  ```

- **BR-025-004:** DIPA651.cbl 200-220행에 구현 (처리유형 라우팅)
  ```cobol
  EVALUATE XDIPA651-I-PRCSS-DSTCD
     WHEN '20'
        PERFORM S3100-QIPA651-CALL-RTN THRU S3100-QIPA651-CALL-EXT
        PERFORM S3200-QIPA652-CALL-RTN THRU S3200-QIPA652-CALL-EXT
     WHEN '40'
        PERFORM S3100-QIPA651-CALL-RTN THRU S3100-QIPA651-CALL-EXT
        PERFORM S3300-QIPA653-CALL-RTN THRU S3300-QIPA653-CALL-EXT
  END-EVALUATE
  ```

- **BR-025-005:** QIPA651.cbl 250-320행에 구현 (재무데이터 일관성)
  ```cobol
  SELECT 재무분석보고서구분, 재무항목코드, 사업부문번호, 사업부문구분명,
         기준년항목금액, 기준년비율, 기준년업체수,
         "N1년전항목금액", "N1년전비율", "N1년전업체수",
         "N2년전항목금액", "N2년전비율", "N2년전업체수"
  FROM THKIPB113
  WHERE 그룹회사코드 = :XQIPA651-I-GROUP-CO-CD
    AND 기업집단그룹코드 = :XQIPA651-I-CORP-CLCT-GROUP-CD
    AND 기업집단등록코드 = :XQIPA651-I-CORP-CLCT-REGI-CD
    AND 평가년월일 = :XQIPA651-I-VALUA-YMD
  ```

- **BR-025-006:** DIPA651.cbl 270-290행에 구현 (레코드수 제한)
  ```cobol
  IF DBSQL-SELECT-CNT > CO-NUM-100
      MOVE CO-NUM-100 TO XDIPA651-O-PRSNT-NOITM1
  ELSE
      MOVE DBSQL-SELECT-CNT TO XDIPA651-O-PRSNT-NOITM1
  END-IF
  ```

- **BR-025-007:** DIPA651.cbl 350-360행 및 420-430행에 구현 (주석분류 필터링)
  ```cobol
  MOVE '05' TO XQIPA652-I-CORP-C-COMT-DSTCD
  MOVE '05' TO XQIPA653-I-CORP-C-COMT-DSTCD
  ```

### 6.3 기능 구현

- **F-025-001:** AIP4A65.cbl 200-230행에 구현 (S3000-PROCESS-RTN - 사업분석 조회 조정)
  ```cobol
  S3000-PROCESS-RTN.
      INITIALIZE XDIPA651-IN
      MOVE YNIP4A65-CA TO XDIPA651-IN
      #DYCALL DIPA651 YCCOMMON-CA XDIPA651-CA
      MOVE XDIPA651-OUT TO YPIP4A65-CA
  S3000-PROCESS-EXT.
  ```

- **F-025-002:** DIPA651.cbl 230-330행에 구현 (S3100-QIPA651-CALL-RTN - 재무분석 데이터 조회)
  ```cobol
  S3100-QIPA651-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA651-IN XQIPA651-OUT
      MOVE BICOM-GROUP-CO-CD TO XQIPA651-I-GROUP-CO-CD
      MOVE XDIPA651-I-CORP-CLCT-GROUP-CD TO XQIPA651-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA651-I-CORP-CLCT-REGI-CD TO XQIPA651-I-CORP-CLCT-REGI-CD
      MOVE XDIPA651-I-VALUA-YMD TO XQIPA651-I-VALUA-YMD
      #DYSQLA QIPA651 SELECT XQIPA651-CA
  S3100-QIPA651-CALL-EXT.
  ```

- **F-025-003:** DIPA651.cbl 340-400행에 구현 (S3200-QIPA652-CALL-RTN - 최신 주석 조회)
  ```cobol
  S3200-QIPA652-CALL-RTN.
      INITIALIZE YCDBSQLA-CA XQIPA652-IN XQIPA652-OUT
      MOVE BICOM-GROUP-CO-CD TO XQIPA652-I-GROUP-CO-CD
      MOVE XDIPA651-I-CORP-CLCT-GROUP-CD TO XQIPA652-I-CORP-CLCT-GROUP-CD
      MOVE '05' TO XQIPA652-I-CORP-C-COMT-DSTCD
      #DYSQLA QIPA652 SELECT XQIPA652-CA
  S3200-QIPA652-CALL-EXT.
  ```

- **F-025-004:** DIPA651.cbl 290-330행에 구현 (데이터 집계 및 형식화)
  ```cobol
  PERFORM VARYING WK-I FROM 1 BY 1
          UNTIL WK-I > XDIPA651-O-PRSNT-NOITM1
      MOVE XQIPA651-O-FNAF-A-RPTDOC-DSTCD(WK-I) TO XDIPA651-O-FNAF-A-RPTDOC-DSTCD(WK-I)
      MOVE XQIPA651-O-FNAF-ITEM-CD(WK-I) TO XDIPA651-O-FNAF-ITEM-CD(WK-I)
      MOVE XQIPA651-O-BIZ-SECT-NO(WK-I) TO XDIPA651-O-BIZ-SECT-NO(WK-I)
      MOVE XQIPA651-O-BASE-YR-ITEM-AMT(WK-I) TO XDIPA651-O-BASE-YR-ITEM-AMT(WK-I)
  END-PERFORM
  ```

### 6.4 데이터베이스 테이블
- **THKIPB113**: 사업구조 데이터를 위한 기업집단 재무분석 목록 테이블
- **THKIPB130**: 분석 주석을 위한 기업집단 주석 명세 테이블

### 6.5 오류 코드
- **B3000070**: 처리구분코드 검증 오류
- **B3800004**: 필수 필드 검증 오류
- **B3900009**: 데이터 조회 오류
- **UKIP0001**: 기업집단그룹코드 입력 필요 메시지
- **UKIP0002**: 기업집단등록코드 입력 필요 메시지
- **UKIP0003**: 평가일자 입력 필요 메시지

### 6.6 기술 아키텍처
- COBOL 프로그램을 사용한 온라인 트랜잭션 처리 시스템
- SQL 프로그램을 통한 DB2 데이터베이스 접근 (QIPA651, QIPA652, QIPA653)
- 공통 처리를 위한 프레임워크 구성요소 (IJICOMM, YCCOMMON)
- 카피북 기반 데이터 구조 정의
- 프레임워크 오류 관리를 통한 오류 처리

### 6.7 데이터 흐름 아키텍처
1. **입력 처리**: AIP4A65가 YNIP4A65 카피북을 통해 조회 매개변수를 수신
2. **프레임워크 통합**: IJICOMM 및 YCCOMMON이 공통 처리 서비스를 제공
3. **데이터베이스 조정**: DIPA651이 처리 분류에 따라 데이터베이스 접근을 조정
4. **재무데이터 경로**: QIPA651이 사업구조분석 데이터를 위해 THKIPB113을 조회
5. **주석데이터 경로**: QIPA652/QIPA653이 처리 유형에 따라 THKIPB130을 조회
6. **결과 조립**: DIPA651이 조회 결과를 XDIPA651 출력 구조로 조립
7. **출력 생성**: AIP4A65가 최종 결과를 YPIP4A65 카피북 구조로 형식화
8. **프레임워크 완료**: XZUGOTMY가 출력 영역 관리 및 트랜잭션 완료를 처리
