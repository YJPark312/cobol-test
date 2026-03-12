package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;
import com.kbstar.sqc.common.CommonArea;

/**
 * 기업집단종합의견관리 FU 클래스.
 * <pre>
 * 유닛 설명 : 기업집단 종합의견 정보의 저장, 수정, 삭제를 담당하는 기능 유닛
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
@BizUnit(value = "기업집단종합의견관리", type = "FU")
public class FUCorpGrpOpnMgt extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA130 duTSKIPA130;

    /**
     * 기업집단종합의견저장.
     * <pre>
     * 메소드 설명 : 기업집단 종합의견 정보를 저장하는 기능
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
     */
    @BizMethod("기업집단종합의견저장")
    public IDataSet saveCorpGrpOpn(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        CommonArea ca = getCommonArea(onlineCtx);
        IDataSet responseData = new DataSet();

        try {
            log.debug("기업집단종합의견저장 처리 시작");

            // 공통영역에서 사용자 정보 조회
            String empId = "SYSTEM"; // TODO: 실제 사용자 ID 조회 로직 구현 필요
            String currentDate = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());

            // 저장용 데이터 준비
            IDataSet saveReq = new DataSet();
            saveReq.put("groupCoCd", requestData.getString("groupCoCd"));
            saveReq.put("custIdnfr", _buildCustIdnfr(requestData));
            saveReq.put("serno", requestData.getInt("serno"));
            saveReq.put("dataCtnt", requestData.getString("comtCtnt"));
            saveReq.put("regiYmd", currentDate);
            saveReq.put("regiEmpid", empId);

            // 데이터 저장
            duTSKIPA130.insert(saveReq, onlineCtx);

            // 응답 데이터 설정
            responseData.put("returnCd", "0000");
            responseData.put("returnMsg", "정상처리되었습니다.");

            log.debug("기업집단종합의견저장 처리 완료");

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 고객식별자 생성.
     * <pre>
     * 기업집단그룹코드 + 기업집단등록코드 + 평가년월일 + 기업집단주석구분으로 고객식별자 생성
     * </pre>
     * @param requestData 요청 데이터
     * @return 고객식별자
     */
    private String _buildCustIdnfr(IDataSet requestData) {
        StringBuilder custIdnfr = new StringBuilder();
        custIdnfr.append(requestData.getString("corpClctGroupCd"));
        custIdnfr.append(requestData.getString("corpClctRegiCd"));
        custIdnfr.append(requestData.getString("valuaYmd"));
        custIdnfr.append(requestData.getString("corpCComtDstcd"));
        return custIdnfr.toString();
    }
}
