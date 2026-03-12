# n-KESA 자바 개발 가이드 (PoC 및 실전 코딩용)

본 문서는 KB국민은행 C2J 변환 PoC를 위한 표준 프레임워크 기반의 자바 코드 작성 지침을 정리한 것입니다.

---

## 1. 어플리케이션 아키텍처 및 패키지 구조
모든 클래스는 프레임워크가 지정한 계층 구조를 따라야 하며, 전용 베이스 클래스를 상속받아야 합니다.

| 계층 | 역할 | 패키지 경로 (예시) | 상속 클래스 |
| :--- | :--- | :--- | :--- |
| **PU** | Presentation Unit (채널 인터페이스) | `kbs.***.pu` | `KesaBasePU` |
| **FU** | Functional Unit (비즈니스 로직) | `kbs.***.fu` | `KesaBaseFU` |
| **DU** | Data Unit (DB 액세스) | `kbs.***.du` | `KesaBaseDU` |

---

## 2. 필수 Java 코딩 패턴

### 2.1 데이터 객체 (IDataSet, IDataMap) 활용
n-KESA는 일반적인 VO/DTO 대신 프레임워크 전용 Map 객체를 사용합니다.

```java
// 1. 데이터 추출 (Request)
IDataMap inputMap = requestData.getDataMap("INPUT_MAP");
String userId = inputMap.getString("USER_ID");

// 2. 데이터 설정 (Response)
IDataMap resultMap = createDataMap();
resultMap.put("USER_NM", "홍길동");
responseData.putDataMap("OUTPUT_MAP", resultMap);

```

### 2.2 FU에서 DU 호출 (Shared Method)

비즈니스 로직(FU)에서 DB 작업(DU)을 수행할 때는 반드시 `callSharedMethod`를 사용합니다.

```java
// FU 클래스 내부 예시
public IDataSet selectUserInfo(IDataSet requestData, IOnlineContext onlineCtx) {
    IDataMap param = requestData.getDataMap("IN_NODE");
    
    // DU의 메소드를 호출 (유닛명, 메소드명, 파라미터, 컨텍스트)
    IDataSet result = callSharedMethod("UserInfoDU", "selectUserDetail", param, onlineCtx);
    
    return result;
}

```

---

## 3. Data Unit (DU) 및 SQL (XSQL) 작성 규칙

### 3.1 SQL 작성 표준 (XSQL 파일)

* **스키마 필수:** 모든 테이블명 앞에 스키마를 명시합니다 (예: `INST1.TBT_COMM_CD`).
* **주석:** `--`는 금지되며, 반드시 `/* ... */`를 사용합니다.
* **Alias:** Java Map의 Key와 매핑되도록 큰따옴표(`"`)를 사용하여 CamelCase로 지정합니다.
* **바인딩:** `#변수명#` 형식을 사용합니다.

```xml
<select id="selectUserDetail" parameterClass="map" resultClass="hmap">
    SELECT  USER_ID   AS "userId"
          , USER_NM   AS "userNm"
          , JOIN_DT   AS "joinDt"
    FROM    INST1.TBT_USER_INFO
    WHERE   USER_ID = #userId#
</select>

```

### 3.2 DU 내 주요 DB API

DU 클래스 내에서 SQL을 실행할 때 사용하는 핵심 메소드입니다.

| 메소드명 | 용도 | 리턴 타입 |
| --- | --- | --- |
| `dbSelectSingle` | 단건 조회 | `IDataMap` |
| `dbSelect` | 다건 조회 | `IDataList` |
| `dbInsert` | 데이터 등록 | `int` (영향받은 행 수) |
| `dbUpdate` | 데이터 수정 | `int` |
| `dbDelete` | 데이터 삭제 | `int` |

---

## 4. 공통 유틸리티 및 예외 처리

### 4.1 핵심 유틸리티 클래스

자바 기본 API보다 성능과 표준이 검증된 프레임워크 유틸리티를 사용하십시오.

* **문자열:** `StringUtil.isEmpty(str)`, `StringUtil.nullToEmpty(str)`
* **날짜:** `DateUtil.getCurrentDate()`, `DateUtil.getFormatDate(date, "yyyyMMdd")`
* **숫자/연산:** `NumberUtil` (나눗셈 오차 방지를 위해 연산 마지막 단계에서 수행 권장)

### 4.2 예외 처리 (Exception)

비즈니스 로직 오류 발생 시 프레임워크 예외 객체를 던집니다.

```java
if (inputMap.get("USER_ID") == null) {
    throw new BizException("ERR_CODE_001", new String[]{"사용자 ID가 없습니다."});
}

```

---

## 5. 개발 생산성 팁 (IDE 단축키)

* **Ctrl + Space:** 컨텍스트 어시스트 (특히 `n_` 입력 후 사용 시 프레임워크 코드 템플릿 호출 가능).
* **Alt + Shift + A:** 열 편집 모드 (멀티 라인 변수 수정 시 유용).
* **Ctrl + 마우스 오버:** `callSharedMethod` 호출부에서 해당 FU/DU 소스 코드로 즉시 이동.
* **SQL 타임아웃:** 기본 150초로 설정되어 있으며, 대량 처리 시 별도 협의가 필요합니다.

---

*본 문서는 2025 C2J 변환 PoC 전용 가이드를 요약한 것입니다.*
