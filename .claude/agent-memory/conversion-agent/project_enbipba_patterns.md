---
name: enbipba 프로젝트 변환 패턴
description: com.kbstar.kip.enbipba 기업집단신용평가이력관리 변환에서 확인된 n-KESA 프레임워크 패턴 및 결정사항
type: project
---

## 패키지 구조
- 최상위: `com.kbstar.kip.enbipba`
- biz/: PU, DU 클래스
- xsql/: SQL XML 파일 (DU와 동일명)
- consts/: 상수 클래스
- uio/: PM/DM IO 정보 XML
- util/: 기타 유틸리티 (필요시)

## 클래스 명명 패턴
- ProcessUnit: `PUCorpEvalHistory extends ProcessUnit`
- DataUnit: `DUCorpEvalHistoryA extends DataUnit`
- 상수 클래스: `CCorpEvalConsts` (final 키워드 금지, public static만)

## 어노테이션 패턴
- `@BizUnit("설명")` 클래스 레벨
- `@BizMethod` public DM/PM 메서드
- `@BizUnitBind private DUXxx duXxx` DI 주입 (동일 컴포넌트 내)

## 메서드 시그니처
```java
public IDataSet methodName(IDataSet requestData, IOnlineContext onlineCtx)
```

## DB 접근 메서드 (DataUnit 상속)
- 단건 SELECT: `IDataSet result = dbSelect("sqlId", param)`
- 다건 SELECT: `IRecordSet rs = dbSelectMulti("sqlId", param)`
- INSERT: `int rows = dbInsert("sqlId", param)`
- DELETE: `int rows = dbDelete("sqlId", param)`
- NOTFOUND 판별: result == null 또는 rs.getRecordCount() == 0

## COBOL 커서 패턴 변환
DBIO OPEN-FETCH-CLOSE → `dbSelectMulti()` + IRecordSet 루프
```java
IRecordSet rs = dbSelectMulti("selectListXxxForUpdate", param);
for (int i = 0; i < rs.getRecordCount(); i++) {
    IRecord rec = rs.getRecord(i);
    // rec.getString("fieldName")
}
```

## 에러 처리
```java
throw new BusinessException(errCd, treatCd, "메시지");
```
- DM에서 throw → PM까지 자동 전파, re-throw 불필요

## 로깅
```java
ILog log = getLog(onlineCtx);
log.debug("★[S1000] 메시지");
```

## CommonArea 취득
```java
CommonArea ca = getCommonArea(onlineCtx);
String groupCoCd = ca.getGroupCoCd();
String userEmpid = ca.getUserEmpid();
String screenNo = ca.getScreenNo();
```

## formId 조립 (#BOFMID 대응)
```java
String formId = CCorpEvalConsts.FORM_ID_PREFIX + screenNo; // "V1" + 화면번호
responseData.put("formId", formId);
```
- TODO: 프레임워크 자동 처리 여부 확인 필요

## IDataSet 파라미터 전달 규칙
- requestData 직접 전달 금지
- 필드별 명시적 `new DataSet()` 생성 후 `param.put("key", value)` 매핑

## SQLIO 소스 미확보 시 처리
- 역설계 SQL 작성 + TODO 주석 표시
- XSQL에 `<!-- TODO: [SQLIO 소스 미확보] ... -->` 명시

## 처리구분 '02' TBD
- 무동작 분기 + TODO 주석으로 구현
- 업무팀 확인 후 로직 추가 예정

**Why:** SQLIO(QIPA301~QIPA308) 소스 미확보 및 처리구분 '02' 업무 로직 미정의
**How to apply:** 향후 동일 프로젝트 재방문 시 위 TODO 항목 8개 수동 검토 필요
