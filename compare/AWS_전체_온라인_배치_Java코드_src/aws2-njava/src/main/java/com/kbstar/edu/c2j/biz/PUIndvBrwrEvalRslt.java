package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.common.CommonArea;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단개별평가결과조회.
 * <pre>
 * 유닛 설명 : 기업집단 구성원의 개별평가결과를 조회하는 온라인 거래
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
@BizUnit(value = "기업집단개별평가결과조회", type = "PU")
public class PUIndvBrwrEvalRslt extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FUCorpGrpIndvEvalInq fuCorpGrpIndvEvalInq;

    /**
     * 기업집단개별평가결과조회.
     * <pre>
     * 메소드 설명 : 기업집단 구성원의 개별평가결과를 조회하는 온라인 거래
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
     *	- field : valuaYmd [평가년월일] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : returnCd [리턴코드] (string)
     *	- field : returnMsg [리턴메시지] (string)
     *	- field : totalNoitm [총건수] (numeric)
     *	- field : prsntNoitm [현재건수] (numeric)
     *	- recordSet : grid1 [개별평가결과 LIST]
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : brwrName [차주명] (string)
     *		- field : crdtVRptdocNo [신용평가보고서번호] (string)
     *		- field : valuaYmd [평가년월일] (string)
     *		- field : bsnsCrdtGrdDstcd [영업신용등급구분코드] (string)
     *		- field : vldYmd [유효년월일] (string)
     *		- field : stlaccBaseYmd [결산기준년월일] (string)
     *		- field : mdlScaleDstcd [모형규모구분코드] (string)
     *		- field : fnafBsnsDstcd [재무업종구분코드] (string)
     *		- field : nonFnafBsnsDstcd [비재무업종구분코드] (string)
     *		- field : fnafMdelValscr [재무모델평가점수] (numeric)
     *		- field : adjsAnFnafValscr [조정후비재무평가점수] (numeric)
     *		- field : rprsMdelValscr [대표자모델평가점수] (numeric)
     *		- field : grdRstrcCnflCnt [등급제한저촉개수] (numeric)
     *		- field : grdAdjsDstcd [등급조정구분코드] (string)
     *		- field : adjsStgeNoDstcd [조정단계번호구분코드] (string)
     *		- field : lastAplyYms [최종적용일시] (string)
     *		- field : lastAplyEmpid [최종적용직원번호] (string)
     *		- field : lastAplyBrncd [최종적용부점코드] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단개별평가결과조회")
    public IDataSet pmKIP04A7240(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);

        try {
            // BR-017-001: 기업집단 파라미터 검증
            validateParameters(requestData);
            
            // FU 계층을 통한 개별평가결과 조회
            IDataSet evalRes = fuCorpGrpIndvEvalInq.retrieveIndvEvalResults(requestData, onlineCtx);
            
            // 응답 데이터 구성
            responseData.put("totalNoitm", evalRes.getInt("totalNoitm"));
            responseData.put("prsntNoitm", evalRes.getInt("prsntNoitm"));
            responseData.put("grid1", evalRes.get("grid1"));
            
            log.debug("기업집단개별평가결과조회 완료 - 조회건수: " + evalRes.getInt("prsntNoitm"));

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 입력 파라미터 검증 (BR-017-001).
     */
    private void validateParameters(IDataSet requestData) {
        String groupCoCd = requestData.getString("groupCoCd");
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        String valuaYmd = requestData.getString("valuaYmd");

        if (groupCoCd == null || groupCoCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKIP0001", "그룹회사코드를 입력하고 거래를 다시 실행하여 주시기 바랍니다.");
        }
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드를 입력하고 거래를 다시 실행하여 주시기 바랍니다.");
        }
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKIP0002", "기업집단등록코드를 입력하고 거래를 다시 실행하여 주시기 바랍니다.");
        }
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException("B2700019", "UKIP0003", "평가년월일을 입력하고 거래를 다시 실행하여 주시기 바랍니다.");
        }
    }
}
