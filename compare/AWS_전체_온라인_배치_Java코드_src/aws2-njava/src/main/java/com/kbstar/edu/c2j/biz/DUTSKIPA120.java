package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 월별기업집단기본정보 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPA120 테이블에 대한 데이터 접근을 담당하는 데이터 유닛
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
@BizUnit(value = "월별기업집단기본정보", type = "DU")
public class DUTSKIPA120 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 월별기업집단관계사현황조회.
     * <pre>
     * 메소드 설명 : TSKIPA120 테이블에서 월별 기업집단 관계사 현황을 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
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
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("월별기업집단관계사현황조회")
    public IDataSet selectHistoricalCompanyList(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // 입력 데이터 검증
            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            String baseYm = requestData.getString("baseYm");
            
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드는 필수입니다.");
            }
            
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드는 필수입니다.");
            }
            
            if (baseYm == null || baseYm.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKIP0001", "기준년월은 필수입니다.");
            }

            // 조회 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctRegiCd", corpClctRegiCd);
            queryReq.put("corpClctGroupCd", corpClctGroupCd);
            queryReq.put("baseYm", baseYm);
            
            // 데이터베이스 조회 실행
            IRecordSet recordSet = dbSelect("selectHistoricalCorpGrpCompanyList", queryReq, onlineCtx);
            
            // 산업분류명 및 부점명 해결
            IRecordSet enrichedRecordSet = enrichCompanyData(recordSet, onlineCtx);
            
            responseData.put("companyList", enrichedRecordSet);
            responseData.put("totalCount", enrichedRecordSet.getRecordCount());
            
            log.debug("월별기업집단관계사현황조회 완료 - 조회건수: " + enrichedRecordSet.getRecordCount());

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B3900002", "UKII0126", "데이터 검색오류", e);
        }

        return responseData;
    }

    /**
     * 회사 데이터 보강 (산업분류명, 부점명 조회).
     * F-024-003: 회사분류해결 구현
     */
    private IRecordSet enrichCompanyData(IRecordSet recordSet, IOnlineContext onlineCtx) {
        IRecordSet enrichedRecordSet = new nexcore.framework.core.data.RecordSet();
        
        for (int i = 0; i < recordSet.getRecordCount(); i++) {
            IRecord record = recordSet.getRecord(i);
            
            // 산업분류명 조회
            String stndIClsfiCd = record.getString("stndIClsfiCd");
            if (stndIClsfiCd != null && !stndIClsfiCd.trim().isEmpty()) {
                String stndIClsfiName = getIndustryClassificationName(stndIClsfiCd, onlineCtx);
                record.set("stndIClsfiName", stndIClsfiName);
            }
            
            // 부점명 조회
            String custMgtBrncd = record.getString("custMgtBrncd");
            if (custMgtBrncd != null && !custMgtBrncd.trim().isEmpty()) {
                String brnName = getBranchName(custMgtBrncd, onlineCtx);
                record.set("brnName", brnName);
            }
            
            enrichedRecordSet.addRecord(record);
        }
        
        return enrichedRecordSet;
    }

    /**
     * 산업분류명 조회.
     * THKJIUI02 테이블 조회
     */
    private String getIndustryClassificationName(String stndIClsfiCd, IOnlineContext onlineCtx) {
        try {
            IDataSet queryReq = new DataSet();
            queryReq.put("stndIClsfiCd", stndIClsfiCd);
            queryReq.put("useYn", "Y");
            
            IRecordSet recordSet = dbSelect("selectIndustryClassificationName", queryReq, onlineCtx);
            
            if (recordSet.getRecordCount() > 0) {
                return recordSet.getRecord(0).getString("stndIClsfiName");
            }
        } catch (Exception e) {
            getLog(onlineCtx).warn("산업분류명 조회 실패: " + stndIClsfiCd, e);
        }
        
        return "";
    }

    /**
     * 부점명 조회.
     * THKJIBR01 테이블 조회
     */
    private String getBranchName(String custMgtBrncd, IOnlineContext onlineCtx) {
        try {
            IDataSet queryReq = new DataSet();
            queryReq.put("custMgtBrncd", custMgtBrncd);
            queryReq.put("useYn", "Y");
            
            IRecordSet recordSet = dbSelect("selectBranchName", queryReq, onlineCtx);
            
            if (recordSet.getRecordCount() > 0) {
                return recordSet.getRecord(0).getString("brnName");
            }
        } catch (Exception e) {
            getLog(onlineCtx).warn("부점명 조회 실패: " + custMgtBrncd, e);
        }
        
        return "";
    }

    /**
     * 기업집단월별기본정보조회.
     * <pre>
     * 메소드 설명 : TSKIPA120 테이블에서 특정 기업의 월별 기본정보를 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : exmtnCustIdnfr [심사고객식별자] (string)
     *	- field : baseYm [기준년월] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- record : companyInfo [기업 기본정보]
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : rpsntBzno [대표사업자등록번호] (string)
     *		- field : rpsntEntpName [대표업체명] (string)
     *		- field : totalLnbzAmt [총여신금액] (decimal)
     *		- field : lnbzBal [여신잔액] (decimal)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단월별기본정보조회")
    public IDataSet selectMonthlyCompanyInfo(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // 입력 데이터 검증
            String exmtnCustIdnfr = requestData.getString("exmtnCustIdnfr");
            String baseYm = requestData.getString("baseYm");
            
            if (exmtnCustIdnfr == null || exmtnCustIdnfr.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKII0282", "심사고객식별자는 필수입니다.");
            }
            
            if (baseYm == null || baseYm.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKIP0001", "기준년월은 필수입니다.");
            }

            // 조회 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("exmtnCustIdnfr", exmtnCustIdnfr);
            queryReq.put("baseYm", baseYm);
            
            // 데이터베이스 조회 실행
            IRecordSet recordSet = dbSelect("selectMonthlyCompanyInfo", queryReq, onlineCtx);
            
            if (recordSet.getRecordCount() > 0) {
                IRecord companyInfo = recordSet.getRecord(0);
                responseData.put("companyInfo", companyInfo);
            }
            
            log.debug("기업집단월별기본정보조회 완료 - 심사고객식별자: " + exmtnCustIdnfr);

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B3900002", "UKII0126", "데이터 검색오류", e);
        }

        return responseData;
    }
}
