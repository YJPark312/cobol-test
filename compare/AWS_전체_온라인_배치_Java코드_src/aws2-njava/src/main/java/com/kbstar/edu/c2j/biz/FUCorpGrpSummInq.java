package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단요약조회 관리 FU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단 요약 정보를 조회하고 관리하는 기능 단위
 * ---------------------------------------------------------------------------------
 *  버전	일자			작성자			설명
 * ---------------------------------------------------------------------------------
 *   1.0	20251002	MultiQ4KBBank		최초 작성 (WP-041 구현)
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank
 * @since 2025-10-02
 */
@BizUnit("기업집단요약조회")
public class FUCorpGrpSummInq extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPB110 duTSKIPB110;
    @BizUnitBind private DUTSKIPB113 duTSKIPB113;

    /**
     * 기업집단요약조회처리
     * <pre>
     * 메소드 설명 : 기업집단의 요약 정보를 조회하는 기능
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251002	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단요약조회처리")
    public IDataSet inquireCorpGrpSummary(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단요약조회처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // BR-041-001: 기업집단그룹코드 검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B4100001", "UKFH0001", "기업집단그룹코드는 필수입력항목입니다.");
            }

            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B4100002", "UKFH0002", "기업집단등록코드는 필수입력항목입니다.");
            }

            // BR-041-003: 평가일자 검증
            String valuaYmd = requestData.getString("valuaYmd");
            if (valuaYmd != null && !valuaYmd.trim().isEmpty()) {
                if (!valuaYmd.matches("^\\d{8}$")) {
                    throw new BusinessException("B4100003", "UKFH0003", "평가년월일은 YYYYMMDD 형식이어야 합니다.");
                }
            }

            // 조회 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", corpClctGroupCd);
            queryReq.put("corpClctRegiCd", corpClctRegiCd);
            queryReq.put("valuaYmd", valuaYmd);
            queryReq.put("groupCoCd", requestData.getString("groupCoCd"));
            
            // F-041-001: 기업집단 기본정보 조회
            IDataSet basicResult = duTSKIPB110.select(queryReq, onlineCtx);
            
            // F-041-002: 기업집단 사업부문분석 조회
            IDataSet summResult = duTSKIPB113.selectCorpGrpBizSectAnal(queryReq, onlineCtx);
            
            // 결과 데이터 처리
            IRecordSet basicList = basicResult.getRecordSet("output");
            IRecordSet summList = summResult.getRecordSet("output");
            
            int totalCount = 0;
            int presentCount = 0;
            
            if (basicList != null) {
                totalCount = basicList.getRecordCount();
                presentCount = Math.min(totalCount, 500); // BR-041-006: 레코드수제한
            }
            
            // 응답 데이터 구성 (명세서 준수)
            responseData.put("returnCd", "00");
            responseData.put("returnMsg", "기업집단요약조회가 완료되었습니다.");
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("basicInfo", basicList);
            responseData.put("summaryInfo", summList);
            
            log.debug("기업집단요약조회처리 완료 - 조회건수: " + totalCount);

        } catch (BusinessException e) {
            log.error("기업집단요약조회처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단요약조회처리 시스템 오류", e);
            throw new BusinessException("B4100999", "UKFH0999", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }
}
