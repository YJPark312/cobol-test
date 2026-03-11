# 정적 분석 규칙

> 변환된 Java 코드에 적용하는 정적 분석 및 코딩 컨벤션 규칙.
> validation-agent와 refinement-agent가 이 규칙을 기준으로 검증/수정한다.

---

## 1. 필수 규칙 (CRITICAL) - 위반 시 빌드 차단

### CR-001: BigDecimal 사용 강제
- **설명**: 금액, 이율 등 소수점 연산에 `double`, `float` 사용 금지
- **위반 패턴**: `double balance`, `float rate`
- **올바른 패턴**: `BigDecimal balance`, `BigDecimal rate`

### CR-002: null 반환 금지 (단건 조회)
- **설명**: Mapper 단건 조회는 반드시 `Optional<T>` 반환
- **위반 패턴**: `AccountVo selectByAccountNo(String no)` → null 반환 가능
- **올바른 패턴**: `Optional<AccountVo> selectByAccountNo(String no)`

### CR-003: @Transactional 선언 위치
- **설명**: 트랜잭션은 ServiceImpl 메서드에만 선언, Controller/Mapper에 선언 금지
- **위반 패턴**: Controller 또는 Mapper에 `@Transactional`
- **올바른 패턴**: `AccountServiceImpl.openAccount()` 에 `@Transactional`

### CR-004: SQL Injection 방지
- **설명**: MyBatis XML에서 `${}` 사용 금지, `#{}` 사용 강제
- **위반 패턴**: `WHERE ACCOUNT_NO = ${accountNo}`
- **올바른 패턴**: `WHERE ACCOUNT_NO = #{accountNo}`

### CR-005: 예외 은닉 금지
- **설명**: catch 블록에서 예외를 무시하거나 `System.out`으로만 출력 금지
- **위반 패턴**: `catch (Exception e) {}`
- **올바른 패턴**: `catch (Exception e) { log.error("...", e); throw new BizException(e); }`

### CR-006: 개인정보 로그 출력 금지
- **설명**: 주민번호, 비밀번호, 카드번호 전체를 로그에 출력 금지
- **위반 패턴**: `log.info("residentNo={}", residentNo)`
- **올바른 패턴**: `log.info("residentNo={}****", residentNo.substring(0, 6))`

---

## 2. 경고 규칙 (WARNING) - 검토 후 수정 권고

### WR-001: 매직 넘버 금지
- **설명**: 코드 내 의미 불명확한 숫자 리터럴 사용 금지
- **위반 패턴**: `if (balance.compareTo(new BigDecimal("1000000")) > 0)`
- **올바른 패턴**: 상수 클래스에 `MAX_BALANCE = new BigDecimal("1000000")` 정의

### WR-002: 메서드 길이 제한
- **설명**: 하나의 메서드는 50줄 이하 권고 (COBOL 단락 분리 패턴 반영)
- **위반 패턴**: 100줄 이상의 서비스 메서드
- **올바른 패턴**: private 메서드로 기능 분리

### WR-003: 빈 catch 블록 경고
- **설명**: 비어있는 catch 블록은 반드시 사유 주석 작성
- **위반 패턴**: `catch (Exception e) { /* do nothing */ }`
- **올바른 패턴**: `catch (Exception e) { // 파일 없는 경우 정상 처리, 무시 의도적 }`

### WR-004: 불필요한 else 제거
- **설명**: if 블록이 return/throw로 끝나는 경우 else 불필요
- **위반 패턴**:
  ```java
  if (account == null) { throw ...; }
  else { return account.getBalance(); }
  ```
- **올바른 패턴**:
  ```java
  if (account == null) { throw ...; }
  return account.getBalance();
  ```

### WR-005: Lombok 어노테이션 통일
- **설명**: VO 클래스에 `@Setter` 사용 금지, `@Builder` 사용 권고
- **위반 패턴**: `@Data` (setter 포함) on VO class
- **올바른 패턴**: `@Getter @Builder @NoArgsConstructor @AllArgsConstructor`

### WR-006: 로그 레벨 적정성
- **설명**: 정상 처리 흐름은 INFO, 디버그 정보는 DEBUG, 오류는 ERROR
- **위반 패턴**: 정상 흐름에 ERROR 레벨 로그
- **올바른 패턴**: 레벨 분리 준수

---

## 3. 정보성 규칙 (INFO) - 참고용

### IR-001: JavaDoc 권고 대상
- public Service 인터페이스 메서드
- public Controller 메서드
- 비즈니스 로직이 복잡한 private 메서드

### IR-002: 테스트 커버리지 목표
- Service 계층: 80% 이상
- 핵심 비즈니스 로직(이자계산, 잔액검증): 90% 이상

### IR-003: MyBatis resultMap 명시
- 자동 매핑(`autoMappingBehavior`) 의존 금지
- 모든 쿼리에 `resultMap` 명시적 선언

---

## 4. COBOL 변환 특화 규칙

### CV-001: WORKING-STORAGE 전역변수 제거
- COBOL의 WS 전역변수를 Java 인스턴스 변수로 변환 금지
- 메서드 파라미터 또는 지역변수로 처리

### CV-002: GOBACK/STOP RUN 변환
- GOBACK → `return` 또는 메서드 종료
- STOP RUN → main 종료 또는 `throw new SystemException()`
- 중간 종료(9900-ABEND) → `throw new BizException(code, message)`

### CV-003: PERFORM 루프 → 표준 Java 루프
- `PERFORM VARYING` → `for` 또는 `Stream`
- `PERFORM UNTIL` → `while`
- 불필요한 GOTO 패턴 제거

### CV-004: 88레벨 → enum 변환
- 반드시 enum 클래스로 변환
- `fromCode(String code)` 정적 팩토리 메서드 제공
- 유효하지 않은 코드 입력 시 예외 발생

### CV-005: 복리 계산 정확도
- COBOL PERFORM 루프 복리와 Java Math.pow() 결과 일치 확인
- 소수점 6자리 이하에서 차이 발생 가능 → `BigDecimal.pow()` 사용 권고

---

## 5. 검증 체크리스트

validation-agent는 아래 항목을 순서대로 확인한다.

```
[ ] CR-001: double/float 사용 여부 (grep: double|float)
[ ] CR-002: Optional 반환 여부 (Mapper 인터페이스 확인)
[ ] CR-003: @Transactional 위치 (Controller/Mapper에 있으면 위반)
[ ] CR-004: ${ } 사용 여부 (XML Mapper 확인)
[ ] CR-005: 빈 catch 블록 여부
[ ] CR-006: 개인정보 로그 출력 여부
[ ] WR-001: 매직 넘버 사용 여부
[ ] WR-002: 메서드 50줄 초과 여부
[ ] WR-005: VO에 @Setter 또는 @Data 사용 여부
[ ] CV-001: 인스턴스 변수로 WORKING-STORAGE 처리 여부
[ ] CV-004: 88레벨 enum 변환 여부
```
