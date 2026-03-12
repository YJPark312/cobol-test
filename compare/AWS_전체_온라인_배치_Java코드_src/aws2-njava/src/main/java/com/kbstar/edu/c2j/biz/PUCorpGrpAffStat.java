package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;
import com.kbstar.sqc.common.CommonArea;

/**
 * 기업집단계열사현황저장.
 * <pre>
 * 유닛 설명 : 기업집단 계열사 정보를 일괄 저장하는 온라인 거래 처리 유닛
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
@BizUnit(value = "기업집단계열사현황저장", type = "PU")
public class PUCorpGrpAffStat extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FUCorpGrpAffStat fuCorpGrpAffStat;

    /**
     * 거래코드: KIP04A6440
     * 거래명: 전체계열사현황보기
     * <pre>
     * 메소드 설명 : 기업집단 계열사 현황 조회 처리 (AIP4A64 모듈)
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : prcssDstcd [처리구분코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaBaseYmd [평가기준년월일] (string)
     *	- field : valuaYmd [평가년월일] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : totalNoitm [총건수] (numeric)
     *	- field : prsntNoitm [현재건수] (numeric)
     *	- recordSet : affiliateGrid [계열사현황그리드]
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : coprName [법인명] (string)
     *		- field : kisCOpblcDstcd [한국신용평가기업공개구분코드] (string)
     *		- field : dsticName [구분명] (string)
     *		- field : incorYmd [설립년월일] (string)
     *		- field : bztypName [업종명] (string)
     *		- field : rprsName [대표자명] (string)
     *		- field : stlaccBsemn [결산기준월] (string)
     *		- field : totalAsam [총자산금액] (numeric)
     *		- field : salepr [매출액] (numeric)
     *		- field : captlTsumnAmt [자본총계금액] (numeric)
     *		- field : netPrft [순이익] (numeric)
     *		- field : oprft [영업이익] (numeric)
     *		- field : fncs [금융비용] (numeric)
     *		- field : ebitdaAmt [EBITDA금액] (numeric)
     *		- field : corpCLiablRato [기업집단부채비율] (numeric)
     *		- field : ambrRlncRt [차입금의존도율] (numeric)
     *		- field : netBAvtyCsfwAmt [순영업현금흐름금액] (numeric)
     * </pre>
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("전체계열사현황보기")
    public IDataSet pmKIP04A6440(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);

        try {
            log.debug("기업집단계열사현황조회 시작");
            
            // BR-050-001: 기업집단검증규칙 - 필수 입력값 검증
            validateCorpGrpInquiryInput(requestData);
            
            // BR-050-002: 처리구분규칙 - 처리구분에 따른 분기 처리
            String prcssDstcd = requestData.getString("prcssDstcd");
            
            IDataSet responseData = new DataSet();
            
            if ("20".equals(prcssDstcd)) {
                // 신규평가 처리
                responseData = processNewEvaluation(requestData, onlineCtx);
            } else if ("40".equals(prcssDstcd)) {
                // 기존평가 처리
                responseData = processExistingEvaluation(requestData, onlineCtx);
            } else {
                throw new BusinessException("B3000070", "UKII0291", "처리구분코드를 확인 후 거래하세요");
            }
            
            log.debug("기업집단계열사현황조회 완료 - 총건수: " + responseData.get("totalNoitm"));
            
            return responseData;

        } catch (BusinessException e) {
            log.error("기업집단계열사현황조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단계열사현황조회 시스템 오류", e);
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
    }

    /**
     * 기업집단계열사현황저장.
     * <pre>
     * 메소드 설명 : 기업집단 계열사 정보를 일괄 저장하는 온라인 거래
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string)
     *	- field : valuaBaseYmd [평가기준일자] (string)
     *	- recordSet : grid1 [계열사 정보 LIST]
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : corpName [법인명] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : returnCd [리턴코드] (string)
     *	- field : returnMsg [리턴메시지] (string)
     *	- field : totalNoitm [총건수] (bigDecimal)
     *	- field : prsntNoitm [현재건수] (bigDecimal)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단계열사현황저장")
    public IDataSet pmKIP11A69E0(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);

        try {
            log.debug("기업집단계열사현황저장 시작");
            
            // 비즈니스 룰 BR-020-001: 기업집단식별검증
            validateInput(requestData);
            
            // FU 호출하여 계열사 현황 조회 처리
            IDataSet responseData = fuCorpGrpAffStat.inquireCorpGrpAffStat(requestData, onlineCtx);
            
            log.debug("기업집단계열사현황저장 완료 - 처리건수: " + responseData.get("prsntNoitm"));
            
            return responseData;

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
    }

    /**
     * 입력값 검증 - BR-020-001 구현
     */
    private void validateInput(IDataSet requestData) {
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        String valuaYmd = requestData.getString("valuaYmd");
        String valuaBaseYmd = requestData.getString("valuaBaseYmd");
        
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0001", "기업집단그룹코드 확인후 거래하세요");
        }
        
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0002", "기업집단등록코드 확인후 거래하세요");
        }
        
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0003", "평가년월일 확인후 거래하세요");
        }
        
        if (valuaBaseYmd == null || valuaBaseYmd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKJK0134", "평가기준일 입력 후 다시 거래하세요");
        }
    }

    /**
     * 기업집단 조회 입력값 검증 - BR-050-001 구현
     */
    private void validateCorpGrpInquiryInput(IDataSet requestData) {
        String prcssDstcd = requestData.getString("prcssDstcd");
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        String valuaBaseYmd = requestData.getString("valuaBaseYmd");
        
        // BR-050-001: 처리구분코드 검증
        if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKII0291", "처리구분코드를 확인 후 거래하세요");
        }
        
        // BR-050-001: 기업집단그룹코드 검증
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0001", "기업집단그룹코드를 확인 후 거래하세요");
        }
        
        // BR-050-001: 기업집단등록코드 검증
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0002", "기업집단등록코드를 확인 후 거래하세요");
        }
        
        // BR-050-003: 평가기준년월일 검증
        if (valuaBaseYmd == null || valuaBaseYmd.trim().isEmpty()) {
            throw new BusinessException("B2701130", "UKIP0008", "평가기준년월일을 확인 후 거래하세요");
        }
        
        // BR-050-003: 평가기준년월일 형식 검증
        if (!isValidDateFormat(valuaBaseYmd)) {
            throw new BusinessException("B2701130", "UKIP0008", "평가기준년월일 형식을 확인 후 거래하세요");
        }
    }

    /**
     * 신규평가 처리 - F-050-002 구현
     */
    private IDataSet processNewEvaluation(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("신규평가 처리 시작");
        
        // FU 호출하여 신규평가 계열사 조회 처리
        IDataSet responseData = fuCorpGrpAffStat.processNewEvaluationAffiliates(requestData, onlineCtx);
        
        log.debug("신규평가 처리 완료");
        return responseData;
    }

    /**
     * 기존평가 처리 - F-050-004 구현
     */
    private IDataSet processExistingEvaluation(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기존평가 처리 시작");
        
        // FU 호출하여 기존평가 계열사 조회 처리
        IDataSet responseData = fuCorpGrpAffStat.processExistingEvaluationAffiliates(requestData, onlineCtx);
        
        log.debug("기존평가 처리 완료");
        return responseData;
    }

    /**
     * 날짜 형식 검증 유틸리티
     */
    private boolean isValidDateFormat(String dateStr) {
        if (dateStr == null || dateStr.length() != 8) {
            return false;
        }
        
        try {
            int year = Integer.parseInt(dateStr.substring(0, 4));
            int month = Integer.parseInt(dateStr.substring(4, 6));
            int day = Integer.parseInt(dateStr.substring(6, 8));
            
            if (year < 1900 || year > 2100) return false;
            if (month < 1 || month > 12) return false;
            if (day < 1 || day > 31) return false;
            
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
