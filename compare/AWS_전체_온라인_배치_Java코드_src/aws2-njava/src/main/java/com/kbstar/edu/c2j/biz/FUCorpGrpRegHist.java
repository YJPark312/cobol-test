package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단등록이력조회.
 * <pre>
 * 유닛 설명 : 기업집단 등록변경 이력 데이터를 조회하고 처리하는 기능 유닛
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
@BizUnit(value = "기업집단등록이력조회", type = "FU")
public class FUCorpGrpRegHist extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA112 duTSKIPA112;

    /**
     * 기업집단등록이력조회처리.
     * <pre>
     * 메소드 설명 : 기업집단 등록변경 이력 데이터를 조회하고 처리
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : exmtnCustIdnfr [심사고객식별자] (string)
     *	- field : dscnTranDstcd [중단거래구분] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- recordSet : LIST [이력 레코드 LIST]
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : regiYms [등록년월일시] (string)
     *		- field : regiMTranDstcd [등록수기거래구분코드] (string)
     *		- field : corpClctRegiCd [기업집단등록코드] (string)
     *		- field : corpClctGroupCd [기업집단그룹코드] (string)
     *		- field : regiBrncd [등록부점코드] (string)
     *		- field : regiBrnName [등록부점명] (string)
     *		- field : regiEmpid [등록직원번호] (string)
     *		- field : regiEmnm [등록직원명] (string)
     *	- field : totalCount [총건수] (bigDecimal)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단등록이력조회처리")
    public IDataSet retrieveHistory(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // 비즈니스 룰 BR-011-003: 기업집단 이력 조회
            // 비즈니스 룰 BR-011-004: 데이터 정렬 및 페이징
            // 기업집단 이력 조회 (BR-011-003, BR-011-004)
            IDataSet histReq = new DataSet();
            histReq.put("groupCoCd", "KB0");
            histReq.put("exmtnCustIdnfr", requestData.getString("exmtnCustIdnfr"));
            histReq.put("dscnTranDstcd", requestData.getString("dscnTranDstcd"));
            
            // 비즈니스 룰 BR-011-007: 연속 거래 처리
            // 연속 처리 로직 (BR-011-007)
            String dscnTranDstcd = requestData.getString("dscnTranDstcd");
            if ("1".equals(dscnTranDstcd) || "2".equals(dscnTranDstcd)) {
                histReq.put("nextKey1", "99999999999999");
            }
            
            // DU 계층을 통한 데이터베이스 조회 실행
            IDataSet histRes = duTSKIPA112.selectList(histReq, onlineCtx);
            
            // 조회 결과 처리
            // 응답 데이터 설정
            responseData.put("totalNoitm", histRes.getInt("totalNoitm"));
            responseData.put("prsntNoitm", histRes.getInt("prsntNoitm"));
            responseData.put("sysLastPrcssYms", histRes.getString("sysLastPrcssYms"));
            responseData.put("grid1", histRes.get("grid1"));
            
            log.debug("기업집단등록이력조회 완료 - 고객식별자: " + requestData.getString("exmtnCustIdnfr") + 
                     ", 조회건수: " + histRes.getInt("prsntNoitm"));

        } catch (BusinessException e) {
            // 비즈니스 예외는 그대로 전파
            throw e;
        } catch (Exception e) {
            // 시스템 오류 발생 시 표준 오류 메시지 반환
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }
}
