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
 * 월별기업관계연결정보 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPA121 테이블에 대한 데이터 접근을 담당하는 데이터 유닛
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
@BizUnit(value = "월별기업관계연결정보", type = "DU")
public class DUTSKIPA121 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 월별기업관계연결정보조회.
     * <pre>
     * 메소드 설명 : TSKIPA121 테이블에서 월별 기업관계연결 정보를 조회
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
    @BizMethod("월별기업관계연결정보조회")
    public IDataSet selectRelationInfo(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("월별기업관계연결정보조회 시작");
            
            // 입력 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("baseYm", requestData.getString("baseYm"));
            
            IRecordSet resultSet = dbSelect("selectRelationInfo", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("relationList", resultSet);
            
            log.debug("월별기업관계연결정보조회 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("월별기업관계연결정보조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("월별기업관계연결정보조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }
}
