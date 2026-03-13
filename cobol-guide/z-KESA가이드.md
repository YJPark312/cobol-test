# z-KESA 프레임워크 프로그램 작성 가이드

> **대상 소스**: AIPBA30.cbl (AS), DIPA301.cbl (DC) 및 연관 온라인 프로그램
> **출처**: C2J변환솔루션PoC용_z-KESA가이드_AWS_최종.pdf
> **목적**: 분석/플래닝 에이전트가 COBOL→Java 변환 시 참조할 z-KESA 프레임워크 규칙 정리

---

## 1. z-KESA 프레임워크 개요

z-KESA(z/OS KB Enterprise Software Architecture)는 메인프레임 환경의 온라인/배치 애플리케이션 개발 프레임워크다.

### 1.1 온라인 거래 처리 흐름

```
단말 → MCI → 프레임워크(z-KESA) → AS 프로그램 → DC/IC/PC 프로그램 → DB
                                    ↑ COMMON AREA 공유 ↑
```

1. 단말에서 채널전문 전송
2. MCI가 내부표준전문으로 변환
3. 프레임워크가 AS 입력 카피북으로 편집 후 **AS 프로그램** 호출
4. AS 프로그램이 업무 처리 (DC/IC/PC 호출)
5. AS 프로그램이 출력 카피북 조립 후 프레임워크에 Return
6. 프레임워크가 출력 전문 조립 후 단말 전송

---

## 2. 프로그램 계층 구조 (Program Type)

| 타입 | 설명 | 예시 |
|------|------|------|
| **AS** | Application Service. 거래의 진입점. 입력검증, 업무처리 총괄 | AIPBA30 |
| **DC** | Data Control. DB 접근 전담 모듈 | DIPA301 |
| **IC** | Information Control. 전행공통정보 조회 | IJICOMM |
| **PC** | Process Control. 업무 공통 처리 모듈 | - |
| **FC** | Function Control. 특정 기능 모듈 | - |
| **BC** | Business Control. 업무공통 처리 | - |

### 호출 규칙
- AS는 DC, IC, PC, FC를 `#DYCALL`로 호출할 수 있다
- DC는 DB에만 접근하며 다른 DC를 호출하지 않는 것이 원칙
- IC는 공통정보(전행공통, 고객, 계좌 등)를 조회하는 역할
- 에러는 `#ERROR` 매크로로 처리하고 임의 Rollback/Commit 불가 (프레임워크가 처리)

---

## 3. 카피북(CopyBook) 명명 규칙

| 카피북 종류 | 파라미터 구분자 | Type | 명명규칙 | 예시 |
|------------|----------------|------|---------|------|
| Common Area 등 FW 공통 | Y | C | YC + 의미있는영숫자(6) | YCCOMMON |
| AS 프로그램 입력 | Y | N | YN + 프로그램ID 선두1자 제외 6자리 | YNIPBA30 |
| AS 프로그램 출력 | Y | P | YP + 프로그램ID 선두1자 제외 6자리 | YPIPBA30 |
| 프로그램 인터페이스 | X | - | X + 프로그램ID(7자리) | XDIPA301 |
| DBIO 테이블 KEY | T | K | TK + 테이블명 4번째부터 6자리 | TKIPB110 |
| DBIO 테이블 RECORD | T | R | TR + 테이블명 4번째부터 6자리 | TRIPB110 |
| SQLIO 인터페이스 | X | Q | XQ + 프로그램ID 6자리 | - |

---

## 4. AIPBA30 (AS 프로그램) 구조 분석

### 4.1 프로그램 개요
- **프로그램명**: AIPBA30 (AS기업집단신용평가이력관리)
- **처리유형**: AS (Application Service)
- **처리개요**: 기업집단신용평가이력을 조회

### 4.2 WORKING-STORAGE SECTION 구성

```cobol
* [1] CONSTANT AREA (상수 정의)
01  CO-AREA.
    03  CO-PGM-ID       PIC X(008) VALUE 'AIPBA30'.
    03  CO-STAT-OK      PIC X(002) VALUE '00'.   -- 정상
    03  CO-STAT-ERROR   PIC X(002) VALUE '09'.   -- 오류
    03  CO-STAT-ABNORMAL PIC X(002) VALUE '98'.  -- 비정상
    03  CO-STAT-SYSERROR PIC X(002) VALUE '99'.  -- 시스템오류

* [2] CONSTANT ERROR AREA (에러/조치 메시지 코드)
01  CO-ERROR-AREA.
    03  CO-B3800004     PIC X(008) VALUE 'B3800004'. -- 필수항목 오류
    03  CO-B3900002     PIC X(008) VALUE 'B3900002'. -- DB에러
    03  CO-UKIF0072     PIC X(008) VALUE 'UKIF0072'. -- 필수입력항목 확인 조치
    03  CO-UKII0182     PIC X(008) VALUE 'UKII0182'. -- DB오류 조치

* [3] WORKING AREA
01  WK-AREA.
    03  WK-FMID         PIC X(013).  -- 출력 폼 ID

* [4] PGM INTERFACE PARAMETER (사용할 카피북 선언)
01  XZUGOTMY-CA.  COPY XZUGOTMY.   -- 출력영역 할당용
01  XIJICOMM-CA.  COPY XIJICOMM.   -- IJICOMM(공통IC) 인터페이스
01  XDIPA301-CA.  COPY XDIPA301.   -- DIPA301(DC) 인터페이스

* [5] DBIO/SQLIO INTERFACE
    COPY YCDBSQLA.  -- SQLIO 공통 카피북
```

### 4.3 LINKAGE SECTION 구성

```cobol
LINKAGE SECTION.
01  YCCOMMON-CA.  COPY YCCOMMON.   -- 프레임워크 공통영역 (필수)
01  YNIPBA30-CA.  COPY YNIPBA30.   -- AS 입력 카피북
01  YPIPBA30-CA.  COPY YPIPBA30.   -- AS 출력 카피북 (PROCEDURE에서 참조 불가, #GETOUT으로 획득)

PROCEDURE DIVISION
    USING YCCOMMON-CA
          YNIPBA30-CA.
```

### 4.4 PROCEDURE DIVISION 처리 흐름

```
S0000-MAIN-RTN
├── S1000-INITIALIZE-RTN   : 초기화 (#GETOUT, IJICOMM 호출)
├── S2000-VALIDATION-RTN   : 입력값 검증 (#ERROR 처리)
├── S3000-PROCESS-RTN      : 업무처리 (DIPA301 DC 호출, 출력조립)
└── S9000-FINAL-RTN        : 처리종료 (#OKEXIT)
```

### 4.5 초기화 절 상세 (S1000-INITIALIZE-RTN)

```cobol
S1000-INITIALIZE-RTN.
*  기본영역 초기화
   INITIALIZE WK-AREA
              XIJICOMM-IN
              XZUGOTMY-IN.

*  출력영역 확보 - AS에서 필수
   #GETOUT YPIPBA30-CA.

*  COMMON AREA SETTING: 비계약업무구분코드 SET
   MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD.
   MOVE SPACES TO JICOM-NON-CTRC-APLCN-NO.

*  공통IC 프로그램 IJICOMM 호출 (전행공통정보 조립)
   #DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA.

*  IJICOMM 호출 결과 확인
   IF COND-XIJICOMM-OK
      CONTINUE
   ELSE
      #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
   END-IF.
```

### 4.6 입력값 검증 절 (S2000-VALIDATION-RTN)

```cobol
S2000-VALIDATION-RTN.
*  디버깅용 로그
   #USRLOG "★[S2000-VALIDATION-RTN]"
   #USRLOG "처리구분 =" YNIPBA30-PRCSS-DSTCD

*  필수항목 체크 패턴
   IF YNIPBA30-PRCSS-DSTCD = SPACE
      #ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR
   END-IF.
```

### 4.7 업무처리 절 (S3000-PROCESS-RTN)

```cobol
S3000-PROCESS-RTN.
*  DC 인터페이스 초기화
   INITIALIZE XDIPA301-IN.

*  AS 입력 → DC 입력으로 복사
   MOVE YNIPBA30-CA TO XDIPA301-IN.

*  DC 호출
   #DYCALL DIPA301 YCCOMMON-CA XDIPA301-CA.

*  DC 결과 확인
   IF NOT COND-XDIPA301-OK AND
      NOT COND-XDIPA301-NOTFOUND
      #ERROR XDIPA301-R-ERRCD XDIPA301-R-TREAT-CD XDIPA301-R-STAT
   END-IF.

*  DC 출력 → AS 출력으로 복사
   MOVE XDIPA301-OUT TO YPIPBA30-CA.

*  출력 폼 ID 지정
   MOVE 'V1'           TO WK-FMID(1:2).
   MOVE BICOM-SCREN-NO TO WK-FMID(3:11).
   #BOFMID WK-FMID.
```

---

## 5. DIPA301 (DC 프로그램) 구조

- **프로그램명**: DIPA301 (DC기업집단신용평가이력관리)
- **처리유형**: DC (Data Control)
- **접근 테이블**: THKIPB110 (기업집단평가기본) - READ, CREATE

### DC 프로그램 구조 패턴

```cobol
LINKAGE SECTION.
01  YCCOMMON-CA.  COPY YCCOMMON.      -- 공통영역 (필수)
01  XDIPA301-CA.                       -- 모듈 인터페이스 영역

PROCEDURE DIVISION
    USING YCCOMMON-CA
          XDIPA301-CA.

*  DC 기본 처리 패턴
S1000-INITIALIZE-RTN.
    INITIALIZE WK-AREA.
    INITIALIZE XDIPA301-OUT XDIPA301-RETURN.  -- 출력/결과영역 초기화
    MOVE CO-STAT-OK TO XDIPA301-R-STAT.
```

### DC에서 DBIO/SQLIO 사용 패턴

```cobol
*  WORKING-STORAGE에 테이블 인터페이스 선언
01  TRIPB110-REC.  COPY TRIPB110.   -- 테이블 레코드
01  TKIPB110-KEY.  COPY TKIPB110.   -- 테이블 키

*  DB 접근 (DBIO 또는 SQLIO)
*  DBIO - SELECT 예시
   MOVE XDIPA301-I-KEY TO KIPB110-PK-KEY.
   #DYDBIO SELECT-CMD-N TKIPB110-PK TRIPB110-REC.
   IF NOT COND-DBIO-OK
      #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
   END-IF.

*  SQLIO 사용 시 (복합 조건 조회)
   COPY YCDBSQLA.              -- SQLIO 공통 인터페이스
   #DYSQLA SQLIO프로그램명 SELECT XQXX0000-CA.
```

---

## 6. 프레임워크 매크로 사용 가이드

AIPBA30 및 연관 소스에서 사용하는 매크로 상세 설명.

### 6.1 #ERROR - 에러 처리

```
기능: 프로그램 처리 중 에러 처리 및 메시지 조립
사용법: #ERROR 에러메시지코드변수 조치메시지코드변수 결과상태코드변수
```

**결과 상태코드**:
| 코드 | 변수명 | 의미 |
|------|--------|------|
| '00' | CO-STAT-OK | 정상 |
| '09' | CO-STAT-ERROR | 오류 |
| '98' | CO-STAT-ABNORMAL | 비정상 |
| '99' | CO-STAT-SYSERROR | 시스템오류 |

**주의사항**:
- 결과상태코드 98, 99는 중요오류로 동일오류 10회 연속 시 자동거래정지
- BATCH MAIN 프로그램에서는 #ERROR 후 `#OKEXIT`으로 별도 종료처리 필요
- IC/DC에서 발행한 #ERROR는 파라미터 Return 영역에만 조립됨 → AS/PC에서 별도 #ERROR 발행 필요

```cobol
*  사용 예시
#ERROR CO-B3800004 CO-UKIF0072 CO-STAT-ERROR

*  DC 호출 후 에러 전파 패턴
IF NOT COND-XDIPA301-OK AND NOT COND-XDIPA301-NOTFOUND
   #ERROR XDIPA301-R-ERRCD XDIPA301-R-TREAT-CD XDIPA301-R-STAT
END-IF.
```

### 6.2 #OKEXIT - 정상 종료

```
기능: 프로그램 정상 종료 처리
사용법: #OKEXIT 정상종료상태코드
```

```cobol
*  사용 예시
S9000-FINAL-RTN.
    #OKEXIT CO-STAT-OK.
```

**주의**: `#OKEXIT` 발행 시 즉시 프로그램 종료. 모든 온라인 거래는 반드시 출력이 있어야 함.

### 6.3 #GETOUT - 출력영역 할당

```
기능: AS 프로그램 출력영역 확보 및 초기화
사용법: #GETOUT 출력영역카피북명
대상: AS 프로그램에서만 사용
```

```cobol
*  WORKING-STORAGE에 선언
01  XZUGOTMY-CA.
    COPY XZUGOTMY.

*  초기화 절에서 호출
#GETOUT YPIPBA30-CA.
```

### 6.4 #DYCALL - 프로그램 Dynamic 호출

```
기능: 다른 프로그램(DC/IC/PC/FC 등)을 Dynamic으로 호출
사용법: #DYCALL 프로그램ID YCCOMMON-CA 프로그램인터페이스CA
```

```cobol
*  IC 호출 예시 (IJICOMM - 공통정보 조립)
#DYCALL IJICOMM YCCOMMON-CA XIJICOMM-CA.
IF COND-XIJICOMM-OK
   CONTINUE
ELSE
   #ERROR XIJICOMM-R-ERRCD XIJICOMM-R-TREAT-CD XIJICOMM-R-STAT
END-IF.

*  DC 호출 예시 (DIPA301 - 기업집단평가이력 조회)
#DYCALL DIPA301 YCCOMMON-CA XDIPA301-CA.
```

**주의**: 프로그램 ID는 변수/상수 사용 불가 (리터럴만 가능). AS/IC/PC/DC/FC/BCS 호출 규칙 적용.

### 6.5 #USRLOG - 사용자 로그 출력

```
기능: 개발자가 디버깅용으로 변수값을 로그로 출력
사용법: #USRLOG [출력형식] 출력대상변수또는상수
```

```cobol
*  기본 사용 예시 (AIPBA30에서 사용하는 패턴)
#USRLOG "★[S2000-VALIDATION-RTN]"
#USRLOG "=입력항목="
#USRLOG "처리구분 =" YNIPBA30-PRCSS-DSTCD
#USRLOG "기업집단그룹코드 =" YNIPBA30-CORP-CLCT-GROUP-CD

*  형식 지정 예시
#USRLOG "계좌번호=" WK-ACNO ",거래금액=" %10 WK-AMT
```

### 6.6 #BOFMID - 출력 폼 ID 설정

```
기능: 출력 폼 ID를 Common Area에 Set
사용법: #BOFMID 폼ID변수 [폼ID2 ...]
최대 20개 지정 가능
```

```cobol
*  AIPBA30에서 사용 패턴
MOVE 'V1'           TO WK-FMID(1:2).
MOVE BICOM-SCREN-NO TO WK-FMID(3:11).
#BOFMID WK-FMID.
```

---

## 7. DBIO / SQLIO 사용 방법

### 7.1 DBIO - 기본 DB 접근 모듈

**DATA DIVISION 선언**:
```cobol
*  DBIO/SQLIO 공통 인터페이스
   COPY YCDBSQLA.

*  테이블별 카피북 선언
01  TKIPB110-KEY.  COPY TKIPB110.   -- 테이블 KEY 카피북
01  TRIPB110-REC.  COPY TRIPB110.   -- 테이블 RECORD 카피북
```

**사용 커맨드**:
| Command | SQL | Locking |
|---------|-----|---------|
| SELECT-CMD-N | SELECT | No lock |
| SELECT-CMD-Y | SELECT | Lock |
| INSERT-CMD-Y | INSERT | Lock |
| UPDATE-CMD-Y | UPDATE | Lock |
| DELETE-CMD-Y | DELETE | Lock |
| OPEN-CMD-n | OPEN (커서) | No lock |
| FETCH-CMD-n | FETCH | No lock |
| CLOSE-CMD-n | CLOSE | No lock |

**에러 결과 코드**:
| 코드 | 조건변수 | 의미 |
|------|---------|------|
| 00 | COND-DBIO-OK | 정상 |
| 01 | COND-DBIO-DUPM | 중복 (Key 중복) |
| 02 | COND-DBIO-MRNF | Not Found |
| 09 | - | 기타 SQL 오류 |
| 98/99 | - | DBIO 비정상/시스템 오류 |

```cobol
*  DBIO 사용 예시
MOVE WK-KEY TO KIPB110-PK-KEY.
#DYDBIO SELECT-CMD-N TKIPB110-PK TRIPB110-REC.
EVALUATE TRUE
    WHEN COND-DBIO-OK
         CONTINUE
    WHEN COND-DBIO-MRNF
         업무요건에 따른 처리
    WHEN OTHER
         #ERROR CO-B3900009 CO-UKII0182 CO-STAT-ERROR
END-EVALUATE.
```

### 7.2 SQLIO - 복합 조건 SELECT 전용

DBIO를 보조하여 복잡한 WHERE 조건의 SELECT만 가능.

```cobol
*  WORKING-STORAGE에 SQLIO 인터페이스 선언
   COPY YCDBSQLA.

*  SQLIO 호출 매크로
#DYSQLA SQLIO프로그램명 SELECT XQXX0000-CA.
```

---

## 8. YCCOMMON (공통정보 영역, Common Area)

모든 어플리케이션 계층에서 공유되는 공통 데이터 영역.

### 8.1 영역 구성

| 영역 | 약자 | 설명 |
|------|------|------|
| 시스템 공통 | SICOM | 프레임워크 제어 영역 (업무팀 참조 불가) |
| 입력 공통 | BICOM | 거래 입력 기본정보 (갱신 불가) |
| 출력 공통 | BOCOM | 출력 폼, 에러정보, 취소복원 정보 |
| 전행공통정보 | JICOM | 일자정보, 부점정보 등 |
| 고객정보 | AACOM | 거래 고객 기본/세부 정보 |
| 상품정보 | DMCOM | 거래 계좌 상품기본 정보 |
| 계약정보 | HCCOM | 거래 계좌 계약기본 정보 |
| 정산정보 | HDCOM | 거래내역 등 정산 공통 정보 |

### 8.2 주요 참조 항목 (AIPBA30 관련)

```cobol
*  BICOM (입력공통) - 입력 내부표준전문 공통부
   BICOM-SCREN-NO          -- 화면번호 (출력 폼 ID 조립에 사용)
   BICOM-GROUP-CO-CD       -- 그룹회사코드

*  JICOM (전행공통정보) - IJICOMM 호출로 세팅됨
   JICOM-NON-CTRC-BZWK-DSTCD  -- 비계약업무구분코드 (AIPBA30: '060')
   JICOM-NON-CTRC-APLCN-NO     -- 비계약신청번호
```

---

## 9. 에러 처리 원칙

1. **임의 Rollback/Commit 금지**: 프레임워크가 처리
2. **에러 계층 규칙**:
   - IC/DC/FC에서 발행한 `#ERROR` → 파라미터 Return 영역에만 저장
   - AS/PC에서 발행한 `#ERROR`만 최종 출력 메시지에 포함
   - 따라서 AS 프로그램은 DC 에러를 받아서 별도로 `#ERROR` 발행 필요
3. **Sync/Rollback 판단 기준**: AS 프로그램의 에러정보 설정 여부

```cobol
*  AS 프로그램의 에러 전파 패턴
#DYCALL DIPA301 YCCOMMON-CA XDIPA301-CA.
IF NOT COND-XDIPA301-OK AND NOT COND-XDIPA301-NOTFOUND
   *  DC에서 받은 에러코드를 AS에서 재발행 → 출력 메시지에 포함됨
   #ERROR XDIPA301-R-ERRCD XDIPA301-R-TREAT-CD XDIPA301-R-STAT
END-IF.
```

---

## 10. 프로그램 인터페이스 결과 영역 패턴

DC/IC/PC 프로그램의 인터페이스 카피북은 공통적으로 RETURN, IN, OUT 영역으로 구성된다.

```cobol
*  예: XDIPA301 카피북 구조
01  XDIPA301-CA.
    03  XDIPA301-RETURN.           -- 결과 영역
        05  XDIPA301-R-STAT       PIC X(002).
            88  COND-XDIPA301-OK       VALUE '00'.  -- 정상
            88  COND-XDIPA301-NOTFOUND VALUE '02'.  -- Not Found
            88  COND-XDIPA301-ERROR    VALUE '09'.  -- 오류
        05  XDIPA301-R-ERRCD      PIC X(008).       -- 에러메시지코드
        05  XDIPA301-R-TREAT-CD   PIC X(008).       -- 조치메시지코드
        05  XDIPA301-R-SQL-CD     PIC S9(005).      -- SQLCODE
    03  XDIPA301-IN.               -- 입력 영역
        ...
    03  XDIPA301-OUT.              -- 출력 영역
        ...
```

---

## 11. Java 변환 시 매핑 참조

| COBOL z-KESA 요소 | Java 변환 대응 |
|------------------|--------------|
| AS 프로그램 | Spring MVC Controller 또는 Service 레이어 |
| DC 프로그램 | MyBatis Mapper + Repository 패턴 |
| IC 프로그램 | 공통 Service (공통정보 조회) |
| YCCOMMON | 공통 Context 객체 (RequestContext 등) |
| #DYCALL | 서비스 메서드 호출 (의존성 주입) |
| #ERROR | Exception throw (커스텀 BusinessException) |
| #OKEXIT | 메서드 return |
| #GETOUT | 출력 DTO 초기화 (new ResponseDto()) |
| #USRLOG | log.debug() / log.info() |
| #BOFMID | 응답 폼 ID 설정 (ResponseDto.setFormId()) |
| DBIO/SQLIO | MyBatis Mapper XML |
| COPY YCDBSQLA | MyBatis SqlSession 등 DB 접근 인터페이스 |
| CO-STAT-OK('00') | 정상 return |
| CO-STAT-ERROR('09') | throw BusinessException |
| CO-STAT-SYSERROR('99') | throw SystemException |
