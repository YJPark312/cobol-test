---
name: project_patterns
description: n-KESA 프레임워크 기반 COBOL-Java 마이그레이션 프로젝트의 테스트 패턴 및 핵심 발견사항
type: project
---

## 프로젝트: KIP ENBIPBA (기업집단신용평가이력)

**기본 정보**:
- 패키지: com.kbstar.kip.enbipba
- 테스트 디렉토리: src/test/java/com/kbstar/kip/enbipba/
- 빌드 명령: `export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home && mvn test`
- JaCoCo: pom.xml에 추가됨 (0.8.11)

## Protected 메서드 처리 - 핵심 패턴

n-KESA 프레임워크에서 DataUnit/ProcessUnit의 DB 접근 메서드(`dbInsert`, `dbSelect`, `dbSelectMulti`, `dbDelete`)와 공통 메서드(`getCommonArea`, `getLog`)가 모두 `protected`로 선언됨.

**문제**: Mockito `@Spy` + `doReturn()` 방식은 compile-time에 protected 접근 오류 발생 (메서드가 `com.kbstar.sqc.base` 패키지에서 정의됨)

**해결**: Test subclass 패턴
- `TestableDUCorpEvalHistoryA extends DUCorpEvalHistoryA`: HashMap stub registry + call count 추적
- `TestablePUCorpEvalHistory extends PUCorpEvalHistory`: getCommonArea() override + setter 제공

## @BizUnitBind 필드 주입

Mockito @InjectMocks가 @BizUnitBind를 인식하지 못함. Java Reflection으로 해결:
```java
Field duField = PUCorpEvalHistory.class.getDeclaredField("duCorpEvalHistoryA");
duField.setAccessible(true);
duField.set(instance, mockDu);
```

## 발견된 소스 코드 버그

DUCorpEvalHistoryA.java line 82: `prcssDstcd.replaceAll(...)` - null 체크 누락으로 NPE 발생.
PM(PUCorpEvalHistory)에서 먼저 null 체크하므로 운영 영향은 낮으나 DU 직접 호출 시 위험.

## 테스트 커버리지 기준선 (첫 실행)

- CCorpEvalConsts: 라인 100%, 브랜치 N/A, 메서드 100%
- PUCorpEvalHistory: 라인 100%, 브랜치 100%, 메서드 100%
- DUCorpEvalHistoryA: 라인 77.9%, 브랜치 54.3%, 메서드 100%
- 전체 합계: 라인 81.7%, 브랜치 62.8%, 메서드 100%

DUCorpEvalHistoryA 브랜치 미달 원인: 처리구분 '02' no-op 분기, 루프 내 null 분기, 로그 레벨 분기

**Why:** 첫 번째 테스트 실행에서 확립된 기준선으로 향후 회귀 감지에 활용
**How to apply:** 추후 테스트 재실행 시 커버리지 저하 여부 비교 기준으로 사용
