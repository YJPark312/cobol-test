# 업무 명세서: 기업집단종합의견저장 (Corporate Group Comprehensive Opinion Storage)

## 문서 관리
- **버전:** 1.0
- **날짜:** 2025-09-25
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-022
- **진입점:** AIPBA91
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

이 워크패키지는 거래처리 도메인에서 기업집단 종합의견 정보를 관리하는 포괄적인 온라인 저장 시스템을 구현합니다. 시스템은 상세한 기업집단 평가의견의 실시간 저장 및 관리를 제공하여 기업집단 고객의 신용평가 및 위험평가 프로세스를 지원합니다.

업무 목적은 다음과 같습니다:
- 기업집단 신용평가를 위한 종합의견 정보 저장 (Store comprehensive opinion information for corporate group credit evaluation)
- 상세 기업집단 평가의견 실시간 저장 및 갱신 기능 (Provide real-time storage and update capabilities for detailed corporate group evaluation opinions)
- 구조화된 의견 데이터 저장을 통한 트랜잭션 일관성 지원 (Support transaction consistency through structured opinion data storage)
- 평가 코멘트 및 사업 평가를 포함한 상세 기업집단 의견 프로필 유지 (Maintain detailed corporate group opinion profiles including evaluation comments and business assessments)
- 온라인 거래처리를 위한 실시간 의견 데이터 저장 (Enable real-time opinion data storage for online transaction processing)
- 기업집단 평가 프로세스의 감사추적 및 데이터 무결성 제공 (Provide audit trail and data integrity for corporate group evaluation processes)

시스템은 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIPBA91 → IJICOMM → YCCOMMON → XIJICOMM → DIPA911 → RIPA130 → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPB130 → TKIPB130 → XDIPA911 → XZUGOTMY → YNIPBA91 → YPIPBA91, 기업집단 식별 검증, 의견 데이터 저장, 포괄적 저장 작업을 처리합니다.

주요 업무 기능은 다음과 같습니다:
- 의견 저장을 위한 기업집단 식별 및 검증 (Corporate group identification and validation for opinion storage)
- 상세 평가 내용을 포함한 종합의견 데이터 저장 (Comprehensive opinion data storage with detailed evaluation content)
- 구조화된 데이터 저장을 통한 트랜잭션 일관성 관리 (Transaction consistency management through structured data storage)
- 정확한 평가 저장을 위한 의견 내용 정밀도 처리 (Opinion content precision handling for accurate evaluation storage)
- 포괄적 평가정보를 포함한 기업집단 의견 프로필 관리 (Corporate group opinion profile management with comprehensive evaluation information)
- 데이터 무결성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for data integrity)

## 2. 업무 엔티티

### BE-022-001: 기업집단의견저장요청 (Corporate Group Opinion Storage Request)
- **설명:** 기업집단 종합의견 정보 저장 작업을 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | YNIPBA91-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA91-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA91-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 의견 평가 날짜 | YNIPBA91-VALUA-YMD | valuaYmd |
| 기업집단주석구분 (Corporate Group Comment Classification) | String | 2 | 선택사항 | 기업집단 주석 분류 | YNIPBA91-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 일련번호 (Serial Number) | Numeric | 4 | 선택사항 | 의견 레코드 순차 번호 | YNIPBA91-SERNO | serno |
| 주석내용 (Comment Content) | String | 4000 | 선택사항 | 상세 의견 및 평가 내용 | YNIPBA91-COMT-CTNT | comtCtnt |

- **검증 규칙:**
  - 그룹회사코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 YYYYMMDD 형식이어야 함
  - 기업집단주석구분은 선택사항이지만 제공될 때는 유효해야 함
  - 일련번호는 선택사항이며 특정 의견 레코드 식별에 사용됨
  - 주석내용은 포괄적 평가 세부사항을 위한 대용량 텍스트 지원

### BE-022-002: 기업집단의견정보 (Corporate Group Opinion Information)
- **설명:** 상세 평가 내용 및 평가 정보를 포함하여 데이터베이스에 저장된 포괄적 기업집단 의견 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB130-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 의견 평가 날짜 | RIPB130-VALUA-YMD | valuaYmd |
| 기업집단주석구분 (Corporate Group Comment Classification) | String | 2 | NOT NULL | 기업집단 주석 분류 | RIPB130-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 일련번호 (Serial Number) | Numeric | 4 | NOT NULL | 의견 레코드 순차 번호 | RIPB130-SERNO | serno |
| 주석내용 (Comment Content) | String | 4002 | 선택사항 | 상세 의견 및 평가 내용 | RIPB130-COMT-CTNT | comtCtnt |
| 시스템최종처리일시 (System Last Processing Timestamp) | String | 20 | 타임스탬프 형식 | 마지막 시스템 처리 타임스탬프 | RIPB130-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | String | 7 | 선택사항 | 레코드를 마지막으로 처리한 사용자 | RIPB130-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 모든 기본키 필드는 의견 식별을 위해 필수
  - 평가년월일은 유효한 YYYYMMDD 형식이어야 함
  - 주석내용은 포괄적 평가 세부사항을 위한 대용량 텍스트 지원
  - 시스템 타임스탬프는 데이터 무결성을 위한 감사 추적 유지
  - 일련번호는 동일한 평가 날짜 내에서 고유 식별 보장

### BE-022-003: 기업재무대상관리 (Corporate Group Financial Target Management)
- **설명:** 평가 목적을 위한 기업집단 재무대상 관리 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPA130-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPA130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPA130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 등록년월일 (Registration Date) | String | 8 | YYYYMMDD 형식 | 재무대상 등록 날짜 | RIPA130-REGI-YMD | regiYmd |
| 고객식별자 (Customer Identifier) | String | 10 | NOT NULL | 고객 고유 식별자 | RIPA130-CUST-IDNFR | custIdnfr |
| 업체명 (Enterprise Name) | String | 42 | 선택사항 | 업체명 | RIPA130-ENTP-NAME | entpName |
| 평가기준년 (Evaluation Base Year) | String | 4 | YYYY 형식 | 평가 기준년도 | RIPA130-VALUA-BASE-YR | valuaBaseYr |
| 평가대상여부1 (Evaluation Target Flag 1) | String | 1 | Y/N | 첫 번째 평가대상 지시자 | RIPA130-VALUA-TAGET-YN1 | valuaTagetYn1 |
| 전년 (Previous Year) | String | 4 | YYYY 형식 | 비교를 위한 전년도 | RIPA130-PYY | pyy |
| 평가대상여부2 (Evaluation Target Flag 2) | String | 1 | Y/N | 두 번째 평가대상 지시자 | RIPA130-VALUA-TAGET-YN2 | valuaTagetYn2 |
| 전전년 (Before Previous Year) | String | 4 | YYYY 형식 | 전년도 이전 년도 | RIPA130-BF-PYY | bfPyy |
| 평가대상여부3 (Evaluation Target Flag 3) | String | 1 | Y/N | 세 번째 평가대상 지시자 | RIPA130-VALUA-TAGET-YN3 | valuaTagetYn3 |
| 등록부점코드 (Registration Branch Code) | String | 4 | 선택사항 | 등록 부점 코드 | RIPA130-REGI-BRNCD | regiBrncd |
| 등록직원번호 (Registration Employee ID) | String | 7 | 선택사항 | 등록한 직원 ID | RIPA130-REGI-EMPID | regiEmpid |

- **검증 규칙:**
  - 모든 기본키 필드는 재무대상 식별을 위해 필수
  - 등록년월일은 유효한 YYYYMMDD 형식이어야 함
  - 고객식별자는 각 재무대상 레코드에 필수
  - 평가대상여부는 Y 또는 N 값이어야 함
  - 년도 필드는 유효한 YYYY 형식이어야 함
  - 시스템 감사 필드는 데이터 무결성 및 추적성 유지

### BE-022-004: 기업집단의견저장응답 (Corporate Group Opinion Storage Response)
- **설명:** 저장 작업 결과 및 처리 상태를 포함하는 출력 응답
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리여부 (Processing Status) | String | 1 | 상태 코드 | 처리 결과 상태 | YPIPBA91-PRCSS-YN | processingStatus |
| 처리결과 (Processing Result) | Numeric | 1 | 0/1 | 저장 작업 결과 | XDIPA911-O-PRCSS-YN | processingResult |
| 반환상태 (Return Status) | String | 2 | 상태 코드 | 전체 작업 상태 | XDIPA911-R-STAT | returnStatus |
| 오류코드 (Error Code) | String | 8 | 선택사항 | 처리 실패 시 오류 코드 | XDIPA911-R-ERRCD | errorCd |
| 조치코드 (Treatment Code) | String | 8 | 선택사항 | 오류 처리를 위한 조치 코드 | XDIPA911-R-TREAT-CD | treatCd |
| SQL코드 (SQL Code) | Numeric | 5 | 선택사항 | 데이터베이스 작업 결과 코드 | XDIPA911-R-SQL-CD | sqlCd |

- **검증 규칙:**
  - 처리여부는 저장 작업의 성공 또는 실패를 나타냄
  - 처리결과는 저장 작업의 숫자 결과를 표시
  - 반환상태는 전체 작업 상태를 제공
  - 오류코드는 문제 해결을 위한 상세 정보 제공
  - 조치코드는 적절한 오류 해결 조치를 안내
  - SQL코드는 감사 목적으로 데이터베이스 작업 결과를 반영

## 3. 업무 규칙

### BR-022-001: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단식별검증 (Corporate Group Identification Validation)
- **설명:** 의견 저장 작업을 위한 필수 기업집단 식별 매개변수를 검증
- **조건:** 기업집단 의견 저장이 요청될 때 모든 필수 식별 필드가 제공되고 유효해야 함
- **관련 엔티티:** BE-022-001
- **예외:** 필수 필드가 누락되거나 유효하지 않으면 시스템 오류

### BR-022-002: 의견데이터완전성검증 (Opinion Data Completeness Validation)
- **규칙명:** 의견데이터완전성검증 (Opinion Data Completeness Validation)
- **설명:** 저장 목적을 위한 포괄적 의견 데이터 무결성 및 완전성을 보장
- **조건:** 의견 데이터가 저장될 때 모든 필수 의견 필드가 존재하고 적절히 형식화되어야 함
- **관련 엔티티:** BE-022-002, BE-022-004
- **예외:** 의견 내용이 손상되거나 불완전하면 데이터 무결성 오류

### BR-022-003: 평가일자일관성 (Evaluation Date Consistency)
- **규칙명:** 평가일자일관성 (Evaluation Date Consistency)
- **설명:** 기업집단 의견 레코드 전반에 걸쳐 평가 날짜의 일관성을 유지
- **조건:** 평가 날짜가 지정될 때 모든 관련 의견 레코드에서 일관되어야 함
- **관련 엔티티:** BE-022-001, BE-022-002
- **예외:** 평가 날짜가 일치하지 않으면 날짜 불일치 오류

### BR-022-004: 의견저장권한 (Opinion Storage Authorization)
- **규칙명:** 의견저장권한 (Opinion Storage Authorization)
- **설명:** 사용자 권한 수준에 따라 기업집단 의견 저장에 대한 접근을 제어
- **조건:** 의견 저장이 요청될 때 사용자는 해당 기업집단에 대한 적절한 권한을 가져야 함
- **관련 엔티티:** BE-022-001, BE-022-004
- **예외:** 사용자가 적절한 권한이 없으면 접근 거부

### BR-022-005: 재무대상저장일관성 (Financial Target Storage Consistency)
- **규칙명:** 재무대상저장일관성 (Financial Target Storage Consistency)
- **설명:** 재무대상 관리와 의견 저장 데이터 간의 일관성을 보장
- **조건:** 재무대상 데이터가 존재할 때 의견 저장 매개변수와 일관되어야 함
- **관련 엔티티:** BE-022-003, BE-022-002
- **예외:** 재무대상이 의견 매개변수와 일치하지 않으면 데이터 불일치 오류

### BR-022-006: 의견레코드유일성 (Opinion Record Uniqueness)
- **규칙명:** 의견레코드유일성 (Opinion Record Uniqueness)
- **설명:** 기본키 조합을 기반으로 의견 레코드의 유일성을 보장
- **조건:** 의견 데이터를 저장할 때 그룹 코드, 평가 날짜, 주석 분류, 일련번호의 조합이 유일해야 함
- **관련 엔티티:** BE-022-002
- **예외:** 동일한 기본키를 가진 레코드가 이미 존재하면 중복키 오류

### BR-022-007: 주석내용크기검증 (Comment Content Size Validation)
- **규칙명:** 주석내용크기검증 (Comment Content Size Validation)
- **설명:** 주석 내용이 최대 허용 크기를 초과하지 않는지 검증
- **조건:** 주석 내용을 저장할 때 내용 크기가 4000자를 초과하지 않아야 함
- **관련 엔티티:** BE-022-001, BE-022-002
- **예외:** 주석 내용이 최대 허용 길이를 초과하면 크기 제한 오류

## 4. 업무 기능

### F-022-001: 기업집단의견저장처리 (Corporate Group Opinion Storage Processing)
- **기능명:** 기업집단의견저장처리 (Corporate Group Opinion Storage Processing)
- **설명:** 포괄적 기업집단 의견 저장 요청을 처리하고 상세 평가 내용을 저장

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단식별 | Object | 기업집단을 위한 기본 식별 매개변수 |
| 평가기준 | Object | 평가 날짜 및 분류 매개변수 |
| 의견내용 | Object | 저장을 위한 상세 의견 및 평가 내용 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 처리상태 | String | 저장 작업의 성공 또는 실패 상태 |
| 처리결과 | Numeric | 저장 성공을 나타내는 숫자 결과 |
| 오류정보 | Object | 저장 실패 시 상세 오류 정보 |

**처리 로직:**
1. 기업집단 식별 매개변수 검증
2. 평가 날짜 형식 및 일관성 확인
3. 의견 내용 크기 및 형식 검증
4. 동일한 키를 가진 기존 의견 레코드 확인
5. 기업집단 의견 저장소에 의견 데이터 저장 또는 갱신
6. 처리 결과와 함께 저장 작업 상태 반환

**적용된 업무 규칙:**
- BR-022-001: 기업집단식별검증
- BR-022-002: 의견데이터완전성검증
- BR-022-003: 평가일자일관성
- BR-022-006: 의견레코드유일성
- BR-022-007: 주석내용크기검증

### F-022-002: 의견데이터검증 (Opinion Data Validation)
- **기능명:** 의견데이터검증 (Opinion Data Validation)
- **설명:** 저장 작업을 위한 기업집단 의견 데이터 무결성 및 완전성을 검증

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 의견레코드 | Object | 검증을 위한 완전한 의견 레코드 |
| 검증기준 | Object | 검증 규칙 및 요구사항 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증결과 | Boolean | 데이터가 검증을 통과했는지 나타냄 |
| 오류메시지 | Array | 있는 경우 검증 오류 목록 |

**처리 로직:**
1. 의견 식별을 위한 필수 필드 검증
2. 의견 내용 형식 및 구조 확인
3. 평가 날짜 일관성 검증
4. 주석 분류 유효성 확인
5. 내용 크기 제한 검증
6. 상세 오류 정보와 함께 검증 결과 반환

**적용된 업무 규칙:**
- BR-022-002: 의견데이터완전성검증
- BR-022-003: 평가일자일관성
- BR-022-004: 의견저장권한
- BR-022-007: 주석내용크기검증

### F-022-003: 재무대상통합 (Financial Target Integration)
- **기능명:** 재무대상통합 (Financial Target Integration)
- **설명:** 재무대상 관리 정보를 기업집단 의견 저장과 통합

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단키 | Object | 기업집단 식별을 위한 기본키 |
| 재무기준 | Object | 재무 평가 기준 및 매개변수 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 통합상태 | String | 성공 또는 실패 상태 |
| 재무데이터 | Object | 통합된 재무대상 정보 |
| 일관성확인 | Object | 데이터 일관성 검증 결과 |

**처리 로직:**
1. 재무대상 관리 데이터 조회
2. 의견 저장 매개변수와의 일관성 검증
3. 재무 데이터를 의견 정보와 통합
4. 데이터 소스 간 일관성 확인 수행
5. 검증 결과와 함께 통합된 데이터 반환

**적용된 업무 규칙:**
- BR-022-005: 재무대상저장일관성
- BR-022-002: 의견데이터완전성검증
- BR-022-003: 평가일자일관성

### F-022-004: 데이터베이스저장관리 (Database Storage Management)
- **기능명:** 데이터베이스저장관리 (Database Storage Management)
- **설명:** 삽입 및 갱신 작업을 포함한 기업집단 의견 데이터의 데이터베이스 저장 작업을 관리

**입력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 의견데이터 | Object | 저장을 위한 완전한 의견 데이터 |
| 작업유형 | String | 삽입 또는 갱신 작업 지시자 |

**출력 매개변수:**
| 매개변수 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 저장결과 | String | 데이터베이스 작업 결과 상태 |
| 레코드상태 | String | 레코드가 삽입되었는지 갱신되었는지 나타냄 |
| SQL상태 | Object | 데이터베이스 작업 상태 및 코드 |

**처리 로직:**
1. 기존 의견 레코드 확인
2. 삽입 또는 갱신 작업 결정
3. 적절한 데이터베이스 작업 실행
4. 데이터베이스 작업 결과 처리
5. 저장 작업 상태 반환

**적용된 업무 규칙:**
- BR-022-006: 의견레코드유일성
- BR-022-002: 의견데이터완전성검증

## 5. 프로세스 흐름

```
기업집단 종합의견 저장 프로세스 흐름

1. 초기화 단계
   ├── 입력 매개변수 수락 (그룹 코드, 평가 날짜, 의견 내용)
   ├── 공통 영역 설정 초기화
   └── 출력 영역 할당 준비

2. 매개변수 검증 단계
   ├── 그룹회사코드 검증
   ├── 기업집단그룹코드 검증
   ├── 기업집단등록코드 검증
   ├── 평가년월일 형식 검증
   └── 주석내용 크기 검증

3. 프레임워크 설정 단계
   ├── 공통 인터페이스 초기화를 위한 IJICOMM 호출
   ├── 업무분류코드(060) 설정
   └── 프레임워크 구성요소 초기화

4. 데이터베이스 저장 단계
   ├── 데이터베이스 저장 매개변수 준비
   ├── DIPA911 의견 데이터 저장 실행
   ├── 기존 의견 레코드 확인
   ├── INSERT 또는 UPDATE 작업 수행
   └── THKIPB130 테이블 저장 결과 처리

5. 의견 데이터 처리 단계
   ├── 의견 데이터 완전성 검증
   ├── 저장을 위한 의견 내용 형식화
   ├── 데이터 무결성 확인 적용
   └── 저장 작업 결과 처리

6. 응답 생성 단계
   ├── 데이터베이스 결과를 출력 구조로 매핑
   ├── 처리 상태 지시자 설정
   ├── 오류 조건 처리 (있는 경우)
   └── 최종 응답 구조 준비

7. 완료 단계
   ├── 출력 영역 관리 완료
   ├── 시스템 타임스탬프 설정
   └── 포괄적 의견 저장 결과 반환
```

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **메인 프로그램:** `/KIP.DONLINE.SORC/AIPBA91.cbl` - 기업집단종합의견저장
- **데이터베이스 구성요소:** `/KIP.DONLINE.SORC/DIPA911.cbl` - 의견 데이터 저장을 위한 데이터베이스 컨트롤러
- **데이터베이스 I/O:** `/KIP.DDB2.DBSORC/RIPA130.cbl` - 재무대상관리를 위한 데이터베이스 I/O 프로그램
- **입력 인터페이스:** `/KIP.DCOMMON.COPY/YNIPBA91.cpy` - 입력 매개변수 구조
- **출력 인터페이스:** `/KIP.DCOMMON.COPY/YPIPBA91.cpy` - 출력 결과 구조
- **데이터베이스 인터페이스:** `/KIP.DCOMMON.COPY/XDIPA911.cpy` - 데이터베이스 구성요소 인터페이스
- **테이블 구조:** `/KIP.DDB2.DBCOPY/TRIPB130.cpy`, `/KIP.DDB2.DBCOPY/TKIPB130.cpy`
- **프레임워크 구성요소:** `/ZKESA.LIB/IJICOMM.cbl`, `/ZKESA.LIB/YCCOMMON.cpy`, `/ZKESA.LIB/XIJICOMM.cpy`
- **공통 구성요소:** `/ZKESA.LIB/YCDBIOCA.cpy`, `/ZKESA.LIB/YCCSICOM.cpy`, `/ZKESA.LIB/YCCBICOM.cpy`, `/ZKESA.LIB/XZUGOTMY.cpy`

### 6.2 업무 규칙 구현

- **BR-022-001:** AIPBA91.cbl 120-130행에 구현 (기업집단 매개변수 검증)
  ```cobol
  IF YNIPBA91-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  ```

- **BR-022-002:** DIPA911.cbl 80-120행에 구현 (의견 데이터 검증)
  ```cobol
  IF BICOM-GROUP-CO-CD = SPACE
      #USRLOG "그룹회사코드 오류"
      #ERROR CO-B3600003 CO-UKIH0029 CO-STAT-ERROR
  END-IF
  IF XDIPA911-I-VALUA-YMD = SPACE
      #USRLOG "기준일자 오류"
      #ERROR CO-B2700094 CO-UKII0390 CO-STAT-ERROR
  END-IF
  ```

- **BR-022-003:** DIPA911.cbl 140-180행에 구현 (평가 날짜 일관성 검증)
  ```cobol
  MOVE XDIPA911-I-VALUA-YMD TO KIPB130-PK-VALUA-YMD
  MOVE XDIPA911-I-CORP-CLCT-GROUP-CD TO KIPB130-PK-CORP-CLCT-GROUP-CD
  MOVE XDIPA911-I-CORP-CLCT-REGI-CD TO KIPB130-PK-CORP-CLCT-REGI-CD
  ```

- **BR-022-004:** AIPBA91.cbl 80-100행에 구현 (프레임워크 권한 제어)
  ```cobol
  MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD
  #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
  IF COND-XIJICOMM-OK
     CONTINUE
  ELSE
     #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
  END-IF
  ```

- **BR-022-006:** DIPA911.cbl 200-250행에 구현 (의견 레코드 유일성 확인)
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC
  EVALUATE TRUE
      WHEN COND-DBIO-OK
           MOVE 'Y' TO WK-REC-EXIST
      WHEN COND-DBIO-MRNF
           MOVE 'N' TO WK-REC-EXIST
      WHEN OTHER
           #ERROR CO-B4200223 CO-UKIH0072 CO-STAT-ERROR
  END-EVALUATE
  ```

- **BR-022-007:** DIPA911.cbl 280-320행에 구현 (주석 내용 저장)
  ```cobol
  MOVE XDIPA911-I-COMT-CTNT TO RIPB130-COMT-CTNT
  IF WK-REC-EXIST = 'N'
      #DYDBIO INSERT-CMD-Y TKIPB130-PK TRIPB130-REC
  ELSE
      #DYDBIO UPDATE-CMD-Y TKIPB130-PK TRIPB130-REC
  END-IF
  ```

### 6.3 기능 구현

- **F-022-001:** AIPBA91.cbl 130-170행에 구현 (S3000-PROCESS-RTN - 메인 의견 저장 처리)
  ```cobol
  S3000-PROCESS-RTN.
      INITIALIZE XDIPA911-IN
      MOVE YNIPBA91-CA TO XDIPA911-IN
      #USRLOG "DIPA911 CALL"
      #DYCALL DIPA911 YCCOMMON-CA XDIPA911-CA
      IF COND-XDIPA911-OK
         CONTINUE
      ELSE
         #ERROR XDIPA911-R-ERRCD XDIPA911-R-TREAT-CD XDIPA911-R-STAT
      END-IF
      MOVE XDIPA911-OUT TO YPIPBA91-CA
  S3000-PROCESS-EXT.
  ```

- **F-022-002:** DIPA911.cbl 70-120행에 구현 (S2000-VALIDATION-RTN - 의견 데이터 검증)
  ```cobol
  S2000-VALIDATION-RTN.
      IF BICOM-GROUP-CO-CD = SPACE
          #USRLOG "그룹회사코드 오류"
          #ERROR CO-B3600003 CO-UKIH0029 CO-STAT-ERROR
      END-IF
      IF XDIPA911-I-VALUA-YMD = SPACE
          #USRLOG "기준일자 오류"
          #ERROR CO-B2700094 CO-UKII0390 CO-STAT-ERROR
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-022-004:** DIPA911.cbl 250-350행에 구현 (S3100-DBIO-SAVE-RTN - 데이터베이스 저장 관리)
  ```cobol
  S3100-DBIO-SAVE-RTN.
      MOVE BICOM-GROUP-CO-CD TO RIPB130-GROUP-CO-CD
      MOVE XDIPA911-I-CORP-CLCT-GROUP-CD TO RIPB130-CORP-CLCT-GROUP-CD
      MOVE XDIPA911-I-CORP-CLCT-REGI-CD TO RIPB130-CORP-CLCT-REGI-CD
      MOVE XDIPA911-I-VALUA-YMD TO RIPB130-VALUA-YMD
      MOVE XDIPA911-I-CORP-C-COMT-DSTCD TO RIPB130-CORP-C-COMT-DSTCD
      MOVE XDIPA911-I-SERNO TO RIPB130-SERNO
      MOVE XDIPA911-I-COMT-CTNT TO RIPB130-COMT-CTNT
      IF WK-REC-EXIST = 'N'
          #DYDBIO INSERT-CMD-Y TKIPB130-PK TRIPB130-REC
      ELSE
          #DYDBIO UPDATE-CMD-Y TKIPB130-PK TRIPB130-REC
      END-IF
      EVALUATE TRUE
          WHEN COND-DBIO-OK
               CONTINUE
          WHEN OTHER
               EVALUATE WK-REC-EXIST
                   WHEN 'N'
                        #ERROR CO-B4200221 CO-UKIH0516 CO-STAT-ERROR
                   WHEN 'Y'
                        #ERROR CO-B4200224 CO-UKIH0516 CO-STAT-ERROR
               END-EVALUATE
      END-EVALUATE
  S3100-DBIO-SAVE-EXT.
  ```

### 6.4 데이터베이스 테이블
- **THKIPB130**: 기업집단주석명세 (Corporate Group Opinion Details) - 평가 내용 및 평가 데이터를 포함한 포괄적 의견 정보 저장을 위한 기본 테이블
- **THKIPA130**: 기업재무대상관리정보 (Corporate Financial Target Management Information) - 재무대상 관리 및 평가 일관성을 위한 지원 테이블

### 6.5 오류 코드
- **오류 코드 B3600552**: 기업집단코드 오류 - 기업집단코드 값이 누락됨
- **오류 코드 B3600003**: 그룹회사코드 오류 - 그룹회사코드 값이 누락됨
- **오류 코드 B2700094**: 날짜 오류 - 유효하지 않은 평가 날짜 형식
- **오류 코드 B4200223**: 테이블 선택 오류 - 데이터베이스 쿼리 실패
- **오류 코드 B4200221**: 테이블 삽입 오류 - 데이터베이스 삽입 작업 실패
- **오류 코드 B4200224**: 테이블 갱신 오류 - 데이터베이스 갱신 작업 실패
- **조치 코드 UKII0282**: 기업집단코드를 입력하고 거래를 재시도하세요
- **조치 코드 UKIH0029**: 그룹회사코드를 입력하고 거래를 재시도하세요
- **조치 코드 UKII0390**: 평가날짜를 입력하고 거래를 재시도하세요
- **조치 코드 UKIH0072**: 시스템 관리자에게 연락하세요
- **조치 코드 UKIH0516**: 데이터 수정 문제에 대해 시스템 관리자에게 연락하세요

### 6.6 기술 아키텍처
- **AS 계층**: AIPBA91 - 기업집단종합의견저장을 위한 애플리케이션 서버 구성요소
- **IC 계층**: IJICOMM - 공통 영역 설정 및 프레임워크 초기화를 위한 인터페이스 구성요소
- **DC 계층**: DIPA911 - THKIPB130 데이터베이스 접근 및 의견 데이터 저장을 위한 데이터 구성요소
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 거래 관리를 위한 비즈니스 구성요소 프레임워크
- **SQLIO 계층**: RIPA130, YCDBIOCA - SQL 실행 및 결과 처리를 위한 데이터베이스 접근 구성요소
- **프레임워크**: XZUGOTMY - 출력 영역 할당 및 메모리 관리를 위한 프레임워크 구성요소

### 6.7 데이터 흐름 아키텍처
1. **입력 처리 흐름**: AIPBA91 → YNIPBA91 (입력 구조) → 매개변수 검증 → 처리 초기화
2. **프레임워크 설정 흐름**: AIPBA91 → IJICOMM → XIJICOMM → YCCOMMON → 공통 영역 초기화
3. **데이터베이스 저장 흐름**: AIPBA91 → DIPA911 → RIPA130 → YCDBIOCA → THKIPB130 데이터베이스 작업
4. **서비스 통신 흐름**: AIPBA91 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스
5. **출력 처리 흐름**: 데이터베이스 결과 → XDIPA911 → YPIPBA91 (출력 구조) → AIPBA91
6. **오류 처리 흐름**: 모든 계층 → 프레임워크 오류 처리 → XZUGOTMY → 사용자 오류 메시지
7. **거래 흐름**: 요청 → 검증 → 데이터베이스 저장 → 결과 처리 → 응답 → 거래 완료
