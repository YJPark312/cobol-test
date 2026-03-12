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
 * 기업집단신용평가보고서 관리 PU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단의 신용평가 보고서 생성 및 관리를 담당하는 온라인 거래 처리 단위
 * 포함된 AS 모듈: AIP4A32, AIP4A31
 * ---------------------------------------------------------------------------------
 *  버전	일자			작성자			설명
 * ---------------------------------------------------------------------------------
 *   1.0	20251002	MultiQ4KBBank		최초 작성
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank
 * @since 2025-10-02
 */
@BizUnit("기업집단신용평가보고서")
public class PUCorpGrpCrdtEvalRpt extends com.kbstar.sqc.base.ProcessUnit {

    // FM 레이어 - 기업집단신용평가보고서 기능 유닛 바인딩
    @BizUnitBind private FUCorpGrpCrdtEvalRpt fuCorpGrpCrdtEvalRpt;
    
    // FM 레이어 - 기업집단신용평가보고서개요 기능 유닛 바인딩 (WP-055)
    @BizUnitBind private FUCorpGrpCrdtEvalRptOvw fuCorpGrpCrdtEvalRptOvw;

    /**
     * 거래코드: KIP04A3240
     * 거래명: 기업집단신용평가보고서(재무/비재무평가)
     * <pre>
     * 메소드 설명 : 기업집단의 신용평가 보고서 생성 및 관리를 수행하는 온라인 거래
     * 비즈니스 기능:
     * - 기업집단 신용평가 보고서 생성
     * - 재무/비재무 평가 데이터 통합
     * - 보고서 형식 관리
     * 
     * 입력 파라미터:
     * - field : corpClctGroupCd [기업집단그룹코드] (string)
     * - field : corpClctRegiCd [기업집단등록코드] (string)
     * - field : valuaYmd [평가년월일] (string)
     * - field : procUserId [처리사용자ID] (string)
     * - field : procTermId [처리단말기ID] (string)
     * 
     * 출력 파라미터:
     * - field : processStatus [처리상태] (string)
     * - field : processMessage [처리메시지] (string)
     * - recordSet : reportData [보고서데이터 LIST]
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단신용평가보고서(재무/비재무평가)")
    public IDataSet pmKIP04A3240(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단신용평가보고서 조회 시작 - pmKIP04A3240");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 검증 및 보안 검증
            validateInput(requestData, onlineCtx);
            
            // FM 레이어 호출 - 기업집단신용평가보고서 조회 처리
            responseData = fuCorpGrpCrdtEvalRpt.processCorpGrpCrdtEvalRpt(requestData, onlineCtx);
            
            log.debug("기업집단신용평가보고서 조회 완료 - pmKIP04A3240");
            
        } catch (BusinessException be) {
            log.error("기업집단신용평가보고서 조회 중 업무 오류 발생: " + be.getMessage());
            throw be;
        } catch (Exception e) {
            log.error("기업집단신용평가보고서 조회 중 시스템 오류 발생: " + e.getMessage());
            throw new BusinessException("B3900002", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.");
        }
        
        return responseData;
    }

    /**
     * 거래코드: KIP04A3140
     * 거래명: 기업집단신용평가보고서개요
     * <pre>
     * 메소드 설명 : 기업집단의 신용평가 보고서 개요 정보를 조회하고 관리하는 온라인 거래
     * 비즈니스 기능:
     * - 기업집단 신용평가 보고서 개요 조회
     * - 평가 요약 정보 제공
     * - 보고서 메타데이터 관리
     * 
     * 입력 파라미터:
     * - field : corpClctGroupCd [기업집단그룹코드] (string)
     * - field : corpClctRegiCd [기업집단등록코드] (string)
     * - field : valuaYmd [평가년월일] (string)
     * 
     * 출력 파라미터:
     * - field : processStatus [처리상태] (string)
     * - field : processMessage [처리메시지] (string)
     * - recordSet : overviewData [개요데이터 LIST]
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단신용평가보고서개요")
    public IDataSet pmKIP04A3140(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단신용평가보고서개요 조회 시작 - pmKIP04A3140");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 검증 및 보안 검증
            validateCorpGrpCrdtEvalRptOvwInput(requestData, onlineCtx);
            
            // FM 레이어 호출 - 기업집단신용평가보고서개요 처리
            responseData = fuCorpGrpCrdtEvalRptOvw.processCorpGrpCrdtEvalRptOvw(requestData, onlineCtx);
            
            log.debug("기업집단신용평가보고서개요 조회 완료 - pmKIP04A3140");
            
        } catch (BusinessException be) {
            log.error("기업집단신용평가보고서개요 조회 중 업무 오류 발생: " + be.getMessage());
            throw be;
        } catch (Exception e) {
            log.error("기업집단신용평가보고서개요 조회 중 시스템 오류 발생: " + e.getMessage());
            throw new BusinessException("B3900002", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.");
        }
        
        return responseData;
    }
    
    /**
     * 입력 매개변수 검증
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    private void validateInput(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        
        // 기업집단그룹코드 검증
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            log.error("기업집단그룹코드가 입력되지 않았습니다.");
            throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드 입력후 다시 거래하세요");
        }
        
        // 기업집단등록코드 검증
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            log.error("기업집단등록코드가 입력되지 않았습니다.");
            throw new BusinessException("B3600552", "UKIP0002", "기업집단등록코드 입력후 다시 거래하세요");
        }
        
        // 평가년월일 검증
        String valuaYmd = requestData.getString("valuaYmd");
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            log.error("평가년월일이 입력되지 않았습니다.");
            throw new BusinessException("B2700019", "UKIP0003", "평가년월일 입력후 다시 거래하세요");
        }
        
        // 처리사용자ID 검증
        String procUserId = requestData.getString("procUserId");
        if (procUserId == null || procUserId.trim().isEmpty()) {
            log.error("처리사용자ID가 입력되지 않았습니다.");
            throw new BusinessException("B3800004", "UKIP0004", "유효한 사용자ID를 입력하세요");
        }
        
        // 처리단말기ID 검증
        String procTermId = requestData.getString("procTermId");
        if (procTermId == null || procTermId.trim().isEmpty()) {
            log.error("처리단말기ID가 입력되지 않았습니다.");
            throw new BusinessException("B3800005", "UKIP0005", "유효한 단말기ID를 입력하세요");
        }
        
        log.debug("입력 매개변수 검증 완료");
    }
    
    /**
     * 기업집단신용평가보고서개요 입력 매개변수 검증
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    private void validateCorpGrpCrdtEvalRptOvwInput(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        
        // BR-055-001: 기업집단그룹코드 검증
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            log.error("기업집단그룹코드가 입력되지 않았습니다.");
            throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드 입력후 다시 거래하세요");
        }
        
        // BR-055-002: 기업집단등록코드 검증
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            log.error("기업집단등록코드가 입력되지 않았습니다.");
            throw new BusinessException("B3600552", "UKIP0002", "기업집단등록코드 입력후 다시 거래하세요");
        }
        
        // BR-055-003: 평가년월일 검증
        String valuaYmd = requestData.getString("valuaYmd");
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            log.error("평가년월일이 입력되지 않았습니다.");
            throw new BusinessException("B2700019", "UKIP0003", "평가년월일 입력후 다시 거래하세요");
        }
        
        log.debug("기업집단신용평가보고서개요 입력 매개변수 검증 완료");
    }

}