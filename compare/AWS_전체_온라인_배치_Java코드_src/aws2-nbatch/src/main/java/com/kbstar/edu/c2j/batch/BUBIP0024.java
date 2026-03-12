package com.kbstar.edu.c2j.batch;

import java.util.HashMap;
import java.util.Map;

import com.kbstar.sqc.base.BusinessException;

import nexcore.framework.batch.BatchProfile;
import nexcore.framework.batch.appbase.AbsRecordHandler;
import nexcore.framework.batch.appbase.AutoCommitRecordHandler;
import nexcore.framework.batch.appbase.DBSession;
import nexcore.framework.core.component.streotype.BizBatch;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.Record;
import nexcore.framework.core.log.ILog;

/**
 * 기업집단사업부문구조별참조자료생성 (Corporate Group Business Sector Structure Reference Data Generation)
 * <pre>
 * WP-013 FLOW_002 - BIP0024
 * 기업집단 평가데이터를 기반으로 사업부문별 구조 참조자료 생성
 * - 3개년 비교분석 (기준년도 + 과거 2개년)
 * - 사업부문별 매출비율 및 업체수 산출
 * - TSKIPB113 테이블에 참조자료 생성
 * </pre>
 * @author MultiQ4KBBank
 * @since 2025-10-01
 */
@BizBatch("기업집단사업부문구조별참조자료생성")
public class BUBIP0024 extends com.kbstar.sqc.batch.base.BatchUnit {

    private ILog log;
    private BatchProfile profile;
    
    // 입력 파라미터
    private String groupCoCd = "KB0"; // 그룹회사코드 (고정값)
    private String workBaseDate; // 작업기준일자
    
    // 처리 카운터
    private long b110FetchCount = 0; // 기업집단평가 조회건수
    private long b113InsertCount = 0; // 참조자료 생성건수
    private long b113UpdateCount = 0; // 참조자료 갱신건수
    private long b113DeleteCount = 0; // 기존자료 삭제건수
    
    // 커밋 포인트
    private int commitCount = 10;

    public BUBIP0024() {
        super();
    }

    /**
     * 배치 전처리 - 시스템 파라미터 초기화 및 입력 검증
     */
    @Override
    public void beforeExecute() {
        this.log = context.getLogger();
        this.profile = context.getBatchProfile();
        
        // SYSIN 파라미터 읽기
        workBaseDate = context.getInParameter("WORK_BASE_DATE");
        
        log.info("=== BIP0024 기업집단사업부문구조별참조자료생성 시작 ===");
        log.info("작업기준일자: " + workBaseDate);
        log.info("그룹회사코드: " + groupCoCd);
        
        // 입력 파라미터 검증
        if (workBaseDate == null || workBaseDate.trim().isEmpty()) {
            throw new BusinessException("EBM24001", "UBM24001", "작업기준일자가 누락되었습니다");
        }
        
        log.info("배치 초기화 완료");
    }

    /**
     * 배치 메인 처리
     * 1. 기업집단평가데이터 선정
     * 2. 기존 참조자료 삭제
     * 3. 다년도 사업부문 구조 참조자료 생성
     */
    @Override
    public void execute() {
        // 기업집단평가데이터 처리
        processCorporateGroupEvaluation();
        
        // 처리 결과 출력
        log.info("=== 처리 완료 ===");
        log.info("기업집단평가 조회건수: " + b110FetchCount);
        log.info("참조자료 삭제건수: " + b113DeleteCount);
        log.info("참조자료 생성건수: " + b113InsertCount);
        log.info("참조자료 갱신건수: " + b113UpdateCount);
    }

    /**
     * 배치 후처리 - 최종 통계 출력
     */
    @Override
    public void afterExecute() {
        if (super.exceptionInExecute == null) {
            log.info("=== BIP0024 배치 정상 완료 ===");
        } else {
            log.error("=== BIP0024 배치 오류 발생 ===");
        }
    }

    /**
     * 기업집단평가데이터 처리
     * BR-013-001: 기업집단평가데이터선정
     */
    private void processCorporateGroupEvaluation() {
        log.info("=== 기업집단평가데이터 처리 시작 ===");
        
        Map<String, Object> sqlIn = new HashMap<>();
        sqlIn.put("groupCoCd", groupCoCd);
        
        DBSession readSession = dbNewSession(false, "READ");
        
        // 기업집단평가데이터 조회 및 처리
        dbSelect("selectCorporateGroupEvaluation", sqlIn, makeCorpGroupHandler(), readSession);
        
        log.info("=== 기업집단평가데이터 처리 완료 ===");
    }

    /**
     * 기업집단평가 레코드 처리 핸들러
     */
    private AbsRecordHandler makeCorpGroupHandler() {
        return new AutoCommitRecordHandler(this) {
            @Override
            public void handleRecord(IRecord record) {
                try {
                    b110FetchCount++;
                    
                    // 기업집단 정보 추출
                    String corpClctGroupCd = record.getString("corpClctGroupCd");
                    String corpClctRegiCd = record.getString("corpClctRegiCd");
                    String valuaYmd = record.getString("valuaYmd");
                    String valuaBaseYmd = record.getString("valuaBaseYmd");
                    
                    log.info("처리 중: 기업집단그룹코드=" + corpClctGroupCd + 
                            ", 등록코드=" + corpClctRegiCd + ", 평가일자=" + valuaYmd);
                    
                    // 기존 참조자료 삭제
                    deleteExistingReferenceData(corpClctGroupCd, corpClctRegiCd, valuaYmd);
                    
                    // 다년도 참조자료 생성
                    generateMultiYearReferenceData(corpClctGroupCd, corpClctRegiCd, valuaYmd, valuaBaseYmd);
                    
                    // 커밋 포인트 처리
                    if (b110FetchCount % commitCount == 0) {
                        log.info("처리 진행: " + b110FetchCount + "건");
                    }
                    
                } catch (Exception e) {
                    log.error("기업집단평가 레코드 처리 오류: " + e.getMessage());
                    throw new BusinessException("EBM24002", "UBM24002", 
                        "기업집단평가 레코드 처리 오류: " + e.getMessage());
                }
            }
        };
    }

    /**
     * BR-013-007: 기존 참조자료 삭제
     */
    private void deleteExistingReferenceData(String corpClctGroupCd, String corpClctRegiCd, String valuaYmd) {
        Map<String, Object> sqlIn = new HashMap<>();
        sqlIn.put("groupCoCd", groupCoCd);
        sqlIn.put("corpClctGroupCd", corpClctGroupCd);
        sqlIn.put("corpClctRegiCd", corpClctRegiCd);
        sqlIn.put("valuaYmd", valuaYmd);
        
        DBSession writeSession = dbNewSession(true, "WRITE");
        
        try {
            int deleteCount = dbDelete("deleteExistingReferenceData", sqlIn, writeSession);
            b113DeleteCount += deleteCount;
            
            if (deleteCount > 0) {
                log.info("기존 참조자료 삭제: " + deleteCount + "건");
            }
            
        } catch (Exception e) {
            log.error("기존 참조자료 삭제 오류: " + e.getMessage());
            throw new BusinessException("EBM24003", "UBM24003", 
                "기존 참조자료 삭제 오류: " + e.getMessage());
        }
    }

    /**
     * BR-013-002, BR-013-006: 다년도 참조자료 생성
     */
    private void generateMultiYearReferenceData(String corpClctGroupCd, String corpClctRegiCd, 
                                               String valuaYmd, String valuaBaseYmd) {
        
        // BR-013-002: 다년도 과거기간 산출
        String[] settlementDates = calculateMultiYearDates(valuaBaseYmd);
        
        // 3개년 처리 (기준년도, N-1년, N-2년)
        for (int yearIndex = 0; yearIndex < 3; yearIndex++) {
            String stlaccEndYmd = settlementDates[yearIndex];
            String stlaccYmd = stlaccEndYmd.substring(0, 6); // YYYYMM
            
            log.info("처리년도 " + (yearIndex + 1) + ": " + stlaccEndYmd);
            
            // 사업부문별 재무데이터 집계 및 참조자료 생성
            generateBusinessSectorReferenceData(corpClctGroupCd, corpClctRegiCd, valuaYmd, 
                                               stlaccEndYmd, stlaccYmd, yearIndex);
        }
    }

    /**
     * BR-013-002: 다년도 과거기간 산출
     */
    private String[] calculateMultiYearDates(String valuaBaseYmd) {
        Map<String, Object> sqlIn = new HashMap<>();
        sqlIn.put("valuaBaseYmd", valuaBaseYmd);
        
        DBSession readSession = dbNewSession(false, "READ");
        
        try {
            IRecord dateRecord = dbSelectSingle("calculateMultiYearDates", sqlIn, readSession);
            
            String[] dates = new String[3];
            dates[0] = dateRecord.getString("baseYearDate");    // 기준년도
            dates[1] = dateRecord.getString("n1YearDate");      // N-1년
            dates[2] = dateRecord.getString("n2YearDate");      // N-2년
            
            return dates;
            
        } catch (Exception e) {
            log.error("다년도 날짜 계산 오류: " + e.getMessage());
            throw new BusinessException("EBM24004", "UBM24004", 
                "다년도 날짜 계산 오류: " + e.getMessage());
        }
    }

    /**
     * BR-013-003, BR-013-004, BR-013-005: 사업부문별 참조자료 생성
     */
    private void generateBusinessSectorReferenceData(String corpClctGroupCd, String corpClctRegiCd, 
                                                    String valuaYmd, String stlaccEndYmd, 
                                                    String stlaccYmd, int yearIndex) {
        
        Map<String, Object> sqlIn = new HashMap<>();
        sqlIn.put("groupCoCd", groupCoCd);
        sqlIn.put("corpClctGroupCd", corpClctGroupCd);
        sqlIn.put("corpClctRegiCd", corpClctRegiCd);
        sqlIn.put("stlaccEndYmd", stlaccEndYmd);
        sqlIn.put("stlaccYmd", stlaccYmd);
        
        DBSession readSession = dbNewSession(false, "READ");
        
        // 사업부문별 재무데이터 조회 및 처리
        dbSelect("selectBusinessSectorFinancialData", sqlIn, 
                makeBusinessSectorHandler(corpClctGroupCd, corpClctRegiCd, valuaYmd, yearIndex), 
                readSession);
    }

    /**
     * 사업부문별 재무데이터 처리 핸들러
     */
    private AbsRecordHandler makeBusinessSectorHandler(String corpClctGroupCd, String corpClctRegiCd, 
                                                      String valuaYmd, int yearIndex) {
        return new AutoCommitRecordHandler(this) {
            @Override
            public void handleRecord(IRecord record) {
                try {
                    // BR-013-005: 사업부문비율 산출 및 BR-013-006: 참조자료 생성
                    generateReferenceDataRecord(record, corpClctGroupCd, corpClctRegiCd, valuaYmd, yearIndex);
                    
                } catch (Exception e) {
                    log.error("사업부문 데이터 처리 오류: " + e.getMessage());
                    throw new BusinessException("EBM24005", "UBM24005", 
                        "사업부문 데이터 처리 오류: " + e.getMessage());
                }
            }
        };
    }

    /**
     * BR-013-005, BR-013-006: 참조자료 레코드 생성/갱신
     */
    private void generateReferenceDataRecord(IRecord sectorData, String corpClctGroupCd, 
                                           String corpClctRegiCd, String valuaYmd, int yearIndex) {
        
        String bizSectDstic = sectorData.getString("bizSectDstic");
        String bizSectDsticName = sectorData.getString("bizSectDsticName");
        long bizSectAsaleAmt = sectorData.getLong("bizSectAsaleAmt");
        long bizSaTotalAmt = sectorData.getLong("bizSaTotalAmt");
        int entpCnt = sectorData.getInt("entpCnt");
        
        // BR-013-005: 비율 계산
        double ratio = 0.0;
        if (bizSaTotalAmt > 0 && bizSectAsaleAmt > 0) {
            ratio = Math.round((double) bizSectAsaleAmt / bizSaTotalAmt * 100.0 * 1000.0) / 1000.0;
        }
        
        Map<String, Object> refData = new HashMap<>();
        refData.put("groupCoCd", groupCoCd);
        refData.put("corpClctGroupCd", corpClctGroupCd);
        refData.put("corpClctRegiCd", corpClctRegiCd);
        refData.put("valuaYmd", valuaYmd);
        refData.put("fnafARptdocDstcd", "00"); // 재무분석보고서구분
        refData.put("fnafItemCd", "0000"); // 재무항목코드
        refData.put("bizSectDstic", "00" + bizSectDstic); // 사업부문번호
        refData.put("bizSectDsticName", bizSectDsticName);
        
        // BR-013-006: 년도별 데이터 설정
        if (yearIndex == 0) { // 기준년도
            refData.put("baseYrItemAmt", bizSectAsaleAmt);
            refData.put("baseYrRato", ratio);
            refData.put("baseYrEntpCnt", entpCnt);
            insertReferenceData(refData);
            b113InsertCount++;
        } else { // N-1년, N-2년
            if (yearIndex == 1) {
                refData.put("n1YrBfItemAmt", bizSectAsaleAmt);
                refData.put("n1YrBfRato", ratio);
                refData.put("n1YrBfEntpCnt", entpCnt);
            } else {
                refData.put("n2YrBfItemAmt", bizSectAsaleAmt);
                refData.put("n2YrBfRato", ratio);
                refData.put("n2YrBfEntpCnt", entpCnt);
            }
            updateReferenceData(refData);
            b113UpdateCount++;
        }
    }

    /**
     * 참조자료 신규 생성
     */
    private void insertReferenceData(Map<String, Object> refData) {
        // 시스템 처리 정보 설정
        refData.put("sysLastPrcssYms", getCurrentTimestamp());
        refData.put("sysLastUno", "BATCH01");
        
        DBSession writeSession = dbNewSession(true, "WRITE");
        
        try {
            dbInsert("insertReferenceData", refData, writeSession);
        } catch (Exception e) {
            log.error("참조자료 생성 오류: " + e.getMessage());
            throw new BusinessException("EBM24006", "UBM24006", 
                "참조자료 생성 오류: " + e.getMessage());
        }
    }

    /**
     * 참조자료 갱신
     */
    private void updateReferenceData(Map<String, Object> refData) {
        // 시스템 처리 정보 설정
        refData.put("sysLastPrcssYms", getCurrentTimestamp());
        refData.put("sysLastUno", "BATCH01");
        
        DBSession writeSession = dbNewSession(true, "WRITE");
        
        try {
            int updateCount = dbUpdate("updateReferenceData", refData, writeSession);
            if (updateCount == 0) {
                // 갱신할 레코드가 없으면 신규 생성
                dbInsert("insertReferenceData", refData, writeSession);
                b113InsertCount++;
                b113UpdateCount--; // 카운터 조정
            }
        } catch (Exception e) {
            log.error("참조자료 갱신 오류: " + e.getMessage());
            throw new BusinessException("EBM24007", "UBM24007", 
                "참조자료 갱신 오류: " + e.getMessage());
        }
    }

    /**
     * 현재 타임스탬프 생성
     */
    private String getCurrentTimestamp() {
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        return now.format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSSSS"));
    }
}
