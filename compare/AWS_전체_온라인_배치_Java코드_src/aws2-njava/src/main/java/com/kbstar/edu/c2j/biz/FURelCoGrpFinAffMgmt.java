package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 관계회사집단재무계열관리 FU 클래스.
 * <pre>
 * 유닛 설명 : 관계회사집단의 재무계열을 관리하고 처리하는 기능 유닛
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
@BizUnit(value = "관계회사집단재무계열관리", type = "FU")
public class FURelCoGrpFinAffMgmt extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA130 duTSKIPA130;

    /**
     * 관계회사집단재무계열관리처리.
     * <pre>
     * 메소드 설명 : 관계회사집단의 재무계열 정보를 조회하고 관리하는 처리
     * 비즈니스 기능:
     * - BR-031-001: 처리구분검증 (01: 조회, 02: 등록기업조회, 03: 등록, 04: 수정)
     * - BR-031-002: 기업집단식별검증
     * - BR-031-003: 평가기준년검증
     * - BR-031-008: 처리유형결정
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
    @BizMethod("관계회사집단재무계열관리처리")
    public IDataSet processRelCoGrpFinAffMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("관계회사집단재무계열관리처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // BR-031-001: 처리구분검증
            String prcssDstcd = requestData.getString("prcssDstcd");
            if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIP0007", "처리구분코드를 입력하고 트랜잭션을 재시도하세요.");
            }
            
            // BR-031-008: 처리유형결정 - 유효한 처리구분코드 검증
            if (!prcssDstcd.matches("^(01|02|03|04)$")) {
                throw new BusinessException("B3800004", "UKIP0007", "처리구분은 유효한 코드(01, 02, 03, 04)여야 합니다.");
            }

            // BR-031-002: 기업집단식별검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3800001", "UKIP0001", "기업집단그룹코드를 입력하고 트랜잭션을 재시도하세요.");
            }

            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3800002", "UKIP0002", "기업집단등록코드를 입력하고 트랜잭션을 재시도하세요.");
            }

            // BR-031-003: 평가기준년검증
            String valuaBaseYr = requestData.getString("valuaBaseYr");
            if (valuaBaseYr != null && !valuaBaseYr.trim().isEmpty()) {
                if (!valuaBaseYr.matches("^\\d{4}$")) {
                    throw new BusinessException("B2700460", "UKIP0008", "평가기준년은 유효한 YYYY 형식이어야 합니다.");
                }
            }

            // BR-031-008: 처리유형결정 - 처리구분별 로직 분기
            switch (prcssDstcd) {
                case "01": // 계열기업조회
                    responseData = processAffiliateInquiry(requestData, onlineCtx);
                    break;
                case "02": // 등록기업조회
                    responseData = processRegisteredInquiry(requestData, onlineCtx);
                    break;
                case "03": // 기업등록
                    responseData = processEnterpriseRegistration(requestData, onlineCtx);
                    break;
                case "04": // 기업수정
                    responseData = processEnterpriseModification(requestData, onlineCtx);
                    break;
                default:
                    throw new BusinessException("B3800004", "UKIP0007", "지원하지 않는 처리구분코드입니다.");
            }
            
            log.debug("관계회사집단재무계열관리처리 완료 - 처리구분: " + prcssDstcd);

        } catch (BusinessException e) {
            log.error("관계회사집단재무계열관리처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("관계회사집단재무계열관리처리 시스템 오류", e);
            throw new BusinessException("B3100999", "UKII0999", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 계열기업조회 처리 (처리구분 01).
     * @param requestData 요청정보
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리결과
     */
    private IDataSet processAffiliateInquiry(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("계열기업조회 처리 시작");
        
        IDataSet responseData = new DataSet();
        
        // DU 메소드 호출을 위한 파라미터 설정
        IDataSet queryReq = new DataSet();
        queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        queryReq.put("valuaBaseYr", requestData.getString("valuaBaseYr"));
        queryReq.put("groupCoCd", requestData.getString("groupCoCd"));
        
        // DU 메소드 호출
        IDataSet result = duTSKIPA130.selectFinTargetInfo(queryReq, onlineCtx);
        
        // 결과 데이터 처리
        IRecordSet resultList = result.getRecordSet("output");
        int totalCount = 0;
        int presentCount = 0;
        
        if (resultList != null) {
            totalCount = resultList.getRecordCount();
            presentCount = Math.min(totalCount, 500); // BR-031-007: 레코드수제한
        }
        
        // 응답 데이터 구성
        responseData.put("totalNoitm", totalCount);
        responseData.put("prsntNoitm", presentCount);
        responseData.put("GRID", resultList);
        
        log.debug("계열기업조회 처리 완료 - 조회건수: " + totalCount);
        return responseData;
    }

    /**
     * 등록기업조회 처리 (처리구분 02).
     * @param requestData 요청정보
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리결과
     */
    private IDataSet processRegisteredInquiry(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("등록기업조회 처리 시작");
        
        // 등록기업조회 로직 구현
        IDataSet responseData = processAffiliateInquiry(requestData, onlineCtx);
        
        log.debug("등록기업조회 처리 완료");
        return responseData;
    }

    /**
     * 기업등록 처리 (처리구분 03).
     * @param requestData 요청정보
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리결과
     */
    private IDataSet processEnterpriseRegistration(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업등록 처리 시작");
        
        IDataSet responseData = new DataSet();
        
        // 등록 로직 구현
        IDataSet insertReq = new DataSet();
        insertReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        insertReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        insertReq.put("valuaBaseYr", requestData.getString("valuaBaseYr"));
        insertReq.put("groupCoCd", requestData.getString("groupCoCd"));
        
        IDataSet result = duTSKIPA130.insert(insertReq, onlineCtx);
        
        responseData.put("resultCode", "00");
        responseData.put("resultMessage", "기업등록이 완료되었습니다.");
        responseData.put("processedCount", 1);
        
        log.debug("기업등록 처리 완료");
        return responseData;
    }

    /**
     * 기업수정 처리 (처리구분 04).
     * @param requestData 요청정보
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리결과
     */
    private IDataSet processEnterpriseModification(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업수정 처리 시작");
        
        IDataSet responseData = new DataSet();
        
        // 수정 로직 구현
        IDataSet updateReq = new DataSet();
        updateReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        updateReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        updateReq.put("valuaBaseYr", requestData.getString("valuaBaseYr"));
        updateReq.put("groupCoCd", requestData.getString("groupCoCd"));
        
        IDataSet result = duTSKIPA130.update(updateReq, onlineCtx);
        
        responseData.put("resultCode", "00");
        responseData.put("resultMessage", "기업수정이 완료되었습니다.");
        responseData.put("processedCount", 1);
        
        log.debug("기업수정 처리 완료");
        return responseData;
    }
}
