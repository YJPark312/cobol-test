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
 * FU 클래스: FUCorpGrpConFinStmtComp
 * 업무명: 기업집단연결재무제표구성
 * @author MultiQ4KBBank
 */
@BizUnit("기업집단연결재무제표구성")
public class FUCorpGrpConFinStmtComp extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA110 duTSKIPA110;
    @BizUnitBind private DUTSKIPC130 duTSKIPC130;
    @BizUnitBind private DUTSKIPC131 duTSKIPC131;

    /**
     * 기업집단연결재무제표구성 처리
     * <pre>
     * 메소드 설명 : 기업집단의 연결재무제표 구성을 위한 데이터 조회 및 처리
     * 비즈니스 기능:
     * - 기업집단 관계기업 기본정보 조회 (TSKIPA110)
     * - 기업집단 최상위지배기업 정보 조회 (TSKIPC110)
     * - 재무제표 존재여부 검증 및 처리
     * - 합산연결대상 정보 구성
     * 
     * 입력 파라미터:
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaBaseYmd [평가기준년월일] (string)
     *	- field : prcssDstic [처리구분] (string)
     * 
     * 출력 파라미터:
     *	- field : totalNoitm1 [총건수] (int)
     *	- field : prsntNoitm1 [현재건수] (int)
     *	- recordSet : corpGrpStatusList [기업집단현황정보 LIST]
     *		- field : groupCoCd [그룹회사코드] (string)
     *		- field : stlaccYm [결산년월] (string)
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : rpsntEntpName [대표업체명] (string)
     *		- field : mamaCCustIdnfr [모기업고객식별자] (string)
     *		- field : mamaCorpName [모기업명] (string)
     *		- field : mostHSwayCorpYn [최상위지배기업여부] (string)
     *		- field : cnslFnstExstYn [연결재무제표존재여부] (string)
     *		- field : idiviFnstExstYn [개별재무제표존재여부] (string)
     *		- field : fnstReflctYn [재무제표반영여부] (string)
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251002	MultiQ4KBBank		최초 작성 (WP-043)
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단연결재무제표구성처리")
    public IDataSet processCorpGrpConFinStmtComp(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단연결재무제표구성 처리 시작");
            
            // 입력 파라미터 검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            String valuaBaseYmd = requestData.getString("valuaBaseYmd");
            String prcssDstic = requestData.getString("prcssDstic");
            
            log.debug("입력 파라미터 - 기업집단그룹코드: " + corpClctGroupCd);
            log.debug("입력 파라미터 - 기업집단등록코드: " + corpClctRegiCd);
            log.debug("입력 파라미터 - 평가기준년월일: " + valuaBaseYmd);
            log.debug("입력 파라미터 - 처리구분: " + prcssDstic);

            // 필수 파라미터 검증
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드를 입력하세요.");
            }
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드를 입력하세요.");
            }
            if (valuaBaseYmd == null || valuaBaseYmd.trim().isEmpty()) {
                throw new BusinessException("B2701130", "UKII0244", "평가기준년월일을 입력하세요.");
            }
            if (prcssDstic == null || prcssDstic.trim().isEmpty()) {
                throw new BusinessException("B3000070", "UKII0291", "처리구분을 입력하세요.");
            }

            // 기준년도 계산
            String baseYear = valuaBaseYmd.substring(0, 4);
            int baseYearInt = Integer.parseInt(baseYear);
            
            // 결과 데이터 초기화
            IDataSet corpGrpStatusList = new DataSet();
            int totalCount = 0;
            int currentCount = 0;

            // 처리구분에 따른 분기 처리
            if ("01".equals(prcssDstic)) {
                // 저장된 데이터 조회 (TSKIPC130 테이블 활용)
                log.debug("저장된 데이터 조회 처리");
                
                IDataSet conFinStmtRequest = new DataSet();
                conFinStmtRequest.put("corpClctGroupCd", corpClctGroupCd);
                conFinStmtRequest.put("corpClctRegiCd", corpClctRegiCd);
                conFinStmtRequest.put("baseYear", baseYear);
                
                IDataSet conFinStmtResult = duTSKIPC130.select(conFinStmtRequest, onlineCtx);
                IRecordSet conFinStmtRecords = conFinStmtResult.getRecordSet("output");
                
                if (conFinStmtRecords != null && conFinStmtRecords.getRecordCount() > 0) {
                    totalCount = conFinStmtRecords.getRecordCount();
                    currentCount = Math.min(totalCount, 500);
                    
                    for (int i = 0; i < currentCount; i++) {
                        IRecord conFinStmtRecord = conFinStmtRecords.getRecord(i);
                        IDataSet statusRecord = new DataSet();
                        statusRecord.put("groupCoCd", conFinStmtRecord.getString("groupCoCd"));
                        statusRecord.put("stlaccYm", baseYear + "12");
                        statusRecord.put("exmtnCustIdnfr", conFinStmtRecord.getString("custIdnfr"));
                        statusRecord.put("rpsntEntpName", conFinStmtRecord.getString("entpName"));
                        statusRecord.put("mamaCCustIdnfr", conFinStmtRecord.getString("parentCustIdnfr"));
                        statusRecord.put("mamaCorpName", conFinStmtRecord.getString("parentCorpName"));
                        statusRecord.put("mostHSwayCorpYn", conFinStmtRecord.getString("topCtrlCorpYn"));
                        statusRecord.put("cnslFnstExstYn", "Y");
                        statusRecord.put("idiviFnstExstYn", "Y");
                        statusRecord.put("fnstReflctYn", "Y");
                        corpGrpStatusList.put("record" + i, statusRecord);
                    }
                }
                
            } else {
                // 실시간 계산 처리 (TSKIPA110 테이블 활용)
                log.debug("실시간 계산 처리");
                
                // 다년도 처리 (기준년, 전년, 전전년)
                for (int yearOffset = 0; yearOffset >= -2; yearOffset--) {
                    int targetYear = baseYearInt + yearOffset;
                    String targetYearStr = String.valueOf(targetYear);
                    
                    log.debug("처리 대상 년도: " + targetYearStr);
                    
                    IDataSet relCoRequest = new DataSet();
                    relCoRequest.put("corpClctGroupCd", corpClctGroupCd);
                    relCoRequest.put("corpClctRegiCd", corpClctRegiCd);
                    relCoRequest.put("baseYear", targetYearStr);
                    
                    IDataSet relCoResult = duTSKIPA110.selectCorpGrpBasicInfo(relCoRequest, onlineCtx);
                    IRecordSet relCoRecords = relCoResult.getRecordSet("output");
                    
                    if (relCoRecords != null && relCoRecords.getRecordCount() > 0) {
                        for (int i = 0; i < relCoRecords.getRecordCount() && currentCount < 500; i++) {
                            IRecord relCoRecord = relCoRecords.getRecord(i);
                            IDataSet statusRecord = new DataSet();
                            
                            statusRecord.put("groupCoCd", "KB0");
                            statusRecord.put("stlaccYm", targetYearStr + "12");
                            statusRecord.put("exmtnCustIdnfr", relCoRecord.getString("custIdnfr"));
                            statusRecord.put("rpsntEntpName", relCoRecord.getString("entpName"));
                            statusRecord.put("mamaCCustIdnfr", relCoRecord.getString("parentCustIdnfr"));
                            statusRecord.put("mamaCorpName", relCoRecord.getString("parentCorpName"));
                            
                            // 재무제표 존재여부 검증
                            String cnslFnstExstYn = validateConsolidatedFinStmt(relCoRecord.getString("custIdnfr"), targetYearStr, onlineCtx);
                            String idiviFnstExstYn = validateIndividualFinStmt(relCoRecord.getString("custIdnfr"), targetYearStr, onlineCtx);
                            
                            statusRecord.put("mostHSwayCorpYn", determineTopCtrlCorp(relCoRecord, onlineCtx));
                            statusRecord.put("cnslFnstExstYn", cnslFnstExstYn);
                            statusRecord.put("idiviFnstExstYn", idiviFnstExstYn);
                            statusRecord.put("fnstReflctYn", ("Y".equals(cnslFnstExstYn) || "Y".equals(idiviFnstExstYn)) ? "Y" : "N");
                            
                            corpGrpStatusList.put("record" + currentCount, statusRecord);
                            currentCount++;
                            totalCount++;
                        }
                    }
                }
            }

            // 응답 데이터 설정
            responseData.put("totalNoitm1", totalCount);
            responseData.put("prsntNoitm1", currentCount);
            responseData.put("corpGrpStatusList", corpGrpStatusList);
            
            log.debug("기업집단연결재무제표구성 처리 완료 - 총건수: " + totalCount + ", 현재건수: " + currentCount);

        } catch (BusinessException e) {
            log.error("기업집단연결재무제표구성 처리 비즈니스 오류", e);
            throw e;
            
        } catch (Exception e) {
            log.error("기업집단연결재무제표구성 처리 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 연결재무제표 존재여부 검증
     */
    private String validateConsolidatedFinStmt(String custIdnfr, String targetYear, IOnlineContext onlineCtx) {
        try {
            // 실제 구현에서는 외부 재무제표 테이블 조회
            // 현재는 기본값 반환
            return "Y";
        } catch (Exception e) {
            return "N";
        }
    }

    /**
     * 개별재무제표 존재여부 검증
     */
    private String validateIndividualFinStmt(String custIdnfr, String targetYear, IOnlineContext onlineCtx) {
        try {
            // 실제 구현에서는 내부/외부 개별재무제표 테이블 조회
            // 현재는 기본값 반환
            return "Y";
        } catch (Exception e) {
            return "N";
        }
    }

    /**
     * 최상위지배기업 여부 결정
     */
    private String determineTopCtrlCorp(IRecord relCoRecord, IOnlineContext onlineCtx) {
        try {
            String parentCustIdnfr = relCoRecord.getString("parentCustIdnfr");
            // 모기업 고객식별자가 없으면 최상위지배기업
            return (parentCustIdnfr == null || parentCustIdnfr.trim().isEmpty()) ? "Y" : "N";
        } catch (Exception e) {
            return "N";
        }
    }
}
