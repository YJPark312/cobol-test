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
 * 승인결의록확정 FU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단 승인결의록 확정 처리를 위한 기능 단위
 * 포함된 기능: 위원회 위원 저장, 반송 처리, 통보 관리
 * ---------------------------------------------------------------------------------
 *  버전	일자			작성자			설명
 * ---------------------------------------------------------------------------------
 *   1.0	20251001	MultiQ4KBBank		최초 작성 (AIPBA96 변환)
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank
 * @since 2025-10-01
 */
@BizUnit("승인결의록확정")
public class FUAppvlRslnConfirm extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA110 duTSKIPA110;

    /**
     * 승인결의록확정처리.
     * <pre>
     * 메소드 설명 : 기업집단 승인결의록 확정 메인 처리
     * 비즈니스 기능:
     * - 처리구분에 따른 위원회 위원 저장 또는 반송 처리
     * - 위원회 위원 통보 및 메시징 처리
     * - 승인결의 데이터 검증 및 관리
     * 
     * 입력 파라미터:
     *	- field : prcssDstcd [처리구분코드] (string) - '01':위원저장, '02':반송처리
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string)
     *	- field : corpClctName [기업집단명] (string)
     *	- field : mainDebtAffltYn [주채무계열여부] (string)
     *	- field : corpCValuaDstcd [기업집단평가구분코드] (string)
     *	- field : valuaDefinsYmd [평가확정년월일] (string)
     *	- field : valuaBaseYmd [평가기준년월일] (string)
     *	- recordSet : memberList [위원정보 LIST]
     *		- field : totalNoitm [총건수] (int)
     *		- field : prsntNoitm [현재건수] (int)
     *		- field : athorCmmbDstcd [승인위원구분코드] (string)
     *		- field : athorCmmbEmpid [승인위원직원번호] (string)
     *		- field : athorCmmbEmnm [승인위원직원명] (string)
     *		- field : athorDstcd [승인구분코드] (string)
     *		- field : athorOpinCtnt [승인의견내용] (string)
     *		- field : serno [일련번호] (int)
     * 
     * 출력 파라미터:
     *	- field : resultCd [결과코드] (string)
     *	- field : processedCount [처리건수] (int)
     *	- field : notificationCount [통보건수] (int)
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("승인결의록확정처리")
    public IDataSet processApprovalResolutionConfirm(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("승인결의록확정처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 검증
            validateInputParameters(requestData);
            
            String prcssDstcd = requestData.getString("prcssDstcd");
            int processedCount = 0;
            int notificationCount = 0;
            
            // 처리구분에 따른 분기 처리
            if ("01".equals(prcssDstcd)) {
                // 위원회 위원 저장 처리
                processedCount = processCommitteeMemberStorage(requestData, onlineCtx);
                
                // 위원회 위원 통보 처리
                notificationCount = processCommitteeMemberNotification(requestData, onlineCtx);
                
            } else if ("02".equals(prcssDstcd)) {
                // 반송 처리 (신용평가 삭제)
                processedCount = processReturnHandling(requestData, onlineCtx);
            }
            
            // 응답 데이터 구성
            responseData.put("resultCd", "00");
            responseData.put("processedCount", processedCount);
            responseData.put("notificationCount", notificationCount);
            
            log.debug("승인결의록확정처리 완료 - 처리건수: " + processedCount + ", 통보건수: " + notificationCount);
            
        } catch (BusinessException e) {
            log.error("승인결의록확정처리 업무 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("승인결의록확정처리 시스템 오류: " + e.getMessage());
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 입력파라미터검증.
     * <pre>
     * 메소드 설명 : 승인결의록 확정을 위한 입력 파라미터 검증
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     */
    private void validateInputParameters(IDataSet requestData) {
        // BR-053-001: 처리구분검증
        String prcssDstcd = requestData.getString("prcssDstcd");
        if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
            throw new BusinessException("B3000070", "UKII0126", "처리구분코드는 필수입니다.");
        }
        
        if (!"01".equals(prcssDstcd) && !"02".equals(prcssDstcd)) {
            throw new BusinessException("B3000070", "UKII0126", "처리구분코드는 '01' 또는 '02'여야 합니다.");
        }
        
        // BR-053-002: 기업집단식별검증
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3000070", "UKII0126", "기업집단그룹코드는 필수입니다.");
        }
        
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3000070", "UKII0126", "기업집단등록코드는 필수입니다.");
        }
        
        // BR-053-007: 평가일자일관성
        String valuaYmd = requestData.getString("valuaYmd");
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException("B3000070", "UKII0126", "평가년월일은 필수입니다.");
        }
        
        if (valuaYmd.length() != 8) {
            throw new BusinessException("B3000070", "UKII0126", "평가년월일은 YYYYMMDD 형식이어야 합니다.");
        }
    }

    /**
     * 위원회위원저장처리.
     * <pre>
     * 메소드 설명 : 위원회 위원 정보 저장 처리
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리건수
     */
    private int processCommitteeMemberStorage(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("위원회위원저장처리 시작");
        
        try {
            // 위원회 위원 정보 저장을 위한 DU 호출
            IDataSet storageRequest = new DataSet();
            storageRequest.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            storageRequest.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            storageRequest.put("valuaYmd", requestData.getString("valuaYmd"));
            storageRequest.put("corpClctName", requestData.getString("corpClctName"));
            storageRequest.put("mainDebtAffltYn", requestData.getString("mainDebtAffltYn"));
            storageRequest.put("corpCValuaDstcd", requestData.getString("corpCValuaDstcd"));
            storageRequest.put("valuaDefinsYmd", requestData.getString("valuaDefinsYmd"));
            storageRequest.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            storageRequest.put("sysLastUno", onlineCtx.getUserId());
            
            // DUTHKIPA110을 통한 승인결의 데이터 저장
            IDataSet storageResult = duTSKIPA110.insertApprovalResolutionData(storageRequest, onlineCtx);
            
            log.debug("위원회위원저장처리 완료");
            
            return storageResult.getString("processedCount") != null ? 
                Integer.parseInt(storageResult.getString("processedCount")) : 1;
            
        } catch (Exception e) {
            log.error("위원회위원저장처리 오류: " + e.getMessage());
            throw new BusinessException("B3900042", "UKII0182", "위원회 위원 저장 중 오류가 발생했습니다.", e);
        }
    }

    /**
     * 위원회위원통보처리.
     * <pre>
     * 메소드 설명 : 선정된 위원회 위원에게 통보 메시지 발송
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 통보건수
     */
    private int processCommitteeMemberNotification(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("위원회위원통보처리 시작");
        
        try {
            // BR-053-005: 위원회위원통보요구사항
            int notificationCount = 0;
            
            // 위원회 위원 수 확인
            IDataSet countRequest = new DataSet();
            countRequest.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            countRequest.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            countRequest.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IDataSet countResult = duTSKIPA110.selectCommitteeMemberCount(countRequest, onlineCtx);
            
            if ((countResult.getString("totalCount") != null ? 
                Integer.parseInt(countResult.getString("totalCount")) : 0) > 0) {
                // 위원회 위원 목록 처리
                if (requestData.containsKey("memberList")) {
                    IRecordSet memberList = (IRecordSet) requestData.get("memberList");
                    
                    for (int i = 0; i < memberList.getRecordCount(); i++) {
                        // 각 위원에게 통보 메시지 발송 (실제 메시징 시스템 연동은 TODO)
                        // TODO: 메시징 시스템 연동 - XZUGMSNM 호출
                        String empId = memberList.getRecord(i).getString("athorCmmbEmpid");
                        String empName = memberList.getRecord(i).getString("athorCmmbEmnm");
                        
                        log.debug("위원회 위원 통보 대상: " + empId + " (" + empName + ")");
                        notificationCount++;
                    }
                }
            }
            
            log.debug("위원회위원통보처리 완료 - 통보건수: " + notificationCount);
            
            return notificationCount;
            
        } catch (Exception e) {
            log.error("위원회위원통보처리 오류: " + e.getMessage());
            throw new BusinessException("B4000111", "UKII0814", "위원회 위원 통보 중 오류가 발생했습니다.", e);
        }
    }

    /**
     * 반송처리관리.
     * <pre>
     * 메소드 설명 : 승인결의 반송 처리 및 신용평가 삭제
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리건수
     */
    private int processReturnHandling(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("반송처리관리 시작");
        
        try {
            // BR-053-009: 반송처리검증
            IDataSet returnRequest = new DataSet();
            returnRequest.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            returnRequest.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            returnRequest.put("valuaYmd", requestData.getString("valuaYmd"));
            returnRequest.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            
            // DUTHKIPA110을 통한 기존 평가 데이터 삭제 처리
            IDataSet returnResult = duTSKIPA110.deleteApprovalResolutionData(returnRequest, onlineCtx);
            
            log.debug("반송처리관리 완료");
            
            return returnResult.getString("processedCount") != null ? 
                Integer.parseInt(returnResult.getString("processedCount")) : 1;
            
        } catch (Exception e) {
            log.error("반송처리관리 오류: " + e.getMessage());
            throw new BusinessException("B3900042", "UKII0182", "반송 처리 중 오류가 발생했습니다.", e);
        }
    }

    /**
     * 위원회위원수검증.
     * <pre>
     * 메소드 설명 : 위원회 위원 수 검증 및 임계값 확인
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 검증결과 DataSet 객체
     */
    @BizMethod("위원회위원수검증")
    public IDataSet validateCommitteeMemberCount(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("위원회위원수검증 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // BR-053-003: 위원회위원수검증
            IDataSet countRequest = new DataSet();
            countRequest.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            countRequest.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            countRequest.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IDataSet countResult = duTSKIPA110.selectCommitteeMemberCount(countRequest, onlineCtx);
            
            int totalCount = countResult.getString("totalCount") != null ? 
                Integer.parseInt(countResult.getString("totalCount")) : 0;
            boolean thresholdCompliance = totalCount >= 3; // 최소 3명 이상
            
            responseData.put("validationResult", thresholdCompliance ? "Y" : "N");
            responseData.put("committeeMemberCount", totalCount);
            responseData.put("thresholdCompliance", thresholdCompliance ? "Y" : "N");
            
            log.debug("위원회위원수검증 완료 - 위원수: " + totalCount + ", 임계값준수: " + thresholdCompliance);
            
        } catch (BusinessException e) {
            log.error("위원회위원수검증 업무 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("위원회위원수검증 시스템 오류: " + e.getMessage());
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

}
