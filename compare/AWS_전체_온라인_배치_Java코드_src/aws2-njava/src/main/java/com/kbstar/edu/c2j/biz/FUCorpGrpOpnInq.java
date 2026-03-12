package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단종합의견조회.
 * <pre>
 * 유닛 설명 : 기업집단 종합의견 정보 조회 기능 유닛
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
@BizUnit(value = "기업집단종합의견조회", type = "FU")
public class FUCorpGrpOpnInq extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPB130 duTSKIPB130;

    /**
     * 기업집단종합의견조회처리.
     * <pre>
     * 메소드 설명 : 기업집단 종합의견 정보 조회 및 검증
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
     *	- field : serno [일련번호] (bigDecimal)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : comtCtnt [주석내용] (string)
     * </pre>
     */
    @BizMethod("기업집단종합의견조회처리")
    public IDataSet inquireCorpGrpOpn(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단종합의견조회 시작");

        // BR-021-001: 기업집단식별검증
        validateCorpGrpId(requestData);

        // BR-021-003: 평가일자일관성
        validateEvaluationDate(requestData);

        // 의견 데이터 조회
        IDataSet resultData = duTSKIPB130.select(requestData, onlineCtx);

        // BR-021-002: 의견데이터완전성검증
        validateOpinionData(resultData);

        log.debug("기업집단종합의견조회 완료");
        return resultData;
    }

    /**
     * 기업집단식별검증.
     * <pre>
     * BR-021-001: 기업집단식별검증
     * 필수 식별 파라미터 검증
     * </pre>
     */
    private void validateCorpGrpId(IDataSet requestData) {
        String groupCoCd = requestData.getString("groupCoCd");
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");

        if (isEmpty(groupCoCd)) {
            throw new BusinessException("B3600003", "UKFH0208", "그룹회사코드를 입력하고 거래를 재시도하여 주시기 바랍니다.");
        }

        if (isEmpty(corpClctGroupCd)) {
            throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드를 입력하고 거래를 재시도하여 주시기 바랍니다.");
        }

        if (isEmpty(corpClctRegiCd)) {
            throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드를 입력하고 거래를 재시도하여 주시기 바랍니다.");
        }
    }

    /**
     * 평가일자일관성검증.
     * <pre>
     * BR-021-003: 평가일자일관성
     * 평가일자 형식 및 일관성 검증
     * </pre>
     */
    private void validateEvaluationDate(IDataSet requestData) {
        String valuaYmd = requestData.getString("valuaYmd");

        if (isEmpty(valuaYmd)) {
            throw new BusinessException("B2700094", "UKII0390", "평가년월일을 입력하고 거래를 재시도하여 주시기 바랍니다.");
        }

        // YYYYMMDD 형식 검증
        if (valuaYmd.length() != 8 || !valuaYmd.matches("\\d{8}")) {
            throw new BusinessException("B2700094", "UKII0390", "평가년월일 형식이 올바르지 않습니다.");
        }
    }

    /**
     * 의견데이터완전성검증.
     * <pre>
     * BR-021-002: 의견데이터완전성검증
     * 조회된 의견 데이터의 완전성 검증
     * </pre>
     */
    private void validateOpinionData(IDataSet resultData) {
        if (resultData == null) {
            throw new BusinessException("B4200223", "UKIH0072", "해당 조건의 의견 정보가 존재하지 않습니다.");
        }
    }

    /**
     * 문자열 공백 검증.
     */
    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}
