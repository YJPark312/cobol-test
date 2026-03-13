---
name: enbipba_component_patterns
description: com.kbstar.kip.enbipba 컴포넌트 정적 분석에서 발견된 반복 패턴 및 주요 결정사항
type: project
---

## 프레임워크 패턴 (n-KESA)

- DB 접근: MyBatis 계열 XSQL (iBATIS sqlMap) 사용. parameterClass="map", resultClass="map"
- 바인드 변수: `#변수명:타입#` 형식 (DB2 필수 타입 명시)
- 단건 조회: `dbSelect(sqlId, param)` → null 반환 = NOTFOUND
- 다건 조회: `dbSelectMulti(sqlId, param)` → IRecordSet

## 반복 발견 이슈 유형

### 카테고리별 HIGH 이슈
1. PM 메서드에 try-catch 구조 누락 (n-KESA 가이드 §11.2 필수)
2. @BizMethod 어노테이션 설명 문자열 누락
3. log.debug에 개인정보/업무식별자 출력 (userEmpid, 직원한글명, 기업집단코드류)
4. XML COUNT 컬럼 별칭과 Java getString 키명 불일치
5. SQLIO 역설계 SQL에서 반환 컬럼명과 Java 접근 키명 불일치

### DB 쿼리 정합성 패턴
- SELECT ... AS EXIST_CNT → Java result.getString("cnt"): 별칭 불일치 패턴
- insertThkipb110 계열: XML 바인드 변수 수와 Java insertParam.put 수 불일치 다수 발생
- CURSOR 루프 변환 (dbSelectMulti + for loop): SELECT 컬럼 목록이 DELETE WHERE 컬럼을 모두 포함해야 함

## 이 컴포넌트 특이사항

- SQLIO 소스 미확보 8건 (QIPA301, 302, 303, 304, 305, 306, 307, 308) — 역설계 SQL 전면 검증 필요
- 처리구분 '02' (확정취소) 미구현 상태
- 거래코드 미확정으로 PM 메서드명 임시 (`pmAipba30Xxxx01`)
- 직원 정보 조회: FUBcEmployee.getEmployeeInfo() 공통 유틸 대체 권고

## COBOL → Java 변환 체크포인트

- CURSOR 패턴 → dbSelectMulti: SELECT 결과 컬럼과 Java rec.getString 키명 일치 여부 반드시 확인
- DBIO INSERT: XML 바인드 변수 전체 목록과 Java put 목록을 1:1 대조 필수
- COUNT(*) AS 별칭: Java에서 소문자 camelCase로 변환하여 접근 (EXIST_CNT → existCnt)
