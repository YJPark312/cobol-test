package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단항목별평가 DU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단항목별평가(TSKIPB114) 테이블에 대한 데이터 접근 단위
 * 테이블 정보:
 * - 테이블명: TSKIPB114 (기업집단항목별평가목록)
 * - 설명: 기업집단평가시스템의 기업집단별 기업집단항목별평가에 대한 목록
 * - 스키마: DB2DBA
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
@BizUnit(value = "기업집단항목별평가", type = "DU")
public class DUTSKIPB114 extends com.kbstar.sqc.base.DataUnit {

    public DUTSKIPB114() {
        super();
    }

    /**
     * 기업집단항목별평가 단건 조회.
     * <pre>
     * 메소드 설명 : 기업집단 식별정보로 항목별평가정보를 조회
     * 조회 조건:
     * - 그룹회사코드
     * - 기업집단그룹코드
     * - 기업집단등록코드
     * - 평가년월일
     * - 기업집단항목평가구분코드
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 조회 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단항목별평가 조회")
    public IDataSet select(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단항목별평가 조회 시작");

            IRecord record = dbSelectSingle("select", requestData, onlineCtx);
            if (record != null) {
                responseData.putAll(record);
                
                IRecordSet recordSet = new nexcore.framework.core.data.RecordSet();
                recordSet.addRecord(record);
                responseData.put("LIST", recordSet);
                
                log.debug("기업집단항목별평가 조회 성공");
            } else {
                IRecordSet emptyRecordSet = new nexcore.framework.core.data.RecordSet();
                responseData.put("LIST", emptyRecordSet);
                
                log.debug("기업집단항목별평가 조회 결과 없음");
            }

        } catch (Exception e) {
            log.error("기업집단항목별평가 조회 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "데이터 조회 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단항목별평가 목록 조회.
     * <pre>
     * 메소드 설명 : 기업집단 조건으로 항목별평가정보 목록을 조회
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 조회 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단항목별평가 목록조회")
    public IDataSet selectList(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단항목별평가 목록조회 시작");

            IRecordSet recordSet = dbSelect("selectList", requestData, onlineCtx);
            responseData.put("LIST", recordSet);
            
            log.debug("기업집단항목별평가 목록조회 완료 - 조회건수: " + recordSet.getRecordCount());

        } catch (Exception e) {
            log.error("기업집단항목별평가 목록조회 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "데이터 조회 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단항목별평가 등록.
     * <pre>
     * 메소드 설명 : 새로운 기업집단항목별평가정보를 등록
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단항목별평가 등록")
    public IDataSet insert(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단항목별평가 등록 시작");

            int result = dbInsert("insert", requestData, onlineCtx);
            responseData.put("insertCount", result);
            
            log.debug("기업집단항목별평가 등록 완료 - 등록건수: " + result);

        } catch (Exception e) {
            log.error("기업집단항목별평가 등록 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "데이터 등록 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단항목별평가 수정.
     * <pre>
     * 메소드 설명 : 기존 기업집단항목별평가정보를 수정
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단항목별평가 수정")
    public IDataSet update(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단항목별평가 수정 시작");

            int result = dbUpdate("update", requestData, onlineCtx);
            responseData.put("updateCount", result);
            
            log.debug("기업집단항목별평가 수정 완료 - 수정건수: " + result);

        } catch (Exception e) {
            log.error("기업집단항목별평가 수정 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "데이터 수정 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단별 평가항목 삭제.
     * <pre>
     * 메소드 설명 : 기업집단 식별정보로 해당하는 모든 평가항목을 삭제
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단별평가항목삭제")
    public IDataSet deleteByCorpGrp(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단별평가항목삭제 시작");

            int result = dbDelete("deleteByCorpGrp", requestData, onlineCtx);
            responseData.put("deleteCount", result);
            
            log.debug("기업집단별평가항목삭제 완료 - 삭제건수: " + result);

        } catch (Exception e) {
            log.error("기업집단별평가항목삭제 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "데이터 삭제 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }
}
