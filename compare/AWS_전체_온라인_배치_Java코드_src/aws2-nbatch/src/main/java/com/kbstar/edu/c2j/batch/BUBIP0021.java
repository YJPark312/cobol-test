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
 * 기업집단 합산재무제표생성 (Corporate Group Consolidated Financial Statement Generation)
 * <pre>
 * BIP0021 - 기업집단 합산재무제표생성 배치 프로그램
 * 기업집단별 계열사의 개별재무제표를 집계하여 합산재무제표를 생성
 * 다년도(4년 범위) 재무데이터 처리를 통한 포괄적 재무분석 지원
 * </pre>
 * @author MultiQ4KBBank
 * @since 2025-10-01
 */
@BizBatch("기업집단합산재무제표생성")
public class BUBIP0021 extends com.kbstar.sqc.batch.base.BatchUnit {
    
    // 비즈니스 상수
    private static final String GROUP_CO_CD = "KB0";
    private static final String FNAF_STLACC_DSTCD = "1";
    private static final String FNAF_ORGL_DSTCD_SUM = "S";
    private static final String FNST_FXDFM_DSTCD = "1";
    private static final String BATCH_USER_ID = "BIP0021";
    
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
    private String fourYearBaseDate;         // 4년기준년월일
    private String calcBaseDate;             // 계산기준년월일
    
    // 처리 카운터들
    private int corpGroupCount = 0;          // 기업집단처리건수
    private int settlementYearCount = 0;     // 결산년처리건수
    private int customerCount = 0;           // 고객처리건수
    private int instanceCount = 0;           // 인스턴스처리건수
    private int insertCount = 0;             // 입력건수
    private int deleteCount = 0;             // 삭제건수
    
    /**
     * F-009-001: 처리환경초기화
     * 배치 전처리 메소드 - 매개변수 설정 및 초기화
     */
    @Override
    public void beforeExecute() {
        this.log = context.getLogger();
        
        log.info("=== BIP0021 기업집단합산재무제표생성 배치 시작 ===");
        
        try {
            // 매개변수 초기화
            initializeParameters();
            
            // DB 세션 초기화
            initializeDBSessions();
            
            log.info("처리환경초기화 완료 - 작업기준일자: " + workBaseDate + ", 기준년: " + baseYear);
            
        } catch (Exception e) {
            log.error("처리환경초기화 중 오류 발생", e);
            throw new BusinessException("BIP0021-011", "처리환경초기화 실패: " + e.getMessage());
        }
    }
    
    /**
     * F-009-002: 처리대상기업집단선택 및 전체 처리 흐름
     * 배치 메인 메소드 - 기업집단별 합산재무제표 생성
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
            throw new BusinessException("BIP0021-099", "시스템 오류: " + e.getMessage());
        }
    }
    
    /**
     * F-009-006: 처리결과보고
     * 배치 후처리 메소드 - 리소스 정리 및 통계 출력
     */
    @Override
    public void afterExecute() {
        try {
            // DB 세션 정리
            cleanupDBSessions();
            
            log.info("=== BIP0021 기업집단합산재무제표생성 배치 완료 ===");
            log.info("총 처리 통계:");
            log.info("- 기업집단 처리건수: " + corpGroupCount);
            log.info("- 결산년 처리건수: " + settlementYearCount);
            log.info("- 고객 처리건수: " + customerCount);
            log.info("- 인스턴스 처리건수: " + instanceCount);
            log.info("- 삽입건수: " + insertCount);
            log.info("- 삭제건수: " + deleteCount);
            
        } catch (Exception e) {
            log.error("배치 후처리 중 오류 발생", e);
        }
    }
    
    /**
     * 매개변수 초기화
     */
    private void initializeParameters() {
        // SYSIN 매개변수에서 작업기준일자 추출
        this.workBaseDate = context.getInParameter("WORK_BASE_DATE");
        
        if (workBaseDate == null || workBaseDate.trim().isEmpty()) {
            throw new BusinessException("BIP0021-011", "입력일자가 공백입니다");
        }
        
        // 기준년 설정 (작업기준일자의 첫 4자리)
        this.baseYear = workBaseDate.substring(0, 4);
        
        log.info("매개변수 초기화 완료 - workBaseDate: " + workBaseDate + ", baseYear: " + baseYear);
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
            throw new BusinessException("BIP0021-021", "DB 세션 초기화 실패: " + e.getMessage());
        }
    }
    
    /**
     * 입력 매개변수 검증 (BR-009-008)
     */
    private void validateInputParameters() {
        if (workBaseDate == null || workBaseDate.trim().isEmpty()) {
            throw new BusinessException("BIP0021-011", "작업기준일자가 공백입니다");
        }
        
        if (baseYear == null || baseYear.trim().isEmpty()) {
            throw new BusinessException("BIP0021-011", "기준년이 공백입니다");
        }
        
        log.info("입력 매개변수 검증 완료");
    }
    
    /**
     * F-009-002: 처리대상기업집단선택 및 처리
     */
    private void processCorpGroups() {
        log.info("기업집단 처리 시작");
        
        try {
            // 기업집단 선택 쿼리 실행
            Map<String, Object> params = new HashMap<>();
            params.put("groupCoCd", GROUP_CO_CD);
            
            dbSelect("selectCorpGroups", params, new AbsRecordHandler(this) {
                @Override
                public void handleRecord(IRecord record) {
                    try {
                        processCorpGroup(record);
                        corpGroupCount++;
                    } catch (Exception e) {
                        log.error("기업집단 처리 중 오류 발생", e);
                        throw new BusinessException("BIP0021-022", "기업집단 처리 오류: " + e.getMessage());
                    }
                }
            }, readSession);
            
        } catch (Exception e) {
            log.error("기업집단 선택 중 오류 발생", e);
            throw new BusinessException("BIP0021-021", "기업집단 선택 오류: " + e.getMessage());
        }
        
        log.info("기업집단 처리 완료 - 처리건수: " + corpGroupCount);
    }
    
    /**
     * 개별 기업집단 처리
     */
    private void processCorpGroup(IRecord corpGroupRecord) {
        String corpClctGroupCd = corpGroupRecord.getString("corpClctGroupCd");
        String corpClctRegiCd = corpGroupRecord.getString("corpClctRegiCd");
        String baseYm = corpGroupRecord.getString("baseYm");
        
        log.info("기업집단 처리 시작 - 그룹코드: " + corpClctGroupCd + ", 등록코드: " + corpClctRegiCd);
        
        try {
            // F-009-002: 다년도날짜계산
            calculateMultiYearDates(baseYm);
            
            // F-009-003: 기존합산재무제표삭제
            deleteExistingConsolidatedStatements(corpClctGroupCd, corpClctRegiCd);
            
            // 4년 범위 처리 (BR-009-002)
            for (int yearOffset = 3; yearOffset >= 0; yearOffset--) {
                int targetYear = Integer.parseInt(baseYear) - yearOffset;
                processSettlementYear(corpClctGroupCd, corpClctRegiCd, String.valueOf(targetYear));
            }
            
        } catch (Exception e) {
            log.error("기업집단 처리 중 오류 발생 - 그룹코드: " + corpClctGroupCd, e);
            throw new BusinessException("BIP0021-023", "기업집단 처리 오류: " + e.getMessage());
        }
    }
    
    /**
     * F-009-002: 다년도날짜계산기능
     */
    private void calculateMultiYearDates(String baseYm) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("baseYm", baseYm);
            
            final String[] result = new String[2];
            
            dbSelect("calculateMultiYearDates", params, new AbsRecordHandler(this) {
                @Override
                public void handleRecord(IRecord record) {
                    result[0] = record.getString("calcBaseDate");
                    result[1] = record.getString("fourYearBaseDate");
                }
            }, readSession);
            
            this.calcBaseDate = result[0];
            this.fourYearBaseDate = result[1];
            
            log.info("다년도 날짜 계산 완료 - 계산기준일: " + calcBaseDate + ", 4년기준일: " + fourYearBaseDate);
            
        } catch (Exception e) {
            log.error("다년도 날짜 계산 중 오류 발생", e);
            throw new BusinessException("BIP0021-024", "날짜 계산 오류: " + e.getMessage());
        }
    }
    
    /**
     * F-009-008: 기존데이터정리기능
     */
    private void deleteExistingConsolidatedStatements(String corpClctGroupCd, String corpClctRegiCd) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("groupCoCd", GROUP_CO_CD);
            params.put("corpClctGroupCd", corpClctGroupCd);
            params.put("corpClctRegiCd", corpClctRegiCd);
            params.put("baseYr", baseYear);
            params.put("fnafAStlaccDstcd", FNAF_STLACC_DSTCD);
            
            int deletedCount = dbDelete("deleteExistingConsolidatedStatements", params, writeSession);
            deleteCount += deletedCount;
            
            log.info("기존 합산재무제표 삭제 완료 - 삭제건수: " + deletedCount);
            
        } catch (Exception e) {
            log.error("기존 합산재무제표 삭제 중 오류 발생", e);
            throw new BusinessException("BIP0021-025", "기존 데이터 삭제 오류: " + e.getMessage());
        }
    }
    
    /**
     * 결산년별 처리
     */
    private void processSettlementYear(String corpClctGroupCd, String corpClctRegiCd, String stlaccYr) {
        log.info("결산년 처리 시작 - 결산년: " + stlaccYr);
        
        try {
            // 계산기준일 설정
            String yearCalcBaseDate = stlaccYr + "1231";
            
            // F-009-003: 계열사선택기능
            processAffiliates(corpClctGroupCd, corpClctRegiCd, stlaccYr, yearCalcBaseDate);
            
            // F-009-007: 합산재무제표생성기능
            generateConsolidatedFinancialStatement(corpClctGroupCd, corpClctRegiCd, stlaccYr);
            
            settlementYearCount++;
            
        } catch (Exception e) {
            log.error("결산년 처리 중 오류 발생 - 결산년: " + stlaccYr, e);
            throw new BusinessException("BIP0021-026", "결산년 처리 오류: " + e.getMessage());
        }
    }
    
    /**
     * F-009-003: 계열사선택 및 개별재무제표처리
     */
    private void processAffiliates(String corpClctGroupCd, String corpClctRegiCd, String stlaccYr, String calcBaseDate) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("groupCoCd", GROUP_CO_CD);
            params.put("corpClctGroupCd", corpClctGroupCd);
            params.put("corpClctRegiCd", corpClctRegiCd);
            params.put("stlaccYr", stlaccYr);
            
            dbSelect("selectAffiliates", params, new AbsRecordHandler(this) {
                @Override
                public void handleRecord(IRecord record) {
                    try {
                        processIndividualFinancialStatement(record, calcBaseDate);
                        customerCount++;
                    } catch (Exception e) {
                        log.error("계열사 처리 중 오류 발생", e);
                        throw new BusinessException("BIP0021-027", "계열사 처리 오류: " + e.getMessage());
                    }
                }
            }, readSession);
            
        } catch (Exception e) {
            log.error("계열사 선택 중 오류 발생", e);
            throw new BusinessException("BIP0021-028", "계열사 선택 오류: " + e.getMessage());
        }
    }
    
    /**
     * F-009-004, F-009-005: 개별재무제표처리 (당행/외부)
     */
    private void processIndividualFinancialStatement(IRecord affiliateRecord, String calcBaseDate) {
        String exmtnCustIdnfr = affiliateRecord.getString("exmtnCustIdnfr");
        
        try {
            // F-009-004: 당행재무제표처리기능
            boolean ownBankDataExists = processOwnBankFinancialStatement(exmtnCustIdnfr, calcBaseDate);
            
            if (!ownBankDataExists) {
                // F-009-005: 외부재무제표처리기능
                processExternalFinancialStatement(exmtnCustIdnfr, calcBaseDate);
            }
            
        } catch (Exception e) {
            log.error("개별재무제표 처리 중 오류 발생 - 고객식별자: " + exmtnCustIdnfr, e);
            throw new BusinessException("BIP0021-029", "개별재무제표 처리 오류: " + e.getMessage());
        }
    }
    
    /**
     * F-009-004: 당행재무제표처리기능
     */
    private boolean processOwnBankFinancialStatement(String exmtnCustIdnfr, String calcBaseDate) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("groupCoCd", GROUP_CO_CD);
            params.put("exmtnCustIdnfr", exmtnCustIdnfr);
            params.put("calcBaseDate", calcBaseDate);
            params.put("startDate", getStartDate(calcBaseDate));
            
            final boolean[] hasData = {false};
            final IRecord[] ownBankRecord = {null};
            
            dbSelect("selectOwnBankFinancialStatement", params, new AbsRecordHandler(this) {
                @Override
                public void handleRecord(IRecord record) {
                    ownBankRecord[0] = record;
                    hasData[0] = true;
                }
            }, readSession);
            
            if (hasData[0] && ownBankRecord[0] != null) {
                // F-009-006: 개별재무제표저장기능
                saveIndividualFinancialStatement(ownBankRecord[0], "1");
                instanceCount++;
                return true;
            }
            
            return false;
            
        } catch (Exception e) {
            log.error("당행 재무제표 처리 중 오류 발생", e);
            throw new BusinessException("BIP0021-030", "당행 재무제표 처리 오류: " + e.getMessage());
        }
    }
    
    /**
     * F-009-005: 외부재무제표처리기능
     */
    private void processExternalFinancialStatement(String exmtnCustIdnfr, String calcBaseDate) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("groupCoCd", GROUP_CO_CD);
            params.put("fnafAnlsBkdataNo", "07" + exmtnCustIdnfr);
            params.put("calcBaseDate", calcBaseDate);
            params.put("startDate", getStartDate(calcBaseDate));
            
            final IRecord[] externalRecord = {null};
            
            dbSelect("selectExternalFinancialStatement", params, new AbsRecordHandler(this) {
                @Override
                public void handleRecord(IRecord record) {
                    externalRecord[0] = record;
                }
            }, readSession);
            
            if (externalRecord[0] != null) {
                // F-009-006: 개별재무제표저장기능
                saveIndividualFinancialStatement(externalRecord[0], externalRecord[0].getString("fnafAbOrglDstcd"));
                instanceCount++;
            }
            
        } catch (Exception e) {
            log.error("외부 재무제표 처리 중 오류 발생", e);
            throw new BusinessException("BIP0021-031", "외부 재무제표 처리 오류: " + e.getMessage());
        }
    }
    
    /**
     * F-009-006: 개별재무제표저장기능
     */
    private void saveIndividualFinancialStatement(IRecord financialRecord, String fnafAbOrglDstcd) {
        try {
            Map<String, Object> params = new HashMap<>();
            // 재무제표 데이터 매핑
            params.put("groupCoCd", GROUP_CO_CD);
            params.put("corpClctGroupCd", financialRecord.getString("corpClctGroupCd"));
            params.put("corpClctRegiCd", financialRecord.getString("corpClctRegiCd"));
            params.put("fnafAStlaccDstcd", FNAF_STLACC_DSTCD);
            params.put("baseYr", baseYear);
            params.put("stlaccYr", financialRecord.getString("stlaccYr"));
            params.put("fnafARptdocDstcd", financialRecord.getString("fnafARptdocDstcd"));
            params.put("fnafItemCd", financialRecord.getString("fnafItemCd"));
            params.put("fnafAbOrglDstcd", fnafAbOrglDstcd);
            params.put("fnstItemAmt", financialRecord.getLong("fnstItemAmt"));
            params.put("fnafItemCmrt", financialRecord.getBigDecimal("fnafItemCmrt"));
            params.put("stlaccYsEntpCnt", 1);
            params.put("sysLastUno", BATCH_USER_ID);
            
            // BR-009-004: 재무데이터검증규칙 - 0이 아닌 경우만 저장
            Long fnstItemAmt = financialRecord.getLong("fnstItemAmt");
            if (fnstItemAmt != null && fnstItemAmt != 0) {
                int insertedCount = dbInsert("insertIndividualFinancialStatement", params, writeSession);
                insertCount += insertedCount;
            }
            
        } catch (Exception e) {
            log.error("개별재무제표 저장 중 오류 발생", e);
            throw new BusinessException("BIP0021-032", "개별재무제표 저장 오류: " + e.getMessage());
        }
    }
    
    /**
     * F-009-007: 합산재무제표생성기능
     */
    private void generateConsolidatedFinancialStatement(String corpClctGroupCd, String corpClctRegiCd, String stlaccYr) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("groupCoCd", GROUP_CO_CD);
            params.put("corpClctGroupCd", corpClctGroupCd);
            params.put("corpClctRegiCd", corpClctRegiCd);
            params.put("baseYr", baseYear);
            params.put("stlaccYr", stlaccYr);
            params.put("fnafAStlaccDstcd", FNAF_STLACC_DSTCD);
            params.put("fnafAbOrglDstcd", FNAF_ORGL_DSTCD_SUM);
            params.put("sysLastUno", BATCH_USER_ID);
            
            int consolidatedCount = dbInsert("insertConsolidatedFinancialStatement", params, writeSession);
            insertCount += consolidatedCount;
            
            log.info("합산재무제표 생성 완료 - 결산년: " + stlaccYr + ", 생성건수: " + consolidatedCount);
            
        } catch (Exception e) {
            log.error("합산재무제표 생성 중 오류 발생", e);
            throw new BusinessException("BIP0021-033", "합산재무제표 생성 오류: " + e.getMessage());
        }
    }
    
    /**
     * 시작일자 계산 (BR-009-010)
     */
    private String getStartDate(String calcBaseDate) {
        try {
            int year = Integer.parseInt(calcBaseDate.substring(0, 4));
            return (year - 1) + "0101";
        } catch (Exception e) {
            log.error("시작일자 계산 중 오류 발생", e);
            return calcBaseDate;
        }
    }
    
    /**
     * 처리 통계 출력
     */
    private void displayProcessingStatistics() {
        log.info("=== 처리 통계 ===");
        log.info("기업집단 처리건수: " + corpGroupCount);
        log.info("결산년 처리건수: " + settlementYearCount);
        log.info("고객 처리건수: " + customerCount);
        log.info("인스턴스 처리건수: " + instanceCount);
        log.info("삽입건수: " + insertCount);
        log.info("삭제건수: " + deleteCount);
    }
    
    /**
     * DB 세션 정리
     */
    private void cleanupDBSessions() {
        // nKESA 프레임워크에서 세션 관리는 자동으로 처리됨
        log.info("배치 처리 완료");
    }
}
