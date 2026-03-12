package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 관계기업수기조정정보 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPA112 테이블에 대한 데이터 접근을 담당하는 데이터 유닛
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
@BizUnit(value = "관계기업수기조정정보", type = "DU")
public class DUTSKIPA112 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 기업집단등록이력조회.
     * <pre>
     * 메소드 설명 : TSKIPA112 테이블에서 기업집단 등록변경 이력을 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : exmtnCustIdnfr [심사고객식별자] (string)
     *	- field : nextKey1 [다음키1] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- recordSet : LIST [데이터베이스 레코드 LIST]
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : regiYms [등록년월일시] (string)
     *		- field : regiMTranDstcd [등록수기거래구분코드] (string)
     *		- field : corpClctRegiCd [기업집단등록코드] (string)
     *		- field : corpClctGroupCd [기업집단그룹코드] (string)
     *		- field : regiBrncd [등록부점코드] (string)
     *		- field : regiBrnName [등록부점명] (string)
     *		- field : regiEmpid [등록직원번호] (string)
     *		- field : regiEmnm [등록직원명] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단등록이력조회")
    public IDataSet selectList(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // 입력 데이터 검증 및 변환
            // 조회 파라미터 기본값 설정
            IDataSet queryReq = new DataSet();
            String groupCoCd = requestData.getString("groupCoCd");
            if (groupCoCd == null) groupCoCd = "KB0";
            queryReq.put("groupCoCd", groupCoCd);
            queryReq.put("exmtnCustIdnfr", requestData.getString("exmtnCustIdnfr"));
            
            String nextKey1 = requestData.getString("nextKey1");
            if (nextKey1 == null || nextKey1.trim().isEmpty()) {
                queryReq.put("nextKey1", "99999999999999");
            } else {
                queryReq.put("nextKey1", nextKey1);
            }
            
            // 페이징 처리를 위한 레코드 수 계산
            // 페이징 제한 설정
            int maxCntLimit = 100;
            queryReq.put("maxCntLimit", maxCntLimit);
            
            // 페이징을 포함한 데이터베이스 조회 실행
            IRecordSet recordSet = dbSelect("selectCorpGrpRegHstList", queryReq, 1, maxCntLimit + 1, onlineCtx);
            
            // 페이징을 위한 결과 집합 처리
            int actualCount = recordSet.getRecordCount();
            int presentCount = Math.min(actualCount, maxCntLimit);
            
            // 결과 그리드에 레코드 추가
            IRecordSet resultGrid = new nexcore.framework.core.data.RecordSet();
            for (int i = 0; i < presentCount; i++) {
                IRecord record = recordSet.getRecord(i);
                resultGrid.addRecord(record);
            }
            
            responseData.put("grid1", resultGrid);
            responseData.put("totalNoitm", presentCount);
            responseData.put("prsntNoitm", presentCount);
            
            // 최종 응답 데이터 설정
            String sysLastPrcssYms = new java.text.SimpleDateFormat("yyyyMMddHHmmss")
                                        .format(new java.util.Date());
            responseData.put("sysLastPrcssYms", sysLastPrcssYms);
            
            // 다음 페이지를 위한 연속 키 처리
            if (actualCount > maxCntLimit) {
                IRecord lastRecord = recordSet.getRecord(maxCntLimit - 1);
                String nextPrcssYms = lastRecord.getString("regiYms");
                log.debug("연속키 설정 필요 - 다음처리일시: " + nextPrcssYms);
            }
            
            log.debug("기업집단등록이력조회 완료 - 조회건수: " + presentCount);

        } catch (BusinessException e) {
            // 비즈니스 예외는 그대로 전파
            throw e;
        } catch (Exception e) {
            // 데이터베이스 오류 발생 시 전용 오류 메시지 반환
            throw new BusinessException("B4200229", "UKII0974", "데이터 검색오류", e);
        }

        return responseData;
    }

    /**
     * 기업집단수기조정내역조회.
     * <pre>
     * 메소드 설명 : TSKIPA112 테이블에서 기업집단 수기조정 내역을 조회
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
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : nextKey1 [다음키1] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- recordSet : grid1 [수기조정내역 LIST]
     *		- field : hwrtModfiDstcd [수기변경구분] (string)
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : rpsntBzno [대표사업자번호] (string)
     *		- field : rpsntEntpName [대표업체명] (string)
     *		- field : regiYms [등록일시] (string)
     *		- field : regiEmnm [등록직원명] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단수기조정내역조회")
    public IDataSet selectManualAdjustmentList(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // 조회 파라미터 설정
            IDataSet queryReq = new DataSet();
            String groupCoCd = requestData.getString("groupCoCd");
            if (groupCoCd == null) groupCoCd = "KB0";
            queryReq.put("groupCoCd", groupCoCd);
            queryReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            
            String nextKey1 = requestData.getString("nextKey1");
            if (nextKey1 == null || nextKey1.trim().isEmpty()) {
                queryReq.put("nextKey1", "99999999999999");
            } else {
                queryReq.put("nextKey1", nextKey1);
            }
            
            // 페이징 제한 설정 (BR-012-004)
            int maxCntLimit = 100;
            queryReq.put("maxCntLimit", maxCntLimit);
            
            // 데이터베이스 조회 실행 (BR-012-003, BR-012-005, BR-012-008)
            IRecordSet recordSet = dbSelect("selectCorpGrpManAdjList", queryReq, 1, maxCntLimit + 1, onlineCtx);
            
            // 페이징 처리
            int actualCount = recordSet.getRecordCount();
            int presentCount = Math.min(actualCount, maxCntLimit);
            
            IRecordSet resultGrid = new nexcore.framework.core.data.RecordSet();
            for (int i = 0; i < presentCount; i++) {
                IRecord record = recordSet.getRecord(i);
                resultGrid.addRecord(record);
            }
            
            responseData.put("grid1", resultGrid);
            responseData.put("totalNoitm", presentCount);
            responseData.put("prsntNoitm", presentCount);
            
            log.debug("기업집단수기조정내역조회 완료 - 조회건수: " + presentCount);

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B4200229", "UKII0974", "데이터 검색오류", e);
        }

        return responseData;
    }
}
