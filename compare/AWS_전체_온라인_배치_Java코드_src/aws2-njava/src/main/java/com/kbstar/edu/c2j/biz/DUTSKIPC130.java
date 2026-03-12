package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;

import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단결합연결재무제표정보 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPC130 테이블 데이터 접근
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
@BizUnit(value = "기업집단결합연결재무제표정보 테이블DU", type = "DU")
public class DUTSKIPC130 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 기업집단결합연결재무제표정보 테이블 SELECT.
     * <pre>
     * 기업집단결합연결재무제표정보 조회
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : fnafStmtYr [재무제표년도] (string)
     *    - field : fnafStmtDstcd [재무제표구분코드] (string) - optional
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *    - recordSet : LIST [기업집단결합연결재무제표정보 LIST]
     *        - field : groupCoCd [그룹회사코드] (string)
     *        - field : corpClctGroupCd [기업집단그룹코드] (string)
     *        - field : corpClctRegiCd [기업집단등록코드] (string)
     *        - field : fnafStmtYr [재무제표년도] (string)
     *        - field : fnafStmtDstcd [재무제표구분코드] (string)
     *        - field : chsnFnafStmtAmt [결합재무제표금액] (decimal)
     *        - field : cnctFnafStmtAmt [연결재무제표금액] (decimal)
     *        - field : fnafStmtItmCd [재무제표항목코드] (string)
     *        - field : fnafStmtItmNm [재무제표항목명] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단결합연결재무제표정보 테이블 SELECT")
    public IDataSet select(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        
        try {
            IRecordSet recordset = dbSelect("select", requestData, onlineCtx);
            responseData.put("LIST", recordset);
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
	        // TODO: 에러코드 B3900009, 조치메시지 UKII0182 확인 필요
            throw new BusinessException("B3900009", "UKII0182", "데이터를 검색할 수 없습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단결합연결재무제표정보 테이블 INSERT.
     * <pre>
     * 신규 기업집단결합연결재무제표정보 레코드 생성
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : fnafStmtYr [재무제표년도] (string)
     *    - field : fnafStmtDstcd [재무제표구분코드] (string)
     *    - field : chsnFnafStmtAmt [결합재무제표금액] (decimal)
     *    - field : cnctFnafStmtAmt [연결재무제표금액] (decimal)
     *    - field : fnafStmtItmCd [재무제표항목코드] (string)
     *    - field : fnafStmtItmNm [재무제표항목명] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (삽입된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단결합연결재무제표정보 테이블 INSERT")
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
     * 기업집단결합연결재무제표정보 테이블 UPDATE.
     * <pre>
     * 기업집단결합연결재무제표정보 레코드 수정
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : fnafStmtYr [재무제표년도] (string)
     *    - field : fnafStmtDstcd [재무제표구분코드] (string)
     *    - field : chsnFnafStmtAmt [결합재무제표금액] (decimal)
     *    - field : cnctFnafStmtAmt [연결재무제표금액] (decimal)
     *    - field : fnafStmtItmCd [재무제표항목코드] (string)
     *    - field : fnafStmtItmNm [재무제표항목명] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (수정된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단결합연결재무제표정보 테이블 UPDATE")
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
