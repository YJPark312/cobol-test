# z-KESA → n-KESA 프레임워크 매핑룰

COBOL(z-KESA) → Java(n-KESA) 전환을 위한 프레임워크 전체 매핑룰입니다.
GraphRAG 구축 시 노드/엣지로 파싱하여 활용합니다.

## 소스 문서

| 문서 | 경로 | 비고 |
|------|------|------|
| z-KESA 가이드 | `framework/z-kesa/제3장_z-KESA활용_20170203_v2.01.pdf` | COBOL 프레임워크 (29,099줄) |
| n-KESA 가이드 | `framework/n-kesa/코어뱅킹 현대화_FW_개발가이드_20260312_V0.71.docx` | Java 프레임워크 (13,936줄) |

## 매핑룰 파일 목록

| 파일 | 크기 | 내용 |
|------|------|------|
| 01_architecture_structure.md | 99K | 아키텍처, 프로그램 계층, DIVISION/SECTION, 호출, CommonArea, IO편집, 연동거래, 에러처리, 출력, 취소/중단, 시스템 인터페이스, 명명규칙 |
| 02_db_access.md | 52K | DBIO/SQLIO → XSQL/DBIO Unit, 커서패턴, SQL바인딩, Lock/Isolation, 에러처리, Array처리, 성능지침 |
| 03_batch_processing.md | 60K | 배치 프로그램 구조, JCL→Shell, 파일I/O, DB접근, Restart, Commit, 병렬처리, 루프배치, 명명규칙 |
| 04_macros_utilities.md | 57K | 매크로 24종(#ERROR, #DYCALL, #DYDBIO 등), 유틸리티 12종(ZSGTIME, ZUGCDCV 등), 명명규칙 |
| 05_dataset_coding_guide.md | 71K | COBOL→Java 데이터타입, MOVE/INITIALIZE/STRING, IDataSet/IRecordSet/IRecord API, BigDecimal, Null처리, 금기규칙, 성능지침 |
| 06_eai_v3_integration.md | 72K | EAI 연계(callOutbound/sendOutbound), XIO설계, EAITransformer, OutboundHeader, KBMessage, MCI BID/PUSH, V3표준전문(Inbound/Outbound), 타이머 |

## 보조 데이터 (표 추출)

| 파일 | 경로 | 내용 |
|------|------|------|
| z-kesa_tables.txt | `framework/z-kesa/` | PDF에서 추출한 표 391개 (4,365줄) |
| n-kesa_tables.txt | `framework/n-kesa/` | DOCX에서 추출한 표 220개 (1,601줄) |

API 시그니처, 필드 정의, 코드값 테이블 등 상세 참조 시 위 표 추출 파일을 활용합니다.

## 매핑 엔트리 구조

각 매핑 항목은 다음 구조로 작성되어 있습니다:

```
### [카테고리] - 개념명
- z-KESA: z-KESA 용어/개념
- n-KESA: n-KESA 대응 용어/개념
- z-KESA Detail: COBOL 패턴, 매크로, 카피북 상세
- n-KESA Detail: Java 클래스, 메소드, API 상세
- Mapping Rule: 구체적 전환 규칙
```

## 생성 일자

2026-04-07
