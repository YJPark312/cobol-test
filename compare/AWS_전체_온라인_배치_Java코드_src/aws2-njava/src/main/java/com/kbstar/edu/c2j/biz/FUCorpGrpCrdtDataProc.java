package com.kbstar.edu.c2j.biz;

import java.math.BigDecimal;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import nexcore.framework.core.component.streotype.BizUnitBind;
import com.kbstar.sqc.base.BusinessException;
import com.kbstar.sqc.common.CommonArea;

/**
 * 기업집단신용데이터처리.
 * <pre>
 * 유닛 설명 : 기업집단신용등급모니터링 데이터 처리
 * ---------------------------------------------------------------------------------
 *  버전    일자            작성자            설명
 * ---------------------------------------------------------------------------------
 *   0.1    20250929    MultiQ4KBBank        최초 작성
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank
 * @since 2025-09-29
 */
@BizUnit(value = "기업집단신용데이터처리", type = "FU")
public class FUCorpGrpCrdtDataProc extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPB110 duTSKIPB110; // 기업집단평가기본 테이블DU

    /**
     * 기업집단신용등급조회.
     * <pre>
     * 기업집단신용등급조회
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : groupCoCd [그룹회사코드] (string)
     *    - field : inquryBaseYm [조회기준년월] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string) - optional
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *    - field : totalNoitm [총건수] (int)
     *    - field : prsntNoitm [현재건수] (int)
     *    - recordSet : LIST [기업집단평가기본 테이블 LIST]
     *        - field : corpClctGroupCd [기업집단그룹코드] (string)
     *        - field : corpClctRegiCd [기업집단등록코드] (string)
     *        - field : corpClctName [기업집단명] (string)
     *        - field : writYr [작성년] (string)
     *        - field : valuaDefinsYmd [평가확정년월일] (string)
     *        - field : valuaBaseYmd [평가기준년월일] (string)
     *        - field : lastClctGrdDstcd [최종집단등급구분] (string)
     *        - field : valdYmd [유효년월일] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-09-29
     */
    @BizMethod("기업집단신용등급조회")
    public IDataSet getCorpGrpCrdtRating(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        // CommonArea 객체 참조
        CommonArea ca = getCommonArea(onlineCtx);
        
        // BR-016-013: DC 레벨 조회기준년월 검증
        String inquryBaseYm = requestData.getString("inquryBaseYm");
        if (inquryBaseYm == null || inquryBaseYm.trim().isEmpty()) {
            // TODO: 에러코드 B3800004, 조치메시지 UKIP0001 확인 필요
            throw new BusinessException("B3800004", "UKIP0001", "조회기준년월을 입력해주세요.");
        }
        
        try {
            // BR-016-010: 공통영역 초기화 (비계약업무구분 = '060' 신평)
            ca.getJiCom().put("NON-CTRC-BZWK-DSTCD", "060");
            
            // BR-016-003: 그룹회사코드 설정 (공통영역에서 가져오기)
            String groupCoCd = ca.getBiCom().getGroupCoCd();
            requestData.put("groupCoCd", groupCoCd);
            
            // DU 호출 - 기업집단평가기본 테이블 조회 (BR-016-005: 최대 1000건 제한은 DU에서 처리)
            IDataSet duResult = duTSKIPB110.selectList(requestData, onlineCtx);
            
            // BR-016-008: 데이터 매핑 및 변환
            if (duResult.getRecordSet("LIST") != null) {
                IRecordSet recordSet = duResult.getRecordSet("LIST");
                int recordCount = recordSet.getRecordCount();
                
                // BR-016-012: 출력 파라미터 조립
                responseData.put("totalNoitm", recordCount);
                responseData.put("prsntNoitm", recordCount);
                responseData.put("LIST", recordSet);
            } else {
                responseData.put("totalNoitm", 0);
                responseData.put("prsntNoitm", 0);
            }
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            // 일반 시스템 오류
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

}
