# 04. 매크로 & 유틸리티 매핑

---

# z-KESA (COBOL) → n-KESA (Java) 프레임워크 매핑 완전 가이드

---

## 0. 명명규칙 매핑 (Naming Convention Mapping)

---

### [명명규칙] - 프로젝트 명명

- z-KESA: 어플리케이션코드 기반 PDS(파티션 데이터셋), CICS 거래코드, 소스 라이브러리명 (예: KLA.SOURCE, BFA.SOURCE)
- n-KESA: Eclipse 기반 Maven 프로젝트, 저장소명 = 어플리케이션코드-njava (n-KESA 1.0 서버업무), 어플리케이션코드-core-n2java (n-KESA 2.0 계정계), 어플리케이션코드-comm-n2java (공통성), 어플리케이션코드-server-n2java (서버)
- z-KESA Detail: 메인프레임 TSO/ISPF 기반 소스 관리, PDS 라이브러리 단위 관리
- n-KESA Detail: 형상관리(SVN/Git) 기반 Eclipse 프로젝트 단위 관리, -njava (온라인), -nbatch (배치), -nconfig (설정파일)
- Mapping Rule: z-KESA의 어플리케이션코드를 그대로 n-KESA 프로젝트 접두사로 사용. 배치/온라인/설정 분리 원칙 동일

---

### [명명규칙] - 패키지 명명

- z-KESA: 없음 (COBOL은 패키지 개념 없음; 소스 PDS 내 멤버명으로 관리)
- n-KESA: [기본패키지].[어플리케이션코드].[컴포넌트아이디] → com.kbstar.bne.ppsncustcnegocnsel
- z-KESA Detail: 프로그램은 8자리 프로그램명으로 식별. 예: ALA0110 (AS), PLA0110 (PC), DLA0110 (DC)
- n-KESA Detail: 기본패키지 com.kbstar, 어플리케이션코드 3자리, 컴포넌트아이디 명사형 소문자 Camel 조합
- Mapping Rule: COBOL 8자리 프로그램명의 어플리케이션코드 부분(2-3자리)을 n-KESA 패키지 어플리케이션코드로 매핑. 컴포넌트아이디는 업무명을 메타데이터 영문단어 소문자 조합으로 재정의

---

### [명명규칙] - 프로그램 계층 (온라인)

- z-KESA: AS(Application Service), PC(Process Component), DC(Domain Component), IC(Intermediate Component), FC(Function Component), BC(Base Component)
- n-KESA: PU(ProcessUnit / PM메소드), FU(FunctionUnit / FM메소드), DU(DataUnit / DM메소드), DBIO(DBIO Unit / DBM메소드)
- z-KESA Detail: 프로그램명 = 계층구분(1) + 어플리케이션코드(2) + 식별번호(4) + 총 8자. 예: ALA0110 (AS), PLA0110 (PC), DLA0110 (DC)
- n-KESA Detail: ProcessUnit = PU+명사형Camel (예: PUPpsnCustCnegoCnselMgt), FunctionUnit = FU+명사형, DataUnit = DU+테이블명+[A-Z], DBIO Unit = DBIO_+테이블명+[A-Z]
- Mapping Rule: AS → PM메소드 (PU 클래스), PC → FM메소드 (FU 클래스), DC/IC/FC → DM메소드 (DU 클래스) 또는 FM, BC/공통DC → DBIO Unit (DBM). 1:N 대응 가능 (하나의 FU에 복수 FM)

---

### [명명규칙] - 메소드 명명

- z-KESA: 프로그램 자체가 하나의 단위. 거래코드 = CICS TRAN코드(4자). 프로그램 PARAGRAPH명 (예: S1000-INITIALIZE-RTN)
- n-KESA: PM = pm + 거래코드(10자리). FM = 동사형+명사형Camel. DM = 동사형 (select/selectList/insert/update/delete). DBM = insert/select/selectForUpdate/update/delete
- z-KESA Detail: CICS 거래코드 4자리, 프로그램명 8자리로 식별
- n-KESA Detail: 거래코드 10자리 = 어플리케이션코드(3)+거래구분코드(2)+거래구분식별번호(3)+단축거래구분코드(1)+거래식별번호(1). 예: pmBNE0000401
- Mapping Rule: z-KESA CICS 거래코드를 n-KESA 거래코드로 확장(4→10자) 재부여. PM은 1:1 매핑. AS의 Paragraph 단위 로직은 FM/DM으로 분리

---

### [명명규칙] - 배치 프로그램

- z-KESA: B + 어플리케이션코드(2) + 식별번호(4) = 총 7자. 예: BLA0001
- n-KESA: BU(BatchUnit) + 명사형Camel (예: BUBnkTchsMgt). 배치스탭: BU+명사형+BS+명사형 (예: BUBnkTchsMgtBSStep)
- z-KESA Detail: Batch JCL명 = 구분자(1)+어플리케이션코드(3)+작업주기구분자(1)+사용자정의(3)
- n-KESA Detail: 배치 쉘 파일명 = JOB구분코드(m/t)+어플리케이션코드(3)+임의채번(4)+.sh. 예: msqc1001.sh
- Mapping Rule: z-KESA Batch Main PGM → n-KESA BU(Batch Unit). z-KESA JCL → n-KESA 배치 쉘(.sh). 배치 패키지에 .batch 식별자 추가

---

### [명명규칙] - XSQL (SQL 파일)

- z-KESA: DBIO 프로그램명 = R + 어플리케이션코드(2) + 분류코드(4) (자동생성). SQLIO 프로그램명 = Q + 어플리케이션코드 + 식별번호
- n-KESA: XSQL 파일명 = DU+테이블명+[A-Z].xsql (온라인 DataUnit과 1:1). SQL ID = DM메소드명과 동일. DBIO XSQL은 DBIO_+테이블명.xsql
- z-KESA Detail: DBIO 카피북 TK+테이블명 (PK), TR+테이블명 (REC). SQLIO 카피북 XQ+프로그램명
- n-KESA Detail: XSQL은 컴포넌트 하위 .xsql 패키지에 위치. SQL ID와 DM 메소드명 1:1 매핑
- Mapping Rule: z-KESA DBIO → n-KESA DBIO Unit + XSQL. z-KESA SQLIO → n-KESA DataUnit + XSQL (SELECT 전용)

---

### [명명규칙] - 상수 명명

- z-KESA: COBOL 상수 = 01/03/05 레벨 + VALUE 절. 예: 03 CO-STAT-OK PIC X(02) VALUE '00'. 에러코드 변수 예: CO-B1234567 (8자), CO-U1234 (5자)
- n-KESA: 상수 클래스 = C+명사형+Consts (예: CBnkgConsts.java). 패키지 = [기본패키지].[앱코드].[컴포넌트아이디].consts. 상수명 = 대문자+언더스코어 (예: CONST_STRING)
- z-KESA Detail: 공통상수는 COPYBOOK에 선언. 상태코드: 00=OK, 09=ERROR, 98=ABNORMAL, 99=SYSERROR
- n-KESA Detail: 상수는 별도 consts 패키지의 클래스에 선언. BusinessException 생성자에 에러코드/조치코드 직접 문자열로 전달
- Mapping Rule: z-KESA VALUE절 상수 → n-KESA static final 상수 클래스로 전환. CO-STAT-OK/'00' → 제거(정상종료는 메소드 정상 return), CO-STAT-ERROR/'09' → BusinessException throw

---

### [명명규칙] - 주석 작성

- z-KESA: 프로그램 설명 주석(필수: 프로그램명, 유형, 처리개요, 변경일시/근거/작성자), 기능(PARAGRAPH) 설명 주석(필수: ID 및 기능설명), 코드 설명 주석(권고)
- n-KESA: 클래스 주석 (Javadoc), 메소드 주석 (Javadoc: @param, @return 등), 단행 주석 (//), 다행 주석 (/* */), 오류 주석, 기타 주석
- z-KESA Detail: *@프로그램명, *@기능, *@작성자, *@변경이력 형식의 COBOL 주석 (* 로 시작)
- n-KESA Detail: /** Javadoc */ 형식으로 클래스/메소드 선두에 작성. 프레임워크 개발도구에서 자동 생성 템플릿 제공
- Mapping Rule: z-KESA의 *@ 필드 주석을 Javadoc @param/@return/@throws/@author/@since 태그로 변환

---

## 1. 매크로 매핑 (Section 6.1) - Macros

---

### [매크로 6.1.1] - 에러 처리 (#ERROR)

- z-KESA: #ERROR
- n-KESA: throw new BusinessException(String errorCode, String processCode) / throw new BusinessException(String errorCode, String processCode, Throwable cause) / throw new BusinessException(String errorCode, String processCode, String customMsg, Throwable cause)
- z-KESA Detail: #ERROR 에러메시지코드(X8) 조치메시지코드(X5) 결과상태코드(X2). 사용예: #ERROR CO-BXX12345 CO-KFAU1234 CO-STAT-ERROR. 온라인/배치 모두 사용. 상태코드: 09=ERROR, 98=ABNORMAL, 99=SYSERROR. 결과상태코드 98/99는 동일오류 10회 연속시 자동거래정지. 하위 프로그램(IC/DC/FC/BC) #ERROR는 파라미터 RETURN 영역에 세팅만 하고, AS/PC 계층에서 최종 판단 후 재발행
- n-KESA Detail: com.kbstar.sqc.base.BusinessException 클래스. 생성자: new BusinessException("B3800205", "UBNE0070"). 예상하지 못한 Exception은 BusinessException으로 감싸서 throw. 예상한 BusinessException은 그대로 상위 계층으로 전달. DataException은 DB 오류 전용. 클래스: com.kbstar.sqc.base.BusinessException (단일에러), DataException (DB오류)
- Mapping Rule: #ERROR 발행 위치에 throw new BusinessException(에러코드, 조치코드) 삽입. 하위 모듈에서 #ERROR를 재발행하는 패턴은 BusinessException을 catch 후 wrap하여 re-throw. 결과상태코드 변수 제거(상태는 exception으로 표현)

---

### [매크로 6.1.2] - 멀티 에러처리 (#MULERR)

- z-KESA: #MULERR
- n-KESA: addBusinessException(String errorCode, String processCode, IOnlineContext onlineCtx) / addBusinessException(String errorCode, String processCode, String telgmItemName, IOnlineContext onlineCtx)
- z-KESA Detail: #MULERR START ~ #MULERR END 블록 내에서 #ERROR 발행시 즉시종료 없이 최대 10개 에러 누적. #MULERR END 또는 10개 도달시 종료. AS/PC 프로그램에서만 사용가능. 사용예: #MULERR START / IF 조건 / #ERROR B0000001 U0000 CO-STAT-ERROR / END-IF / #MULERR END
- n-KESA Detail: addBusinessException 은 즉시 throw 없이 onlineCtx 내에 에러 누적. BusinessException과 함께 사용 불가. 멀티에러 처리시 addBusinessException만 사용. 메소드: addBusinessException(errorCode, processCode, onlineCtx), addBusinessException(errorCode, processCode, telgmItemName, onlineCtx)
- Mapping Rule: #MULERR START → (블록 시작, 특별한 Java 코드 불필요). 블록 내 각 #ERROR → addBusinessException() 호출로 변환. #MULERR END → (블록 종료, 특별한 Java 코드 불필요). 10개 제한은 프레임워크가 내부 처리

---

### [매크로 6.1.3] - 사용자 맞춤메시지 (#CSTMSG)

- z-KESA: #CSTMSG
- n-KESA: new BusinessException(String errorCode, String processCode, String customMsg) 의 customMsg 파라미터
- z-KESA Detail: #CSTMSG WK-MSG. 파라미터: WK-MSG PIC X(100). 여러 번 발행시 최종발행분이 우선. 오류종료(#ERROR)인 경우에만 유효. 사용예: 03 CO-LONG PIC X(100) VALUE "현재 잔액이 부족하여 출금할 수 없습니다". #CSTMSG CO-LONG
- n-KESA Detail: BusinessException 생성자 3번째 파라미터 customMsg로 100바이트 이내 사용자정의 메시지 전달. 예: throw new BusinessException("B3800205","UBNE0070","현재 잔액이 부족하여 출금할 수 없습니다", e)
- Mapping Rule: #CSTMSG 발행 직전 변수에 담긴 메시지 값을 추출하여 #ERROR에 대응하는 BusinessException 생성자의 customMsg 파라미터로 전달. #CSTMSG + #ERROR 두 줄을 하나의 throw new BusinessException(코드, 조치, 메시지) 한 줄로 통합

---

### [매크로 6.1.4] - 호출요청 (#ERAFPG)

- z-KESA: #ERAFPG
- n-KESA: 선후처리 필터(FU 클래스의 FM 메소드) + 프레임워크 관리콘솔 등록 / 또는 @PostProcess 어노테이션 패턴
- z-KESA Detail: #ERAFPG 호출요청프로그램명(X8) 입력파라미터(X200). 오류 또는 후처리가 필요시 사용. Rollback 후 갱신프로그램(후처리프로그램) 호출 요청. 인터페이스 영역: INPUT 200Byte, OUTPUT 1Byte. AS 프로그램에서만 사용가능. 사용예: #ERAFPG DLA1080 XDLA1080-IN (비밀번호오류회수 갱신프로그램 등록)
- n-KESA Detail: 선후처리 FM은 FU 클래스 내 FM 메소드로 작성. "공유메소드여부"를 "예"로 설정. 프레임워크 관리콘솔에 선후처리로 등록(담당자 요청). IOnlineContext, CommonArea는 거래 전체에서 공유. 후처리 에러시 rollback 동작은 3.11.4 참조
- Mapping Rule: z-KESA #ERAFPG로 등록한 후처리 프로그램을 n-KESA 선후처리 FM으로 전환. 후처리 프로그램의 200Byte 인터페이스를 IDataSet으로 전환. 오류후처리는 catch 블록 내에서 해당 FM 직접 호출 또는 프레임워크 선후처리 필터로 등록

---

### [매크로 6.1.5] - 에러메시지출력 (#TRMMSG)

- z-KESA: #TRMMSG
- n-KESA: ReturnStatus 패턴 - BusinessException ex = new BusinessException(errorCode, processCode, customMsg); / 상위에서 catch 후 응답 DataSet에 에러정보 세팅
- z-KESA Detail: #TRMMSG 에러메시지코드(X8) 조치코드(X5). COMMIT 후 에러메시지 조립. #ERROR에 의한 에러처리가 먼저 있으면 #TRMMSG는 무시됨. 정상처리(COMMIT)는 완료했지만 단말에는 에러 메시지를 보내야 하는 특수 케이스. 온라인 전용
- n-KESA Detail: ReturnStatus 패턴 사용: BusinessException 객체를 throw 없이 생성 → PM에서 catch하거나 ReturnStatus 객체를 활용. 예: BusinessException ex = new BusinessException("S9700048", "USQC0014", "부가메시지"); / 응답 DataSet에 에러코드/조치코드 세팅 후 정상 return. 3.6.3.1 BusinessException 사용예(ReturnStatus) 참조
- Mapping Rule: DB COMMIT은 성공했지만 단말에 에러응답을 보내야 하는 케이스. throw 없이 BusinessException 객체를 생성한 후 응답 DataSet에 에러정보를 수동으로 세팅하는 ReturnStatus 패턴으로 전환. 또는 @Transactional 분리로 트랜잭션 제어

---

### [매크로 6.1.6] - 정상종료 (#OKEXIT)

- z-KESA: #OKEXIT
- n-KESA: 메소드의 정상 return (IDataSet 반환) / 정상부가메시지 코드는 출력 DataSet에 세팅
- z-KESA Detail: #OKEXIT 정상종료상태코드 [정상부가메시지코드]. CO-STAT-OK = '00'. 발행시 프로그램 종료. AS/연동출력편집프로그램에서 #OKEXIT 으로 부가메시지코드 지정. 부가메시지 코드: N0000000=정상처리완료, N0000001=취소정정처리완료, N0000002=조회없음, N0000003=조회완료, N0000004=등록완료, N0000005=변경완료. 온라인/배치 모두 사용
- n-KESA Detail: PM/FM/DM 메소드에서 IDataSet을 return. 정상종료 코드 세팅 필요없음 (예외 없이 return = 정상). 부가메시지는 응답 DataSet에 해당 필드를 세팅하거나 프레임워크가 자동 처리. 배치에서는 step 완료가 정상종료
- Mapping Rule: #OKEXIT → 메소드 말미의 return 문. 상태코드 변수(CO-STAT-OK) 세팅 및 체크 로직 제거. #OKEXIT 의 정상부가메시지코드는 응답 DataSet의 해당 필드에 put()으로 세팅하거나 프레임워크 기본값 활용

---

### [매크로 6.1.7] - 출력화면번호 지정 (#SCRENO)

- z-KESA: #SCRENO
- n-KESA: commontype.getTranInfoType().setStndScrenNo(String screenNo) / ca.getBiCom().getScrenNo() 조회 후 응답전문 헤더에 화면번호 세팅
- z-KESA Detail: #SCRENO 출력화면번호(X11). 입력화면과 출력화면이 다른 경우 내부표준전문의 화면번호 변경. AS/PC 프로그램에서만 사용가능. 한 거래 내 중복 사용시 최후발행분만 유효. 상수/변수 모두 사용가능
- n-KESA Detail: MCI BID 응답처리(3.10) 또는 연동거래(3.8.9)에서 출력 화면번호 지정. setStndScrenNo("BNL72888000") 형태로 표준화면번호 지정. 3.3.7 MCI 출력전문 조립 참조
- Mapping Rule: #SCRENO 출력화면번호 → 응답 전문 헤더 객체의 setStndScrenNo(화면번호) 또는 CommonArea의 screnNo 필드 세팅. PM 계층에서만 호출 원칙 동일

---

### [매크로 6.1.8] - 출력 폼 ID SET (#BOFMID)

- z-KESA: #BOFMID
- n-KESA: addOutFormInfo(String formId, String formType, String copies, String elctrFxdDstCd, String fCopies, String bCopies, IOnlineContext onlineCtx)
- z-KESA Detail: #BOFMID '출력폼ID-1' '출력폼ID-2' ~ '출력폼ID-20'. 폼 ID를 공통영역에 SETTING. 최대 20개 SET 가능. 폼 ID 중복시 SKIP. 상수 또는 변수 사용 가능. 온라인 전용
- n-KESA Detail: addOutFormInfo("KHC0313059","V1","01","01","","",onlineCtx). formId: 출력화면ID, formType: 폼유형, copies: 매수 등. 거래에 복수 폼이 있는 경우 반드시 addOutFormInfo를 사용하여 출력폼 지정. 3.3.7 MCI 출력전문 조립 참조
- Mapping Rule: 각 #BOFMID 의 폼ID를 addOutFormInfo() 호출로 1:1 변환. 최대 20개 반복 호출. 폼 타입/매수 등 추가 파라미터는 업무 설계서 기준으로 지정

---

### [매크로 6.1.9] - 출력메모리 할당 (#GETOUT)

- z-KESA: #GETOUT
- n-KESA: IDataSet responseData = createDataSet() 또는 PM 메소드의 IDataSet 반환 객체 초기화 / 출력 구조는 메소드 IO 설계에서 정의
- z-KESA Detail: #GETOUT 출력영역파라미터 [출력제정의번호(2)]. AS 프로그램에서만 사용. 출력 COPY북(YPXXXXXXXX-CA)에 대한 메모리 확보 및 초기화. LINKAGE SECTION에 선언된 출력 카피북 포인터 영역을 프레임워크가 할당. 사용예: #GETOUT YPLA1010-CA
- n-KESA Detail: PM 메소드의 리턴 IDataSet이 곧 출력영역. 메소드 생성 시 출력 IO 정의에서 구조 확정. IDataSet requestData를 복사하거나 new IDataSet 생성. 초기화는 createDataSet() 또는 requestData.clone(). 출력 구조는 프레임워크 개발도구의 메소드 IO 설계 화면에서 정의
- Mapping Rule: #GETOUT + 출력 카피북 초기화 패턴을 제거. 대신 PM 메소드가 반환하는 IDataSet 객체를 사용. 출력 필드는 responseData.put("fieldName", value) 패턴으로 세팅. 출력 제정의번호(복수 출력 패턴)는 n-KESA의 복수 IDataSet 또는 IRecordSet 구성으로 대체

---

### [매크로 6.1.10] - 프로그램 호출 (#DYCALL)

- z-KESA: #DYCALL
- n-KESA: callSharedMethod(String compId, String unitId_methodName, IDataSet requestData, IOnlineContext onlineCtx) / callServiceByRequired(String tranCd, IDataSet requestData, IOnlineContext onlineCtx) / 직접 메소드 호출 (동일 컴포넌트 내)
- z-KESA Detail: #DYCALL 프로그램ID YCCOMMON-CA 프로그램호출영역. Dynamic Call. 프로그램ID는 변수/상수 불가(반드시 상수). AS/IC/PC/DC/FC/BCS 호출규칙 체크. YCCOMMON-CA(Common Area) + 프로그램간 인터페이스 카피북 전달. 사용예: #DYCALL DLA0110 YCCOMMON-CA XDLA0110-CA
- n-KESA Detail: 동일 컴포넌트 내 FM/DM 호출: 직접 메소드 호출 또는 callMethodByRequiresNew(). 타 컴포넌트 FM 호출: callSharedMethod(컴포넌트ID, "유닛ID.메소드명", reqData, onlineCtx). PM→PM(연동거래): callServiceByRequired(거래코드, reqData, onlineCtx). 첫 파라미터는 반드시 String 상수값으로 사용
- Mapping Rule: #DYCALL 호출패턴을 호출 계층에 따라 세 가지로 분기. 동일 컴포넌트 DC/IC → 직접 Java 메소드 호출. 타 컴포넌트 PC/IC/DC → callSharedMethod(). AS 연동거래 → callServiceByRequired(). YCCOMMON-CA는 IOnlineContext onlineCtx로 대체. 인터페이스 카피북(XDLA0110-CA)은 IDataSet으로 대체

---

### [매크로 6.1.11] - 프로그램 STATIC 호출 (#STCALL)

- z-KESA: #STCALL
- n-KESA: 직접 Java 메소드 호출 (Static 방식과 동등) - 단, 프레임워크 API 준수 원칙
- z-KESA Detail: #STCALL 프로그램ID 프로그램호출영역. DYNAMIC 호출이 기본. 개발자 사용 금지. 프레임워크팀 허락 하에만 사용. 사용예: #STCALL ZSGTIME XZSGTIME-CA
- n-KESA Detail: Java에서 Dynamic/Static 구분 없음. 같은 JVM 내에서 모두 직접 메소드 호출. 성능 최적화가 필요한 경우 callMethodByRequiresNew()를 통해 별도 트랜잭션으로 분리 가능. 일반적으로 #DYCALL 매핑과 동일하게 처리
- Mapping Rule: #STCALL은 #DYCALL과 동일한 n-KESA 패턴으로 매핑. 유틸리티 프로그램(ZSGTIME 등) 호출은 해당 Java 유틸리티 클래스의 static 메소드 또는 인스턴스 메소드 호출로 직접 대체

---

### [매크로 6.1.12] - DBIO 호출 (#DYDBIO)

- z-KESA: #DYDBIO
- n-KESA: DBIO Unit의 DBM 메소드 호출: dbInsert() / dbSelect() / dbSelectForUpdate() / dbUpdate() / dbDelete() / DataUnit의 DM 메소드 (SELECT 전용)
- z-KESA Detail: #DYDBIO 기능COMMAND 테이블키정보 테이블정보. 기능커맨드: SELECT-CMD-N(NO LOCK), SELECT-CMD-Y(LOCK), INSERT-CMD-Y, UPDATE-CMD-Y, DELETE-CMD-Y, LKUPDT-CMD-Y(LOCK UPDATE), OPEN-CMD-0~4(커서OPEN), FETCH-CMD-0~4(FETCH), CLOSE-CMD-0~4(CLOSE), SELFST-CMD-0~4(SELECT FIRST). 테이블키 카피북: TK+테이블명, 테이블레코드 카피북: TR+테이블명. 사용후 반드시 결과 체크(COND-DBIO-OK, COND-DBIO-MRNF). 초기화절에서 PK/REC 초기화 필수
- n-KESA Detail: 계정계 업무: DBIO Unit(DBIO_+테이블명) 사용. DBM 메소드: insert("insert",param,onlineCtx), select("select",param,onlineCtx), selectForUpdate("selectForUpdate",param,onlineCtx), update("update",param,onlineCtx), delete("delete",param,onlineCtx). 커서(OPEN/FETCH/CLOSE) → dbSelect()+RecordHandler 패턴 또는 dbSelectPage(). MRNF(not found) 처리: IRecord가 null이거나 IRecordSet이 empty. 일반서버업무는 DataUnit의 dbSelect/dbInsert/dbUpdate/dbDelete 사용
- Mapping Rule: SELECT-CMD-N/Y → dbSelect() 또는 dbSelectSingle() (selectForUpdate 미사용), SELECT-CMD-Y → selectForUpdate(). INSERT-CMD-Y → dbInsert(). UPDATE-CMD-Y → dbUpdate(). DELETE-CMD-Y → dbDelete(). LKUPDT-CMD-Y → selectForUpdate 후 update. OPEN/FETCH/CLOSE 커서패턴 → dbSelect()+RecordHandler 구현. COND-DBIO-MRNF 체크 → null/empty 체크로 변환. 에러시 #ERROR → throw new BusinessException() 또는 DataException

---

### [매크로 6.1.13] - SQLIO SELECT (#DYSQLA)

- z-KESA: #DYSQLA
- n-KESA: DataUnit의 DM 메소드: dbSelect(String stmtName, Object param, IOnlineContext onlineCtx) / dbSelectSingle() / dbSelectPage()
- z-KESA Detail: #DYSQLA SQLIO명 기능 SQLIO인터페이스. 기능: SELECT, OPEN, FETCH, CLOSE. DBIO를 보조하여 SELECT만 가능. SQLIO인터페이스(YCDBSQLA)는 BPG에서 등록생성. 초기화절에서 SQLIO인터페이스 초기화 필수. 사용예: #DYSQLA QLA0010 SELECT XQLA0010-CA
- n-KESA Detail: DataUnit(DU+테이블명.java)에서 XSQL 파일의 SQL ID를 호출. SELECT 단건: dbSelectSingle("select", param, onlineCtx). SELECT 다건: dbSelect("selectList", param, onlineCtx). 페이징: dbSelectPage("selectList", param, pageNo, rowPerPage, onlineCtx). OPEN/FETCH/CLOSE 커서 → dbSelect()+RecordHandler
- Mapping Rule: #DYSQLA ... SELECT → dbSelect() 또는 dbSelectSingle(). 커서(OPEN/FETCH/CLOSE) → RecordHandler 구현 또는 dbSelectPage(). SQLIO 카피북(XQLA0010-CA)의 조회조건/결과 필드 → IDataSet param/IRecordSet으로 전환. COND-DBSQL-OK 체크 → null/empty 체크

---

### [매크로 6.1.14] - 입력편집용 영역확보 (#GETINP)

- z-KESA: #GETINP
- n-KESA: 선처리 FM(Filter FunctionUnit)에서 requestData 조작 / 연동거래 선처리에서 입력 DataSet 조립
- z-KESA Detail: #GETINP [입력편집할 거래코드] [입력편집할 AS카피북]. 연동제어프로그램에서 직접 입력편집시 사용. 거래코드에 해당하는 입력카피북을 입력으로 선언. 연동제어프로그램의 출력은 AS 입력카피북. 파라미터: YCSFIAYA 사용. 사용예: #GETINP KLA01002 YNLA1002-CA
- n-KESA Detail: 연동거래(3.8.9)의 선처리 FM 또는 callServiceByRequired() 호출 전 requestData 조립 패턴. 연동거래 CommonArea 복제는 3.8.9.6 참조. 선처리에서 입력 DataSet을 조립하여 연동거래 PM 호출
- Mapping Rule: #GETINP로 확보하는 입력편집 영역을 callServiceByRequired() 호출 전 requestData IDataSet으로 직접 구성. 연동제어프로그램의 역할을 선처리 FM 또는 PM 로직으로 흡수

---

### [매크로 6.1.15] - 채번 NCS (#GETNCS)

- z-KESA: #GETNCS
- n-KESA: 채번 서비스 FM 호출 (FU의 FM 메소드) 또는 DB 시퀀스/AUTO_INCREMENT 활용 / UUID 생성 / 별도 채번 서비스 API 호출
- z-KESA Detail: #GETNCS FUNC-CD COUNTER-NAME [INIT-VALUE]. CICS NCS(Named Counter Server)를 이용한 유일번호 채번. FUNC-CD: COND-COUNTER(채번+1/일반업무), COND-COUNT(단순채번+1), COND-DELNEW(삭제후생성), COND-CREATE(신규생성), COND-DELETE(삭제), COND-SELECT(현재값조회). 카피북: XZUGNCSM. 최대값: 2,147,483,647 (초과시 초기값으로 리셋). NCS COUNTER NAME: [생성구분(1)][기관코드(3)][업무코드(3)][로깅인터벌(2)][요일구분(1)][식별번호(6)]=16자. 채번 후 에러처리해도 채번번호 rollback 불가. 온라인/배치 사용
- n-KESA Detail: n-KESA에서는 NCS 개념 없음. 대체방안: (1) DB 시퀀스 직접 사용 - dbInsertAndReturnPK() 또는 XSQL에서 NEXT VALUE FOR 시퀀스 사용. (2) 채번 공통 FM 호출 (프레임워크/공통팀 제공). (3) UUID 사용: UUID.randomUUID().toString(). 결번없는 채번이 필요한 경우 DB 시퀀스 방식이 가장 적합
- Mapping Rule: #GETNCS COND-COUNTER → DB 시퀀스 채번(XSQL에서 NEXTVAL). #GETNCS COND-CREATE → DB 시퀀스 생성 (DBA 협의). #GETNCS COND-DELETE → 채번 카운터 삭제 배치 대체. NCS Counter Name 명명규칙(16자)을 DB 시퀀스명으로 대체. NCS 결번가능성 주의사항은 DB 시퀀스도 동일하게 적용

---

### [매크로 6.1.16] - JCL 실행 (#JCLSRT) (미사용)

- z-KESA: #JCLSRT
- n-KESA: worKB 연계 호출 (3.14) 또는 배치 스케줄러(Control-M) 연동 API / 배치 JOB 트리거 서비스
- z-KESA Detail: #JCLSRT JCLNAME(X8). 온라인에서 사전등록된 배치 JCL 기동. 현재 미사용. 카피북: XZUGJCLE. 사용예: #JCLSRT CO-CHA-JCLNAME
- n-KESA Detail: worKB 연계 호출(3.14): 입력 파라미터 정의 후 callWorKB() 형태로 호출. 또는 배치 스케줄러(Control-M) API를 통한 JOB 동적 기동. 3.14 worKB 연계 호출 참조
- Mapping Rule: #JCLSRT는 미사용(deprecated) 이므로 해당 로직 제거 우선 검토. 실제로 온라인에서 배치를 기동해야 하는 경우 worKB 연계(3.14) 또는 별도 배치 트리거 서비스 API로 대체

---

### [매크로 6.1.17] - 사용자로그출력 (#USRLOG)

- z-KESA: #USRLOG
- n-KESA: log.debug(String msg) / log.info(String msg) / log.warn(String msg) / log.error(String msg)
- z-KESA Detail: #USRLOG [출력형식] 출력대상변수 또는 상수. 출력형식: %T(변수명출력), %ii(길이), %Vff(소수점), %P(Pointer), %I(INDEX), %L(Length). 최대 130자. JOB Sysout 또는 프레임워크 User LOG에 출력. 디버깅 활용. COMP/COMP-3 출력시 형식 지정 필수. 상수 숫자 직접사용 불가. 온라인/배치 모두 사용
- n-KESA Detail: context.getLogger()로 로거 획득. log.debug()/log.info()/log.warn()/log.error() 사용. 반드시 if(log.isDebugEnabled()){...} 구문으로 감싸서 String 연산 방지. 파라미터 치환 형식: log.debug("{0},{1}", param1, param2). apache commons-logging 호환 인터페이스. 로그는 online-거래코드-YYYYMMDD.log 파일 및 NJFT_FLOW_LOG DB 테이블에 저장
- Mapping Rule: #USRLOG 변수 출력 → log.debug("변수명: {0}", 변수값). 숫자형(COMP/COMP-3) 변수는 Java에서 자동으로 toString() 처리됨. 출력형식(%T, %ii 등) → String.format() 또는 log.debug()의 파라미터 치환으로 변환. 운영환경 성능을 위해 if(log.isDebugEnabled()) 구문 필수 적용

---

### [매크로 6.1.18] - 중단거래 요청 (#DSCNTR)

- z-KESA: #DSCNTR
- n-KESA: setDscnTranInfo(String dscnTranDstcd, String bfTdkInfoCtnt, IOnlineContext onlineCtx) / ca.getBiCom().getDscnTranDstcd() (중단거래구분코드 조회)
- z-KESA Detail: #DSCNTR [중단거래구분코드(X1)] [중단거래다음KEY변수(X100 이내)]. 중단거래구분코드: 1=중단거래, 2=중단거래자동. 다음KEY변수 100Byte 이내. BICOM-DSCN-TRAN-DSTCD로 중단거래 구분코드 확인. 사용예: IF 계속데이터존재 / #DSCNTR 1 WK-NEXT-KEY / END-IF
- n-KESA Detail: setDscnTranInfo("1", bfTdkInfoCtnt, onlineCtx) - 다음 차수를 위한 Key 저장 요청. 중단거래구분코드: "0"=일반거래, "1"=중단거래, "2"=중단거래(Auto). ca.getBiCom().getDscnTranDstcd()로 현재 거래의 중단여부 확인. 초회차는 구분코드=0, n회차부터 1 또는 2로 세팅. 중지회차 확인: 3.12.5 참조. 후처리에서 Key 저장됨
- Mapping Rule: #DSCNTR 1 WK-NEXT-KEY → setDscnTranInfo("1", nextKey, onlineCtx). #DSCNTR 2 WK-NEXT-KEY → setDscnTranInfo("2", nextKey, onlineCtx). BICOM-DSCN-TRAN-DSTCD 참조 → ca.getBiCom().getDscnTranDstcd(). 중단거래 KEY를 담는 WK-NEXT-KEY(X100) → String bfTdkInfoCtnt (100자 이내)

---

### [매크로 6.1.19] - 운영로그 출력 (#SYSLOG)

- z-KESA: #SYSLOG
- n-KESA: log.info(String msg) / log.error(String msg) / 운영 모니터링은 프레임워크 로그파일 및 DB 로그 활용
- z-KESA Detail: #SYSLOG 구분코드(X2) 변수1 변수2 상수1 ... 구분코드: CON(콘솔), OUT(출력). COMP/COMP-3 출력시 편집모드 변수로 MOVE 후 출력. 운영자 대상 로그. 온라인 전용
- n-KESA Detail: log.info()는 INFO 레벨 로그 파일에 기록. log.error()는 ERROR 레벨로 기록. FLOW_LOG DB 저장(개발/스테이징 환경). 운영 환경에서는 INFO 이상만 기록. 3.4 로그처리 참조
- Mapping Rule: #SYSLOG CON → log.info(). #SYSLOG OUT → log.info() 또는 log.error(). COMP/COMP-3 형 변수의 편집처리는 Java에서 불필요(자동 toString). 구분코드(CON/OUT)는 로그레벨(info/error)로 변환

---

### [매크로 6.1.20] - Format Dump (#FMDUMP)

- z-KESA: #FMDUMP
- n-KESA: log.debug("필드명: {0}", requestData) / requestData.toString() / 개발도구의 메소드 테스트 화면에서 DataSet 내용 확인
- z-KESA Detail: #FMDUMP SPACE 카피북명. 사용자가 원하는 카피북 전체를 표현. 주로 디버깅 용도. 사용예: #FMDUMP SPACE STND-TELGM-HEADER. 온라인/배치 모두 사용
- n-KESA Detail: log.debug("{0}", requestData)로 IDataSet 전체 내용 출력. IDataSet의 toString()은 전체 필드-값을 출력. 개발환경에서는 프레임워크 로컬 테스트 도구에서 DataSet 내용을 화면으로 확인 가능. if(log.isDebugEnabled()) 구문 필수
- Mapping Rule: #FMDUMP SPACE 카피북명 → if(log.isDebugEnabled()){ log.debug("카피북명: {0}", 해당DataSet); }. 배포 전 디버깅 목적 코드는 최종 제거 또는 debug 레벨로 유지

---

### [매크로 6.1.21] - 보안모듈 호출 (#CRYPTO)

- z-KESA: #CRYPTO
- n-KESA: KBCryptoUtils.encryptText(String plainText) / KBCryptoUtils.decryptText(String encryptedText) / KBCryptoUtils.encryptBytes() / KBCryptoUtils.decryptBytes()
- z-KESA Detail: #CRYPTO. 카피북: XFAVSCPH. 보안모듈 호출(암호화). 사용예: 01 XFAVSCPH-CA. COPY XFAVSCPH. #CRYPTO. 파라미터 상세 불명(프레임워크 내부 처리). 온라인/배치 사용
- n-KESA Detail: KBCryptoUtils 클래스 (com.kbstar.sqc.util.KBCryptoUtils). 개인정보 DB 암호화(scpDB): encryptText(), decryptText(), encryptBytes(), decryptBytes(), encryptFile(), decryptFile(). 단방향 암호화: encryptTextHash(int algorithm, String plainText), encryptTextHmac(String plainText). 알고리즘 상수: KBCryptoUtils.ALGORITHM_SHA256. KB 정보보호부 KMS 연동. 신규AP에 암호화모듈 설치 요청 필요. 3.3.8 데이터 암호화 API 참조
- Mapping Rule: #CRYPTO (암호화용) → KBCryptoUtils.encryptText() 또는 encryptBytes(). 복호화 → KBCryptoUtils.decryptText() 또는 decryptBytes(). 파일암호화 → encryptFile()/decryptFile(). XFAVSCPH 카피북의 IN/OUT 필드 → KBCryptoUtils 메소드의 파라미터/리턴값으로 매핑

---

### [매크로 6.1.22] - 보안모듈 호출 (#SECCVT)

- z-KESA: #SECCVT
- n-KESA: KBCryptoUtils.encryptText() (전문암호화용, scpHost) / 전문 암호화 전용 메소드 (3.3.8.3 전문암호화 scpHost)
- z-KESA Detail: #SECCVT. 카피북: XFAVSNSH. 보안모듈 호출(전문 암호화, #CRYPTO와 구분). 사용예: 01 XFAVSNSH-CA. COPY XFAVSNSH. #SECCVT. #CRYPTO와 다른 용도로 추정(전문 암호화). 온라인/배치 사용
- n-KESA Detail: 전문 암호화(scpHost): 3.3.8.3 전문 암호화 API 사용. KBCryptoUtils 클래스 또는 별도 전문암호화 메소드. XFAVSNSH 카피북에 대응하는 전문암호화 파라미터 구조를 Java 파라미터로 변환
- Mapping Rule: #SECCVT (전문암호화) → KBCryptoUtils 전문암호화 메소드(scpHost 계열). XFAVSNSH 카피북의 IN/OUT → Java 파라미터/리턴값. #CRYPTO와 #SECCVT의 용도 구분(개인정보DB암호화 vs 전문암호화)을 n-KESA의 scpDB vs scpHost API로 대응

---

### [매크로 6.1.23] - 후처리 LOG CHECK (#LOGCHK)

- z-KESA: #LOGCHK
- n-KESA: 선후처리 필터(FU FM) 내에서 onlineCtx 또는 CommonArea의 로그정보 조회 / 프레임워크 FLOW_LOG DB 조회
- z-KESA Detail: #LOGCHK. 카피북: YLLDLOGM. 후처리 LOG CHECK 로직 삽입. 사용예: 01 YLLDLOGM-CA. COPY YLLDLOGM. #LOGCHK. 후처리 로그 상태 확인 목적
- n-KESA Detail: 선후처리 FM(FU의 FM)에서 onlineCtx.getException()으로 에러여부 확인. 3.11.3.3 에러 후처리 Exception 조회예 참조. FLOW_LOG DB(NJFT_FLOW_LOG 테이블)에서 로그 이력 확인 가능. 에러후처리에서 응답DataSet 조회: 3.11.3.4 참조
- Mapping Rule: #LOGCHK → 선후처리 FM에서 후처리 Exception 조회(3.11.3.3) 로직으로 대체. YLLDLOGM 카피북의 로그상태 필드 → onlineCtx/CommonArea 의 해당 필드 또는 별도 로그조회 서비스 호출

---

### [매크로 6.1.24] - Macro 종료 (#END)

- z-KESA: #END
- n-KESA: (해당 없음 - Java에서 자동 처리)
- z-KESA Detail: #END. 매크로 종료 처리. #XXXXXX A1 A2 ... #END 형태로 사용. 매크로 블록의 끝을 나타내는 구분자. 사용예: #USRLOG "중계로그..." WK-KEY / #END
- n-KESA Detail: Java 메소드는 { }(중괄호)로 블록 경계가 명확. 별도의 종료 마커 불필요. 메소드 끝의 닫는 괄호(})가 #END와 동일한 역할
- Mapping Rule: #END → 제거(Java에서 불필요). 매크로 블록 시작/끝 구조(#MULERR START...END, #USRLOG...#END 등)는 Java의 {} 블록으로 자동 대응

---

## 2. 유틸리티 매핑 (Section 6.2) - Utility Programs

---

### [유틸리티 6.2.1] - BIT, BYTE 변환 (ZUDAV01)

- z-KESA: ZUDAV01
- n-KESA: Java 표준 비트연산 및 변환 API / org.apache.commons.codec.binary.BinaryCodec / Integer.toBinaryString() / Integer.parseInt(str, 2)
- z-KESA Detail: CALL 방식 호출. 카피북: XZUDAV01. BIT↔BYTE 상호변환. 최대 BIT길이 8192byte, BYTE길이 2048byte. POINTER 형태 입출력. XZUDAV01-I-TYPE: 'I'(BIT→BYTE), 'Y'(BYTE→BIT). 예: "10010010001"→591, "ABC"→"101010111100". 온라인/배치 사용
- n-KESA Detail: Java 표준 API로 대체. BIT→BYTE: Integer.parseInt("10010010001", 2) → 1169. BYTE→BIT(각 바이트를 이진수로): Integer.toBinaryString(byte값). 또는 commons-codec BinaryCodec 사용. 대용량은 BitSet 클래스 활용
- Mapping Rule: ZUDAV01 CALL 블록 제거. XZUDAV01-I-TYPE='I' (BIT→BYTE) → Integer.parseInt(bitString, 2). XZUDAV01-I-TYPE='Y' (BYTE→BIT) → Integer.toBinaryString() 또는 BinaryCodec.toAsciiString(). POINTER 입출력 → Java String/byte[] 파라미터로 직접 전달

---

### [유틸리티 6.2.2] - 숫자 변환 (ZUDAV02)

- z-KESA: ZUDAV02
- n-KESA: 한글숫자변환 공통 유틸 클래스 (업무팀 자체 구현 또는 공통팀 제공) / Java 미표준이므로 별도 구현 필요
- z-KESA Detail: CALL 방식 호출. 카피북: XZUDAV02. 아라비아 숫자를 영문/한글 숫자로 변환. XZUDAV02-I-TYPE: '1'(한글), '2'(영문). 예: 1500→"fifteen hundred", 1234→"일천 이백 삼십 사". 최대 PIC S9(15)V999. 결과길이: XZUDAV02-O-LEN, 결과값: XZUDAV02-O-AMT(X200). 온라인/배치 사용
- n-KESA Detail: Java 표준 API에 없음. 공통팀에서 제공하는 숫자→한글/영문 변환 유틸 클래스 사용 또는 업무팀 자체 구현. 영문: com.ibm.icu.text.RuleBasedNumberFormat (ICU4J 라이브러리) 활용 가능. 한글: 별도 커스텀 유틸 구현
- Mapping Rule: ZUDAV02 CALL → 공통팀 제공 유틸 메소드 호출 또는 ICU4J RuleBasedNumberFormat 사용. XZUDAV02-I-TYPE='1'(한글) → 커스텀 한글숫자변환 메소드. XZUDAV02-I-TYPE='2'(영문) → RuleBasedNumberFormat.format(). 결과 O-LEN/O-AMT → String 반환값으로 대체

---

### [유틸리티 6.2.3] - ASCII, EBCDIC 변환 (ZUDAV03)

- z-KESA: ZUDAV03
- n-KESA: new String(bytes, "Cp500") / bytes = str.getBytes("Cp500") / Java NIO Charset 변환 (Charset.forName("IBM500"))
- z-KESA Detail: CALL 방식(ASM 비표준 호출). 카피북: XZUDAV03. ASCII↔EBCDIC 단순 상호변환. 최대 200자. XZUDAV03-I-TYPE: 'A'(ASCII→EBCDIC), 'E'(EBCDIC→ASCII). 예: X'313233'→X'F1F2F3'. 온라인/배치 사용
- n-KESA Detail: Java의 Charset을 이용한 인코딩 변환. ASCII→EBCDIC: str.getBytes(Charset.forName("IBM500")) 또는 "Cp500". EBCDIC→ASCII: new String(ebcdicBytes, Charset.forName("IBM500")). 한글 포함 데이터는 ZUGCDCV/ZUGDAPC 유틸리티와 동일한 방식으로 처리
- Mapping Rule: ZUDAV03 CALL 블록 제거. XZUDAV03-I-TYPE='A' → str.getBytes(Charset.forName("IBM500")). XZUDAV03-I-TYPE='E' → new String(bytes, Charset.forName("IBM500")). 최대 200자 제한은 Java에서 입력값 길이 체크로 구현

---

### [유틸리티 6.2.4] - ASCII, EBCDIC 코드변환 및 전반자 코드변환 (ZUGDAPC)

- z-KESA: ZUGDAPC
- n-KESA: Java Charset 변환 (IBM-1364, EUC-KR, UTF-8) / 한글 전반자 변환 공통 유틸 / ZUGCDCV 매핑과 동일
- z-KESA Detail: #DYCALL 호출. 카피북: XZUGDAPC. ASCII↔EBCDIC 및 전자↔전반자 혼용변환. IBM1364(KSC5700) 기반. 최대 2000자. 요청타입(2Byte): 'SM'(그래픽/전자+SOSI→전반자혼용), 'DM'(전반자혼용→전자+SOSI), 'LL'(유효길이계산), 'AE'(ASCII→EBCDIC), 'EA'(EBCDIC→ASCII), 'ZZ'(ASCII→EBCDIC+혼용). 응답코드: '000'정상, 'ERR'비정상, 'PAR'파라미터오류, 'CDE'코드변환오류, 'OVR'길이오류. 온라인/배치 사용
- n-KESA Detail: ZUGCDCV로 대체(6.2.12 참조). Java에서 IBM-1364(확장한글) Charset: Charset.forName("x-IBM1364") 또는 "Cp1364". 전반자 변환은 java.text.Normalizer 또는 별도 공통 유틸 사용. SO/SI 처리는 Java byte 배열 직접 조작
- Mapping Rule: ZUGDAPC → ZUGCDCV 로 우선 대체. 요청코드 매핑: SM→AMEM, DM→EDEM, AE→AMEM/AMED, EA→EMAM 등(ZUGCDCV 6.2.12의 업무요건별 권고안 참조). Java Charset 변환으로 직접 구현 가능. XZUGDAPC-IN/OT 카피북 필드 → Java 메소드 파라미터/리턴값으로 대체

---

### [유틸리티 6.2.5] - IBM 2 BYTE, KSC5601 변환 (ZUDAA04)

- z-KESA: ZUDAA04
- n-KESA: Java Charset 변환: Charset.forName("x-IBM1364") ↔ Charset.forName("EUC-KR") / 한글 인코딩 공통 유틸
- z-KESA Detail: CALL 방식(ASM). 카피북: XZUDAA04. IBM 2Byte(IBM1364) ↔ KSC5601 상호변환. POINTER 형식 입출력. XZUDAA04-IN-TYPE: 'I'(IBM→KSC5601), 'K'(KSC5601→IBM). XZUDAA04-IN-LEN: 입력길이. 포인터 방식으로 입출력 주소 지정. 온라인/배치 사용
- n-KESA Detail: IBM1364(IBM 확장한글) ↔ EUC-KR(KSC5601): byte[] ibm = str.getBytes("x-IBM1364"); → new String(ibm, "EUC-KR") 방식으로 변환. 또는 공통팀 제공 한글 인코딩 변환 유틸 사용. 포인터 방식 불필요(Java는 값 직접 전달)
- Mapping Rule: ZUDAA04 CALL 블록 제거. XZUDAA04-IN-TYPE='I' (IBM→KSC5601) → new String(ibmBytes, "EUC-KR"). XZUDAA04-IN-TYPE='K' (KSC5601→IBM) → str.getBytes("x-IBM1364"). POINTER 입출력 → byte[]/String 직접 파라미터 전달

---

### [유틸리티 6.2.6] - ASCII, UNICODE 코드 변환 (ZUDAV05)

- z-KESA: ZUDAV05
- n-KESA: new String(asciiBytes, StandardCharsets.US_ASCII) / str.getBytes(StandardCharsets.UTF_16) / Java Charset 변환
- z-KESA Detail: CALL 방식. 카피북: XZUDAV05. ASCII↔UNICODE 상호변환. 최대 200Byte. XZUDAV05-I-TYPE: 'A'(ASCII→UNICODE), 'U'(UNICODE→ASCII). 입력: XZUDAV05-I-DATA(X200), 출력: XZUDAV05-O-DATA(X200). 온라인/배치 사용
- n-KESA Detail: Java의 String은 기본적으로 Unicode(UTF-16). ASCII→Unicode: 별도 변환 불필요(ASCII는 Unicode의 부분집합). ASCII bytes → Java String: new String(bytes, StandardCharsets.US_ASCII). Java String → ASCII bytes: str.getBytes(StandardCharsets.US_ASCII)
- Mapping Rule: ZUDAV05 CALL 블록 제거. XZUDAV05-I-TYPE='A' (ASCII→Unicode) → new String(bytes, StandardCharsets.US_ASCII). XZUDAV05-I-TYPE='U' (Unicode→ASCII) → str.getBytes(StandardCharsets.US_ASCII). Java String 자체가 Unicode이므로 대부분의 경우 변환 불필요

---

### [유틸리티 6.2.7] - DEC, HEX 코드 변환 (ZUDAV06)

- z-KESA: ZUDAV06
- n-KESA: org.apache.commons.codec.binary.Hex.encodeHexString() / Hex.decodeHex() / String.format("%02X", byte값)
- z-KESA Detail: CALL 방식. 카피북: XZUDAV06. DEC→HEX 변환 전용. 입력 최대 200Byte, 출력 최대 400Byte. 예: "1234567890"→"F1F2F3F4F5F6F7F8F9F0"(EBCDIC HEX). XZUDAV06-I-DEC(X200), XZUDAV06-O-HEX(X400). 온라인/배치 사용
- n-KESA Detail: apache commons-codec 사용. DEC→HEX: Hex.encodeHexString(bytes) 또는 String.format("%X", value). HEX→DEC: Hex.decodeHex(hexStr). 단순 십진수→16진수: Integer.toHexString(int) 또는 Long.toHexString(long). 대용량은 byte 배열 처리
- Mapping Rule: ZUDAV06 CALL 블록 제거. XZUDAV06-I-DEC 입력 → Java String/byte[] 파라미터. XZUDAV06-O-HEX 출력 → Hex.encodeHexString(bytes) 반환값. 최대 길이 체크(입력200/출력400)는 Java 입력값 검증으로 구현

---

### [유틸리티 6.2.8] - TIMESTAMP 제공 (ZSGTIME)

- z-KESA: ZSGTIME
- n-KESA: java.time.LocalDateTime.now() / java.sql.Timestamp / DateTimeFormatter / System.currentTimeMillis()
- z-KESA Detail: CALL 방식(ASM). 카피북: XZSGTIME. 현재 TIMESTAMP 제공. 26Byte(예: "2008-10-03-14.06.43.236052") 및 20Byte(예: "20081003140643236052") 형식. XZSGTIME-TIME-STAM26(X26), XZSGTIME-TIME-STAM20(X20), XZSGTIME-TIME-WORK(X32, 내부용). 온라인/배치 사용. 사용예: #DYCALL ZSGTIME XZSGTIME-CA 또는 CALL YCFCTLAR-CALL-PRM USING XZSGTIME-CA
- n-KESA Detail: Java 8+ 시간 API. LocalDateTime.now()로 현재 시각 획득. 26자형식: DateTimeFormatter.ofPattern("yyyy-MM-dd-HH.mm.ss.SSSSSS"). 20자형식: DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSSSS")(단, 마이크로초 처리 주의). java.sql.Timestamp.valueOf(LocalDateTime.now()).toString()도 유사한 형식 제공
- Mapping Rule: ZSGTIME CALL → LocalDateTime.now(). XZSGTIME-TIME-STAM26 → LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd-HH.mm.ss.SSSSSS")). XZSGTIME-TIME-STAM20 → LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSSSS")). XZSGTIME-TIME-WORK 필드는 Java에서 불필요(제거)

---

### [유틸리티 6.2.9] - BATCH TIME WAIT (ZBDAV13)

- z-KESA: ZBDAV13
- n-KESA: Thread.sleep(long millis) / TimeUnit.SECONDS.sleep(long) / TimeUnit.MILLISECONDS.sleep(long)
- z-KESA Detail: CALL 방식(ASM). 카피북: XZBDAV13. Batch에서 TIME DELAY 기능. XZBDAV13-WAIT: PIC S9(007) COMP, 단위 1/100초. 예: 100초 = 10000 (1/100초 단위). #DYCALL ZBDAV13 XZBDAV13-CA로 호출. Batch 전용(온라인 사용 불가)
- n-KESA Detail: Thread.sleep(milliseconds). ZBDAV13의 1/100초 단위 → 밀리초로 환산 후 Thread.sleep(). 예: XZBDAV13-WAIT=10000(100초) → Thread.sleep(100000L). TimeUnit.SECONDS.sleep(100) 또는 TimeUnit.MILLISECONDS.sleep(10*waitUnit) 형태로 가독성 향상. Batch 스탭 메소드 내에서 사용
- Mapping Rule: ZBDAV13 CALL → Thread.sleep(xzbdav13Wait * 10L) (1/100초 → 밀리초로 *10 환산). InterruptedException 처리 필요: catch(InterruptedException e) { Thread.currentThread().interrupt(); }. 온라인에서 sleep 사용은 n-KESA에서도 성능상 금지

---

### [유틸리티 6.2.10] - HEX, CHAR 코드변환 (ZUDAV20)

- z-KESA: ZUDAV20
- n-KESA: org.apache.commons.codec.binary.Hex.encodeHexString() / Hex.decodeHex() / String.format()
- z-KESA Detail: #DYCALL 호출. 카피북: XZUDAV20. CHAR↔HEX 상호변환. 최대 4000Byte(CH: 입력2000/출력4000). 요청타입(X2): 'CH'(CHAR→HEX), 'HC'(HEX→CHAR). XZUDAV20-I-TYPE(X2), XZUDAV20-I-LENG(9(4)), XZUDAV20-I-DATA(X4000), XZUDAV20-O-LENG(9(4)), XZUDAV20-O-DATA(X4000). 예: "A"→"C1"(EBCDIC기준). 온라인/배치 사용
- n-KESA Detail: CH(CHAR→HEX): Hex.encodeHexString(str.getBytes(charset)) 또는 String.format("%" + (len*2) + "X", value). HC(HEX→CHAR): new String(Hex.decodeHex(hexStr), charset). 대용량(최대4000byte) 처리는 StringBuilder + 반복으로 구현
- Mapping Rule: ZUDAV20 CALL 블록 제거. XZUDAV20-I-TYPE='CH' → Hex.encodeHexString(inputBytes). XZUDAV20-I-TYPE='HC' → new String(Hex.decodeHex(hexString), charset). XZUDAV20-I-LENG → str.length(). XZUDAV20-O-DATA/O-LENG → 반환 String과 length() 값으로 대체

---

### [유틸리티 6.2.11] - 메신저 전송요청 유틸리티 (ZUGMSNM)

- z-KESA: ZUGMSNM
- n-KESA: sendBidMessage() (MCI BID 메시지 전송) / callOutbound() (EAI 연계) / 내부 메신저 연동 FM 호출 / 3.10 MCI BID, PUSH 메시지 전송
- z-KESA Detail: #DYCALL 호출. 카피북: XZUGMSNM. KB-WiseNet 메신저 기능을 통한 쪽지/알림/팝업 전송. 수신인 1명. 파라미터: XZUGMSNM-IN-SERVTYPE(X1, 0:세션기반/1:IP기반), XZUGMSNM-IN-REMPNO(X7,수신직원번호), XZUGMSNM-IN-SENDNO(X7,발신직원번호), XZUGMSNM-IN-TITLE(X40,제목), XZUGMSNM-IN-BODY(X500,본문), XZUGMSNM-IN-URGENTYN(X1,긴급여부), XZUGMSNM-IN-SAVEOPTION(X1,저장여부), XZUGMSNM-IN-RECVIP(X24,수신자IP). 온라인 전용
- n-KESA Detail: n-KESA에서는 MCI BID/PUSH 메시지(3.10) 또는 EAI 연계로 대체. sendBidMessage(header, outDataDS, "BID거래코드", onlineCtx): 원인없는 BID로 단말에 메시지 전송. 또는 KB-WiseNet 연동 EAI 서비스를 callOutbound()로 호출. 수신직원번호는 DB에서 조회하여 동적 지정 원칙 동일
- Mapping Rule: ZUGMSNM → sendBidMessage() 또는 callOutbound(EAI연계). XZUGMSNM-IN-REMPNO(수신직원번호) → BID 메시지의 단말사번 또는 EAI 파라미터. XZUGMSNM-IN-TITLE+BODY(제목+본문) → BID 메시지 전문 본문. XZUGMSNM-IN-URGENTYN(긴급여부) → BID 메시지 타입(팝업/알림). 수신인1명 제한 → BID 단건 또는 다건전송(3.10.4)

---

### [유틸리티 6.2.12] - ASCII, EBCDIC 코드변환 유틸리티 (ZUGCDCV)

- z-KESA: ZUGCDCV
- n-KESA: Java Charset 변환 (IBM1364, EUC-KR, UTF-8) + SO/SI 처리 공통 유틸 / 한글 전반자 변환 유틸
- z-KESA Detail: #DYCALL 호출. 카피북: XZUGCDCV. ASCII↔EBCDIC, 전자↔전반자 혼용변환. 최대 4000byte 입력/8000byte 출력. 코드형태(X4): EM(EBCDIC MIXED/IBM1364), ES(EBCDIC Single/KSC5601), ED(EBCDIC전자+SO/SI), EG(EBCDIC전자-SO/SI), AM(ASCII MIXED/KSC5700), AD(ASCII전자). 변환기능(X4): Source코드(2)+Target코드(2) (예: EMAM=EBCDIC MIXED→ASCII MIXED). SO/SI처리옵션(X1): 기본/D/B/S. 길이유지옵션(X1): 기본/K. 입출력길이(9(4)). ZUGDAPC 대비 기능 확장. 온라인/배치 사용. 참고: ZUGDAPC 요청코드와 ZUGCDCV 매핑(SM→AMEM, DM→EDEM 등)
- n-KESA Detail: Java Charset 기반 인코딩 변환으로 대체. EMAM(EBCDIC Mixed→ASCII Mixed): new String(ebcdicBytes, "x-IBM1364").getBytes("EUC-KR") 또는 각 문자셋간 변환. SO/SI 처리는 byte 배열 직접 조작 또는 공통팀 제공 유틸. 길이 산출(LENG): String.length() 또는 byte배열.length. 최대길이 초과시 substring() 처리
- Mapping Rule: ZUGCDCV CALL → Java Charset 변환 로직으로 대체. 코드변환기능(FLAG-CD) 별 Java 대응: EMAM → new String(bytes, "x-IBM1364")/str.getBytes("EUC-KR"). AMEM → new String(bytes, "EUC-KR")/str.getBytes("x-IBM1364"). ESED → EUC-KR→EBCDIC전자 변환. LENG(길이계산) → str.getBytes(charset).length. SO/SI 옵션 처리는 공통팀 제공 유틸 또는 byte 배열 후처리로 구현. XZUGCDCV 카피북의 IN/OT 필드 → Java 메소드 파라미터로 대체

---

### [유틸리티 - ZUGRSTH] - 내부표준관련조회 모듈 (ZUGRSTH)

- z-KESA: ZUGRSTH
- n-KESA: CommonArea에서 직접 조회 (ca.getBoCom() 등) / getCommonArea(onlineCtx).getBiCom() / 프레임워크 거래프로파일 조회 getTxProfileValue()
- z-KESA Detail: #DYCALL ZUGRSTH YCCOMMON-CA XZUGRSTH-CA. 내부표준전문에 SETTING된 대외기관코드 등 조회. 카피북: XZUGRSTH. 입력: XZUGRSTH-IN-FINM(X21, 요청필드명, 예:"OSID-INSTI-CD"). 출력: XZUGRSTH-OT-LEN(9(2)), XZUGRSTH-OT-DATA(X40). 리턴코드: 00=정상, 02=초기화/미세팅, 98/99=시스템오류. Section 3.16.3에서 상세 기술
- n-KESA Detail: n-KESA에서는 CommonArea 객체를 통해 직접 접근. CommonArea ca = getCommonArea(onlineCtx). 대외기관코드: ca.getBiCom().getInstCd() 등 해당 필드 직접 조회. 거래프로파일 조회: String val = getTxProfileValue("profileKey", onlineCtx). IOnlineContext의 각 CommonArea 필드를 직접 getter로 접근
- Mapping Rule: ZUGRSTH의 FINM(필드명)별로 n-KESA CommonArea의 해당 getter 메소드로 매핑. "OSID-INSTI-CD" → ca.getBiCom().getOsdIdInstiCd() 등 필드명 변환. XZUGRSTH-OT-DATA → getter 반환값(String). 리턴코드 체크 → null 체크로 변환. CommonArea 필드 목록은 Appendix 1 "공통정보 영역(COMMON AREA) 항목" 참조

---

## 3. 공통 영역 및 인터페이스 매핑

---

### [공통영역] - YCCOMMON-CA (Common Area)

- z-KESA: YCCOMMON-CA (COPY YCCOMMON)
- n-KESA: IOnlineContext onlineCtx / CommonArea ca = getCommonArea(onlineCtx)
- z-KESA Detail: LINKAGE SECTION의 첫 번째 필수 파라미터. 모든 프로그램이 공유하는 공통 인터페이스 영역. #DYCALL 시 첫 번째 파라미터로 반드시 전달. JICOM(전행공통), BICOM(업무입력공통), BOCOM(업무출력공통), SICOM(시스템공통) 등으로 구성. 에러코드, 상태코드, 거래정보 등 포함
- n-KESA Detail: IOnlineContext: PM 최초 호출시 생성~거래종료까지 유지. getCommonArea(onlineCtx)로 CommonArea 객체 획득. CommonArea 내부: SICOM, BICOM, BOCOM(프레임워크 생성), JICOM 및 도메인별 공통영역(선처리에서 생성). 3.7 IOnlineContext 상세 참조
- Mapping Rule: YCCOMMON-CA → IOnlineContext onlineCtx (PM/FM/DM 파라미터). YCCOMMON 내 각 필드 → ca.getBiCom().xxx(), ca.getBocom().xxx() 등 getter로 접근. 모든 메소드 시그니처에서 IOnlineContext onlineCtx 필수 파라미터로 통일

---

### [공통영역] - 프로그램간 인터페이스 카피북 (X+프로그램명-CA)

- z-KESA: X+프로그램명-CA (예: XDLA0110-CA, XPFA0201-CA)
- n-KESA: IDataSet requestData / IRecordSet / IRecord
- z-KESA Detail: LINKAGE SECTION에 선언. #DYCALL의 두 번째 이후 파라미터. RETURN 영역: X-R-STAT(X2), X-R-LINE(9(6)), X-R-ERRCD(X8), X-R-TREAT-CD(X5), X-R-SQL-CD. IN 영역: 입력 필드. OUT 영역: 출력 필드. 카피북명: X+(프로그램명2-7자리)로 저장
- n-KESA Detail: IDataSet: Map 형태의 입출력 데이터 컨테이너. 단건 결과: IRecord. 다건 결과: IRecordSet. PM 입출력은 고정길이 구조(IO 설계 기반). FM/DM은 IDataSet 자유형식. requestData.get("fieldName"), requestData.put("fieldName", value)
- Mapping Rule: X카피북-IN 필드 → requestData.put("fieldName", value) 또는 IDataSet 생성. X카피북-OUT 필드 → IDataSet 반환 후 responseData.get("fieldName"). X카피북-RETURN 영역(R-STAT, R-ERRCD 등) → BusinessException/DataException으로 대체. 카피북명에서 Java 클래스 불필요(IDataSet 동적 처리)

---

### [공통영역] - SQL 관련 공통 (YCDBIOCA, YCDBSQLA)

- z-KESA: COPY YCDBIOCA (DBIO 인터페이스), COPY YCDBSQLA (SQLIO 인터페이스)
- n-KESA: XSQL 파일 (DU명.xsql) + DataUnit/DBIO Unit 클래스
- z-KESA Detail: YCDBIOCA: DBIO 공통 파라미터(DBIO-SQLCODE, COND-DBIO-OK, COND-DBIO-MRNF 등). YCDBSQLA: SQLIO 공통 파라미터(COND-DBSQL-OK 등). 각 DBIO/SQLIO 프로그램 호출 전 COPY 선언 필수
- n-KESA Detail: XSQL: DU클래스명.xsql 파일에 SQL 쿼리 정의. DU/DBIO Unit이 XSQL을 실행. DataException: DB 오류 처리. SQLCODE 조회: DataException.getSqlCode() 또는 SQLExceptionUtils 사용. INSERT 중복 에러: DataException catch 후 getSqlCode() 확인. 3.6.5 DataException 참조
- Mapping Rule: YCDBIOCA/YCDBSQLA COPY 선언 제거. COND-DBIO-OK/COND-DBSQL-OK 체크 → null/empty 체크 또는 DataException catch. DBIO-SQLCODE → DataException.getSqlCode(). 초기화(INITIALIZE YCDBIOCA) → 불필요(Java 자동 초기화)

---

## 4. 배치 관련 추가 매핑

---

### [배치] - 배치 초기화 및 실행정보 관리

- z-KESA: Framework Batch 초기화 매크로 및 실행정보 관리 루틴 (BATCH MAIN PGM의 INITIALIZATION-RTN)
- n-KESA: BU(BatchUnit) 클래스의 execute() 메소드 / BatchStep 클래스의 handleRecord() / @BatchStepParameter
- z-KESA Detail: GOBACK 문은 BATCH MAIN에서만 사용. #ERROR 발행시 배치는 종료하지 않고 계속 처리. #OKEXIT으로 종료처리 필요. Batch 실행정보(시작/종료시간, 처리건수 등) 관리는 프레임워크 제공 기능 활용
- n-KESA Detail: BU는 AbstractBatchUnit 상속. execute()에서 배치 로직 구현. 중간 Commit: AutoCommitRecordHandler 사용(3.5.13). 배치 스탭의 stopImmediately()로 조기 종료. 배치 실행정보 관리는 5.7절 참조
- Mapping Rule: BATCH MAIN PGM의 S1000-INIT → BU.execute() 초반. GOBACK → BU 메소드 정상 return. #ERROR → BusinessException throw 또는 catch 후 log.error + continue 처리(배치 계속처리 여부 결정). 배치 실행정보는 BatchContext 객체로 관리

---

### [배치] - 배치에서 DBIO 사용

- z-KESA: Framework Batch에서 #DYDBIO 사용 (온라인 DBIO 동일)
- n-KESA: DBIO Unit(DBIO_+테이블명).insert/update/delete() / DataUnit의 dbSelect() / RecordHandler 패턴
- z-KESA Detail: Batch에서 CUD: DBIO 사용 필수(#DYDBIO). Batch에서 READ-ONLY: 직접 SQL 사용 가능. 동일 어플리케이션내 테이블만 CUD 가능. 타 어플리케이션 CUD는 해당팀 DC/IC 모듈 호출
- n-KESA Detail: 배치 DBM 메소드: dbInsert(stmtName, param, session), dbUpdate(stmtName, param, session), dbDelete(stmtName, param, session). 대량 처리: dbSelect()+RecordHandler, AutoCommitRecordHandler. Array 처리(addBatch): 3.5.9.2 참조. 타 DB 사용: 3.5.15 참조
- Mapping Rule: 배치 #DYDBIO INSERT/UPDATE/DELETE → DBIO Unit DBM 메소드. 배치 READ-ONLY SELECT → DataUnit DM dbSelect() + RecordHandler. 중간 Commit → AutoCommitRecordHandler의 commitInterval 설정. DBSession 파라미터로 DB 세션 분리 가능

---

## 5. 요약 대응 테이블

| z-KESA 매크로/유틸 | 기능 | n-KESA Java API/패턴 |
|---|---|---|
| #ERROR | 에러처리/종료 | throw new BusinessException(errorCode, processCode) |
| #MULERR START~END | 멀티에러 누적 | addBusinessException(errorCode, processCode, onlineCtx) |
| #CSTMSG | 맞춤메시지 | BusinessException 생성자 3번째 파라미터 customMsg |
| #ERAFPG | 후처리 프로그램 요청 | 선후처리 FM(FU 클래스) + 프레임워크 관리콘솔 등록 |
| #TRMMSG | COMMIT후 에러메시지 | ReturnStatus 패턴 / 응답DataSet에 에러정보 수동 세팅 |
| #OKEXIT | 정상종료 | 메소드 정상 return (IDataSet 반환) |
| #SCRENO | 출력화면번호 지정 | setStndScrenNo(screenNo) / 응답전문 헤더 화면번호 세팅 |
| #BOFMID | 출력 폼 ID SET | addOutFormInfo(formId, formType, copies, ..., onlineCtx) |
| #GETOUT | 출력메모리 할당 | PM의 IDataSet responseData (출력DataSet 자동 관리) |
| #DYCALL | Dynamic 프로그램 호출 | callSharedMethod() / callServiceByRequired() / 직접 메소드 호출 |
| #STCALL | Static 프로그램 호출 | 직접 Java 메소드 호출 (#DYCALL과 동일) |
| #DYDBIO | DBIO 호출 | DBIO Unit DBM: dbInsert/select/update/delete() |
| #DYSQLA | SQLIO SELECT | DataUnit DM: dbSelect() / dbSelectSingle() / dbSelectPage() |
| #GETINP | 입력편집용 영역확보 | callServiceByRequired() 전 requestData IDataSet 직접 구성 |
| #GETNCS | NCS 채번 | DB 시퀀스(NEXTVAL) / 공통팀 채번 FM |
| #JCLSRT | JCL 실행(미사용) | worKB 연계(3.14) 또는 배치 트리거 서비스 |
| #USRLOG | 사용자 로그 출력 | log.debug() / log.info() (if(isDebugEnabled()) 구문 필수) |
| #DSCNTR | 중단거래 요청 | setDscnTranInfo(dscnTranDstcd, nextKey, onlineCtx) |
| #SYSLOG | 운영로그 출력 | log.info() / log.error() |
| #FMDUMP | Format Dump | log.debug("{0}", dataSet) |
| #CRYPTO | 보안모듈(암호화) | KBCryptoUtils.encryptText() / encryptBytes() (scpDB) |
| #SECCVT | 보안모듈(전문암호화) | KBCryptoUtils 전문암호화 메소드 (scpHost) |
| #LOGCHK | 후처리 LOG CHECK | 선후처리 FM에서 onlineCtx.getException() 조회 |
| #END | 매크로 종료 | (Java {} 블록으로 자동 대응, 별도 코드 불필요) |
| ZUDAV01 | BIT↔BYTE 변환 | Integer.parseInt(str,2) / Integer.toBinaryString() |
| ZUDAV02 | 숫자→한글/영문 변환 | 공통팀 제공 변환 유틸 또는 ICU4J RuleBasedNumberFormat |
| ZUDAV03 | ASCII↔EBCDIC 변환 | Charset.forName("IBM500") / new String(bytes,"Cp500") |
| ZUGDAPC | ASCII/EBCDIC/전반자 변환 | ZUGCDCV 대체 / Java Charset(x-IBM1364, EUC-KR) |
| ZUDAA04 | IBM2Byte↔KSC5601 변환 | Charset.forName("x-IBM1364") ↔ "EUC-KR" |
| ZUDAV05 | ASCII↔UNICODE 변환 | StandardCharsets.US_ASCII / Java String 자체 Unicode |
| ZUDAV06 | DEC→HEX 변환 | Hex.encodeHexString() / Integer.toHexString() |
| ZSGTIME | TIMESTAMP 제공 | LocalDateTime.now() + DateTimeFormatter |
| ZBDAV13 | Batch TIME WAIT | Thread.sleep(waitUnit * 10L) (1/100초→밀리초 변환) |
| ZUDAV20 | HEX↔CHAR 변환 | Hex.encodeHexString() / Hex.decodeHex() |
| ZUGMSNM | 메신저 전송요청 | sendBidMessage() / callOutbound(EAI연계) |
| ZUGCDCV | ASCII/EBCDIC/전반자 변환 | Java Charset(x-IBM1364, EUC-KR) + SO/SI 처리 공통 유틸 |
| ZUGRSTH | 내부표준관련조회 | getCommonArea(onlineCtx).getBiCom().xxx() getter 직접 접근 |
| YCCOMMON-CA | 공통 파라미터 영역 | IOnlineContext onlineCtx / CommonArea ca |
| X+프로그램명-CA | 인터페이스 카피북 | IDataSet requestData / IDataSet responseData |
| YCDBIOCA/YCDBSQLA | DBIO/SQLIO 공통파라미터 | DataException / XSQL 파일 + DU/DBIO Unit |

---

**완료: z-KESA Section 6.1 매크로 24종 (6.1.1~6.1.24) 및 Section 6.2 유틸리티 12종 (6.2.1~6.2.12) + ZUGRSTH 유틸리티 + 공통영역/인터페이스 + 명명규칙 전체 매핑 완료.**