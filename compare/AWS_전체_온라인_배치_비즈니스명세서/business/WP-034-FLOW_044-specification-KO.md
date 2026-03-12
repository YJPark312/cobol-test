# 업무 명세서: 기업집단신용등급조정검토등록 (Corporate Group Credit Rating Adjustment Review Registration)

## 문서 관리
- **버전:** 1.0
- **일자:** 2025-09-26
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-034
- **진입점:** AIPBA81
- **업무 도메인:** CREDIT

## 목차
1. 개요
2. 업무 엔티티
3. 업무 규칙
4. 업무 기능
5. 프로세스 흐름
6. 레거시 구현 참조

## 1. 개요

본 워크패키지는 신용 처리 도메인에서 포괄적인 온라인 기업집단 신용등급 조정 검토 등록 시스템을 구현합니다. 이 시스템은 기업집단 평가를 위한 실시간 신용등급 조정 기능을 제공하며, 기업집단 신용 평가 및 규제 준수를 위한 신용 위험 관리 및 등급 검토 운영을 지원합니다.

업무 목적은 다음과 같습니다:
- 필수 파라미터 검증을 통한 포괄적 기업집단 신용등급 조정 검토 제공 (Provide comprehensive corporate group credit rating adjustment review with mandatory parameter validation)
- 기업집단 평가의 등급 조정 사유 및 분류 코드의 실시간 등록 지원 (Support real-time registration of rating adjustment reasons and classification codes for corporate group evaluations)
- 처리 단계 제어를 통한 기업집단 평가 기본 정보 관리 지원 (Enable corporate group evaluation basic information management with processing stage control)
- 분류 기반 삭제 운영을 통한 기업집단 주석 명세 데이터 무결성 유지 (Maintain corporate group comment specification data integrity with classification-based deletion operations)
- 기업집단 신용등급 조정 운영의 감사추적 및 거래 추적 제공 (Provide audit trail and transaction tracking for corporate group credit rating adjustment operations)
- 구조화된 신용등급 조정 문서화 및 승인 프로세스를 통한 규제 준수 지원 (Support regulatory compliance through structured credit rating adjustment documentation and approval processes)

시스템은 포괄적인 다중 모듈 온라인 흐름을 통해 데이터를 처리합니다: AIPBA81 → IJICOMM → YCCOMMON → XIJICOMM → DIPA811 → RIPA110 → YCDBIOCA → YCCSICOM → YCCBICOM → RIPA130 → TRIPB118 → TKIPB118 → TRIPB110 → TKIPB110 → TRIPB130 → TKIPB130 → YCDBSQLA → XDIPA811 → XZUGOTMY → YNIPBA81 → YPIPBA81, 기업집단 파라미터 검증, 등급 조정 사유 등록, 평가 기본 정보 업데이트, 및 주석 관리 운영을 처리합니다.

주요 업무 기능은 다음을 포함합니다:
- 필수 필드 검증을 포함한 기업집단 신용등급 조정 파라미터 검증 (Corporate group credit rating adjustment parameter validation with mandatory field verification)
- 분류 코드 관리 및 내용 저장을 포함한 등급 조정 사유 등록 (Rating adjustment reason registration with classification code management and content storage)
- 처리 단계 제어 및 조정 분류를 포함한 기업집단 평가 기본 정보 업데이트 (Corporate group evaluation basic information updates with processing stage control and adjustment classification)
- 데이터 일관성을 위한 분류 기반 삭제 운영을 통한 주석 명세 관리 (Comment specification management through classification-based deletion operations for data consistency)
- 구조화된 거래 제어 및 오류 처리를 통한 데이터베이스 무결성 관리 (Database integrity management through structured transaction control and error handling)
- 신용등급 조정 워크플로 준수를 위한 처리 결과 추적 및 상태 관리 (Processing result tracking and status management for credit rating adjustment workflow compliance)

## 2. 업무 엔티티

### BE-034-001: 기업집단신용등급조정요청 (Corporate Group Credit Rating Adjustment Request)
- **설명:** 기업집단 신용등급 조정 검토 등록 운영을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | YNIPBA81-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | YNIPBA81-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | YNIPBA81-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 신용등급 평가를 위한 평가일자 | YNIPBA81-VALUA-YMD | valuaYmd |
| 등급조정구분코드 (Rating Adjustment Classification Code) | String | 1 | NOT NULL | 등급 조정 유형 분류 | YNIPBA81-GRD-ADJS-DSTCD | grdAdjsDstcd |
| 등급조정사유내용 (Rating Adjustment Reason Content) | String | 502 | 선택사항 | 등급 조정에 대한 상세 사유 | YNIPBA81-GRD-ADJS-RESN-CTNT | grdAdjsResnCtnt |
| 처리구분 (Processing Classification) | String | 2 | 선택사항 | 처리 유형 분류 코드 | YNIPBA81-PRCSS-DSTIC | prcssdstic |

- **검증 규칙:**
  - 그룹회사코드는 필수이며 공백일 수 없음
  - 기업집단그룹코드는 필수이며 공백일 수 없음
  - 기업집단등록코드는 필수이며 공백일 수 없음
  - 평가년월일은 필수이며 유효한 YYYYMMDD 형식이어야 함
  - 등급조정구분코드는 조정 운영에 필수임
  - 등급조정사유내용은 등급 변경에 대한 상세한 정당화를 제공함
  - 처리구분은 수행할 조정 운영의 유형을 결정함

### BE-034-002: 기업집단등급조정사유 (Corporate Group Rating Adjustment Reason)
- **설명:** 기업집단 평가 시스템에 저장된 등급 조정 사유 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB118-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB118-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB118-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 등급 조정을 위한 평가일자 | RIPB118-VALUA-YMD | valuaYmd |
| 등급조정구분 (Rating Adjustment Classification) | String | 1 | NOT NULL | 등급 조정 유형 분류 | RIPB118-GRD-ADJS-DSTCD | grdAdjsDstcd |
| 등급조정사유내용 (Rating Adjustment Reason Content) | String | 502 | 선택사항 | 조정에 대한 상세 사유 내용 | RIPB118-GRD-ADJS-RESN-CTNT | grdAdjsResnCtnt |
| 시스템최종처리일시 (System Last Processing DateTime) | String | 20 | 시스템 생성 | 최종 처리를 위한 시스템 타임스탬프 | RIPB118-SYS-LAST-PRCSS-YMS | sysLastPrcssYms |
| 시스템최종사용자번호 (System Last User Number) | String | 7 | 시스템 생성 | 최종 업데이트를 위한 시스템 사용자 식별자 | RIPB118-SYS-LAST-UNO | sysLastUno |

- **검증 규칙:**
  - 모든 기본키 필드는 고유 식별을 위해 필수임
  - 등급조정구분은 시스템 표준에 따라 유효해야 함
  - 등급조정사유내용은 등급 변경에 대한 업무 정당화를 제공함
  - 시스템 필드는 데이터베이스 운영 중 자동으로 채워짐
  - 평가년월일은 기업집단 평가 기간과 일치해야 함
  - 등급 조정 레코드는 시스템 타임스탬프 필드를 통해 감사 추적을 유지함

### BE-034-003: 기업집단평가기본정보 (Corporate Group Evaluation Basic Information)
- **설명:** 등급 조정 상태를 포함한 기업집단의 기본 평가 정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB110-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB110-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB110-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 기업집단을 위한 평가일자 | RIPB110-VALUA-YMD | valuaYmd |
| 기업집단처리단계구분 (Corporate Group Processing Stage Classification) | String | 1 | NOT NULL | 처리 단계 상태 코드 | RIPB110-CORP-CP-STGE-DSTCD | corpCpStgeDstcd |
| 등급조정구분 (Rating Adjustment Classification) | String | 1 | 선택사항 | 등급 조정 유형 분류 | RIPB110-GRD-ADJS-DSTCD | grdAdjsDstcd |
| 기업집단명 (Corporate Group Name) | String | 72 | 선택사항 | 기업집단명 | RIPB110-CORP-CLCT-NAME | corpClctName |
| 최종집단등급구분 (Final Group Rating Classification) | String | 3 | 선택사항 | 최종 등급 분류 코드 | RIPB110-LAST-CLCT-GRD-DSTCD | lastClctGrdDstcd |

- **검증 규칙:**
  - 기본키 필드는 고유 레코드 식별을 위해 제공되어야 함
  - 기업집단처리단계구분은 조정 등록 중 '4' (저장)로 설정됨
  - 등급조정구분은 조정 요청 파라미터를 기반으로 업데이트됨
  - 기업집단명은 평가 레코드에 대한 업무 컨텍스트를 제공함
  - 최종집단등급구분은 현재 등급 상태를 반영함
  - 처리 단계는 기업집단 평가의 워크플로 상태를 제어함

### BE-034-004: 기업집단주석명세 (Corporate Group Comment Specification)
- **설명:** 분류 관리를 포함한 기업집단 평가를 위한 주석 명세 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 그룹회사코드 (Group Company Code) | String | 3 | NOT NULL | 그룹회사 분류 식별자 | RIPB130-GROUP-CO-CD | groupCoCd |
| 기업집단그룹코드 (Corporate Group Code) | String | 3 | NOT NULL | 기업집단 분류 식별자 | RIPB130-CORP-CLCT-GROUP-CD | corpClctGroupCd |
| 기업집단등록코드 (Corporate Group Registration Code) | String | 3 | NOT NULL | 기업집단 등록 식별자 | RIPB130-CORP-CLCT-REGI-CD | corpClctRegiCd |
| 평가년월일 (Evaluation Date) | String | 8 | YYYYMMDD 형식 | 주석 연관을 위한 평가일자 | RIPB130-VALUA-YMD | valuaYmd |
| 기업집단주석구분 (Corporate Group Comment Classification) | String | 2 | NOT NULL | 주석 분류 식별자 | RIPB130-CORP-C-COMT-DSTCD | corpCComtDstcd |
| 일련번호 (Serial Number) | Numeric | 4 | NOT NULL | 주석 순서를 위한 순차 번호 | RIPB130-SERNO | serno |
| 주석내용 (Comment Content) | String | 4002 | 선택사항 | 평가를 위한 주석 내용 | RIPB130-COMT-CTNT | comtCtnt |

- **검증 규칙:**
  - 모든 기본키 필드는 고유 주석 식별을 위해 필수임
  - 기업집단주석구분 '27'은 등급 조정을 위해 특별히 관리됨
  - 일련번호는 여러 주석에 대한 순서 시퀀스를 제공함
  - 주석내용은 상세한 평가 노트 및 관찰을 저장함
  - 주석 분류는 저장된 주석의 유형과 목적을 결정함
  - 주석은 데이터 일관성을 유지하기 위해 등급 조정 등록 중 삭제됨

### BE-034-005: 기업집단신용등급조정응답 (Corporate Group Credit Rating Adjustment Response)
- **설명:** 기업집단 신용등급 조정 운영을 위한 출력 응답 데이터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 레거시 변수 | 제안 변수 |
|------|-------------|------|----------|------|-------------|-----------|
| 처리결과구분코드 (Processing Result Classification Code) | String | 2 | NOT NULL | 처리 결과 상태 코드 | YPIPBA81-PRCSS-RSULT-DSTCD | prcssRsultDstcd |

- **검증 규칙:**
  - 처리결과구분코드는 조정 운영의 성공 또는 실패를 나타냄
  - 결과 코드는 데이터베이스 운영의 실제 결과를 반영해야 함
  - 응답은 등급 조정 등록 완료의 확인을 제공함
  - 결과 분류는 적절한 오류 처리 및 사용자 알림을 가능하게 함

## 3. 업무 규칙

### BR-034-001: 기업집단파라미터검증 (Corporate Group Parameter Validation)
- **설명:** 기업집단 신용등급 조정 파라미터에 대한 필수 검증 규칙
- **조건:** 기업집단 신용등급 조정이 요청될 때 모든 필수 파라미터가 검증되어야 함
- **관련 엔티티:** BE-034-001
- **예외:** 필수 파라미터가 누락되거나 유효하지 않은 경우 시스템 오류

### BR-034-002: 등급조정분류검증 (Rating Adjustment Classification Validation)
- **설명:** 등급 조정 분류 코드 및 업무 로직에 대한 검증 규칙
- **조건:** 등급 조정 분류가 제공될 때 분류 코드는 유효하고 업무 규칙과 일치해야 함
- **관련 엔티티:** BE-034-001, BE-034-002
- **예외:** 유효하지 않은 등급 조정 분류가 제공된 경우 분류 오류

### BR-034-003: 기업집단평가일자일관성 (Corporate Group Evaluation Date Consistency)
- **설명:** 기업집단 등급 조정 운영 전반에 걸친 평가일자의 일관성 규칙
- **조건:** 평가일자가 지정될 때 모든 관련 기업집단 레코드에서 일관되어야 함
- **관련 엔티티:** BE-034-001, BE-034-002, BE-034-003, BE-034-004
- **예외:** 관련 레코드 간 평가일자가 일관되지 않은 경우 일자 일관성 오류

### BR-034-004: 등급조정사유등록제어 (Rating Adjustment Reason Registration Control)
- **설명:** 등급 조정 사유 등록 및 데이터 무결성에 대한 제어 규칙
- **조건:** 등급 조정 사유가 등록될 때 새로운 등록 전에 기존 레코드가 삭제되어야 함
- **관련 엔티티:** BE-034-002
- **예외:** 등급 조정 사유 등록이 실패한 경우 데이터 무결성 오류

### BR-034-005: 기업집단처리단계관리 (Corporate Group Processing Stage Management)
- **설명:** 등급 조정 운영 중 기업집단 처리 단계에 대한 관리 규칙
- **조건:** 등급 조정이 등록될 때 워크플로 제어를 위해 처리 단계가 '4' (저장)로 설정되어야 함
- **관련 엔티티:** BE-034-003
- **예외:** 단계 분류를 업데이트할 수 없는 경우 처리 단계 오류

### BR-034-006: 주석분류삭제제어 (Comment Classification Deletion Control)
- **설명:** 등급 조정 운영 중 주석 분류 삭제에 대한 제어 규칙
- **조건:** 등급 조정이 처리될 때 데이터 일관성을 위해 분류 '27'의 주석이 삭제되어야 함
- **관련 엔티티:** BE-034-004
- **예외:** 분류 기반 삭제가 실패한 경우 주석 삭제 오류

### BR-034-007: 데이터베이스거래무결성 (Database Transaction Integrity)
- **설명:** 기업집단 신용등급 조정 데이터베이스 운영에 대한 거래 무결성 규칙
- **조건:** 데이터베이스 운영이 수행될 때 모든 테이블 업데이트에서 거래 무결성이 유지되어야 함
- **관련 엔티티:** BE-034-002, BE-034-003, BE-034-004
- **예외:** 데이터베이스 운영이 실패한 경우 거래 롤백

### BR-034-008: 신용등급조정감사추적 (Credit Rating Adjustment Audit Trail)
- **설명:** 기업집단 신용등급 조정 운영에 대한 감사 추적 규칙
- **조건:** 등급 조정 운영이 완료될 때 시스템은 타임스탬프 및 사용자 식별과 함께 감사 추적을 유지해야 함
- **관련 엔티티:** BE-034-002
- **예외:** 시스템 추적 정보를 기록할 수 없는 경우 감사 추적 오류

### BR-034-009: 처리결과상태검증 (Processing Result Status Validation)
- **설명:** 처리 결과 상태 및 응답 생성에 대한 검증 규칙
- **조건:** 등급 조정 운영이 완료될 때 처리 결과 상태는 실제 운영 결과를 반영해야 함
- **관련 엔티티:** BE-034-005
- **예외:** 처리 결과가 실제 운영 결과와 일치하지 않는 경우 상태 검증 오류

### BR-034-010: 기업집단식별일관성 (Corporate Group Identification Consistency)
- **설명:** 모든 등급 조정 운영에서 기업집단 식별에 대한 일관성 규칙
- **조건:** 기업집단 운영이 수행될 때 그룹 식별은 모든 관련 레코드 및 운영에서 일관되어야 함
- **관련 엔티티:** BE-034-001, BE-034-002, BE-034-003, BE-034-004
- **예외:** 운영 간 그룹 식별이 일관되지 않은 경우 식별 일관성 오류

## 4. 업무 기능

### F-034-001: 기업집단신용등급조정파라미터검증 (Corporate Group Credit Rating Adjustment Parameter Validation)
- **설명:** 기업집단 신용등급 조정 검토 등록 운영을 위한 입력 파라미터 검증

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사 분류 식별자 |
| corpClctGroupCd | String | 기업집단 분류 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| valuaYmd | String | YYYYMMDD 형식의 평가일자 |
| grdAdjsDstcd | String | 등급 조정 분류 코드 |

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
5. 등급조정구분코드가 제공되었는지 검증
6. 적절한 상태 및 오류 메시지와 함께 검증 결과 반환

### F-034-002: 기업집단등급조정사유등록 (Corporate Group Rating Adjustment Reason Registration)
- **설명:** 기업집단 평가를 위한 등급 조정 사유 정보 등록

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사 분류 식별자 |
| corpClctGroupCd | String | 기업집단 분류 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| valuaYmd | String | 등급 조정을 위한 평가일자 |
| grdAdjsDstcd | String | 등급 조정 분류 코드 |
| grdAdjsResnCtnt | String | 등급 조정 사유 내용 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| registrationStatus | String | 등록 운영 결과 상태 |
| recordCount | Numeric | 처리된 레코드 수 |

**처리 로직:**
1. 기본키 파라미터를 사용하여 기존 등급 조정 사유 레코드 조회
2. 데이터 무결성을 유지하기 위해 발견된 기존 레코드 삭제
3. 입력 파라미터로 새로운 등급 조정 사유 레코드 준비
4. THKIPB118 테이블에 새로운 등급 조정 사유 레코드 삽입
5. 시스템 타임스탬프 및 사용자 식별 필드 업데이트
6. 등록 상태 및 처리된 레코드 수 반환

### F-034-003: 기업집단평가기본정보업데이트 (Corporate Group Evaluation Basic Information Update)
- **설명:** 등급 조정 분류로 기업집단 평가 기본 정보 업데이트

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사 분류 식별자 |
| corpClctGroupCd | String | 기업집단 분류 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| valuaYmd | String | 기업집단을 위한 평가일자 |
| grdAdjsDstcd | String | 등급 조정 분류 코드 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| updateStatus | String | 업데이트 운영 결과 상태 |
| processingStage | String | 업데이트된 처리 단계 분류 |

**처리 로직:**
1. 기본키를 사용하여 기존 기업집단 평가 기본 레코드 조회
2. 업데이트 운영을 위한 레코드 존재 및 접근성 검증
3. 입력 파라미터로 등급 조정 분류 업데이트
4. 기업집단 처리 단계 분류를 '4' (저장)로 설정
5. 수정된 정보로 THKIPB110 테이블의 레코드 업데이트
6. 업데이트 상태 및 현재 처리 단계 분류 반환

### F-034-004: 기업집단주석명세관리 (Corporate Group Comment Specification Management)
- **설명:** 분류 기반 삭제로 기업집단 주석 명세 관리

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| groupCoCd | String | 그룹회사 분류 식별자 |
| corpClctGroupCd | String | 기업집단 분류 식별자 |
| corpClctRegiCd | String | 기업집단 등록 식별자 |
| valuaYmd | String | 주석 연관을 위한 평가일자 |
| corpCComtDstcd | String | 기업집단 주석 분류 |
| serno | Numeric | 주석 식별을 위한 일련번호 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| deletionStatus | String | 주석 삭제 운영 상태 |
| deletedRecordCount | Numeric | 삭제된 주석 레코드 수 |

**처리 로직:**
1. 기본키 파라미터를 사용하여 기존 주석 명세 레코드 조회
2. 등급 조정 주석을 위한 주석 분류 '27'로 레코드 필터링
3. 데이터 일관성을 유지하기 위해 발견된 기존 주석 레코드 삭제
4. 삭제 운영 성공 및 레코드 수 검증
5. 주석 관리 운영을 위한 시스템 감사 추적 업데이트
6. 삭제 상태 및 삭제된 레코드 수 반환

### F-034-005: 기업집단신용등급조정응답생성 (Corporate Group Credit Rating Adjustment Response Generation)
- **설명:** 기업집단 신용등급 조정 운영을 위한 응답 데이터 생성

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| reasonRegistrationStatus | String | 등급 조정 사유 등록 상태 |
| evaluationUpdateStatus | String | 평가 기본 정보 업데이트 상태 |
| commentManagementStatus | String | 주석 명세 관리 상태 |
| overallOperationResult | String | 전체 운영 결과 상태 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| prcssRsultDstcd | String | 처리 결과 분류 코드 |
| responseStatus | String | 최종 응답 상태 |

**처리 로직:**
1. 모든 업무 기능의 개별 운영 상태 결과 평가
2. 운영의 성공 또는 실패를 기반으로 전체 처리 결과 결정
3. 운영 결과를 기반으로 처리 결과 분류 코드 생성
4. 실제 운영 결과와 응답 일관성 검증
5. 최종 처리 결과 분류 및 응답 상태 반환

### F-034-006: 데이터베이스거래제어관리 (Database Transaction Control Management)
- **설명:** 기업집단 신용등급 조정을 위한 데이터베이스 거래 운영 제어

**입력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| transactionScope | String | 데이터베이스 거래 운영 범위 |
| operationSequence | Array | 수행할 데이터베이스 운영 시퀀스 |
| rollbackConditions | Array | 거래 롤백을 트리거하는 조건 |

**출력 파라미터:**
| 파라미터 | 데이터 타입 | 설명 |
|----------|-------------|------|
| transactionStatus | String | 데이터베이스 거래 완료 상태 |
| operationResults | Array | 개별 데이터베이스 운영 결과 |

**처리 로직:**
1. 등급 조정 운영을 위한 데이터베이스 거래 범위 초기화
2. 오류 처리와 함께 적절한 시퀀스로 데이터베이스 운영 실행
3. 모든 데이터베이스 운영에서 거래 무결성 모니터링
4. 운영이 실패하거나 업무 규칙을 위반하는 경우 롤백 절차 구현
5. 모든 운영이 성공적으로 완료된 경우에만 거래 커밋
6. 거래 상태 및 상세 운영 결과 반환

## 5. 프로세스 흐름

```
기업집단 신용등급 조정 검토 등록 프로세스 흐름
├── 입력 파라미터 검증
│   ├── 그룹회사코드 검증
│   ├── 기업집단그룹코드 검증
│   ├── 기업집단등록코드 검증
│   ├── 평가년월일 검증
│   └── 등급조정분류 검증
├── 공통 영역 설정 및 초기화
│   ├── 비계약 업무 분류 설정
│   ├── 공통 IC 프로그램 호출
│   └── 출력 영역 할당
├── 기업집단 등급 조정 사유 처리
│   ├── 기존 등급 조정 사유 조회
│   ├── 데이터 무결성을 위한 기존 레코드 삭제
│   ├── 새로운 등급 조정 사유 레코드 준비
│   ├── 등급 조정 분류 할당
│   ├── 등급 조정 사유 내용 저장
│   └── 감사 추적과 함께 데이터베이스 삽입
├── 기업집단 평가 기본 정보 업데이트
│   ├── 기존 평가 기본 레코드 조회
│   ├── 레코드 존재 및 접근성 검증
│   ├── 등급 조정 분류 업데이트
│   ├── 처리 단계 분류 설정 ('4' - 저장)
│   └── 거래 제어와 함께 데이터베이스 업데이트
├── 기업집단 주석 명세 관리
│   ├── 기존 주석 명세 조회
│   ├── 주석 분류 필터링 ('27' - 등급 조정)
│   ├── 분류 기반 주석 삭제
│   └── 데이터 일관성 검증
├── 응답 데이터 생성
│   ├── 개별 운영 상태 평가
│   ├── 전체 처리 결과 결정
│   ├── 처리 결과 분류 코드 생성
│   └── 최종 응답 조립
└── 거래 완료 및 정리
    ├── 데이터베이스 거래 무결성 검증
    ├── 오류 처리 및 롤백 절차
    ├── 시스템 감사 추적 기록
    └── 시스템 자원 정리
```

## 6. 레거시 구현 참조

### 6.1 소스 파일
- **AIPBA81.cbl**: 기업집단 신용등급 조정 검토 등록을 위한 메인 애플리케이션 서버 프로그램
- **DIPA811.cbl**: 신용등급 조정 운영 및 데이터베이스 조정을 위한 데이터 컨트롤러 프로그램
- **IJICOMM.cbl**: 시스템 초기화를 위한 공통 인터페이스 통신 프로그램
- **RIPA110.cbl**: THKIPA110 테이블 운영을 위한 데이터베이스 I/O 프로그램 (관계기업기본정보)
- **RIPA130.cbl**: THKIPA130 테이블 운영을 위한 데이터베이스 I/O 프로그램 (기업재무대상관리정보)
- **YNIPBA81.cpy**: 등급 조정 요청을 위한 입력 파라미터 카피북 구조
- **YPIPBA81.cpy**: 처리 결과를 위한 출력 파라미터 카피북 구조
- **XDIPA811.cpy**: 내부 통신을 위한 데이터 컨트롤러 인터페이스 카피북
- **TRIPB118.cpy**: THKIPB118 테이블 구조 카피북 (기업집단평가등급조정사유목록)
- **TRIPB110.cpy**: THKIPB110 테이블 구조 카피북 (기업집단평가기본)
- **TRIPB130.cpy**: THKIPB130 테이블 구조 카피북 (기업집단주석명세)
- **TKIPB118.cpy**: THKIPB118 테이블 키 구조 카피북
- **TKIPB110.cpy**: THKIPB110 테이블 키 구조 카피북
- **TKIPB130.cpy**: THKIPB130 테이블 키 구조 카피북
- **YCCOMMON.cpy**: 시스템 통신을 위한 공통 처리 영역 카피북
- **YCDBIOCA.cpy**: 데이터베이스 I/O 통신 영역 카피북
- **YCDBSQLA.cpy**: 데이터베이스 SQL 통신 영역 카피북
- **YCCSICOM.cpy**: 공통 시스템 인터페이스 통신 카피북
- **YCCBICOM.cpy**: 공통 업무 인터페이스 통신 카피북
- **XIJICOMM.cpy**: 공통 처리를 위한 인터페이스 통신 카피북
- **XZUGOTMY.cpy**: 메모리 관리를 위한 출력 영역 할당 카피북

### 6.2 업무 규칙 구현

- **BR-034-001:** AIPBA81.cbl 170-190행 및 DIPA811.cbl 170-190행에 구현 (기업집단파라미터검증)
  ```cobol
  IF YNIPBA81-GROUP-CO-CD = SPACE
      #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF.
  IF YNIPBA81-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIPBA81-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF.
  IF YNIPBA81-VALUA-YMD = SPACE
      #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF.
  ```

- **BR-034-002:** DIPA811.cbl 200-220행에 구현 (등급조정분류검증)
  ```cobol
  MOVE XDIPA811-I-GRD-ADJS-DSTCD
    TO RIPB118-GRD-ADJS-DSTCD.
  IF RIPB118-GRD-ADJS-DSTCD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  ```

- **BR-034-003:** DIPA811.cbl 240-280행에 구현 (기업집단평가일자일관성)
  ```cobol
  MOVE XDIPA811-I-VALUA-YMD
    TO RIPB118-VALUA-YMD
       KIPB118-PK-VALUA-YMD
       KIPB110-PK-VALUA-YMD
       KIPB130-PK-VALUA-YMD.
  ```

- **BR-034-004:** DIPA811.cbl 250-290행에 구현 (등급조정사유등록제어)
  ```cobol
  #DYDBIO SELECT-CMD-Y TKIPB118-PK TRIPB118-REC.
  EVALUATE TRUE
      WHEN COND-DBIO-OK
          #DYDBIO DELETE-CMD-Y TKIPB118-PK TRIPB118-REC
      WHEN COND-DBIO-MRNF
          CONTINUE
      WHEN OTHER
          #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
  END-EVALUATE.
  ```

- **BR-034-005:** DIPA811.cbl 380-400행에 구현 (기업집단처리단계관리)
  ```cobol
  MOVE '4' TO RIPB110-CORP-CP-STGE-DSTCD.
  MOVE XDIPA811-I-GRD-ADJS-DSTCD
    TO RIPB110-GRD-ADJS-DSTCD.
  #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC.
  ```

- **BR-034-006:** DIPA811.cbl 420-460행에 구현 (주석분류삭제제어)
  ```cobol
  MOVE '27' TO KIPB130-PK-CORP-C-COMT-DSTCD.
  MOVE 1 TO KIPB130-PK-SERNO.
  #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC.
  EVALUATE TRUE
      WHEN COND-DBIO-OK
          #DYDBIO DELETE-CMD-Y TKIPB130-PK TRIPB130-REC
      WHEN COND-DBIO-MRNF
          CONTINUE
      WHEN OTHER
          #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
  END-EVALUATE.
  ```

- **BR-034-007:** DIPA811.cbl 250-460행 전반에 구현 (데이터베이스거래무결성)
  ```cobol
  IF NOT COND-DBIO-OK AND NOT COND-DBIO-MRNF
      STRING ' SQLCODE : ' DELIMITED BY SIZE
             DBIO-SQLCODE DELIMITED BY SIZE
             ' DBIO-STAT : ' DELIMITED BY SIZE
             DBIO-STAT DELIMITED BY SIZE
      INTO WK-ERR-LONG
      #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
  END-IF.
  ```

- **BR-034-008:** DIPA811.cbl 300-320행에 구현 (신용등급조정감사추적)
  ```cobol
  MOVE BICOM-GROUP-CO-CD TO RIPB118-GROUP-CO-CD.
  MOVE XDIPA811-I-CORP-CLCT-GROUP-CD TO RIPB118-CORP-CLCT-GROUP-CD.
  MOVE XDIPA811-I-GRD-ADJS-RESN-CTNT TO RIPB118-GRD-ADJS-RESN-CTNT.
  #DYDBIO INSERT-CMD-Y TKIPB118-PK TRIPB118-REC.
  ```

- **BR-034-009:** AIPBA81.cbl 280-300행에 구현 (처리결과상태검증)
  ```cobol
  IF COND-XDIPA811-OK
      CONTINUE
  ELSE
      #ERROR XDIPA811-R-ERRCD
             XDIPA811-R-TREAT-CD
             XDIPA811-R-STAT
  END-IF.
  MOVE XDIPA811-OUT TO YPIPBA81-CA.
  ```

- **BR-034-010:** DIPA811.cbl 240-280행 전반에 구현 (기업집단식별일관성)
  ```cobol
  MOVE BICOM-GROUP-CO-CD TO KIPB118-PK-GROUP-CO-CD
                            KIPB110-PK-GROUP-CO-CD
                            KIPB130-PK-GROUP-CO-CD.
  MOVE XDIPA811-I-CORP-CLCT-GROUP-CD TO KIPB118-PK-CORP-CLCT-GROUP-CD
                                        KIPB110-PK-CORP-CLCT-GROUP-CD
                                        KIPB130-PK-CORP-CLCT-GROUP-CD.
  ```

### 6.3 기능 구현

- **F-034-001:** AIPBA81.cbl 170-190행 및 DIPA811.cbl 170-190행에 구현 (기업집단신용등급조정파라미터검증)
  ```cobol
  IF YNIPBA81-GROUP-CO-CD = SPACE
      #ERROR CO-B3600003 CO-UKFH0208 CO-STAT-ERROR
  END-IF.
  IF YNIPBA81-CORP-CLCT-GROUP-CD = SPACE
      #ERROR CO-B3600552 CO-UKIP0001 CO-STAT-ERROR
  END-IF.
  IF YNIPBA81-CORP-CLCT-REGI-CD = SPACE
      #ERROR CO-B3600552 CO-UKII0282 CO-STAT-ERROR
  END-IF.
  IF YNIPBA81-VALUA-YMD = SPACE
      #ERROR CO-B2701130 CO-UKII0244 CO-STAT-ERROR
  END-IF.
  ```

- **F-034-002:** DIPA811.cbl 220-320행에 구현 (기업집단등급조정사유등록)
  ```cobol
  PERFORM S3100-PROC-THKIPB118-RTN THRU S3100-PROC-THKIPB118-EXT.
  
  MOVE BICOM-GROUP-CO-CD TO RIPB118-GROUP-CO-CD KIPB118-PK-GROUP-CO-CD.
  MOVE XDIPA811-I-CORP-CLCT-GROUP-CD TO RIPB118-CORP-CLCT-GROUP-CD KIPB118-PK-CORP-CLCT-GROUP-CD.
  MOVE XDIPA811-I-CORP-CLCT-REGI-CD TO RIPB118-CORP-CLCT-REGI-CD KIPB118-PK-CORP-CLCT-REGI-CD.
  MOVE XDIPA811-I-VALUA-YMD TO RIPB118-VALUA-YMD KIPB118-PK-VALUA-YMD.
  MOVE XDIPA811-I-GRD-ADJS-DSTCD TO RIPB118-GRD-ADJS-DSTCD.
  MOVE XDIPA811-I-GRD-ADJS-RESN-CTNT TO RIPB118-GRD-ADJS-RESN-CTNT.
  #DYDBIO INSERT-CMD-Y TKIPB118-PK TRIPB118-REC.
  ```

- **F-034-003:** DIPA811.cbl 340-410행에 구현 (기업집단평가기본정보업데이트)
  ```cobol
  PERFORM S3200-PROC-THKIPB110-RTN THRU S3200-PROC-THKIPB110-EXT.
  
  MOVE BICOM-GROUP-CO-CD TO KIPB110-PK-GROUP-CO-CD.
  MOVE XDIPA811-I-CORP-CLCT-GROUP-CD TO KIPB110-PK-CORP-CLCT-GROUP-CD.
  MOVE XDIPA811-I-CORP-CLCT-REGI-CD TO KIPB110-PK-CORP-CLCT-REGI-CD.
  MOVE XDIPA811-I-VALUA-YMD TO KIPB110-PK-VALUA-YMD.
  #DYDBIO SELECT-CMD-Y TKIPB110-PK TRIPB110-REC.
  MOVE XDIPA811-I-GRD-ADJS-DSTCD TO RIPB110-GRD-ADJS-DSTCD.
  MOVE '4' TO RIPB110-CORP-CP-STGE-DSTCD.
  #DYDBIO UPDATE-CMD-Y TKIPB110-PK TRIPB110-REC.
  ```

- **F-034-004:** DIPA811.cbl 420-480행에 구현 (기업집단주석명세관리)
  ```cobol
  PERFORM S3300-PROC-THKIPB130-RTN THRU S3300-PROC-THKIPB130-EXT.
  
  MOVE BICOM-GROUP-CO-CD TO KIPB130-PK-GROUP-CO-CD.
  MOVE XDIPA811-I-CORP-CLCT-GROUP-CD TO KIPB130-PK-CORP-CLCT-GROUP-CD.
  MOVE XDIPA811-I-CORP-CLCT-REGI-CD TO KIPB130-PK-CORP-CLCT-REGI-CD.
  MOVE XDIPA811-I-VALUA-YMD TO KIPB130-PK-VALUA-YMD.
  MOVE '27' TO KIPB130-PK-CORP-C-COMT-DSTCD.
  MOVE 1 TO KIPB130-PK-SERNO.
  #DYDBIO SELECT-CMD-Y TKIPB130-PK TRIPB130-REC.
  #DYDBIO DELETE-CMD-Y TKIPB130-PK TRIPB130-REC.
  ```

- **F-034-005:** AIPBA81.cbl 280-300행에 구현 (기업집단신용등급조정응답생성)
  ```cobol
  IF COND-XDIPA811-OK
      CONTINUE
  ELSE
      #ERROR XDIPA811-R-ERRCD XDIPA811-R-TREAT-CD XDIPA811-R-STAT
  END-IF.
  MOVE XDIPA811-OUT TO YPIPBA81-CA.
  ```

- **F-034-006:** DIPA811.cbl 250-480행 전반에 구현 (데이터베이스거래제어관리)
  ```cobol
  EVALUATE TRUE
      WHEN COND-DBIO-OK
          CONTINUE
      WHEN COND-DBIO-MRNF
          CONTINUE
      WHEN OTHER
          STRING ' SQLCODE : ' DELIMITED BY SIZE
                 DBIO-SQLCODE DELIMITED BY SIZE
                 ' DBIO-STAT : ' DELIMITED BY SIZE
                 DBIO-STAT DELIMITED BY SIZE
          INTO WK-ERR-LONG
          #ERROR CO-B4200095 CO-UKIE0009 CO-STAT-ERROR
  END-EVALUATE.
  ```

### 6.4 데이터베이스 테이블
- **THKIPB118 (기업집단평가등급조정사유목록)**: 등급 조정 사유 및 분류를 저장하는 기업집단 평가 등급 조정 사유 목록 테이블
- **THKIPB110 (기업집단평가기본)**: 기본 평가 정보 및 처리 단계를 저장하는 기업집단 평가 기본 테이블
- **THKIPB130 (기업집단주석명세)**: 분류 관리와 함께 평가 주석 및 주석을 저장하는 기업집단 주석 명세 테이블

### 6.5 오류 코드

#### 6.5.1 파라미터 검증 오류
- **B3600003**: 필수 필드 누락 오류 - 필수 그룹회사코드가 제공되지 않은 경우 발생
- **B3600552**: 기업집단 검증 오류 - 기업집단 코드가 누락되거나 유효하지 않은 경우 발생
- **B2701130**: 일자 검증 오류 - 평가일자가 누락되거나 유효하지 않은 형식인 경우 발생
- **UKFH0208**: 그룹회사코드 검증 오류 - 유효하지 않거나 누락된 그룹회사 식별자
- **UKIP0001**: 기업집단그룹코드 검증 오류 - 유효하지 않거나 누락된 기업집단 식별자
- **UKII0282**: 기업집단등록코드 검증 오류 - 유효하지 않거나 누락된 등록 식별자
- **UKII0244**: 평가년월일 검증 오류 - 유효하지 않거나 누락된 평가일자

#### 6.5.2 데이터베이스 운영 오류
- **B3900009**: 데이터베이스 접근 오류 - 데이터 검색 또는 조작 운영이 실패한 경우 발생
- **B4200095**: 데이터베이스 무결성 오류 - 운영 중 데이터 일관성 검증 실패
- **B4200219**: 거래 처리 오류 - 데이터베이스 거래 운영 실패
- **B4200223**: 레코드 미발견 오류 - 필요한 기업집단 평가 레코드를 찾을 수 없는 경우 발생
- **UKII0182**: 시스템 오류 처리 - 기술 지원 연락이 필요한 일반 시스템 오류
- **UKIE0009**: 데이터베이스 운영 오류 - 데이터베이스 처리 운영 실패

#### 6.5.3 업무 로직 오류
- **UBNA0036**: 업무 규칙 검증 오류 - 업무 로직 제약조건이 위반된 경우 발생
- **UBNA0048**: 처리 로직 오류 - 등급 조정 중 업무 처리 운영 실패

### 6.6 기술 아키텍처
- **애플리케이션 서버 계층**: AIPBA81은 신용등급 조정을 위한 사용자 인터페이스 및 업무 로직 조정 처리
- **데이터 컨트롤러 계층**: DIPA811은 등급 조정 운영, 데이터베이스 조정, 및 거래 제어 관리
- **데이터베이스 접근 계층**: RIPA110, RIPA130은 기업집단 테이블을 위한 데이터베이스 운영 및 SQL 처리
- **공통 프레임워크 계층**: IJICOMM, YCCOMMON은 공유 서비스, 통신, 및 시스템 초기화 제공
- **데이터 구조 계층**: 카피북은 등급 조정 운영을 위한 데이터 구조, 인터페이스 명세, 및 테이블 레이아웃 정의

### 6.7 데이터 흐름 아키텍처
1. **입력 처리**: YNIPBA81은 검증 요구사항과 함께 기업집단 신용등급 조정 파라미터 수신
2. **파라미터 검증**: 그룹 코드, 등록 코드, 및 평가일자에 대한 필수 필드 검증
3. **공통 영역 설정**: IJICOMM은 신용 운영을 위한 공통 처리 환경 및 업무 분류 초기화
4. **등급 조정 사유 처리**: DIPA811은 기존 레코드 삭제 및 새로운 등급 조정 사유 삽입 조정
5. **평가 기본 정보 업데이트**: 처리 단계 및 조정 분류와 함께 기업집단 평가 기본 테이블 업데이트
6. **주석 명세 관리**: 데이터 일관성을 유지하기 위한 주석 레코드의 분류 기반 삭제
7. **데이터베이스 거래 제어**: 데이터 무결성을 위한 롤백 기능을 포함한 포괄적 거래 관리
8. **응답 생성**: YPIPBA81은 처리 결과 분류 및 운영 상태 반환
9. **거래 완료**: 거래 완료를 위한 시스템 정리, 감사 추적 기록, 및 자원 관리
