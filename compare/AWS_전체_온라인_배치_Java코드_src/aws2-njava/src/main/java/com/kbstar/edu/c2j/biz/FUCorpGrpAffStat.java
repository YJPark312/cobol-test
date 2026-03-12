package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단계열사현황 FU 클래스.
 * <pre>
 * 유닛 설명 : 기업집단 계열사 현황 조회 및 관리 기능 단위
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
@BizUnit(value = "기업집단계열사현황", type = "FU")
public class FUCorpGrpAffStat extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA110 duTSKIPA110;

    /**
     * 기업집단계열사현황조회.
     * <pre>
     * 메소드 설명 : 기업집단의 계열사 현황 정보를 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단계열사현황조회")
    public IDataSet inquireCorpGrpAffStat(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단계열사현황조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // DU 호출하여 기업집단 기본정보 조회
            IDataSet corpGrpData = duTSKIPA110.selectCorpGrpBasicInfo(requestData, onlineCtx);
            
            responseData.put("returnCd", "00");
            responseData.put("returnMsg", "정상처리");
            responseData.put("prsntNoitm", corpGrpData.getRecordSet("LIST") != null ? 
                corpGrpData.getRecordSet("LIST").getRecordCount() : 0);
            
            log.debug("기업집단계열사현황조회 완료");
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B4200099", "UKII0803", "기업집단계열사현황조회 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 신규평가계열사조회.
     * <pre>
     * 메소드 설명 : 신규평가 대상 계열사 정보를 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("신규평가계열사조회")
    public IDataSet processNewEvaluationAffiliates(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("신규평가계열사조회 시작");
        
        // DU 호출하여 기업집단 기본정보 조회 (신규평가)
        IDataSet responseData = duTSKIPA110.selectCorpGrpBasicInfo(requestData, onlineCtx);
        
        log.debug("신규평가계열사조회 완료");
        return responseData;
    }

    /**
     * 기존평가계열사조회.
     * <pre>
     * 메소드 설명 : 기존평가 대상 계열사 정보를 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기존평가계열사조회")
    public IDataSet processExistingEvaluationAffiliates(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기존평가계열사조회 시작");
        
        // DU 호출하여 기업집단 기본정보 조회 (기존평가)
        IDataSet responseData = duTSKIPA110.selectCorpGrpBasicInfo(requestData, onlineCtx);
        
        log.debug("기존평가계열사조회 완료");
        return responseData;
    }
}
