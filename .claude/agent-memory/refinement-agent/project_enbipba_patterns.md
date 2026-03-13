---
name: enbipba 컴포넌트 리파인먼트 패턴
description: com.kbstar.kip.enbipba 컴포넌트 정적 분석 결과에서 반복 등장하는 이슈 유형과 해결 패턴
type: project
---

## 프로젝트 컨텍스트
- 컴포넌트: com.kbstar.kip.enbipba (기업집단신용평가이력관리)
- 대상 COBOL: AIPBA30.cbl (AS/PU), DIPA301.cbl (DC/DU)
- SQLIO 소스(QIPA301~QIPA308) 미확보 상태 — 역설계 SQL 전량 수동 검증 필요

**Why:** 최초 변환 시 SQLIO 소스 미확보로 인해 역설계된 SQL이 다수 존재하며, 이로 인해 컬럼명/바인드변수명 불일치가 반복 발생함.

**How to apply:** validation_report에서 DB 쿼리 정합성 이슈 발생 시, SQLIO 소스 미확보 여부를 먼저 확인하고 Java 코드의 접근 키명을 기준으로 XML을 수정하는 방향을 우선 적용.

---

## 자주 발생하는 이슈 유형

### 1. COUNT 별칭 불일치
- XML: `COUNT(*) AS EXIST_CNT` vs Java: `getString("cnt")` 패턴
- 해결: Java 접근 키명 기준으로 XML 별칭 통일 (`AS CNT`)

### 2. resultClass="map" 에서 컬럼명 → Java 키 매핑
- n-KESA XSQL은 MyBatis resultClass="map" 사용
- camelCase 자동 변환 없음 → AS 별칭으로 Java 접근 키명과 일치시켜야 함
- 패턴: `FNAF_A_RPTDOC_DSTCD AS fnafARptdocDstcd`

### 3. PM 메서드 try-catch 구조 누락
- n-KESA 가이드 §11.2 필수: BusinessException re-throw + Exception wrap
- 에러 코드는 ERR_B3900002, 조치 코드는 TREAT_UKII0182 사용 일반적

### 4. @BizMethod 설명 문자열 누락
- `@BizMethod` → `@BizMethod("설명")`
- DM: "기업집단신용평가이력 관리 DM" 형태
- PM: "기업집단신용평가이력관리 PM" 형태

### 5. 민감정보 로그 출력
- 제거 대상: 직원번호(userEmpid), 직원한글명, 기업집단그룹코드, 기업집단등록코드
- 처리구분 등 비민감 파라미터는 replaceAll("[\r\n]", "_") 적용 후 유지

### 6. 바인드 변수명 불일치
- Java put 키명을 기준으로 XML #바인드명# 통일
- 특히 직원번호: Java는 "userEmpid", XML은 "empId" 불일치 패턴 주의

---

## UNRESOLVED 재발 이슈 (업무팀 확인 필요)
- 처리구분 '02' 확정취소 로직 미정의
- selectMainDebtAffltYnQipa307 VALUA_YMD 조건 추가 여부
- selectExistCheckQipa301 VALUA_YMD 조건 추가 여부
- FUBcEmployee 공통 유틸 대체 여부 (DU에서 callSharedMethodByDirect 가능 여부 확인 필요)
- PM 메서드명 거래코드 확정 (pmAipba30Xxxx01 → pm[실제10자리])
