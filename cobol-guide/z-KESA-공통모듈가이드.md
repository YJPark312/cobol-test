# z-KESA 공통 유틸리티 프로그램 가이드

> **대상 소스**: AIPBA30.cbl 및 연관 COBOL 소스에서 호출하는 공통 유틸리티
> **출처**: C2J변환솔루션PoC용_z-KESA공통유틸리티_가이드_AWS_완료.pdf
> **목적**: 분석/플래닝 에이전트가 공통 유틸리티 호출 패턴을 Java로 변환 시 참조

---

## 1. 공통 유틸리티 개요

### 1.1 호출 방식 (공통 규칙)

모든 공통 유틸리티는 `#DYCALL` 매크로로 호출하며, 인터페이스 카피북(XCJIxxxx)을 통해 파라미터를 전달한다.

```cobol
*  공통 유틸리티 호출 패턴
01  XCJIxxxx-CA.
    COPY XCJIxxxx.     -- WORKING-STORAGE에 선언

*  호출
INITIALIZE XCJIxxxx-IN.               -- 입력영역 초기화
MOVE 값 TO XCJIxxxx-I-항목명.         -- 입력값 SET
#DYCALL CJIxxxx YCCOMMON-CA XCJIxxxx-CA.  -- 유틸리티 호출

*  결과 확인
IF XCJIxxxx-R-STAT = ZEROS            -- '00' 정상
   MOVE XCJIxxxx-OUT TO 내부변수
ELSE
   #ERROR 에러코드 조치코드 상태코드
END-IF.
```

### 1.2 RETURN 영역 공통 구조

```cobol
03  XCJIxxxx-RETURN.
    05  XCJIxxxx-R-STAT        PIC X(002).
        88  COND-XCJIxxxx-OK         VALUE '00'. -- 정상
        88  COND-XCJIxxxx-ERROR      VALUE '09'. -- 오류
        88  COND-XCJIxxxx-ABNORMAL   VALUE '98'. -- 비정상
        88  COND-XCJIxxxx-SYSERROR   VALUE '99'. -- 시스템오류
    05  XCJIxxxx-R-LINE        PIC 9(006).       -- 오류위치
    05  XCJIxxxx-R-ERRCD       PIC X(008).       -- 에러메시지코드
    05  XCJIxxxx-R-TREAT-CD    PIC X(008).       -- 조치메시지코드
    05  XCJIxxxx-R-SQL-CD      PIC S9(005).      -- SQLCODE
```

---

## 2. AIPBA30 및 연관 소스에서 사용하는 공통 유틸리티 목록

| 유틸리티 ID | 한글명 | 카피북 | 사용 소스 |
|------------|--------|--------|---------|
| IJICOMM | 공통정보 조립 IC | XIJICOMM | AIPBA30 (공통정보 세팅) |
| CJIBR01 | 부점기본 조회 | XCJIBR01 | 연관 온라인 소스 |
| CJIBR03 | 관할/대출실행팀 소속부점코드 조회 | XCJIBR03 | 연관 온라인 소스 |
| CJIBR07 | 부점운영지원내역 조회 | XCJIBR07 | 연관 온라인 소스 |
| CJIER01 | 에러/조치메시지코드 조회 | XCJIER01 | 연관 온라인 소스 |
| CJIHR01 | 직원기본 조회 | XCJIHR01 | DIPA301, 연관 소스 |
| CJIUI01 | 전행 인스턴스코드 내용 조회 | XCJIUI01 | 연관 온라인 소스 |

---

## 3. IJICOMM (공통정보 조립 IC)

AIPBA30의 초기화 절에서 반드시 호출하는 전행공통정보 조립 IC 프로그램.

### 3.1 역할
- YCCOMMON의 JICOM 영역(전행공통정보)을 업무 거래에 맞게 세팅
- 비계약업무구분코드, 비계약신청번호 등 공통정보를 COMMON AREA에 조립

### 3.2 사용 패턴 (AIPBA30 기준)

```cobol
*  WORKING-STORAGE 선언
01  XIJICOMM-CA.
    COPY XIJICOMM.

*  초기화 절에서 사용
S1000-INITIALIZE-RTN.
*  초기화
    INITIALIZE XIJICOMM-IN.

*  비계약업무구분코드 SET (신평:060)
    MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD.
*  비계약신청번호 초기화
    MOVE SPACES TO JICOM-NON-CTRC-APLCN-NO.

*  IJICOMM 호출
    #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA.

*  결과 확인
    IF COND-XIJICOMM-OK
       CONTINUE
    ELSE
       #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
    END-IF.
```

### 3.3 Java 변환 시 참고
- IJICOMM 호출은 공통 서비스의 컨텍스트 초기화에 해당
- `RequestContext` 또는 `CommonInfoService.buildCommonInfo()` 호출로 대응
- 비계약업무구분코드('060')는 서비스 파라미터 또는 상수로 처리

---

## 4. CJIBR01 - 부점기본 조회

### 4.1 개요
| 항목 | 내용 |
|------|------|
| 프로그램 ID | CJIBR01 |
| 카피북 | XCJIBR01 |
| 사용 구분 | 온라인, 배치 |
| 테이블 | THKJIBR01 (부점기본) |

**기능**: 조회 요청일자 시점의 부점기본 정보를 조회한다.

**주요 규칙**:
- 부점코드는 숫자로 입력 (공백/'0000' 불가)
- 년월일 미입력 시 현재시점(Common Area의 거래처리기준일) 기준 조회
- 폐쇄부점 조회 시 리턴상태코드 '07' 반환

### 4.2 사용 패턴

```cobol
*  WORKING-STORAGE 선언
01  XCJIBR01-CA.
    COPY XCJIBR01.

*  입력값 SET
    INITIALIZE XCJIBR01-IN.
    MOVE BICOM-GROUP-CO-CD TO XCJIBR01-I-GROUP-CO-CD.  -- 그룹회사코드
    MOVE WK-BRNCD          TO XCJIBR01-I-BRNCD.         -- 부점코드
*   년월일 미입력 시 현재시점 기준 조회

*  유틸리티 호출
    #DYCALL CJIBR01 YCCOMMON-CA XCJIBR01-CA.

*  결과 확인
    IF XCJIBR01-R-STAT = ZEROS
       MOVE XCJIBR01-O-BRN-HANGL-NAME TO WK-BRN-NAME  -- 부점한글명
       MOVE XCJIBR01-O-BRNCD          TO WK-BRNCD
    ELSE
       #ERROR 에러코드 조치코드 상태코드
    END-IF.
```

### 4.3 주요 출력 항목

```cobol
XCJIBR01-O-BRNCD            PIC X(004)  -- 부점코드
XCJIBR01-O-BRN-HANGL-NAME   PIC X(022)  -- 부점한글명
XCJIBR01-O-BRN-H-ABRVN-NAME PIC X(008)  -- 부점한글약칭명
XCJIBR01-O-BRN-DSTCD        PIC X(002)  -- 부점구분코드
XCJIBR01-O-OPNN-YMD         PIC X(008)  -- 개점년월일
XCJIBR01-O-CLSR-YMD         PIC X(008)  -- 폐쇄년월일
XCJIBR01-O-BNK-CD           PIC X(003)  -- 은행코드
XCJIBR01-O-INTGRA-BRNCD     PIC X(004)  -- 통합부점코드 (폐쇄부점인 경우)
```

### 4.4 Java 변환 시 참고
- `BranchRepository.findByBranchCode(branchCode, baseDate)` 로 대응
- 폐쇄부점('07') 케이스는 별도 예외 처리 필요

---

## 5. CJIBR03 - 관할/대출실행팀 소속부점코드 조회

### 5.1 개요
| 항목 | 내용 |
|------|------|
| 프로그램 ID | CJIBR03 |
| 카피북 | XCJIBR03 |
| 테이블 | THKJIBR01 (부점기본) |

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

### 5.2 사용 패턴

```cobol
01  XCJIBR03-CA.
    COPY XCJIBR03.

    INITIALIZE XCJIBR03-IN.
    MOVE '1'           TO XCJIBR03-I-DSTCD.  -- 구분코드
    MOVE WK-BRNCD      TO XCJIBR03-I-BRNCD.  -- 부점코드

    #DYCALL CJIBR03 YCCOMMON-CA XCJIBR03-CA.

    IF XCJIBR03-R-STAT = ZEROS
       PERFORM UNTIL XCJIBR03-O-BRN-NOITM = 0
          COMPUTE XCJIBR03-O-BRN-NOITM = XCJIBR03-O-BRN-NOITM - 1
          MOVE XCJIBR03-O-BRN-INFO-ARAY(XCJIBR03-O-BRN-NOITM) TO 내부변수
       END-PERFORM
    ELSE
       #ERROR 에러코드 조치코드 상태코드
    END-IF.
```

### 5.3 주요 출력 항목

```cobol
XCJIBR03-O-BRN-NOITM        PIC 9(004)      -- 부점건수
XCJIBR03-O-BRN-INFO-ARAY    OCCURS 2000     -- 부점정보 배열
    XCJIBR03-O-BRNCD         PIC X(004)     -- 부점코드
    XCJIBR03-O-BRN-HANGL-NAME PIC X(022)   -- 부점한글명
```

---

## 6. CJIBR07 - 부점운영지원내역 조회

### 6.1 개요
| 항목 | 내용 |
|------|------|
| 프로그램 ID | CJIBR07 |
| 카피북 | XCJIBR07 |
| 계열사 | 은행 전용 |
| 테이블 | THKJIBR03 (부점운영지원내역) |

**기능**: 부점과 관련된 부수적 정보(운영지원내역)를 조회한다.

**입력 체크**:
- 그룹회사코드 SPACE 불가
- 부점코드 숫자 입력, '0000' 불가

### 6.2 사용 패턴

```cobol
01  XCJIBR07-CA.
    COPY XCJIBR07.

    INITIALIZE XCJIBR07-IN.
    MOVE BICOM-GROUP-CO-CD TO XCJIBR07-I-GROUP-CO-CD.
    MOVE '4004'            TO XCJIBR07-I-BRNCD.

    #DYCALL CJIBR07 YCCOMMON-CA XCJIBR07-CA.

    IF XCJIBR07-R-STAT = ZEROS
       MOVE XCJIBR07-OUT TO 내부변수
    ELSE
       #ERROR 에러코드 조치코드 상태코드
    END-IF.
```

---

## 7. CJIER01 - 에러/조치메시지코드 조회

### 7.1 개요
| 항목 | 내용 |
|------|------|
| 프로그램 ID | CJIER01 |
| 카피북 | XCJIER01 |
| 테이블 | THKJIER01 (에러메시지목록) |

**기능**: 에러메시지코드, 책임자승인사유코드, 조치메시지코드를 조회한다.

**채널별 메시지 처리**:
| 채널구분코드 | 설명 |
|------------|------|
| 01 | 단말 (기본) |
| 02 | 자동화기기 |
| 04 | 콜센터 |
| 11~99 | 대내외서버 |

**규칙**:
- 에러정보 없으면 리턴상태코드 '09' 반환
- 대외망 채널인 경우 `XCJIER01-I-CHNL-DSTCD` 반드시 SET 필요

### 7.2 사용 패턴

```cobol
01  XCJIER01-CA.
    COPY XCJIER01.

    INITIALIZE XCJIER01-IN.
    MOVE CO-B3800004 TO XCJIER01-I-ERRCD.   -- 조회할 에러코드
    MOVE '01'        TO XCJIER01-I-CHNL-DSTCD.  -- 채널구분 (단말)

    #DYCALL CJIER01 YCCOMMON-CA XCJIER01-CA.

    IF XCJIER01-R-STAT = ZEROS
       MOVE XCJIER01-O-ERR-MSG TO WK-ERR-MSG
    ELSE
       #ERROR 에러코드 조치코드 상태코드
    END-IF.
```

### 7.3 Java 변환 시 참고
- `MessageSource` 또는 DB 기반 메시지 조회 서비스로 대응
- 채널별 메시지 분기 로직 구현 필요

---

## 8. CJIHR01 - 직원기본 조회

### 8.1 개요
| 항목 | 내용 |
|------|------|
| 프로그램 ID | CJIHR01 |
| 카피북 | XCJIHR01 |
| 테이블 | THKJIHR01 (직원기본) |

**기능**: 직원번호 또는 직원주민번호(직원식별자)로 인사직원정보를 조회한다.

**주요 규칙**:
- 직원번호 **또는** 직원주민번호(식별자) 중 하나만 입력 (동시 입력 불가)
- 직원주민등록번호는 2016.11 이후 미제공 → `CJIHR12` 사용 권고
- 직원고객식별자(10자리) 추가 제공

### 8.2 사용 패턴 (DIPA301에서 직원명 조회 시)

```cobol
01  XCJIHR01-CA.
    COPY XCJIHR01.

    INITIALIZE XCJIHR01-IN.
    MOVE WK-EMP-NO TO XCJIHR01-I-EMP-NO.   -- 직원번호

    #DYCALL CJIHR01 YCCOMMON-CA XCJIHR01-CA.

    IF XCJIHR01-R-STAT = ZEROS
       MOVE XCJIHR01-O-EMP-HANGL-FNAME  TO WK-EMP-HANGL-FNAME   -- 직원한글명
       MOVE XCJIHR01-O-BELNG-BRNCD      TO WK-BELNG-BRNCD        -- 소속부점코드
    ELSE
       #ERROR 에러코드 조치코드 상태코드
    END-IF.
```

### 8.3 주요 입력 항목

```cobol
XCJIHR01-I-EMP-NO            PIC X(007)  -- 직원번호 (직원번호/주민번호 중 하나 필수)
XCJIHR01-I-EMP-IDNFR         PIC X(013)  -- 직원식별자(주민번호)
```

### 8.4 주요 출력 항목

```cobol
XCJIHR01-O-EMP-HANGL-FNAME   PIC X(042)  -- 직원한글성명
XCJIHR01-O-BELNG-BRNCD       PIC X(004)  -- 소속부점코드
XCJIHR01-O-RTIRE-YMD         PIC X(008)  -- 퇴직년월일
XCJIHR01-O-BRNMGR-YN         PIC X(001)  -- 부점장여부
XCJIHR01-O-USER-DSTCD        PIC X(002)  -- 사용자유형구분코드
XCJIHR01-O-USER-CERTN-YN     PIC X(001)  -- 사용자인증여부
XCJIHR01-O-WRK-STUS-DSTCD    PIC X(001)  -- 근무상태구분코드
XCJIHR01-O-EMP-CUST-IDNFR    PIC X(010)  -- 직원고객식별자
```

### 8.5 Java 변환 시 참고
- `EmployeeRepository.findByEmployeeNo(empNo)` 로 대응
- 퇴직 여부 확인 로직 포함 필요

---

## 9. CJIUI01 - 전행 인스턴스코드 내용 조회

### 9.1 개요
| 항목 | 내용 |
|------|------|
| 프로그램 ID | CJIUI01 |
| 카피북 | XCJIUI01 |
| 테이블 | THKJIUI02 (업무인스턴스코드) |

**기능**: 인스턴스식별자, 인스턴스코드에 맞는 업무 인스턴스 내용을 조회한다.

**구분코드**:
| 코드 | 설명 |
|------|------|
| '1' | 업무인스턴스코드 단건조회 |
| '2' | 업무인스턴스식별자에 의한 코드전체조회 (최대 30건) |

**주요 규칙**:
- 조회건수 없으면 리턴상태코드 '09' 반환
- 구분코드 '2' 사용 시 최대 30건, 30건 초과 시 조회완료여부 '0' 리턴
- 다음 조회 시 미완료조회여부 '1' 입력, **카피북 초기화 금지**

### 9.2 사용 패턴

```cobol
01  XCJIUI01-CA.
    COPY XCJIUI01.

    INITIALIZE XCJIUI01-IN.
    MOVE '1'             TO XCJIUI01-I-DSTCD.        -- 구분코드
    MOVE WK-INSTNC-IDNFR TO XCJIUI01-I-INSTNC-IDNFR. -- 인스턴스식별자
    MOVE WK-INSTNC-CD    TO XCJIUI01-I-INSTNC-CD.     -- 인스턴스코드

    #DYCALL CJIUI01 YCCOMMON-CA XCJIUI01-CA.

    IF XCJIUI01-R-STAT = ZEROS
       MOVE XCJIUI01-O-INSTNC-CTNT TO 내부변수1  -- 인스턴스내용
       MOVE XCJIUI01-O-CMPS-INSTNC-CTNT TO 내부변수2  -- 축약인스턴스내용
    ELSE
       #ERROR 에러코드 조치코드 상태코드
    END-IF.
```

### 9.3 Java 변환 시 참고
- 코드성 데이터 조회 → `CodeRepository.findInstanceContent(identifier, code)`
- 또는 캐시 기반 코드 테이블 서비스로 대응

---

## 10. ZUGMSNM - 메신저 전송요청 유틸리티

연관 소스(AIPBA30 시스템)에서 사용되는 메신저 알림 유틸리티.

### 10.1 개요
| 항목 | 내용 |
|------|------|
| 프로그램 ID | ZUGMSNM |
| 카피북 | XZUGMSNM |
| 사용 구분 | 온라인만 사용 가능 |

**기능**: KB-WiseNet 메신저 기능을 통한 메시지(쪽지) 전송 요청.

### 10.2 사용 패턴

```cobol
01  XZUGMSNM-CA.
    COPY XZUGMSNM.

    INITIALIZE XZUGMSNM-IN.
    MOVE CO-SESSION-MSN      TO XZUGMSNM-IN-SERVTYPE.   -- 서비스유형 (0:세션, 1:IP)
    MOVE WK-RECEIVE-EMP-NO   TO XZUGMSNM-IN-REMPNO.     -- 수신직원번호
    MOVE WK-SEND-EMP-NO      TO XZUGMSNM-IN-SEMPNO.     -- 발신직원번호
    MOVE WK-MEMO-TITLE       TO XZUGMSNM-IN-TITLE.      -- 쪽지제목
    MOVE WK-MEMO-BODY        TO XZUGMSNM-IN-BODY.       -- 쪽지본문 (500Byte 이내)
    MOVE CO-CHAR-NO          TO XZUGMSNM-IN-URGENTYN.   -- 긴급여부
    MOVE CO-CHAR-NO          TO XZUGMSNM-IN-SAVEOPTION. -- 발신함저장여부

    #DYCALL ZUGMSNM YCCOMMON-CA XZUGMSNM-CA.

    IF NOT COND-XZUGMSNM-OK
       #ERROR 에러코드 조치코드 상태코드
    END-IF.
```

**주의**: 수신직원번호는 소스에 하드코딩 금지 → DB 관리 등으로 동적 처리

### 10.3 Java 변환 시 참고
- 메신저/알림 서비스 API 호출로 대응
- 배치 프로그램에서는 사용 불가

---

## 11. 공통 유틸리티 Java 변환 매핑표

| COBOL 유틸리티 | Java 변환 방향 | 비고 |
|--------------|-------------|------|
| IJICOMM | CommonContextService.buildContext() | RequestContext 초기화 |
| CJIBR01 | BranchService.getBranchInfo(branchCode, date) | 날짜 파라미터 처리 |
| CJIBR03 | BranchService.getSubordinateBranches(branchCode, type) | OCCURS 배열 → List |
| CJIBR07 | BranchService.getBranchOperationInfo(groupCd, branchCode) | |
| CJIER01 | MessageService.getErrorMessage(errorCode, channelCode) | MessageSource |
| CJIHR01 | EmployeeService.getEmployeeInfo(empNo) | |
| CJIUI01 | CodeService.getInstanceContent(identifier, code) | 코드 캐시 적용 권장 |
| ZUGMSNM | MessengerService.sendMessage(request) | 비동기 처리 검토 |

### 공통 유틸리티 호출 변환 패턴

```java
// COBOL #DYCALL CJIxxxx YCCOMMON-CA XCJIxxxx-CA
// → Java 서비스 메서드 호출

BranchInfoDto branchInfo = branchService.getBranchInfo(
    context.getGroupCompanyCode(),  // BICOM-GROUP-CO-CD
    branchCode,                      // XCJIBR01-I-BRNCD
    null                             // 년월일 미입력 = 현재시점
);

// 에러 처리 패턴
if (branchInfo == null) {
    throw new BusinessException("B3800004", "UKIF0072");
}
```

---

## 12. COBOL 카피북 → Java DTO 변환 패턴

공통 유틸리티의 카피북 구조는 Java DTO 클래스로 변환한다.

```java
// XCJIBR01 카피북 → BranchInfoDto
public class BranchInfoDto {
    private String branchCode;           // XCJIBR01-O-BRNCD
    private String branchKorName;        // XCJIBR01-O-BRN-HANGL-NAME
    private String branchAbbrevName;     // XCJIBR01-O-BRN-H-ABRVN-NAME
    private String branchTypeCode;       // XCJIBR01-O-BRN-DSTCD
    private String openDate;             // XCJIBR01-O-OPNN-YMD
    private String closeDate;            // XCJIBR01-O-CLSR-YMD
    private String integratedBranchCode; // XCJIBR01-O-INTGRA-BRNCD (폐쇄시)
    // ...
}

// XCJIHR01 카피북 → EmployeeInfoDto
public class EmployeeInfoDto {
    private String employeeNo;           // XCJIHR01-I-EMP-NO
    private String employeeKorName;      // XCJIHR01-O-EMP-HANGL-FNAME
    private String belongBranchCode;     // XCJIHR01-O-BELNG-BRNCD
    private String retireDate;           // XCJIHR01-O-RTIRE-YMD
    private String branchManagerYn;      // XCJIHR01-O-BRNMGR-YN
    private String workStatusCode;       // XCJIHR01-O-WRK-STUS-DSTCD
    // ...
}
```
