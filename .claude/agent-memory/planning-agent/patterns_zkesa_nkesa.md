---
name: zKESA→nKESA 반복 변환 패턴
description: planning-agent가 변환 설계서 작성 시 반복적으로 적용하는 z-KESA→n-KESA 패턴 및 결정 사항
type: project
---

## 프레임워크 계층 매핑 (확정)

| zKESA | nKESA | 패키지 위치 |
|-------|-------|-----------|
| AS 프로그램 | ProcessUnit (PU) + PM 메서드 | biz/ |
| DC 프로그램 | DataUnit (DU) + DM 메서드 | biz/ |
| IC/FC/BC 프로그램 | FunctionUnit (FU) + FM 메서드 | 공통 컴포넌트 |
| DBIO SELECT | dbSelect() / dbSelectMulti() | DU 내장 |
| DBIO INSERT/UPDATE/DELETE | dbInsert() / dbUpdate() / dbDelete() | DU 내장 |
| SQLIO (복합 SELECT) | XSQL XML에 복합 SQL 작성 + dbSelectMulti() | xsql/ |
| DBIO OPEN-FETCH-CLOSE | dbSelectMulti() + IRecordSet 루프 | 커서 전체 대체 |
| #ERROR | throw new BusinessException(errCd, treatCd, msg) | |
| #OKEXIT | return responseData | |
| #GETOUT | IDataSet responseData = new DataSet() | |
| #USRLOG | log.debug() | ILog log = getLog(onlineCtx) |
| #DYCALL (동일 컴포넌트) | @BizUnitBind + 직접 메서드 호출 | |
| #DYCALL (타 컴포넌트) | callSharedMethodByDirect(componentId, "FU.method", req, ctx) | |
| YCCOMMON-CA | IOnlineContext + CommonArea | getCommonArea(onlineCtx) |
| CO-AREA 상수 | CXxxConsts 상수 클래스 (public static, final 금지) | consts/ |
| WK-AREA 변수 | 메서드 내 로컬 변수 (멤버 필드 절대 금지) | |
| PIC X(n) | String | |
| PIC 9(n) | int/long | |
| PIC S9(n)V9(m) | BigDecimal (BigDecimal.valueOf() 또는 new BigDecimal("") 사용) | |
| OCCURS | IRecordSet + IRecord | |

## 패키지 네이밍 규칙 (확정)

com.kbstar.[appCode3].[componentId]/
├── biz/     ← PU, FU, DU
├── uio/     ← PM/FM/DM IO 정보 XML
├── xsql/    ← SQL XML (DU와 1:1)
├── consts/  ← C + CamelCase + Consts
└── util/    ← POJO 유틸리티

## 공통 유틸리티 호출 컴포넌트 ID

callSharedMethodByDirect 시 첫 번째 인자: "com.kbstar.kji.enbncmn"

## 중요 코딩 제약

- Unit 클래스 싱글톤: 인스턴스 변수 금지, @BizUnitBind 필드만 허용
- Commit/Rollback 직접 호출 절대 금지
- PM: try-catch 필수 (BusinessException re-throw, Exception wrap)
- DM: try-catch 불필요, 직접 throw BusinessException 가능
- DM에서 다른 DU 호출 금지
- 상수 클래스 final 키워드 금지 (핫 디플로이 이유)
- 원본 requestData 직접 전달 금지: new DataSet()으로 복사 후 전달

## 변환 순서 원칙

Bottom-Up: 상수 클래스 → DU + XSQL → PU (의존 관계 역방향)
