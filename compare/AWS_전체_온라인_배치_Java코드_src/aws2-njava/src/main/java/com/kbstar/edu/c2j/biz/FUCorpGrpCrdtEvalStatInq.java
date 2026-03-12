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
 * 기업집단신용평가현황 FU 클래스.
 * <pre>
 * 유닛 설명 : 기업집단 신용평가 현황 조회 및 처리 기능 단위
 * ---------------------------------------------------------------------------------
 *  버전	일자			작성자			설명
 * ---------------------------------------------------------------------------------
 *   1.0	20251002	MultiQ4KBBank		최초 작성 (복구)
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank, 2025-10-02
 * @since 2025-10-02
 */
@BizUnit(value = "기업집단신용평가현황", type = "FU")
public class FUCorpGrpCrdtEvalStatInq extends com.kbstar.sqc.base.FunctionUnit {

    // DM 레이어 바인딩 - 기존 DU 클래스들 활용
    @BizUnitBind private DUTSKIPA110 duTSKIPA110;
    @BizUnitBind private DUTSKIPA130 duTSKIPA130;

    /**
     * 기업집단신용평가현황 처리.
     * <pre>
     * 메소드 설명 : 기업집단신용평가현황 조회 및 처리를 수행하는 주요 기능
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251002	MultiQ4KBBank		최초 작성 (복구)
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank, 2025-10-02
     * @since 2025-10-02
     */
    @BizMethod("기업집단신용평가현황처리")
    public IDataSet processCorpGrpCrdtEvalStat(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단신용평가현황 처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 검증
            validateInput(requestData, onlineCtx);
            
            // DU 호출하여 기업집단 기본정보 조회
            IDataSet corpGrpData = duTSKIPA110.selectCorpGrpBasicInfo(requestData, onlineCtx);
            
            // DU 호출하여 재무분석 정보 조회 (간단한 조회로 대체)
            IDataSet finAnalData = duTSKIPA130.select(requestData, onlineCtx);
            
            // 응답 데이터 구성
            responseData.put("returnCd", "00");
            responseData.put("returnMsg", "정상처리");
            responseData.put("CORP_GRP_INFO", corpGrpData.get("LIST"));
            responseData.put("FIN_ANAL_INFO", finAnalData.get("LIST"));
            
            log.debug("기업집단신용평가현황 처리 완료");
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B4200099", "UKII0803", "기업집단신용평가현황 처리 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 입력 검증.
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     */
    private void validateInput(IDataSet requestData, IOnlineContext onlineCtx) {
        // 기업집단그룹코드 검증
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIF0072", "기업집단그룹코드는 필수입력항목입니다.");
        }
        
        // 평가기준년월일 검증
        String valuaBaseYmd = requestData.getString("valuaBaseYmd");
        if (valuaBaseYmd == null || valuaBaseYmd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIF0072", "평가기준년월일은 필수입력항목입니다.");
        }
        if (!valuaBaseYmd.matches("^\\d{8}$")) {
            throw new BusinessException("B3800004", "UKIF0072", "평가기준년월일은 YYYYMMDD 형식이어야 합니다.");
        }
    }
}
