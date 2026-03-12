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
 * TSKIPA130 테이블 DU 클래스.
 * <pre>
 * 유닛 설명 : TSKIPA130 테이블에 대한 CRUD 작업을 담당하는 데이터 유닛
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
@BizUnit(value = "TSKIPA130테이블", type = "DU")
public class DUTSKIPA130 extends com.kbstar.sqc.base.DataUnit {

    /**
     * TSKIPA130 조회.
     * <pre>
     * 메소드 설명 : TSKIPA130 테이블에서 데이터 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : custIdnfr [고객식별자] (string)
     *	- field : serno [일련번호] (numeric) - 선택사항
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- recordSet : LIST [조회결과 목록]
     * </pre>
     */
    @BizMethod("TSKIPA130조회")
    public IDataSet select(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        IDataSet responseData = new DataSet();

        try {
            log.debug("TSKIPA130 조회 시작");

            IRecordSet recordSet = dbSelect("selectTSKIPA130", requestData, onlineCtx);
            responseData.put("LIST", recordSet);

            log.debug("TSKIPA130 조회 완료");

        } catch (Exception e) {
            log.error("TSKIPA130 조회 중 오류 발생", e);
            throw new BusinessException("B4200223", "UKIH0072", "데이터베이스 조회 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * TSKIPA130 등록.
     * <pre>
     * 메소드 설명 : TSKIPA130 테이블에 데이터 등록
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : custIdnfr [고객식별자] (string)
     *	- field : serno [일련번호] (numeric)
     *	- field : dataCtnt [데이터내용] (string)
     *	- field : regiYmd [등록년월일] (string)
     *	- field : regiEmpid [등록직원ID] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("TSKIPA130등록")
    public IDataSet insert(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        IDataSet responseData = new DataSet();

        try {
            log.debug("TSKIPA130 등록 시작");

            int result = dbInsert("insertTSKIPA130", requestData, onlineCtx);
            responseData.put("insertCount", result);

            log.debug("TSKIPA130 등록 완료");

        } catch (Exception e) {
            log.error("TSKIPA130 등록 중 오류 발생", e);
            throw new BusinessException("B4200224", "UKIH0073", "데이터베이스 등록 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * TSKIPA130 수정.
     * <pre>
     * 메소드 설명 : TSKIPA130 테이블 데이터 수정
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : custIdnfr [고객식별자] (string)
     *	- field : serno [일련번호] (numeric)
     *	- field : dataCtnt [데이터내용] (string)
     *	- field : lastModfiYmd [최종수정년월일] (string)
     *	- field : lastModfiEmpid [최종수정직원ID] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("TSKIPA130수정")
    public IDataSet update(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        IDataSet responseData = new DataSet();

        try {
            log.debug("TSKIPA130 수정 시작");

            int result = dbUpdate("updateTSKIPA130", requestData, onlineCtx);
            responseData.put("updateCount", result);

            log.debug("TSKIPA130 수정 완료");

        } catch (Exception e) {
            log.error("TSKIPA130 수정 중 오류 발생", e);
            throw new BusinessException("B4200225", "UKIH0074", "데이터베이스 수정 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * TSKIPA130 삭제.
     * <pre>
     * 메소드 설명 : TSKIPA130 테이블 데이터 삭제
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : custIdnfr [고객식별자] (string)
     *	- field : serno [일련번호] (numeric)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    @BizMethod("TSKIPA130삭제")
    public IDataSet delete(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        IDataSet responseData = new DataSet();

        try {
            log.debug("TSKIPA130 삭제 시작");

            int result = dbDelete("deleteTSKIPA130", requestData, onlineCtx);
            responseData.put("deleteCount", result);

            log.debug("TSKIPA130 삭제 완료");

        } catch (Exception e) {
            log.error("TSKIPA130 삭제 중 오류 발생", e);
            throw new BusinessException("B4200226", "UKIH0075", "데이터베이스 삭제 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 기업재무대상관리정보조회.
     * <pre>
     * 메소드 설명 : TSKIPA130 테이블에서 기업재무대상관리 정보를 조회
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
    @BizMethod("기업재무대상관리정보조회")
    public IDataSet selectFinTargetInfo(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업재무대상관리정보조회 시작");
            
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("valuaYmd", requestData.getString("valuaYmd"));
            
            IRecordSet resultSet = dbSelect("selectFinTargetInfo", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("finTargetList", resultSet);
            
            log.debug("기업재무대상관리정보조회 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("기업재무대상관리정보조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업재무대상관리정보조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 재무데이터 조회.
     * <pre>
     * 메소드 설명 : TSKIPA130 테이블에서 재무분석 데이터를 조회
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
     *	- field : aplyYmd [적용년월일] (string)
     *	- field : fnstDstic [재무제표구분] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- recordSet : LIST [재무데이터 목록]
     * </pre>
     * @author MultiQ4KBBank, 2025-10-02
     * @since 2025-10-02
     */
    @BizMethod("재무데이터조회")
    public IDataSet selectFinancialData(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        IDataSet responseData = new DataSet();

        try {
            log.debug("재무데이터 조회 시작");

            // 입력 파라미터 검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            String aplyYmd = requestData.getString("aplyYmd");
            String fnstDstic = requestData.getString("fnstDstic");

            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드가 입력되지 않았습니다.");
            }

            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKIP0002", "기업집단등록코드가 입력되지 않았습니다.");
            }

            if (aplyYmd == null || aplyYmd.trim().isEmpty()) {
                throw new BusinessException("B2700019", "UKIP0003", "적용년월일이 입력되지 않았습니다.");
            }

            // 쿼리 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", corpClctGroupCd);
            queryReq.put("corpClctRegiCd", corpClctRegiCd);
            queryReq.put("aplyYmd", aplyYmd);
            queryReq.put("fnstDstic", fnstDstic != null ? fnstDstic : "개별");

            IRecordSet resultSet = dbSelect("selectFinancialData", queryReq, onlineCtx);
            responseData.put("LIST", resultSet);

            log.debug("재무데이터 조회 완료 - 조회건수: " + resultSet.getRecordCount());

        } catch (BusinessException be) {
            log.error("재무데이터 조회 중 업무 오류: " + be.getMessage());
            throw be;
        } catch (Exception e) {
            log.error("재무데이터 조회 중 시스템 오류", e);
            throw new BusinessException("B4200001", "UKIP0006", "재무데이터 조회 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }
    
    /**
     * 기업집단 재무분석 데이터 조회 (WP-055).
     * <pre>
     * 메소드 설명 : 기업집단신용평가보고서개요를 위한 재무분석 데이터 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251002	MultiQ4KBBank		최초 작성 (WP-055)
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string)
     *	- field : valuaBaseYmd [평가기준년월일] (string) - 선택사항
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- recordSet : LIST [재무분석데이터 목록]
     * </pre>
     * @author MultiQ4KBBank, 2025-10-02
     */
    @BizMethod("기업집단재무분석데이터조회")
    public IDataSet selectCorpGrpFinAnalData(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        IDataSet responseData = new DataSet();

        try {
            log.debug("기업집단 재무분석 데이터 조회 시작 (WP-055)");

            // 입력 파라미터 검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            String valuaYmd = requestData.getString("valuaYmd");

            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드가 입력되지 않았습니다.");
            }

            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKIP0002", "기업집단등록코드가 입력되지 않았습니다.");
            }

            if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
                throw new BusinessException("B2700019", "UKIP0003", "평가년월일이 입력되지 않았습니다.");
            }

            // 쿼리 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", corpClctGroupCd);
            queryReq.put("corpClctRegiCd", corpClctRegiCd);
            queryReq.put("valuaYmd", valuaYmd);
            queryReq.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));

            IRecordSet resultSet = dbSelect("selectCorpGrpFinAnalData", queryReq, onlineCtx);
            responseData.put("LIST", resultSet);

            log.debug("기업집단 재무분석 데이터 조회 완료 - 조회건수: " + resultSet.getRecordCount());

        } catch (BusinessException be) {
            log.error("기업집단 재무분석 데이터 조회 중 업무 오류: " + be.getMessage());
            throw be;
        } catch (Exception e) {
            log.error("기업집단 재무분석 데이터 조회 중 시스템 오류", e);
            throw new BusinessException("B4200001", "UKIP0006", "기업집단 재무분석 데이터 조회 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }
}
