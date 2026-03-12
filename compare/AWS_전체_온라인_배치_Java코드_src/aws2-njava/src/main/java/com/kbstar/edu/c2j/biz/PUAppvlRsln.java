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
 * 승인결의록 관리 PU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단 승인결의록 관리를 위한 온라인 거래 처리 단위
 * 포함된 AS 모듈: AIP4A95, AIPBA97, AIPBA96
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
@BizUnit("승인결의록")
public class PUAppvlRsln extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FUAppvlRslnOpnMgt fuAppvlRslnOpnMgt;
    @BizUnitBind private FUAppvlRslnInq fuAppvlRslnInq;
    @BizUnitBind private FUAppvlRslnConfirm fuAppvlRslnConfirm;

    /**
     * 거래코드: KIP04A9540
     * 거래명: 기업집단승인결의록조회
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("기업집단승인결의록조회")
    public IDataSet pmKIP04A9540(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단승인결의록조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // FU 클래스를 통한 승인결의록 조회 처리
            responseData = fuAppvlRslnInq.inquireApprovalResolution(requestData, onlineCtx);
            
            log.debug("기업집단승인결의록조회 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단승인결의록조회 업무 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("기업집단승인결의록조회 시스템 오류: " + e.getMessage());
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 거래코드: KIP11A97E0
     * 거래명: 기업집단승인결의록개별의견등록
     * <pre>
     * 메소드 설명 : 기업집단 승인결의록 개별의견 등록 처리
     * 비즈니스 기능:
     * - 처리구분에 따른 승인위원 의견등록 및 수정
     * - 위원 완료상태 검증 및 자동 알림 발송
     * - 승인결의 워크플로 상태 관리
     * 
     * 입력 파라미터:
     *	- field : prcssdstic [처리구분코드] (string) - '00':조회, '01':수정
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : corpClctName [기업집단명] (string)
     *	- field : valuaYmd [평가년월일] (string)
     *	- field : totalNoitm [총건수] (int)
     *	- field : prsntNoitm [현재건수] (int)
     *	- recordSet : memberList [위원정보 LIST]
     *		- field : athorCmmbDstcd [승인위원구분코드] (string)
     *		- field : athorCmmbEmpid [승인위원직원번호] (string)
     *		- field : athorCmmbEmnm [승인위원직원명] (string)
     *		- field : athorDstcd [승인구분코드] (string)
     *		- field : athorOpinCtnt [승인의견내용] (string)
     *		- field : serno [일련번호] (int)
     * 
     * 출력 파라미터:
     *	- field : resultCd [결과코드] (string)
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (AIPBA97 변환)
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("기업집단승인결의록개별의견등록")
    public IDataSet pmKIP11A97E0(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단승인결의록개별의견등록 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // FU 클래스를 통한 승인결의 개별의견 등록 처리
            responseData = fuAppvlRslnOpnMgt.manageApprovalOpinion(requestData, onlineCtx);
            
            log.debug("기업집단승인결의록개별의견등록 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단승인결의록개별의견등록 업무 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("기업집단승인결의록개별의견등록 시스템 오류: " + e.getMessage());
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 거래코드: KIP11A96E0
     * 거래명: 기업집단승인결의록확정
     * <pre>
     * 메소드 설명 : 기업집단 승인결의록 확정 처리
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
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (AIPBA96 변환)
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("기업집단승인결의록확정")
    public IDataSet pmKIP11A96E0(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단승인결의록확정 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // FU 클래스를 통한 승인결의록 확정 처리 (PM → FM → DM 패턴)
            responseData = fuAppvlRslnConfirm.processApprovalResolutionConfirm(requestData, onlineCtx);
            
            log.debug("기업집단승인결의록확정 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단승인결의록확정 업무 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("기업집단승인결의록확정 시스템 오류: " + e.getMessage());
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

}
