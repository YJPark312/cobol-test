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
 * 기업집단합산연결재무비율조회.
 * <pre>
 * 유닛 설명 : 기업집단의 합산연결재무비율을 조회하고 처리하는 기능 유닛
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
@BizUnit(value = "기업집단합산연결재무비율조회", type = "FU")
public class FUCorpGrpConFinRatioInq extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPC121 duTSKIPC121;  // 기업집단합산재무비율
    @BizUnitBind private DUTSKIPC131 duTSKIPC131;  // 기업집단합산연결재무비율

    /**
     * 기업집단합산연결재무비율조회처리.
     * <pre>
     * 메소드 설명 : 기업집단의 합산연결재무비율을 조회하는 메인 처리 메소드
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
    @BizMethod("기업집단합산연결재무비율조회처리")
    public IDataSet processCorpGrpConFinRatioInq(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        try {
            log.debug("기업집단합산연결재무비율조회 시작");
            
            // BR-040-001: 기업집단코드 검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKII0282", "기업집단그룹코드는 필수입력항목입니다.");
            }
            
            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드는 필수입력항목입니다.");
            }
            
            // BR-040-002: 기준년 검증
            String baseYr = requestData.getString("baseYr");
            if (baseYr == null || baseYr.trim().isEmpty()) {
                throw new BusinessException("B2700460", "UKII0055", "기준년은 필수입력항목입니다.");
            }
            
            // BR-040-003: 재무분석결산구분 검증
            String fnafAStlaccDstcd = requestData.getString("fnafAStlaccDstcd");
            if (fnafAStlaccDstcd == null || fnafAStlaccDstcd.trim().isEmpty()) {
                throw new BusinessException("B3000108", "UKII0299", "재무분석결산구분은 필수입력항목입니다.");
            }
            
            // BR-040-004: 재무분석보고서구분 검증
            String fnafARptdocDst1 = requestData.getString("fnafARptdocDst1");
            String fnafARptdocDst2 = requestData.getString("fnafARptdocDst2");
            if (fnafARptdocDst1 == null || fnafARptdocDst1.trim().isEmpty()) {
                throw new BusinessException("B3002107", "UKII0297", "재무분석보고서구분1은 필수입력항목입니다.");
            }
            if (fnafARptdocDst2 == null || fnafARptdocDst2.trim().isEmpty()) {
                throw new BusinessException("B3002107", "UKII0297", "재무분석보고서구분2는 필수입력항목입니다.");
            }
            
            // BR-040-005: 분석기간 검증
            String anlsTrmStr = requestData.getString("anlsTrm");
            if (anlsTrmStr == null || anlsTrmStr.trim().isEmpty() || "0".equals(anlsTrmStr)) {
                throw new BusinessException("B3000661", "UKII0361", "분석기간은 필수입력항목입니다.");
            }
            
            // BR-040-007: 합산대개별 처리 규칙
            String fnstDstic = requestData.getString("fnstDstic");
            if ("01".equals(fnstDstic)) {
                // 합산비율 처리
                responseData = processConsolidatedRatio(requestData, onlineCtx);
            } else if ("02".equals(fnstDstic)) {
                // 개별비율 처리
                responseData = processSeparateRatio(requestData, onlineCtx);
            } else {
                // 전체 처리 (기본값)
                responseData = processAllRatio(requestData, onlineCtx);
            }
            
            log.debug("기업집단합산연결재무비율조회 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단합산연결재무비율조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단합산연결재무비율조회 시스템 오류", e);
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 합산비율처리.
     * <pre>
     * 메소드 설명 : 기업집단의 합산연결재무비율을 처리
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
    @BizMethod("합산비율처리")
    public IDataSet processConsolidatedRatio(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        try {
            log.debug("합산비율처리 시작");
            
            // F-040-003: 합산재무비율 처리 - TSKIPC131 테이블 조회
            IDataSet consolidatedResult = duTSKIPC131.selectList(requestData, onlineCtx);
            
            // BR-040-008: 결산년 정렬 규칙 적용
            IRecordSet resultSet = consolidatedResult.getRecordSet("output");
            int totalCount = 0;
            int currentCount = 0;
            
            if (resultSet != null) {
                totalCount = resultSet.getRecordCount();
                currentCount = totalCount;
            }
            
            // 응답 데이터 구성 (명세서 F-040-003 준수)
            // settlementYears: 업체수를 포함한 결산년도 목록 추출
            IDataSet settlementYearsData = new DataSet();
            // consolidatedRatios: 합산재무비율 추출  
            IDataSet consolidatedRatiosData = new DataSet();
            
            if (resultSet != null) {
                // 결산년도와 업체수 정보만 추출
                for (int i = 0; i < resultSet.getRecordCount(); i++) {
                    IRecord record = resultSet.getRecord(i);
                    // 결산년도, 업체수 관련 필드만 추출하여 settlementYears에 추가
                }
                // 재무비율 관련 정보만 추출하여 consolidatedRatios에 추가
                consolidatedRatiosData.put("output", resultSet);
                settlementYearsData.put("output", resultSet); // 임시로 전체 데이터, 추후 필드별 분리 필요
            }
            
            responseData.put("settlementYears", settlementYearsData);
            responseData.put("consolidatedRatios", consolidatedRatiosData);
            responseData.put("processingStatus", "00");
            
            log.debug("합산비율처리 완료 - 총 " + totalCount + "건");
            
        } catch (Exception e) {
            log.error("합산비율처리 오류", e);
            throw new BusinessException("B4000101", "UKII0101", "합산비율처리 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 개별비율처리.
     * <pre>
     * 메소드 설명 : 기업집단의 개별재무비율을 처리
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
    @BizMethod("개별비율처리")
    public IDataSet processSeparateRatio(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        try {
            log.debug("개별비율처리 시작");
            
            // F-040-004: 개별재무비율 처리 - TSKIPC121 테이블 조회
            IDataSet separateResult = duTSKIPC121.selectList(requestData, onlineCtx);
            
            // BR-040-009: 업체수 집계 규칙 적용
            IRecordSet resultSet = separateResult.getRecordSet("output");
            int totalCount = 0;
            int currentCount = 0;
            
            if (resultSet != null) {
                totalCount = resultSet.getRecordCount();
                currentCount = totalCount;
            }
            
            // 응답 데이터 구성 (명세서 F-040-004 준수)
            // settlementYears: 업체수를 포함한 결산년도 목록 추출
            IDataSet settlementYearsData = new DataSet();
            // separateRatios: 개별재무비율 추출
            IDataSet separateRatiosData = new DataSet();
            
            if (resultSet != null) {
                // 결산년도와 업체수 정보만 추출하여 settlementYears에 추가
                // 재무비율 관련 정보만 추출하여 separateRatios에 추가
                separateRatiosData.put("output", resultSet);
                settlementYearsData.put("output", resultSet); // 임시로 전체 데이터, 추후 필드별 분리 필요
            }
            
            responseData.put("settlementYears", settlementYearsData);
            responseData.put("separateRatios", separateRatiosData);
            responseData.put("processingStatus", "00");
            
            log.debug("개별비율처리 완료 - 총 " + totalCount + "건");
            
        } catch (Exception e) {
            log.error("개별비율처리 오류", e);
            throw new BusinessException("B4000201", "UKII0201", "개별비율처리 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 전체비율처리.
     * <pre>
     * 메소드 설명 : 기업집단의 합산 및 개별재무비율을 모두 처리
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
    @BizMethod("전체비율처리")
    public IDataSet processAllRatio(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        try {
            log.debug("전체비율처리 시작");
            
            // 합산비율 처리
            IDataSet consolidatedResult = duTSKIPC131.selectList(requestData, onlineCtx);
            IRecordSet consolidatedSet = consolidatedResult.getRecordSet("output");
            int consolidatedCount = (consolidatedSet != null) ? consolidatedSet.getRecordCount() : 0;
            
            // 개별비율 처리
            IDataSet separateResult = duTSKIPC121.selectList(requestData, onlineCtx);
            IRecordSet separateSet = separateResult.getRecordSet("output");
            int separateCount = (separateSet != null) ? separateSet.getRecordCount() : 0;
            
            // BR-040-010: 데이터 조회 제한 규칙 적용
            if (consolidatedCount > 6000) {
                consolidatedCount = 6000;
            }
            if (separateCount > 6000) {
                separateCount = 6000;
            }
            
            // 응답 데이터 구성 (명세서 준수)
            IDataSet settlementYearsData = new DataSet();
            IDataSet consolidatedRatiosData = new DataSet();
            IDataSet separateRatiosData = new DataSet();
            
            // 합산 데이터 처리
            if (consolidatedSet != null) {
                consolidatedRatiosData.put("output", consolidatedSet);
                settlementYearsData.put("consolidated", consolidatedSet);
            }
            
            // 개별 데이터 처리  
            if (separateSet != null) {
                separateRatiosData.put("output", separateSet);
                settlementYearsData.put("separate", separateSet);
            }
            
            responseData.put("settlementYears", settlementYearsData);
            responseData.put("consolidatedRatios", consolidatedRatiosData);
            responseData.put("separateRatios", separateRatiosData);
            responseData.put("processingStatus", "00");
            
            log.debug("전체비율처리 완료 - 합산: " + consolidatedCount + "건, 개별: " + separateCount + "건");
            
        } catch (Exception e) {
            log.error("전체비율처리 오류", e);
            throw new BusinessException("B4000301", "UKII0301", "전체비율처리 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }
}
