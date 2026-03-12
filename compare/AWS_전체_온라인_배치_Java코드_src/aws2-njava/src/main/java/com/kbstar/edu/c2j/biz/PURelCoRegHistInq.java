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
 * 관계기업등록변경이력정보조회.
 * <pre>
 * 유닛 설명 : 기업집단 관계기업의 등록변경 이력정보를 조회하는 온라인 거래
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
@BizUnit(value = "관계기업등록변경이력정보조회", type = "PU")
public class PURelCoRegHistInq extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FUCorpGrpRegHist fuCorpGrpRegHist;

    /**
     * 고객검증 private 메소드 (BR-011-008)
     * <pre>
     * 비즈니스 룰 BR-011-008: 고객번호 패딩 처리
     * - 심사고객식별자에 "00000"을 추가하여 고객번호 생성
     * - 고객번호 패턴 구분코드는 "2"로 설정
     * - 그룹회사코드는 "KB0"으로 고정
     * </pre>
     * @param exmtnCustIdnfr 심사고객식별자
     * @param onlineCtx 온라인 컨텍스트
     * @return 검증결과
     */
    private IDataSet _validateCustomer(String exmtnCustIdnfr, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // 비즈니스 룰 BR-011-008: 고객번호 패딩 처리
            // 고객번호 패딩 처리 (BR-011-008)
            String custNo = exmtnCustIdnfr + "00000";
            String custNoPtrnDstcd = "2";
            String groupCoCd = "KB0";
            
            // 입력 데이터 검증 및 변환
            IDataSet jicomReq = new DataSet();
            jicomReq.put("JICOM-CNO", custNo);
            jicomReq.put("JICOM-CNO-PTRN-DSTIC", custNoPtrnDstcd);
            jicomReq.put("BICOM-GROUP-CO-CD", groupCoCd);
            
            // TODO: IJICOMM.req 호출을 실제 프레임워크 메소드로 대체 필요
            IDataSet jicomRes = new DataSet(); // Mock 응답
            jicomRes.put("returnCd", "00");
            
            responseData.put("custNo", custNo);
            responseData.put("custNoPtrnDstcd", custNoPtrnDstcd);
            String returnCd = jicomRes.getString("returnCd");
            if (returnCd == null) returnCd = "00";
            responseData.put("returnCd", returnCd);
            
            log.debug("고객검증 완료 - 심사고객식별자: " + exmtnCustIdnfr + ", 고객번호: " + custNo);

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 관계기업등록변경이력정보조회.
     * <pre>
     * 메소드 설명 : 기업집단 관계기업의 등록변경 이력정보를 조회하는 온라인 거래
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : prcssClassCd [처리구분코드] (string)
     *	- field : exmtnCustIdnfr [심사고객식별자] (string)
     *	- field : dscnTranDstcd [중단거래구분] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : returnCd [리턴코드] (string)
     *	- field : returnMsg [리턴메시지] (string)
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
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("관계기업등록변경이력정보조회")
    public IDataSet pmKIP04A1340(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);

        // 비즈니스 룰 BR-011-001: 처리구분코드 검증
        // 비즈니스 룰 BR-011-002: 심사고객식별자 검증
        // 입력값 검증 (BR-011-001, BR-011-002)
        String prcssClassCd = requestData.getString("prcssClassCd");
        String exmtnCustIdnfr = requestData.getString("exmtnCustIdnfr");
        
        if (!"R1".equals(prcssClassCd)) {
            throw new BusinessException("B3800004", "UKII0291", "처리구분코드 오류");
        }
        
        if (exmtnCustIdnfr == null || exmtnCustIdnfr.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKII0007", "심사고객식별자 오류");
        }

        try {
            // 비즈니스 룰 BR-011-008: 고객번호 패딩 처리
            // 고객 검증 (BR-011-008)
            IDataSet custValidRes = _validateCustomer(exmtnCustIdnfr, onlineCtx);
            
            // 데이터베이스 조회 파라미터 구성
            // FU 계층을 통한 기업집단 이력 조회
            IDataSet histReq = new DataSet();
            histReq.put("exmtnCustIdnfr", exmtnCustIdnfr);
            histReq.put("dscnTranDstcd", requestData.getString("dscnTranDstcd"));
            
            IDataSet histRes = fuCorpGrpRegHist.retrieveHistory(histReq, onlineCtx);
            
            // 조회 결과 가공 및 응답 데이터 구성
            // 응답 데이터 구성
            responseData.put("totalNoitm", histRes.getInt("totalNoitm"));
            responseData.put("prsntNoitm", histRes.getInt("prsntNoitm"));
            responseData.put("sysLastPrcssYms", histRes.getString("sysLastPrcssYms"));
            responseData.put("grid1", histRes.get("grid1"));
            
            log.debug("관계기업등록변경이력정보조회 완료 - 고객식별자: " + exmtnCustIdnfr + 
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
