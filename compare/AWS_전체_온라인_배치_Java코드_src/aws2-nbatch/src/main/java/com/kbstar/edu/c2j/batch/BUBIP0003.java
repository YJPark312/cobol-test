package com.kbstar.edu.c2j.batch;

import java.util.HashMap;
import java.util.Map;

import com.kbstar.sqc.base.BusinessException;

import nexcore.framework.batch.BatchProfile;
import nexcore.framework.batch.appbase.AbsRecordHandler;
import nexcore.framework.batch.appbase.DBSession;
import nexcore.framework.core.component.streotype.BizBatch;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.Record;
import nexcore.framework.core.log.ILog;

/**
 * 관계기업군 그룹 월정보 생성.
 * <pre>
 * DB to DB - 월별 기업그룹 정보 백업
 * 소스: TSEDUA110 → 타겟: TSEDUA120
 * 소스: TSEDUA111 → 타겟: TSEDUA121
 * </pre>
 * @author MultiQ4KBBank
 * @since 2024-09-15
 */
@BizBatch("관계기업군 그룹 월정보 생성")
public class BUBIP0003 extends com.kbstar.sqc.batch.base.BatchUnit {
    
    // 로거
    private ILog log;
    
    // 배치 프로파일
    private BatchProfile profile;
    
    // 커밋 횟수
    private int commitCount;
    
    // 처리 카운터들
    private int readCnt1 = 0;    // TSEDUA110 읽기
    private int readCnt2 = 0;    // TSEDUA111 읽기
    private int readCnt3 = 0;    // TSEDUA120 읽기 (삭제용)
    private int readCnt4 = 0;    // TSEDUA121 읽기 (삭제용)
    private int deleteCnt3 = 0;  // TSEDUA120 삭제
    private int deleteCnt4 = 0;  // TSEDUA121 삭제
    private int insertCnt1 = 0;  // TSEDUA120 삽입
    private int insertCnt2 = 0;  // TSEDUA121 삽입
    
    public BUBIP0003() {
        super();
    }

    /**
     * 배치 전처리 메소드.
     * 여기서 Exception 발생시 execute() 메소드는 실행되지 않고, afterExecute() 는 실행됨
     */
    @Override
    public void beforeExecute() {
        this.log = context.getLogger();
        
        // BR-028-001: 작업년월 필수 검증
        String workYm = context.getInParameter("workYm");
        if (workYm == null || workYm.trim().isEmpty()) {
            // 원본 에러 정보 로깅
            log.error("관리년월 누락 오류 - 에러코드: 08, 메시지: CHECK SYSIN PARAMETERS, 상세: 관리년월이 누락되었습니다. SYSIN 매개변수를 확인하세요");
            // TODO: 에러코드 B3900042, 액션메시지 UKII0182 확인 필요 - 개발자 검증 요망
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.");
        }
        
        // BR-028-009, BR-028-012: 기준년월 형식 검증 (YYYYMM)
        if (!isValidYearMonth(workYm)) {
            log.error("작업년월 형식 오류: " + workYm);
            throw new BusinessException("B3900042", "UKII0182", "작업년월은 YYYYMM 형식이어야 합니다.");
        }
        
        this.profile = context.getBatchProfile();
        this.commitCount = profile == null || profile.getCommitCount() == 0 ? 1000 : profile.getCommitCount();
    }

    /**
     * 배치 메인 메소드
     */
    @Override
    public void execute() {
        // DB 조회 조건 설정
        Map<String, Object> sqlIn = new HashMap<>();
        sqlIn.put("grCoCd", context.getInParameter("grCoCd"));
        sqlIn.put("workYm", context.getInParameter("workYm"));
        
        log.info("DB 조회 조건: " + sqlIn);
        
        DBSession readSession = dbNewSession(false, "READ");
        
        // 1단계: 기존 월별 데이터 삭제
        log.info("기존 월별 데이터 삭제 시작");
        dbSelect("selectTargetEdua120", sqlIn, makeDeleteHandler120(), readSession);
        dbSelect("selectTargetEdua121", sqlIn, makeDeleteHandler121(), readSession);
        log.info("기존 월별 데이터 삭제 완료");
        
        // 2단계: 새 데이터 백업
        log.info("새 데이터 백업 시작");
        dbSelect("selectSourceEdua110", sqlIn, makeBackupHandler110(), readSession);
        dbSelect("selectSourceEdua111", sqlIn, makeBackupHandler111(), readSession);
        log.info("새 데이터 백업 완료");
    }
    
    /**
     * TSEDUA120 삭제 핸들러
     */
    private AbsRecordHandler makeDeleteHandler120() {
        return new AbsRecordHandler(this) {
            public void handleRecord(IRecord record) {
                try {
                    context.setProgressCurrent(getCurrentSize());
                    
                    readCnt3++;
                    // TODO: TSEDUA120 삭제 로직 구현 필요
                    dbDelete("deleteTargetEdua120", record);
                    deleteCnt3++;
                    
                    if (getCurrentSize() % commitCount == 0) {
                        txCommit();
                    }
                } catch(Exception e) {
                    log.error("[에러발생] Position=" + getCurrentSize() + ", record=" + record.toString().trim(), e);
                    // 원본 에러 정보 로깅
                    log.error("데이터베이스 작업 오류 - 에러코드: 59, 메시지: CHECK DATABASE STATUS, 상세: 데이터베이스 작업 중 오류가 발생했습니다", e);
                    // TODO: 에러코드 B3900042, 액션메시지 UKII0182 확인 필요 - 개발자 검증 요망
                    throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
                }
            }
        };
    }
    
    /**
     * TSEDUA121 삭제 핸들러
     */
    private AbsRecordHandler makeDeleteHandler121() {
        return new AbsRecordHandler(this) {
            public void handleRecord(IRecord record) {
                try {
                    context.setProgressCurrent(getCurrentSize());
                    
                    readCnt4++;
                    // TODO: TSEDUA121 삭제 로직 구현 필요
                    dbDelete("deleteTargetEdua121", record);
                    deleteCnt4++;
                    
                    if (getCurrentSize() % commitCount == 0) {
                        txCommit();
                    }
                } catch(Exception e) {
                    log.error("[에러발생] Position=" + getCurrentSize() + ", record=" + record.toString().trim(), e);
                    // 원본 에러 정보 로깅
                    log.error("데이터베이스 작업 오류 - 에러코드: 59, 메시지: CHECK DATABASE STATUS, 상세: 데이터베이스 작업 중 오류가 발생했습니다", e);
                    // TODO: 에러코드 B3900042, 액션메시지 UKII0182 확인 필요 - 개발자 검증 요망
                    throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
                }
            }
        };
    }
    
    /**
     * TSEDUA110 백업 핸들러
     */
    private AbsRecordHandler makeBackupHandler110() {
        return new AbsRecordHandler(this) {
            public void handleRecord(IRecord record) {
                try {
                    context.setProgressCurrent(getCurrentSize());
                    
                    readCnt1++;
                    // TODO: TSEDUA110 → TSEDUA120 백업 로직 구현 필요
                    Map<String, Object> backupData = new HashMap<>();
                    if (record != null && record.getRecordMap() != null) {
                        backupData.putAll(record.getRecordMap());
                    }
                    backupData.put("baseYm", context.getInParameter("workYm"));
                    
                    dbInsert("insertTargetEdua120", backupData);
                    insertCnt1++;
                    
                    if (getCurrentSize() % commitCount == 0) {
                        txCommit();
                    }
                } catch(Exception e) {
                    log.error("[에러발생] Position=" + getCurrentSize() + ", record=" + record.toString().trim(), e);
                    // 원본 에러 정보 로깅
                    log.error("데이터베이스 작업 오류 - 에러코드: 59, 메시지: CHECK DATABASE STATUS, 상세: 데이터베이스 작업 중 오류가 발생했습니다", e);
                    // TODO: 에러코드 B3900042, 액션메시지 UKII0182 확인 필요 - 개발자 검증 요망
                    throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
                }
            }
        };
    }
    
    /**
     * TSEDUA111 백업 핸들러
     */
    private AbsRecordHandler makeBackupHandler111() {
        return new AbsRecordHandler(this) {
            public void handleRecord(IRecord record) {
                try {
                    context.setProgressCurrent(getCurrentSize());
                    
                    readCnt2++;
                    // TODO: TSEDUA111 → TSEDUA121 백업 로직 구현 필요
                    Map<String, Object> backupData = new HashMap<>();
                    if (record != null && record.getRecordMap() != null) {
                        backupData.putAll(record.getRecordMap());
                    }
                    backupData.put("baseYm", context.getInParameter("workYm"));
                    
                    dbInsert("insertTargetEdua121", backupData);
                    insertCnt2++;
                    
                    if (getCurrentSize() % commitCount == 0) {
                        txCommit();
                    }
                } catch(Exception e) {
                    log.error("[에러발생] Position=" + getCurrentSize() + ", record=" + record.toString().trim(), e);
                    // 원본 에러 정보 로깅
                    log.error("데이터베이스 작업 오류 - 에러코드: 59, 메시지: CHECK DATABASE STATUS, 상세: 데이터베이스 작업 중 오류가 발생했습니다", e);
                    // TODO: 에러코드 B3900042, 액션메시지 UKII0182 확인 필요 - 개발자 검증 요망
                    throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
                }
            }
        };
    }

    /**
     * 배치 후처리 메소드.
     * beforeExecute(), execute() 의 Exception 발생 여부와 관계없이 이 메소드는 실행됨
     */
    @Override
    public void afterExecute() {
        // S9300-DISPLAY-RESULTS-RTN 구현
        log.info("*------------------------------------------*");
        log.info("* BIP0003 PGM END                          *");
        log.info("*------------------------------------------*");
        log.info("* read   TSEDUA110 COUNT = " + readCnt1);
        log.info("* read   TSEDUA111 COUNT = " + readCnt2);
        log.info("* read   TSEDUA120 COUNT = " + readCnt3);
        log.info("* read   TSEDUA121 COUNT = " + readCnt4);
        log.info("* DELETE TSEDUA120 COUNT = " + deleteCnt3);
        log.info("* DELETE TSEDUA121 COUNT = " + deleteCnt4);
        log.info("* INSERT TSEDUA120 COUNT = " + insertCnt1);
        log.info("* INSERT TSEDUA121 COUNT = " + insertCnt2);
        log.info("*------------------------------------------*");
        
        if(super.exceptionInExecute == null){
            log.info("배치 정상 완료");
        } else {
            log.info("배치 오류 발생");
        }
    }
    
    /**
     * BR-028-009, BR-028-012: 기준년월 형식 검증.
     * YYYYMM 형식 확인
     */
    private boolean isValidYearMonth(String yearMonth) {
        if (yearMonth == null || yearMonth.length() != 6) {
            return false;
        }
        
        try {
            int year = Integer.parseInt(yearMonth.substring(0, 4));
            int month = Integer.parseInt(yearMonth.substring(4, 6));
            
            return year >= 1900 && year <= 2100 && month >= 1 && month <= 12;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * BR-028-003, BR-028-007: 금액 필드 검증.
     * 음수가 아닌 값 확인
     */
    private boolean isValidAmount(Object amount) {
        if (amount == null) return true; // null은 허용
        
        try {
            if (amount instanceof Number) {
                return ((Number) amount).doubleValue() >= 0;
            }
            double value = Double.parseDouble(amount.toString());
            return value >= 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * BR-028-004: 여신잔액 제약조건 검증.
     * 여신잔액 <= 총여신금액
     */
    private boolean isValidCreditBalance(Object balance, Object totalAmount) {
        if (balance == null || totalAmount == null) return true;
        
        try {
            double balanceVal = balance instanceof Number ? 
                ((Number) balance).doubleValue() : Double.parseDouble(balance.toString());
            double totalVal = totalAmount instanceof Number ? 
                ((Number) totalAmount).doubleValue() : Double.parseDouble(totalAmount.toString());
                
            return balanceVal <= totalVal;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * BR-028-006: 주채무계열그룹여부 검증.
     * 'Y', 'N', 또는 공백만 허용
     */
    private boolean isValidMainDebtFlag(String flag) {
        return flag == null || flag.trim().isEmpty() || 
               "Y".equals(flag) || "N".equals(flag);
    }
}
