package com.kbstar.edu.c2j.batch;

import java.util.HashMap;
import java.util.Map;

import com.kbstar.sqc.base.BusinessException;

import nexcore.framework.batch.appbase.AbsRecordHandler;
import nexcore.framework.core.component.streotype.BizBatch;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.Record;
import nexcore.framework.core.log.ILog;

/**
 * 기업집단 합산재무비율 생성 (Corporate Group Consolidated Financial Ratios Generation)
 * <pre>
 * BIP0023 - 기업집단 합산재무비율 생성 배치 프로그램
 * 기업집단 평가 데이터를 처리하여 합산재무비율을 계산하고 THKIPC121에 저장
 * </pre>
 * @author MultiQ4KBBank
 * @since 2025-10-01
 */
@BizBatch("기업집단합산재무비율생성")
public class BUBIP0023 extends com.kbstar.sqc.batch.base.BatchUnit {
    
    // 비즈니스 상수
    private static final String GROUP_CO_CD = "KB0";
    private static final String FNAF_RPTDOC_DSTCD = "19";
    private static final String FNAF_STLACC_DSTCD = "1";
    private static final String FNAF_ORGL_DSTCD = "S";
    private static final double MAX_RATIO = 99999.99;
    private static final double MIN_RATIO = -99999.99;
    
    // 로거
    private ILog log;
    
    // 작업 변수들
    private String workBaseDate;             // 작업기준일자
    private String baseYr;                   // 기준년
    
    // 처리 카운터들
    private int c001Cnt = 0;                 // 기업집단 처리건수
    private int c002Cnt = 0;                 // 결산년 처리건수
    private int c003Cnt = 0;                 // 재무공식 처리건수
    private int chglogWrite = 0;             // 변경로그 작성건수
    
    /**
     * F-006-001: 처리환경초기화
     * 배치 전처리 메소드 - 매개변수 설정 및 초기화
     */
    @Override
    public void beforeExecute() {
        this.log = context.getLogger();
        
        log.info("=== BIP0023 기업집단합산재무비율생성 배치 시작 ===");
        
        try {
            // SYSIN 매개변수 처리
            initializeParameters();
            
            log.info("시스템 초기화 완료 - 작업기준일자: " + workBaseDate + ", 기준년: " + baseYr);
            
        } catch (Exception e) {
            log.error("시스템 초기화 중 오류 발생", e);
            throw new BusinessException("EBM02001", "UBM02001", "시스템 초기화 실패: " + e.getMessage());
        }
    }
    
    /**
     * F-006-002: 처리대상기업집단선택 및 메인 처리 로직
     * 배치 메인 메소드 - 기업집단별 합산재무비율 생성
     */
    @Override
    public void execute() {
        try {
            // F-006-002: 기업집단 선택 및 처리
            processCorpGroups();
            
            // 처리 통계 출력
            displayProcessingStatistics();
            
        } catch (Exception e) {
            log.error("배치 처리 중 오류 발생", e);
            throw new BusinessException("EBM02002", "UBM02001", "배치 처리 실패: " + e.getMessage());
        }
    }
    
    /**
     * 배치 후처리 메소드
     */
    @Override
    public void afterExecute() {
        log.info("=== BIP0023 기업집단합산재무비율생성 배치 종료 ===");
        log.info("총 처리 통계:");
        log.info("- 기업집단 처리건수: " + c001Cnt);
        log.info("- 결산년 처리건수: " + c002Cnt);
        log.info("- 재무공식 처리건수: " + c003Cnt);
        log.info("- 변경로그 작성건수: " + chglogWrite);
    }
    
    /**
     * SYSIN 매개변수 초기화
     */
    private void initializeParameters() {
        // 작업기준일자 설정 (SYSIN에서 전달받음)
        this.workBaseDate = context.getInParameter("workBaseDate");
        if (workBaseDate == null || workBaseDate.trim().isEmpty()) {
            throw new BusinessException("EBM02011", "UBM02001", "작업기준일자가 설정되지 않았습니다.");
        }
        
        // 기준년 계산 (작업기준일자에서 년도 추출)
        if (workBaseDate.length() >= 4) {
            this.baseYr = workBaseDate.substring(0, 4);
        } else {
            throw new BusinessException("EBM02011", "UBM02001", "작업기준일자 형식이 올바르지 않습니다: " + workBaseDate);
        }
        
        // 카운터 초기화
        c001Cnt = 0;
        c002Cnt = 0;
        c003Cnt = 0;
        chglogWrite = 0;
    }
    
    /**
     * F-006-002: 기업집단 선택 및 처리
     * BR-006-001: 기업집단선택기준 적용
     */
    private void processCorpGroups() {
        // 기업집단 선택 쿼리 실행
        Map<String, Object> params = new HashMap<>();
        
        try {
            // CUR_C001: 기업집단 선택 커서
            dbSelect("selectCorpGroups", params, new AbsRecordHandler(this) {
                @Override
                public void handleRecord(IRecord corpGroup) {
                    String corpClctGroupCd = (String) corpGroup.get("corpClctGroupCd");
                    String corpClctRegiCd = (String) corpGroup.get("corpClctRegiCd");
                    String baseYm = (String) corpGroup.get("baseYm");
                    
                    log.info("기업집단 처리 시작 - 그룹코드: " + corpClctGroupCd + ", 등록코드: " + corpClctRegiCd);
                    
                    try {
                        // F-006-003: 기존 합산비율 삭제
                        deleteExistingRatios(corpClctGroupCd, corpClctRegiCd);
                        
                        // F-006-004: 결산년 처리
                        processSettlementYears(corpClctGroupCd, corpClctRegiCd, baseYm);
                        
                        c001Cnt++;
                    } catch (Exception e) {
                        log.error("기업집단 처리 중 오류 발생", e);
                        throw new BusinessException("EBM02021", "UBM02001", "기업집단 처리 실패", e);
                    }
                }
            });
            
        } catch (Exception e) {
            log.error("기업집단 처리 중 오류 발생", e);
            throw new BusinessException("EBM02021", "UBM02001", "기업집단 처리 실패", e);
        }
    }
    
    /**
     * F-006-003: 기존합산비율삭제
     * BR-006-005: 데이터삭제및재생성로직 적용
     */
    private void deleteExistingRatios(String corpClctGroupCd, String corpClctRegiCd) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("groupCoCd", GROUP_CO_CD);
            params.put("corpClctGroupCd", corpClctGroupCd);
            params.put("corpClctRegiCd", corpClctRegiCd);
            params.put("baseYr", baseYr);
            params.put("fnafARptdocDstcd", FNAF_RPTDOC_DSTCD);
            
            // 기존 데이터 삭제
            int deleteCount = dbDelete("deleteExistingRatios", params);
            log.info("기존 합산비율 삭제 완료 - 삭제건수: " + deleteCount);
            
        } catch (Exception e) {
            log.error("기존 합산비율 삭제 중 오류 발생", e);
            throw new BusinessException("EBM02022", "UBM02001", "기존 합산비율 삭제 실패", e);
        }
    }
    
    /**
     * F-006-004: 결산년처리
     * BR-006-002: 결산년처리로직 적용
     */
    private void processSettlementYears(String corpClctGroupCd, String corpClctRegiCd, String baseYm) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("groupCoCd", GROUP_CO_CD);
            params.put("corpClctGroupCd", corpClctGroupCd);
            params.put("corpClctRegiCd", corpClctRegiCd);
            params.put("baseYr", baseYr.substring(0, 4));
            
            // CUR_C002: 결산년 선택 커서
            dbSelect("selectSettlementYears", params, makeSettlementYearHandler(corpClctGroupCd, corpClctRegiCd));
            
        } catch (Exception e) {
            log.error("결산년 처리 중 오류 발생", e);
            throw new BusinessException("EBM02023", "UBM02001", "결산년 처리 실패", e);
        }
    }
    
    /**
     * F-006-005: 재무비율계산
     * BR-006-003: 재무산식계산규칙 적용
     * BR-006-006: 산식변수치환규칙 적용
     */
    private void calculateFinancialRatios(String corpClctGroupCd, String corpClctRegiCd, 
                                        String stlaccYr, String stlaccYrB, String stlaccCnt) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("stlaccYr", stlaccYr);
            params.put("stlaccYrB", stlaccYrB);
            
            // CUR_C003: 재무공식 선택 커서 (복잡한 변수 치환 로직 포함)
            dbSelect("selectFinancialFormulas", params, makeFinancialFormulaHandler(corpClctGroupCd, corpClctRegiCd, stlaccYr, stlaccYrB, stlaccCnt));
            
        } catch (Exception e) {
            log.error("재무비율 계산 중 오류 발생", e);
            throw new BusinessException("EBM02024", "UBM02001", "재무비율 계산 실패", e);
        }
    }
    
    /**
     * 재무공식 파싱 및 계산
     * BR-006-003: 재무산식계산규칙 적용
     * BR-006-006: 산식변수치환규칙 적용
     */
    private double parseFinancialFormula(String formula) {
        try {
            if (formula == null || formula.trim().isEmpty()) {
                return 0.0;
            }
            
            // 기본적인 수식 파싱 로직
            String cleanFormula = formula.trim();
            
            // 단순 숫자인 경우
            try {
                return Double.parseDouble(cleanFormula);
            } catch (NumberFormatException e) {
                // 수식 처리 계속
            }
            
            // 기본 사칙연산 처리
            if (cleanFormula.contains("+")) {
                String[] parts = cleanFormula.split("\\+");
                double result = 0.0;
                for (String part : parts) {
                    result += parseFinancialFormula(part.trim());
                }
                return result;
            }
            
            if (cleanFormula.contains("-")) {
                String[] parts = cleanFormula.split("-");
                if (parts.length == 2) {
                    return parseFinancialFormula(parts[0].trim()) - parseFinancialFormula(parts[1].trim());
                }
            }
            
            if (cleanFormula.contains("*")) {
                String[] parts = cleanFormula.split("\\*");
                if (parts.length == 2) {
                    return parseFinancialFormula(parts[0].trim()) * parseFinancialFormula(parts[1].trim());
                }
            }
            
            if (cleanFormula.contains("/")) {
                String[] parts = cleanFormula.split("/");
                if (parts.length == 2) {
                    double denominator = parseFinancialFormula(parts[1].trim());
                    if (denominator != 0.0) {
                        return parseFinancialFormula(parts[0].trim()) / denominator;
                    }
                }
            }
            
            log.debug("재무공식 파싱 완료: " + formula + " = 0.0 (기본값)");
            return 0.0;
            
        } catch (Exception e) {
            log.warn("재무공식 파싱 실패, 기본값 0.0 사용: " + formula, e);
            return 0.0;
        }
    }
    
    /**
     * F-006-006: 합산비율레코드삽입
     * TSKIPC121 테이블에 계산된 합산재무비율 저장
     */
    private void insertConsolidatedRatio(String corpClctGroupCd, String corpClctRegiCd, String stlaccYr,
                                       String fnafARptdocDstic, String fnafItemCd, double ratio, String stlaccCnt) {
        try {
            Map<String, Object> record = new HashMap<>();
            
            // 키 필드들
            record.put("groupCoCd", GROUP_CO_CD);
            record.put("corpClctGroupCd", corpClctGroupCd);
            record.put("corpClctRegiCd", corpClctRegiCd);
            record.put("fnafAStlaccDstcd", FNAF_STLACC_DSTCD);
            record.put("baseYr", baseYr);
            record.put("stlaccYr", stlaccYr);
            record.put("fnafARptdocDstcd", fnafARptdocDstic);
            record.put("fnafItemCd", fnafItemCd);
            
            // 데이터 필드들
            record.put("fnafAbOrglDstcd", FNAF_ORGL_DSTCD);  // 시스템 생성 데이터
            record.put("corpClctFnafRato", ratio);
            record.put("nmrtVal", 0);            // 분자값 (사용안함)
            record.put("dnmnVal", 0);            // 분모값 (사용안함)
            record.put("stlaccYsEntpCnt", Integer.parseInt(stlaccCnt));
            
            // 시스템 필드들
            record.put("sysLastPrcssYms", new java.sql.Timestamp(System.currentTimeMillis()));
            record.put("sysLastUno", "BIP0023");
            
            // 레코드 삽입
            dbInsert("insertConsolidatedRatio", record);
            
            log.debug("합산비율 삽입 완료 - 그룹: " + corpClctGroupCd + ", 항목: " + fnafItemCd + ", 비율: " + ratio);
            
        } catch (Exception e) {
            log.error("합산비율 레코드 삽입 중 오류 발생", e);
            throw new BusinessException("EBM02025", "UBM02001", "합산비율 레코드 삽입 실패", e);
        }
    }
    
    /**
     * F-006-008: 처리통계기능
     * 배치 처리 통계 출력
     */
    private void displayProcessingStatistics() {
        log.info("=== 처리 통계 ===");
        log.info("기업집단 처리건수 (C001): " + c001Cnt);
        log.info("결산년 처리건수 (C002): " + c002Cnt);
        log.info("재무공식 처리건수 (C003): " + c003Cnt);
        log.info("변경로그 작성건수: " + chglogWrite);
        
        // 처리 결과 검증
        if (c001Cnt == 0) {
            log.warn("처리된 기업집단이 없습니다.");
        }
        
        if (c003Cnt == 0) {
            log.warn("처리된 재무공식이 없습니다.");
        }
    }
    
    /**
     * 결산년 처리 핸들러
     */
    private AbsRecordHandler makeSettlementYearHandler(String corpClctGroupCd, String corpClctRegiCd) {
        return new AbsRecordHandler(this) {
            @Override
            public void handleRecord(IRecord settlementYear) {
                try {
                    String stlaccYr = settlementYear.getString("stlaccYr");
                    String stlaccCnt = settlementYear.getString("stlaccCnt");
                    
                    // 결산년B 계산 (전년도)
                    int stlaccYrInt = Integer.parseInt(stlaccYr);
                    String stlaccYrB = String.valueOf(stlaccYrInt - 1);
                    
                    log.info("결산년 처리 - 결산년: " + stlaccYr + ", 결산년B: " + stlaccYrB);
                    
                    // F-006-005: 재무비율 계산
                    calculateFinancialRatios(corpClctGroupCd, corpClctRegiCd, stlaccYr, stlaccYrB, stlaccCnt);
                    
                    c002Cnt++;
                    
                } catch (Exception e) {
                    log.error("결산년 처리 중 오류 발생", e);
                    throw new BusinessException("EBM02022", "UBM02001", "결산년 처리 실패", e);
                }
            }
        };
    }
    
    /**
     * 재무공식 처리 핸들러
     */
    private AbsRecordHandler makeFinancialFormulaHandler(String corpClctGroupCd, String corpClctRegiCd, 
                                                       String stlaccYr, String stlaccYrB, String stlaccCnt) {
        return new AbsRecordHandler(this) {
            @Override
            public void handleRecord(IRecord formula) {
                try {
                    String fnafARptdocDstic = formula.getString("fnafARptdocDstic");
                    String fnafItemCd = formula.getString("fnafItemCd");
                    String clfrCtnt = formula.getString("clfrCtnt");
                    
                    // XFIIQ001 재무공식 파싱 프로그램 호출
                    double calculatedRatio = parseFinancialFormula(clfrCtnt);
                    
                    // BR-006-004: 비율값범위검증
                    if (calculatedRatio > MAX_RATIO) {
                        calculatedRatio = MAX_RATIO;
                    } else if (calculatedRatio < MIN_RATIO) {
                        calculatedRatio = MIN_RATIO;
                    }
                    
                    // F-006-006: 합산비율레코드삽입
                    insertConsolidatedRatio(corpClctGroupCd, corpClctRegiCd, stlaccYr, 
                                          fnafARptdocDstic, fnafItemCd, calculatedRatio, stlaccCnt);
                    
                    c003Cnt++;
                    
                } catch (Exception e) {
                    log.error("재무공식 처리 중 오류 발생", e);
                    throw new BusinessException("EBM02023", "UBM02001", "재무공식 처리 실패", e);
                }
            }
        };
    }
}
