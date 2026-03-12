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
 * 승인결의록 조회 FU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단 승인결의록 조회 기능을 위한 기능 단위
 * 업무 기능:
 * - 기업집단 승인결의록 기본정보 조회
 * - 승인위원회 요약정보 조회
 * - 위원명세 및 승인의견 조회
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
@BizUnit(value = "승인결의록조회", type = "FU")
public class FUAppvlRslnInq extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPB110 duTSKIPB110;
    @BizUnitBind private DUTSKIPB131 duTSKIPB131;
    @BizUnitBind private DUTSKIPB132 duTSKIPB132;
    @BizUnitBind private DUTSKIPB133 duTSKIPB133;

    /**
     * 기업집단 승인결의록 조회.
     * <pre>
     * 메소드 설명 : 기업집단 승인결의록 전체 정보를 조회하여 반환
     * 
     * 처리 순서:
     * 1. 입력 파라미터 검증
     * 2. 기업집단 기본정보 조회 (TSKIPB110)
     * 3. 승인위원회 요약정보 조회 (TSKIPB131)
     * 4. 위원명세정보 조회 (TSKIPB132)
     * 5. 승인의견정보 조회 (TSKIPB133)
     * 6. 결과 데이터 조립 및 반환
     * 
     * 입력 파라미터:
     * - prcssDstcd: 처리구분코드
     * - groupCoCd: 그룹회사코드
     * - corpClctGroupCd: 기업집단그룹코드
     * - corpClctRegiCd: 기업집단등록코드
     * - valuaYmd: 평가년월일
     * 
     * 출력 파라미터:
     * - 기업집단기본정보 (단건)
     * - 승인위원회요약정보 (단건)
     * - 위원명세정보 (그리드, 최대 100건)
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리 결과 데이터
     */
    @BizMethod("승인결의록조회")
    public IDataSet inquireApprovalResolution(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("승인결의록조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 1. 입력 파라미터 검증
            validateInputParameters(requestData);
            
            // 2. 기업집단 기본정보 조회
            IDataSet basicInfoResult = duTSKIPB110.select(requestData, onlineCtx);
            IRecordSet basicInfoRecordSet = (IRecordSet) basicInfoResult.get("LIST");
            if (basicInfoRecordSet == null || basicInfoRecordSet.getRecordCount() == 0) {
                throw new BusinessException("B3400001", "UKIP0015", "기업집단 식별 파라미터 및 평가일자를 확인하여 주시기 바랍니다.");
            }
            
            // 3. 승인위원회 요약정보 조회
            IDataSet summaryResult = duTSKIPB131.select(requestData, onlineCtx);
            IRecordSet summaryRecordSet = summaryResult.getRecordSet("output");
            
            // 4. 위원명세정보 조회 (최대 100건 제한)
            IDataSet memberResult = duTSKIPB132.selectList(requestData, onlineCtx);
            IRecordSet memberRecordSet = (IRecordSet) memberResult.get("LIST");
            
            // 5. 승인의견정보 조회
            IDataSet opinionResult = duTSKIPB133.selectList(requestData, onlineCtx);
            IRecordSet opinionRecordSet = (IRecordSet) opinionResult.get("LIST");
            
            // 6. 결과 데이터 조립
            assembleResponseData(responseData, basicInfoRecordSet, summaryRecordSet, memberRecordSet, opinionRecordSet);
            
            log.debug("승인결의록조회 완료");
            
        } catch (BusinessException e) {
            log.error("승인결의록조회 업무 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("승인결의록조회 시스템 오류: " + e.getMessage());
            throw new BusinessException("B3500001", "UKII0290", "잠시 후 트랜잭션을 재시도하거나 시스템 관리자에게 문의하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }
    
    /**
     * 입력 파라미터 검증.
     * 
     * @param requestData 요청 데이터
     */
    private void validateInputParameters(IDataSet requestData) {
        // BR-044-001: 처리구분코드 검증
        String prcssDstcd = requestData.getString("prcssDstcd");
        if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
            throw new BusinessException("B3000070", "UKII0126", "처리구분 문제에 대해 시스템 관리자에게 문의하여 주시기 바랍니다.");
        }
        
        // BR-044-002: 기업집단식별검증
        String groupCoCd = requestData.getString("groupCoCd");
        if (groupCoCd == null || groupCoCd.trim().isEmpty()) {
            throw new BusinessException("B3800001", "UKIP0001", "유효한 그룹회사코드를 입력하고 트랜잭션을 재시도하여 주시기 바랍니다.");
        }
        
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3800002", "UKIP0002", "유효한 기업집단코드를 입력하고 트랜잭션을 재시도하여 주시기 바랍니다.");
        }
        
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3800003", "UKIP0003", "유효한 기업집단등록코드를 입력하고 트랜잭션을 재시도하여 주시기 바랍니다.");
        }
        
        // BR-044-003: 평가일자검증
        String valuaYmd = requestData.getString("valuaYmd");
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0004", "YYYYMMDD 형식으로 평가일자를 입력하고 트랜잭션을 재시도하여 주시기 바랍니다.");
        }
    }
    
    /**
     * 응답 데이터 조립.
     * 
     * @param responseData 응답 데이터
     * @param basicInfoRecordSet 기본정보 레코드셋
     * @param summaryRecordSet 요약정보 레코드셋
     * @param memberRecordSet 위원명세 레코드셋
     * @param opinionRecordSet 승인의견 레코드셋
     */
    private void assembleResponseData(IDataSet responseData, IRecordSet basicInfoRecordSet, IRecordSet summaryRecordSet, 
                                    IRecordSet memberRecordSet, IRecordSet opinionRecordSet) {
        
        // 기본정보 설정
        if (basicInfoRecordSet != null && basicInfoRecordSet.getRecordCount() > 0) {
            IRecord basicInfo = basicInfoRecordSet.getRecord(0);
            responseData.put("corpClctName", basicInfo.getString("corpClctName"));
            responseData.put("mainDebtAffltYn", basicInfo.getString("mainDebtAffltYn"));
            responseData.put("corpCValuaDstcd", basicInfo.getString("corpCValuaDstcd"));
            responseData.put("valuaDefinsYmd", basicInfo.getString("valuaDefinsYmd"));
            responseData.put("valuaBaseYmd", basicInfo.getString("valuaBaseYmd"));
            responseData.put("fnafScor", basicInfo.getString("fnafScor"));
            responseData.put("nonFnafScor", basicInfo.getString("nonFnafScor"));
            responseData.put("chsnScor", basicInfo.getString("chsnScor"));
            responseData.put("spareCGrdDstcd", basicInfo.getString("spareCGrdDstcd"));
            responseData.put("lastClctGrdDstcd", basicInfo.getString("lastClctGrdDstcd"));
            responseData.put("valdYmd", basicInfo.getString("valdYmd"));
            responseData.put("valuaEmpid", basicInfo.getString("valuaEmpid"));
            responseData.put("valuaEmnm", basicInfo.getString("valuaEmnm"));
            responseData.put("valuaBrncd", basicInfo.getString("valuaBrncd"));
            responseData.put("mgtBrncd", basicInfo.getString("mgtBrncd"));
        }
        
        // 요약정보 설정
        if (summaryRecordSet != null && summaryRecordSet.getRecordCount() > 0) {
            IRecord summaryInfo = summaryRecordSet.getRecord(0);
            responseData.put("valuaBrnName", summaryInfo.getString("valuaBrnName"));
            responseData.put("enrlCmmbCnt", summaryInfo.getString("enrlCmmbCnt"));
            responseData.put("attndCmmbCnt", summaryInfo.getString("attndCmmbCnt"));
            responseData.put("athorCmmbCnt", summaryInfo.getString("athorCmmbCnt"));
            responseData.put("notAthorCmmbCnt", summaryInfo.getString("notAthorCmmbCnt"));
            responseData.put("mtagDstcd", summaryInfo.getString("mtagDstcd"));
            responseData.put("cmpreAthorDstcd", summaryInfo.getString("cmpreAthorDstcd"));
            responseData.put("prevGrd", summaryInfo.getString("prevGrd"));
            responseData.put("athorBrnName", summaryInfo.getString("athorBrnName"));
            responseData.put("athorYmd", summaryInfo.getString("athorYmd"));
        }
        
        // 그리드 데이터 조립 (위원명세 + 승인의견)
        java.util.List<IDataSet> gridList = new java.util.ArrayList<>();
        
        // BR-044-006: 레코드수 제한 (최대 100건)
        int memberCount = (memberRecordSet != null) ? memberRecordSet.getRecordCount() : 0;
        int maxCount = Math.min(memberCount, 100);
        
        responseData.put("totalNoitm", String.valueOf(memberCount));
        responseData.put("prsntNoitm", String.valueOf(maxCount));
        
        if (memberRecordSet != null) {
            for (int i = 0; i < maxCount; i++) {
                IRecord memberRecord = memberRecordSet.getRecord(i);
                IDataSet gridRecord = new DataSet();
                
                // 위원정보 설정
                gridRecord.put("athorCmmbDstcd", memberRecord.getString("athorCmmbDstcd"));
                gridRecord.put("athorCmmbEmpid", memberRecord.getString("athorCmmbEmpid"));
                gridRecord.put("athorCmmbEmnm", memberRecord.getString("athorCmmbEmnm"));
                gridRecord.put("athorDstcd", memberRecord.getString("athorDstcd"));
                
                // 해당 위원의 승인의견 찾기
                String empid = memberRecord.getString("athorCmmbEmpid");
                if (opinionRecordSet != null) {
                    for (int j = 0; j < opinionRecordSet.getRecordCount(); j++) {
                        IRecord opinionRecord = opinionRecordSet.getRecord(j);
                        if (empid.equals(opinionRecord.getString("athorCmmbEmpid"))) {
                            gridRecord.put("athorOpinCtnt", opinionRecord.getString("athorOpinCtnt"));
                            gridRecord.put("serno", opinionRecord.getString("serno"));
                            break;
                        }
                    }
                }
                
                gridList.add(gridRecord);
            }
        }
        
        responseData.put("Grid1", gridList);
    }
}
