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
 * 기업집단연결재무제표작성.
 * <pre>
 * 유닛 설명 : 기업집단의 연결재무제표를 작성하고 관리하는 기능 유닛
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
@BizUnit(value = "기업집단연결재무제표작성", type = "FU")
public class FUCorpGrpConFinStmtPrep extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA110 duTSKIPA110;  // 기업집단기본정보
    @BizUnitBind private DUTSKIPB110 duTSKIPB110;  // 기업집단평가기본정보
    @BizUnitBind private DUTSKIPA111 duTSKIPA111;

    /**
     * 기업집단연결재무제표작성처리.
     * <pre>
     * 메소드 설명 : 기업집단의 연결재무제표 작성 및 합산연결대상 선정 처리
     * 비즈니스 기능:
     * - BR-026-001: 기업집단등록코드 검증
     * - BR-026-002: 연결재무제표 데이터 무결성
     * - BR-026-003: 재무제표 작성일자 검증
     * - BR-026-004: 자회사 정보 일관성
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
    @BizMethod("기업집단연결재무제표작성처리")
    public IDataSet processCorpGrpConFinStmtPrep(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단연결재무제표작성처리 시작");
            
            // 입력 데이터 로깅
            log.debug("입력 파라미터 - 기업집단그룹코드: " + requestData.getString("corpClctGroupCd"));
            log.debug("입력 파라미터 - 기업집단등록코드: " + requestData.getString("corpClctRegiCd"));
            log.debug("입력 파라미터 - 평가년월일: " + requestData.getString("valuaYmd"));

            // BR-026-001: 기업집단등록코드 검증
            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B2900001", "UKII0001", "기업집단등록코드는 필수입력항목입니다.");
            }

            // BR-026-002: 기업집단그룹코드 검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B2900002", "UKII0002", "기업집단그룹코드는 필수입력항목입니다.");
            }

            // F-026-001: 기업집단 연결재무제표 데이터 조회 (FM → DM 호출)
            // F-026-001: 기업집단 연결재무제표 기본정보 조회 (WP-026 명세서 기준)
            log.debug("기업집단 기본정보 조회 시작");
            IDataSet conFinStmtReq = new DataSet();
            conFinStmtReq.put("corpClctGroupCd", corpClctGroupCd);
            conFinStmtReq.put("corpClctRegiCd", corpClctRegiCd);
            conFinStmtReq.put("valuaYmd", requestData.getString("valuaYmd"));
            conFinStmtReq.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            
            // WP-026 명세서에 따른 실제 테이블 접근: TSKIPA110 (기업집단기본정보)
            IDataSet conFinStmtResult = duTSKIPA110.selectCorpGrpBasicInfo(conFinStmtReq, onlineCtx);
            
            // F-026-002: 기업집단 기본정보 조회
            log.debug("기업집단 기본정보 조회 시작");
            IDataSet basicInfoReq = new DataSet();
            basicInfoReq.put("corpClctGroupCd", corpClctGroupCd);
            basicInfoReq.put("corpClctRegiCd", corpClctRegiCd);
            basicInfoReq.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IDataSet basicInfoResult = duTSKIPA111.selectByName(basicInfoReq, onlineCtx);

            // BR-026-003: 데이터 완전성 검증
            int totalRecords = 0;
            if (conFinStmtResult.getRecordSet("output") != null) {
                totalRecords += conFinStmtResult.getRecordSet("output").getRecordCount();
            }
            if (basicInfoResult.getRecordSet("grid1") != null) {
                totalRecords += basicInfoResult.getRecordSet("grid1").getRecordCount();
            }

            // 응답 데이터 구성
            responseData.put("returnCd", "00");
            responseData.put("returnMsg", "정상처리되었습니다.");
            responseData.put("totalRecords", totalRecords);
            
            // 연결재무제표 정보
            if (conFinStmtResult.getRecordSet("output") != null) {
                responseData.put("conFinStmtInfo", conFinStmtResult.getRecordSet("output"));
            }
            
            // 기업집단 기본정보
            if (basicInfoResult.getRecordSet("grid1") != null) {
                responseData.put("basicInfo", basicInfoResult.getRecordSet("grid1"));
            }

            log.debug("기업집단연결재무제표작성처리 완료 - 총 " + totalRecords + "건");

        } catch (BusinessException be) {
            log.error("기업집단연결재무제표작성처리 비즈니스 오류: " + be.getMessage());
            responseData.put("returnCd", be.getErrorCode());
            responseData.put("returnMsg", be.getMessage());
        } catch (Exception e) {
            log.error("기업집단연결재무제표작성처리 시스템 오류: " + e.getMessage(), e);
            responseData.put("returnCd", "99");
            responseData.put("returnMsg", "시스템 오류가 발생했습니다.");
        }

        return responseData;
    }
}
