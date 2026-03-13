# n-KESA 프레임워크 프로그램 작성 가이드

> **출처**: C2J변환솔루션PoC용_n-KESA가이드_AWS_최종 (1).pdf, C2J 보충자료.pptx
> **목적**: 변환/검증 에이전트가 COBOL→Java 변환 시 참조할 n-KESA 프레임워크 규칙 정리

---

## 1. n-KESA 프레임워크 개요

n-KESA(Next-generation KB Enterprise Software Architecture)는 개방형/Linux/AWS 환경의 온라인/배치 애플리케이션 개발 프레임워크다. z-KESA(메인프레임 COBOL)의 Java 후속 아키텍처이며, NEXCORE J2EE WAS 기반 컴포넌트 아키텍처로 구성된다.

### 1.1 온라인 거래 처리 흐름

```
단말 → MCI → 프레임워크(n-KESA) → PU(ProcessUnit) → FU(FunctionUnit) → DU(DataUnit) → DB
                                     ↑ IOnlineContext / CommonArea 공유 ↑
```

1. 단말에서 요청 전송
2. MCI가 내부 표준전문으로 변환
3. 프레임워크가 IDataSet으로 편집 후 **PU** 호출
4. PU가 업무 처리 총괄 (FU/DU 호출)
5. FU가 업무 로직 처리 (DU 호출)
6. DU가 DB 접근 (XSQL 실행)
7. PU가 응답 IDataSet 조립 후 프레임워크에 Return

### 1.2 실행 환경 (WAS)

- **Websphere J2EE** 기반 실행 환경
- **DB**: DB2, Oracle, MySQL 환경 적용
- **내부표준전문**: JSON 기반 처리
- **트랜잭션**: 프레임워크가 Commit/Rollback 관리 (임의 제어 금지)
- **전문복원**: 책임자 승인, 취소거래 등 지원
- **대량 입출력**: 대량 입력/출력 처리 지원
- **로그**: 거래로그, 업무로그 기본 제공
- **유틸**: Flat, JSON 등 전문 변환 유틸리티
- **DBIO**: CRUD 기능, 원장보정로그, 변경로그 자동 기록
- **선후처리**: 프레임워크 선처리/후처리 기능 제공
- **암복호화**: 암복호화 모듈 연계
- **배치**: Control-M 연계 배치 실행, 온라인-배치 연계, 센터컷 실행

### 1.3 컴포넌트 아키텍처

- 애플리케이션은 **컴포넌트** 단위로 패키징 (1 컴포넌트 = 1 JAR)
- 컴포넌트는 **핫 디플로이** 가능 (WAS 재기동 없이 배포)
- Unit 클래스는 **싱글톤** 인스턴스로 동작 → **멤버 필드 사용 금지**
- 예외: `@BizUnitBind`로 선언한 FU/DU 참조 필드만 허용

| 특징 | 내용 |
|------|------|
| 패키징 | 컴포넌트 단위로 JAR 패키징 |
| 클래스로딩 | 프레임워크 자체 클래스 로더 동작. 컴포넌트 단위로 클래스 로딩. 일부 변경 시에도 컴포넌트 전체 JAR 재패키징 및 재로딩 |
| 직접 참조 | 컴포넌트 내 클래스 간에는 직접 호출 가능. 타 컴포넌트 클래스는 import 불가 → FW API로 간접 호출 |
| 컴파일 | 컴포넌트별 별도 CLASSPATH로 컴파일. 타 컴포넌트 클래스 참조 시 컴파일 에러 발생 |

### 1.4 컴포넌트 내부 디렉토리 (패키지) 구조

```
com.kbstar.[appCode3].[componentId]/
├── biz/        ← PU, FU, DU 클래스 위치 (비즈니스 로직)
├── uio/        ← PM/FM/DM의 IO 정보 XML 파일 (PU/FU/DU와 1:1 생성)
├── xio/        ← External용 전문(Outbound) 레이아웃 XML 파일
├── xsql/       ← SQL XML 파일 (DU와 동일 이름으로 1:1 생성)
├── consts/     ← 상수 클래스
├── base/       ← 부모 클래스 (비대면 IBF 기반 소스 전환 시에만 사용, PU만 허용)
└── util/       ← 컴포넌트 내 기타 POJO 유틸리티 클래스
```

**주의**:
- 컴포넌트 단위로 클래스 로더가 동작함
- 컴포넌트 내의 패키지 간 클래스 직접 참조 가능
- 타 컴포넌트의 클래스는 visible 하지 않음 (import 불가)

---

## 2. 프로그램 계층 구조 (Unit Type)

| 타입 | 설명 | Base Class |
|------|------|------------|
| **PU** | ProcessUnit. 거래의 진입점. 입력검증, 업무처리 총괄 | com.kbstar.sqc.base.ProcessUnit |
| **FU** | FunctionUnit. 업무 로직 처리 모듈 | com.kbstar.sqc.base.FunctionUnit |
| **DU** | DataUnit. DB 접근 전담 모듈 | com.kbstar.sqc.base.DataUnit |
| **BU** | BatchUnit. 배치 프로그램 | com.kbstar.sqc.batch.base.BatchUnit |
| **DBIO** | DB CRUD 전담 모듈. 단건 CUD, 단건/Lock 조회 | 프레임워크 제공 (원장보정로그, 변경로그 자동) |

### 호출 규칙 (Call Hierarchy)

| 호출자 → 피호출 | PU | FU | DU | DBIO |
|-----------------|----|----|-----|------|
| **PU** | × | ○ | ○ | ○ |
| **FU** | × | ○ | ○ | ○ |
| **DU** | × | × | × | × |

- PU → FM → DM (표준 top-down 호출)
- PU → DM 직접 호출 **가능**
- FM → FM 호출 **가능**
- DM → DM 호출 **불가** (DU에서 다른 DU 호출 금지)
- **DU**: 단건조회, 목록조회만 담당
- **DBIO**: 모든 단건 CUD 처리, 단건 조회/Lock 조회 기능 제공, 원장보정로그/변경로그 자동 기록
- 에러는 `BusinessException`으로 처리하고 임의 Rollback/Commit 불가 (프레임워크가 처리)

---

## 3. 메서드 타입 및 시그니처

### 3.1 메서드 타입

| 타입 | 위치 | 설명 |
|------|------|------|
| **PM** | PU | Process Method. 거래코드와 1:1 대응. 거래 진입점 |
| **FM** | FU | Function Method. 업무 로직 처리 |
| **DM** | DU | Data Method. DB 접근 (SELECT/INSERT/UPDATE/DELETE) |

### 3.2 표준 메서드 시그니처

모든 PM/FM/DM은 동일한 시그니처를 사용한다:

```java
public IDataSet methodName(IDataSet requestData, IOnlineContext onlineCtx)
```

- **requestData**: 입력 데이터 (IDataSet)
- **onlineCtx**: 온라인 컨텍스트 (IOnlineContext)
- **return**: 출력 데이터 (IDataSet)

---

## 4. PU (ProcessUnit) 작성 규칙

### 4.1 PM 템플릿 코드

```java
package com.kbstar.app.componentId;

import com.kbstar.sqc.base.ProcessUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import nexcore.framework.core.exception.BusinessException;
import nexcore.framework.online.channel.bean.CommonArea;

@BizUnit("PU 설명")
public class PUSampleName extends ProcessUnit {

    @BizMethod("PM 설명")
    public IDataSet pmEDU1234501(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);

        try {
            // TODO 업무 로직 작성
            // FU/DU 호출, 입력 검증, 출력 조립

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("에러코드", "조치메시지", "맞춤메시지", e);
        }
        return responseData;
    }
}
```

### 4.2 PM 작성 규칙

- PM명은 `pm` + 거래코드(10자리) 형식: `pmEDU1234501`
- `try-catch` 구조 필수: `BusinessException`은 re-throw, 그 외 Exception은 `BusinessException`으로 감싸서 throw
- `getLog(onlineCtx)`로 ILog 획득
- `getCommonArea(onlineCtx)`로 CommonArea 획득
- 반드시 `responseData`를 return

---

## 5. FU (FunctionUnit) 작성 규칙

### 5.1 FM 템플릿 코드

```java
package com.kbstar.app.componentId;

import com.kbstar.sqc.base.FunctionUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import nexcore.framework.online.channel.bean.CommonArea;

@BizUnit("FU 설명")
public class FUSampleName extends FunctionUnit {

    @BizUnitBind
    private DUSampleTable duSampleTable;  // DU 참조 (싱글톤 주입)

    @BizMethod("FM 설명")
    public IDataSet testFm(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);

        // TODO 업무 로직 작성
        // DU 호출, 업무 판단 로직

        return responseData;
    }
}
```

### 5.2 FM 작성 규칙

- FM에서는 try-catch 불필요 (PM에서 최종 처리)
- `@BizUnitBind`로 DU/FU 참조 주입
- FM명 접두사: register~/modify~/delete~/get~/getList~/is~/validate~/calculate~/getNoOf~/manage~

---

## 6. DU (DataUnit) 작성 규칙

### 6.1 DM 템플릿 코드

```java
package com.kbstar.app.componentId;

import com.kbstar.sqc.base.DataUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;

@BizUnit("DU 설명")
public class DUTableNameA extends DataUnit {

    @BizMethod("DM 설명")
    public IDataSet selectSampleData(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();

        // 단건 조회
        IDataSet result = dbSelect("selectSampleData", requestData);

        // 다건 조회
        IRecordSet rs = dbSelectMulti("selectSampleList", requestData);

        responseData.putRecordSet("rs", rs);
        return responseData;
    }
}
```

### 6.2 DM 작성 규칙

- DM에서 다른 DU 호출 **금지**
- DM명 접두사: insert~/update~/delete~/select~/selectList~
- XSQL 파일은 DU와 1:1 매핑 (같은 이름)
- **COMMIT/ROLLBACK 직접 호출 금지** (프레임워크가 처리)

### 6.3 DU DB 접근 메서드

| 메서드 | 기능 | 반환 타입 |
|--------|------|----------|
| `dbSelect(sqlId, param)` | 단건 SELECT | IDataSet |
| `dbSelectMulti(sqlId, param)` | 다건 SELECT (RecordSet) | IRecordSet |
| `dbInsert(sqlId, param)` | INSERT | int (영향 row 수) |
| `dbUpdate(sqlId, param)` | UPDATE | int |
| `dbDelete(sqlId, param)` | DELETE | int |

---

## 7. XSQL (SQL XML) 작성 규칙

### 7.1 기본 구조

XSQL 파일은 DU 클래스와 1:1로 매핑되며, 같은 이름을 사용한다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<sqlMap namespace="DUTableNameA">

    <select id="selectSampleData" parameterClass="map" resultClass="map">
        SELECT COL1, COL2, COL3
          FROM SCHEMA.TABLE_NAME
         WHERE KEY_COL = #keyCol:VARCHAR#
    </select>

    <select id="selectSampleList" parameterClass="map" resultClass="map">
        SELECT COL1, COL2
          FROM SCHEMA.TABLE_NAME
         WHERE COND_COL = #condCol:VARCHAR#
         ORDER BY COL1
    </select>

    <insert id="insertSampleData" parameterClass="map">
        INSERT INTO SCHEMA.TABLE_NAME (COL1, COL2, COL3)
        VALUES (#col1:VARCHAR#, #col2:VARCHAR#, #col3:NUMERIC#)
    </insert>

    <update id="updateSampleData" parameterClass="map">
        UPDATE SCHEMA.TABLE_NAME
           SET COL2 = #col2:VARCHAR#
         WHERE KEY_COL = #keyCol:VARCHAR#
    </update>

    <delete id="deleteSampleData" parameterClass="map">
        DELETE FROM SCHEMA.TABLE_NAME
         WHERE KEY_COL = #keyCol:VARCHAR#
    </delete>

</sqlMap>
```

### 7.2 바인드 변수 타입 지정 규칙 (DB2 필수)

DB2 환경에서는 바인드 변수에 반드시 타입을 명시해야 한다:

```
#변수명:타입#
```

| 타입 | 설명 | 예시 |
|------|------|------|
| VARCHAR | 문자열 | `#acno:VARCHAR#` |
| NUMERIC | 숫자 | `#amount:NUMERIC#` |
| INTEGER | 정수 | `#count:INTEGER#` |
| DATE | 날짜 | `#baseDate:DATE#` |
| TIMESTAMP | 타임스탬프 | `#regDtm:TIMESTAMP#` |
| DECIMAL | 소수 | `#rate:DECIMAL#` |

### 7.3 XSQL 작성 주의사항

- **COMMIT/ROLLBACK 절대 금지** (프레임워크가 트랜잭션 관리)
- SQL ID는 `[동사형]` 또는 `[동사형]+[명사형]` 네이밍
- SQL ID 동사 접두사: insert/update/delete/select/selectList
- parameterClass와 resultClass는 `map` 사용
- XSQL 파일명은 DU 클래스명과 동일

---

## 8. IDataSet / IRecordSet / IRecord API

### 8.1 IDataSet (DTO)

IDataSet은 Field, FieldMap, RecordSet, Record를 담는 범용 DTO 컨테이너다.

```
IDataSet
├── Field      : 단일 key-value (String key → Object value)
├── FieldMap   : key-value Map
├── RecordSet  : 헤더 기반 List 구조
└── Record     : RecordSet의 한 건 (row)
```

**주요 API**:

```java
// 생성
IDataSet ds = new DataSet();

// Field 조작 (Map-like)
ds.put("key", value);                  // 값 설정
String val = ds.getString("key");      // 문자열 조회
boolean has = ds.containsKey("key");   // 키 존재 확인
ds.remove("key");                      // 키 삭제
int size = ds.size();                  // 크기
Map map = ds.toMap();                  // Map 변환
ds.putAll(map);                        // Map 일괄 설정

// RecordSet 조작
ds.putRecordSet("rsName", recordSet);  // RecordSet 설정
IRecordSet rs = ds.getRecordSet("rsName"); // RecordSet 조회
```

### 8.2 IRecordSet (List 구조)

IRecordSet은 헤더 기반 List 구조로, COBOL의 OCCURS 배열에 대응한다.

```java
// 생성 방법 1: 헤더 배열로 생성
IRecordSet rs = new RecordSet(new String[]{"name", "price", "desc"});

// 생성 방법 2: 빈 RecordSet 생성 후 헤더 추가
IRecordSet rs = new RecordSet();
rs.addHeader("name");
rs.addHeader("price");

// 생성 방법 3: Map으로 생성
IRecordSet rs = new RecordSet(map);

// 생성 방법 4: DB 조회 결과 (DU에서)
IRecordSet rs = dbSelectMulti("selectList", param);

// Record 추가
IRecord rec = rs.newRecord();
rec.set("name", "홍길동");
rec.set("price", 1000);

// Record 조회
int count = rs.getRecordCount();
IRecord rec = rs.getRecord(0);       // 인덱스로 조회

// Record 삭제
rs.removeRecord(0);

// RecordSet 복제
IRecordSet cloned = rs.clone();
IRecordSet partial = rs.clone(new String[]{"name", "price"});  // 특정 헤더만

// RecordSet → Map 변환
Map recMap = rs.getRecordMap(0);      // 특정 인덱스 Record를 Map으로
List<Map> recMaps = rs.getRecordMaps(); // 전체 Record를 List<Map>으로
```

### 8.3 IRecord (Row)

```java
// 값 설정
rec.set("name", "홍길동");
rec.set(0, "홍길동");           // 인덱스로 설정

// 값 조회 (typed getter)
String name = rec.getString("name");
int count = rec.getInt("count");
long amount = rec.getLong("amount");
float rate = rec.getFloat("rate");
double ratio = rec.getDouble("ratio");
BigDecimal money = rec.getBigDecimal("money");
byte[] data = rec.getByteArray("data");
IRecordSet nested = rec.getRecordSet("subRs");
Object obj = rec.getObject("any");

// 인덱스로도 조회 가능
String val = rec.getString(0);
```

---

## 9. IOnlineContext / CommonArea

### 9.1 IOnlineContext

온라인 거래의 컨텍스트 정보를 담는 객체. 모든 메서드에 파라미터로 전달된다.

```java
// ILog 획득
ILog log = getLog(onlineCtx);

// CommonArea 획득
CommonArea ca = getCommonArea(onlineCtx);
```

### 9.2 CommonArea

YCCOMMON(z-KESA)에 대응하는 공통정보 영역. JICOM(전행공통), 도메인별 공통영역 등 포함.

| 영역 | z-KESA 대응 | 설명 |
|------|------------|------|
| 시스템 공통 | SICOM | 프레임워크 제어 영역 |
| 입력 공통 | BICOM | 거래 입력 기본정보 |
| 출력 공통 | BOCOM | 출력 폼, 에러정보 |
| 전행공통정보 | JICOM | 일자정보, 부점정보 등 |

```java
// CommonArea에서 값 조회
CommonArea ca = getCommonArea(onlineCtx);
String groupCoCd = ca.getGroupCoCd();     // 그룹회사코드
String branchCd = ca.getBranchCd();       // 부점코드
String txDate = ca.getTxDate();           // 거래처리기준일
```

---

## 10. 컴포넌트 호출 방법

### 10.1 호출 방식 요약

| 호출 유형 | API | 대상 | 트랜잭션 |
|----------|-----|------|---------|
| 컴포넌트 내 직접 호출 | `@BizUnitBind` + 메서드 호출 | 같은 컴포넌트 FM/DM/DBM | 동일 트랜잭션 |
| 타 컴포넌트 공유메서드 | `callSharedMethod()` / `callSharedMethodByDirect()` | 타 컴포넌트 공유 FM/DM/DBM | 동일 트랜잭션 |
| 타 컴포넌트 서비스 | `callService()` | 타 컴포넌트 PM | 동일 트랜잭션 |
| 트랜잭션 분리 호출 | `callMethodByRequiresNew()` | 같은 컴포넌트 내에서도 사용 가능 | **트랜잭션 분리** |
| 타 WAS/인스턴스 호출 | `callRemoteService()` | 타 WAS 노드의 PM | **트랜잭션 분리** (Remote) |

### 10.2 같은 컴포넌트 내 호출 (직접 호출)

`@BizUnitBind`로 DU/FU를 주입받아 직접 호출한다:

```java
@BizUnitBind
private FUSampleName fuSampleName;

@BizUnitBind
private DUTableNameA duTableNameA;

// 호출
IDataSet result = fuSampleName.testFm(requestData, onlineCtx);
IDataSet dbResult = duTableNameA.selectSampleData(requestData, onlineCtx);
```

### 10.3 타 컴포넌트 공유 FM/DM 호출 (callSharedMethod)

타 컴포넌트의 클래스는 import 불가하므로, FW Reflection API로 간접 호출한다:

```java
// callSharedMethodByDirect - 타 컴포넌트의 공유 FM/DM/DBM 호출
IDataSet result = callSharedMethodByDirect(
    "com.kbstar.app.targetComponentId",  // 대상 컴포넌트 ID
    "FUClassName.methodName",            // 대상 클래스.메서드명
    requestData,                         // 입력 IDataSet
    onlineCtx                            // 컨텍스트
);
```

### 10.4 타 컴포넌트 PM 호출 (callService)

같은 WAS 인스턴스 내의 타 컴포넌트 PM을 호출한다:

```java
// callService - 동일 WAS 내 타 컴포넌트 PM 호출
IDataSet result = callService(txCode, requestData, onlineCtx);
```

### 10.5 타 WAS/인스턴스 PM 호출 (callRemoteService)

다른 WAS 노드/인스턴스에 있는 PM을 호출한다. 트랜잭션이 분리된다:

```java
// callRemoteService - 타 WAS 노드의 PM 호출 (트랜잭션 분리)
IDataSet result = callRemoteService(txCode, requestData, onlineCtx);
```

### 10.6 트랜잭션 분리 호출 (callMethodByRequiresNew)

동일 컴포넌트 내에서도 트랜잭션 분리가 필요한 경우 사용한다:

```java
// callMethodByRequiresNew - 트랜잭션 분리하여 호출
IDataSet result = callMethodByRequiresNew(
    "FUClassName.methodName",
    requestData,
    onlineCtx
);
```

### 10.7 호출 범위별 정리

```
┌─────────────────────────────────────────────────────────┐
│ 동일 WAS 노드                                            │
│  ┌──────────────────────────────────────────────────┐   │
│  │ 동일 인스턴스                                       │   │
│  │  ┌─────────────────────────────────────────┐     │   │
│  │  │ 동일 어플리케이션                           │     │   │
│  │  │  ┌──────────────────────────────┐       │     │   │
│  │  │  │ 동일 컴포넌트                  │       │     │   │
│  │  │  │  → 직접 호출 (@BizUnitBind)   │       │     │   │
│  │  │  └──────────────────────────────┘       │     │   │
│  │  │  → callSharedMethod (FM/DM)              │     │   │
│  │  │  → callService (PM)                      │     │   │
│  │  └─────────────────────────────────────────┘     │   │
│  │  → callSharedMethod (타 어플리케이션 FM)           │   │
│  │  → callService (타 어플리케이션 PM)                │   │
│  └──────────────────────────────────────────────────┘   │
│  → callRemoteService (타 인스턴스, 트랜잭션 분리)          │
└─────────────────────────────────────────────────────────┘
  → callRemoteService (타 WAS 노드, 트랜잭션 분리)
```

---

## 11. 예외 처리 (Exception Handling)

### 11.1 BusinessException

n-KESA의 표준 예외 클래스. 에러코드 + 조치코드 + 맞춤메시지로 구성.

```java
// 생성자
new BusinessException("에러코드", "조치메시지코드", "맞춤메시지")
new BusinessException("에러코드", "조치메시지코드", "맞춤메시지", cause)
```

### 11.2 PM에서의 예외 처리 패턴 (필수)

```java
@BizMethod("PM 설명")
public IDataSet pmXXXXXXXXXX(IDataSet requestData, IOnlineContext onlineCtx) {
    IDataSet responseData = new DataSet();
    try {
        // 업무 로직
    } catch (BusinessException e) {
        throw e;                        // BusinessException은 그대로 re-throw
    } catch (Exception e) {
        throw new BusinessException("에러코드", "조치코드", "맞춤메시지", e);
    }
    return responseData;
}
```

### 11.3 FM/DM에서의 예외 처리

- FM/DM에서는 try-catch 불필요 (PM에서 최종 처리)
- 업무 조건 오류 시 직접 `throw new BusinessException(...)` 가능
- **임의 Rollback/Commit 절대 금지** (프레임워크가 관리)

---

## 12. 로깅 (ILog)

ILog 인터페이스는 Apache commons-logging과 호환된다.

```java
ILog log = getLog(onlineCtx);

log.debug("디버깅 메시지: " + value);
log.info("정보 메시지: " + value);
log.warn("경고 메시지: " + value);
log.error("에러 메시지: " + value);
log.error("에러 메시지", exception);       // 예외 로그
```

**주의**:
- 운영 환경에서는 debug 레벨이 OFF → 성능 영향 최소화
- 민감정보(계좌번호, 주민번호 등) 로그 출력 금지

---

## 13. 배치 프로그램 (BatchUnit)

### 13.1 BU 템플릿 코드

```java
package com.kbstar.app.common.batch;

import com.kbstar.sqc.batch.base.BatchUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;

@BizBatch("배치 설명")
public class BUSampleBatch extends BatchUnit {

    @Override
    public IDataSet execute(IDataSet requestData) {
        IDataSet responseData = new DataSet();

        // TODO 배치 업무 로직

        return responseData;
    }

    @Override
    public void beforeExecute(IDataSet requestData) {
        // 배치 실행 전 처리 (선택)
    }

    @Override
    public void afterExecute(IDataSet requestData, IDataSet responseData) {
        // 배치 실행 후 처리 (선택)
    }
}
```

### 13.2 배치 실행 구조

- 독립 JVM으로 실행 (온라인 WAS와 분리)
- 쉘 스크립트로 기동: `execute()` → `beforeExecute()` → `execute()` → `afterExecute()`
- 배치에서는 `IOnlineContext` 없음 → CommonArea 직접 사용 불가

---

## 14. 코딩 제약사항

### 14.1 멤버 필드 금지

Unit 클래스는 싱글톤이므로 인스턴스 변수를 사용하면 스레드 안전성 문제 발생.

```java
// ❌ 금지
public class FUSample extends FunctionUnit {
    private String someValue;        // 절대 금지!
    private List<String> someList;   // 절대 금지!
}

// ✅ 허용 - @BizUnitBind만 가능
public class FUSample extends FunctionUnit {
    @BizUnitBind
    private DUTableNameA duTableNameA;  // OK
}
```

### 14.2 BigDecimal 필수 규칙

모든 금액 연산은 반드시 `BigDecimal` 사용:

```java
// ❌ 금지
BigDecimal bad = new BigDecimal(0.1);           // double 정밀도 손실!

// ✅ 올바른 생성
BigDecimal good1 = BigDecimal.valueOf(0.1);     // valueOf 사용
BigDecimal good2 = new BigDecimal("0.1");       // String 생성자 사용
BigDecimal zero = BigDecimal.ZERO;              // 상수 사용
```

### 14.3 상수(Constants) 규칙

```java
// 패키지: com.kbstar.[appCode].[componentId].consts
// 클래스명: C + CamelCase + Consts
package com.kbstar.app.componentId.consts;

public class CSampleConsts {
    public static String STATUS_OK = "00";          // public static (final 붙이지 않음)
    public static String STATUS_ERROR = "09";
    public static String STATUS_ABNORMAL = "98";
    public static String STATUS_SYSERROR = "99";
}
```

**주의**: `final` 키워드를 붙이면 컴파일 시 인라이닝되어 핫디플로이가 안됨 → `public static`만 사용

### 14.4 private 메서드 네이밍

```java
// private 메서드는 언더스코어(_) 접두사
private IDataSet _calculateAmount(IDataSet data) {
    // ...
}
```

---

## 15. 파라미터 전달 규칙

원본 requestData를 다른 메서드에 직접 전달하지 않고, 새 DataSet을 만들어 전달한다.

```java
// ❌ 원본 직접 전달 금지
IDataSet result = duSample.selectData(requestData, onlineCtx);

// ✅ 새 DataSet 생성 후 전달
IDataSet param = new DataSet();
param.put("key1", requestData.getString("inputKey1"));
param.put("key2", requestData.getString("inputKey2"));
IDataSet result = duSample.selectData(param, onlineCtx);

// ✅ 또는 clone 사용
IDataSet param = requestData.clone();
IDataSet result = duSample.selectData(param, onlineCtx);
```

---

## 16. 어노테이션 정리

| 어노테이션 | 대상 | 설명 |
|-----------|------|------|
| `@BizUnit("설명")` | PU/FU/DU 클래스 | Unit 클래스 선언 |
| `@BizMethod("설명")` | PM/FM/DM 메서드 | 비즈니스 메서드 선언 |
| `@BizBatch("설명")` | BU 클래스 | 배치 Unit 클래스 선언 |
| `@BizUnitBind` | FU/DU 참조 필드 | 싱글톤 Unit 주입 (같은 컴포넌트 내) |

---

## 17. 명명 규칙 (Naming Convention)

### 17.1 온라인 명명 규칙

| 대상 | 규칙 | 예시 |
|------|------|------|
| 패키지 | com.kbstar.[appCode3].[componentId] | com.kbstar.kji.enbncmn |
| PU 클래스 | PU(대문자) + [명사형 CamelCase] | PUCreditEvaluation |
| FU 클래스 | FU(대문자) + [명사형 CamelCase] | FUCreditHistory |
| FU (전행공통) | FUBc + [명사형 CamelCase] | FUBcNumbering |
| DU (기본) | DU(대문자) + [테이블명] + [A-Z] | DUThkipb110A |
| DU (옵션) | DU(대문자) + [화면아이디] + [A-Z] | DUEDU12345A |
| PM | pm(소문자) + [거래코드10자리] | pmEDU1234501 |
| FM | [동사형] + [명사형] CamelCase | getCreditHistory |
| DM | [동사형] 또는 [동사형]+[명사형] | selectCreditEvalList |
| XSQL 파일 | DU와 1:1 동일 이름 | DUThkipb110A.xml |
| SQL ID | [동사형] or [동사형]+[명사형] | selectCreditEval |
| 상수 패키지 | .consts | com.kbstar.app.cmp.consts |
| 상수 클래스 | C + CamelCase + Consts | CCreditConsts |
| 상수 값 | UPPER_CASE | MAX_RETRY_COUNT |

### 17.2 FM 동사 접두사

| 접두사 | 의미 | 예시 |
|--------|------|------|
| register~ | 등록 | registerCreditEval |
| modify~ | 수정 | modifyCreditScore |
| delete~ | 삭제 | deleteCreditHistory |
| get~ | 단건 조회 | getCreditInfo |
| getList~ | 다건 조회 | getListCreditHistory |
| is~ | 판단 | isCreditValid |
| validate~ | 검증 | validateCreditInput |
| calculate~ | 계산 | calculateCreditScore |
| getNoOf~ | 건수 조회 | getNoOfCreditEval |
| manage~ | 관리 (등록/수정/삭제 통합) | manageCreditEval |

### 17.3 DM 동사 접두사

| 접두사 | 의미 |
|--------|------|
| insert~ | INSERT |
| update~ | UPDATE |
| delete~ | DELETE |
| select~ | SELECT 단건 |
| selectList~ | SELECT 다건 |

### 17.4 배치 명명 규칙

| 대상 | 규칙 | 예시 |
|------|------|------|
| 프로젝트 | [어플리케이션코드]-nbatch | kji-nbatch |
| 패키지 | com.kbstar.[appCode].[common].batch | com.kbstar.kji.common.batch |
| BU 클래스 | BU(대문자) + [명사형] | BUCreditBatchProcess |

---

## 18. z-KESA → n-KESA 계층 매핑 (M/F 전환 기준)

COBOL z-KESA의 프로그램 계층화 원칙과 n-KESA Unit 계층의 대응 관계:

| z-KESA (COBOL) | 역할 | n-KESA (Java) | 역할 |
|----------------|------|--------------|------|
| **AS** | 거래 단위. 하위 계층 호출하여 거래 완성 | **PU + PM** | 거래 진입점. FM/DM 호출하여 거래 완성 |
| **PC** | 거래를 절차의 유사성/연관성으로 분류한 프로세스 단위 | **FU + FM** | 업무 로직 처리, 프로세스 제어 |
| **DC** | 데이터 CRUD 관장. 데이터 처리 비즈니스 로직 담당 | **DU + DM / DBIO** | 데이터 조회(DU), CUD(DBIO) |
| **FC** | 데이터 참조 없는 어플리케이션 내 로직/유틸리티 | **FU + FM** | 유틸리티성 로직 (DB 접근 없음) |
| **BC** | 전행 차원 업무기능 공통 사용 | **FUBc* (전행공통 FU)** | callSharedMethodByDirect로 호출 |
| **IC** | 공통정보 조회 (전행공통, 고객, 계좌 등) | **FUBc* / CommonArea** | 전행공통 유틸리티 또는 CommonArea |

**전환 시 주의사항**:
- z-KESA의 DC는 n-KESA에서 **DU(조회)와 DBIO(CUD)로 분리**된다
- z-KESA의 PC/FC는 n-KESA에서 모두 **FU**로 통합된다
- z-KESA의 BC/IC는 n-KESA에서 **전행공통 FUBc* 클래스**로 대응된다
- z-KESA `#DYCALL`은 같은 컴포넌트면 `@BizUnitBind` 직접 호출, 타 컴포넌트면 `callSharedMethodByDirect`로 전환

---

## 19. z-KESA → n-KESA 상세 매핑 참조

| z-KESA (COBOL) 요소 | n-KESA (Java) 변환 대응 |
|---------------------|----------------------|
| AS 프로그램 | PU (ProcessUnit) 클래스 + PM 메서드 |
| DC 프로그램 | DU (DataUnit) 클래스 + DM 메서드 + XSQL |
| IC/FC/BC 프로그램 | FU (FunctionUnit) 클래스 + FM 메서드 |
| YCCOMMON (공통영역) | IOnlineContext + CommonArea |
| 카피북 (COPY) | IDataSet / DTO 클래스 |
| #DYCALL | @BizUnitBind + 메서드 호출 또는 callSharedMethodByDirect |
| #ERROR | throw new BusinessException(에러코드, 조치코드, 메시지) |
| #OKEXIT | return responseData |
| #GETOUT | IDataSet responseData = new DataSet() |
| #USRLOG | log.debug() / log.info() |
| #BOFMID | 응답 데이터에 폼 ID 설정 |
| DBIO SELECT-CMD-N | dbSelect(sqlId, param) |
| DBIO SELECT 다건 | dbSelectMulti(sqlId, param) → IRecordSet |
| DBIO INSERT-CMD-Y | dbInsert(sqlId, param) |
| DBIO UPDATE-CMD-Y | dbUpdate(sqlId, param) |
| DBIO DELETE-CMD-Y | dbDelete(sqlId, param) |
| SQLIO (복합 SELECT) | XSQL에 복합 WHERE 조건 SELECT 작성 |
| COPY YCDBSQLA | DU 기본 DB 접근 메서드 (상속으로 제공) |
| CO-STAT-OK ('00') | 정상 return responseData |
| CO-STAT-ERROR ('09') | throw new BusinessException("에러코드", ...) |
| CO-STAT-ABNORMAL ('98') | throw new BusinessException("98", ...) |
| CO-STAT-SYSERROR ('99') | throw new BusinessException("99", ...) |
| COND-DBIO-OK | dbSelect 정상 반환 |
| COND-DBIO-MRNF (Not Found) | dbSelect 결과 null 또는 empty 체크 |
| COND-DBIO-DUPM (중복) | DuplicateKeyException catch |
| OCCURS 배열 | IRecordSet + IRecord |
| PIC X(n) 문자열 | String |
| PIC 9(n) 숫자 | int / long |
| PIC S9(n)V9(m) 금액 | BigDecimal |
| WORKING-STORAGE 변수 | 메서드 내 로컬 변수 |
