---
name: AIPBA30/DIPA301 분석 프로젝트 컨텍스트
description: AIPBA30(AS) + DIPA301(DC) 기업집단신용평가이력관리 프로그램 분석 결과 요약
type: project
---

AIPBA30(AS) + DIPA301(DC) 쌍이 분석 완료됨 (2026-03-13).

**Why:** COBOL→Java 마이그레이션 POC 프로젝트 대상 프로그램. z-KESA 프레임워크 기반.

**How to apply:** 후속 planning/conversion 단계에서 이 컨텍스트 참조.

## 핵심 발견사항

- AIPBA30(AS)은 입력검증+DIPA301 호출+출력조립만 담당. 255행으로 단순
- DIPA301(DC)은 1985행. 처리구분 '01'(신규평가) INSERT, '02'(확정취소) 무동작, '03'(삭제) 11테이블 연쇄 DELETE
- MOVE YNIPBA30-CA TO XDIPA301-IN: 96 bytes 전체 구조 복사 (양쪽 구조 동일)
- 처리구분 '02' 확정취소가 실질 처리 없음 — 업무팀 확인 필요 (HIGH 위험)
- 11개 테이블 삭제 단일 트랜잭션 처리 필요: THKIPB110~THKIPB133

## 미해결 카피북 목록

프레임워크 공통: XZUGOTMY, XIJICOMM, YCCOMMON, YCDBSQLA, YCDBIOCA
테이블 (TR+TK): TRIPB110~133, TKIPB110~133 (12쌍)
SQLIO 인터페이스: XQIPA301~308 (8개)

## DIPA301이 접근하는 테이블 목록

THKIPB110(평가기본), THKIPB111(연혁명세), THKIPB112(재무분석목록),
THKIPB113(사업부분구조분석명세), THKIPB114(항목별평가목록), THKIPB116(계열사명세),
THKIPB118(평가등급조정사유목록), THKIPB119(재무평점단계별목록),
THKIPB130(주석명세), THKIPB131(승인결의록명세), THKIPB132(승인결의록위원명세),
THKIPB133(승인결의록의견명세)

## nKESA 매핑

- AIPBA30 → PU.pmAipba30()
- DIPA301 → DU.dmDipa301() (처리구분별 분기 or 별도 DM 메서드)
