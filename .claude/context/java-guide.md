# 사내 Java 개발 가이드

> 테스트용 샘플. 실제 사내 표준으로 교체 필요.

---

## 기술 스택
| 항목 | 버전 | 비고 |
|------|------|------|
| Java | 17 | LTS |
| Spring Boot | 3.2.x | |
| MyBatis | 3.5.x | DB 접근 |
| Maven | 3.9.x | 빌드 |
| JUnit | 5.x | 테스트 |
| Mockito | 5.x | Mock |
| SLF4J + Logback | 2.x | 로깅 |

---

## 패키지 구조
```
com.company.project
├── controller          # REST API 컨트롤러
├── service             # 비즈니스 로직
│   └── impl
├── repository          # MyBatis Mapper 인터페이스
├── domain              # VO / DTO 클래스
│   ├── vo              # DB 매핑 Value Object
│   └── dto             # 요청/응답 Data Transfer Object
├── mapper              # MyBatis XML Mapper
├── common
│   ├── exception       # 커스텀 예외
│   ├── constants       # 상수 클래스
│   └── util            # 유틸리티
└── config              # 설정 클래스
```

---

## 클래스 네이밍 규칙
| 계층 | 접미사 | 예시 |
|------|--------|------|
| Controller | Controller | AccountController |
| Service 인터페이스 | Service | AccountService |
| Service 구현체 | ServiceImpl | AccountServiceImpl |
| Repository | Mapper | AccountMapper |
| DB VO | Vo | AccountVo |
| 요청 DTO | ReqDto | AccountOpenReqDto |
| 응답 DTO | ResDto | AccountOpenResDto |
| 예외 | Exception | AccountNotFoundException |
| 상수 | Constants | AccountConstants |

---

## 공통 응답 구조
```java
public class ApiResponse<T> {
    private String resultCode;   // 0000: 성공, 그 외 실패
    private String resultMsg;
    private T data;
}
```

### 결과 코드 정의
| 코드 | 설명 |
|------|------|
| 0000 | 성공 |
| 0001 | 데이터 없음 (Not Found) |
| 0002 | 중복 데이터 (Duplicate) |
| 0003 | 유효성 검사 실패 (Validation Error) |
| 9999 | 시스템 오류 |

---

## 예외 처리 규칙

### 커스텀 예외 계층
```
RuntimeException
└── BizException (비즈니스 예외 공통)
    ├── AccountNotFoundException
    ├── CustomerNotFoundException
    ├── InsufficientBalanceException
    ├── AccountStatusException
    └── TransactionLimitException
```

### 예외 처리 방식
- Service 계층에서 BizException 발생
- `@ControllerAdvice`의 `GlobalExceptionHandler`에서 일괄 처리
- DB 오류는 `DataAccessException`으로 래핑 후 재처리
- 로깅: ERROR 레벨, 스택트레이스 포함

```java
// 예시
public AccountVo getAccount(String accountNo) {
    return accountMapper.selectByAccountNo(accountNo)
        .orElseThrow(() -> new AccountNotFoundException(accountNo));
}
```

---

## 서비스 계층 규칙
- 트랜잭션은 Service 구현체 메서드에 `@Transactional` 선언
- 조회 전용 메서드: `@Transactional(readOnly = true)`
- 서비스 간 직접 호출 금지 → 공통 유틸 또는 이벤트 방식 사용
- COBOL CALL 관계는 서비스 내부 메서드 호출로 변환

```java
@Service
@RequiredArgsConstructor
@Slf4j
public class AccountServiceImpl implements AccountService {

    private final AccountMapper accountMapper;
    private final TransactionService transactionService;  // ACCT002 대응
    private final InterestService interestService;        // ACCT003 대응

    @Override
    @Transactional
    public AccountOpenResDto openAccount(AccountOpenReqDto reqDto) {
        // 유효성 검사
        // 계좌번호 생성
        // DB 저장
        // 초기 입금 처리 (transactionService 호출)
        // 응답 반환
    }
}
```

---

## Repository(Mapper) 규칙
- MyBatis 인터페이스 + XML Mapper 방식
- 동적 쿼리는 XML의 `<if>`, `<choose>`, `<foreach>` 사용
- 단건 조회는 `Optional<T>` 반환
- `resultMap`은 명시적으로 선언 (자동 매핑 금지)

```java
@Mapper
public interface AccountMapper {
    Optional<AccountVo> selectByAccountNo(String accountNo);
    int insertAccount(AccountVo accountVo);
    int updateAccount(AccountVo accountVo);
    List<AccountVo> selectByCustomerId(String customerId);
}
```

---

## VO / DTO 규칙
- Lombok `@Getter`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor` 사용
- VO는 DB 컬럼과 1:1 매핑, setter 금지 (`@Setter` 사용 금지)
- DTO는 요청/응답 용도로 분리, `@Valid` 어노테이션 활용

```java
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AccountVo {
    private String accountNo;
    private String customerId;
    private String accountType;
    private BigDecimal balance;
    private LocalDate openDate;
    private LocalDate closeDate;
    private String status;
    private BigDecimal interestRate;
    private LocalDate lastTxnDate;
    private BigDecimal overdraftLimit;
    private String branchCode;
    private LocalDateTime regDttm;
    private LocalDateTime updDttm;
}
```

---

## 로깅 규칙
- 클래스 레벨: `@Slf4j` (Lombok)
- 입력 파라미터 로그: DEBUG 레벨
- 비즈니스 주요 처리: INFO 레벨
- 오류: ERROR 레벨 (예외 스택트레이스 포함)
- 개인정보(주민번호, 계좌번호 일부) 마스킹 필수

```java
log.debug("[계좌조회] accountNo={}", accountNo);
log.info("[계좌개설] 완료 accountNo={}, customerId={}", accountNo, customerId);
log.error("[계좌개설] 실패 accountNo={}", accountNo, e);
```

---

## 날짜/금액 처리 규칙
| COBOL 타입 | Java 타입 | 비고 |
|------------|-----------|------|
| PIC X(08) 날짜 | LocalDate | DateTimeFormatter.BASIC_ISO_DATE |
| PIC X(14) 타임스탬프 | LocalDateTime | yyyyMMddHHmmss |
| PIC S9(13)V99 COMP-3 | BigDecimal | scale=2, HALF_UP |
| PIC S9(03)V9(04) COMP-3 이율 | BigDecimal | scale=4, HALF_UP |

- 금액 계산은 반드시 `BigDecimal` 사용 (`double` 사용 금지)
- 반올림 모드: `RoundingMode.HALF_UP`

---

## 단위 테스트 규칙
- Service 테스트: Mockito로 Mapper 모킹
- 경계값 테스트 필수: 잔액 0, 한도 초과, null 입력
- 테스트 메서드명: `메서드명_시나리오_기대결과`

```java
@Test
void openAccount_정상요청_계좌번호반환() { ... }

@Test
void openAccount_존재하지않는고객_예외발생() { ... }

@Test
void withdraw_잔액부족_InsufficientBalanceException발생() { ... }
```
