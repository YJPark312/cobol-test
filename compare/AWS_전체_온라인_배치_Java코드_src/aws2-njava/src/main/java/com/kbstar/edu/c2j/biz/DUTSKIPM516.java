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
 * 비재무항목배점 DU 클래스.
 * <pre>
 * 클래스 설명 : 비재무항목배점(TSKIPM516) 테이블에 대한 데이터 접근 단위
 * 테이블 정보:
 * - 테이블명: TSKIPM516 (비재무항목배점명세)
 * - 설명: 기업집단평가시스템의 비재무항목별 배점 매트릭스 정보
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
@BizUnit(value = "비재무항목배점", type = "DU")
public class DUTSKIPM516 extends com.kbstar.sqc.base.DataUnit {

    public DUTSKIPM516() {
        super();
    }

    /**
     * 비재무항목배점 단건 조회.
     * <pre>
     * 메소드 설명 : 비재무항목번호로 배점정보를 조회
     * 조회 조건:
     * - 그룹회사코드
     * - 적용년월일
     * - 비재무항목번호
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 조회 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("비재무항목배점 조회")
    public IDataSet select(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("비재무항목배점 조회 시작");

            IRecord record = dbSelectSingle("select", requestData, onlineCtx);
            if (record != null) {
                responseData.putAll(record);
                
                IRecordSet recordSet = new nexcore.framework.core.data.RecordSet();
                recordSet.addRecord(record);
                responseData.put("LIST", recordSet);
                
                log.debug("비재무항목배점 조회 성공 - 항목번호: " + record.getString("nonFnafItemNo"));
            } else {
                IRecordSet emptyRecordSet = new nexcore.framework.core.data.RecordSet();
                responseData.put("LIST", emptyRecordSet);
                
                log.debug("비재무항목배점 조회 결과 없음");
            }

        } catch (Exception e) {
            log.error("비재무항목배점 조회 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "데이터 조회 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 비재무항목배점 목록 조회.
     * <pre>
     * 메소드 설명 : 조건으로 비재무항목배점정보 목록을 조회
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 조회 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("비재무항목배점 목록조회")
    public IDataSet selectList(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("비재무항목배점 목록조회 시작");

            IRecordSet recordSet = dbSelect("selectList", requestData, onlineCtx);
            responseData.put("LIST", recordSet);
            
            log.debug("비재무항목배점 목록조회 완료 - 조회건수: " + recordSet.getRecordCount());

        } catch (Exception e) {
            log.error("비재무항목배점 목록조회 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "데이터 조회 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 비재무항목배점 등록.
     * <pre>
     * 메소드 설명 : 새로운 비재무항목배점정보를 등록
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("비재무항목배점 등록")
    public IDataSet insert(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("비재무항목배점 등록 시작");

            int result = dbInsert("insert", requestData, onlineCtx);
            responseData.put("insertCount", result);
            
            log.debug("비재무항목배점 등록 완료 - 등록건수: " + result);

        } catch (Exception e) {
            log.error("비재무항목배점 등록 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "데이터 등록 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 비재무항목배점 수정.
     * <pre>
     * 메소드 설명 : 기존 비재무항목배점정보를 수정
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("비재무항목배점 수정")
    public IDataSet update(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("비재무항목배점 수정 시작");

            int result = dbUpdate("update", requestData, onlineCtx);
            responseData.put("updateCount", result);
            
            log.debug("비재무항목배점 수정 완료 - 수정건수: " + result);

        } catch (Exception e) {
            log.error("비재무항목배점 수정 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "데이터 수정 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }
}
