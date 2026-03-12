package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단계열사명세 테이블DU.
 * <pre>
 * 유닛 설명 : TSKIPB116 테이블에 대한 계열사 정보 저장/삭제를 담당하는 데이터 유닛
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
@BizUnit(value = "기업집단계열사명세", type = "DU")
public class DUTSKIPB116 extends com.kbstar.sqc.base.DataUnit {

    /**
     * 계열사정보삭제.
     * <pre>
     * 메소드 설명 : TSKIPB116 테이블에서 기업집단의 기존 계열사 정보 삭제
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("계열사정보삭제")
    public void delete(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);

        try {
            int deletedCount = dbDelete("delete", requestData, onlineCtx);
            
            log.debug("계열사정보삭제 완료 - 그룹코드: " + requestData.getString("corpClctGroupCd") + 
                     ", 등록코드: " + requestData.getString("corpClctRegiCd") + 
                     ", 삭제건수: " + deletedCount);

        } catch (Exception e) {
            log.error("계열사정보삭제 오류", e);
            throw new BusinessException("B4200219", "UKII0182", "데이터를 삭제할 수 없습니다", e);
        }
    }

    /**
     * 계열사정보삽입.
     * <pre>
     * 메소드 설명 : TSKIPB116 테이블에 새로운 계열사 정보 삽입
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string)
     *	- field : valuaBaseYmd [평가기준년월일] (string)
     *	- field : exmtnCustIdnfr [심사고객식별자] (string)
     *	- field : coprName [법인명] (string)
     *	- field : kisCOpblcDstcd [한국신용평가기업공개구분코드] (string)
     *	- field : incorYmd [설립년월일] (string)
     *	- field : bztypName [업종명] (string)
     *	- field : rprsName [대표자명] (string)
     *	- field : totalAsam [총자산금액] (bigDecimal)
     *	- field : salepr [매출액] (bigDecimal)
     *	- field : captlTsumnAmt [자본총계금액] (bigDecimal)
     *	- field : netPrft [순이익] (bigDecimal)
     *	- field : oprft [영업이익] (bigDecimal)
     *	- field : fncs [금융비용] (bigDecimal)
     *	- field : ebitdaAmt [EBITDA금액] (bigDecimal)
     *	- field : corpCLiablRato [기업집단부채비율] (bigDecimal)
     *	- field : ambrRlncRt [차입금의존도율] (bigDecimal)
     *	- field : netBAvtyCsfwAmt [순영업현금흐름금액] (bigDecimal)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("계열사정보삽입")
    public void insert(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);

        try {
            int insertedCount = dbInsert("insert", requestData, onlineCtx);
            
            log.debug("계열사정보삽입 완료 - 심사고객식별자: " + requestData.getString("exmtnCustIdnfr") + 
                     ", 법인명: " + requestData.getString("coprName") + 
                     ", 삽입건수: " + insertedCount);

        } catch (Exception e) {
            log.error("계열사정보삽입 오류", e);
            throw new BusinessException("B3900010", "UKII0182", "데이터를 생성할 수 없습니다", e);
        }
    }
}
