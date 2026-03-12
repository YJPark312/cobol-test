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
 * TSKIPB113 테이블 DU 클래스.
 * <pre>
 * 유닛 설명 : 기업집단사업부분구조분석명세 테이블에 대한 데이터 접근 유닛
 * 테이블명 : TSKIPB113 (기업집단사업부분구조분석명세)
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
@BizUnit(value = "기업집단사업부분구조분석명세", type = "DU")
public class DUTSKIPB113 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 기업집단사업부문분석 조회.
     * <pre>
     * 메소드 설명 : 기업집단사업부문분석 데이터를 조회한다
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 조회결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단사업부문분석조회")
    public IDataSet selectCorpGrpBizSectAnal(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단사업부문분석조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            IRecordSet resultSet = dbSelect("DUTSKIPB113.selectCorpGrpBizSectAnal", requestData, onlineCtx);
            responseData.put("resultSet", resultSet);
            
            log.debug("기업집단사업부문분석조회 완료 - 조회건수: " + resultSet.getRecordCount());
            
        } catch (Exception e) {
            log.error("기업집단사업부문분석조회 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "기업집단사업부문분석조회 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단사업부문분석 삽입.
     * <pre>
     * 메소드 설명 : 기업집단사업부문분석 데이터를 삽입한다
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
    @BizMethod("기업집단사업부문분석삽입")
    public IDataSet insertCorpGrpBizSectAnal(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단사업부문분석삽입 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            int insertCount = dbInsert("DUTSKIPB113.insertCorpGrpBizSectAnal", requestData, onlineCtx);
            responseData.put("insertCount", insertCount);
            
            log.debug("기업집단사업부문분석삽입 완료 - 삽입건수: " + insertCount);
            
        } catch (Exception e) {
            log.error("기업집단사업부문분석삽입 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "기업집단사업부문분석삽입 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단사업부문분석 수정.
     * <pre>
     * 메소드 설명 : 기업집단사업부문분석 데이터를 수정한다
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
    @BizMethod("기업집단사업부문분석수정")
    public IDataSet updateCorpGrpBizSectAnal(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단사업부문분석수정 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            int updateCount = dbUpdate("DUTSKIPB113.updateCorpGrpBizSectAnal", requestData, onlineCtx);
            responseData.put("updateCount", updateCount);
            
            log.debug("기업집단사업부문분석수정 완료 - 수정건수: " + updateCount);
            
        } catch (Exception e) {
            log.error("기업집단사업부문분석수정 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "기업집단사업부문분석수정 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단사업부문분석 삭제.
     * <pre>
     * 메소드 설명 : 기업집단사업부문분석 데이터를 삭제한다
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
    @BizMethod("기업집단사업부문분석삭제")
    public IDataSet deleteCorpGrpBizSectAnal(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단사업부문분석삭제 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            int deleteCount = dbDelete("DUTSKIPB113.deleteCorpGrpBizSectAnal", requestData, onlineCtx);
            responseData.put("deleteCount", deleteCount);
            
            log.debug("기업집단사업부문분석삭제 완료 - 삭제건수: " + deleteCount);
            
        } catch (Exception e) {
            log.error("기업집단사업부문분석삭제 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "기업집단사업부문분석삭제 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }
}
