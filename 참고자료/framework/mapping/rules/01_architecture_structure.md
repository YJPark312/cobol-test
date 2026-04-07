# 01. 아키텍처 & 프로그램 구조 매핑

z-KESA (COBOL) → n-KESA (Java) 프레임워크 아키텍처 & 프로그램 구조 완전 매핑


---

# z-KESA → n-KESA 아키텍처/프로그램 구조 완전 매핑

---

## SECTION 1: 아키텍처 전체 구조

---

### [Architecture] - 프레임워크 정체성
- z-KESA: z-KESA (z/OS KB Enterprise Software Architecture) — IBM 메인프레임(z/OS) 기반, CICS 환경, COBOL 언어
- n-KESA: n-KESA (NEXCORE 기반 Java WAS 환경) — Java WAS 환경, Spring 기반, Eclipse IDE
- z-KESA Detail: 메인프레임 z/OS 상의 CICS 트랜잭션 서버에서 COBOL 프로그램을 실행. 프레임워크 메인 진입점은 ZMFGATE
- n-KESA Detail: Java WAS(IBM Liberty) 환경에서 NEXCORE 프레임워크 런타임 위에서 실행. 배치는 SpringBoot 기반 JVM으로 실행
- Mapping Rule: 전체 실행 환경이 메인프레임 CICS → Java WAS로 전환. COBOL 소스 → Java 클래스로 1:1 변환하되 프레임워크 계층구조 매핑 규칙 적용

---

### [Architecture] - 온라인 거래 처리 흐름 전체
- z-KESA: 단말 → MCI(채널전문→내부표준전문) → CICS → ZMFGATE(프레임워크 메인) → Common Area 편집 → AS 프로그램 → PC/DC/IC → DBIO/SQLIO → AS 출력 카피북 → 프레임워크 출력편집 → MCI → 단말
- n-KESA: 단말 → MCI(채널전문→내부표준전문) → WAS → PM 진입점 → IOnlineContext(CommonArea) 생성 → PM → FM → DM/DBIO → responseData → MCI 출력전문 조립 → MCI → 단말
- z-KESA Detail: ①단말 입력 → ②MCI 채널전문→내부표준전문 변환 → ③CICS ZMFGATE 호출 → ④프레임워크가 공통부를 Common Area로 편집, AS 입력 카피북 편집 → ⑤AS 프로그램 기동(PC/DC 호출 가능) → ⑦AS 출력카피북 편집 후 Return → ⑧프레임워크 출력편집 → ⑨MCI 전송 → ⑩MCI→단말
- n-KESA Detail: 동일한 MCI 채널 경로를 거쳐 WAS로 유입. PM 메소드가 진입점. IOnlineContext 객체에 CommonArea 포함. PM→FM→DM/DBIO 호출 후 responseData 반환. 출력은 addOutFormInfo() 또는 MCI 출력전문 조립 함수 사용
- Mapping Rule: 거래 흐름 구조 동일, 진입점 ZMFGATE→PM, 채널 인터페이스는 MCI 동일 유지. 출력 FormID 지정 방식은 #BOFMID 매크로→addOutFormInfo() API로 변환

---

### [Architecture] - 프로그램 계층구조 (3계층)
- z-KESA: AS / PC / DC / IC / FC / BC 6계층 구조
- n-KESA: ProcessUnit(PU) / FunctionUnit(FU) / DataUnit(DU) / DBIO Unit 4계층 구조
- z-KESA Detail:
  - AS (Application Service): 어플리케이션 거래의 메인 프로그램, 프레임워크 스케줄러에서 호출
  - PC (Process Component): 거래의 처리 절차를 정의하는 프로세스 단위
  - DC (Domain Component): 데이터의 CRUD 및 비즈니스 로직을 처리하는 부품 프로그램
  - IC (Intermediate Component): 두 개 이상의 DC를 호출하여 완성되는 공통성 업무 부품
  - FC (Function Component): 기능성 공통 컴포넌트
  - BC (Business Component): 전행공통 비즈니스 컴포넌트
- n-KESA Detail:
  - PU (ProcessUnit): 서비스 처리 Flow 관리 담당, pm[거래코드]() 메소드가 진입점
  - FU (FunctionUnit): 단위 비즈니스 로직/공통 로직/선후처리 담당, 타 컴포넌트 호출 단위
  - DU (DataUnit): 데이터 조회전용(SELECT) 담당, DM 메소드
  - DBIO Unit: 단건 데이터의 INSERT/SELECT/UPDATE/DELETE 담당, DBM 메소드
- Mapping Rule:
  - AS → PU (ProcessUnit), pm[거래코드] 메소드
  - PC → FU (FunctionUnit), FM 메소드
  - DC → DU (DataUnit) + DBIO Unit, DM/DBM 메소드
  - IC → FU (FunctionUnit) 또는 공유 FM
  - FC/BC → FU (FunctionUnit), 공유 FM으로 구현

---

### [Architecture] - 컴포넌트 개념
- z-KESA: 개별 프로그램 단위(AS, PC, DC 등)가 각각 독립 COBOL 프로그램
- n-KESA: Component = Java Class들의 업무적 묶음 단위, 어플리케이션 코드로 명명, jar 파일로 패키징
- z-KESA Detail: 각 프로그램은 독립된 COBOL 소스 파일. 컴파일/링크 후 각 모듈로 배포. #DYCALL로 동적 호출
- n-KESA Detail: 하나의 컴포넌트는 하나의 jar 파일로 패키징되어 배포. 컴포넌트 단위로 hot deploy 가능. 컴포넌트 내 클래스 간 직접 호출 가능, 타 컴포넌트는 프레임워크 API로만 호출
- Mapping Rule: COBOL 프로그램 단위 → Java 클래스(유닛) 단위. 업무적으로 관련 있는 클래스들을 하나의 컴포넌트로 묶어 jar로 배포

---

### [Architecture] - 메소드 개념
- z-KESA: COBOL PARAGRAPH (S0000-MAIN-RTN 등 서브루틴 단위)
- n-KESA: Java 메소드 (PM, FM, DM, DBM)
- z-KESA Detail: PARAGRAPH는 'S0000-~-RTN'으로 시작하고 'S0000-~-EXT'로 종료. PERFORM THRU로 호출
- n-KESA Detail: public IDataSet methodName(IDataSet requestData, IOnlineContext onlineCtx) 형태. @BizMethod 어노테이션 필수. PM/FM/DM/DBM 역할별로 구분
- Mapping Rule: COBOL의 주요 PARAGRAPH 단위 → Java 메소드. S0000-MAIN-RTN → pm[거래코드](), S1000-INITIALIZE-RTN → 메소드 내 초기화 블록, S3000-PROCESS-RTN → FM 메소드 호출 로직, S9000-FINAL-RTN → return responseData

---

## SECTION 2: COBOL DIVISION/SECTION → Java 클래스 구조

---

### [Program Structure] - IDENTIFICATION DIVISION
- z-KESA: IDENTIFICATION DIVISION (PROGRAM-ID, AUTHOR, DATE-WRITTEN)
- n-KESA: Java 클래스 선언부 + JavaDoc 주석
- z-KESA Detail:
```
IDENTIFICATION DIVISION.
PROGRAM-ID. AFA2001.
AUTHOR. 김국민.
DATE-WRITTEN. 08/04/10.
```
  PROGRAM-ID는 프로그램 Member명과 반드시 일치
- n-KESA Detail:
```java
/**
 * 01_일반거래.
 * <pre>
 * 프로그램 설명 :
 * 버전   일자         작성자          설명
 * 0.1    2019-04-19   홍길동        최초 작성
 * </pre>
 * @author admin (Administrator)
 * @since 2019-02-11 09:57:27
 */
@BizUnit(value="클래스한글명", type="PU")
public class PUBnkgNomal extends com.kbstar.sqc.base.ProcessUnit {
```
- Mapping Rule: PROGRAM-ID → 클래스명(명명규칙 적용). AUTHOR/DATE-WRITTEN → @author/@since JavaDoc. @BizUnit 어노테이션으로 클래스 유형 선언

---

### [Program Structure] - ENVIRONMENT DIVISION / CONFIGURATION SECTION
- z-KESA: ENVIRONMENT DIVISION → CONFIGURATION SECTION (SOURCE-COMPUTER, OBJECT-COMPUTER, SPECIAL-NAMES)
- n-KESA: N/A - Java에서 불필요
- z-KESA Detail:
```cobol
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SOURCE-COMPUTER. IBM-Z10.
OBJECT-COMPUTER. IBM-Z10.
SPECIAL-NAMES.
  CLASS COND-ATOZ IS 'A' THRU 'Z'.
```
- n-KESA Detail: Java는 JVM 추상화로 컴퓨터 환경 선언 불필요. SPECIAL-NAMES의 클래스 조건 → Java 상수 클래스(CSampleConsts)로 대체
- Mapping Rule: ENVIRONMENT/CONFIGURATION DIVISION 전체 삭제. SPECIAL-NAMES의 조건 정의 → Java 상수 또는 enum으로 대체

---

### [Program Structure] - ENVIRONMENT DIVISION / INPUT-OUTPUT SECTION
- z-KESA: INPUT-OUTPUT SECTION (BATCH MAIN 프로그램에서 FILE 사용시만 추가)
- n-KESA: 배치 FIO (File I/O) 레이아웃 정의, IFileTool API
- z-KESA Detail: BATCH에서만 파일 정의 시 사용. FILE-CONTROL 단락에서 SELECT, ASSIGN, ORGANIZATION 등 선언
- n-KESA Detail: FIO 명명규칙: FIO(대문자) + 배치유닛명 + 일련번호(2). IFileTool 인터페이스로 파일 처리. 파일 레이아웃은 개발도구에서 정의
- Mapping Rule: COBOL FILE-CONTROL → FIO 레이아웃 정의. OPEN/READ/WRITE/CLOSE → IFileTool.open(), read(), write(), close() API

---

### [Program Structure] - DATA DIVISION / WORKING-STORAGE SECTION
- z-KESA: WORKING-STORAGE SECTION (4개 영역: CONSTANT AREA, WORKING AREA, PGM INTERFACE PARAMETER, DBIO/SQLIO INTERFACE)
- n-KESA: 메소드 내 로컬 변수 선언 + IDataSet requestData + IDataSet responseData
- z-KESA Detail:
  - CONSTANT AREA (CO- 접두사): CO-PGM-ID, CO-STAT-OK('00'), CO-STAT-ERROR('09'), CO-STAT-ABNORMAL('98'), CO-STAT-SYSERROR('99'), 에러코드, 조치코드
  - WORKING AREA (WK- 접두사): WK-I, WK-J 등 작업용 변수, INITIALIZE 시 초기화 필수
  - PGM INTERFACE PARAMETER: 호출할 PC/DC 프로그램 인터페이스 카피북(XPFA0201-CA 등), INITIALIZE 필수
  - DBIO/SQLIO INTERFACE: COPY YCDBIOCA, COPY YCDBSQLA
  - TABLE ACCESS INTERFACE: TKFAEC03-KEY, TRFAEC03-REC 등
- n-KESA Detail:
  - 상수: 별도 상수 클래스(CSampleConsts)에 public static 필드로 선언. 동일 컴포넌트 내에서만 사용
  - 로컬 작업변수: 메소드 내 로컬 변수로 선언 (String, long, BigDecimal 등)
  - 인터페이스 파라미터: IDataSet requestData로 입력, IDataSet responseData로 출력
  - DB 인터페이스: XSQL 파일에 SQL 작성, DM/DBM 메소드로 호출
- Mapping Rule:
  - CO- 변수 → Java 상수 클래스(C[명사형]Consts.java), public static String 선언(final 금지)
  - WK- 변수 → 메소드 내 로컬 변수
  - XPxx-CA 카피북 → IDataSet 객체의 put/getString 등으로 대체
  - YCDBIOCA/YCDBSQLA → 프레임워크 내장 DB 처리 API

---

### [Program Structure] - DATA DIVISION / LINKAGE SECTION
- z-KESA: LINKAGE SECTION (타 프로그램으로부터 DATA를 전달받는 영역)
- n-KESA: 메소드 파라미터 (IDataSet requestData, IOnlineContext onlineCtx)
- z-KESA Detail:
```cobol
LINKAGE SECTION.
01 YCCOMMON-CA.  COPY YCCOMMON.   *필수 - Common Area
01 YNFA2001-CA.  COPY YNFA2001.   *AS 입력 카피북
01 YPFA2001-CA.  COPY YPFA2001.   *AS 출력 카피북 (POINTER 인터페이스)
```
  - YCCOMMON-CA는 프레임워크를 사용하는 모든 프로그램에 첫 번째로 선언 필수
  - POINTER 인터페이스 영역은 USING 구문에 선언된 영역 이후에 정의
- n-KESA Detail:
```java
public IDataSet pmBNE0000401(IDataSet requestData, IOnlineContext onlineCtx) {
    IDataSet responseData = new DataSet();
    CommonArea ca = getCommonArea(onlineCtx);
    ...
}
```
- Mapping Rule:
  - YCCOMMON-CA → IOnlineContext onlineCtx + getCommonArea(onlineCtx)
  - YNxxxx-CA (AS 입력 카피북) → IDataSet requestData의 필드로 접근
  - YPxxxx-CA (AS 출력 카피북) → IDataSet responseData에 put()으로 세팅
  - XPxxxx-CA (PC/DC 인터페이스) → 별도 IDataSet 객체 생성 후 FM/DM 호출 파라미터로 전달

---

### [Program Structure] - DATA DIVISION / WORKING-STORAGE CONSTANT AREA
- z-KESA: CO-AREA 01 레벨, CO- 접두사 상수 (CO-PGM-ID, CO-STAT-OK, CO-STAT-ERROR 등)
- n-KESA: 상수 클래스 (C[명사형]Consts.java) 또는 BusinessException 상수
- z-KESA Detail:
```cobol
01 CO-AREA.
  03 CO-PGM-ID       PIC X(008) VALUE 'AFA2001 '.
  03 CO-STAT-OK      PIC X(002) VALUE '00'.
  03 CO-STAT-ERROR   PIC X(002) VALUE '09'.
  03 CO-STAT-ABNORMAL PIC X(002) VALUE '98'.
  03 CO-STAT-SYSERROR PIC X(002) VALUE '99'.
  03 CO-B1050001     PIC X(008) VALUE 'B1050001'.
  03 CO-UKFA5002     PIC X(008) VALUE 'UKFA5002'.
```
- n-KESA Detail:
```java
public class CSampleConsts {
    public static String STAT_OK = "00";
    public static String STAT_ERROR = "09";
    public static String ERR_B1050001 = "B1050001";
    public static String TRT_UKFA5002 = "UKFA5002";
}
```
- Mapping Rule: CO-STAT-OK/ERROR 등 상태코드 상수 → 상수 클래스 필드. CO-B(에러코드), CO-U(조치코드) → 상수 클래스 또는 BusinessException 생성자 인라인 리터럴. INITIALIZE 불필요(static 초기화)

---

### [Program Structure] - PROCEDURE DIVISION 기본 구조
- z-KESA: PROCEDURE DIVISION USING YCCOMMON-CA YNFA2001-CA. → 4개 표준 PARAGRAPH
- n-KESA: public IDataSet pmXXX(IDataSet requestData, IOnlineContext onlineCtx) 메소드 본체
- z-KESA Detail:
```cobol
PROCEDURE DIVISION USING YCCOMMON-CA YNFA2001-CA.
S0000-MAIN-RTN.        *전체 처리 메인
S1000-INITIALIZE-RTN.  *초기화
S2000-VALIDATION-RTN.  *입력값 검증
S3000-PROCESS-RTN.     *업무처리
S9000-FINAL-RTN.       *처리종료 (#OKEXIT 호출)
```
- n-KESA Detail:
```java
public IDataSet pmBNE0000401(IDataSet requestData, IOnlineContext onlineCtx) {
    IDataSet responseData = new DataSet();
    CommonArea ca = getCommonArea(onlineCtx);
    // 입력값 검증
    // 업무 로직 작성
    // 출력 값 설정
    return responseData;
}
```
- Mapping Rule:
  - S0000-MAIN-RTN → 메소드 본체 전체
  - S1000-INITIALIZE-RTN → 메소드 상단 변수 초기화 블록
  - S2000-VALIDATION-RTN → 입력값 검증 로직 (if 조건으로 BusinessException throw)
  - S3000-PROCESS-RTN → 업무 로직 (FM/DM 호출 등)
  - S9000-FINAL-RTN → return responseData

---

### [Program Structure] - 사용금지 명령어 대응
- z-KESA: EXEC CICS 사용금지, EXEC SQL 사용금지, GOBACK 사용금지, DISPLAY 사용금지, CALL 사용금지, GOTO 사용제한
- n-KESA: 대응 금기 규칙
- z-KESA Detail:
  - EXEC CICS → 프레임워크 MACRO 사용
  - EXEC SQL → DBIO 또는 SQLIO 사용
  - GOBACK → 온라인에서 #ERROR 또는 #OKEXIT 사용, BATCH MAIN에서만 허용
  - DISPLAY → #USRLOG MACRO 사용
  - CALL → #DYCALL MACRO 사용
  - GO TO → PARAGRAPH 내 GOTO만 가능, '-GO'로 종료
  - IF → END-IF로 반드시 종료
  - IN LINE PERFORM → END-PERFORM으로 종료
- n-KESA Detail:
  - System.exit() 호출 금지
  - java.lang.Runtime 객체 사용 금지
  - java.lang.Thread 상속 금지
  - System.out/System.err 사용 금지 → logger 사용
  - printStackTrace() 직접 호출 금지
  - String + 연산 금지 → StringBuffer 사용
  - record.toString() 직접 사용 금지
  - COMMIT/ROLLBACK SQL 구문 XSQL에 직접 사용 금지 (프레임워크가 관리)
  - System.gc() 호출 금지
  - for 루프 조건에 method 호출 금지
- Mapping Rule: COBOL 사용금지 명령어 → Java 금기 규칙으로 대응. 각 금지 항목별 대체 방법 적용

---

## SECTION 3: 프로그램간 호출 방법

---

### [Program Call] - #DYCALL 매크로 (표준 Dynamic 호출)
- z-KESA: #DYCALL [PGM명] YCCOMMON-CA [프로그램간 인터페이스 영역 1…n]
- n-KESA: callSharedMethod*() API 또는 @BizUnitBind 직접 호출
- z-KESA Detail:
```cobol
*검증PC DYNAMIC호출
#DYCALL PFA0201 YCCOMMON-CA XPFA0201-CA
*결과 확인
IF NOT COND-XPFA0201-OK
  #ERROR CO-B0150001 CO-UKFA5001 CO-STAT-ERROR
END-IF
*다중 파라미터 호출
#DYCALL DFA9202 YCCOMMON-CA XDFA9202-CA XDFA9106-CA
```
  - 반드시 YCCOMMON-CA가 첫 번째 파라미터
  - 프로그램명은 Dynamic Load로 런타임에 결정
- n-KESA Detail:
  - 동일 컴포넌트 내 FM 호출: @BizUnitBind로 FU를 주입 후 직접 메소드 호출
  - 동일 어플리케이션 코드 내 타 컴포넌트 FM 호출: callSharedFM() API
  - 다른 어플리케이션 간 FM 호출: callSharedFM() API (공유 FM만 가능)
  - PM 간 호출: 연동거래 API 사용
```java
@BizUnitBind
private FUPpsnCustMgt fuPpsnCustMgt;
// 직접 호출
IDataSet result = fuPpsnCustMgt.registerPpsnCust(requestData, onlineCtx);
```
- Mapping Rule: #DYCALL [PC명] → @BizUnitBind 주입 후 fm메소드() 직접 호출 또는 callSharedFM(). #DYCALL [DC명] → @BizUnitBind 주입 후 dm메소드() 직접 호출 또는 callSharedMethod(). YCCOMMON-CA 파라미터 → onlineCtx 파라미터로 대응

---

### [Program Call] - #STCALL 매크로 (STATIC 호출)
- z-KESA: #STCALL [PGM명] YCCOMMON-CA [인터페이스 영역]
- n-KESA: 동일 컴포넌트 내 직접 메소드 호출 (컴파일 타임 결정)
- z-KESA Detail: 프로그램을 STATIC 방식으로 호출. Dynamic과 달리 링크 편집 시 프로그램명 결정. 성능상 이점 있으나 유연성 감소
- n-KESA Detail: Java는 기본적으로 컴파일 타임에 클래스 참조가 결정됨. @BizUnitBind 사용 시 동일 컴포넌트 내에서 직접 클래스 참조. 타 컴포넌트는 항상 프레임워크 API 경유
- Mapping Rule: #STCALL → @BizUnitBind로 주입된 유닛의 직접 메소드 호출 (동일 컴포넌트 내). 성능 차이는 JVM JIT 컴파일로 자동 최적화됨

---

### [Program Call] - 비표준 프로그램 호출 (Common Area 미사용)
- z-KESA: #DYCALL [유틸리티명] [인터페이스영역] (YCCOMMON-CA 생략)
- n-KESA: 유틸리티 클래스 정적 메소드 직접 호출
- z-KESA Detail:
```cobol
*ZSGTIME을 DYNAMIC 호출 (YCCOMMON-CA 파라미터 없음)
#DYCALL ZSGTIME XZSGTIME-CA
```
  Common Area를 참조하지 않는 Assembly 모듈 또는 유틸리티 패키지 호출
- n-KESA Detail:
```java
// 유틸리티 클래스 직접 호출 예
String runtimeId = BaseUtils.getRuntimeId();
String envMode = BaseUtils.getRuntimeMode();
```
- Mapping Rule: 비표준 #DYCALL → 프레임워크 유틸리티 클래스(BaseUtils, StringUtils, KBCryptoUtils 등) 정적 메소드 직접 호출

---

### [Program Call] - AS 프로그램 호출 (프레임워크 스케줄러)
- z-KESA: 프레임워크 스케줄러(ZMFGATE)에서 YCCOMMON-CA + YNxxxxxx-CA(입력 메시지 AREA)를 파라미터로 AS 호출
- n-KESA: 프레임워크 런타임이 거래코드 기반으로 pm[거래코드]() 메소드 호출
- z-KESA Detail: AS 프로그램은 직접 호출되지 않고 항상 프레임워크가 스케줄 후 호출. PROCEDURE DIVISION USING YCCOMMON-CA YNFA2001-CA.
- n-KESA Detail: 거래 프로파일에 등록된 거래코드와 PM 메소드명(pmBNE0000401)이 1:1 매핑. 프레임워크 런타임이 거래코드로 PM을 lookup하여 호출
- Mapping Rule: ZMFGATE → 프레임워크 런타임 (자동). 거래코드 기반 AS 매핑 → 거래 프로파일 등록 + pm[거래코드] 메소드 명명 규칙

---

### [Program Call] - 계층 구조별 호출 가능 범위
- z-KESA: AS→PC→IC→DC→BC, AS→DC 직접 호출 가능
- n-KESA: PM→FM→DM/DBM, PM→DM, FM→FM (동일 레이어 가능), DM→DM 불가
- z-KESA Detail: 어플리케이션 계층구조상 상위 레이어만 하위 레이어 호출. AS에서 PC, DC, IC를 직접 호출 가능. PC에서 DC, IC, BC 호출. BC는 전행공통 컴포넌트
- n-KESA Detail:
  - PM→FM 가능, PM→DM 가능
  - FM→FM 가능 (동일 레이어 내)
  - DM→DM 불가 (X), DM→DBM 불가 (X)
  - DBM→DBM 불가 (X), DBM→DM 불가 (X)
  - 타 컴포넌트 PM 직접 호출 불가 (연동거래 API 사용)
- Mapping Rule: z-KESA 계층 호출 규칙 → n-KESA 호출 관계 규칙으로 대응. AS→PC→DC 흐름 → PM→FM→DM/DBM으로 재구성. IC(2개 이상 DC 조합) → FU의 FM으로 재구현

---

### [Program Call] - 타 컴포넌트 호출 API
- z-KESA: #DYCALL [프로그램명] YCCOMMON-CA [인터페이스]
- n-KESA: callSharedFM(), callSharedDM(), callSharedMethod***() API
- z-KESA Detail: 모든 프로그램 호출은 #DYCALL 단일 매크로로 처리. 어플리케이션 코드 구분 없이 동일 패턴
- n-KESA Detail:
  - 동일 어플리케이션 코드 내 타 컴포넌트의 공유 FM/DM: callSharedMethod***() API
  - 다른 어플리케이션 간: 공유 FM만 호출 가능 (DM 불가, DM을 감싸는 FM 생성 필요)
  - "공유메소드 여부" 속성을 "예"로 설정한 메소드만 타 컴포넌트에서 호출 가능
- Mapping Rule: #DYCALL → 호출 대상 레이어 및 어플리케이션 경계에 따라 적절한 callSharedMethod API 선택

---

### [Program Call] - CALL 문 (비표준 케이스)
- z-KESA: CALL [프로그램명] USING [파라미터] END-CALL (부득이한 경우만 허용)
- n-KESA: N/A - 직접 Java 메소드 호출로 대체
- z-KESA Detail: CALL 문은 사용금지이나 부득이한 경우 사용 가능. 반드시 END-CALL로 종료
- n-KESA Detail: Java에서 외부 라이브러리 호출은 jar 의존성 추가 후 직접 클래스 메소드 호출. 외부 라이브러리 배포는 별도 CM 절차 필요
- Mapping Rule: COBOL CALL → Java 클래스 메소드 직접 호출. 외부 모듈은 jar로 패키징하여 의존성 추가

---

## SECTION 4: Common Area

---

### [Common Area] - Common Area 전체
- z-KESA: YCCOMMON-CA (COPY YCCOMMON), 모든 프로그램의 첫 번째 LINKAGE 파라미터로 필수
- n-KESA: IOnlineContext 내의 CommonArea 객체, getCommonArea(onlineCtx)로 접근
- z-KESA Detail:
  - YCCOMMON 카피북으로 정의된 공통 영역
  - BICOM- 접두사로 항목 접근 (예: BICOM-HNDLN-BRNCD, BICOM-USER-EMPID, BICOM-USER-NAME, BICOM-SLIP-NO, BICOM-TRAN-START-YMS)
  - LINKAGE SECTION에 01 YCCOMMON-CA. COPY YCCOMMON. 선언 필수
  - 모든 #DYCALL의 첫 번째 파라미터로 전달
- n-KESA Detail:
  - IOnlineContext 객체에 포함되어 거래 시작부터 종료까지 유지
  - CommonArea ca = getCommonArea(onlineCtx);로 접근
  - JICOM 공통영역, 도메인별 공통영역, 입력매체부 항목 등 업무별 영역 포함
  - 3.7절 IOnlineContext 상세 참조
- Mapping Rule: 01 YCCOMMON-CA (COPY YCCOMMON) → IOnlineContext onlineCtx 파라미터 + CommonArea ca = getCommonArea(onlineCtx). BICOM-XXXX 항목 → ca.get[항목명]() 또는 ca.[필드명]으로 접근

---

### [Common Area] - JICOM 공통영역 생성
- z-KESA: Common Area 내 JICOM 영역 (프레임워크가 자동 구성)
- n-KESA: JICOM 공통영역 생성 API (3.7.4.1)
- z-KESA Detail: 프레임워크(ZMFGATE)가 내부표준전문의 공통부를 Common Area의 JICOM 영역으로 자동 편집. BICOM-HNDLN-BRNCD(취급부점코드), BICOM-USER-EMPID(사용자번호), BICOM-USER-NAME(사용자이름) 등
- n-KESA Detail: 3.7.4.1 JICOM 공통영역 생성 API 사용. 거래 입력 시 프레임워크가 자동으로 CommonArea 내 JICOM 영역에 매핑
- Mapping Rule: BICOM-HNDLN-BRNCD → ca.getJicom().getHndlnBrncd() 등 CommonArea 하위 JICOM 영역 접근

---

### [Common Area] - 입력매체부 항목
- z-KESA: Common Area 내 입력매체부 (채널 구분 정보 등)
- n-KESA: CommonArea 내 입력매체부 항목 사용 (3.7.4.2)
- z-KESA Detail: Common Area의 입력매체부에 채널(MCI/EAI), 단말종류, 거래매체 등 정보 포함
- n-KESA Detail: 3.7.4.2 참조. 입력매체부 항목은 CommonArea의 전용 영역으로 접근
- Mapping Rule: BICOM 내 매체부 항목 → CommonArea 입력매체부 항목 접근 API

---

### [Common Area] - 도메인별 공통영역
- z-KESA: Common Area 내 도메인별 영역 (업무팀별 추가 공통 영역)
- n-KESA: 도메인별 공통영역 생성 (3.7.4.3, 3.7.4.4)
- z-KESA Detail: 공통부 이외에 도메인(업무)별로 공통영역을 추가할 수 있음. 예) 계정계 공통영역, 수신 도메인 공통영역 등
- n-KESA Detail: 3.7.4.3 도메인별 공통영역 생성, 3.7.4.4 거래호출 내 사용자정의 공통영역 생성. CommonArea 내 업무별 영역으로 관리
- Mapping Rule: z-KESA Common Area 도메인 영역 → n-KESA CommonArea 내 도메인별 업무별 영역 생성 API 사용

---

### [Common Area] - 책임자 승인 정보 영역
- z-KESA: Common Area 내 책임자 정보 항목 (BICOM-N1ST-SPVSR-EMPID 등)
- n-KESA: CommonArea 내 책임자 승인 정보 영역
- z-KESA Detail:
  - 승인완료구분코드(1): 0:승인무/1:요청/2:완료/3:거절/4:취소
  - 책임자승인 대표구분코드(1): 0:일반/1:단순/3:복수/4:복수(지점장)/5:복수(내부통제)
  - 승인요청사유건수(2), 책임자직원번호(7), 책임자이름(20), 책임자소속부점(4) × 2
  - 승인사유코드 01~10 (80byte)
  - 책임자 승인 유틸리티: CJISUPR (XCJISUPR 카피북)
- n-KESA Detail: CommonArea 내 책임자 승인 관련 영역. 프레임워크에서 관리. EAI M/F 연계시 책임자승인 처리는 3.9.11.1 참조
- Mapping Rule: XCJISUPR-CA + #DYCALL CJISUPR → CommonArea 책임자 승인 영역 API 또는 전행공통 FU 호출

---

### [Common Area] - 연동 출력부 정보
- z-KESA: Common Area 내 연동부 정보 (BICOM-SLIP-NO 등)
- n-KESA: CommonArea 내 연동 관련 정보
- z-KESA Detail: BICOM-SLIP-NO(전표번호), 연동정보 영역. 연동출력편집프로그램 YCSFOAYE 카피북의 연동거래코드/연동카피북명/연동포인터 정보
- n-KESA Detail: 연동거래 시 CommonArea 복제(3.8.9.6). 연동거래간 데이터는 IDataSet으로 전달
- Mapping Rule: BICOM-SLIP-NO → CommonArea 내 전표번호 항목. YCSFOAYE 연동 포인터 → IDataSet 객체 직접 전달

---

## SECTION 5: 입출력 메시지 편집

---

### [IO Editing] - BIM (Bancs I/O Manager) / 입출력 편집 등록
- z-KESA: BIM (Bancs I/O Manager) - RDz 플러그인, 카피북 관리, 입출력 편집정보 관리
- n-KESA: NEXCORE 개발도구 - MMI(전문관리통합시스템) + 메소드 IO 설계기
- z-KESA Detail:
  - BIM 기능: 카피북(Copybook) 관리, 입출력 편집정보 관리, 거래스케줄 파라미터 관리, 연동정의 정보 관리, 연동 편집정보 관리
  - 거래입출력항목설계서 Excel Import → 내부표준전문 카피북 자동생성
  - AS 입력 카피북 등록: 프로그램설계서 Excel Import → 카피북 자동생성
  - 입력편집정보 등록: 내부표준전문 ↔ AS 입력카피북 매핑 (자동편집/수동편집)
  - 출력편집정보 등록: AS 출력카피북 ↔ 매체별 전문 카피북 매핑
  - 최대 200개 편집항목 (초과시 그룹항목 처리)
- n-KESA Detail:
  - MMI(전문관리통합시스템)로부터 배포받은 전문을 IO Assist에서 검색하여 PM IO 설계에 적용
  - 메소드 IO 설계기에서 Input/Output 항목 직접 정의 (고정길이 구조)
  - 항목ID (Camel표기법), 항목명, 데이터유형, 길이, 길이참조, 패딩, 패딩문자 설정
  - 반복부 처리: 레코드셋으로 정의, 길이참조 필드 지정
  - FM/DM의 IO: 고정길이 여부 "아니오", 데이터유형+검증유형만 설정
- Mapping Rule: BIM 입력편집 등록 → MMI 배포 + PM IO 설계기에서 Input 항목 정의. BIM 출력편집 등록 → PM IO 설계기 Output 항목 정의 + addOutFormInfo() API

---

### [IO Editing] - 카피북 명명규칙
- z-KESA: Y[Type][프로그램ID] 체계 (예: YCCOMMON, YNJI4719, YPJI4719, XPFA2001)
- n-KESA: N/A - 카피북 개념 없음, IDataSet의 필드키(Camel표기법)로 대체
- z-KESA Detail:
  - YC: Common Area/Framework 공통 (예: YCCOMMON)
  - YG: 계리 (General Ledger, 예: YGJK0001)
  - YL: 로그 (예: YLJK0001)
  - YW: Work (예: YWJK0001)
  - YN: AS 프로그램 입력 (예: YNJI3001)
  - YP: AS 프로그램 출력 (예: YPJI3001)
  - XP: 프로그램 인터페이스 (AS/DBIO 제외, 예: XPJI3001)
  - TK: DBIO 테이블 KEY (예: TKJI0101 = TK+테이블명4번째부터 6자리)
  - TR: DBIO 테이블 RECORD (예: TRJI0101)
  - V1~V6: 매체별 출력 카피북 (V1:화면, V2:통장, V3:전표, V4:영수증, V5:장표, V6:임의장표)
  - VY: 연동출력부 카피북
- n-KESA Detail: 카피북 없음. IDataSet의 키(fieldId)가 Camel 표기법의 문자열. 클래스명/메소드명은 명명규칙 참조
- Mapping Rule: YCCOMMON → IOnlineContext/CommonArea. YNxxxx → requestData 필드. YPxxxx → responseData 필드. XPxxxx → FM/DM 호출용 별도 IDataSet. TKxxxx/TRxxxx → DBIO 자동생성 클래스(DBIO_테이블명)의 DBM 메소드 파라미터

---

### [IO Editing] - COBOL 데이터 타입 → Java 타입 변환
- z-KESA: PIC X(n), PIC 9(n), PIC S9(n), OCCURS, REDEFINES, POINTER
- n-KESA: String, long, BigDecimal, IRecordSet, 별도 처리
- z-KESA Detail:
  - X(n): 문자 (BIM 타입 'X')
  - 9(n): 정수 (BIM 타입 'N')
  - S9(n) LEADING SEPARATE: 부호 있는 정수 (BIM 타입 'S')
  - OCCURS n TIMES: 배열 (BIM 타입 'A')
  - REDEFINES: 재정의 (BIM 타입 'R')
  - VALUE 'xx': 조건 (BIM 타입 'C')
  - POINTER: 포인터 인터페이스
- n-KESA Detail:
  - X(n) → String (MMI IO 설계에서 string 타입, 패딩=right, 패딩문자=0x20)
  - 9(n), S9(n) → long (int는 금액 표현 부족), 금액은 반드시 long 또는 BigDecimal
  - S9(n)V9(m) 소수 → BigDecimal (double/float 사용 금지)
  - OCCURS n TIMES → IRecordSet (레코드셋, 반복부)
  - 가변 반복부 → IRecordSet + 길이참조 필드 (레코드건수 필드 별도 정의)
  - REDEFINES → 동일 데이터를 다른 타입으로 접근 시 Java 타입 변환 로직으로 처리
  - POINTER → N/A (Java는 객체 참조로 처리)
- Mapping Rule: 타입 변환 규칙 표로 정리. 금액 필드는 반드시 long 또는 BigDecimal. 반복부는 IRecordSet으로 변환

---

### [IO Editing] - 200개 초과 편집항목 처리
- z-KESA: 그룹항목으로 묶어 처리 (입력편집 최대 200개 제한)
- n-KESA: N/A - IDataSet은 항목 수 제한 없음
- z-KESA Detail: BMS의 입력편집정보 관리 테이블이 최대 32K로 구성되어 200개 항목까지 수용. 초과 시 의미있는 GROUP 항목으로 묶어서 등록. 그룹항목으로 묶인 내부 항목은 Validation 불가, 조건연동 대상 항목 제외 필수
- n-KESA Detail: IDataSet은 Map 기반으로 항목 수 제한 없음. 레코드셋 내 컬럼도 제한 없음
- Mapping Rule: BMS 200개 제한으로 인한 그룹항목 처리 로직 → n-KESA에서는 자연스럽게 IDataSet으로 모든 항목 처리 가능. 그룹 개념은 IDataSet 내 데이터셋 중첩으로 표현 가능

---

### [IO Editing] - 전표/영수증 버전번호 관리
- z-KESA: 2.2.8 전표/영수증 출력매체 재인자 처리를 위한 버전 관리
- n-KESA: addOutFormInfo()의 copies 파라미터로 반복 출력 제어
- z-KESA Detail: 전표/영수증 재인자 처리를 위해 출력카피북에 버전번호 항목 포함. BIM에서 관리
- n-KESA Detail: addOutFormInfo("formId", "V3", "01", ...) copies 파라미터로 출력 매수 제어. fCopies/bCopies로 수표 앞면/뒷면 매수 제어
- Mapping Rule: 버전번호 기반 재인자 처리 → addOutFormInfo()의 copies/fCopies/bCopies 파라미터로 출력 제어

---

## SECTION 6: 연동정의 및 연동편집

---

### [Integration] - 연동정의 등록
- z-KESA: BIM에서 연동정의 설계서 등록 (연동스케줄링 설계서)
- n-KESA: 연동거래 API (3.8.9)
- z-KESA Detail:
  - 연동정의: 하나의 입력거래에서 최대 20개의 연동수행 지원
  - 기동거래(선행 AS) → 수동거래(후행 AS) 구조
  - 조건부 연동: 입력값의 유무에 따라 연동 생성 결정
  - 연동처리 취소처리 순서 정의
  - BIM 입력편집 타입 'Y' 항목에 연동 AS 거래코드 등록
- n-KESA Detail:
  - 동기 단일 트랜잭션 연동: 3.8.9.1
  - 동기 예외처리+트랜잭션 연동: 3.8.9.2
  - 비동기 연동거래: 3.8.9.3
  - 비동기 연동거래 수동거래 응답 Merge: 3.8.9.4
  - 지연비동기 연동거래: 3.8.9.5
  - 연동거래 시 CommonArea 복제: 3.8.9.6
  - 연동거래 사용패턴: 3.8.9.7
- Mapping Rule: z-KESA 연동정의 BIM 등록 → n-KESA 연동거래 API 코드로 구현. 조건부 연동 → if 조건문 + 연동거래 API 조건부 호출

---

### [Integration] - 연동거래간 편집 (선행→후행 데이터 전달)
- z-KESA: BIM에서 연동거래간 편집 정보 등록 (선행 AS 출력 → 후행 AS 입력 매핑)
- n-KESA: IDataSet 객체를 직접 구성하여 연동거래 API에 전달
- z-KESA Detail: BIM의 연동편집 정보 관리: 연동 AS간 입력/출력 카피북 필드 매핑 등록. 선행 AS의 출력 카피북 필드 → 후행 AS의 입력 카피북 필드로 자동 편집. 연동 편집도 200개 항목 제한 있음
- n-KESA Detail: 연동거래 API 호출 시 IDataSet을 생성하여 필요한 필드를 put()으로 세팅 후 전달. responseData.put("key", value)로 직접 구성
- Mapping Rule: BIM 연동 편집 등록 (필드 매핑) → Java 코드 내 IDataSet.put("fieldKey", value) 직접 조립으로 대체

---

### [Integration] - 연동출력편집 프로그램
- z-KESA: 연동출력편집 PC 프로그램 (YCSFOAYE 카피북 기반)
- n-KESA: MCI 출력전문 조립 (addOutFormInfo API)
- z-KESA Detail:
  - 기동 AS의 매체별 출력영역과 수동 AS의 연동출력부를 입력으로 추가 편집
  - PC 프로그램으로 작성, 거래파라미터에 등록
  - YCSFOAYE 카피북: 거래코드, 매체건수, 매체영역(카피북명/포인터) × 10, 연동건수, 연동거래코드/카피북명/포인터 × 19
  - V1FA2001-CA(화면), V2HC0001-CA(통장), V3FA2001-CA(전표), V4FA2001-CA(영수증), V5FA2001-CA(장표), V6FA2001-CA(임의장표) 매체 포인터 SET
  - VY+거래코드 연동출력부 카피북 포인터로 수동 AS 데이터 접근
- n-KESA Detail:
  - addOutFormInfo(String formId, String formType, String copies, String elctrFxdDstCd, String fCopies, String bCopies, IOnlineContext onlineCtx)
  - 출력 FormType: V0(공통출력부), V1(화면), V2(통장), V3(전표), V4(영수증), V5(장표), V6(임의장표), V7(EAI개설), V8(강제메시지)
  - 복수 폼 등록 시 addOutFormInfo 반복 호출
- Mapping Rule: 연동출력편집 PC 프로그램 전체 → addOutFormInfo() API 호출로 대체. V1~V6 매체 포인터 → FormType 파라미터(V1~V6). VYFA1001→V1FA2001 매핑 로직 → IDataSet 필드 복사 로직으로 변환

---

### [Integration] - 연동처리 취소처리
- z-KESA: 2.3.4 연동처리 취소처리 (연동스케줄에 취소처리순서 정의)
- n-KESA: 비동기 취소 처리 (3.9.8)
- z-KESA Detail: 연동스케줄 정의에 취소처리순서 추가. 거래 취소 시 정의된 순서로 연동거래 취소 수행
- n-KESA Detail: 비동기 취소 처리: 타이머 기동(3.9.8.1), 타이머 취소(3.9.8.2). IR방식/SAF방식 구분(3.9.7.5/3.9.7.6)
- Mapping Rule: 연동 취소처리 순서 → 비동기 취소 처리 API + 타이머 처리 로직

---

## SECTION 7: 거래 파라미터 등록

---

### [Transaction Parameter] - 거래 파라미터 등록
- z-KESA: BIM에서 거래스케줄파라미터 등록 (거래파라미터설계서 자동등록)
- n-KESA: 거래 프로파일 등록 (관리콘솔 또는 자동등록)
- z-KESA Detail: 거래코드별 파라미터 정보 등록. 거래스케줄파라미터에 연동출력편집프로그램명 등록. 거래파라미터 항목: AS 거래코드, 연동정보, 출력편집 정보 등
- n-KESA Detail: 거래 프로파일에 PM 메소드와 거래코드 1:1 매핑 등록. 개발 시 첫 거래 시 자동 등록. 스테이징/운영은 CM 절차로 등록. 관리콘솔(8.2.1 거래프로파일, 8.2.2 거래프로파일속성상세) 참조
- Mapping Rule: BIM 거래스케줄파라미터 → 거래 프로파일 등록. 자동등록: 개발환경에서 첫 거래 시 자동. 운영: CM 절차 필요

---

## SECTION 8: DBIO / SQLIO

---

### [DB Access] - DBIO 프로그램
- z-KESA: DBIO 프로그램 (#DYDBIO 매크로로 호출)
- n-KESA: DBIO Unit (DBM 메소드: insert, select, selectForUpdate, update, delete)
- z-KESA Detail:
  - TK[테이블명]: 테이블 KEY 카피북
  - TR[테이블명]: 테이블 RECORD 카피북
  - YCDBIOCA: DBIO Interface Parameter 카피북 (Command, Access Key, 실행결과 상태, SQL Code)
  - 결과코드: 00(정상), 01(중복/DUPM), 02(없음/MRNF), 09(기타 SQL Status), 98/99(비정상/System Error)
  - COPY YCDBIOCA 선언 + #DYDBIO 호출
  - EVALUATE 로 결과코드 확인: COND-DBIO-OK, COND-DBIO-DUPM, COND-DBIO-MRNF
  - Lock SELECT: 갱신을 수반하는 경우에만 사용
  - 복수 Row Update 불허
- n-KESA Detail:
  - DBIO_[테이블명] 클래스 자동생성 (IDE에서 테이블 선택 시 코드 자동생성)
  - DBM 메소드: insert(), select(), selectForUpdate(), update(), delete()
  - 계정성 업무에서 CUD는 반드시 DBIO를 통해 처리
  - LOB/Binary 컬럼 사용 불가
  - 타 DB 테이블 CUD 시 DBIO 사용 불가 (DU 사용, 사전 협의 필요)
  - DBIO 로그: 보정로그 적재, 변경로그(CHGLOG) 파일 적재
- Mapping Rule:
  - TKxx + TRxx + YCDBIOCA + #DYDBIO → DBIO_테이블명 클래스의 DBM 메소드 직접 호출
  - COND-DBIO-DUPM(01) → DataException (Insert 중복 에러) catch
  - COND-DBIO-MRNF(02) → 단건조회 결과 null 처리 또는 DataException
  - COND-DBIO-OK(00) 이외 → DataException 또는 BusinessException throw

---

### [DB Access] - SQLIO 프로그램
- z-KESA: SQLIO 프로그램 (#DYSQLA 매크로로 호출)
- n-KESA: DataUnit (DU)의 DM 메소드 + XSQL 파일
- z-KESA Detail:
  - 사용자 작성 SQL을 이용한 DB Access 모듈
  - #DYSQLA USING [SQLIO명] [SQLIO 카피북] 형태로 호출
  - Multi-Row Fetch: 한번의 Call로 원하는 Row를 받은 후 다음 Key를 Set하여 재호출
  - SELECT List에 반드시 사용될 Column만 기술 (SELECT * 금지)
  - Dynamic SQL 사용 금지
  - 복수 Row Update 불허, Cursor 사용 원칙
  - LOCK SELECT는 갱신 수반 시만 사용
- n-KESA Detail:
  - DataUnit(DU) 클래스의 DM 메소드: select(), selectList() 등
  - XSQL 파일에 SQL 작성. DU와 XSQL 1:1 매핑
  - 단건조회: dbSelect("sqlId", paramDataset)
  - 다건조회: dbSelect("sqlId", paramDataset) → IRecordSet
  - 페이징 처리: 3.5.7 참조
  - FOR UPDATE → selectForUpdate DBM 메소드
  - WITH UR → XSQL에 WITH UR 직접 기술 (3.5.17.1)
  - 바인드 변수: #변수명:타입# 형식 (DB2는 타입 명시 필수)
- Mapping Rule:
  - SQLIO + #DYSQLA → DU의 DM 메소드 + XSQL
  - SQLIO 카피북 → XSQL의 SQL ID와 IDataSet 파라미터
  - Multi-Row Fetch → 페이징 처리 API 또는 selectList로 전체 조회
  - SQLIO SELECT * 금지 → XSQL SELECT 절에 사용 컬럼만 명시

---

### [DB Access] - DBIO/SQLIO 소스생성 제약사항
- z-KESA: 3.5.3 DBIO 및 SQLIO 소스생성 제약사항
- n-KESA: DBIO 사용 시 유의사항 (1.1.6)
- z-KESA Detail: 자동생성 소스 임의 변경 금지. 테이블 레이아웃 변경 시 재생성 필수
- n-KESA Detail: DBIO 자동생성 코드는 개발자 임의 변경 불가. 테이블 레이아웃 변경 시 IDE에서 DBIO 재생성. LOB/Binary 타입 컬럼 사용 불가. 타 DB CUD 불가
- Mapping Rule: 동일 원칙 적용. 자동생성 코드는 수정 금지, 재생성으로 반영

---

### [DB Access] - #DBCALL 매크로 (직접 SQL)
- z-KESA: #DBCALL (DBIO/SQLIO 생성 없이 직접 SQL 사용)
- n-KESA: DU의 XSQL 직접 작성 + dbUpdate/dbInsert/dbDelete API
- z-KESA Detail: BATCH 프로그램에서 SQL 직접 사용 시 작성방법. 5.4.8 SQL 직접 사용시 작성방법 참조
- n-KESA Detail: 배치에서 배치 클래스 부모(BatchUnit)의 dbSelect, dbUpdate, dbInsert, dbDelete 메소드로 DB 직접 접근. XSQL 파일에 SQL 작성
- Mapping Rule: BATCH #DBCALL → BatchUnit 부모 클래스의 db* 메소드 + XSQL

---

## SECTION 9: Error 처리

---

### [Error Handling] - #ERROR 매크로 (단일 에러)
- z-KESA: #ERROR [에러코드] [조치코드] [상태코드]
- n-KESA: throw new BusinessException("에러코드", "조치코드", "맞춤메시지")
- z-KESA Detail:
```cobol
#ERROR CO-B0150001 CO-UKFA5001 CO-STAT-ERROR
```
  - 즉시 해당 거래를 종료하고 Common Area에 에러 정보 SET
  - 에러 발생 시점에서 즉시 오류종료처리, 직전 프로그램으로 Return
  - 에러코드 체계: B[에러유형구분][일련번호] (B:비즈니스, S:시스템, D:DB I/O)
  - 조치코드 체계: U[어플리케이션코드][일련번호] (예: UKJI0001)
  - 상태코드: CO-STAT-ERROR('09'), CO-STAT-ABNORMAL('98'), CO-STAT-SYSERROR('99')
- n-KESA Detail:
```java
throw new BusinessException("B0150001", "UKFA5001", "맞춤메시지");
// 또는
throw new BusinessException("B0150001", "UKFA5001", "맞춤메시지", exception);
// ReturnStatus 사용
throw new BusinessException("에러코드", "조치메시지코드", returnStatus);
```
  - 3.6.3 단일 에러 처리. catch(BusinessException e) { throw e; } 패턴
  - 3.6.3.1 BusinessException 사용 예, ReturnStatus 사용 예
- Mapping Rule: #ERROR [에러코드] [조치코드] [상태코드] → throw new BusinessException("에러코드", "조치코드", ...). 에러코드/조치코드 체계 동일 유지

---

### [Error Handling] - #MULERR 매크로 (멀티 에러)
- z-KESA: #MULERR START ... #MULERR END (최대 10건)
- n-KESA: addBusinessException() API (3.6.4)
- z-KESA Detail:
```cobol
#MULERR START
IF YNKLA010-ACNO = SPACE
  #ERROR B1000001 U1000111 CO-STAT-ERROR
END-IF
...
#MULERR END
```
  - 창구거래 입력 데이터 정당성 체크에만 사용
  - 검증 PC에서만 사용
  - 멀티에러 시작/종료 구간에서 호출 가능 프로그램: 전행공통 BC만 가능
  - 10건 초과 시 직전 10건 에러정보 편집 후 종료
  - 멀티에러 진행 중 책임자승인 등 예외사항 발생 시 예외사항 발생 전 멀티에러 정보 편집 후 종료
- n-KESA Detail:
```java
// 멀티에러 추가
addBusinessException("B1000001", "U1000111");
addBusinessException("B1000021", "U1000111");
// 에러 확인 후 throw
```
  - 3.6.4 멀티 에러 처리. addBusinessException 사용 예(3.6.4.1)
- Mapping Rule: #MULERR START/END 블록 → addBusinessException() 반복 호출. 멀티에러 10건 제한 → 동일하게 최대 10건 적용

---

### [Error Handling] - #CSTMSG 매크로 (사용자 맞춤메시지)
- z-KESA: #CSTMSG [맞춤메시지 내용]
- n-KESA: BusinessException 생성자 세 번째 파라미터 "맞춤메시지"
- z-KESA Detail:
```cobol
*사용자 맞춤메시지 SET 후 #ERROR 호출
#CSTMSG 입력항목별 오류내용...
#ERROR CO-B0150001 CO-UKFA5001 CO-STAT-ERROR
```
  에러 발생 원인을 상세 설명 위한 추가 메시지. Optional
- n-KESA Detail:
```java
throw new BusinessException("B0150001", "UKFA5001", "맞춤메시지 내용");
```
  BusinessException 세 번째 파라미터로 맞춤메시지 전달
- Mapping Rule: #CSTMSG + #ERROR → throw new BusinessException("에러코드", "조치코드", "맞춤메시지")로 합쳐서 처리

---

### [Error Handling] - #ERAFPG 매크로 (에러처리 후 테이블갱신 호출요청)
- z-KESA: #ERAFPG [프로그램명] [입력인터페이스] (Rollback 후 원장갱신모듈 호출)
- n-KESA: N/A - 별도 패턴 구현 필요 (BusinessException + 후속 FM 호출)
- z-KESA Detail:
```cobol
*입력값 설정 (계좌번호)
MOVE YNKLA011-ACNO TO XDKLA011-I-ACNO
*후속 호출프로그램 SET (비밀번호오류횟수 갱신프로그램)
#ERAFPG DKLA011 XDKLA011-IN
*비밀번호 오류처리
#ERROR BXX12345 U1234567 CO-STAT-ERROR
```
  - 프레임워크가 에러에 따른 Rollback 처리 후 지정 프로그램 호출, 원장갱신 후 Commit
  - #ERAFPG 호출요청프로그램명(8), 입력파라미터 SIZE 최대 200byte
  - Rollback 대상외 에러(비밀번호 오류횟수 반영 등)에 사용
- n-KESA Detail: 직접 대응 API 없음. 비밀번호 오류횟수 갱신 등 Rollback 후 별도 처리가 필요한 경우: 프레임워크팀과 협의. 또는 별도 트랜잭션 경계를 가진 공유 FM 호출 패턴으로 구현
- Mapping Rule: #ERAFPG → N/A. Rollback 후 별도 처리 요건은 n-KESA에서 별도 트랜잭션 FM 패턴 또는 프레임워크 팀과 협의하여 구현. BusinessException throw 후 catch 블록에서 별도 로직 실행 가능하나 트랜잭션 경계 주의

---

### [Error Handling] - #TRMMSG 매크로 (에러메시지 출력)
- z-KESA: #TRMMSG (에러메시지 단말출력 처리)
- n-KESA: N/A - 프레임워크 자동 처리
- z-KESA Detail: 단말에 에러메시지를 출력하기 위한 매크로. 에러코드/조치코드를 기반으로 공통관리시스템에서 메시지 조회 후 출력
- n-KESA Detail: BusinessException에 에러코드/조치코드 설정 시 프레임워크가 자동으로 메시지 조회 및 응답 전문 구성. 3.6.8 메시지 등록 참조
- Mapping Rule: #TRMMSG → 프레임워크 자동 처리. BusinessException 코드 설정으로 충분

---

### [Error Handling] - #OKEXIT 매크로 (정상종료)
- z-KESA: #OKEXIT [정상상태코드]
- n-KESA: return responseData
- z-KESA Detail:
```cobol
S9000-FINAL-RTN.
  #OKEXIT CO-STAT-OK.
S9000-FINAL-EXT.
  EXIT.
```
  현재 프로그램을 정상 종료, STAT를 '00'으로 SET하고 호출 프로그램으로 Return. GOBACK 대신 사용
- n-KESA Detail:
```java
return responseData; // 정상 종료
```
  예외 없이 메소드 종료 시 정상 완료로 처리됨. 프레임워크가 응답 전문 구성
- Mapping Rule: #OKEXIT → return responseData. STAT 코드 설정 불필요 (예외 없으면 자동 정상 처리)

---

### [Error Handling] - DB I/O 에러처리
- z-KESA: DBIO 결과코드 체계 (00/01/02/09/98/99) + EVALUATE로 처리
- n-KESA: DataException 클래스로 처리 (3.6.5)
- z-KESA Detail:
  - 00: 정상, 01: 중복(DUPM), 02: 없음(MRNF), 09: 기타 SQL Status, 98/99: 비정상/System Error
  - COND-DBIO-OK, COND-DBIO-DUPM, COND-DBIO-MRNF 조건으로 체크
  - 98/99는 DBIO 자체에서 FW 에러처리 후 직접 Return
- n-KESA Detail:
  - DataException: DB 처리 시 DBMS 오류 처리 (3.6.5)
  - Insert 중복 에러: 3.6.5.1 DataException catch 후 처리
  - DB 처리 시 DBMS 오류 코드 조회: 3.6.5.2
- Mapping Rule:
  - COND-DBIO-DUPM(01) → catch(DataException e) + 중복 판단 로직
  - COND-DBIO-MRNF(02) → 단건조회 null 체크 또는 DataException
  - COND-DBIO-OK(00) 이외 → DataException 또는 BusinessException 재throw
  - 98/99 → 프레임워크가 자동 처리

---

### [Error Handling] - 에러 응답 개별부 생성
- z-KESA: 3.15 대외개설거래 에러전문 조립 프로그램
- n-KESA: 3.6.9 에러 응답 개별부 생성
- z-KESA Detail: 대외개설거래에서 에러 발생 시 에러전문을 별도 프로그램으로 조립. ZUGRSTH(내부표준관련조회 모듈) 사용. 에러전문 조립 프로그램 등록 및 인터페이스
- n-KESA Detail: 3.6.9 에러 응답 개별부 생성 API 사용
- Mapping Rule: z-KESA 대외개설거래 에러전문 조립 프로그램 → n-KESA 에러 응답 개별부 생성 (3.6.9)

---

### [Error Handling] - 에러 처리 계층 흐름
- z-KESA: DC/BC에서 에러 발생 → #ERROR → PC/AS로 Return → AS에서 최종 에러처리 → 프레임워크 출력
- n-KESA: DM/DBM에서 BusinessException throw → FM catch 후 재throw → PM catch 후 처리 또는 재throw → 프레임워크 출력
- z-KESA Detail: 에러처리매크로 호출 시 해당 프로그램을 호출한 프로그램으로 제어권 반환. 최종적으로 Framework를 통해 에러메시지 출력. DC/IC/BC에서 발행한 에러는 해당 호출 PC/AS에서 응답코드 확인 후 최종 에러처리
- n-KESA Detail: BusinessException은 catch { throw e; } 패턴으로 상위로 전파. PM에서 최종 처리. 3.6.6 PM에서의 예외처리 참조
- Mapping Rule: 에러 전파 방향 동일 (하위→상위). z-KESA #ERROR 후 자동 Return → Java BusinessException throw로 동일 동작 구현

---

### [Error Handling] - 에러 메시지 코드 체계
- z-KESA: 에러코드 B[에러유형][일련번호], 조치코드 U[어플리케이션코드][일련번호]
- n-KESA: 동일 코드 체계 유지 (3.6.8 메시지 등록)
- z-KESA Detail:
  - 에러코드(8자리): B(비즈니스)/S(시스템)/D(DB I/O) + 에러유형구분(2) + 일련번호(5)
  - 에러유형구분: 구분코드 1,2,3,4,5,6만 사용
  - 조치코드(8자리): U(조치) + 어플리케이션코드(3) + 일련번호(4) (예: UKJI0001)
  - 에러메시지: 공통관리시스템에서 통합관리, 전행공통팀 검토 승인 후 사용
  - 조치메시지: 업무별 등록 (승인 불요)
- n-KESA Detail: 3.6.8 메시지 등록. BusinessException("에러코드", "조치코드", ...) 동일 코드 체계 사용
- Mapping Rule: 에러코드/조치코드 체계 동일 유지. COBOL 상수(CO-B1050001, CO-UKFA5002) → Java String 리터럴 또는 상수 클래스 필드

---

## SECTION 10: 출력 처리

---

### [Output Processing] - #GETOUT 매크로 (출력영역 확보)
- z-KESA: #GETOUT [AS 출력카피북] (출력정보 조립영역 확보 및 초기화)
- n-KESA: IDataSet responseData = new DataSet() (메소드 시작 시 자동 생성)
- z-KESA Detail:
```cobol
01 XZUGOTMY-CA.  COPY XZUGOTMY.
...
S1000-INITIALIZE-RTN.
  INITIALIZE XZUGOTMY-CA.
  #GETOUT YPKLA101-CA.
```
  - XZUGOTMY 카피북: 출력영역확보 요청 매크로 인터페이스
  - #GETOUT은 AS 프로그램에서만 호출, INITIALIZE 후 수행
  - AS 출력 카피북(YPxxxx-CA)을 파라미터로 전달
  - POINTER 인터페이스로 출력영역 확보
- n-KESA Detail:
```java
IDataSet responseData = new DataSet();
```
  PM 메소드 시작 시 자동 생성. 별도 영역 확보 불필요
- Mapping Rule: #GETOUT → IDataSet responseData = new DataSet(). XZUGOTMY-CA 선언/초기화 불필요. YPxxxx-CA 출력카피북 항목 → responseData.put("fieldKey", value)

---

### [Output Processing] - #BOFMID 매크로 (출력 폼 ID 지정)
- z-KESA: #BOFMID '출력폼 ID-1' '출력폼 ID-2' ~ '출력폼 ID-20'
- n-KESA: addOutFormInfo(formId, formType, copies, elctrFxdDstCd, fCopies, bCopies, onlineCtx)
- z-KESA Detail:
```cobol
*전표
#BOFMID 'V3KFA01001001'
*출력화면
#BOFMID 'V1KFA01001100'
*통장
IF XPFA1003-I-BNKBK-TRAN-DSTCD = '2'
  #BOFMID 'V2KFA01001003'
END-IF
*영수증
#BOFMID 'V4KFA01001002'
```
  - FormID 체계: 출력편집매체구분(2) + 화면폼ID(AS거래코드(8)+폼Serial(3))
  - V1:화면, V2:통장, V3:전표, V4:영수증, V5:장표, V6:임의장표, V7:EAI전문, V8:강제메시지
  - 한 거래에서 최대 20개까지 지정
  - Common Area에 저장되어 프레임워크에서 매체별 MCI 전달
  - 인터넷뱅킹/콜센터 전용: "V1INTERNET", EAI개설 전용: "V7INTERFACE"
  - MCI/EAI채널에서 출력 FormID 미조립 시 프레임워크 에러처리
- n-KESA Detail:
```java
addOutFormInfo("KHC0313059", "V1", "01", "01", "", "", onlineCtx);
// 복수 폼 지정
addOutFormInfo("KFA01001001", "V3", "01", "", "", "", onlineCtx); // 전표
addOutFormInfo("KFA01001100", "V1", "01", "", "", "", onlineCtx); // 화면
```
  - FormType: V0(공통출력부), V1(화면), V2(통장), V3(전표), V4(영수증), V5(장표), V6(임의장표), V7(EAI개설), V8(강제메시지)
  - copies: 반복출력매수, fCopies: 수표앞면 매수, bCopies: 수표뒷면 매수
- Mapping Rule: #BOFMID '[V1~V6][AS거래코드][폼Serial]' → addOutFormInfo("[폼ID]", "[V1~V6]", "01", "01", "", "", onlineCtx). 동일 FormType 코드(V1~V8) 유지. 최대 20개 제한 → 20회 호출 가능

---

### [Output Processing] - #SCRENO 매크로 (출력화면번호 지정)
- z-KESA: #SCRENO (출력화면번호 지정 매크로, 6.1.7)
- n-KESA: addOutFormInfo()의 formId 파라미터로 화면번호 지정
- z-KESA Detail: 출력 화면번호를 Common Area에 지정하는 매크로. 인터넷뱅킹/콜센터 거래 등 특수 채널 거래에서 FormID 지정
- n-KESA Detail: addOutFormInfo()에서 formId로 화면번호 직접 지정
- Mapping Rule: #SCRENO → addOutFormInfo() formId 파라미터

---

### [Output Processing] - SAF에 의한 강제 메시지처리
- z-KESA: 3.8.5 SAF에 의한 강제 메시지처리 (V8 FormID 사용)
- n-KESA: V8 FormType으로 addOutFormInfo() 호출
- z-KESA Detail: SAF(Send And Forget) 방식으로 강제 메시지 출력. #BOFMID 'V8...' 사용
- n-KESA Detail: addOutFormInfo("formId", "V8", ...) + EAI 비동기 IR/SAF 방식 구분(3.9.7.5/3.9.7.6)
- Mapping Rule: V8 FormID #BOFMID → addOutFormInfo("formId", "V8", ...). EAI 비동기 SAF 방식과 연계

---

### [Output Processing] - 매체별 출력 원칙
- z-KESA: AS 출력카피북은 매체/채널/기동수동과 무관한 Superset으로 정의
- n-KESA: responseData에 모든 출력 필드 통합, addOutFormInfo로 매체 지정
- z-KESA Detail:
  - 출력편집 매체유형: 화면, 통장, 전표, 영수증, 장표, 임의장표
  - 통장 데이터: 공통프로그램(계약의 통장정리 IC)과 프레임워크 사이 공통영역으로 조립
  - 기동 호출 시: 매체별 출력편집 수행
  - 수동 호출 시: 연동출력부 편집 수행
  - 자동화기기: V1(화면), V2(통장), V6(임의장표)만 출력, 나머지 무시
- n-KESA Detail:
  - PM이 단일 responseData에 모든 출력 데이터 구성
  - addOutFormInfo()로 매체별 FormID 등록
  - MCI에서 채널별/매체별로 출력 정보 매핑
- Mapping Rule: AS 출력카피북 Superset → responseData 단일 객체. 매체별 카피북 → addOutFormInfo FormType 파라미터

---

## SECTION 11: 연동거래 처리

---

### [Integration Program] - 연동 제어 프로그램 (3.9.1)
- z-KESA: 연동 제어 프로그램 (기동 AS 프로그램이 연동 제어)
- n-KESA: PM 메소드에서 연동거래 API 직접 호출
- z-KESA Detail: 기동 AS가 연동 스케줄에 따라 수동 AS를 제어. #GETINP 매크로로 입력편집용 영역확보(연동제어프로그램용). 기동 AS는 프레임워크 스케줄에 의해 호출되고, 수동 AS는 연동정의에 의해 자동 호출
- n-KESA Detail: PM 메소드 내에서 연동거래 API(3.8.9) 직접 호출. 동기/비동기/지연비동기 연동 구분
- Mapping Rule: 연동 제어 프로그램 개념 → PM 메소드 내 연동거래 API 코드로 구현

---

### [Integration Program] - #GETINP 매크로 (입력편집용 영역확보)
- z-KESA: #GETINP (연동제어프로그램용 입력편집용 영역확보, 6.1.14)
- n-KESA: IDataSet requestData를 새로 구성하여 연동거래 API에 전달
- z-KESA Detail: 연동 제어 프로그램에서 후행 AS의 입력편집 영역을 확보하기 위한 매크로
- n-KESA Detail: IDataSet newReqData = new DataSet(); newReqData.put("key", value); 로 후행 거래 입력 데이터 구성 후 연동거래 API 파라미터로 전달
- Mapping Rule: #GETINP → IDataSet newReqData = new DataSet() + 필요 필드 put()

---

### [Integration Program] - 연동 확인 프로그램 (3.9.2)
- z-KESA: 연동 확인 프로그램 (수동 AS 처리 후 결과 확인)
- n-KESA: 연동거래 API 결과 IDataSet 직접 확인
- z-KESA Detail: 수동 AS의 처리 결과를 기동 AS에서 확인하는 프로그램. 연동출력부의 내용을 참조하여 처리
- n-KESA Detail: 연동거래 API 호출 후 반환된 IDataSet에서 처리 결과 직접 확인. 비동기의 경우 응답 Merge(3.8.9.4) 참조
- Mapping Rule: 연동 확인 프로그램 → 연동거래 API 반환값 직접 확인 코드

---

### [Integration Program] - 연동 출력편집 프로그램 (3.9.3)
- z-KESA: 연동 출력편집 PC 프로그램 (YCSFOAYE 기반, 거래파라미터에 등록)
- n-KESA: addOutFormInfo() API + PM 내 출력 데이터 조립
- z-KESA Detail: 기동 AS의 매체별 출력영역 + 수동 AS의 연동출력부를 조합하여 최종 출력 편집. PC 프로그램으로 작성, 거래파라미터에 1개 등록
- n-KESA Detail: PM에서 responseData에 연동 결과 포함 조립 후 addOutFormInfo()로 매체 지정
- Mapping Rule: YCSFOAYE 기반 연동출력편집 PC → PM 내 responseData 조립 + addOutFormInfo() 통합

---

### [Integration Program] - callRemoteService (3.8.11)
- z-KESA: N/A (z-KESA에 직접 대응 개념 없음)
- n-KESA: callRemoteService API (3.8.11, ResponseContext)
- z-KESA Detail: N/A
- n-KESA Detail: callRemoteService로 외부 서비스 호출. ResponseContext로 응답 처리. 3.8.11.1~3 참조
- Mapping Rule: N/A → n-KESA 신규 기능. EAI 동기 송신(callOutbound)과 유사

---

## SECTION 12: 업무로그 조립

---

### [Business Log] - 업무로그 조립 (3.10)
- z-KESA: #USRLOG 매크로 (사용자로그출력, 6.1.17)
- n-KESA: ILog 인터페이스 API (3.4.2 로그 API)
- z-KESA Detail:
```cobol
#USRLOG '로그내용'
```
  - 6.1.17 사용자로그출력. DISPLAY 문 대신 사용
  - 3.10 업무로그 조립: 업무 로그영역 구성(3.10.1), 업무로그 개별부 조립(3.10.2), 업무 거래유형별 업무로그 조립부 코딩 예제(3.10.3)
- n-KESA Detail:
```java
ILog log = getLog(onlineCtx);
log.debug("디버그 로그");
log.info("정보 로그");
log.error("에러 로그");
```
  - 3.4.2 로그 API, 3.4.3 로그레벨
  - online-[거래코드]-일자.log 파일에 기록
  - FLOW_LOG DB 저장(3.4.6), 프레임워크 거래/전문 로그(3.4.7)
- Mapping Rule: #USRLOG → ILog log = getLog(onlineCtx); log.info() 또는 log.debug(). DISPLAY 금지 → System.out 금지 + logger 사용

---

### [Business Log] - #SYSLOG 매크로 (운영로그 출력)
- z-KESA: #SYSLOG (운영로그 출력, 6.1.19)
- n-KESA: ILog.error() 또는 FLOW_LOG DB 저장
- z-KESA Detail: 운영 환경에서 시스템 로그 출력용 매크로
- n-KESA Detail: log.error()로 에러 로그 기록. FLOW_LOG DB 저장(3.4.6)
- Mapping Rule: #SYSLOG → log.error() 또는 FLOW_LOG DB 저장

---

### [Business Log] - #LOGCHK 매크로 (후처리 LOG CHECK)
- z-KESA: #LOGCHK (후처리 LOG CHECK, 6.1.23)
- n-KESA: 선후처리 필터의 에러 후처리 (3.11.3.3/3.11.3.4)
- z-KESA Detail: 거래 후처리 단계에서 로그 체크를 위한 매크로
- n-KESA Detail: 선후처리 필터(Filter)에서 에러 후처리 시 Exception 조회(3.11.3.3), 에러 후처리에서 응답 DataSet 조회(3.11.3.4)
- Mapping Rule: #LOGCHK → 선후처리 필터 후처리 메소드 내 에러 확인 로직

---

## SECTION 13: 센터일괄처리(C/C) 인터페이스

---

### [Center Batch] - 센터일괄처리(C/C) 인터페이스 (3.11)
- z-KESA: 센터일괄처리(C/C) 인터페이스 조립 방법 (3.11)
- n-KESA: 센터컷(CenterCut) 어플리케이션 개발 (7장)
- z-KESA Detail:
  - 3.11.1 센터일괄처리 개요, 3.11.2 작업 프로세스, 3.11.3 인터페이스 조립 방법, 3.11.4 오류처리
  - 센터일괄처리(Center Cut): 온라인 거래처럼 처리되는 대량 배치 처리
  - 입출력 인터페이스 카피북 조립
- n-KESA Detail:
  - 7.1 센터컷 처리 흐름, 7.2 센터컷 개발, 7.3 센터컷 테스트, 7.4 센터컷 실행
  - CC_ID(센터컷업무코드), EXC_KEY(실행키) 사용
  - 입력데이터 테이블 필수 컬럼 정의
  - 온디맨드 배치에서 호출(7.1.4.1), 일반 배치에서 호출(7.1.4.2)
  - 센터컷 프로파일 등록, WAS 인스턴스 설정, 병렬 처리
- Mapping Rule: z-KESA C/C 인터페이스 → n-KESA 센터컷(CenterCut) 어플리케이션. 센터컷 입력데이터 테이블 활용. CC_ID + EXC_KEY 식별자 체계

---

### [Center Batch] - #JCLSRT 매크로 (JCL 실행)
- z-KESA: #JCLSRT (JCL 실행, 6.1.16, 현재 미사용)
- n-KESA: 온디맨드 배치 기동 (5.6.5)
- z-KESA Detail: JCL(Job Control Language)을 실행하는 매크로. 현재 미사용
- n-KESA Detail: 5.6.5 온디맨드 배치 기동 API. 호출 API, JobName, 파라미터 전달, 결과 PUSH. Control-M에 배치 쉘 등록하여 실행
- Mapping Rule: #JCLSRT(미사용) → 온디맨드 배치 기동 API(5.6.5). JCL → 배치 쉘 파일(*.sh)

---

## SECTION 14: 취소거래

---

### [Cancel] - 취소거래 처리 (3.12)
- z-KESA: 취소거래 처리 (3.12) - 취소복원정보 영역 조립/참조
- n-KESA: N/A - 동일 개념의 별도 섹션 없음 (비동기 취소 처리 3.9.8 참조)
- z-KESA Detail:
  - 3.12.1 취소거래 설계 원칙
  - 3.12.2 취소처리 유형 및 입력 데이터 플로우
  - 3.12.3 거래코드 및 입출력 전문/공통정보 영역
  - 3.12.4 취소복원정보 영역 조립/참조 플로우
  - 취소거래 시 원거래의 취소복원정보를 활용하여 역거래 처리
- n-KESA Detail: 직접 대응 섹션 없음. 취소 처리는 업무 로직 내에서 직접 구현 또는 비동기 취소 처리 API(3.9.8) 활용
- Mapping Rule: z-KESA 취소거래 처리 패턴 → n-KESA에서 업무 로직으로 직접 구현. 취소복원정보 영역 → IDataSet 또는 DB 조회로 원거래 정보 복원

---

### [Cancel] - 취소구분코드 / 취소복원정보
- z-KESA: Common Area 내 취소구분코드 인스턴스, 취소복원정보 영역
- n-KESA: CommonArea 내 취소 관련 항목 접근
- z-KESA Detail: Common Area의 취소구분코드 항목. 취소복원정보 영역 조립/참조 플로우(3.12.4)
- n-KESA Detail: CommonArea 접근 API로 취소 관련 정보 조회
- Mapping Rule: Common Area 취소구분코드 → CommonArea 취소 관련 필드 접근

---

## SECTION 15: 중단거래

---

### [Interrupt] - 중단거래 처리 (3.13 / 3.12 n-KESA)
- z-KESA: 중단거래 처리 (3.13) - #DSCNTR 매크로
- n-KESA: 중단거래 (3.12) - IOnlineContext API
- z-KESA Detail:
  - 3.13.1 중단거래 처리 흐름
  - 3.13.2 중단거래 요구 방법
  - 3.13.3 중단거래 시 복원영역 사용방법
  - #DSCNTR 매크로(6.1.18): 중단거래 요청
- n-KESA Detail:
  - 3.12.1 개요, 3.12.2 API
  - 3.12.3 중단거래 요구
  - 3.12.4 중단거래 복원영역 조회
  - 3.12.5 중단거래의 거래중단요청(중지거래) 여부 조회 확인
  - 3.12.6 중단거래 처리 예
- Mapping Rule: #DSCNTR 매크로 → n-KESA 중단거래 API(IOnlineContext 기반). 복원영역 → IDataSet 또는 DB 저장 후 조회

---

### [Interrupt] - #DSCNTR 매크로 (중단거래 요청)
- z-KESA: #DSCNTR (중단거래 요청, 6.1.18)
- n-KESA: 중단거래 API (3.12.2)
- z-KESA Detail:
```cobol
#DSCNTR [파라미터]
```
  중단거래 요청 시 사용하는 매크로
- n-KESA Detail: 3.12.2 API 참조. IOnlineContext 기반 중단거래 요구 메소드
- Mapping Rule: #DSCNTR → n-KESA 중단거래 요구 API

---

## SECTION 16: 시스템 인터페이스

---

### [System Interface] - 시스템 인터페이스 방법 (3.14)
- z-KESA: 시스템 인터페이스 방법 (3.14) - 3.14.2 인터페이스 유형 및 사용방법
- n-KESA: EAI 연계 (3.9) + MCI BID/PUSH (3.10)
- z-KESA Detail:
  - 3.14.1 사용 범위 및 원칙
  - 3.14.2 인터페이스 유형 및 사용 방법
  - 3.14.3 타이머에 의한 타임아웃 관리
  - EAI를 통한 외부기관 인터페이스
- n-KESA Detail:
  - 3.9 EAI 연계: XIO 설계, EAI 전문 XIO 설계, EAI 전문 변환(EAITransformer), 동기/비동기 송신
  - 3.10 MCI BID/PUSH 메시지 전송
- Mapping Rule: z-KESA 시스템 인터페이스 → n-KESA EAI 연계(3.9) + MCI BID/PUSH(3.10)

---

### [System Interface] - EAI 연계
- z-KESA: EAI를 통한 대외기관 인터페이스 (외부전문 송수신)
- n-KESA: EAI 연계 (3.9) - callOutbound(동기), sendOutbound(비동기)
- z-KESA Detail:
  - EAI 채널로 외부기관과 인터페이스
  - EAI 거래에 대한 입출력 편집 등록
  - 대외기관코드 조회 유틸리티 ZUGRSTH(3.16)
  - 대외개설거래 에러전문 조립 프로그램(3.15)
- n-KESA Detail:
  - XIO 설계(3.9.2): EAI 전문 XIO 설계(3.9.3)
  - EAI 전문 변환(3.9.4): EAITransformer, OutboundHeader, 표준전문 헤더, ByteArrayWrap
  - 메인프레임 Async EAI 송신(3.9.5)
  - EAI 동기 송신(3.9.6): callOutbound, IOutboundResponse, 에러 여부 판단, 멀티폼 출력
  - EAI 비동기 송신(3.9.7): sendOutbound, IR/SAF 방식
  - 비동기 취소 처리(3.9.8): 타이머 기동/취소
  - 비동기 응답 거래 전달 Async Merge(3.9.9)
  - 자동화기기 전문 에러 응답 처리(3.9.10)
  - V3표준전문 Outbound(3.17.3): callEAIApiService, callStandardApiService, callRestApiService
- Mapping Rule: z-KESA EAI 인터페이스 → n-KESA EAI 연계 API. 동기: callOutbound(). 비동기: sendOutbound(). V3표준전문: callEAIApiService() 또는 callStandardApiService()

---

### [System Interface] - MCI BID/PUSH
- z-KESA: MCI를 통한 단말 출력 (FormID 기반)
- n-KESA: MCI BID/PUSH 메시지 전송 (3.10)
- z-KESA Detail: MCI 단말 채널에 FormID와 출력 데이터를 전달하여 단말 출력 처리
- n-KESA Detail:
  - 3.10.1 개요, 3.10.2 비동기 응답
  - 3.10.3 BID응답처리, 3.10.4 BID 다건전송
  - 3.10.5 싱글뷰(SingleView), 3.10.6 미니싱글뷰(MiniSingleView)
- Mapping Rule: MCI 단말 출력 → addOutFormInfo() + MCI BID/PUSH API

---

### [System Interface] - V3표준전문 처리
- z-KESA: N/A (z-KESA에는 V3표준전문 개념 없음)
- n-KESA: V3표준전문 처리 (3.17)
- z-KESA Detail: N/A
- n-KESA Detail:
  - 3.17.1 개요
  - 3.17.2 V3표준전문 Inbound: MMI 정보 매핑 등록, @BizMethod 어노테이션 추가, 요청 매핑, HTTP메서드 전용 매핑, API G/W Inbound 에러응답 처리
  - 3.17.3 V3표준전문 Outbound: EAI API 연계(callEAIApiService), API G/W 연계, 표준전문/비표준전문 처리(callStandardApiService, callRestApiService)
- Mapping Rule: N/A → n-KESA 신규 기능. REST API 기반 표준전문 인터페이스

---

### [System Interface] - 타이머에 의한 타임아웃 관리 (3.14.3)
- z-KESA: 3.14.3 타이머에 의한 타임아웃 관리
- n-KESA: 비동기 취소 처리의 타이머 기동/취소 (3.9.8.1/3.9.8.2)
- z-KESA Detail: 시스템 인터페이스 시 타임아웃 처리를 위한 타이머 관리
- n-KESA Detail: 3.9.8.1 타이머 기동, 3.9.8.2 타이머 취소 - 정상응답. 비동기 EAI 송신 후 응답 대기 시간 관리
- Mapping Rule: z-KESA 타이머 관리 → n-KESA 비동기 취소 처리 타이머 API(3.9.8)

---

## SECTION 17: 배치 타이머 처리

---

### [Batch Timer] - 배치 타이머 처리 방법 (3.17)
- z-KESA: 3.17 배치 타이머 처리 방법
- n-KESA: 배치 실행 쉘 + Control-M 스케줄 등록
- z-KESA Detail:
  - 3.17.1 등록 방법
  - 3.17.2 타이머 처리 프로그램 인터페이스 COPY BOOK
  - 3.17.3 타이머처리 전문 조립 프로그램 작성 예시
  - BATCH TIME WAIT: ZBDAV13 유틸리티 (6.2.9)
- n-KESA Detail: 배치 쉘 파일을 Control-M에 등록하여 스케줄 실행. 루프배치(상주배치) 패턴(5.8) 사용 가능. 루프 시간 체크(5.8.2)
- Mapping Rule: z-KESA 배치 타이머 → Control-M 스케줄 등록 + 배치 쉘 파일 실행. ZBDAV13(BATCH TIME WAIT) → 상주배치(루프배치) 패턴(5.8) 또는 Thread.sleep() (권장하지 않음)

---

## SECTION 18: 대외개설거래 에러전문 조립

---

### [External] - 대외개설거래 에러전문 조립 프로그램 (3.15)
- z-KESA: 대외개설거래 에러전문 조립 프로그램 작성 방법 (3.15)
- n-KESA: 에러 응답 개별부 생성 (3.6.9) + EAI 에러 응답 처리
- z-KESA Detail:
  - 3.15.1 개요: 대외개설거래에서 에러 발생 시 에러전문 별도 조립
  - 3.15.2 대외개설거래 에러전문 조립 프로그램 등록
  - 3.15.3 프로그램 인터페이스 설명
  - 3.15.4 대외개설거래 오류전문 조립 프로그램 작성 예시
- n-KESA Detail: 3.6.9 에러 응답 개별부 생성. 자동화기기 전문 에러 응답 처리(3.9.10)
- Mapping Rule: z-KESA 대외개설거래 에러전문 조립 → n-KESA 에러 응답 개별부 생성(3.6.9) + EAI 에러 응답 처리(3.9.10)

---

### [External] - 대외기관코드 조회 유틸리티 (3.16)
- z-KESA: ZUGRSTH (내부표준관련조회 모듈, 3.16)
- n-KESA: 해당 조회 FM 또는 DM 메소드로 구현
- z-KESA Detail:
  - 3.16.1 사용 방법
  - 3.16.2 내부표준관련조회 모듈(ZUGRSTH)의 호출
  - 3.16.3 ZUGRSTH 사용 시 프로그램 파라미터 조립방법
  - 3.16.4 대외기관코드 조회 모듈 사용 예시
  - #DYCALL ZUGRSTH로 호출
- n-KESA Detail: 대외기관코드는 전행공통 FU 또는 DM의 메소드로 조회. callSharedFM() API로 호출
- Mapping Rule: #DYCALL ZUGRSTH → callSharedFM("전행공통 FU.메소드명") 또는 해당 DM 직접 호출

---

## SECTION 19: 프레임워크 유틸리티 및 매크로

---

### [Utility] - #DYDBIO 매크로 (DBIO 호출)
- z-KESA: #DYDBIO (DBIO 호출, 6.1.12)
- n-KESA: DBIO_[테이블명] DBM 메소드 직접 호출 (@BizUnitBind)
- z-KESA Detail:
```cobol
COPY YCDBIOCA.   *DBIO Interface
COPY TKFAEC03.   *테이블 KEY 카피북
COPY TRFAEC03.   *테이블 RECORD 카피북
*DBIO 호출
#DYDBIO [테이블명] [COMMAND] TKFAEC03-KEY TRFAEC03-REC
```
  YCDBIOCA에 command 세팅 후 호출. 결과는 YCDBIOCA의 결과코드로 확인
- n-KESA Detail:
```java
@BizUnitBind
private DBIO_TKFAEC03 dbioTkfaec03;
// 단건 조회
IDataSet result = dbioTkfaec03.select(requestData, onlineCtx);
// 삽입
dbioTkfaec03.insert(requestData, onlineCtx);
// 갱신
dbioTkfaec03.update(requestData, onlineCtx);
// 삭제
dbioTkfaec03.delete(requestData, onlineCtx);
// Lock 조회
dbioTkfaec03.selectForUpdate(requestData, onlineCtx);
```
- Mapping Rule: #DYDBIO [테이블명] + COMMAND → DBIO_[테이블명]의 해당 DBM 메소드 호출. YCDBIOCA command 세팅 → DBM 메소드명으로 직접 구분

---

### [Utility] - #DYSQLA 매크로 (SQLIO SELECT)
- z-KESA: #DYSQLA (SQLIO SELECT, 6.1.13)
- n-KESA: DU의 DM 메소드 (select, selectList) + XSQL
- z-KESA Detail:
```cobol
#DYSQLA USING [SQLIO명] [SQLIO 카피북]
```
  사용자 정의 SQL 실행. Multi-Row Fetch 지원
- n-KESA Detail:
```java
IDataSet result = duTsbne2000.select(requestData, onlineCtx);
IRecordSet rs = duTsbne2000.selectList(requestData, onlineCtx);
```
- Mapping Rule: #DYSQLA → DU.DM 메소드 호출

---

### [Utility] - #GETNCS 매크로 (채번 NCS)
- z-KESA: #GETNCS (채번 NCS, 6.1.15)
- n-KESA: 전행공통 채번 FM 또는 DB Sequence 사용
- z-KESA Detail: NCS(Number Control Service)를 통한 일련번호 채번. 6.1.15 채번 NCS(#GETNCS). NCS 채번관리 배치 JCL 포함
- n-KESA Detail: 전행공통 채번 FU의 FM 호출 또는 DB Sequence(DB2의 SEQUENCE 오브젝트) 사용. XSQL에서 자동채번 처리
- Mapping Rule: #GETNCS → 전행공통 채번 FM callSharedFM() 또는 XSQL 내 DB Sequence

---

### [Utility] - #CRYPTO 매크로 (보안모듈 호출)
- z-KESA: #CRYPTO (보안모듈 호출, 6.1.21)
- n-KESA: KBCryptoUtils API (3.3.8)
- z-KESA Detail: 암호화/복호화를 위한 보안모듈 호출 매크로
- n-KESA Detail:
  - 개인정보 DB 암호화: KBCryptoUtils.encryptText(), decryptText() (scpDB)
  - 지주 계열사 DB 암호화: KBCryptoUtils.encryptTextForKBGroup(), decryptTextForKBGroup() (scpDB)
  - 전문 암호화: KBCryptoUtils.scpHostEncode(), scpHostDecode() (scpHost)
  - 단방향 암호화: KBCryptoUtils.encryptTextHash(ALGORITHM_SHA256, ...)
  - Hmac 암호화: KBCryptoUtils.encryptTextHmac()
- Mapping Rule: #CRYPTO → KBCryptoUtils API. scpDB/scpHost 구분에 따라 적절한 메소드 선택

---

### [Utility] - #SECCVT 매크로 (보안모듈 호출)
- z-KESA: #SECCVT (보안모듈 호출, 6.1.22)
- n-KESA: KBCryptoUtils API (3.3.8)
- z-KESA Detail: ASCII/EBCDIC 코드변환을 포함한 보안 관련 코드변환 매크로
- n-KESA Detail: KBCryptoUtils 또는 코드변환 유틸리티 사용
- Mapping Rule: #SECCVT → KBCryptoUtils 또는 코드변환 유틸리티 API

---

### [Utility] - #FMDUMP 매크로 (Format Dump)
- z-KESA: #FMDUMP (Format Dump, 6.1.20)
- n-KESA: log.debug() + IDataSet.toString() (로그 기록 시만 허용)
- z-KESA Detail: 디버그 목적의 메모리 덤프 출력
- n-KESA Detail: 디버그 로그: log.debug("debug info"). DataSet toString은 로그 기록 시만 허용 (직접 값 가공 금지)
- Mapping Rule: #FMDUMP → log.debug() 로그 기록

---

### [Utility] - #END 매크로 (Macro 종료)
- z-KESA: #END (Macro 종료, 6.1.24)
- n-KESA: N/A - Java 메소드 자동 종료
- z-KESA Detail: 매크로 처리 종료를 선언하는 매크로
- n-KESA Detail: Java 메소드는 return 또는 블록 종료 시 자동 종료
- Mapping Rule: #END → N/A (Java 자동 처리)

---

## SECTION 20: 프레임워크 유틸리티 모듈

---

### [Utility Module] - ZUDAV01 (BIT/BYTE 변환)
- z-KESA: ZUDAV01 (#DYCALL ZUDAV01, BIT/BYTE 변환)
- n-KESA: Java bit 연산자 또는 java.util.BitSet
- z-KESA Detail: 6.2.1 BIT/BYTE 변환 유틸리티. #DYCALL ZUDAV01로 호출
- n-KESA Detail: Java의 비트 연산자(&, |, ^, ~, <<, >>)로 직접 처리. 또는 java.util.BitSet 활용
- Mapping Rule: ZUDAV01 → Java 비트 연산자 직접 사용

---

### [Utility Module] - ZUDAV02 (숫자 변환)
- z-KESA: ZUDAV02 (숫자 변환, 6.2.2)
- n-KESA: Long.parseLong(), Integer.parseInt(), BigDecimal, String.format()
- z-KESA Detail: 숫자 형식 변환 유틸리티. EBCDIC 숫자↔이진수 변환 등
- n-KESA Detail: Long.parseLong(), Integer.parseInt(), BigDecimal.valueOf(). 금액은 BigDecimal 사용 필수
- Mapping Rule: ZUDAV02 → Java 기본 타입 변환 메소드. 금액 연산은 BigDecimal 필수

---

### [Utility Module] - ZUDAV03 (ASCII/EBCDIC 변환)
- z-KESA: ZUDAV03 (ASCII/EBCDIC 변환, 6.2.3)
- n-KESA: String encoding 변환 (charset 지정)
- z-KESA Detail: ASCII ↔ EBCDIC 코드변환 유틸리티. #DYCALL ZUDAV03
- n-KESA Detail: new String(bytes, "Cp1047") 또는 "IBM-1047"(EBCDIC). KBCryptoUtils.scpHostEncode()에서 SCPECOD_ASCII/SCPECOD_EBCDIC 상수 사용
- Mapping Rule: ZUDAV03 → Java charset 기반 String 인코딩 변환 또는 KBCryptoUtils 전문 인코딩 상수

---

### [Utility Module] - ZUGDAPC (ASCII/EBCDIC 및 전반자 코드변환)
- z-KESA: ZUGDAPC (ASCII/EBCDIC 코드변환 및 전반자 코드변환, 6.2.4)
- n-KESA: 코드변환 유틸리티 또는 Java charset
- z-KESA Detail: 6.2.4 ASCII, EBCDIC 코드변환 및 전반자 코드변환. 전각/반각 변환 포함
- n-KESA Detail: Java charset 변환 + 전각/반각 변환 유틸리티 또는 ZUGCDCV 대응 유틸리티
- Mapping Rule: ZUGDAPC → Java charset + 전각/반각 변환 로직

---

### [Utility Module] - ZUDAA04 (IBM 2 BYTE/KSC5601 변환)
- z-KESA: ZUDAA04 (IBM 2 BYTE, KSC5601 변환, 6.2.5)
- n-KESA: Java charset "EUC-KR" / "Cp933" 변환
- z-KESA Detail: IBM 2바이트 코드 ↔ KSC5601 변환
- n-KESA Detail: Java String 인코딩 변환: new String(bytes, "EUC-KR"), bytes = str.getBytes("EUC-KR")
- Mapping Rule: ZUDAA04 → Java charset "EUC-KR" 변환

---

### [Utility Module] - ZUDAV05 (ASCII/UNICODE 코드 변환)
- z-KESA: ZUDAV05 (ASCII, UNICODE 코드 변환, 6.2.6)
- n-KESA: Java charset "UTF-8" / "UTF-16" 변환
- z-KESA Detail: ASCII ↔ UNICODE 코드변환 유틸리티
- n-KESA Detail: new String(bytes, "UTF-8"), bytes = str.getBytes("UTF-8"). KBCryptoUtils.ENCODRDING_UTF8 상수
- Mapping Rule: ZUDAV05 → Java charset "UTF-8" 변환

---

### [Utility Module] - ZUDAV06 (DEC/HEX 코드 변환)
- z-KESA: ZUDAV06 (DEC, HEX 코드 변환, 6.2.7)
- n-KESA: Integer.toHexString(), Integer.parseInt(hex, 16)
- z-KESA Detail: 10진수 ↔ 16진수 변환 유틸리티
- n-KESA Detail: Integer.toHexString(decimal), Integer.parseInt("ff", 16)
- Mapping Rule: ZUDAV06 → Java Integer.toHexString() / Integer.parseInt(hex, 16)

---

### [Utility Module] - ZSGTIME (TIMESTAMP 제공)
- z-KESA: ZSGTIME (TIMESTAMP 제공, 6.2.8) - #DYCALL ZSGTIME XZSGTIME-CA (비표준 호출)
- n-KESA: java.time.LocalDateTime, java.util.Date, BaseUtils
- z-KESA Detail:
```cobol
*ZSGTIME를 DYNAMIC 호출 (YCCOMMON-CA 없음)
#DYCALL ZSGTIME XZSGTIME-CA
```
  현재 Timestamp 제공. Common Area 없이 호출하는 비표준 패턴
- n-KESA Detail:
```java
LocalDateTime now = LocalDateTime.now();
// 또는
java.util.Date date = new java.util.Date();
```
- Mapping Rule: ZSGTIME → LocalDateTime.now() 또는 java.util.Date

---

### [Utility Module] - ZBDAV13 (BATCH TIME WAIT)
- z-KESA: ZBDAV13 (BATCH TIME WAIT, 6.2.9)
- n-KESA: 상주배치(루프배치)의 루프 시간 체크 (5.8.2)
- z-KESA Detail: 배치 프로그램에서 일정 시간 대기하는 유틸리티
- n-KESA Detail: 5.8.2 루프 시간 체크. 상주배치(루프배치) 패턴에서 일정 주기로 처리
- Mapping Rule: ZBDAV13 → 루프배치 루프 시간 체크(5.8.2)

---

### [Utility Module] - ZUDAV20 (HEX/CHAR 코드변환)
- z-KESA: ZUDAV20 (HEX, CHAR 코드변환, 6.2.10)
- n-KESA: DatatypeConverter.parseHexBinary() / printHexBinary()
- z-KESA Detail: 16진수 ↔ 문자 코드변환 유틸리티
- n-KESA Detail: javax.xml.bind.DatatypeConverter.parseHexBinary(), printHexBinary(). 또는 Apache Commons Codec의 Hex.encodeHexString()
- Mapping Rule: ZUDAV20 → Java HEX 변환 유틸리티

---

### [Utility Module] - ZUGMSNM (메신저 전송요청 유틸리티)
- z-KESA: ZUGMSNM (메신저 전송요청 유틸리티, 6.2.11)
- n-KESA: MCI BID 메시지 전송 (3.10) 또는 별도 메신저 FU
- z-KESA Detail: 메신저 전송 요청을 위한 유틸리티. #DYCALL ZUGMSNM
- n-KESA Detail: 3.10 MCI BID/PUSH 메시지 전송. 또는 전행공통 FU의 메신저 전송 FM 호출
- Mapping Rule: ZUGMSNM → MCI BID 전송 API(3.10) 또는 전행공통 메신저 FM callSharedFM()

---

### [Utility Module] - ZUGCDCV (ASCII/EBCDIC 코드변환 유틸리티)
- z-KESA: ZUGCDCV (ASCII, EBCDIC 코드변환 유틸리티, 6.2.12)
- n-KESA: Java charset 변환 + KBCryptoUtils 전문 인코딩
- z-KESA Detail: 6.2.12 대외거래 송수신 시 코드변환 기능 개선. ASCII ↔ EBCDIC 변환. EAI 대외거래 전문에서 코드변환 필요 시 사용
- n-KESA Detail: EAI 전문 변환 시 ByteArrayWrap(3.9.4.5). KBCryptoUtils.scpHostEncode(text, SCPECOD_ASCII/SCPECOD_EBCDIC)
- Mapping Rule: ZUGCDCV → EAI ByteArrayWrap(3.9.4.5) + KBCryptoUtils 인코딩 처리

---

### [Utility Module] - BaseUtils / PropertyUtils
- z-KESA: N/A
- n-KESA: BaseUtils (3.3.9), PropertyUtils (3.3.10)
- z-KESA Detail: N/A
- n-KESA Detail:
  - BaseUtils.getRuntimeId(): 프레임워크 런타임 ID
  - BaseUtils.getRuntimeMode(): 환경구분코드 {L/D/S/O}
  - PropertyUtils.getProperty(appCode, fileName, key, reloadIfModified): 프로퍼티 단건 조회
  - PropertyUtils.getProperties(appCode, fileName, reloadIfModified): 전체 프로퍼티 조회
  - 프로퍼티 파일 위치: 로컬 C:\fsconfig\OOO\, 서버 /fsconfig/OOO/
- Mapping Rule: N/A → n-KESA 신규 기능. 환경설정 정보 조회 API

---

### [Utility Module] - StringUtils
- z-KESA: COBOL 문자열 처리 (MOVE, INSPECT, STRING, UNSTRING 등)
- n-KESA: nexcore.framework.core.util.StringUtils
- z-KESA Detail: COBOL 내장 문자열 처리 명령어 사용
- n-KESA Detail:
  - StringUtils.isBlank(): null, 빈문자열, 공백 모두 true
  - StringUtils.isEmpty(): null, 빈문자열만 true
  - StringUtils.equals(): 둘 다 null도 같은 값으로 처리
  - substring(), contains(), trim(), indexOf() 등 StringUtils API 사용 (null 안전)
- Mapping Rule: COBOL 문자열 처리 → StringUtils API. 직접 String API 사용 대신 null 안전 StringUtils 사용

---

### [Utility Module] - DataSetUtils
- z-KESA: N/A (COBOL 테이블 정렬은 직접 구현)
- n-KESA: nexcore.framework.core.util.DataSetUtils
- z-KESA Detail: COBOL에서 배열 정렬은 SORT 명령어 또는 직접 구현
- n-KESA Detail: DataSetUtils.sort(rs, "컬럼명", ascending): 레코드셋 정렬. 단일 또는 복수 컬럼 기준 정렬 지원
- Mapping Rule: COBOL SORT → DataSetUtils.sort() API

---

### [Utility Module] - BizCacheUtils (캐시)
- z-KESA: N/A (COBOL에 캐시 개념 없음)
- n-KESA: BizCacheUtils (3.13)
- z-KESA Detail: N/A
- n-KESA Detail: 3.13.3 BizCacheUtils의 캐시 API. 3.13.4 캐시 사용 예제코드. 캐시 정보 설정(3.13.2)
- Mapping Rule: N/A → n-KESA 신규 기능. 자주 조회되는 데이터(코드 테이블 등)를 캐시하여 성능 향상

---

### [Utility Module] - worKB 연계 호출 (3.14)
- z-KESA: N/A
- n-KESA: worKB 연계 호출 (3.14)
- z-KESA Detail: N/A
- n-KESA Detail: 3.14.1 개요, 3.14.2 입력 파라미터 정의, 3.14.3 리턴 값 정의, 3.14.4 사용 예시, 3.14.5 제약 사항
- Mapping Rule: N/A → n-KESA 신규 기능

---

### [Utility Module] - FileUtils (3.15)
- z-KESA: BATCH에서 FILE ACCESS (INPUT-OUTPUT SECTION, OPEN/READ/WRITE/CLOSE)
- n-KESA: FileUtils API (3.15.1) + IFileTool
- z-KESA Detail: BATCH 프로그램의 FILE 처리. SELECT/ASSIGN/ORGANIZATION/ACCESS MODE 선언. OPEN/READ/WRITE/CLOSE 명령어
- n-KESA Detail: FileUtils API(3.15.1). 배치에서는 IFileTool로 파일 처리. FIO 레이아웃 정의(5.4.2), IFileTool 생성(5.4.3), 파일 오픈(5.4.4), Write(5.4.8), Read(5.4.9)
- Mapping Rule: COBOL FILE 처리 → IFileTool API + FIO 레이아웃 정의

---

## SECTION 21: 선후처리 필터

---

### [Filter] - 선후처리 필터 (3.11)
- z-KESA: N/A (z-KESA에 직접 대응 개념 없음, 전행공통 BC가 유사 역할)
- n-KESA: 선후처리 필터 (3.11)
- z-KESA Detail: 전행공통 BC(Business Component)가 공통 처리 역할 담당
- n-KESA Detail:
  - 3.11.1 개요, 3.11.2 CommonArea 공유
  - 3.11.3 데이터셋 처리: 선처리 DataSet(3.11.3.1), 후처리 DataSet(3.11.3.2), 에러 후처리 Exception 조회(3.11.3.3), 에러 후처리 응답 DataSet 조회(3.11.3.4)
  - 3.11.4 에러 발생 시 롤백, 3.11.5 연동거래 시 선후처리 동작
  - 3.11.6 배포, 3.11.7 선후처리 메소드 호출
  - FM이 선후처리 등록 단위
- Mapping Rule: z-KESA 전행공통 BC 공통처리 → n-KESA 선후처리 필터로 구현. FM이 선후처리 등록 단위

---

## SECTION 22: 성능 최적화

---

### [Performance] - COBOL 프로그램 작성 지침 (3.19)
- z-KESA: 3.19 성능 최적화를 위한 COBOL 프로그램 작성 지침
- n-KESA: 3.3.6 성능 주의사항 (Java 기반)
- z-KESA Detail:
  - 3.19.1 프로그램 수행 로직 작성 시 주의사항
  - 3.19.2 데이터 타입의 선정 시 주의사항
  - 3.19.3 데이터 테이블 사용 시 주의사항
  - 3.19.4 파일 사용 시 고려사항
  - 날짜/시간 취득: DB2 SQL Call 사용 금지, CICS 프레임워크 언어 제공 기능 사용
  - Dynamic SQL 사용 금지
  - SELECT List에 필요 컬럼만 기술
  - Equal 조건 술어 컬럼은 SELECT List/ORDER BY/GROUP BY 미기술
  - 동일 데이터 중복 SQL 발행 금지
  - Lock 경합 최소화: Lock Avoidance 기능 활용
  - OPTIMIZE FOR n ROWS 기술
- n-KESA Detail:
  - String + 연산 금지 → StringBuffer 사용, 초기 크기 지정
  - static Map/List 사용 주의
  - Unit CALL DEPTH 최대값(30) 준수
  - Runtime.gc() 호출 금지
  - for 루프 조건에 method 호출 금지
  - Map/List 초기 크기 지정
  - BigDecimal 사용 필수 (금액, 실수 연산)
  - DB2에서 바인드 변수 타입 명시 필수
  - COMMIT/ROLLBACK SQL 구문 XSQL 직접 사용 금지
  - WITH UR 사용(3.5.17.1), FOR UPDATE 사용 가이드(3.5.17.2)
- Mapping Rule: z-KESA COBOL 성능 지침 → n-KESA Java 성능 주의사항으로 대응. SQL 작성 지침은 XSQL에 동일 적용. 날짜취득 DB2 SQL 금지 → LocalDateTime.now() 사용

---

### [Performance] - 계획정지 시 원장반영 방법 (3.20)
- z-KESA: 3.20 계획정지 시 원장반영 방법
- n-KESA: n-KESA 2.0 계정계 업무 24×365 처리 지원 (DBIO 보정로그)
- z-KESA Detail:
  - 3.20.1 개요, 3.20.2 계획정지 구성도, 3.20.3 작업흐름
  - 3.20.4 본원장 반영 정상처리와 예외처리 비교
  - 3.20.5 예외처리 절차
  - 3.20.6 반영로그(THKLA9030)
  - 3.20.7 Sample Program(ZBD7777) 설명
- n-KESA Detail:
  - DBIO 유닛의 보정로그 적재 기능 (24×365 지원)
  - 일자전환(24×365) 지원: D-1 원장데이터 확보, 계획정지 시스템 활용
  - DBIO 기능: 단건 C/U/D, 단건 Lock R/R, 보정로그 적재, 변경로그(CHGLOG) 파일 적재
  - n-KESA 2.0: 계정계 업무에서 DBIO 필수, DU는 SELECT 전용
- Mapping Rule: z-KESA 계획정지 원장반영 → n-KESA 2.0 DBIO 보정로그 적재 메커니즘으로 대체. ZBD7777 샘플 → DBIO 기반 계획정지 처리 패턴

---

## SECTION 23: 개발도구 및 환경

---

### [Dev Tool] - RDz (통합 개발툴)
- z-KESA: RDz (Rational Developer for System z) - IBM 통합개발툴
- n-KESA: Eclipse 기반 NEXCORE 개발도구
- z-KESA Detail: TSO(PCOM) 설치. RDz에서 BMS 플러그인으로 BIM/BPG 기능 제공. 호스트 연결, JES, "내 작업" 필터 필수. RC 코드 "00"이면 정상
- n-KESA Detail: Eclipse 기반. NEXCORE 퍼스펙티브, NEXCORE 탐색기, 유닛 편집기, SQL 편집기, 배치 편집기. 메뉴바/툴바/편집기/뷰 구성. SSO 자동 로그인. C:\설치경로\eclipse\eclipse.exe 실행
- Mapping Rule: RDz → NEXCORE Eclipse 개발도구. BMS → NEXCORE 탐색기 + 유닛 편집기 + SQL 편집기

---

### [Dev Tool] - BPG (Bancs Program Generator)
- z-KESA: BPG (Bancs Program Generator) - DBIO/SQLIO 자동생성, 기초소스코드 생성
- n-KESA: NEXCORE 개발도구의 유닛 생성 위저드 + 프로그램 설계서 가져오기/내보내기
- z-KESA Detail:
  - DBIO 자동생성: Primary Key/Access Key 설정, CRUD 기능
  - SQLIO 자동생성: 사용자 SQL 기반 DB Access 모듈
  - 기초소스코드 생성: 프로그램설계서(Excel) → BPG → COBOL 소스
  - BDT(Bancs Development Transformer): Excel 설계문서 → COBOL 프로그램 변환
- n-KESA Detail:
  - 유닛 생성: [컴포넌트 선택] → [우클릭] → [유닛 생성]/[데이터유닛 생성]/[DBIO 생성]
  - DBIO 생성: 테이블 선택 시 코드 자동생성
  - 프로그램 설계서 가져오기: 2.4.4.1 (Excel → Java 클래스 생성)
  - 프로그램 설계서 내보내기: 2.4.4.2 (Java 클래스 → Excel)
  - 프로그램목록 내보내기: 2.4.4.3
- Mapping Rule: BPG → NEXCORE 유닛 생성 위저드 + 프로그램 설계서 가져오기. BDT → 프로그램 설계서 가져오기(Excel→Java). DBIO 자동생성 → NEXCORE DBIO 생성 위저드

---

### [Dev Tool] - 형상관리
- z-KESA: Host의 프로그램 Dataset에 소스 직접 복사
- n-KESA: 형상관리 시스템 (SVN/Git 등), 개발도구 연동
- z-KESA Detail: 개발자 PC에 생성된 기초소스코드를 Host Dataset으로 복사. 컴파일 후 배포
- n-KESA Detail:
  - Eclipse workspace에서 형상관리 공유
  - *.java, *.uio(메소드 IO), *.xsql(SQL), *.xio(아웃바운드 IO) 모두 세트로 등록
  - 로컬 배포 → 로컬 WAS 자동 redeploy (WAS restart 불필요)
  - 개발서버 배포: 배포 에이전트가 10분 주기 자동 배포
  - CM(변경관리) 절차: 스테이징/운영 배포
- Mapping Rule: Host Dataset 직접 관리 → 형상관리 시스템(SVN/Git) + Eclipse 연동. 컴파일/배포 → 로컬 배포 + 자동 redeploy

---

### [Dev Tool] - 단위 테스트 방법
- z-KESA: 4.2 단위 테스트 방법 (모듈 단위 테스트, 단위 거래 테스트), CICS LOG
- n-KESA: 4.1 로컬 메소드 테스트, 4.2 로컬 환경 디버깅
- z-KESA Detail:
  - 4.2.1 모듈 단위 테스트
  - 4.2.2 단위 거래 테스트
  - 4.3 테스트 오류 추적: CICS LOG 내용(4.3.1), 테스트 거래 종료 유형(4.3.2), 처리시간 산출(4.3.3)
  - 4.4 온라인거래 디버깅 정보조회 방법
- n-KESA Detail:
  - 4.1 로컬 메소드 테스트: 타 컴포넌트 jar 다운로드, 메소드 테스트, PM 메소드 테스트, 테스트 이력 조회
  - 4.2 로컬 환경 디버깅: 디버깅 설정(4.2.2), 디버깅 수행(4.2.3)
  - 4.3 로그 분석-로컬: 메소드 테스트 로그
  - 4.4 서버 테스트: 배포된 소스 확인, 배포 에이전트
  - 4.5 로그 분석: 서버 로그 종류(4.5.1.1), 전문로그 상세(4.5.1.2), 로그통합조회(4.5.1.3), Flow 로그(4.5.1.4)
- Mapping Rule: CICS LOG → 서버 로그/전문 로그. 단위 거래 테스트 → 로컬 메소드 테스트. 처리시간 산출 → Flow 로그(4.5.1.4)

---

## SECTION 24: 명명규칙 매핑

---

### [Naming] - 프로그램 명명규칙
- z-KESA: COBOL 프로그램명 7자리 + 유형 접두사 (A:AS, P:PC, D:DC, I:IC, F:FC, B:BC)
- n-KESA: 유닛 클래스 명명규칙 (PU/FU/DU/DBIO + Camel 명사형)
- z-KESA Detail:
  - AS: A[어플리케이션코드][4자리] (예: AJI4719)
  - PC: P[어플리케이션코드][4자리] (예: PFA0201)
  - DC: D[어플리케이션코드][4자리] (예: DFA9202)
  - IC: I[어플리케이션코드][4자리]
  - FC: F[어플리케이션코드][4자리]
  - BC: B[어플리케이션코드][4자리]
  - DBIO: DBIO 프로그램 (BPG 자동생성)
  - SQLIO: SQLIO 프로그램 (BPG 자동생성)
- n-KESA Detail:
  - ProcessUnit: PU(대문자) + [명사형Camel] (예: PUPpsnCustCnegoCnselMgt)
  - FunctionUnit: FU(대문자) + [명사형Camel] (예: FUBnkTchsMgt)
  - DataUnit 기본: DU(대문자) + [테이블명] + [A-Z] (예: DUTSBNE2000)
  - DataUnit 옵션: DU(대문자) + [화면아이디] + [A-Z] (예: DUBNE00001000A)
  - DBIO: DBIO_(대문자) + [테이블명] + [A-Z] (예: DBIO_TSBNE2000)
  - 전행공통 FU: FUBc + [명사형]
- Mapping Rule:
  - A(AS) 프로그램 → PU(ProcessUnit) 클래스
  - P(PC) 프로그램 → FU(FunctionUnit) 클래스 + FM 메소드
  - D(DC) 프로그램 → DU(DataUnit) 또는 DBIO Unit 클래스
  - I(IC) 프로그램 → FU(FunctionUnit) 클래스 (공유 FM)
  - B(BC) 프로그램 → FU(FunctionUnit) 클래스 (전행공통, FUBc 접두사)
  - DBIO 프로그램 → DBIO_[테이블명] 클래스

---

### [Naming] - 메소드 명명규칙
- z-KESA: PARAGRAPH 명명 (S0000-MAIN-RTN, S1000-INITIALIZE-RTN 등)
- n-KESA: PM/FM/DM/DBM 메소드 명명규칙
- z-KESA Detail:
  - S0000-MAIN-RTN / S0000-MAIN-EXT: 메인 파라그래프
  - S1000-INITIALIZE-RTN: 초기화
  - S2000-VALIDATION-RTN: 입력값 검증
  - S3000-PROCESS-RTN: 업무처리
  - S9000-FINAL-RTN: 처리종료
  - S[번호]-[기능명]-RTN / EXT 패턴
- n-KESA Detail:
  - PM: pm(소문자) + [거래코드10자리] (예: pmBNE0000401)
  - FM: [동사형] + [명사형] Camel (예: registerBnkCnselPshist)
  - DM: select, selectList 등 쿼리구분(소문자) + [명사형] (예: selectAcno)
  - DBM: insert, select, selectForUpdate, update, delete (자동생성)
  - 메소드 접두어: FM-register~, modify~, delete~, get~, getList~, is~, validate~, calculate~, getNoOf~, manage~. DM-select~, selectList~. DBM-insert, select, selectForUpdate, update, delete
- Mapping Rule: S[번호]-[기능]-RTN 파라그래프 구조 → 단일 Java 메소드 + 내부 블록으로 구조화. 파라그래프 분리 → 필요 시 private 메소드(_로 시작)로 분리

---

### [Naming] - 패키지 명명규칙
- z-KESA: 어플리케이션코드 기반 Dataset 라이브러리 체계
- n-KESA: com.kbstar.[어플리케이션코드].[컴포넌트ID] 패키지
- z-KESA Detail: COBOL 프로그램은 Dataset 라이브러리에 저장. 예: xxx.DDB2.DBCOPY(DBIO 카피북)
- n-KESA Detail:
  - 기본패키지: com.kbstar
  - 어플리케이션코드: 3자리 (예: bne, sqc)
  - 컴포넌트ID: 명사형+명사형 소문자 (예: ppsncustcnegocnsel)
  - 전체예시: com.kbstar.bne.ppsncustcnegocnsel
  - biz 패키지: PU/FU/DU/DBIO 클래스는 컴포넌트명 하위 .biz 패키지
  - consts 패키지: 상수 클래스는 .consts 패키지
  - xsql 패키지: XSQL 파일은 .xsql 폴더
- Mapping Rule: COBOL Dataset 라이브러리 → Java 패키지 구조 (com.kbstar.[앱코드].[컴포넌트])

---

### [Naming] - XSQL 명명규칙
- z-KESA: SQLIO 프로그램 + 카피북 (BPG 자동생성)
- n-KESA: XSQL 파일 명명규칙 (DU와 1:1)
- z-KESA Detail: SQLIO 프로그램명 = 카피북명에서 파생. 예: XQFA0308(SQLIO 카피북) → SQLIO 프로그램
- n-KESA Detail:
  - XSQL 파일명: DU명과 동일 (예: DUTSBNE2000.xsql)
  - SQL ID: DM 메소드명과 동일 (예: selectAcno)
  - 배치 XSQL: 배치 클래스명과 동일
- Mapping Rule: SQLIO 카피북명 → XSQL 파일의 SQL ID

---

### [Naming] - XIO 명명규칙 (n-KESA 전용)
- z-KESA: N/A (EAI 카피북으로 관리)
- n-KESA: XIO_(EAI서비스코드 또는 MCI거래코드)
- z-KESA Detail: N/A
- n-KESA Detail: EAI 전송용 전문변환, MCI BID/PUSH 전문변환 레이아웃 저장 파일. xml 형식. 동일 서비스코드에 여러 전문 매핑 필요 시 경로 구분자(REQ1, RES2) 추가
- Mapping Rule: N/A → XIO 파일 신규 생성

---

## SECTION 25: 배치 프로그램 구조

---

### [Batch] - 배치 프로그램 구조 전체
- z-KESA: 5장 BATCH 프로그램 작성 방법 (COBOL BATCH)
- n-KESA: 5장 배치 어플리케이션 개발 (Java BATCH)
- z-KESA Detail:
  - 5.1 개요, 5.2 아키텍처 설계 지침
  - 5.2.1 Batch 작업 시스템, 5.2.2 Batch 작업 유형
  - 5.2.3 Batch 처리 원칙, 5.2.4/5.2.5 설계 방향
  - 5.3 Batch 프로그램 구성: 5.3.1 구성도, 5.3.2 생성, 5.3.3 기본 고려사항, 5.3.4 처리 흐름
  - 5.4 Batch 프로그램 작성: 파일 정의, 변수 선언, 변수 초기화, Batch 정보 초기화, Restart 처리, 본 업무처리, SQL 직접 사용, COMMIT 처리, 사용자 종료요구 처리, 정상종료
  - 5.5 Compile & 수행, 5.6 유틸리티, 5.7 관리기능
- n-KESA Detail:
  - 5.1 개발 절차: 배치 프로젝트, 배치 프로그램 생성, SQL/FIO 작성, 업무 로직 작성, 로컬 배포/테스트
  - 5.2 파라미터와 리턴값
  - 5.3 DB Access 개발: DataSource 관리, CUD 개발, 트랜잭션 처리, Select 개발, RecordHandler
  - 5.4 파일처리: IFileTool, FIO 레이아웃
  - 5.5 개발 관련 기타사항: 예외처리, 처리 진행률, 건수금액 로깅
  - 5.6 온라인 프레임워크 연계: 공유 FM 호출, CommonArea, EAI 송신, 온디맨드 배치 기동
  - 5.7 병렬처리: 멀티 프로세스, BatchStep, 멀티쓰레드, 역할 분리 방식, SharedMap
  - 5.8 상주배치(루프배치)
- Mapping Rule: COBOL BATCH 전체 → Java BatchUnit/BatchStep 클래스 + XSQL + 배치 쉘 파일

---

### [Batch] - 배치 클래스 기본 구조
- z-KESA: BATCH MAIN 프로그램 (COBOL IDENTIFICATION/DATA/PROCEDURE DIVISION)
- n-KESA: BatchUnit 클래스 (beforeExecute/execute/afterExecute)
- z-KESA Detail:
```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID. ZBD7777.
DATA DIVISION.
WORKING-STORAGE SECTION.
...
PROCEDURE DIVISION.
S0000-MAIN-RTN.
  PERFORM 초기화-RTN
  PERFORM BATCH처리-RTN
  PERFORM 정상종료-RTN
```
  GOBACK으로 종료
- n-KESA Detail:
```java
@BizBatch("기본 배치")
public class BUAcnInpt extends com.kbstar.sqc.batch.base.BatchUnit {
    @Override
    public void beforeExecute() { /* 전처리 */ }
    @Override
    public void execute() { /* 메인 로직 */ }
    @Override
    public void afterExecute() {
        if (super.exceptionInExecute == null) { /* 정상 */ }
        else { /* 에러 */ }
    }
}
```
- Mapping Rule: BATCH MAIN COBOL 프로그램 → BatchUnit Java 클래스. PROCEDURE DIVISION S0000-MAIN-RTN → execute(). 초기화 → beforeExecute(). 정상종료/GOBACK → execute() 정상 return. 에러처리 → afterExecute()의 exceptionInExecute 확인

---

### [Batch] - 배치 COMMIT 처리
- z-KESA: 5.4.9 COMMIT 처리 (COBOL에서 수동 COMMIT)
- n-KESA: 중간 Commit (5.3.7), AutoCommitRecordHandler (5.3.13)
- z-KESA Detail: 배치에서 데이터 갱신 시 주기적으로 Commit. 'WITH HOLD' Option으로 Cursor Position 유지
- n-KESA Detail:
  - 5.3.7 중간 Commit: 배치에서 수동 Commit 수행
  - 5.3.13 AutoCommitRecordHandler: 대량 데이터 처리 시 자동 중간 Commit
  - 온라인: Container에서 자동 Commit (개발자 직접 Commit 불가)
  - 배치: 프로그램에서 수동 Commit 수행
- Mapping Rule: COBOL 배치 COMMIT → AutoCommitRecordHandler 또는 중간 Commit API. 온라인에서는 프레임워크 자동 처리

---

### [Batch] - 배치 Restart 처리
- z-KESA: 5.4.6 Restart 처리
- n-KESA: 5.3.8 중간 값 저장 + 동일 Job instance 재처리 (6.1.9)
- z-KESA Detail: 배치 재처리를 위한 Restart 처리. 중단 지점부터 재시작 가능하도록 처리
- n-KESA Detail: 5.3.8 중간 값 저장(saveValueKey). 6.1.9 동일 Job instance 재처리 (관리콘솔)
- Mapping Rule: COBOL Restart 처리 → 중간 값 저장(saveValueKey) + 재처리 API

---

### [Batch] - 배치 병렬처리
- z-KESA: 5장 Batch 처리 원칙 (JCL 기반 병렬 스텝)
- n-KESA: 5.7 병렬처리 (멀티 프로세스, BatchStep, 멀티쓰레드)
- z-KESA Detail: JCL에서 병렬 STEP 정의. 각 STEP은 독립 COBOL 프로그램
- n-KESA Detail:
  - 5.7.1 개요, 5.7.2 멀티 프로세스
  - 5.7.3 배치 스탭(BatchStep), 5.7.4 멀티 쓰레드(BatchStep 방식)
  - 5.7.5 멀티 쓰레드(nKESA1.0), 5.7.6/5.7.7 역할 분리 방식 멀티 쓰레드
  - 5.7.7.1~5.7.7.7 단일큐/멀티큐
  - 5.7.8 Heap 메모리 공유(SharedMap)
- Mapping Rule: JCL 병렬 STEP → BatchStep 병렬 처리. 병렬 스텝 간 공유 데이터 → SharedMap

---

## SUMMARY TABLE (요약 대응표)

| z-KESA 개념 | n-KESA 대응 |
|---|---|
| AS 프로그램 | ProcessUnit (PU) + pm[거래코드] |
| PC 프로그램 | FunctionUnit (FU) + FM 메소드 |
| DC 프로그램 | DataUnit (DU) + DM / DBIO Unit + DBM |
| IC 프로그램 | FunctionUnit (FU) + 공유 FM |
| FC/BC 프로그램 | FunctionUnit (FU, FUBc 접두사) |
| YCCOMMON-CA | IOnlineContext + CommonArea |
| YNxxxx-CA (입력카피북) | IDataSet requestData |
| YPxxxx-CA (출력카피북) | IDataSet responseData |
| XPxxxx-CA (인터페이스) | 별도 IDataSet 객체 |
| TKxxxx + TRxxxx | DBIO_테이블명 DBM 파라미터 |
| DBIO 프로그램 | DBIO Unit (DBIO_테이블명) |
| SQLIO 프로그램 | DataUnit (DU) + XSQL |
| #DYCALL | @BizUnitBind 직접 호출 / callSharedMethod API |
| #STCALL | @BizUnitBind 직접 메소드 호출 |
| #DYDBIO | DBIO_테이블명.insert/select/update/delete() |
| #DYSQLA | DU.selectList() / DU.select() |
| #ERROR | throw new BusinessException("에러코드","조치코드","맞춤메시지") |
| #MULERR START/END | addBusinessException() |
| #CSTMSG | BusinessException 세 번째 파라미터 |
| #ERAFPG | N/A - 별도 트랜잭션 FM 패턴으로 구현 |
| #OKEXIT | return responseData |
| #GETOUT | IDataSet responseData = new DataSet() |
| #BOFMID | addOutFormInfo(formId, formType, ...) |
| #SCRENO | addOutFormInfo() formId 파라미터 |
| #GETNCS | 전행공통 채번 FM / DB Sequence |
| #CRYPTO / #SECCVT | KBCryptoUtils API |
| #USRLOG | ILog log = getLog(onlineCtx); log.info/debug() |
| #SYSLOG | log.error() / FLOW_LOG DB 저장 |
| #LOGCHK | 선후처리 필터 에러 후처리 (3.11.3.3) |
| #DSCNTR | 중단거래 API (3.12.2) |
| #FMDUMP | log.debug() |
| #MULERR | addBusinessException() |
| #JCLSRT | 온디맨드 배치 기동 (5.6.5) |
| BIM | MMI + 메소드 IO 설계기 |
| BPG/BDT | 유닛 생성 위저드 + 프로그램 설계서 가져오기 |
| RDz | Eclipse NEXCORE 개발도구 |
| PARAGRAPH S0000 | Java 메소드 본체 |
| PARAGRAPH S1000 | 메소드 초기화 블록 |
| PARAGRAPH S2000 | if 조건 + BusinessException throw |
| PARAGRAPH S3000 | FM/DM 호출 로직 |
| PARAGRAPH S9000 | return responseData |
| WORKING-STORAGE CO- | 상수 클래스 (C[명사형]Consts) |
| WORKING-STORAGE WK- | 메소드 내 로컬 변수 |
| LINKAGE SECTION | 메소드 파라미터 (requestData, onlineCtx) |
| IDENTIFICATION DIVISION | JavaDoc 주석 + @BizUnit 어노테이션 |
| ENVIRONMENT DIVISION | N/A (삭제) |
| PIC X(n) | String |
| PIC 9(n) / S9(n) | long / BigDecimal |
| OCCURS | IRecordSet |
| XZUGOTMY (출력영역확보) | N/A (responseData 자동 생성) |
| YCDBIOCA | N/A (DBIO Unit 자동 처리) |
| YCDBSQLA | N/A (XSQL 자동 처리) |
| V1~V6 출력 FormID | addOutFormInfo FormType V1~V6 |
| 연동정의 (BIM) | 연동거래 API 코드 (3.8.9) |
| 연동출력편집 PC | addOutFormInfo() + responseData 조립 |
| EAI 인터페이스 | callOutbound() / sendOutbound() (3.9) |
| 대외기관코드 ZUGRSTH | 전행공통 FU callSharedFM() |
| C/C 센터일괄처리 | 센터컷(CenterCut) 어플리케이션 (7장) |
| 배치 COMMIT | AutoCommitRecordHandler / 중간 Commit API |
| 배치 RESTART | saveValueKey + 재처리 API |
| JCL 병렬 STEP | BatchStep 병렬 처리 (5.7) |
| ZBDAV13 (TIME WAIT) | 루프배치 루프 시간 체크 (5.8.2) |
| ZSGTIME | LocalDateTime.now() |
| ZUDAV02 숫자변환 | Long.parseLong() / BigDecimal |
| ZUDAV03 ASCII/EBCDIC | Java charset 변환 / KBCryptoUtils |
| ZUGCDCV 코드변환 | ByteArrayWrap + KBCryptoUtils |
| ZUGMSNM 메신저 | MCI BID/PUSH API (3.10) |
| 취소거래 (3.12) | 업무 로직 직접 구현 / 비동기 취소 (3.9.8) |
| 중단거래 (3.13) | 중단거래 API (n-KESA 3.12) |
| 배치 타이머 (3.17) | Control-M 스케줄 + 루프배치 |
| 계획정지 원장반영 (3.20) | DBIO 보정로그 (n-KESA 2.0) |
| 책임자승인 CJISUPR | CommonArea 책임자승인 영역 API |
| V3표준전문 | N/A (n-KESA 신규: 3.17) |
| BizCacheUtils | N/A (n-KESA 신규: 3.13) |
| callRemoteService | N/A (n-KESA 신규: 3.8.11) |

---

**Total mapping entries: 90+ individual concept mappings across 25 sections.**

Key files referenced:
- z-KESA: `/Users/soyeon/Projects/cobol-test/참고자료/framework/z-kesa/z-kesa_full.txt`
- n-KESA: `/Users/soyeon/Projects/cobol-test/참고자료/framework/n-kesa/n-kesa_full.txt`