package com.kbstar.edu.c2j.batch;

import java.util.HashMap;
import java.util.Map;

import com.kbstar.sqc.base.BusinessException;

import nexcore.framework.batch.appbase.AbsRecordHandler;
import nexcore.framework.batch.appbase.DBSession;
import nexcore.framework.core.component.streotype.BizBatch;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.Record;
import nexcore.framework.core.log.ILog;
import nexcore.framework.core.util.StringUtils;

/**
 * 기업집단 현황 업데이트 시스템.
 * <pre>
 * 기업집단 현황 업데이트 배치 프로세스
 * TSKIPA110, TSKIPA111 테이블 처리를 통한 기업집단 관계 정보 업데이트
 * 비즈니스 규칙: BR-018-001, BR-018-002, BR-018-003, BR-018-004, BR-018-005, BR-018-006
 * </pre>
 * @author MultiQ4KBBank
 * @since 2025-10-02
 */
@BizBatch("기업집단 현황 업데이트 시스템")
public class BUBIP0002 extends com.kbstar.sqc.batch.base.BatchUnit {
    
    private ILog log;
    
    // 처리 통계
    private int readA110Cnt = 0;      // TSKIPA110 읽기 건수
    private int updateA110Cnt = 0;    // TSKIPA110 업데이트 건수
    private int readA111Cnt = 0;      // TSKIPA111 읽기 건수
    private int updateA111Cnt = 0;    // TSKIPA111 업데이트 건수
    private int skipCnt = 0;          // 건너뛰기 건수
    private int commitCnt = 0;        // 커밋 횟수

    /**
     * 배치 전처리 메소드.
     * 여기서 Exception 발생시 execute() 메소드는 실행되지 않고, afterExecute() 는 실행됨
     */
    @Override
    public void beforeExecute() {
        this.log = context.getLogger();
        
        // 작업기준일자 검증 (BR-018-001)
        String workBsd = context.getInParameter("workBsd");
        if (StringUtils.isEmpty(workBsd)) {
            // 원본 에러 정보 로깅
            log.error("작업기준일자 누락 오류 - 에러코드: 33, 메시지: CHECK SYSIN PARAMETERS, 상세: 작업기준일자가 누락되었습니다. SYSIN 매개변수를 확인하세요");
            throw new BusinessException("B3900042", "UKIP0126", "업무담당자에게 문의 바랍니다.");
        }
        
        log.info("=== BIP0002 배치 시작 ===");
        log.info("작업기준일자: " + workBsd);
    }

    /**
     * 배치 메인 메소드
     * 기업집단 현황 업데이트 처리
     */
    @Override
    public void execute() {
        String workBsd = context.getInParameter("workBsd");
        
        // 1단계: 관계기업 정보 업데이트 처리
        processRelatedCompanies(workBsd);
        
        // 2단계: 기업집단 집계 처리
        processGroupAggregation(workBsd);
        
        log.info("=== BIP0002 배치 완료 ===");
        log.info("TSKIPA110 읽기: " + readA110Cnt + "건");
        log.info("TSKIPA110 업데이트: " + updateA110Cnt + "건");
        log.info("TSKIPA111 읽기: " + readA111Cnt + "건");
        log.info("TSKIPA111 업데이트: " + updateA111Cnt + "건");
        log.info("건너뛰기: " + skipCnt + "건");
        log.info("커밋 횟수: " + commitCnt + "회");
    }

    /**
     * 관계기업 정보 업데이트 처리 (F-018-008)
     */
    private void processRelatedCompanies(String workBsd) {
        log.info("=== 관계기업 정보 업데이트 시작 ===");
        
        Map<String, Object> sqlIn = new HashMap<String, Object>();
        sqlIn.put("groupCoCd", "KB0");
        
        // CUR_A110 커서로 기존 관계기업 조회
        try {
            DBSession readSession = dbNewSession(false, "READ");
            dbSelect("CUR_A110", sqlIn, new AbsRecordHandler(this) {
                @Override
                public void handleRecord(IRecord record) {
                    readA110Cnt++;
                    
                    String exmtnCustIdnfr = record.getString("exmtnCustIdnfr");
                    
                    // 고객정보 검증 (BR-018-001)
                    if (StringUtils.isEmpty(exmtnCustIdnfr) || " ".equals(exmtnCustIdnfr)) {
                        skipCnt++;
                        log.info("고객식별자 누락으로 건너뛰기 - 고객식별자: " + exmtnCustIdnfr);
                        return;
                    }
                    
                    try {
                        // 포괄적 정보 수집 및 업데이트
                        updateRelatedCompanyInfo(record, workBsd);
                        updateA110Cnt++;
                        
                        // 커밋 처리 (1000건마다)
                        if (readA110Cnt % 1000 == 0) {
                            txCommit();
                            commitCnt++;
                            log.info("관계기업 처리 진행: " + readA110Cnt + "건 처리됨");
                        }
                        
                    } catch (Exception e) {
                        log.error("관계기업 정보 업데이트 오류 - 고객식별자: " + exmtnCustIdnfr, e);
                    }
                }
            }, readSession);
            
            // 최종 커밋
            txCommit();
            commitCnt++;
            
        } catch (Exception e) {
            log.error("CUR_A110 커서 처리 오류", e);
            throw new BusinessException("B3900002", "UKIP0126", "업무담당자에게 문의 바랍니다.", e);
        }
        
        log.info("=== 관계기업 정보 업데이트 완료 ===");
    }

    /**
     * 관계기업 정보 업데이트 (포괄적 정보 통합)
     */
    private void updateRelatedCompanyInfo(IRecord record, String workBsd) {
        String exmtnCustIdnfr = record.getString("exmtnCustIdnfr");
        
        Map<String, Object> updateData = new HashMap<String, Object>();
        updateData.put("exmtnCustIdnfr", exmtnCustIdnfr);
        updateData.put("groupCoCd", "KB0");
        
        // 1. 고객정보 조회 (F-018-001)
        Map<String, Object> custInfo = getCustomerInfo(exmtnCustIdnfr);
        
        // 2. 고객유형 분류 및 정보 수집 (BR-018-002)
        String custType = (String) custInfo.get("cuniqnoDstcd");
        if (isPersonalCustomer(custType)) {
            // SOHO 고객 분류 (F-018-002)
            Map<String, Object> sohoInfo = getSohoInfo(exmtnCustIdnfr);
            if (!"1".equals(sohoInfo.get("sohoExpsrDstic"))) {
                // CRS 정보 조회 (F-018-003)
                Map<String, Object> crsInfo = getCrsInfo(exmtnCustIdnfr);
                updateData.putAll(crsInfo);
            } else {
                updateData.putAll(sohoInfo);
            }
        } else {
            // 법인고객 CRS 정보 조회 (F-018-003)
            Map<String, Object> crsInfo = getCrsInfo(exmtnCustIdnfr);
            updateData.putAll(crsInfo);
        }
        
        // 3. 업무모듈 통합 (BR-018-006)
        updateData.putAll(getDinaInfo(exmtnCustIdnfr));      // F-018-004
        updateData.putAll(getTeInfo(exmtnCustIdnfr));        // F-018-005
        updateData.putAll(getSahuInfo(exmtnCustIdnfr));      // F-018-006
        updateData.putAll(getTongInfo(exmtnCustIdnfr));      // F-018-007
        updateData.putAll(getEarlyWarningInfo(exmtnCustIdnfr));
        
        // 4. 연말처리 규칙 적용 (BR-018-004)
        applyYearEndProcessing(updateData, workBsd);
        
        // 5. 시스템 처리 정보 업데이트
        updateData.put("sysLastPrcssYms", getCurrentTimestamp());
        updateData.put("sysLastUno", "BATCH");
        
        // 6. TSKIPA110 업데이트 실행
        try {
            dbUpdate("updateA110", updateData);
            log.debug("TSKIPA110 정상 업데이트 - 고객식별자: " + exmtnCustIdnfr);
        } catch (Exception e) {
            log.error("TSKIPA110 업데이트 실패 - 고객식별자: " + exmtnCustIdnfr, e);
            throw e;
        }
    }

    /**
     * 기업집단 집계 처리 (F-018-009)
     */
    private void processGroupAggregation(String workBsd) {
        log.info("=== 기업집단 집계 처리 시작 ===");
        
        Map<String, Object> sqlIn = new HashMap<String, Object>();
        sqlIn.put("groupCoCd", "KB0");
        
        // CUR_A111 커서로 기업집단 조회
        try {
            DBSession readSession = dbNewSession(false, "READ");
            dbSelect("CUR_A111", sqlIn, new AbsRecordHandler(this) {
                @Override
                public void handleRecord(IRecord record) {
                    readA111Cnt++;
                    
                    String corpClctGroupCd = record.getString("corpClctGroupCd");
                    String corpClctRegiCd = record.getString("corpClctRegiCd");
                    
                    try {
                        // 집계 정보 계산 및 업데이트
                        updateGroupAggregation(record, workBsd);
                        updateA111Cnt++;
                        
                        // 커밋 처리 (1000건마다)
                        if (readA111Cnt % 1000 == 0) {
                            txCommit();
                            commitCnt++;
                            log.info("기업집단 집계 진행: " + readA111Cnt + "건 처리됨");
                        }
                        
                    } catch (Exception e) {
                        log.error("기업집단 집계 오류 - 그룹코드: " + corpClctGroupCd, e);
                    }
                }
            }, readSession);
            
            // 최종 커밋
            txCommit();
            commitCnt++;
            
        } catch (Exception e) {
            log.error("CUR_A111 커서 처리 오류", e);
            throw new BusinessException("B3900002", "UKIP0126", "업무담당자에게 문의 바랍니다.", e);
        }
        
        log.info("=== 기업집단 집계 처리 완료 ===");
    }

    /**
     * 기업집단 집계 정보 업데이트
     */
    private void updateGroupAggregation(IRecord record, String workBsd) {
        String corpClctGroupCd = record.getString("corpClctGroupCd");
        String corpClctRegiCd = record.getString("corpClctRegiCd");
        
        Map<String, Object> updateData = new HashMap<String, Object>();
        updateData.put("corpClctGroupCd", corpClctGroupCd);
        updateData.put("corpClctRegiCd", corpClctRegiCd);
        updateData.put("groupCoCd", "KB0");
        
        // 집계된 총여신금액 계산
        Map<String, Object> aggregateData = calculateGroupTotals(corpClctGroupCd, corpClctRegiCd);
        updateData.putAll(aggregateData);
        
        // 주채무계열그룹 분류 규칙 적용 (BR-018-005)
        if ("GRS".equals(corpClctRegiCd)) {
            String mainDaGroupYn = determineMainDebtGroup(corpClctGroupCd);
            updateData.put("mainDaGroupYn", mainDaGroupYn);
            updateData.put("corpGmGroupDstcd", "1".equals(mainDaGroupYn) ? "01" : "00");
        }
        
        // 시스템 처리 정보 업데이트
        updateData.put("sysLastPrcssYms", getCurrentTimestamp());
        updateData.put("sysLastUno", "BATCH");
        
        // TSKIPA111 업데이트 실행
        try {
            dbUpdate("updateA111", updateData);
        } catch (Exception e) {
            log.error("TSKIPA111 업데이트 실패 - 그룹코드: " + corpClctGroupCd, e);
            throw e;
        }
    }

    // 헬퍼 메소드들
    private boolean isPersonalCustomer(String custType) {
        return custType != null && 
               ("01".equals(custType) || "03".equals(custType) || "04".equals(custType) || 
                "05".equals(custType) || "10".equals(custType) || "16".equals(custType));
    }

    private Map<String, Object> getCustomerInfo(String exmtnCustIdnfr) {
        // XIAA0019 모듈 호출 시뮬레이션
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("cuniqno", "CUST" + exmtnCustIdnfr);
        result.put("cuniqnoDstcd", "02");
        result.put("rpsntEntpName", "테스트회사");
        return result;
    }

    private Map<String, Object> getSohoInfo(String exmtnCustIdnfr) {
        // XIIH0059 모듈 호출 시뮬레이션
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("sohoExpsrDstic", "0");
        result.put("corpCvGrdDstcd", "BBB0");
        result.put("stndIClsfiCd", "12345");
        result.put("corpScalDstcd", "2");
        return result;
    }

    private Map<String, Object> getCrsInfo(String exmtnCustIdnfr) {
        // XIIIK083 모듈 호출 시뮬레이션
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("corpCvGrdDstcd", "AAA0");
        result.put("stndIClsfiCd", "54321");
        result.put("corpScalDstcd", "1");
        return result;
    }

    private Map<String, Object> getDinaInfo(String exmtnCustIdnfr) {
        // XDINA0V2 모듈 호출 시뮬레이션
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("corpLPlicyDstcd", "01");
        result.put("corpLPlicySerno", 123456789);
        result.put("corpLPlicyCtnt", "기업여신정책내용");
        return result;
    }

    private Map<String, Object> getTeInfo(String exmtnCustIdnfr) {
        // XIJL4010 모듈 호출 시뮬레이션
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("totalLnbzAmt", 1000000000L);
        result.put("lnbzBal", 800000000L);
        result.put("custMgtBrncd", "1234");
        result.put("fcltFndsClam", 500000000L);
        result.put("fcltFndsBal", 400000000L);
        result.put("wrknFndsClam", 300000000L);
        result.put("wrknFndsBal", 250000000L);
        return result;
    }

    private Map<String, Object> getSahuInfo(String exmtnCustIdnfr) {
        // XIIBAY01 모듈 호출 시뮬레이션
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("amov", 50000000L);
        return result;
    }

    private Map<String, Object> getTongInfo(String exmtnCustIdnfr) {
        // XIIEZ187 모듈 호출 시뮬레이션
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("scurtyAmt", 200000000L);
        return result;
    }

    private Map<String, Object> getEarlyWarningInfo(String exmtnCustIdnfr) {
        // XIIF9911 모듈 호출 시뮬레이션
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("elyAaMgtDstcd", "0");
        return result;
    }

    private void applyYearEndProcessing(Map<String, Object> updateData, String workBsd) {
        // 연말처리 규칙 (BR-018-004)
        String currentYear = workBsd.substring(0, 4);
        // 실제 구현에서는 이전 처리 연도와 비교하여 전년총여신금액 업데이트
        updateData.put("pyyTotalLnbzAmt", 0L);
    }

    private Map<String, Object> calculateGroupTotals(String corpClctGroupCd, String corpClctRegiCd) {
        Map<String, Object> result = new HashMap<String, Object>();
        
        Map<String, Object> sqlIn = new HashMap<String, Object>();
        sqlIn.put("corpClctGroupCd", corpClctGroupCd);
        sqlIn.put("corpClctRegiCd", corpClctRegiCd);
        
        // 그룹 총계 조회를 위한 핸들러
        final Map<String, Object> totalResult = new HashMap<>();
        DBSession readSession = dbNewSession(false, "READ");
        dbSelect("selectGroupTotals", sqlIn, new AbsRecordHandler(this) {
            public void handleRecord(IRecord record) {
                totalResult.put("totalLnbzAmt", record.getLong("totalLnbzAmt"));
            }
        }, readSession);
        
        if (totalResult.containsKey("totalLnbzAmt")) {
            result.put("totalLnbzAmt", totalResult.get("totalLnbzAmt"));
        } else {
            result.put("totalLnbzAmt", 0L);
        }
        
        return result;
    }

    private String determineMainDebtGroup(String corpClctGroupCd) {
        // 주채무계열그룹 결정 로직 (BR-018-005)
        // 실제 구현에서는 규제 가이드라인에 따른 복잡한 로직 필요
        return "0"; // 기본값
    }

    private String getCurrentTimestamp() {
        return String.format("%1$tY%1$tm%1$td%1$tH%1$tM%1$tS%1$tL0000", System.currentTimeMillis());
    }

    /**
     * 배치 후처리 메소드
     */
    @Override
    public void afterExecute() {
        log.info("=== BIP0002 배치 후처리 완료 ===");
    }
}
