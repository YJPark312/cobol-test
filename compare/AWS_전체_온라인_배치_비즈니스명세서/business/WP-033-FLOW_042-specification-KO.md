# 업무 명세서: 기업집단사업분석저장 (Corporate Group Business Analysis Storage)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-033
- **진입점:** AIPBA66
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 거래 처리 도메인에서 포괄적인 온라인 기업집단 사업분석 저장 시스템을 구현합니다. 이 시스템은 기업집단 사업구조 분석 데이터의 실시간 저장 기능을 제공하며, 기업집단 사업 평가 및 전략 계획을 위한 재무 분석 및 사업부문 평가 운영을 지원합니다.

업무 목적은 다음과 같습니다:
- 다년도 재무 데이터 관리를 통한 포괄적 기업집단 사업구조 분석 저장 제공 (Provide comprehensive corporate group business structure analysis storage with multi-year financial data management)
- 기준년 및 과거 기간의 금액, 비율, 업체수를 포함한 사업부문 분석의 실시간 저장 지원 (Support real-time storage of business sector analysis including amounts, ratios, and enterprise counts for base year and historical periods)
- 분류 기반 조직화를 통한 사업분석 의견 및 주석 관리 지원 (Enable business analysis opinion and comment management with classification-based organization)
- 포괄적 검증 및 업데이트 운영을 통한 기업집단 사업분석 데이터 무결성 유지 (Maintain corporate group business analysis data integrity with comprehensive validation and update operations)
- 기업집단 사업분석 저장 운영의 감사추적 및 거래 추적 제공 (Provide audit trail and transaction tracking for corporate group business analysis storage operations)
- 구조화된 사업분석 데이터 저장 및 검색을 통한 의사결정 프로세스 지원 (Support decision-making processes through structured business analysis data storage and retrieval)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIPBA66 → IJICOMM → YCCOMMON → XIJICOMM → DIPA661 → RIPA113 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA130 → QIPA661 → YCDBSQLA → XQIPA661 → TRIPB113 → TKIPB113 → TRIPB130 → TKIPB130 → XDIPA661 → XZUGOTMY → YNIPBA66 → YPIPBA66, 사업분석 파라미터 검증, 기존 데이터 검색 및 삭제, 신규 데이터 삽입, 포괄적 사업분석 저장 운영을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 필수 필드 검증을 포함한 기업집단 사업분석 파라미터 검증 (Corporate group business analysis parameter validation with mandatory field verification)
- 기준년, N-1년, N-2년 분석을 포함한 다년도 사업부문 재무 데이터 저장 (Multi-year business sector financial data storage with base year, N-1 year, and N-2 year analysis)
- 구조화된 데이터 삭제 및 삽입 운영을 통한 데이터베이스 무결성 관리 (Database integrity management through structured data deletion and insertion operations)
- 분류 기반 주석 관리를 포함한 사업분석 의견 저장 (Business analysis opinion storage with classification-based comment management)
- 다중 테이블 관계 처리를 포함한 기업집단 사업구조 분석 이력 관리 (Corporate group business structure analysis history management with multi-table relationship handling)
- 데이터 일관성 및 거래 무결성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for data consistency and transaction integrity)

## 2. 업무 엔티티

### BE-033-001: 기업집단사업분석요청 (Corporate Group Business Analysis Request)
- **설명:** 기업집단 사업분석 저장 운영을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수1 (Total Count 1) | Numeric | 5 | Unsigned | 사업부문 분석 레코드의 총 개수 | YNIPBA66-TOTAL-NOITM1 | totalNoitm1 |
| 현재건수1 (Current Count 1) | Numeric | 5 | Unsigned | 사업부문 분석 레코드의 현재 개수 | YNIPBA66-PRSNT-NOITM1 | prsntNoitm1 |
| 총건수2 (Total Count 2) | Numeric | 5 | Unsigned | 주석 레코드의 총 개수 | YNIPBA66-TOTAL-NOITM2 | totalNoitm2 |
| 현재건수2 (Current Count 2) | Numeric | 5 | Unsigned | 주석 레코드의 현재 개수 | YNIPBA66-PRSNT-NOITM2 | prsntNoitm2 |
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | YNIPBA66-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA66-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA66-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD format | 사업분석을 위한 평가일자 | YNIPBA66-VALUA-YMD | valuaYmd |

- **검증 규칙:**
  - 그룹회사코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 건수 필드는 음수가 아닌 숫자 값이어야 함
  - 두 그리드 유형 모두에서 총건수는 현재건수보다 크거나 같아야 함

### BE-033-002: 사업부문분석데이터 (Business Sector Analysis Data)
- **설명:** 다년도 비교를 포함한 사업부문의 재무분석 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 재무분석보고서구분 (Financial Analysis Report Classification) | String | 2 | NOT NULL | 재무분석 보고서 유형 식별자 | YNIPBA66-FNAF-A-RPTDOC-DSTCD | fnafARptdocDstcd |
| 재무항목코드 (Financial Item Code) | String | 4 | NOT NULL | 재무항목 분류 코드 | YNIPBA66-FNAF-ITEM-CD | fnafItemCd |
| 사업부문번호 (Business Sector Number) | String | 4 | NOT NULL | 사업부문 식별 번호 | YNIPBA66-BIZ-SECT-NO | bizSectNo |
| 사업부문구분명 (Business Sector Classification Name) | String | 32 | NOT NULL | 사업부문 분류 설명 | YNIPBA66-BIZ-SECT-DSTIC-NAME | bizSectDsticName |
| 기준년항목금액 (Base Year Item Amount) | Numeric | 15 | Unsigned | 기준년도 재무 금액 | YNIPBA66-BASE-YR-ITEM-AMT | baseYrItemAmt |
| 기준년비율 (Base Year Ratio) | Numeric | 7 | 99999.99 format | 기준년도 백분율 비율 | YNIPBA66-BASE-YR-RATO | baseYrRato |
| 기준년업체수 (Base Year Enterprise Count) | Numeric | 5 | Unsigned | 기준년도 업체 수 | YNIPBA66-BASE-YR-ENTP-CNT | baseYrEntpCnt |
| N1년전항목금액 (N1 Year Before Item Amount) | Numeric | 15 | Unsigned | N-1년도 재무 금액 | YNIPBA66-N1-YR-BF-ITEM-AMT | n1YrBfItemAmt |
| N1년전비율 (N1 Year Before Ratio) | Numeric | 7 | 99999.99 format | N-1년도 백분율 비율 | YNIPBA66-N1-YR-BF-RATO | n1YrBfRato |
| N1년전업체수 (N1 Year Before Enterprise Count) | Numeric | 5 | Unsigned | N-1년도 업체 수 | YNIPBA66-N1-YR-BF-ENTP-CNT | n1YrBfEntpCnt |
| N2년전항목금액 (N2 Year Before Item Amount) | Numeric | 15 | Unsigned | N-2년도 재무 금액 | YNIPBA66-N2-YR-BF-ITEM-AMT | n2YrBfItemAmt |
| N2년전비율 (N2 Year Before Ratio) | Numeric | 7 | 99999.99 format | N-2년도 백분율 비율 | YNIPBA66-N2-YR-BF-RATO | n2YrBfRato |
| N2년전업체수 (N2 Year Before Enterprise Count) | Numeric | 5 | Unsigned | N-2년도 업체 수 | YNIPBA66-N2-YR-BF-ENTP-CNT | n2YrBfEntpCnt |

- **검증 규칙:**
  - 재무분석보고서구분은 각 사업부문 레코드에 필수
  - 재무항목코드와 사업부문번호는 필수 식별자
  - 사업부문구분명은 명확성을 위해 제공되어야 함
  - 금액 필드는 음수가 아닌 숫자 값이어야 함
  - 비율 필드는 유효한 백분율 범위(0-99999.99) 내에 있어야 함
  - 업체수 필드는 음수가 아닌 정수여야 함
  - 기준년, N-1, N-2 기간에 걸쳐 다년도 데이터 일관성이 유지되어야 함

### BE-033-003: 사업분석주석데이터 (Business Analysis Comment Data)
- **설명:** 분류 관리를 포함한 사업분석의 주석 및 의견 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단주석구분 (Corporate Group Comment Classification) | String | 2 | NOT NULL | 주석 분류 식별자 | YNIPBA66-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 주석내용 (Comment Content) | String | 2002 | Optional | 사업분석 의견 내용 | YNIPBA66-COMT-CTNT | comtCtnt |

- **검증 규칙:**
  - 기업집단주석구분은 각 주석 레코드에 필수
  - 주석내용은 선택사항이지만 중요한 사업분석 맥락을 제공
  - 주석 분류는 시스템 표준에 따라 유효해야 함
  - 주석 내용 길이는 허용된 최대 크기를 초과하지 않아야 함
  - 동일한 사업분석 평가에 여러 주석이 연관될 수 있음

### BE-033-004: 사업분석저장응답 (Business Analysis Storage Response)
- **설명:** 사업분석 저장 운영에 대한 출력 응답 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수 (Total Count) | Numeric | 5 | Unsigned | 처리된 레코드의 총 개수 | YPIPBA66-TOTAL-NOITM | totalNoitm |
| 현재건수 (Current Count) | Numeric | 5 | Unsigned | 처리된 레코드의 현재 개수 | YPIPBA66-PRSNT-NOITM | prsntNoitm |

- **검증 규칙:**
  - 건수 필드는 음수가 아닌 숫자 값이어야 함
  - 총건수는 현재건수보다 크거나 같아야 함
  - 응답 건수는 실제 처리 결과를 반영해야 함
  - 건수 값은 입력 처리 운영과 일치해야 함

## 3. 업무 규칙

### BR-033-001: 기업집단파라미터검증 (Corporate Group Parameter Validation)
- **설명:** 기업집단 사업분석 파라미터에 대한 필수 검증 규칙
- **조건:** 기업집단 사업분석 저장이 요청될 때 모든 필수 파라미터가 검증되어야 함
- **관련 엔티티:** BE-033-001
- **예외:** 필수 파라미터가 누락되거나 유효하지 않은 경우 시스템 오류

### BR-033-002: 사업부문데이터무결성 (Business Sector Data Integrity)
- **설명:** 사업부문 재무분석 정보에 대한 데이터 무결성 규칙
- **조건:** 사업부문 분석 데이터가 처리될 때 다년도 기간에 걸쳐 재무 데이터 일관성이 유지되어야 함
- **관련 엔티티:** BE-033-002
- **예외:** 재무 데이터 불일치가 감지되면 데이터 검증 오류

### BR-033-003: 주석분류관리 (Comment Classification Management)
- **설명:** 사업분석 주석에 대한 분류 기반 관리 규칙
- **조건:** 사업분석 주석이 저장될 때 적절한 분류 코드가 적용되어야 함
- **관련 엔티티:** BE-033-003
- **예외:** 유효하지 않은 주석 분류가 제공되면 분류 오류

### BR-033-004: 데이터업데이트거래제어 (Data Update Transaction Control)
- **설명:** 사업분석 데이터 업데이트 운영에 대한 거래 제어 규칙
- **조건:** 기존 사업분석 데이터가 업데이트될 때 신규 데이터 삽입 전에 이전 데이터가 삭제되어야 함
- **관련 엔티티:** BE-033-002, BE-033-003
- **예외:** 데이터 업데이트 운영이 실패하면 거래 롤백

### BR-033-005: 처리건수검증 (Processing Count Validation)
- **설명:** 처리 건수 일관성 및 정확성에 대한 검증 규칙
- **조건:** 사업분석 저장 운영이 완료될 때 처리 건수는 실제 운영 결과를 반영해야 함
- **관련 엔티티:** BE-033-004
- **예외:** 처리 건수가 일치하지 않으면 건수 불일치 오류

### BR-033-006: 다년도재무분석일관성 (Multi-Year Financial Analysis Consistency)
- **설명:** 다년도 재무분석 데이터 관리에 대한 일관성 규칙
- **조건:** 다년도 사업부문 데이터가 처리될 때 기준년, N-1년, N-2년 데이터는 논리적 일관성을 유지해야 함
- **관련 엔티티:** BE-033-002
- **예외:** 다년도 재무 데이터 관계가 유효하지 않으면 데이터 일관성 오류

## 4. 업무 기능

### F-033-001: 기업집단사업분석파라미터검증 (Corporate Group Business Analysis Parameter Validation)
- **설명:** 기업집단 사업분석 저장 운영을 위한 입력 파라미터 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사 분류 식별자 |
| corpClctGroupCd | String | 기업집단 분류 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| valuaYmd | String | YYYYMMDD 형식의 평가일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| validationResult | String | 파라미터 검증 결과 상태 |
| errorMessage | String | 검증 실패 시 오류 메시지 |

**처리 로직:**
1. 그룹회사코드가 공백이거나 null이 아닌지 검증
2. 기업집단그룹코드가 공백이거나 null이 아닌지 검증
3. 기업집단등록코드가 공백이거나 null이 아닌지 검증
4. 평가년월일이 공백이 아니고 유효한 YYYYMMDD 형식인지 검증
5. 적절한 상태 및 오류 메시지와 함께 검증 결과 반환

### F-033-002: 사업부문분석데이터처리 (Business Sector Analysis Data Processing)
- **설명:** 다년도 비교를 포함한 사업부문 재무분석 데이터 처리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| businessSectorData | Array | 사업부문 분석 레코드 배열 |
| totalCount1 | Numeric | 사업부문 레코드의 총 개수 |
| currentCount1 | Numeric | 사업부문 레코드의 현재 개수 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| processedCount | Numeric | 성공적으로 처리된 레코드 수 |
| processingStatus | String | 전체 처리 상태 결과 |

**처리 로직:**
1. 사업부문 데이터 배열 및 건수 파라미터 검증
2. 각 사업부문 분석 레코드를 반복 처리
3. 재무분석보고서구분 및 항목코드 검증
4. 다년도 재무 데이터(기준년, N-1, N-2) 처리
5. 금액, 비율, 업체수 일관성 검증
6. 처리된 사업부문 분석 데이터 저장
7. 처리 건수 및 상태 결과 반환

### F-033-003: 사업분석주석관리 (Business Analysis Comment Management)
- **설명:** 분류 기반 조직화를 통한 사업분석 주석 및 의견 관리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| commentData | Array | 사업분석 주석 레코드 배열 |
| totalCount2 | Numeric | 주석 레코드의 총 개수 |
| currentCount2 | Numeric | 주석 레코드의 현재 개수 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| storedCommentCount | Numeric | 성공적으로 저장된 주석 수 |
| commentStatus | String | 주석 저장 운영 상태 |

**처리 로직:**
1. 주석 데이터 배열 및 건수 파라미터 검증
2. 각 사업분석 주석 레코드 처리
3. 기업집단주석구분코드 검증
4. 적절한 분류와 함께 주석 내용 저장
5. 주석-분석 관계 무결성 유지
6. 저장된 주석 수 및 운영 상태 반환

### F-033-004: 데이터업데이트거래제어 (Data Update Transaction Control)
- **설명:** 사업분석 데이터 업데이트를 위한 거래 운영 제어

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 데이터 선택을 위한 그룹회사 식별자 |
| corpClctGroupCd | String | 기업집단 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| valuaYmd | String | 데이터 선택을 위한 평가일자 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| deletedRecordCount | Numeric | 삭제된 기존 레코드 수 |
| transactionStatus | String | 거래 운영 상태 |

**처리 로직:**
1. 입력 파라미터를 사용하여 기존 사업분석 데이터 조회
2. 발견된 경우 기존 사업부문 분석 레코드 삭제
3. 발견된 경우 기존 주석 레코드 삭제
4. 삭제 프로세스 전반에 걸쳐 거래 무결성 유지
5. 신규 데이터 삽입 운영 준비
6. 삭제 건수 및 거래 상태 반환

### F-033-005: 사업분석저장응답생성 (Business Analysis Storage Response Generation)
- **설명:** 사업분석 저장 운영에 대한 응답 데이터 생성

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| processedBusinessSectorCount | Numeric | 처리된 사업부문 레코드 수 |
| processedCommentCount | Numeric | 처리된 주석 레코드 수 |
| operationStatus | String | 전체 운영 상태 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| totalNoitm | Numeric | 처리된 레코드의 총 개수 |
| prsntNoitm | Numeric | 처리된 레코드의 현재 개수 |
| responseStatus | String | 최종 응답 상태 |

**처리 로직:**
1. 사업부문 및 주석 건수로부터 총 처리 레코드 수 계산
2. 성공적인 운영을 기반으로 현재 처리 레코드 수 결정
3. 모든 운영 결과를 기반으로 포괄적 응답 상태 생성
4. 응답 건수 일관성 및 정확성 검증
5. 처리 건수 및 상태와 함께 최종 응답 데이터 반환

## 5. 프로세스 흐름

```
기업집단사업분석저장 프로세스 흐름
├── 입력 파라미터 검증
│   ├── 그룹회사코드 검증
│   ├── 기업집단그룹코드 검증
│   ├── 기업집단등록코드 검증
│   └── 평가년월일 검증
├── 공통영역 설정 및 초기화
│   ├── 비계약업무구분 설정
│   ├── 공통 IC 프로그램 호출
│   └── 출력영역 할당
├── 기존 데이터 검색 및 삭제
│   ├── 사업부문분석 데이터 조회
│   ├── 기존 레코드 삭제 프로세스
│   └── 거래 무결성 유지
├── 사업부문분석 데이터 처리
│   ├── 재무분석보고서 데이터 검증
│   ├── 다년도 재무 데이터 처리
│   │   ├── 기준년 데이터 처리
│   │   ├── N-1년 데이터 처리
│   │   └── N-2년 데이터 처리
│   ├── 사업부문분류 관리
│   └── 데이터베이스 삽입 운영
├── 사업분석주석 처리
│   ├── 주석분류 검증
│   ├── 주석내용 처리
│   └── 주석 데이터베이스 저장
├── 응답 데이터 생성
│   ├── 처리건수 계산
│   ├── 운영상태 결정
│   └── 최종 응답 조립
└── 거래 완료 및 정리
    ├── 처리결과 검증
    ├── 오류처리 및 롤백
    └── 시스템 자원 정리
```

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIPBA66.cbl**: 기업집단 사업분석 저장을 위한 메인 애플리케이션 서버 프로그램
- **DIPA661.cbl**: 사업분석 저장 운영을 위한 데이터 컨트롤러 프로그램
- **IJICOMM.cbl**: 공통 인터페이스 통신 프로그램
- **QIPA661.cbl**: 사업부문 분석 데이터 검색을 위한 SQL 조회 프로그램
- **RIPA113.cbl**: THKIPB113 테이블 운영을 위한 데이터베이스 I/O 프로그램
- **RIPA130.cbl**: THKIPB130 테이블 운영을 위한 데이터베이스 I/O 프로그램
- **YNIPBA66.cpy**: 입력 파라미터 카피북 구조
- **YPIPBA66.cpy**: 출력 파라미터 카피북 구조
- **XDIPA661.cpy**: 데이터 컨트롤러 인터페이스 카피북
- **TRIPB113.cpy**: THKIPB113 테이블 구조 카피북
- **TRIPB130.cpy**: THKIPB130 테이블 구조 카피북
- **YCCOMMON.cpy**: 공통 처리 영역 카피북
- **YCDBIOCA.cpy**: 데이터베이스 I/O 통신 영역 카피북
- **YCDBSQLA.cpy**: 데이터베이스 SQL 통신 영역 카피북

### 6.2 업무 규칙 구현

- **BR-033-001:** AIPBA66.cbl의 150-175행에 구현 (기업집단파라미터검증)
  ```cobol
  IF YNIPBA66-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIPBA66-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF.
  IF YNIPBA66-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **BR-033-002:** DIPA661.cbl의 160-180행에 구현 (사업부문데이터무결성)
  ```cobol
  IF  XDIPA661-I-CORP-CLCT-GROUP-CD  =  SPACE
      #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF  XDIPA661-I-CORP-CLCT-REGI-CD  =  SPACE
      #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF.
  IF  XDIPA661-I-VALUA-YMD  =  SPACE
      #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **BR-033-003:** DIPA661.cbl의 330-350행에 구현 (주석분류관리)
  ```cobol
  IF XDIPA661-I-CORP-C-COMT-DSTCD(WK-I) = SPACE
     #ERROR CO-B3800004 CO-UKIP0004 CO-STAT-ERROR
  END-IF.
  MOVE XDIPA661-I-CORP-C-COMT-DSTCD(WK-I)
    TO TRIPB130-CORP-C-COMT-DSTCD.
  ```

- **BR-033-004:** DIPA661.cbl의 190-220행에 구현 (데이터업데이트거래제어)
  ```cobol
  IF WK-DATA-YN  =  'Y'  THEN
     PERFORM S3200-THKIPB113-INSERT-RTN
        THRU S3200-THKIPB113-INSERT-EXT
     VARYING WK-I  FROM 1  BY 1
       UNTIL WK-I >  XDIPA661-I-TOTAL-NOITM1
  END-IF.
  IF XDIPA661-I-TOTAL-NOITM2 > 0
     PERFORM S3300-THKIPB130-INSERT-RTN
        THRU S3300-THKIPB130-INSERT-EXT
     VARYING WK-I  FROM 1  BY 1
       UNTIL WK-I >  XDIPA661-I-TOTAL-NOITM2
  END-IF.
  ```

- **BR-033-005:** DIPA661.cbl의 210-225행에 구현 (처리건수검증)
  ```cobol
  MOVE  XDIPA661-I-TOTAL-NOITM1
    TO  XDIPA661-O-TOTAL-NOITM
  MOVE  XDIPA661-I-PRSNT-NOITM1
    TO  XDIPA661-O-PRSNT-NOITM
  IF XDIPA661-O-TOTAL-NOITM NOT = XDIPA661-O-PRSNT-NOITM
     #ERROR CO-B4200095 CO-UKJI0299 CO-STAT-ERROR
  END-IF.
  ```

- **BR-033-006:** RIPA113.cbl의 180-200행에 구현 (다년도재무분석일관성)
  ```cobol
  IF TRIPB113-BASE-YR-ITEM-AMT < ZERO
     #ERROR CO-B4200095 CO-UKJI0299 CO-STAT-ERROR
  END-IF.
  IF TRIPB113-N1-YR-BF-ITEM-AMT < ZERO
     #ERROR CO-B4200095 CO-UKJI0299 CO-STAT-ERROR
  END-IF.
  IF TRIPB113-N2-YR-BF-ITEM-AMT < ZERO
     #ERROR CO-B4200095 CO-UKJI0299 CO-STAT-ERROR
  END-IF.
  ```

- **BR-033-007:** RIPA113.cbl의 220-240행에 구현 (저장운영검증)
  ```cobol
  IF SQLCODE NOT = ZERO
     #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
  END-IF.
  ADD 1 TO WK-INSERT-CNT.
  ```

- **BR-033-008:** DIPA661.cbl의 380-400행에 구현 (거래완료검증)
  ```cobol
  IF WK-INSERT-CNT NOT = XDIPA661-I-TOTAL-NOITM1
     #ERROR CO-B4200219 CO-UKJI0299 CO-STAT-ERROR
  END-IF.
  MOVE 'SUCCESS' TO XDIPA661-O-PROCESS-STATUS.
  ```

### 6.3 기능 구현

- **F-033-001:** AIPBA66.cbl의 150-175행에 구현 (기업집단사업분석파라미터검증)
  ```cobol
  IF YNIPBA66-GROUP-CO-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIPBA66-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIPBA66-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF.
  IF YNIPBA66-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **F-033-002:** DIPA661.cbl의 240-320행에 구현 (사업부문분석데이터처리)
  ```cobol
  PERFORM S3200-THKIPB113-INSERT-RTN
     THRU S3200-THKIPB113-INSERT-EXT
  VARYING WK-I FROM 1 BY 1
    UNTIL WK-I > XDIPA661-I-TOTAL-NOITM1.
  
  MOVE XDIPA661-I-FNAF-A-RPTDOC-DSTCD(WK-I)
    TO TRIPB113-FNAF-A-RPTDOC-DSTCD.
  MOVE XDIPA661-I-FNAF-ITEM-CD(WK-I)
    TO TRIPB113-FNAF-ITEM-CD.
  MOVE XDIPA661-I-BIZ-SECT-NO(WK-I)
    TO TRIPB113-BIZ-SECT-NO.
  ```

- **F-033-003:** DIPA661.cbl의 280-320행에 구현 (기존데이터삭제처리)
  ```cobol
  MOVE  BICOM-GROUP-CO-CD
    TO  XQIPA661-I-GROUP-CO-CD
  MOVE  XDIPA661-I-CORP-CLCT-GROUP-CD
    TO  XQIPA661-I-CORP-CLCT-GROUP-CD
  MOVE  XDIPA661-I-CORP-CLCT-REGI-CD
    TO  XQIPA661-I-CORP-CLCT-REGI-CD
  MOVE  XDIPA661-I-VALUA-YMD
    TO  XQIPA661-I-VALUA-YMD
  #DYSQLA  QIPA661 SELECT XQIPA661-CA
  ```

- **F-033-004:** RIPA113.cbl의 150-200행에 구현 (신규데이터삽입처리)
  ```cobol
  MOVE BICOM-GROUP-CO-CD
    TO TRIPB113-GROUP-CO-CD.
  MOVE XDIPA661-I-CORP-CLCT-GROUP-CD
    TO TRIPB113-CORP-CLCT-GROUP-CD.
  MOVE XDIPA661-I-CORP-CLCT-REGI-CD
    TO TRIPB113-CORP-CLCT-REGI-CD.
  MOVE XDIPA661-I-VALUA-YMD
    TO TRIPB113-VALUA-YMD.
  #DYSQLA RIPA113 INSERT TRIPB113-CA
  ```

- **F-033-005:** DIPA661.cbl의 210-225행에 구현 (사업분석저장응답포맷팅)
  ```cobol
  MOVE  XDIPA661-I-TOTAL-NOITM1
    TO  XDIPA661-O-TOTAL-NOITM
  MOVE  XDIPA661-I-PRSNT-NOITM1
    TO  XDIPA661-O-PRSNT-NOITM
  MOVE XDIPA661-OUT
    TO YPIPBA66-CA.
  ```
  ```

- **응답 생성 (DIPA661.cbl의 210-225행)**:
  ```cobol
  MOVE  XDIPA661-I-TOTAL-NOITM1
    TO  XDIPA661-O-TOTAL-NOITM
  MOVE  XDIPA661-I-PRSNT-NOITM1
    TO  XDIPA661-O-PRSNT-NOITM
  MOVE XDIPA661-OUT
    TO YPIPBA66-CA.
  ```

### 6.4 데이터베이스 테이블
- **THKIPB113 (기업집단재무분석목록)**: 다년도 재무정보를 포함한 사업부문 분석 데이터를 저장하는 기업집단 재무분석 목록 테이블
- **THKIPB130 (기업집단주석명세)**: 분류 관리를 통한 사업분석 의견 및 주석을 저장하는 기업집단 주석 명세 테이블

### 6.5 오류 코드

#### 6.5.1 파라미터 검증 오류
- **B3800004**: 필수 필드 누락 오류 - 필수 파라미터가 제공되지 않았을 때 발생
- **UKIP0001**: 그룹회사코드 검증 오류 - 유효하지 않거나 누락된 그룹회사 식별자
- **UKIP0002**: 기업집단등록코드 검증 오류 - 유효하지 않거나 누락된 등록 식별자
- **UKIP0003**: 평가년월일 검증 오류 - 유효하지 않거나 누락된 평가일자

#### 6.5.2 데이터베이스 운영 오류
- **B3900009**: 데이터베이스 접근 오류 - 데이터 검색 또는 조작 운영이 실패했을 때 발생
- **UKII0182**: 시스템 오류 처리 - 기술 지원 연락이 필요한 일반적인 시스템 오류
- **B4200095**: 데이터베이스 무결성 오류 - 데이터 일관성 검증 실패
- **B4200219**: 거래 처리 오류 - 데이터베이스 거래 운영 실패

#### 6.5.3 업무 로직 오류
- **B3900009**: 업무 규칙 검증 오류 - 업무 로직 제약조건이 위반되었을 때 발생
- **UKJI0299**: 처리 로직 오류 - 업무 처리 운영 실패

### 6.6 기술 아키텍처
- **애플리케이션 서버 계층**: AIPBA66이 사용자 인터페이스 및 업무 로직 조정을 처리
- **데이터 컨트롤러 계층**: DIPA661이 사업분석 저장 운영 및 데이터 흐름을 관리
- **데이터베이스 접근 계층**: RIPA113, RIPA130, QIPA661이 데이터베이스 운영 및 SQL 처리를 담당
- **공통 프레임워크 계층**: IJICOMM, YCCOMMON이 공유 서비스 및 통신을 제공
- **데이터 구조 계층**: 카피북이 데이터 구조 및 인터페이스 명세를 정의

### 6.7 데이터 흐름 아키텍처
1. **입력 처리**: YNIPBA66이 검증 파라미터와 함께 기업집단 사업분석 데이터를 수신
2. **파라미터 검증**: 그룹코드 및 평가일자에 대한 필수 필드 검증
3. **공통영역 설정**: IJICOMM이 공통 처리 환경 및 업무 분류를 초기화
4. **데이터 검색**: QIPA661이 업데이트 운영을 위한 기존 사업분석 데이터를 조회
5. **데이터 삭제**: RIPA113 및 RIPA130이 데이터 무결성 유지를 위해 기존 레코드를 삭제
6. **데이터 삽입**: 데이터베이스 I/O 프로그램을 통한 신규 사업부문 분석 및 주석 데이터 삽입
7. **응답 생성**: YPIPBA66이 처리 건수 및 운영 상태를 반환
8. **거래 완료**: 거래 완료를 위한 시스템 정리 및 자원 관리
