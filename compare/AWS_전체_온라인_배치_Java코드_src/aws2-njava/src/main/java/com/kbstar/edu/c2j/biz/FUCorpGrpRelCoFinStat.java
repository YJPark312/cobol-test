package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * FU 클래스: FUCorpGrpRelCoFinStat
 * 기업집단관계기업재무현황 처리 기능 유닛
 * @author MultiQ4KBBank
 */
@BizUnit(value = "기업집단관계기업재무현황처리", type = "FU")
public class FUCorpGrpRelCoFinStat extends com.kbstar.sqc.base.FunctionUnit {

	@BizUnitBind private DUTSKIPA110 duThkipa110;
	@BizUnitBind private FUCorpGrpFinCalc fuCorpGrpFinCalc;

    /**
     * 기업집단관계기업재무현황 조회 처리
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("기업집단관계기업재무현황조회처리")
    public IDataSet processCorpGrpRelCoFinStatInquiry(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단관계기업재무현황조회처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // F-048-001: 기업집단재무조회처리
            // 1. 기업집단회사정보 조회
            IDataSet companyInfoResult = processCorpGrpCompanyInfo(requestData, onlineCtx);
            
            // 2. 다년도재무데이터 처리
            IDataSet multiYearFinDataResult = processMultiYearFinancialData(requestData, onlineCtx);
            
            // 3. 결과 컴파일 및 형식화
            responseData = compileFinancialResults(companyInfoResult, multiYearFinDataResult, onlineCtx);
            
            log.debug("기업집단관계기업재무현황조회처리 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단관계기업재무현황조회처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단관계기업재무현황조회처리 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단회사정보 처리
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("기업집단회사정보처리")
    public IDataSet processCorpGrpCompanyInfo(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단회사정보처리 시작");
        
        try {
            // BR-048-007: 기업집단회사정보처리
            // DUTHKIPA110을 활용한 기업집단 기본정보 조회
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaYmd", requestData.getString("inquryYmd"));
            
            IDataSet companyInfo = duThkipa110.selectCorpGrpBasicInfo(queryReq, onlineCtx);
            
            // BR-048-010: 고객식별및관리
            // 회사정보 검증 및 처리
            validateCompanyInfo(companyInfo);
            
            log.debug("기업집단회사정보처리 완료");
            return companyInfo;
            
        } catch (BusinessException e) {
            log.error("기업집단회사정보처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단회사정보처리 시스템 오류", e);
            throw new BusinessException("B4200099", "UKII0803", "입력 매개변수를 확인하고 거래를 재시도", e);
        }
    }

    /**
     * 다년도재무데이터 처리
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("다년도재무데이터처리")
    public IDataSet processMultiYearFinancialData(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("다년도재무데이터처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // BR-048-009: 다년도재무데이터처리
            String inquryYmd = requestData.getString("inquryYmd");
            int baseYear = Integer.parseInt(inquryYmd.substring(0, 4));
            
            // 당년, 전년, 전전년 처리
            for (int i = 0; i < 3; i++) {
                int targetYear = baseYear - i;
                String targetYmd = String.valueOf(targetYear) + inquryYmd.substring(4);
                
                // F-048-004: 다년도재무데이터조회
                IDataSet yearlyData = processYearlyFinancialData(requestData, targetYmd, onlineCtx);
                responseData.put("year" + (i + 1) + "Data", yearlyData);
            }
            
            log.debug("다년도재무데이터처리 완료");
            
        } catch (BusinessException e) {
            log.error("다년도재무데이터처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("다년도재무데이터처리 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 연도별 재무데이터 처리
     * @param requestData 요청정보 DataSet 객체
     * @param targetYmd 대상년월일
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("연도별재무데이터처리")
    public IDataSet processYearlyFinancialData(IDataSet requestData, String targetYmd, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("연도별재무데이터처리 시작 - 대상년월일: " + targetYmd);
        
        try {
            // F-048-002: 재무데이터처리및계산
            IDataSet finCalcReq = new DataSet();
            finCalcReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            finCalcReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            finCalcReq.put("valuaBaseYmd", targetYmd);
            finCalcReq.put("prcssDstic", "01"); // 개별재무제표 처리
            
            // 재무공식계산 처리
            IDataSet finCalcResult = fuCorpGrpFinCalc.processFinancialCalculation(finCalcReq, onlineCtx);
            
            log.debug("연도별재무데이터처리 완료 - 대상년월일: " + targetYmd);
            return finCalcResult;
            
        } catch (BusinessException e) {
            log.error("연도별재무데이터처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("연도별재무데이터처리 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
    }

    /**
     * 재무결과 컴파일
     * @param companyInfoResult 회사정보 결과
     * @param multiYearFinDataResult 다년도재무데이터 결과
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("재무결과컴파일")
    public IDataSet compileFinancialResults(IDataSet companyInfoResult, IDataSet multiYearFinDataResult, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("재무결과컴파일 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // BR-048-011: 재무데이터그리드처리
            // 건수정보 설정
            int totalCount = companyInfoResult.getInt("totalNoitm");
            int presentCount = companyInfoResult.getInt("prsntNoitm");
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            
            // 회사정보 설정
            IRecordSet companyOutput = (IRecordSet) companyInfoResult.get("output");
            if (companyOutput != null && companyOutput.getRecordCount() > 0) {
                responseData.put("exmtnCustIdnfr", companyOutput.getRecord(0).getString("exmtnCustIdnfr"));
                responseData.put("rpsntBzno", companyOutput.getRecord(0).getString("rpsntBzno"));
                responseData.put("rpsntEntpName", companyOutput.getRecord(0).getString("rpsntEntpName"));
                responseData.put("corpLPlicyCtnt", companyOutput.getRecord(0).getString("corpLPlicyCtnt"));
                responseData.put("corpCvGrdDstcd", companyOutput.getRecord(0).getString("corpCvGrdDstcd"));
                responseData.put("corpScalDstcd", companyOutput.getRecord(0).getString("corpScalDstcd"));
                responseData.put("stndIClsfiCd", companyOutput.getRecord(0).getString("stndIClsfiCd"));
                responseData.put("custMgtBrncd", companyOutput.getRecord(0).getString("custMgtBrncd"));
            }
            
            // 다년도 재무데이터 설정
            responseData.put("multiYearFinData", multiYearFinDataResult);
            
            log.debug("재무결과컴파일 완료");
            
        } catch (Exception e) {
            log.error("재무결과컴파일 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 회사정보 검증
     * @param companyInfo 회사정보 DataSet
     */
    private void validateCompanyInfo(IDataSet companyInfo) {
        if (companyInfo == null) {
            throw new BusinessException("B4200099", "UKII0803", "기업집단 회사정보가 존재하지 않습니다");
        }
        
        IRecordSet output = (IRecordSet) companyInfo.get("output");
        if (output == null || output.getRecordCount() == 0) {
            throw new BusinessException("B4200099", "UKII0803", "기업집단 회사정보가 존재하지 않습니다");
        }
    }

    /**
     * 기업집단관계기업재무현황상세 조회 처리 (합산연결재무제표)
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("기업집단관계기업재무현황상세조회처리")
    public IDataSet processCorpGrpRelCoFinStatDetailInquiry(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단관계기업재무현황상세조회처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // F-049-001: 기업집단재무조회처리
            // 1. 기업집단회사정보 조회
            IDataSet companyInfoResult = processCorpGrpCompanyInfoDetail(requestData, onlineCtx);
            
            // 2. 합산연결재무데이터 처리 및 계산
            IDataSet consolidatedFinDataResult = processConsolidatedFinancialDataAndCalculation(requestData, onlineCtx);
            
            // 3. 다년도재무데이터 조회
            IDataSet multiYearFinDataResult = processMultiYearFinancialDataDetail(requestData, onlineCtx);
            
            // 4. 결과 컴파일 및 형식화
            responseData = compileConsolidatedFinancialResults(companyInfoResult, consolidatedFinDataResult, multiYearFinDataResult, onlineCtx);
            
            log.debug("기업집단관계기업재무현황상세조회처리 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단관계기업재무현황상세조회처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단관계기업재무현황상세조회처리 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단회사정보 상세 처리
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("기업집단회사정보상세처리")
    public IDataSet processCorpGrpCompanyInfoDetail(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단회사정보상세처리 시작");
        
        try {
            // BR-049-007: 기업집단회사정보처리
            // DUTHKIPA110을 활용한 기업집단 기본정보 조회
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IDataSet companyInfo = duThkipa110.selectCorpGrpBasicInfo(queryReq, onlineCtx);
            
            // BR-049-010: 고객식별및관리
            // 회사정보 검증 및 처리
            validateCompanyInfoDetail(companyInfo);
            
            log.debug("기업집단회사정보상세처리 완료");
            return companyInfo;
            
        } catch (BusinessException e) {
            log.error("기업집단회사정보상세처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단회사정보상세처리 시스템 오류", e);
            throw new BusinessException("B4200099", "UKII0803", "입력 매개변수를 확인하고 거래를 재시도", e);
        }
    }

    /**
     * 합산연결재무데이터 처리 및 계산
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("합산연결재무데이터처리및계산")
    public IDataSet processConsolidatedFinancialDataAndCalculation(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("합산연결재무데이터처리및계산 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // F-049-002: 합산연결재무데이터처리및계산
            // BR-049-003: 재무데이터처리분류
            String prcssDstic = "03"; // 합산연결재무제표 처리
            
            IDataSet finCalcReq = new DataSet();
            finCalcReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            finCalcReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            finCalcReq.put("valuaBaseYmd", requestData.getString("valuaYmd"));
            finCalcReq.put("prcssDstic", prcssDstic);
            finCalcReq.put("base", 0); // 당년 기준
            
            // 합산연결재무제표 데이터 처리
            IDataSet consolidatedData = processConsolidatedFinancialStatements(finCalcReq, onlineCtx);
            
            // BR-049-004: 재무비율계산처리
            // 재무비율 계산
            IDataSet ratioData = calculateFinancialRatios(consolidatedData, onlineCtx);
            
            // BR-049-006: 합산연결재무제표데이터검증
            // 데이터 일관성 검증
            validateConsolidatedFinancialData(consolidatedData, ratioData);
            
            responseData.put("consolidatedData", consolidatedData);
            responseData.put("ratioData", ratioData);
            
            log.debug("합산연결재무데이터처리및계산 완료");
            
        } catch (BusinessException e) {
            log.error("합산연결재무데이터처리및계산 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("합산연결재무데이터처리및계산 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 다년도재무데이터 상세 처리
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("다년도재무데이터상세처리")
    public IDataSet processMultiYearFinancialDataDetail(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("다년도재무데이터상세처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // F-049-004: 다년도재무데이터조회
            // BR-049-009: 다년도재무데이터처리
            String valuaYmd = requestData.getString("valuaYmd");
            int baseYear = Integer.parseInt(valuaYmd.substring(0, 4));
            
            // 당년, 전년, 전전년 처리
            for (int i = 0; i < 3; i++) {
                int targetYear = baseYear - i;
                String targetYmd = String.valueOf(targetYear) + valuaYmd.substring(4);
                
                IDataSet yearlyReq = new DataSet();
                yearlyReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
                yearlyReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
                yearlyReq.put("valuaBaseYmd", targetYmd);
                yearlyReq.put("prcssDstic", "03"); // 합산연결재무제표
                yearlyReq.put("base", i);
                
                IDataSet yearlyData = processYearlyConsolidatedFinancialData(yearlyReq, onlineCtx);
                responseData.put("year" + (i + 1) + "Data", yearlyData);
            }
            
            log.debug("다년도재무데이터상세처리 완료");
            
        } catch (BusinessException e) {
            log.error("다년도재무데이터상세처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("다년도재무데이터상세처리 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 합산연결재무제표 처리
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("합산연결재무제표처리")
    public IDataSet processConsolidatedFinancialStatements(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("합산연결재무제표처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // DUTHKIPA110을 활용한 합산연결재무제표 데이터 조회
            IDataSet consolidatedQuery = new DataSet();
            consolidatedQuery.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            consolidatedQuery.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            consolidatedQuery.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            consolidatedQuery.put("fnafAStlaccDstcd", "1"); // 재무분석결산구분코드
            
            IDataSet consolidatedResult = duThkipa110.selectCorpGrpBasicInfo(consolidatedQuery, onlineCtx);
            
            // 합산연결재무제표 데이터 구성
            IRecordSet resultSet = (IRecordSet) consolidatedResult.get("output");
            if (resultSet != null && resultSet.getRecordCount() > 0) {
                responseData.put("aplyYmd", requestData.getString("valuaBaseYmd"));
                responseData.put("fnafAbOrglDstcd", "1"); // 재무분석자료원구분코드
                responseData.put("totalAsst", resultSet.getRecord(0).getString("totalAsst"));
                responseData.put("oncp", resultSet.getRecord(0).getString("oncp"));
                responseData.put("ambr", resultSet.getRecord(0).getString("ambr"));
                responseData.put("cshAsst", resultSet.getRecord(0).getString("cshAsst"));
                responseData.put("salepr", resultSet.getRecord(0).getString("salepr"));
                responseData.put("oprft", resultSet.getRecord(0).getString("oprft"));
                responseData.put("fncs", resultSet.getRecord(0).getString("fncs"));
                responseData.put("netPrft", resultSet.getRecord(0).getString("netPrft"));
                responseData.put("bzoproNcf", resultSet.getRecord(0).getString("bzoproNcf"));
                responseData.put("ebitda", resultSet.getRecord(0).getString("ebitda"));
            }
            
            log.debug("합산연결재무제표처리 완료");
            
        } catch (BusinessException e) {
            log.error("합산연결재무제표처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("합산연결재무제표처리 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 재무비율 계산
     * @param consolidatedData 합산연결재무제표 데이터
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("재무비율계산")
    public IDataSet calculateFinancialRatios(IDataSet consolidatedData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("재무비율계산 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // F-049-003: 수학공식처리
            // BR-049-005: 수학공식처리
            
            // 부채비율 계산 (부채 / 자기자본 * 100)
            String totalAsst = consolidatedData.getString("totalAsst");
            String oncp = consolidatedData.getString("oncp");
            
            if (totalAsst != null && oncp != null && !oncp.equals("0")) {
                double totalAsstVal = Double.parseDouble(totalAsst);
                double oncpVal = Double.parseDouble(oncp);
                double liablVal = totalAsstVal - oncpVal; // 부채 = 총자산 - 자기자본
                
                double liablRato = (liablVal / oncpVal) * 100;
                responseData.put("liablRato", String.format("%.2f", liablRato));
            } else {
                responseData.put("liablRato", "0.00");
            }
            
            // 차입금의존도 계산 (차입금 / 총자산 * 100)
            String ambr = consolidatedData.getString("ambr");
            if (totalAsst != null && ambr != null && !totalAsst.equals("0")) {
                double totalAsstVal = Double.parseDouble(totalAsst);
                double ambrVal = Double.parseDouble(ambr);
                
                double ambrRlnc = (ambrVal / totalAsstVal) * 100;
                responseData.put("ambrRlnc", String.format("%.2f", ambrRlnc));
            } else {
                responseData.put("ambrRlnc", "0.00");
            }
            
            log.debug("재무비율계산 완료");
            
        } catch (BusinessException e) {
            log.error("재무비율계산 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("재무비율계산 시스템 오류", e);
            throw new BusinessException("B3000108", "UKII0291", "수학공식 및 계산 매개변수를 확인", e);
        }
        
        return responseData;
    }

    /**
     * 연도별 합산연결재무데이터 처리
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("연도별합산연결재무데이터처리")
    public IDataSet processYearlyConsolidatedFinancialData(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("연도별합산연결재무데이터처리 시작 - 대상년월일: " + requestData.getString("valuaBaseYmd"));
        
        try {
            // 합산연결재무제표 처리
            IDataSet consolidatedData = processConsolidatedFinancialStatements(requestData, onlineCtx);
            
            // 재무비율 계산
            IDataSet ratioData = calculateFinancialRatios(consolidatedData, onlineCtx);
            
            // 결과 통합
            IDataSet responseData = new DataSet();
            responseData.put("consolidatedData", consolidatedData);
            responseData.put("ratioData", ratioData);
            
            log.debug("연도별합산연결재무데이터처리 완료 - 대상년월일: " + requestData.getString("valuaBaseYmd"));
            return responseData;
            
        } catch (BusinessException e) {
            log.error("연도별합산연결재무데이터처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("연도별합산연결재무데이터처리 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
    }

    /**
     * 합산연결재무결과 컴파일
     * @param companyInfoResult 회사정보 결과
     * @param consolidatedFinDataResult 합산연결재무데이터 결과
     * @param multiYearFinDataResult 다년도재무데이터 결과
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("합산연결재무결과컴파일")
    public IDataSet compileConsolidatedFinancialResults(IDataSet companyInfoResult, IDataSet consolidatedFinDataResult, 
                                                       IDataSet multiYearFinDataResult, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("합산연결재무결과컴파일 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // BR-049-011: 재무데이터그리드처리
            // 건수정보 설정
            int totalCount = companyInfoResult.getInt("totalNoitm");
            int presentCount = companyInfoResult.getInt("prsntNoitm");
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            
            // 회사정보 설정
            IRecordSet companyOutput = (IRecordSet) companyInfoResult.get("output");
            if (companyOutput != null && companyOutput.getRecordCount() > 0) {
                responseData.put("exmtnCustIdnfr", companyOutput.getRecord(0).getString("exmtnCustIdnfr"));
                responseData.put("rpsntBzno", companyOutput.getRecord(0).getString("rpsntBzno"));
                responseData.put("rpsntEntpName", companyOutput.getRecord(0).getString("rpsntEntpName"));
                responseData.put("corpLPlicyCtnt", companyOutput.getRecord(0).getString("corpLPlicyCtnt"));
                responseData.put("corpCvGrdDstcd", companyOutput.getRecord(0).getString("corpCvGrdDstcd"));
                responseData.put("corpScalDstcd", companyOutput.getRecord(0).getString("corpScalDstcd"));
                responseData.put("stndIClsfiCd", companyOutput.getRecord(0).getString("stndIClsfiCd"));
                responseData.put("brnHanglName", companyOutput.getRecord(0).getString("brnHanglName"));
            }
            
            // 합산연결재무데이터 설정
            IDataSet consolidatedData = (IDataSet) consolidatedFinDataResult.get("consolidatedData");
            IDataSet ratioData = (IDataSet) consolidatedFinDataResult.get("ratioData");
            
            if (consolidatedData != null) {
                responseData.put("aplyYmd", consolidatedData.getString("aplyYmd"));
                responseData.put("fnafAbOrglDstcd", consolidatedData.getString("fnafAbOrglDstcd"));
                responseData.put("totalAsst", consolidatedData.getString("totalAsst"));
                responseData.put("oncp", consolidatedData.getString("oncp"));
                responseData.put("ambr", consolidatedData.getString("ambr"));
                responseData.put("cshAsst", consolidatedData.getString("cshAsst"));
                responseData.put("salepr", consolidatedData.getString("salepr"));
                responseData.put("oprft", consolidatedData.getString("oprft"));
                responseData.put("fncs", consolidatedData.getString("fncs"));
                responseData.put("netPrft", consolidatedData.getString("netPrft"));
                responseData.put("bzoproNcf", consolidatedData.getString("bzoproNcf"));
                responseData.put("ebitda", consolidatedData.getString("ebitda"));
            }
            
            if (ratioData != null) {
                responseData.put("liablRato", ratioData.getString("liablRato"));
                responseData.put("ambrRlnc", ratioData.getString("ambrRlnc"));
            }
            
            // 다년도 재무데이터 설정
            responseData.put("multiYearFinData", multiYearFinDataResult);
            
            log.debug("합산연결재무결과컴파일 완료");
            
        } catch (Exception e) {
            log.error("합산연결재무결과컴파일 시스템 오류", e);
            throw new BusinessException("B3002140", "UKII0674", "업무로직 문제는 시스템 관리자에게 문의", e);
        }
        
        return responseData;
    }

    /**
     * 회사정보 상세 검증
     * @param companyInfo 회사정보 DataSet
     */
    private void validateCompanyInfoDetail(IDataSet companyInfo) {
        if (companyInfo == null) {
            throw new BusinessException("B4200099", "UKII0803", "기업집단 회사정보가 존재하지 않습니다");
        }
        
        IRecordSet output = (IRecordSet) companyInfo.get("output");
        if (output == null || output.getRecordCount() == 0) {
            throw new BusinessException("B4200099", "UKII0803", "기업집단 회사정보가 존재하지 않습니다");
        }
    }

    /**
     * 합산연결재무데이터 검증
     * @param consolidatedData 합산연결재무제표 데이터
     * @param ratioData 재무비율 데이터
     */
    private void validateConsolidatedFinancialData(IDataSet consolidatedData, IDataSet ratioData) {
        // BR-049-006: 합산연결재무제표데이터검증
        if (consolidatedData == null) {
            throw new BusinessException("B4200099", "UKII0803", "합산연결재무제표 데이터가 유효하지 않습니다");
        }
        
        String totalAsst = consolidatedData.getString("totalAsst");
        String oncp = consolidatedData.getString("oncp");
        
        if (totalAsst == null || totalAsst.equals("0") || oncp == null || oncp.equals("0")) {
            throw new BusinessException("B4200099", "UKII0803", "합산연결재무제표 데이터가 유효하지 않습니다");
        }
    }

}
