package com.kbstar.kip.enbipba.biz;

import com.kbstar.kip.enbipba.consts.CCorpEvalConsts;
import com.kbstar.sqc.base.ProcessUnit;
import com.kbstar.sqc.framework.annotation.BizMethod;
import com.kbstar.sqc.framework.annotation.BizUnit;
import com.kbstar.sqc.framework.annotation.BizUnitBind;
import com.kbstar.sqc.framework.context.CommonArea;
import com.kbstar.sqc.framework.context.IOnlineContext;
import com.kbstar.sqc.framework.data.IDataSet;
import com.kbstar.sqc.framework.data.impl.DataSet;
import com.kbstar.sqc.framework.exception.BusinessException;
import com.kbstar.sqc.framework.log.ILog;

/**
 * 기업집단신용평가이력관리 ProcessUnit (PM 진입점).
 *
 * <p>COBOL AIPBA30.cbl (AS 프로그램, 255행)을 n-KESA ProcessUnit으로 변환한 클래스이다.</p>
 *
 * <p>처리 순서:
 * <ol>
 *   <li>S1000 초기화: CommonArea 취득, 비계약업무구분코드 설정, IJICOMM 대응</li>
 *   <li>S2000 입력값검증: 처리구분/기업집단그룹코드/평가년월일/기업집단등록코드 필수 체크</li>
 *   <li>S3000 업무처리: DUCorpEvalHistoryA.manageCorpEvalHistory 호출, 응답 조립, 폼ID 설정</li>
 *   <li>S9000 처리종료: responseData 반환 (#OKEXIT 대응)</li>
 * </ol>
 * </p>
 *
 * <p>관련 COBOL 카피북:
 * <ul>
 *   <li>YNIPBA30.cpy (AS 입력, 96bytes): 처리구분(2), 기업집단그룹코드(3), 기업집단명(72),
 *       평가년월일(8), 평가기준년월일(8), 기업집단등록코드(3)</li>
 *   <li>YPIPBA30.cpy (AS 출력, 10bytes): 총건수(5), 현재건수(5)</li>
 * </ul>
 * </p>
 *
 * @author conversion-agent
 * @version 1.0
 * @since 2026-03-13
 */
@BizUnit("기업집단신용평가이력관리 ProcessUnit")
public class PUCorpEvalHistory extends ProcessUnit {

    // ----------------------------------------------------------------
    // 의존 DataUnit 주입 (COBOL #DYCALL DIPA301 대응)
    // 동일 컴포넌트(com.kbstar.kip.enbipba) 내이므로 @BizUnitBind 직접 주입
    // ----------------------------------------------------------------
    @BizUnitBind
    private DUCorpEvalHistoryA duCorpEvalHistoryA;


    // ----------------------------------------------------------------
    // PM 메서드
    // ----------------------------------------------------------------

    /**
     * 기업집단신용평가이력관리 거래 PM 메서드.
     *
     * <p>COBOL S0000-MAIN-RTN(S1000~S9000) 전체 처리를 담당한다.</p>
     *
     * <p>입력 파라미터 (requestData 키):
     * <ul>
     *   <li>prcssDstcd: 처리구분 (필수, '01'=신규평가/'02'=확정취소/'03'=삭제)</li>
     *   <li>corpClctGroupCd: 기업집단그룹코드 (필수, 3자리)</li>
     *   <li>valuaYmd: 평가년월일 (필수, 8자리)</li>
     *   <li>corpClctRegiCd: 기업집단등록코드 (필수, 3자리)</li>
     *   <li>corpClctName: 기업집단명 (72자리)</li>
     *   <li>valuaStdYmd: 평가기준년월일 (8자리)</li>
     * </ul>
     * </p>
     *
     * <p>출력 파라미터 (responseData 키):
     * <ul>
     *   <li>totalNoitm: 총건수</li>
     *   <li>nowNoitm: 현재건수</li>
     *   <li>formId: 폼ID ('V1' + 화면번호)</li>
     * </ul>
     * </p>
     *
     * <p>TODO: [거래코드 미확정] 메서드명 pmAipba30Xxxx01은 임시명 - 실제 거래코드 확보 후 수정 필요
     * 원본 구문: COBOL AIPBA30 프로그램명 기반 거래코드 확정 필요</p>
     *
     * @param requestData 입력 데이터셋 (YNIPBA30 카피북 대응 필드 포함)
     * @param onlineCtx   온라인 컨텍스트
     * @return 응답 데이터셋 (YPIPBA30 카피북 대응 필드 + formId)
     * @throws BusinessException 필수 입력값 누락, DU 처리 오류 발생 시
     */
    @BizMethod
    public IDataSet pmAipba30Xxxx01(IDataSet requestData, IOnlineContext onlineCtx) {

        ILog log = getLog(onlineCtx);
        log.debug("★[S0000-MAIN-RTN] PUCorpEvalHistory.pmAipba30Xxxx01 START");

        // ----------------------------------------------------------------
        // S1000: 초기화 (COBOL S1000-INITIALIZE-RTN 대응)
        // ----------------------------------------------------------------
        log.debug("★[S1000-INITIALIZE-RTN] 초기화 시작");

        // 출력영역 확보 (#GETOUT YPIPBA30-CA 대응)
        IDataSet responseData = new DataSet();

        // CommonArea 취득 (IJICOMM 공통IC 호출 대응)
        // 비계약업무구분코드 세팅 (COBOL MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD 대응)
        CommonArea ca = getCommonArea(onlineCtx);

        // TODO: [프레임워크 확인 필요] CommonArea에 비계약업무구분코드 세팅 방법 확인
        // 원본 구문: MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD (IJICOMM 호출 전 파라미터 세팅)
        // 프레임워크 CommonArea API 확인 후 ca.setNonCtrcBzwkDstcd(CCorpEvalConsts.NON_CTRC_BZWK_DSTCD) 형태로 수정
        // 현재는 requestData에 비계약업무구분코드를 포함하여 DU로 전달

        // IJICOMM 오류 처리 - CommonArea 취득 실패 시 예외 전파 (프레임워크가 처리)
        // 원본: IF COND-XIJICOMM-OK CONTINUE ELSE #ERROR XIJICOMM-R-ERRCD...
        // Java: getCommonArea 실패 시 프레임워크가 자동으로 BusinessException 발생

        String groupCoCd = (ca != null && ca.getGroupCoCd() != null)
                ? ca.getGroupCoCd() : "";
        String userEmpid = (ca != null && ca.getUserEmpid() != null)
                ? ca.getUserEmpid() : "";
        String screenNo = (ca != null && ca.getScreenNo() != null)
                ? ca.getScreenNo() : "";

        log.debug("★[S1000] groupCoCd=" + groupCoCd + ", userEmpid=" + userEmpid);

        // ----------------------------------------------------------------
        // S2000: 입력값 검증 (COBOL S2000-VALIDATION-RTN 대응)
        // ----------------------------------------------------------------
        log.debug("★[S2000-VALIDATION-RTN] 입력값 검증 시작");

        String prcssDstcd    = requestData.getString("prcssDstcd");
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String valuaYmd      = requestData.getString("valuaYmd");
        String corpClctRegiCd  = requestData.getString("corpClctRegiCd");

        log.debug("★[S2000] =입력항목=");
        log.debug("★[S2000] 처리구분=" + prcssDstcd);
        log.debug("★[S2000] 기업집단그룹코드=" + corpClctGroupCd);
        log.debug("★[S2000] 평가년월일=" + valuaYmd);
        log.debug("★[S2000] 기업집단등록코드=" + corpClctRegiCd);

        // 처리구분 필수 체크 (COBOL IF YNIPBA30-PRCSS-DSTCD = SPACE 대응)
        if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
            throw new BusinessException(
                    CCorpEvalConsts.ERR_B3800004,
                    CCorpEvalConsts.TREAT_UKIP0007,
                    "처리구분코드를 입력해 주십시오.");
        }

        // 기업집단그룹코드 필수 체크 (COBOL IF YNIPBA30-CORP-CLCT-GROUP-CD = SPACE 대응)
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException(
                    CCorpEvalConsts.ERR_B3800004,
                    CCorpEvalConsts.TREAT_UKIP0001,
                    "기업집단그룹코드 입력 후 다시 거래하세요.");
        }

        // 평가년월일 필수 체크 (COBOL IF YNIPBA30-VALUA-YMD = SPACE 대응)
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException(
                    CCorpEvalConsts.ERR_B3800004,
                    CCorpEvalConsts.TREAT_UKIP0003,
                    "평가일자 입력 후 다시 거래하세요.");
        }

        // 기업집단등록코드 필수 체크 (COBOL IF YNIPBA30-CORP-CLCT-REGI-CD = SPACE 대응)
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException(
                    CCorpEvalConsts.ERR_B3800004,
                    CCorpEvalConsts.TREAT_UKIP0002,
                    "기업집단등록코드 입력 후 다시 거래하세요.");
        }

        // ----------------------------------------------------------------
        // S3000: 업무처리 (COBOL S3000-PROCESS-RTN 대응)
        // ----------------------------------------------------------------
        log.debug("★[S3000-PROCESS-RTN] 업무처리 시작");

        // DC 입력 파라미터 조립 (COBOL MOVE YNIPBA30-CA TO XDIPA301-IN 대응)
        // 원본 requestData 직접 전달 금지 — 필드별 명시적 매핑 (conversion_plan 5.2 지침)
        IDataSet duParam = new DataSet();
        duParam.put("prcssDstcd",       prcssDstcd);
        duParam.put("corpClctGroupCd",  corpClctGroupCd);
        duParam.put("corpClctRegiCd",   corpClctRegiCd);
        duParam.put("valuaYmd",         valuaYmd);
        duParam.put("corpClctName",     requestData.getString("corpClctName"));
        duParam.put("valuaStdYmd",      requestData.getString("valuaStdYmd"));
        // CommonArea에서 취득한 공통 컨텍스트 값 (COBOL BICOM-* 대응)
        duParam.put("groupCoCd",        groupCoCd);
        duParam.put("userEmpid",        userEmpid);

        // DC 호출 (COBOL #DYCALL DIPA301 YCCOMMON-CA XDIPA301-CA 대응)
        // @BizUnitBind로 주입된 duCorpEvalHistoryA 직접 호출
        IDataSet duResult = duCorpEvalHistoryA.manageCorpEvalHistory(duParam, onlineCtx);

        // DC 호출 결과 확인 (COBOL IF NOT COND-XDIPA301-OK AND NOT COND-XDIPA301-NOTFOUND 대응)
        // Java에서는 DM 내 BusinessException이 자동 전파되므로 별도 re-throw 불필요
        // duResult == null 또는 정상/NOTFOUND 모두 정상 처리로 간주

        // 출력 파라미터 조립 (COBOL MOVE XDIPA301-OUT TO YPIPBA30-CA 대응)
        if (duResult != null) {
            responseData.put("totalNoitm", duResult.getString("totalNoitm"));
            responseData.put("nowNoitm",   duResult.getString("nowNoitm"));
        } else {
            responseData.put("totalNoitm", "00000");
            responseData.put("nowNoitm",   "00000");
        }

        // 폼ID 설정 (#BOFMID WK-FMID 대응)
        // COBOL: MOVE 'V1' TO WK-FMID(1:2), MOVE BICOM-SCREN-NO TO WK-FMID(3:11)
        // TODO: [프레임워크 확인 필요] #BOFMID 처리 방식 (프레임워크 자동 처리 vs responseData.put) 확인 필요
        String formId = CCorpEvalConsts.FORM_ID_PREFIX + screenNo;
        responseData.put("formId", formId);
        log.debug("★[S3000] formId=" + formId);

        // ----------------------------------------------------------------
        // S9000: 처리종료 (#OKEXIT CO-STAT-OK 대응)
        // ----------------------------------------------------------------
        log.debug("★[S9000-FINAL-RTN] 처리종료");
        return responseData;
    }

}
