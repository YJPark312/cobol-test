# 참고자료 목록

COBOL-to-Java 전환 솔루션(C2J Pilot)의 GraphRAG 구축 및 변환 파이프라인에 활용되는 참고자료입니다.

---

## framework/ — KESA 프레임워크 가이드

COBOL(z-KESA)에서 Java(n-KESA)로 전환할 때 소스/타겟 프레임워크의 API, 구조, 유틸리티를 이해하기 위한 자료입니다.

### z-kesa/ (레거시 — 전환 대상)

| 파일 | 설명 |
|------|------|
| 제3장_z-KESA활용_20170203_v2.01.pdf | z-KESA 프레임워크 활용 가이드. COBOL 환경에서의 프레임워크 구조, API 호출 패턴, 트랜잭션 처리 방식 등을 정의 |

### n-kesa/ (타겟 — 전환 목표)

| 파일 | 설명 |
|------|------|
| nKesa_서버용_별첨1_공통Utility설명서_v1.52.doc | n-KESA 1.x 공통 유틸리티 설명서. Java 환경에서 사용하는 공통 유틸리티 클래스, 메서드 정의 |
| nKesa2.0_서버용_별첨1_공통Utility설명서_v1.52_20260310.doc | n-KESA 2.0 공통 유틸리티 설명서. 코어뱅킹 현대화에 맞춰 업데이트된 최신 버전 |

### mapping/ (z-KESA → n-KESA 매핑)

| 파일 | 설명 |
|------|------|
| zkesa & nkesa 비교_20250417.xlsx | z-KESA와 n-KESA의 API/구조 비교표. 전환 시 1:1 매핑 관계 정의 |
| nkesa2.0 코어현대화 고객_CommonArea_맵핑_20250902.xlsx | 고객 업무 영역의 CommonArea(공통 데이터 영역) 필드별 z-KESA → n-KESA 매핑 정의 |

---

## domain/ — 업무 도메인 자료

은행 코어뱅킹 업무 모듈(고객, 상품 등)의 구조와 데이터 설계를 정의하는 자료입니다. COBOL 프로그램의 업무 맥락을 이해하는 데 활용됩니다.

| 파일 | 설명 |
|------|------|
| KAA_고객모듈 설명서_v1.0.doc | 고객(KAA) 모듈 설명서. 고객 정보 관리 업무의 구조, 처리 흐름, 주요 기능 정의 |
| KAA_고객모듈 맵핑표_v1.09_0320.xlsx | 고객 모듈 COBOL↔Java 필드/구조체 맵핑표 |
| PDM_상품모듈 설명서_v0.32.doc | 상품(PDM) 모듈 설명서. 상품 정보 관리의 데이터 구조, 처리 로직 정의 |
| PDM_입출력설계서_v0.27.xlsx | 상품 모듈의 입출력 전문 설계서. 전문 헤더/바디 필드 레이아웃 정의 |
| PGMF06_제6장_상품정보_v2.00.pdf | 상품정보 업무 기능 명세 (제6장) |
| PGMF13_별첨2_상품정보설명서_v2.00.pdf | 상품정보 상세 설명서 (별첨). 상품 코드 체계, 속성, 처리 규칙 등 |

---

## architecture/ — 아키텍처 및 인프라

코어뱅킹 현대화 프로젝트의 전체 아키텍처, 개발 가이드, 인프라 표준을 정의하는 자료입니다.

| 파일 | 설명 |
|------|------|
| 코어뱅킹 현대화_FW_아키텍처정의서_20260127_V0.7.pptx | 코어뱅킹 현대화 프레임워크의 전체 아키텍처 정의. 레이어 구조, 컴포넌트 관계, 배포 구조 |
| 코어뱅킹 현대화_FW_개발가이드_20260312_V0.71.docx | 프레임워크 기반 Java 개발 가이드. 코딩 규칙, 패키지 구조, 공통 모듈 사용법 |
| TheK_E0_AA_인프라아키텍처_표준전문헤더레이아웃정의서_V2.0.4_210820.xlsx | 표준 전문 헤더 레이아웃 정의서. 온라인/배치 전문의 헤더 필드 구조, 길이, 타입 정의 |
| KB은행_암호화가이드_v1.31.pptx | 암호화 처리 가이드. 개인정보 암복호화 적용 기준, API 사용법, 적용 대상 필드 |

---

## conversion/ — C2J 변환 관련

COBOL→Java 변환 작업에 직접 참고하는 교육 및 보충 자료입니다.

| 파일 | 설명 |
|------|------|
| C2J 보충자료.pptx | C2J 변환 솔루션 보충 설명 자료. 변환 규칙, 예외 케이스, 주의사항 |
| 코어뱅킹 현대화_FW_온라인교육_20260106_교육.pptx | 프레임워크 온라인 교육 자료. 개발자 대상 n-KESA 기반 개발 교육 내용 |

---

## research/ — 연구 논문

GraphRAG 구축 및 코드 변환 파이프라인 설계에 참고하는 학술 논문입니다.

### GraphRAG 관련

| 파일 | 설명 |
|------|------|
| GraphRAG_Local-to-Global_2404.16130.pdf | Microsoft GraphRAG 원본 논문. 텍스트에서 지식 그래프를 구축하고 Local/Global 검색을 결합하여 질의 응답하는 방법론 제시 |
| GraphRAG_Survey_2408.08921.pdf | GraphRAG 기법 종합 서베이. Graph-Based Indexing, Graph-Guided Retrieval, Graph-Enhanced Generation 워크플로우 정리 |

### COBOL→Java 변환

| 파일 | 설명 |
|------|------|
| COBOL-to-Java_Automated-Testing_2504.10548.pdf | 심볼릭 실행 기반 COBOL 단위 테스트 자동 생성 → JUnit 변환으로 COBOL↔Java 의미적 등가성 검증 |
| COBOL-to-Java_Automated-Validation_2506.10999.pdf | COBOL→Java 변환 결과의 등가성 검증 프레임워크. 자동화된 테스트 생성 및 모킹을 통한 검증 방법론 |

### 레거시 코드 현대화

| 파일 | 설명 |
|------|------|
| LegacyTranslate_Multi-Agent_2603.14054.pdf | 멀티에이전트 기반 레거시 코드(PL/SQL→Java) 변환 프레임워크. 역할 분담된 에이전트 협업 구조 제안 |
| Google_Code-Migration-at-Scale_2504.09691.pdf | Google의 대규모 LLM 코드 마이그레이션 사례. 69.46% 편집을 LLM이 생성, 작업 시간 50% 단축 |
| Legacy-Code-Modernization-LLM_2411.14971.pdf | LLM을 활용한 레거시 코드(MUMPS, 메인프레임 어셈블리) 문서화 및 현대화 연구 |

### 에이전트 프레임워크

| 파일 | 설명 |
|------|------|
| ACE_Agentic-Context-Engineering_2510.04618.pdf | ACE(Agentic Context Engineering) 논문 (ICLR 2026). 컨텍스트를 압축하지 않고 진화하는 Playbook으로 유지하여 에이전트 성능을 향상시키는 프레임워크. 본 프로젝트의 ACE Playbook 시스템의 이론적 기반 |
