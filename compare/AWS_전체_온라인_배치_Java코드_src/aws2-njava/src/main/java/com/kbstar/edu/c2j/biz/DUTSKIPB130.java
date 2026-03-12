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
 * 기업집단주석 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPB130 테이블에 대한 기업집단 주석 정보 조회를 담당하는 데이터 유닛
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
@BizUnit(value = "기업집단주석", type = "DU")
public class DUTSKIPB130 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 기업집단주석조회.
     * <pre>
     * 메소드 설명 : TSKIPB130 테이블에서 기업집단 주석 정보를 조회
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
    @BizMethod("기업집단주석조회")
    public IDataSet select(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단주석조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            IRecordSet resultSet = dbSelect("select", requestData, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("output", resultSet);
            
            log.debug("기업집단주석조회 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("기업집단주석조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단주석조회 시스템 오류", e);
            throw new BusinessException("B3100001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단주석등록.
     * <pre>
     * 메소드 설명 : TSKIPB130 테이블에 기업집단 주석 정보를 등록
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
    @BizMethod("기업집단주석등록")
    public IDataSet insert(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단주석등록 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            int result = dbInsert("insert", requestData, onlineCtx);
            
            responseData.put("resultCode", "00");
            responseData.put("resultMessage", "등록이 완료되었습니다.");
            responseData.put("processedCount", result);
            
            log.debug("기업집단주석등록 완료 - 처리건수: " + result);

        } catch (BusinessException e) {
            log.error("기업집단주석등록 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단주석등록 시스템 오류", e);
            throw new BusinessException("B3100001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단주석삭제.
     * <pre>
     * 메소드 설명 : TSKIPB130 테이블의 기업집단 주석 정보를 삭제
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
    @BizMethod("기업집단주석삭제")
    public IDataSet delete(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단주석삭제 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            int result = dbDelete("delete", requestData, onlineCtx);
            
            responseData.put("resultCode", "00");
            responseData.put("resultMessage", "삭제가 완료되었습니다.");
            responseData.put("processedCount", result);
            
            log.debug("기업집단주석삭제 완료 - 처리건수: " + result);

        } catch (BusinessException e) {
            log.error("기업집단주석삭제 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단주석삭제 시스템 오류", e);
            throw new BusinessException("B3100001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단주석 테이블 DELETE.
     * <pre>
     * 기업집단주석 레코드 삭제
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
     * @since 2025-10-02
     */
    @BizMethod("기업집단주석 테이블 DELETE")
    public int deleteCorpGrpComment(IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            int deleteCount = dbDelete("deleteCorpGrpComment", requestData, onlineCtx);
            return deleteCount;
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            // TODO: 에러코드 B4200219, 조치메시지 UKII0182 확인 필요
            throw new BusinessException("B4200219", "UKII0182", "데이터를 삭제할 수 없습니다.", e);
        }
    }
}
