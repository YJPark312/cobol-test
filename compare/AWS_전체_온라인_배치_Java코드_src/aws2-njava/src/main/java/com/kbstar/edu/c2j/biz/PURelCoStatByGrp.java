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
 * 관계기업군별관계기업현황 관리 PU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단 관계사 현황 정보를 조회하는 온라인 거래 처리 단위
 * 포함된 AS 모듈: AIP4A12
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
@BizUnit("관계기업군별관계기업현황")
public class PURelCoStatByGrp extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FUCorpGrpRelCoStatInq fuCorpGrpRelCoStatInq;

    /**
     * 거래코드: KIP04A1240
     * 거래명: 관계기업군별관계기업현황조회
     * <pre>
     * 메소드 설명 : 기업집단 관계사 현황 정보를 조회하는 온라인 서비스
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (WP-024 구현)
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : prcssDistcd [처리구분코드] (string) - 필수
     *	- field : corpClctRegiCd [기업집단등록코드] (string) - 필수
     *	- field : corpClctGroupCd [기업집단그룹코드] (string) - 필수
     *	- field : baseDstic [기준구분] (string) - 필수 ('1': 현재데이터, 기타: 이력데이터)
     *	- field : baseYm [기준년월] (string) - 이력데이터 조회시 필수 (YYYYMM)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- recordSet : companyList [관계사 정보 LIST]
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : rpsntBzno [대표사업자등록번호] (string)
     *		- field : rpsntEntpName [대표업체명] (string)
     *		- field : corpCvGrdDstcd [기업신용평가등급구분코드] (string)
     *		- field : corpScalDstcd [기업규모구분코드] (string)
     *		- field : stndIClsfiCd [표준산업분류코드] (string)
     *		- field : stndIClsfiName [표준산업분류명] (string)
     *		- field : custMgtBrncd [고객관리부점코드] (string)
     *		- field : brnName [부점명] (string)
     *		- field : totalLnbzAmt [총여신금액] (decimal)
     *		- field : lnbzBal [여신잔액] (decimal)
     *		- field : scurtyAmt [담보금액] (decimal)
     *		- field : amov [연체금액] (decimal)
     *		- field : pyyTotalLnbzAmt [전년총여신금액] (decimal)
     *		- field : corpLPlicyCtnt [기업여신정책내용] (string)
     *		- field : fcltFndsClam [시설자금한도금액] (decimal)
     *		- field : fcltFndsBal [시설자금잔액] (decimal)
     *		- field : wrknFndsClam [운전자금한도금액] (decimal)
     *		- field : wrknFndsBal [운전자금잔액] (decimal)
     *		- field : infcClam [투자금융한도금액] (decimal)
     *		- field : infcBal [투자금융잔액] (decimal)
     *		- field : etcFndsClam [기타자금한도금액] (decimal)
     *		- field : etcFndsBal [기타자금잔액] (decimal)
     *		- field : drvtPTranClam [파생상품거래한도금액] (decimal)
     *		- field : drvtPrdctTranBal [파생상품거래잔액] (decimal)
     *		- field : drvtPcTranClam [파생상품신용거래한도금액] (decimal)
     *		- field : drvtPsTranClam [파생상품담보거래한도금액] (decimal)
     *		- field : inlsGrcrStupClam [포괄신용공여설정한도금액] (decimal)
     *		- field : elyAaMgtDstcd [조기경보사후관리구분코드] (string)
     *		- field : hwrtModfiDstcd [수기변경구분코드] (string)
     *	- field : totalCount [총 조회건수] (int)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("관계기업군별관계기업현황조회")
    public IDataSet pmKIP04A1240(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("관계기업군별관계기업현황조회 시작");
            
            // 입력 데이터 로깅
            log.debug("입력 파라미터 - 처리구분코드: " + requestData.getString("prcssDistcd"));
            log.debug("입력 파라미터 - 기업집단등록코드: " + requestData.getString("corpClctRegiCd"));
            log.debug("입력 파라미터 - 기업집단그룹코드: " + requestData.getString("corpClctGroupCd"));
            log.debug("입력 파라미터 - 기준구분: " + requestData.getString("baseDstic"));
            log.debug("입력 파라미터 - 기준년월: " + requestData.getString("baseYm"));

            // PM → FM 호출 (변환 가이드 준수)
            IDataSet result = fuCorpGrpRelCoStatInq.processCorpGrpRelCoStatInq(requestData, onlineCtx);
            
            // 응답 데이터 설정
            responseData.put("companyList", result.getRecordSet("companyList"));
            responseData.put("totalCount", result.getInt("totalCount"));
            
            // 처리 상태 설정
            responseData.put("processStatus", "SUCCESS");
            responseData.put("processMessage", "관계기업군별관계기업현황조회가 성공적으로 완료되었습니다.");
            
            log.debug("관계기업군별관계기업현황조회 완료 - 조회건수: " + result.getInt("totalCount"));

        } catch (BusinessException e) {
            log.error("관계기업군별관계기업현황조회 비즈니스 오류", e);
            
            // 비즈니스 예외는 그대로 전파
            throw e;
            
        } catch (Exception e) {
            log.error("관계기업군별관계기업현황조회 시스템 오류", e);
            
            // 시스템 오류를 비즈니스 예외로 변환
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

}
