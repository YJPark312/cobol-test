package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단신용등급조회.
 * <pre>
 * 유닛 설명 : 기업집단 신용등급 정보를 조회하고 등급조정 처리를 수행하는 기능 유닛
 * ---------------------------------------------------------------------------------
 *  버전	일자			작성자			설명
 * ---------------------------------------------------------------------------------
 *   1.0	20251001	MultiQ4KBBank		최초 작성
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank
 * @since 2025-10-01
 */
@BizUnit(value = "기업집단신용등급조회", type = "FU")
public class FUCorpGrpCrdtRatingInq extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPB110 duTSKIPB110;

    /**
     * 기업집단신용등급조회처리.
     * <pre>
     * 메소드 설명 : 기업집단 신용등급 정보를 조회하고 등급조정 로직을 적용하여 결과를 반환
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : fnafScor [재무점수] (numeric)
     *	- field : nonFnafScor [비재무점수] (numeric)
     *	- field : chsnScor [결합점수] (numeric)
     *	- field : spareCGrdDstcd [예비집단등급구분코드] (string)
     *	- field : newScGrdDstcd [신예비집단등급구분코드] (string)
     *	- field : grdAdjsDstic [등급조정구분] (string)
     *	- field : grdAdjsResnCtnt [등급조정사유내용] (string)
     *	- field : storgYn [저장여부] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단신용등급조회처리")
    public IDataSet processCorpGrpCrdtRatingInq(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // BR-015-001: 입력 매개변수 검증
            validateInputParameters(requestData);
            
            // BR-015-002: 기업집단 신용데이터 조회
            IDataSet creditData = duTSKIPB110.select(requestData, onlineCtx);
            
            // BR-015-003: 등급조정 처리 로직 적용
            processGradeAdjustment(creditData, responseData);
            
            // BR-015-004: 신용점수 데이터 무결성 유지
            transferCreditScores(creditData, responseData);
            
            log.debug("기업집단신용등급조회 완료");

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B2900042", "UKII0182", "시스템 오류", e);
        }

        return responseData;
    }

    /**
     * 입력 매개변수 검증 (BR-015-001).
     */
    private void validateInputParameters(IDataSet requestData) {
        String groupCoCd = requestData.getString("groupCoCd");
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        String valuaYmd = requestData.getString("valuaYmd");

        if (groupCoCd == null || groupCoCd.trim().isEmpty()) {
            throw new BusinessException("B3600003", "UKFH0208", "그룹회사코드 확인");
        }
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드 확인");
        }
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드 확인");
        }
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException("B2701130", "UKII0244", "평가년월일 확인");
        }
    }

    /**
     * 등급조정 처리 로직 (BR-015-003).
     */
    private void processGradeAdjustment(IDataSet creditData, IDataSet responseData) {
        String grdAdjsDstcd = creditData.getString("grdAdjsDstcd");
        String corpCpStgeDstcd = creditData.getString("corpCpStgeDstcd");
        
        if ("9".equals(grdAdjsDstcd) && "6".equals(corpCpStgeDstcd)) {
            // 등급조정구분=9이고 처리단계=6인 경우
            responseData.put("storgYn", "Y");
            responseData.put("grdAdjsDstic", "0");
        } else if ("9".equals(grdAdjsDstcd) && !"6".equals(corpCpStgeDstcd)) {
            // 등급조정구분=9이고 처리단계≠6인 경우
            responseData.put("storgYn", "N");
            responseData.put("grdAdjsDstic", grdAdjsDstcd);
        } else {
            // 기타 모든 경우
            responseData.put("storgYn", "Y");
            responseData.put("grdAdjsDstic", grdAdjsDstcd);
            responseData.put("grdAdjsResnCtnt", creditData.getString("grdAdjsResnCtnt"));
        }
    }

    /**
     * 신용점수 데이터 전송 (BR-015-004).
     */
    private void transferCreditScores(IDataSet creditData, IDataSet responseData) {
        // COMP-3 정밀도 유지하여 점수 데이터 전송
        responseData.put("fnafScor", creditData.get("fnafScor"));
        responseData.put("nonFnafScor", creditData.get("nonFnafScor"));
        responseData.put("chsnScor", creditData.get("chsnScor"));
        responseData.put("spareCGrdDstcd", creditData.getString("spareCGrdDstcd"));
        responseData.put("newScGrdDstcd", ""); // 신예비집단등급구분코드는 향후 사용을 위해 예약
    }
}
