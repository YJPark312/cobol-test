# Planning Agent Memory

## 프로젝트 개요
- 대상: ACCT001(계좌관리) / ACCT002(거래처리) / ACCT003(이자계산) COBOL → Java 변환
- 작업 디렉토리: /Users/datapipeline-poc/Desktop/claude_code/02.cobol-test2
- 주요 산출물 경로: output/analysis_spec.md, output/conversion_plan.md

## 핵심 아키텍처 패턴 (확정)
- 패키지 루트: com.company.project
- 계층: controller / service / service.impl / repository / domain.vo / domain.dto / mapper / common / config
- DB 접근: MyBatis 3.5.x (인터페이스 + XML, resultMap 명시 필수, 자동 매핑 금지)
- 서비스 명명: AccountService/AccountServiceImpl, TransactionService/TransactionServiceImpl, InterestService/InterestServiceImpl
- Mapper 명명: AccountMapper, CustomerMapper, TransactionMapper, LimitMapper, InterestRateMapper, InterestHistMapper, AuditMapper

## 위험도 상 항목 → 설계 대응 (분석 확정)
1. WS-DAILY-RATE 혼용 → calcSimpleInterest(dailyRate), calcCompoundInterest(monthlyRate) 지역변수 분리
2. 세금 테이블 미적용 버그 → 비즈니스 확인 전 고정 세율(15.4%) + TODO 주석 처리
3. ACCTMST 이중 OPEN → AccountService @Transactional(REQUIRED), Txn/Interest @Transactional(PROPAGATION_REQUIRED), AuditService @Transactional(REQUIRES_NEW)
4. TR-COUNTER-ACCOUNT 미설정 → TxnReqDto에 counterAccountNo(String) 필드 추가, XFER 시 @NotBlank 검증

## 자주 쓰이는 변환 규칙
- COBOL CALL → DI 주입 서비스 메서드 호출 + DTO 파라미터
- PERFORM → private 메서드
- EVALUATE TRUE → switch expression + enum
- 88레벨 → enum (AccountType CH/SA/FX, AccountStatus A/C/F, TxnType DEPO/WITH/XFER/FEE)
- PIC S9(13)V99 COMP-3 → BigDecimal(scale=2, HALF_UP)
- PIC S9(03)V9(04) COMP-3 → BigDecimal(scale=4, HALF_UP)
- PIC X(08) 날짜 → LocalDate (DateTimeFormatter.BASIC_ISO_DATE)
- OCCURS n TIMES → List<T>
- 경과일 수동 루프 → ChronoUnit.DAYS.between()
- 복리 루프 → BigDecimal 루프 + MathContext.DECIMAL128

## 예외 계층 (확정)
RuntimeException > BizException > AccountNotFoundException(0001) / CustomerNotFoundException(0001) / DuplicateAccountException(0002) / AccountStatusException(0003) / InsufficientBalanceException(0003) / TransactionLimitException(0003) / SystemException(9999)

## TBD 항목 (비즈니스 확인 필요)
- TBD-1: 세금 등급별 세율 적용 여부 (V1:0%, G1:9.9%, N1:15.4%)
- TBD-2: 일한도/월한도 구현 범위
- TBD-3: ALLOW-OVERDRAFT 빈 단락 의도
- TBD-5: 계좌번호 채번 방식 (DB 시퀀스 vs UUID)

## 선행 읽기 순서 (conversion_plan 작성 시)
1. .claude/context/java-guide.md
2. .claude/context/gap-analysis.md
3. output/analysis_spec.md
