# 06. EAI 연계 & V3표준전문 매핑

---

## z-KESA (COBOL) → n-KESA (Java) EAI Integration & V3 Standard Telegram Processing: Complete Framework Mapping

---

### [EAI Overview] - EAI 연계 기본 개념 및 Outbound 분류

- z-KESA: 시스템 인터페이스 (Section 3.14)
- n-KESA: EAI 연계 / Outbound (Section 3.9)
- z-KESA Detail: 메인프레임 업무에서 내/외부 시스템으로 EAI를 경유하여 전문을 송신. 전송요청모듈 ZMFFIFS 호출이 기본 패턴. 원칙: EAI 경유 (카드승인 TANDEM 제외). 연계처리는 Async 형태를 기준으로 함. 요청/응답 UOW 분리 필수.
- n-KESA Detail: Outbound = EAI/MCI 등을 거래 실행 중에 호출하는 것. 요청 Outbound(대외기관 조회전문 송신)와 응답 Outbound(비동기 응답 전송)로 구분. 응답 여부에 따라 `callOutbound`(동기, 응답 대기) vs `sendOutbound`(비동기, 응답 안 받음).
- Mapping Rule: z-KESA의 ZMFFIFS 호출 패턴 전체를 n-KESA의 callOutbound/sendOutbound 호출 패턴으로 전환. 전송구분코드(IR/SAF)는 OutboundHeader의 isIR 파라미터로 대응.

---

### [EAI] - 인터페이스 유형: IR 방식

- z-KESA: IR(Interactive) 방식 / XZMFFIFS-TMS-DSCD = '2'(IR DUMMY SEND) 또는 '3'(IR TIME DELAY)
- n-KESA: IR 방식 sendOutbound; `OutboundHeader eaiHeader = new OutboundHeader(onlineCtx, true);`
- z-KESA Detail: 전송구분코드 '2'=IR(DUMMY SEND): 실시간 처리, 단말 대기, 상대 응답 결과에 따라 다음 프로세스 진행. 공동망 등 대다수 대외거래에 사용. 전문요청과 응답 전문을 프레임워크 연동거래 스케쥴링으로 처리. 복원영역 사용 가능. '3'=IR(TIME DELAY): 자원 LOCK 유발로 온라인 영향 우려, 제한적 허용.
- n-KESA Detail: IR 방식: nKESA 온라인 거래에서 sendOutbound 한 번 호출 후 한 번 응답 거래 수신. GUID 고정부(33자리) 유지, 경로번호만 +10 증가. EAI 전송 후 MCI로 DUMMY 리턴하여 단말 계속 응답 대기(단말대기요구여부). `OutboundHeader(onlineCtx, true)` 로 IR 설정. 비동기 IR 방식 하나의 거래에서 sendOutbound 한 번만 가능.
- Mapping Rule: XZMFFIFS-TMS-DSCD = '2' → `new OutboundHeader(onlineCtx, true)` + `sendOutboundNow()` 또는 `sendOutboundAfterCommit()`. XZMFFIFS-TMS-DSCD = '3'(TIME DELAY)는 callOutbound(동기)로 대응.

---

### [EAI] - 인터페이스 유형: SAF 방식

- z-KESA: SAF(Stored And Forward) 방식 / XZMFFIFS-TMS-DSCD = '1'(SAF LU0), '5'(SAF 통지 대량처리), '7'(강제메시지 SAF)
- n-KESA: SAF 방식 sendOutbound; `OutboundHeader eaiHeader = new OutboundHeader(onlineCtx, false);`
- z-KESA Detail: 데이터 축적 후 전송. 응답결과와 상관없이 본 거래 처리 완료 가능. 타행환 입금업무에서 사용. 센터일괄처리(C/C)에서는 SAF 형태만 가능. 대량 전송시 EAI 및 기관 시스템 부하 감안하여 유량제어 고려. '5': 대량처리 SAF(자동전송 시작/종료시각 조립: XZMFFIFS-START-HMS, XZMFFIFS-END-HMS).
- n-KESA Detail: SAF 방식: nKESA 온라인 거래에서 여러 번 송신하고 응답 여러 번 수신 가능. 최대 999건. EAI 송신마다 GUID 고정부 재채번, 원거래 GUID에 최초 nKESA 온라인 거래 GUID를 set. EAI 송신 후 단말로 일반 응답 내려줘 단말 락 해제. `OutboundHeader(onlineCtx, false)` 로 SAF 설정.
- Mapping Rule: XZMFFIFS-TMS-DSCD = '1'/'5'/'7' → `new OutboundHeader(onlineCtx, false)` + `sendOutboundAfterCommit()`. 배치에서 EAI 호출: 공유 FM 사용 + 건수 제한 + 건건 sleep 속도제한.

---

### [EAI] - XIO 설계 (전문 레이아웃 파일)

- z-KESA: COPY BOOK (copybook) 기반 전문 레이아웃 정의 (e.g., COPY NELC2001, COPY XZMFFIFS)
- n-KESA: XIO 파일 (XML 형식, 컴포넌트 하위 XIO 노드에서 생성)
- z-KESA Detail: 전문 개별부 레이아웃은 COBOL COPY BOOK으로 선언. `COPY XZMFFIFS` (전송요청모듈 인터페이스), `COPY NELC2001` (EAI 입력전문 개별부), `COPY YCSFIERM` (오류전문 조립 프로그램 인터페이스), `COPY XZUGRSTH` (대외기관코드 조회 인터페이스). 입출력 구분이 COBOL 구조체 재정의(REDEFINES)로 처리됨.
- n-KESA Detail: XIO = EAI 전송용/MCI BID/PUSH 전문 변환용 레이아웃 정보 저장 파일(XML). 명명규칙: `XIO_` + EAI서비스코드 또는 MCI거래코드 또는 전문IO ID. 복수 전문시: `XIO_서비스코드_RES1`, `XIO_서비스코드_RES2`. 생성: 컴포넌트 하위 XIO 노드 우클릭 > XIO(아웃바운드) IO 생성. 타 컴포넌트의 XIO 사용 불가. PM 메소드 IO(UIO) 설계와 동일 방법으로 항목 작성. 입출력 구분 없음(필요에 따라 1개 또는 2개 XIO 파일로 구성).
- Mapping Rule: z-KESA의 각 COPY BOOK → n-KESA의 XIO 파일로 1:1 또는 N:1로 전환. REQ/RES 방향성은 XIO 파일 분리 또는 isInData 파라미터로 처리.

---

### [EAI] - EAI 전문 XIO 설계 (4가지 전문 유형)

- z-KESA: 전문 전송요청 모듈(ZMFFIFS)의 전문 파라미터(XZMFFIFS-S-DATA, XZMFFIFS-TIMER-DATA) - 단일 전문 구조
- n-KESA: MMI 등록 4가지 타입 XIO 설계 (REQ1/REQ2/RES1/RES2)
- z-KESA Detail: 전문 전송요청 파라미터 구조: ①전송요청구분(XZMFFIFS-TMS-DSCD) ②전송대상시스템정보(MDI-KDCD, OTP-SVR-LU-NO, WTIN-EXTNL-DSTCD, OSID-INSTI-CD, SVR-TRN-NO 등) ③전송데이터(XZMFFIFS-SMSG-LN, XZMFFIFS-S-DATA, 최대 29,000 byte) ④타이머관리정보 ⑤기타정보. EAI 전문변환 규칙은 EAI 시스템에 별도 등록.
- n-KESA Detail: MMI(전문관리통합시스템) 등록 후 XIO 작성. 연계 타입 4종: REQ1(소스→EAI 요청전문, 소스가 nKESA면 XIO 생성), REQ2(EAI→타겟 전달전문, 타겟이 nKESA면 PM Input에 정의), RES1(EAI→타겟 응답전문, 타겟이 nKESA면 PM Output에 정의), RES2(소스→EAI 응답전문, 소스가 nKESA면 Sync=XIO 생성 / Async=PM Input에 정의). IO Assist의 전문IO 기능으로 MMI 시스템송수신정의서로부터 XIO에 적용. EAI 전문은 JSON 기본 처리(XML 필요시 프레임워크 설정으로 구분).
- Mapping Rule: z-KESA 전문 개별부(XZMFFIFS-S-DATA에 들어가는 데이터) → n-KESA REQ1(송신전문) XIO. EAI 응답전문 개별부 → RES2 XIO. COBOL COPYBOOK 항목을 XIO 항목으로 1:1 변환.

---

### [EAI] - EAITransformer (DataSet ↔ byte[] 전문 변환)

- z-KESA: 전문 조립 COBOL 코드 (MOVE 명령으로 필드별 직접 조립); XZMFFIFS-S-DATA 에 직접 데이터 MOVE
- n-KESA: `EAITransformer` 클래스 (com.kbstar.sqc.fwexten.eai 패키지)
- z-KESA Detail: 전문 조립 예시: `MOVE WK-TELGM-LEN TO XZMFFIFS-SMSG-LN`, `MOVE WK-SEND-MSG(1:WK-TELGM-LEN) TO XZMFFIFS-S-DATA`. 내부표준전문 헤더+공통부+개별부를 전송요청모듈이 합산하여 EAI 전송 전문 생성. 코드변환은 EAI 시스템 등록 변환규칙을 따름.
- n-KESA Detail: EAITransformer 메소드들:
  - `ByteArrayWrap convertToEAIMessage(KBMessage kbm, IDataSet dataset, String xioId, boolean isInData, IOnlineContext onlineCtx)`: EAI 송신 메시지로 변환. isInData: "InData" 또는 "OutData" 생성 지시자.
  - `ByteArrayWrap convertToEAIMessage(KBMessage kbm, IDataSet dataset, String xioId, String encoding, boolean isInData, IOnlineContext onlineCtx)`: encoding 별도 선택 가능("euc-kr" 또는 "UTF-8").
  - `IDataSet convertEAIIndividualToDataSet(IOutboundResponse eaiRecv, String xioId, IOnlineContext onlineCtx)`: 동기 방식 EAI 호출 후 리턴받은 전문 중 개별부(Individual/OutData)를 IDataSet으로 변환.
  - Flat Data 레이아웃용: `ByteArrayWrap transformByteArrayForXio(String xioId, IDataSet dataset, IOnlineContext onlineCtx)`, encoding 인자 추가 버전도 존재.
  - EAITransformer 호출 시점에 이미 byte[] 최종 전문으로 변환됨 → `convertToEAIMessage` 호출 전에 모든 KBMessage 값 set 완료 필수.
- Mapping Rule: z-KESA의 MOVE 명령 기반 전문 조립 코드 → n-KESA의 `EAITransformer.convertToEAIMessage(kbmsg, dataset, xioId, true, onlineCtx)` 한 줄로 대체. 응답 전문 파싱: z-KESA의 MOVE 명령 역방향 → `EAITransformer.convertEAIIndividualToDataSet(eaiRecv, xioId, onlineCtx)`.

---

### [EAI] - OutboundHeader (헤더 객체 복제 및 타입 정의)

- z-KESA: YCCOMMON-CA (공통정보영역 선언) + XZMFFIFS-CA (전송요청 파라미터 조립); 내부표준전문 헤더/공통부는 ZMFFIFS 모듈이 자동 조립
- n-KESA: `OutboundHeader` 클래스
- z-KESA Detail: `COPY YCCOMMON` 으로 YCCOMMON-CA 선언. XZMFFIFS 파라미터에 전송방식, 대상 시스템 정보(MDI-KDCD, OTP-SVR-LU-NO), 내외부구분코드(WTIN-EXTNL-DSTCD), 대외기관코드(OSID-INSTI-CD), 서버거래코드(SVR-TRN-NO), 원거래복원여부(ORGTRN-RET-YN), GUID(TRN-LOG-NO), 전문전송일련번호(MSG-SERNO) 직접 조립. #DYCALL ZMFFIFS로 호출.
- n-KESA Detail: `OutboundHeader eaiHeader = new OutboundHeader(onlineCtx)`: 내부적으로 헤더 객체(KBMessage)가 복제됨. 생성자 오버로드: `OutboundHeader(onlineCtx, true)` (IR), `OutboundHeader(onlineCtx, false)` (SAF). `eaiHeader.setSync(true)`: 동기 전송 설정(기본값 false=비동기). `eaiHeader.getKBMessage()`: 복제된 헤더 객체 리턴 → set해도 원 거래 헤더 객체 값 불변. 동기 호출시 GUID 재채번 필요하면 `createNewGuidAndSet()` 호출.
- Mapping Rule: z-KESA의 XZMFFIFS 파라미터 조립 블록 전체 → `new OutboundHeader(onlineCtx)` + `eaiHeader.setSync(true/false)`. 서버전송구분코드('2'=IR) → `setSync(false)` + `new OutboundHeader(onlineCtx, true)`. 원거래복원여부(ORGTRN-RET-YN='1') → 연동거래 설계 시 KBMessage 헤더 항목으로 매핑.

---

### [EAI] - 표준전문 헤더 (KBMessage 클래스)

- z-KESA: 내부표준전문 헤더부/공통부 (COPY YCSTNDHD 등); BICOM 영역에서 헤더 값 참조
- n-KESA: `KBMessage` 클래스 (com.kbstar.sqc.fwexten.kbmessage)
- z-KESA Detail: 일반 Inbound 거래에서는 YCCOMMON-CA(공통정보영역)의 BICOM, SICOM 등 영역에서 헤더값 참조. 대외개설거래 에러전문 조립 프로그램에서는 `COPY YCSTNDHD`로 내부표준전문 헤더 및 공통부 직접 참조. 헤더부: GUID, CICS트랜코드, 전문요청구분코드 등. 공통부: 거래정보(TranInfo), 채널정보(ChnlInfo), 에러정보(ErrInfo) 등.
- n-KESA Detail: KBMessage = 내부표준 전문의 Java 클래스 매핑체. import: `com.kbstar.sqc.fwexten.kbmessage.KBMessage`, `HeaderType`, `EntrBnkBzwkCmnType`. 접근법: `KBMessage kbm = eaiHeader.getKBMessage()`. EAI 송수신 처리시 직접 get/set. 일반 Inbound 거래에서는 CommonArea에서 헤더값 조회. 구조:
  - `kbm.getHeaderType()`: HeaderType 객체 (헤더부)
  - `kbm.getCommonType()`: CommonType 객체 (공통부)
    - `getCommonType().getTranInfoType()`: 거래정보
    - `getCommonType().getChnlInfoType()`: 채널정보
    - `getCommonType().getInMsgInfoType()`: 입력메시지정보
    - `getCommonType().getAthorInfoType()`: 승인정보
    - `getCommonType().getOutMsgInfoType()`: 출력메시지정보
    - `getCommonType().getErrInfoType()`: 에러정보
    - `getCommonType().getSupplInfoType()`: 부가정보
    - `getCommonType().getEntrBnkBzwkCmnType()`: 기업은행업무공통
  - `kbm.getErrMessage()`: ErrMessage 객체
- Mapping Rule: z-KESA BICOM/SICOM 접근 → `getCommonArea(onlineCtx).getBiCom().getXxx()`. EAI 전문 헤더 직접 접근(YCSTNDHD) → `eaiHeader.getKBMessage().getHeaderType().getXxx()`.

---

### [EAI] - EAI 거래 표준전문 헤더 주요 필드 매핑

- z-KESA: 내부표준전문 헤더/공통부 항목 (COPY YCSTNDHD 항목들)
- n-KESA: KBMessage setter/getter 메소드
- z-KESA Detail: ZMFFIFS 파라미터 항목들 (XZMFFIFS-XXX) 및 내부표준전문 헤더 항목들로 직접 조립.
- n-KESA Detail: 주요 EAI 전문 헤더 설정 항목별 메소드:

| 항목 | z-KESA 필드 | n-KESA 메소드 | 설명 |
|------|-------------|---------------|------|
| CICS트랜잭션코드 | BICOM-CICS-TRAN-CD | `kbmsg.getHeaderType().setStndCicsTrncd()` | M/F 호출시: "앞2자리+E$" (예: "XXE$", "FAE$") |
| 전문요청구분코드 | - | `kbmsg.getHeaderType().setStndTelgmDmndDstcd()` | "S"=요청, "R"=응답 |
| GUID번호(36자리) | BICOM-GU-ID-NO | `headerType.getStndGuIdNo()` | 조회만 가능 |
| 내부표준전문길이 | - | `headerType.getStndIntnlSTelgmLen()` | |
| 거래입력년월일 | - | `headerType.getStndTranBaseYmd()` | |
| 전문유효년월일 | - | `headerType.getStndTelgmValdYmd()` | |
| 전문버전번호 | - | `headerType.getStndTelgmVsnno()` | |
| 총괄타임아웃임계치 | XZMFFIFS-GNRZ-TOUT-CRTC-NMVL | `headerType.getStndGnrzToutCrtcNmvl()` | 999=감시제외 |
| SYSID명 | - | `headerType.getStndSysidName()` | |
| 처리대상CICS트랜코드 | - | `headerType.getStndPrcssTCicsTrncd()` / `setStndPrcssTCicsTrncd()` | M/F Async: 기존 공백→CICS 4자리 |
| 전문수신거래코드 | XZMFFIFS-SVR-TRN-NO | `tranInfoType.setStndTelgmRecvTranCd()` | EAI 외부전문: 전문종별+업무구분코드 |
| 처리결과전문수신거래코드 | XZMFFIFS-PRCSS-RTD-TRAN-CD | `tranInfoType.setStndPrcssRtdTranCd()` | 응답거래코드. Sync거래: CICS4자리+어플3자리 필수 |
| 화면번호 | BICOM-SCREN-NO | `tranInfoType.setStndScrenNo()` / `getStndScrenNo()` | |
| 대외기관코드 | XZMFFIFS-OSID-INSTI-CD | `tranInfoType.setStndOsidInstiCd()` / `getStndOsidInstiCd()` | 12byte |
| 거래일련번호 | XZMFFIFS-MSG-SERNO | `tranInfoType.setStndTranSerno()` | |
| 인터페이스시스템구분코드 | XZMFFIFS-WTIN-EXTNL-DSTCD | `tranInfoType.setStndInoPartlDstcd()` | 1=내부, 2=대외기관, 3=금융결제원공동망, 4=인터넷망TANDEM, 9=TANDEM |
| 복합거래요청구분코드 | XZMFFIFS-CMPX-T-DMND-DSTCD | `tranInfoType.setStndCmpxTDmndDstcd()` | 'M'=복수응답, 'T'=다중전송 |
| 리바운드거래여부 | - | `tranInfoType.getStndRbndTranYn()` | |
| 원거래복원여부 | XZMFFIFS-ORGTRN-RET-YN | `tranInfoType.getStndOgtranRstrYn()` | |
| 원거래GUID번호 | XZMFFIFS-TRN-LOG-NO | `tranInfoType.getStndOgtranGuIdNo()` | |
| 중계채널구분코드 | - | `chnlInfoType.setStndRelayChnlDstcd()` | "02" 등 |
| 사용자직원번호 | BICOM-USER-EMPID | `chnlInfoType.getStndUserEmpid()` / `setStndUserEmpid()` | BID 전송시 단말사번 |
| 출력데이터유형구분코드 | - | `outMsgInfoType.setStndOutptDPtrnDstcd()` | "01"=정상, "02"=오류 |
| 에러코드 | - | `errInfoType.getStndErrcd()` | |
| 조치코드 | - | `errInfoType.getStndTreatCd()` | |
| 자동화기기현금반환구분코드 | XZMFFIFS-ATM-CSH-RETUN-DSTCD | `supplInfoType.getStndAtmCshRetunDstcd()` | 'R'=반환, 'A'=기기수납 |
| 송신EAI서비스명 | - | `supplInfoType.setStndSendEaiSvcName()` | "ABC12345" 형태의 EAI 서비스명 |
| 전송요구ID | - | `supplInfoType.setStndTrsmtRqstId()` | Time Delay 방식 전문전송시 프레임워크 고유번호 |
| 인터페이스송신거래코드 | - | `supplInfoType.getStndIntfacSendTranCd()` | |
| 취소가능여부 | XZMFFIFS-CANAV-YN | `supplInfoType.getStndCnclAbilYn()` | |
| 취소제외여부 | XZMFFIFS-CANAV-YN(기타정보) | `supplInfoType.getStndCnclEcludYn()` | '0'=자동취소처리, '1'=자동취소제외 |
| 승인완료구분코드 | BICOM-ATHOR-FNSH-DSTCD | `athorInfoType.getStndAthorFnshDstcd()` | |
| 마감후여부 | BICOM-CLSNG-AF-YN | `entrBnkBzwkCmnType.getStndClsngAfYn()` | |
| 거래중단요청여부 | - | `entrBnkBzwkCmnType.getStndTranDscnDmndYn()` | |

- Mapping Rule: z-KESA의 각 XZMFFIFS-XXX 필드 MOVE 명령 → n-KESA의 `kbmsg.getXxxType().setStndXxx(value)` 1:1 대응.

---

### [EAI] - ByteArrayWrap (byte 배열 조작 편의 클래스)

- z-KESA: COBOL 문자열 처리 (WK-SEND-MSG, MOVE WK-SEND-MSG(1:WK-TELGM-LEN) TO XZMFFIFS-S-DATA); 포인터/COMP 길이 조합
- n-KESA: `ByteArrayWrap` 클래스
- z-KESA Detail: 전문 데이터는 X(29000) 고정 길이 버퍼(XZMFFIFS-S-DATA). 실제 데이터 길이는 XZMFFIFS-SMSG-LN(9(09) COMP). 전문 참조시 부분 문자열 참조: `WK-SEND-MSG(1:WK-TELGM-LEN)`. 타이머전문 데이터도 동일 구조(XZMFFIFS-TIMER-DATA, XZMFFIFS-TIMER-LN).
- n-KESA Detail: `ByteArrayWrap` = byte[] 재사용을 위한 편의 클래스. 생성자: `ByteArrayWrap(byte[] bytes)` (전체 사용), `ByteArrayWrap(byte[] bytes, int offset, int length)` (부분 사용). API:
  - `byte[] getByteArray()`: 내부 bytes 그대로 리턴
  - `int getOffset()`: offset 리턴
  - `int getLength()`: length 리턴
  - `byte getByte(int index)`: 사용 부분 중 index 위치 값
  - `String getString(int offset, int length)`: 부분 String 변환
  - `String getString(int offset, int length, String charset)`: charset 지정 변환
  - `byte[] getByteArray(int offset, int length)`: 부분 잘라 새 byte[]에 담아 리턴 (복제본)
  - `ByteArrayWrap reuse(int offset, int length)`: 원본 bytes 재사용하며 새 ByteArrayWrap 리턴
  - `ByteArrayWrap clone()`: 사용 부분만큼 byte[] 생성 후 복제한 ByteArrayWrap 리턴
  - `ByteArrayWrap merge(ByteArrayWrap input)`: this + input 길이 합산하여 새 byte[] 생성 후 리턴
  - `String toString()`: 사용 부분 String 변환
  - `String toString(String charset)`: charset으로 String 변환
- Mapping Rule: z-KESA의 가변 길이 전문 참조 패턴(WK-SEND-MSG(offset:length)) → `ByteArrayWrap.getString(offset, length)` 또는 `reuse(offset, length)`. 전문 조립 결과 byte[]는 ByteArrayWrap으로 래핑하여 callOutbound/sendOutbound에 전달.

---

### [EAI] - 메인프레임 Async EAI 송신 (M/F 연계 패턴)

- z-KESA: ZMFFIFS 전송구분코드 '2'(IR DUMMY SEND) + CICS 트랜코드 변형 패턴
- n-KESA: 메인프레임 Async 거래패턴 (callOutbound 또는 sendOutboundNow)
- z-KESA Detail: IR(DUMMY SEND) 방식('2')으로 ZMFFIFS 호출. BICOM-CICS-TRAN-CD 에 M/F CICS 코드 4자리 설정. 메인프레임으로의 연계는 EAI를 경유하는 것이 원칙.
- n-KESA Detail: M/F Async 거래 패턴을 사용하려면 내부표준전문 항목 수정 필수:
  - `stndCicsTrncd`: 기존 'CICS 4자리' → [CICS 앞2자리 + "E$"] (예: "XXE$", "FAE$")
  - `stndPrcssTCicsTrncd`: 기존 공백 → [CICS코드 4자리] (예: "XXXX", "FA01")
  - 패턴1(동기): callOutbound(동기) 사용, 송/수신 PM 1개
  - 패턴2(비동기): sendOutboundNow() 사용, 송/수신 PM 2개
  - 예시:
    ```java
    kbmsg.getHeaderType().setStndCicsTrncd("FAE$");
    kbmsg.getHeaderType().setStndPrcssTCicsTrncd("FA01");
    ByteArrayWrap eaiSendTelgm = EAITransformer.convertToEAIMessage(kbmsg, responseData, xioId, true, onlineCtx);
    // 패턴1: IOutboundResponse eaiRecv = callOutbound(OutboundTarget.EAI1, eaiHeader, eaiSendTelgm, onlineCtx);
    // 패턴2: sendOutboundNow("EAI1", eaiHeader, xml, onlineCtx);
    ```
- Mapping Rule: z-KESA M/F 연계 전문(ZMFFIFS 호출 코드에서 SVR-TRN-NO에 M/F 거래코드 설정) → n-KESA에서 setStndCicsTrncd("xxE$") + setStndPrcssTCicsTrncd("xxxx") 패턴으로 반드시 변환.

---

### [EAI] - callOutbound (동기 EAI 송신)

- z-KESA: ZMFFIFS 전송구분코드 '3'(IR TIME DELAY) + RETURN 코드 확인 패턴; `IF XZMFFIFS-R-STAT = CO-STAT-OK`
- n-KESA: `callOutbound()` 메소드
- z-KESA Detail: `#DYCALL ZMFFIFS YCCOMMON-CA XZMFFIFS-CA` 호출. 전송구분코드 '3'(TIME DELAY)은 응답올 때 까지 TASK 자원 LOCK. 리턴코드: 00=정상, 09=입력파라미터오류, 98=후속처리오류(#ERROR처리), 99=시스템오류. 동기 방식: 단말 대기 상태에서 상대 시스템 응답 후 다음 업무 처리.
- n-KESA Detail: API 오버로드:
  - `IOutboundResponse callOutbound(IOutboundTarget kind, IOutboundHeader header, ByteArrayWrap requestData, IOnlineContext onlineCtx)`: 기본 타임아웃 적용
  - `IOutboundResponse callOutbound(IOutboundTarget kind, IOutboundHeader header, ByteArrayWrap requestData, int timeoutSeconds, IOnlineContext onlineCtx)`: Sync timeout(초단위) 지정
  - `kind` 파라미터 (EAI 종류 구분):
    - `OutboundTarget.EAI1` (또는 String "EAI1"): 내부EAI
    - `OutboundTarget.EAI2` (또는 String "EAI2"): 대외EAI
    - `OutboundTarget.EAI3` (또는 String "EAI3"): 공동망
    - `OutboundTarget.EAI4` (또는 String "EAI4"): DMZ
  - 타임아웃 초과시 Exception 발생. 동기 방식 GUID 고정부(33자리) 유지, 경로번호만 +1 증가.
  - 사용 전 `eaiHeader.setSync(true)` 필수. setSync(true) 하지 않으면 Async IR 방식으로 GUID 경로번호 +10 증가.
  - 예시:
    ```java
    OutboundHeader eaiHeader = new OutboundHeader(onlineCtx);
    eaiHeader.setSync(true);
    KBMessage kbmsg = eaiHeader.getKBMessage();
    kbmsg.getHeaderType().setStndTelgmDmndDstcd("S");
    kbmsg.getHeaderType().setStndCicsTrncd("XXE$");
    kbmsg.getHeaderType().setStndPrcssTCicsTrncd(cicsTranCd);
    kbmsg.getCommonType().getTranInfoType().setStndTelgmRecvTranCd("KFK1234567");
    kbmsg.getCommonType().getTranInfoType().setStndInoPartlDstcd("1");
    ByteArrayWrap eaiSendTelgm = EAITransformer.convertToEAIMessage(kbmsg, responseData, xioId, true, onlineCtx);
    IOutboundResponse eaiRecv = callOutbound("EAI1", eaiHeader, eaiSendTelgm, onlineCtx);
    IDataSet eaiRecvDs = EAITransformer.convertEAIIndividualToDataSet(eaiRecv, xioId, onlineCtx);
    ```
- Mapping Rule: z-KESA IR(TIME DELAY) 또는 동기 처리 → n-KESA callOutbound. 내외부구분코드(WTIN-EXTNL-DSTCD) 값 → kind 파라미터(EAI1/EAI2/EAI3/EAI4)로 매핑. z-KESA 리턴코드 체크(`IF XZMFFIFS-R-STAT = CO-STAT-OK`) → `IOutboundResponse` 객체의 에러 여부 판단으로 전환.

---

### [EAI] - IOutboundResponse (동기 EAI 호출 응답 객체)

- z-KESA: XZMFFIFS-R-STAT (리턴코드) + 응답 전문 데이터 (포인터/ADDRESS OF 패턴)
- n-KESA: `IOutboundResponse` 인터페이스
- z-KESA Detail: ZMFFIFS 호출 후 리턴코드 확인: `IF XZMFFIFS-R-STAT = CO-STAT-OK`. 응답 전문 개별부는 별도 COPY BOOK으로 재정의하여 접근.
- n-KESA Detail: `IOutboundResponse` = 동기 호출 후 전문수신 결과 담는 객체. 헤더(KBMessage)와 개별부(IDataSet)로 구성. 접근:
  - `KBMessage kbm = (KBMessage) eaiRecv.getHeader()`: 응답 전문 헤더
  - `IDataSet eaiRecvDs = EAITransformer.convertEAIIndividualToDataSet(eaiRecv, xioId, onlineCtx)`: 응답 전문 개별부를 IDataSet으로
  - `List<OutFormType> outFormsList = getOutFormsInfo(eaiRecv)`: 멀티폼 출력 결과 확인
- Mapping Rule: z-KESA XZMFFIFS-R-STAT 체크 코드 → n-KESA `IOutboundResponse`의 에러 여부 판단 코드로 전환.

---

### [EAI] - 에러 여부 판단 (동기 EAI 응답)

- z-KESA: `IF XZMFFIFS-R-STAT = CO-STAT-OK` / `#ERROR CO-B4000118 CO-UKJN0008 CO-STAT-ERROR`
- n-KESA: 출력데이터유형구분코드 "02" 체크 + `ErrMessage` 객체
- z-KESA Detail: 리턴코드 기반 정상/오류 판단. 00=정상, 09=파라미터오류, 98/99=시스템오류(#ERROR 처리). 상대시스템 정상/오류처리는 상대시스템과 협의.
- n-KESA Detail: 수신한 EAI 전문 에러 여부: "전문헤더 > 출력메시지정보 > 출력데이터유형구분코드"의 "02" 여부:
  ```java
  String outptDPtrnDstCd = kbm.getCommonType().getOutMsgInfoType().getStndOutptDPtrnDstcd();
  boolean isError = "02".equals(outptDPtrnDstCd) || "2".equals(outptDPtrnDstCd);
  ```
  에러시 에러코드/조치코드 조회:
  ```java
  String errCd   = kbm.getCommonType().getErrInfoType().getStndErrcd();
  String treatCd = kbm.getCommonType().getErrInfoType().getStndTreatCd();
  ```
  에러 상세 (`ErrMessage` 객체):
  ```java
  ErrMessage errmsg = kbm.getErrMessage();
  errmsg.getErrmsgErrcd();              // 에러코드
  errmsg.getErrmsgTreatCd();           // 조치코드
  errmsg.getErrmsgErrPgmzName();       // 에러프로그램명
  errmsg.getErrmsgErrSituNo();         // 에러 위치
  errmsg.getErrmsgOutptCstzMsgCtnt();  // 출력맞춤메시지 내용
  List<MultiErrMsg> multiErrMsgList = errmsg.getMultiErrMsg(); // 멀티에러
  int stpErrNoitm = errmsg.getErrmsgStpErrNoitm(); // 계층별 에러 건수(최대 4건)
  errmsg.getErrmsgStpErrTranCd();     // 계층별 에러 거래코드
  errmsg.getErrmsgStpErrcd1();        // 에러코드1 ~ 에러코드N
  ```
- Mapping Rule: z-KESA `IF XZMFFIFS-R-STAT NOT = CO-STAT-OK; #ERROR ...` → `if("02".equals(outptDPtrnDstCd)) { throw new BusinessException(errCd, treatCd, "맞춤메시지"); }`.

---

### [EAI] - 멀티폼 출력 결과 확인

- z-KESA: 복합거래요청구분코드(XZMFFIFS-CMPX-T-DMND-DSTCD = 'M') + 복수응답 전문 처리
- n-KESA: `getOutFormsInfo(eaiRecv)` → `List<OutFormType>`
- z-KESA Detail: 복합거래요청구분코드 'M': 하나의 요구 전문에 2개 이상의 응답이 올 경우 설정.
- n-KESA Detail:
  ```java
  IOutboundResponse eaiRecv = callOutbound("EAI1", eaiHeader, xml, onlineCtx);
  List<OutFormType> outFormsList = getOutFormsInfo(eaiRecv);
  for(OutFormType form : outFormsList) {
      // form에 대한 추가처리
  }
  ```
- Mapping Rule: z-KESA 복수응답(CMPX-T-DMND-DSTCD='M') 처리 → n-KESA getOutFormsInfo + OutFormType 루프 처리.

---

### [EAI] - sendOutbound (비동기 EAI 송신)

- z-KESA: ZMFFIFS 전송구분코드 '1'(SAF) 또는 '2'(IR DUMMY SEND) 호출; 응답거래 별도 구현
- n-KESA: `sendOutboundNow()` / `sendOutboundAfterCommit()`
- z-KESA Detail: IR(DUMMY SEND, '2'): 전문 전송 후 단말은 DUMMY 리턴(모래시계 대기). SAF('1'): 전문 전송 후 본 거래 완료. 응답전문 수신 거래는 별개의 거래코드로 처리. 처리결과수신전문거래코드(PRCSS-RTD-TRAN-CD) 조립 필수.
- n-KESA Detail: API:
  ```java
  void sendOutboundNow(IOutboundTarget kind, IOutboundHeader header, ByteArrayWrap requestData, IOnlineContext onlineCtx)
  // sendOutbound 메소드 호출 시점에 즉시 전송
  
  void sendOutboundAfterCommit(IOutboundTarget kind, IOutboundHeader header, ByteArrayWrap requestData, IOnlineContext onlineCtx)
  // 정상 commit 후 전송. 후처리 에러로 롤백되면 전문 전송 안됨
  ```
  비동기 전송시 `처리결과수신거래코드(응답거래코드)` 반드시 명시 필수. 타겟 거래 정상처리 시 이 거래코드의 거래가 기동되어 응답전문 수신.
  설정 예:
  ```java
  kbmsg.getCommonType().getTranInfoType().setStndPrcssRtdTranCd("BFE1234500"); // 처리결과를 수신할 거래코드
  kbmsg.getCommonType().getChnlInfoType().setStndRelayChnlDstcd("02");
  kbmsg.getCommonType().getSupplInfoType().setStndSendEaiSvcName("ABC12345");
  ```
- Mapping Rule: z-KESA IR DUMMY SEND + 단말 DUMMY 응답 → n-KESA sendOutboundNow + IR 방식(isIR=true). z-KESA SAF 전송 + 본거래 완료 → n-KESA sendOutboundAfterCommit + SAF 방식(isIR=false). PRCSS-RTD-TRAN-CD 조립 → setStndPrcssRtdTranCd() 필수.

---

### [EAI] - 비동기 응답 PM에서 원단말 응답 전문 송신

- z-KESA: 응답거래의 별도 AS/PC 프로그램에서 MCI 경유 응답 전문 송신 (내부 프레임워크 처리)
- n-KESA: `AsyncResponseHeader` + `sendAsyncResponseNow()`
- z-KESA Detail: EAI 응답거래(별개 거래코드)에서 원단말로 결과 전송. 내부표준전문 복원 처리. 연동거래 스케쥴링에 포함하여 처리.
- n-KESA Detail:
  ```java
  AsyncResponseHeader arh = new AsyncResponseHeader(onlineCtx);
  KBMessage kbmsg = arh.getKBMessage();
  // 헤더값 set
  arh.addOutFormInfo("XXX06M18000", "V1", "01", "01", "", ""); // 출력 폼데이타 설정
  sendAsyncResponseNow(arh, responseData, "EDU0432141", true, false, onlineCtx);
  ```
  생성 시 최초 원 단말 요청전문 헤더(KBMessage)가 복원되어 설정됨. API 오버로드:
  - `ByteArrayWrap sendAsyncResponseNow(AsyncResponseHeader arh, IDataSet responseData, IOnlineContext onlineCtx)`: dummyReturn=true, dummyReturnReleaseOnFail=false 기본값
  - `ByteArrayWrap sendAsyncResponseNow(AsyncResponseHeader arh, IDataSet responseData, String 거래코드, boolean dummyReturn, boolean dummyReturnReleaseOnFail, IOnlineContext onlineCtx)`: 응답전문의 전문수신거래코드 변경 가능. dummyReturn: EAI 비동기 수신거래인 경우 EAI로 개별부 없는 헤더만 전송. dummyReturnReleaseOnFail: 후처리 에러시 dummy 리턴 취소 여부.
- Mapping Rule: z-KESA 응답거래 PC 프로그램에서의 전문 조립 및 MCI 송신 → n-KESA AsyncResponseHeader + sendAsyncResponseNow 패턴으로 전환.

---

### [EAI] - 비동기 응답 PM에서 응답전문 헤더 값 조회

- z-KESA: 연동거래에서 복원된 YCCOMMON-CA를 통해 원거래 정보 참조
- n-KESA: `getEAIResponseKBMessage(onlineCtx)` (예외적으로 EAI 응답 전문 수신 거래에서만 사용)
- z-KESA Detail: 비동기 응답거래에서 원거래 내부표준전문 헤더는 EAI의 복원 기능으로 YCCOMMON-CA에 복원됨. BICOM 등으로 접근.
- n-KESA Detail: 일반 온라인 거래는 전문 헤더 값을 직접 조회 불가 → CommonArea 매핑 항목만 확인 가능. 예외적으로 EAI 응답 전문 수신 거래에서만 사용:
  ```java
  KBMessage getEAIResponseKBMessage(IOnlineContext onlineCtx)
  // EAI 응답 거래인 경우 전문 헤더 객체 리턴
  ```
  EAI 타겟 거래 에러 발생시 응답전문의 Individual 하위에 에러 상세정보 담김. 위 API로 KBMessage 획득 후 `getErrMessage()` 호출하면 ErrMessage 객체 반환.
- Mapping Rule: z-KESA 복원된 YCCOMMON-CA에서 BICOM.GU-ID-NO 등 참조 → n-KESA getEAIResponseKBMessage(onlineCtx).getHeaderType().getStndGuIdNo().

---

### [EAI] - IR 방식 / SAF 방식 구분 설정

- z-KESA: XZMFFIFS-TMS-DSCD = '1'(SAF) / '2'(IR DUMMY SEND)
- n-KESA: `new OutboundHeader(onlineCtx, isIR)`
- z-KESA Detail: 서버전송구분코드: 1=SAF(LU0), 2=IR(DUMMY SEND), 3=IR(TIME DELAY), 4=DPL(ONLY LINK), 5=SAF(통지/대량처리), 6=타이머등록, 7=강제메시지(SAF)
- n-KESA Detail: IR 방식: `OutboundHeader eaiHeader = new OutboundHeader(onlineCtx, true)`. SAF 방식: `OutboundHeader eaiHeader = new OutboundHeader(onlineCtx, false)`. IR 방식 특성: GUID 경로번호 +10 증가. IR 방식에서 sendOutbound는 한 번만 가능(두 번 이상시 에러). SAF 방식: GUID 고정부 재채번, 원거래 GUID에 최초 거래 GUID set, sendOutbound 최대 999건.
- Mapping Rule: z-KESA XZMFFIFS-TMS-DSCD 값 → n-KESA OutboundHeader 생성자 두 번째 인자로 1:1 매핑.

---

### [EAI] - 타이머 기동 (비동기 취소 처리)

- z-KESA: ZMFFIFS 파라미터 타이머관리정보 조립 (XZMFFIFS-TIMER-YN='1', XZMFFIFS-WTIME-ITV, XZMFFIFS-TIMER-PGM, XZMFFIFS-TIMER-CN, XZMFFIFS-TIMER-DATA, XZMFFIFS-TIMER-LN)
- n-KESA: `reserveCallTimerService()` (기존 callDelayAsyncService는 deprecated)
- z-KESA Detail: 타이머 관리정보 파라미터:
  - XZMFFIFS-TIMER-YN: 타이머관리여부(0=비관리, 1=관리대상)
  - XZMFFIFS-WTIME-ITV: INTERVAL TIME, 초단위(기본값 30초), 총괄타임아웃임계치 초과시 총괄값 적용
  - XZMFFIFS-TIMER-CN: 타이머재처리횟수(기본값 1회)
  - XZMFFIFS-TIMER-PGM: 타임아웃 발생시 호출할 PC 프로그램명
  - XZMFFIFS-AP-PARM-CTNT: 업무개별요청DATA (취소거래 발생시 COMMON AREA의 FMCOM-SYS-INTFAC-CTNT로 복원)
  - XZMFFIFS-TIMER-LN/DATA: 타이머가 발생시킬 온라인 거래 전문 데이터
  - IR 거래에서만 사용 권장. SAF에서 사용시 일자전환/계획정지 상황에서 별도 처리 로직 필요.
  - 타이머 스케쥴링은 ZMFFIFS 호출 시 지정된 타이머 정보로 프레임워크 타이머 관리에서 관리.
  - 타임아웃 발생시: ①지정 프로그램 호출 → ②업무 프로그램에서 재처리 또는 취소 거래 발생 → ③취소요청시 원거래 GUID로 원거래 복원 후 취소거래 요청 → ④모든 업무처리 취소 로직 구현 필수.
- n-KESA Detail:
  ```java
  String timerReserveId = reserveCallTimerService("EDU0100401", 30, pmEDU0100401Req, onlineCtx);
  // "EDU0100401" = 30초 후 실행할 거래코드, 30 = 타임아웃 초, pmEDU0100401Req = 취소에 필요한 DataSet
  ```
  순서 필수: `new OutboundHeader()` 먼저 → `reserveCallTimerService()` 호출 → `sendOutbound()` 호출. EAI 호출시 사용된 헤더값 중 전송요구 ID와 GUID가 timerReserveId값 일부에 포함됨. timerReserveId(TimerKey) 값 관리 중요(취소시 필요).
- Mapping Rule: z-KESA 타이머관리정보 파라미터(TIMER-YN='1', TIMER-PGM, WTIME-ITV 등) 조립 → n-KESA `reserveCallTimerService(거래코드, 초단위timeout, requestDataSet, onlineCtx)` 한 줄로 대체. TIMER-PGM(8자리 PC 프로그램명) → 거래코드(PM 메소드명).

---

### [EAI] - 타이머 취소 (정상응답 수신시)

- z-KESA: 타이머 관리 DB 갱신 처리 (프레임워크 내부); 응답 전문 수신 후 연동제어 프로그램에서 타이머 정보 갱신
- n-KESA: `cancelCallTimerService()` (기존 removeDelayAsyncService는 deprecated)
- z-KESA Detail: 응답전문이 수신된 경우 연동제어 프로그램에서 타이머 등록 전문의 응답 정보를 반영하여 갱신. 취소요청시 프레임워크에서 원거래 GUID를 이용하여 원거래를 복원하여 취소 거래 요청. 타이머 스케쥴링 처리는 프레임워크 자동 관리.
- n-KESA Detail:
  ```java
  boolean removed = cancelCallTimerService(null, onlineCtx);
  // null: 헤더의 전송요구ID와 GUID를 이용하여 Key 자동 조립
  // true: 타이머 취소 성공
  // false: 이미 타이머 거래가 기동됨 → 별도 로직 처리 필요
  ```
  - null 인자 사용시: 비동기 응답 거래 헤더에 요청 당시의 전송요구ID 값이 반드시 동일하게 들어와야 함.
  - 또는 reserveCallTimerService에서 리턴한 TimerKey 값을 개별부 전문으로 송신 후 응답 전문으로 받아 cancelCallTimerService 첫번째 인자로 사용 가능.
  - cancelCallTimerService 리턴값: true=타이머 취소됨, false=타이머 거래 이미 실행됨.
- Mapping Rule: z-KESA 타이머 응답 갱신(프레임워크 자동 처리) → n-KESA `cancelCallTimerService(null, onlineCtx)` 명시적 호출로 전환. 타이머 취소 실패(false)시 보상거래 실행 여부 판단 로직 추가 필요.

---

### [EAI] - Async Merge (비동기 응답 대기)

- z-KESA: 연동거래 스케쥴링 (BIM) + 복원영역 사용; 요청/응답 UOW 분리 처리
- n-KESA: `getAsyncOutboundResponse()` / `notifyWaitingOutboundSender()` 패턴 (Async Merge)
- z-KESA Detail: 사용자 입장 한 거래가 기술적으로 두 개의 거래로 구성. 원인거래 처리결과 복원과 전문응답 결과에 따른 미처리 업무내역 복원. 연동정의(BIM)의 오류시 취소제외여부 설정. 응답결과에 따라 원인거래 모든 처리 정상 또는 취소(오류) 처리 필수. 복원 불가 경우: CANAV-YN='1'(취소제외) 설정.
- n-KESA Detail: 비동기 처리 요청 PM과 응답 PM을 따로 개발하는 패턴. 요청 PM에서 sendOutboundNow() 후 getAsyncOutboundResponse()로 응답 대기. 응답 PM에서 notifyWaitingOutboundSender()로 대기중인 요청 PM 깨움. API:
  ```java
  // 요청PM에서:
  sendOutboundNow(OutboundTarget.EAI1, eaiHeader, xml, onlineCtx);
  IOutboundResponse asyncResponse = getAsyncOutboundResponse(eaiHeader, 30, onlineCtx);
  // 30초 타임아웃, eaiHeader=최초 비동기 전문 송신 객체
  
  KBMessage msg = (KBMessage) asyncResponse.getHeader();
  String outptDPtrnDstcd = msg.getCommonType().getOutMsgInfoType().getStndOutptDPtrnDstcd();
  if("02".equals(outptDPtrnDstcd)) {
      String errCd = msg.getErrMessage().getErrmsgErrcd();
      String treatCd = msg.getErrMessage().getErrmsgTreatCd();
  } else {
      IDataSet eaiRecvData = (IDataSet) asyncResponse.getBody();
  }
  
  // 응답PM에서:
  // 전달 전 에러 여부 판단: getEAIResponseKBMessage API 활용
  notifyWaitingOutboundSender(requestData, onlineCtx);
  // 에러전문이라도 notifyWaitingOutboundSender 호출 필수
  ```
  `getAsyncOutboundResponse()` API: `IOutboundResponse getAsyncOutboundResponse(IOutboundHeader outboundHeader, int timeoutSeconds, IOnlineContext onlineCtx)` - 응답 전문 수신될 때까지 대기. Timeout 후 응답 없으면 에러 발생.
  `notifyWaitingOutboundSender()` API: `void notifyWaitingOutboundSender(IDataSet dataset, IOnlineContext onlineCtx)` - 응답받은 개별부 데이터(dataset)와 전문헤더(onlineCtx)를 송신측에 전달. 에러 상세정보도 dataset에 포함하여 전달.
- Mapping Rule: z-KESA 연동거래 스케쥴링(BIM) + 원인거래 복원영역 패턴 → n-KESA Async Merge 패턴(getAsyncOutboundResponse + notifyWaitingOutboundSender)으로 전환. 연동정의 오류시 취소제외여부(BIM 설정) → n-KESA supplInfoType.setStndCnclEcludYn() 설정.

---

### [EAI] - 자동화기기 전문 에러 응답 처리

- z-KESA: 대외개설거래 에러전문 조립 프로그램(YCSFIERM 인터페이스) + XZMFFIFS-ATM-CSH-RETUN-DSTCD
- n-KESA: `setAtmErrorMsg()` 메소드
- z-KESA Detail: 자동화기기(ATM) 거래에서 에러 발생시 대외기관에 오류 전문 송신 필요. 자동화기기현금반환구분코드(XZMFFIFS-ATM-CSH-RETUN-DSTCD): 'R'=반환, 'A'=기기수납. 대외개설거래 에러전문 조립 프로그램(PC 계층): BMS [거래 파라미터 관리] 화면에서 오류전문여부="Y", 오류전문프로그램에 PC 프로그램명 등록(개설거래에서만 필수). 호출시 거래기준일자 및 최종사용자번호만 참조 가능, DBIO 저널로그 축적만 제한적 허용.
- n-KESA Detail: `setAtmErrorMsg()` API:
  ```java
  void setAtmErrorMsg(
      String errCd,                    // 에러코드
      String treatCd,                  // 조치코드
      String errPgmName,               // 에러프로그램명
      int errSituNo,                   // 에러 위치
      String errmsgOutptCstzMsgCtnt,   // 맞춤메시지
      IOnlineContext onlineCtx
  )
  ```
  무인공과금 업무 자동화기기 거래에서 에러 발생시 사용. setAtmErrorMsg로 에러 set → 최종 에러 Flat 전문 조립 → 응답. setAtmErrorMsg 후에도 본 거래 롤백을 위해 `throw new BusinessException(...)` 필수.
  예시:
  ```java
  IOutboundResponse asyncResponse = getAsyncOutboundResponse(eaiHeader, 30, onlineCtx);
  KBMessage kbmessage = (KBMessage) asyncResponse.getHeader();
  String outptDPtrnDstcd = kbmessage.getCommonType().getOutMsgInfoType().getStndOutptDPtrnDstcd();
  if("02".equals(outptDPtrnDstcd)) {
      String errCd = kbmessage.getErrMessage().getErrmsgErrcd();
      String treatCd = kbmessage.getErrMessage().getErrmsgTreatCd();
      String errPgmName = kbmessage.getErrMessage().getErrmsgErrPgmzName();
      int errSituNo = kbmessage.getErrMessage().getErrmsgErrSituNo();
      String errmsgOutptCstzMsgCtnt = kbmessage.getErrMessage().getErrmsgOutptCstzMsgCtnt();
      setAtmErrorMsg(errCd, treatCd, errPgmName, errSituNo, errmsgOutptCstzMsgCtnt, onlineCtx);
      throw new BusinessException("B3000142", "USQC0000");
  }
  ```
- Mapping Rule: z-KESA 대외개설거래 에러전문 조립 프로그램(YCSFIERM 인터페이스, PC 계층, BMS 등록) → n-KESA setAtmErrorMsg() 단일 메소드 호출로 대체. YCSFIERM의 출력파라미터(O-LEN, O-RTN-TRAN-CD, TELGM-DATA) 조립 로직 → 프레임워크가 자동 처리.

---

### [EAI] - M/F 연계시 책임자승인 처리

- z-KESA: M/F 연계 응답 전문 에러코드 'B88ZZZZZ' 확인 + 책임자승인정보 Set 전행공통 모듈 호출
- n-KESA: `NKESAUtils.isAthorFnshError()` + 책임자승인정보 Set 전행공통 모듈 호출
- z-KESA Detail: 수동거래(M/F)에서 책임자 승인 사유 발생시 응답전문 에러코드 'B88ZZZZZ'로 응답옴. 직접 확인: EAI 응답결과 에러코드에 'B88ZZZZZ' 셋팅 여부 확인 후 책임자승인정보 Set.
- n-KESA Detail:
  ```java
  IOutboundResponse eaiRecv = callOutbound("EAI1", eaiHeader, eaiSendTelgm, onlineCtx);
  // 방법1) 응답결과 사용
  if(NKESAUtils.isAthorFnshError(eaiRecv)) { // 책임자 승인정보 Set 전행공통 모듈 호출 }
  // 방법2) 응답결과의 KBMessage 사용
  KBMessage kbm = (KBMessage) eaiRecv.getHeader();
  if(NKESAUtils.isAthorFnshError(kbm)) { // 책임자 승인정보 Set 전행공통 모듈 호출 }
  ```
  기동거래(n-KESA)에서 책임자승인 사유 발생시: 기존 책임자승인 가이드대로 처리.
- Mapping Rule: z-KESA 에러코드 'B88ZZZZZ' 직접 비교 코드 → n-KESA `NKESAUtils.isAthorFnshError(eaiRecv)` 호출로 대체.

---

### [EAI] - 제약사항: IR 방식 건수 제한

- z-KESA: IR(DUMMY SEND) 방식에서 전문전송일련번호(XZMFFIFS-MSG-SERNO) 관리; 복수 전송시 일련번호 부여
- n-KESA: 비동기 IR 방식에서 한 거래에서 sendOutbound 한 번만 가능
- z-KESA Detail: XZMFFIFS-MSG-SERNO(X(03)): 한 거래에서 복수의 전문전송 요청시 일련번호 부여. 초기값(SPACE)인 경우 '001'로 조립.
- n-KESA Detail: IR 방식: 비동기 IR 방식 호출시 하나의 거래에서 sendOutbound 한 번만 가능 (두 번 이상시 에러 발생). SAF 방식: sendOutbound 최대 999건까지 가능.
- Mapping Rule: z-KESA에서 복수 전문전송(MSG-SERNO 증가)을 IR 방식으로 하던 경우 → n-KESA에서는 SAF 방식으로 변경하거나 callOutbound(동기) 사용.

---

### [EAI] - 제약사항: 배치에서 EAI 호출

- z-KESA: 센터일괄처리(C/C)에서는 SAF 형태 전문전송만 가능. 대량전송시 EAI/기관 시스템 부하 감안 유량제어. 업무팀 전문 테이블을 이용한 별도 유량제어 고려.
- n-KESA: 공유 FM 사용으로 EAI 호출 가능. 전체 건수 제한(별도 설정). 건건 sleep 속도제한.
- z-KESA Detail: 센터일괄처리(C/C): SAF 형태만 허용. 대량 전문전송시 별도 유량제어 메커니즘 구현 필요.
- n-KESA Detail: 배치에서 EAI 호출: 공유 FM을 사용하면 가능. EAI 과부하 방지를 위해 전체 건수 제한(별도 프레임워크 설정). 건건 sleep을 적용하여 속도제한.
- Mapping Rule: z-KESA 배치 SAF 전문전송 → n-KESA 공유 FM + sendOutboundAfterCommit(). 유량제어 설정은 프레임워크 팀과 협의.

---

### [EAI] - 제약사항: EAI로부터 동기(SYNC)로 피호출 될 경우 IO 등록 방법

- z-KESA: BMS [거래 파라미터 관리]에서 거래 등록. EAI 피호출 거래는 특수 등록.
- n-KESA: MMI에서 nKesa 메뉴를 통해 IO 등록 (MCI IO로 등록하지 않음)
- z-KESA Detail: 대외거래 응답 등 사유로 EAI로부터 직접 피호출되는 거래.
- n-KESA Detail: EAI로부터 SYNC로 피호출 될 경우: 1) 통합품질시스템에서 채널없는 거래로 등록. 2) MMI에서 nKesa 메뉴를 통해서 IO를 등록(MCI IO가 아닌 nKESA IO로 등록). 일반 거래(MCI 경유): 1) 통합품질시스템에서 채널(단말 등) 경유 거래로 등록. 2) MMI에서 MCI 메뉴를 통해 IO 등록.
- Mapping Rule: z-KESA EAI 피호출 거래 BMS 등록 → n-KESA MMI의 nKesa 메뉴에서 IO 등록으로 전환.

---

### [MCI BID/PUSH] - MCI BID/PUSH 메시지 전송 개요

- z-KESA: ZMFFIFS 전송구분코드 '8'(BID/MCI) / 내외부구분코드 '8': BID(MCI)
- n-KESA: `BidPushMessageHeader` + `sendBidMessage()` / `sendSingleViewPushMessage()` / `sendMiniSingleViewPushMessage()`
- z-KESA Detail: 내외부구분코드 8=BID(MCI). XZMFFIFS-WTIN-EXTNL-DSTCD = '8'. 서버에서 단말로 일방적 전문 전송.
- n-KESA Detail: BID 거래 패턴: 서버→단말 outbound 전송. MCI 시스템이 중계. BID 종류: 원인있는 BID(EAI 비동기 응답), 원인없는 BID(알림창, BIDMESSAGE). PUSHMESSAGE: 싱글뷰/미니싱글뷰 구현. 필수 등록: BID 거래코드를 MMI에 등록 → MCI 또는 nKESA에 배포.
- Mapping Rule: z-KESA ZMFFIFS TMS-DSCD='8' (BID/MCI) → n-KESA BidPushMessageHeader + sendBidMessage(). 거래코드 MMI 등록 및 MCI 배포 필수.

---

### [MCI BID/PUSH] - 비동기 응답 (원인있는 BID)

- z-KESA: EAI ASYNC 응답거래에서 MCI 경유 원단말 응답 전문 전송 (내부 프레임워크 처리)
- n-KESA: `AsyncResponseHeader` + `sendAsyncResponseNow()` (단말대기요구여부='1' 설정)
- z-KESA Detail: 원인있는 BID. 최초 원거래는 단말대기요구여부를 '1'로 세트하여 MCI 응답 → MCI는 단말로 전문 미전송 → 단말 계속 응답 대기. EAI 응답받은 거래에서 MCI 비동기 응답시 단말에 최종 응답 전문 전달.
- n-KESA Detail:
  ```java
  AsyncResponseHeader header = new AsyncResponseHeader(onlineCtx);
  KBMessage kbMsg = header.getKBMessage();
  CommonType commontype = kbMsg.getCommonType();
  commontype.getOutMsgInfoType().setStndOutptDPtrnDstcd("01"); // 정상
  IDataSet outDataDS = new DataSet();
  outDataDS.put("acnName", "한글1");
  header.addOutFormInfo("XXX06M18000", "V1", "01", "01", "", "");
  sendAsyncResponseNow(header, outDataDS, onlineCtx);
  ```
  최초 원 단말 요청전문의 헤더(KBMessage) 복원되어 설정됨. 응답메시지결과코드, 송수신 구분 값 등 일부 항목만 응답전문 규칙에 맞게 변경.
- Mapping Rule: z-KESA 단말대기요구여부='1' + EAI 응답거래 MCI 송신 → n-KESA sendAsyncResponseNow 패턴으로 전환.

---

### [MCI BID/PUSH] - BID응답처리 (원인없는 BID, BIDMESSAGE)

- z-KESA: ZMFFIFS BID 송신 패턴 (서버→단말 단방향)
- n-KESA: `BidPushMessageHeader` + `sendBidMessage()`
- z-KESA Detail: 서버에서 단말로 알림창 등 단방향 전문 전송.
- n-KESA Detail:
  ```java
  BidPushMessageHeader header = new BidPushMessageHeader(onlineCtx);
  KBMessage kbMsg = header.getKBMessage();
  CommonType commontype = kbMsg.getCommonType();
  commontype.getOutMsgInfoType().setStndOutptDPtrnDstcd("01"); // 정상
  commontype.getTranInfoType().setStndScrenNo("BNL72888000"); // 화면번호
  commontype.getChnlInfoType().setStndUserEmpid("단말사번"); // (중요) 전송할 단말사번
  IDataSet outDataDS = new DataSet();
  outDataDS.put("acnName", "한글1");
  sendBidMessage(header, outDataDS, "BID의거래코드", onlineCtx);
  ```
  `sendBidMessage()` API 오버로드:
  - `ByteArrayWrap sendBidMessage(BidPushMessageHeader oh, IDataSet responseData, String txid, IOnlineContext onlineCtx)`: dummyReturn=false, dummyReturnReleaseOnFail=false 기본값
  - `ByteArrayWrap sendBidMessage(BidPushMessageHeader oh, IDataSet responseData, String txid, boolean dummyReturn, boolean dummyReturnReleaseOnFail, IOnlineContext onlineCtx)`: dummyReturn, dummyReturnReleaseOnFail 설정 가능
  - GUID 새로 채번됨. 단말사번으로 단말이 로그인되어 있어야 전송됨.
  - 체크리스트: BID거래코드 MMI 등록 → MCI 또는 nKESA 배포 확인. 단말사번 설정 확인. MCI 모니터링 사이트에서 수신 여부 확인.
- Mapping Rule: z-KESA ZMFFIFS BID 송신 코드 → n-KESA sendBidMessage(). txid에 BID 거래코드 설정 필수.

---

### [MCI BID/PUSH] - BID 다건전송

- z-KESA: 복수 전문전송(MSG-SERNO 증가) 또는 반복 ZMFFIFS 호출 패턴
- n-KESA: `BidPushMessageHeader.addBidMsg()` + V8DTO 구조
- z-KESA Detail: 복수 BID 메시지를 여러 단말에 전송하는 패턴. 별도 명시적 지원 없이 반복 호출.
- n-KESA Detail: MMI를 통해 출력IO에 V8DTO 정의 후 header.addBidMsg()로 전송내역 추가:
  ```java
  BidPushMessageHeader header = new BidPushMessageHeader(onlineCtx);
  header.addBidMsg("단말사번1", "송신메시지", "화면번호1", "");
  header.addBidMsg("단말사번2", "송신메시지", "화면번호2", "");
  sendBidMessage(header, outDataDS, "BID의거래코드", onlineCtx);
  ```
  `addBidMsg()` API: `void addBidMsg(String empId, String bigMessageContent, String bidMessageLinkedScreen, String bigMessageLinkedData)`. V8DTO 구조: bidMsgCnt, bidMsgCatlgu[{bidMsgRecvEmpid, bidMsgCtnt, bidMsgLnkdScen}...].
  체크리스트: BID거래 출력IO에 V8DTO구조 등록 확인. 전문로그에서 V8DTO 포함 여부 확인.
- Mapping Rule: z-KESA 반복 BID 송신 호출 → n-KESA addBidMsg() 반복 호출 후 sendBidMessage() 단 1회 호출로 대체.

---

### [MCI BID/PUSH] - 싱글뷰(SingleView)

- z-KESA: 해당 없음 (마켓팅플랫폼 전용 기능)
- n-KESA: `sendSingleViewPushMessage()`
- z-KESA Detail: N/A
- n-KESA Detail: 마켓팅플랫폼 전용. nKESA에서 단말로 전문 전송하여 싱글뷰 화면 표시. MCI에 PUSH 거래코드와 IO 별도 등록 필요.
  ```java
  BidPushMessageHeader header = new BidPushMessageHeader(onlineCtx);
  KBMessage kbMsg = header.getKBMessage();
  kbMsg.getCommonType().getOutMsgInfoType().setStndOutptDPtrnDstcd("01");
  kbMsg.getCommonType().getTranInfoType().setStndScrenNo("BNL72888000");
  sendSingleViewPushMessage(header, outDataDS, "싱글뷰의거래코드", onlineCtx);
  ```
  API 오버로드:
  - `ByteArrayWrap sendSingleViewPushMessage(BidPushMessageHeader oh, IDataSet responseData, String txId, IOnlineContext onlineCtx)`: 단말대기여부=대기하지않음(0), 싱글뷰PM 자체 응답=더미응답. dummyReturn=false, dummyReturnReleaseOnFail=false
  - `ByteArrayWrap sendSingleViewPushMessage(BidPushMessageHeader oh, IDataSet responseData, String txId, boolean dummyReturn, boolean dummyReturnReleaseOnFail, IOnlineContext onlineCtx)`: dummyReturn, dummyReturnReleaseOnFail 설정 가능
- Mapping Rule: 신규 기능으로 z-KESA 직접 대응 없음. n-KESA 신규 구현시 sendSingleViewPushMessage() 사용.

---

### [MCI BID/PUSH] - 미니싱글뷰(MiniSingleView)

- z-KESA: 해당 없음 (마켓팅플랫폼 전용 기능)
- n-KESA: `sendMiniSingleViewPushMessage()`
- z-KESA Detail: N/A
- n-KESA Detail: 마켓팅플랫폼 전용. MCI에 PUSH 거래코드와 IO 별도 등록 필요. 거래프로파일에 무응답거래로 설정 필수.
  ```java
  BidPushMessageHeader header = new BidPushMessageHeader(onlineCtx);
  sendMiniSingleViewPushMessage(header, outDataDS, "미니싱글뷰의거래코드", onlineCtx);
  ```
  API 오버로드:
  - `ByteArrayWrap sendMiniSingleViewPushMessage(BidPushMessageHeader oh, IDataSet responseData, String txId, IOnlineContext onlineCtx)`: dummyReturn=false, dummyReturnReleaseOnFail=false
  - `ByteArrayWrap sendMiniSingleViewPushMessage(BidPushMessageHeader oh, IDataSet responseData, String txId, boolean dummyReturn, boolean dummyReturnReleaseOnFail, IOnlineContext onlineCtx)`: 인자 추가
  - 체크리스트: 미니싱글뷰 거래프로파일에 무응답거래로 설정 여부 확인.
- Mapping Rule: 신규 기능으로 z-KESA 직접 대응 없음.

---

### [V3표준전문] - V3표준전문 개요

- z-KESA: 내부표준전문 V2.0 (전 영역 헤더+공통부+개별부 구조)
- n-KESA: V3표준전문 (Restful URI 기반, 헤더 축약 구조)
- z-KESA Detail: 내부표준전문 구조: Header(헤더부) + Common(TranInfo, ChnlInfo, InMsgInfo, AthorInfo, EntrBnkBzwkCmn, OutMsgInfo, ErrInfo, SpareArea, StndInptMdiaPartlInfo) + Individual(InData 개별부). 모든 항목 고정 key:value 형태. 거래코드 기반 V2 전문 처리.
- n-KESA Detail: V3표준전문 구조: Header(StndGuIdNo, StndSysOperEvirnDstcd, StndInptMsgWritYms 등 필요한 항목만) + Individual(InData 개별부). V2와 key명 동일. value 없으면 null 또는 "" 세팅. Restful URI 기반 API 연계를 위해 V3.0 정의(The K 표준전문 V2.0 이후). API G/W(Kbaas) 및 EAI 인터페이스 영역과 V3 전문으로 통신.
- Mapping Rule: z-KESA 전체 공통부 항목 조립 → n-KESA V3에서는 필요한 헤더 항목만 세팅. 거래코드 기반 → URI 기반으로 전환.

---

### [V3표준전문 Inbound] - MMI 정보 매핑 등록

- z-KESA: BMS [거래 파라미터 관리] 화면에서 거래 등록
- n-KESA: MMI(전문관리통합시스템)에 API 정보 추가 등록 (기존 전문설계 + API 정보)
- z-KESA Detail: BMS에서 거래코드, 오류전문여부, 오류전문프로그램, 거래 스케줄 파라미터 등 등록.
- n-KESA Detail: V3표준전문 연계 처리를 위해 MMI에 API 정보 추가 등록 필수:
  1. nKESA 거래코드 조회 화면에서 대상 거래코드 조회(소스시스템ID = "NKS")
  2. 메시지 위저드 팝업 상세보기 > API 정보 등록 팝업
  3. API 정보 등록 화면: 현재 거래코드(인터페이스)와 RESTful 정보 매핑 등록 (URI, 메소드, 업무URI)
  4. nKESA 배포: MCI 경유하지 않는 n-KESA 거래코드 배포 (기존 배포 방법 그대로 사용)
  배포 후 관리콘솔 [온라인/거래프로파일 관리(RestApi)] 메뉴에서 URI경로, Method, Profile, 등록일시 확인. 등록 오류시 Restful URI 연계 처리 불가 → 재배포 조치.
- Mapping Rule: z-KESA BMS 거래 등록 → n-KESA MMI 거래코드 등록 + API 정보(URI/메소드) 추가 등록으로 확장.

---

### [V3표준전문 Inbound] - 어노테이션 추가

- z-KESA: BMS 거래코드 기반 라우팅 (프레임워크 자동 처리)
- n-KESA: `@RequestMapping`, `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping` 어노테이션
- z-KESA Detail: 거래코드 기반으로 AS/PC 프로그램이 호출됨. 프레임워크 스케쥴러에서 자동 분배.
- n-KESA Detail: PM 메소드에 어노테이션 추가로 Restful URI 매핑:
  ```java
  import com.kbstar.sqc.fwexten.openapi.annotation.RequestMapping;
  // 주의: Spring Annotation이 아님. com.kbstar.sqc.fwexten.openapi.annotation 패키지 사용.
  
  // 일반 사용예
  @RequestMapping(value="/api/v3/qqq/aaa/bbb/", method=RequestMethod.GET)
  @BizMethod("조회")
  public IDataSet pmEDUTESK003(IDataSet requestData, IOnlineContext onlineCtx) { ... }
  
  // 1개 PM에 2개 주소 매핑
  @RequestMapping(value={"/api/v3/qqq/aaa/bbb/", "/api/v3/sqc/test2/"}, method=RequestMethod.GET)
  
  // PathVariable 사용
  @RequestMapping(value="/api/v3/qqq/aaa/bbb/{name}", method=RequestMethod.GET)
  // requestData.getString("name") 으로 값 접근 (MMI IO에 등록 필수)
  
  // HTTP 메서드 전용 매핑
  import com.kbstar.sqc.fwexten.openapi.annotation.GetMapping;
  import com.kbstar.sqc.fwexten.openapi.annotation.PostMapping;
  @PostMapping("/api/v3/sqc/restapitest3")
  @GetMapping("/api/v3/sqc/restapitest3")
  ```
- Mapping Rule: z-KESA 거래코드 기반 라우팅(프레임워크 자동) → n-KESA 어노테이션(@RequestMapping 등) 추가. 기존 거래코드 기반 PM 메소드에 어노테이션만 추가하면 됨.

---

### [V3표준전문 Inbound] - 요청 매핑 작성 주의사항

- z-KESA: 해당 없음 (거래코드 체계는 별도 규칙)
- n-KESA: URI 경로 규칙, HTTP Method, 단위 제한 등
- z-KESA Detail: N/A
- n-KESA Detail: 규칙:
  - UNIT 메소드: 거래코드 단위(PM)에만 설정 가능. FM/DM 설정 불가.
  - 사용 가능 HTTP Method: @GetMapping, @PostMapping, @DeleteMapping, @PutMapping, @RequestMapping
  - 중복 설정 허용.
  - URI 형식: `@PostMapping("/api/v3/업무코드3자리/<resource중분류>/<resource>~")`
  - URI 경로는 유니크 필수. 최소 4depth 이상(Resource중분류까지 필수).
    - 정상: `/api/v3/sqc/apitest`, `/api/v3/sqc/apitest/{key}`
    - 비정상: `/api/v3/sqc`, `/api/v3/sqc/{key}`
  - 거래코드-URI 다중매핑 허용: `@PostMapping(path={"/api/v3/sqc/apitest1", "/api/v3/sqc/apitest2"})`
  - URI 경로에 * 사용 금지.
  - PathVariable 허용: `/api/v3/sqc/apitest/{key}` 설정시 `/api/v3/sqc/apitest/3` 요청 → 표준전문 개별부에 key=3으로 세팅.
- Mapping Rule: 신규 요건. z-KESA 거래코드 변환 규칙과 별개로 URI 설계 필수.

---

### [V3표준전문 Inbound] - API G/W Inbound 에러응답 처리

- z-KESA: #ERROR 매크로 + 에러코드/조치코드 발행; 에러전문 조립은 MCI/프레임워크 처리
- n-KESA: `setErrorResponseDataSet()` + `throw new BusinessException()`
- z-KESA Detail: 오류 발생시 #ERROR 매크로 호출 → 프레임워크가 에러 전문 조립 → MCI에서 에러상세메시지 조립 → 채널 연계.
- n-KESA Detail: MCI 경유시: 에러코드만 발행, 상세 메시지 조립은 MCI에서 수행. API G/W 경유시: 상세 메시지 조립을 API G/W에서 수행하지 않음 → 어플리케이션 레벨에서 직접 조립 필수.
  ```java
  try {
      ...
  } catch(Exception e) {
      responseData.put("처리결과구분", "N");
      responseData.put("에러코드", "에러코드");
      responseData.put("에러메시지", "시스템 오류로 간편인증서 정보 조회에 실패하였습니다.");
      setErrorResponseDataSet(responseData, onlineCtx);
      // setErrorResponseDataSet한 값이 PM 출력 레이아웃대로 변환되어 전송됨
      throw new BusinessException("Bxxxxxxx", "Uxxxxxxx", "맞춤메시지", e);
  }
  ```
  에러코드, 에러메시지를 어떻게 주고받을지 소스 시스템과 협의 후 포멧 결정 필요.
- Mapping Rule: z-KESA #ERROR 매크로 → n-KESA `throw new BusinessException(errCd, treatCd, msg)`. API G/W 경유시 추가로 `setErrorResponseDataSet(responseData, onlineCtx)` 호출하여 에러 개별부 데이터 직접 조립.

---

### [V3표준전문 Outbound] - EAI API 서비스 코드 생성

- z-KESA: EAI 시스템에 전문변환 규칙 등록 (EAI 팀과 협의)
- n-KESA: EAI 어댑터 설정 요청 + MMI에 EAI 서비스 코드 및 API 서비스 경로 등록
- z-KESA Detail: 메인프레임에서 대외기관 및 내부 서버시스템으로 전문 전송시 코드변환은 EAI 시스템에 등록한 전문변환 규칙에 따라 이루어짐. EAI 시스템에 해당 전문에 대한 변환규칙 등록여부 확인 필수.
- n-KESA Detail: V3표준전문 방식으로 EAI 연계 처리하려면 EAI 어댑터 설정 필요 → EAI 팀에 어댑터 생성 요청. MMI(전문관리통합시스템)에서 EAI 서비스 코드 생성시 정보 매핑 API 서비스 경로 등록.
- Mapping Rule: z-KESA EAI 전문변환 규칙 등록 → n-KESA EAI 어댑터 설정 요청 + MMI API 서비스 경로 등록.

---

### [V3표준전문 Outbound] - callEAIApiService (EAI API 연계)

- z-KESA: ZMFFIFS(전송요청모듈) 호출 (TCP 통신 기반)
- n-KESA: `callEAIApiService()` (HTTP Restful URI 방식 Outbound)
- z-KESA Detail: `#DYCALL ZMFFIFS YCCOMMON-CA XZMFFIFS-CA` 패턴으로 TCP 통신. 파라미터 직접 조립 후 호출.
- n-KESA Detail: V3 전문으로 EAI와 HTTP 통신:
  ```java
  RestResponseContext callEAIApiService(
      String httpMethod,         // GET, POST, PUT, DELETE
      String URI,                // EAI 서비스코드 등록시 작성한 API URI정보
      OutboundHeader outboundHeader, // 내부표준전문 항목 값들이 매핑된 KBMessage 객체
      IDataSet requestData,      // 내부표준전문의 개별부 설정 항목
      int timeout,               // (선택) 타임아웃. 기본 60초
      String encoding,           // (선택) 인코딩. 기본 UTF-8
      IOnlineContext onlineCtx   // 거래 속성정보, CommonArea정보 등
  )
  ```
  PM, FM에서 모두 호출 가능. 기존 callOutbound(TCP 방식)와 별개 추가 API. 거래내역 확인: 관리콘솔 [온라인/전문로그 조회] 메뉴.
  호출 예시:
  ```java
  OutboundHeader oh = new OutboundHeader(onlineCtx);
  KBMessage kbms = oh.getKBMessage();
  kbms.getCommonType().getTranInfoType().setStndTelgmRecvTranCd("SQC0000003");
  kbms.getCommonType().getTranInfoType().setStndPrcssRtdTranCd("    SQC");
  requestData.put("cncycd", "USD");
  ResponseContext responseContext = callEAIApiService("POST", "/api/test/v3/sqc/eaiTest", oh, requestData, onlineCtx);
  ```
- Mapping Rule: z-KESA ZMFFIFS TCP 호출 → n-KESA callEAIApiService HTTP 호출로 전환 (V3 EAI 연계시). 파라미터 구조: 전송요청구분(HTTP 메소드), SVR-TRN-NO(URI), XZMFFIFS-CA 전체(OutboundHeader+requestData).

---

### [V3표준전문 Outbound] - ResponseContext (EAI API 응답 객체)

- z-KESA: ZMFFIFS 리턴코드 + 응답 전문 개별부 (COPYBOOK REDEFINE 접근)
- n-KESA: `ResponseContext` 객체 (callEAIApiService 리턴값)
- z-KESA Detail: ZMFFIFS 리턴코드(00/09/98/99) 확인 후 응답 전문 접근.
- n-KESA Detail: `ResponseContext` 객체 속성:
  - `KBMessage getKBMessage()`: 응답 전문의 헤더부, 공통부 담고 있는 KBMessage 객체
  - `IDataSet getOutData()`: 응답 전문 개별부 DataSet 객체
  - `List<OutFormType> getOutForms()`: 응답 전문의 Form 데이터
  - `OutDataCommon getOutDataCommon()`: 출력 공통부 데이터
  에러 여부 판단:
  ```java
  KBMessage responseKBMessage = responseContext.getKBMessage();
  String outptDPtrnDstCd = responseKBMessage.getCommonType().getOutMsgInfoType().getStndOutptDPtrnDstcd();
  boolean isError = "02".equals(outptDPtrnDstCd) || "2".equals(outptDPtrnDstCd);
  if(isError) {
      String errcd = responseKBMessage.getErrMessage().getErrmsgErrcd();
      String treatCd = responseKBMessage.getErrMessage().getErrmsgTreatCd();
      throw new BusinessException(errcd, treatCd, "출력맞춤메시지");
  } else {
      responseData = (IDataSet)responseContext.getOutData().clone();
  }
  ```
- Mapping Rule: z-KESA ZMFFIFS 리턴코드 체크 + 응답 COPYBOOK 참조 → n-KESA ResponseContext.getKBMessage() 에러 판단 + ResponseContext.getOutData() 개별부 접근으로 전환.

---

### [V3표준전문 Outbound] - API G/W 연계 (callStandardApiService)

- z-KESA: 해당 없음 (API G/W 개념 없음)
- n-KESA: `callStandardApiService()` (KBaaS API G/W 경유 표준전문 처리)
- z-KESA Detail: N/A. 메인프레임은 EAI 경유가 기본이며 API G/W 개념 적용되지 않음.
- n-KESA Detail: 업무팀에서 KBaaS API 사용신청 후 발급받은 ClientID, ClientSecret을 프레임워크 팀에 전달하여 등록. 토큰 만료 여부 체크 및 재발행은 프레임워크 내부 처리. 시스템간 연계를 위한 양자간 인증 처리만 지원.
  ```java
  ResponseContext callStandardApiService(
      String ClientId,               // KBaaS포탈에서 등록한 클라이언트 ID
      String appCode,                // 클라이언트ID 등록한 (대문자)업무코드 3자리
      String httpMethod,             // GET, POST, PUT, DELETE
      String URI,                    // KBaaS에 등록한 URI 정보
      Map<String,String> httpHeader, // Http header에 세팅할 데이터
      OutboundHeader outboundHeader, // 내부표준전문 KBMessage 객체
      IDataSet requestData,          // 내부표준전문의 개별부
      int timeout,                   // (선택) 기본 60초
      String encoding,               // (선택) 기본 UTF-8
      IOnlineContext onlineCtx
  )
  ```
  ResponseContext 동일 구조: getKBMessage(), getOutData(), getOutForms(), getOutDataCommon().
  호출 예시:
  ```java
  Map<String,String> httpHeader = new HashMap<>();
  OutboundHeader oh = new OutboundHeader(onlineCtx);
  requestData.put("acno", "123456789");
  ResponseContext responseContext = callStandardApiService(
      "발급받은 클라이언트ID", "업무코드", "POST", "/api/v3/sqc/restapitest", httpHeader, oh, requestData, onlineCtx);
  ```
  거래내역 확인: 관리콘솔 [온라인/전문로그 조회].
- Mapping Rule: 신규 기능. z-KESA 대응 없음. n-KESA 신규 구현시 API G/W 연계에 사용. 프레임워크 팀에 ClientID, ClientSecret, 호출 API G/W 도메인명, 업무코드 3자리 전달 필수.

---

### [V3표준전문 Outbound] - 방화벽 신청 목록

- z-KESA: 해당 없음 (메인프레임 네트워크 별도 관리)
- n-KESA: 업무AP → API G/W 방화벽 신청 (업무팀 직접 진행)
- z-KESA Detail: N/A
- n-KESA Detail: 방화벽 신청 목적지 목록 (내부 API G/W):
  - 개발: 10.138.70.42 / dev-apim-api.kbonecloud.com
  - 스테이징: 10.138.70.42 / stg-apim-api.kbonecloud.com
  - 운영: 10.136.70.35 / apim-api.kbonecloud.com
  마이데이터 전용: dev-mydata-api.kbonecloud.com / stg-mydata-api.kbonecloud.com / mydata-api.kbonecloud.cm
  임베디드뱅킹 전용(내부): internal-zemfi-api.kbstar.com / internal-yemfi-api.kbstar.com / internal-emfi-api.kbstar.com
  스타뱅킹 전용: dev-internal-msb-api.kbstar.com / stg-internal-msb-api.kbstar.com / internal-msb-api.kbstar.com
  타사 API G/W: dev-outbound-api.kbonecloud.com / stg-outbound-api.kbonecloud.com / outbound-api.kbonecloud.com
  임베디드뱅킹 전용(타사): outbound-zemfi-api.kbstar.com / outbound-yemfi-api.kbstar.com / outbound-emfi-api.kbstar.com
  ※ API G/W 구성 환경에 따라 도메인 변경 가능 → API 팀 확인 후 등록.
  ※ KBaaS Admin Portal: http://kbaas.kbonecloud.com (Oauth인증 가이드 참고)
- Mapping Rule: 신규 요건. n-KESA API G/W 연계시 업무팀에서 직접 방화벽 신청.

---

### [V3표준전문 Outbound] - callRestApiService (비표준전문 처리)

- z-KESA: 해당 없음 (비표준 REST 연계 미지원)
- n-KESA: `callRestApiService()` (KB G/W 경유 행내/대외 비표준 API)
- z-KESA Detail: N/A. 메인프레임에서는 모든 대외 연계가 EAI를 경유하는 표준전문 방식.
- n-KESA Detail: KB G/W를 경유하여 행내/대외 API 제공자와 통신시 사용:
  ```java
  RestResponseContext callRestApiService(
      String ClientId,               // KBaaS포탈에서 등록한 클라이언트 ID
      String appCode,                // (대문자)업무코드 3자리
      String httpMethod,             // GET, POST, PUT, DELETE
      String URI,                    // KBBAAS에 등록한 URI 정보
      Map<String,String> httpHeader, // Http header 세팅 데이터
      IDataSet requestData,          // 개별부 설정 항목
      Boolean isGuidRecreated,       // (선택) guid재채번 설정. 기본 false
      int timeout,                   // (선택) 기본 60초
      String encoding,               // (선택) 기본 UTF-8
      IOnlineContext onlineCtx
  )
  ```
  `RestResponseContext` 객체 속성 (callStandardApiService의 ResponseContext와 다름):
  - `Map<String,List<String>> getHeaders()`: 응답 전문 헤더 정보
  - `IDataSet getOutData()`: 응답 전문 개별부 DataSet
  - `int getResponseCode()`: HTTP 응답 상태코드
  호출 예시:
  ```java
  RestResponseContext response = callRestApiService(
      "발급받은 클라이언트ID", "업무코드", "POST", "/v1/ban/foreignExchange/exchangeRate", httpHeader, requestData, onlineCtx);
  log.debug("HTTP STATUS=" + response.getResponseCode());
  log.debug("HTTP HEADER=" + response.getHeaders().toString());
  log.debug("HTTP BODY=" + response.getOutData().toString());
  responseData = (IDataSet) response.getOutData().clone();
  ```
  거래내역 확인: 관리콘솔 [온라인/전문로그 조회].
- Mapping Rule: 신규 기능. z-KESA 대응 없음. 비표준 REST API 연계시 사용. callStandardApiService(표준전문)와 달리 ResponseContext가 아닌 RestResponseContext 리턴 → getResponseCode(), getHeaders() 추가 제공.

---

### [대외기관코드 조회] - ZUGRSTH → CommonArea/KBMessage 접근

- z-KESA: 내부표준관련조회 모듈(ZUGRSTH) 호출 (Section 3.16)
- n-KESA: `CommonArea.getBiCom().getXxx()` 또는 `KBMessage.getCommonType().getTranInfoType().getStndOsidInstiCd()`
- z-KESA Detail: 채널 및 대외기관에서 MCI/EAI를 경유해서 입력되는 내부표준전문의 헤더부와 공통부 항목 중 업무 요건상 참조 필요시 유틸리티 호출. 현재 대외기관코드를 대상으로 함(추가 항목은 프레임워크팀과 협의). 코딩 방법: `#DYCALL ZUGRSTH YCCOMMON-CA XZUGRSTH-CA`. 파라미터:
  - XZUGRSTH-CA (COPY XZUGRSTH): 초기화 필수
  - 입력부: XZUGRSTH-IN-FINM(X(21)) = 요청 필드명 (예: 'OSID-INSTI-CD')
  - 출력부: XZUGRSTH-OT-LEN(9(02)) = 출력데이터 길이, XZUGRSTH-OT-DATA(X(40)) = 요청하신 데이터 값
  - 리턴코드: 00=정상, 02=요청필드값 초기화/미설정, 98/99=시스템오류(#ERROR)
  사용 예시:
  ```cobol
  INITIALIZE XZUGRSTH-CA
  MOVE 'OSID-INSTI-CD' TO XZUGRSTH-IN-FINM
  #DYCALL ZUGRSTH YCCOMMON-CA XZUGRSTH-CA
  IF XZUGRSTH-R-STAT = CO-STAT-OK
      MOVE XZUGRSTH-OT-DATA(1:XZUGRSTH-OT-LEN) TO XXXXXXX(업무필드)
  ELSE
      #ERROR CO-BXXXXXXX CO-UXXXXXXX CO-STAT-ERROR
  END-IF
  ```
- n-KESA Detail: n-KESA에서는 ZUGRSTH 유틸리티가 불필요. 입력 전문의 내부표준전문 헤더/공통부 항목은 CommonArea 또는 KBMessage로 직접 접근:
  - CommonArea를 통한 접근 (일반 Inbound 거래): `CommonArea ca = getCommonArea(onlineCtx); String osidInstiCd = ca.getBiCom().getOsidInstiCd();` (BICOM 영역 직접 접근)
  - KBMessage를 통한 접근 (EAI 송수신 처리시): `KBMessage kbm = eaiHeader.getKBMessage(); String osidInstiCd = kbm.getCommonType().getTranInfoType().getStndOsidInstiCd();`
  - EAI 응답 전문 헤더 접근시: `KBMessage kbm = (KBMessage) eaiRecv.getHeader(); String osidInstiCd = kbm.getCommonType().getTranInfoType().getStndOsidInstiCd();`
- Mapping Rule: z-KESA `#DYCALL ZUGRSTH YCCOMMON-CA XZUGRSTH-CA` 전체 블록(초기화+MOVE+CALL+리턴코드체크) → n-KESA `getCommonArea(onlineCtx).getBiCom().getOsidInstiCd()` 또는 `kbm.getCommonType().getTranInfoType().getStndOsidInstiCd()` 한 줄로 대체. XZUGRSTH-IN-FINM에 지정하던 필드명 → n-KESA의 해당 getter 메소드 이름으로 변환.

---

### [타이머 관리] - z-KESA 타이머 관리 → n-KESA 비동기 취소 타이머 전체 흐름

- z-KESA: ZMFFIFS 타이머관리정보 파라미터 조립 + TIMER 호출 PC 프로그램 + 배치 타이머 처리(Section 3.17)
- n-KESA: `reserveCallTimerService()` + `cancelCallTimerService()` + 타이머 거래(PM)
- z-KESA Detail: 타이머 관리 전체 흐름 (Section 3.14.3):
  ①전송요청모듈 호출시 타임아웃 등록여부(TIMER-YN) 및 인터벌 타임(WTIME-ITV) 지정
  ②프레임워크 자동 타이머 스케쥴링에서 관리대상 전문 추가 및 지정시간 후 응답전문 수신여부 확인
  ③응답전문 수신시 연동제어 프로그램에서 타이머 등록 전문의 응답 정보 반영하여 갱신
  ④타임아웃 발생시 프레임워크에서 사용자 지정 프로그램(TIMER-PGM) 호출
  ⑤업무 프로그램에서 타임아웃 발생에 따른 업무처리 흐름 수행 또는 재 타임아웃 관리 요청
  ⑥횟수 1회 처리만 가능, TASK 999회 초과시 타임아웃 처리 프로그램에서 원거래 취소처리 여부 요청(반드시 TASK 종료 옵션 사용)
  ⑦취소요청시 프레임워크에서 원거래 GUID로 원거래 복원하여 취소거래 요청
  ⑧업무 프로그램에서 모든 업무처리 취소 로직 구현 필수
  
  배치 타이머(Section 3.17): 불규칙적 배치성 작업(JCL 기동)과 특정 조건처리를 반복 처리. 배치 타이머 등록: BATCH JCL(온라인) 이용. 타이머 테이블에 사전 등록된 프로그램 호출 후 새로운 거래 발생. 등록 항목: 기동시작시각(YYYYMMDDHHMMSS), 기동종료시각, 데몬상태구분, 데몬호출간격(분), 데몬일련번호.
- n-KESA Detail: 타이머 관리 전체 흐름:
  - 타이머 기동: `reserveCallTimerService(거래코드, 초단위timeout, DataSet, onlineCtx)` → timerReserveId 리턴
  - 타이머 취소: `cancelCallTimerService(null 또는 timerReserveId, onlineCtx)` → boolean 리턴
  - 순서: new OutboundHeader() → reserveCallTimerService() → sendOutbound()
  - 취소 타이머 거래(PM): 타임아웃 발생시 실행될 PM 메소드를 거래코드로 등록
  - 취소거래 판단 로직은 해당 PM 메소드에서 직접 구현
  
  z-KESA 배치 타이머(Section 3.17) 대응: n-KESA에서는 reserveCallTimerService를 이용한 온라인 타이머 거래 또는 별도 배치 스케쥴러(쿼츠 등) 활용.
- Mapping Rule: 
  - ZMFFIFS 타이머관리정보(TIMER-YN='1', WTIME-ITV, TIMER-PGM) 파라미터 조립 → `reserveCallTimerService(TIMER-PGM에 해당하는 거래코드, WTIME-ITV 초단위, 취소에 필요한 DataSet, onlineCtx)` 한 줄로 대체.
  - 타임아웃 발생시 호출될 PC 프로그램(TIMER-PGM) → 타이머 거래코드에 해당하는 PM 메소드로 전환.
  - 업무개별요청DATA(XZMFFIFS-AP-PARM-CTNT, FMCOM-SYS-INTFAC-CTNT로 복원) → reserveCallTimerService의 DataSet 인자로 전달.
  - 원거래 복원(GUID 기반) → cancelCallTimerService의 null 인자(프레임워크가 헤더의 전송요구ID+GUID로 자동 조립)로 대체.
  - z-KESA 배치 타이머 JCL 등록 방식 → n-KESA 배치 스케쥴러 또는 reserveCallTimerService 활용으로 전환(프레임워크 팀 협의).

---

**파일 경로 참조:**
- `/Users/soyeon/Projects/cobol-test/참고자료/framework/z-kesa/z-kesa_full.txt` (Section 3.14: 본문 lines 11767-12576, Section 3.15: lines 12646-12963, Section 3.16: lines 12965-13116, Section 3.17 배치타이머: lines 13122-13260)
- `/Users/soyeon/Projects/cobol-test/참고자료/framework/n-kesa/n-kesa_full.txt` (Section 3.9 EAI연계: lines 5330-6517, Section 3.10 MCI BID/PUSH: lines 6519-6797, Section 3.17 V3표준전문: lines 7281-7851)