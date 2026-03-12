# 업무 명세서: 기업집단합산연결재무비율조회시스템 (Corporate Group Consolidated Financial Ratio Inquiry System)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-040
- **진입점:** AIP4A58
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 거래처리 도메인에서 포괄적인 온라인 기업집단 합산연결재무비율 조회시스템을 구현합니다. 이 시스템은 실시간 기업집단 재무분석 기능을 제공하며, 자동화된 데이터베이스 검색 및 결과 집계 기능을 통한 다차원 재무비율 계산을 지원하여 기업집단 재무평가 및 비율 결정을 수행합니다.

업무 목적은 다음과 같습니다:
- 다차원 분석 지원을 통한 포괄적 기업집단 합산연결재무비율 조회 제공 (Provide comprehensive corporate group consolidated financial ratio inquiry with multi-dimensional analysis support)
- 기업집단 평가를 위한 합산 및 개별 재무비율의 실시간 계산 및 관리 지원 (Support real-time calculation and management of consolidated and separate financial ratios for corporate group evaluation)
- 합산계산 및 과거추세 분석을 통한 구조화된 재무비율 결정 지원 (Enable structured financial ratio determination with consolidated calculation and historical trend analysis)
- 자동 검증 및 트랜잭션 데이터베이스 운영을 통한 데이터 무결성 유지 (Maintain data integrity through automated validation and transactional database operations)
- 최적화된 데이터베이스 접근 및 배치 운영을 통한 확장 가능한 비율처리 제공 (Provide scalable ratio processing through optimized database access and batch operations)
- 구조화된 재무평가 문서화 및 감사추적 유지를 통한 규제 준수 지원 (Support regulatory compliance through structured financial evaluation documentation and audit trail maintenance)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIP4A58 → IJICOMM → YCCOMMON → XIJICOMM → DIPA581 → RIPA121 → YCDBIOCA → YCCSICOM → YCCBICOM → QIPA581 → YCDBSQLA → XQIPA581 → QIPA585 → XQIPA585 → QIPA583 → XQIPA583 → QIPA584 → XQIPA584 → TRIPC121 → TKIPC121 → TRIPC131 → TKIPC131 → XDIPA581 → XZUGOTMY → YNIP4A58 → YPIP4A58, 기업집단 파라미터 검증, 재무비율 처리, 다중 테이블 데이터베이스 운영, 결과 집계 운영을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 필수필드 검증을 포함한 기업집단 파라미터 검증 (Corporate group parameter validation with mandatory field verification)
- 합산 및 개별 비율처리 및 결합결과 계산을 포함한 다차원 재무비율 계산 (Multi-dimensional financial ratio calculation with consolidated and separate ratio processing and combined result calculation)
- 다년도 기반 추세계산 및 비교를 포함한 과거 재무비율 결정 (Historical financial ratio determination with trend calculation and comparison based on multiple years)
- 조정된 선택, 조인, 집계 처리를 통한 트랜잭션 데이터베이스 운영 (Transactional database operations through coordinated select, join, and aggregation processing)
- 처리단계 관리를 포함한 재무평가 단계 추적 및 업데이트 (Financial evaluation stage tracking and update with processing stage management)
- 기업집단 재무평가 지원을 위한 처리결과 최적화 및 감사추적 유지 (Processing result optimization and audit trail maintenance for corporate group financial assessment support)
## 2. 업무 엔티티

### BE-040-001: 기업집단재무조회요청 (Corporate Group Financial Inquiry Request)
- **설명:** 다차원 분석 지원을 통한 기업집단 합산연결재무비율 조회 운영을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIP4A58-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A58-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 재무제표구분 (Financial Statement Classification) | String | 2 | NOT NULL | 재무제표 유형 분류 | YNIP4A58-FNST-DSTIC | fnstDstic |
| 재무분석결산구분코드 (Financial Analysis Settlement Classification) | String | 1 | NOT NULL | 재무분석 결산 유형 | YNIP4A58-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| 기준년 (Base Year) | String | 4 | YYYY 형식 | 재무분석 기준년도 | YNIP4A58-BASE-YR | baseYr |
| 분석기간 (Analysis Period) | String | 1 | NOT NULL | 분석기간 분류 | YNIP4A58-ANLS-TRM | anlsTrm |
| 재무분석보고서구분코드1 (Financial Analysis Report Classification 1) | String | 2 | NOT NULL | 첫 번째 재무분석 보고서 유형 | YNIP4A58-FNAF-A-RPTDOC-DST1 | fnafARptdocDst1 |
| 재무분석보고서구분코드2 (Financial Analysis Report Classification 2) | String | 2 | NOT NULL | 두 번째 재무분석 보고서 유형 | YNIP4A58-FNAF-A-RPTDOC-DST2 | fnafARptdocDst2 |

- **검증 규칙:**
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 재무제표구분은 필수이며 공백일 수 없음
  - 재무분석결산구분코드는 필수이며 공백일 수 없음
  - 기준년은 필수이며 YYYY 형식이어야 함
  - 분석기간은 필수이며 유효한 숫자값이어야 함
  - 재무분석보고서구분코드들은 필수이며 공백일 수 없음

### BE-040-002: 기업집단재무비율결과 (Corporate Group Financial Ratio Result)
- **설명:** 계산 세부사항을 포함한 기업집단 합산연결재무비율 조회의 출력 결과
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 현재건수1 (Current Item Count 1) | Numeric | 5 | NOT NULL | 합산비율 항목의 현재 건수 | YPIP4A58-PRSNT-NOITM1 | prsntNoitm1 |
| 총건수1 (Total Item Count 1) | Numeric | 5 | NOT NULL | 합산비율 항목의 총 건수 | YPIP4A58-TOTAL-NOITM1 | totalNoitm1 |
| 현재건수2 (Current Item Count 2) | Numeric | 5 | NOT NULL | 개별비율 항목의 현재 건수 | YPIP4A58-PRSNT-NOITM2 | prsntNoitm2 |
| 총건수2 (Total Item Count 2) | Numeric | 5 | NOT NULL | 개별비율 항목의 총 건수 | YPIP4A58-TOTAL-NOITM2 | totalNoitm2 |
| 결산년 (Settlement Year) | String | 4 | YYYY 형식 | 재무데이터의 결산년도 | YPIP4A58-STLACC-YR | stlaccYr |
| 결산년합계업체수 (Settlement Year Total Enterprise Count) | Numeric | 9 | NOT NULL | 결산년도의 총 업체수 | YPIP4A58-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| 결산년도 (Settlement Year) | String | 4 | YYYY 형식 | 비율계산의 결산년도 | YPIP4A58-STLACCZ-YR | stlacczYr |
| 재무항목명 (Financial Item Name) | String | 102 | NOT NULL | 재무항목 설명 | YPIP4A58-FNAF-ITEM-NAME | fnafItemName |
| 기업집단재무비율 (Corporate Group Financial Ratio) | Numeric | 7 | 5자리 + 소수점 2자리 | 계산된 재무비율 값 | YPIP4A58-CORP-CLCT-FNAF-RATO | corpClctFnafRato |
| 분석지표분류구분코드 (Analysis Indicator Classification) | String | 2 | NOT NULL | 분석지표 분류 | YPIP4A58-ANLS-I-CLSFI-DSTCD | anlsIClsfiDstcd |

- **검증 규칙:**
  - 모든 건수 필드는 음이 아닌 숫자값이어야 함
  - 결산년도는 YYYY 형식이어야 함
  - 재무비율은 소수점 2자리를 가진 유효한 숫자값이어야 함
  - 재무항목명은 공백일 수 없음
  - 분석지표분류구분코드는 유효한 코드여야 함

### BE-040-003: 기업집단합산연결재무비율 (Corporate Group Consolidated Financial Ratio)
- **설명:** 상세 계산을 포함한 기업집단 합산연결재무비율의 데이터베이스 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPC131-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPC131-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPC131-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 재무분석결산구분 (Financial Analysis Settlement Classification) | String | 1 | NOT NULL | 재무분석 결산 유형 | RIPC131-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| 기준년 (Base Year) | String | 4 | YYYY 형식 | 분석 기준년도 | RIPC131-BASE-YR | baseYr |
| 결산년 (Settlement Year) | String | 4 | YYYY 형식 | 데이터 결산년도 | RIPC131-STLACC-YR | stlaccYr |
| 재무분석보고서구분 (Financial Analysis Report Classification) | String | 2 | NOT NULL | 재무분석 보고서 유형 | RIPC131-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| 재무항목코드 (Financial Item Code) | String | 4 | NOT NULL | 재무항목 식별자 | RIPC131-FNAF-ITEM-CD | fnafItemCd |
| 기업집단재무비율 (Corporate Group Financial Ratio) | Numeric | 7 | 5자리 + 소수점 2자리 | 계산된 합산비율 | RIPC131-CORP-CLCT-FNAF-RATO | corpClctFnafRato |
| 분자값 (Numerator Value) | Numeric | 15 | NOT NULL | 비율계산의 분자 | RIPC131-NMRT-VAL | nmrtVal |
| 분모값 (Denominator Value) | Numeric | 15 | NOT NULL | 비율계산의 분모 | RIPC131-DNMN-VAL | dnmnVal |
| 결산년합계업체수 (Settlement Year Total Enterprise Count) | Numeric | 9 | NOT NULL | 총 업체수 | RIPC131-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |

- **검증 규칙:**
  - 모든 키 필드는 고유 레코드 식별을 위해 필수임
  - 재무비율은 분자와 분모값으로부터 계산됨
  - 업체수는 양의 숫자값이어야 함
  - 결산년도와 기준년도는 유효한 YYYY 형식이어야 함

### BE-040-004: 기업집단합산재무비율 (Corporate Group Separate Financial Ratio)
- **설명:** 개별 계산을 포함한 기업집단 개별재무비율의 데이터베이스 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPC121-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPC121-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPC121-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 재무분석결산구분 (Financial Analysis Settlement Classification) | String | 1 | NOT NULL | 재무분석 결산 유형 | RIPC121-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| 기준년 (Base Year) | String | 4 | YYYY 형식 | 분석 기준년도 | RIPC121-BASE-YR | baseYr |
| 결산년 (Settlement Year) | String | 4 | YYYY 형식 | 데이터 결산년도 | RIPC121-STLACC-YR | stlaccYr |
| 재무분석보고서구분 (Financial Analysis Report Classification) | String | 2 | NOT NULL | 재무분석 보고서 유형 | RIPC121-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| 재무항목코드 (Financial Item Code) | String | 4 | NOT NULL | 재무항목 식별자 | RIPC121-FNAF-ITEM-CD | fnafItemCd |
| 재무분석자료원구분 (Financial Analysis Data Source Classification) | String | 1 | NOT NULL | 재무분석 자료원 유형 | RIPC121-FNAF-AB-ORGL-DSTCD | fnafAbOrglDstcd |
| 기업집단재무비율 (Corporate Group Financial Ratio) | Numeric | 7 | 5자리 + 소수점 2자리 | 계산된 개별비율 | RIPC121-CORP-CLCT-FNAF-RATO | corpClctFnafRato |
| 분자값 (Numerator Value) | Numeric | 15 | NOT NULL | 비율계산의 분자 | RIPC121-NMRT-VAL | nmrtVal |
| 분모값 (Denominator Value) | Numeric | 15 | NOT NULL | 비율계산의 분모 | RIPC121-DNMN-VAL | dnmnVal |
| 결산년합계업체수 (Settlement Year Total Enterprise Count) | Numeric | 9 | NOT NULL | 총 업체수 | RIPC121-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |

- **검증 규칙:**
  - 모든 키 필드는 고유 레코드 식별을 위해 필수임
  - 재무비율은 분자와 분모값으로부터 계산됨
  - 자료원구분은 계산방법을 결정함
  - 업체수는 양의 숫자값이어야 함
## 3. 업무 규칙

### BR-040-001: 기업집단코드검증 (Corporate Group Code Validation)
- **설명:** 재무비율 조회 운영을 위한 기업집단코드 검증
- **조건:** 기업집단코드가 제공될 때 공백이거나 스페이스가 아니어야 함
- **관련 엔티티:** BE-040-001
- **예외사항:** 공백이거나 스페이스 값은 오류 B3600552와 처리코드 UKII0282를 발생시킴

### BR-040-002: 기준년검증 (Base Year Validation)
- **설명:** 재무분석 기간 결정을 위한 기준년 검증
- **조건:** 기준년이 제공될 때 공백이 아니고 YYYY 형식이어야 함
- **관련 엔티티:** BE-040-001, BE-040-003, BE-040-004
- **예외사항:** 공백 값은 오류 B2700460과 처리코드 UKII0055를 발생시킴

### BR-040-003: 재무분석결산구분검증 (Financial Analysis Settlement Classification Validation)
- **설명:** 적절한 데이터 분류를 위한 재무분석결산구분 검증
- **조건:** 결산구분이 제공될 때 공백이거나 스페이스가 아니어야 함
- **관련 엔티티:** BE-040-001, BE-040-003, BE-040-004
- **예외사항:** 공백이거나 스페이스 값은 오류 B3000108과 처리코드 UKII0299를 발생시킴

### BR-040-004: 재무분석보고서구분검증 (Financial Analysis Report Classification Validation)
- **설명:** 적절한 보고서 분류를 위한 재무분석보고서구분 검증
- **조건:** 보고서구분이 제공될 때 DST1과 DST2 모두 공백이거나 스페이스가 아니어야 함
- **관련 엔티티:** BE-040-001, BE-040-003, BE-040-004
- **예외사항:** 공백이거나 스페이스 값은 오류 B3002107과 처리코드 UKII0297을 발생시킴

### BR-040-005: 분석기간검증 (Analysis Period Validation)
- **설명:** 재무비율 계산 범위를 위한 분석기간 검증
- **조건:** 분석기간이 제공될 때 0이 아니고 유효한 숫자값이어야 함
- **관련 엔티티:** BE-040-001
- **예외사항:** 0이거나 유효하지 않은 값은 오류 B3000661과 처리코드 UKII0361을 발생시킴

### BR-040-006: 재무비율계산규칙 (Financial Ratio Calculation Rule)
- **설명:** 기업집단 재무비율의 계산 방법론 정의
- **조건:** 재무비율 계산 시 분자를 분모로 나누어 소수점 2자리 정밀도로 계산
- **관련 엔티티:** BE-040-003, BE-040-004
- **예외사항:** 0으로 나누기는 null 또는 0 비율값을 결과로 함

### BR-040-007: 합산대개별처리규칙 (Consolidated vs Separate Processing Rule)
- **설명:** 재무제표구분에 기반한 처리유형 결정
- **조건:** 처리구분이 '01'일 때 합산비율 처리, '02'일 때 개별비율 처리
- **관련 엔티티:** BE-040-003, BE-040-004
- **예외사항:** 유효하지 않은 처리구분은 데이터 처리 없음을 결과로 함

### BR-040-008: 결산년정렬규칙 (Settlement Year Ordering Rule)
- **설명:** 결산년 데이터 표시를 위한 정렬 방법론 정의
- **조건:** 결산년 데이터 검색 시 처리구분과 결산년 내림차순으로 정렬
- **관련 엔티티:** BE-040-002, BE-040-003, BE-040-004
- **예외사항:** 정렬 운영에 대한 특별한 예외사항 없음

### BR-040-009: 업체수집계규칙 (Enterprise Count Aggregation Rule)
- **설명:** 업체수 계산을 위한 집계 방법론 정의
- **조건:** 업체수 계산 시 결산년과 그룹분류별로 집계
- **관련 엔티티:** BE-040-002, BE-040-003, BE-040-004
- **예외사항:** 누락된 업체 데이터는 0 건수값을 결과로 함

### BR-040-010: 데이터조회제한규칙 (Data Retrieval Limit Rule)
- **설명:** 성능 최적화를 위한 최대 데이터 검색 제한 정의
- **조건:** 재무비율 데이터 검색 시 쿼리당 최대 6000건으로 결과 제한
- **관련 엔티티:** BE-040-002
- **예외사항:** 제한 초과는 잘린 결과 집합을 결과로 함

### BR-040-011: 재무항목분류규칙 (Financial Item Classification Rule)
- **설명:** 재무항목과 지표의 분류 방법론 정의
- **조건:** 재무항목 처리 시 분석지표유형별로 분류하고 순차적 정렬 유지
- **관련 엔티티:** BE-040-002
- **예외사항:** 유효하지 않은 분류는 기본 분류를 결과로 함

### BR-040-012: 과거데이터접근규칙 (Historical Data Access Rule)
- **설명:** 과거 재무비율 데이터의 접근 방법론 정의
- **조건:** 과거 데이터 접근 시 기준년과 분석기간 파라미터에 기반하여 검색
- **관련 엔티티:** BE-040-003, BE-040-004
- **예외사항:** 누락된 과거 데이터는 빈 결과 집합을 결과로 함
## 4. 업무 기능

### F-040-001: 기업집단재무조회초기화 (Corporate Group Financial Inquiry Initialization)
- **기능명:** 기업집단재무조회초기화기능 (Corporate Group Financial Inquiry Initialization Function)
- **설명:** 파라미터 검증 및 시스템 설정을 통한 기업집단 재무비율 조회 처리 초기화

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록코드 |
| fnstDstic | String | 2 | 재무제표 구분 |
| fnafAStlaccDstcd | String | 1 | 재무분석 결산구분 |
| baseYr | String | 4 | 분석 기준년도 |
| anlsTrm | String | 1 | 분석기간 |
| fnafARptdocDst1 | String | 2 | 재무분석 보고서구분 1 |
| fnafARptdocDst2 | String | 2 | 재무분석 보고서구분 2 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| initializationStatus | String | 2 | 초기화 완료 상태 |
| validationResult | String | 2 | 파라미터 검증 결과 |
| systemSetupStatus | String | 2 | 시스템 설정 완료 상태 |

#### 처리 로직
1. 작업 저장소 영역과 출력 파라미터 초기화
2. 업무 규칙에 따른 모든 필수 입력 파라미터 검증
3. 비계약 업무 처리를 위한 공통 영역 파라미터 설정
4. 데이터베이스 연결 및 트랜잭션 컨텍스트 초기화
5. 재무비율 처리를 위한 시스템 환경 준비
6. 초기화 상태 및 검증 결과 반환

### F-040-002: 기업집단파라미터검증 (Corporate Group Parameter Validation)
- **기능명:** 기업집단파라미터검증기능 (Corporate Group Parameter Validation Function)
- **설명:** 기업집단 재무비율 조회 운영을 위한 입력 파라미터 검증

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류코드 |
| baseYr | String | 4 | 분석 기준년도 |
| fnafAStlaccDstcd | String | 1 | 재무분석 결산구분 |
| fnafARptdocDst1 | String | 2 | 재무분석 보고서구분 1 |
| fnafARptdocDst2 | String | 2 | 재무분석 보고서구분 2 |
| anlsTrm | Numeric | 1 | 분석기간 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| validationStatus | String | 2 | 전체 검증 상태 |
| errorCode | String | 8 | 검증 실패 시 오류코드 |
| treatmentCode | String | 8 | 오류 처리를 위한 처리코드 |

#### 처리 로직
1. 기업집단코드가 공백이거나 스페이스가 아닌지 검증
2. 기준년이 공백이 아니고 YYYY 형식인지 검증
3. 재무분석결산구분이 공백이 아닌지 검증
4. 재무분석보고서구분들이 공백이 아닌지 검증
5. 분석기간이 0이 아니고 유효한 숫자인지 검증
6. 검증 실패 시 적절한 오류코드와 함께 검증 상태 반환

### F-040-003: 합산재무비율처리 (Consolidated Financial Ratio Processing)
- **기능명:** 합산재무비율처리기능 (Consolidated Financial Ratio Processing Function)
- **설명:** 기업집단 분석을 위한 합산재무비율 처리

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록코드 |
| fnafAStlaccDstcd | String | 1 | 재무분석 결산구분 |
| baseYr | String | 4 | 분석 기준년도 |
| processingType | String | 2 | 처리 유형 분류 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| settlementYears | Array | Variable | 업체수를 포함한 결산년도 목록 |
| consolidatedRatios | Array | Variable | 합산재무비율 |
| processingStatus | String | 2 | 처리 완료 상태 |

#### 처리 로직
1. THKIPC131 테이블에서 합산재무비율 데이터 조회
2. 지정된 파라미터에 대한 결산년도 및 업체수 조회
3. 분자 및 분모 값을 기반으로 합산비율 계산
4. 처리구분 및 결산년도 내림차순으로 결과 정렬
5. 성능 최적화를 위한 데이터 조회 제한 적용
6. 결산년도 정보와 함께 합산비율 결과 반환

### F-040-004: 개별재무비율처리 (Separate Financial Ratio Processing)
- **기능명:** 개별재무비율처리기능 (Separate Financial Ratio Processing Function)
- **설명:** 기업집단 분석을 위한 개별재무비율 처리

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록코드 |
| fnafAStlaccDstcd | String | 1 | 재무분석 결산구분 |
| baseYr | String | 4 | 분석 기준년도 |
| processingType | String | 2 | 처리 유형 분류 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| settlementYears | Array | Variable | 업체수를 포함한 결산년도 목록 |
| separateRatios | Array | Variable | 개별재무비율 |
| processingStatus | String | 2 | 처리 완료 상태 |

#### 처리 로직
1. THKIPC121 테이블에서 개별재무비율 데이터 조회
2. 지정된 파라미터에 대한 결산년도 및 업체수 조회
3. 분자 및 분모 값을 기반으로 개별비율 계산
4. 처리 로직에 데이터 소스 분류 포함
5. 처리구분 및 결산년도 내림차순으로 결과 정렬
6. 결산년도 정보와 함께 개별비율 결과 반환

### F-040-005: 재무항목메타데이터조회 (Financial Item Metadata Retrieval)
- **기능명:** 재무항목메타데이터조회기능 (Financial Item Metadata Retrieval Function)
- **설명:** 비율 처리를 위한 재무항목 메타데이터 및 계산공식 조회

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| groupCoCd | String | 3 | 그룹회사코드 |
| fnafARptdocDstcd | String | 2 | 재무분석 보고서분류 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| financialItems | Array | Variable | 재무항목 메타데이터 |
| calculationFormulas | Array | Variable | 항목별 계산공식 |
| classificationData | Array | Variable | 분석지표 분류 |

#### 처리 로직
1. THKIIMD10, THKIIMB16, THKIIMB18, THKIIMB11 테이블에서 재무항목 메타데이터 조회
2. 재무항목명 및 계산공식 조회
3. 분석지표 분류 및 비교유형 조회
4. 분석지표 분류 및 순서번호별 결과 정렬
5. 성능 최적화를 위한 최대 레코드 제한 적용
6. 포괄적인 재무항목 메타데이터 반환

### F-040-006: 재무비율계산엔진 (Financial Ratio Calculation Engine)
- **기능명:** 재무비율계산엔진기능 (Financial Ratio Calculation Engine Function)
- **설명:** 수학적 공식 및 업무규칙을 사용한 재무비율 계산

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| numeratorValue | Numeric | 15 | 비율 계산을 위한 분자값 |
| denominatorValue | Numeric | 15 | 비율 계산을 위한 분모값 |
| calculationFormula | String | 50 | 계산을 위한 수학적 공식 |
| precisionDigits | Numeric | 2 | 결과의 소수점 정밀도 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| calculatedRatio | Numeric | 7 | 계산된 재무비율 |
| calculationStatus | String | 2 | 계산 완료 상태 |
| errorIndicator | String | 1 | 잘못된 계산에 대한 오류 지시자 |

#### 처리 로직
1. 분자 및 분모 값이 숫자인지 검증
2. 0으로 나누기 조건 확인
3. 비율 계산을 위한 수학적 공식 적용
4. 지정된 소수점 정밀도로 결과 반올림
5. 계산 오류 및 예외 상황 처리
6. 상태 지시자와 함께 계산된 비율 반환

### F-040-007: 결과집계및형식화 (Result Aggregation and Formatting)
- **기능명:** 결과집계및형식화기능 (Result Aggregation and Formatting Function)
- **설명:** 출력 표시를 위한 재무비율 결과 집계 및 형식화

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| consolidatedResults | Array | Variable | 합산재무비율 결과 |
| separateResults | Array | Variable | 개별재무비율 결과 |
| formatSpecification | String | 10 | 출력 형식 사양 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| formattedResults | Object | Variable | 형식화된 출력 결과 |
| summaryStatistics | Object | Variable | 요약 통계 및 건수 |
| presentationData | Array | Variable | 표시용으로 형식화된 데이터 |

#### 처리 로직
1. 합산 및 개별 재무비율 결과 집계
2. 항목 건수를 포함한 요약 통계 계산
3. 표시 요구사항에 따른 숫자 값 형식화
4. 결산년도 및 재무항목 범주별 데이터 구성
5. 재무비율에 대한 업무 형식화 규칙 적용
6. 출력 표시 준비가 완료된 형식화된 결과 반환

### F-040-008: 결산년데이터처리 (Settlement Year Data Processing)
- **기능명:** 결산년데이터처리기능 (Settlement Year Data Processing Function)
- **설명:** 업체수 집계를 포함한 결산년 데이터 처리

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록코드 |
| fnafAStlaccDstcd | String | 1 | 재무분석 결산구분 |
| baseYr | String | 4 | 분석 기준년도 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| settlementYearList | Array | Variable | 결산년도 목록 |
| enterpriseCountList | Array | Variable | 결산년도별 업체수 |
| processingResult | String | 2 | 처리 결과 상태 |

#### 처리 로직
1. 재무비율 테이블에서 고유한 결산년도 조회
2. 각 결산년도별 업체수 계산
3. 업체수 계산을 위한 집계 규칙 적용
4. 결산년도를 시간순 내림차순으로 정렬
5. 결산기간 전반에 걸친 데이터 일관성 검증
6. 업체수와 함께 결산년도 데이터 반환

### F-040-009: 재무분석보고서처리 (Financial Analysis Report Processing)
- **기능명:** 재무분석보고서처리기능 (Financial Analysis Report Processing Function)
- **설명:** 분류 처리를 포함한 재무분석 보고서 데이터 처리

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| fnafARptdocDst1 | String | 2 | 재무분석 보고서분류 1 |
| fnafARptdocDst2 | String | 2 | 재무분석 보고서분류 2 |
| groupCoCd | String | 3 | 그룹회사코드 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| reportClassifications | Array | Variable | 보고서 분류 데이터 |
| analysisIndicators | Array | Variable | 분석지표 분류 |
| reportMetadata | Object | Variable | 보고서 메타데이터 정보 |

#### 처리 로직
1. 재무분석 보고서 분류 검증
2. 분류 테이블에서 보고서 메타데이터 조회
3. 분석지표 분류 조회
4. 보고서 유형별 특정 로직 처리
5. 분류 검증 규칙 적용
6. 메타데이터와 함께 보고서 처리 결과 반환

### F-040-010: 데이터베이스트랜잭션관리 (Database Transaction Management)
- **기능명:** 데이터베이스트랜잭션관리기능 (Database Transaction Management Function)
- **설명:** 재무비율 처리 운영을 위한 데이터베이스 트랜잭션 관리

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| transactionType | String | 2 | 트랜잭션 유형 분류 |
| isolationLevel | String | 2 | 트랜잭션 격리 수준 |
| timeoutValue | Numeric | 5 | 트랜잭션 타임아웃(초) |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| transactionId | String | 20 | 고유 트랜잭션 식별자 |
| transactionStatus | String | 2 | 트랜잭션 상태 지시자 |
| commitResult | String | 2 | 커밋 운영 결과 |

#### 처리 로직
1. 데이터베이스 트랜잭션 컨텍스트 초기화
2. 데이터 일관성을 위한 적절한 격리 수준 설정
3. 트랜잭션 타임아웃 및 리소스 사용량 모니터링
4. 오류 조건에서 트랜잭션 롤백 처리
5. ACID 속성을 통한 데이터 무결성 보장
6. 트랜잭션 관리 결과 반환

### F-040-011: 오류처리및복구 (Error Handling and Recovery)
- **기능명:** 오류처리및복구기능 (Error Handling and Recovery Function)
- **설명:** 포괄적인 오류 처리 및 복구 메커니즘 제공

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| errorCode | String | 8 | 시스템 또는 업무 오류코드 |
| errorContext | String | 100 | 오류 컨텍스트 정보 |
| recoveryOption | String | 2 | 복구 옵션 사양 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| treatmentCode | String | 8 | 오류 처리코드 |
| recoveryStatus | String | 2 | 복구 운영 상태 |
| errorMessage | String | 200 | 상세 오류 메시지 |

#### 처리 로직
1. 오류코드 분석 및 오류 범주 결정
2. 적절한 오류 처리 전략 적용
3. 가능한 경우 자동 복구 시도
4. 감사 및 디버깅을 위한 오류 세부사항 로깅
5. 사용자 친화적인 오류 메시지 제공
6. 오류 처리 및 복구 상태 반환

### F-040-012: 성능최적화 (Performance Optimization)
- **기능명:** 성능최적화기능 (Performance Optimization Function)
- **설명:** 쿼리 최적화 및 리소스 관리를 통한 시스템 성능 최적화

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| queryType | String | 2 | 쿼리 유형 분류 |
| recordLimit | Numeric | 5 | 최대 레코드 조회 제한 |
| optimizationLevel | String | 1 | 최적화 수준 설정 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| optimizedQuery | String | 1000 | 최적화된 SQL 쿼리 |
| performanceMetrics | Object | Variable | 성능 측정 데이터 |
| resourceUsage | Object | Variable | 시스템 리소스 사용 통계 |

#### 처리 로직
1. 쿼리 패턴 및 실행 계획 분석
2. 쿼리 최적화 기법 적용
3. 대용량 데이터셋에 대한 결과 집합 제한 구현
4. 시스템 리소스 활용도 모니터링
5. 자주 접근하는 데이터 캐싱
6. 최적화 결과 및 성능 메트릭 반환

### F-040-013: 데이터검증및무결성 (Data Validation and Integrity)
- **기능명:** 데이터검증및무결성기능 (Data Validation and Integrity Function)
- **설명:** 처리 전반에 걸쳐 데이터 검증 보장 및 데이터 무결성 유지

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| validationType | String | 2 | 검증 유형 사양 |
| dataContext | Object | Variable | 검증을 위한 데이터 컨텍스트 |
| integrityRules | Array | Variable | 데이터 무결성 규칙 집합 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| validationResult | String | 2 | 전체 검증 결과 |
| integrityStatus | String | 2 | 데이터 무결성 상태 |
| violationList | Array | Variable | 검증 위반 목록 |

#### 처리 로직
1. 입력 데이터에 업무 규칙 검증 적용
2. 데이터 형식 및 내용 제약 조건 확인
3. 관련 엔티티 간 참조 무결성 검증
4. 숫자 범위 및 계산 검증
5. 처리 단계 전반에 걸친 데이터 일관성 보장
6. 위반 세부사항과 함께 검증 결과 반환

### F-040-014: 감사추적관리 (Audit Trail Management)
- **기능명:** 감사추적관리기능 (Audit Trail Management Function)
- **설명:** 재무비율 처리 운영에 대한 포괄적인 감사 추적 관리

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| operationType | String | 2 | 감사 로깅을 위한 운영 유형 |
| userId | String | 20 | 감사 추적을 위한 사용자 식별자 |
| operationData | Object | Variable | 감사 로깅을 위한 운영 데이터 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| auditId | String | 20 | 고유 감사 추적 식별자 |
| auditStatus | String | 2 | 감사 로깅 상태 |
| auditTimestamp | String | 14 | 감사 운영 타임스탬프 |

#### 처리 로직
1. 감사 로깅을 위한 운영 세부사항 캡처
2. 사용자 접근 및 운영 타임스탬프 기록
3. 데이터 변경 및 업무 규칙 적용 로깅
4. 감사 추적 무결성 및 보안 유지
5. 감사 보고 및 규정 준수 요구사항 지원
6. 감사 추적 관리 결과 반환

### F-040-015: 시스템통합인터페이스 (System Integration Interface)
- **기능명:** 시스템통합인터페이스기능 (System Integration Interface Function)
- **설명:** 외부 시스템 통신을 위한 시스템 통합 인터페이스 제공

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| interfaceType | String | 2 | 인터페이스 유형 사양 |
| externalSystemId | String | 10 | 외부 시스템 식별자 |
| messageFormat | String | 10 | 메시지 형식 사양 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| interfaceResult | String | 2 | 인터페이스 운영 결과 |
| responseMessage | Object | Variable | 외부 시스템으로부터의 응답 메시지 |
| integrationStatus | String | 2 | 통합 상태 지시자 |

#### 처리 로직
1. 외부 시스템과의 연결 설정
2. 시스템 호환성을 위한 데이터 형식 변환
3. 메시지 라우팅 및 프로토콜 관리 처리
4. 통합 실패에 대한 오류 처리 구현
5. 통합 모니터링 및 로깅 유지
6. 통합 결과 및 상태 정보 반환

### F-040-016: 업무규칙엔진 (Business Rule Engine)
- **기능명:** 업무규칙엔진기능 (Business Rule Engine Function)
- **설명:** 재무비율 처리를 위한 업무 규칙 및 제약 조건 실행

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| ruleType | String | 2 | 업무 규칙 유형 분류 |
| ruleContext | Object | Variable | 규칙 실행 컨텍스트 |
| ruleParameters | Array | Variable | 규칙 파라미터 값 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| ruleResult | String | 2 | 규칙 실행 결과 |
| ruleViolations | Array | Variable | 규칙 위반 목록 |
| ruleMetrics | Object | Variable | 규칙 실행 메트릭 |

#### 처리 로직
1. 컨텍스트를 기반으로 적용 가능한 업무 규칙 로드
2. 규칙 검증 로직 실행
3. 업무 제약 조건 및 계산 적용
4. 규칙 충돌 및 우선순위 처리
5. 규칙 실행 결과 및 위반 로깅
6. 규칙 처리 결과 및 메트릭 반환

### F-040-004: 개별재무비율처리 (Separate Financial Ratio Processing)
- **설명:** 기업집단 분석을 위한 개별재무비율 처리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| corpClctGroupCd | String | 기업집단 분류코드 |
| corpClctRegiCd | String | 기업집단 등록코드 |
| fnafAStlaccDstcd | String | 재무분석 결산구분 |
| baseYr | String | 분석 기준년도 |
| processingType | String | 처리유형 분류 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| settlementYears | Array | 업체수를 포함한 결산년도 목록 |
| separateRatios | Array | 개별재무비율 |
| processingStatus | String | 처리 완료 상태 |

**처리 로직:**
1. THKIPC121 테이블에서 개별재무비율 데이터 조회
2. 지정된 파라미터에 대한 결산년도 및 업체수 검색
3. 분자와 분모값에 기반한 개별비율 계산
4. 처리 로직에 자료원구분 포함
5. 처리구분과 결산년도 내림차순으로 결과 정렬
6. 결산년도 정보와 함께 개별비율 결과 반환

### F-040-005: 재무항목메타데이터조회 (Financial Item Metadata Retrieval)
- **설명:** 비율 처리를 위한 재무항목 메타데이터 및 계산공식 검색

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사코드 |
| fnafARptdocDstcd | String | 재무분석 보고서구분 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| financialItems | Array | 재무항목 메타데이터 |
| calculationFormulas | Array | 항목별 계산공식 |
| classificationData | Array | 분석지표 분류 |

**처리 로직:**
1. THKIIMD10, THKIIMB16, THKIIMB18, THKIIMB11 테이블에서 재무항목 메타데이터 조회
2. 재무항목명과 계산공식 검색
3. 분석지표 분류 및 비교유형 획득
4. 분석지표분류와 순번으로 결과 정렬
5. 성능 최적화를 위한 최대 레코드 제한 적용
6. 포괄적인 재무항목 메타데이터 반환

### F-040-006: 재무비율계산엔진 (Financial Ratio Calculation Engine)
- **설명:** 수학공식과 업무규칙을 사용한 재무비율 계산

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| numeratorValue | Numeric | 비율계산을 위한 분자값 |
| denominatorValue | Numeric | 비율계산을 위한 분모값 |
| calculationFormula | String | 계산을 위한 수학공식 |
| precisionDigits | Numeric | 결과의 소수점 정밀도 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| calculatedRatio | Numeric | 계산된 재무비율 |
| calculationStatus | String | 계산 완료 상태 |
| errorIndicator | String | 유효하지 않은 계산에 대한 오류 지시자 |

**처리 로직:**
1. 분자와 분모값이 숫자인지 검증
2. 0으로 나누기 조건 확인
3. 비율계산을 위한 수학공식 적용
4. 지정된 소수점 정밀도로 결과 반올림
5. 계산 오류 및 예외 상황 처리
6. 상태 지시자와 함께 계산된 비율 반환

### F-040-007: 결과집계및형식화 (Result Aggregation and Formatting)
- **설명:** 출력 표시를 위한 재무비율 결과 집계 및 형식화

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| consolidatedResults | Array | 합산재무비율 결과 |
| separateResults | Array | 개별재무비율 결과 |
| formatSpecification | String | 출력 형식 명세 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| formattedResults | Object | 형식화된 출력 결과 |
| summaryStatistics | Object | 요약 통계 및 건수 |
| presentationData | Array | 표시용으로 형식화된 데이터 |

**처리 로직:**
1. 합산 및 개별재무비율 결과 집계
2. 항목 건수를 포함한 요약 통계 계산
3. 표시 요구사항에 따른 숫자값 형식화
4. 결산년도 및 재무항목 범주별 데이터 구성
5. 재무비율에 대한 업무 형식화 규칙 적용
6. 출력 표시를 위해 준비된 형식화된 결과 반환
## 5. 프로세스 흐름

```
기업집단 합산연결재무비율 조회 프로세스 흐름
├── F-040-001: 기업집단재무조회초기화
│   ├── 작업 저장소 및 출력 영역 초기화
│   ├── 필수 입력 파라미터 검증
│   ├── 비계약 업무 처리를 위한 공통 영역 설정
│   └── 재무 처리를 위한 시스템 환경 준비
├── F-040-002: 기업집단파라미터검증
│   ├── 기업집단코드 검증 (BR-040-001)
│   ├── 기준년 형식 및 내용 검증 (BR-040-002)
│   ├── 재무분석결산구분 검증 (BR-040-003)
│   ├── 재무분석보고서구분 검증 (BR-040-004)
│   └── 분석기간 숫자값 검증 (BR-040-005)
├── F-040-003: 합산재무비율처리
│   ├── 합산재무비율을 위한 THKIPC131 조회
│   ├── 결산년도 및 업체수 검색
│   ├── 재무비율계산규칙 적용 (BR-040-006)
│   ├── 합산대개별 처리 로직 (BR-040-007)
│   └── 결산년정렬규칙 적용 (BR-040-008)
├── F-040-004: 개별재무비율처리
│   ├── 개별재무비율을 위한 THKIPC121 조회
│   ├── 결산년도 및 업체수 검색
│   ├── 재무비율계산규칙 적용 (BR-040-006)
│   ├── 자료원구분 처리 포함
│   └── 업체수집계규칙 적용 (BR-040-009)
├── F-040-005: 재무항목메타데이터조회
│   ├── 다중 테이블에서 재무항목 메타데이터 조회
│   ├── 계산공식 및 분류 검색
│   ├── 데이터조회제한규칙 적용 (BR-040-010)
│   └── 재무항목분류규칙 처리 (BR-040-011)
├── F-040-006: 재무비율계산엔진
│   ├── 분자와 분모값을 사용한 비율 계산
│   ├── 정밀도 제어를 통한 수학공식 적용
│   ├── 0으로 나누기 및 오류 조건 처리
│   └── 상태 지시자와 함께 계산된 비율 반환
└── F-040-007: 결과집계및형식화
    ├── 합산 및 개별 결과 집계
    ├── 요약 통계 및 항목 건수 계산
    ├── 표시를 위한 숫자값 형식화
    └── 출력을 위한 형식화된 결과 반환
```

## 6. 레거시 구현 참조

### 소스 파일
- **AIP4A58.cbl**: 기업집단 합산연결재무비율 조회의 주 진입점
- **DIPA581.cbl**: 합산재무비율 처리를 위한 데이터베이스 컴포넌트
- **QIPA581.cbl**: 결산년도 및 업체수 검색을 위한 SQL 쿼리 컴포넌트
- **QIPA585.cbl**: 재무항목 메타데이터 검색을 위한 SQL 쿼리 컴포넌트
- **QIPA583.cbl**: 재무계산공식 처리를 위한 SQL 쿼리 컴포넌트
- **QIPA584.cbl**: 추가 재무데이터 처리를 위한 SQL 쿼리 컴포넌트
- **RIPA121.cbl**: 개별재무비율 처리를 위한 데이터베이스 컴포넌트
- **IJICOMM.cbl**: 시스템 초기화를 위한 공통 인터페이스 컴포넌트
- **YCCOMMON.cpy**: 시스템 파라미터를 위한 공통 영역 카피북
- **XIJICOMM.cpy**: 공통 처리를 위한 인터페이스 카피북
- **YCDBIOCA.cpy**: 데이터베이스 I/O 공통 영역 카피북
- **YCDBSQLA.cpy**: SQL 처리 공통 영역 카피북
- **YCCSICOM.cpy**: 공통 시스템 인터페이스 카피북
- **YCCBICOM.cpy**: 공통 업무 인터페이스 카피북
- **XZUGOTMY.cpy**: 출력 영역 관리 카피북
- **YNIP4A58.cpy**: 재무조회를 위한 입력 파라미터 카피북
- **YPIP4A58.cpy**: 재무조회 결과를 위한 출력 파라미터 카피북
- **XDIPA581.cpy**: 데이터베이스 컴포넌트 인터페이스 카피북
- **XQIPA581.cpy**: 결산데이터를 위한 SQL 쿼리 인터페이스 카피북
- **XQIPA585.cpy**: 재무메타데이터를 위한 SQL 쿼리 인터페이스 카피북
- **XQIPA583.cpy**: 계산공식을 위한 SQL 쿼리 인터페이스 카피북
- **XQIPA584.cpy**: 추가 처리를 위한 SQL 쿼리 인터페이스 카피북
- **TRIPC131.cpy**: 합산재무비율을 위한 테이블 카피북
- **TKIPC131.cpy**: 합산재무비율을 위한 테이블 키 카피북
- **TRIPC121.cpy**: 개별재무비율을 위한 테이블 카피북
- **TKIPC121.cpy**: 개별재무비율을 위한 테이블 키 카피북

### 업무 규칙 구현
- **BR-040-001**: AIP4A58.cbl 170-173행에 구현
  ```cobol
  IF YNIP4A58-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```
- **BR-040-002**: AIP4A58.cbl 180-183행에 구현
  ```cobol
  IF YNIP4A58-BASE-YR = SPACE
      #ERROR CO-B2700460 CO-UKII0055 CO-STAT-ERROR
  END-IF
  ```
- **BR-040-003**: AIP4A58.cbl 190-193행에 구현
  ```cobol
  IF YNIP4A58-FNAF-A-STLACC-DSTCD = SPACE
      #ERROR CO-B3000108 CO-UKII0299 CO-STAT-ERROR
  END-IF
  ```
- **BR-040-004**: AIP4A58.cbl 200-213행에 구현
  ```cobol
  IF YNIP4A58-FNAF-A-RPTDOC-DST1 = SPACE
      #ERROR CO-B3002107 CO-UKII0297 CO-STAT-ERROR
  END-IF
  IF YNIP4A58-FNAF-A-RPTDOC-DST2 = SPACE
      #ERROR CO-B3002107 CO-UKII0297 CO-STAT-ERROR
  END-IF
  ```
- **BR-040-005**: AIP4A58.cbl 220-223행에 구현
  ```cobol
  IF YNIP4A58-ANLS-TRM = 0
      #ERROR CO-B3000661 CO-UKII0361 CO-STAT-ERROR
  END-IF
  ```
- **BR-040-006**: DIPA581.cbl 계산 로직에 구현
  ```cobol
  COMPUTE WK-SANR-RAT = WK-SANR-AMT / DNMN-VAL
  ```
- **BR-040-007**: QIPA581.cbl SQL UNION 로직에 구현
  ```sql
  WHERE A.처리구분코드 = :XQIPA581-I-PRCSS-DSTCD
  ```
- **BR-040-008**: QIPA581.cbl ORDER BY 절에 구현
  ```sql
  ORDER BY A.처리구분코드, A.결산년 DESC
  ```
- **BR-040-009**: QIPA581.cbl SELECT DISTINCT 로직에 구현
  ```sql
  SELECT DISTINCT 결산년, 결산년합계업체수
  ```
- **BR-040-010**: DIPA581.cbl 819-822행에 구현
  ```cobol
  IF DBSQL-SELECT-CNT > CO-N6000 THEN
     MOVE CO-N6000 TO DBSQL-SELECT-CNT
  END-IF
  ```
- **BR-040-011**: QIPA585.cbl ORDER BY 절에 구현
  ```sql
  ORDER BY MB18.분석지표분류구분, MB16.재무조회일련번호
  ```
- **BR-040-012**: QIPA583.cbl 및 QIPA584.cbl 파라미터 필터링에 구현
  ```sql
  WHERE 기준년 = :XQIPA583-I-BASE-YR
  ```

### 기능 구현
- **F-040-001**: AIP4A58.cbl S1000-INITIALIZE-RTN 섹션 130-160행에 구현
  ```cobol
  INITIALIZE WK-AREA XIJICOMM-IN XZUGOTMY-IN
  #GETOUT YPIP4A58-CA
  MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD
  #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
  ```
- **F-040-002**: AIP4A58.cbl S2000-VALIDATION-RTN 섹션 165-225행에 구현
  ```cobol
  PERFORM S2000-VALIDATION-RTN THRU S2000-VALIDATION-EXT
  ```
- **F-040-003**: DIPA581.cbl 및 QIPA581.cbl 합산 처리에 구현
  ```cobol
  #DYSQLA QIPA581 SELECT XQIPA581-CA
  ```
- **F-040-004**: DIPA581.cbl 개별 처리 로직에 구현
  ```cobol
  PERFORM S3100-PROCESS-RTN THRU S3100-PROCESS-EXT
  ```
- **F-040-005**: QIPA585.cbl 재무 메타데이터 검색에 구현
  ```sql
  SELECT MD10.재무항목명, MB11.계산식구분, MB16.재무항목코드
  FROM THKIIMB16 MB16, THKIIMB18 MB18, THKIIMB11 MB11, THKIIMD10 MD10
  ```
- **F-040-006**: DIPA581.cbl 계산 엔진 섹션에 구현
  ```cobol
  PERFORM S4000-CALC-RTN THRU S4000-CALC-EXT
  ```
- **F-040-007**: AIP4A58.cbl 출력 파라미터 조립에 구현
  ```cobol
  MOVE XDIPA581-OUT TO YPIP4A58-CA
  ```

### 데이터베이스 테이블
- **THKIPC131**: 기업집단 합산연결재무비율
- **THKIPC121**: 기업집단 개별재무비율
- **THKIIMB16**: 재무항목 마스터
- **THKIIMB18**: 재무분석지표 분류
- **THKIIMB11**: 재무계산공식
- **THKIIMD10**: 재무항목 설명

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
- **AS Layer**: AIP4A58 - 기업집단 합산연결재무비율 조회 처리를 위한 애플리케이션 서버 컴포넌트
- **IC Layer**: IJICOMM - 공통 프레임워크 서비스 및 시스템 초기화를 위한 인터페이스 컴포넌트
- **DC Layer**: DIPA581 - 재무비율 계산 및 데이터베이스 조정을 위한 데이터 컴포넌트
- **BC Layer**: RIPA121 - 전문화된 재무비율 계산 및 합산 처리를 위한 비즈니스 컴포넌트
- **SQLIO Layer**: QIPA581, QIPA585, QIPA583, QIPA584 - SQL 처리 및 쿼리 실행을 위한 데이터베이스 접근 컴포넌트
- **Framework**: YCCOMMON, XIJICOMM을 통한 공유 서비스 및 매크로 사용을 위한 공통 프레임워크

### 데이터 흐름 아키텍처
1. **입력 흐름**: [Component] → [Component] → [Component]
2. **데이터베이스 접근**: [Component] → [Database Components] → [Database Tables]
3. **서비스 호출**: [Component] → [Service Components] → [Service Description]
4. **출력 흐름**: [Component] → [Component] → [Component]
5. **오류 처리**: 모든 레이어 → 프레임워크 오류 처리 → 사용자 메시지