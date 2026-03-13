# Build Result Report

**Date**: 2026-03-13 12:32:13
**Build System**: Maven
**Build Status**: FAILURE
**Exit Code**: N/A (빌드 도구 미설치 — BUILD_TOOL_NOT_AVAILABLE)
**Duration**: 0s

---

## Summary

Maven 및 Java (JVM) 가 모두 이 환경에 설치되어 있지 않아 빌드를 실행할 수 없었습니다 (`BUILD_TOOL_NOT_AVAILABLE`). 추가로 `pom.xml`에 선언된 사내 프레임워크 JAR (`lib/sqc-framework.jar`, system scope)가 `lib/` 디렉토리 자체가 없어 의존성 조건을 충족하지 못합니다. Maven이 설치된 환경에서 실행하더라도 이 의존성 문제로 컴파일이 실패할 것이 예측됩니다. refinement_log.md 기준 UNRESOLVED 항목 5건이 잔존하나, 이는 빌드 컴파일 단계가 아닌 런타임/업무 로직 수준의 이슈입니다.

---

## Compilation Errors

No compilation errors detected. (빌드 도구 미설치로 컴파일 미실행. 실행 시 아래 예측 오류 발생 예상)

---

## Dependency Conflicts

| # | Artifact | 상태 | Details |
|---|----------|------|---------|
| 1 | com.kbstar.sqc:sqc-framework:1.0.0 | JAR 파일 미존재 | `pom.xml` L28: `${project.basedir}/lib/sqc-framework.jar` — `lib/` 디렉토리 없음. system scope 의존성 해소 불가. Maven 실행 시 `Could not find artifact` 또는 `systemPath does not exist` 오류 발생 예정 |

---

## Other Errors

### 1. BUILD_TOOL_NOT_AVAILABLE — Maven 미설치

- `mvn` 명령이 PATH에서 탐색되지 않음 (`which mvn` → not found)
- Homebrew (`/opt/homebrew`), `/usr/local`, `/Library` 경로 전체 탐색 결과 mvn 실행 파일 없음
- 설치 방법: `brew install maven` 또는 https://maven.apache.org/install.html 참조

### 2. BUILD_TOOL_NOT_AVAILABLE — Java (JVM) 미설치

- `java -version` 실행 결과: "Unable to locate a Java Runtime"
- `/Library/Java/JavaVirtualMachines/` 디렉토리 비어 있음
- `pom.xml`에 Java 17 설정: `<maven.compiler.source>17</maven.compiler.source>`
- 설치 방법: https://www.java.com 또는 `brew install openjdk@17`

### 3. system scope JAR 파일 부재 — sqc-framework.jar

- `pom.xml` L22-L29: `com.kbstar.sqc:sqc-framework:1.0.0` (scope=system)
- 선언된 경로: `${project.basedir}/lib/sqc-framework.jar`
- 실제 상태: `lib/` 디렉토리 자체가 없음
- 영향: 아래 클래스들이 컴파일 불가
  - `com.kbstar.sqc.base.DataUnit`
  - `com.kbstar.sqc.base.ProcessUnit`
  - `com.kbstar.sqc.framework.annotation.BizUnit`
  - `com.kbstar.sqc.framework.annotation.BizMethod`
  - `com.kbstar.sqc.framework.annotation.BizUnitBind`
  - `com.kbstar.sqc.framework.context.IOnlineContext`
  - `com.kbstar.sqc.framework.context.CommonArea`
  - `com.kbstar.sqc.framework.data.IDataSet`
  - `com.kbstar.sqc.framework.data.IRecord`
  - `com.kbstar.sqc.framework.data.IRecordSet`
  - `com.kbstar.sqc.framework.data.impl.DataSet`
  - `com.kbstar.sqc.framework.exception.BusinessException`
  - `com.kbstar.sqc.framework.log.ILog`

### 4. refinement_log.md UNRESOLVED 항목 (빌드 영향 없음 — 런타임/업무 로직 이슈)

아래 항목은 컴파일 단계에서는 오류를 유발하지 않으나, 런타임 및 업무 정확성에 영향을 줄 수 있습니다.

| Item | 상태 | 내용 | 영향 |
|------|------|------|------|
| Item 13 | UNRESOLVED | 처리구분 '02' 미구현 빈 분기 | 런타임 — 업무팀 협의 필요 |
| Item 16 | UNRESOLVED | PM 메서드명 임시 문자열 (`pmAipba30Xxxx01`) | 거래코드 등록 불일치 |
| Item 17 | UNRESOLVED | `MAX_100` 타입 일관성 (int vs String) | 낮은 위험 |
| Item 18 | UNRESOLVED | 직원 테이블 직접 조회 vs FUBcEmployee 대체 권고 | 보안 위험 (HIGH) |
| Item 19 | UNRESOLVED | `selectMainDebtAffltYnQipa307` WHERE 절 `VALUA_YMD` 조건 누락 | 런타임 조회 범위 불명확 |
| Item 20 | UNRESOLVED | `selectExistCheckQipa301` WHERE 절 `VALUA_YMD` 조건 누락 | 기존재 확인 범위 과다 |
| Item 21 | UNRESOLVED | N+1 쿼리 패턴 | 성능 저하 위험 |
| Item 22 | UNRESOLVED | 미검증 테이블 조회 (SQLIO 소스 미확보) | 정보 유출 위험 (HIGH) |

---

## Raw Build Output (Last 100 Lines)

```
[BUILD_TOOL_NOT_AVAILABLE] mvn 명령어 미설치
$ which mvn
mvn not found

$ java -version
The operation couldn't be completed. Unable to locate a Java Runtime.
Please visit http://www.java.com for information on installing Java.

$ ls /Library/Java/JavaVirtualMachines/
(empty — no JVM installed)

$ ls /Users/datapipeline-poc/Desktop/claude_code/02.cobol-test2/lib/
ls: No such file or directory
lib/ 디렉토리 없음

[BUILD ABORTED] Maven 및 Java 미설치로 빌드 실행 불가. Exit code: N/A
```

---

## Orchestrator Recommendation Payload

```json
{
  "status": "FAILURE",
  "exit_code": -1,
  "build_system": "maven",
  "compilation_error_count": 0,
  "dependency_conflict_count": 1,
  "errors": [
    {
      "type": "BUILD_TOOL_NOT_AVAILABLE",
      "detail": "mvn 명령어가 시스템 PATH에 존재하지 않음. Maven 미설치."
    },
    {
      "type": "BUILD_TOOL_NOT_AVAILABLE",
      "detail": "Java (JVM) 가 설치되어 있지 않음. java -version 실행 실패."
    },
    {
      "type": "DEPENDENCY_MISSING",
      "detail": "lib/sqc-framework.jar 미존재. pom.xml system scope dependency 해소 불가. 컴파일 시 com.kbstar.sqc.* 전체 클래스 cannot find symbol 예상."
    }
  ],
  "dependency_conflicts": [
    {
      "artifact": "com.kbstar.sqc:sqc-framework:1.0.0",
      "scope": "system",
      "declared_path": "${project.basedir}/lib/sqc-framework.jar",
      "actual_status": "FILE_NOT_FOUND",
      "detail": "lib/ 디렉토리 자체 없음"
    }
  ],
  "unresolved_refinement_items": [
    "Item 13: 처리구분 02 미구현",
    "Item 16: PM 메서드명 임시 문자열",
    "Item 17: MAX_100 타입 일관성",
    "Item 18: 직원 테이블 직접 조회 보안",
    "Item 19: selectMainDebtAffltYnQipa307 VALUA_YMD 조건 누락",
    "Item 20: selectExistCheckQipa301 VALUA_YMD 조건 누락",
    "Item 21: N+1 쿼리 패턴",
    "Item 22: 미검증 테이블 조회"
  ],
  "matched_rules": [],
  "auto_recoverable": false,
  "recovery_agent": null,
  "retry_recommended": false,
  "retry_reason": "Maven 및 Java 미설치, sqc-framework.jar 미존재. 환경 설정 및 사내 프레임워크 JAR 파일 수동 배치 후 재시도 필요. playbook-build.md에 RULE-B* 규칙이 정의되어 있지 않아 자동 복구 불가."
}
```
