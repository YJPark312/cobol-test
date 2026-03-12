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
 * 관계기업미등록기업정보 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPA113 테이블에 대한 관계기업 미등록기업 정보 조회를 담당하는 데이터 유닛
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
@BizUnit(value = "관계기업미등록기업정보", type = "DU")
public class DUTSKIPA113 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 관계기업미등록기업정보조회.
     * <pre>
     * 메소드 설명 : TSKIPA113 테이블에서 관계기업 미등록기업 정보를 조회
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
    @BizMethod("관계기업미등록기업정보조회")
    public IDataSet select(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("관계기업미등록기업정보조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            IRecordSet resultSet = dbSelect("select", requestData, onlineCtx);
            responseData.put("resultSet", resultSet);
            
            log.debug("관계기업미등록기업정보조회 완료 - 조회건수: " + resultSet.getRecordCount());
            
        } catch (Exception e) {
            log.error("관계기업미등록기업정보조회 오류", e);
            throw new BusinessException("B4500001", "UKII0182", "관계기업미등록기업정보조회 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 관계기업미등록기업정보목록조회.
     * <pre>
     * 메소드 설명 : TSKIPA113 테이블에서 관계기업 미등록기업 정보 목록을 조회

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
    @BizMethod("관계기업미등록기업정보목록조회")
    public IDataSet selectList(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("관계기업미등록기업정보목록조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {

            IRecordSet resultSet = dbSelect("selectList", requestData, onlineCtx);
            responseData.put("LIST", resultSet);
            
            log.debug("관계기업미등록기업정보목록조회 완료 - 조회건수: " + resultSet.getRecordCount());
            
        } catch (Exception e) {
            log.error("관계기업미등록기업정보목록조회 오류", e);
            throw new BusinessException("B4500002", "UKII0182", "관계기업미등록기업정보목록조회 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 관계기업미등록기업정보등록.
     * <pre>
     * 메소드 설명 : TSKIPA113 테이블에 관계기업 미등록기업 정보를 등록

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
    @BizMethod("관계기업미등록기업정보등록")
    public IDataSet insert(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("관계기업미등록기업정보등록 시작");
        
        IDataSet responseData = new DataSet();
        
        try {

            int resultCount = dbInsert("insert", requestData, onlineCtx);
            responseData.put("resultCount", resultCount);
            
            log.debug("관계기업미등록기업정보등록 완료 - 등록건수: " + resultCount);
            
        } catch (Exception e) {
            log.error("관계기업미등록기업정보등록 오류", e);
            throw new BusinessException("B4500003", "UKII0182", "관계기업미등록기업정보등록 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 관계기업미등록기업정보수정.
     * <pre>
     * 메소드 설명 : TSKIPA113 테이블의 관계기업 미등록기업 정보를 수정

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
    @BizMethod("관계기업미등록기업정보수정")
    public IDataSet update(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("관계기업미등록기업정보수정 시작");
        
        IDataSet responseData = new DataSet();
        
        try {

            int resultCount = dbUpdate("update", requestData, onlineCtx);
            responseData.put("resultCount", resultCount);
            
            log.debug("관계기업미등록기업정보수정 완료 - 수정건수: " + resultCount);
            
        } catch (Exception e) {
            log.error("관계기업미등록기업정보수정 오류", e);
            throw new BusinessException("B4500004", "UKII0182", "관계기업미등록기업정보수정 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 관계기업미등록기업정보삭제.
     * <pre>
     * 메소드 설명 : TSKIPA113 테이블에서 관계기업 미등록기업 정보를 삭제

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
    @BizMethod("관계기업미등록기업정보삭제")
    public IDataSet delete(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("관계기업미등록기업정보삭제 시작");
        
        IDataSet responseData = new DataSet();
        
        try {

            int resultCount = dbDelete("delete", requestData, onlineCtx);
            responseData.put("resultCount", resultCount);
            
            log.debug("관계기업미등록기업정보삭제 완료 - 삭제건수: " + resultCount);
            
        } catch (Exception e) {
            log.error("관계기업미등록기업정보삭제 오류", e);
            throw new BusinessException("B4500005", "UKII0182", "관계기업미등록기업정보삭제 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }
}
