package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.RecordSet;

import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단평가기본 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPB110 테이블 데이터 접근
 * ---------------------------------------------------------------------------------
 *  버전    일자            작성자            설명
 * ---------------------------------------------------------------------------------
 *   0.1    20250929    MultiQ4KBBank        최초 작성
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank
 * @since 2025-09-29
 */
@BizUnit(value = "기업집단평가기본 테이블DU", type = "DU")
public class DUTSKIPB110 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 기업집단평가기본 테이블 SELECT LIST.
     * <pre>
     * 기업집단신용등급목록조회
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : inquryBaseYm [조회기준년월] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string) - optional
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *    - recordSet : LIST [기업집단평가기본 테이블 LIST]
     *        - field : corpClctGroupCd [기업집단그룹코드] (string)
     *        - field : corpClctRegiCd [기업집단등록코드] (string)
     *        - field : corpClctName [기업집단명] (string)
     *        - field : writYr [작성년] (string)
     *        - field : valuaDefinsYmd [평가확정년월일] (string)
     *        - field : valuaBaseYmd [평가기준년월일] (string)
     *        - field : lastClctGrdDstcd [최종집단등급구분] (string)
     *        - field : valdYmd [유효년월일] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-09-29
     */
    @BizMethod("기업집단평가기본 테이블 SELECT LIST")
    public IDataSet selectList(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        
        try {
            // BR-016-005: 최대 1000건 제한
            IRecordSet recordset = dbSelect("selectList", requestData, onlineCtx);
            
            // 건수 제한 적용
            if (recordset != null && recordset.getRecordCount() > 1000) {
                // 1000건으로 제한
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
	        // TODO: 에러코드 B3900009, 조치메시지 UKII0182 확인 필요
            throw new BusinessException("B3900009", "UKII0182", "데이터를 검색할 수 없습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단평가이력 테이블 SELECT LIST.
     * <pre>
     * 기업집단신용평가이력목록조회
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctName [기업집단명] (string)
     *    - field : valuaYmd [평가년월일] (string) - optional
     *    - field : corpClctRegiCd [기업집단등록코드] (string) - optional
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *    - recordSet : LIST [기업집단평가이력 LIST]
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-09-29
     */
    @BizMethod("기업집단평가이력 테이블 SELECT LIST")
    public IDataSet selectListHist(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        
        try {
            // BR-030-003: 최대 1000건 제한
            IRecordSet recordset = dbSelect("selectListHist", requestData, onlineCtx);
            
            // 건수 제한 적용
            if (recordset != null && recordset.getRecordCount() > 1000) {
                // 1000건으로 제한
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
	        // TODO: 에러코드 B3900009, 조치메시지 UKII0182 확인 필요
            throw new BusinessException("B3900009", "UKII0182", "데이터를 검색할 수 없습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단평가기본 테이블 INSERT.
     * <pre>
     * 신규 기업집단평가 레코드 생성
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : valuaYmd [평가년월일] (string)
     *    - field : corpClctName [기업집단명] (string)
     *    - field : valuaBaseYmd [평가기준년월일] (string)
     *    - field : mainDebtAffltYn [주채무계열여부] (string)
     *    - field : corpCValuaDstcd [기업집단평가구분] (string)
     *    - field : corpCpStgeDstcd [기업집단처리단계구분] (string)
     *    - field : grdAdjsDstcd [등급조정구분] (string)
     *    - field : adjsStgeNoDstcd [조정단계번호구분] (string)
     *    - field : fnafScor [재무점수] (decimal)
     *    - field : nonFnafScor [비재무점수] (decimal)
     *    - field : chsnScor [결합점수] (decimal)
     *    - field : spareCGrdDstcd [예비집단등급구분] (string)
     *    - field : lastClctGrdDstcd [최종집단등급구분] (string)
     *    - field : valuaEmpid [평가직원번호] (string)
     *    - field : valuaEmnm [평가직원명] (string)
     *    - field : valuaBrncd [평가부점코드] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (삽입된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-09-29
     */
    @BizMethod("기업집단평가기본 테이블 INSERT")
    public int insert(IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            int insertCount = dbInsert("insert", requestData, onlineCtx);
            return insertCount;
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
	        // TODO: 에러코드 B3900009, 조치메시지 UKII0182 확인 필요
	        throw new BusinessException("B3900009", "UKII0182", "데이터를 생성할 수 없습니다.", e);
        }
    }

    /**
     * 기업집단평가기본 테이블 DELETE.
     * <pre>
     * 기업집단평가 레코드 삭제
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : valuaYmd [평가년월일] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (삭제된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-09-29
     */
    @BizMethod("기업집단평가기본 테이블 DELETE")
    public int delete(IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            int deleteCount = dbDelete("delete", requestData, onlineCtx);
            return deleteCount;
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
	        // TODO: 에러코드 B4200219, 조치메시지 UKII0182 확인 필요
	        throw new BusinessException("B4200219", "UKII0182", "데이터를 삭제할 수 없습니다.", e);
        }
    }

    /**
     * 기업집단평가기본 테이블 SELECT.
     * <pre>
     * 기업집단평가 레코드 조회
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : valuaYmd [평가년월일] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * 
     * @author MultiQ4KBBank
     * @since 2025-09-29
     */
    @BizMethod("기업집단평가기본 테이블 SELECT")
    public IDataSet select(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        
        try {
            IRecordSet recordset = dbSelect("select", requestData, onlineCtx);
            responseData.put("RECORD", recordset);
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
	        // TODO: 에러코드 B3900009, 조치메시지 UKII0182 확인 필요
            throw new BusinessException("B3900009", "UKII0182", "데이터를 검색할 수 없습니다.", e);
        }
        
        return responseData;
    }

    
    /**
     * 기업집단평가기본 테이블 UPDATE.
     * <pre>
     * 신규 기업집단평가 레코드 생성
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : valuaYmd [평가년월일] (string)
     *    - field : corpClctName [기업집단명] (string)
     *    - field : valuaBaseYmd [평가기준년월일] (string)
     *    - field : mainDebtAffltYn [주채무계열여부] (string)
     *    - field : corpCValuaDstcd [기업집단평가구분] (string)
     *    - field : corpCpStgeDstcd [기업집단처리단계구분] (string)
     *    - field : grdAdjsDstcd [등급조정구분] (string)
     *    - field : adjsStgeNoDstcd [조정단계번호구분] (string)
     *    - field : fnafScor [재무점수] (decimal)
     *    - field : nonFnafScor [비재무점수] (decimal)
     *    - field : chsnScor [결합점수] (decimal)
     *    - field : spareCGrdDstcd [예비집단등급구분] (string)
     *    - field : lastClctGrdDstcd [최종집단등급구분] (string)
     *    - field : valuaEmpid [평가직원번호] (string)
     *    - field : valuaEmnm [평가직원명] (string)
     *    - field : valuaBrncd [평가부점코드] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (삽입된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-09-29
     */
    @BizMethod("기업집단평가기본 테이블 UPDATE")
    public int update(IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            int updateCount = dbUpdate("update", requestData, onlineCtx);
            return updateCount;
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
	        // TODO: 에러코드 B3900009, 조치메시지 UKII0182 확인 필요
	        throw new BusinessException("B3900009", "UKII0182", "데이터를 생성할 수 없습니다.", e);
        }
    }
}
