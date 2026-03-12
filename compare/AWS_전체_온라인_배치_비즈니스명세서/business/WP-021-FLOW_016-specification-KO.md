# 업무 명세서: 기업집단종합의견조회 (Corporate Group Comprehensive Opinion Inquiry)

## 문서 관리
- **버전:** 1.0
- **날짜:** 2025-09-25
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-021
- **진입점:** AIP4A90
- **업무 도메인:** TRANSACTION

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 트랜잭션 처리 도메인에서 기업집단 종합의견 정보를 관리하는 포괄적인 온라인 조회 시스템을 구현합니다. 이 시스템은 상세한 기업집단 평가의견에 대한 실시간 접근을 제공하여 기업집단 고객의 신용평가 및 위험평가 프로세스를 지원합니다.

업무 목적은 다음과 같습니다:
- 기업집단 신용평가를 위한 종합의견 정보 조회 (Retrieve comprehensive opinion information for corporate group credit evaluation)
- 상세 기업집단 평가의견 실시간 접근 제공 (Provide real-time access to detailed corporate group evaluation opinions)
- 구조화된 의견 데이터 조회를 통한 트랜잭션 일관성 지원 (Support transaction consistency through structured opinion data retrieval)
- 평가 코멘트 및 사업 평가를 포함한 상세 기업집단 의견 프로필 유지 (Maintain detailed corporate group opinion profiles including evaluation comments and business assessments)
- 온라인 거래처리를 위한 실시간 의견 데이터 접근 (Enable real-time opinion data access for online transaction processing)
- 기업집단 평가 프로세스의 감사추적 및 데이터 무결성 제공 (Provide audit trail and data integrity for corporate group evaluation processes)

시스템은 다중 모듈 온라인 플로우를 통해 데이터를 처리합니다: AIP4A90 → IJICOMM → YCCOMMON → XIJICOMM → DIPA901 → RIPA130 → YCDBIOCA → YCCSICOM → YCCBICOM → TRIPB130 → TKIPB130 → XDIPA901 → XZUGOTMY → YNIP4A90 → YPIP4A90, 기업집단 식별 검증, 의견 데이터 조회, 포괄적 조회 작업을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 의견 조회를 위한 기업집단 식별 및 검증 (Corporate group identification and validation for opinion inquiry)
- 상세 평가 내용을 포함한 종합의견 데이터 조회 (Comprehensive opinion data retrieval with detailed evaluation content)
- 구조화된 데이터 접근을 통한 트랜잭션 일관성 관리 (Transaction consistency management through structured data access)
- 정확한 평가 표시를 위한 의견 내용 정밀도 처리 (Opinion content precision handling for accurate evaluation display)
- 포괄적 평가정보를 포함한 기업집단 의견 프로필 관리 (Corporate group opinion profile management with comprehensive evaluation information)
- 데이터 무결성을 위한 처리상태 추적 및 오류처리 (Processing status tracking and error handling for data integrity)

## 2. 업무 엔티티

### BE-021-001: 기업집단의견조회요청 (Corporate Group Opinion Inquiry Request)
- **설명:** 기업집단 종합의견 정보 조회 작업을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | YNIP4A90-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIP4A90-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIP4A90-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 의견 평가 날짜 | YNIP4A90-VALUA-YMD | valuaYmd |
| 기업집단주석구분 (Corporate Group Comment Classification) | String | 2 | 선택사항 | 기업집단 주석 분류 | YNIP4A90-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 일련번호 (Serial Number) | Numeric | 4 | 선택사항 | 의견 레코드의 순차 번호 | YNIP4A90-SERNO | serno |

- **검증 규칙:**
  - 그룹회사코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 YYYYMMDD 형식이어야 함
  - 기업집단주석구분은 선택사항이지만 제공될 때는 유효해야 함
  - 일련번호는 선택사항이며 특정 의견 레코드 식별에 사용됨

### BE-021-002: 기업집단의견정보 (Corporate Group Opinion Information)
- **설명:** 상세한 평가 내용 및 평가 정보를 포함한 포괄적인 기업집단 의견 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB130-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 의견 평가 날짜 | RIPB130-VALUA-YMD | valuaYmd |
| 기업집단주석구분 (Corporate Group Comment Classification) | String | 2 | NOT NULL | 기업집단 주석 분류 | RIPB130-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 일련번호 (Serial Number) | Numeric | 4 | NOT NULL | 의견 레코드의 순차 번호 | RIPB130-SERNO | serno |
| 주석내용 (Comment Content) | String | 4002 | 선택사항 | 상세한 의견 및 평가 내용 | RIPB130-COMT-CTNT | comtCtnt |
| 시스템최종처리일시 (System Last Processing Timestamp) | String | 20 | 타임스탬프 형식 | 마지막 시스템 처리 타임스탬프 | RIPB130-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | String | 7 | 선택사항 | 레코드를 마지막으로 처리한 사용자 | RIPB130-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 모든 기본키 필드는 의견 식별을 위해 필수임
  - 평가년월일은 유효한 YYYYMMDD 형식이어야 함
  - 주석내용은 포괄적인 평가 세부사항을 위한 대용량 텍스트 지원
  - 시스템 타임스탬프는 데이터 무결성을 위한 감사 추적 유지
  - 일련번호는 동일한 평가 날짜 내에서 고유 식별 보장

### BE-021-003: 기업재무대상관리 (Corporate Group Financial Target Management)
- **설명:** 평가 목적을 위한 기업집단 재무대상 관리 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPA130-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPA130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPA130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 등록년월일 (Registration Date) | String | 8 | YYYYMMDD 형식 | 재무대상 등록 날짜 | RIPA130-REGI-YMD | regiYmd |
| 고객식별자 (Customer Identifier) | String | 10 | NOT NULL | 고객의 고유 식별자 | RIPA130-CUST-IDNFR | custIdnfr |
| 업체명 (Enterprise Name) | String | 42 | 선택사항 | 기업체 명칭 | RIPA130-ENTP-NAME | entpName |
| 평가기준년 (Evaluation Base Year) | String | 4 | YYYY 형식 | 평가 기준년도 | RIPA130-VALUA-BASE-YR | valuaBaseYr |
| 평가대상여부1 (Evaluation Target Flag 1) | String | 1 | Y/N | 첫 번째 평가대상 지시자 | RIPA130-VALUA-TAGET-YN1 | valuaTagetYn1 |
| 전년 (Previous Year) | String | 4 | YYYY 형식 | 비교를 위한 전년도 | RIPA130-PYY | pyy |
| 평가대상여부2 (Evaluation Target Flag 2) | String | 1 | Y/N | 두 번째 평가대상 지시자 | RIPA130-VALUA-TAGET-YN2 | valuaTagetYn2 |
| 전전년 (Before Previous Year) | String | 4 | YYYY 형식 | 전년도 이전 년도 | RIPA130-BF-PYY | bfPyy |
| 평가대상여부3 (Evaluation Target Flag 3) | String | 1 | Y/N | 세 번째 평가대상 지시자 | RIPA130-VALUA-TAGET-YN3 | valuaTagetYn3 |
| 등록부점코드 (Registration Branch Code) | String | 4 | 선택사항 | 등록 부점 코드 | RIPA130-REGI-BRNCD | regiBrncd |
| 등록직원번호 (Registration Employee ID) | String | 7 | 선택사항 | 등록한 직원 ID | RIPA130-REGI-EMPID | regiEmpid |

- **검증 규칙:**
  - 모든 기본키 필드는 재무대상 식별을 위해 필수임
  - 등록년월일은 유효한 YYYYMMDD 형식이어야 함
  - 고객식별자는 각 재무대상 레코드에 필수임
  - 평가대상여부 플래그는 Y 또는 N 값이어야 함
  - 년도 필드는 유효한 YYYY 형식이어야 함
  - 시스템 감사 필드는 데이터 무결성과 추적성 유지

### BE-021-004: 기업집단의견조회응답 (Corporate Group Opinion Inquiry Response)
- **설명:** 포괄적인 의견 조회 결과 및 상세한 평가 내용을 포함한 출력 응답
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 주석내용 (Comment Content) | String | 4002 | 선택사항 | 포괄적인 의견 및 평가 내용 | YPIP4A90-COMT-CTNT | comtCtnt |
| 처리상태 (Processing Status) | String | 2 | 상태 코드 | 처리 결과 상태 | XDIPA901-R-STAT | processingStatus |
| 오류코드 (Error Code) | String | 8 | 선택사항 | 처리 실패 시 오류 코드 | XDIPA901-R-ERRCD | errorCd |
| 조치코드 (Treatment Code) | String | 8 | 선택사항 | 오류 처리를 위한 조치 코드 | XDIPA901-R-TREAT-CD | treatCd |
| SQL코드 (SQL Code) | Numeric | 5 | 선택사항 | 데이터베이스 작업 결과 코드 | XDIPA901-R-SQL-CD | sqlCd |

- **검증 규칙:**
  - 주석내용은 주요 의견 평가 결과를 포함함
  - 처리상태는 조회 작업의 성공 또는 실패를 나타냄
  - 오류코드는 문제 해결을 위한 상세 정보 제공
  - 조치코드는 적절한 오류 해결 조치를 안내함
  - SQL코드는 감사 목적의 데이터베이스 작업 결과 반영
## 3. 업무 규칙

### BR-021-001: 기업집단식별검증 (Corporate Group Identification Validation)
- **규칙명:** 기업집단식별검증 (Corporate Group Identification Validation)
- **설명:** 의견 조회 작업을 위한 필수 기업집단 식별 파라미터를 검증합니다
- **조건:** 기업집단 의견 조회가 요청될 때 모든 필수 식별 필드가 제공되고 유효해야 합니다
- **관련 엔티티:** BE-021-001
- **예외사항:** 필수 필드가 누락되거나 유효하지 않으면 시스템 오류

### BR-021-002: 의견데이터완전성검증 (Opinion Data Completeness Validation)
- **규칙명:** 의견데이터완전성검증 (Opinion Data Completeness Validation)
- **설명:** 평가 목적을 위한 포괄적인 의견 데이터 무결성과 완전성을 보장합니다
- **조건:** 의견 데이터가 조회될 때 모든 필수 의견 필드가 존재하고 적절히 형식화되어야 합니다
- **관련 엔티티:** BE-021-002, BE-021-004
- **예외사항:** 의견 내용이 손상되거나 불완전하면 데이터 무결성 오류

### BR-021-003: 평가일자일관성 (Evaluation Date Consistency)
- **규칙명:** 평가일자일관성 (Evaluation Date Consistency)
- **설명:** 기업집단 의견 레코드 전반에 걸쳐 평가 날짜의 일관성을 유지합니다
- **조건:** 평가 날짜가 지정될 때 모든 관련 의견 레코드에서 일관되어야 합니다
- **관련 엔티티:** BE-021-001, BE-021-002
- **예외사항:** 평가 날짜가 일치하지 않으면 날짜 불일치 오류

### BR-021-004: 의견접근권한 (Opinion Access Authorization)
- **규칙명:** 의견접근권한 (Opinion Access Authorization)
- **설명:** 사용자 권한 수준에 따라 기업집단 의견 정보에 대한 접근을 제어합니다
- **조건:** 의견 조회가 요청될 때 사용자는 해당 기업집단에 대한 적절한 권한을 가져야 합니다
- **관련 엔티티:** BE-021-001, BE-021-004
- **예외사항:** 사용자가 적절한 권한이 없으면 접근 거부

### BR-021-005: 재무대상평가일관성 (Financial Target Evaluation Consistency)
- **규칙명:** 재무대상평가일관성 (Financial Target Evaluation Consistency)
- **설명:** 재무대상 관리와 의견 평가 데이터 간의 일관성을 보장합니다
- **조건:** 재무대상 데이터가 존재할 때 의견 평가 파라미터와 일관되어야 합니다
- **관련 엔티티:** BE-021-003, BE-021-002
- **예외사항:** 재무대상이 의견 파라미터와 일치하지 않으면 데이터 불일치 오류

## 4. 업무 기능

### F-021-001: 기업집단의견조회처리 (Corporate Group Opinion Inquiry Processing)
- **기능명:** 기업집단의견조회처리 (Corporate Group Opinion Inquiry Processing)
- **설명:** 포괄적인 기업집단 의견 조회 요청을 처리하고 상세한 평가 내용을 조회합니다

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단 식별정보 | Object | 기업집단의 기본 식별 파라미터 |
| 평가 기준 | Object | 평가 날짜 및 분류 파라미터 |
| 조회 옵션 | Object | 특정 의견 레코드를 위한 선택적 파라미터 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 의견 내용 | String | 포괄적인 의견 및 평가 내용 |
| 처리 결과 | String | 조회의 성공 또는 실패 상태 |
| 오류 정보 | Object | 조회 실패 시 상세한 오류 정보 |

**처리 로직:**
1. 기업집단 식별 파라미터 검증
2. 평가 날짜 형식 및 일관성 확인
3. 기업집단 의견 저장소에서 의견 데이터 조회
4. 표시를 위한 의견 내용 형식화
5. 처리 상태와 함께 포괄적인 의견 정보 반환

**적용된 업무 규칙:**
- BR-021-001: 기업집단식별검증
- BR-021-002: 의견데이터완전성검증
- BR-021-003: 평가일자일관성

### F-021-002: 의견데이터검증 (Opinion Data Validation)
- **기능명:** 의견데이터검증 (Opinion Data Validation)
- **설명:** 조회 작업을 위한 기업집단 의견 데이터 무결성과 완전성을 검증합니다

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 의견 레코드 | Object | 검증을 위한 완전한 의견 레코드 |
| 검증 기준 | Object | 검증 규칙 및 요구사항 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 검증 결과 | Boolean | 데이터가 검증을 통과했는지 여부 |
| 오류 메시지 | Array | 검증 오류가 있을 경우 오류 목록 |

**처리 로직:**
1. 의견 식별을 위한 필수 필드 검증
2. 의견 내용 형식 및 구조 확인
3. 평가 날짜 일관성 검증
4. 주석 분류 유효성 확인
5. 상세한 오류 정보와 함께 검증 결과 반환

**적용된 업무 규칙:**
- BR-021-002: 의견데이터완전성검증
- BR-021-003: 평가일자일관성
- BR-021-004: 의견접근권한

### F-021-003: 재무대상통합 (Financial Target Integration)
- **기능명:** 재무대상통합 (Financial Target Integration)
- **설명:** 재무대상 관리 정보를 기업집단 의견 데이터와 통합합니다

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 기업집단 키 | Object | 기업집단 식별을 위한 기본 키 |
| 재무 기준 | Object | 재무 평가 기준 및 파라미터 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| 통합 상태 | String | 성공 또는 실패 상태 |
| 재무 데이터 | Object | 통합된 재무대상 정보 |
| 일관성 확인 | Object | 데이터 일관성 검증 결과 |

**처리 로직:**
1. 재무대상 관리 데이터 조회
2. 의견 평가 파라미터와의 일관성 검증
3. 재무 데이터를 의견 정보와 통합
4. 데이터 소스 간 일관성 확인 수행
5. 검증 결과와 함께 통합된 데이터 반환

**적용된 업무 규칙:**
- BR-021-005: 재무대상평가일관성
- BR-021-002: 의견데이터완전성검증
- BR-021-003: 평가일자일관성
## 5. 프로세스 흐름

```
기업집단종합의견조회 프로세스 흐름

1. 초기화 단계
   ├── 입력 파라미터 수신 (그룹코드, 평가일자)
   ├── 공통영역 설정 초기화
   └── 출력영역 할당 준비

2. 파라미터 검증 단계
   ├── 그룹회사코드 검증
   ├── 기업집단그룹코드 검증
   ├── 기업집단등록코드 검증
   └── 평가년월일 형식 검증

3. 프레임워크 설정 단계
   ├── 공통 인터페이스 초기화를 위한 IJICOMM 호출
   ├── 업무분류코드(060) 설정
   └── 프레임워크 컴포넌트 초기화

4. 데이터베이스 조회 단계
   ├── 데이터베이스 조회 파라미터 준비
   ├── DIPA901 의견 데이터 조회 실행
   └── THKIPB130 테이블 접근 결과 처리

5. 의견 데이터 처리 단계
   ├── 데이터베이스 결과에서 의견 내용 추출
   ├── 의견 데이터 완전성 검증
   ├── 출력을 위한 의견 내용 형식화
   └── 데이터 무결성 검사 적용

6. 응답 생성 단계
   ├── 데이터베이스 결과를 출력 구조로 매핑
   ├── 처리 상태 지시자 설정
   ├── 오류 조건 처리 (있는 경우)
   └── 최종 응답 구조 준비

7. 완료 단계
   ├── 출력영역 관리 완료
   ├── 시스템 타임스탬프 설정
   └── 종합의견조회 결과 반환
```

## 6. 레거시 구현 참조

### 소스 파일
- **메인 프로그램:** `/KIP.DONLINE.SORC/AIP4A90.cbl` - 기업집단종합의견조회
- **데이터베이스 컴포넌트:** `/KIP.DDB2.DBSORC/DIPA901.cbl` - 의견 데이터 접근을 위한 데이터베이스 컨트롤러
- **데이터베이스 I/O:** `/KIP.DDB2.DBSORC/RIPA130.cbl` - 재무대상관리를 위한 데이터베이스 I/O 프로그램
- **입력 인터페이스:** `/KIP.DCOMMON.COPY/YNIP4A90.cpy` - 입력 파라미터 구조
- **출력 인터페이스:** `/KIP.DCOMMON.COPY/YPIP4A90.cpy` - 출력 결과 구조
- **데이터베이스 인터페이스:** `/KIP.DDB2.DBCOPY/XDIPA901.cpy` - 데이터베이스 컴포넌트 인터페이스
- **테이블 구조:** `/KIP.DDB2.DBCOPY/TRIPB130.cpy`, `/KIP.DDB2.DBCOPY/TKIPB130.cpy`
- **프레임워크 컴포넌트:** `/ZKESA.LIB/IJICOMM.cbl`, `/ZKESA.LIB/YCCOMMON.cpy`, `/ZKESA.LIB/XIJICOMM.cpy`
- **공통 컴포넌트:** `/ZKESA.LIB/YCDBIOCA.cpy`, `/ZKESA.LIB/YCCSICOM.cpy`, `/ZKESA.LIB/YCCBICOM.cpy`, `/ZKESA.LIB/XZUGOTMY.cpy`

### 업무 규칙 구현

- **BR-021-001:** AIP4A90.cbl 150-180라인에 구현 (기업집단 파라미터 검증)
  ```cobol
  IF YNIP4A90-GROUP-CO-CD = SPACE
      #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF
  IF YNIP4A90-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF
  IF YNIP4A90-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF
  IF YNIP4A90-VALUA-YMD = SPACE
      #ERROR CO-B2700094 CO-UKII0390 CO-STAT-ERROR
  END-IF
  ```

- **BR-021-002:** DIPA901.cbl 200-250라인에 구현 (의견 데이터 조회 및 검증)
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC
  IF YCDBSQLA-RETURN-CD NOT = '00'
      MOVE '21' TO WK-RETURN-CODE
      MOVE YCDBSQLA-RETURN-CD TO XDIPA901-R-SQL-CD
      MOVE 'B4200223' TO XDIPA901-R-ERRCD
      MOVE 'UKIH0072' TO XDIPA901-R-TREAT-CD
  ELSE
      MOVE RIPB130-COMT-CTNT TO XDIPA901-O-COMT-CTNT
  END-IF
  ```

- **BR-021-003:** DIPA901.cbl 120-150라인에 구현 (평가일자 일관성 검증)
  ```cobol
  IF XDIPA901-I-VALUA-YMD = SPACE
      MOVE '11' TO WK-RETURN-CODE
      MOVE 'B2700094' TO XDIPA901-R-ERRCD
      MOVE 'UKII0390' TO XDIPA901-R-TREAT-CD
  END-IF
  MOVE XDIPA901-I-VALUA-YMD TO TKIPB130-VALUA-YMD
  ```

- **BR-021-004:** AIP4A90.cbl 100-130라인에 구현 (프레임워크 권한 제어)
  ```cobol
  INITIALIZE XIJICOMM-IN
  MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD
  #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
  IF COND-XIJICOMM-OK
      CONTINUE
  ELSE
      #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
  END-IF
  ```

- **BR-021-005:** RIPA130.cbl 180-220라인에 구현 (재무대상 일관성 확인)
  ```cobol
  SELECT GROUP-CO-CD, CORP-CLCT-GROUP-CD, CORP-CLCT-REGI-CD, VALUA-BASE-YR
  FROM THKIPA130
  WHERE GROUP-CO-CD = :RIPA130-I-GROUP-CO-CD
    AND CORP-CLCT-GROUP-CD = :RIPA130-I-CORP-CLCT-GROUP-CD
    AND CORP-CLCT-REGI-CD = :RIPA130-I-CORP-CLCT-REGI-CD
  ```

### 기능 구현

- **F-021-001:** AIP4A90.cbl 300-400라인에 구현 (S3000-PROCESS-RTN - 메인 의견조회 처리)
  ```cobol
  S3000-PROCESS-RTN.
      INITIALIZE XDIPA901-CA
      MOVE YNIP4A90-GROUP-CO-CD TO XDIPA901-I-GROUP-CO-CD
      MOVE YNIP4A90-CORP-CLCT-GROUP-CD TO XDIPA901-I-CORP-CLCT-GROUP-CD
      MOVE YNIP4A90-CORP-CLCT-REGI-CD TO XDIPA901-I-CORP-CLCT-REGI-CD
      MOVE YNIP4A90-VALUA-YMD TO XDIPA901-I-VALUA-YMD
      MOVE YNIP4A90-CORP-C-COMT-DSTCD TO XDIPA901-I-CORP-C-COMT-DSTCD
      MOVE YNIP4A90-SERNO TO XDIPA901-I-SERNO
      #DYCALL DIPA901 YCCOMMON-CA XDIPA901-CA
      MOVE XDIPA901-O-COMT-CTNT TO YPIP4A90-COMT-CTNT
  S3000-PROCESS-EXT.
  ```

- **F-021-002:** DIPA901.cbl 250-320라인에 구현 (S2000-VALIDATION-RTN - 의견 데이터 검증)
  ```cobol
  S2000-VALIDATION-RTN.
      IF BICOM-GROUP-CO-CD = SPACE
          MOVE '11' TO WK-RETURN-CODE
          MOVE 'B3600003' TO XDIPA901-R-ERRCD
          MOVE 'UKFH0208' TO XDIPA901-R-TREAT-CD
          GO TO S2000-VALIDATION-EXT
      END-IF
      IF XDIPA901-I-CORP-CLCT-GROUP-CD = SPACE
          MOVE '11' TO WK-RETURN-CODE
          MOVE 'B3600552' TO XDIPA901-R-ERRCD
          MOVE 'UKIP0001' TO XDIPA901-R-TREAT-CD
      END-IF
  S2000-VALIDATION-EXT.
  ```

- **F-021-003:** DIPA901.cbl 350-420라인에 구현 (S3100-DBIO-SELECT-RTN - 데이터베이스 쿼리 실행)
  ```cobol
  S3100-DBIO-SELECT-RTN.
      INITIALIZE TKIPB130-PK TRIPB130-REC
      MOVE XDIPA901-I-GROUP-CO-CD TO TKIPB130-GROUP-CO-CD
      MOVE XDIPA901-I-CORP-CLCT-GROUP-CD TO TKIPB130-CORP-CLCT-GROUP-CD
      MOVE XDIPA901-I-CORP-CLCT-REGI-CD TO TKIPB130-CORP-CLCT-REGI-CD
      MOVE XDIPA901-I-VALUA-YMD TO TKIPB130-VALUA-YMD
      MOVE XDIPA901-I-CORP-C-COMT-DSTCD TO TKIPB130-CORP-C-COMT-DSTCD
      MOVE XDIPA901-I-SERNO TO TKIPB130-SERNO
      #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC
      EVALUATE TRUE
          WHEN COND-DBIO-OK
              MOVE RIPB130-COMT-CTNT TO XDIPA901-O-COMT-CTNT
          WHEN COND-DBIO-MRNF
              MOVE '21' TO WK-RETURN-CODE
              MOVE 'B4200223' TO XDIPA901-R-ERRCD
              MOVE 'UKIH0072' TO XDIPA901-R-TREAT-CD
          WHEN OTHER
              MOVE '21' TO WK-RETURN-CODE
              MOVE 'B4200223' TO XDIPA901-R-ERRCD
              MOVE 'UKIH0072' TO XDIPA901-R-TREAT-CD
      END-EVALUATE
  S3100-DBIO-SELECT-EXT.
  ```

### 데이터베이스 테이블
- **THKIPB130**: 기업집단종합의견명세 (Corporate Group Comprehensive Opinion Details) - 평가 내용 및 평가 데이터를 포함한 종합의견 정보 저장을 위한 기본 테이블
- **THKIPA130**: 기업재무대상관리정보 (Corporate Financial Target Management Information) - 재무대상 관리 및 평가 일관성을 위한 지원 테이블

### 오류 코드
- **오류 코드 B3600003**: 그룹회사코드 오류 - 그룹회사코드 값이 누락됨
- **오류 코드 B3600552**: 기업집단코드 오류 - 기업집단코드 값이 누락됨
- **오류 코드 B2700094**: 날짜 오류 - 유효하지 않은 평가일자 형식
- **오류 코드 B4200223**: 테이블 select 오류 - 데이터베이스 쿼리 실패
- **조치 코드 UKFH0208**: 그룹회사코드를 입력하고 거래를 재시도하세요
- **조치 코드 UKIP0001**: 기업집단코드를 입력하고 거래를 재시도하세요
- **조치 코드 UKII0282**: 기업집단등록코드를 입력하고 거래를 재시도하세요
- **조치 코드 UKII0390**: 평가년월일을 입력하고 거래를 재시도하세요
- **조치 코드 UKIH0072**: 시스템 관리자에게 연락하세요

### 기술 아키텍처
- **AS 계층**: AIP4A90 - 기업집단종합의견조회를 위한 애플리케이션 서버 컴포넌트
- **IC 계층**: IJICOMM - 공통영역 설정 및 프레임워크 초기화를 위한 인터페이스 컴포넌트
- **DC 계층**: DIPA901 - THKIPB130 데이터베이스 접근 및 의견 데이터 조회를 위한 데이터 컴포넌트
- **BC 계층**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리를 위한 비즈니스 컴포넌트 프레임워크
- **SQLIO 계층**: RIPA130, YCDBIOCA - SQL 실행 및 결과 처리를 위한 데이터베이스 접근 컴포넌트
- **프레임워크**: XZUGOTMY - 출력영역 할당 및 메모리 관리를 위한 프레임워크 컴포넌트

### 데이터 흐름 아키텍처
1. **입력 처리 흐름**: AIP4A90 → YNIP4A90 (입력 구조) → 파라미터 검증 → 처리 초기화
2. **프레임워크 설정 흐름**: AIP4A90 → IJICOMM → XIJICOMM → YCCOMMON → 공통영역 초기화
3. **데이터베이스 접근 흐름**: AIP4A90 → DIPA901 → RIPA130 → YCDBIOCA → THKIPB130 데이터베이스 작업
4. **서비스 통신 흐름**: AIP4A90 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스
5. **출력 처리 흐름**: 데이터베이스 결과 → XDIPA901 → YPIP4A90 (출력 구조) → AIP4A90
6. **오류 처리 흐름**: 모든 계층 → 프레임워크 오류 처리 → XZUGOTMY → 사용자 오류 메시지
7. **트랜잭션 흐름**: 요청 → 검증 → 데이터베이스 쿼리 → 결과 처리 → 응답 → 트랜잭션 완료
