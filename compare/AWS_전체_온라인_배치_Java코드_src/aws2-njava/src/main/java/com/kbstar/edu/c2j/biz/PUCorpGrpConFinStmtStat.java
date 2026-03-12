package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단합산연결재무제표현황 관리 PU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단 연결재무제표 현황 및 재무비율 정보를 조회하는 온라인 거래 처리 단위
 * 포함된 AS 모듈: AIP4A57, AIP4A58
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
@BizUnit("기업집단합산연결재무제표현황")
public class PUCorpGrpConFinStmtStat extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FUCorpGrpConFinStmtStat fuCorpGrpConFinStmtStat;
    @BizUnitBind private FUCorpGrpConFinRatioInq fuCorpGrpConFinRatioInq;

    /**
     * 거래코드: KIP04A5740
     * 거래명: 기업집단합산연결재무제표조회
     * <pre>
     * 메소드 설명 : 기업집단의 합산 및 연결 재무제표 현황 정보를 조회하는 온라인 서비스
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (WP-037 구현)
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : prcssdstic [처리구분코드] (string) - 필수
     *	- field : corpClctGroupCd [기업집단그룹코드] (string) - 필수
     *	- field : corpClctRegiCd [기업집단등록코드] (string) - 필수
     *	- field : fnstDstic [재무제표구분] (string) - 필수
     *	- field : fnafAStlaccDstcd [재무분석결산구분코드] (string) - 필수
     *	- field : baseYr [기준년] (string) - 필수 (YYYY)
     *	- field : anlsTrm [분석기간] (string) - 필수
     *	- field : unit [단위] (string) - 필수
     *	- field : fnafARptdocDst1 [재무분석보고서구분코드1] (string) - 필수
     *	- field : fnafARptdocDst2 [재무분석보고서구분코드2] (string) - 필수
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- recordSet : settlementYears [결산년도 목록]
     *		- field : stlaccYr [결산년] (string)
     *		- field : stlaccYsEntpCnt [결산년합계업체수] (numeric)
     *		- field : prcssdstic [처리구분] (string)
     *	- recordSet : financialItems [재무항목 정보]
     *		- field : stlacczYr [결산년도] (string)
     *		- field : fnafItemName [재무항목명] (string)
     *		- field : fnstItemAmt [재무제표항목금액] (numeric)
     *	- field : returnCd [리턴코드] (string)
     *	- field : returnMsg [리턴메시지] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단합산연결재무제표조회")
    public IDataSet pmKIP04A5740(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단합산연결재무제표조회 시작");
        
        try {
            // FU 메소드 호출
            IDataSet responseData = fuCorpGrpConFinStmtStat.processCorpGrpConFinStmtInq(requestData, onlineCtx);
            
            log.debug("기업집단합산연결재무제표조회 완료");
            return responseData;
            
        } catch (BusinessException e) {
            log.error("기업집단합산연결재무제표조회 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("기업집단합산연결재무제표조회 시스템 오류: " + e.getMessage());
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.");
        }
    }

    /**
     * 거래코드: KIP04A5840
     * 거래명: 기업집단합산연결재무비율조회
     * <pre>
     * 메소드 설명 : 기업집단의 합산 및 개별 재무비율을 조회하고 통계를 생성하는 온라인 서비스
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (WP-040 구현)
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : corpClctGroupCd [기업집단그룹코드] (string) - 필수
     *	- field : corpClctRegiCd [기업집단등록코드] (string) - 필수
     *	- field : fnstDstic [재무제표구분] (string) - 필수
     *	- field : fnafAStlaccDstcd [재무분석결산구분코드] (string) - 필수
     *	- field : baseYr [기준년] (string) - 필수 (YYYY)
     *	- field : anlsTrm [분석기간] (string) - 필수
     *	- field : fnafARptdocDst1 [재무분석보고서구분코드1] (string) - 필수
     *	- field : fnafARptdocDst2 [재무분석보고서구분코드2] (string) - 필수
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- recordSet : settlementYears [결산년도 목록]
     *		- field : stlaccYr [결산년] (string)
     *		- field : stlaccYsEntpCnt [결산년합계업체수] (numeric)
     *	- recordSet : consolidatedRatios [합산재무비율]
     *		- field : corpClctFnafRato [기업집단재무비율] (numeric)
     *		- field : nmrtVal [분자값] (numeric)
     *		- field : dnmnVal [분모값] (numeric)
     *		- field : fnafItemCd [재무항목코드] (string)
     *	- recordSet : separateRatios [개별재무비율]
     *		- field : corpClctFnafRato [기업집단재무비율] (numeric)
     *		- field : nmrtVal [분자값] (numeric)
     *		- field : dnmnVal [분모값] (numeric)
     *		- field : fnafItemCd [재무항목코드] (string)
     *	- field : processingStatus [처리상태] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단합산연결재무비율조회")
    public IDataSet pmKIP04A5840(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단합산연결재무비율조회 시작");
        
        try {
            // FU 메소드 호출
            IDataSet responseData = fuCorpGrpConFinRatioInq.processCorpGrpConFinRatioInq(requestData, onlineCtx);
            
            log.debug("기업집단합산연결재무비율조회 완료");
            return responseData;
            
        } catch (BusinessException e) {
            log.error("기업집단합산연결재무비율조회 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("기업집단합산연결재무비율조회 시스템 오류: " + e.getMessage());
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.");
        }
    }

}
