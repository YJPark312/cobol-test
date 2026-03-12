# 업무 명세서: 기업집단그룹코드조회 (Corporate Group Code Inquiry)

## 문서 관리
- **버전:** 1.0
- **날짜:** 2025-09-25
- **표준:** IEEE 830-1998
- **작업패키지 ID:** WP-019
- **진입점:** AIP4A55
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 작업패키지는 신용평가 및 위험평가 목적을 위한 유연한 검색 기능을 통해 기업집단 정보를 조회하는 포괄적인 온라인 조회 시스템을 구현합니다. 시스템은 사용자가 특정 그룹코드 또는 기업집단명 패턴을 통해 기업집단 데이터를 찾을 수 있는 이중 검색 모드를 제공하여 신용처리 도메인에서 효율적인 기업관계 분석을 지원합니다.

업무 목적은 다음과 같습니다:
- 신용평가를 위한 유연한 기업집단 정보 조회 제공 (Provide flexible corporate group information retrieval for credit evaluation)
- 포괄적인 기업집단 발견을 위한 이중 검색 모드 지원 (Support dual search modes for comprehensive corporate group discovery)
- 그룹코드 및 명칭 기반 검색을 통한 기업관계 분석 활성화 (Enable corporate relationship analysis through group code and name-based searches)
- 신용의사결정을 위한 기업집단 데이터 무결성 및 일관성 유지 (Maintain corporate group data integrity and consistency for credit decisions)
- 현재 기업집단 등록정보에 대한 실시간 접근 제공 (Provide real-time access to current corporate group registration information)
- 정확한 기업집단 식별을 통한 신용평가 워크플로우 지원 (Support credit evaluation workflow with accurate corporate group identification)

시스템은 다중 모듈 온라인 플로우를 통해 데이터를 처리합니다: AIP4A55 → IJICOMM → YCCOMMON → XIJICOMM → DIPA461 → QIPA462 → YCDBSQLA → XQIPA462 → YCCSICOM → YCCBICOM → QIPA463 → XQIPA463 → XDIPA461 → XZUGOTMY → YNIP4A55 → YPIP4A55, 기업집단 검색 매개변수 검증, 이중 모드 데이터베이스 쿼리, 포괄적인 결과 포맷팅을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 검색모드 결정을 위한 처리구분 검증 (Processing type validation for search mode determination)
- 기업집단코드 기반 정확한 검색 기능 (Corporate group code-based exact search functionality)
- 기업집단명 패턴 기반 유연한 검색 기능 (Corporate group name pattern-based flexible search capability)
- 그리드 기반 출력 형식의 다중 레코드 결과 처리 (Multi-record result processing with grid-based output formatting)
- 트랜잭션 일관성을 갖춘 실시간 데이터베이스 접근 (Real-time database access with transaction consistency)
- 공통영역 설정 및 오류처리를 위한 프레임워크 통합 (Framework integration for common area setup and error handling)

## 2. 업무 엔티티

### BE-019-001: 기업집단조회요청 (Corporate Group Inquiry Request)
- **설명:** 처리구분 결정을 포함한 기업집단 정보 조회 작업을 위한 입력 매개변수
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Type Code) | String | 2 | NOT NULL | 검색 모드 결정을 위한 처리구분 | YNIP4A55-PRCSS-DSTCD | prcssDstcd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | Optional | 정확한 검색을 위한 기업집단 분류코드 | YNIP4A55-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단명 (Corporate Group Name) | String | 72 | Optional | 패턴 기반 검색을 위한 기업집단명 | YNIP4A55-CORP-CLCT-NAME | corpClctName |

- **검증 규칙:**
  - 처리구분코드는 필수이며 공백이거나 SPACE일 수 없음
  - 처리구분에 따라 기업집단그룹코드 또는 기업집단명 중 하나는 제공되어야 함
  - 기업집단그룹코드는 정확한 검색 모드에 사용됨
  - 기업집단명은 패턴 기반 검색 모드에 사용됨
  - 데이터베이스 쿼리 실행 전 입력 매개변수 검증

### BE-019-002: 기업집단정보 (Corporate Group Information)
- **설명:** 기업관계 데이터베이스에서 조회된 포괄적인 기업집단 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 데이터베이스 쿼리를 위한 그룹회사 식별자 | XQIPA462-I-GROUP-CO-CD | groupCoCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | XQIPA462-O-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류코드 | XQIPA462-O-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단명 (Corporate Group Name) | String | 72 | NOT NULL | 전체 기업집단명 | XQIPA462-O-CORP-CLCT-NAME | corpClctName |

- **검증 규칙:**
  - 모든 필드는 기업관계 테이블에서 조회됨
  - 그룹회사코드는 주요 검색 키 역할
  - 기업집단등록코드는 각 그룹 등록을 고유하게 식별
  - 기업집단명은 정확한 매치와 패턴 기반 검색 모두 지원
  - 데이터베이스 제약조건을 통한 데이터 무결성 유지

### BE-019-003: 기업집단검색결과 (Corporate Group Search Results)
- **설명:** 그리드 기반 표시를 포함한 검색 결과가 포함된 포맷된 출력 응답
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수 (Total Item Count) | Numeric | 5 | Positive integer | 검색 결과의 총 개수 | YPIP4A55-TOTAL-NOITM | totalNoitm |
| 현재건수 (Present Item Count) | Numeric | 5 | Positive integer | 결과 집합의 현재 항목 수 | YPIP4A55-PRSNT-NOITM | prsntNoitm |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 각 결과의 등록코드 | YPIP4A55-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 각 결과의 그룹 분류코드 | YPIP4A55-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단명 (Corporate Group Name) | String | 72 | NOT NULL | 각 결과의 그룹명 | YPIP4A55-CORP-CLCT-NAME | corpClctName |

- **검증 규칙:**
  - 결과는 최대 1000개 레코드로 그리드 형식으로 표시됨
  - 총건수는 완전한 검색 결과 크기를 반영
  - 현재건수는 현재 페이지 또는 배치 크기를 나타냄
  - 모든 결과 필드는 데이터베이스 소스에서 데이터 무결성 유지
  - 그리드 구조는 효율적인 사용자 인터페이스 표시 지원

### BE-019-004: 데이터베이스조회제어정보 (Database Query Control Information)
- **설명:** 기업집단 데이터 조회를 위한 데이터베이스 쿼리 매개변수 및 제어 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 쿼리를 위한 그룹회사 식별자 | XQIPA462-I-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | Optional | 정확한 검색을 위한 기업집단코드 | XQIPA462-I-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단명패턴 (Corporate Group Name Pattern) | String | 72 | Optional | 검색을 위한 기업집단명 패턴 | XQIPA463-I-CORP-CLCT-NAME | corpClctNamePattern |
| SQL선택건수 (SQL Select Count) | Numeric | 9 | Positive integer | 조회된 레코드 수 | DBSQL-SELECT-CNT | sqlSelectCnt |
| 데이터베이스반환코드 (Database Return Code) | String | 2 | '00', '02', '09' | 데이터베이스 작업 결과코드 | YCDBSQLA-RETURN-CD | dbReturnCd |

- **검증 규칙:**
  - 쿼리 매개변수는 처리구분과 검색 모드에 의해 결정됨
  - 정확한 검색은 그룹코드 기준 사용
  - 패턴 검색은 유연한 매칭을 위한 명칭 패턴 사용
  - SQL선택건수는 성공적인 조회 결과를 나타냄
  - 데이터베이스반환코드는 작업 성공 또는 실패 상태를 나타냄
## 3. 업무 규칙

### BR-019-001: 처리구분검증 (Processing Type Validation)
- **설명:** 검색 모드를 결정하고 적절한 요청 처리를 보장하기 위해 처리구분코드를 검증
- **조건:** 기업집단 조회가 요청될 때 처리구분코드가 제공되고 공백이 아니어야 함
- **관련 엔티티:** BE-019-001 (기업집단조회요청)
- **예외사항:** 
  - 처리구분코드는 SPACE이거나 공백일 수 없음
  - 처리구분은 실행할 검색 모드를 결정함

### BR-019-002: 기업집단코드검색논리 (Corporate Group Code Search Logic)
- **설명:** 그룹회사코드와 기업집단코드를 사용하여 기업집단 정보에 대한 정확한 검색을 실행
- **조건:** 정확한 검색 모드가 선택될 때 정확한 매치 기준을 사용하여 기업집단 데이터를 조회
- **관련 엔티티:** BE-019-002 (기업집단정보), BE-019-004 (데이터베이스조회제어정보)
- **예외사항:** 
  - 유효한 그룹회사 및 기업집단코드 조합에 대해 데이터베이스 쿼리가 성공해야 함
  - 동일한 그룹코드에 대해 여러 등록이 존재하는 경우 여러 레코드 반환

### BR-019-003: 기업집단명패턴검색논리 (Corporate Group Name Pattern Search Logic)
- **설명:** 그룹회사코드와 명칭 패턴을 사용하여 기업집단 정보에 대한 패턴 기반 검색을 실행
- **조건:** 패턴 검색 모드가 선택될 때 패턴 매칭 작업을 사용하여 기업집단 데이터를 조회
- **관련 엔티티:** BE-019-002 (기업집단정보), BE-019-004 (데이터베이스조회제어정보)
- **예외사항:** 
  - 유연한 매칭을 위해 기업집단명에 패턴 작업 적용
  - 패턴 검색에서 고유 결과 보장
  - 명칭 패턴을 기반으로 모든 매칭 레코드 반환

### BR-019-004: 검색결과처리논리 (Search Results Processing Logic)
- **설명:** 데이터베이스 쿼리 결과를 처리하고 그리드 기반 표시를 위해 포맷팅
- **조건:** 데이터베이스 쿼리가 성공적으로 완료될 때 적절한 개수와 그리드 구조로 결과를 포맷
- **관련 엔티티:** BE-019-003 (기업집단검색결과)
- **예외사항:** 
  - 총건수는 완전한 결과 집합 크기를 반영해야 함
  - 현재건수는 현재 배치 또는 페이지 크기를 나타냄
  - 그리드 구조는 응답당 최대 1000개 레코드 지원

### BR-019-005: 데이터베이스트랜잭션일관성 (Database Transaction Consistency)
- **설명:** 적절한 트랜잭션 격리 및 오류 처리로 일관된 데이터 조회 보장
- **조건:** 데이터베이스 쿼리가 실행될 때 트랜잭션 일관성과 적절한 오류 처리 유지
- **관련 엔티티:** BE-019-004 (데이터베이스조회제어정보)
- **예외사항:** 
  - 효율적인 데이터 조회를 위한 결과 집합 관리
  - 적절한 오류 코드 확인 및 오류 전파
  - 일관된 읽기를 위한 트랜잭션 격리 유지

### BR-019-006: 프레임워크통합준수 (Framework Integration Compliance)
- **설명:** 공통 프레임워크 구성요소 및 오류 처리 표준과의 적절한 통합 보장
- **조건:** 요청을 처리할 때 모든 프레임워크 구성요소를 초기화하고 검증
- **관련 엔티티:** 모든 업무 엔티티
- **예외사항:** 
  - 공통 영역 설정을 위한 프레임워크 호출이 성공해야 함
  - 처리 전에 출력 영역 할당이 성공해야 함
  - 오류 처리는 프레임워크 표준을 따라야 함
## 4. 업무 기능

### F-019-001: 기업집단조회검증 (Corporate Group Inquiry Validation)
- **설명:** 기업집단 조회를 위한 입력 매개변수를 검증하고 처리 환경을 초기화
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 처리구분코드 | String | 2 | NOT NULL | 검색 모드 결정 | YNIP4A55-PRCSS-DSTCD |
| 기업집단그룹코드 | String | 3 | Optional | 정확한 검색을 위한 그룹코드 | YNIP4A55-CORP-CLCT-GROUP-CD |
| 기업집단명 | String | 72 | Optional | 패턴 검색을 위한 그룹명 | YNIP4A55-CORP-CLCT-NAME |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 검증결과 | String | 2 | 성공/오류 코드 | YCCOMMON-RETURN-CD |
| 프레임워크상태 | Structure | Variable | 프레임워크 초기화 상태 | XIJICOMM-* |
| 처리환경 | Structure | Variable | 초기화된 처리 변수 | WK-AREA |

- **처리 논리:**
  1. 작업 저장소 및 프레임워크 영역 초기화
  2. 프레임워크를 사용하여 출력 영역 할당
  3. 처리구분코드가 SPACE가 아닌지 검증
  4. 프레임워크 호출을 사용하여 공통 영역 설정
  5. 처리구분에 따라 데이터베이스 쿼리 매개변수 준비

- **적용된 업무 규칙:** BR-019-001, BR-019-006

### F-019-002: 기업집단코드검색 (Corporate Group Code Search)
- **설명:** 그룹코드 기준을 사용하여 기업집단 정보에 대한 정확한 검색을 실행
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 그룹회사코드 | String | 3 | NOT NULL | 그룹회사 식별자 | XQIPA462-I-GROUP-CO-CD |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 분류 | XQIPA462-I-CORP-CLCT-GROUP-CD |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 기업집단등록코드 | String | 3 | 등록 식별자 | XQIPA462-O-CORP-CLCT-REGI-CD |
| 기업집단그룹코드 | String | 3 | 그룹 분류코드 | XQIPA462-O-CORP-CLCT-GROUP-CD |
| 기업집단명 | String | 72 | 전체 그룹명 | XQIPA462-O-CORP-CLCT-NAME |
| 레코드개수 | Numeric | 9 | 발견된 레코드 수 | DBSQL-SELECT-CNT |

- **처리 논리:**
  1. 데이터베이스 쿼리 매개변수 준비
  2. 기업관계 테이블에 대한 쿼리 실행
  3. 정확한 매치 기준을 사용하여 매칭 레코드 조회
  4. 적절한 오류 처리로 결과 집합 처리
  5. 레코드 개수와 함께 포맷된 결과 반환

- **적용된 업무 규칙:** BR-019-002, BR-019-005

### F-019-003: 기업집단명패턴검색 (Corporate Group Name Pattern Search)
- **설명:** 명칭 기준을 사용하여 기업집단 정보에 대한 패턴 기반 검색을 실행
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 그룹회사코드 | String | 3 | NOT NULL | 그룹회사 식별자 | XQIPA463-I-GROUP-CO-CD |
| 기업집단명패턴 | String | 72 | NOT NULL | 검색을 위한 명칭 패턴 | XQIPA463-I-CORP-CLCT-NAME |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 기업집단그룹코드 | String | 3 | 그룹 분류코드 | XQIPA463-O-CORP-CLCT-GROUP-CD |
| 기업집단등록코드 | String | 3 | 등록 식별자 | XQIPA463-O-CORP-CLCT-REGI-CD |
| 기업집단명 | String | 42 | 축약된 그룹명 | XQIPA463-O-CORP-CLCT-NAME |
| 레코드개수 | Numeric | 9 | 발견된 레코드 수 | DBSQL-SELECT-CNT |

- **처리 논리:**
  1. 데이터베이스 쿼리 매개변수 준비
  2. 패턴 작업 및 고유 절과 함께 쿼리 실행
  3. 패턴 기반 기준을 사용하여 매칭 레코드 조회
  4. 적절한 오류 처리로 결과 집합 처리
  5. 레코드 개수와 함께 포맷된 결과 반환

- **적용된 업무 규칙:** BR-019-003, BR-019-005

### F-019-004: 검색결과처리 (Search Results Processing)
- **설명:** 데이터베이스 쿼리 결과를 처리하고 그리드 기반 출력 표시를 위해 포맷팅
- **입력:**

| 매개변수 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 |
|----------|-------------|------|----------|------|-------------|
| 데이터베이스결과 | Structure | Variable | 원시 데이터베이스 쿼리 결과 | XQIPA462-OUT / XQIPA463-OUT |
| 레코드개수 | Numeric | 9 | 조회된 레코드 수 | DBSQL-SELECT-CNT |

- **출력:**

| 매개변수 | 데이터 타입 | 길이 | 설명 | 레거시 변수 |
|----------|-------------|------|------|-------------|
| 총건수 | Numeric | 5 | 총 검색 결과 | YPIP4A55-TOTAL-NOITM |
| 현재건수 | Numeric | 5 | 현재 배치 크기 | YPIP4A55-PRSNT-NOITM |
| 그리드결과 | Structure | Variable | 포맷된 그리드 데이터 | YPIP4A55-GRID |

- **처리 논리:**
  1. 정확한 검색 또는 패턴 검색에서 데이터베이스 쿼리 결과 처리
  2. 총건수 및 현재건수 계산
  3. 표시를 위해 결과를 그리드 구조로 포맷
  4. 적절한 데이터 매핑 및 필드 정렬 보장
  5. 사용자 인터페이스 표시를 위한 적절한 개수 설정

- **적용된 업무 규칙:** BR-019-004, BR-019-006
## 5. 프로세스 흐름

```
기업집단그룹코드조회 프로세스 흐름

1. 초기화 단계
   ├── 입력 매개변수 수락 (처리구분, 그룹코드, 그룹명)
   ├── 공통 영역 설정 초기화
   └── 출력 영역 할당 준비

2. 매개변수 검증 단계
   ├── 처리구분코드가 공백이 아닌지 검증
   ├── 처리구분에 따른 검색 매개변수 검증
   └── 프레임워크 구성요소 초기화

3. 검색 모드 결정 단계
   ├── 처리구분코드 분석
   ├── 정확한 검색 또는 패턴 검색 모드 결정
   └── 적절한 쿼리 매개변수 준비

4. 데이터베이스 쿼리 단계
   ├── 그룹코드 기준에 대한 정확한 검색 실행
   ├── 그룹명 기준에 대한 패턴 검색 실행
   ├── 기업집단 정보 조회
   └── 오류 처리와 함께 쿼리 결과 처리

5. 결과 처리 단계
   ├── 데이터베이스 결과를 그리드 구조로 포맷
   ├── 총건수 및 현재건수 계산
   ├── 결과 집합 제한 적용
   └── 출력 응답 구조 준비

6. 완료 단계
   ├── 포맷된 조회 결과 반환
   ├── 처리 통계 생성
   └── 트랜잭션 처리 완료
```
## 6. 레거시 구현 참조

### 6.1 소스 파일
- **메인 프로그램:** `/KIP.DONLINE.SORC/AIP4A55.cbl` - 기업집단그룹코드조회 메인 프로그램
- **데이터베이스 컨트롤러:** `/KIP.DONLINE.SORC/DIPA461.cbl` - 기업집단조회를 위한 데이터베이스 컨트롤러
- **정확한 검색 쿼리:** `/KIP.DDB2.DBSORC/QIPA462.cbl` - 정확한 그룹코드 검색을 위한 SQL 쿼리 프로그램
- **패턴 검색 쿼리:** `/KIP.DDB2.DBSORC/QIPA463.cbl` - 패턴 명칭 검색을 위한 SQL 쿼리 프로그램
- **입력 인터페이스:** `/KIP.DCOMMON.COPY/YNIP4A55.cpy` - 기업집단조회 입력 구조
- **출력 인터페이스:** `/KIP.DCOMMON.COPY/YPIP4A55.cpy` - 기업집단조회 출력 구조
- **데이터베이스 인터페이스 (정확한):** `/KIP.DCOMMON.COPY/XQIPA462.cpy` - 정확한 검색 데이터베이스 인터페이스
- **데이터베이스 인터페이스 (패턴):** `/KIP.DCOMMON.COPY/XQIPA463.cpy` - 패턴 검색 데이터베이스 인터페이스
- **데이터베이스 컨트롤러 인터페이스:** `/KIP.DCOMMON.COPY/XDIPA461.cpy` - 데이터베이스 컨트롤러 인터페이스
- **프레임워크 구성요소:** `/ZKESA.LIB/IJICOMM.cbl`, `/ZKESA.LIB/YCCOMMON.cpy`, `/ZKESA.LIB/XIJICOMM.cpy`
- **공통 구성요소:** `/ZKESA.LIB/YCDBSQLA.cpy`, `/ZKESA.LIB/YCCSICOM.cpy`, `/ZKESA.LIB/YCCBICOM.cpy`, `/ZKESA.LIB/XZUGOTMY.cpy`

### 6.2 업무 규칙 구현

- **BR-019-001:** AIP4A55.cbl 180-200행에 구현 (처리구분 검증)
  ```cobol
  IF YNIP4A55-PRCSS-DSTCD = SPACE
     #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
  END-IF
  MOVE YNIP4A55-PRCSS-DSTCD TO WK-PRCSS-DSTCD
  EVALUATE WK-PRCSS-DSTCD
     WHEN '01'
        CONTINUE
     WHEN '02'
        CONTINUE
     WHEN OTHER
        #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
  END-EVALUATE
  ```

- **BR-019-002:** AIP4A55.cbl 250-290행에 구현 (기업집단코드 검색 논리)
  ```cobol
  MOVE YNIP4A55-CORP-CLCT-GROUP-CD TO XDIPA461-I-CORP-CLCT-GROUP-CD
  MOVE 'QIPA462' TO XDIPA461-I-QRYID
  #DYCALL DIPA461 XDIPA461-CA
  EVALUATE TRUE
     WHEN COND-XDIPA461-OK
        CONTINUE
     WHEN COND-XDIPA461-NOTFOUND
        MOVE ZERO TO WK-TOTAL-CNT
        GO TO S3000-PROC-END
     WHEN OTHER
        #ERROR XDIPA461-R-ERRCD XDIPA461-R-TREAT-CD XDIPA461-R-STAT
  END-EVALUATE
  ```

- **BR-019-003:** AIP4A55.cbl 300-340행에 구현 (기업집단명 패턴 검색 논리)
  ```cobol
  MOVE YNIP4A55-CORP-CLCT-NAME TO XDIPA461-I-CORP-CLCT-NAME
  MOVE 'QIPA463' TO XDIPA461-I-QRYID
  #DYCALL DIPA461 XDIPA461-CA
  EVALUATE TRUE
     WHEN COND-XDIPA461-OK
        CONTINUE
     WHEN COND-XDIPA461-NOTFOUND
        MOVE ZERO TO WK-TOTAL-CNT
        GO TO S3000-PROC-END
     WHEN OTHER
        #ERROR XDIPA461-R-ERRCD XDIPA461-R-TREAT-CD XDIPA461-R-STAT
  END-EVALUATE
  ```

- **BR-019-004:** AIP4A55.cbl 350-400행에 구현 (검색 결과 처리 논리)
  ```cobol
  MOVE XDIPA461-OUT TO YPIP4A55-CA
  MOVE DBSQL-SELECT-CNT TO WK-TOTAL-CNT
  MOVE WK-TOTAL-CNT TO YPIP4A55-TOTAL-NOITM
  IF WK-TOTAL-CNT > 1000
     MOVE 1000 TO YPIP4A55-PRSNT-NOITM
  ELSE
     MOVE WK-TOTAL-CNT TO YPIP4A55-PRSNT-NOITM
  END-IF
  PERFORM VARYING WK-IDX FROM 1 BY 1 UNTIL WK-IDX > YPIP4A55-PRSNT-NOITM
     MOVE XDIPA461-O-CORP-CLCT-REGI-CD(WK-IDX) TO YPIP4A55-CORP-CLCT-REGI-CD(WK-IDX)
     MOVE XDIPA461-O-CORP-CLCT-GROUP-CD(WK-IDX) TO YPIP4A55-CORP-CLCT-GROUP-CD(WK-IDX)
     MOVE XDIPA461-O-CORP-CLCT-NAME(WK-IDX) TO YPIP4A55-CORP-CLCT-NAME(WK-IDX)
  END-PERFORM
  ```

- **BR-019-005:** QIPA462.cbl 180-220행 및 QIPA463.cbl 190-230행에 구현 (데이터베이스 트랜잭션 일관성)
  ```cobol
  EXEC SQL
     DECLARE C1 CURSOR WITH HOLD FOR
     SELECT 기업집단등록코드, 기업집단그룹코드, 기업집단명
     FROM THKIPA111
     WHERE 그룹회사코드 = :XQIPA462-I-GROUP-CO-CD
       AND 기업집단그룹코드 = :XQIPA462-I-CORP-CLCT-GROUP-CD
     ORDER BY 기업집단등록코드
  END-EXEC
  EXEC SQL
     OPEN C1
  END-EXEC
  EXEC SQL
     FETCH C1 INTO :XQIPA462-O-CORP-CLCT-REGI-CD,
                   :XQIPA462-O-CORP-CLCT-GROUP-CD,
                   :XQIPA462-O-CORP-CLCT-NAME
  END-EXEC
  ```

- **BR-019-006:** AIP4A55.cbl 150-180행에 구현 (프레임워크 통합 준수)
  ```cobol
  INITIALIZE WK-AREA XIJICOMM-IN XZUGOTMY-IN
  #GETOUT YPIP4A55-CA
  #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
  IF COND-XIJICOMM-OK
     CONTINUE
  ELSE
     #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
  END-IF
  MOVE 'V1' TO WK-FMID(1:2)
  MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
  #BOFMID WK-FMID
  ```

### 6.3 기능 구현

- **F-019-001:** AIP4A55.cbl 130-210행에 구현 (S1000-INITIALIZE-RTN 및 S2000-VALIDATION-RTN)
  ```cobol
  S1000-INITIALIZE-RTN.
      INITIALIZE WK-AREA XIJICOMM-IN XZUGOTMY-IN
      #GETOUT YPIP4A55-CA
      #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA
      IF COND-XIJICOMM-OK
         CONTINUE
      ELSE
         #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
      END-IF
      MOVE 'V1' TO WK-FMID(1:2)
      MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
      #BOFMID WK-FMID
  S1000-INITIALIZE-EXT.
  
  S2000-VALIDATION-RTN.
      IF YNIP4A55-PRCSS-DSTCD = SPACE
         #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
      END-IF
      EVALUATE YNIP4A55-PRCSS-DSTCD
         WHEN '01'
            IF YNIP4A55-CORP-CLCT-GROUP-CD = SPACE
               #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
            END-IF
         WHEN '02'
            IF YNIP4A55-CORP-CLCT-NAME = SPACE
               #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
            END-IF
         WHEN OTHER
            #ERROR CO-B3000070 CO-UKIP0007 CO-STAT-ERROR
      END-EVALUATE
  S2000-VALIDATION-EXT.
  ```

- **F-019-002:** AIP4A55.cbl 240-300행에 구현 (S3100-PROC-EXACT-SEARCH-RTN)
  ```cobol
  S3100-PROC-EXACT-SEARCH-RTN.
      INITIALIZE XDIPA461-CA
      MOVE '001' TO XDIPA461-I-GROUP-CO-CD
      MOVE YNIP4A55-CORP-CLCT-GROUP-CD TO XDIPA461-I-CORP-CLCT-GROUP-CD
      MOVE 'QIPA462' TO XDIPA461-I-QRYID
      #DYCALL DIPA461 XDIPA461-CA
      EVALUATE TRUE
         WHEN COND-XDIPA461-OK
            CONTINUE
         WHEN COND-XDIPA461-NOTFOUND
            MOVE ZERO TO WK-TOTAL-CNT
            GO TO S3100-PROC-EXACT-SEARCH-EXT
         WHEN OTHER
            #ERROR XDIPA461-R-ERRCD XDIPA461-R-TREAT-CD XDIPA461-R-STAT
      END-EVALUATE
      MOVE DBSQL-SELECT-CNT TO WK-TOTAL-CNT
  S3100-PROC-EXACT-SEARCH-EXT.
  ```

- **F-019-003:** AIP4A55.cbl 310-370행에 구현 (S3200-PROC-PATTERN-SEARCH-RTN)
  ```cobol
  S3200-PROC-PATTERN-SEARCH-RTN.
      INITIALIZE XDIPA461-CA
      MOVE '001' TO XDIPA461-I-GROUP-CO-CD
      MOVE YNIP4A55-CORP-CLCT-NAME TO XDIPA461-I-CORP-CLCT-NAME
      MOVE 'QIPA463' TO XDIPA461-I-QRYID
      #DYCALL DIPA461 XDIPA461-CA
      EVALUATE TRUE
         WHEN COND-XDIPA461-OK
            CONTINUE
         WHEN COND-XDIPA461-NOTFOUND
            MOVE ZERO TO WK-TOTAL-CNT
            GO TO S3200-PROC-PATTERN-SEARCH-EXT
         WHEN OTHER
            #ERROR XDIPA461-R-ERRCD XDIPA461-R-TREAT-CD XDIPA461-R-STAT
      END-EVALUATE
      MOVE DBSQL-SELECT-CNT TO WK-TOTAL-CNT
  S3200-PROC-PATTERN-SEARCH-EXT.
  ```

- **F-019-004:** AIP4A55.cbl 380-450행에 구현 (S4000-RESULT-PROCESSING-RTN)
  ```cobol
  S4000-RESULT-PROCESSING-RTN.
      MOVE XDIPA461-OUT TO YPIP4A55-CA
      MOVE WK-TOTAL-CNT TO YPIP4A55-TOTAL-NOITM
      IF WK-TOTAL-CNT > 1000
         MOVE 1000 TO YPIP4A55-PRSNT-NOITM
      ELSE
         MOVE WK-TOTAL-CNT TO YPIP4A55-PRSNT-NOITM
      END-IF
      PERFORM VARYING WK-IDX FROM 1 BY 1 UNTIL WK-IDX > YPIP4A55-PRSNT-NOITM
         MOVE XDIPA461-O-CORP-CLCT-REGI-CD(WK-IDX) TO YPIP4A55-CORP-CLCT-REGI-CD(WK-IDX)
         MOVE XDIPA461-O-CORP-CLCT-GROUP-CD(WK-IDX) TO YPIP4A55-CORP-CLCT-GROUP-CD(WK-IDX)
         MOVE XDIPA461-O-CORP-CLCT-NAME(WK-IDX) TO YPIP4A55-CORP-CLCT-NAME(WK-IDX)
      END-PERFORM
      MOVE 'V1' TO WK-FMID(1:2)
      MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
      #BOFMID WK-FMID
  S4000-RESULT-PROCESSING-EXT.
  ```

### 6.4 데이터베이스 테이블
- **THKIPA111 (기업관계연결정보)**: 기업집단 관계 정보 테이블
  - 기업집단 관계 정보를 위한 주요 테이블
  - 키 필드: 그룹회사코드 (Group Company Code), 기업집단그룹코드 (Corporate Group Code), 기업집단등록코드 (Corporate Group Registration Code)
  - 포함: 검색 작업을 위한 기업집단명 (Corporate Group Name)
  - LIKE 작업을 통한 정확한 매치 및 패턴 기반 검색 모두 지원
  - QIPA462 (정확한 검색) 및 QIPA463 (패턴 검색) 쿼리 프로그램 모두에서 사용
  - 최적의 쿼리 성능을 위해 그룹회사코드 및 기업집단코드에 인덱스 설정
  - 관련 기업 정보 테이블과의 참조 무결성 유지

### 6.5 오류 코드
- **오류 집합 CO-B3000070**:
  - **에러코드**: CO-UKIP0007 - "처리구분코드 오류"
  - **조치메시지**: CO-UKIP0007 - "처리구분코드 확인"
  - **사용**: AIP4A55.cbl에서 PRCSS-DSTCD가 SPACE이거나 유효하지 않을 때 처리구분코드 검증 오류

- **오류 집합 XIJICOMM**:
  - **에러코드**: XIJICOMM-R-ERRCD - 프레임워크 초기화 오류 코드
  - **조치메시지**: XIJICOMM-R-TREAT-CD - 프레임워크 오류 처리 코드
  - **사용**: AIP4A55.cbl에서 프레임워크 초기화 및 공통 영역 설정 오류

- **오류 집합 XDIPA461**:
  - **에러코드**: XDIPA461-R-ERRCD - 데이터베이스 구성요소 호출 오류 코드
  - **조치메시지**: XDIPA461-R-TREAT-CD - 데이터베이스 구성요소 오류 처리 코드
  - **사용**: AIP4A55.cbl에서 데이터베이스 구성요소 호출 및 처리 오류

- **SQL 오류 코드**:
  - **SQLCODE 0**: 성공적인 SQL 실행
  - **SQLCODE +100**: 데이터 없음 조건
  - **SQLCODE -xxx**: 다양한 SQL 실행 오류
  - **사용**: QIPA462.cbl 및 QIPA463.cbl에서 데이터베이스 쿼리 실행 및 트랜잭션 오류 처리

- **프레임워크 오류 코드**:
  - **XZUGOTMY 오류 코드**: 출력 영역 할당 및 메모리 관리 오류
  - **YCDBSQLA 오류 코드**: 데이터베이스 접근 계층 오류 코드
  - **사용**: 애플리케이션 플로우 전반에 걸친 프레임워크 구성요소 오류 처리

### 6.6 기술 아키텍처
- **AS 계층 (Application Server)**: AIP4A55 - 기업집단그룹코드조회 처리를 위한 메인 애플리케이션 서버 구성요소
- **IC 계층 (Interface Component)**: IJICOMM - 공통 영역 설정 및 프레임워크 초기화를 위한 인터페이스 구성요소
- **DC 계층 (Data Component)**: DIPA461 - 데이터베이스 접근 조정을 위한 데이터 구성요소 컨트롤러
- **BC 계층 (Business Component)**: YCCOMMON, YCCSICOM, YCCBICOM - 트랜잭션 관리 및 통신을 위한 비즈니스 구성요소 프레임워크
- **SQLIO 계층 (SQL Input/Output)**: QIPA462, QIPA463, YCDBSQLA - SQL 실행 및 결과 처리를 위한 데이터베이스 접근 구성요소
- **프레임워크 계층**: XZUGOTMY - 출력 영역 할당 및 메모리 관리를 위한 프레임워크 구성요소
- **데이터베이스 계층**: 기업집단 관계 데이터 저장을 위한 THKIPA111 테이블이 있는 DB2 데이터베이스
- **통신 계층**: 모듈 간 통신 및 데이터 전송을 위한 프레임워크 구성요소

### 6.7 데이터 플로우 아키텍처
1. **입력 처리 플로우**: AIP4A55 → YNIP4A55 (입력 구조) → 매개변수 검증 → 처리구분 결정
2. **프레임워크 설정 플로우**: AIP4A55 → IJICOMM → XIJICOMM → YCCOMMON → 공통 영역 초기화
3. **데이터베이스 접근 플로우**: AIP4A55 → DIPA461 → QIPA462/QIPA463 → YCDBSQLA → THKIPA111 데이터베이스 쿼리
4. **서비스 통신 플로우**: AIP4A55 → XIJICOMM → YCCSICOM → YCCBICOM → 프레임워크 서비스
5. **출력 처리 플로우**: 데이터베이스 결과 → XQIPA462/XQIPA463 → XDIPA461 → YPIP4A55 (출력 구조) → AIP4A55
6. **오류 처리 플로우**: 모든 계층 → 프레임워크 오류 처리 → XZUGOTMY → 사용자 오류 메시지
7. **트랜잭션 플로우**: 요청 → 검증 → 데이터베이스 쿼리 → 결과 처리 → 응답 → 트랜잭션 완료
8. **메모리 관리 플로우**: XZUGOTMY → 출력 영역 할당 → 데이터 처리 → 메모리 정리 → 리소스 해제
