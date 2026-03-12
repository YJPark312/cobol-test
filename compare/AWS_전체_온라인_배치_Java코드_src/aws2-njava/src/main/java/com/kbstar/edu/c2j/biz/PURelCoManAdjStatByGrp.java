package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 관계기업수기조정내역조회.
 * <pre>
 * 유닛 설명 : 기업집단 관계기업의 수기조정 내역정보를 조회하는 온라인 거래
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
@BizUnit(value = "관계기업수기조정내역조회", type = "PU")
public class PURelCoManAdjStatByGrp extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FUCorpGrpManAdjHist fuCorpGrpManAdjHist;

    /**
     * 관계기업수기조정내역조회.
     * <pre>
     * 메소드 설명 : 기업집단 관계기업의 수기조정 내역정보를 조회하는 온라인 거래
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : prcssClassCd [처리구분코드] (string)
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : dscnTranDstcd [중단거래구분] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : totalNoitm [총건수] (numeric)
     *	- field : prsntNoitm [현재건수] (numeric)
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
    @BizMethod("관계기업수기조정내역조회")
    public IDataSet pmKIP04A1440(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        // 비즈니스 룰 BR-012-001: 처리구분코드 검증
        String prcssClassCd = requestData.getString("prcssClassCd");
        if (prcssClassCd == null || prcssClassCd.trim().isEmpty()) {
            throw new BusinessException("B3000070", "UKII0126", "업무담당자에게 문의 바랍니다");
        }

        // 비즈니스 룰 BR-012-002: 기업집단 매개변수 검증
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty() ||
            corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3000070", "UKII0126", "업무담당자에게 문의 바랍니다");
        }

        try {
            // FU 계층을 통한 수기조정 내역 조회
            IDataSet histReq = new DataSet();
            histReq.put("groupCoCd", "KB0");
            histReq.put("corpClctGroupCd", corpClctGroupCd);
            histReq.put("corpClctRegiCd", corpClctRegiCd);
            histReq.put("dscnTranDstcd", requestData.getString("dscnTranDstcd"));
            
            IDataSet histRes = fuCorpGrpManAdjHist.retrieveManualAdjustmentHistory(histReq, onlineCtx);
            
            // 응답 데이터 구성
            responseData.put("totalNoitm", histRes.getInt("totalNoitm"));
            responseData.put("prsntNoitm", histRes.getInt("prsntNoitm"));
            responseData.put("grid1", histRes.get("grid1"));
            
            log.debug("관계기업수기조정내역조회 완료 - 기업집단코드: " + corpClctGroupCd + 
                     ", 등록코드: " + corpClctRegiCd + ", 조회건수: " + histRes.getInt("prsntNoitm"));

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }
}
