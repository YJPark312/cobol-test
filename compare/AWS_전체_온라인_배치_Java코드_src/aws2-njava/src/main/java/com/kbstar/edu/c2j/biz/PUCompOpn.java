package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;
import com.kbstar.sqc.common.CommonArea;

/**
 * 기업집단종합의견 관리 PU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단의 종합의견 정보를 관리하는 온라인 거래 처리 단위
 * 포함된 AS 모듈: AIPBA91, AIP4A90
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
@BizUnit("종합의견")
public class PUCompOpn extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FUCorpGrpOpnInq fuCorpGrpOpnInq;
    @BizUnitBind private FUCorpGrpOpnMgt fuCorpGrpOpnMgt;

    /**
     * 기업집단종합의견저장.
     * <pre>
     * 메소드 설명 : 기업집단의 종합의견 정보를 저장하는 온라인 거래
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
     *	- field : corpCComtDstcd [기업집단주석구분] (string)
     *	- field : serno [일련번호] (numeric)
     *	- field : comtCtnt [주석내용] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : returnCd [리턴코드] (string)
     *	- field : returnMsg [리턴메시지] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단종합의견저장")
    public IDataSet pmKIP11A91E0(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);

        try {
            log.debug("기업집단종합의견저장 시작");
            
            // 비즈니스 룰 BR-021-001: 기업집단식별검증
            validateInputForSave(requestData);
            
            // FU 호출하여 종합의견 저장 처리
            IDataSet responseData = fuCorpGrpOpnMgt.saveCorpGrpOpn(requestData, onlineCtx);
            
            log.debug("기업집단종합의견저장 완료");
            
            return responseData;

        } catch (BusinessException e) {
            log.error("기업집단종합의견저장 비즈니스 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("기업집단종합의견저장 시스템 오류: " + e.getMessage());
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
    }

    /**
     * 기업집단종합의견조회.
     * <pre>
     * 메소드 설명 : 기업집단의 종합의견 정보를 조회하는 온라인 거래
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
     *	- field : corpCComtDstcd [기업집단주석구분] (string) - 선택사항
     *	- field : serno [일련번호] (numeric) - 선택사항
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : returnCd [리턴코드] (string)
     *	- field : returnMsg [리턴메시지] (string)
     *	- recordSet : opinionList [종합의견 정보 LIST]
     *		- field : groupCoCd [그룹회사코드] (string)
     *		- field : corpClctGroupCd [기업집단그룹코드] (string)
     *		- field : corpClctRegiCd [기업집단등록코드] (string)
     *		- field : valuaYmd [평가년월일] (string)
     *		- field : corpCComtDstcd [기업집단주석구분] (string)
     *		- field : serno [일련번호] (numeric)
     *		- field : comtCtnt [주석내용] (string)
     *		- field : sysLastPrcssYms [시스템최종처리일시] (string)
     *		- field : sysLastUno [시스템최종사용자번호] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단종합의견조회")
    public IDataSet pmKIP04A9040(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);

        try {
            log.debug("기업집단종합의견조회 시작");
            
            // 비즈니스 룰 BR-021-001: 기업집단식별검증
            validateInputForInquiry(requestData);
            
            // FU 호출하여 종합의견 조회 처리
            IDataSet responseData = fuCorpGrpOpnInq.inquireCorpGrpOpn(requestData, onlineCtx);
            
            log.debug("기업집단종합의견조회 완료");
            
            return responseData;

        } catch (BusinessException e) {
            log.error("기업집단종합의견조회 비즈니스 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("기업집단종합의견조회 시스템 오류: " + e.getMessage());
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
    }

    /**
     * 저장용 입력값 검증 - BR-021-001 구현.
     * <pre>
     * 비즈니스 룰 BR-021-001: 기업집단식별검증
     * - 그룹회사코드, 기업집단그룹코드, 기업집단등록코드는 필수 입력
     * - 평가년월일은 YYYYMMDD 형식으로 입력
     * - 기업집단주석구분, 일련번호는 필수 입력
     * - 주석내용은 4002자 이내로 제한
     * </pre>
     * @param requestData 요청 데이터
     */
    private void validateInputForSave(IDataSet requestData) {
        String groupCoCd = requestData.getString("groupCoCd");
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        String valuaYmd = requestData.getString("valuaYmd");
        String corpCComtDstcd = requestData.getString("corpCComtDstcd");
        String comtCtnt = requestData.getString("comtCtnt");
        
        // 필수 필드 검증
        if (groupCoCd == null || groupCoCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0001", "그룹회사코드 확인후 거래하세요");
        }
        
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0002", "기업집단그룹코드 확인후 거래하세요");
        }
        
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0003", "기업집단등록코드 확인후 거래하세요");
        }
        
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0004", "평가년월일 확인후 거래하세요");
        }
        
        if (corpCComtDstcd == null || corpCComtDstcd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0005", "기업집단주석구분 확인후 거래하세요");
        }
        
        // 날짜 형식 검증
        if (valuaYmd.length() != 8) {
            throw new BusinessException("B3800004", "UKIP0006", "평가년월일은 YYYYMMDD 형식으로 입력하세요");
        }
        
        // 주석내용 길이 검증
        if (comtCtnt != null && comtCtnt.length() > 4002) {
            throw new BusinessException("B3800004", "UKIP0007", "주석내용은 4002자 이내로 입력하세요");
        }
    }

    /**
     * 조회용 입력값 검증 - BR-021-001 구현.
     * <pre>
     * 비즈니스 룰 BR-021-001: 기업집단식별검증
     * - 그룹회사코드, 기업집단그룹코드, 기업집단등록코드는 필수 입력
     * - 평가년월일은 YYYYMMDD 형식으로 입력
     * - 기업집단주석구분, 일련번호는 선택사항
     * </pre>
     * @param requestData 요청 데이터
     */
    private void validateInputForInquiry(IDataSet requestData) {
        String groupCoCd = requestData.getString("groupCoCd");
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        String valuaYmd = requestData.getString("valuaYmd");
        
        // 필수 필드 검증
        if (groupCoCd == null || groupCoCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0001", "그룹회사코드 확인후 거래하세요");
        }
        
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0002", "기업집단그룹코드 확인후 거래하세요");
        }
        
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0003", "기업집단등록코드 확인후 거래하세요");
        }
        
        // 날짜 형식 검증 (선택사항이지만 제공될 때는 유효해야 함)
        if (valuaYmd != null && !valuaYmd.trim().isEmpty()) {
            if (valuaYmd.length() != 8) {
                throw new BusinessException("B3800004", "UKIP0006", "평가년월일은 YYYYMMDD 형식으로 입력하세요");
            }
        }
    }

}
