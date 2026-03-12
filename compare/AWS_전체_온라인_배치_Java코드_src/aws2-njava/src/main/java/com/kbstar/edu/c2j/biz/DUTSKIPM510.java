package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;

import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단재무평가재무비율목록 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPM510 테이블 데이터 접근
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
@BizUnit(value = "기업집단재무평가재무비율목록 테이블DU", type = "DU")
public class DUTSKIPM510 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 기업집단재무평가재무비율목록 테이블 SELECT.
     * <pre>
     * 기업집단재무평가재무비율목록 조회
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : fnafRatioCd [재무비율코드] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *    - recordSet : LIST [기업집단재무평가재무비율목록 LIST]
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단재무평가재무비율목록 테이블 SELECT")
    public IDataSet select(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        
        try {
            IRecordSet recordset = dbSelect("select", requestData, onlineCtx);
            responseData.put("LIST", recordset);
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B3900009", "UKII0182", "데이터를 검색할 수 없습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단재무평가재무비율목록 테이블 INSERT.
     * <pre>
     * 기업집단재무평가재무비율목록 등록
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : fnafRatioCd [재무비율코드] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (삽입된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단재무평가재무비율목록 테이블 INSERT")
    public int insert(IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            int insertCount = dbInsert("insert", requestData, onlineCtx);
            return insertCount;
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B3900009", "UKII0182", "데이터를 생성할 수 없습니다.", e);
        }
    }

    /**
     * 기업집단재무평가재무비율목록 테이블 UPDATE.
     * <pre>
     * 기업집단재무평가재무비율목록 수정
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : fnafRatioCd [재무비율코드] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (수정된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단재무평가재무비율목록 테이블 UPDATE")
    public int update(IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            int updateCount = dbUpdate("update", requestData, onlineCtx);
            return updateCount;
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B3900009", "UKII0182", "데이터를 수정할 수 없습니다.", e);
        }
    }

    /**
     * 기업집단재무평가재무비율목록 테이블 DELETE.
     * <pre>
     * 기업집단재무평가재무비율목록 삭제
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : fnafRatioCd [재무비율코드] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (삭제된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단재무평가재무비율목록 테이블 DELETE")
    public int delete(IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            int deleteCount = dbDelete("delete", requestData, onlineCtx);
            return deleteCount;
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B4200219", "UKII0182", "데이터를 삭제할 수 없습니다.", e);
        }
    }
}
