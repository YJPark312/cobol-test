package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.RecordSet;

import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단최상위지배기업 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPC110 테이블 데이터 접근
 * ---------------------------------------------------------------------------------
 *  버전    일자            작성자            설명
 * ---------------------------------------------------------------------------------
 *   0.1    20251002    MultiQ4KBBank        최초 작성
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank
 * @since 2025-10-02
 */
@BizUnit(value = "기업집단최상위지배기업 테이블DU", type = "DU")
public class DUTSKIPC110 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 최상위지배기업 조회.
     * <pre>
     * 기업집단의 최상위지배기업 목록 조회
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string) - optional
     *    - field : custIdnfr [고객식별자] (string) - optional
     *    - field : valuaBaseYmd [평가기준년월일] (string) - optional
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *    - recordSet : LIST [최상위지배기업 목록]
     *        - field : groupCoCd [그룹회사코드] (string)
     *        - field : corpClctGroupCd [기업집단그룹코드] (string)
     *        - field : corpClctRegiCd [기업집단등록코드] (string)
     *        - field : exmtnCustIdnfr [심사고객식별자] (string)
     *        - field : rpsntEntpName [대표업체명] (string)
     *        - field : mamaCCustIdnfr [모기업고객식별자] (string)
     *        - field : mamaCorpName [모기업명] (string)
     *        - field : mostHSwayCorpYn [최상위지배기업여부] (string)
     *        - field : cnslFnstExstYn [연결재무제표존재여부] (string)
     *        - field : idiviFnstExstYn [개별재무제표존재여부] (string)
     *        - field : fnstReflctYn [재무제표반영여부] (string)
     *        - field : stlaccYm [결산년월] (string)
     *        - field : parentCustIdnfr [모기업고객식별자] (string)
     *        - field : parentCorpName [모기업명] (string)
     *        - field : topControllingYn [최상위지배여부] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("최상위지배기업 조회")
    public IDataSet selectTopControllingEntity(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        
        try {
            IRecordSet recordset = dbSelect("selectTopControllingEntity", requestData, onlineCtx);
            
            // 건수 제한 적용 (최대 1000건)
            if (recordset != null && recordset.getRecordCount() > 1000) {
                IRecordSet limitedRecordset = new RecordSet();
                for (int i = 0; i < 1000; i++) {
                    limitedRecordset.addRecord(recordset.getRecord(i));
                }
                responseData.put("LIST", limitedRecordset);
            } else {
                responseData.put("LIST", recordset);
            }
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B3900009", "UKII0182", "데이터를 검색할 수 없습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단 합산연결대상 조회.
     * <pre>
     * 기업집단의 합산연결대상 목록 조회
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : baseYear [기준년도] (string) - optional
     *    - field : stlaccYear [결산년도] (string) - optional
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *    - recordSet : LIST [합산연결대상 목록]
     *        - field : groupCoCd [그룹회사코드] (string)
     *        - field : corpClctGroupCd [기업집단그룹코드] (string)
     *        - field : corpClctRegiCd [기업집단등록코드] (string)
     *        - field : custIdnfr [고객식별자] (string)
     *        - field : entpName [업체명] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단 합산연결대상 조회")
    public IDataSet selectCorpGrpConsolidationTarget(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        
        try {
            IRecordSet recordset = dbSelect("selectCorpGrpConsolidationTarget", requestData, onlineCtx);
            
            // 건수 제한 적용 (최대 1000건)
            if (recordset != null && recordset.getRecordCount() > 1000) {
                IRecordSet limitedRecordset = new RecordSet();
                for (int i = 0; i < 1000; i++) {
                    limitedRecordset.addRecord(recordset.getRecord(i));
                }
                responseData.put("LIST", limitedRecordset);
            } else {
                responseData.put("LIST", recordset);
            }
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B3900009", "UKII0182", "데이터를 검색할 수 없습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 최상위지배기업 등록.
     * <pre>
     * 새로운 최상위지배기업 레코드 등록
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : custIdnfr [고객식별자] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (삽입된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("최상위지배기업 등록")
    public int insertTopControllingEntity(IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            int insertCount = dbInsert("insertTopControllingEntity", requestData, onlineCtx);
            return insertCount;
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B3900009", "UKII0182", "데이터를 생성할 수 없습니다.", e);
        }
    }

    /**
     * 최상위지배기업 수정.
     * <pre>
     * 기존 최상위지배기업 레코드 수정
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : custIdnfr [고객식별자] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (수정된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("최상위지배기업 수정")
    public int updateTopControllingEntity(IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            int updateCount = dbUpdate("updateTopControllingEntity", requestData, onlineCtx);
            return updateCount;
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B3900009", "UKII0182", "데이터를 수정할 수 없습니다.", e);
        }
    }

    /**
     * 최상위지배기업 삭제.
     * <pre>
     * 기존 최상위지배기업 레코드 삭제
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : custIdnfr [고객식별자] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (삭제된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("최상위지배기업 삭제")
    public int deleteTopControllingEntity(IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            int deleteCount = dbDelete("deleteTopControllingEntity", requestData, onlineCtx);
            return deleteCount;
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B4200219", "UKII0182", "데이터를 삭제할 수 없습니다.", e);
        }
    }
}
