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
 * 기업관계연결정보 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPA111 테이블에 대한 기업집단 정보 조회를 담당하는 데이터 유닛
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
@BizUnit(value = "기업관계연결정보", type = "DU")
public class DUTSKIPA111 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 기업집단코드정확검색.
     * <pre>
     * 메소드 설명 : TSKIPA111 테이블에서 기업집단코드를 이용한 정확한 검색
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : totalNoitm [총건수] (bigDecimal)
     *	- field : prsntNoitm [현재건수] (bigDecimal)
     *	- recordSet : grid1 [데이터베이스 레코드 LIST]
     *		- field : corpClctRegiCd [기업집단등록코드] (string)
     *		- field : corpClctGroupCd [기업집단그룹코드] (string)
     *		- field : corpClctName [기업집단명] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단코드정확검색")
    public IDataSet selectByCode(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            IDataSet queryReq = new DataSet();
            String groupCoCd = requestData.getString("groupCoCd");
            if (groupCoCd == null) groupCoCd = "001";
            queryReq.put("groupCoCd", groupCoCd);
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            
            IRecordSet resultSet = dbSelect("selectByCode", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("grid1", resultSet);
            
            log.debug("기업집단코드정확검색 완료 - 그룹코드: " + requestData.getString("corpClctGroupCd") + 
                     ", 조회건수: " + totalCount);

        } catch (Exception e) {
            log.error("기업집단코드정확검색 오류", e);
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단명패턴검색.
     * <pre>
     * 메소드 설명 : TSKIPA111 테이블에서 기업집단명을 이용한 패턴 검색
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : corpClctName [기업집단명] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : totalNoitm [총건수] (bigDecimal)
     *	- field : prsntNoitm [현재건수] (bigDecimal)
     *	- recordSet : grid1 [데이터베이스 레코드 LIST]
     *		- field : corpClctRegiCd [기업집단등록코드] (string)
     *		- field : corpClctGroupCd [기업집단그룹코드] (string)
     *		- field : corpClctName [기업집단명] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단명패턴검색")
    public IDataSet selectByName(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            IDataSet queryReq = new DataSet();
            String groupCoCd = requestData.getString("groupCoCd");
            if (groupCoCd == null) groupCoCd = "001";
            queryReq.put("groupCoCd", groupCoCd);
            queryReq.put("corpClctName", requestData.getString("corpClctName"));
            
            IRecordSet resultSet = dbSelect("selectByName", queryReq, onlineCtx);
            
            int totalCount = resultSet.getRecordCount();
            int presentCount = Math.min(totalCount, 1000);
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("grid1", resultSet);
            
            log.debug("기업집단명패턴검색 완료 - 기업집단명: " + requestData.getString("corpClctName") + 
                     ", 조회건수: " + totalCount);

        } catch (Exception e) {
            log.error("기업집단명패턴검색 오류", e);
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단정보등록.
     * <pre>
     * 메소드 설명 : TSKIPA111 테이블에 기업집단 정보를 등록
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251002	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : corpClctName [기업집단명] (string)
     *	- field : mainDaGroupYn [주채무계열그룹여부] (string)
     *	- field : corpGmGroupDstcd [기업군관리그룹구분코드] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : resultCd [결과코드] (string)
     *	- field : resultMsg [결과메시지] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단정보등록")
    public IDataSet insert(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            IDataSet queryReq = new DataSet();
            String groupCoCd = requestData.getString("groupCoCd");
            if (groupCoCd == null) groupCoCd = "001";
            
            queryReq.put("groupCoCd", groupCoCd);
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryReq.put("corpClctName", requestData.getString("corpClctName"));
            queryReq.put("mainDaGroupYn", requestData.getString("mainDaGroupYn"));
            queryReq.put("corpGmGroupDstcd", requestData.getString("corpGmGroupDstcd"));
            
            int insertCount = dbInsert("insert", queryReq, onlineCtx);
            
            responseData.put("resultCd", "00");
            responseData.put("resultMsg", "기업집단정보 등록 완료");
            
            log.debug("기업집단정보등록 완료 - 그룹코드: " + requestData.getString("corpClctGroupCd") + 
                     ", 등록건수: " + insertCount);

        } catch (Exception e) {
            log.error("기업집단정보등록 오류", e);
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단정보조회
     * <pre>
     * 메소드 설명 : 기업집단 정보를 조회하는 기능
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251002	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단정보조회")
    public IDataSet select(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        try {
            log.debug("기업집단정보조회 시작");
            
            // 기본 조회 로직 - selectByCode 메소드 활용
            IDataSet result = selectByCode(requestData, onlineCtx);
            
            // 결과 데이터 복사
            responseData.put("output", result.getRecordSet("output"));
            responseData.put("returnCd", "00");
            responseData.put("returnMsg", "조회가 완료되었습니다.");
            
            log.debug("기업집단정보조회 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단정보조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단정보조회 시스템 오류", e);
            throw new BusinessException("B4200998", "UKFH0998", "조회 중 오류가 발생했습니다.", e);
        }
        
        return responseData;
    }
}
