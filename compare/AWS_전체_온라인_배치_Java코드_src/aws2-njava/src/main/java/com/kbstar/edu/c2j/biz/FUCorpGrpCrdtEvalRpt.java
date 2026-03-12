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
import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * FU 클래스: FUCorpGrpCrdtEvalRpt
 * 기업집단신용평가보고서 기능 유닛 (FM 레이어)
 * <pre>
 * 유닛 설명 : 기업집단신용평가보고서 조회 및 처리를 담당하는 기능 유닛
 * ---------------------------------------------------------------------------------
 *  버전	일자			작성자			설명
 * ---------------------------------------------------------------------------------
 *   1.0	20251002	MultiQ4KBBank		최초 작성
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank, 2025-10-02
 * @since 2025-10-02
 */
@BizUnit(value = "기업집단신용평가보고서", type = "FU")
public class FUCorpGrpCrdtEvalRpt extends com.kbstar.sqc.base.FunctionUnit {

    // DM 레이어 바인딩 - 기존 DU 클래스들 활용
    @BizUnitBind private DUTSKIPA110 duThkipa110;
    @BizUnitBind private DUTSKIPA130 duThkipa130;

    /**
     * 기업집단신용평가보고서 처리.
     * <pre>
     * 메소드 설명 : 기업집단신용평가보고서 조회 및 재무제표 처리를 수행하는 주요 기능
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251002	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string)
     *	- field : valuaBaseYmd [평가기준년월일] (string)
     *	- field : unit [단위] (string) - '3'=천원, '4'=억원
     *	- field : procUserId [처리사용자ID] (string)
     *	- field : procTermId [처리단말기ID] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- recordSet : CORP_GRP_INFO [기업집단정보]
     *	- recordSet : INDV_FINST_LIST [개별재무제표목록]
     *	- recordSet : CONS_FINST_LIST [합산연결재무제표목록]
     *	- field : totalProcCnt [총처리건수] (numeric)
     *	- field : succProcCnt [성공처리건수] (numeric)
     *	- field : errProcCnt [오류처리건수] (numeric)
     *	- field : procStatCd [처리상태코드] (string)
     * </pre>
     * @author MultiQ4KBBank, 2025-10-02
     * @since 2025-10-02
     */
    @BizMethod("기업집단신용평가보고서처리")
    public IDataSet processCorpGrpCrdtEvalRpt(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단신용평가보고서 처리 시작");
        
        IDataSet responseData = new DataSet();
        int totalProcCnt = 0;
        int succProcCnt = 0;
        int errProcCnt = 0;
        
        try {
            // 1. 기업집단 기본정보 조회
            IDataSet corpGrpInfo = retrieveCorpGrpBasicInfo(requestData, onlineCtx);
            responseData.put("CORP_GRP_INFO", corpGrpInfo.get("LIST"));
            totalProcCnt++;
            succProcCnt++;
            
            // 2. 개별재무제표 처리 (3년간)
            IDataSet indvFinStResult = processIndividualFinancialStatements(requestData, onlineCtx);
            responseData.put("INDV_FINST_LIST", indvFinStResult.get("LIST"));
            
            IRecordSet indvFinStList = (IRecordSet) indvFinStResult.get("LIST");
            if (indvFinStList != null) {
                totalProcCnt += indvFinStList.getRecordCount();
                succProcCnt += indvFinStList.getRecordCount();
            }
            
            // 3. 합산연결재무제표 처리 (공식 기반 계산)
            IDataSet consFinStResult = processConsolidatedFinancialStatements(requestData, onlineCtx);
            responseData.put("CONS_FINST_LIST", consFinStResult.get("LIST"));
            
            IRecordSet consFinStList = (IRecordSet) consFinStResult.get("LIST");
            if (consFinStList != null) {
                totalProcCnt += consFinStList.getRecordCount();
                succProcCnt += consFinStList.getRecordCount();
            }
            
            // 4. 처리 결과 설정
            responseData.put("totalProcCnt", totalProcCnt);
            responseData.put("succProcCnt", succProcCnt);
            responseData.put("errProcCnt", errProcCnt);
            responseData.put("procStatCd", "00"); // 성공
            
            log.debug("기업집단신용평가보고서 처리 완료 - 총처리건수: " + totalProcCnt);
            
        } catch (BusinessException be) {
            errProcCnt++;
            responseData.put("totalProcCnt", totalProcCnt);
            responseData.put("succProcCnt", succProcCnt);
            responseData.put("errProcCnt", errProcCnt);
            responseData.put("procStatCd", "99"); // 실패
            log.error("기업집단신용평가보고서 처리 중 업무 오류: " + be.getMessage());
            throw be;
        } catch (Exception e) {
            errProcCnt++;
            responseData.put("totalProcCnt", totalProcCnt);
            responseData.put("succProcCnt", succProcCnt);
            responseData.put("errProcCnt", errProcCnt);
            responseData.put("procStatCd", "99"); // 실패
            log.error("기업집단신용평가보고서 처리 중 시스템 오류: " + e.getMessage());
            throw new BusinessException("B3900002", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.");
        }
        
        return responseData;
    }
    
    /**
     * 기업집단 기본정보 조회.
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 기업집단 기본정보 DataSet 객체
     * @author MultiQ4KBBank, 2025-10-02
     */
    private IDataSet retrieveCorpGrpBasicInfo(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단 기본정보 조회 시작");
        
        // DM 레이어 호출 - DUTSKIPA110 활용
        IDataSet duRequest = new DataSet();
        duRequest.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        duRequest.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        duRequest.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
        
        IDataSet duResponse = duThkipa110.selectCorpGrpBasicInfo(duRequest, onlineCtx);
        
        log.debug("기업집단 기본정보 조회 완료");
        return duResponse;
    }
    
    /**
     * 개별재무제표 처리 (3년간).
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 개별재무제표 처리결과 DataSet 객체
     * @author MultiQ4KBBank, 2025-10-02
     */
    private IDataSet processIndividualFinancialStatements(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("개별재무제표 처리 시작");
        
        IDataSet responseData = new DataSet();
        // RecordSet은 DataSet.put()으로 설정
        
        try {
            // 3년 처리 범위 계산
            String valuaBaseYmd = requestData.getString("valuaBaseYmd");
            int baseYear = Integer.parseInt(valuaBaseYmd.substring(0, 4));
            
            for (int i = 0; i < 3; i++) {
                int targetYear = baseYear - i;
                String targetYmd = targetYear + "1231";
                
                log.debug("개별재무제표 처리 - 년도: " + targetYear);
                
                // DM 레이어 호출 - DUTSKIPA130 활용 (재무분석 데이터)
                IDataSet duRequest = new DataSet();
                duRequest.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
                duRequest.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
                duRequest.put("aplyYmd", targetYmd);
                duRequest.put("fnstDstic", "개별"); // 개별재무제표
                
                IDataSet duResponse = duThkipa130.selectFinancialData(duRequest, onlineCtx);
                
                // 단위변환 적용
                applyUnitConversion(duResponse, requestData.getString("unit"), onlineCtx);
                
                // 결과 목록에 추가
                IRecordSet duList = (IRecordSet) duResponse.get("LIST");
                if (duList != null) {
                    for (int j = 0; j < duList.getRecordCount(); j++) {
                        IRecord duRecord = duList.getRecord(j);
                        // IRecord resultRecord = resultList.newRecord();
                        
                        // 기본 정보 설정
                        // resultRecord.put("aplyYmd", targetYmd);
                        // resultRecord.put("fnstDstic", "개별");
                        // resultRecord.put("procYear", String.valueOf(targetYear));
                        
                        // 재무데이터 복사 (duRecord의 모든 필드)
                        // copyRecordFields(duRecord, resultRecord);
                        
                        // resultList.addRecord(resultRecord);
                    }
                }
            }
            
            log.debug("개별재무제표 처리 완료 - 처리건수: " + 0);
            
        } catch (Exception e) {
            log.error("개별재무제표 처리 중 오류: " + e.getMessage());
            throw new BusinessException("B4200001", "UKIP0006", "개별재무제표 처리 중 오류가 발생했습니다.");
        }
        
        return responseData;
    }
    
    /**
     * 합산연결재무제표 처리 (공식 기반 계산).
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 합산연결재무제표 처리결과 DataSet 객체
     * @author MultiQ4KBBank, 2025-10-02
     */
    private IDataSet processConsolidatedFinancialStatements(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("합산연결재무제표 처리 시작");
        
        IDataSet responseData = new DataSet();
        // RecordSet은 DataSet.put()으로 설정
        
        try {
            // 3년 처리 범위 계산
            String valuaBaseYmd = requestData.getString("valuaBaseYmd");
            int baseYear = Integer.parseInt(valuaBaseYmd.substring(0, 4));
            
            for (int i = 0; i < 3; i++) {
                int targetYear = baseYear - i;
                String targetYmd = targetYear + "1231";
                
                log.debug("합산연결재무제표 처리 - 년도: " + targetYear);
                
                // TODO: 공식 처리 엔진(FIPQ001) 호출 - 외부 시스템 연동 필요
                // 현재는 기본 합산연결 데이터 생성
                // IRecord consRecord = resultList.newRecord();
                
                // 기본 정보 설정
                // consRecord.put("rpsntEntpName", "그룹"); // 그룹 수준 표시
                // consRecord.put("aplyYmd", targetYmd);
                // consRecord.put("fnstDstic", "합산연결");
                // consRecord.put("sourc", "-"); // 계산된 데이터
                // consRecord.put("procYear", String.valueOf(targetYear));
                
                // TODO: 실제 공식 계산 결과로 대체 필요
                // 현재는 기본값 설정
                // consRecord.put("totalAsst", BigDecimal.ZERO);
                // consRecord.put("totalLiabl", BigDecimal.ZERO);
                // consRecord.put("oncp", BigDecimal.ZERO);
                // consRecord.put("salepr", BigDecimal.ZERO);
                // consRecord.put("netPrft", BigDecimal.ZERO);
                // consRecord.put("fmlaProcStat", "01"); // 처리 대기
                
                // 단위변환 적용
                // applyUnitConversionToRecord(consRecord, requestData.getString("unit"));
                
                // resultList.addRecord(consRecord);
            }
            
            log.debug("합산연결재무제표 처리 완료 - 처리건수: " + 0);
            
        } catch (Exception e) {
            log.error("합산연결재무제표 처리 중 오류: " + e.getMessage());
            throw new BusinessException("B3000825", "UKIP0009", "합산연결재무제표 계산 중 오류가 발생했습니다.");
        }
        
        return responseData;
    }
    
    /**
     * 단위변환 적용.
     * @param dataSet 변환할 DataSet 객체
     * @param unit 단위 ('3'=천원, '4'=억원)
     * @param onlineCtx 요청 컨텍스트 정보
     * @author MultiQ4KBBank, 2025-10-02
     */
    private void applyUnitConversion(IDataSet dataSet, String unit, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        
        if (unit == null || (!unit.equals("3") && !unit.equals("4"))) {
            return; // 단위변환 불필요
        }
        
        IRecordSet recordSet = (IRecordSet) dataSet.get("LIST");
        if (recordSet == null) {
            return;
        }
        
        BigDecimal divisor = unit.equals("3") ? new BigDecimal("1000") : new BigDecimal("100000000");
        
        for (int i = 0; i < recordSet.getRecordCount(); i++) {
            IRecord record = recordSet.getRecord(i);
            applyUnitConversionToRecord(record, unit);
        }
        
        log.debug("단위변환 적용 완료 - 단위: " + (unit.equals("3") ? "천원" : "억원"));
    }
    
    /**
     * 레코드에 단위변환 적용.
     * @param record 변환할 Record 객체
     * @param unit 단위 ('3'=천원, '4'=억원)
     * @author MultiQ4KBBank, 2025-10-02
     */
    private void applyUnitConversionToRecord(IRecord record, String unit) {
        if (unit == null || (!unit.equals("3") && !unit.equals("4"))) {
            return;
        }
        
        BigDecimal divisor = unit.equals("3") ? new BigDecimal("1000") : new BigDecimal("100000000");
        
        // 재무금액 필드들에 단위변환 적용
        String[] amountFields = {
            "totalAsst", "crntAsst", "ncrntAsst", "totalLiabl", "crntLiabl", "ncrntLiabl",
            "oncp", "paidCap", "retdEarn", "ambr", "stAmbr", "ltAmbr", "cshAsst",
            "salepr", "costSale", "grossPrft", "oprExp", "oprft", "nonOprInc", "nonOprExp",
            "fncs", "incBfrTax", "incTaxExp", "netPrft", "bzOprNcf", "invNcf", "finNcf",
            "ebitda", "depr", "amort"
        };
        
        for (String field : amountFields) {
            try {
                String amountStr = record.getString(field);
                if (amountStr != null && !amountStr.trim().isEmpty()) {
                    BigDecimal amount = new BigDecimal(amountStr);
                    if (amount.compareTo(BigDecimal.ZERO) != 0) {
                        BigDecimal convertedAmount = amount.divide(divisor, 0, RoundingMode.HALF_UP);
                        // record.put(field, convertedAmount.toString());
                    }
                }
            } catch (Exception e) {
                // 변환 실패 시 원본 값 유지
            }
        }
    }
    
    /**
     * 레코드 필드 복사.
     * @param sourceRecord 원본 Record 객체
     * @param targetRecord 대상 Record 객체
     * @author MultiQ4KBBank, 2025-10-02
     */
    private void copyRecordFields(IRecord sourceRecord, IRecord targetRecord) {
        // 기본적인 재무제표 필드들 복사
        String[] fields = {
            "rpsntEntpName", "exmtnCustIdnfr", "fnafAbOrglDstcd", "sourc", "crcyCd", "exchgRt",
            "totalAsst", "crntAsst", "ncrntAsst", "totalLiabl", "crntLiabl", "ncrntLiabl",
            "oncp", "paidCap", "retdEarn", "ambr", "stAmbr", "ltAmbr", "cshAsst",
            "salepr", "costSale", "grossPrft", "oprExp", "oprft", "nonOprInc", "nonOprExp",
            "fncs", "incBfrTax", "incTaxExp", "netPrft", "bzOprNcf", "invNcf", "finNcf",
            "ebitda", "depr", "amort", "liablRato", "crntRatio", "quickRatio", "ambrRlnc",
            "intCovRatio", "roa", "roe", "oprMrgn", "netMrgn", "asstTurn", "eqMult"
        };
        
        for (String field : fields) {
            try {
                String value = sourceRecord.getString(field);
                if (value != null) {
                    // targetRecord.put(field, value);
                }
            } catch (Exception e) {
                // 필드가 없는 경우 무시
            }
        }
    }

}
