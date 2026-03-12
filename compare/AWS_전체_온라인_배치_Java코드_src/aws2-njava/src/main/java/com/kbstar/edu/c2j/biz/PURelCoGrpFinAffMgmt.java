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
 * 관계기업군재무생성계열기업관리.
 * <pre>
 * 유닛 설명 : 관계기업 집단의 재무계열을 관리하고 처리하는 포괄적인 온라인 처리 시스템
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
@BizUnit(value = "관계기업군재무생성계열기업관리", type = "PU")
public class PURelCoGrpFinAffMgmt extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FURelCoGrpFinAffMgmt fuRelCoGrpFinAffMgmt;

    /**
     * 관계기업재무생성기업관리.
     * <pre>
     * 메소드 설명 : 관계기업 집단의 재무계열 관리 및 처리
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : prcssDstcd [처리구분코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaBaseYr [평가기준년] (string)
     *	- field : regiBrncd [등록부점코드] (string) - 선택사항
     *	- field : regiEmpid [등록직원번호] (string) - 선택사항
     *	- field : regiYmd1 [등록년월일1] (string) - 선택사항
     *	- field : prsntNoitm [현재건수] (numeric) - 선택사항
     *	- field : totalNoitm [총건수] (numeric) - 선택사항
     *	- recordSet : GRID [기업정보 그리드] - 선택사항
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : returnCd [리턴코드] (string)
     *	- field : returnMsg [리턴메시지] (string)
     *	- field : prsntNoitm [현재건수] (numeric)
     *	- field : totalNoitm [총건수] (numeric)
     *	- recordSet : GRID [계열기업정보 그리드]
     *		- field : custIdnfr [고객식별자] (string)
     *		- field : entpName [업체명] (string)
     *		- field : valuaTagetYn1 [평가대상여부1] (string)
     *		- field : valuaTagetYn2 [평가대상여부2] (string)
     *		- field : valuaTagetYn3 [평가대상여부3] (string)
     *		- field : regiYmd2 [등록년월일2] (string)
     * </pre>
     */
    @BizMethod("관계기업재무생성기업관리")
    public IDataSet pmKIP11A18E0(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("관계기업재무생성기업관리 처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 검증
            validateInputParameters(requestData);
            
            // FU 메소드 호출
            IDataSet result = fuRelCoGrpFinAffMgmt.processRelCoGrpFinAffMgmt(requestData, onlineCtx);
            
            // 결과 데이터 설정
            responseData.put("returnCd", "00");
            responseData.put("returnMsg", "정상처리");
            responseData.put("prsntNoitm", result.get("prsntNoitm"));
            responseData.put("totalNoitm", result.get("totalNoitm"));
            responseData.put("GRID", result.get("GRID"));
            
            log.debug("관계기업재무생성기업관리 처리 완료");
            
        } catch (BusinessException e) {
            log.error("관계기업재무생성기업관리 처리 중 오류 발생", e);
            responseData.put("returnCd", e.getErrorCode());
            responseData.put("returnMsg", e.getMessage());
        } catch (Exception e) {
            log.error("관계기업재무생성기업관리 처리 중 시스템 오류 발생", e);
            responseData.put("returnCd", "99");
            responseData.put("returnMsg", "시스템 오류가 발생했습니다.");
        }
        
        return responseData;
    }
    
    /**
     * 입력 파라미터 검증.
     * @param requestData 요청 데이터
     */
    private void validateInputParameters(IDataSet requestData) {
        String prcssDstcd = requestData.getString("prcssDstcd");
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        String valuaBaseYr = requestData.getString("valuaBaseYr");
        
        // BR-031-001: 처리구분코드 검증
        if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0007", "처리구분코드를 입력하고 트랜잭션을 재시도하세요.");
        }
        
        // BR-031-002: 기업집단식별검증
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0001", "기업집단그룹코드를 입력하고 트랜잭션을 재시도하세요.");
        }
        
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0002", "기업집단등록코드를 입력하고 트랜잭션을 재시도하세요.");
        }
        
        // BR-031-003: 평가기준년검증
        if (valuaBaseYr == null || valuaBaseYr.trim().isEmpty()) {
            throw new BusinessException("B2700460", "UBND0033", "유효한 기준년도를 YYYY 형식으로 입력하고 트랜잭션을 재시도하세요.");
        }
        
        // 년도 형식 검증
        if (!valuaBaseYr.matches("\\d{4}")) {
            throw new BusinessException("B2700460", "UBND0033", "유효한 기준년도를 YYYY 형식으로 입력하고 트랜잭션을 재시도하세요.");
        }
    }
}
