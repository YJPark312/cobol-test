# 📚 n-KESA 공통 유틸리티 상세 가이드 (Java 개발자용)

본 문서는 C2J(C to Java) 변환 및 PoC 개발 시 필수적으로 사용되는 공통 모듈의 명세와 호출 규격을 정리한 것입니다.

## 1. 표준 호출 패턴 (Implementation Pattern)

n-KESA 프레임워크에서 공통 유틸리티는 주로 `callSharedMethodByDirect`를 통해 호출됩니다.

```java
// 표준 호출 예시
IDataSet request = new DataSet();
request.put("inputKey", "inputValue");

IDataSet response = callSharedMethodByDirect(
    "com.kbstar.kji.enbncmn", // 패키지 경로
    "ClassName.methodName",    // 클래스명.메소드명
    request, 
    onlineCtx
);

```

---

## 2. 날짜 및 시간 유틸리티 (FUBcDate)

금융 업무의 핵심인 영업일 및 만기일 계산 로직을 제공합니다.

| 메소드명 | 설명 | 주요 파라미터 |
| --- | --- | --- |
| `calculateNumberOfDays` | 일수/월수/영업일/공휴일 산출 

 | 시작일자, 종료일자, 계산구분 |
| `calculateExpirDd` | 만기일 및 역만기일 산출 

 | 기산일자, 기간, 기간단위 |
| `calculateDteBtnDfrn` | 두 날짜 간 차이(년/월/일) 산출 

 | 시작일자, 종료일자 |
| `calculateHHMMSS` | 시분초 가감 연산 

 | 기준시간, 증감시간 |
| `calculateEnmnBzoprDay` | 월초/월말 영업일 및 월말일 산출 

 | 기준년월, 부점코드 |
| `calculateAge` | 연령 계산 

 | 기준일자, 생년월일 |

---

## 3. 번호 채번 및 검증 (Numbering & Validation)

계좌번호 생성 및 데이터 유효성 체크를 담당합니다.

* 
**계좌번호 채번 (`FUBcNumbering.getAcnoNumbering`)**: 신규 계좌 개설 시 사용되는 계좌번호를 자동 생성합니다.


* 
**관리번호 채번 (`FUBcNumbering.getMgtNoNumbering`)**: 각종 업무용 관리 번호를 발급합니다.


* 
**비밀번호 검증 (`FUBcValidation.validationPassword`)**: 숫자 연속성, 동일 숫자 반복 등 비밀번호 정책 준수 여부를 체크합니다.


* 
**고유식별정보 검출 (`FUBcValidation.validationUniqIdnfiInfo2`)**: 데이터 내 주민번호, 외국인번호 등 민감 정보 포함 여부를 확인합니다.



---

## 4. 조직 및 직원 정보 (Branch & Employee)

은행 조직 구조 및 인사 정보 조회를 위한 기능을 제공합니다.

### 부점(Branch) 정보 조회

* 
**부점 기본 조회 (`FUBcBranch.getBranchBasic`)**: 부점명, 부점장 정보 등 기본 내역을 반환합니다.


* 
**통합부점 조회 (`FUBcBranch.getIntegrationBranch`)**: 부점 폐쇄 시 통합된 대상 부점을 조회합니다.


* 
**실시간 주소 조회 (`FUBcBranch.getBranchAddrTelno`)**: 부점의 최신 주소와 전화번호를 조회합니다.



### 직원(Employee) 정보 조회

* 
**직원 기본 조회 (`FUBcEmployee.getPafiarEmpInfo`)**: 사번 기준 성명, 직위, 소속 정보를 조회합니다.


* 
**IT 직원 정보 (`FUBcEmployee.getITEmpInfo`)**: 전산 인력 전용 상세 정보를 조회합니다.



---

## 5. 환율 및 통화 (Rate & Code)

외환 및 여수신 업무에 필요한 기준 정보를 제공합니다.

* 
**기준환율 (`FUBcRate.getBaseExchangeRate`)**: 일자별 고시 기준 환율 조회.


* 
**시장환율 (`FUBcRate.getMarketExchangeRate`)**: 실시간 시장 거래 환율 정보.


* 
**통화코드 (`FUBcCode.getCurrencyCode`)**: ISO 통화 코드 정보 조회.



---

## 6. 기타 공통 기능

* 
**날짜 변환 (`FUBcDateChange.changeJulTOGreg`)**: 줄리안 일자와 그레고리언 일자 간 상호 변환을 지원합니다.


* 
**체크디지트 검증**: 외국인등록번호 또는 특정 부점 코드의 유효성을 검증하는 로직을 포함합니다.


* 
**ECC 복호화 (`FUBcEcc.getDecodeStringCode`)**: 암호화된 문서번호 데이터를 복호화하여 원본을 추출합니다.

---

**Tip**: 모든 메소드 호출 시 `requestData`에 담는 Key값은 가이드 문서의 '입력 항목' 정의를 반드시 준수해야 하며, 결과값은 `responseData`에서 '출력 항목' 명칭으로 추출하여 사용하십시오.