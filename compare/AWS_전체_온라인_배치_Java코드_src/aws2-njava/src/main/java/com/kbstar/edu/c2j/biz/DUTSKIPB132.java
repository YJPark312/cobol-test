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
 * 기업집단승인결의록위원명세 DU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단승인결의록위원명세(TSKIPB132) 테이블에 대한 데이터 접근 단위
 * 테이블 정보:
 * - 테이블명: TSKIPB132 (기업집단승인결의록위원명세)
 * - 설명: 기업집단평가시스템의 기업집단신용평가 승인결의록위원에 대한 정보를 관리
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
@BizUnit(value = "기업집단승인결의록위원명세", type = "DU")
public class DUTSKIPB132 extends com.kbstar.sqc.base.DataUnit {

    public DUTSKIPB132() {
        super();
    }

    /**
     * 기업집단승인결의록위원명세 단건 조회.
     * <pre>
     * 메소드 설명 : 기업집단 식별정보와 위원정보로 위원명세를 조회
     * 조회 조건:
     * - 그룹회사코드
     * - 기업집단그룹코드
     * - 기업집단등록코드
     * - 평가년월일
     * - 승인위원직원번호
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 조회 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단승인결의록위원명세 조회")
    public IDataSet select(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단승인결의록위원명세 조회 시작");

            // 단건 조회
            IRecord record = dbSelectSingle("select", requestData, onlineCtx);
            if (record != null) {
                responseData.putAll(record);
                log.debug("기업집단승인결의록위원명세 조회 성공 - 위원: " + record.getString("athorCmmbEmpid"));
            } else {
                log.debug("기업집단승인결의록위원명세 조회 결과 없음");
            }

        } catch (Exception e) {
            log.error("기업집단승인결의록위원명세 조회 오류: " + e.getMessage());
            throw new BusinessException("B3900001", "UKII0182", "위원명세 조회 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단승인결의록위원명세 목록 조회.
     * <pre>
     * 메소드 설명 : 기업집단 식별정보로 위원명세 목록을 조회
     * 조회 조건:
     * - 그룹회사코드
     * - 기업집단그룹코드
     * - 기업집단등록코드
     * - 평가년월일
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 조회 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단승인결의록위원명세 목록조회")
    public IDataSet selectList(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단승인결의록위원명세 목록조회 시작");

            // 목록 조회
            IRecordSet recordSet = dbSelect("selectList", requestData, onlineCtx);
            responseData.put("LIST", recordSet);
            
            if (recordSet != null) {
                log.debug("기업집단승인결의록위원명세 목록조회 성공 - 건수: " + recordSet.getRecordCount());
            } else {
                log.debug("기업집단승인결의록위원명세 목록조회 결과 없음");
            }

        } catch (Exception e) {
            log.error("기업집단승인결의록위원명세 목록조회 오류: " + e.getMessage());
            throw new BusinessException("B3900001", "UKII0182", "위원명세 목록조회 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단승인결의록위원명세 등록.
     * <pre>
     * 메소드 설명 : 새로운 위원명세 정보를 등록
     * 등록 데이터:
     * - 그룹회사코드
     * - 기업집단그룹코드
     * - 기업집단등록코드
     * - 평가년월일
     * - 승인위원직원번호
     * - 승인위원구분
     * - 승인구분
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단승인결의록위원명세 등록")
    public IDataSet insert(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단승인결의록위원명세 등록 시작");

            // 데이터 등록
            int insertCount = dbInsert("insert", requestData, onlineCtx);
            responseData.put("insertCount", insertCount);
            
            log.debug("기업집단승인결의록위원명세 등록 완료 - 건수: " + insertCount);

        } catch (Exception e) {
            log.error("기업집단승인결의록위원명세 등록 오류: " + e.getMessage());
            throw new BusinessException("B3900001", "UKII0182", "위원명세 등록 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단승인결의록위원명세 수정.
     * <pre>
     * 메소드 설명 : 기존 위원명세 정보를 수정
     * 수정 조건:
     * - 그룹회사코드
     * - 기업집단그룹코드
     * - 기업집단등록코드
     * - 평가년월일
     * - 승인위원직원번호
     * 수정 데이터:
     * - 승인위원구분
     * - 승인구분
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단승인결의록위원명세 수정")
    public IDataSet update(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단승인결의록위원명세 수정 시작");

            // 데이터 수정
            int updateCount = dbUpdate("update", requestData, onlineCtx);
            responseData.put("updateCount", updateCount);
            
            log.debug("기업집단승인결의록위원명세 수정 완료 - 건수: " + updateCount);

        } catch (Exception e) {
            log.error("기업집단승인결의록위원명세 수정 오류: " + e.getMessage());
            throw new BusinessException("B3900001", "UKII0182", "위원명세 수정 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단승인결의록위원명세 삭제.
     * <pre>
     * 메소드 설명 : 기존 위원명세 정보를 삭제
     * 삭제 조건:
     * - 그룹회사코드
     * - 기업집단그룹코드
     * - 기업집단등록코드
     * - 평가년월일
     * - 승인위원직원번호
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단승인결의록위원명세 삭제")
    public IDataSet delete(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단승인결의록위원명세 삭제 시작");

            // 데이터 삭제
            int deleteCount = dbDelete("delete", requestData, onlineCtx);
            responseData.put("deleteCount", deleteCount);
            
            log.debug("기업집단승인결의록위원명세 삭제 완료 - 건수: " + deleteCount);

        } catch (Exception e) {
            log.error("기업집단승인결의록위원명세 삭제 오류: " + e.getMessage());
            throw new BusinessException("B3900001", "UKII0182", "위원명세 삭제 중 오류가 발생했습니다.", e);
        }

        return responseData;
    }
}
