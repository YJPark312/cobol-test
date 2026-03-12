# COBOL→Java 마이그레이션 프로젝트

## 프로젝트 개요
- 목적: COBOL 소스코드를 사내 Java 프레임워크 기준으로 변환
- 변환 방식: SOD 기반 멀티 에이전트 파이프라인
- 빌드 도구: Maven  # 또는 Gradle로 변경

---

## 디렉토리 구조
```
your-project/
├── CLAUDE.md
├── cobol/                        # 변환할 COBOL 원본 소스
├── src/
│   ├── main/java/                # 변환된 Java 소스 (자동 생성)
│   └── test/java/                # JUnit 테스트 코드 (자동 생성)
├── output/                       # 산출물 MD 파일 (자동 생성)
└── .claude/
    ├── agents/                   # 에이전트 정의 파일
    └── context/                  # 참고 자료
```

---

## 공통 참고 자료 경로
모든 에이전트는 아래 자료를 반드시 읽고 작업한다.

| 자료명 | 경로 | 참조 에이전트 |
|--------|------|--------------|
| DB 메타 정보 | db/ | 분석, 변환, 테스트 |
| 사내 Java 가이드 (프레임워크) | java-guide/n-KESA가이드.md | 플래닝, 변환, 검증, 리파인먼트 |
| 사내 Java 가이드 (공통모듈) | java-guide/n-KESA-공통모듈가이드.md | 플래닝, 변환, 검증, 리파인먼트 |
| COBOL 가이드 (프레임워크) | cobol-guide/z-KESA가이드.md | 분석, 플래닝, 변환 |
| COBOL 가이드 (공통모듈) | cobol-guide/z-KESA-공통모듈가이드.md | 분석, 플래닝, 변환 |
| COBOL→Java 갭 분석 | .claude/context/gap-analysis.md | 분석, 플래닝, 변환 |
| 정적 분석 규칙 | .claude/context/static-rules.md | 검증, 리파인먼트 |

---

## 산출물 경로
| 산출물 | 경로 | 생성 에이전트 | 사람 검토 |
|--------|------|--------------|----------|
| 분석 명세서 | output/analysis_spec.md | analysis-agent | ✅ 필수 |
| 변환 계획서 | output/conversion_plan.md | planning-agent | ✅ 필수 |
| 변환 로그 | output/conversion_log.md | conversion-agent | - |
| 검증 리포트 | output/validation_report.md | validation-agent | ✅ 필수 |
| 수정 로그 | output/refinement_log.md | refinement-agent | - |
| 빌드 결과 | output/build_result.md | build-agent | 실패 시 |
| 테스트 리포트 | output/test_report.md | unittest-agent | ✅ 필수 |
| 파이프라인 상태 | output/pipeline_status.md | orchestrator | - |
| Java 소스 | src/main/java/ | conversion-agent | - |
| 테스트 코드 | src/test/java/ | unittest-agent | - |

---

## 에이전트 실행 규칙

### 기본 원칙
- 모든 에이전트는 이전 단계 산출물을 INPUT으로 받아 동작한다
- 각 에이전트는 자신의 산출물만 생성한다 (SOD 원칙)
- 에이전트 파일 생성/수정은 절대 하지 않는다

### 실행 순서
1. analysis-agent   → analysis_spec.md 생성 후 사람 확인 대기
2. planning-agent   → conversion_plan.md 생성 후 사람 확인 대기
3. conversion-agent → Java 소스 생성
4. validation-agent → validation_report.md 생성
5. refinement-agent → 검증 피드백 반영
6. build-agent      → 빌드 실행
7. unittest-agent   → 테스트 실행

### 빌드 실패 재시도 규칙
- 1차 재시도: refinement-agent 단순 오류 수정 → 재빌드
- 2차 재시도: conversion-agent 문제 구간 재변환 → 재빌드
- 3차 재시도: planning-agent 설계 재검토 → 재변환 → 재빌드
- 3회 모두 실패: 작업 중단 후 output/build_error.md 생성, 사람에게 보고

### 사람 확인이 필요한 시점
- analysis_spec.md 생성 직후 → 내용 확인 후 명시적으로 "다음 진행해줘" 입력
- conversion_plan.md 생성 직후 → 내용 확인 후 명시적으로 "다음 진행해줘" 입력
- 빌드 3회 실패 시 → 수동 개입 필요
- test_report.md 생성 직후 → 동등성 검증 결과 최종 확인

---

## 에이전트별 권한 경계 (SOD)
| 에이전트 | 할 수 있는 것 | 절대 하면 안 되는 것 |
|---------|-------------|-------------------|
| orchestrator | 흐름 제어, 상태 기록 | 코드 접근/수정 |
| analysis-agent | COBOL 읽기, MD 작성 | 코드 생성 |
| planning-agent | 설계 문서 작성 | 코드 생성 |
| conversion-agent | Java 코드 생성 | 검증, 수정 |
| validation-agent | 정적 분석, MD 작성 | 코드 실행/수정 |
| refinement-agent | 피드백 반영 수정 | 신규 설계, 범위 외 수정 |
| build-agent | 빌드 실행, 결과 보고 | 코드 로직 수정 |
| unittest-agent | 테스트 생성/실행 | 소스 코드 수정 |

---

## 코딩 규칙
- Java 버전: 17  # 사내 환경에 맞게 수정
- 빌드 도구: Maven
- DB 접근: MyBatis  # 또는 JPA로 변경
- 기본 패키지: com.company.project  # 사내 패키지명으로 수정
- 로깅: SLF4J + Logback
- 테스트: JUnit5 + Mockito
