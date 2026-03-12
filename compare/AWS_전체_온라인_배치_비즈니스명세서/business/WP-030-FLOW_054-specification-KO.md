# 업무 명세서: 기업집단신용평가이력조회 (Corporate Group Credit Evaluation History Inquiry)

## 문서 관리
- **버전:** 1.0
- **일자:** 2024-09-22
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP_030
- **진입점:** AIP4A34
- **업무 도메인:** TRANSACTION
- **플로우 ID:** FLOW_054
- **플로우 유형:** Complete
- **우선순위 점수:** 73.00
- **복잡도:** 28

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 기업집단신용평가이력조회 시스템을 구현합니다. 이 시스템은 기업집단의 신용평가 이력에 대한 포괄적인 조회 기능을 제공하며, 사용자가 기업집단의 과거 신용평가 데이터를 검색하고 조회할 수 있도록 합니다. 시스템은 다양한 처리 유형을 지원하며 재무점수, 비재무점수, 결합점수, 등급 분류 등 상세한 평가 정보를 제공합니다.

주요 업무 목적은 신용위험관리 담당자가 기업집단의 과거 신용평가를 검토할 수 있도록 하여 의사결정 프로세스와 규제 준수 요구사항을 지원하는 것입니다.

## 2. 업무 엔티티

### BE-030-001: 기업집단조회요청 (Corporate Group Inquiry Request)
- **설명:** 기업집단 신용평가 이력 조회를 위한 입력 매개변수

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리구분코드 (Processing Type Code) | String | 2 | 필수, 이력조회는 '21' | 처리 유형 식별자 | YNIP4A34-PRCSS-DSTCD | prcssDstcd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | 필수 | 기업집단 식별자 | YNIP4A34-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단명 (Corporate Group Name) | String | 72 | 필수 | 기업집단명 | YNIP4A34-CORP-CLCT-NAME | corpClctName |
| 평가년월일 (Evaluation Date) | Date | 8 | 선택, YYYYMMDD 형식 | 평가일자 | YNIP4A34-VALUA-YMD | valuaYmd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | 선택 | 등록코드 | YNIP4A34-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 처리단계내용 (Processing Stage Content) | String | 22 | 선택 | 처리단계 설명 | YNIP4A34-PRCSS-STGE-CTNT | prcssStgeCtnt |

- **검증 규칙:**
  - 처리구분코드는 공백이 아니어야 함
  - 기업집단그룹코드는 공백이 아니어야 함
  - 기업집단명은 공백이 아니어야 함

### BE-030-002: 기업집단평가이력 (Corporate Group Evaluation History)
- **설명:** 기업집단의 과거 신용평가 데이터

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 총건수 (Total Count) | Numeric | 5 | 음수 불가 | 전체 레코드 수 | YPIP4A34-TOTAL-NOITM | totalNoitm |
| 현재건수 (Current Count) | Numeric | 5 | 음수 불가, ≤1000 | 현재 레코드 수 | YPIP4A34-PRSNT-NOITM | prsntNoitm |
| 작성년 (Writing Year) | String | 4 | YYYY 형식 | 평가 연도 | YPIP4A34-WRIT-YR | writYr |
| 확정여부 (Confirmation Status) | String | 2 | Y/N 값 | 평가 확정 상태 | YPIP4A34-DEFINS-YN | definsYn |
| 평가년월일 (Evaluation Date) | Date | 8 | YYYYMMDD 형식 | 평가일자 | YPIP4A34-VALUA-YMD | valuaYmd |
| 유효년월일 (Valid Date) | Date | 8 | YYYYMMDD 형식 | 유효기한일자 | YPIP4A34-VALD-YMD | valdYmd |
| 평가기준년월일 (Evaluation Base Date) | Date | 8 | YYYYMMDD 형식 | 평가기준일자 | YPIP4A34-VALUA-BASE-YMD | valuaBaseYmd |
| 평가부점명 (Evaluation Branch Name) | String | 52 | 선택 | 평가 부점명 | YPIP4A34-VALUA-BRN-NAME | valuaBrnName |
| 처리단계내용 (Processing Stage Content) | String | 22 | 선택 | 처리단계 설명 | YPIP4A34-PRCSS-STGE-CTNT | prcssStgeCtnt |
| 재무점수 (Financial Score) | Decimal | 7,2 | 부호 있는 숫자 | 재무평가 점수 | YPIP4A34-FNAF-SCOR | fnafScor |
| 비재무점수 (Non-Financial Score) | Decimal | 7,2 | 부호 있는 숫자 | 비재무평가 점수 | YPIP4A34-NON-FNAF-SCOR | nonFnafScor |
| 결합점수 (Combined Score) | Decimal | 9,5 | 부호 있는 숫자 | 결합평가 점수 | YPIP4A34-CHSN-SCOR | chsnScor |
| 신예비집단등급구분 (New Preliminary Group Grade Code) | String | 3 | 선택 | 예비등급 분류 | YPIP4A34-NEW-SC-GRD-DSTCD | newScGrdDstcd |
| 구분명1 (Classification Name 1) | String | 10 | 선택 | 등급조정 분류 | YPIP4A34-DSTIC-NAME1 | dsticName1 |
| 구분명2 (Classification Name 2) | String | 10 | 선택 | 조정단계 분류 | YPIP4A34-DSTIC-NAME2 | dsticName2 |
| 신최종집단등급구분 (New Final Group Grade Code) | String | 3 | 선택 | 최종등급 분류 | YPIP4A34-NEW-LC-GRD-DSTCD | newLcGrdDstcd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | 선택 | 등록코드 | YPIP4A34-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 주채무계열여부 (Main Debt Affiliate Status) | String | 4 | 선택 | 주채무계열 표시자 | YPIP4A34-MAIN-DEBT-AFFLT-YN | mainDebtAffltYn |
| 관리부점코드 (Management Branch Code) | String | 4 | 선택 | 관리부점 코드 | YPIP4A34-MGT-BRNCD | mgtBrncd |
| 관리부점명 (Management Branch Name) | String | 42 | 선택 | 관리부점명 | YPIP4A34-MGTBRN-NAME | mgtbrnName |
| 평가확정년월일 (Evaluation Confirmation Date) | Date | 8 | YYYYMMDD 형식 | 평가확정일자 | YPIP4A34-VALUA-DEFINS-YMD | valuaDefinsYmd |
| 평가직원명 (Evaluator Name) | String | 52 | 선택 | 평가담당자명 | YPIP4A34-VALUA-EMNM | valuaEmnm |

- **검증 규칙:**
  - 현재건수는 1000건을 초과할 수 없음
  - 모든 날짜 필드는 YYYYMMDD 형식이어야 함
  - 점수는 음수 값이 가능함
  - 확정여부는 처리단계에서 파생됨

### BE-030-003: 부점정보 (Branch Information)
- **설명:** 평가부점 및 관리부점 정보

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | 필수 | 그룹회사 식별자 | XQIPA542-O-GROUP-CO-CD | groupCoCd |
| 부점코드 (Branch Code) | String | 4 | 필수 | 부점 식별자 | XQIPA542-O-BRNCD | brncd |
| 적용시작년월일 (Application Start Date) | Date | 8 | YYYYMMDD 형식 | 적용시작일자 | XQIPA542-O-APLY-START-YMD | aplyStartYmd |
| 적용종료년월일 (Application End Date) | Date | 8 | YYYYMMDD 형식 | 적용종료일자 | XQIPA542-O-APLY-END-YMD | aplyEndYmd |
| 부점한글명 (Branch Korean Name) | String | 22 | 선택 | 부점 한글명 | XQIPA542-O-BRN-HANGL-NAME | brnHanglName |

- **검증 규칙:**
  - 적용시작년월일은 적용종료년월일보다 작거나 같아야 함
  - 부점코드는 유효하고 부점마스터에 존재해야 함

## 3. 업무 규칙

### BR-030-001: 처리구분코드 검증
- **설명:** 처리구분코드가 제공되고 비어있지 않음을 검증
- **조건:** 처리구분코드가 공백이거나 빈 값일 때 검증 오류 발생
- **관련 엔티티:** [BE-030-001]
- **예외:** 처리구분코드가 공백이면 오류 B3000070과 처리 UKIP0001 반환

### BR-030-002: 필수 필드 검증
- **설명:** 조회 요청의 필수 입력 필드 검증
- **조건:** 조회 요청이 제출될 때 기업집단그룹코드와 기업집단명은 공백이 아니어야 함
- **관련 엔티티:** [BE-030-001]
- **예외:** 필수 필드가 공백이면 오류 B3800004와 적절한 처리코드 반환

### BR-030-003: 레코드 수 제한
- **설명:** 단일 조회에서 반환되는 레코드 수 제한
- **조건:** 조회 결과가 1000건을 초과할 때 처음 1000건만 반환
- **관련 엔티티:** [BE-030-002]
- **예외:** 예외 없음 - 시스템이 자동으로 최대 1000건으로 제한

### BR-030-004: 확정상태 결정
- **설명:** 처리단계에 기반한 평가 확정상태 결정
- **조건:** 처리단계코드가 '6'이 아닐 때 확정상태는 'N', 그렇지 않으면 확정상태는 'Y'
- **관련 엔티티:** [BE-030-002]
- **예외:** 예외 없음 - 상태는 자동으로 계산됨

### BR-030-005: 주채무계열여부 로직
- **설명:** 확정여부와 그룹관리유형에 기반한 주채무계열여부 결정
- **조건:** 평가가 확정되지 않고 그룹관리유형이 '01'일 때 상태는 '여', 그렇지 않고 평가가 확정되고 주채무계열플래그가 '1'일 때 상태는 '여', 그렇지 않으면 상태는 '부'
- **관련 엔티티:** [BE-030-002]
- **예외:** 예외 없음 - 상태는 업무로직에 기반하여 자동으로 계산됨

### BR-030-006: 신용점수 계산 로직
- **설명:** 평가기준과 재무지표에 기반한 신용점수 계산
- **조건:** 평가데이터가 사용 가능할 때 가중요소를 사용하여 종합점수 계산
- **관련 엔티티:** [BE-030-002]
- **예외:** 계산데이터가 불완전하면 기본 점수산정 방법론 사용

### BR-030-007: 등급분류 로직
- **설명:** 계산된 점수와 업무기준에 기반한 신용등급 분류
- **조건:** 신용점수가 계산될 때 적절한 등급분류 할당
- **관련 엔티티:** [BE-030-002]
- **예외:** 점수가 정상범위를 벗어나면 예외적 등급할당 규칙 적용

### BR-030-006: 날짜 범위 검증
- **설명:** 부점정보 조회를 위한 날짜 범위 검증
- **조건:** 부점정보를 조회할 때 평가일자는 부점 적용일자 범위 내에 있어야 함
- **관련 엔티티:** [BE-030-003]
- **예외:** 유효한 부점 레코드를 찾을 수 없으면 부점명은 공백으로 유지

### BR-030-007: 인스턴스코드 해석
- **설명:** 표시를 위해 인스턴스코드를 설명적 이름으로 해석
- **조건:** 인스턴스코드가 존재할 때 인스턴스마스터에서 해당 설명적 이름 조회
- **관련 엔티티:** [BE-030-002]
- **예외:** 특정 오류(B3600011/UKJI0962)로 인스턴스코드 조회가 실패하면 오류 없이 처리 계속

## 4. 업무 기능

### F-030-001: 기업집단신용평가이력조회
- **설명:** 검색 조건에 기반하여 기업집단 신용평가 이력을 조회하는 주요 기능

- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 처리구분코드 (Processing Type Code) | String | 2 | 필수, '21'이어야 함 | 처리유형 식별자 |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | 필수 | 기업집단 식별자 |
| 기업집단명 (Corporate Group Name) | String | 72 | 필수 | 기업집단명 |
| 평가년월일 (Evaluation Date) | Date | 8 | 선택 | 특정 평가일자 |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | 선택 | 등록코드 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 총건수 (Total Count) | Numeric | 5 | 음수 불가 | 일치하는 레코드의 총 수 |
| 현재건수 (Current Count) | Numeric | 5 | ≤1000 | 반환된 레코드 수 |
| 평가이력그리드 (Evaluation History Grid) | Array | 1000 | 최대 1000건 | 평가이력 레코드 배열 |

- **처리 로직:**
  1. 업무규칙 BR-030-001과 BR-030-002에 따라 입력 매개변수 검증
  2. 데이터베이스 접근 모듈 QIPA341을 호출하여 평가이력 조회
  3. 반환된 각 레코드에 대해 BR-030-004를 사용하여 확정상태 결정
  4. F-030-003을 사용하여 평가부점 및 관리부점명 조회
  5. F-030-004를 사용하여 인스턴스코드를 설명적 이름으로 해석
  6. BR-030-003에 따라 레코드 수 제한 적용
  7. 모든 보강된 데이터와 함께 형식화된 결과 집합 반환

- **적용된 업무규칙:** [BR-030-001, BR-030-002, BR-030-003, BR-030-004, BR-030-005]

### F-030-002: 평가확정상태확인
- **설명:** 신용평가의 확정상태를 결정

- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 그룹회사코드 (Group Company Code) | String | 3 | 필수 | 그룹회사 식별자 |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | 필수 | 기업집단 식별자 |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | 필수 | 등록코드 |
| 평가년월일 (Evaluation Date) | Date | 8 | 필수 | 평가일자 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 확정여부 (Confirmation Status) | String | 2 | Y/N 값 | 평가 확정상태 |

- **처리 로직:**
  1. 입력 매개변수로 데이터베이스 접근 모듈 QIPA342 호출
  2. 업무규칙 BR-030-004를 적용하여 확정상태 결정
  3. 확정상태 표시자 반환

- **적용된 업무규칙:** [BR-030-004]

### F-030-003: 부점명조회
- **설명:** 부점코드와 날짜 범위에 기반하여 부점 한글명 조회

- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 그룹회사코드 (Group Company Code) | String | 3 | 필수 | 그룹회사 식별자 |
| 부점코드 (Branch Code) | String | 4 | 필수 | 부점 식별자 |
| 기준일자 (Reference Date) | Date | 8 | 필수 | 유효성 확인을 위한 날짜 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 부점한글명 (Branch Korean Name) | String | 22 | 선택 | 부점 한글명 |

- **처리 로직:**
  1. 부점코드와 날짜 범위로 데이터베이스 접근 모듈 QIPA542 호출
  2. 날짜 범위 검증을 위해 업무규칙 BR-030-006 적용
  3. 찾으면 부점 한글명 반환, 찾지 못하면 공백 반환

- **적용된 업무규칙:** [BR-030-006]

### F-030-004: 인스턴스코드해석
- **설명:** 표시 목적으로 인스턴스코드를 설명적 이름으로 해석

- **입력:**

| 입력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 인스턴스식별자 (Instance Identifier) | String | 9 | 필수 | 인스턴스 유형 식별자 |
| 인스턴스코드 (Instance Code) | String | 가변 | 필수 | 해석할 코드 |
| 그룹회사코드 (Group Company Code) | String | 3 | 필수 | 그룹회사 식별자 |

- **출력:**

| 출력 | 데이터 타입 | 길이 | 제약조건 | 설명 |
|------|-------------|------|----------|------|
| 인스턴스내용 (Instance Content) | String | 가변 | 선택 | 코드에 대한 설명적 이름 |

- **처리 로직:**
  1. 인스턴스 식별자와 코드로 업무컴포넌트 CJIUI01 호출
  2. 오류 처리를 위해 업무규칙 BR-030-007 적용
  3. 찾으면 설명적 내용 반환, 찾지 못하거나 특정 오류 시 공백 반환

- **적용된 업무규칙:** [BR-030-007]

## 5. 프로세스 흐름

```
기업집단신용평가이력조회 프로세스 흐름

1. 사용자 입력 검증
   ├── 처리구분코드 검증 (BR-030-001)
   ├── 기업집단그룹코드 검증 (BR-030-002)
   └── 기업집단명 검증 (BR-030-002)

2. 주요 이력조회 (F-030-001)
   ├── 데이터베이스 쿼리 실행 (QIPA341)
   ├── 레코드 제한 적용 (BR-030-003)
   └── 각 레코드 처리:
       ├── 확정상태 결정 (F-030-002, BR-030-004)
       ├── 주채무계열여부 계산 (BR-030-005)
       ├── 평가부점명 조회 (F-030-003)
       ├── 관리부점명 조회 (F-030-003)
       ├── 처리단계설명 해석 (F-030-004)
       ├── 등급조정설명 해석 (F-030-004)
       └── 조정단계설명 해석 (F-030-004)

3. 결과 조립
   ├── 총건수 설정
   ├── 현재건수 설정 (1000건으로 제한)
   └── 형식화된 그리드 데이터 반환

4. 오류 처리
   ├── 입력 검증 오류 → 오류코드 반환
   ├── 데이터베이스 오류 → 시스템 오류 반환
   └── 인스턴스 해석 오류 → 처리 계속
```

## 6. 레거시 구현 참조

### 소스 파일
- **AIP4A34.cbl**: 기업집단신용평가이력조회를 위한 주요 AS(Application Service) 프로그램
- **DIPA341.cbl**: 업무로직 처리 및 데이터 오케스트레이션을 위한 DC(Data Component) 프로그램
- **QIPA341.cbl**: 기업집단평가이력 데이터베이스 접근을 위한 SQLIO 프로그램
- **QIPA342.cbl**: 평가확정상태 조회를 위한 SQLIO 프로그램
- **QIPA542.cbl**: 부점정보 조회를 위한 SQLIO 프로그램
- **YNIP4A34.cpy**: 조회요청 구조를 정의하는 입력 카피북
- **YPIP4A34.cpy**: 조회응답 구조를 정의하는 출력 카피북
- **XDIPA341.cpy**: 데이터컴포넌트 통신을 위한 DC 인터페이스 카피북
- **XQIPA341.cpy**: 평가이력 쿼리를 위한 데이터베이스 인터페이스 카피북
- **XQIPA342.cpy**: 확정상태 쿼리를 위한 데이터베이스 인터페이스 카피북
- **XQIPA542.cpy**: 부점정보 쿼리를 위한 데이터베이스 인터페이스 카피북

### 업무규칙 구현

- **BR-030-001:** AIP4A34.cbl 150-152행에 구현
  ```cobol
  IF YNIP4A34-PRCSS-DSTCD = SPACE
     #ERROR CO-B3000070 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  ```

- **BR-030-002:** AIP4A34.cbl 155-162행과 DIPA341.cbl 120-131행에 구현
  ```cobol
  IF YNIP4A34-CORP-CLCT-GROUP-CD = SPACE
     #ERROR CO-B3800004 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  
  IF YNIP4A34-CORP-CLCT-NAME = SPACE
     #ERROR CO-B3800004 CO-UKIP0006 CO-STAT-ERROR
  END-IF.
  ```

- **BR-030-003:** DIPA341.cbl 175-181행에 구현
  ```cobol
  IF  DBSQL-SELECT-CNT  >  CO-MAX-1000  THEN
      MOVE  CO-MAX-1000
        TO  XDIPA341-O-PRSNT-NOITM
  ELSE
      MOVE  DBSQL-SELECT-CNT
        TO  XDIPA341-O-PRSNT-NOITM
  END-IF
  ```

- **BR-030-004:** QIPA342.cbl 150-155행에 구현
  ```cobol
  SELECT CASE WHEN 기업집단처리단계구분 <> '6'
              THEN 'N'
         ELSE 'Y'
         END AS 확정여부
  ```

- **BR-030-005:** QIPA341.cbl 150-162행에 구현
  ```cobol
  CASE
  WHEN B110.평가확정년월일 = ''
  THEN CASE
       WHEN A111.기업군관리그룹구분 = '01'
       THEN '여'
       ELSE '부'
       END
  ELSE
       CASE WHEN B110.주채무계열여부 = '1'
       THEN '여'
       ELSE '부'
       END
  END 주채무계열여부
  ```

### 기능 구현

- **F-030-001:** DIPA341.cbl 140-320행에 구현
  ```cobol
  S3100-PSHIST-SEL-RTN.
  *@   SQLIO영역 초기화
      INITIALIZE       XQIPA341-IN
                       XQIPA341-OUT
                       YCDBSQLA-CA
  *@   SQLIO 호출
      #DYSQLA QIPA341 SELECT XQIPA341-CA
  ```

- **F-030-002:** DIPA341.cbl 322-350행에 구현
  ```cobol
  S3110-QIPA342-CALL-RTN.
  *@   SQLIO 호출
      #DYSQLA QIPA342 SELECT XQIPA342-CA
  *@   오류처리
      IF NOT COND-DBSQL-OK OR COND-DBSQL-MRNF
          #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
      END-IF
  ```

- **F-030-003:** DIPA341.cbl 410-440행에 구현
  ```cobol
  S3130-BRN-NAME-SEL-RTN.
  *@1  SQLIO 호출
      #DYSQLA QIPA542 XQIPA542-CA.
  *#1  SQLIO 호출결과 오류체크
      IF NOT COND-DBSQL-OK   AND
         NOT COND-DBSQL-MRNF THEN
         #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
      END-IF
  ```

- **F-030-004:** DIPA341.cbl 352-380행에 구현
  ```cobol
  S3120-INSTNC-CD-SEL-RTN.
  *@  처리내용:BC전행 인스턴스코드조회 프로그램 호출
      #DYCALL CJIUI01
              YCCOMMON-CA
              XCJIUI01-CA
  *#  호출결과 확인
      IF NOT COND-XCJIUI01-OK                  AND
         NOT (XCJIUI01-R-ERRCD    = 'B3600011' AND
              XCJIUI01-R-TREAT-CD = 'UKJI0962')
         #ERROR XCJIUI01-R-ERRCD
                XCJIUI01-R-TREAT-CD
                XCJIUI01-R-STAT
      END-IF
  ```

### 데이터베이스 테이블
- **THKIPB110**: 기업집단평가기본 - 기업집단 신용평가 데이터의 주요 테이블
- **THKIPA111**: 기업관계연결정보 - 기업관계 및 그룹관리 정보 테이블
- (공통) **THKJIBR01**: 부점기본 - 부점정보 마스터 테이블

### 오류코드
- **오류 집합 B3800004**:
  - **에러코드**: B3800004 - "필수항목 오류입니다."
  - **조치메시지**: UKIP0001 - "필수입력항목을 확인해 주세요."
  - **사용**: 필수 필드 누락에 대한 입력 검증 오류

- **오류 집합 B3900002**:
  - **에러코드**: B3900002 - "DB에러(SQLIO 에러)"
  - **조치메시지**: UKII0182 - "전산부 업무담당자에게 연락해주시기 바랍니다."
  - **사용**: SQLIO 작업에서 데이터베이스 접근 오류

- **오류 집합 B3000070**:
  - **에러코드**: B3000070 - "처리구분코드 오류입니다."
  - **조치메시지**: UKIP0001 - "필수입력항목을 확인해 주세요."
  - **사용**: 처리구분코드 검증 오류

- **오류 집합 CO-UKIP0006**:
  - **조치메시지**: UKIP0006 - "기업집단명 입력 후 다시 거래하세요."
  - **사용**: 기업집단명 검증 오류

- **오류 집합 CO-UKIP0003**:
  - **조치메시지**: UKIP0003 - "평가일자 입력 후 다시 거래하세요."
  - **사용**: 평가일자 검증 오류

- **오류 집합 CO-UKIP0002**:
  - **조치메시지**: UKIP0002 - "기업집단등록코드 입력 후 다시 거래하세요."
  - **사용**: 기업집단등록코드 검증 오류

- **오류 집합 DIPA341**:
  - **에러코드**: B3800004 - "필수항목 오류입니다."
  - **조치메시지**: UKIF0072 - "필수입력항목을 확인해 주세요."
  - **에러코드**: B3900009 - "데이터를 검색할 수 없습니다."
  - **조치메시지**: UKII0182 - "전산부 업무담당자에게 연락해주시기 바랍니다."
  - **사용**: DIPA341.cbl의 업무로직 검증 및 데이터베이스 접근 오류 처리

### 기술 아키텍처
- **AS 계층**: AIP4A34 - 사용자 인터페이스 및 입력 검증을 처리하는 Application Server 컴포넌트
- **DC 계층**: DIPA341 - 업무로직 오케스트레이션 및 데이터 처리를 담당하는 Data Component
- **SQLIO 계층**: QIPA341, QIPA342, QIPA542 - SQL 작업을 위한 데이터베이스 접근 컴포넌트
- **BC 계층**: CJIUI01 - 인스턴스코드 해석을 위한 Business Component
- **프레임워크**: 매크로 지원이 있는 KB Banking Framework (#DYCALL, #DYSQLA, #ERROR, #GETOUT, #OKEXIT, #BOFMID)

### 데이터 흐름 아키텍처
1. **입력 흐름**: 사용자 요청 → AIP4A34 → DIPA341 → 데이터베이스 컴포넌트
2. **데이터베이스 접근**: DIPA341 → QIPA341 (이력) → QIPA342 (확정) → QIPA542 (부점)
3. **서비스 호출**: DIPA341 → CJIUI01 (인스턴스 해석) → 인스턴스 마스터 데이터
4. **출력 흐름**: 데이터베이스 결과 → DIPA341 → AIP4A34 → 사용자 응답
5. **오류 처리**: 모든 계층 → 프레임워크 오류 처리 → 표준화된 오류 메시지
