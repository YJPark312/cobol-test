# C2J Orchestrator Memory

## 프로젝트 구조 (확인 완료)
- 작업 디렉토리: /Users/datapipeline-poc/Desktop/claude_code/02.cobol-test2
- COBOL 소스: cobol/ACCT001.cbl (메인), ACCT002.cbl, ACCT003.cbl
- Copybook: 없음 (cobol/*.cpy 없음 — 이후 파이프라인 실행 시도 불필요)
- 산출물 디렉토리: output/ (파이프라인 최초 실행 시 자동 생성됨)
- 에이전트 정의: .claude/agents/*.md
- 컨텍스트: .claude/context/db-meta.md, gap-analysis.md, java-guide.md, static-rules.md

## 파이프라인 단계 순서 (CLAUDE.md 기준)
1. analysis-agent → output/analysis_spec.md → 사람 확인 대기
2. planning-agent → output/conversion_plan.md → 사람 확인 대기
3. conversion-agent → src/main/java/ 소스 생성
4. validation-agent → output/validation_report.md → 사람 확인 대기
5. refinement-agent → 피드백 반영
6. build-agent → output/build_result.md (실패 시 사람 확인)
7. unittest-agent → output/test_report.md → 사람 확인 대기

## 재시도 정책
- build-agent / unittest-agent 실패: 최대 3회 재시도
- 3회 초과 시 HALTED, 사람 개입 요청
- 재시도 1: refinement-agent 단순 수정 → 재빌드
- 재시도 2: conversion-agent 문제 구간 재변환 → 재빌드
- 재시도 3: planning-agent 설계 재검토 → 재변환 → 재빌드

## 주요 산출물 경로
- output/pipeline_status.md — 오케스트레이터만 관리
- output/analysis_spec.md — analysis-agent 생성
- output/conversion_plan.md — planning-agent 생성
- output/handoff_*.md — 에이전트 간 핸드오프 문서 (오케스트레이터 작성)

## 알려진 ACCT001/002/003 주요 리스크 (analysis 결과 요약)
- 위험도 상: 복리 루프 정밀도, WS-DAILY-RATE 혼용(단리=일이율/복리=월이율), 세금 테이블 미적용 버그, 동일 파일 이중 OPEN 트랜잭션
- 미해결 참조: TR-COUNTER-ACCOUNT 미설정(XFER), TR-CHANNEL 미설정, WS-TAX-TABLE 미사용
- 하드코딩 상수: 이율(CH/SA/FX), 수수료(ATM/INET/TELL), 세율(15.4%) → 외재화 필요
