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
 * 기업집단수기조정내역조회.
 * <pre>
 * 유닛 설명 : 기업집단 수기조정 내역 데이터를 조회하고 처리하는 기능 유닛
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
@BizUnit(value = "기업집단수기조정내역조회", type = "FU")
public class FUCorpGrpManAdjHist extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA112 duTSKIPA112;

    /**
     * 기업집단수기조정내역조회처리.
     * <pre>
     * 메소드 설명 : 기업집단 수기조정 내역 데이터를 조회하고 처리
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
     *	- field : dscnTranDstcd [중단거래구분] (string)
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
     *	- field : totalNoitm [총건수] (numeric)
     *	- field : prsntNoitm [현재건수] (numeric)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단수기조정내역조회처리")
    public IDataSet retrieveManualAdjustmentHistory(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // 비즈니스 룰 BR-012-003: 수기조정 이력 조회
            // 비즈니스 룰 BR-012-004: 페이징 관리
            IDataSet histReq = new DataSet();
            histReq.put("groupCoCd", requestData.getString("groupCoCd"));
            histReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            histReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            
            // 비즈니스 룰 BR-012-007: 중단거래 처리
            String dscnTranDstcd = requestData.getString("dscnTranDstcd");
            if ("1".equals(dscnTranDstcd) || "2".equals(dscnTranDstcd)) {
                histReq.put("nextKey1", "99999999999999");
            } else {
                histReq.put("nextKey1", "99999999999999");
            }
            
            // DU 계층을 통한 수기조정 내역 조회
            IDataSet histRes = duTSKIPA112.selectManualAdjustmentList(histReq, onlineCtx);
            
            // 응답 데이터 설정
            responseData.put("totalNoitm", histRes.getInt("totalNoitm"));
            responseData.put("prsntNoitm", histRes.getInt("prsntNoitm"));
            responseData.put("grid1", histRes.get("grid1"));
            
            log.debug("기업집단수기조정내역조회 완료 - 기업집단코드: " + requestData.getString("corpClctGroupCd") + 
                     ", 등록코드: " + requestData.getString("corpClctRegiCd") + 
                     ", 조회건수: " + histRes.getInt("prsntNoitm"));

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }
}
