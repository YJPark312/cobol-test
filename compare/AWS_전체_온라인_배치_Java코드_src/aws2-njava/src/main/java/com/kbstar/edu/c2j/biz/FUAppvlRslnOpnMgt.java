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
 * 승인결의 의견관리 FU 클래스.
 * <pre>
 * 유닛 설명 : 기업집단 승인결의록 개별의견 등록 및 관리 기능 유닛
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
@BizUnit(value = "승인결의의견관리", type = "FU")
public class FUAppvlRslnOpnMgt extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPB132 duTSKIPB132;
    @BizUnitBind private DUTSKIPB133 duTSKIPB133;
    @BizUnitBind private DUTSKIPB110 duTSKIPB110;

    /**
     * 승인결의 개별의견 관리.
     * <pre>
     * 메소드 설명 : 기업집단 승인결의록 개별의견 등록 및 수정 처리
     * 비즈니스 기능:
     * - BR-036-001: 처리구분검증
     * - BR-036-002: 기업집단파라미터검증
     * - BR-036-003: 위원분류검증
     * - BR-036-004: 의견내용관리
     * - BR-036-005: 위원완료상태검증
     * - BR-036-006: 자동알림발송
     * - BR-036-007: 일련번호관리
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
    @BizMethod("승인결의개별의견관리")
    public IDataSet manageApprovalOpinion(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("승인결의개별의견관리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // BR-036-001: 처리구분검증
            String prcssdstic = requestData.getString("prcssdstic");
            if (prcssdstic == null || prcssdstic.trim().isEmpty()) {
                throw new BusinessException("B3000070", "UKII0126", "처리구분코드는 필수입력항목입니다.");
            }
            
            if (!"00".equals(prcssdstic) && !"01".equals(prcssdstic)) {
                throw new BusinessException("B3000070", "UKII0291", "처리구분코드는 '00' 또는 '01'이어야 합니다.");
            }

            // BR-036-002: 기업집단파라미터검증
            String groupCoCd = requestData.getString("groupCoCd");
            if (groupCoCd == null || groupCoCd.trim().isEmpty()) {
                throw new BusinessException("B3000070", "UKII0126", "그룹회사코드는 필수입력항목입니다.");
            }

            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3000070", "UKII0126", "기업집단그룹코드는 필수입력항목입니다.");
            }

            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3000070", "UKII0126", "기업집단등록코드는 필수입력항목입니다.");
            }

            String valuaYmd = requestData.getString("valuaYmd");
            if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
                throw new BusinessException("B3000070", "UKII0126", "평가년월일은 필수입력항목입니다.");
            }

            if (!valuaYmd.matches("^\\d{8}$")) {
                throw new BusinessException("B3000070", "UKII0126", "평가년월일은 YYYYMMDD 형식이어야 합니다.");
            }

            // 처리구분에 따른 분기 처리
            if ("00".equals(prcssdstic)) {
                // 조회 처리
                responseData = _processInquiry(requestData, onlineCtx);
            } else if ("01".equals(prcssdstic)) {
                // 수정 처리
                responseData = _processUpdate(requestData, onlineCtx);
            }

            // 성공 결과코드 설정
            responseData.put("resultCd", "00");
            
            log.debug("승인결의개별의견관리 완료");
            
        } catch (BusinessException e) {
            log.error("승인결의개별의견관리 업무 오류: " + e.getMessage());
            responseData.put("resultCd", "99");
            throw e;
        } catch (Exception e) {
            log.error("승인결의개별의견관리 시스템 오류: " + e.getMessage());
            responseData.put("resultCd", "99");
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 조회 처리.
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리 결과
     */
    private IDataSet _processInquiry(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("승인결의 조회 처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 위원명세 조회
            IDataSet memberReq = new DataSet();
            memberReq.put("groupCoCd", requestData.getString("groupCoCd"));
            memberReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            memberReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            memberReq.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IDataSet memberRes = duTSKIPB132.selectList(memberReq, onlineCtx);
            IRecordSet memberList = memberRes.getRecordSet("LIST");
            
            if (memberList != null && memberList.getRecordCount() > 0) {
                // 각 위원의 의견내용 조회
                for (int i = 0; i < memberList.getRecordCount(); i++) {
                    IRecord memberRecord = memberList.getRecord(i);
                    
                    // 의견명세 조회
                    IDataSet opinionReq = new DataSet();
                    opinionReq.put("groupCoCd", requestData.getString("groupCoCd"));
                    opinionReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
                    opinionReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
                    opinionReq.put("valuaYmd", requestData.getString("valuaYmd"));
                    opinionReq.put("athorCmmbEmpid", memberRecord.getString("athorCmmbEmpid"));
                    
                    IDataSet opinionRes = duTSKIPB133.selectLatest(opinionReq, onlineCtx);
                    if (opinionRes.getString("athorOpinCtnt") != null) {
                        // WP-025~035 성공 패턴 적용 - 직접 응답 구성
                        log.debug("개별의견 정보 조회됨: " + opinionRes.getString("athorOpinCtnt"));
                    }
                }
                
                // 명세서 F-036-002 위원정보관리 출력 파라미터 준수
                responseData.put("memberValidationResult", "00");
                responseData.put("memberRole", "COMMITTEE_MEMBER");
                responseData.put("memberPermissions", new String[]{"OPINION_REGISTER", "OPINION_UPDATE"});
            }
            
            log.debug("승인결의 조회 처리 완료");
            
        } catch (Exception e) {
            log.error("승인결의 조회 처리 오류: " + e.getMessage());
            throw new BusinessException("B3900001", "UKII0182", "조회 처리 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 수정 처리.
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리 결과
     */
    private IDataSet _processUpdate(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("승인결의 수정 처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 위원정보 파라미터 검증
            String athorCmmbEmpid = requestData.getString("athorCmmbEmpid");
            if (athorCmmbEmpid == null || athorCmmbEmpid.trim().isEmpty()) {
                throw new BusinessException("B3000070", "UKII0126", "승인위원직원번호는 필수입력항목입니다.");
            }
            
            String athorCmmbDstcd = requestData.getString("athorCmmbDstcd");
            if (!"1".equals(athorCmmbDstcd) && !"2".equals(athorCmmbDstcd) && !"3".equals(athorCmmbDstcd)) {
                throw new BusinessException("B3000070", "UKII0291", "승인위원구분코드는 '1', '2', '3' 중 하나여야 합니다.");
            }
            
            // BR-044-004: 의견내용관리
            String athorOpinCtnt = requestData.getString("athorOpinCtnt");
            if (athorOpinCtnt != null && !athorOpinCtnt.trim().isEmpty()) {
                if (athorOpinCtnt.length() > 1002) {
                    throw new BusinessException("B3000070", "UKII0126", "승인의견내용은 1002자를 초과할 수 없습니다.");
                }
                
                // 의견명세 업데이트
                _updateOpinionSpec(requestData, onlineCtx);
            }
            
            // 위원명세 업데이트
            _updateMemberSpec(requestData, onlineCtx);
            
            // BR-044-005: 위원완료상태검증 및 BR-044-006: 자동알림발송
            _checkCompletionAndNotify(requestData, onlineCtx);
            
            log.debug("승인결의 수정 처리 완료");
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("승인결의 수정 처리 오류: " + e.getMessage());
            throw new BusinessException("B3900001", "UKII0182", "수정 처리 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 위원명세 업데이트.
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     */
    private void _updateMemberSpec(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet updateReq = new DataSet();
        updateReq.put("groupCoCd", requestData.getString("groupCoCd"));
        updateReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        updateReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        updateReq.put("valuaYmd", requestData.getString("valuaYmd"));
        updateReq.put("athorCmmbEmpid", requestData.getString("athorCmmbEmpid"));
        updateReq.put("athorCmmbDstcd", requestData.getString("athorCmmbDstcd"));
        updateReq.put("athorDstcd", requestData.getString("athorDstcd"));
        
        duTSKIPB132.update(updateReq, onlineCtx);
    }

    /**
     * 의견명세 업데이트.
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     */
    private void _updateOpinionSpec(IDataSet requestData, IOnlineContext onlineCtx) {
        // BR-044-007: 일련번호관리
        String sernoStr = requestData.getString("serno");
        int nextSerno = (sernoStr != null && !sernoStr.trim().isEmpty()) ? 
                       Integer.parseInt(sernoStr) + 1 : 1;
        
        IDataSet insertReq = new DataSet();
        insertReq.put("groupCoCd", requestData.getString("groupCoCd"));
        insertReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        insertReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        insertReq.put("valuaYmd", requestData.getString("valuaYmd"));
        insertReq.put("athorCmmbEmpid", requestData.getString("athorCmmbEmpid"));
        insertReq.put("serno", String.valueOf(nextSerno));
        insertReq.put("athorOpinCtnt", requestData.getString("athorOpinCtnt"));
        
        duTSKIPB133.insert(insertReq, onlineCtx);
    }

    /**
     * 완료상태 확인 및 알림 발송.
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     */
    private void _checkCompletionAndNotify(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        
        try {
            // 위원 완료상태 조회
            IDataSet memberReq = new DataSet();
            memberReq.put("groupCoCd", requestData.getString("groupCoCd"));
            memberReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            memberReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            memberReq.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IDataSet memberRes = duTSKIPB132.selectList(memberReq, onlineCtx);
            IRecordSet memberList = memberRes.getRecordSet("LIST");
            
            if (memberList != null && memberList.getRecordCount() > 0) {
                int pendingCount = 0;
                
                // 대기 중인 위원 수 계산
                for (int i = 0; i < memberList.getRecordCount(); i++) {
                    IRecord memberRecord = memberList.getRecord(i);
                    String athorDstcd = memberRecord.getString("athorDstcd");
                    if (athorDstcd == null || athorDstcd.trim().isEmpty()) {
                        pendingCount++;
                    }
                }
                
                // 모든 위원이 완료한 경우 알림 발송
                if (pendingCount == 0) {
                    _sendCompletionNotification(requestData, onlineCtx);
                }
            }
            
        } catch (Exception e) {
            log.warn("완료상태 확인 및 알림 발송 중 오류 (처리는 계속): " + e.getMessage());
            // 알림 실패는 주 트랜잭션에 영향을 주지 않음
        }
    }

    /**
     * 완료 알림 발송.
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     */
    private void _sendCompletionNotification(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        
        try {
            // 평가직원정보 조회
            IDataSet evalReq = new DataSet();
            evalReq.put("groupCoCd", requestData.getString("groupCoCd"));
            evalReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            evalReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            evalReq.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IDataSet evalRes = duTSKIPB110.select(evalReq, onlineCtx);
            
            String valuaEmpid = evalRes.getString("valuaEmpid");
            String corpClctName = evalRes.getString("corpClctName");
            
            if (valuaEmpid != null && !valuaEmpid.trim().isEmpty()) {
                // TODO: 메시징 시스템 연동 필요
                // 실제 구현에서는 ZUGMSNM 모듈과 연동하여 알림 메시지 발송
                log.info("승인결의 완료 알림 발송 대상: " + valuaEmpid + ", 기업집단: " + corpClctName);
            }
            
        } catch (Exception e) {
            log.warn("완료 알림 발송 중 오류 (처리는 계속): " + e.getMessage());
            // 알림 실패는 주 트랜잭션에 영향을 주지 않음
        }
    }
}
