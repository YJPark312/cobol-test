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
 * 기업집단관계사현황조회.
 * <pre>
 * 유닛 설명 : 기업집단 관계사 현황 정보를 조회하고 처리하는 기능 유닛
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
@BizUnit(value = "기업집단관계사현황조회", type = "FU")
public class FUCorpGrpRelCoStatInq extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA112 duTSKIPA112;
    @BizUnitBind private DUTSKIPA120 duTSKIPA120;

    /**
     * 기업집단관계사현황조회처리.
     * <pre>
     * 메소드 설명 : 기업집단 관계사 현황 정보를 조회하고 처리
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : prcssDistcd [처리구분코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : baseDstic [기준구분] (string)
     *	- field : baseYm [기준년월] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- recordSet : companyList [관계사 정보 LIST]
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : rpsntBzno [대표사업자등록번호] (string)
     *		- field : rpsntEntpName [대표업체명] (string)
     *		- field : corpCvGrdDstcd [기업신용평가등급구분코드] (string)
     *		- field : corpScalDstcd [기업규모구분코드] (string)
     *		- field : stndIClsfiCd [표준산업분류코드] (string)
     *		- field : stndIClsfiName [표준산업분류명] (string)
     *		- field : custMgtBrncd [고객관리부점코드] (string)
     *		- field : brnName [부점명] (string)
     *		- field : totalLnbzAmt [총여신금액] (decimal)
     *		- field : lnbzBal [여신잔액] (decimal)
     *		- field : scurtyAmt [담보금액] (decimal)
     *		- field : amov [연체금액] (decimal)
     *		- field : pyyTotalLnbzAmt [전년총여신금액] (decimal)
     *		- field : corpLPlicyCtnt [기업여신정책내용] (string)
     *		- field : fcltFndsClam [시설자금한도금액] (decimal)
     *		- field : fcltFndsBal [시설자금잔액] (decimal)
     *		- field : wrknFndsClam [운전자금한도금액] (decimal)
     *		- field : wrknFndsBal [운전자금잔액] (decimal)
     *		- field : infcClam [투자금융한도금액] (decimal)
     *		- field : infcBal [투자금융잔액] (decimal)
     *		- field : etcFndsClam [기타자금한도금액] (decimal)
     *		- field : etcFndsBal [기타자금잔액] (decimal)
     *		- field : drvtPTranClam [파생상품거래한도금액] (decimal)
     *		- field : drvtPrdctTranBal [파생상품거래잔액] (decimal)
     *		- field : drvtPcTranClam [파생상품신용거래한도금액] (decimal)
     *		- field : drvtPsTranClam [파생상품담보거래한도금액] (decimal)
     *		- field : inlsGrcrStupClam [포괄신용공여설정한도금액] (decimal)
     *		- field : elyAaMgtDstcd [조기경보사후관리구분코드] (string)
     *		- field : hwrtModfiDstcd [수기변경구분코드] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단관계사현황조회처리")
    public IDataSet processCorpGrpRelCoStatInq(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // BR-024-001: 기업집단식별검증
            validateCorpGrpIdentification(requestData);
            
            // BR-024-002: 처리구분검증
            validateProcessingClassification(requestData);
            
            // BR-024-003: 기준구분데이터선택
            String baseDstic = requestData.getString("baseDstic");
            IDataSet companyData;
            
            if ("1".equals(baseDstic)) {
                // 현재 데이터 조회 (TSKIPA110)
                companyData = retrieveCurrentCompanyData(requestData, onlineCtx);
            } else {
                // 이력 데이터 조회 (TSKIPA120)
                companyData = retrieveHistoricalCompanyData(requestData, onlineCtx);
            }
            
            // F-024-002: 재무데이터집계
            IDataSet aggregatedData = aggregateFinancialData(companyData, onlineCtx);
            
            // F-024-004: 수기조정통합
            IDataSet finalData = integrateManualAdjustments(aggregatedData, requestData, onlineCtx);
            
            // 결과 정렬 (총여신금액 내림차순)
            IRecordSet sortedCompanyList = sortByTotalCreditAmount(finalData.getRecordSet("companyList"));
            
            responseData.put("companyList", sortedCompanyList);
            responseData.put("totalCount", sortedCompanyList.getRecordCount());
            
            log.debug("기업집단관계사현황조회 완료 - 조회건수: " + sortedCompanyList.getRecordCount());

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단식별검증.
     * BR-024-001 구현
     */
    private void validateCorpGrpIdentification(IDataSet requestData) {
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드는 필수입니다.");
        }
        
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드는 필수입니다.");
        }
    }

    /**
     * 처리구분검증.
     * BR-024-002 구현
     */
    private void validateProcessingClassification(IDataSet requestData) {
        String prcssDistcd = requestData.getString("prcssDistcd");
        
        if (prcssDistcd == null || prcssDistcd.trim().isEmpty()) {
            throw new BusinessException("B3000070", "UKIP0001", "처리구분코드는 필수입니다.");
        }
    }

    /**
     * 현재 데이터 조회.
     * TSKIPA110 테이블 조회
     */
    private IDataSet retrieveCurrentCompanyData(IDataSet requestData, IOnlineContext onlineCtx) {
        // DUTSKIPA110 클래스를 통한 현재 데이터 조회 (실제 구현에서는 해당 DU 클래스 필요)
        // 현재는 기본 구조만 제공
        IDataSet queryData = new DataSet();
        queryData.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        queryData.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        
        // TODO: DUTSKIPA110 클래스 구현 후 실제 조회 로직 추가
        IDataSet responseData = new DataSet();
        IRecordSet companyList = new nexcore.framework.core.data.RecordSet();
        responseData.put("companyList", companyList);
        
        return responseData;
    }

    /**
     * 이력 데이터 조회.
     * TSKIPA120 테이블 조회
     */
    private IDataSet retrieveHistoricalCompanyData(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet queryData = new DataSet();
        queryData.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        queryData.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        queryData.put("baseYm", requestData.getString("baseYm"));
        
        return duTSKIPA120.selectHistoricalCompanyList(queryData, onlineCtx);
    }

    /**
     * 재무데이터집계.
     * F-024-002 구현
     */
    private IDataSet aggregateFinancialData(IDataSet companyData, IOnlineContext onlineCtx) {
        // BR-024-004: 재무데이터일관성 검증
        // BR-024-005: 신용한도검증
        
        IRecordSet companyList = companyData.getRecordSet("companyList");
        IRecordSet aggregatedList = new nexcore.framework.core.data.RecordSet();
        
        for (int i = 0; i < companyList.getRecordCount(); i++) {
            IRecord company = companyList.getRecord(i);
            
            // 재무 데이터 일관성 검증
            validateFinancialConsistency(company);
            
            // 신용한도 검증
            validateCreditLimits(company);
            
            aggregatedList.addRecord(company);
        }
        
        IDataSet result = new DataSet();
        result.put("companyList", aggregatedList);
        return result;
    }

    /**
     * 재무데이터일관성 검증.
     * BR-024-004 구현
     */
    private void validateFinancialConsistency(IRecord company) {
        // 재무 금액이 음수가 아닌지 검증
        String[] amountFields = {"totalLnbzAmt", "lnbzBal", "scurtyAmt", "amov", "pyyTotalLnbzAmt"};
        
        for (String field : amountFields) {
            java.math.BigDecimal amount = company.getBigDecimal(field);
            if (amount != null && amount.compareTo(java.math.BigDecimal.ZERO) < 0) {
                getLog().warn("재무데이터 일관성 경고 - 음수 금액: " + field + " = " + amount);
            }
        }
    }

    /**
     * 신용한도검증.
     * BR-024-005 구현
     */
    private void validateCreditLimits(IRecord company) {
        // 잔액이 한도를 초과하지 않는지 검증
        validateLimitBalance("fcltFndsClam", "fcltFndsBal", company);
        validateLimitBalance("wrknFndsClam", "wrknFndsBal", company);
        validateLimitBalance("infcClam", "infcBal", company);
        validateLimitBalance("etcFndsClam", "etcFndsBal", company);
    }

    /**
     * 한도-잔액 관계 검증.
     */
    private void validateLimitBalance(String limitField, String balanceField, IRecord company) {
        java.math.BigDecimal limit = company.getBigDecimal(limitField);
        java.math.BigDecimal balance = company.getBigDecimal(balanceField);
        
        if (limit != null && balance != null && balance.compareTo(limit) > 0) {
            getLog().warn("신용한도 초과 경고 - " + balanceField + "(" + balance + ") > " + limitField + "(" + limit + ")");
        }
    }

    /**
     * 수기조정통합.
     * F-024-004 구현
     */
    private IDataSet integrateManualAdjustments(IDataSet companyData, IDataSet requestData, IOnlineContext onlineCtx) {
        IRecordSet companyList = companyData.getRecordSet("companyList");
        IRecordSet integratedList = new nexcore.framework.core.data.RecordSet();
        
        for (int i = 0; i < companyList.getRecordCount(); i++) {
            IRecord company = companyList.getRecord(i);
            
            // BR-024-007: 수기조정우선순위 처리
            IDataSet adjustmentData = getManualAdjustmentData(company.getString("exmtnCustIdnfr"), onlineCtx);
            
            if (adjustmentData != null && adjustmentData.getRecordSet("adjustmentList").getRecordCount() > 0) {
                IRecord adjustment = adjustmentData.getRecordSet("adjustmentList").getRecord(0);
                company.put("elyAaMgtDstcd", adjustment.getString("elyAaMgtDstcd"));
                company.put("hwrtModfiDstcd", adjustment.getString("hwrtModfiDstcd"));
            }
            
            integratedList.addRecord(company);
        }
        
        IDataSet result = new DataSet();
        result.put("companyList", integratedList);
        return result;
    }

    /**
     * 수기조정데이터 조회.
     * BR-024-007 구현
     */
    private IDataSet getManualAdjustmentData(String exmtnCustIdnfr, IOnlineContext onlineCtx) {
        IDataSet queryData = new DataSet();
        queryData.put("exmtnCustIdnfr", exmtnCustIdnfr);
        
        try {
            return duTSKIPA112.selectManualAdjustmentList(queryData, onlineCtx);
        } catch (Exception e) {
            getLog().warn("수기조정데이터 조회 실패: " + exmtnCustIdnfr, e);
            // 수기조정 데이터가 없어도 처리 계속
            IDataSet emptyResult = new DataSet();
            IRecordSet emptyList = new nexcore.framework.core.data.RecordSet();
            emptyResult.put("adjustmentList", emptyList);
            return emptyResult;
        }
    }

    /**
     * 총여신금액 내림차순 정렬.
     */
    private IRecordSet sortByTotalCreditAmount(IRecordSet companyList) {
        // 총여신금액 기준 내림차순 정렬
        java.util.List<IRecord> recordList = new java.util.ArrayList<>();
        
        for (int i = 0; i < companyList.getRecordCount(); i++) {
            recordList.add(companyList.getRecord(i));
        }
        
        recordList.sort((r1, r2) -> {
            java.math.BigDecimal amt1 = r1.getBigDecimal("totalLnbzAmt");
            java.math.BigDecimal amt2 = r2.getBigDecimal("totalLnbzAmt");
            
            if (amt1 == null) amt1 = java.math.BigDecimal.ZERO;
            if (amt2 == null) amt2 = java.math.BigDecimal.ZERO;
            
            return amt2.compareTo(amt1); // 내림차순
        });
        
        IRecordSet sortedList = new nexcore.framework.core.data.RecordSet();
        for (IRecord record : recordList) {
            sortedList.addRecord(record);
        }
        
        return sortedList;
    }
}
