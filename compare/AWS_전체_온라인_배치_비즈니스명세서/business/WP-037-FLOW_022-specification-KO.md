# 업무 명세서: 기업집단합산재무제표조회 (Corporate Group Consolidated Financial Statement Inquiry)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-037
- **진입점:** AIP4A57
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 거래처리 도메인에서 포괄적인 온라인 기업집단 합산재무제표 조회 시스템을 구현합니다. 시스템은 기업집단 합산 및 합산연결 재무제표에 대한 실시간 재무데이터 검색 기능을 제공하며, 유연한 보고서 구성과 자동화된 계산처리 기능을 통한 다년도 분석을 지원합니다.

업무 목적은 다음과 같습니다:
- 처리유형 구분을 통한 포괄적 기업집단 합산재무제표 조회 제공 (Provide comprehensive corporate group consolidated financial statement inquiry with processing type differentiation)
- 의사결정을 위한 합산 및 합산연결 재무데이터의 실시간 검색 및 분석 지원 (Support real-time retrieval and analysis of consolidated and combined financial data for decision making)
- 유연한 기간 설정 및 보고서 형식 선택을 통한 다년도 재무분석 지원 (Enable multi-year financial analysis with flexible period configuration and reporting format selection)
- 자동 계산처리 및 수식평가를 통한 재무데이터 무결성 유지 (Maintain financial data integrity with automated calculation processing and formula evaluation)
- 최적화된 데이터베이스 접근 및 결과 집계를 통한 확장 가능한 조회 처리 제공 (Provide scalable inquiry processing through optimized database access and result aggregation)
- 구조화된 재무제표 문서화 및 감사추적 유지를 통한 규제 준수 지원 (Support regulatory compliance through structured financial statement documentation and audit trail maintenance)

시스템은 포괄적인 다중모듈 온라인 흐름을 통해 데이터를 처리합니다: AIP4A57 → IJICOMM → YCCOMMON → XIJICOMM → DIPA571 → FIPQ001 → FIPQ002 → XFIPQ002 → XFIPQ001 → QIPA573 → YCDBSQLA → XQIPA573 → YCCSICOM → YCCBICOM → QIPA572 → XQIPA572 → QIPA574 → XQIPA574 → QIPA571 → XQIPA571 → XDIPA571 → XZUGOTMY → YNIP4A57 → YPIP4A57, 기업집단 파라미터 검증, 재무제표 유형 결정, 다년도 데이터 검색, 계산처리, 결과 집계 작업을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 처리유형 검증을 포함한 기업집단 합산재무제표 파라미터 검증 (Corporate group consolidated financial statement parameter validation with processing type verification)
- 결산년 결정 및 기간 분석을 포함한 다년도 재무데이터 검색 (Multi-year financial data retrieval with settlement year determination and period analysis)
- 합산 및 합산연결 데이터 구분을 포함한 재무제표 유형 처리 (Financial statement type processing with consolidated and combined data differentiation)
- 수식평가 및 수학함수 실행을 통한 자동 계산처리 (Automated calculation processing through formula evaluation and mathematical function execution)
- 설정 가능한 단위 변환 및 표시 형식을 포함한 재무항목 집계 및 보고 (Financial item aggregation and reporting with configurable unit conversion and display formatting)
- 대규모 재무데이터 조회를 위한 처리 결과 최적화 및 성능 관리 (Processing result optimization and performance management for large-scale financial data inquiry)
## 2. 업무 엔티티

### BE-037-001: 기업집단재무제표조회요청 (Corporate Group Financial Statement Inquiry Request)
- **설명:** 처리유형 구분을 통한 기업집단 합산재무제표 조회 작업을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Classification Code) | String | 2 | NOT NULL | 처리유형 분류 ('01': 기준년조회, '02': 재무제표조회) | YNIP4A57-PRCSS-DSTIC | prcssdstic |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIP4A57-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A57-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 재무제표구분 (Financial Statement Classification) | String | 2 | NOT NULL | 재무제표 유형 ('01': 합산연결, '02': 합산) | YNIP4A57-FNST-DSTIC | fnstDstic |
| 재무분석결산구분코드 (Financial Analysis Settlement Classification Code) | String | 1 | Optional | 재무분석을 위한 결산 분류 | YNIP4A57-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| 기준년 (Base Year) | String | 4 | YYYY 형식 | 재무분석 기준년도 | YNIP4A57-BASE-YR | baseYr |
| 분석기간 (Analysis Period) | String | 1 | NOT NULL | 분석기간 명세 (3년 또는 5년) | YNIP4A57-ANLS-TRM | anlsTrm |
| 단위 (Unit) | String | 1 | NOT NULL | 표시단위 분류 | YNIP4A57-UNIT | unit |
| 재무분석보고서구분코드1 (Financial Analysis Report Classification Code 1) | String | 2 | Optional | 주요 보고서 분류 | YNIP4A57-FNAF-A-RPTDOC-DST1 | fnafARptdocDst1 |
| 재무분석보고서구분코드2 (Financial Analysis Report Classification Code 2) | String | 2 | Optional | 보조 보고서 분류 | YNIP4A57-FNAF-A-RPTDOC-DST2 | fnafARptdocDst2 |

- **검증 규칙:**
  - 처리구분코드는 필수이며 '01'(기준년조회) 또는 '02'(재무제표조회)이어야 함
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 재무제표구분은 합산연결 대 합산 처리를 결정함
  - 처리유형 '01'은 기업집단 식별 파라미터만 필요
  - 처리유형 '02'는 완전한 조회를 위해 모든 재무분석 파라미터 필요
  - 분석기간은 분석 년수를 나타내는 유효한 숫자값이어야 함
  - 단위 명세는 표시 형식 및 계산 정밀도에 영향을 미침

### BE-037-002: 재무제표결산년정보 (Financial Statement Settlement Year Information)
- **설명:** 업체수 추적을 포함한 기업집단 재무제표의 결산년 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 결산년 (Settlement Year) | String | 4 | YYYY 형식 | 재무제표 결산년도 | YPIP4A57-STLACC-YR | stlaccYr |
| 결산년합계업체수 (Settlement Year Total Enterprise Count) | Numeric | 9 | NOT NULL | 결산년도별 총 업체수 | YPIP4A57-STLACC-YS-ENTP-CNT | stlaccYsEntpCnt |
| 처리구분 (Processing Classification) | String | 2 | NOT NULL | 처리유형 식별자 | YPIP4A57-PRCSS-DSTIC | prcssdstic |

- **검증 규칙:**
  - 결산년은 유효한 YYYY 형식이어야 하며 기준년을 초과할 수 없음
  - 업체수는 양의 숫자값이어야 함
  - 처리구분은 조회 컨텍스트를 나타냄
  - 결산년은 분석기간 결정을 위해 시간순으로 정렬됨
  - 업체수는 각 결산년도별 데이터 가용성과 완전성을 반영함

### BE-037-003: 재무제표항목상세 (Financial Statement Item Detail)
- **설명:** 계산된 금액과 메타데이터를 포함한 상세 재무제표 항목 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 결산년도 (Settlement Year) | String | 4 | YYYY 형식 | 재무항목의 결산년도 | YPIP4A57-STLACCZ-YR | stlacczYr |
| 재무항목명 (Financial Item Name) | String | 102 | NOT NULL | 재무제표 항목명 | YPIP4A57-FNAF-ITEM-NAME | fnafItemName |
| 재무제표항목금액 (Financial Statement Item Amount) | Numeric | 15 | Signed | 정밀도를 포함한 계산된 재무금액 | YPIP4A57-FNST-ITEM-AMT | fnstItemAmt |

- **검증 규칙:**
  - 결산년도는 사용 가능한 데이터 기간에 해당해야 함
  - 재무항목명은 보고를 위한 설명적 식별을 제공함
  - 재무제표항목금액은 특정 계정 유형에 대해 음수값을 지원함
  - 금액 정밀도는 재무계산의 정확성을 유지함
  - 항목들은 기본 계정 데이터와 수식을 기반으로 집계되고 계산됨

### BE-037-004: 기업집단합산연결재무제표명세 (Corporate Group Consolidated Financial Statement Specification)
- **설명:** 계정 추적을 포함한 합산연결 재무제표 데이터의 데이터베이스 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | THKIPC130-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | THKIPC130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | THKIPC130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 재무분석결산구분 (Financial Analysis Settlement Classification) | String | 1 | NOT NULL | 분석을 위한 결산 분류 | THKIPC130-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| 기준년 (Base Year) | String | 4 | YYYY 형식 | 재무데이터 기준년도 | THKIPC130-BASE-YR | baseYr |
| 결산년 (Settlement Year) | String | 4 | YYYY 형식 | 재무데이터 결산년도 | THKIPC130-STLACC-YR | stlaccYr |
| 재무분석보고서구분 (Financial Analysis Report Classification) | String | 2 | NOT NULL | 보고서 분류 식별자 | THKIPC130-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| 재무항목코드 (Financial Item Code) | String | 4 | NOT NULL | 재무항목 분류 코드 | THKIPC130-FNAF-ITEM-CD | fnafItemCd |
| 재무제표항목금액 (Financial Statement Item Amount) | Numeric | 15 | Signed | 재무제표 항목 금액 | THKIPC130-FNST-ITEM-AMT | fnstItemAmt |

- **검증 규칙:**
  - 모든 키 필드는 고유한 레코드 식별을 위해 필수임
  - 결산년은 과거 데이터 무결성을 위해 기준년을 초과할 수 없음
  - 재무항목코드는 저장되는 재무데이터의 유형을 결정함
  - 금액은 계정 성격에 따라 양수 및 음수값을 모두 지원함
  - 데이터는 그룹 엔티티 전반의 합산연결 재무정보를 나타냄

### BE-037-005: 기업집단합산재무제표명세 (Corporate Group Combined Financial Statement Specification)
- **설명:** 계정 추적을 포함한 합산 재무제표 데이터의 데이터베이스 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | THKIPC120-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | THKIPC120-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | THKIPC120-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 재무분석결산구분 (Financial Analysis Settlement Classification) | String | 1 | NOT NULL | 분석을 위한 결산 분류 | THKIPC120-FNAF-A-STLACC-DSTCD | fnafAStlaccDstcd |
| 기준년 (Base Year) | String | 4 | YYYY 형식 | 재무데이터 기준년도 | THKIPC120-BASE-YR | baseYr |
| 결산년 (Settlement Year) | String | 4 | YYYY 형식 | 재무데이터 결산년도 | THKIPC120-STLACC-YR | stlaccYr |
| 재무분석보고서구분 (Financial Analysis Report Classification) | String | 2 | NOT NULL | 보고서 분류 식별자 | THKIPC120-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| 재무항목코드 (Financial Item Code) | String | 4 | NOT NULL | 재무항목 분류 코드 | THKIPC120-FNAF-ITEM-CD | fnafItemCd |
| 재무제표항목금액 (Financial Statement Item Amount) | Numeric | 15 | Signed | 재무제표 항목 금액 | THKIPC120-FNST-ITEM-AMT | fnstItemAmt |

- **검증 규칙:**
  - 모든 키 필드는 고유한 레코드 식별을 위해 필수임
  - 결산년은 과거 데이터 무결성을 위해 기준년을 초과할 수 없음
  - 재무항목코드는 저장되는 재무데이터의 유형을 결정함
  - 금액은 계정 성격에 따라 양수 및 음수값을 모두 지원함
  - 데이터는 연결조정 없이 그룹 엔티티 전반의 합산 재무정보를 나타냄
## 3. 업무 규칙

### BR-037-001: 기업집단파라미터검증규칙 (Corporate Group Parameter Validation Rule)
- **규칙명:** 기업집단파라미터검증규칙 (Corporate Group Parameter Validation Rule)
- **설명:** 재무제표 조회를 위한 필수 기업집단 식별 파라미터를 검증
- **조건:** 기업집단 재무제표 조회가 요청될 때 기업집단코드가 제공되고 유효해야 함
- **관련 엔티티:** BE-037-001
- **예외사항:** 없음 - 모든 기업집단 조회는 유효한 그룹 식별이 필요함

### BR-037-002: 처리유형구분규칙 (Processing Type Differentiation Rule)
- **규칙명:** 처리유형구분규칙 (Processing Type Differentiation Rule)
- **설명:** 처리구분코드에 따라 필요한 파라미터와 처리 로직을 결정
- **조건:** 처리구분이 '01'일 때 기본 그룹 파라미터만 필요, 처리구분이 '02'일 때 전체 재무분석 파라미터 필요
- **관련 엔티티:** BE-037-001
- **예외사항:** 유효하지 않은 처리코드는 오류 종료를 발생시킴

### BR-037-003: 재무분석파라미터검증규칙 (Financial Analysis Parameter Validation Rule)
- **규칙명:** 재무분석파라미터검증규칙 (Financial Analysis Parameter Validation Rule)
- **설명:** 포괄적인 재무제표 조회를 위한 재무분석 파라미터를 검증
- **조건:** 처리유형이 '02'일 때 기준년, 결산구분, 보고서구분, 분석기간, 단위가 제공되어야 함
- **관련 엔티티:** BE-037-001
- **예외사항:** 처리유형 '01'은 상세 파라미터 검증을 우회함

### BR-037-004: 기준년제약규칙 (Base Year Constraint Rule)
- **규칙명:** 기준년제약규칙 (Base Year Constraint Rule)
- **설명:** 과거 재무데이터 검색을 위한 기준년 제약을 강제
- **조건:** 기준년이 2001년 미만일 때 데이터 가용성을 위해 자동으로 2001년으로 조정
- **관련 엔티티:** BE-037-001, BE-037-002
- **예외사항:** 없음 - 최소년도 제약은 데이터 가용성을 보장함

### BR-037-005: 분석기간제한규칙 (Analysis Period Limitation Rule)
- **규칙명:** 분석기간제한규칙 (Analysis Period Limitation Rule)
- **설명:** 사용 가능한 결산년과 시스템 제약에 따라 분석기간을 제한
- **조건:** 사용 가능한 결산년이 분석기간을 초과할 때 분석기간으로 제한, 사용 가능한 결산년이 적을 때 사용 가능한 수를 사용
- **관련 엔티티:** BE-037-002, BE-037-003
- **예외사항:** 없음 - 시스템이 사용 가능한 데이터에 적응함

### BR-037-006: 재무제표유형처리규칙 (Financial Statement Type Processing Rule)
- **규칙명:** 재무제표유형처리규칙 (Financial Statement Type Processing Rule)
- **설명:** 재무제표 분류에 따라 데이터베이스 테이블과 처리 로직을 결정
- **조건:** 재무제표 분류가 '01'일 때 THKIPC130에서 합산연결 데이터 처리, 분류가 '02'일 때 THKIPC120에서 합산 데이터 처리
- **관련 엔티티:** BE-037-004, BE-037-005
- **예외사항:** 유효하지 않은 분류코드는 오류 처리를 발생시킴

### BR-037-007: 결산년순서규칙 (Settlement Year Ordering Rule)
- **규칙명:** 결산년순서규칙 (Settlement Year Ordering Rule)
- **설명:** 분석을 위한 결산년의 적절한 시간순 정렬을 보장
- **조건:** 결산년을 검색할 때 최신 우선 분석을 위해 결산년 내림차순으로 정렬
- **관련 엔티티:** BE-037-002, BE-037-003
- **예외사항:** 없음 - 분석 무결성을 위해 일관된 정렬이 필요함

### BR-037-008: 재무항목계산규칙 (Financial Item Calculation Rule)
- **규칙명:** 재무항목계산규칙 (Financial Item Calculation Rule)
- **설명:** 수식 평가와 수학 함수를 사용하여 재무항목 계산을 처리
- **조건:** 재무항목이 계산을 필요로 할 때 파생값을 위한 함수 평가와 함께 수식 처리를 적용
- **관련 엔티티:** BE-037-003
- **예외사항:** 계산 오류는 적절한 오류 처리와 함께 0 또는 null 값을 발생시킴

### BR-037-009: 결과집합크기제한규칙 (Result Set Size Limitation Rule)
- **규칙명:** 결과집합크기제한규칙 (Result Set Size Limitation Rule)
- **설명:** 시스템 자원 고갈을 방지하기 위해 결과집합 크기를 제한
- **조건:** 쿼리 결과가 6000개 레코드를 초과할 때 성능 최적화를 위해 6000개 레코드로 제한
- **관련 엔티티:** BE-037-003
- **예외사항:** 없음 - 시스템 안정성을 위해 하드 제한이 강제됨

### BR-037-010: 단위변환처리규칙 (Unit Conversion Processing Rule)
- **규칙명:** 단위변환처리규칙 (Unit Conversion Processing Rule)
- **설명:** 표시 형식을 위한 단위 명세에 따라 단위 변환을 적용
- **조건:** 단위가 지정될 때 재무금액 표시를 위한 적절한 스케일링과 형식을 적용
- **관련 엔티티:** BE-037-001, BE-037-003
- **예외사항:** 유효하지 않은 단위 명세는 기본 형식을 사용함
## 4. 업무 기능

### F-037-001: 기업집단파라미터검증기능 (Corporate Group Parameter Validation Function)
- **기능명:** 기업집단파라미터검증기능 (Corporate Group Parameter Validation Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류코드 |
| baseYr | String | 4 | 분석 기준년도 |
| fnafAStlaccDstcd | String | 1 | 재무분석 결산구분 |
| fnafARptdocDst1 | String | 2 | 주요 보고서 분류 |
| fnafARptdocDst2 | String | 2 | 보조 보고서 분류 |
| anlsTrm | String | 1 | 분석기간 명세 |
| unit | String | 1 | 표시단위 분류 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| validationResult | String | 2 | 검증 결과 상태 |
| errorCode | String | 8 | 검증 실패 시 오류코드 |
| treatmentCode | String | 8 | 오류 처리를 위한 처리코드 |

#### 처리 로직
1. 기업집단코드가 공백이 아닌지 검증
2. 처리유형 '02'에 대해 모든 재무분석 파라미터 검증
3. 기준년 형식과 유효성 확인
4. 보고서 분류코드 검증
5. 분석기간과 단위 명세 검증
6. 적절한 오류코드와 함께 검증 결과 반환

### F-037-002: 결산년검색기능 (Settlement Year Retrieval Function)
- **기능명:** 결산년검색기능 (Settlement Year Retrieval Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| groupCoCd | String | 3 | 그룹회사코드 |
| corpClctGroupCd | String | 3 | 기업집단코드 |
| corpClctRegiCd | String | 3 | 기업집단등록코드 |
| fnafAStlaccDstcd | String | 1 | 결산구분 |
| baseYr | String | 4 | 분석 기준년도 |
| fnafARptdocDstcd | String | 2 | 보고서 분류 |
| prcssdstic | String | 2 | 처리구분 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| settlementYears | Array | Variable | 결산년 정보 배열 |
| settlementCount | Numeric | 5 | 사용 가능한 결산년 수 |
| processingResult | String | 2 | 처리 결과 상태 |

#### 처리 로직
1. 합산연결 및 합산 재무제표 테이블 쿼리
2. 업체수와 함께 고유한 결산년 검색
3. 처리구분과 기준년 제약으로 필터링
4. 결산년을 시간순 내림차순으로 정렬
5. 메타데이터와 함께 결산년 배열 반환

### F-037-003: 재무제표데이터검색기능 (Financial Statement Data Retrieval Function)
- **기능명:** 재무제표데이터검색기능 (Financial Statement Data Retrieval Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| fnstDstic | String | 2 | 재무제표 분류 |
| settlementYear | String | 4 | 대상 결산년도 |
| previousYear | String | 4 | 이전 결산년도 |
| groupCoCd | String | 3 | 그룹회사코드 |
| corpClctGroupCd | String | 3 | 기업집단코드 |
| corpClctRegiCd | String | 3 | 기업집단등록코드 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| financialItems | Array | Variable | 재무제표 항목 배열 |
| itemCount | Numeric | 5 | 재무항목 수 |
| processingResult | String | 2 | 처리 결과 상태 |

#### 처리 로직
1. 재무제표 분류에 따라 대상 테이블 결정
2. 재무제표 계정코드와 수식 쿼리
3. 파생 항목에 대한 계산 처리 실행
4. 단위 변환과 형식 적용
5. 계산된 금액과 함께 재무항목 배열 반환

### F-037-004: 재무항목계산기능 (Financial Item Calculation Function)
- **기능명:** 재무항목계산기능 (Financial Item Calculation Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| calculationFormula | String | 4002 | 계산을 위한 수학 수식 |
| financialData | Array | Variable | 계산을 위한 소스 재무데이터 |
| unit | String | 1 | 변환을 위한 단위 명세 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| calculatedAmount | Numeric | 15 | 계산된 재무금액 |
| calculationStatus | String | 2 | 계산 처리 상태 |
| errorMessage | String | 200 | 계산 실패 시 오류메시지 |

#### 처리 로직
1. 수학 수식을 파싱하고 변수 식별
2. 재무데이터 값을 수식에 치환
3. 수학 함수 처리 실행
4. 명세에 따른 단위 변환 적용
5. 상태 정보와 함께 계산된 금액 반환

### F-037-005: 결과집계기능 (Result Aggregation Function)
- **기능명:** 결과집계기능 (Result Aggregation Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| settlementData | Array | Variable | 결산년 데이터 배열 |
| financialItems | Array | Variable | 재무항목 데이터 배열 |
| anlsTrm | String | 1 | 분석기간 명세 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| aggregatedResult | Object | Variable | 집계된 재무제표 결과 |
| totalItemCount | Numeric | 5 | 처리된 총 항목 수 |
| processingStatus | String | 2 | 전체 처리 상태 |

#### 처리 로직
1. 분석기간별 결산년 정보 집계
2. 다년도에 걸친 재무항목 통합
3. 결과집합 크기 제한 적용
4. 표시를 위한 출력 구조 형식화
5. 포괄적인 집계 결과 반환

### F-037-006: 오류처리기능 (Error Handling Function)
- **기능명:** 오류처리기능 (Error Handling Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| errorCode | String | 8 | 시스템 오류코드 |
| treatmentCode | String | 8 | 오류 처리코드 |
| errorContext | String | 100 | 오류에 대한 컨텍스트 정보 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| errorResponse | Object | Variable | 형식화된 오류 응답 |
| recoveryAction | String | 50 | 권장 복구 조치 |

#### 처리 로직
1. 오류 유형과 심각도 분류
2. 적절한 처리 조치 결정
3. 사용자 표시를 위한 오류 응답 형식화
4. 감사 추적을 위한 오류 정보 로깅
5. 복구 지침과 함께 구조화된 오류 응답 반환
## 5. 프로세스 흐름

### 기업집단합산재무제표조회 프로세스 흐름

```
기업집단합산재무제표조회 (Corporate Group Consolidated Financial Statement Inquiry)
├── 입력파라미터수신 (Input Parameter Reception)
│   ├── 처리구분검증 (Processing Classification Validation)
│   ├── 기업집단코드검증 (Corporate Group Code Validation)
│   └── 재무분석파라미터검증 (Financial Analysis Parameter Validation)
├── 공통프레임워크초기화 (Common Framework Initialization)
│   ├── 비계약업무구분설정 (Non-Contract Business Classification Setup)
│   ├── 공통인터페이스컴포넌트호출 (Common Interface Component Call)
│   └── 출력영역할당 (Output Area Allocation)
├── 처리유형결정 (Processing Type Determination)
│   ├── 기준년조회처리 ('01' Base Year Inquiry Processing)
│   │   ├── 기업집단파라미터조립 (Corporate Group Parameter Assembly)
│   │   ├── 결산년데이터검색 (Settlement Year Data Retrieval)
│   │   └── 이용가능년정보반환 (Available Year Information Return)
│   └── 재무제표조회처리 ('02' Financial Statement Inquiry Processing)
│       ├── 재무분석파라미터조립 (Financial Analysis Parameter Assembly)
│       ├── 결산년결정 (Settlement Year Determination)
│       ├── 재무제표유형처리 (Financial Statement Type Processing)
│       ├── 다년도데이터검색 (Multi-Year Data Retrieval)
│       └── 재무항목계산처리 (Financial Item Calculation Processing)
├── 데이터베이스쿼리처리 (Database Query Processing)
│   ├── 결산년쿼리실행 (Settlement Year Query Execution)
│   │   ├── 합산연결재무제표쿼리 (Consolidated Financial Statement Query)
│   │   ├── 합산재무제표쿼리 (Combined Financial Statement Query)
│   │   └── 결산년결과집계 (Settlement Year Result Aggregation)
│   ├── 재무계정코드쿼리실행 (Financial Account Code Query Execution)
│   │   ├── 계정코드목록검색 (Account Code List Retrieval)
│   │   ├── 수식처리실행 (Formula Processing Execution)
│   │   └── 재무항목계산 (Financial Item Calculation)
│   └── 결과집합최적화 (Result Set Optimization)
│       ├── 크기제한적용 (Size Limitation Application)
│       ├── 성능최적화 (Performance Optimization)
│       └── 메모리관리 (Memory Management)
├── 계산처리 (Calculation Processing)
│   ├── 수학수식평가 (Mathematical Formula Evaluation)
│   │   ├── 수식파싱 (Formula Parsing)
│   │   ├── 변수치환 (Variable Substitution)
│   │   ├── 함수실행 (Function Execution)
│   │   └── 결과계산 (Result Calculation)
│   ├── 단위변환처리 (Unit Conversion Processing)
│   │   ├── 단위명세분석 (Unit Specification Analysis)
│   │   ├── 스케일링팩터적용 (Scaling Factor Application)
│   │   └── 표시형식조정 (Display Format Adjustment)
│   └── 재무금액집계 (Financial Amount Aggregation)
│       ├── 다년도금액통합 (Multi-Year Amount Consolidation)
│       ├── 계정잔액계산 (Account Balance Calculation)
│       └── 요약정보생성 (Summary Information Generation)
├── 결과조립 (Result Assembly)
│   ├── 결산년정보조립 (Settlement Year Information Assembly)
│   │   ├── 년도목록생성 (Year List Generation)
│   │   ├── 업체수집계 (Enterprise Count Aggregation)
│   │   └── 분석기간조정 (Analysis Period Adjustment)
│   ├── 재무항목정보조립 (Financial Item Information Assembly)
│   │   ├── 항목명할당 (Item Name Assignment)
│   │   ├── 금액값할당 (Amount Value Assignment)
│   │   └── 메타데이터정보할당 (Metadata Information Assignment)
│   └── 출력구조형식화 (Output Structure Formatting)
│       ├── 그리드구조조직화 (Grid Structure Organization)
│       ├── 건수정보할당 (Count Information Assignment)
│       └── 표시형식적용 (Display Format Application)
└── 응답생성 (Response Generation)
    ├── 성공응답처리 (Success Response Processing)
    │   ├── 결과데이터패키징 (Result Data Packaging)
    │   ├── 상태코드할당 (Status Code Assignment)
    │   └── 출력파라미터반환 (Output Parameter Return)
    ├── 오류응답처리 (Error Response Processing)
    │   ├── 오류코드할당 (Error Code Assignment)
    │   ├── 처리코드할당 (Treatment Code Assignment)
    │   └── 오류메시지생성 (Error Message Generation)
    └── 거래완료 (Transaction Completion)
        ├── 자원정리 (Resource Cleanup)
        ├── 감사추적기록 (Audit Trail Recording)
        └── 세션종료 (Session Termination)
```
## 6. 레거시 구현 참조

### 소스 파일
- **AIP4A57.cbl**: 기업집단 합산재무제표 조회를 위한 주요 진입점 프로그램
- **DIPA571.cbl**: 합산연결 재무제표 데이터 처리를 위한 데이터베이스 컨트롤러
- **QIPA571.cbl**: 기준년 조회 작업을 위한 SQL 쿼리 프로세서
- **QIPA572.cbl**: 합산연결 재무제표 계정 검색을 위한 SQL 쿼리 프로세서
- **QIPA573.cbl**: 결산년 데이터 검색을 위한 SQL 쿼리 프로세서
- **QIPA574.cbl**: 합산 재무제표 계정 검색을 위한 SQL 쿼리 프로세서
- **FIPQ001.cbl**: 함수 지원을 포함한 수학 수식 계산 프로세서
- **FIPQ002.cbl**: 복잡한 재무 수식을 위한 확장 계산 프로세서
- **IJICOMM.cbl**: 프레임워크 초기화를 위한 공통 인터페이스 컴포넌트
- **YNIP4A57.cpy**: 요청 구조를 정의하는 입력 파라미터 카피북
- **YPIP4A57.cpy**: 응답 구조를 정의하는 출력 파라미터 카피북
- **XDIPA571.cpy**: 데이터베이스 컨트롤러 인터페이스 카피북
- **XQIPA571.cpy**: 기준년 쿼리 인터페이스 카피북
- **XQIPA572.cpy**: 합산연결 계정 쿼리 인터페이스 카피북
- **XQIPA573.cpy**: 결산년 쿼리 인터페이스 카피북
- **XQIPA574.cpy**: 합산 계정 쿼리 인터페이스 카피북
- **XFIPQ001.cpy**: 수식 계산 인터페이스 카피북
- **XFIPQ002.cpy**: 확장 계산 인터페이스 카피북
- **XIJICOMM.cpy**: 공통 인터페이스 컴포넌트 카피북
- **YCCOMMON.cpy**: 공통 프레임워크 파라미터 카피북
- **YCDBSQLA.cpy**: 데이터베이스 SQL 접근 프레임워크 카피북
- **YCCSICOM.cpy**: 공통 시스템 인터페이스 카피북
- **YCCBICOM.cpy**: 공통 업무 인터페이스 카피북
- **XZUGOTMY.cpy**: 출력 메모리 관리 카피북

### 업무 규칙 구현

- **BR-037-001:** AIP4A57.cbl 182-184행에서 기업집단 파라미터 검증으로 구현
  ```cobol
  IF YNIP4A57-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF.
  ```

- **BR-037-002:** AIP4A57.cbl 186-236행과 DIPA571.cbl 244-254행에서 처리유형 구분으로 구현
  ```cobol
  IF  YNIP4A57-PRCSS-DSTIC NOT = '01'
  *   처리유형 '02'에 대한 추가 파라미터 검증
      IF YNIP4A57-BASE-YR = SPACE
         #ERROR CO-B2700460 CO-UKII0055 CO-STAT-ERROR
      END-IF
  END-IF
  
  EVALUATE  XDIPA571-I-PRCSS-DSTIC
  WHEN '01'
      PERFORM  S6000-BASE-YR-PROC-RTN
         THRU  S6000-BASE-YR-PROC-EXT
  WHEN '02'
      PERFORM  S3100-PROCESS-RTN
         THRU  S3100-PROCESS-EXT
  END-EVALUATE
  ```

- **BR-037-003:** DIPA571.cbl 194-232행에서 재무분석 파라미터 검증으로 구현
  ```cobol
  IF  XDIPA571-I-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF

  IF  XDIPA571-I-PRCSS-DSTIC NOT = '01'
      IF  XDIPA571-I-FNAF-A-STLACC-DSTCD = SPACE
          #ERROR CO-B3000108 CO-UKII0299 CO-STAT-ERROR
      END-IF
      
      IF  XDIPA571-I-BASE-YR = SPACE
          #ERROR CO-B2700460 CO-UKII0055 CO-STAT-ERROR
      END-IF
  END-IF
  ```

- **BR-037-004:** DIPA571.cbl 296-300행에서 기준년 제약 규칙으로 구현
  ```cobol
  *    2001이하는 2001으로 고정
  IF XQIPA573-I-BASE-YR < '2001' THEN
       MOVE  CO-C2001
         TO  XQIPA573-I-BASE-YR
  END-IF
  ```

- **BR-037-005:** DIPA571.cbl 442-445행에서 분석기간 제한 규칙으로 구현
  ```cobol
  IF  DBSQL-SELECT-CNT  >  CO-N6000  THEN
      MOVE  CO-N6000
        TO  DBSQL-SELECT-CNT
  END-IF
  ```

- **BR-037-006:** DIPA571.cbl 244-254행에서 재무제표 유형 처리 규칙으로 구현
  ```cobol
  EVALUATE  XDIPA571-I-PRCSS-DSTIC
  WHEN '01'
      PERFORM  S6000-BASE-YR-PROC-RTN
         THRU  S6000-BASE-YR-PROC-EXT
  WHEN '02'
      PERFORM  S3100-PROCESS-RTN
         THRU  S3100-PROCESS-EXT
  END-EVALUATE
  ```

- **BR-037-007:** QIPA573.cbl 297행에서 결산년 순서 규칙으로 구현
  ```cobol
  ORDER BY 처리구분코드, 결산년 DESC
  ```

- **BR-037-008:** FIPQ001.cbl에서 포괄적 수식 평가와 수학 함수 처리로 구현
  ```cobol
  *@지원함수  : ABS, MAX, MIN, POWER, EXP, LOG, EXACT
  *@　　　　　　IF(OR, AND, NOT), INT, STD
  MOVE  '99'
    TO  XFIPQ001-I-PRCSS-DSTIC
  MOVE  WK-SANSIK
    TO  XFIPQ001-I-CLFR
  
  IF (WK-SANSIK = '0')
      COMPUTE WK-AMT = 0
  ELSE
      #DYCALL  FIPQ001 YCCOMMON-CA XFIPQ001-CA
  END-IF
  ```

- **BR-037-009:** DIPA571.cbl 442-445행에서 결과집합 크기 제한 규칙으로 구현
  ```cobol
  IF  DBSQL-SELECT-CNT  >  CO-N6000  THEN
      MOVE  CO-N6000
        TO  DBSQL-SELECT-CNT
  END-IF
  ```

- **BR-037-010:** DIPA571.cbl 67-72행에서 단위 변환 처리 규칙으로 구현
  ```cobol
  03  CO-C2001                PIC  X(004) VALUE '2001'.
  03  CO-N6000                PIC  9(004) VALUE 6000.
  03  CO-DANWI                PIC  X(001) VALUE '3'.
  03  CO-DANWI2               PIC  X(001) VALUE '4'.
  03  CO-THUSAND              PIC  9(004) VALUE 1000.
  03  CO-HUNDRED-MILLION      PIC  9(006) VALUE 100000.
  ```

### 기능 구현

- **F-037-001:** AIP4A57.cbl 176-240행에서 기업집단 파라미터 검증 기능으로 구현
  ```cobol
  S2000-VALIDATION-RTN.
  *@1 입력항목검증
  *#1 기업집단코드 체크
      IF YNIP4A57-CORP-CLCT-GROUP-CD = SPACE
         #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
      END-IF.

      IF  YNIP4A57-PRCSS-DSTIC NOT = '01'
  *#1     기준년 체크
          IF YNIP4A57-BASE-YR = SPACE
             #ERROR CO-B2700460 CO-UKII0055 CO-STAT-ERROR
          END-IF
  *#1     분석기간 체크
          IF YNIP4A57-ANLS-TRM = 0
             #ERROR CO-B3000661 CO-UKII0361 CO-STAT-ERROR
          END-IF
  *#1     단위 체크
          IF YNIP4A57-UNIT = SPACE
             #ERROR CO-B0100285 CO-UKII0467 CO-STAT-ERROR
          END-IF
      END-IF
  ```

- **F-037-002:** DIPA571.cbl 728-798행에서 결산년 검색 기능으로 구현
  ```cobol
  S6000-BASE-YR-PROC-RTN.
      #USRLOG '# 기준년 조회'
  *--------------------------------------------
  *@3.1.1 입력파라미터 조립
  *--------------------------------------------
      INITIALIZE XQIPA571-IN.
      
      MOVE XDIPA571-I-GROUP-CO-CD
        TO XQIPA571-I-GROUP-CO-CD
      MOVE XDIPA571-I-CORP-CLCT-GROUP-CD
        TO XQIPA571-I-CORP-CLCT-GROUP-CD
      MOVE XDIPA571-I-CORP-CLCT-REGI-CD
        TO XQIPA571-I-CORP-CLCT-REGI-CD
  ```

- **F-037-003:** DIPA571.cbl 240-280행에서 재무제표 데이터 검색 기능으로 구현
  ```cobol
  S3000-PROCESS-RTN.
      #USRLOG '처리구분 값 : ' XDIPA571-I-PRCSS-DSTIC
      
      EVALUATE  XDIPA571-I-PRCSS-DSTIC
      WHEN '01'
          PERFORM  S6000-BASE-YR-PROC-RTN
             THRU  S6000-BASE-YR-PROC-EXT
      WHEN '02'
          PERFORM  S3100-PROCESS-RTN
             THRU  S3100-PROCESS-EXT
      END-EVALUATE
  ```

- **F-037-004:** FIPQ001.cbl에서 수학 수식 계산 처리로 구현
  ```cobol
  *@업무명    : KIP     (기업집단신용평가)
  *@프로그램명: FIPQ001 (FC산식내함수계산)
  *@처리유형  : FC
  *@처리개요  : 산식내 함수계산하는 거래이다
  *@처리내용  : 함수를　계산하여　숫자값으로　치환
  *@지원함수  : ABS, MAX, MIN, POWER, EXP, LOG, EXACT
  *@　　　　　　IF(OR, AND, NOT), INT, STD
  
  77  CO-E             PIC 9(2)V9(20) VALUE 2.71828182845904523536.
  ```

- **F-037-005:** DIPA571.cbl 442-445행에서 결과 집계 기능으로 구현
  ```cobol
  *--------------------------------------------
  *@3.2.1.4 출력파라미터 조립
  *--------------------------------------------
  IF  DBSQL-SELECT-CNT  >  CO-N6000  THEN
      MOVE  CO-N6000
        TO  DBSQL-SELECT-CNT
  END-IF
  ```

- **F-037-006:** 모든 모듈에서 #ERROR 매크로를 사용한 표준화된 오류 처리로 구현
  ```cobol
  IF YNIP4A57-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF.
  
  IF  XDIPA571-I-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

### 데이터베이스 테이블
- **THKIPC130**: 합산연결 재무데이터를 저장하는 기업집단 합산연결재무제표 테이블
- **THKIPC120**: 합산 재무데이터를 저장하는 기업집단 합산재무제표 테이블
- **재무수식테이블**: 계산 처리를 위해 QIPA572와 QIPA574를 통해 참조됨

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
- **AS Layer**: AIP4A57 - 기업집단 합산재무제표조회를 위한 Application Server 컴포넌트
- **IC Layer**: IJICOMM - 공통 프레임워크 서비스 및 시스템 초기화를 위한 Interface Component
- **DC Layer**: DIPA571 - 재무제표 처리 및 데이터베이스 조정을 위한 Data Component
- **BC Layer**: QIPA571, QIPA572, QIPA573, QIPA574, FIPQ001, FIPQ002 - 데이터베이스 작업 및 계산 처리를 위한 Business Components
- **SQLIO Layer**: 데이터베이스 접근 컴포넌트 - 재무데이터 검색을 위한 SQL 처리 및 쿼리 실행
- **Framework**: YCCOMMON, XIJICOMM을 포함한 공통 프레임워크로 공유 서비스 및 매크로 사용

### 데이터 흐름 아키텍처
1. **입력 흐름**: [Component] → [Component] → [Component]
2. **데이터베이스 접근**: [Component] → [Database Components] → [Database Tables]
3. **서비스 호출**: [Component] → [Service Components] → [Service Description]
4. **출력 흐름**: [Component] → [Component] → [Component]
5. **오류 처리**: 모든 레이어 → 프레임워크 오류 처리 → 사용자 메시지