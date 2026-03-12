# 업무 명세서: 기업집단연혁관리시스템 (Corporate Group History Management System)

## 문서 관리
- **버전:** 1.0
- **날짜:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-038
- **진입점:** AIPBA63
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 거래처리 도메인에서 포괄적인 온라인 기업집단 연혁관리 시스템을 구현합니다. 시스템은 자동화된 검증 및 데이터베이스 지속성 기능을 통한 다중그리드 데이터 입력을 지원하여 실시간 기업집단 연혁데이터 관리 기능을 제공하며, 기업집단 평가 및 감사추적 유지를 위한 기능을 제공합니다.

업무 목적은 다음과 같습니다:
- 다중그리드 데이터 입력 지원을 통한 포괄적 기업집단 연혁관리 제공 (Provide comprehensive corporate group history management with multi-grid data entry support)
- 기업집단 연혁사건 및 주석데이터의 실시간 저장 및 관리 지원 (Support real-time storage and management of corporate group historical events and commentary data)
- 시간순 정렬 및 내용관리를 통한 구조화된 연혁데이터 조직화 지원 (Enable structured historical data organization with chronological ordering and content management)
- 자동 검증 및 트랜잭션 데이터베이스 운영을 통한 데이터 무결성 유지 (Maintain data integrity through automated validation and transactional database operations)
- 최적화된 데이터베이스 접근 및 배치 운영을 통한 확장 가능한 연혁처리 제공 (Provide scalable history processing through optimized database access and batch operations)
- 구조화된 연혁문서화 및 관리부점 추적을 통한 규제 준수 지원 (Support regulatory compliance through structured historical documentation and management branch tracking)

시스템은 포괄적인 다중모듈 온라인 흐름을 통해 데이터를 처리합니다: AIPBA63 → IJICOMM → YCCOMMON → XIJICOMM → DIPA631 → RIPA111 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA130 → RIPA110 → TRIPB111 → TKIPB111 → TRIPB130 → TKIPB130 → TRIPB110 → TKIPB110 → YCDBSQLA → XDIPA631 → XZUGOTMY → YNIPBA63 → YPIPBA63, 기업집단 파라미터 검증, 연혁데이터 처리, 다중테이블 데이터베이스 운영, 결과 집계 운영을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 필수필드 검증을 포함한 기업집단 연혁파라미터 검증 (Corporate group history parameter validation with mandatory field verification)
- 시간순 이벤트 관리 및 내용 검증을 포함한 다중그리드 연혁데이터 입력 (Multi-grid historical data entry with chronological event management and content validation)
- 구조화된 주석관리 및 내용 조직화를 포함한 기업집단 주석처리 (Corporate group commentary processing with structured annotation management and content organization)
- 조정된 삽입, 수정, 삭제 처리를 통한 트랜잭션 데이터베이스 운영 (Transactional database operations through coordinated insert, update, and delete processing)
- 조직계층 유지를 포함한 관리부점 추적 및 업데이트 (Management branch tracking and update with organizational hierarchy maintenance)
- 기업집단 평가지원을 위한 처리결과 최적화 및 감사추적 유지 (Processing result optimization and audit trail maintenance for corporate group evaluation support)
## 2. 업무 엔티티

### BE-038-001: 기업집단연혁관리요청 (Corporate Group History Management Request)
- **설명:** 다중그리드 데이터 입력 지원을 통한 기업집단 연혁관리 운영을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 현재건수1 (Current Item Count 1) | Numeric | 5 | NOT NULL | 그리드 1의 현재 연혁 항목 수 | YNIPBA63-PRSNT-NOITM1 | prsntNoitm1 |
| 총건수1 (Total Item Count 1) | Numeric | 5 | NOT NULL | 그리드 1의 총 연혁 항목 수 | YNIPBA63-TOTAL-NOITM1 | totalNoitm1 |
| 현재건수2 (Current Item Count 2) | Numeric | 5 | NOT NULL | 그리드 2의 현재 주석 항목 수 | YNIPBA63-PRSNT-NOITM2 | prsntNoitm2 |
| 총건수2 (Total Item Count 2) | Numeric | 5 | NOT NULL | 그리드 2의 총 주석 항목 수 | YNIPBA63-TOTAL-NOITM2 | totalNoitm2 |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA63-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA63-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 기업집단 평가를 위한 평가일자 | YNIPBA63-VALUA-YMD | valuaYmd |
| 관리부점코드 (Management Branch Code) | String | 4 | NOT NULL | 기업집단을 담당하는 관리부점 | YNIPBA63-MGT-BRNCD | mgtBrncd |

- **검증 규칙:**
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 YYYYMMDD 형식이어야 함
  - 관리부점코드는 조직 추적을 위해 필수
  - 현재건수1은 총건수1을 초과할 수 없음
  - 현재건수2는 총건수2를 초과할 수 없음
  - 그리드 데이터 배열은 현재 항목 수에 기반하여 처리됨

### BE-038-002: 기업집단연혁항목 (Corporate Group History Item)
- **설명:** 시간순 정보 및 내용 세부사항을 포함한 개별 연혁 이벤트 항목
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 장표출력여부 (Document Output Flag) | String | 1 | '0' 또는 '1' | 항목이 문서 출력에 포함되어야 하는지를 나타내는 플래그 | YNIPBA63-SHET-OUTPT-YN | shetOutptYn |
| 연혁년월일 (History Date) | String | 8 | YYYYMMDD 형식 | 연혁 이벤트가 발생한 날짜 | YNIPBA63-ORDVL-YMD | ordvlYmd |
| 연혁내용 (History Content) | String | 202 | NOT NULL | 연혁 이벤트의 상세 설명 | YNIPBA63-ORDVL-CTNT | ordvlCtnt |

- **검증 규칙:**
  - 장표출력여부는 '0'(제외) 또는 '1'(포함)이어야 함
  - 연혁년월일은 제공될 때 유효한 YYYYMMDD 형식이어야 함
  - 연혁내용은 필수이며 공백일 수 없음
  - 항목들은 배열 인덱스에 기반하여 순차적으로 처리됨
  - 장표출력여부가 '1'인 항목만 데이터베이스에 저장됨

### BE-038-003: 기업집단주석항목 (Corporate Group Commentary Item)
- **설명:** 구조화된 내용 관리를 통한 기업집단 평가를 위한 주석 및 어노테이션 항목
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 기업집단주석구분 (Corporate Group Commentary Classification) | String | 2 | NOT NULL | 주석 유형에 대한 분류 코드 | YNIPBA63-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 주석내용 (Commentary Content) | String | 2002 | NOT NULL | 기업집단에 대한 상세 주석 내용 | YNIPBA63-COMT-CTNT | comtCtnt |

- **검증 규칙:**
  - 기업집단주석구분은 필수
  - 주석내용은 필수이며 공백일 수 없음
  - 내용 길이는 광범위한 주석 요구사항을 지원
  - 분류는 주석 조직화 및 검색을 결정
  - 항목들은 총건수2에 기반하여 처리됨

### BE-038-004: 기업집단연혁명세 (Corporate Group History Specification)
- **설명:** 감사추적 정보를 포함한 기업집단 연혁 이벤트에 대한 데이터베이스 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB111-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB111-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB111-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 연혁 레코드를 위한 평가일자 | RIPB111-VALUA-YMD | valuaYmd |
| 일련번호 (Serial Number) | Numeric | 4 | NOT NULL | 연혁 항목의 순차 번호 | RIPB111-SERNO | serno |
| 장표출력여부 (Document Output Flag) | String | 1 | '0' 또는 '1' | 문서 출력 포함 플래그 | RIPB111-SHET-OUTPT-YN | shetOutptYn |
| 연혁년월일 (History Date) | String | 8 | YYYYMMDD 형식 | 연혁 이벤트 발생일자 | RIPB111-ORDVL-YMD | ordvlYmd |
| 연혁내용 (History Content) | String | 202 | NOT NULL | 연혁 이벤트 설명 | RIPB111-ORDVL-CTNT | ordvlCtnt |

- **검증 규칙:**
  - 모든 키 필드는 고유 레코드 식별을 위해 필수
  - 일련번호는 평가일자 내에서 순차적 정렬을 제공
  - 장표출력여부는 생성된 보고서에 포함을 제어
  - 연혁년월일은 이벤트의 시간순 조직화를 지원
  - 연혁내용은 상세한 이벤트 문서화를 제공
  - 레코드는 트랜잭션 데이터베이스 운영을 통해 관리됨

### BE-038-005: 기업집단주석명세 (Corporate Group Commentary Specification)
- **설명:** 내용 관리를 통한 기업집단 주석 및 어노테이션에 대한 데이터베이스 명세
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB130-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 주석 레코드를 위한 평가일자 | RIPB130-VALUA-YMD | valuaYmd |
| 기업집단주석구분 (Corporate Group Commentary Classification) | String | 2 | NOT NULL | 주석 유형 분류 | RIPB130-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 일련번호 (Serial Number) | Numeric | 4 | NOT NULL | 주석 항목의 순차 번호 | RIPB130-SERNO | serno |
| 주석내용 (Commentary Content) | String | 4002 | NOT NULL | 상세 주석 내용 | RIPB130-COMT-CTNT | comtCtnt |

- **검증 규칙:**
  - 모든 키 필드는 고유 레코드 식별을 위해 필수
  - 주석구분은 내용 조직화를 결정
  - 일련번호는 분류 내에서 순차적 정렬을 제공
  - 주석내용은 광범위한 어노테이션 요구사항을 지원
  - 레코드는 트랜잭션 데이터베이스 운영을 통해 관리됨
  - 분류 '01'은 개요 주석 유형을 나타냄

### BE-038-006: 기업집단평가기본정보 (Corporate Group Evaluation Basic Information)
- **설명:** 관리부점 추적을 포함한 기본 기업집단 평가 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB110-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 기본 정보를 위한 평가일자 | RIPB110-VALUA-YMD | valuaYmd |
| 관리부점코드 (Management Branch Code) | String | 4 | NOT NULL | 기업집단을 담당하는 관리부점 | RIPB110-MGT-BRNCD | mgtBrncd |

- **검증 규칙:**
  - 모든 키 필드는 고유 레코드 식별을 위해 필수
  - 관리부점코드는 연혁관리 프로세스를 통해 업데이트됨
  - 연혁관리 운영 전에 레코드가 존재해야 함
  - 업데이트는 트랜잭션 데이터베이스 운영을 통해 수행됨
  - 관리부점 추적은 조직 계층을 지원
## 3. 업무 규칙

### BR-038-001: 기업집단파라미터검증규칙 (Corporate Group Parameter Validation Rule)
- **규칙명:** 기업집단파라미터검증규칙 (Corporate Group Parameter Validation Rule)
- **설명:** 연혁관리 운영을 위한 필수 기업집단 식별 파라미터를 검증
- **조건:** 기업집단 연혁관리가 요청될 때 기업집단코드, 등록코드, 평가일자가 제공되고 유효해야 함
- **관련 엔티티:** BE-038-001
- **예외:** 없음 - 모든 기업집단 연혁 운영은 유효한 그룹 식별이 필요

### BR-038-002: 연혁항목처리규칙 (History Item Processing Rule)
- **규칙명:** 연혁항목처리규칙 (History Item Processing Rule)
- **설명:** 장표출력플래그에 기반하여 처리되고 저장될 연혁 항목을 결정
- **조건:** 연혁 항목이 처리될 때 장표출력플래그가 '1'인 항목만 데이터베이스에 저장됨
- **관련 엔티티:** BE-038-002, BE-038-004
- **예외:** 플래그가 '0'인 항목은 데이터베이스 운영 중 건너뜀

### BR-038-003: 주석구분규칙 (Commentary Classification Rule)
- **규칙명:** 주석구분규칙 (Commentary Classification Rule)
- **설명:** 구조화된 어노테이션 관리를 위한 주석 분류를 강제
- **조건:** 주석 항목이 처리될 때 개요 주석 유형에 대해 분류코드 '01'이 사용됨
- **관련 엔티티:** BE-038-003, BE-038-005
- **예외:** 없음 - 분류는 처리 중 자동으로 할당됨

### BR-038-004: 트랜잭션데이터베이스운영규칙 (Transactional Database Operation Rule)
- **규칙명:** 트랜잭션데이터베이스운영규칙 (Transactional Database Operation Rule)
- **설명:** 조정된 데이터베이스 운영을 통해 데이터 일관성을 보장
- **조건:** 연혁 데이터가 저장될 때 새 레코드가 삽입되기 전에 기존 레코드가 삭제됨
- **관련 엔티티:** BE-038-004, BE-038-005
- **예외:** 데이터베이스 오류는 트랜잭션 롤백 및 오류 보고를 초래

### BR-038-005: 관리부점업데이트규칙 (Management Branch Update Rule)
- **규칙명:** 관리부점업데이트규칙 (Management Branch Update Rule)
- **설명:** 기업집단 기본 레코드의 관리부점 정보를 업데이트
- **조건:** 연혁관리가 완료될 때 기본정보 테이블의 관리부점코드가 업데이트됨
- **관련 엔티티:** BE-038-001, BE-038-006
- **예외:** 기본정보 레코드가 존재해야 하며 그렇지 않으면 오류가 보고됨

### BR-038-006: 일련번호할당규칙 (Serial Number Assignment Rule)
- **규칙명:** 일련번호할당규칙 (Serial Number Assignment Rule)
- **설명:** 연혁 및 주석 항목에 순차적 일련번호를 할당
- **조건:** 항목이 저장될 때 일련번호가 1부터 시작하여 순차적으로 할당됨
- **관련 엔티티:** BE-038-004, BE-038-005
- **예외:** 없음 - 순차적 번호 매기기는 적절한 정렬을 보장

### BR-038-007: 데이터검증규칙 (Data Validation Rule)
- **규칙명:** 데이터검증규칙 (Data Validation Rule)
- **설명:** 입력 데이터 형식 및 내용 요구사항을 검증
- **조건:** 데이터가 처리될 때 날짜는 YYYYMMDD 형식이어야 하고 내용 필드는 공백일 수 없음
- **관련 엔티티:** BE-038-001, BE-038-002, BE-038-003
- **예외:** 유효하지 않은 데이터는 오류 보고 및 트랜잭션 종료를 초래

### BR-038-008: 그리드처리규칙 (Grid Processing Rule)
- **규칙명:** 그리드처리규칙 (Grid Processing Rule)
- **설명:** 현재 항목 수에 기반하여 다중그리드 데이터를 처리
- **조건:** 그리드 데이터가 처리될 때 각 그리드의 현재 항목 수로 처리가 제한됨
- **관련 엔티티:** BE-038-001, BE-038-002, BE-038-003
- **예외:** 현재 항목 수는 총 항목 수를 초과할 수 없음

### BR-038-009: 데이터베이스정리규칙 (Database Cleanup Rule)
- **규칙명:** 데이터베이스정리규칙 (Database Cleanup Rule)
- **설명:** 중복을 방지하기 위해 새 데이터를 삽입하기 전에 기존 레코드를 제거
- **조건:** 새 연혁 데이터가 저장될 때 동일한 기업집단 및 평가일자의 기존 레코드가 먼저 삭제됨
- **관련 엔티티:** BE-038-004, BE-038-005
- **예외:** 삽입 운영 전에 삭제 운영이 성공적으로 완료되어야 함

### BR-038-010: 오류처리규칙 (Error Handling Rule)
- **규칙명:** 오류처리규칙 (Error Handling Rule)
- **설명:** 모든 데이터베이스 및 검증 운영에 대한 포괄적인 오류 처리를 제공
- **조건:** 오류가 발생할 때 적절한 오류코드 및 처리 메시지가 사용자에게 반환됨
- **관련 엔티티:** 모든 엔티티
- **예외:** 시스템 오류는 상세한 오류 정보와 함께 비정상 종료를 초래
## 4. 업무 기능

### F-038-001: 기업집단파라미터검증기능 (Corporate Group Parameter Validation Function)
- **기능명:** 기업집단파라미터검증기능 (Corporate Group Parameter Validation Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 분류 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | YYYYMMDD 형식의 평가일자 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| validationResult | String | 2 | 검증 결과 상태 |
| errorCode | String | 8 | 검증 실패 시 오류 코드 |
| treatmentCode | String | 8 | 오류 처리를 위한 처리 코드 |

#### 처리 로직
1. 기업집단코드가 공백이 아닌지 검증
2. 기업집단등록코드가 공백이 아닌지 검증
3. 평가일자가 공백이 아니고 올바른 형식인지 검증
4. 파라미터 형식 및 업무규칙 준수 확인
5. 적절한 오류코드와 함께 검증 결과 반환

### F-038-002: 연혁데이터처리기능 (History Data Processing Function)
- **기능명:** 연혁데이터처리기능 (History Data Processing Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| prsntNoitm1 | Numeric | 5 | 현재 연혁 항목 수 |
| historyItems | Array | Variable | 연혁 항목 데이터 배열 |
| corpClctGroupCd | String | 3 | 기업집단 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | 평가일자 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| processedCount | Numeric | 5 | 처리된 항목 수 |
| processingResult | String | 2 | 처리 결과 상태 |
| errorMessage | String | 100 | 처리 실패 시 오류 메시지 |

#### 처리 로직
1. 기업집단 및 평가일자에 대한 기존 연혁 레코드 삭제
2. 현재 항목 수에 기반하여 연혁 항목 처리
3. 장표출력플래그가 '1'인 항목 필터링
4. 순차적 일련번호로 새 연혁 레코드 삽입
5. 건수 정보와 함께 처리 결과 반환

### F-038-003: 주석데이터처리기능 (Commentary Data Processing Function)
- **기능명:** 주석데이터처리기능 (Commentary Data Processing Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| totalNoitm2 | Numeric | 5 | 총 주석 항목 수 |
| commentaryItems | Array | Variable | 주석 항목 데이터 배열 |
| corpClctGroupCd | String | 3 | 기업집단 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | 평가일자 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| processedCount | Numeric | 5 | 처리된 주석 항목 수 |
| processingResult | String | 2 | 처리 결과 상태 |
| errorMessage | String | 100 | 처리 실패 시 오류 메시지 |

#### 처리 로직
1. 기업집단 및 평가일자에 대한 기존 주석 레코드 삭제
2. 총 항목 수에 기반하여 주석 항목 처리
3. 개요 주석에 대해 분류코드 '01' 할당
4. 순차적 일련번호로 새 주석 레코드 삽입
5. 건수 정보와 함께 처리 결과 반환

### F-038-004: 관리부점업데이트기능 (Management Branch Update Function)
- **기능명:** 관리부점업데이트기능 (Management Branch Update Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| corpClctGroupCd | String | 3 | 기업집단 코드 |
| corpClctRegiCd | String | 3 | 기업집단 등록 코드 |
| valuaYmd | String | 8 | 평가일자 |
| mgtBrncd | String | 4 | 관리부점 코드 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| updateResult | String | 2 | 업데이트 결과 상태 |
| errorCode | String | 8 | 업데이트 실패 시 오류 코드 |
| treatmentCode | String | 8 | 오류 처리를 위한 처리 코드 |

#### 처리 로직
1. 기업집단 기본정보 레코드 위치 확인
2. 업데이트 운영을 위한 레코드 잠금
3. 관리부점코드 업데이트
4. 업데이트 트랜잭션 커밋
5. 상태 정보와 함께 업데이트 결과 반환

### F-038-005: 데이터베이스트랜잭션관리기능 (Database Transaction Management Function)
- **기능명:** 데이터베이스트랜잭션관리기능 (Database Transaction Management Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| operationType | String | 10 | 데이터베이스 운영 유형 |
| tableIdentifier | String | 20 | 대상 테이블 식별자 |
| recordData | Object | Variable | 운영을 위한 레코드 데이터 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| transactionResult | String | 2 | 트랜잭션 결과 상태 |
| recordsAffected | Numeric | 5 | 영향받은 레코드 수 |
| errorInformation | String | 200 | 상세 오류 정보 |

#### 처리 로직
1. 데이터베이스 연결 및 트랜잭션 초기화
2. 지정된 데이터베이스 운영 실행
3. 데이터베이스 오류 및 예외 처리
4. 결과에 기반하여 트랜잭션 커밋 또는 롤백
5. 트랜잭션 상태 및 영향받은 레코드 수 반환

### F-038-006: 결과집계기능 (Result Aggregation Function)
- **기능명:** 결과집계기능 (Result Aggregation Function)

#### 입력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| historyProcessingResult | Object | Variable | 연혁 처리 결과 데이터 |
| commentaryProcessingResult | Object | Variable | 주석 처리 결과 데이터 |
| updateResult | Object | Variable | 관리부점 업데이트 결과 |

#### 출력 파라미터
| 파라미터 | 데이터 타입 | 길이 | 설명 |
|----------|-------------|------|------|
| totalNoitm | Numeric | 5 | 처리된 총 항목 수 |
| prsntNoitm | Numeric | 5 | 처리된 현재 항목 수 |
| overallStatus | String | 2 | 전체 처리 상태 |

#### 처리 로직
1. 모든 운영의 처리 결과 집계
2. 총 및 현재 항목 수 계산
3. 전체 처리 상태 결정
4. 응답을 위한 출력 구조 형식화
5. 포괄적인 처리 요약 반환
## 5. 프로세스 흐름

### 기업집단연혁관리 프로세스 흐름

```
기업집단연혁관리시스템 (Corporate Group History Management System)
├── 입력파라미터수신 (Input Parameter Reception)
│   ├── 기업집단코드검증 (Corporate Group Code Validation)
│   ├── 기업집단등록코드검증 (Corporate Group Registration Code Validation)
│   ├── 평가일자검증 (Evaluation Date Validation)
│   └── 관리부점코드검증 (Management Branch Code Validation)
├── 공통프레임워크초기화 (Common Framework Initialization)
│   ├── 비계약업무구분설정 (Non-Contract Business Classification Setup)
│   ├── 공통인터페이스컴포넌트호출 (Common Interface Component Call)
│   └── 출력영역할당 (Output Area Allocation)
├── 데이터베이스컨트롤러처리 (Database Controller Processing)
│   ├── 연혁데이터관리 (History Data Management)
│   │   ├── 기존연혁레코드삭제 (Existing History Record Deletion)
│   │   │   ├── 연혁테이블쿼리실행 (History Table Query Execution)
│   │   │   ├── 레코드검색및잠금 (Record Retrieval and Lock)
│   │   │   └── 배치레코드삭제 (Batch Record Deletion)
│   │   └── 신규연혁레코드삽입 (New History Record Insertion)
│   │       ├── 장표출력플래그필터링 (Document Output Flag Filtering)
│   │       ├── 일련번호할당 (Serial Number Assignment)
│   │       └── 연혁레코드생성 (History Record Creation)
│   ├── 주석데이터관리 (Commentary Data Management)
│   │   ├── 기존주석레코드삭제 (Existing Commentary Record Deletion)
│   │   │   ├── 주석테이블쿼리실행 (Commentary Table Query Execution)
│   │   │   ├── 구분기반레코드검색 (Classification-Based Record Retrieval)
│   │   │   └── 배치주석삭제 (Batch Commentary Deletion)
│   │   └── 신규주석레코드삽입 (New Commentary Record Insertion)
│   │       ├── 주석구분할당 (Commentary Classification Assignment)
│   │       ├── 일련번호할당 (Serial Number Assignment)
│   │       └── 주석레코드생성 (Commentary Record Creation)
│   └── 관리부점업데이트 (Management Branch Update)
│       ├── 기본정보레코드검색 (Basic Information Record Retrieval)
│       ├── 레코드잠금및검증 (Record Lock and Validation)
│       └── 관리부점코드업데이트 (Management Branch Code Update)
├── 데이터베이스접근계층처리 (Database Access Layer Processing)
│   ├── THKIPB111연혁테이블운영 (THKIPB111 History Table Operations)
│   │   ├── 커서기반레코드삭제 (Cursor-Based Record Deletion)
│   │   ├── 트랜잭션레코드삽입 (Transactional Record Insertion)
│   │   └── 데이터무결성검증 (Data Integrity Validation)
│   ├── THKIPB130주석테이블운영 (THKIPB130 Commentary Table Operations)
│   │   ├── 구분기반쿼리처리 (Classification-Based Query Processing)
│   │   ├── 배치주석관리 (Batch Commentary Management)
│   │   └── 내용검증및저장 (Content Validation and Storage)
│   └── THKIPB110기본정보테이블운영 (THKIPB110 Basic Information Table Operations)
│       ├── 기본키기반레코드접근 (Primary Key-Based Record Access)
│       ├── 관리부점업데이트처리 (Management Branch Update Processing)
│       └── 트랜잭션커밋및검증 (Transaction Commit and Validation)
├── 결과조립 (Result Assembly)
│   ├── 처리건수집계 (Processing Count Aggregation)
│   │   ├── 연혁항목건수계산 (History Item Count Calculation)
│   │   ├── 주석항목건수계산 (Commentary Item Count Calculation)
│   │   └── 총처리건수할당 (Total Processing Count Assignment)
│   ├── 상태정보조립 (Status Information Assembly)
│   │   ├── 데이터베이스운영상태검증 (Database Operation Status Validation)
│   │   ├── 오류코드및메시지할당 (Error Code and Message Assignment)
│   │   └── 성공상태확인 (Success Status Confirmation)
│   └── 출력구조형식화 (Output Structure Formatting)
│       ├── 응답파라미터조립 (Response Parameter Assembly)
│       ├── 건수정보할당 (Count Information Assignment)
│       └── 상태코드할당 (Status Code Assignment)
└── 응답생성 (Response Generation)
    ├── 성공응답처리 (Success Response Processing)
    │   ├── 처리결과패키징 (Processing Result Packaging)
    │   ├── 건수정보반환 (Count Information Return)
    │   └── 성공상태할당 (Success Status Assignment)
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
- **AIPBA63.cbl**: 기업집단연혁관리시스템의 주요 진입점 프로그램
- **DIPA631.cbl**: 기업집단 연혁데이터 처리 및 관리를 위한 데이터베이스 컨트롤러
- **RIPA111.cbl**: THKIPB111 연혁테이블 운영을 위한 데이터베이스 I/O 프로세서
- **RIPA130.cbl**: THKIPB130 주석테이블 운영을 위한 데이터베이스 I/O 프로세서
- **RIPA110.cbl**: THKIPB110 기본정보테이블 운영을 위한 데이터베이스 I/O 프로세서
- **IJICOMM.cbl**: 프레임워크 초기화 및 설정을 위한 공통 인터페이스 컴포넌트
- **YNIPBA63.cpy**: 기업집단 연혁요청 구조를 정의하는 입력 파라미터 카피북
- **YPIPBA63.cpy**: 처리결과 구조를 정의하는 출력 파라미터 카피북
- **XDIPA631.cpy**: 파라미터 전달을 위한 데이터베이스 컨트롤러 인터페이스 카피북
- **TRIPB111.cpy**: THKIPB111 기업집단연혁테이블 레코드 구조
- **TKIPB111.cpy**: THKIPB111 기업집단연혁테이블 키 구조
- **TRIPB130.cpy**: THKIPB130 기업집단주석테이블 레코드 구조
- **TKIPB130.cpy**: THKIPB130 기업집단주석테이블 키 구조
- **TRIPB110.cpy**: THKIPB110 기업집단기본정보테이블 레코드 구조
- **TKIPB110.cpy**: THKIPB110 기업집단기본정보테이블 키 구조
- **XIJICOMM.cpy**: 프레임워크 운영을 위한 공통 인터페이스 컴포넌트 카피북
- **YCCOMMON.cpy**: 시스템 통합을 위한 공통 프레임워크 파라미터 카피북
- **YCDBIOCA.cpy**: 트랜잭션 관리를 위한 데이터베이스 I/O 접근 프레임워크 카피북
- **YCCSICOM.cpy**: 시스템 운영을 위한 공통 시스템 인터페이스 카피북
- **YCCBICOM.cpy**: 업무 운영을 위한 공통 업무 인터페이스 카피북
- **YCDBSQLA.cpy**: 쿼리 처리를 위한 데이터베이스 SQL 접근 프레임워크 카피북
- **XZUGOTMY.cpy**: 응답 처리를 위한 출력 메모리 관리 카피북

### 6.2 업무규칙 구현

- **BR-038-001:** AIPBA63.cbl 158-160행 및 DIPA631.cbl 185-189행에 구현 (기업집단파라미터검증)
  ```cobol
  IF YNIPBA63-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  
  IF  XDIPA631-I-CORP-CLCT-GROUP-CD  =  SPACE
      #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  ```

- **BR-038-002:** DIPA631.cbl 350-352행에 구현 (연혁항목처리규칙)
  ```cobol
  IF  XDIPA631-I-SHET-OUTPT-YN(WK-I) = '1' THEN
      PERFORM S3200-THKIPB111-INSERT-RTN
         THRU S3200-THKIPB111-INSERT-EXT
  END-IF
  ```

- **BR-038-003:** DIPA631.cbl 456-458행에 구현 (주석구분규칙)
  ```cobol
  MOVE  '01'
    TO  KIPB130-PK-CORP-C-COMT-DSTCD
        RIPB130-CORP-C-COMT-DSTCD
  ```

- **BR-038-004:** DIPA631.cbl 218-220행 및 240-242행에 구현 (트랜잭션데이터베이스운영규칙)
  ```cobol
  PERFORM S3100-THKIPB111-DELETE-RTN
     THRU S3100-THKIPB111-DELETE-EXT.

  PERFORM S3200-THKIPB111-INSERT-RTN
     THRU S3200-THKIPB111-INSERT-EXT
  ```

- **BR-038-005:** DIPA631.cbl 260-262행에 구현 (관리부점업데이트규칙)
  ```cobol
  PERFORM S3400-THKIPB110-UPDATE-RTN
     THRU S3400-THKIPB110-UPDATE-EXT
  ```

- **BR-038-006:** DIPA631.cbl 380-382행 및 620-622행에 구현 (일련번호할당규칙)
  ```cobol
  MOVE  WK-I
    TO  KIPB111-PK-SERNO
        RIPB111-SERNO
  
  MOVE WK-I
    TO KIPB130-PK-SERNO
       RIPB130-SERNO
  ```

- **BR-038-007:** AIPBA63.cbl 162-164행 및 DIPA631.cbl 195-197행에 구현 (데이터검증규칙)
  ```cobol
  IF YNIPBA63-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  
  IF  XDIPA631-I-VALUA-YMD          =  SPACE
      #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **BR-038-008:** DIPA631.cbl 240-242행 및 250-252행에 구현 (그리드처리규칙)
  ```cobol
  VARYING WK-I  FROM 1  BY 1
    UNTIL WK-I >  XDIPA631-I-PRSNT-NOITM1.

  VARYING WK-I  FROM 1  BY 1
    UNTIL WK-I >  XDIPA631-I-TOTAL-NOITM2
  ```

- **BR-038-009:** DIPA631.cbl 280-320행에 구현 (데이터베이스정리규칙)
  ```cobol
  #DYDBIO  OPEN-CMD-1  TKIPB111-PK TRIPB111-REC
  PERFORM VARYING WK-I FROM 1 BY 1
          UNTIL COND-DBIO-MRNF
      #DYDBIO DELETE-CMD-Y  TKIPB111-PK TRIPB111-REC
  END-PERFORM
  ```

- **BR-038-010:** #ERROR 매크로를 사용한 표준화된 오류처리로 모든 모듈에 구현
  ```cobol
  IF  NOT COND-DBIO-OK   THEN
      #ERROR CO-B3900010 CO-UKII0182 CO-STAT-ERROR
  END-IF
  ```

### 기능 구현

- **F-038-001:** AIPBA63.cbl 150-170행 및 DIPA631.cbl 180-200행에 구현 (기업집단파라미터검증기능)
  ```cobol
  S2000-VALIDATION-RTN.
  IF YNIPBA63-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  
  IF YNIPBA63-CORP-CLCT-REGI-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0002 CO-STAT-ERROR
  END-IF.
  
  IF YNIPBA63-VALUA-YMD = SPACE
     #ERROR CO-B3800004 CO-UKIP0003 CO-STAT-ERROR
  END-IF.
  ```

- **F-038-002:** DIPA631.cbl 270-420행에 구현 (연혁데이터처리기능)
  ```cobol
  S3100-THKIPB111-DELETE-RTN.
  #DYDBIO  OPEN-CMD-1  TKIPB111-PK TRIPB111-REC
  PERFORM VARYING WK-I FROM 1 BY 1
          UNTIL COND-DBIO-MRNF
      #DYDBIO DELETE-CMD-Y  TKIPB111-PK TRIPB111-REC
  END-PERFORM
  
  S3200-THKIPB111-INSERT-RTN.
  IF  XDIPA631-I-SHET-OUTPT-YN(WK-I) = '1' THEN
      #DYDBIO INSERT-CMD-Y  TKIPB111-PK TRIPB111-REC
  END-IF
  ```

- **F-038-003:** DIPA631.cbl 430-580행에 구현 (주석데이터처리기능)
  ```cobol
  S3300-THKIPB130-INSERT-RTN.
  PERFORM VARYING WK-I FROM 1 BY 1
          UNTIL COND-DBIO-MRNF
      #DYDBIO DELETE-CMD-Y  TKIPB130-PK TRIPB130-REC
  END-PERFORM
  
  PERFORM VARYING WK-I FROM 1 BY 1
          UNTIL WK-I > XDIPA631-I-TOTAL-NOITM2
      #DYDBIO INSERT-CMD-Y  TKIPB130-PK TRIPB130-REC
  END-PERFORM
  ```

- **F-038-004:** DIPA631.cbl 650-700행에 구현 (관리부점업데이트기능)
  ```cobol
  S3400-THKIPB110-UPDATE-RTN.
  #DYDBIO SELECT-CMD-Y  TKIPB110-PK TRIPB110-REC
  
  S3410-THKIPB110-UPDATE-RTN.
  MOVE XDIPA631-I-MGT-BRNCD
    TO RIPB110-MGT-BRNCD
  #DYDBIO  UPDATE-CMD-Y  TKIPB110-PK  TRIPB110-REC.
  ```

- **F-038-005:** 포괄적인 데이터베이스 트랜잭션 관리로 DIPA631.cbl 전체에 구현
  ```cobol
  #DYDBIO SELECT-CMD-Y  TKIPB111-PK TRIPB111-REC
  #DYDBIO INSERT-CMD-Y  TKIPB111-PK TRIPB111-REC
  #DYDBIO UPDATE-CMD-Y  TKIPB110-PK  TRIPB110-REC
  #DYDBIO DELETE-CMD-Y  TKIPB111-PK TRIPB111-REC
  ```

- **F-038-006:** DIPA631.cbl 265-270행에 구현 (결과집계기능)
  ```cobol
  MOVE  XDIPA631-I-TOTAL-NOITM1
    TO  XDIPA631-O-TOTAL-NOITM
  MOVE  XDIPA631-I-PRSNT-NOITM1
    TO  XDIPA631-O-PRSNT-NOITM
  ```

### 데이터베이스 테이블
- **THKIPB111**: 시간순 정보를 포함한 연혁 이벤트 데이터를 저장하는 기업집단연혁명세 테이블
- **THKIPB130**: 주석 및 어노테이션 데이터를 저장하는 기업집단주석명세 테이블
- **THKIPB110**: 기본적인 기업집단 데이터를 저장하는 기업집단평가기본정보 테이블

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
- **AS Layer**: AIPBA63 - 기업집단 연혁관리를 위한 Application Server 컴포넌트
- **IC Layer**: IJICOMM - 공통 프레임워크 서비스 및 시스템 초기화를 위한 Interface Component
- **DC Layer**: DIPA631 - 연혁데이터 처리 및 데이터베이스 조정을 위한 Data Component
- **BC Layer**: RIPA111, RIPA130, RIPA110 - 연혁 및 주석데이터 작업을 위한 Business Components
- **SQLIO Layer**: 데이터베이스 접근 컴포넌트 - 연혁데이터 관리를 위한 SQL 처리 및 쿼리 실행
- **Framework**: YCCOMMON, XIJICOMM을 포함한 공통 프레임워크로 공유 서비스 및 매크로 사용

### 데이터 흐름 아키텍처
1. **입력 흐름**: [Component] → [Component] → [Component]
2. **데이터베이스 접근**: [Component] → [Database Components] → [Database Tables]
3. **서비스 호출**: [Component] → [Service Components] → [Service Description]
4. **출력 흐름**: [Component] → [Component] → [Component]
5. **오류 처리**: 모든 레이어 → 프레임워크 오류 처리 → 사용자 메시지