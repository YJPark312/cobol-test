# 업무 명세서: 관계기업수기조정내역조회 (Corporate Group Manual Adjustment History Inquiry)

## 문서 관리
- **버전:** 1.0
- **날짜:** 2025-09-24
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-012
- **진입점:** AIP4A14
- **업무 도메인:** CUSTOMER

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

이 워크패키지는 신용평가 및 고객관리 목적으로 기업집단 수기조정 이력정보를 조회하는 포괄적인 온라인 조회 시스템을 구현합니다. 시스템은 기업집단 관계에 대한 수기 수정의 상세한 이력 추적을 제공하며, 특정 기업집단 내 계열사의 추가, 삭제, 변경을 포함합니다.

업무 목적은 다음과 같습니다:
- 관계기업 수기조정 내역의 포괄적 조회 (Corporate Group Manual Adjustment History Comprehensive Inquiry)
- 기업집단 관계 및 계열사 소속의 수기 수정 추적 (Manual Modification Tracking of Corporate Group Relationships and Affiliate Memberships)
- 과거 수기조정 데이터를 통한 신용평가 지원 (Credit Evaluation Support with Historical Manual Adjustment Data)
- 규제 준수 및 위험관리를 위한 감사추적 유지 (Audit Trail Maintenance for Regulatory Compliance and Risk Management)
- 담당자 정보와 함께 상세한 수기조정 추적 제공 (Detailed Manual Adjustment Tracking with Responsible Party Information)
- 수기 개입을 통한 기업집단 발전의 과거 분석 지원 (Historical Analysis Support of Corporate Group Evolution through Manual Interventions)

시스템은 확장된 다중 모듈 흐름을 통해 데이터를 처리합니다: AIP4A14 → IJICOMM → YCCOMMON → XIJICOMM → QIPA141 → YCDBSQLA → XQIPA141 → YCCSICOM → YCCBICOM → XZUGOTMY → YNIP4A14 → YPIP4A14, 기업집단 매개변수 검증, 수기조정 이력 조회, 포괄적인 출력 형식화를 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 기업집단 매개변수 검증 및 처리 (Corporate Group Parameter Validation and Processing)
- 시간순 정렬된 수기조정 이력 조회 (Manual Adjustment History Retrieval with Chronological Ordering)
- 수기 수정 유형 추적 및 분류 (Manual Modification Type Tracking and Classification)
- 감사 목적의 직원 정보 통합 (Employee Information Integration for Audit Purposes)
- 연속키 관리를 통한 대용량 결과집합 페이징 지원 (Pagination Support for Large Result Sets with Continuation Key Management)
- 트랜잭션 격리 및 일관성을 갖춘 실시간 데이터 접근 (Real-time Data Access with Transaction Isolation and Consistency)

## 2. 업무 엔티티

### BE-012-001: 기업집단수기조정조회매개변수 (Corporate Group Manual Adjustment Inquiry Parameters)
- **설명:** 기업집단 수기조정 이력 조회를 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Process Classification Code) | String | 2 | NOT NULL | 조회 작업을 위한 프로세스 타입 식별자 | YNIP4A14-PRCSS-DSTCD | prcssClassCd |
| 그룹회사코드 (Group Company Code) | String | 3 | Fixed='KB0' | KB금융그룹을 위한 고정 식별자 | YNIP4A14-GROUP-CO-CD | groupCoCd |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | Optional | 심사를 위한 고객 식별자 | YNIP4A14-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 코드 | YNIP4A14-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A14-CORP-CLCT-REGI-CD | corpClctRegiCd |

- **검증 규칙:**
  - 처리구분코드는 필수이며 공백일 수 없음
  - 그룹회사코드는 KB금융그룹을 위해 'KB0'이어야 함
  - 기업집단그룹코드와 등록코드 조합이 유효해야 함
  - 심사고객식별자는 그룹 수준 조회에서 선택사항

### BE-012-002: 기업집단수기조정이력 (Corporate Group Manual Adjustment History)
- **설명:** 기업집단 관계에 대한 수기조정의 이력 기록
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 수기변경구분 (Manual Modification Classification) | String | 1 | NOT NULL | 수행된 수기 수정의 유형 | XQIPA141-O-HWRT-MODFI-DSTCD | hwrtModfiDstcd |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사를 위한 고객 식별자 | XQIPA141-O-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 대표사업자번호 (Representative Business Number) | String | 10 | NOT NULL | 대표회사의 사업자등록번호 | XQIPA141-O-RPSNT-BZNO | rpsntBzno |
| 대표업체명 (Representative Company Name) | String | 52 | NOT NULL | 대표회사의 명칭 | XQIPA141-O-RPSNT-ENTP-NAME | rpsntEntpName |
| 등록일시 (Registration Timestamp) | String | 14 | YYYYMMDDHHMMSS | 등록 또는 수정 타임스탬프 | XQIPA141-O-REGI-YMS | regiYms |
| 등록직원명 (Registration Employee Name) | String | 42 | Optional | 등록을 처리한 직원명 | XQIPA141-O-REGI-EMNM | regiEmnm |

- **검증 규칙:**
  - 수기변경구분은 변경 유형을 나타냄 (추가, 삭제, 수정)
  - 등록일시는 YYYYMMDDHHMMSS 형식의 유효한 타임스탬프여야 함
  - 대표사업자번호는 유효한 사업자등록번호 형식이어야 함
  - 대표업체명은 식별 목적으로 필수
  - 직원명은 표시 목적으로 LEFT OUTER JOIN을 통해 조회됨

### BE-012-003: 조회결과집합정보 (Inquiry Result Set Information)
- **설명:** 페이징 및 데이터 조회 제어를 위한 결과집합 관리 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수 (Total Item Count) | Numeric | 5 | Positive integer | 사용 가능한 총 레코드 수 | YPIP4A14-TOTAL-NOITM | totalNoitm |
| 현재건수 (Present Item Count) | Numeric | 5 | Positive integer | 현재 결과집합의 레코드 수 | YPIP4A14-PRSNT-NOITM | prsntNoitm |
| 최대건수제한 (Maximum Count Limit) | Numeric | 7 | Fixed=100 | 페이지당 최대 레코드 수 | CO-MAX-CNT | maxCntLimit |
| 다음키처리일시 (Next Key Processing Timestamp) | String | 14 | YYYYMMDDHHMMSS | 페이징 연속을 위한 다음 키 | WK-NEXT-PRCSS-YMS | nextPrcssYms |
| 다음총건수 (Next Total Count) | Numeric | 5 | Positive integer | 페이징을 위한 누적 총 건수 | WK-NEXT-TOTAL-CNT | nextTotalCnt |
| 다음현재건수 (Next Present Count) | Numeric | 5 | Positive integer | 페이징을 위한 현재 건수 | WK-NEXT-PRSNT-CNT | nextPrsntCnt |
| 중단거래구분 (Discontinuation Transaction Classification) | String | 1 | '1','2' | 트랜잭션 연속 표시자 | BICOM-DSCN-TRAN-DSTCD | dscnTranDstcd |

- **검증 규칙:**
  - 최대건수제한은 페이지당 100개 레코드로 고정
  - 총건수는 모든 페이지에 걸친 누적 건수를 나타냄
  - 현재건수는 최대건수제한을 초과할 수 없음
  - 다음키처리일시는 시간순 페이징에 사용됨
  - 중단거래구분 '1' 또는 '2'는 연속이 필요함을 나타냄
### BE-012-004: 데이터베이스조회제어정보 (Database Query Control Information)
- **설명:** 데이터베이스 쿼리 제어 매개변수 및 결과 관리
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | Fixed='KB0' | 쿼리를 위한 그룹회사 식별자 | XQIPA141-I-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 쿼리를 위한 기업집단 분류 | XQIPA141-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 쿼리를 위한 기업집단 등록 | XQIPA141-I-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 다음키1 (Next Key 1) | String | 20 | HIGH-VALUE default | 시간순 정렬을 위한 페이징 키 | XQIPA141-I-NEXT-KEY1 | nextKey1 |
| SQL배열수 (SQL Array Count) | Numeric | 9 | Fixed=101 | SQL 결과 처리를 위한 배열 크기 | DBSQLI-ARRAY-CNT | sqlArrayCnt |
| SQL선택요청수 (SQL Select Request Count) | Numeric | 9 | Variable | 요청된 레코드 수 | DBSQLI-SELECT-REQ | sqlSelectReq |
| SQL선택결과수 (SQL Select Result Count) | Numeric | 9 | Variable | 반환된 레코드 수 | DBSQL-SELECT-CNT | sqlSelectCnt |

- **검증 규칙:**
  - 그룹회사코드는 KB금융그룹을 위해 'KB0'이어야 함
  - 다음키1은 첫 번째 쿼리에서 HIGH-VALUE로 초기화, 연속에서 마지막 타임스탬프로 설정
  - SQL배열수는 최적 성능을 위해 101로 고정
  - SQL선택요청수는 지정되지 않으면 배열 수로 기본 설정
  - SQL선택결과수는 실제 조회된 레코드를 나타냄

## 3. 업무 규칙

### BR-012-001: 처리구분검증 (Process Classification Validation)
- **설명:** 수기조정 조회 작업을 위한 처리구분코드 검증
- **조건:** 처리구분코드가 제공될 때 공백이 아님을 검증
- **관련 엔티티:** BE-012-001 (기업집단수기조정조회매개변수)
- **예외사항:** 
  - 처리구분코드가 누락되거나 공백인 경우 오류 B3000070/UKII0126

### BR-012-002: 기업집단매개변수검증 (Corporate Group Parameter Validation)
- **설명:** 조회 작업을 위한 기업집단 식별 매개변수 검증
- **조건:** 기업집단 코드가 제공될 때 존재하고 접근 가능함을 검증
- **관련 엔티티:** BE-012-001 (기업집단수기조정조회매개변수)
- **예외사항:** 
  - 기업집단그룹코드와 등록코드 조합이 유효하지 않은 경우 오류

### BR-012-003: 수기조정이력조회 (Manual Adjustment History Retrieval)
- **설명:** 지정된 기업집단의 수기조정 이력을 시간순으로 조회
- **조건:** 유효한 기업집단 매개변수가 제공될 때 타임스탬프 내림차순으로 모든 수기조정을 조회
- **관련 엔티티:** BE-012-002 (기업집단수기조정이력), BE-012-004 (데이터베이스조회제어정보)
- **예외사항:** 
  - 데이터베이스 쿼리 실패 시 오류 B4200229/UKII0974
  - 데이터가 없는 경우 오류 없음 (SQLCODE +100)

### BR-012-004: 페이징관리 (Pagination Management)
- **설명:** 대용량 수기조정 데이터 집합에 대한 결과집합 페이징 관리
- **조건:** 결과 건수가 최대 제한을 초과할 때 연속키로 페이징 구현
- **관련 엔티티:** BE-012-003 (조회결과집합정보)
- **예외사항:** 
  - 결과 건수 > 100개 레코드일 때 연속 필요
  - 연속을 위해 마지막 레코드 타임스탬프로 다음 키 설정

### BR-012-005: 직원정보통합 (Employee Information Integration)
- **설명:** 수기조정 이력에서 표시 목적으로 직원 마스터 데이터 통합
- **조건:** 수기조정 이력이 조회될 때 직원명을 위해 직원 마스터 테이블과 조인
- **관련 엔티티:** BE-012-002 (기업집단수기조정이력)
- **예외사항:** 
  - LEFT OUTER JOIN으로 직원을 찾을 수 없어도 이력 레코드 표시 보장
  - 직원명을 사용할 수 없으면 빈 문자열 반환

### BR-012-006: 트랜잭션격리일관성 (Transaction Isolation and Consistency)
- **설명:** 수기조정 데이터에 대한 동시 접근을 위한 데이터 일관성 및 격리 보장
- **조건:** 데이터베이스 쿼리 실행 시 성능을 위해 WITH UR (Uncommitted Read) 사용
- **관련 엔티티:** BE-012-004 (데이터베이스조회제어정보)
- **예외사항:** 
  - 읽기 전용 작업을 위한 WITH UR 격리 수준
  - 결과집합 관리를 위한 CURSOR WITH HOLD

### BR-012-007: 중단거래처리 (Discontinuation Transaction Processing)
- **설명:** 저장된 페이징 키를 사용하여 중단된 트랜잭션의 연속 처리
- **조건:** 중단거래코드 = '1' 또는 '2'일 때 이전 응답에서 연속키 조회
- **관련 엔티티:** BE-012-003 (조회결과집합정보)
- **예외사항:** 
  - 연속키가 없으면 처음부터 시작

### BR-012-008: 수기변경구분필터 (Manual Modification Classification Filter)
- **설명:** 수정 분류에 따른 수기조정 레코드 필터링
- **조건:** 수기조정 조회 시 수정 분류 > 0인 레코드만 포함
- **관련 엔티티:** BE-012-002 (기업집단수기조정이력)
- **예외사항:** 
  - 수정 분류 = 0인 레코드는 결과에서 제외
## 4. 업무 기능

### F-012-001: 기업집단매개변수검증 (Corporate Group Parameter Validation)
- **설명:** 수기조정 조회 작업을 위한 기업집단 매개변수 검증 및 처리
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 처리구분코드 | String | 2 | NOT NULL | 조회를 위한 프로세스 타입 | YNIP4A14-PRCSS-DSTCD |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 식별자 | YNIP4A14-CORP-CLCT-GROUP-CD |
| 기업집단등록코드 | String | 3 | NOT NULL | 등록 식별자 | YNIP4A14-CORP-CLCT-REGI-CD |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 검증결과 | String | 2 | 성공/오류 코드 | YCCOMMON-RETURN-CD |
| 쿼리매개변수 | Structure | Variable | 형식화된 쿼리 매개변수 | XQIPA141-I-* |

- **처리 로직:**
  1. 처리구분코드가 공백이 아님을 검증
  2. 기업집단그룹코드와 등록코드 조합 검증
  3. 그룹회사코드를 'KB0' (KB금융그룹)으로 설정
  4. 첫 번째 쿼리를 위해 페이징 키를 HIGH-VALUE로 초기화
  5. 검증 결과 및 형식화된 매개변수 반환

- **적용된 업무 규칙:** BR-012-001, BR-012-002

### F-012-002: 수기조정이력조회 (Manual Adjustment History Retrieval)
- **설명:** 지정된 기업집단의 포괄적인 수기조정 이력 조회
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | 그룹 식별자 | XQIPA141-I-GROUP-CO-CD |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 식별자 | XQIPA141-I-CORP-CLCT-GROUP-CD |
| 기업집단등록코드 | String | 3 | NOT NULL | 등록 식별자 | XQIPA141-I-CORP-CLCT-REGI-CD |
| 다음키1 | String | 20 | Optional | 페이징 키 | XQIPA141-I-NEXT-KEY1 |
| 중단거래코드 | String | 1 | '1','2' | 연속 표시자 | BICOM-DSCN-TRAN-DSTCD |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 수기조정이력배열 | Array | Variable | 이력 레코드 | XQIPA141-O-* |
| 총레코드수 | Numeric | 5 | 사용 가능한 총 레코드 | YPIP4A14-TOTAL-NOITM |
| 현재레코드수 | Numeric | 5 | 현재 페이지 레코드 | YPIP4A14-PRSNT-NOITM |
| 연속키 | String | 80 | 다음 페이지 키 | WK-NEXT-KEY |

- **처리 로직:**
  1. 데이터베이스 쿼리 매개변수 초기화
  2. 페이징 키 설정 (첫 번째 쿼리는 HIGH-VALUE, 후속은 연속키)
  3. 직원명을 위한 LEFT OUTER JOIN으로 SQL 쿼리 실행
  4. 등록 타임스탬프 내림차순으로 결과집합 처리
  5. 수정 분류 > 0인 레코드 필터링
  6. 결과집합 > 100개 레코드에 대한 페이징 로직 구현
  7. 완전한 수기조정 이력 세부사항으로 출력 배열 형식화

- **적용된 업무 규칙:** BR-012-003, BR-012-004, BR-012-005, BR-012-006, BR-012-008

### F-012-003: 결과집합형식화출력 (Result Set Formatting and Output)
- **설명:** 프레젠테이션을 위한 수기조정 조회 결과집합 형식화 및 구조화
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 원시이력데이터 | Array | Variable | 데이터베이스 결과집합 | XQIPA141-O-* |
| 레코드수 | Numeric | 9 | Positive integer | 레코드 수 | DBSQL-SELECT-CNT |
| 최대수 | Numeric | 7 | Fixed=100 | 페이지 크기 제한 | CO-MAX-CNT |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 형식화그리드 | Array | Variable | 구조화된 출력 | YPIP4A14-GRID1 |
| 페이징정보 | Structure | Variable | 페이지 제어 데이터 | YPIP4A14-*-NOITM |
| 연속제어 | Structure | Variable | 다음 페이지 제어 | WK-NEXT-* |

- **처리 로직:**
  1. 출력 그리드 구조 초기화
  2. 데이터베이스 결과집합 반복 (최대 수까지)
  3. 데이터베이스 출력에서 프레젠테이션 형식으로 각 필드 매핑
  4. 페이징 카운터 계산 (총, 현재, 다음)
  5. 더 많은 레코드가 사용 가능하면 연속키 설정
  6. 클라이언트 소비를 위한 최종 출력 구조 형식화

- **적용된 업무 규칙:** BR-012-004

## 5. 프로세스 흐름

```
기업집단 수기조정 이력 조회 프로세스 흐름

1. 초기화 단계
   ├── 입력 매개변수 수락 (처리코드, 기업집단 코드)
   ├── 입력 매개변수 검증
   └── 처리 변수 초기화

2. 매개변수 검증 단계
   ├── 처리구분코드 검증
   ├── 기업집단그룹코드 및 등록코드 검증
   └── 그룹회사코드를 'KB0'으로 설정

3. 데이터베이스 쿼리 단계
   ├── 쿼리 매개변수 설정 (그룹 코드, 페이징 키)
   ├── QIPA141 데이터베이스 쿼리 실행
   └── 수기조정 이력 레코드 조회

4. 결과 처리 단계
   ├── 각 수기조정 레코드 처리
   ├── 수정 분류별 레코드 필터링
   └── 페이징 로직 적용 (최대 100개 레코드)

5. 출력 형식화 단계
   ├── 데이터베이스 필드를 출력 구조로 매핑
   ├── 페이징 카운터 계산
   └── 필요시 연속키 설정

6. 완료 단계
   ├── 출력 구조 완료
   ├── 처리 결과 로깅
   └── 형식화된 응답 반환
```
## 6. 레거시 구현 참조

### 소스 파일
- **메인 프로그램:** `/KIP.DONLINE.SORC/AIP4A14.cbl` - AS관계기업수기조정내역조회
- **데이터베이스 쿼리:** `/KIP.DDB2.DBSORC/QIPA141.cbl` - 관계기업군별 수기등록 현황 조회
- **입력 구조:** `/KIP.DCOMMON.COPY/YNIP4A14.cpy` - AS관계기업수기조정내역조회 입력
- **출력 구조:** `/KIP.DCOMMON.COPY/YPIP4A14.cpy` - AS관계기업수기조정내역조회 출력
- **데이터베이스 인터페이스:** `/KIP.DDB2.DBCOPY/XQIPA141.cpy` - QIPA141 데이터베이스 인터페이스

### 업무 규칙 구현

- **BR-012-001:** AIP4A14.cbl 150-160행에 구현 (처리구분 검증)
  ```cobol
  IF YNIP4A14-PRCSS-DSTCD = SPACE
  THEN
     #ERROR CO-B3000070 CO-UKII0126 CO-STAT-ERROR
  END-IF
  ```

- **BR-012-002:** AIP4A14.cbl 180-200행에 구현 (기업집단 매개변수 설정)
  ```cobol
  MOVE BICOM-GROUP-CO-CD TO XQIPA141-I-GROUP-CO-CD
  MOVE YNIP4A14-CORP-CLCT-GROUP-CD TO XQIPA141-I-CORP-CLCT-GROUP-CD
  MOVE YNIP4A14-CORP-CLCT-REGI-CD TO XQIPA141-I-CORP-CLCT-REGI-CD
  ```

- **BR-012-003:** AIP4A14.cbl 220-240행에 구현 (페이징 키 관리)
  ```cobol
  MOVE HIGH-VALUE TO XQIPA141-I-NEXT-KEY1
  IF BICOM-DSCN-TRAN-DSTCD = '1' OR '2'
     MOVE BOCOM-BF-TDK-INFO-CTNT TO WK-NEXT-KEY
     MOVE WK-NEXT-PRCSS-YMS TO XQIPA141-I-NEXT-KEY1
  ```

- **BR-012-004:** AIP4A14.cbl 300-320행에 구현 (결과 건수 검증)
  ```cobol
  IF DBSQL-SELECT-CNT > CO-MAX-CNT
  THEN
     MOVE CO-MAX-CNT TO YPIP4A14-PRSNT-NOITM
     ADD CO-MAX-CNT TO WK-NEXT-TOTAL-CNT
  ELSE
     MOVE DBSQL-SELECT-CNT TO YPIP4A14-PRSNT-NOITM
  END-IF
  ```

- **BR-012-005:** QIPA141.cbl 200-220행에 구현 (직원명 조인)
  ```cobol
  LEFT OUTER JOIN THKJIHR01 HR01
    ON HR01.그룹회사코드 = :XQIPA141-I-GROUP-CO-CD
   AND A112.등록직원번호 = HR01.직원번호
  ```

- **BR-012-006:** QIPA141.cbl 150-170행에 구현 (커서 선언)
  ```cobol
  DECLARE CUR_SQL CURSOR WITH HOLD
                             WITH ROWSET POSITIONING FOR
  ```

- **BR-012-007:** AIP4A14.cbl 220-240행에 구현 (중단 처리)
  ```cobol
  IF BICOM-DSCN-TRAN-DSTCD = '1' OR '2'
     MOVE BOCOM-BF-TDK-INFO-CTNT TO WK-NEXT-KEY
     MOVE WK-NEXT-PRCSS-YMS TO XQIPA141-I-NEXT-KEY1
  ELSE
     MOVE 0 TO WK-NEXT-TOTAL-CNT
     MOVE 0 TO WK-NEXT-PRSNT-CNT
  END-IF
  ```

- **BR-012-008:** QIPA141.cbl 240-250행에 구현 (수정 분류 필터)
  ```cobol
  AND A112.수기변경구분 > 0
  ```

### 기능 구현

- **F-012-001:** AIP4A14.cbl 170-200행에 구현 (S3100-INPUT-SET-RTN)
  ```cobol
  INITIALIZE XQIPA141-IN
  MOVE BICOM-GROUP-CO-CD TO XQIPA141-I-GROUP-CO-CD
  MOVE YNIP4A14-CORP-CLCT-GROUP-CD TO XQIPA141-I-CORP-CLCT-GROUP-CD
  MOVE YNIP4A14-CORP-CLCT-REGI-CD TO XQIPA141-I-CORP-CLCT-REGI-CD
  ```

- **F-012-002:** QIPA141.cbl 180-260행에 구현 (CUR_SQL 커서 쿼리)
  ```cobol
  SELECT
   A112.수기변경구분
  ,A112.심사고객식별자
  ,A112.대표사업자번호
  ,A112.대표업체명
  ,A112.등록일시
  ,VALUE(HR01.직원한글성명,' ') 등록직원명
  FROM THKIPA112 A112
       LEFT OUTER JOIN THKJIHR01 HR01
         ON HR01.그룹회사코드 = :XQIPA141-I-GROUP-CO-CD
        AND A112.등록직원번호 = HR01.직원번호
  WHERE A112.그룹회사코드 = :XQIPA141-I-GROUP-CO-CD
    AND A112.기업집단그룹코드 = :XQIPA141-I-CORP-CLCT-GROUP-CD
    AND A112.기업집단등록코드 = :XQIPA141-I-CORP-CLCT-REGI-CD
    AND A112.심사고객식별자 > '0000000000'
    AND A112.등록일시 < :XQIPA141-I-NEXT-KEY1
    AND A112.수기변경구분 > 0
  ORDER BY A112.등록일시 DESC
  ```

- **F-012-003:** AIP4A14.cbl 280-320행에 구현 (S3100-OUTPUT-SET-RTN)
  ```cobol
  PERFORM VARYING WK-I FROM CO-N1 BY CO-N1
          UNTIL WK-I > DBSQL-SELECT-CNT OR WK-I > CO-MAX-CNT
    MOVE XQIPA141-O-HWRT-MODFI-DSTCD(WK-I) TO YPIP4A14-HWRT-MODFI-DSTCD(WK-I)
    MOVE XQIPA141-O-EXMTN-CUST-IDNFR(WK-I) TO YPIP4A14-EXMTN-CUST-IDNFR(WK-I)
    MOVE XQIPA141-O-RPSNT-BZNO(WK-I) TO YPIP4A14-RPSNT-BZNO(WK-I)
    MOVE XQIPA141-O-RPSNT-ENTP-NAME(WK-I) TO YPIP4A14-RPSNT-ENTP-NAME(WK-I)
    MOVE XQIPA141-O-REGI-EMNM(WK-I) TO YPIP4A14-REGI-EMNM(WK-I)
    MOVE XQIPA141-O-REGI-YMS(WK-I) TO YPIP4A14-REGI-YMS(WK-I)
  END-PERFORM
  ```

### 데이터베이스 테이블
- **THKIPA112**: 관계기업수기조정정보 (Corporate Group Manual Adjustment Information) - 수기조정 이력의 주요 데이터 소스
- **THKJIHR01**: 직원기본 (Employee Basic Information) - 등록 직원을 위한 직원명 조회

### 오류 코드
- **오류 집합 CO-B3000070**:
  - **에러코드**: CO-UKII0126 - "업무담당자에게 문의 바랍니다"
  - **조치메시지**: CO-UKII0126 - "업무담당자에게 문의 바랍니다"
  - **사용**: AIP4A14.cbl의 처리구분코드 검증

- **오류 집합 CO-B4200229**:
  - **에러코드**: CO-UKII0974 - "데이터 검색오류"
  - **조치메시지**: CO-UKII0974 - "데이터 검색오류"
  - **사용**: AIP4A14.cbl의 데이터베이스 쿼리 오류 처리

### 기술 아키텍처
- **AS 계층**: AIP4A14 - 수기조정 이력 조회를 위한 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM - 공통 처리를 위한 인터페이스 컴포넌트
- **DC 계층**: QIPA141 - THKJIHR01 조인과 함께 THKIPA112 데이터베이스 접근을 위한 데이터 컴포넌트
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 비즈니스 컴포넌트 프레임워크
- **SQLIO 계층**: YCDBSQLA, XQIPA141 - SQL 실행을 위한 데이터베이스 접근 컴포넌트
- **프레임워크**: XZUGOTMY - 메시지 처리 및 오류 처리를 위한 프레임워크 컴포넌트

### 데이터 흐름 아키텍처
1. **입력 흐름**: AIP4A14 → YNIP4A14 (입력 구조) → 매개변수 검증
2. **공통 처리**: AIP4A14 → IJICOMM → 공통 프레임워크 서비스
3. **데이터베이스 접근**: AIP4A14 → QIPA141 → YCDBSQLA → THKIPA112 + THKJIHR01 데이터베이스 쿼리
4. **서비스 호출**: AIP4A14 → XIJICOMM → YCCOMMON → 프레임워크 서비스
5. **출력 흐름**: 데이터베이스 결과 → XQIPA141 → YPIP4A14 (출력 구조) → AIP4A14
6. **오류 처리**: 모든 계층 → XZUGOTMY → 프레임워크 오류 처리 → 사용자 메시지
