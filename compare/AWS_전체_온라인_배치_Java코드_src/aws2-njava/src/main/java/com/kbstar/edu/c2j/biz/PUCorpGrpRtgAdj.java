package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.common.CommonArea;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단신용등급조회.
 * <pre>
 * 유닛 설명 : 기업집단 고객의 신용등급 정보를 조회하는 온라인 거래
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
@BizUnit(value = "기업집단신용등급조회", type = "PU")
public class PUCorpGrpRtgAdj extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FUCorpGrpCrdtRatingInq fuCorpGrpCrdtRatingInq;
    @BizUnitBind private FUCorpGrpRtgAdjReg fuCorpGrpRtgAdjReg;
    @BizUnitBind private FUCorpGrpCrdtEvalSummInq fuCorpGrpCrdtEvalSummInq;

    /**
     * 기업집단신용등급조정검토등록.
     * <pre>
     * 메소드 설명 : 기업집단 신용등급 조정 검토 등록 처리
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (STUB)
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단신용등급조정검토등록")
    public IDataSet pmKIP11A81E0(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단신용등급조정검토등록 시작");
            
            // BR-034-001: 기업집단신용등급조정검토코드 검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3400001", "UKFH0001", "기업집단그룹코드는 필수입력항목입니다.");
            }

            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3400002", "UKFH0002", "기업집단등록코드는 필수입력항목입니다.");
            }

            // BR-034-003: 등급조정검토 기간 검증
            String valuaYmd = requestData.getString("valuaYmd");
            if (valuaYmd != null && !valuaYmd.trim().isEmpty()) {
                if (!valuaYmd.matches("^\\d{8}$")) {
                    throw new BusinessException("B3400003", "UKFH0003", "평가년월일은 YYYYMMDD 형식이어야 합니다.");
                }
            }

            // PM → FM 호출 (변환 가이드 준수: PM → FU → DU)
            IDataSet result = fuCorpGrpRtgAdjReg.registerCorpGrpRtgAdj(requestData, onlineCtx);
            
            // 응답 데이터 설정
            responseData.put("returnCd", result.getString("returnCd"));
            responseData.put("returnMsg", result.getString("returnMsg"));
            responseData.put("processedCount", result.getInt("processedCount"));
            responseData.put("totalNoitm", result.getInt("totalNoitm"));
            responseData.put("prsntNoitm", result.getInt("prsntNoitm"));
            
            log.debug("기업집단신용등급조정검토등록 완료 - 처리건수: " + result.getInt("processedCount"));

        } catch (BusinessException e) {
            log.error("기업집단신용등급조정검토등록 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단신용등급조정검토등록 시스템 오류", e);
            throw new BusinessException("B3400999", "UKFH0999", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단신용등급조정등록.
     * <pre>
     * 메소드 설명 : 기업집단 신용등급 조정 등록 처리
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
     *	- field : newLcGrdDstcd [신최종집단등급구분코드] (string)
     *	- field : adjsStgeNoDstcd [조정단계번호구분코드] (string)
     *	- field : comtCtnt [주석내용] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : prcssRsultDstcd [처리결과구분코드] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단신용등급조정등록")
    public IDataSet pmKIP11A83E0(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);

        // BR-029-001: 그룹회사코드 검증
        String groupCoCd = requestData.getString("groupCoCd");
        if (groupCoCd == null || groupCoCd.trim().isEmpty()) {
            throw new BusinessException("B3600003", "UKFH0208", "그룹회사코드가 누락되었습니다.");
        }

        // BR-029-002: 기업집단 식별 검증
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드가 누락되었습니다.");
        }
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드가 누락되었습니다.");
        }

        // BR-029-003: 평가일자 검증
        String valuaYmd = requestData.getString("valuaYmd");
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException("B2701130", "UKII0244", "평가년월일이 누락되었습니다.");
        }

        // BR-029-004: 신용등급 조정 검증
        String newLcGrdDstcd = requestData.getString("newLcGrdDstcd");
        if (newLcGrdDstcd == null || newLcGrdDstcd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKII0282", "신최종집단등급구분코드가 누락되었습니다.");
        }

        // BR-029-005: 조정단계 제어
        String adjsStgeNoDstcd = requestData.getString("adjsStgeNoDstcd");
        if (adjsStgeNoDstcd == null || adjsStgeNoDstcd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKII0282", "조정단계번호구분코드가 누락되었습니다.");
        }

        // BR-029-006: 주석 관리
        String comtCtnt = requestData.getString("comtCtnt");
        if (comtCtnt == null || comtCtnt.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKII0282", "주석내용이 누락되었습니다.");
        }

        try {
            // FU 계층을 통한 기업집단 신용등급 조정 등록 처리
            IDataSet adjResult = fuCorpGrpRtgAdjReg.registerCorpGrpRtgAdj(requestData, onlineCtx);
            
            // 응답 데이터 구성
            responseData.put("prcssRsultDstcd", adjResult.getString("prcssRsultDstcd"));
            
            log.debug("기업집단 신용등급 조정 등록 완료 - 그룹코드: " + corpClctGroupCd + ", 등록코드: " + corpClctRegiCd);

        } catch (BusinessException e) {
            // 비즈니스 예외는 그대로 전파
            throw e;
        } catch (Exception e) {
            // 시스템 오류 발생 시 표준 오류 메시지 반환
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단신용평가요약조회.
     * <pre>
     * 메소드 설명 : 기업집단 신용평가 요약 정보를 조회하는 온라인 거래
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
     *	- field : fnshYn [완료여부] (string)
     *	- field : adjsStgeNoDstcd [조정단계번호구분] (string)
     *	- field : comtCtnt [주석내용] (string)
     *	- field : totalNoitm [총건수] (numeric)
     *	- field : prsntNoitm [현재건수] (numeric)
     *	- recordSet : evalGridData [평가그리드데이터] (recordSet)
     *		- field : grdAdjsDstcd [등급조정구분코드] (string)
     *		- field : valuaYmd [평가년월일] (string)
     *		- field : valuaBaseYmd [평가기준년월일] (string)
     *		- field : fnafScor [재무점수] (numeric)
     *		- field : nonFnafScor [비재무점수] (numeric)
     *		- field : chsnScor [결합점수] (numeric)
     *		- field : spareCGrdDstcd [예비집단등급구분코드] (string)
     *		- field : lastClctGrdDstcd [최종집단등급구분코드] (string)
     *		- field : newScGrdDstcd [신예비집단등급구분코드] (string)
     *		- field : newLcGrdDstcd [신최종집단등급구분코드] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단신용평가요약조회")
    public IDataSet pmKIP04A8240(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);

        // BR-032-001: 그룹회사코드 검증
        String groupCoCd = requestData.getString("groupCoCd");
        if (groupCoCd == null || groupCoCd.trim().isEmpty()) {
            throw new BusinessException("B3600003", "UKFH0208", "그룹회사코드가 누락되었습니다.");
        }

        // BR-032-002: 기업집단 식별 검증
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드가 누락되었습니다.");
        }
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드가 누락되었습니다.");
        }

        // BR-032-003: 평가일자 검증
        String valuaYmd = requestData.getString("valuaYmd");
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException("B2701130", "UKII0244", "평가년월일이 누락되었습니다.");
        }

        try {
            // FU 계층을 통한 기업집단 신용평가 요약 조회 처리
            IDataSet evalSummResult = fuCorpGrpCrdtEvalSummInq.processCorpGrpCrdtEvalSummInq(requestData, onlineCtx);
            
            // 응답 데이터 구성
            responseData.put("fnshYn", evalSummResult.getString("fnshYn"));
            responseData.put("adjsStgeNoDstcd", evalSummResult.getString("adjsStgeNoDstcd"));
            responseData.put("comtCtnt", evalSummResult.getString("comtCtnt"));
            responseData.put("totalNoitm", evalSummResult.get("totalNoitm"));
            responseData.put("prsntNoitm", evalSummResult.get("prsntNoitm"));
            responseData.put("evalGridData", evalSummResult.get("evalGridData"));
            
            log.debug("기업집단 신용평가 요약 조회 완료 - 그룹코드: " + corpClctGroupCd + ", 등록코드: " + corpClctRegiCd);

        } catch (BusinessException e) {
            // 비즈니스 예외는 그대로 전파
            throw e;
        } catch (Exception e) {
            // 시스템 오류 발생 시 표준 오류 메시지 반환
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단신용등급조회.
     * <pre>
     * 메소드 설명 : 기업집단 고객의 신용등급 정보를 조회하는 온라인 거래
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
     *	- field : evltDt [평가일자] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : returnCd [리턴코드] (string)
     *	- field : returnMsg [리턴메시지] (string)
     *	- field : fnclScr [재무점수] (bigDecimal)
     *	- field : nfnclScr [비재무점수] (bigDecimal)
     *	- field : cmbndScr [결합점수] (bigDecimal)
     *	- field : prlmGrdClsf [예비등급분류] (string)
     *	- field : grdAdjClsf [등급조정분류] (string)
     *	- field : grdAdjRsnCntn [등급조정사유내용] (string)
     *	- field : saveElgblYn [저장가능여부] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단신용등급조회")
    public IDataSet pmKIP04A8040(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);

        // 비즈니스 룰 BR-015-001: 입력매개변수 검증
        String groupCoCd = requestData.getString("groupCoCd");
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        String evltDt = requestData.getString("evltDt");
        
        // 입력값 검증
        if (groupCoCd == null || groupCoCd.trim().isEmpty()) {
            throw new BusinessException("B3600003", "UKFH0208", "그룹회사코드가 누락되었습니다.");
        }
        
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드가 누락되었습니다.");
        }
        
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드가 누락되었습니다.");
        }
        
        if (evltDt == null || evltDt.trim().isEmpty()) {
            throw new BusinessException("B2701130", "UKII0244", "평가일자가 누락되었습니다.");
        }

        try {
            // FU 계층을 통한 기업집단 신용등급 조회
            IDataSet crdtRatingRes = fuCorpGrpCrdtRatingInq.processCorpGrpCrdtRatingInq(requestData, onlineCtx);
            
            // 응답 데이터 구성
            responseData.put("returnCd", "00");
            responseData.put("returnMsg", "정상처리");
            responseData.put("fnclScr", crdtRatingRes.get("fnclScr"));
            responseData.put("nfnclScr", crdtRatingRes.get("nfnclScr"));
            responseData.put("cmbndScr", crdtRatingRes.get("cmbndScr"));
            responseData.put("prlmGrdClsf", crdtRatingRes.getString("prlmGrdClsf"));
            responseData.put("grdAdjClsf", crdtRatingRes.getString("grdAdjClsf"));
            responseData.put("grdAdjRsnCntn", crdtRatingRes.getString("grdAdjRsnCntn"));
            responseData.put("saveElgblYn", crdtRatingRes.getString("saveElgblYn"));
            
            log.debug("기업집단 신용등급 조회 완료 - 그룹코드: " + corpClctGroupCd + ", 등록코드: " + corpClctRegiCd);

        } catch (BusinessException e) {
            // 비즈니스 예외는 그대로 전파
            throw e;
        } catch (Exception e) {
            // 시스템 오류 발생 시 표준 오류 메시지 반환
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }

}
