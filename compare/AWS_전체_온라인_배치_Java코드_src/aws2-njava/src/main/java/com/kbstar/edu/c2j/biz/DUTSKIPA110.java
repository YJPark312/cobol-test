package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * TSKIPA110 테이블 DU 클래스.
 * <pre>
 * 유닛 설명 : TSKIPA110 테이블에 대한 CRUD 작업을 담당하는 데이터 유닛
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
@BizUnit(value = "TSKIPA110테이블", type = "DU")
public class DUTSKIPA110 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 기업집단기본정보조회.
     * <pre>
     * 메소드 설명 : TSKIPA110 테이블에서 기업집단 기본정보를 조회
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
    @BizMethod("기업집단기본정보조회")
    public IDataSet selectCorpGrpBasicInfo(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단기본정보조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IRecordSet resultSet = dbSelect("selectCorpGrpBasicInfo", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("output", resultSet);
            
            log.debug("기업집단기본정보조회 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("기업집단기본정보조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단기본정보조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단기본정보등록.
     * <pre>
     * 메소드 설명 : TSKIPA110 테이블에 기업집단 기본정보를 등록
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
    @BizMethod("기업집단기본정보등록")
    public IDataSet insertCorpGrpBasicInfo(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단기본정보등록 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            int result = dbInsert("insertCorpGrpBasicInfo", requestData, onlineCtx);
            
            responseData.put("resultCode", "00");
            responseData.put("resultMessage", "등록이 완료되었습니다.");
            responseData.put("processedCount", result);
            
            log.debug("기업집단기본정보등록 완료 - 처리건수: " + result);

        } catch (BusinessException e) {
            log.error("기업집단기본정보등록 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단기본정보등록 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단기본정보수정.
     * <pre>
     * 메소드 설명 : TSKIPA110 테이블의 기업집단 기본정보를 수정
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
    @BizMethod("기업집단기본정보수정")
    public IDataSet updateCorpGrpBasicInfo(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단기본정보수정 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            int result = dbUpdate("updateCorpGrpBasicInfo", requestData, onlineCtx);
            
            responseData.put("resultCode", "00");
            responseData.put("resultMessage", "수정이 완료되었습니다.");
            responseData.put("processedCount", result);
            
            log.debug("기업집단기본정보수정 완료 - 처리건수: " + result);

        } catch (BusinessException e) {
            log.error("기업집단기본정보수정 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단기본정보수정 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단합산연결재무제표조회.
     * <pre>
     * 메소드 설명 : TSKIPA110 테이블에서 기업집단 합산연결재무제표 정보를 조회
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
    @BizMethod("기업집단합산연결재무제표조회")
    public IDataSet selectCorpGrpConsolidatedFinStat(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단합산연결재무제표조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            queryReq.put("fnafAStlaccDstcd", requestData.getString("fnafAStlaccDstcd"));
            queryReq.put("prcssDstic", requestData.getString("prcssDstic"));
            queryReq.put("base", requestData.getString("base"));
            
            IRecordSet resultSet = dbSelect("selectCorpGrpConsolidatedFinStat", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("output", resultSet);
            
            log.debug("기업집단합산연결재무제표조회 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("기업집단합산연결재무제표조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단합산연결재무제표조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단재무비율계산.
     * <pre>
     * 메소드 설명 : TSKIPA110 테이블 데이터를 기반으로 재무비율을 계산
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
    @BizMethod("기업집단재무비율계산")
    public IDataSet calculateCorpGrpFinancialRatio(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단재무비율계산 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            queryReq.put("totalAsst", requestData.getString("totalAsst"));
            queryReq.put("oncp", requestData.getString("oncp"));
            queryReq.put("ambr", requestData.getString("ambr"));
            
            IRecordSet resultSet = dbSelect("calculateCorpGrpFinancialRatio", queryReq, onlineCtx);
            
            responseData.put("resultCode", "00");
            responseData.put("resultMessage", "재무비율 계산이 완료되었습니다.");
            responseData.put("output", resultSet);
            
            log.debug("기업집단재무비율계산 완료");

        } catch (BusinessException e) {
            log.error("기업집단재무비율계산 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단재무비율계산 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단다년도재무데이터조회.
     * <pre>
     * 메소드 설명 : TSKIPA110 테이블에서 기업집단 다년도 재무데이터를 조회
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
    @BizMethod("기업집단다년도재무데이터조회")
    public IDataSet selectCorpGrpMultiYearFinData(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단다년도재무데이터조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("baseYear", requestData.getString("baseYear"));
            queryReq.put("yearRange", requestData.getString("yearRange"));
            
            IRecordSet resultSet = dbSelect("selectCorpGrpMultiYearFinData", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("output", resultSet);
            
            log.debug("기업집단다년도재무데이터조회 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("기업집단다년도재무데이터조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단다년도재무데이터조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단계열사현황조회.
     * <pre>
     * 메소드 설명 : WP-050 전용 - 기업집단 계열사 현황 조회
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
    @BizMethod("기업집단계열사현황조회")
    public IDataSet selectCorpGrpAffiliateStatus(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단계열사현황조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("prcssDstcd", requestData.getString("prcssDstcd"));
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            queryReq.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IRecordSet resultSet = dbSelect("selectCorpGrpAffiliateStatus", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("output", resultSet);
            
            log.debug("기업집단계열사현황조회 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("기업집단계열사현황조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단계열사현황조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단계열사재무데이터조회.
     * <pre>
     * 메소드 설명 : WP-050 전용 - 기업집단 계열사 재무데이터 조회
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
    @BizMethod("기업집단계열사재무데이터조회")
    public IDataSet selectCorpGrpAffiliateFinData(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단계열사재무데이터조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            queryReq.put("exmtnCustIdnfr", requestData.getString("exmtnCustIdnfr"));
            queryReq.put("fnafAStlaccDstcd", "1"); // 결산구분코드
            queryReq.put("prcssDstic", "01"); // 처리구분
            
            IRecordSet resultSet = dbSelect("selectCorpGrpAffiliateFinData", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("output", resultSet);
            
            log.debug("기업집단계열사재무데이터조회 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("기업집단계열사재무데이터조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단계열사재무데이터조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단계열사위험평가조회.
     * <pre>
     * 메소드 설명 : WP-050 전용 - 기업집단 계열사 위험평가 조회
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
    @BizMethod("기업집단계열사위험평가조회")
    public IDataSet selectCorpGrpAffiliateRiskAssessment(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단계열사위험평가조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            queryReq.put("riskAsmtId", requestData.getString("riskAsmtId"));
            queryReq.put("riskMdlVer", requestData.getString("riskMdlVer"));
            
            IRecordSet resultSet = dbSelect("selectCorpGrpAffiliateRiskAssessment", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("output", resultSet);
            
            log.debug("기업집단계열사위험평가조회 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("기업집단계열사위험평가조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단계열사위험평가조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단계열사요약정보조회.
     * <pre>
     * 메소드 설명 : WP-051 전용 - 기업집단 계열사 요약정보 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (WP-051)
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단계열사요약정보조회")
    public IDataSet selectCorpGrpAffiliateSummary(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단계열사요약정보조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("prcssDstcd", requestData.getString("prcssDstcd"));
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            queryReq.put("valuaYmd", requestData.getString("valuaYmd"));
            queryReq.put("valuaDefinsYmd", requestData.getString("valuaDefinsYmd"));
            
            IRecordSet resultSet = dbSelect("selectCorpGrpAffiliateSummary", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("output", resultSet);
            
            log.debug("기업집단계열사요약정보조회 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("기업집단계열사요약정보조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단계열사요약정보조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단계열사평가데이터조회.
     * <pre>
     * 메소드 설명 : WP-051 전용 - 기업집단 계열사 평가데이터 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (WP-051)
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단계열사평가데이터조회")
    public IDataSet selectCorpGrpAffiliateEvalData(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단계열사평가데이터조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaYmd", requestData.getString("valuaYmd"));
            queryReq.put("exmtnCustIdnfr", requestData.getString("exmtnCustIdnfr"));
            
            IRecordSet resultSet = dbSelect("selectCorpGrpAffiliateEvalData", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("output", resultSet);
            
            log.debug("기업집단계열사평가데이터조회 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("기업집단계열사평가데이터조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단계열사평가데이터조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 승인결의록정보조회.
     * <pre>
     * 메소드 설명 : WP-053 전용 - 승인결의록 정보 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (WP-053)
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("승인결의록정보조회")
    public IDataSet selectApprovalResolutionInfo(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("승인결의록정보조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IRecordSet resultSet = dbSelect("selectApprovalResolutionInfo", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("output", resultSet);
            
            log.debug("승인결의록정보조회 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("승인결의록정보조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("승인결의록정보조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 승인결의록데이터등록.
     * <pre>
     * 메소드 설명 : WP-053 전용 - 승인결의록 데이터 등록
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (WP-053)
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("승인결의록데이터등록")
    public IDataSet insertApprovalResolutionData(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("승인결의록데이터등록 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            int result = dbInsert("insertApprovalResolutionData", requestData, onlineCtx);
            
            responseData.put("resultCode", "00");
            responseData.put("resultMessage", "승인결의록 데이터 등록이 완료되었습니다.");
            responseData.put("processedCount", result);
            
            log.debug("승인결의록데이터등록 완료 - 처리건수: " + result);

        } catch (BusinessException e) {
            log.error("승인결의록데이터등록 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("승인결의록데이터등록 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 승인결의록데이터삭제.
     * <pre>
     * 메소드 설명 : WP-053 전용 - 승인결의록 데이터 삭제 (반송 처리용)
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (WP-053)
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("승인결의록데이터삭제")
    public IDataSet deleteApprovalResolutionData(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("승인결의록데이터삭제 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            int result = dbDelete("deleteApprovalResolutionData", requestData, onlineCtx);
            
            responseData.put("resultCode", "00");
            responseData.put("resultMessage", "승인결의록 데이터 삭제가 완료되었습니다.");
            responseData.put("processedCount", result);
            
            log.debug("승인결의록데이터삭제 완료 - 처리건수: " + result);

        } catch (BusinessException e) {
            log.error("승인결의록데이터삭제 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("승인결의록데이터삭제 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 위원회위원수조회.
     * <pre>
     * 메소드 설명 : WP-053 전용 - 위원회 위원 수 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (WP-053)
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("위원회위원수조회")
    public IDataSet selectCommitteeMemberCount(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("위원회위원수조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IRecordSet resultSet = dbSelect("selectCommitteeMemberCount", queryReq, onlineCtx);
            
            int totalCount = 0;
            if (resultSet.getRecordCount() > 0) {
                totalCount = Integer.parseInt(resultSet.getRecord(0).getString("totalCount"));
            }
            
            responseData.put("totalCount", totalCount);
            responseData.put("resultCode", "00");
            responseData.put("resultMessage", "위원회 위원 수 조회가 완료되었습니다.");
            
            log.debug("위원회위원수조회 완료 - 위원수: " + totalCount);

        } catch (BusinessException e) {
            log.error("위원회위원수조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("위원회위원수조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

}
