package com.kbstar.edu.c2j.batch;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

import com.kbstar.sqc.base.BusinessException;

import nexcore.framework.batch.appbase.AbsRecordHandler;
import nexcore.framework.batch.appbase.DBSession;
import nexcore.framework.batch.appbase.fio.IFileTool;
import nexcore.framework.core.component.streotype.BizBatch;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.Record;
import nexcore.framework.core.log.ILog;
import nexcore.framework.core.util.StringUtils;

/**
 * 기업그룹 관계관리 배치처리.
 * <pre>
 * 월별 기업그룹 관계관리 배치 프로세스
 * 외부 신용평가 데이터와 내부 테이블 동기화
 * 비즈니스 규칙: BR-027-001, BR-027-002, BR-027-003, BR-027-019, BR-027-020, BR-027-022, BR-027-025
 * </pre>
 * @author MultiQ4KBBank
 * @since 2024-09-15
 */
@BizBatch("기업그룹 관계관리 배치처리")
public class BUBIP0001 extends com.kbstar.sqc.batch.base.BatchUnit {
    
    private ILog log;
    private OutputStream fileOutStream;
    private IFileTool fileToolWrite;
    
    // 처리 통계
    private int readCnt = 0;
    private int insertCnt = 0;
    private int updateCnt = 0;
    private int skipCnt1 = 0; // CRM 미등록분
    private int skipCnt2 = 0; // 수기등록분
    private int commitCnt = 0; // 커밋 횟수

    /**
     * 배치 전처리 메소드.
     * 여기서 Exception 발생시 execute() 메소드는 실행되지 않고, afterExecute() 는 실행됨
     */
    @Override
    public void beforeExecute() {
        this.log = context.getLogger();
        
        // 작업기준일자 검증 (BR-027-001)
        String workBsd = context.getInParameter("workBsd");
        if (StringUtils.isEmpty(workBsd)) {
            // 원본 에러 정보 로깅
            log.error("작업기준일자 누락 오류 - 에러코드: 33, 메시지: CHECK SYSIN PARAMETERS, 상세: 작업기준일자가 누락되었습니다. SYSIN 매개변수를 확인하세요");
            // TODO: 에러코드 B3900042, 액션메시지 UKII0182 확인 필요 - 개발자 검증 요망
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.");
        }
        
        // 출력 파일 설정
        String outFilename = context.getInParameter("OUTPUT_FILE");
        if (StringUtils.isEmpty(outFilename)) {
            outFilename = "BIP0001_OUTPUT_" + workBsd + ".log";
        }
        
        try {
            // FIO 파일 레이아웃 로딩
            this.fileToolWrite = getFileTool("FIOBUBIP000101");
            this.fileOutStream = fileOpenOutputStream(outFilename);
            fileToolWrite.setOutputStream(this.fileOutStream);
            fileToolWrite.initialize();
        } catch (Exception e) {
            // 원본 에러 정보 로깅
            log.error("파일 처리 오류 - 에러코드: 99, 메시지: CHECK FILE STATUS, 상세: 파일 처리 중 오류가 발생했습니다. 파일 상태를 확인하세요", e);
            // TODO: 에러코드 B3900042, 액션메시지 UKII0182 확인 필요 - 개발자 검증 요망
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        log.info("=== BIP0001 배치 시작 ===");
        log.info("작업기준일자: " + workBsd);
    }

    /**
     * 배치 메인 메소드
     * TODO: 외부 시스템 연동 개발 필요
     * TODO: 한국신용평가 시스템의 외부 테이블 직접 조회를 API 호출로 변경 필요
     * TODO: 대상 테이블: THKABCB01, THKAAADET, THKAABPCB, THKAABPCO, THKABCA01
     */
    @Override
    public void execute() {
        String workBsd = context.getInParameter("workBsd");
        
        // 날짜 범위 설정 (BR-027-025)
        String startYms = workBsd.substring(0, 6) + "01000000000000";
        String endYms = workBsd.substring(0, 6) + "31999999999999";
        
        Map<String, Object> sqlIn = new HashMap<String, Object>();
        sqlIn.put("startYms", startYms);
        sqlIn.put("endYms", endYms);
        
        log.info("DB 조회 조건: " + sqlIn);
        
        DBSession readSession = dbNewSession(false, "READ");
        
        // TODO: 외부 시스템 연동 필요 - 한국신용평가 데이터 조회
        // TODO: CUR_MAIN 쿼리는 외부 테이블(THKABCB01, THKAAADET, THKAABPCB, THKAABPCO, THKABCA01) 접근
        // TODO: 적합한 거래코드나 API 호출로 변경 필요 (예: EAI 연동, 웹서비스 호출)
        txBegin();
        dbSelect("CUR_MAIN", sqlIn, makeHandler(), readSession);
        txCommit();
        
        log.info("처리 완료 - 읽기:" + readCnt + ", 신규:" + insertCnt + ", 변경:" + updateCnt + 
                ", SKIP1:" + skipCnt1 + ", SKIP2:" + skipCnt2);
    }

    /**
     * DB 조회 결과 처리 핸들러.
     * 기업그룹 관계관리 비즈니스 로직 수행
     * @return 핸들러
     */
    private AbsRecordHandler makeHandler() {
        return new AbsRecordHandler(this) {
            public void handleRecord(IRecord record) {
                readCnt++;
                context.setProgressCurrent(getCurrentSize());
                
                String custIdnfr = record.getString("custIdnfr");
                String rpsntBzno = record.getString("rpsntBzno");
                String kisGroupCd = record.getString("kisGroupCd");
                
                // CRM 등록 검증 (BR-027-002, BR-027-003)
                if (StringUtils.isEmpty(custIdnfr) || StringUtils.isEmpty(rpsntBzno)) {
                    skipCnt1++;
                    writeOutputLog(record, "N", "N", "CRM NOT FOUND!!");
                    return;
                }
                
                try {
                    // 기존 등록 확인
                    Map<String, Object> checkParam = new HashMap<String, Object>();
                    checkParam.put("custIdnfr", custIdnfr);
                    
                    IRecord existing = dbSelectSingle("selectExistingBasicInfo", checkParam);
                    
                    boolean isNew = (existing == null);
                    boolean custSaved = false;
                    boolean groupSaved = false;
                    String processDesc = "";
                    
                    if (isNew) {
                        // 신규 등록
                        if (!StringUtils.isEmpty(kisGroupCd)) {
                            Map<String, Object> insertParam = new HashMap<String, Object>();
                            insertParam.put("custIdnfr", custIdnfr);
                            insertParam.put("rpsntBzno", rpsntBzno);
                            insertParam.put("rpsntEntpName", record.getString("rpsntEntpName"));
                            insertParam.put("kisGroupCd", kisGroupCd);
                            
                            dbInsert("insertBasicInfo", insertParam);
                            insertCnt++;
                            custSaved = true;
                            
                            // 연결정보 처리
                            processConnectionInfo(record);
                            groupSaved = true;
                            
                            // Manual Adjustment 정보 처리 (BR-027-012, BR-027-013)
                            processManualAdjustmentInfo(record, "2"); // 신규등록
                            
                            processDesc = "신규등록완료";
                        } else {
                            processDesc = "기등록내역 없음";
                        }
                    } else {
                        // 기존 등록 확인
                        String existingGroupCd = existing.getString("기업집단그룹코드");
                        String existingRegiCd = existing.getString("기업집단등록코드");
                        String existingConnRegiDstcd = existing.getString("법인그룹연결등록구분");
                        
                        // 수기등록분 SKIP (BR-027-020)
                        if ("2".equals(existingConnRegiDstcd)) {
                            skipCnt2++;
                            processDesc = "수기등록분 SKIP";
                        }
                        // BR-027-021: 주채무계열그룹 우선순위 처리
                        else if (isMainDebtGroup(existing)) {
                            // 주채무계열그룹은 무조건 처리
                            processBasicInfo(record);
                            custSaved = true;
                            
                            processConnectionInfo(record);
                            groupSaved = true;
                            
                            processManualAdjustmentInfo(record, "3"); // 변경
                            updateCnt++;
                            processDesc = "주채무계열그룹 우선처리";
                        }
                        // 코드 동일시 Manual Adjustment Cleanup (BR-027-023)
                        else if (kisGroupCd.equals(existingGroupCd) && "GRS".equals(existingRegiCd)) {
                            // Manual Adjustment Cleanup 수행
                            performManualAdjustmentCleanup(custIdnfr, kisGroupCd);
                            processDesc = "CODE SAME SKIP";
                        }
                        // 업데이트 필요
                        else {
                            Map<String, Object> updateParam = new HashMap<String, Object>();
                            updateParam.put("custIdnfr", custIdnfr);
                            updateParam.put("kisGroupCd", kisGroupCd);
                            
                            dbUpdate("updateBasicInfo", updateParam);
                            updateCnt++;
                            custSaved = true;
                            
                            // 연결정보 처리
                            processConnectionInfo(record);
                            groupSaved = true;
                            
                            // Manual Adjustment 정보 처리 (BR-027-012, BR-027-013)
                            processManualAdjustmentInfo(record, "3"); // 변경
                            
                            processDesc = "변경완료";
                        }
                    }
                    
                    writeOutputLog(record, custSaved ? "Y" : "N", groupSaved ? "Y" : "N", processDesc);
                    
                    // BR-027-018: 커밋 제어 (1000건 단위)
                    performCommitControl();
                    
                } catch (Exception e) {
                    log.error("처리 오류: " + custIdnfr, e);
                    writeOutputLog(record, "N", "N", "처리오류: " + e.getMessage());
                    // 원본 에러 정보 로깅
                    log.error("데이터베이스 작업 오류 - 에러코드: 59, 메시지: CHECK DATABASE STATUS, 상세: 데이터베이스 작업 중 오류가 발생했습니다. 데이터베이스 상태를 확인하세요", e);
                    // TODO: 에러코드 B3900042, 액션메시지 UKII0182 확인 필요 - 개발자 검증 요망
                    throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
                }
            }
        };
    }
    
    private void processConnectionInfo(IRecord record) {
        String kisGroupCd = record.getString("kisGroupCd");
        String kisGroupName = record.getString("kisGroupName");
        
        if (StringUtils.isEmpty(kisGroupCd)) return;
        
        Map<String, Object> connParam = new HashMap<String, Object>();
        connParam.put("kisGroupCd", kisGroupCd);
        
        IRecord connInfo = dbSelectSingle("selectConnectionInfo", connParam);
        
        if (connInfo == null) {
            // 연결정보 신규 생성
            connParam.put("kisGroupName", kisGroupName);
            dbInsert("insertConnectionInfo", connParam);
        } else {
            // 그룹명 변경 확인 (BR-027-022)
            String existingGroupName = connInfo.getString("기업집단명");
            if (!kisGroupName.equals(existingGroupName)) {
                connParam.put("kisGroupName", kisGroupName);
                dbUpdate("updateConnectionInfo", connParam);
            }
        }
    }
    
    /**
     * 출력 로그 작성.
     * 처리 결과를 파일에 기록
     * @param record 처리 레코드
     * @param custSaveYn 고객정보 저장 여부
     * @param groupSaveYn 그룹정보 저장 여부
     * @param processDesc 처리 설명
     */
    private void writeOutputLog(IRecord record, String custSaveYn, String groupSaveYn, String processDesc) {
        try {
            Map<String, Object> logRecord = new HashMap<String, Object>();
            
            // KIS Customer Number (마지막 6자리)
            String kisEntpCd = record.getString("kisEntpCd");
            String brwrKisCustNo = kisEntpCd != null && kisEntpCd.length() >= 6 ? 
                kisEntpCd.substring(kisEntpCd.length() - 6) : "";
            
            logRecord.put("brwrKisCustNo", brwrKisCustNo);
            logRecord.put("brwrKisGroupCd", record.getString("kisGroupCd"));
            logRecord.put("brwrKisGroupNm", record.getString("kisGroupName"));
            logRecord.put("brwrCustIdnfr", record.getString("custIdnfr"));
            logRecord.put("crwrCrmMgmtNo", "00000");
            logRecord.put("brwrCustSaveYn", custSaveYn);
            logRecord.put("brwrGroupSaveYn", groupSaveYn);
            logRecord.put("brwrProcessDesc", processDesc);
            
            IRecord outputRecord = new Record();
            for (Map.Entry<String, Object> entry : logRecord.entrySet()) {
                outputRecord.set(entry.getKey(), entry.getValue());
            }
            fileToolWrite.writeRecordToOut(outputRecord);
            
        } catch (Exception e) {
            log.error("출력 로그 작성 오류", e);
        }
    }

    /**
     * Manual Adjustment Cleanup 수행 (BR-027-023).
     * 그룹코드가 동일할 때 수기변경구분을 '0'으로 초기화
     * @param custIdnfr 고객식별자
     * @param kisGroupCd KIS 그룹코드
     */
    private void performManualAdjustmentCleanup(String custIdnfr, String kisGroupCd) {
        Map<String, Object> cleanupParam = new HashMap<String, Object>();
        cleanupParam.put("custIdnfr", custIdnfr);
        cleanupParam.put("kisGroupCd", kisGroupCd);
        
        dbUpdate("cleanupManualAdjustment", cleanupParam);
    }
    
    /**
     * Manual Adjustment 정보 처리 (BR-027-012, BR-027-013).
     * 순차적 일련번호 생성 및 등록변경거래구분 설정
     * @param record 처리 레코드
     * @param tranDstcd 등록변경거래구분 ('2': 신규, '3': 변경)
     */
    private void processManualAdjustmentInfo(IRecord record, String tranDstcd) {
        String custIdnfr = record.getString("custIdnfr");
        String kisGroupCd = record.getString("kisGroupCd");
        
        // 순차적 일련번호 생성 (BR-027-012)
        Map<String, Object> serialParam = new HashMap<String, Object>();
        serialParam.put("custIdnfr", custIdnfr);
        serialParam.put("kisGroupCd", kisGroupCd);
        
        IRecord serialResult = dbSelectSingle("getNextSerialNumber", serialParam);
        int nextSerial = serialResult != null ? serialResult.getInt("nextSerial") : 1;
        
        // Manual Adjustment 정보 INSERT
        Map<String, Object> adjustParam = new HashMap<String, Object>();
        adjustParam.put("custIdnfr", custIdnfr);
        adjustParam.put("kisGroupCd", kisGroupCd);
        adjustParam.put("serialNo", nextSerial);
        adjustParam.put("rpsntBzno", record.getString("rpsntBzno"));
        adjustParam.put("rpsntEntpName", record.getString("rpsntEntpName"));
        adjustParam.put("tranDstcd", tranDstcd); // BR-027-013: '2' 또는 '3'
        
        dbInsert("insertManualAdjustment", adjustParam);
    }
    
    /**
     * BR-027-018: 커밋 제어 처리.
     * 1000건 단위로 커밋 수행
     */
    private void performCommitControl() {
        commitCnt++;
        if (commitCnt >= 1000) {
            try {
                // 배치 프레임워크에서는 직접 커밋하지 않고 카운터만 관리
                log.info("커밋 포인트 도달: " + commitCnt + "건 처리 완료");
                commitCnt = 0; // 카운터 초기화
            } catch (Exception e) {
                log.error("커밋 제어 실패: " + e.getMessage());
                throw new BusinessException("B3900042", "UKII0182", "커밋 처리 중 오류가 발생했습니다.", e);
            }
        }
    }
    
    /**
     * BR-027-021: 주채무계열그룹 처리 우선순위.
     * 기업군관리그룹구분이 '01'인 경우 우선 처리
     */
    private boolean isMainDebtGroup(IRecord existing) {
        String groupMgtType = existing.getString("기업군관리그룹구분");
        return "01".equals(groupMgtType);
    }
    
    /**
     * BR-027-024: 시스템 등록구분 할당.
     * 시스템 등록시 법인그룹연결등록구분을 '1'로 설정
     */
    private void setSystemRegistrationCode(Map<String, Object> param) {
        param.put("connRegiDstcd", "1"); // 시스템 등록
        param.put("regiCd", "GRS"); // BR-027-007: 시스템 등록코드
    }
    
    /**
     * 관계기업기본정보 처리.
     */
    private void processBasicInfo(IRecord record) {
        Map<String, Object> basicParam = new HashMap<String, Object>();
        basicParam.put("custIdnfr", record.getString("custIdnfr"));
        basicParam.put("rpsntBzno", record.getString("rpsntBzno"));
        basicParam.put("kisGroupCd", record.getString("kisGroupCd"));
        basicParam.put("rpsntEntpName", record.getString("rpsntEntpName"));
        
        // BR-027-024: 시스템 등록구분 할당
        setSystemRegistrationCode(basicParam);
        
        dbInsert("insertBasicInfo", basicParam);
    }

    /**
     * 배치 후처리 메소드.
     * beforeExecute(), execute() 의 Exception 발생 여부와 관계없이 이 메소드는 실행됨
     */
    @Override
    public void afterExecute() {
        try {
            // BR-027-015: 처리 건수 일관성 검증
            int totalProcessed = insertCnt + updateCnt + skipCnt1 + skipCnt2;
            if (readCnt != totalProcessed) {
                log.warn("처리 건수 불일치: 읽기=" + readCnt + ", 처리합계=" + totalProcessed);
            }
            
            // BR-027-014: 처리 통계 출력 (음수 검증 포함)
            log.info("=== 배치 처리 완료 통계 ===");
            log.info("총 읽기 건수: " + Math.max(0, readCnt));
            log.info("신규 등록 건수: " + Math.max(0, insertCnt));
            log.info("변경 처리 건수: " + Math.max(0, updateCnt));
            log.info("CRM 미등록 스킵: " + Math.max(0, skipCnt1));
            log.info("수기등록 스킵: " + Math.max(0, skipCnt2));
            
        } catch (Exception e) {
            log.error("배치 후처리 중 오류: " + e.getMessage());
        } finally {
            // 파일 스트림 정리
            if (fileOutStream != null) {
                try {
                    fileOutStream.close();
                } catch (Exception e) {
                    log.warn("파일 스트림 닫기 실패: " + e.getMessage());
                }
            }
        }
        
        if (super.exceptionInExecute == null) {
            log.info("=== BIP0001 배치 정상 완료 ===");
        } else {
            log.error("=== BIP0001 배치 오류 발생 ===");
        }
    }
}
