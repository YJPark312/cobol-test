package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단요약정보 FU 클래스.
 * <pre>
 * 유닛 설명 : 기업집단 요약 정보 조회 및 관리 기능 단위
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
@BizUnit(value = "기업집단요약정보", type = "FU")
public class FUCorpGrpSummInfo extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA110 duTSKIPA110;

    /**
     * 기업집단계열사조회.
     * <pre>
     * 메소드 설명 : 기업집단의 계열사 요약 정보를 조회
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
    @BizMethod("기업집단계열사조회")
    public IDataSet inquireCorpGrpAffiliates(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단계열사조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 처리구분에 따른 분기 처리
            String prcssDstcd = requestData.getString("prcssDstcd");
            
            if ("1".equals(prcssDstcd)) {
                // 신규평가 처리
                IDataSet affiliateResult = duTSKIPA110.selectCorpGrpAffiliateStatus(requestData, onlineCtx);
                responseData.putAll(affiliateResult);
                
                IDataSet finDataResult = duTSKIPA110.selectCorpGrpAffiliateFinData(requestData, onlineCtx);
                if (finDataResult.getRecordSet("LIST") != null) {
                    responseData.put("affiliateGrid1", finDataResult.getRecordSet("LIST"));
                }
                
            } else if ("2".equals(prcssDstcd)) {
                // 기존평가 처리
                IDataSet existingResult = duTSKIPA110.selectCorpGrpAffiliateStatus(requestData, onlineCtx);
                responseData.putAll(existingResult);
                
                if (existingResult.getRecordSet("LIST") != null) {
                    responseData.put("affiliateGrid1", existingResult.getRecordSet("LIST"));
                }
            }
            
            // 출력그리드 처리 - 기본 응답 필드 설정
            IRecordSet affiliateGrid = responseData.getRecordSet("affiliateGrid1");
            if (affiliateGrid != null && affiliateGrid.getRecordCount() > 0) {
                responseData.put("exmtnCustIdnfr", affiliateGrid.getRecord(0).getString("exmtnCustIdnfr"));
                responseData.put("coprName", affiliateGrid.getRecord(0).getString("coprName"));
                responseData.put("totalAsam", affiliateGrid.getRecord(0).getString("totalAsam"));
                responseData.put("salepr", affiliateGrid.getRecord(0).getString("salepr"));
                responseData.put("captlTsumnAmt", affiliateGrid.getRecord(0).getString("captlTsumnAmt"));
                responseData.put("netPrft", affiliateGrid.getRecord(0).getString("netPrft"));
                responseData.put("oprft", affiliateGrid.getRecord(0).getString("oprft"));
            }
            
            responseData.put("returnCd", "00");
            responseData.put("returnMsg", "정상처리");
            
            log.debug("기업집단계열사조회 완료");
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B4200099", "UKII0803", "기업집단계열사조회 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }
}
