package com.kbstar.edu.c2j.batch;

import java.util.HashMap;
import java.util.Map;

import com.kbstar.sqc.base.BusinessException;

import nexcore.framework.batch.BatchProfile;
import nexcore.framework.batch.appbase.AbsRecordHandler;
import nexcore.framework.batch.appbase.DBSession;
import nexcore.framework.core.component.streotype.BizBatch;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.log.ILog;

/**
 * 기업집단 합산연결재무제표생성 (Corporate Group Consolidated Financial Statement Generation)
 * <pre>
 * BIP0028 - 기업집단 합산연결재무제표생성 배치 프로그램
 * 기업집단별 계열사의 개별/연결재무제표를 집계하여 합산연결재무제표를 생성
 * </pre>
 * @author MultiQ4KBBank
 * @since 2025-10-01
 */
@BizBatch("기업집단합산연결재무제표생성")
public class BUBIP0028 extends com.kbstar.sqc.batch.base.BatchUnit {
    
    // 비즈니스 상수
    private static final String GROUP_CO_CD = "KB0";
    private static final String FNAF_STLACC_DSTCD = "1";
    private static final String BATCH_USER_ID = "BIP0028";
    private static final String REPORT_TYPE_PREFIX = "1";
    
    // 로거
    private ILog log;
    
    // 배치 프로파일
    private BatchProfile profile;
    
    // DB 세션 관리
    private DBSession readSession;
    private DBSession writeSession;
    
    // 작업 변수들
    private String workBaseDate;             // 작업기준일자
    private String baseYear;                 // 기준년
    private String baseYmd;                  // 기준년월일
    private String fourYearBaseYmd;          // 4년기준년월일
    private int calcFourYear;                // 계산4년
    
    // 처리 카운터들
    private int corpGroupCount = 0;          // 기업집단처리건수
    private int settlementYearCount = 0;     // 결산년처리건수
    private int custCount = 0;               // 고객수
    private int instCount = 0;               // 인스턴스수
    private int insertCount = 0;             // 입력건수
    private int deleteCount = 0;             // 삭제건수
    
    /**
     * F-010-001: 처리환경초기화
     * 배치 전처리 메소드 - 매개변수 설정 및 초기화
     */
    @Override
    public void beforeExecute() {
        this.log = context.getLogger();
        
        log.info("=== BIP0028 기업집단합산연결재무제표생성 배치 시작 ===");
        
        try {
            // 매개변수 초기화
            initializeParameters();
            
            // DB 세션 초기화
            initializeDBSessions();
            
            log.info("처리환경초기화 완료 - 작업기준일자: " + workBaseDate + ", 기준년: " + baseYear);
            
        } catch (Exception e) {
            log.error("처리환경초기화 중 오류 발생", e);
            throw new BusinessException("BIP0028-011", "처리환경초기화 실패: " + e.getMessage());
        }
    }
    
    /**
     * F-010-002: 처리대상기업집단선택 및 전체 처리 흐름
     * 배치 메인 메소드 - 기업집단별 합산연결재무제표 생성
     */
    @Override
    public void execute() {
        try {
            // 입력 매개변수 검증
            validateInputParameters();
            
            // 기업집단별 처리
            processCorpGroups();
            
            // 처리 결과 보고
            displayProcessingStatistics();
            
        } catch (BusinessException e) {
            log.error("배치 처리 중 비즈니스 오류 발생", e);
            throw e;
        } catch (Exception e) {
            log.error("배치 처리 중 시스템 오류 발생", e);
            throw new BusinessException("BIP0028-031", "배치 처리 실패: " + e.getMessage());
        }
    }
    
    /**
     * 배치 후처리 메소드 - 리소스 정리
     */
    @Override
    public void afterExecute() {
        try {
            // nKESA 프레임워크에서 세션 관리는 자동으로 처리됨
            log.info("=== BIP0028 기업집단합산연결재무제표생성 배치 완료 ===");
            
        } catch (Exception e) {
            log.error("배치 후처리 중 오류 발생", e);
        }
    }
    
    /**
     * 매개변수 초기화
     */
    private void initializeParameters() {
        // SYSIN에서 작업기준일자 획득
        workBaseDate = context.getInParameter("WORK_BASE_DATE");
        
        if (workBaseDate != null && workBaseDate.length() >= 4) {
            baseYear = workBaseDate.substring(0, 4);
        }
        
        log.info("매개변수 초기화 - workBaseDate: " + workBaseDate + ", baseYear: " + baseYear);
    }
    
    /**
     * DB 세션 초기화
     */
    private void initializeDBSessions() {
        try {
            this.readSession = dbNewSession(false, "READ");
            this.writeSession = dbNewSession(true, "WRITE");
            log.info("DB 세션 초기화 완료");
        } catch (Exception e) {
            log.error("DB 세션 초기화 실패", e);
            throw new BusinessException("BIP0028-021", "DB 세션 초기화 실패: " + e.getMessage());
        }
    }
    
    /**
     * BR-010-009: 입력파라미터검증규칙
     * 입력 매개변수 검증
     */
    private void validateInputParameters() {
        if (workBaseDate == null || workBaseDate.trim().isEmpty()) {
            throw new BusinessException("BIP0028-011", "작업기준일자가 입력되지 않았습니다");
        }
        
        if (baseYear == null || baseYear.length() != 4) {
            throw new BusinessException("BIP0028-012", "기준년 형식이 올바르지 않습니다");
        }
        
        log.info("입력 매개변수 검증 완료");
    }
    
    /**
     * F-010-002: 처리대상기업집단선택
     * 기업집단별 처리 메인 로직
     */
    private void processCorpGroups() {
        log.info("기업집단 처리 시작");
        
        // 기업집단 선택
        Map<String, Object> params = new HashMap<>();
        params.put("groupCoCd", GROUP_CO_CD);
        
        dbSelect("selectCorpGroups", params, new AbsRecordHandler(this) {
            @Override
            public void handleRecord(IRecord record) {
                try {
                    String corpClctGroupCd = record.getString("corpClctGroupCd");
                    String corpClctRegiCd = record.getString("corpClctRegiCd");
                    String baseYm = record.getString("baseYm");
                    
                    log.info("기업집단 처리 - 그룹코드: " + corpClctGroupCd + ", 등록코드: " + corpClctRegiCd);
                    
                    // 날짜 범위 계산
                    calculateDateRanges(baseYm);
                    
                    // 기존 데이터 정리
                    deleteExistingData(corpClctGroupCd, corpClctRegiCd);
                    
                    // 다년도 처리
                    processMultipleYears(corpClctGroupCd, corpClctRegiCd);
                    
                    corpGroupCount++;
                    
                } catch (Exception e) {
                    log.error("기업집단 처리 중 오류 발생", e);
                    throw new BusinessException("BIP0028-032", "기업집단 처리 실패: " + e.getMessage());
                }
            }
        });
        
        log.info("기업집단 처리 완료 - 처리건수: " + corpGroupCount);
    }
    
    /**
     * F-010-002: 날짜범위계산기능
     * BR-010-008: 날짜범위계산규칙
     */
    private void calculateDateRanges(String baseYm) {
        Map<String, Object> params = new HashMap<>();
        params.put("baseYm", baseYm);
        
        dbSelect("calculateDateRanges", params, new AbsRecordHandler(this) {
            @Override
            public void handleRecord(IRecord record) {
                baseYmd = record.getString("baseYmd");
                fourYearBaseYmd = record.getString("fourYearBaseYmd");
                calcFourYear = Integer.parseInt(baseYear) - 3;
            }
        });
        
        log.info("날짜 범위 계산 완료 - baseYmd: " + baseYmd + ", fourYearBaseYmd: " + fourYearBaseYmd);
    }
    
    /**
     * F-010-003: 기존데이터정리기능
     * BR-010-007: 기존데이터정리규칙
     */
    private void deleteExistingData(String corpClctGroupCd, String corpClctRegiCd) {
        Map<String, Object> params = new HashMap<>();
        params.put("groupCoCd", GROUP_CO_CD);
        params.put("corpClctGroupCd", corpClctGroupCd);
        params.put("corpClctRegiCd", corpClctRegiCd);
        params.put("baseYr", baseYear);
        params.put("fnafAStlaccDstcd", FNAF_STLACC_DSTCD);
        
        // 기존 합산연결재무제표 삭제
        int deletedC130 = dbDelete("deleteExistingConsolidatedStatements", params, writeSession);
        
        // 기존 개별재무제표 삭제
        int deletedC140 = dbDelete("deleteExistingIndividualStatements", params, writeSession);
        
        deleteCount += (deletedC130 + deletedC140);
        
        log.info("기존 데이터 삭제 완료 - C130: " + deletedC130 + "건, C140: " + deletedC140 + "건");
    }
    
    /**
     * F-010-008: 다년도처리제어기능
     * BR-010-002: 다년도처리규칙
     */
    private void processMultipleYears(String corpClctGroupCd, String corpClctRegiCd) {
        log.info("다년도 처리 시작 - " + calcFourYear + "년부터 " + baseYear + "년까지");
        
        for (int year = calcFourYear; year <= Integer.parseInt(baseYear); year++) {
            custCount = 0;
            instCount = 0;
            
            String currentYear = String.valueOf(year);
            String calcBaseYmd = currentYear + baseYmd.substring(4);
            
            log.info("결산년 처리 시작 - " + currentYear + "년");
            
            // 계열사 선택 및 처리
            processAffiliates(corpClctGroupCd, corpClctRegiCd, currentYear, calcBaseYmd);
            
            // 합산재무제표 생성
            if (instCount > 0) {
                generateConsolidatedStatements(corpClctGroupCd, corpClctRegiCd, currentYear);
            }
            
            settlementYearCount++;
            log.info("결산년 처리 완료 - " + currentYear + "년, 고객수: " + custCount + ", 인스턴스수: " + instCount);
        }
    }
    
    /**
     * F-010-004: 계열사선택기능
     * 계열사 선택 및 재무제표 처리
     */
    private void processAffiliates(String corpClctGroupCd, String corpClctRegiCd, String stlaccYr, String calcBaseYmd) {
        Map<String, Object> params = new HashMap<>();
        params.put("groupCoCd", GROUP_CO_CD);
        params.put("corpClctGroupCd", corpClctGroupCd);
        params.put("corpClctRegiCd", corpClctRegiCd);
        params.put("stlaccYm", stlaccYr + "12");
        
        // 4년 전의 경우 3년 전 데이터 사용
        if (Integer.parseInt(stlaccYr) == calcFourYear) {
            params.put("stlaccYm", String.valueOf(calcFourYear + 1) + "12");
        }
        
        dbSelect("selectAffiliates", params, new AbsRecordHandler(this) {
            @Override
            public void handleRecord(IRecord record) {
                try {
                    String exmtnCustIdnfr = record.getString("exmtnCustIdnfr");
                    String mamaCCustIdnfr = record.getString("mamaCCustIdnfr");
                    
                    custCount++;
                    
                    // BR-010-003: 재무제표유형우선순위규칙
                    if (mamaCCustIdnfr == null || mamaCCustIdnfr.trim().isEmpty()) {
                        // 연결재무제표 처리
                        processConsolidatedFinancialStatements(exmtnCustIdnfr, corpClctGroupCd, corpClctRegiCd, stlaccYr, calcBaseYmd);
                    } else {
                        // 개별재무제표 처리
                        processIndividualFinancialStatements(exmtnCustIdnfr, corpClctGroupCd, corpClctRegiCd, stlaccYr, calcBaseYmd);
                    }
                    
                } catch (Exception e) {
                    log.error("계열사 처리 중 오류 발생", e);
                    // 계속 처리
                }
            }
        });
    }
    
    /**
     * F-010-005: 연결재무제표처리기능
     * BR-010-004: 재무제표출처우선순위규칙
     */
    private void processConsolidatedFinancialStatements(String exmtnCustIdnfr, String corpClctGroupCd, String corpClctRegiCd, String stlaccYr, String calcBaseYmd) {
        Map<String, Object> params = new HashMap<>();
        params.put("groupCoCd", GROUP_CO_CD);
        params.put("fnafAnlsBkdataNo", "07" + exmtnCustIdnfr);
        params.put("calcBaseYmd", calcBaseYmd);
        params.put("fromDate", String.valueOf(Integer.parseInt(calcBaseYmd) - 10000 + 1));
        params.put("toDate", calcBaseYmd);
        
        // 연결재무제표 확인 (IFRS/GAAP 우선순위)
        dbSelect("selectConsolidatedFinancialStatements", params, new AbsRecordHandler(this) {
            @Override
            public void handleRecord(IRecord record) {
                String fnafAbOrglDstcd = record.getString("fnafAbOrglDstcd");
                String stlaccBaseYmd = record.getString("stlaccBaseYmd");
                String fnstFxdfmDstcd = record.getString("fnstFxdfmDstcd");
                
                // 재무항목 처리
                processFinancialItems(exmtnCustIdnfr, corpClctGroupCd, corpClctRegiCd, stlaccYr, stlaccBaseYmd, fnafAbOrglDstcd, fnstFxdfmDstcd, true);
                instCount++;
            }
        });
    }
    
    /**
     * F-010-006: 개별재무제표처리기능
     */
    private void processIndividualFinancialStatements(String exmtnCustIdnfr, String corpClctGroupCd, String corpClctRegiCd, String stlaccYr, String calcBaseYmd) {
        Map<String, Object> params = new HashMap<>();
        params.put("groupCoCd", GROUP_CO_CD);
        params.put("exmtnCustIdnfr", exmtnCustIdnfr);
        params.put("fromDate", String.valueOf(Integer.parseInt(calcBaseYmd) - 10000 + 1));
        params.put("toDate", calcBaseYmd);
        
        // 당행 개별재무제표 확인
        dbSelect("selectBankIndividualStatements", params, new AbsRecordHandler(this) {
            @Override
            public void handleRecord(IRecord record) {
                String stlaccBaseYmd = record.getString("stlaccBaseYmd");
                String crdtVRptdocNo = record.getString("crdtVRptdocNo");
                
                // 재무항목 처리 (당행 데이터)
                processFinancialItems(exmtnCustIdnfr, corpClctGroupCd, corpClctRegiCd, stlaccYr, stlaccBaseYmd, "1", "1", false);
                instCount++;
            }
        });
        
        // 당행 데이터가 없으면 외부기관 개별재무제표 확인
        if (instCount == 0) {
            dbSelect("selectExternalIndividualStatements", params, new AbsRecordHandler(this) {
                @Override
                public void handleRecord(IRecord record) {
                    String stlaccBaseYmd = record.getString("stlaccBaseYmd");
                    String fnafAbOrglDstcd = record.getString("fnafAbOrglDstcd");
                    
                    // 재무항목 처리 (외부기관 데이터)
                    processFinancialItems(exmtnCustIdnfr, corpClctGroupCd, corpClctRegiCd, stlaccYr, stlaccBaseYmd, fnafAbOrglDstcd, "1", false);
                    instCount++;
                }
            });
        }
    }
    
    /**
     * 재무항목 처리 및 TSKIPC140 삽입
     */
    private void processFinancialItems(String exmtnCustIdnfr, String corpClctGroupCd, String corpClctRegiCd, String stlaccYr, String stlaccBaseYmd, String fnafAbOrglDstcd, String fnstFxdfmDstcd, boolean isConsolidated) {
        Map<String, Object> params = new HashMap<>();
        params.put("groupCoCd", GROUP_CO_CD);
        params.put("exmtnCustIdnfr", exmtnCustIdnfr);
        params.put("fnafAnlsBkdataNo", "07" + exmtnCustIdnfr);
        params.put("stlaccBaseYmd", stlaccBaseYmd);
        params.put("fnafAbOrglDstcd", fnafAbOrglDstcd);
        params.put("fnstFxdfmDstcd", fnstFxdfmDstcd);
        
        String queryId;
        if (isConsolidated) {
            queryId = "2".equals(fnstFxdfmDstcd) ? "selectIFRSFinancialItems" : "selectGAAPFinancialItems";
        } else {
            queryId = "1".equals(fnafAbOrglDstcd) ? "selectBankFinancialItems" : "selectExternalFinancialItems";
        }
        
        dbSelect(queryId, params, new AbsRecordHandler(this) {
            @Override
            public void handleRecord(IRecord record) {
                try {
                    Map<String, Object> insertParams = new HashMap<>();
                    insertParams.put("groupCoCd", GROUP_CO_CD);
                    insertParams.put("corpClctGroupCd", corpClctGroupCd);
                    insertParams.put("corpClctRegiCd", corpClctRegiCd);
                    insertParams.put("exmtnCustIdnfr", exmtnCustIdnfr);
                    insertParams.put("fnafAStlaccDstcd", FNAF_STLACC_DSTCD);
                    insertParams.put("baseYr", baseYear);
                    insertParams.put("stlaccYr", stlaccYr);
                    insertParams.put("fnafAbOrglDstcd", fnafAbOrglDstcd);
                    
                    String fnafARptdocDstcd = record.getString("fnafARptdocDstcd");
                    
                    // BR-010-012: 보고서구분변환규칙
                    if (isConsolidated && "2".equals(fnstFxdfmDstcd)) {
                        // IFRS 연결 데이터의 경우 보고서구분 변환
                        fnafARptdocDstcd = "2" + fnafARptdocDstcd.substring(1);
                    }
                    
                    insertParams.put("fnafARptdocDstcd", fnafARptdocDstcd);
                    insertParams.put("fnafItemCd", record.getString("fnafItemCd"));
                    insertParams.put("fnstItemAmt", record.getLong("fnstItemAmt"));
                    insertParams.put("fnafItemCmrt", 0);
                    insertParams.put("sysLastUno", BATCH_USER_ID);
                    
                    // BR-010-005: 재무데이터검증규칙 - 0이 아닌 금액만 처리
                    if (record.getLong("fnstItemAmt") != 0) {
                        int inserted = dbInsert("insertIndividualStatement", insertParams, writeSession);
                        insertCount += inserted;
                    }
                    
                } catch (Exception e) {
                    log.error("재무항목 처리 중 오류 발생", e);
                    // 계속 처리
                }
            }
        });
    }
    
    /**
     * F-010-007: 합산재무제표생성기능
     * BR-010-006: 합산재무제표생성규칙
     */
    private void generateConsolidatedStatements(String corpClctGroupCd, String corpClctRegiCd, String stlaccYr) {
        Map<String, Object> params = new HashMap<>();
        params.put("groupCoCd", GROUP_CO_CD);
        params.put("corpClctGroupCd", corpClctGroupCd);
        params.put("corpClctRegiCd", corpClctRegiCd);
        params.put("fnafAStlaccDstcd", FNAF_STLACC_DSTCD);
        params.put("baseYr", baseYear);
        params.put("stlaccYr", stlaccYr);
        params.put("custCnt", custCount);
        params.put("sysLastUno", BATCH_USER_ID);
        
        dbSelect("selectAggregatedFinancialData", params, new AbsRecordHandler(this) {
            @Override
            public void handleRecord(IRecord record) {
                try {
                    Map<String, Object> insertParams = new HashMap<>();
                    insertParams.put("groupCoCd", GROUP_CO_CD);
                    insertParams.put("corpClctGroupCd", corpClctGroupCd);
                    insertParams.put("corpClctRegiCd", corpClctRegiCd);
                    insertParams.put("fnafAStlaccDstcd", FNAF_STLACC_DSTCD);
                    insertParams.put("baseYr", baseYear);
                    insertParams.put("stlaccYr", stlaccYr);
                    
                    // BR-010-012: 보고서구분변환규칙 - 최종 합산 데이터는 '1' + 두 번째 자리
                    String originalRptdoc = record.getString("fnafARptdocDstcd");
                    String finalRptdoc = REPORT_TYPE_PREFIX + originalRptdoc.substring(1);
                    
                    insertParams.put("fnafARptdocDstcd", finalRptdoc);
                    insertParams.put("fnafItemCd", record.getString("fnafItemCd"));
                    insertParams.put("fnstItemAmt", record.getLong("fnstItemAmt"));
                    insertParams.put("fnafItemCmrt", 0);
                    insertParams.put("stlaccYsEntpCnt", custCount);
                    insertParams.put("sysLastUno", BATCH_USER_ID);
                    
                    int inserted = dbInsert("insertConsolidatedStatement", insertParams, writeSession);
                    insertCount += inserted;
                    
                } catch (Exception e) {
                    log.error("합산재무제표 생성 중 오류 발생", e);
                    // 계속 처리
                }
            }
        });
        
        log.info("합산재무제표 생성 완료 - " + stlaccYr + "년");
    }
    
    /**
     * F-010-006: 처리결과보고
     * 처리 통계 표시
     */
    private void displayProcessingStatistics() {
        log.info("=== 처리 결과 통계 ===");
        log.info("기업집단 처리건수: " + corpGroupCount);
        log.info("결산년 처리건수: " + settlementYearCount);
        log.info("총 삭제건수: " + deleteCount);
        log.info("총 입력건수: " + insertCount);
        log.info("==================");
    }
}
