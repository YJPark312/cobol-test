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
 * 기업집단합산연결재무비율 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPC131 테이블 데이터 접근
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
@BizUnit(value = "기업집단합산연결재무비율 테이블DU", type = "DU")
public class DUTSKIPC131 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 기업집단합산연결재무비율 테이블 SELECT.
     * <pre>
     * 기업집단합산연결재무비율 레코드 조회
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : fnafStmtYmd [재무제표년월일] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단합산연결재무비율 테이블 SELECT")
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
     * 기업집단합산연결재무비율 테이블 SELECT LIST.
     * <pre>
     * 기업집단합산연결재무비율목록조회
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : fnafStmtYmd [재무제표년월일] (string) - optional
     *    - field : corpClctRegiCd [기업집단등록코드] (string) - optional
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *    - recordSet : LIST [기업집단합산연결재무비율 테이블 LIST]
     *        - field : corpClctGroupCd [기업집단그룹코드] (string)
     *        - field : corpClctRegiCd [기업집단등록코드] (string)
     *        - field : fnafStmtYmd [재무제표년월일] (string)
     *        - field : fnafRatioCd [재무비율코드] (string)
     *        - field : fnafRatioVal [재무비율값] (decimal)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단합산연결재무비율 테이블 SELECT LIST")
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
     * 기업집단합산연결재무비율 테이블 INSERT.
     * <pre>
     * 신규 기업집단합산연결재무비율 레코드 생성
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : fnafStmtYmd [재무제표년월일] (string)
     *    - field : fnafRatioCd [재무비율코드] (string)
     *    - field : fnafRatioVal [재무비율값] (decimal)
     *    - field : fnafRatioNm [재무비율명] (string)
     *    - field : fnafRatioDesc [재무비율설명] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (삽입된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단합산연결재무비율 테이블 INSERT")
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
     * 기업집단합산연결재무비율 테이블 UPDATE.
     * <pre>
     * 기업집단합산연결재무비율 레코드 수정
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : fnafStmtYmd [재무제표년월일] (string)
     *    - field : fnafRatioCd [재무비율코드] (string)
     *    - field : fnafRatioVal [재무비율값] (decimal)
     *    - field : fnafRatioNm [재무비율명] (string)
     *    - field : fnafRatioDesc [재무비율설명] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (수정된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단합산연결재무비율 테이블 UPDATE")
    public int update(IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            int updateCount = dbUpdate("update", requestData, onlineCtx);
            return updateCount;
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
	        // TODO: 에러코드 B3900009, 조치메시지 UKII0182 확인 필요
	        throw new BusinessException("B3900009", "UKII0182", "데이터를 수정할 수 없습니다.", e);
        }
    }
}
