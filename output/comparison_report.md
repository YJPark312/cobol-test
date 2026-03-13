# C2J 변환 코드 vs 참조 코드 심층 비교 분석 리포트

**작성일**: 2026-03-13
**대상 COBOL**: AIPBA30.cbl (AS, 255행), DIPA301.cbl (DC, 1985행)
**참조 코드**: aws2-njava (사람 작성)
**C2J 코드**: src/main/java/com/kbstar/kip/enbipba/ (AI 생성)

---

## 1. 아키텍처 설계 비교

### 1.1 계층 구조 비교

| 항목 | 참조 코드 | C2J 코드 | COBOL 원본 |
|------|-----------|----------|-----------|
| **PU (ProcessUnit)** | PUCorpGrpCrdtEvalHistMgmt (268행) | PUCorpEvalHistory (225행) | AIPBA30 (AS) |
| **FU (FunctionUnit)** | FUCorpGrpCrdtEvalHistProc (657행) | 없음 | - |
| **DU (DataUnit)** | 테이블별 12개 DU 클래스 (총 2,534행) | DUCorpEvalHistoryA 1개 통합 (1,038행) | DIPA301 (DC) |
| **상수 클래스** | 없음 (하드코딩) | CCorpEvalConsts (135행) | CO-AREA |
| **UIO 정의** | FUCorpGrpCrdtEvalHistProc.uio (44행) | 없음 | COPYBOOK |
| **XSQL** | 없음 (DU 내 dbSelect 문자열 참조) | DUCorpEvalHistoryA.xml (665행) | SQLIO (QIPA301~308) |

### 1.2 핵심 아키텍처 차이 분석

**참조 코드: 3계층 (PU -> FU -> DU)**
```
PUCorpGrpCrdtEvalHistMgmt (PU)
  └─ FUCorpGrpCrdtEvalHistProc (FU) ← 비즈니스 로직 집중
       ├─ DUTSKIPB110 (DU) ← 테이블 접근만
       ├─ DUTSKIPB111 (DU)
       ├─ DUTSKIPB112 (DU)
       ├─ ... (12개 DU)
       └─ DUTSKIPA111 (DU)
```

**C2J 코드: 2계층 (PU -> DU)**
```
PUCorpEvalHistory (PU)
  └─ DUCorpEvalHistoryA (DU) ← 비즈니스 로직 + 테이블 접근 통합
       └─ DUCorpEvalHistoryA.xml (XSQL)
```

**원인 분석**: COBOL 원본이 AS(AIPBA30) -> DC(DIPA301) 2계층이므로, C2J는 이를 충실히 반영하여 PU -> DU 2계층으로 변환하였다. 반면 참조 코드는 n-KESA 표준 3계층(PU/FU/DU) 구조를 적용하여 비즈니스 로직을 FU로 분리하고, 데이터 접근을 테이블별 DU로 세분화하였다.

**n-KESA 표준 준수**: 참조 코드가 표준에 더 부합. n-KESA 표준에서 DU는 순수 데이터 접근만 담당해야 하며, 비즈니스 로직은 FU에 위치해야 한다.

### 1.3 패키지 구조 차이

| 항목 | 참조 코드 | C2J 코드 |
|------|-----------|----------|
| **베이스 패키지** | com.kbstar.edu.c2j | com.kbstar.kip.enbipba |
| **비즈 패키지** | com.kbstar.edu.c2j.biz | com.kbstar.kip.enbipba.biz |
| **UIO 패키지** | com.kbstar.edu.c2j.uio | 없음 |
| **상수 패키지** | 없음 | com.kbstar.kip.enbipba.consts |
| **XSQL 패키지** | 없음 | com.kbstar.kip.enbipba.xsql |

### 1.4 UIO 인터페이스 정의

- **참조 코드**: FUCorpGrpCrdtEvalHistProc.uio (XML)에서 메서드별 입/출력 필드를 고정 길이 기반으로 정의 (fixedLength="true"). 이는 COBOL COPYBOOK의 고정길이 필드 구조를 계승한 것이다.
- **C2J 코드**: UIO 정의 없음. 입출력 인터페이스가 Javadoc 주석으로만 문서화되어 있다.
- **영향**: UIO 파일이 없으면 프레임워크가 요청/응답 데이터의 자동 마샬링을 수행할 수 없어, 실환경 배포 시 문제가 발생할 수 있다.

---

## 2. PU(ProcessUnit) 상세 비교

### 2.1 클래스 기본 정보

| 항목 | 참조 PU | C2J PU |
|------|---------|--------|
| **클래스명** | PUCorpGrpCrdtEvalHistMgmt | PUCorpEvalHistory |
| **상속** | com.kbstar.sqc.base.ProcessUnit | com.kbstar.sqc.base.ProcessUnit |
| **행수** | 268행 | 225행 |
| **PM 메서드 수** | 3개 (pmKIP11A30E0, pmKIP04A4040, pmKIP04A3440) | 1개 (pmAipba30Xxxx01) |
| **@BizUnit** | @BizUnit(value="기업집단신용평가이력관리", type="PU") | @BizUnit("기업집단신용평가이력관리 ProcessUnit") |

### 2.2 메서드명 및 거래코드

| 참조 코드 | 거래코드 | C2J 코드 | 비고 |
|-----------|----------|----------|------|
| pmKIP11A30E0 | KIP11A30E0 | pmAipba30Xxxx01 | C2J: 거래코드 미확정, 임시명 사용 |
| pmKIP04A4040 | KIP04A4040 | 없음 | C2J: 미구현 |
| pmKIP04A3440 | KIP04A3440 | 없음 | C2J: 미구현 |

**원인 분석**: COBOL AIPBA30는 단일 프로그램이지만, 참조 코드에서는 AS 모듈 3개(AIPBA30, AIP4A40, AIP4A34)를 하나의 PU로 통합하여 3개 PM 메서드로 구현하였다. C2J는 AIPBA30.cbl 단일 파일만 변환 대상으로 삼아 1개 PM만 생성하였다.

### 2.3 입력값 검증 비교 (pmKIP11A30E0 vs pmAipba30Xxxx01)

**COBOL 원본 (AIPBA30 S2000-VALIDATION-RTN)**:
```
IF YNIPBA30-PRCSS-DSTCD = SPACE → #ERROR CO-B3800004 CO-UKIF0072
IF YNIPBA30-CORP-CLCT-GROUP-CD = SPACE → #ERROR CO-B3800004 CO-UKIF0072
IF YNIPBA30-VALUA-YMD = SPACE → #ERROR CO-B3800004 CO-UKIF0072
IF YNIPBA30-CORP-CLCT-REGI-CD = SPACE → #ERROR CO-B3800004 CO-UKIF0072
```

| 검증 항목 | COBOL 원본 | 참조 PU | C2J PU |
|-----------|-----------|---------|--------|
| 처리구분코드 | B3800004/UKIF0072 | B3800004/**UKIF0072** | B3800004/**UKIP0007** |
| 기업집단그룹코드 | B3800004/UKIF0072 | B3800004/**UKIP0001** | B3800004/**UKIP0001** |
| 평가년월일 | B3800004/UKIF0072 | B3800004/**UKIP0003** | B3800004/**UKIP0003** |
| 기업집단등록코드 | B3800004/UKIF0072 | B3800004/**UKIP0002** | B3800004/**UKIP0002** |
| 평가기준년월일(신규시) | DC에서 검증 | PU에서 검증(B3800004/UKIP0008) | DU로 위임 |

**분석**:
- COBOL 원본(AIPBA30)은 모든 검증에 CO-UKIF0072(범용 필수항목 오류 메시지) 사용
- 참조 코드는 처리구분에만 UKIF0072 사용, 나머지는 필드별 전용 조치코드(UKIP0001~0003) 사용 -- 이는 DIPA301(DC)의 S2000에서 필드별 조치코드를 사용하는 패턴을 AS 레벨로 끌어올린 것
- **C2J 코드(L138~167)가 DIPA301의 에러코드 체계를 더 정확하게 반영**하였다. 처리구분 검증에 UKIP0007을 사용한 것은 DIPA301 S2000(L292: CO-UKIP0007)과 정확히 일치한다.
- 참조 코드는 평가기준년월일 검증을 PU에서 수행하지만, C2J는 이를 DU로 위임한다. COBOL 원본에서는 이 검증이 DC(DIPA301 L303~311)에서 수행되므로 C2J의 구조가 원본에 더 가깝다.

### 2.4 CommonArea 활용 방식

| 항목 | 참조 PU | C2J PU |
|------|---------|--------|
| **CA 취득** | getCommonArea(onlineCtx) | getCommonArea(onlineCtx) |
| **그룹회사코드** | ca.getBiCom().getGroupCoCd() | ca.getGroupCoCd() |
| **직원번호** | ca.getBiCom().getUserEmpid() | ca.getUserEmpid() |
| **화면번호** | ca.getBiCom().getScrenNo() | ca.getScreenNo() |

**분석**: 참조 코드는 `getBiCom()` 중간 객체를 통해 접근하고, C2J는 직접 접근 방식을 사용한다. 이는 프레임워크 API 차이로 인한 것으로, 실제 프레임워크 버전에 따라 어느 쪽이 맞는지 확인이 필요하다.

### 2.5 FU/DU 호출 방식

**참조 PU (L110)**:
```java
@BizUnitBind private FUCorpGrpCrdtEvalHistProc fuCorpGrpCrdtEvalHistProc;
responseData = fuCorpGrpCrdtEvalHistProc.processCorpGrpCrdtEvalHist(requestData, onlineCtx);
```

**C2J PU (L48~49, L189)**:
```java
@BizUnitBind private DUCorpEvalHistoryA duCorpEvalHistoryA;
IDataSet duResult = duCorpEvalHistoryA.manageCorpEvalHistory(duParam, onlineCtx);
```

**분석**: 참조 코드는 PU->FU->DU 3단계로 호출하며, C2J는 PU->DU 2단계로 직접 호출한다. C2J의 PU에서는 requestData를 그대로 전달하지 않고, 별도 DataSet(duParam)에 필드별로 명시적 매핑하는 방식을 채택하였다 (L176~186). 이는 conversion_plan 5.2 지침을 따른 것으로, 방어적 프로그래밍 관점에서 양호하다.

### 2.6 예외처리 패턴

**참조 PU**:
```java
try {
    responseData = fuCorpGrpCrdtEvalHistProc.processCorpGrpCrdtEvalHist(requestData, onlineCtx);
    responseData.put("statusCode", "00");
} catch (BusinessException e) {
    throw e;
} catch (Exception e) {
    throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게...", e);
}
```

**C2J PU**:
```java
try {
    // ... DU 호출 및 응답 조립 ...
} catch (BusinessException e) {
    throw e;
} catch (Exception e) {
    throw new BusinessException(CCorpEvalConsts.ERR_B3900002, CCorpEvalConsts.TREAT_UKII0182, "...", e);
}
```

**분석**:
- 두 코드 모두 동일한 try-catch-rethrow 패턴을 사용 (정상)
- 참조 코드: 시스템 오류 에러코드 "B3900042" (비표준)
- C2J 코드: 에러코드 "B3900002" (COBOL 원본 CO-B3900002와 일치). **C2J가 원본에 더 충실**

### 2.7 응답 데이터 조립

**참조 PU**: `responseData.put("statusCode", "00")` 추가
**C2J PU**: `responseData.put("formId", ...)` 추가, statusCode 없음

**COBOL 원본 (AIPBA30 L233~242)**:
```cobol
MOVE XDIPA301-OUT TO YPIPBA30-CA.
MOVE 'V1' TO WK-FMID(1:2).
MOVE BICOM-SCREN-NO TO WK-FMID(3:11).
#BOFMID WK-FMID.
```

**분석**: C2J가 COBOL 원본의 폼ID 설정을 정확히 구현하였다. 참조 코드도 폼ID를 설정하나 statusCode를 추가로 넣은 것은 원본에 없는 추가 기능이다.

---

## 3. FU(FunctionUnit) vs DU 비즈니스 로직 비교

### 3.1 역할 분담 차이

**참조 코드 FU (FUCorpGrpCrdtEvalHistProc)가 담당하는 역할:**
1. 처리구분별 분기 ('01'/'02'/'03') -- processCorpGrpCrdtEvalHist 메서드
2. 이력조회 시 추가 정보 가공 -- getCorpGrpCrdtEvalHist 메서드
3. 신규평가 시 중복확인, 직원정보 조회, 주채무계열 조회 통합 처리
4. 12개 DU 호출 오케스트레이션 (연쇄삭제)
5. 코드 해석 (인스턴스 코드 -> 한글명 변환)

**C2J DU (DUCorpEvalHistoryA)가 통합한 역할:**
1. 처리구분별 분기 -- manageCorpEvalHistory 메서드 (DM 진입점)
2. 신규평가 INSERT (기존재 확인 + 주채무계열 조회 + 직원정보 조회 포함)
3. 11개 테이블 연쇄 DELETE (각 테이블별 private 메서드)
4. SQL 매핑 (XSQL XML 파일 연동)

**분석**: C2J 코드는 FU 없이 DU가 비즈니스 로직과 데이터 접근을 모두 담당한다. 이는 COBOL DC(DIPA301)가 업무로직+DB접근을 모두 포함하고 있어 이를 그대로 1:1 변환한 결과이다. n-KESA 표준에서는 DU에 비즈니스 로직을 넣지 않아야 하므로 구조적 개선이 필요하다.

### 3.2 처리구분별 분기 로직 비교

**COBOL 원본 (DIPA301 L240~248)**:
```cobol
EVALUATE XDIPA301-I-PRCSS-DSTCD
    WHEN '01' PERFORM S3000-PROCESS-RTN
    WHEN '02'
    WHEN '03' PERFORM S4000-PROCESS-RTN
END-EVALUATE.
```
- '02'와 '03'은 동일한 S4000-PROCESS-RTN을 수행 (WHEN 절 fall-through)

**참조 FU (L366~378)**:
```java
if ("01".equals(prcssDstcd)) {
    responseData = _createNewCorpGrpCrdtEval(requestData, onlineCtx);
} else if ("02".equals(prcssDstcd)) {
    responseData = _deleteCorpGrpCrdtEval(requestData, onlineCtx);  // 삭제와 동일
} else if ("03".equals(prcssDstcd)) {
    responseData = _deleteCorpGrpCrdtEval(requestData, onlineCtx);
}
```

**C2J DU (L87~110)**:
```java
if (CCorpEvalConsts.PRCSS_DSTCD_NEW.equals(prcssDstcd)) {          // '01'
    _insertCorpEvalHistory(requestData, onlineCtx);
} else if (CCorpEvalConsts.PRCSS_DSTCD_CANCEL.equals(prcssDstcd)) { // '02'
    log.debug("확정취소 처리 - 현재 무동작 (TBD)");                    // 무동작
} else if (CCorpEvalConsts.PRCSS_DSTCD_DELETE.equals(prcssDstcd)) { // '03'
    _deleteCorpEvalHistoryAll(requestData, onlineCtx);
}
```

**분석**:
- COBOL 원본에서 '02'와 '03'은 같은 처리(S4000)를 수행
- 참조 코드는 원본을 정확히 반영 ('02'와 '03' 모두 _deleteCorpGrpCrdtEval 호출)
- **C2J 코드는 '02'를 무동작으로 구현하여 COBOL 원본과 상이**. 이는 명확한 버그이다.
- C2J는 상수 클래스를 활용하여 매직넘버를 제거한 점은 참조 코드보다 우수

### 3.3 신규평가 INSERT 로직 비교

**COBOL 원본 (DIPA301 S3000~S3220)의 처리 순서**:
1. S3100: QIPA301 기존재 확인 (확정 '6' 기준)
2. S3200: THKIPB110 INSERT
   - S3210: PK SET
   - S3220: REC SET (QIPA307 주채무계열 조회 + QIPA302 직원정보 조회 포함)

| 처리 단계 | 참조 FU | C2J DU | COBOL 원본 |
|-----------|---------|--------|-----------|
| 기존재 확인 | duTSKIPA111.select() 호출 | _selectExistCheck() - SQLIO QIPA301 역설계 | QIPA301 SQLIO |
| 주채무계열 조회 | duTSKIPA111.select() 결과에서 판단 | _selectMainDebtAffltYn() - QIPA307 역설계 | QIPA307 SQLIO |
| 직원정보 조회 | TODO 주석 (미구현) | _selectEmployeeInfo() - QIPA302 역설계 | QIPA302 SQLIO |
| INSERT 실행 | duTSKIPB110.insert() 호출 | dbInsert("insertThkipb110") 직접 호출 | DBIO INSERT-CMD-Y |

**기존재 확인 차이**:
- 참조 코드: DUTSKIPA111(기업관계연결정보)를 조회하여 prcssStgeDstcd='6' 여부 확인 -- COBOL QIPA301이 THKIPA111을 조회한다고 해석
- C2J 코드: THKIPB110을 직접 COUNT(*) 조회하여 CORP_CP_STGE_DSTCD='6' 확인 -- COBOL QIPA301이 THKIPB110을 조회한다고 해석
- COBOL 원본 QIPA301 SQLIO 소스가 미확보이므로 어느 쪽이 정확한지는 검증 불가

**INSERT 파라미터 비교**:

| 파라미터 | 참조 FU | C2J DU | COBOL 원본 |
|---------|---------|--------|-----------|
| groupCoCd | BICOM에서 취득 | requestData.getString("groupCoCd") | BICOM-GROUP-CO-CD |
| corpClctGroupCd | requestData | requestData | XDIPA301-I-CORP-CLCT-GROUP-CD |
| corpCpStgeDstcd | "1" (초기단계) | "0" (해당무) | '0' (해당무) |
| corpCValuaDstcd | "0" | "0" | '0' |
| valuaDefinsYmd | 설정 안함 | null 허용 | SPACE |
| valuaEmpid | ca.getBiCom().getUserEmpid() | requestData.getString("userEmpid") | BICOM-USER-EMPID |
| valuaBrncd | ca.getBiCom().getBrncd() | QIPA302 결과의 belngBrncd | BICOM-BRNCD |

**핵심 차이**:
- **corpCpStgeDstcd**: 참조 코드는 "1"(초기단계), C2J는 "0"(해당무), COBOL 원본은 '0'. **C2J가 COBOL 원본과 일치**
- **valuaBrncd**: 참조 코드는 BICOM의 거래부점(BRNCD), C2J는 직원기본조회 결과의 소속부점(BELNG-BRNCD). COBOL 원본(L596~597)에서는 `MOVE BICOM-BRNCD TO RIPB110-VALUA-BRNCD`로 **거래부점**을 사용. 따라서 **참조 코드가 COBOL 원본과 일치**

### 3.4 삭제 로직 비교

**COBOL 원본 (DIPA301 S4000~S42E1) 삭제 순서**:
S4210: THKIPB110 (SELECT FOR UPDATE + DELETE)
S4220: THKIPB111 (CURSOR OPEN-FETCH-DELETE-CLOSE)
S4230: THKIPB116 (CURSOR OPEN-FETCH-DELETE-CLOSE)
S4240/41: THKIPB113 (SQLIO PK조회 + SELECT FOR UPDATE + DELETE)
S4250/51: THKIPB112 (SQLIO PK조회 + SELECT FOR UPDATE + DELETE)
S4260: THKIPB114 (CURSOR OPEN-FETCH-DELETE-CLOSE)
S4290: THKIPB118 (SELECT FOR UPDATE + DELETE)
S42A0/A1: THKIPB130 (SQLIO PK조회 + SELECT FOR UPDATE + DELETE)
S42B0: THKIPB131 (SELECT FOR UPDATE + DELETE)
S42C0: THKIPB132 (CURSOR OPEN-FETCH-DELETE-CLOSE)
S42D0/D1: THKIPB133 (SQLIO PK조회 + SELECT FOR UPDATE + DELETE)
S42E0/E1: THKIPB119 (SQLIO PK조회 + SELECT FOR UPDATE + DELETE)

**참조 FU 삭제 순서 (L513~547)**:
```
duTSKIPB110.delete → duTSKIPB111.delete → duTSKIPB112.delete → duTSKIPB113.delete →
duTSKIPB114.delete → duTSKIPB116.delete → duTSKIPB118.delete → duTSKIPB119.delete →
duTSKIPB130.delete → duTSKIPB131.delete → duTSKIPB132.delete → duTSKIPB133.delete
```
- 12개 DU의 delete 메서드를 순차 호출 (단순 dbDelete 호출)
- **SELECT FOR UPDATE 패턴 없음** (COBOL 원본의 LOCK 패턴 미반영)
- **CURSOR 패턴 미반영** (일괄 삭제로 변환)

**C2J DU 삭제 순서 (L394~431)**:
```
_deleteThkipb110 → _deleteThkipb111Loop → _deleteThkipb116Loop →
_deleteThkipb113 → _deleteThkipb112 → _deleteThkipb114Loop →
_deleteThkipb118 → _deleteThkipb130 → _deleteThkipb131 →
_deleteThkipb132Loop → _deleteThkipb133 → _deleteThkipb119
```
- **COBOL 원본 삭제 순서를 정확히 반영**
- **SELECT FOR UPDATE 패턴 반영** (LOCK SELECT 후 DELETE)
- **CURSOR 패턴 반영** (dbSelectMulti → IRecordSet 루프 → 건별 DELETE)
- **SQLIO PK조회 패턴 반영** (QIPA303~308 역설계 SQL로 PK 목록 조회 후 건별 처리)

**분석**: C2J 코드가 COBOL 원본의 DELETE 패턴(SELECT FOR UPDATE, CURSOR 루프, SQLIO PK 조회)을 참조 코드보다 훨씬 정확하게 변환하였다. 참조 코드는 모든 삭제를 단순 dbDelete 한 번으로 처리하여 COBOL 원본의 행 수준 LOCK 및 건별 삭제 패턴이 누락되었다.

---

## 4. DU(DataUnit) 상세 비교

### 4.1 클래스 분리 전략

**참조 코드: 테이블별 DU (12개)**

| DU 클래스 | 테이블 | 행수 | CRUD 메서드 |
|-----------|--------|------|-------------|
| DUTSKIPB110 | THKIPB110(기업집단평가기본) | 303행 | selectList, selectListHist, insert, delete, select, update |
| DUTSKIPB111 | THKIPB111(기업집단연혁명세) | 249행 | select, selectNewEvalHistory, insert, update, delete |
| DUTSKIPB112 | THKIPB112(기업집단재무분석목록) | 271행 | select, selectList, insert, update, delete |
| DUTSKIPB113 | THKIPB113(기업집단사업부분구조분석명세) | 177행 | selectCorpGrpBizSectAnal, insertCorpGrpBizSectAnal, updateCorpGrpBizSectAnal, deleteCorpGrpBizSectAnal |
| DUTSKIPB114 | THKIPB114(기업집단항목별평가목록) | 219행 | select, selectList, insert, update, deleteByCorpGrp |
| DUTSKIPB116 | THKIPB116(기업집단계열사명세) | 120행 | delete, insert |
| DUTSKIPB118 | THKIPB118(기업집단평가등급조정사유목록) | 109행 | select, delete |
| DUTSKIPB119 | THKIPB119(재무비율산출명세) | 246행 | select, selectList, selectFinancialRatios, insert, update |
| DUTSKIPB130 | THKIPB130(기업집단주석명세) | 192행 | select, insert, delete, deleteCorpGrpComment |
| DUTSKIPB131 | THKIPB131(기업집단승인결의록명세) | 136행 | select |
| DUTSKIPB132 | THKIPB132(기업집단승인결의록위원명세) | 248행 | select, selectList, insert, update, delete |
| DUTSKIPB133 | THKIPB133(기업집단승인결의록의견명세) | 295행 | select, selectLatest, selectList, insert, update, delete |
| DUTSKIPA111 | THKIPA111(기업관계연결정보) | 258행 | selectByCode, selectByName, insert, select |

**C2J 코드: 통합 DU (1개)**

| DU 클래스 | 테이블 | 행수 | 외부 메서드 + private 메서드 |
|-----------|--------|------|------------------------------|
| DUCorpEvalHistoryA | 12개 테이블 통합 | 1,038행 | manageCorpEvalHistory(DM) + _insertCorpEvalHistory, _deleteCorpEvalHistoryAll, _selectExistCheck, _selectMainDebtAffltYn, _selectEmployeeInfo, _deleteThkipb110~119 등 15개 private |

### 4.2 dbInsert/dbSelect/dbDelete 호출 패턴

**참조 DU** (예: DUTSKIPB110, L176~186):
```java
@BizMethod("기업집단평가기본 테이블 INSERT")
public int insert(IDataSet requestData, IOnlineContext onlineCtx) {
    try {
        int insertCount = dbInsert("insert", requestData, onlineCtx);
        return insertCount;
    } catch ...
}
```
- dbInsert/dbSelect/dbDelete에 **3개 파라미터** 전달 (sqlId, requestData, onlineCtx)
- @BizMethod 어노테이션으로 외부 공개

**C2J DU** (예: L264):
```java
int rows = dbInsert("insertThkipb110", insertParam);
```
- dbInsert/dbSelect/dbDelete에 **2개 파라미터** 전달 (sqlId, param) -- onlineCtx 누락
- private 메서드 내에서 직접 호출, @BizMethod는 manageCorpEvalHistory만 보유

**분석**: C2J의 dbInsert/dbSelect/dbDelete 호출에서 onlineCtx 파라미터가 누락되어 있다. n-KESA DataUnit의 dbInsert/dbSelect/dbDelete API가 2파라미터를 지원하는지 확인이 필요하며, 일반적으로 3파라미터(onlineCtx 포함)가 표준이다.

### 4.3 SELECT FOR UPDATE / CURSOR 패턴

**참조 DU**: SELECT FOR UPDATE 패턴 없음. 모든 삭제가 단순 dbDelete 한 번 호출.

**C2J DU**: COBOL 원본의 3가지 패턴을 충실히 변환:
1. **SELECT FOR UPDATE + DELETE** (THKIPB110, THKIPB118, THKIPB131): selectForUpdate로 LOCK 후 delete
2. **CURSOR LOOP DELETE** (THKIPB111, THKIPB116, THKIPB114, THKIPB132): dbSelectMulti로 목록 조회 후 건별 delete
3. **SQLIO PK조회 + SELECT FOR UPDATE + DELETE** (THKIPB113, THKIPB112, THKIPB130, THKIPB133, THKIPB119): PK 목록 SQLIO 조회 → 건별 LOCK SELECT → 건별 delete

### 4.4 에러 처리 패턴

**참조 DU**: 일관된 try-catch-rethrow. 에러코드는 DU마다 다름 (B3500001, B3900009, B3100001 등)

**C2J DU**: CCorpEvalConsts 상수 활용. 에러코드 체계가 COBOL 원본과 일치 (B3900002, B4200023, B4200219, B3900009)

---

## 5. SQL/XSQL 비교

### 5.1 참조 코드 SQL 구조

참조 코드에는 별도의 XSQL/SQL XML 파일이 없다. DU 클래스의 dbSelect("select",...) 등에서 SQL 매핑 ID만 참조하며, 실제 SQL 파일은 프로젝트 외부 또는 프레임워크에서 관리되는 것으로 보인다.

### 5.2 C2J XSQL 구조

`DUCorpEvalHistoryA.xml` (665행, 34개 SQL문):

| SQL ID | 대응 COBOL | 유형 | 설명 |
|--------|-----------|------|------|
| selectExistCheckQipa301 | QIPA301 | SELECT | 기존재 확인 COUNT(*) |
| selectMainDebtAffltYnQipa307 | QIPA307 | SELECT | 주채무계열여부 조회 |
| selectEmployeeInfoQipa302 | QIPA302 | SELECT | 직원기본정보 조회 |
| insertThkipb110 | S3200 DBIO INSERT | INSERT | 27개 컬럼 신규 INSERT |
| selectThkipb110ForUpdate | S4210 SELECT-CMD-Y | SELECT | LOCK SELECT |
| deleteThkipb110 | S4210 DELETE-CMD-Y | DELETE | 4개 PK 조건 삭제 |
| selectListThkipb111ForUpdate | S4220 OPEN CURSOR | SELECT | FOR UPDATE 목록 |
| deleteThkipb111 | S4220 DELETE-CMD-Y | DELETE | 6개 PK 조건 건별 삭제 |
| ... (이하 테이블별 반복 패턴) | | | |

**특징**:
- 모든 SQL에 COBOL 원본 대응 구문 주석 (예: "대상 COBOL: S3100-QIPA301-CALL-RTN")
- SQLIO 소스 미확보 SQL에 TODO 태그 명시 ("TODO: [변환 불가] SQLIO QIPA301 소스 미확보")
- 바인드 변수 형식: `#fieldName:TYPE#` (nKESA sqlMap 표준)
- COMMIT/ROLLBACK 금지 주석 명시

### 5.3 바인드 변수 처리 차이

| 항목 | 참조 코드 | C2J 코드 |
|------|-----------|----------|
| **바인드 변수 형식** | 확인 불가 (SQL 파일 없음) | #fieldName:VARCHAR# / #fieldName:NUMERIC# |
| **타입 명시** | N/A | VARCHAR, NUMERIC 명시 |
| **스키마 명시** | N/A | BANKDB.THKIPB110 형태로 스키마 포함 |

---

## 6. 네이밍 컨벤션 비교

### 6.1 클래스명

| 항목 | 참조 코드 | C2J 코드 | 평가 |
|------|-----------|----------|------|
| PU | PUCorpGrpCrdtEvalHistMgmt | PUCorpEvalHistory | 참조: 더 상세, C2J: 간결 |
| FU | FUCorpGrpCrdtEvalHistProc | 없음 | - |
| DU | DUTSKIPB110 (COBOL 테이블명 보존) | DUCorpEvalHistoryA (의미 기반) | 참조: COBOL명 보존, C2J: 가독성 우선 |

### 6.2 메서드명

| 항목 | 참조 코드 | C2J 코드 |
|------|-----------|----------|
| PU PM | pmKIP11A30E0 (거래코드 기반) | pmAipba30Xxxx01 (프로그램명 기반, 임시) |
| FU 메서드 | processCorpGrpCrdtEvalHist, getCorpGrpCrdtEvalHist | 없음 |
| DU 메서드 | select, insert, delete (CRUD 동사) | manageCorpEvalHistory (통합 진입점) |
| private 메서드 | _createNewCorpGrpCrdtEval | _insertCorpEvalHistory |

### 6.3 변수명

| 항목 | 참조 코드 | C2J 코드 |
|------|-----------|----------|
| 상수 | 하드코딩 ("B3800004", "01") | CCorpEvalConsts.ERR_B3800004, PRCSS_DSTCD_NEW |
| 필드명 | COBOL 변환명 유지 (corpClctGroupCd) | 동일 (corpClctGroupCd) |
| COBOL 섹션명 | 주석으로 참조 (BR-052-001) | 주석으로 참조 (COBOL S0000-MAIN-RTN 대응) |

### 6.4 COBOL 원본명 보존 방식

- **참조 코드**: DU 클래스명에 COBOL 테이블 SYNONYM 보존 (DUTSKIPB110). 비즈니스 로직 클래스명은 의미 기반.
- **C2J 코드**: 클래스명은 모두 의미 기반. COBOL 원본명은 Javadoc과 주석에 보존 ("COBOL DIPA301.cbl (DC 프로그램, 1985행)을 n-KESA DataUnit으로 변환"). XSQL ID에 COBOL SQLIO명 보존 (selectExistCheckQipa301).

---

## 7. 코드 품질 비교

### 7.1 코드 라인 수

| 구성 요소 | 참조 코드 | C2J 코드 |
|-----------|-----------|----------|
| PU | 268행 | 225행 |
| FU | 657행 | 없음 |
| DU (전체) | 2,534행 (12+1파일) | 1,038행 (1파일) |
| 상수 | 0행 | 135행 |
| UIO | 44행 | 0행 |
| XSQL | 0행 (외부 관리) | 665행 |
| **합계** | **3,503행 (16파일)** | **2,063행 (4파일)** |

### 7.2 재사용성

| 항목 | 참조 코드 | C2J 코드 | 평가 |
|------|-----------|----------|------|
| DU 재사용성 | 높음 (테이블별 DU는 다른 FU/PU에서도 사용 가능) | 낮음 (통합 DU는 현재 거래에만 사용 가능) | 참조 > C2J |
| 상수 재사용성 | 낮음 (하드코딩) | 높음 (CCorpEvalConsts 중앙화) | C2J > 참조 |
| FU 재사용성 | 보통 (비즈니스 로직 분리로 재구성 용이) | N/A | - |

### 7.3 테스트 용이성

| 항목 | 참조 코드 | C2J 코드 |
|------|-----------|----------|
| **단위 테스트** | 높음 (테이블별 DU를 Mock 가능, FU 단위 테스트 용이) | 낮음 (통합 DU 내 private 메서드 테스트 불가) |
| **통합 테스트** | 보통 (다수 DU 의존성 설정 필요) | 높음 (단일 DU만 설정하면 됨) |
| **Mock 난이도** | 12개 DU Mock 필요 | 1개 DU Mock으로 충분 |

### 7.4 유지보수성

| 항목 | 참조 코드 | C2J 코드 |
|------|-----------|----------|
| **테이블 스키마 변경** | 해당 DU만 수정 | 통합 DU 전체 영향도 분석 필요 |
| **비즈니스 로직 변경** | FU만 수정, DU 불변 | DU 내 변경, 데이터/로직 혼재로 리스크 |
| **신규 거래 추가** | 기존 DU 재활용 가능 | 새 DU 또는 기존 DU 확장 필요 |
| **추적성** | 계층별 분리로 변경 추적 용이 | COBOL 원본 주석으로 추적성 확보 |

---

## 8. C2J 코드 개선 사항

### HIGH (즉시 수정 필요)

| # | 항목 | 상세 | 파일/라인 |
|---|------|------|-----------|
| H1 | **처리구분 '02' 확정취소 로직 누락** | COBOL 원본에서 '02'는 '03'과 동일한 S4000(삭제) 수행. C2J는 무동작으로 구현. 비즈니스 로직 오류. | DUCorpEvalHistoryA.java L92~97 |
| H2 | **FU 계층 누락** | n-KESA 표준 3계층(PU/FU/DU) 구조 위반. DU에 비즈니스 로직이 포함되어 있음. FUCorpEvalHistoryA를 분리 필요. | 아키텍처 전체 |
| H3 | **UIO 파일 미생성** | 프레임워크 자동 마샬링을 위해 FUCorpEvalHistoryA.uio (또는 PUCorpEvalHistory.uio) XML 파일 필요. | 누락 파일 |
| H4 | **dbInsert/dbSelect 호출 시 onlineCtx 누락** | DU 내 DB 접근 메서드에 onlineCtx 파라미터 미전달. 프레임워크 트랜잭션/로깅 동작 불가 가능성. | DUCorpEvalHistoryA.java L264, L300 등 다수 |
| H5 | **거래코드 미확정** | pmAipba30Xxxx01은 임시명. 실제 거래코드(KIP11A30E0) 확정 후 메서드명 변경 필요. | PUCorpEvalHistory.java L89 |

### MEDIUM (조기 수정 권장)

| # | 항목 | 상세 | 파일/라인 |
|---|------|------|-----------|
| M1 | **valuaBrncd 매핑 오류** | C2J는 직원조회 결과의 소속부점(belngBrncd)을 사용하나, COBOL 원본은 거래부점(BICOM-BRNCD)을 사용. | DUCorpEvalHistoryA.java L255 |
| M2 | **PM 메서드 2개 미구현** | 참조 코드의 pmKIP04A4040(신용등급모니터링), pmKIP04A3440(평가이력조회) 미구현. AIPBA30 외 AS 모듈(AIP4A40, AIP4A34) 변환 필요. | PUCorpEvalHistory.java |
| M3 | **@BizUnit 어노테이션 형식** | 참조 코드는 type="DU" 지정. C2J는 type 미지정. n-KESA 표준 확인 필요. | DUCorpEvalHistoryA.java L41 |
| M4 | **삭제 시 건수 반환 누락** | COBOL 원본에서 삭제 후 출력 건수(XDIPA301-O-TOTAL-NOITM) 설정 로직 미구현. | DUCorpEvalHistoryA.java L114~117 |
| M5 | **기존재 확인 로직 이중 검증** | C2J PU에서 필수값 검증 후, DU에서도 검증(DIPA301 S2000 반영). 이는 COBOL 원본의 AS+DC 이중 검증을 그대로 반영한 것이나, Java에서는 PU 1회 검증으로 충분. | 구조적 |

### LOW (향후 개선)

| # | 항목 | 상세 | 파일/라인 |
|---|------|------|-----------|
| L1 | **log.debug에 한글 별표(★) 사용** | 프로덕션 로그에 부적합. 영문 태그 또는 구조화 로깅 권장. | DUCorpEvalHistoryA.java 다수 |
| L2 | **SQLIO 소스 미확보 TODO 산재** | QIPA301~308 SQLIO 소스 미확보로 SQL이 역설계 기반. 실제 SQL과 대조 검증 필요. | DUCorpEvalHistoryA.xml 다수 |
| L3 | **final 키워드 미사용** | CCorpEvalConsts 상수가 final 아닌 static으로 선언. 핫디플로이 목적이나, 실수로 값 변경 위험. | CCorpEvalConsts.java |
| L4 | **NullPointerException 위험** | DUCorpEvalHistoryA L82: prcssDstcd.replaceAll() 호출 시 null 체크 없음. PU에서 검증하지만 방어적 코딩 미흡. | DUCorpEvalHistoryA.java L82 |

---

## 9. 참조 코드의 한계점

| # | 항목 | 상세 |
|---|------|------|
| R1 | **SELECT FOR UPDATE 패턴 미반영** | COBOL 원본의 행 수준 LOCK 패턴이 모든 DU에서 누락. 동시성 제어 부재로 데이터 무결성 위험. |
| R2 | **CURSOR 루프 DELETE 패턴 미반영** | 다건 삭제 시 단순 dbDelete 한 번으로 처리. COBOL 원본의 건별 삭제 + 오류 처리 누락. |
| R3 | **에러코드 불일치** | 시스템 오류 코드 B3900042는 COBOL 원본(B3900002)과 불일치. |
| R4 | **매직넘버 하드코딩** | "01", "02", "03", "6", "B3800004" 등 상수가 모두 문자열 리터럴로 하드코딩. |
| R5 | **corpCpStgeDstcd 초기값 오류** | 신규평가 시 "1"(초기단계)로 설정하나, COBOL 원본은 '0'(해당무). |
| R6 | **XSQL 파일 미포함** | SQL 매핑 파일이 프로젝트에 포함되지 않아 SQL 검증 불가. |
| R7 | **직원정보 조회 TODO 미구현** | FU 내 직원명 조회(L464~472)가 TODO 주석으로 미구현 상태. |
| R8 | **인스턴스 코드 해석 하드코딩** | FU 내 _resolveInstanceCode 메서드(L265~324)가 switch-case 하드코딩. FUBcCode 공통 모듈 호출 미구현. |
| R9 | **FU에 비즈니스 로직 과다** | FU에 조회/가공/삭제 오케스트레이션이 모두 포함되어 650행 이상. 비즈니스 로직 분리 검토 필요. |

---

## 10. 종합 점수 및 평가

### 10.1 항목별 점수 (100점 만점)

| 평가 항목 | 참조 코드 | C2J 코드 | 비고 |
|-----------|:---------:|:--------:|------|
| n-KESA 아키텍처 준수 | **80** | **45** | 참조: 3계층 구현, C2J: FU 누락 |
| COBOL 원본 충실도 | **60** | **85** | C2J: 삭제 패턴, 에러코드 등 원본에 더 충실 |
| 입력값 검증 정확도 | **70** | **80** | C2J: DIPA301의 에러코드 체계 정확 반영 |
| 비즈니스 로직 완성도 | **75** | **60** | C2J: '02' 확정취소 누락, PM 2개 미구현 |
| DU 설계 적절성 | **85** | **50** | 참조: 테이블별 분리 재사용성 높음 |
| SQL/DB 접근 패턴 | **55** | **90** | C2J: FOR UPDATE, CURSOR 패턴 충실 반영 |
| 네이밍 컨벤션 | **75** | **70** | 참조: 거래코드 명확, C2J: 임시명 |
| 예외처리 | **75** | **80** | C2J: COBOL 원본 에러코드 정확 매핑 |
| 코드 품질/가독성 | **70** | **75** | C2J: 상수 클래스, COBOL 추적 주석 우수 |
| 재사용성 | **80** | **40** | 참조: 테이블별 DU 재사용 가능 |
| 테스트 용이성 | **80** | **50** | 참조: 계층 분리로 Mock 용이 |
| 유지보수성 | **75** | **60** | 참조: 계층별 변경 격리 |
| 추적성(Traceability) | **65** | **90** | C2J: COBOL 섹션별 대응 주석 상세 |
| 산출물 완성도 | **60** | **70** | C2J: XSQL 포함, 참조: UIO 포함 |
| **종합 평균** | **71.8** | **67.5** | |

### 10.2 종합 평가

**참조 코드 (71.8점)**:
- n-KESA 표준 3계층(PU/FU/DU) 구조를 올바르게 적용
- 테이블별 DU 분리로 재사용성과 테스트 용이성 확보
- UIO 인터페이스 정의 파일 제공
- 단, COBOL 원본의 SELECT FOR UPDATE/CURSOR 패턴 미반영, 에러코드 불일치, 상수 하드코딩 등의 한계 존재

**C2J 코드 (67.5점)**:
- COBOL 원본의 처리 순서, 삭제 패턴, 에러코드 체계를 높은 충실도로 변환
- 상수 클래스(CCorpEvalConsts) 중앙화, XSQL 파일 자동 생성, COBOL 추적 주석 등 우수한 변환 품질
- SQLIO 소스 미확보에도 불구하고 SQL 역설계를 통해 실용적인 SQL 생성
- 단, FU 계층 누락으로 n-KESA 표준 미준수, DU에 비즈니스 로직 혼재, 처리구분 '02' 누락 등 구조적 개선 필요

**결론**:
두 접근법은 서로 상보적 강점을 갖는다. 참조 코드는 **아키텍처 설계**에서 우수하고, C2J 코드는 **COBOL 원본 변환 충실도**에서 우수하다. 최적의 결과물은 C2J 코드의 COBOL 충실 변환(삭제 패턴, 에러코드, 상수 관리, SQL)을 기반으로, 참조 코드의 아키텍처(FU 분리, 테이블별 DU, UIO)를 적용하는 것이다.

**우선 조치 사항**:
1. [긴급] 처리구분 '02' 확정취소 로직 수정 (COBOL 원본처럼 '03'과 동일한 삭제 처리)
2. [중요] FUCorpEvalHistoryA 추출 (DU에서 비즈니스 로직 분리)
3. [중요] UIO 파일 생성
4. [중요] dbInsert/dbSelect 호출에 onlineCtx 추가
5. [보통] valuaBrncd를 거래부점(BICOM-BRNCD)으로 변경
