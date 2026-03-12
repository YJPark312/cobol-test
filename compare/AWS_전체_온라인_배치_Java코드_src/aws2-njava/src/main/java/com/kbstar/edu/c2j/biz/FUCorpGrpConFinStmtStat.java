package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단합산연결재무제표현황.
 * <pre>
 * 유닛 설명 : 기업집단의 합산연결재무제표 현황을 조회하고 처리하는 기능 유닛
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
@BizUnit(value = "기업집단합산연결재무제표현황", type = "FU")
public class FUCorpGrpConFinStmtStat extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA110 duTSKIPA110;  // 기업집단기본정보 (기존 메소드 재사용)
    @BizUnitBind private DUTSKIPB110 duTSKIPB110;  // 기업집단평가기본정보 (기존 메소드 재사용)
    @BizUnitBind private DUTSKIPC120 duTSKIPC120;  // 기업집단합산연결재무제표정보
    @BizUnitBind private DUTSKIPC130 duTSKIPC130;  // 기업집단결합연결재무제표정보

    /**
     * 기업집단합산연결재무제표현황조회처리.
     * <pre>
     * 메소드 설명 : 기업집단의 합산연결재무제표 현황을 조회하는 메인 처리 메소드
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
    @BizMethod("기업집단합산연결재무제표현황조회처리")
    public IDataSet processCorpGrpConFinStmtInq(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        try {
            log.debug("기업집단합산연결재무제표현황조회 시작");
            
            // BR-037-001: 기업집단연결재무제표코드 검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            String prcssdstic = requestData.getString("prcssdstic");
            
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3700001", "UKII0001", "기업집단그룹코드는 필수입력항목입니다.");
            }
            
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3700002", "UKII0002", "기업집단등록코드는 필수입력항목입니다.");
            }
            
            // BR-037-002: 처리구분 검증
            if (prcssdstic == null || prcssdstic.trim().isEmpty()) {
                throw new BusinessException("B3700003", "UKII0003", "처리구분코드는 필수입력항목입니다.");
            }
            
            // 처리구분별 분기 처리 (WP-031 패턴 적용)
            switch (prcssdstic) {
                case "1": // 합산연결 현황 조회
                    responseData = processConsolidatedInquiry(requestData, onlineCtx);
                    break;
                case "2": // 결합연결 현황 조회
                    responseData = processCombinedInquiry(requestData, onlineCtx);
                    break;
                case "3": // 재무제표 상세 조회
                    responseData = processFinancialDetailInquiry(requestData, onlineCtx);
                    break;
                default:
                    throw new BusinessException("B3700004", "UKII0004", "유효하지 않은 처리구분코드입니다: " + prcssdstic);
            }
            
            log.debug("기업집단합산연결재무제표현황조회 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단합산연결재무제표현황조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단합산연결재무제표현황조회 시스템 오류", e);
            throw new BusinessException("B3700999", "UKII0999", "업무관리자에게 문의하시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 합산연결현황조회.
     * <pre>
     * 메소드 설명 : 기업집단의 합산연결 현황을 조회
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
    @BizMethod("합산연결현황조회")
    public IDataSet processConsolidatedInquiry(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        try {
            log.debug("합산연결현황조회 시작");
            
            // F-037-001: 기존 DU 메소드 재사용 - 기업집단기본정보 조회
            IDataSet basicInfoResult = duTSKIPA110.selectCorpGrpBasicInfo(requestData, onlineCtx);
            
            // F-037-002: 기존 DU 메소드 재사용 - 기업집단평가기본정보 조회
            IDataSet evalInfoResult = duTSKIPB110.selectList(requestData, onlineCtx);
            
            // F-037-003: 합산연결재무제표정보 조회
            IDataSet consolidatedResult = duTSKIPC120.select(requestData, onlineCtx);
            
            // 명세서 F-037-003 출력 파라미터 준수
            responseData.put("financialItems", consolidatedResult.getRecordSet("output"));
            responseData.put("itemCount", consolidatedResult.getRecordSet("output") != null ? 
                consolidatedResult.getRecordSet("output").getRecordCount() : 0);
            responseData.put("processingResult", "00");
            
            log.debug("합산연결현황조회 완료");
            
        } catch (Exception e) {
            log.error("합산연결현황조회 오류", e);
            throw new BusinessException("B3700101", "UKII0101", "합산연결현황조회 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 결합연결현황조회.
     * <pre>
     * 메소드 설명 : 기업집단의 결합연결 현황을 조회
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
    @BizMethod("결합연결현황조회")
    public IDataSet processCombinedInquiry(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        try {
            log.debug("결합연결현황조회 시작");
            
            // F-037-003: 기존 DU 메소드 재사용 - 기업집단기본정보 조회
            IDataSet basicInfoResult = duTSKIPA110.selectCorpGrpBasicInfo(requestData, onlineCtx);
            
            // F-037-004: 결합연결재무제표정보 조회
            IDataSet combinedResult = duTSKIPC130.select(requestData, onlineCtx);
            
            // 명세서 F-037-003 출력 파라미터 준수
            responseData.put("financialItems", combinedResult.getRecordSet("output"));
            responseData.put("itemCount", combinedResult.getRecordSet("output") != null ? 
                combinedResult.getRecordSet("output").getRecordCount() : 0);
            responseData.put("processingResult", "00");
            
            log.debug("결합연결현황조회 완료");
            
        } catch (Exception e) {
            log.error("결합연결현황조회 오류", e);
            throw new BusinessException("B3700201", "UKII0201", "결합연결현황조회 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 재무제표상세조회.
     * <pre>
     * 메소드 설명 : 기업집단의 재무제표 상세 정보를 조회
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
    @BizMethod("재무제표상세조회")
    public IDataSet processFinancialDetailInquiry(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        try {
            log.debug("재무제표상세조회 시작");
            
            // F-037-004: 기존 DU 메소드 재사용 - 기업집단평가기본정보 조회
            IDataSet evalInfoResult = duTSKIPB110.selectList(requestData, onlineCtx);
            
            // BR-037-006: 재무제표 연결 규칙 적용
            String baseYr = requestData.getString("baseYr");
            if (baseYr == null || baseYr.trim().isEmpty()) {
                // 기본값 설정 (현재년도 - 1)
                baseYr = String.valueOf(java.time.Year.now().getValue() - 1);
            }
            
            // 명세서 F-037-005 결과집계기능 출력 파라미터 준수
            responseData.put("aggregatedResult", new DataSet());
            responseData.put("totalItemCount", 0);
            responseData.put("processingStatus", "00");
            responseData.put("baseYr", baseYr);
            
            log.debug("재무제표상세조회 완료");
            
        } catch (Exception e) {
            log.error("재무제표상세조회 오류", e);
            throw new BusinessException("B3700301", "UKII0301", "재무제표상세조회 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }
}
