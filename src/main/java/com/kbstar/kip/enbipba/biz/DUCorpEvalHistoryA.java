package com.kbstar.kip.enbipba.biz;

import com.kbstar.kip.enbipba.consts.CCorpEvalConsts;
import com.kbstar.sqc.base.DataUnit;
import com.kbstar.sqc.framework.annotation.BizUnit;
import com.kbstar.sqc.framework.annotation.BizMethod;
import com.kbstar.sqc.framework.context.IOnlineContext;
import com.kbstar.sqc.framework.data.IDataSet;
import com.kbstar.sqc.framework.data.IRecord;
import com.kbstar.sqc.framework.data.IRecordSet;
import com.kbstar.sqc.framework.data.impl.DataSet;
import com.kbstar.sqc.framework.exception.BusinessException;
import com.kbstar.sqc.framework.log.ILog;

/**
 * 기업집단신용평가이력관리 DataUnit
 *
 * <p>COBOL DIPA301.cbl (DC 프로그램, 1985행)을 n-KESA DataUnit으로 변환한 클래스이다.</p>
 *
 * <p>처리구분별 DB 접근 처리:
 * <ul>
 *   <li>처리구분 '01' (신규평가): 기존재 확인 후 THKIPB110 INSERT</li>
 *   <li>처리구분 '02' (확정취소): 무동작 처리 (TBD - 업무팀 확인 필요)</li>
 *   <li>처리구분 '03' (삭제): 11개 테이블 순차 DELETE</li>
 * </ul>
 * </p>
 *
 * <p>대상 테이블:
 * THKIPB110(기업집단평가기본), THKIPB111(기업집단연혁명세), THKIPB116(기업집단계열사명세),
 * THKIPB113(기업집단사업부분구조분석명세), THKIPB112(기업집단재무분석목록),
 * THKIPB114(기업집단항목별평가목록), THKIPB118(기업집단평가등급조정사유목록),
 * THKIPB130(기업집단주석명세), THKIPB131(기업집단승인결의록명세),
 * THKIPB132(기업집단승인결의록위원명세), THKIPB133(기업집단승인결의록의견명세),
 * THKIPB119(기업집단재무평점단계별목록)
 * </p>
 *
 * @author conversion-agent
 * @version 1.0
 * @since 2026-03-13
 */
@BizUnit("기업집단신용평가이력관리 DataUnit")
public class DUCorpEvalHistoryA extends DataUnit {

    // ----------------------------------------------------------------
    // DM 메서드 (외부 호출 가능 진입점)
    // ----------------------------------------------------------------

    /**
     * 기업집단신용평가이력 관리 메인 DM.
     *
     * <p>COBOL S0000-MAIN-RTN (EVALUATE XDIPA301-I-PRCSS-DSTCD 처리구분 분기) 대응.</p>
     *
     * <p>처리구분 값에 따라 아래 처리를 수행한다:
     * <ul>
     *   <li>'01': 신규평가 - 기존재 확인 후 THKIPB110 INSERT</li>
     *   <li>'02': 확정취소 - 무동작 (TBD)</li>
     *   <li>'03': 삭제 - 11개 테이블 연쇄 DELETE</li>
     * </ul>
     * </p>
     *
     * @param requestData  입력 데이터셋.
     *                     필수 키: prcssDstcd(처리구분), groupCoCd(그룹회사코드),
     *                     corpClctGroupCd(기업집단그룹코드), corpClctRegiCd(기업집단등록코드),
     *                     valuaYmd(평가년월일), valuaStdYmd(평가기준년월일),
     *                     corpClctName(기업집단명)
     * @param onlineCtx    온라인 컨텍스트
     * @return 처리 결과 IDataSet (totalNoitm: 총건수, nowNoitm: 현재건수)
     * @throws BusinessException 입력값 오류, DB 처리 오류 발생 시
     */
    @BizMethod("기업집단신용평가이력 관리 DM")
    public IDataSet manageCorpEvalHistory(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[DUCorpEvalHistoryA.manageCorpEvalHistory] START");

        // 로컬 변수 초기화 (COBOL WK-AREA 대응 - 싱글톤이므로 멤버 필드 금지)
        IDataSet responseData = new DataSet();

        // 처리구분 취득
        String prcssDstcd = requestData.getString("prcssDstcd");

        log.debug("[DUCorpEvalHistoryA.manageCorpEvalHistory] prcssDstcd={}", prcssDstcd.replaceAll("[\r\n]", "_"));

        // ----------------------------------------------------------------
        // 처리구분 분기 (COBOL EVALUATE XDIPA301-I-PRCSS-DSTCD 대응)
        // ----------------------------------------------------------------
        if (CCorpEvalConsts.PRCSS_DSTCD_NEW.equals(prcssDstcd)) {
            // 처리구분 '01': 신규평가
            log.debug("★[S3000-PROCESS-RTN] 신규평가 처리 시작");
            _insertCorpEvalHistory(requestData, onlineCtx);

        } else if (CCorpEvalConsts.PRCSS_DSTCD_CANCEL.equals(prcssDstcd)) {
            // 처리구분 '02': 확정취소
            // TODO: [변환 불가] 처리구분 '02' 확정취소 로직 미정의 - 수동 검토 필요
            // 원본 구문: COBOL DIPA301 S4000에서 처리구분 '02' 분기가 존재하나 실제 처리내용 미확인
            // 현재는 무동작으로 구현. 업무팀 확인 후 로직 추가 필요.
            log.debug("★[S4000-PROCESS-RTN] 확정취소 처리 - 현재 무동작 (TBD)");

        } else if (CCorpEvalConsts.PRCSS_DSTCD_DELETE.equals(prcssDstcd)) {
            // 처리구분 '03': 삭제
            log.debug("★[S4200-PROCESS-RTN] 삭제 처리 시작");
            _deleteCorpEvalHistoryAll(requestData, onlineCtx);

        } else {
            // 정의되지 않은 처리구분
            throw new BusinessException(
                    CCorpEvalConsts.ERR_B3800004,
                    CCorpEvalConsts.TREAT_UKIP0007,
                    "처리구분코드를 입력해 주십시오. prcssDstcd=" + prcssDstcd);
        }

        // 출력 파라미터 조립 (COBOL XDIPA301-OUT 대응)
        // 총건수/현재건수는 처리 후 값 설정 (COBOL XDIPA301-O-TOTAL-NOITM, XDIPA301-O-NOW-NOITM 대응)
        responseData.put("totalNoitm", requestData.getString("totalNoitm") != null
                ? requestData.getString("totalNoitm") : "00000");
        responseData.put("nowNoitm", requestData.getString("nowNoitm") != null
                ? requestData.getString("nowNoitm") : "00000");

        log.debug("★[DUCorpEvalHistoryA.manageCorpEvalHistory] END");
        return responseData;
    }


    // ----------------------------------------------------------------
    // 신규평가 처리 (처리구분 '01') - COBOL S3000~S3221 대응
    // ----------------------------------------------------------------

    /**
     * 신규평가 처리 (COBOL S3000-PROCESS-RTN 대응).
     *
     * <p>처리 순서:
     * <ol>
     *   <li>QIPA301: 기존재 확인 (이미 등록된 경우 오류)</li>
     *   <li>QIPA307: 주채무계열여부 조회</li>
     *   <li>QIPA302: 직원기본정보 조회 (직원한글명, 소속부점코드)</li>
     *   <li>THKIPB110 INSERT</li>
     * </ol>
     * </p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException 기존재 확인 중복 오류, DB 처리 오류 발생 시
     */
    private void _insertCorpEvalHistory(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S3000-PROCESS-RTN] _insertCorpEvalHistory START");

        // ----------------------------------------------------------------
        // STEP1: QIPA301 기존재 확인 (COBOL S3100-THKIPB110-CHK-RTN 대응)
        // ----------------------------------------------------------------
        String wkDataYn = _selectExistCheck(requestData, onlineCtx);
        log.debug("★[S3100] 기존재여부=" + wkDataYn);

        // 기존재하는 경우 오류 (COBOL COND-XQIPA301-YN='Y' 분기 대응)
        if (CCorpEvalConsts.DATA_YN_EXISTS.equals(wkDataYn)) {
            throw new BusinessException(
                    CCorpEvalConsts.ERR_B4200023,
                    CCorpEvalConsts.TREAT_UKII0182,
                    "이미 등록되어있는 정보입니다.");
        }

        // ----------------------------------------------------------------
        // STEP2: QIPA307 주채무계열여부 조회 (COBOL S3221-QIPA307-SEL-RTN 대응)
        // ----------------------------------------------------------------
        String wkMainDebtAffltYn = _selectMainDebtAffltYn(requestData, onlineCtx);
        log.debug("★[S3221] 주채무계열여부=" + wkMainDebtAffltYn);

        // ----------------------------------------------------------------
        // STEP3: QIPA302 직원기본정보 조회 (COBOL S5000-EMP-INFO-SEL-RTN 대응)
        // ----------------------------------------------------------------
        IDataSet empInfo = _selectEmployeeInfo(requestData, onlineCtx);
        String wkEmpHanglFname = "";
        String wkBelngBrncd = "";
        if (empInfo != null) {
            wkEmpHanglFname = empInfo.getString("empHanglFname") != null
                    ? empInfo.getString("empHanglFname") : "";
            wkBelngBrncd = empInfo.getString("belngBrncd") != null
                    ? empInfo.getString("belngBrncd") : "";
        }
        log.debug("[S5000] 직원정보 조회 완료");

        // ----------------------------------------------------------------
        // STEP4: THKIPB110 INSERT (COBOL S3200-THKIPB110-INS-RTN 대응)
        // ----------------------------------------------------------------
        log.debug("★[S3200-THKIPB110-INS-RTN] THKIPB110 INSERT 시작");

        // INSERT 파라미터 조립 (COBOL S3210-THKIPB110-PK-SET, S3220-THKIPB110-REC-SET 대응)
        IDataSet insertParam = new DataSet();

        // PK 항목 SET (COBOL S3210 대응)
        // 그룹회사코드 - CommonArea에서 취득 (COBOL BICOM-GROUP-CO-CD 대응)
        insertParam.put("groupCoCd", requestData.getString("groupCoCd"));
        // 기업집단그룹코드
        insertParam.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        // 기업집단등록코드
        insertParam.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        // 평가년월일
        insertParam.put("valuaYmd", requestData.getString("valuaYmd"));

        // 레코드 항목 SET (COBOL S3220 대응)
        // 기업집단명
        insertParam.put("corpClctName", requestData.getString("corpClctName"));
        // 평가확정년월일 (VALUA_DEFINS_YMD) - 초기 NULL 허용
        insertParam.put("valuaDefinsYmd", requestData.getString("valuaDefinsYmd"));
        // 평가기준년월일 (VALUA_BASE_YMD) - XML 바인드 변수명과 일치
        insertParam.put("valuaBaseYmd", requestData.getString("valuaStdYmd"));
        // 비계약업무구분코드 (신평: '060')
        insertParam.put("nonCtrcBzwkDstcd", CCorpEvalConsts.NON_CTRC_BZWK_DSTCD);
        // 기업집단처리단계구분 - 해당무 초기값 ('0')
        insertParam.put("corpCpStgeDstcd", CCorpEvalConsts.CORP_CP_STGE_DSTCD_NONE);
        // 기업집단평가구분 - 해당무 ('0')
        insertParam.put("corpCValuaDstcd", CCorpEvalConsts.CORP_C_VALUA_DSTCD_NONE);
        // 등급조정구분 - 해당무 ('0')
        insertParam.put("grdAdjsDstcd", CCorpEvalConsts.GRD_ADJS_DSTCD_NONE);
        // 조정단계번호구분 - 해당무 ('00')
        insertParam.put("adjsStgeNoDstcd", CCorpEvalConsts.ADJS_STGE_NO_DSTCD_NONE);
        // 안정성지표완성도1 (STABL_IF_CMPTN_VAL1) - 초기 0
        insertParam.put("stablIfCmptnVal1", requestData.getString("stablIfCmptnVal1") != null
                ? requestData.getString("stablIfCmptnVal1") : "0");
        // 안정성지표완성도2 (STABL_IF_CMPTN_VAL2) - 초기 0
        insertParam.put("stablIfCmptnVal2", requestData.getString("stablIfCmptnVal2") != null
                ? requestData.getString("stablIfCmptnVal2") : "0");
        // 수익성지표완성도1 (ERN_IF_CMPTN_VAL1) - 초기 0
        insertParam.put("ernIfCmptnVal1", requestData.getString("ernIfCmptnVal1") != null
                ? requestData.getString("ernIfCmptnVal1") : "0");
        // 수익성지표완성도2 (ERN_IF_CMPTN_VAL2) - 초기 0
        insertParam.put("ernIfCmptnVal2", requestData.getString("ernIfCmptnVal2") != null
                ? requestData.getString("ernIfCmptnVal2") : "0");
        // 재무등급분류완성도 (CSFW_FNAF_CMPTN_VAL) - 초기 0
        insertParam.put("csfwFnafCmptnVal", requestData.getString("csfwFnafCmptnVal") != null
                ? requestData.getString("csfwFnafCmptnVal") : "0");
        // 재무점수 (FNAF_SCOR) - 초기 0
        insertParam.put("fnafScor", requestData.getString("fnafScor") != null
                ? requestData.getString("fnafScor") : "0");
        // 비재무점수 (NON_FNAF_SCOR) - 초기 0
        insertParam.put("nonFnafScor", requestData.getString("nonFnafScor") != null
                ? requestData.getString("nonFnafScor") : "0");
        // 선정점수 (CHSN_SCOR) - 초기 0
        insertParam.put("chsnScor", requestData.getString("chsnScor") != null
                ? requestData.getString("chsnScor") : "0");
        // 예비집단등급구분 - 해당무 ('000')
        insertParam.put("spareCGrdDstcd", CCorpEvalConsts.SPARE_C_GRD_DSTCD_NONE);
        // 최종집단등급구분 - 해당무 ('000')
        insertParam.put("lastClctGrdDstcd", CCorpEvalConsts.LAST_CLCT_GRD_DSTCD_NONE);
        // 유효년월일 (VALD_YMD) - 초기 NULL 허용
        insertParam.put("valdYmd", requestData.getString("valdYmd"));
        // 주채무계열여부 (QIPA307 조회 결과)
        insertParam.put("mainDebtAffltYn", wkMainDebtAffltYn);
        // 평가직원번호 (VALUA_EMPID) - COBOL BICOM-USER-EMPID 대응
        insertParam.put("valuaEmpid", requestData.getString("userEmpid"));
        // 평가직원명 (VALUA_EMNM) - QIPA302 조회 결과 직원한글명 매핑
        insertParam.put("valuaEmnm", wkEmpHanglFname);
        // 평가부점코드 (VALUA_BRNCD) - QIPA302 조회 결과 소속부점코드 매핑
        insertParam.put("valuaBrncd", wkBelngBrncd);
        // 관리부점코드 (MGT_BRNCD) - 초기 NULL 허용
        insertParam.put("mgtBrncd", requestData.getString("mgtBrncd"));
        // 등록직원번호 (COBOL BICOM-USER-EMPID 대응)
        insertParam.put("regiEmpid", requestData.getString("userEmpid"));
        // 최종수정직원번호 (COBOL BICOM-USER-EMPID 대응)
        insertParam.put("lastMdfcEmpid", requestData.getString("userEmpid"));

        // DBIO INSERT 실행
        int rows = dbInsert("insertThkipb110", insertParam);
        if (rows <= 0) {
            throw new BusinessException(
                    CCorpEvalConsts.ERR_B3900002,
                    CCorpEvalConsts.TREAT_UKII0182,
                    "THKIPB110 INSERT 처리 오류가 발생하였습니다.");
        }

        log.debug("★[S3200] THKIPB110 INSERT 완료. rows=" + rows);
    }

    /**
     * QIPA301 기존재 확인 조회 (COBOL S3100-THKIPB110-CHK-RTN 대응).
     *
     * <p>확정된(처리단계='6') 기업집단 평가 이력 기존재 여부를 조회한다.
     * SQLIO QIPA301 소스 미확보로 SQL 역설계 적용.</p>
     *
     * @param requestData 입력 데이터셋 (groupCoCd, corpClctGroupCd, corpClctRegiCd, valuaYmd 필요)
     * @param onlineCtx   온라인 컨텍스트
     * @return "Y": 기존재, "N": 미존재
     * @throws BusinessException DB 조회 오류 발생 시
     */
    private String _selectExistCheck(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S3100-THKIPB110-CHK-RTN] _selectExistCheck START");

        IDataSet param = new DataSet();
        param.put("groupCoCd", requestData.getString("groupCoCd"));
        param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        param.put("valuaYmd", requestData.getString("valuaYmd"));
        // 확정 처리단계 기준 조회 (CORP_CP_STGE_DSTCD = '6')
        param.put("corpCpStgeDstcd", CCorpEvalConsts.CORP_CP_STGE_DSTCD_DEFINS);

        // TODO: [SQLIO 소스 미확보] selectExistCheckQipa301 SQL은 QIPA301 역설계 결과 - 수동 검토 필요
        IDataSet result = dbSelect("selectExistCheckQipa301", param);

        if (result == null) {
            // Not Found: 기존재 없음
            return CCorpEvalConsts.DATA_YN_NOT_EXISTS;
        }

        // 조회 결과 건수 기반 존재 여부 판별
        String cnt = result.getString("cnt");
        if (cnt != null && !"0".equals(cnt.trim())) {
            return CCorpEvalConsts.DATA_YN_EXISTS;
        }
        return CCorpEvalConsts.DATA_YN_NOT_EXISTS;
    }

    /**
     * QIPA307 주채무계열여부 조회 (COBOL S3221-QIPA307-SEL-RTN 대응).
     *
     * <p>기업집단 주채무계열 여부를 조회한다.
     * SQLIO QIPA307 소스 미확보로 SQL 역설계 적용.</p>
     *
     * @param requestData 입력 데이터셋 (groupCoCd, corpClctGroupCd 필요)
     * @param onlineCtx   온라인 컨텍스트
     * @return 주채무계열여부 ("Y"/"N"), 조회 실패 시 "N" 반환
     * @throws BusinessException DB 조회 오류 발생 시
     */
    private String _selectMainDebtAffltYn(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S3221-QIPA307-SEL-RTN] _selectMainDebtAffltYn START");

        IDataSet param = new DataSet();
        param.put("groupCoCd", requestData.getString("groupCoCd"));
        param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));

        // TODO: [SQLIO 소스 미확보] selectMainDebtAffltYnQipa307 SQL은 QIPA307 역설계 결과 - 수동 검토 필요
        IDataSet result = dbSelect("selectMainDebtAffltYnQipa307", param);

        if (result == null) {
            // Not Found: 주채무계열 해당 없음
            return "N";
        }

        String mainDebtAffltYn = result.getString("mainDebtAffltYn");
        return (mainDebtAffltYn != null) ? mainDebtAffltYn.trim() : "N";
    }

    /**
     * QIPA302 직원기본정보 조회 (COBOL S5000-EMP-INFO-SEL-RTN 대응).
     *
     * <p>담당 직원의 한글명 및 소속부점코드를 조회한다.
     * SQLIO QIPA302 소스 미확보로 SQL 역설계 적용.</p>
     *
     * @param requestData 입력 데이터셋 (userEmpid: 담당직원번호, groupCoCd 필요)
     * @param onlineCtx   온라인 컨텍스트
     * @return 직원정보 IDataSet (empHanglFname, belngBrncd), 조회 없으면 null 반환
     * @throws BusinessException DB 조회 오류 발생 시
     */
    private IDataSet _selectEmployeeInfo(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S5000-EMP-INFO-SEL-RTN] _selectEmployeeInfo START");

        IDataSet param = new DataSet();
        param.put("groupCoCd", requestData.getString("groupCoCd"));
        param.put("userEmpid", requestData.getString("userEmpid"));

        // TODO: [SQLIO 소스 미확보] selectEmployeeInfoQipa302 SQL은 QIPA302 역설계 결과 - 수동 검토 필요
        // 대안: FUBcEmployee.getPafiarEmpInfo() 공통 유틸 callSharedMethodByDirect 호출 검토
        IDataSet result = dbSelect("selectEmployeeInfoQipa302", param);

        return result; // null 가능 (Not Found)
    }


    // ----------------------------------------------------------------
    // 삭제 처리 (처리구분 '03') - COBOL S4200~S42E1 대응
    // ----------------------------------------------------------------

    /**
     * 기업집단신용평가이력 전체 삭제 총괄 메서드 (COBOL S4200-DELETE-ALL-RTN 대응).
     *
     * <p>11개 테이블에서 해당 기업집단 평가 이력을 순차적으로 모두 삭제한다.
     * 프레임워크가 트랜잭션을 관리하므로 임의 Commit/Rollback 금지.</p>
     *
     * @param requestData 입력 데이터셋 (groupCoCd, corpClctGroupCd, corpClctRegiCd, valuaYmd 필요)
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 조회/삭제 오류 발생 시
     */
    private void _deleteCorpEvalHistoryAll(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S4200-DELETE-ALL-RTN] _deleteCorpEvalHistoryAll START");

        // S4210: THKIPB110 기업집단평가기본 DELETE
        _deleteThkipb110(requestData, onlineCtx);

        // S4220: THKIPB111 기업집단연혁명세 CURSOR DELETE (다건)
        _deleteThkipb111Loop(requestData, onlineCtx);

        // S4230: THKIPB116 기업집단계열사명세 CURSOR DELETE (다건)
        _deleteThkipb116Loop(requestData, onlineCtx);

        // S4240/S4241: THKIPB113 기업집단사업부분구조분석명세 SQLIO + DELETE
        _deleteThkipb113(requestData, onlineCtx);

        // S4250/S4251: THKIPB112 기업집단재무분석목록 SQLIO + DELETE
        _deleteThkipb112(requestData, onlineCtx);

        // S4260: THKIPB114 기업집단항목별평가목록 CURSOR DELETE (다건)
        _deleteThkipb114Loop(requestData, onlineCtx);

        // S4290: THKIPB118 기업집단평가등급조정사유목록 DELETE
        _deleteThkipb118(requestData, onlineCtx);

        // S42A0/S42A1: THKIPB130 기업집단주석명세 SQLIO + DELETE
        _deleteThkipb130(requestData, onlineCtx);

        // S42B0: THKIPB131 기업집단승인결의록명세 DELETE
        _deleteThkipb131(requestData, onlineCtx);

        // S42C0: THKIPB132 기업집단승인결의록위원명세 CURSOR DELETE (다건)
        _deleteThkipb132Loop(requestData, onlineCtx);

        // S42D0/S42D1: THKIPB133 기업집단승인결의록의견명세 SQLIO + DELETE
        _deleteThkipb133(requestData, onlineCtx);

        // S42E0/S42E1: THKIPB119 기업집단재무평점단계별목록 SQLIO + DELETE
        _deleteThkipb119(requestData, onlineCtx);

        log.debug("★[S4200-DELETE-ALL-RTN] _deleteCorpEvalHistoryAll END");
    }

    /**
     * THKIPB110 기업집단평가기본 DELETE (COBOL S4210-THKIPB110-DEL-RTN 대응).
     *
     * <p>SELECT FOR UPDATE 후 존재하면 DELETE 수행.</p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 처리 오류 발생 시
     */
    private void _deleteThkipb110(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S4210-THKIPB110-DEL-RTN] _deleteThkipb110 START");

        IDataSet param = new DataSet();
        param.put("groupCoCd", requestData.getString("groupCoCd"));
        param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        param.put("valuaYmd", requestData.getString("valuaYmd"));

        // DBIO SELECT-CMD-Y (LOCK SELECT) 대응
        IDataSet selectResult = dbSelect("selectThkipb110ForUpdate", param);

        if (selectResult == null) {
            // Not Found: 삭제 대상 없음 - 정상 처리
            log.debug("★[S4210] THKIPB110 대상 없음 (NOTFOUND)");
            return;
        }

        // DBIO DELETE-CMD-Y 대응
        int rows = dbDelete("deleteThkipb110", param);
        if (rows <= 0) {
            throw new BusinessException(
                    CCorpEvalConsts.ERR_B4200219,
                    CCorpEvalConsts.TREAT_UKII0182,
                    "THKIPB110 데이터를 삭제할 수 없습니다.");
        }

        log.debug("★[S4210] THKIPB110 DELETE 완료. rows=" + rows);
    }

    /**
     * THKIPB111 기업집단연혁명세 CURSOR 루프 DELETE (COBOL S4220-THKIPB111-DEL-RTN 대응).
     *
     * <p>COBOL DBIO OPEN-FETCH-CLOSE 커서 패턴을 dbSelectMulti + IRecordSet 루프로 변환.</p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 처리 오류 발생 시
     */
    private void _deleteThkipb111Loop(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S4220-THKIPB111-DEL-RTN] _deleteThkipb111Loop START");

        IDataSet param = new DataSet();
        param.put("groupCoCd", requestData.getString("groupCoCd"));
        param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        param.put("valuaYmd", requestData.getString("valuaYmd"));

        // DBIO OPEN-FETCH-CLOSE 커서 → dbSelectMulti 변환
        IRecordSet rs = dbSelectMulti("selectListThkipb111ForUpdate", param);

        if (rs == null || rs.getRecordCount() == 0) {
            log.debug("★[S4220] THKIPB111 삭제 대상 없음");
            return;
        }

        // FETCH 루프 → IRecordSet 순회 삭제
        for (int i = 0; i < rs.getRecordCount(); i++) {
            IRecord rec = rs.getRecord(i);

            IDataSet deleteParam = new DataSet();
            deleteParam.put("groupCoCd", rec.getString("groupCoCd"));
            deleteParam.put("corpClctGroupCd", rec.getString("corpClctGroupCd"));
            deleteParam.put("corpClctRegiCd", rec.getString("corpClctRegiCd"));
            deleteParam.put("valuaYmd", rec.getString("valuaYmd"));
            // THKIPB111 PK 추가 컬럼 (COBOL RIPB111-* 대응)
            deleteParam.put("corpHstryDstcd", rec.getString("corpHstryDstcd"));
            deleteParam.put("serno", rec.getString("serno"));

            int rows = dbDelete("deleteThkipb111", deleteParam);
            if (rows <= 0) {
                throw new BusinessException(
                        CCorpEvalConsts.ERR_B4200219,
                        CCorpEvalConsts.TREAT_UKII0182,
                        "THKIPB111 데이터를 삭제할 수 없습니다. index=" + i);
            }
            log.debug("★[S4220] THKIPB111 삭제 건수=" + (i + 1));
        }
    }

    /**
     * THKIPB116 기업집단계열사명세 CURSOR 루프 DELETE (COBOL S4230-THKIPB116-DEL-RTN 대응).
     *
     * <p>COBOL DBIO OPEN-FETCH-CLOSE 커서 패턴을 dbSelectMulti + IRecordSet 루프로 변환.</p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 처리 오류 발생 시
     */
    private void _deleteThkipb116Loop(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S4230-THKIPB116-DEL-RTN] _deleteThkipb116Loop START");

        IDataSet param = new DataSet();
        param.put("groupCoCd", requestData.getString("groupCoCd"));
        param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        param.put("valuaYmd", requestData.getString("valuaYmd"));

        IRecordSet rs = dbSelectMulti("selectListThkipb116ForUpdate", param);

        if (rs == null || rs.getRecordCount() == 0) {
            log.debug("★[S4230] THKIPB116 삭제 대상 없음");
            return;
        }

        for (int i = 0; i < rs.getRecordCount(); i++) {
            IRecord rec = rs.getRecord(i);

            IDataSet deleteParam = new DataSet();
            deleteParam.put("groupCoCd", rec.getString("groupCoCd"));
            deleteParam.put("corpClctGroupCd", rec.getString("corpClctGroupCd"));
            deleteParam.put("corpClctRegiCd", rec.getString("corpClctRegiCd"));
            deleteParam.put("valuaYmd", rec.getString("valuaYmd"));
            // THKIPB116 PK 추가 컬럼 (COBOL RIPB116-* 대응)
            deleteParam.put("affltCoNo", rec.getString("affltCoNo"));

            int rows = dbDelete("deleteThkipb116", deleteParam);
            if (rows <= 0) {
                throw new BusinessException(
                        CCorpEvalConsts.ERR_B4200219,
                        CCorpEvalConsts.TREAT_UKII0182,
                        "THKIPB116 데이터를 삭제할 수 없습니다. index=" + i);
            }
            log.debug("★[S4230] THKIPB116 삭제 건수=" + (i + 1));
        }
    }

    /**
     * THKIPB113 기업집단사업부분구조분석명세 SQLIO + DELETE (COBOL S4240/S4241 대응).
     *
     * <p>SQLIO QIPA303으로 PK 목록을 조회한 후 건별 LOCK SELECT + DELETE 수행.</p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 처리 오류 발생 시
     */
    private void _deleteThkipb113(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S4240-THKIPB113-DEL-RTN] _deleteThkipb113 START");

        IDataSet qipa303Param = new DataSet();
        qipa303Param.put("groupCoCd", requestData.getString("groupCoCd"));
        qipa303Param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        qipa303Param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        qipa303Param.put("valuaYmd", requestData.getString("valuaYmd"));

        // SQLIO QIPA303 SELECT → PK 목록 취득 (COBOL #DYSQLA QIPA303 대응)
        // TODO: [SQLIO 소스 미확보] selectPksQipa303 SQL은 QIPA303 역설계 결과 - 수동 검토 필요
        IRecordSet pkList = dbSelectMulti("selectPksQipa303", qipa303Param);

        if (pkList == null || pkList.getRecordCount() == 0) {
            log.debug("★[S4240] THKIPB113 삭제 대상 없음");
            return;
        }

        // PERFORM VARYING WK-I 루프 대응: PK 목록 건별 LOCK SELECT + DELETE
        for (int i = 0; i < pkList.getRecordCount(); i++) {
            IRecord pkRec = pkList.getRecord(i);

            IDataSet lockParam = new DataSet();
            lockParam.put("groupCoCd", requestData.getString("groupCoCd"));
            lockParam.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            lockParam.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            lockParam.put("valuaYmd", requestData.getString("valuaYmd"));
            // QIPA303 조회 결과의 PK 컬럼 (COBOL XQIPA303-O-FNAF-A-RPTDOC-DSTCD, XQIPA303-O-FNAF-ITEM-CD, XQIPA303-O-BIZ-SECT-NO 대응)
            lockParam.put("fnafARptdocDstcd", pkRec.getString("fnafARptdocDstcd"));
            lockParam.put("fnafItemCd", pkRec.getString("fnafItemCd"));
            lockParam.put("bizSectNo", pkRec.getString("bizSectNo"));

            // DBIO SELECT-CMD-Y (LOCK SELECT) 대응
            IDataSet lockResult = dbSelect("selectThkipb113ForUpdate", lockParam);
            if (lockResult == null) {
                // NOTFOUND: 건너뜀
                continue;
            }

            // DBIO DELETE-CMD-Y 대응
            int rows = dbDelete("deleteThkipb113", lockParam);
            if (rows <= 0) {
                throw new BusinessException(
                        CCorpEvalConsts.ERR_B4200219,
                        CCorpEvalConsts.TREAT_UKII0182,
                        "THKIPB113 데이터를 삭제할 수 없습니다. index=" + i);
            }
            log.debug("★[S4241] THKIPB113 삭제 건수=" + (i + 1));
        }
    }

    /**
     * THKIPB112 기업집단재무분석목록 SQLIO + DELETE (COBOL S4250/S4251 대응).
     *
     * <p>SQLIO QIPA304으로 PK 목록을 조회한 후 건별 LOCK SELECT + DELETE 수행.</p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 처리 오류 발생 시
     */
    private void _deleteThkipb112(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S4250-THKIPB112-DEL-RTN] _deleteThkipb112 START");

        IDataSet qipa304Param = new DataSet();
        qipa304Param.put("groupCoCd", requestData.getString("groupCoCd"));
        qipa304Param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        qipa304Param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        qipa304Param.put("valuaYmd", requestData.getString("valuaYmd"));

        // TODO: [SQLIO 소스 미확보] selectPksQipa304 SQL은 QIPA304 역설계 결과 - 수동 검토 필요
        IRecordSet pkList = dbSelectMulti("selectPksQipa304", qipa304Param);

        if (pkList == null || pkList.getRecordCount() == 0) {
            log.debug("★[S4250] THKIPB112 삭제 대상 없음");
            return;
        }

        for (int i = 0; i < pkList.getRecordCount(); i++) {
            IRecord pkRec = pkList.getRecord(i);

            IDataSet lockParam = new DataSet();
            lockParam.put("groupCoCd", requestData.getString("groupCoCd"));
            lockParam.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            lockParam.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            lockParam.put("valuaYmd", requestData.getString("valuaYmd"));
            // QIPA304 조회 결과의 PK 컬럼 (COBOL XQIPA304-O-ANLS-I-CLSFI-DSTCD, XQIPA304-O-FNAF-A-RPTDOC-DSTCD, XQIPA304-O-FNAF-ITEM-CD 대응)
            lockParam.put("anlsIClsfiDstcd", pkRec.getString("anlsIClsfiDstcd"));
            lockParam.put("fnafARptdocDstcd", pkRec.getString("fnafARptdocDstcd"));
            lockParam.put("fnafItemCd", pkRec.getString("fnafItemCd"));

            IDataSet lockResult = dbSelect("selectThkipb112ForUpdate", lockParam);
            if (lockResult == null) {
                continue;
            }

            int rows = dbDelete("deleteThkipb112", lockParam);
            if (rows <= 0) {
                throw new BusinessException(
                        CCorpEvalConsts.ERR_B4200219,
                        CCorpEvalConsts.TREAT_UKII0182,
                        "THKIPB112 데이터를 삭제할 수 없습니다. index=" + i);
            }
            log.debug("★[S4251] THKIPB112 삭제 건수=" + (i + 1));
        }
    }

    /**
     * THKIPB114 기업집단항목별평가목록 CURSOR 루프 DELETE (COBOL S4260 대응).
     *
     * <p>COBOL DBIO OPEN-FETCH-CLOSE 커서 패턴을 dbSelectMulti + IRecordSet 루프로 변환.</p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 처리 오류 발생 시
     */
    private void _deleteThkipb114Loop(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S4260-THKIPB114-DEL-RTN] _deleteThkipb114Loop START");

        IDataSet param = new DataSet();
        param.put("groupCoCd", requestData.getString("groupCoCd"));
        param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        param.put("valuaYmd", requestData.getString("valuaYmd"));
        // COBOL KIPB114-PK-CORP-CI-VALUA-DSTCD ZEROS 초기값으로 OPEN
        param.put("corpCiValuaDstcd", "0");

        IRecordSet rs = dbSelectMulti("selectListThkipb114ForUpdate", param);

        if (rs == null || rs.getRecordCount() == 0) {
            log.debug("★[S4260] THKIPB114 삭제 대상 없음");
            return;
        }

        for (int i = 0; i < rs.getRecordCount(); i++) {
            IRecord rec = rs.getRecord(i);

            IDataSet deleteParam = new DataSet();
            deleteParam.put("groupCoCd", rec.getString("groupCoCd"));
            deleteParam.put("corpClctGroupCd", rec.getString("corpClctGroupCd"));
            deleteParam.put("corpClctRegiCd", rec.getString("corpClctRegiCd"));
            deleteParam.put("valuaYmd", rec.getString("valuaYmd"));
            // COBOL RIPB114-CORP-CI-VALUA-DSTCD 대응
            deleteParam.put("corpCiValuaDstcd", rec.getString("corpCiValuaDstcd"));

            int rows = dbDelete("deleteThkipb114", deleteParam);
            if (rows <= 0) {
                throw new BusinessException(
                        CCorpEvalConsts.ERR_B4200219,
                        CCorpEvalConsts.TREAT_UKII0182,
                        "THKIPB114 데이터를 삭제할 수 없습니다. index=" + i);
            }
            log.debug("★[S4260] THKIPB114 삭제 건수=" + (i + 1));
        }
    }

    /**
     * THKIPB118 기업집단평가등급조정사유목록 DELETE (COBOL S4290 대응).
     *
     * <p>SELECT FOR UPDATE 후 존재하면 DELETE 수행.</p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 처리 오류 발생 시
     */
    private void _deleteThkipb118(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S4290-THKIPB118-DEL-RTN] _deleteThkipb118 START");

        IDataSet param = new DataSet();
        param.put("groupCoCd", requestData.getString("groupCoCd"));
        param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        param.put("valuaYmd", requestData.getString("valuaYmd"));

        IDataSet lockResult = dbSelect("selectThkipb118ForUpdate", param);
        if (lockResult == null) {
            log.debug("★[S4290] THKIPB118 대상 없음 (NOTFOUND)");
            return;
        }

        int rows = dbDelete("deleteThkipb118", param);
        if (rows <= 0) {
            throw new BusinessException(
                    CCorpEvalConsts.ERR_B4200219,
                    CCorpEvalConsts.TREAT_UKII0182,
                    "THKIPB118 데이터를 삭제할 수 없습니다.");
        }

        log.debug("★[S4290] THKIPB118 DELETE 완료. rows=" + rows);
    }

    /**
     * THKIPB130 기업집단주석명세 SQLIO + DELETE (COBOL S42A0/S42A1 대응).
     *
     * <p>SQLIO QIPA305으로 PK 목록을 조회한 후 건별 LOCK SELECT + DELETE 수행.</p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 처리 오류 발생 시
     */
    private void _deleteThkipb130(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S42A0-THKIPB130-DEL-RTN] _deleteThkipb130 START");

        IDataSet qipa305Param = new DataSet();
        qipa305Param.put("groupCoCd", requestData.getString("groupCoCd"));
        qipa305Param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        qipa305Param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        qipa305Param.put("valuaYmd", requestData.getString("valuaYmd"));

        // TODO: [SQLIO 소스 미확보] selectPksQipa305 SQL은 QIPA305 역설계 결과 - 수동 검토 필요
        IRecordSet pkList = dbSelectMulti("selectPksQipa305", qipa305Param);

        if (pkList == null || pkList.getRecordCount() == 0) {
            log.debug("★[S42A0] THKIPB130 삭제 대상 없음");
            return;
        }

        for (int i = 0; i < pkList.getRecordCount(); i++) {
            IRecord pkRec = pkList.getRecord(i);

            IDataSet lockParam = new DataSet();
            lockParam.put("groupCoCd", requestData.getString("groupCoCd"));
            lockParam.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            lockParam.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            lockParam.put("valuaYmd", requestData.getString("valuaYmd"));
            // QIPA305 조회 결과의 PK 컬럼 (COBOL XQIPA305-O-CORP-C-COMT-DSTCD, XQIPA305-O-SERNO 대응)
            lockParam.put("corpCComtDstcd", pkRec.getString("corpCComtDstcd"));
            lockParam.put("serno", pkRec.getString("serno"));

            IDataSet lockResult = dbSelect("selectThkipb130ForUpdate", lockParam);
            if (lockResult == null) {
                continue;
            }

            int rows = dbDelete("deleteThkipb130", lockParam);
            if (rows <= 0) {
                throw new BusinessException(
                        CCorpEvalConsts.ERR_B4200219,
                        CCorpEvalConsts.TREAT_UKII0182,
                        "THKIPB130 데이터를 삭제할 수 없습니다. index=" + i);
            }
            log.debug("★[S42A1] THKIPB130 삭제 건수=" + (i + 1));
        }
    }

    /**
     * THKIPB131 기업집단승인결의록명세 DELETE (COBOL S42B0 대응).
     *
     * <p>SELECT FOR UPDATE 후 존재하면 DELETE 수행.</p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 처리 오류 발생 시
     */
    private void _deleteThkipb131(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S42B0-THKIPB131-DEL-RTN] _deleteThkipb131 START");

        IDataSet param = new DataSet();
        param.put("groupCoCd", requestData.getString("groupCoCd"));
        param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        param.put("valuaYmd", requestData.getString("valuaYmd"));

        IDataSet lockResult = dbSelect("selectThkipb131ForUpdate", param);
        if (lockResult == null) {
            log.debug("★[S42B0] THKIPB131 대상 없음 (NOTFOUND)");
            return;
        }

        int rows = dbDelete("deleteThkipb131", param);
        if (rows <= 0) {
            throw new BusinessException(
                    CCorpEvalConsts.ERR_B4200219,
                    CCorpEvalConsts.TREAT_UKII0182,
                    "THKIPB131 데이터를 삭제할 수 없습니다.");
        }

        log.debug("★[S42B0] THKIPB131 DELETE 완료. rows=" + rows);
    }

    /**
     * THKIPB132 기업집단승인결의록위원명세 CURSOR 루프 DELETE (COBOL S42C0 대응).
     *
     * <p>COBOL DBIO OPEN-FETCH-CLOSE 커서 패턴을 dbSelectMulti + IRecordSet 루프로 변환.</p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 처리 오류 발생 시
     */
    private void _deleteThkipb132Loop(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S42C0-THKIPB132-DEL-RTN] _deleteThkipb132Loop START");

        IDataSet param = new DataSet();
        param.put("groupCoCd", requestData.getString("groupCoCd"));
        param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        param.put("valuaYmd", requestData.getString("valuaYmd"));
        // COBOL KIPB132-PK-ATHOR-CMMB-EMPID ZEROS 초기값으로 OPEN
        param.put("athorCmmbEmpid", "0");

        IRecordSet rs = dbSelectMulti("selectListThkipb132ForUpdate", param);

        if (rs == null || rs.getRecordCount() == 0) {
            log.debug("★[S42C0] THKIPB132 삭제 대상 없음");
            return;
        }

        for (int i = 0; i < rs.getRecordCount(); i++) {
            IRecord rec = rs.getRecord(i);

            IDataSet deleteParam = new DataSet();
            deleteParam.put("groupCoCd", rec.getString("groupCoCd"));
            deleteParam.put("corpClctGroupCd", rec.getString("corpClctGroupCd"));
            deleteParam.put("corpClctRegiCd", rec.getString("corpClctRegiCd"));
            deleteParam.put("valuaYmd", rec.getString("valuaYmd"));
            // COBOL RIPB132-ATHOR-CMMB-EMPID 대응
            deleteParam.put("athorCmmbEmpid", rec.getString("athorCmmbEmpid"));

            int rows = dbDelete("deleteThkipb132", deleteParam);
            if (rows <= 0) {
                throw new BusinessException(
                        CCorpEvalConsts.ERR_B4200219,
                        CCorpEvalConsts.TREAT_UKII0182,
                        "THKIPB132 데이터를 삭제할 수 없습니다. index=" + i);
            }
            log.debug("★[S42C0] THKIPB132 삭제 건수=" + (i + 1));
        }
    }

    /**
     * THKIPB133 기업집단승인결의록의견명세 SQLIO + DELETE (COBOL S42D0/S42D1 대응).
     *
     * <p>SQLIO QIPA306으로 PK 목록을 조회한 후 건별 LOCK SELECT + DELETE 수행.</p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 처리 오류 발생 시
     */
    private void _deleteThkipb133(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S42D0-THKIPB133-DEL-RTN] _deleteThkipb133 START");

        IDataSet qipa306Param = new DataSet();
        qipa306Param.put("groupCoCd", requestData.getString("groupCoCd"));
        qipa306Param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        qipa306Param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        qipa306Param.put("valuaYmd", requestData.getString("valuaYmd"));

        // TODO: [SQLIO 소스 미확보] selectPksQipa306 SQL은 QIPA306 역설계 결과 - 수동 검토 필요
        IRecordSet pkList = dbSelectMulti("selectPksQipa306", qipa306Param);

        if (pkList == null || pkList.getRecordCount() == 0) {
            log.debug("★[S42D0] THKIPB133 삭제 대상 없음");
            return;
        }

        for (int i = 0; i < pkList.getRecordCount(); i++) {
            IRecord pkRec = pkList.getRecord(i);

            IDataSet lockParam = new DataSet();
            lockParam.put("groupCoCd", requestData.getString("groupCoCd"));
            lockParam.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            lockParam.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            lockParam.put("valuaYmd", requestData.getString("valuaYmd"));
            // QIPA306 조회 결과의 PK 컬럼 (COBOL XQIPA306-O-ATHOR-CMMB-EMPID, XQIPA306-O-SERNO 대응)
            lockParam.put("athorCmmbEmpid", pkRec.getString("athorCmmbEmpid"));
            lockParam.put("serno", pkRec.getString("serno"));

            IDataSet lockResult = dbSelect("selectThkipb133ForUpdate", lockParam);
            if (lockResult == null) {
                continue;
            }

            int rows = dbDelete("deleteThkipb133", lockParam);
            if (rows <= 0) {
                throw new BusinessException(
                        CCorpEvalConsts.ERR_B4200219,
                        CCorpEvalConsts.TREAT_UKII0182,
                        "THKIPB133 데이터를 삭제할 수 없습니다. index=" + i);
            }
            log.debug("★[S42D1] THKIPB133 삭제 건수=" + (i + 1));
        }
    }

    /**
     * THKIPB119 기업집단재무평점단계별목록 SQLIO + DELETE (COBOL S42E0/S42E1 대응).
     *
     * <p>SQLIO QIPA308으로 PK 목록을 조회한 후 건별 LOCK SELECT + DELETE 수행.</p>
     *
     * @param requestData 입력 데이터셋
     * @param onlineCtx   온라인 컨텍스트
     * @throws BusinessException DB 처리 오류 발생 시
     */
    private void _deleteThkipb119(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S42E0-THKIPB119-DEL-RTN] _deleteThkipb119 START");

        IDataSet qipa308Param = new DataSet();
        qipa308Param.put("groupCoCd", requestData.getString("groupCoCd"));
        qipa308Param.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        qipa308Param.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        qipa308Param.put("valuaYmd", requestData.getString("valuaYmd"));

        // TODO: [SQLIO 소스 미확보] selectPksQipa308 SQL은 QIPA308 역설계 결과 - 수동 검토 필요
        IRecordSet pkList = dbSelectMulti("selectPksQipa308", qipa308Param);

        if (pkList == null || pkList.getRecordCount() == 0) {
            log.debug("★[S42E0] THKIPB119 삭제 대상 없음");
            return;
        }

        for (int i = 0; i < pkList.getRecordCount(); i++) {
            IRecord pkRec = pkList.getRecord(i);

            IDataSet lockParam = new DataSet();
            lockParam.put("groupCoCd", requestData.getString("groupCoCd"));
            lockParam.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            lockParam.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            lockParam.put("valuaYmd", requestData.getString("valuaYmd"));
            // QIPA308 조회 결과의 PK 컬럼 (COBOL XQIPA308-O-MDEL-CZ-CLSFI-DSTCD, XQIPA308-O-MDEL-CSZ-CLSFI-CD 대응)
            lockParam.put("mdelCzClsfiDstcd", pkRec.getString("mdelCzClsfiDstcd"));
            lockParam.put("mdelCszClsfiCd", pkRec.getString("mdelCszClsfiCd"));

            IDataSet lockResult = dbSelect("selectThkipb119ForUpdate", lockParam);
            if (lockResult == null) {
                continue;
            }

            int rows = dbDelete("deleteThkipb119", lockParam);
            if (rows <= 0) {
                throw new BusinessException(
                        CCorpEvalConsts.ERR_B4200219,
                        CCorpEvalConsts.TREAT_UKII0182,
                        "THKIPB119 데이터를 삭제할 수 없습니다. index=" + i);
            }
            log.debug("★[S42E1] THKIPB119 삭제 건수=" + (i + 1));
        }
    }

}
