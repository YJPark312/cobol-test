package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;
import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * FU 클래스: FUCorpGrpFinCalc
 * 기업집단 재무계산 처리 기능 유닛
 * @author MultiQ4KBBank
 */
@BizUnit(value = "기업집단재무계산처리", type = "FU")
public class FUCorpGrpFinCalc extends com.kbstar.sqc.base.FunctionUnit {

	@BizUnitBind private DUTSKIPA110 duTSKIPA110;
	@BizUnitBind private FUMathFormula fuMathFormula;

    /**
     * 재무계산 처리
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("재무계산처리")
    public IDataSet processFinancialCalculation(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("재무계산처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // BR-048-003: 재무데이터처리분류
            String prcssDstic = requestData.getString("prcssDstic");
            
            switch (prcssDstic) {
                case "01":
                case "02":
                    // 개별재무제표 처리
                    responseData = processIndividualFinancialStatement(requestData, onlineCtx);
                    break;
                case "03":
                    // 연결재무제표 처리
                    responseData = processConsolidatedFinancialStatement(requestData, onlineCtx);
                    break;
                default:
                    throw new BusinessException("B4200099", "UKII0803", "유효하지 않은 처리구분입니다: " + prcssDstic);
            }
            
            log.debug("재무계산처리 완료");
            
        } catch (BusinessException e) {
            log.error("재무계산처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("재무계산처리 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 개별재무제표 처리
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("개별재무제표처리")
    public IDataSet processIndividualFinancialStatement(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("개별재무제표처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // F-048-002: 재무데이터처리및계산
            // 재무제표 데이터 조회 (DUTSKIPA110 활용)
            IDataSet finStatData = retrieveFinancialStatementData(requestData, onlineCtx);
            
            // BR-048-006: 재무제표데이터검증
            validateFinancialStatementData(finStatData);
            
            // BR-048-004: 재무비율계산처리
            IDataSet finRatioData = calculateFinancialRatios(finStatData, onlineCtx);
            
            // 결과 구성
            responseData.put("fnstDstic", "01"); // 개별재무제표
            responseData.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            responseData.put("financialStatement", finStatData);
            responseData.put("financialRatios", finRatioData);
            responseData.put("fnafAbOrglDstcd", "1"); // 내부 은행 데이터
            
            log.debug("개별재무제표처리 완료");
            
        } catch (BusinessException e) {
            log.error("개별재무제표처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("개별재무제표처리 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 연결재무제표 처리
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("연결재무제표처리")
    public IDataSet processConsolidatedFinancialStatement(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("연결재무제표처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // TODO: 연결재무제표 처리 로직 (외부 시스템 연동 필요)
            // 현재는 기본 구조만 제공
            responseData.put("fnstDstic", "03"); // 연결재무제표
            responseData.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            responseData.put("fnafAbOrglDstcd", "3"); // 연결재무제표
            
            log.debug("연결재무제표처리 완료 (기본 구조)");
            
        } catch (Exception e) {
            log.error("연결재무제표처리 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 재무제표 데이터 조회
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 재무제표 데이터
     */
    @BizMethod("재무제표데이터조회")
    public IDataSet retrieveFinancialStatementData(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("재무제표데이터조회 시작");
        
        try {
            // DUTHKIPA110을 활용한 재무데이터 조회
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaYmd", requestData.getString("valuaBaseYmd"));
            
            IDataSet finData = duTSKIPA110.selectCorpGrpBasicInfo(queryReq, onlineCtx);
            
            // 재무제표 항목 설정 (샘플 데이터)
            IDataSet finStatData = new DataSet();
            finStatData.put("totalAsst", new BigDecimal("1000000000")); // 총자산
            finStatData.put("oncp", new BigDecimal("300000000")); // 자기자본
            finStatData.put("ambr", new BigDecimal("200000000")); // 차입금
            finStatData.put("cshAsst", new BigDecimal("100000000")); // 현금자산
            finStatData.put("salepr", new BigDecimal("800000000")); // 매출액
            finStatData.put("oprft", new BigDecimal("80000000")); // 영업이익
            finStatData.put("fncs", new BigDecimal("10000000")); // 금융비용
            finStatData.put("netPrft", new BigDecimal("60000000")); // 순이익
            finStatData.put("bzoproNcf", new BigDecimal("90000000")); // 영업NCF
            finStatData.put("ebitda", new BigDecimal("100000000")); // EBITDA
            
            log.debug("재무제표데이터조회 완료");
            return finStatData;
            
        } catch (Exception e) {
            log.error("재무제표데이터조회 시스템 오류", e);
            throw new BusinessException("B3900002", "UKII0182", "데이터베이스 연결 문제는 시스템 관리자에게 문의", e);
        }
    }

    /**
     * 재무비율 계산
     * @param finStatData 재무제표 데이터
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 재무비율 데이터
     */
    @BizMethod("재무비율계산")
    public IDataSet calculateFinancialRatios(IDataSet finStatData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("재무비율계산 시작");
        
        IDataSet ratioData = new DataSet();
        
        try {
            // BR-048-004: 재무비율계산처리
            BigDecimal totalAsst = new BigDecimal(finStatData.getString("totalAsst") != null ? finStatData.getString("totalAsst") : "0");
            BigDecimal oncp = new BigDecimal(finStatData.getString("oncp") != null ? finStatData.getString("oncp") : "0");
            BigDecimal ambr = new BigDecimal(finStatData.getString("ambr") != null ? finStatData.getString("ambr") : "0");
            
            // 부채비율 계산 (부채/자기자본 * 100)
            BigDecimal liablRato = BigDecimal.ZERO;
            if (oncp != null && oncp.compareTo(BigDecimal.ZERO) != 0) {
                BigDecimal liabl = totalAsst.subtract(oncp); // 부채 = 총자산 - 자기자본
                
                // F-048-003: 수학공식처리
                IDataSet formulaReq = new DataSet();
                formulaReq.put("formula", "(" + liabl.toString() + " / " + oncp.toString() + ") * 100");
                IDataSet formulaResult = fuMathFormula.processFormula(formulaReq, onlineCtx);
                liablRato = new BigDecimal(formulaResult.getString("result") != null ? formulaResult.getString("result") : "0");
            }
            
            // 차입금의존도 계산 (차입금/총자산 * 100)
            BigDecimal ambrRlnc = BigDecimal.ZERO;
            if (totalAsst != null && totalAsst.compareTo(BigDecimal.ZERO) != 0) {
                IDataSet formulaReq = new DataSet();
                formulaReq.put("formula", "(" + ambr.toString() + " / " + totalAsst.toString() + ") * 100");
                IDataSet formulaResult = fuMathFormula.processFormula(formulaReq, onlineCtx);
                ambrRlnc = new BigDecimal(formulaResult.getString("result") != null ? formulaResult.getString("result") : "0");
            }
            
            ratioData.put("liablRato", liablRato.setScale(2, RoundingMode.HALF_UP));
            ratioData.put("ambrRlnc", ambrRlnc.setScale(2, RoundingMode.HALF_UP));
            
            log.debug("재무비율계산 완료 - 부채비율: " + liablRato + ", 차입금의존도: " + ambrRlnc);
            
        } catch (BusinessException e) {
            log.error("재무비율계산 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("재무비율계산 시스템 오류", e);
            throw new BusinessException("B3000108", "UKII0291", "수학공식 및 계산 매개변수를 확인", e);
        }
        
        return ratioData;
    }

    /**
     * 재무제표 데이터 검증
     * @param finStatData 재무제표 데이터
     */
    private void validateFinancialStatementData(IDataSet finStatData) {
        if (finStatData == null) {
            throw new BusinessException("B4200099", "UKII0803", "재무제표 데이터가 유효하지 않습니다");
        }
        
        BigDecimal totalAsst = new BigDecimal(finStatData.getString("totalAsst") != null ? finStatData.getString("totalAsst") : "0");
        BigDecimal oncp = new BigDecimal(finStatData.getString("oncp") != null ? finStatData.getString("oncp") : "0");
        
        if (totalAsst == null || totalAsst.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException("B4200099", "UKII0803", "총자산 데이터가 유효하지 않습니다");
        }
        
        if (oncp == null || oncp.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException("B4200099", "UKII0803", "자기자본 데이터가 유효하지 않습니다");
        }
    }

}
