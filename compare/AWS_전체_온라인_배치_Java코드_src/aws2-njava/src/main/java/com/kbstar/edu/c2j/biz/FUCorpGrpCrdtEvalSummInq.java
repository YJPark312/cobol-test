package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.common.CommonArea;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단신용평가요약조회.
 * <pre>
 * 유닛 설명 : 기업집단 신용평가 요약 정보를 조회하는 기능 유닛
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
@BizUnit(value = "기업집단신용평가요약조회", type = "FU")
public class FUCorpGrpCrdtEvalSummInq extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPB110 duTSKIPB110;
    @BizUnitBind private DUTSKIPB130 duTSKIPB130;

    /**
     * 기업집단신용평가요약조회처리.
     * <pre>
     * 메소드 설명 : 기업집단 신용평가 요약 정보를 조회하는 메인 처리 메소드
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단신용평가요약조회처리")
    public IDataSet processCorpGrpCrdtEvalSummInq(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);

        try {
            // F-032-002: 평가완료상태 조회
            IDataSet completionStatus = getEvaluationCompletionStatus(requestData, onlineCtx);
            
            // F-032-003: 신용평가 요약 데이터 검색
            IDataSet summaryData = getCreditEvaluationSummaryData(requestData, onlineCtx);
            
            // 응답 데이터 구성
            responseData.put("fnshYn", completionStatus.getString("fnshYn"));
            responseData.put("adjsStgeNoDstcd", completionStatus.getString("adjsStgeNoDstcd"));
            responseData.put("comtCtnt", completionStatus.getString("comtCtnt"));
            responseData.put("totalNoitm", summaryData.get("totalNoitm"));
            responseData.put("prsntNoitm", summaryData.get("prsntNoitm"));
            responseData.put("evalGridData", summaryData.get("evalGridData"));
            
            log.debug("기업집단 신용평가 요약 조회 처리 완료");

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B2900042", "UKII0182", "기업집단 신용평가 요약 조회 처리 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 평가완료상태조회.
     * <pre>
     * 메소드 설명 : 기업집단 신용평가 완료상태를 검색하고 결정
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("평가완료상태조회")
    public IDataSet getEvaluationCompletionStatus(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // TSKIPB110 테이블에서 기업집단평가기본정보 조회 (기존 메소드 사용)
            IDataSet basicInfo = duTSKIPB110.selectList(requestData, onlineCtx);
            
            String fnshYn = "N";
            String adjsStgeNoDstcd = "";
            String comtCtnt = "";
            
            if (basicInfo != null && basicInfo.getRecordSet("resultSet").getRecordCount() > 0) {
                IRecordSet rs = basicInfo.getRecordSet("resultSet");
                
                // BR-032-004: 평가완료상태 결정 (WP-025~036 성공 패턴 적용)
                IRecord firstRecord = rs.getRecord(0);
                String corpCpStgeDstcd = firstRecord.getString("corpCpStgeDstcd");
                if ("5".equals(corpCpStgeDstcd) || "6".equals(corpCpStgeDstcd)) {
                    fnshYn = "Y";
                    adjsStgeNoDstcd = firstRecord.getString("adjsStgeNoDstcd");
                    
                    // BR-032-005: 등급조정 의견 주석 검색
                    IDataSet commentData = new DataSet();
                    commentData.put("groupCoCd", requestData.getString("groupCoCd"));
                    commentData.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
                    commentData.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
                    commentData.put("valuaYmd", requestData.getString("valuaYmd"));
                    commentData.put("comtClsfCd", "27");
                    commentData.put("seqNo", "1");
                    
                    // BR-032-005: 등급조정 의견 주석 검색 (기존 메소드 사용)
                    IDataSet commentResult = duTSKIPB130.select(commentData, onlineCtx);
                    if (commentResult != null && commentResult.getRecordSet("resultSet").getRecordCount() > 0) {
                        IRecordSet commentRs = commentResult.getRecordSet("resultSet");
                        IRecord commentRecord = commentRs.getRecord(0);
                        comtCtnt = commentRecord.getString("comtCtnt");
                    }
                }
            }
            
            responseData.put("fnshYn", fnshYn);
            responseData.put("adjsStgeNoDstcd", adjsStgeNoDstcd);
            responseData.put("comtCtnt", comtCtnt);
            
            log.debug("평가완료상태 조회 완료 - 완료여부: " + fnshYn);

        } catch (Exception e) {
            throw new BusinessException("B4200223", "UKII0182", "평가완료상태 조회 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 신용평가요약데이터검색.
     * <pre>
     * 메소드 설명 : 기업집단에 대한 포괄적인 신용평가 요약 데이터를 검색
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("신용평가요약데이터검색")
    public IDataSet getCreditEvaluationSummaryData(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // BR-032-006: 다년도 평가 데이터 검색 (기존 메소드 사용)
            IDataSet evalData = duTSKIPB110.selectList(requestData, onlineCtx);
            
            int totalCount = 0;
            int currentCount = 0;
            
            if (evalData != null && evalData.getRecordSet("resultSet") != null) {
                IRecordSet rs = evalData.getRecordSet("resultSet");
                totalCount = rs.getRecordCount();
                currentCount = totalCount;
                
                // 평가 그리드 데이터 구성
                responseData.put("evalGridData", rs);
            }
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", currentCount);
            
            log.debug("신용평가 요약 데이터 검색 완료 - 총건수: " + totalCount);

        } catch (Exception e) {
            throw new BusinessException("B3900009", "UBNA0048", "신용평가 요약 데이터 검색 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }
}
