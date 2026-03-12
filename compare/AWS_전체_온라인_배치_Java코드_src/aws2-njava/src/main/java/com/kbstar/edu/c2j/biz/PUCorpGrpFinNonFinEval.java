package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단재무비재무평가 관리 PU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단의 재무/비재무 평가 및 신용등급 산출을 담당하는 온라인 거래 처리 단위
 * 포함된 AS 모듈: AIP4A70, AIPBA71
 * ---------------------------------------------------------------------------------
 *  버전	일자			작성자			설명
 * ---------------------------------------------------------------------------------
 *   1.0	20251002	MultiQ4KBBank		최초 작성
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank
 * @since 2025-10-02
 */
@BizUnit("기업집단재무/비재무평가")
public class PUCorpGrpFinNonFinEval extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind
    private FUCorpGrpFinNonFinEval fuCorpGrpFinNonFinEval;

    /**
     * 거래코드: KIP04A7041
     * 거래명: 기업집단재무/비재무평가조회
     * <pre>
     * 메소드 설명 : 기업집단의 재무/비재무 평가 정보를 조회하는 온라인 거래
     * 비즈니스 기능:
     * - 기업집단 재무평가 데이터 조회
     * - 비재무평가 정보 조회
     * - 평가 결과 통합 제공
     * 
     * 입력 파라미터:
     * - field : corpClctGroupCd [기업집단그룹코드] (string)
     * - field : corpClctRegiCd [기업집단등록코드] (string)
     * - field : valuaYmd [평가년월일] (string)
     * - field : valuaBaseYmd [평가기준년월일] (string)
     * 
     * 출력 파라미터:
     * - field : processStatus [처리상태] (string)
     * - field : processMessage [처리메시지] (string)
     * - recordSet : evalData [평가데이터 LIST]
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단재무/비재무평가조회")
    public IDataSet pmKIP04A7041(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단재무/비재무평가조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 검증
            validateCorpGrpEvalParams(requestData);
            
            // FU 클래스를 통한 기업집단 평가 조회 처리
            responseData = fuCorpGrpFinNonFinEval.processCorpGrpEvalInquiry(requestData, onlineCtx);
            
            log.debug("기업집단재무/비재무평가조회 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단재무/비재무평가조회 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단재무/비재무평가조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단 평가 파라미터 검증
     */
    private void validateCorpGrpEvalParams(IDataSet requestData) {
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        String valuaYmd = requestData.getString("valuaYmd");
        String valuaBaseYmd = requestData.getString("valuaBaseYmd");
        
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B4200099", "UKII0803", "기업집단그룹코드가 없습니다. 확인 후 다시 시도해 주세요");
        }
        
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B4200099", "UKII0803", "기업집단등록코드가 없습니다. 확인 후 다시 시도해 주세요");
        }
        
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException("B4200099", "UKII0803", "평가년월일이 없습니다. 확인 후 다시 시도해 주세요");
        }
        
        if (valuaBaseYmd == null || valuaBaseYmd.trim().isEmpty()) {
            throw new BusinessException("B4200099", "UKII0803", "평가기준년월일이 없습니다. 확인 후 다시 시도해 주세요");
        }
        
        // 날짜 형식 검증 (YYYYMMDD)
        if (!isValidDateFormat(valuaYmd)) {
            throw new BusinessException("B4200099", "UKII0803", "평가년월일 형식이 올바르지 않습니다. YYYYMMDD 형식으로 입력해 주세요");
        }
        
        if (!isValidDateFormat(valuaBaseYmd)) {
            throw new BusinessException("B4200099", "UKII0803", "평가기준년월일 형식이 올바르지 않습니다. YYYYMMDD 형식으로 입력해 주세요");
        }
        
        // 기준일자가 평가일자보다 작거나 같아야 함
        if (valuaBaseYmd.compareTo(valuaYmd) > 0) {
            throw new BusinessException("B4200099", "UKII0803", "평가기준년월일은 평가년월일보다 작거나 같아야 합니다");
        }
    }

    /**
     * 날짜 형식 검증 (YYYYMMDD)
     */
    private boolean isValidDateFormat(String dateStr) {
        if (dateStr == null || dateStr.length() != 8) {
            return false;
        }
        
        try {
            int year = Integer.parseInt(dateStr.substring(0, 4));
            int month = Integer.parseInt(dateStr.substring(4, 6));
            int day = Integer.parseInt(dateStr.substring(6, 8));
            
            if (year < 1900 || year > 2100) return false;
            if (month < 1 || month > 12) return false;
            if (day < 1 || day > 31) return false;
            
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * 거래코드: KIP11A71E0
     * 거래명: 기업집단신용등급산출
     * <pre>
     * 메소드 설명 : 기업집단의 신용등급을 산출하는 온라인 거래
     * 비즈니스 기능:
     * - 기업집단 신용등급 계산
     * - 평가 결과 저장
     * - 등급 산출 로직 처리
     * 
     * 입력 파라미터:
     * - field : groupCoCd [그룹회사코드] (string)
     * - field : corpClctGroupCd [기업집단그룹코드] (string)
     * - field : corpClctRegiCd [기업집단등록코드] (string)
     * - field : valuaYmd [평가년월일] (string)
     * - field : prcssDstic [처리구분] (string)
     * 
     * 출력 파라미터:
     * - field : processStatus [처리상태] (string)
     * - field : processMessage [처리메시지] (string)
     * - recordSet : ratingData [등급데이터 LIST]
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단신용등급산출")
    public IDataSet pmKIP11A71E0(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단신용등급산출 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 기업집단 파라미터 검증
            validateCorpGrpParams(requestData);
            
            // FU 클래스를 통한 비즈니스 로직 처리
            responseData = fuCorpGrpFinNonFinEval.processCorpGrpCreditRating(requestData, onlineCtx);
            
            log.debug("기업집단신용등급산출 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단신용등급산출 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단신용등급산출 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 기업집단 파라미터 검증
     */
    private void validateCorpGrpParams(IDataSet requestData) {
        String groupCoCd = requestData.getString("groupCoCd");
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        String valuaYmd = requestData.getString("valuaYmd");
        String prcssDstic = requestData.getString("prcssDstic");
        
        if (groupCoCd == null || groupCoCd.trim().isEmpty()) {
            throw new BusinessException("B3600003", "UKFH0208", "그룹회사코드를 입력하여 주시기 바랍니다.");
        }
        
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드를 입력하여 주시기 바랍니다.");
        }
        
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드를 입력하여 주시기 바랍니다.");
        }
        
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException("B2701130", "UKII0244", "평가년월일을 입력하여 주시기 바랍니다.");
        }
        
        if (prcssDstic == null || (!prcssDstic.equals("01") && !prcssDstic.equals("02"))) {
            throw new BusinessException("B3900002", "UKII0244", "처리구분은 01(저장) 또는 02(계산)이어야 합니다.");
        }
    }

}
