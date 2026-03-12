# 📘 COBOL 공통 유틸리티 상세 개발 가이드

## 1. 날짜 및 영업일 관련 유틸리티

### 1.1 일수/월수/영업일수 산출 (CJIIL01)

* 
**기능**: 두 날짜 사이의 총 일수, 월수, 영업일수 및 공휴일수를 계산합니다.


* 
**언어 및 사용**: COBOL, 온라인/배치 공통.


* **주요 파라미터 (COPY BOOK: XCJIIL01)**:
* `IN-START-DATE`: 시작년월일 (YYYYMMDD)
* `IN-END-DATE`: 종료년월일 (YYYYMMDD)
* `OUT-TOT-DAYS`: 총 일수
* `OUT-BIZ-DAYS`: 영업일수
* `OUT-HOL-DAYS`: 공휴일수



### 1.2 만기일/역만기일 산출 (CJIIL03)

* 
**기능**: 시작일로부터 특정 일수/월수가 경과한 만기일 또는 이전의 역만기일을 산출합니다.


* **주요 파라미터 (COPY BOOK: XCJIIL03)**:
* `IN-BASE-DATE`: 기준일자
* `IN-TERM-VAL`: 가감할 기간 (일/월 단위)
* `IN-CALC-TYPE`: 구분 (1: 만기일, 2: 역만기일)



### 1.3 윤년 체크 (CJIDT01) 및 휴일 체크 (CJIDT02)

* 
**CJIDT01**: 입력된 연도가 윤년인지 확인하여 결과값을 리턴합니다.


* 
**CJIDT02**: 특정 일자가 공휴일인지 여부를 체크합니다.



---

## 2. 조직 및 인사 정보 조회 유틸리티

### 2.1 부점 기본 정보 조회 (CJIBR01)

* 
**기능**: 부점코드를 입력받아 해당 부점의 한글/영문 명칭, 계층 구조 등 상세 정보를 조회합니다.


* 
**COPY BOOK**: `XCJIBR01`.



### 2.2 직원 기본 정보 조회 (CJIHR01)

* 
**기능**: 직원번호를 기반으로 성명, 소속부점, 직위 등 인사 기본 정보를 조회합니다.


* 
**COPY BOOK**: `XCJIHR01`.



---

## 3. 환율 및 통화 조회 유틸리티

### 3.1 통화코드 조회 (CJICU01)

* 
**기능**: 통화코드에 대한 한글명, 영문명 및 소수점 자리수 정보를 제공합니다.


* 
**COPY BOOK**: `XCJICU01`.



### 3.2 기준환율 조회 (CJIEX01)

* 
**기능**: 특정 일자의 대고객 고시 환율 및 매매기준율 등을 조회합니다.


* 
**COPY BOOK**: `XCJIEX01`.



---

## 4. 코볼 호출 표준 패턴 (Code Snippet)

프로그램 내에서 유틸리티를 호출할 때는 아래와 같은 단계를 준수해야 합니다.

```cobol
* 1. 데이터 영역 선언 (WORKING-STORAGE SECTION)
 COPY XCJIIL01.    *> 일수산출용 Copybook
 
* 2. 처리 로직 (PROCEDURE DIVISION)
 S3000-PROCESS-RTN.
     * [Step 1] 입력 영역 초기화
     INITIALIZE XCJIIL01-IN.
     
     * [Step 2] 호출 파라미터 설정
     MOVE "20250101" TO IN-START-DATE.
     MOVE "20251231" TO IN-END-DATE.
     
     * [Step 3] 공통 유틸리티 호출
     CALL "CJIIL01" USING XCJIIL01-AREA.
     
     * [Step 4] 리턴 코드 검증 (0000: 정상)
     IF XCJIIL01-RET-CODE NOT = "0000"
         DISPLAY "ERROR IN CJIIL01: " XCJIIL01-RET-CODE
         PERFORM S9999-ERROR-EXIT
     END-IF.

```

## 5. 개발 시 주의사항

* 
**공통 유형**: 대부분의 유틸리티는 '공동' 계열사 구분으로 정의되어 있으며, 온라인과 배치 프로그램 모두에서 사용 가능합니다.


* 
**에러 처리**: 리턴 상태 코드가 `0000`이 아닌 경우, 각 유틸리티별 에러 메시지 조회 기능(`CJIER01`)을 연계하여 처리하는 것이 권장됩니다.


* 
**제약사항**: 특정 유틸리티(예: `CJIBR09`)는 사용이 불가하거나 특정 환경에서 제한될 수 있으므로 가이드의 제약사항 섹션을 반드시 확인해야 합니다.