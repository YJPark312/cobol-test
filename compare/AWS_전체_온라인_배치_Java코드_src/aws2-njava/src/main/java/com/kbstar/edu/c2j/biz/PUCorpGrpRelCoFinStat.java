package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단관계회사재무현황 관리 PU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단 관계회사의 재무현황 조회 및 관리를 담당하는 온라인 거래 처리 단위
 * 포함된 AS 모듈: AIP4A21, AIP4A20
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
@BizUnit("기업집단관계기업재무현황")
public class PUCorpGrpRelCoFinStat extends com.kbstar.sqc.base.ProcessUnit {

	@BizUnitBind private FUCorpGrpRelCoFinStat fuCorpGrpRelCoFinStat;

    /**
     * 거래코드: KIP04A2140
     * 거래명: 관계기업주요재무현황(합산연결재무제표)
     * <pre>
     * 메소드 설명 : 기업집단 관계기업의 주요 재무현황을 합산연결재무제표 기준으로 조회하는 온라인 거래
     * 비즈니스 기능:
     * - 관계기업 합산연결재무제표 조회
     * - 주요 재무지표 산출
     * - 재무현황 분석 데이터 제공
     * 
     * 입력 파라미터:
     * - field : corpClctGroupCd [기업집단그룹코드] (string)
     * - field : corpClctRegiCd [기업집단등록코드] (string)
     * - field : valuaYmd [평가년월일] (string)
     * 
     * 출력 파라미터:
     * - field : processStatus [처리상태] (string)
     * - field : processMessage [처리메시지] (string)
     * - recordSet : finStatData [재무현황데이터 LIST]
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("관계기업주요재무현황(합산연결재무제표)")
    public IDataSet pmKIP04A2140(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단관계기업주요재무현황(합산연결재무제표) 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 검증
            validateInputParametersForConsolidated(requestData);
            
            // 기업집단관계기업주요재무현황(합산연결재무제표) 조회 처리
            responseData = fuCorpGrpRelCoFinStat.processCorpGrpRelCoFinStatDetailInquiry(requestData, onlineCtx);
            
            log.debug("기업집단관계기업주요재무현황(합산연결재무제표) 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단관계기업주요재무현황(합산연결재무제표) 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단관계기업주요재무현황(합산연결재무제표) 시스템 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "처리 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 거래코드: KIP04A2040
     * 거래명: 관계기업재무현황(개별기업)
     * <pre>
     * 메소드 설명 : 기업집단 관계기업의 재무현황을 개별기업 기준으로 조회하는 온라인 거래
     * 비즈니스 기능:
     * - 개별기업 재무현황 조회
     * - 관계기업별 재무데이터 제공
     * - 재무지표 분석
     * 
     * 입력 파라미터:
     * - field : corpClctGroupCd [기업집단그룹코드] (string)
     * - field : corpClctRegiCd [기업집단등록코드] (string)
     * - field : inquryYmd [조회년월일] (string)
     * 
     * 출력 파라미터:
     * - field : processStatus [처리상태] (string)
     * - field : processMessage [처리메시지] (string)
     * - recordSet : relCoFinData [관계회사재무데이터 LIST]
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("관계기업재무현황(개별기업)")
    public IDataSet pmKIP04A2040(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단관계기업재무현황조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 검증
            validateInputParameters(requestData);
            
            // 기업집단관계기업재무현황 조회 처리
            responseData = fuCorpGrpRelCoFinStat.processCorpGrpRelCoFinStatInquiry(requestData, onlineCtx);
            
            log.debug("기업집단관계기업재무현황조회 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단관계기업재무현황조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단관계기업재무현황조회 시스템 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "처리 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 입력 파라미터 검증
     * @param requestData 요청정보 DataSet 객체
     */
    private void validateInputParameters(IDataSet requestData) {
        // BR-048-001: 기업집단식별검증
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드를 확인하고 거래를 재시도");
        }
        
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드를 확인하고 거래를 재시도");
        }
        
        // BR-048-002: 조회일자검증
        String inquryYmd = requestData.getString("inquryYmd");
        if (inquryYmd == null || inquryYmd.trim().isEmpty()) {
            throw new BusinessException("B2701130", "UKII0244", "유효한 조회일자를 입력하고 거래를 재시도");
        }
        
        // 조회일자 형식 검증 (YYYYMMDD)
        if (inquryYmd.length() != 8 || !inquryYmd.matches("\\d{8}")) {
            throw new BusinessException("B2701130", "UKII0244", "유효한 조회일자를 입력하고 거래를 재시도");
        }
    }

    /**
     * 합산연결재무제표용 입력 파라미터 검증
     * @param requestData 요청정보 DataSet 객체
     */
    private void validateInputParametersForConsolidated(IDataSet requestData) {
        // BR-049-001: 기업집단식별검증
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드를 확인하고 거래를 재시도");
        }
        
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드를 확인하고 거래를 재시도");
        }
        
        // BR-049-002: 평가일자검증
        String valuaYmd = requestData.getString("valuaYmd");
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException("B2701130", "UKII0244", "유효한 평가년월일을 입력하고 거래를 재시도");
        }
        
        // 평가년월일 형식 검증 (YYYYMMDD)
        if (valuaYmd.length() != 8 || !valuaYmd.matches("\\d{8}")) {
            throw new BusinessException("B2701130", "UKII0244", "유효한 평가년월일을 입력하고 거래를 재시도");
        }
    }

}
