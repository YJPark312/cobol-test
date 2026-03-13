# n-KESA 공통 유틸리티 프로그램 가이드

> **출처**: C2J변환솔루션PoC용_n-KESA공통유틸리티_가이드_AWS.pdf
> **목적**: 변환/검증 에이전트가 공통 유틸리티 호출을 Java로 변환 시 참조

---

## 1. 공통 유틸리티 개요

### 1.1 호출 방식 (공통 규칙)

모든 공통 유틸리티(FUBc* 클래스)는 `callSharedMethodByDirect()`로 호출하며, IDataSet을 통해 파라미터를 전달한다. FUBc* 클래스는 `com.kbstar.kji.enbncmn.biz` 패키지에 위치하며, 모두 `FunctionUnit`을 상속한다.

```java
// 공통 유틸리티 호출 패턴
IDataSet req = new DataSet();
req.put("inField1", value1);              // 입력값 SET
req.put("inField2", value2);

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",            // 공통 컴포넌트 ID
    "FUBcClassName.methodName",           // 클래스.메서드명
    req,                                  // 입력 IDataSet
    onlineCtx                             // 컨텍스트
);

// 결과 확인
String outValue = result.getString("outField1");
```

### 1.2 공통 유틸리티 목록 (주요)

| Java 클래스 | 주요 메서드 | z-KESA 대응 |
|------------|-----------|------------|
| FUBcNumbering | getAcnoNumbering, getMgtNoNumbering | 채번 유틸리티 |
| FUBcValidation | validationPassword | 비밀번호 검증 |
| FUBcCode | getCurrencyCode | 코드 조회 |
| FUBcRate | getBaseExchangeRate, getMarketExchangeRate, getAvgExchangeRate | 환율 조회 |
| FUBcBranch | getBranchInfo, getSubordinateBranches | CJIBR01/03 대응 |
| FUBcMessage | getErrorMessage | CJIER01 대응 |
| FUBcEmployee | getEmployeeInfo | CJIHR01 대응 |
| FUBcBase | 범용 기본 유틸리티 | 공통 기반 |
| FUBcDate | getBusinessDate, addDays, addMonths | 일자 계산 |
| FUBcDateCheck | isBusinessDate, isHoliday | 영업일 체크 |
| FUBcDateChange | convertDateFormat | 일자 변환 |
| FUBcChange | convertHanjaToHangul, convertFullToHalf | 문자 변환 |
| FUBcEcc | encrypt, decrypt | 암복호화 |
| FUBcAuthorization | checkAuthorization | 권한 체크 |
| FUBcTransaction | callTransaction | 거래 호출 |

---

## 2. FUBcNumbering - 채번 유틸리티

### 2.1 getAcnoNumbering - 계좌번호 채번

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcNumbering |
| 메서드 | getAcnoNumbering |
| z-KESA 대응 | 계좌번호 채번 공통모듈 |

**기능**: 계좌번호를 신규 채번하여 반환한다.

#### 입력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| inGroupCoCd | 그룹회사코드 | String |
| inDmndNSbjctCd | 수요대상과목코드 | String |
| inBrncd | 부점코드 | String |

#### 출력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| outAcno | 계좌번호 | String |
| outEdtAcno | 편집계좌번호 | String |
| outDefinsNSbjctCd | 확정대상과목코드 | String |
| outSerno | 일련번호 | String |
| outChkDigit | 체크디지트 | String |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inGroupCoCd", ca.getGroupCoCd());
req.put("inDmndNSbjctCd", "301");
req.put("inBrncd", "4004");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcNumbering.getAcnoNumbering",
    req, onlineCtx
);

String acno = result.getString("outAcno");
String edtAcno = result.getString("outEdtAcno");
```

---

### 2.2 getMgtNoNumbering - 관리번호 채번

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcNumbering |
| 메서드 | getMgtNoNumbering |
| z-KESA 대응 | 관리번호 채번 공통모듈 |

**기능**: 관리번호를 신규 채번하여 반환한다.

#### 입력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| inGroupCoCd | 그룹회사코드 | String |
| inUapplCd | 업무어플리케이션코드 | String |
| inNbringIdnfiCd | 채번식별코드 | String |
| inBrncd | 부점코드 | String |

#### 출력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| outMgtNo | 관리번호 | String |
| outEdtMgtNo | 편집관리번호 | String |
| outNbringSerno | 채번일련번호 | String |
| outChkDigit | 체크디지트 | String |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inGroupCoCd", ca.getGroupCoCd());
req.put("inUapplCd", "IPB");
req.put("inNbringIdnfiCd", "01");
req.put("inBrncd", "4004");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcNumbering.getMgtNoNumbering",
    req, onlineCtx
);

String mgtNo = result.getString("outMgtNo");
```

---

## 3. FUBcValidation - 비밀번호 검증

### 3.1 validationPassword - 비밀번호 제한 체크

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcValidation |
| 메서드 | validationPassword |
| z-KESA 대응 | 비밀번호 제한 체크 유틸리티 |

**기능**: 비밀번호 설정 시 개인정보(주민번호, 전화번호 등) 포함 여부를 검증한다.

#### 입력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| inPpsnCoprCuniqno | 개인법인고유번호 | String |
| inPwd | 비밀번호 | String |
| inOwhusTelno | 자택전화번호 | String |
| inWplcTelno | 직장전화번호 | String |
| inCphnno | 휴대폰번호 | String |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inPpsnCoprCuniqno", custNo);
req.put("inPwd", newPassword);
req.put("inOwhusTelno", homeTel);
req.put("inWplcTelno", officeTel);
req.put("inCphnno", mobileNo);

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcValidation.validationPassword",
    req, onlineCtx
);
// 검증 실패 시 BusinessException 발생
```

---

## 4. FUBcCode - 코드 조회

### 4.1 getCurrencyCode - 통화코드 조회

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcCode |
| 메서드 | getCurrencyCode |
| z-KESA 대응 | 통화코드 조회 유틸리티 |

**기능**: 통화코드 정보를 조회하여 List로 반환한다.

#### 입력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| inGroupCoCd | 그룹회사코드 | String |
| inDstcd | 구분코드 | String |
| inCncycdSerno | 통화코드일련번호 | String |
| inCncycd | 통화코드 | String |
| inCrncyISOcd | 통화ISO코드 | String |

#### 출력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| outArayCnt | 배열건수 | int |
| (RecordSet) | 통화코드 목록 | IRecordSet |
| → outCncycd | 통화코드 | String |
| → outUseYn | 사용여부 | String |
| → outCrncyIsocd | 통화ISO코드 | String |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inGroupCoCd", ca.getGroupCoCd());
req.put("inDstcd", "1");
req.put("inCncycd", "USD");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcCode.getCurrencyCode",
    req, onlineCtx
);

int count = result.getInt("outArayCnt");
IRecordSet rs = result.getRecordSet("outList");
for (int i = 0; i < rs.getRecordCount(); i++) {
    IRecord rec = rs.getRecord(i);
    String cncycd = rec.getString("outCncycd");
    String useYn = rec.getString("outUseYn");
}
```

---

## 5. FUBcRate - 환율 조회

### 5.1 getBaseExchangeRate - 기준환율 조회

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcRate |
| 메서드 | getBaseExchangeRate |
| z-KESA 대응 | 기준환율 조회 유틸리티 |

**기능**: 특정 통화의 기준환율 정보를 조회한다.

#### 입력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| inGroupCoCd | 그룹회사코드 | String |
| inDstcd | 구분코드 | String |
| inOutptDstcd | 출력구분코드 | String |
| inBaseYmd | 기준년월일 | String |
| inCncycd | 통화코드 | String |
| inExrtAplyNth | 환율적용차수 | String |

#### 출력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| rtnStat | 리턴상태 (00=정상, 07=NOTFOUND) | String |
| outBaseYmd | 기준년월일 | String |
| outExrtAplyNth | 환율적용차수 | String |
| outArayCnt | 배열건수 | int |
| (RecordSet) | 환율목록 | IRecordSet |
| → outBaseExrt | 기준환율 | BigDecimal |

**rtnStat 값**:
| 코드 | 설명 |
|------|------|
| 00 | 정상 |
| 07 | NOTFOUND (해당 환율 없음) |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inGroupCoCd", ca.getGroupCoCd());
req.put("inDstcd", "1");
req.put("inOutptDstcd", "1");
req.put("inBaseYmd", "20260313");
req.put("inCncycd", "USD");
req.put("inExrtAplyNth", "01");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcRate.getBaseExchangeRate",
    req, onlineCtx
);

String rtnStat = result.getString("rtnStat");
if ("00".equals(rtnStat)) {
    IRecordSet rs = result.getRecordSet("outBaseExrtList");
    for (int i = 0; i < rs.getRecordCount(); i++) {
        BigDecimal baseExrt = rs.getRecord(i).getBigDecimal("outBaseExrt");
    }
} else if ("07".equals(rtnStat)) {
    // NOTFOUND 처리
}
```

---

### 5.2 getMarketExchangeRate - 시장환율 조회

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcRate |
| 메서드 | getMarketExchangeRate |
| z-KESA 대응 | 시장환율 조회 유틸리티 |

**기능**: 특정 통화의 시장환율 정보를 조회한다. 구조는 getBaseExchangeRate와 유사.

#### 입력/출력 항목

기준환율 조회(getBaseExchangeRate)와 동일한 입출력 구조. rtnStat으로 결과 확인.

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inGroupCoCd", ca.getGroupCoCd());
req.put("inDstcd", "1");
req.put("inBaseYmd", "20260313");
req.put("inCncycd", "USD");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcRate.getMarketExchangeRate",
    req, onlineCtx
);
```

---

### 5.3 getAvgExchangeRate - 평균환율 조회

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcRate |
| 메서드 | getAvgExchangeRate |
| z-KESA 대응 | 평균환율 조회 유틸리티 |

**기능**: 기간별 평균환율을 조회한다.

#### 입력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| inGroupCoCd | 그룹회사코드 | String |
| inDstcd | 구분코드 | String |
| inCncycd | 통화코드 | String |
| inBaseStartYmDd | 기준시작년월일 | String |
| inBaseEndYmDd | 기준종료년월일 | String |

#### 출력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| rtnStat | 리턴상태 (00=정상, 07=NOTFOUND) | String |
| outDealBaseExrt | 거래기준환율 | BigDecimal |
| outBzoprNoday | 영업일수 | int |
| outAvgTargetNoitm | 평균대상건수 | int |
| outAmndAdBaseExrt | 수정기준환율 | BigDecimal |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inGroupCoCd", ca.getGroupCoCd());
req.put("inDstcd", "1");
req.put("inCncycd", "USD");
req.put("inBaseStartYmDd", "20260101");
req.put("inBaseEndYmDd", "20260313");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcRate.getAvgExchangeRate",
    req, onlineCtx
);

BigDecimal avgRate = result.getBigDecimal("outDealBaseExrt");
```

---

## 6. FUBcBranch - 부점 조회

### 6.1 getBranchInfo - 부점기본 조회

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcBranch |
| 메서드 | getBranchInfo |
| z-KESA 대응 | CJIBR01 (부점기본 조회) |

**기능**: 조회 요청일자 시점의 부점기본 정보를 조회한다.

**주요 규칙**:
- 부점코드는 숫자로 입력 (공백/'0000' 불가)
- 기준일 미입력 시 현재시점(CommonArea의 거래처리기준일) 기준 조회
- 폐쇄부점 조회 시 리턴상태코드 '07' 반환

#### 입력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| inGroupCoCd | 그룹회사코드 | String |
| inBrncd | 부점코드 | String |
| inBaseYmd | 기준년월일 (미입력 시 현재) | String |

#### 출력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| outBrncd | 부점코드 | String |
| outBrnHanglName | 부점한글명 | String |
| outBrnHAbrvnName | 부점한글약칭명 | String |
| outBrnDstcd | 부점구분코드 | String |
| outOpnnYmd | 개점년월일 | String |
| outClsrYmd | 폐쇄년월일 | String |
| outBnkCd | 은행코드 | String |
| outIntgraBrncd | 통합부점코드 (폐쇄부점인 경우) | String |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inGroupCoCd", ca.getGroupCoCd());
req.put("inBrncd", "4004");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcBranch.getBranchInfo",
    req, onlineCtx
);

String brnName = result.getString("outBrnHanglName");
```

---

### 6.2 getSubordinateBranches - 관할/소속부점코드 조회

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcBranch |
| 메서드 | getSubordinateBranches |
| z-KESA 대응 | CJIBR03 (관할부점 조회) |

**기능**: 입력 부점에 대해 구분코드별 소속 부점코드 목록을 조회한다.

**구분코드**:
| 코드 | 설명 |
|------|------|
| '1' | 영업지원본부부점코드 |
| '2' | 대출실행팀 부점코드 |
| '3' | 원본서류보관 부점코드 |
| '4' | 프로세스센터 부점코드 |
| '5' | 사업본부 부점코드 |
| '6' | 어음교환소 모점코드 |
| '7' | 출장소모점부점코드 |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inGroupCoCd", ca.getGroupCoCd());
req.put("inDstcd", "1");
req.put("inBrncd", "4004");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcBranch.getSubordinateBranches",
    req, onlineCtx
);

IRecordSet rs = result.getRecordSet("outBrnList");
for (int i = 0; i < rs.getRecordCount(); i++) {
    IRecord rec = rs.getRecord(i);
    String brncd = rec.getString("outBrncd");
    String brnName = rec.getString("outBrnHanglName");
}
```

---

## 7. FUBcMessage - 메시지 조회

### 7.1 getErrorMessage - 에러/조치메시지 조회

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcMessage |
| 메서드 | getErrorMessage |
| z-KESA 대응 | CJIER01 (에러메시지코드 조회) |

**기능**: 에러메시지코드로 에러메시지/조치메시지 내용을 조회한다.

**채널별 메시지 처리**:
| 채널구분코드 | 설명 |
|------------|------|
| 01 | 단말 (기본) |
| 02 | 자동화기기 |
| 04 | 콜센터 |
| 11~99 | 대내외서버 |

#### 입력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| inErrcd | 에러메시지코드 | String |
| inChnlDstcd | 채널구분코드 | String |

#### 출력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| outErrMsg | 에러메시지 내용 | String |
| outTreatMsg | 조치메시지 내용 | String |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inErrcd", "B3800004");
req.put("inChnlDstcd", "01");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcMessage.getErrorMessage",
    req, onlineCtx
);

String errMsg = result.getString("outErrMsg");
```

---

## 8. FUBcEmployee - 직원 조회

### 8.1 getEmployeeInfo - 직원기본 조회

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcEmployee |
| 메서드 | getEmployeeInfo |
| z-KESA 대응 | CJIHR01 (직원기본 조회) |

**기능**: 직원번호로 인사직원정보를 조회한다.

**주요 규칙**:
- 직원번호 **또는** 직원식별자 중 하나만 입력 (동시 입력 불가)
- 직원주민등록번호는 2016.11 이후 미제공

#### 입력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| inEmpNo | 직원번호 | String |
| inEmpIdnfr | 직원식별자(주민번호) | String |

#### 출력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| outEmpHanglFname | 직원한글성명 | String |
| outBelngBrncd | 소속부점코드 | String |
| outRtireYmd | 퇴직년월일 | String |
| outBrnmgrYn | 부점장여부 | String |
| outUserDstcd | 사용자유형구분코드 | String |
| outUserCertnYn | 사용자인증여부 | String |
| outWrkStusDstcd | 근무상태구분코드 | String |
| outEmpCustIdnfr | 직원고객식별자 (10자리) | String |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inEmpNo", "1234567");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcEmployee.getEmployeeInfo",
    req, onlineCtx
);

String empName = result.getString("outEmpHanglFname");
String belongBrn = result.getString("outBelngBrncd");
```

---

## 9. FUBcDate - 일자 계산

### 9.1 getBusinessDate - 영업일자 조회

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcDate |
| 메서드 | getBusinessDate |
| z-KESA 대응 | 일자 계산 유틸리티 |

**기능**: 기준일로부터 영업일 기준 n일 전/후 일자를 조회한다.

#### 입력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| inGroupCoCd | 그룹회사코드 | String |
| inBaseYmd | 기준년월일 | String |
| inDays | 가감일수 (+/-) | int |
| inDstcd | 구분코드 (1:영업일, 2:역일) | String |

#### 출력 항목

| 필드명 | 설명 | 타입 |
|--------|------|------|
| outResultYmd | 결과년월일 | String |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inGroupCoCd", ca.getGroupCoCd());
req.put("inBaseYmd", "20260313");
req.put("inDays", 5);
req.put("inDstcd", "1");  // 영업일 기준

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcDate.getBusinessDate",
    req, onlineCtx
);

String resultDate = result.getString("outResultYmd");
```

---

### 9.2 addDays / addMonths - 일/월 가감

| 메서드 | 기능 |
|--------|------|
| addDays | 역일 기준 n일 가감 |
| addMonths | n개월 가감 |

#### 호출 예시

```java
// addDays
IDataSet req = new DataSet();
req.put("inBaseYmd", "20260313");
req.put("inDays", 30);

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcDate.addDays",
    req, onlineCtx
);

// addMonths
IDataSet req2 = new DataSet();
req2.put("inBaseYmd", "20260313");
req2.put("inMonths", 3);

IDataSet result2 = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcDate.addMonths",
    req2, onlineCtx
);
```

---

## 10. FUBcDateCheck - 영업일 체크

### 10.1 isBusinessDate - 영업일 여부 확인

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcDateCheck |
| 메서드 | isBusinessDate |

**기능**: 지정 일자가 영업일인지 확인한다.

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inGroupCoCd", ca.getGroupCoCd());
req.put("inBaseYmd", "20260313");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcDateCheck.isBusinessDate",
    req, onlineCtx
);

String isBusinessDay = result.getString("outIsBusinessDate"); // Y/N
```

---

### 10.2 isHoliday - 휴일 여부 확인

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcDateCheck |
| 메서드 | isHoliday |

**기능**: 지정 일자가 휴일인지 확인한다.

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inGroupCoCd", ca.getGroupCoCd());
req.put("inBaseYmd", "20260313");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcDateCheck.isHoliday",
    req, onlineCtx
);

String isHoliday = result.getString("outIsHoliday"); // Y/N
```

---

## 11. FUBcDateChange - 일자 변환

### 11.1 convertDateFormat - 일자 포맷 변환

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcDateChange |
| 메서드 | convertDateFormat |

**기능**: 일자 문자열의 포맷을 변환한다.

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inDateStr", "20260313");
req.put("inFromFormat", "yyyyMMdd");
req.put("inToFormat", "yyyy-MM-dd");

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcDateChange.convertDateFormat",
    req, onlineCtx
);

String formatted = result.getString("outDateStr"); // "2026-03-13"
```

---

## 12. FUBcChange - 문자 변환

### 12.1 convertHanjaToHangul - 한자→한글 변환

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcChange |
| 메서드 | convertHanjaToHangul |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inHanjaStr", hanjaString);

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcChange.convertHanjaToHangul",
    req, onlineCtx
);

String hangul = result.getString("outHangulStr");
```

---

### 12.2 convertFullToHalf - 전각→반각 변환

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcChange |
| 메서드 | convertFullToHalf |

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inFullStr", fullWidthStr);

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcChange.convertFullToHalf",
    req, onlineCtx
);

String halfStr = result.getString("outHalfStr");
```

---

## 13. FUBcEcc - 암복호화

### 13.1 encrypt / decrypt

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcEcc |
| 메서드 | encrypt, decrypt |

**기능**: 개인정보 등 민감 데이터의 암호화/복호화 처리.

#### 호출 예시

```java
// 암호화
IDataSet reqEnc = new DataSet();
reqEnc.put("inPlainText", plainText);
reqEnc.put("inEncType", "AES");

IDataSet encResult = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcEcc.encrypt",
    reqEnc, onlineCtx
);
String encrypted = encResult.getString("outCipherText");

// 복호화
IDataSet reqDec = new DataSet();
reqDec.put("inCipherText", encrypted);
reqDec.put("inEncType", "AES");

IDataSet decResult = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcEcc.decrypt",
    reqDec, onlineCtx
);
String decrypted = decResult.getString("outPlainText");
```

---

## 14. FUBcAuthorization - 권한 체크

### 14.1 checkAuthorization

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcAuthorization |
| 메서드 | checkAuthorization |

**기능**: 사용자 권한을 체크한다.

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inEmpNo", empNo);
req.put("inAuthCd", authCode);

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcAuthorization.checkAuthorization",
    req, onlineCtx
);
// 권한 없으면 BusinessException 발생
```

---

## 15. FUBcTransaction - 거래 호출

### 15.1 callTransaction

| 항목 | 내용 |
|------|------|
| 클래스 | FUBcTransaction |
| 메서드 | callTransaction |

**기능**: 타 거래를 호출한다 (내부 거래 연동).

#### 호출 예시

```java
IDataSet req = new DataSet();
req.put("inTxCode", "EDU1234501");
req.put("inParam1", value1);

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcTransaction.callTransaction",
    req, onlineCtx
);
```

---

## 16. z-KESA 공통 유틸리티 → n-KESA 매핑표

| z-KESA 유틸리티 (COBOL) | n-KESA 유틸리티 (Java) | 호출 방식 |
|------------------------|---------------------|----------|
| IJICOMM (공통정보 조립 IC) | CommonArea / IOnlineContext | getCommonArea(onlineCtx) |
| CJIBR01 (부점기본 조회) | FUBcBranch.getBranchInfo | callSharedMethodByDirect |
| CJIBR03 (관할부점 조회) | FUBcBranch.getSubordinateBranches | callSharedMethodByDirect |
| CJIBR07 (부점운영지원 조회) | FUBcBranch.getBranchOperationInfo | callSharedMethodByDirect |
| CJIER01 (에러메시지 조회) | FUBcMessage.getErrorMessage | callSharedMethodByDirect |
| CJIHR01 (직원기본 조회) | FUBcEmployee.getEmployeeInfo | callSharedMethodByDirect |
| CJIUI01 (인스턴스코드 조회) | FUBcCode.getInstanceContent | callSharedMethodByDirect |
| ZUGMSNM (메신저 전송) | FUBcTransaction.callTransaction 또는 별도 API | callSharedMethodByDirect |
| 채번 유틸리티 | FUBcNumbering.getAcnoNumbering / getMgtNoNumbering | callSharedMethodByDirect |
| 비밀번호 검증 | FUBcValidation.validationPassword | callSharedMethodByDirect |
| 통화코드 조회 | FUBcCode.getCurrencyCode | callSharedMethodByDirect |
| 환율 조회 | FUBcRate.getBaseExchangeRate / getMarketExchangeRate / getAvgExchangeRate | callSharedMethodByDirect |
| 일자 계산 | FUBcDate.getBusinessDate / addDays / addMonths | callSharedMethodByDirect |
| 일자 체크 | FUBcDateCheck.isBusinessDate / isHoliday | callSharedMethodByDirect |
| 일자 변환 | FUBcDateChange.convertDateFormat | callSharedMethodByDirect |
| 문자 변환 | FUBcChange.convertHanjaToHangul / convertFullToHalf | callSharedMethodByDirect |
| 암복호화 | FUBcEcc.encrypt / decrypt | callSharedMethodByDirect |
| 권한 체크 | FUBcAuthorization.checkAuthorization | callSharedMethodByDirect |

### 공통 유틸리티 호출 변환 패턴

```java
// z-KESA (COBOL)
// INITIALIZE XCJIxxxx-IN.
// MOVE 값 TO XCJIxxxx-I-항목명.
// #DYCALL CJIxxxx YCCOMMON-CA XCJIxxxx-CA.
// IF XCJIxxxx-R-STAT = ZEROS ...

// ↓ n-KESA (Java) 변환
IDataSet req = new DataSet();
req.put("inField", value);

IDataSet result = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn",
    "FUBcClassName.methodName",
    req, onlineCtx
);

String outValue = result.getString("outField");
```

---

## 17. COBOL 카피북 → IDataSet 변환 패턴

공통 유틸리티의 카피북 입출력 구조는 IDataSet의 put/get으로 변환한다.

```java
// z-KESA (COBOL) 카피북 입력
// INITIALIZE XCJIBR01-IN.
// MOVE BICOM-GROUP-CO-CD TO XCJIBR01-I-GROUP-CO-CD.
// MOVE WK-BRNCD TO XCJIBR01-I-BRNCD.

// ↓ n-KESA (Java) IDataSet 변환
IDataSet req = new DataSet();
req.put("inGroupCoCd", ca.getGroupCoCd());    // XCJIBR01-I-GROUP-CO-CD
req.put("inBrncd", branchCode);                // XCJIBR01-I-BRNCD

// z-KESA (COBOL) 카피북 출력
// IF XCJIBR01-R-STAT = ZEROS
//    MOVE XCJIBR01-O-BRN-HANGL-NAME TO WK-BRN-NAME

// ↓ n-KESA (Java) IDataSet 변환
String brnName = result.getString("outBrnHanglName");

// z-KESA (COBOL) OCCURS 배열 → n-KESA (Java) IRecordSet
// XCJIBR03-O-BRN-INFO-ARAY OCCURS 2000
//     XCJIBR03-O-BRNCD
//     XCJIBR03-O-BRN-HANGL-NAME

// ↓
IRecordSet rs = result.getRecordSet("outBrnList");
for (int i = 0; i < rs.getRecordCount(); i++) {
    IRecord rec = rs.getRecord(i);
    String brncd = rec.getString("outBrncd");
    String brnNm = rec.getString("outBrnHanglName");
}
```
