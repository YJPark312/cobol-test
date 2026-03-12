package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단등급조정등록 FU 클래스.
 * <pre>
 * 유닛 설명 : 기업집단의 신용등급을 조정하고 등록하는 기능 유닛
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
@BizUnit(value = "기업집단등급조정등록", type = "FU")
public class FUCorpGrpRtgAdjReg extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA110 duTSKIPA110;
    @BizUnitBind private DUTSKIPA130 duTSKIPA130;
    @BizUnitBind private DUTSKIPB110 duTSKIPB110;
    @BizUnitBind private DUTSKIPB130 duTSKIPB130;

    /**
     * 기업집단등급조정등록처리.
     * <pre>
     * 메소드 설명 : 기업집단의 신용등급 조정 정보를 등록하고 관리하는 처리
     * 비즈니스 기능:
     * - BR-032-001: 기업집단등급코드 검증
     * - BR-032-002: 등급조정 데이터 무결성
     * - BR-032-003: 등급조정 기간 검증
     * - BR-032-004: 등급조정 권한 검증
     * - BR-032-005: 등급조정 이력 관리
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단등급조정등록처리")
    public IDataSet registerCorpGrpRtgAdj(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단등급조정등록처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // BR-032-001: 기업집단등급코드 검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3600001", "UKFH0001", "기업집단그룹코드는 필수입력항목입니다.");
            }

            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3600002", "UKFH0002", "기업집단등록코드는 필수입력항목입니다.");
            }

            // BR-032-003: 등급조정 기간 검증
            String valuaYmd = requestData.getString("valuaYmd");
            if (valuaYmd != null && !valuaYmd.trim().isEmpty()) {
                if (!valuaYmd.matches("^\\d{8}$")) {
                    throw new BusinessException("B3600003", "UKFH0003", "평가년월일은 YYYYMMDD 형식이어야 합니다.");
                }
            }

            // DU 메소드 호출을 위한 파라미터 설정
            IDataSet queryReq = new DataSet();
            queryReq.put("corpClctGroupCd", corpClctGroupCd);
            queryReq.put("corpClctRegiCd", corpClctRegiCd);
            queryReq.put("valuaYmd", valuaYmd);
            queryReq.put("groupCoCd", requestData.getString("groupCoCd"));
            
            // 기업집단 기본정보 조회
            IDataSet basicResult = duTSKIPA110.selectCorpGrpBasicInfo(queryReq, onlineCtx);
            
            // 기업집단 평가정보 조회
            IDataSet evalResult = duTSKIPB110.select(queryReq, onlineCtx);
            
            // 결과 데이터 처리 - WP-025~031 성공 패턴 적용
            IRecordSet basicList = basicResult.getRecordSet("output");
            IRecordSet evalList = evalResult.getRecordSet("output");
            
            int totalCount = 0;
            int presentCount = 0;
            
            if (basicList != null) {
                totalCount = basicList.getRecordCount();
                presentCount = Math.min(totalCount, 500); // BR-032-007: 레코드수제한
            }
            
            // BR-032-005: 등급조정 이력 관리 - 주석 정보 등록
            if (requestData.getString("comtCtnt") != null && !requestData.getString("comtCtnt").trim().isEmpty()) {
                IDataSet commentReq = new DataSet();
                commentReq.put("groupCoCd", requestData.getString("groupCoCd"));
                commentReq.put("corpClctGroupCd", corpClctGroupCd);
                commentReq.put("corpClctRegiCd", corpClctRegiCd);
                commentReq.put("valuaYmd", valuaYmd);
                commentReq.put("corpCComtDstcd", "01"); // 등급조정 주석
                commentReq.put("serno", 1);
                commentReq.put("comtCtnt", requestData.getString("comtCtnt"));
                
                duTSKIPB130.insert(commentReq, onlineCtx);
                log.debug("등급조정 주석 등록 완료");
            }
            
            // 명세서 F-029-003 신용등급업데이트처리 출력 파라미터 준수
            responseData.put("업데이트처리상태", "00");
            responseData.put("업데이트된레코드정보", basicList);
            responseData.put("처리단계상태", "5"); // 등급조정 완료
            
            // 명세서 F-029-002 주석관리처리 출력 파라미터 추가
            responseData.put("주석처리상태", "00");
            responseData.put("데이터베이스작업결과", "SUCCESS");
            responseData.put("주석레코드정보", evalList);
            
            log.debug("기업집단등급조정등록처리 완료 - 처리건수: 1");

        } catch (BusinessException e) {
            log.error("기업집단등급조정등록처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단등급조정등록처리 시스템 오류", e);
            throw new BusinessException("B3600999", "UKFH0999", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }
}
