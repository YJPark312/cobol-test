package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단평가등급조정사유목록 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPB118 테이블 데이터 접근
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
@BizUnit(value = "기업집단평가등급조정사유목록 테이블DU", type = "DU")
public class DUTSKIPB118 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 기업집단평가등급조정사유목록 테이블 SELECT.
     * <pre>
     * 기업집단평가등급조정사유목록 조회
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : valuaYmd [평가년월일] (string)
     *    - field : adjsStgeNoDstcd [조정단계번호구분] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *    - recordSet : LIST [기업집단평가등급조정사유목록 LIST]
     *        - field : groupCoCd [그룹회사코드] (string)
     *        - field : corpClctGroupCd [기업집단그룹코드] (string)
     *        - field : corpClctRegiCd [기업집단등록코드] (string)
     *        - field : valuaYmd [평가년월일] (string)
     *        - field : adjsStgeNoDstcd [조정단계번호구분] (string)
     *        - field : adjsRsnSeq [조정사유순번] (decimal)
     *        - field : adjsRsnCd [조정사유코드] (string)
     *        - field : adjsRsnCntn [조정사유내용] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-09-29
     */
    @BizMethod("기업집단평가등급조정사유목록 테이블 SELECT")
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
     * 기업집단평가등급조정사유목록 테이블 DELETE.
     * <pre>
     * 기업집단평가등급조정사유목록 삭제
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     *    - field : valuaYmd [평가년월일] (string)
     *    - field : adjsStgeNoDstcd [조정단계번호구분] (string)
     *    - field : adjsRsnSeq [조정사유순번] (decimal)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 (삭제된 레코드 수)
     * 
     * @author MultiQ4KBBank
     * @since 2025-09-29
     */
    @BizMethod("기업집단평가등급조정사유목록 테이블 DELETE")
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
}
