---
name: KIP 기업집단신용평가이력관리 변환 프로젝트
description: AIPBA30(AS)/DIPA301(DC) → PUCorpEvalHistory/DUCorpEvalHistoryA 변환 프로젝트 컨텍스트
type: project
---

AIPBA30(AS)/DIPA301(DC) 두 COBOL 프로그램을 n-KESA Java 프레임워크로 변환하는 프로젝트.

**Why:** z-KESA(메인프레임 IBM z/OS) → n-KESA(Java/WAS/AWS) 아키텍처 전환

**How to apply:** conversion_plan.md 설계 기반으로 conversion-agent가 Java 소스 생성 시 이 컨텍스트 참조

**핵심 결정 사항:**
- 컴포넌트 패키지: com.kbstar.kip.enbipba
- 클래스: PUCorpEvalHistory (PU), DUCorpEvalHistoryA (DU), CCorpEvalConsts (상수)
- 변환 순서: Bottom-Up (상수 → DU + XSQL → PU)
- 처리구분 '02' 무동작 여부 TBD (업무팀 확인 필요)
- SQLIO QIPA301~QIPA308 소스 미확보 (SQL 역설계 필요)

**미결 TBD 목록 (2026-03-13 기준):**
- TBD-01: SQLIO 소스 확보 (가장 중요)
- TBD-03: 처리구분 '02' 무동작 의도 확인 (업무팀)
- TBD-04: 거래코드 10자리 확보 (PM 메서드명)
