# Planning Agent Memory Index

## 프로젝트 컨텍스트

- [KIP 기업집단신용평가이력관리 변환 프로젝트](project_kip_corp_eval.md)
  - AIPBA30/DIPA301 → PUCorpEvalHistory/DUCorpEvalHistoryA
  - 패키지: com.kbstar.kip.enbipba
  - 미결 TBD: SQLIO 소스 확보, 처리구분 '02' 확인, 거래코드 확보

## 변환 패턴

- [zKESA→nKESA 반복 변환 패턴](patterns_zkesa_nkesa.md)
  - 프레임워크 계층 매핑 (AS→PU, DC→DU 등)
  - 패키지 네이밍 규칙
  - 코딩 제약사항 (싱글톤, 트랜잭션, 상수 클래스 등)
  - 변환 순서 원칙 (Bottom-Up)
