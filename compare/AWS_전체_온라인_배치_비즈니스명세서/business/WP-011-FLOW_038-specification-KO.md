# 업무 명세서: 관계기업등록변경이력정보조회 (Corporate Group Affiliated Company Registration Change History Inquiry)

## 문서 관리
- **버전:** 1.0
- **날짜:** 2025-09-24
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-011
- **진입점:** AIP4A13
- **업무 도메인:** CUSTOMER

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용평가 및 고객관리 목적으로 기업집단 관계기업의 등록변경 이력정보를 조회하는 포괄적인 온라인 조회 시스템을 구현합니다. 시스템은 기업집단 관계 변경, 등록 수정, 조직구조 업데이트에 대한 상세한 과거 추적을 여러 시간 기간에 걸쳐 제공합니다.

업무 목적은 다음과 같습니다:
- 기업집단 관계기업의 포괄적인 등록변경 이력정보 조회 (Corporate Group Affiliated Company Registration Change History Inquiry)
- 조직구조 변경 및 기업집단 관계 수정 추적 (Track organizational structure changes and corporate group relationship modifications)
- 과거 기업집단 데이터를 통한 신용평가 지원 (Support credit evaluation with historical corporate group data)
- 규제 준수 및 위험관리를 위한 감사추적 유지 (Maintain audit trail for regulatory compliance and risk management)
- 담당자 정보와 함께 상세한 등록 및 수정 추적 제공 (Provide detailed registration and modification tracking with responsible party information)
- 기업집단 발전 및 관계 변화의 과거 분석 지원 (Enable historical analysis of corporate group evolution and relationship changes)

시스템은 확장된 다중 모듈 흐름을 통해 데이터를 처리합니다: AIP4A13 → IJICOMM → YCCOMMON → XIJICOMM → QIPA131 → YCDBSQLA → XQIPA131 → YCCSICOM → YCCBICOM → XZUGOTMY → YNIP4A13 → YPIP4A13, 고객 식별 검증, 기업집단 이력 조회, 포괄적인 출력 형식화를 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 심사 목적의 고객 식별 및 검증 (Customer identification and validation for examination purposes)
- 시간순 정렬된 기업집단 등록변경 이력 조회 (Corporate group registration change history retrieval with chronological ordering)
- 등록거래 유형 추적 및 분류 (Registration transaction type tracking and classification)
- 감사 목적의 부점 및 직원 정보 통합 (Branch and employee information integration for audit purposes)
- 연속키 관리를 통한 대용량 결과집합 페이징 지원 (Pagination support for large result sets with continuation key management)
- 트랜잭션 격리 및 일관성을 갖춘 실시간 데이터 접근 (Real-time data access with transaction isolation and consistency)

## 2. 업무 엔티티

### BE-011-001: 고객심사정보 (Customer Examination Information)
- **설명:** 심사 및 조회 목적의 핵심 고객 식별 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Process Classification Code) | String | 2 | Fixed='R1' | 조회 작업을 위한 프로세스 유형 식별자 | YNIP4A13-PRCSS-DSTCD | prcssClassCd |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사를 위한 주요 고객 식별자 | YNIP4A13-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 그룹회사코드 (Group Company Code) | String | 3 | Fixed='KB0' | KB금융그룹의 고정 식별자 | BICOM-GROUP-CO-CD | groupCoCd |
| 고객번호 (Customer Number) | String | 15 | NOT NULL | 패딩이 포함된 내부 고객번호 | JICOM-CNO | custNo |
| 고객번호패턴구분 (Customer Number Pattern Classification) | String | 1 | Fixed='2' | 고객번호 형식의 패턴 분류 | JICOM-CNO-PTRN-DSTIC | custNoPtrnDstcd |

- **검증 규칙:**
  - 처리구분코드는 조회 작업을 위해 'R1'이어야 함
  - 심사고객식별자는 필수이며 10자리여야 함
  - 고객번호는 마지막 5자리에 '00000'으로 패딩됨
  - 그룹회사코드는 'KB0'이어야 함 (KB금융그룹 식별자)
  - 고객번호패턴구분은 심사고객을 위해 '2'로 설정됨

### BE-011-002: 기업집단등록이력 (Corporate Group Registration History)
- **설명:** 기업집단 등록변경 및 수정의 과거 기록
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 심사를 위한 고객 식별자 | XQIPA131-O-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 등록일시 (Registration Date Time) | String | 14 | YYYYMMDDHHMMSS | 등록 또는 수정 타임스탬프 | XQIPA131-O-REGI-YMS | regiYms |
| 등록변경거래구분 (Registration Change Transaction Classification) | String | 1 | NOT NULL | 등록변경을 위한 거래 유형 | XQIPA131-O-REGI-M-TRAN-DSTCD | regiMTranDstcd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | XQIPA131-O-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 코드 | XQIPA131-O-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 등록부점코드 (Registration Branch Code) | String | 4 | NOT NULL | 등록이 처리된 부점 코드 | XQIPA131-O-REGI-BRNCD | regiBrncd |
| 등록부점명 (Registration Branch Name) | String | 42 | Optional | 등록이 처리된 부점명 | XQIPA131-O-REGI-BRN-NAME | regiBrnName |
| 등록직원번호 (Registration Employee ID) | String | 7 | NOT NULL | 등록을 처리한 직원 ID | XQIPA131-O-REGI-EMPID | regiEmpid |
| 등록직원명 (Registration Employee Name) | String | 52 | Optional | 등록을 처리한 직원명 | XQIPA131-O-REGI-EMNM | regiEmnm |
| 시스템최종처리일시 (System Last Processing Timestamp) | Timestamp | 14 | YYYYMMDDHHMMSS | 시스템 처리 타임스탬프 | YPIP4A13-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |

- **검증 규칙:**
  - 등록일시는 YYYYMMDDHHMMSS 형식의 유효한 타임스탬프여야 함
  - 등록변경거래구분은 변경 유형을 나타냄 (삽입, 업데이트, 삭제)
  - 기업집단등록코드와 그룹코드 조합이 유효해야 함
  - 등록부점코드는 부점 마스터 테이블에 존재해야 함
  - 등록직원번호는 직원 마스터 테이블에 존재해야 함
  - 부점명과 직원명은 표시 목적으로 LEFT OUTER JOIN을 통해 조회됨

### BE-011-003: 조회결과집합정보 (Inquiry Result Set Information)
- **설명:** 페이징 및 데이터 조회 제어를 위한 결과집합 관리 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수 (Total Item Count) | Numeric | 5 | Positive integer | 사용 가능한 총 레코드 수 | YPIP4A13-TOTAL-NOITM1 | totalNoitm |
| 현재건수 (Present Item Count) | Numeric | 5 | Positive integer | 현재 결과집합의 레코드 수 | YPIP4A13-PRSNT-NOITM1 | prsntNoitm |
| 최대건수제한 (Maximum Count Limit) | Numeric | 7 | Fixed=100 | 페이지당 최대 레코드 수 | CO-MAX-CNT | maxCntLimit |
| 다음키처리일시 (Next Key Processing Timestamp) | String | 14 | YYYYMMDDHHMMSS | 페이징 연속을 위한 다음 키 | WK-NEXT-PRCSS-YMS | nextPrcssYms |
| 다음총건수 (Next Total Count) | Numeric | 5 | Positive integer | 페이징을 위한 누적 총 건수 | WK-NEXT-TOTAL-CNT | nextTotalCnt |
| 다음현재건수 (Next Present Count) | Numeric | 5 | Positive integer | 페이징을 위한 현재 건수 | WK-NEXT-PRSNT-CNT | nextPrsntCnt |
| 중단거래구분 (Discontinuation Transaction Classification) | String | 1 | '1','2' | 거래 연속 표시자 | BICOM-DSCN-TRAN-DSTCD | dscnTranDstcd |

- **검증 규칙:**
  - 최대건수제한은 페이지당 100개 레코드로 고정됨
  - 총건수는 모든 페이지에 걸친 누적 건수를 나타냄
  - 현재건수는 최대건수제한을 초과할 수 없음
  - 다음키처리일시는 시간순 페이징에 사용됨
  - 중단거래구분 '1' 또는 '2'는 연속이 필요함을 나타냄

### BE-011-004: 데이터베이스조회제어정보 (Database Query Control Information)
- **설명:** 데이터베이스 조회 제어 매개변수 및 결과 관리
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | Fixed='KB0' | 조회를 위한 그룹회사 식별자 | XQIPA131-I-GROUP-CO-CD | groupCoCd |
| 심사고객식별자 (Examination Customer Identifier) | String | 10 | NOT NULL | 조회를 위한 고객 식별자 | XQIPA131-I-EXMTN-CUST-IDNFR | exmtnCustIdnfr |
| 다음키1 (Next Key 1) | String | 20 | HIGH-VALUE default | 시간순 정렬을 위한 페이징 키 | XQIPA131-I-NEXT-KEY1 | nextKey1 |
| SQL배열수 (SQL Array Count) | Numeric | 9 | Fixed=101 | SQL 결과 처리를 위한 배열 크기 | DBSQLI-ARRAY-CNT | sqlArrayCnt |
| SQL선택요청수 (SQL Select Request Count) | Numeric | 9 | Variable | 요청된 레코드 수 | DBSQLI-SELECT-REQ | sqlSelectReq |
| SQL선택결과수 (SQL Select Result Count) | Numeric | 9 | Variable | 반환된 레코드 수 | DBSQL-SELECT-CNT | sqlSelectCnt |

- **검증 규칙:**
  - 그룹회사코드는 KB금융그룹을 위해 'KB0'이어야 함
  - 다음키1은 첫 번째 조회를 위해 HIGH-VALUE로 초기화되고, 연속을 위해 마지막 타임스탬프로 설정됨
  - SQL배열수는 최적 성능을 위해 101로 고정됨
  - SQL선택요청수는 지정되지 않으면 배열 수로 기본 설정됨
  - SQL선택결과수는 실제 조회된 레코드를 나타냄

## 3. 업무 규칙

### BR-011-001: 고객식별검증 (Customer Identification Validation)
- **설명:** 심사 목적의 고객 식별 정보를 검증합니다
- **조건:** 심사고객식별자가 제공될 때 고객 존재 및 형식을 검증합니다
- **관련 엔티티:** BE-011-001 (고객심사정보)
- **예외사항:** 
  - 심사고객식별자가 누락된 경우 오류 B3800004/UKII0007
  - 처리구분코드가 'R1'이 아닌 경우 오류 B3800004/UKII0291

### BR-011-002: 처리구분제어 (Process Classification Control)
- **설명:** 조회 작업을 위한 프로세스 유형을 제어합니다
- **조건:** 처리구분코드가 제공될 때 조회 작업을 위해 'R1'이어야 합니다
- **관련 엔티티:** BE-011-001 (고객심사정보)
- **예외사항:** 
  - 처리구분코드가 'R1'이 아닌 경우 오류 B3800004/UKII0291

### BR-011-003: 기업집단이력조회 (Corporate Group History Retrieval)
- **설명:** 기업집단 등록변경 이력을 시간순으로 조회합니다
- **조건:** 유효한 고객식별자가 제공될 때 타임스탬프 내림차순으로 정렬된 모든 등록변경을 조회합니다
- **관련 엔티티:** BE-011-002 (기업집단등록이력), BE-011-004 (데이터베이스조회제어정보)
- **예외사항:** 
  - 데이터베이스 조회 실패 시 오류 B4200229/UKII0974
  - 데이터가 없는 경우 오류 없음 (SQLCODE +100)

### BR-011-004: 페이징관리 (Pagination Management)
- **설명:** 대용량 데이터 집합을 위한 결과집합 페이징을 관리합니다
- **조건:** 결과 건수가 최대 제한을 초과할 때 연속키를 사용한 페이징을 구현합니다
- **관련 엔티티:** BE-011-003 (조회결과집합정보)
- **예외사항:** 
  - 결과 건수가 100개 레코드를 초과할 때 연속이 필요함
  - 연속을 위해 다음키가 마지막 레코드 타임스탬프로 설정됨

### BR-011-005: 부점직원정보통합 (Branch and Employee Information Integration)
- **설명:** 표시 목적으로 부점 및 직원 마스터 데이터를 통합합니다
- **조건:** 등록이력이 조회될 때 이름을 위해 부점 및 직원 마스터 테이블과 조인합니다
- **관련 엔티티:** BE-011-002 (기업집단등록이력)
- **예외사항:** 
  - LEFT OUTER JOIN은 부점/직원을 찾을 수 없어도 이력 레코드가 표시되도록 보장함
  - 부점/직원명을 사용할 수 없는 경우 빈 문자열 반환

### BR-011-006: 트랜잭션격리일관성 (Transaction Isolation and Consistency)
- **설명:** 동시 접근을 위한 데이터 일관성과 격리를 보장합니다
- **조건:** 데이터베이스 조회가 실행될 때 성능을 위해 WITH UR (Uncommitted Read)을 사용합니다
- **관련 엔티티:** BE-011-004 (데이터베이스조회제어정보)
- **예외사항:** 
  - 읽기 전용 작업을 위한 WITH UR 격리 수준
  - 결과집합 관리를 위한 CURSOR WITH HOLD

### BR-011-007: 중단거래처리 (Discontinuation Transaction Processing)
- **설명:** 저장된 페이징 키를 사용하여 중단된 거래의 연속 처리
- **조건:** 중단거래구분코드 = '1' 또는 '2'일 때 이전 응답에서 연속키 조회
- **관련 엔티티:** [BE-011-003]
- **예외사항:** 연속키가 존재하지 않으면 처음부터 시작

### BR-011-008: 고객번호패딩처리 (Customer Number Padding Processing)
- **설명:** IJICOMM 인터페이스를 위해 고객식별자를 패딩으로 형식화
- **조건:** 고객식별자가 존재할 때 11-15번째 위치에 "00000" 패딩 추가
- **관련 엔티티:** [BE-011-001]
- **예외사항:** 없음

## 4. 업무 기능

### F-011-001: 고객심사식별자검증 (Customer Examination Identifier Validation)
- **설명:** 조회 작업을 위한 고객심사식별자를 검증하고 처리합니다
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 처리구분코드 | String | 2 | Fixed='R1' | 조회를 위한 프로세스 유형 | YNIP4A13-PRCSS-DSTCD |
| 심사고객식별자 | String | 10 | NOT NULL | 고객 식별자 | YNIP4A13-EXMTN-CUST-IDNFR |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 검증결과 | String | 2 | 성공/오류 코드 | YCCOMMON-RETURN-CD |
| 고객번호 | String | 15 | 형식화된 고객번호 | JICOM-CNO |
| 고객정보 | Structure | Variable | 고객 상세정보 | AACOM-* |

- **처리 로직:**
  1. 처리구분코드가 'R1'과 같은지 검증
  2. 심사고객식별자가 비어있지 않은지 검증
  3. 패딩을 사용하여 고객번호 형식화 ('00000' 접미사)
  4. 고객정보 조회를 위해 IJICOMM 호출
  5. 검증결과 및 고객 상세정보 반환

- **적용된 업무규칙:** BR-011-001, BR-011-002

### F-011-002: 기업집단이력조회 (Corporate Group History Retrieval)
- **설명:** 포괄적인 기업집단 등록변경 이력을 조회합니다
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 그룹회사코드 | String | 3 | Fixed='KB0' | 그룹 식별자 | XQIPA131-I-GROUP-CO-CD |
| 심사고객식별자 | String | 10 | NOT NULL | 고객 식별자 | XQIPA131-I-EXMTN-CUST-IDNFR |
| 다음키1 | String | 20 | Optional | 페이징 키 | XQIPA131-I-NEXT-KEY1 |
| 중단거래코드 | String | 1 | '1','2' | 연속 표시자 | BICOM-DSCN-TRAN-DSTCD |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 등록이력배열 | Array | Variable | 이력 레코드 | XQIPA131-O-* |
| 총레코드수 | Numeric | 5 | 사용 가능한 총 레코드 | YPIP4A13-TOTAL-NOITM1 |
| 현재레코드수 | Numeric | 5 | 현재 페이지 레코드 | YPIP4A13-PRSNT-NOITM1 |
| 연속키 | String | 80 | 다음 페이지 키 | WK-NEXT-KEY |

- **처리 로직:**
  1. 데이터베이스 조회 매개변수 초기화
  2. 페이징 키 설정 (첫 번째 조회는 HIGH-VALUE, 후속은 연속키)
  3. 부점/직원명을 위한 LEFT OUTER JOIN으로 SQL 조회 실행
  4. 시간순 정렬로 결과집합 처리 (등록일시 DESC)
  5. 100개 레코드를 초과하는 결과집합에 대한 페이징 로직 구현
  6. 완전한 등록이력 상세정보로 출력 배열 형식화

- **적용된 업무규칙:** BR-011-003, BR-011-004, BR-011-005, BR-011-006

### F-011-003: 결과집합형식화출력 (Result Set Formatting and Output)
- **설명:** 프레젠테이션을 위한 조회 결과집합을 형식화하고 구조화합니다
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 원시이력데이터 | Array | Variable | 데이터베이스 결과집합 | XQIPA131-O-* |
| 레코드수 | Numeric | 9 | Positive integer | 레코드 수 | DBSQL-SELECT-CNT |
| 최대수 | Numeric | 7 | Fixed=100 | 페이지 크기 제한 | CO-MAX-CNT |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 형식화그리드 | Array | Variable | 구조화된 출력 | YPIP4A13-GRID1 |
| 페이징정보 | Structure | Variable | 페이지 제어 데이터 | YPIP4A13-*-NOITM1 |
| 연속제어 | Structure | Variable | 다음 페이지 제어 | WK-NEXT-* |

- **처리 로직:**
  1. 출력 그리드 구조 초기화
  2. 데이터베이스 결과집합을 반복 (최대수까지)
  3. 데이터베이스 출력에서 프레젠테이션 형식으로 각 필드 매핑
  4. 페이징 카운터 계산 (총, 현재, 다음)
  5. 더 많은 레코드가 사용 가능한 경우 연속키 설정
  6. 클라이언트 소비를 위한 최종 출력 구조 형식화

- **적용된 업무규칙:** BR-011-004

## 5. 프로세스 흐름

```
기업집단 등록변경 이력 조회 프로세스 흐름

1. 초기화 단계
   ├── 입력 매개변수 수락 (프로세스 코드, 고객 식별자)
   ├── 입력 매개변수 검증
   └── 처리 변수 초기화

2. 고객 검증 단계
   ├── 패딩을 사용하여 고객번호 형식화
   ├── 고객 검증을 위해 IJICOMM 호출
   └── 고객 존재 및 접근 권한 확인

3. 데이터베이스 조회 단계
   ├── 조회 매개변수 설정 (그룹코드, 고객식별자, 페이징키)
   ├── QIPA131 데이터베이스 조회 실행
   └── 등록변경 이력 레코드 조회

4. 결과 처리 단계
   ├── 각 이력 레코드 처리
   ├── 출력 데이터 구조 형식화
   └── 페이징 로직 적용 (최대 100개 레코드)

5. 출력 형식화 단계
   ├── 데이터베이스 필드를 출력 구조로 매핑
   ├── 페이징 카운터 계산
   └── 필요시 연속키 설정

6. 완료 단계
   ├── 출력 구조 확정
   ├── 처리 결과 로그
   └── 형식화된 응답 반환
```

## 6. 레거시 구현 참조

### 소스 파일
- **주요 프로그램:** `/KIP.DONLINE.SORC/AIP4A13.cbl` - AS관계기업등록변경이력정보조회
- **데이터베이스 조회:** `/KIP.DDB2.DBSORC/QIPA131.cbl` - 관계기업 고객정보 등록변경 이력조회
- **입력 구조:** `/KIP.DCOMMON.COPY/YNIP4A13.cpy` - AS관계기업등록변경이력정보조회 입력
- **출력 구조:** `/KIP.DCOMMON.COPY/YPIP4A13.cpy` - AS관계기업등록변경이력정보조회 출력
- **데이터베이스 인터페이스:** `/KIP.DDB2.DBCOPY/XQIPA131.cpy` - QIPA131 데이터베이스 인터페이스

### 업무규칙 구현

- **BR-011-001:** AIP4A13.cbl 150-160라인에 구현 (처리구분코드 검증)
  ```cobol
  IF YNIP4A13-PRCSS-DSTCD NOT = 'R1'
  THEN
     #ERROR CO-B3800004 CO-UKII0291 CO-STAT-ERROR
  END-IF
  ```

- **BR-011-002:** AIP4A13.cbl 170-180라인에 구현 (고객식별자 검증)
  ```cobol
  IF YNIP4A13-EXMTN-CUST-IDNFR = SPACE
  THEN
     #ERROR CO-B3800004 CO-UKII0007 CO-STAT-ERROR
  END-IF
  ```

- **BR-011-003:** AIP4A13.cbl 200-220라인에 구현 (고객번호 형식화)
  ```cobol
  MOVE CO-CHAR-2 TO XIJICOMM-GUBUN
  MOVE YNIP4A13-EXMTN-CUST-IDNFR TO XIJICOMM-CUST-NO
  CALL 'IJICOMM' USING XIJICOMM
  ```

- **BR-011-004:** QIPA131.cbl 100-150라인에 구현 (페이징 로직)
  ```cobol
  SELECT * FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY 등록변경일시 DESC) AS RN,
           기업집단그룹코드, 기업집단등록코드, 등록변경일시
    FROM DB2DBA.THKIPA131
    WHERE 그룹회사코드 = 'KB0' AND 심사고객식별자 = :I-EXMTN-CUST-IDNFR
  ) WHERE RN <= 100
  ```

- **BR-011-005:** AIP4A13.cbl 300-320라인에 구현 (결과 건수 검증)
  ```cobol
  IF DBSQL-SELECT-CNT > CO-MAX-CNT
  THEN
     MOVE CO-MAX-CNT TO WK-PRESENT-CNT
  ELSE
     MOVE DBSQL-SELECT-CNT TO WK-PRESENT-CNT
  END-IF
  ```

- **BR-011-006:** AIP4A13.cbl 350-370라인에 구현 (연속키 관리)
  ```cobol
  IF WK-PRESENT-CNT = CO-MAX-CNT
  THEN
     MOVE XQIPA131-O-REGI-CHNG-DTTM(WK-PRESENT-CNT) TO WK-NEXT-KEY-1
  ELSE
     MOVE HIGH-VALUE TO WK-NEXT-KEY-1
  END-IF
  ```

- **BR-011-007:** AIP4A13.cbl 330-350라인에 구현 (중단거래처리)
  ```cobol
  IF BICOM-DSCN-TRAN-DSTCD = '1' OR '2'
     MOVE BOCOM-BF-TDK-INFO-CTNT TO WK-NEXT-KEY
     MOVE WK-NEXT-PRCSS-YMS TO XQIPA131-I-NEXT-KEY1
  ELSE
     MOVE 0 TO WK-NEXT-TOTAL-CNT
     MOVE 0 TO WK-NEXT-PRSNT-CNT
  END-IF
  ```

- **BR-011-008:** AIP4A13.cbl 210-220라인에 구현 (고객번호패딩)
  ```cobol
  MOVE CO-CHAR-2 TO JICOM-CNO-PTRN-DSTIC
  MOVE YNIP4A13-EXMTN-CUST-IDNFR TO JICOM-CNO
  MOVE "00000" TO JICOM-CNO(11:5)
  ```

### 기능 구현

- **F-011-001:** AIP4A13.cbl 250-300라인에 구현 (S2000-CUSTOMER-VALIDATION-RTN)
  ```cobol
  MOVE CO-CHAR-2 TO XIJICOMM-GUBUN
  MOVE YNIP4A13-EXMTN-CUST-IDNFR TO XIJICOMM-CUST-NO
  CALL 'IJICOMM' USING XIJICOMM
  IF XIJICOMM-RETURN-CODE NOT = ZEROS
     MOVE XIJICOMM-RETURN-CODE TO WK-RETURN-CODE
  ```

- **F-011-002:** QIPA131.cbl 250-320라인에 구현 (CUR_SQL 커서 조회)
  ```cobol
  SELECT A755.심사고객식별자
        ,A755.등록일시
        ,A755.등록변경거래구분
        ,A755.기업집단등록코드
        ,A755.기업집단그룹코드
        ,A755.등록부점코드
        ,VALUE(BR01.부점한글명,' ') 등록부점명
        ,A755.등록직원번호
        ,VALUE(HR01.직원한글성명,' ') 등록직원명
  FROM THKIPA112 A755
       LEFT OUTER JOIN THKJIBR01 BR01
         ON BR01.그룹회사코드 = :XQIPA131-I-GROUP-CO-CD
        AND A755.등록부점코드 = BR01.부점코드
       LEFT OUTER JOIN THKJIHR01 HR01
         ON HR01.그룹회사코드 = :XQIPA131-I-GROUP-CO-CD
        AND A755.등록직원번호 = HR01.직원번호
  WHERE A755.그룹회사코드 = :XQIPA131-I-GROUP-CO-CD
    AND A755.심사고객식별자 = :XQIPA131-I-EXMTN-CUST-IDNFR
    AND A755.등록일시 < :XQIPA131-I-NEXT-KEY1
  ORDER BY A755.등록일시 DESC
  ```

- **F-011-003:** AIP4A13.cbl 400-450라인에 구현 (S4000-OUTPUT-FORMATTING-RTN)
  ```cobol
  PERFORM VARYING WK-I FROM CO-N1 BY CO-N1
          UNTIL WK-I > DBSQL-SELECT-CNT OR WK-I > CO-MAX-CNT
    MOVE XQIPA131-O-EXMTN-CUST-IDNFR(WK-I) TO YPIP4A13-EXMTN-CUST-IDNFR(WK-I)
    MOVE XQIPA131-O-REGI-YMS(WK-I) TO YPIP4A13-REGI-YMS(WK-I)
    MOVE XQIPA131-O-CORP-CLCT-REGI-CD(WK-I) TO YPIP4A13-CORP-CLCT-REGI-CD(WK-I)
  END-PERFORM
  ```

### 데이터베이스 테이블
- **THKIPA112**: 관계기업수기조정정보 (Corporate Group Manual Adjustment Information) - 등록변경 이력의 주요 데이터 소스
- **THKJIBR01**: 부점기본 (Branch Basic Information) - 등록부점의 부점명 조회
- **THKJIHR01**: 직원기본 (Employee Basic Information) - 등록직원의 직원명 조회

### 오류 코드
- **오류 집합 CO-B3800004**:
  - **에러코드**: CO-UKII0291 - "처리구분코드 오류"
  - **조치메시지**: CO-UKII0291 - "담당자에게 연락"
  - **사용**: AIP4A13.cbl에서 처리구분코드 검증

- **오류 집합 CO-B3800004**:
  - **에러코드**: CO-UKII0007 - "심사고객식별자 오류"
  - **조치메시지**: CO-UKII0007 - "심사고객식별자 확인"
  - **사용**: AIP4A13.cbl에서 고객식별자 검증

- **오류 집합 CO-B4200229**:
  - **에러코드**: CO-UKII0974 - "데이터 검색오류"
  - **조치메시지**: CO-UKII0974 - "데이터 검색오류"
  - **사용**: AIP4A13.cbl에서 데이터베이스 조회 오류 처리

### 기술 아키텍처
- **AS 계층**: AIP4A13 - 등록변경 이력 조회를 위한 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM - 고객 검증 및 정보 조회를 위한 인터페이스 컴포넌트
- **DC 계층**: QIPA131 - THKIPA112 데이터베이스 접근과 THKJIBR01/THKJIHR01 조인을 위한 데이터 컴포넌트
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 비즈니스 컴포넌트 프레임워크
- **SQLIO 계층**: YCDBSQLA, XQIPA131 - SQL 실행을 위한 데이터베이스 접근 컴포넌트
- **프레임워크**: XZUGOTMY - 메시지 처리 및 오류 처리를 위한 프레임워크 컴포넌트

### 데이터 흐름 아키텍처
1. **입력 흐름**: AIP4A13 → YNIP4A13 (입력 구조) → 매개변수 검증
2. **고객 검증**: AIP4A13 → IJICOMM → 고객 정보 조회
3. **데이터베이스 접근**: AIP4A13 → QIPA131 → YCDBSQLA → THKIPA112 + THKJIBR01 + THKJIHR01 데이터베이스 조회
4. **서비스 호출**: AIP4A13 → XIJICOMM → YCCOMMON → 프레임워크 서비스
5. **출력 흐름**: 데이터베이스 결과 → XQIPA131 → YPIP4A13 (출력 구조) → AIP4A13
6. **오류 처리**: 모든 계층 → XZUGOTMY → 프레임워크 오류 처리 → 사용자 메시지
