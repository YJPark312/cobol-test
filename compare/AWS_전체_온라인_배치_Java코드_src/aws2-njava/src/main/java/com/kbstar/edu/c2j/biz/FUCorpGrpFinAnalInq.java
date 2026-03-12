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
 * 기업집단재무분석조회.
 * <pre>
 * 유닛 설명 : 기업집단의 재무분석 데이터를 조회하고 분석하는 기능 유닛
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
@BizUnit(value = "기업집단재무분석조회", type = "FU")
public class FUCorpGrpFinAnalInq extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA111 duTSKIPA111;
    @BizUnitBind private DUTSKIPA121 duTSKIPA121;
    @BizUnitBind private DUTSKIPA130 duTSKIPA130;

    /**
     * 기업집단재무분석조회처리.
     * <pre>
     * 메소드 설명 : 기업집단의 재무분석 데이터를 조회하고 분석하는 처리
     * 비즈니스 기능:
     * - BR-027-001: 기업집단등록코드 검증
     * - BR-027-002: 기업집단그룹코드 검증
     * - BR-027-003: 데이터 완전성 검증
     * - BR-027-004: 날짜 형식 검증
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
    @BizMethod("기업집단재무분석조회처리")
    public IDataSet inquireCorpGrpFinAnalysis(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단재무분석조회처리 시작");
            
            // 입력 데이터 로깅
            log.debug("입력 파라미터 - 처리구분코드: " + requestData.getString("prcssDstcd"));
            log.debug("입력 파라미터 - 기업집단그룹코드: " + requestData.getString("corpClctGroupCd"));
            log.debug("입력 파라미터 - 기업집단등록코드: " + requestData.getString("corpClctRegiCd"));

            // BR-027-001: 기업집단등록코드 검증
            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B2900001", "UKII0001", "기업집단등록코드는 필수입력항목입니다.");
            }

            // BR-027-002: 기업집단그룹코드 검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B2900002", "UKII0002", "기업집단그룹코드는 필수입력항목입니다.");
            }

            // BR-027-004: 날짜 형식 검증
            String baseYm = requestData.getString("baseYm");
            if (baseYm != null && !baseYm.trim().isEmpty()) {
                if (!baseYm.matches("^\\d{6}$")) {
                    throw new BusinessException("B2900003", "UKII0003", "기준년월은 YYYYMM 형식이어야 합니다.");
                }
            }
            
            String valuaYmd = requestData.getString("valuaYmd");
            if (valuaYmd != null && !valuaYmd.trim().isEmpty()) {
                if (!valuaYmd.matches("^\\d{8}$")) {
                    throw new BusinessException("B2900004", "UKII0004", "평가년월일은 YYYYMMDD 형식이어야 합니다.");
                }
            }

            // F-027-001: 기업집단 그룹정보 조회 (FM → DM 호출)
            log.debug("기업집단 그룹정보 조회 시작");
            IDataSet groupInfoReq = new DataSet();
            groupInfoReq.put("groupCoCd", requestData.getString("groupCoCd"));
            groupInfoReq.put("corpClctGroupCd", corpClctGroupCd);
            groupInfoReq.put("corpClctName", requestData.getString("corpClctName"));
            
            IDataSet groupInfoResult = duTSKIPA111.selectByName(groupInfoReq, onlineCtx);
            
            // F-027-002: 월별기업관계연결정보 조회
            log.debug("월별기업관계연결정보 조회 시작");
            IDataSet relationReq = new DataSet();
            relationReq.put("corpClctGroupCd", corpClctGroupCd);
            relationReq.put("corpClctRegiCd", corpClctRegiCd);
            relationReq.put("baseYm", requestData.getString("baseYm"));
            
            IDataSet relationResult = duTSKIPA121.selectRelationInfo(relationReq, onlineCtx);

            // F-027-003: 기업재무대상관리정보 조회
            log.debug("기업재무대상관리정보 조회 시작");
            IDataSet finTargetReq = new DataSet();
            finTargetReq.put("corpClctGroupCd", corpClctGroupCd);
            finTargetReq.put("corpClctRegiCd", corpClctRegiCd);
            finTargetReq.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IDataSet finTargetResult = duTSKIPA130.selectFinTargetInfo(finTargetReq, onlineCtx);

            // BR-027-003: 데이터 완전성 검증
            int totalRecords = 0;
            if (groupInfoResult.getRecordSet("grid1") != null) {
                totalRecords += groupInfoResult.getRecordSet("grid1").getRecordCount();
            }
            if (relationResult.getRecordSet("relationList") != null) {
                totalRecords += relationResult.getRecordSet("relationList").getRecordCount();
            }
            if (finTargetResult.getRecordSet("finTargetList") != null) {
                totalRecords += finTargetResult.getRecordSet("finTargetList").getRecordCount();
            }

            // 응답 데이터 구성
            responseData.put("returnCd", "00");
            responseData.put("returnMsg", "정상처리되었습니다.");
            responseData.put("totalRecords", totalRecords);
            
            // 기업집단 그룹정보
            if (groupInfoResult.getRecordSet("grid1") != null) {
                responseData.put("groupInfo", groupInfoResult.getRecordSet("grid1"));
            }
            
            // 월별기업관계연결정보
            if (relationResult.getRecordSet("relationList") != null) {
                responseData.put("relationInfo", relationResult.getRecordSet("relationList"));
            }
            
            // 기업재무대상관리정보
            if (finTargetResult.getRecordSet("finTargetList") != null) {
                responseData.put("finTargetInfo", finTargetResult.getRecordSet("finTargetList"));
            }

            log.debug("기업집단재무분석조회처리 완료 - 총 " + totalRecords + "건");

        } catch (BusinessException be) {
            log.error("기업집단재무분석조회처리 비즈니스 오류: " + be.getMessage());
            responseData.put("returnCd", be.getErrorCode());
            responseData.put("returnMsg", be.getMessage());
        } catch (Exception e) {
            log.error("기업집단재무분석조회처리 시스템 오류: " + e.getMessage(), e);
            responseData.put("returnCd", "99");
            responseData.put("returnMsg", "시스템 오류가 발생했습니다.");
        }

        return responseData;
    }
}
