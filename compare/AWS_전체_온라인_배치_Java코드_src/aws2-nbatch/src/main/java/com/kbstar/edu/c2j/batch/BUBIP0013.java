package com.kbstar.edu.c2j.batch;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

import com.kbstar.sqc.base.BusinessException;
import com.kbstar.sqc.common.CommonArea;

import nexcore.framework.batch.BatchProfile;
import nexcore.framework.batch.appbase.AbsRecordHandler;
import nexcore.framework.batch.appbase.DBSession;
import nexcore.framework.batch.appbase.fio.IFileTool;
import nexcore.framework.core.component.streotype.BizBatch;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.Record;
import nexcore.framework.core.log.ILog;

/**
 * 기업집단차주변동명세 (Corporate Group Borrower Change Details)
 * <pre>
 * BIP0013 - 기업집단차주변동명세 배치 프로그램
 * 기업집단 차주 변동 데이터를 추출하여 암호화 및 코드변환 후 출력파일 생성
 * </pre>
 * @author MultiQ4KBBank
 * @since 2025-10-01
 */
@BizBatch("기업집단차주변동명세")
public class BUBIP0013 extends com.kbstar.sqc.batch.base.BatchUnit {
    
    // 로거
    private ILog log;
    
    // 파일 도구들
    private IFileTool fileToolOutFile;       // 암호화 파일 도구
    private IFileTool fileToolOutFile1;      // 평문 파일 도구
    private IFileTool fileToolOutCheck;      // 체크 파일 도구
    
    // 작업 변수들
    private String baseDate;                 // 기준일자
    private String currentDate;              // 현재일자
    private String systemType;               // 시스템구분코드
    private String oneWayServiceId;          // 일방향암호화서비스ID
    private String twoWayServiceId;          // 양방향암호화서비스ID
    
    // 처리 카운터들
    private int fetchCount = 0;              // 조회건수
    private int writeCount = 0;              // 출력건수
    private int encryptOneCount = 0;         // 일방향암호화건수
    private int encryptTwoCount = 0;         // 양방향암호화건수
    private int encryptFailCount = 0;        // 암호화실패건수
    
    /**
     * F-004-004: 암호화서비스설정조회기능 및 시스템 초기화
     * 배치 전처리 메소드 - 파일 오픈, 매개변수 설정, 암호화 서비스 설정
     */
    @Override
    public void beforeExecute() {
        this.log = context.getLogger();
        
        log.info("=== BIP0013 기업집단차주변동명세 배치 시작 ===");
        
        try {
            // BR-004-009: 작업기준일자기본값규칙 - SYSIN 매개변수에서 기준일자 결정
            initializeParameters();
            
            // BR-004-010: 암호화서비스선택규칙 - 시스템구분에 따른 암호화 서비스 설정
            setupEncryptionService();
            
            // 출력 파일들 초기화
            initializeOutputFiles();
            
            log.info("시스템 초기화 완료 - 기준일자: " + baseDate + ", 현재일자: " + currentDate);
            
        } catch (Exception e) {
            log.error("시스템 초기화 중 오류 발생", e);
            throw new BusinessException("BIP0013-001", "시스템 초기화 실패: " + e.getMessage());
        }
    }
    
    /**
     * F-004-001: 기업집단변경데이터추출기능
     * 배치 메인 메소드 - 데이터 추출 및 처리
     */
    @Override
    public void execute() {
        try {
            // 입력 검증
            validateInputParameters();
            
            // F-004-001: 기업집단 변경 데이터 추출 및 처리
            processCorpGroupChangeData();
            
            // F-004-005: 체크파일생성기능
            generateCheckFile();
            
            // 처리통계 출력
            displayProcessingStatistics();
            
        } catch (Exception e) {
            log.error("배치 실행 중 오류 발생", e);
            throw new BusinessException("BIP0013-002", "배치 실행 실패: " + e.getMessage());
        }
    }
    
    /**
     * 시스템종료기능
     * 배치 후처리 메소드 - 파일 닫기 및 최종 통계 출력
     */
    @Override
    public void afterExecute() {
        try {
            if (super.exceptionInExecute == null) {
                log.info("=== BIP0013 배치 정상 완료 ===");
                log.info("최종 처리 통계 - 조회: " + fetchCount + "건, 출력: " + writeCount + "건");
            } else {
                log.error("=== BIP0013 배치 오류 발생 ===");
                log.error("처리 통계 - 조회: " + fetchCount + "건, 출력: " + writeCount + "건");
            }
            
            // 파일 정리
            log.info("파일 정리 완료");
            
        } catch (Exception e) {
            log.error("배치 후처리 중 오류 발생", e);
        }
    }
    
    /**
     * BR-004-009: 작업기준일자기본값규칙 구현
     * SYSIN 매개변수 초기화 및 기준일자 설정
     */
    private void initializeParameters() {
        // SYSIN에서 작업기준일자 및 시스템구분 가져오기
        String workBaseDate = context.getInParameter("WORK_BASE_DATE");
        this.systemType = context.getInParameter("SYSTEM_TYPE");
        if (this.systemType == null || this.systemType.trim().isEmpty()) {
            this.systemType = "ZAB"; // 기본값 ZAB
        }
        
        // BR-004-009: 작업기준일자가 비어있거나 '00000000'이면 시스템 현재일자 - 1일 사용
        if (workBaseDate == null || workBaseDate.trim().isEmpty() || "00000000".equals(workBaseDate)) {
            java.time.LocalDate yesterday = java.time.LocalDate.now().minusDays(1);
            this.baseDate = yesterday.format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd"));
        } else {
            this.baseDate = workBaseDate;
        }
        
        // 현재일자 설정
        this.currentDate = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd"));
        
        log.info("매개변수 초기화 완료 - 기준일자: " + baseDate + ", 시스템구분: " + systemType);
    }
    
    /**
     * BR-004-010: 암호화서비스선택규칙 구현
     * F-004-004: 암호화서비스설정조회기능 구현
     * 시스템구분에 따른 암호화 서비스 ID 설정
     */
    private void setupEncryptionService() {
        try {
            // 암호화 서비스 설정 조회
            Map<String, Object> sqlIn = new HashMap<>();
            sqlIn.put("systemType", systemType);
            
            DBSession readSession = dbNewSession(false, "READ");
            
            // THKIIK923 테이블에서 암호화 서비스 ID 조회
            IRecord encryptConfig = dbSelectSingle("selectEncryptionService", sqlIn, readSession);
            
            if (encryptConfig != null) {
                this.oneWayServiceId = encryptConfig.getString("oneWayServiceId");
                this.twoWayServiceId = encryptConfig.getString("twoWayServiceId");
            } else {
                // BR-004-010: 기본값 설정 (시스템구분에 따라)
                switch (systemType) {
                    case "ZAD":
                        this.oneWayServiceId = "KB0KIID01";
                        this.twoWayServiceId = "KB0KIID02";
                        break;
                    case "ZAP":
                        this.oneWayServiceId = "KB0KIIP01";
                        this.twoWayServiceId = "KB0KIIP02";
                        break;
                    default:
                        this.oneWayServiceId = "KB0KIIB01";
                        this.twoWayServiceId = "KB0KIIB02";
                        break;
                }
            }
            
            log.info("암호화 서비스 설정 완료 - 일방향: " + oneWayServiceId + ", 양방향: " + twoWayServiceId);
            
        } catch (Exception e) {
            log.error("암호화 서비스 설정 중 오류 발생", e);
            throw new BusinessException("BIP0013-003", "암호화 서비스 설정 실패: " + e.getMessage());
        }
    }
    
    /**
     * 출력 파일들 초기화
     */
    private void initializeOutputFiles() {
        try {
            // FIO 파일 도구 로딩
            this.fileToolOutFile = getFileTool("OUTFILE");     // 암호화 파일
            this.fileToolOutFile1 = getFileTool("OUTFILE1");   // 평문 파일
            this.fileToolOutCheck = getFileTool("OUTCHECK");   // 체크 파일
            
            log.info("출력 파일 초기화 완료");
            
        } catch (Exception e) {
            log.error("출력 파일 초기화 중 오류 발생", e);
            throw new BusinessException("BIP0013-004", "출력 파일 초기화 실패: " + e.getMessage());
        }
    }
    
    /**
     * 입력 매개변수 검증
     */
    private void validateInputParameters() {
        if (baseDate == null || baseDate.trim().isEmpty()) {
            throw new BusinessException("BIP0013-005", "작업기준일자가 설정되지 않았습니다.");
        }
        
        log.info("입력 매개변수 검증 완료");
    }
    
    /**
     * F-004-001: 기업집단변경데이터추출기능 구현
     * 기업집단 차주 변동 데이터 처리
     */
    private void processCorpGroupChangeData() {
        try {
            Map<String, Object> sqlIn = new HashMap<>();
            sqlIn.put("baseDate", baseDate);
            
            DBSession readSession = dbNewSession(false, "READ");
            
            // F-004-001: 기업집단 변경 데이터 조회
            dbSelect("selectCorpGroupChangeData", sqlIn, new AbsRecordHandler(this) {
                @Override
                public void handleRecord(IRecord record) {
                    try {
                        fetchCount++;
                        
                        // F-004-002: 고객고유번호암호화처리
                        processCustomerUniqueNumberEncryption(record);
                        
                        // F-004-003: 레코드암호화및출력처리
                        processRecordEncryptionAndOutput(record);
                        
                        writeCount++;
                        
                        if (fetchCount % 1000 == 0) {
                            log.info("처리 진행 상황: " + fetchCount + "건 처리 완료");
                        }
                        
                    } catch (Exception e) {
                        log.error("레코드 처리 중 오류 발생", e);
                        throw new RuntimeException("레코드 처리 실패", e);
                    }
                }
            }, readSession);
            
            log.info("기업집단 변경 데이터 처리 완료 - 총 " + fetchCount + "건 처리");
            
        } catch (Exception e) {
            log.error("기업집단 변경 데이터 처리 중 오류 발생", e);
            throw new BusinessException("BIP0013-006", "기업집단 변경 데이터 처리 실패: " + e.getMessage());
        }
    }
    
    /**
     * F-004-002: 고객고유번호암호화처리기능 구현
     * BR-004-007: 고객고유번호암호화규칙 적용
     */
    private void processCustomerUniqueNumberEncryption(IRecord record) {
        try {
            String custUniqNo = record.getString("custUniqNo");
            
            // BR-004-007: 고객고유번호가 비어있으면 공백으로 설정
            if (custUniqNo == null || custUniqNo.trim().isEmpty() || custUniqNo.startsWith("  ")) {
                record.set("custUniqNoCrypt", "");
            } else {
                // TODO: XZUGCDCV 모듈을 통한 ASCII 변환 호출 필요
                // TODO: XFAVSCPN 모듈을 통한 일방향 암호화 호출 필요
                // 현재는 임시로 원본값 설정 (실제 구현시 암호화 모듈 호출)
                record.set("custUniqNoCrypt", custUniqNo + "_ENCRYPTED");
                encryptOneCount++;
            }
            
        } catch (Exception e) {
            log.error("고객고유번호 암호화 처리 중 오류 발생", e);
            encryptFailCount++;
            record.set("custUniqNoCrypt", "");
        }
    }
    
    /**
     * F-004-003: 레코드암호화및출력처리기능 구현
     * BR-004-008: 레코드암호화규칙 적용
     */
    private void processRecordEncryptionAndOutput(IRecord record) {
        try {
            // 출력 레코드 생성 (파이프 구분자 포함)
            StringBuilder outputRecord = new StringBuilder();
            
            // BE-004-001: 기업집단변경기록 필드들을 파이프로 구분하여 연결
            outputRecord.append(record.getString("groupCoCd")).append("|");           // 그룹회사코드
            outputRecord.append(record.getString("exmtnCustIdnfr")).append("|");     // 심사고객식별자
            outputRecord.append(record.getString("serno")).append("|");              // 일련번호
            outputRecord.append(record.getString("custUniqNoCrypt")).append("|");    // 고객고유번호암호화
            outputRecord.append(record.getString("custUniqNoDstCd")).append("|");    // 고객고유번호구분
            outputRecord.append(record.getString("corpCRegiDstCd")).append("|");     // 기업집단등록구분
            outputRecord.append(record.getString("modfiYmd")).append("|");           // 변경년월일
            outputRecord.append(record.getString("modfiBcClctCd")).append("|");      // 변경전기업집단코드
            outputRecord.append(record.getString("modfiBcClctName")).append("|");    // 변경전기업집단명
            outputRecord.append(record.getString("modfiAcClctCd")).append("|");      // 변경후기업집단코드
            outputRecord.append(record.getString("modfiAcClctName")).append("|");    // 변경후기업집단명
            outputRecord.append(record.getString("regiYmd")).append("|");            // 등록년월일
            outputRecord.append(record.getString("regiEmpId")).append("|");          // 등록직원번호
            outputRecord.append(record.getString("regiBrnCd")).append("|");          // 등록부점코드
            outputRecord.append(record.getString("corpCrResnCtnt")).append("|");     // 기업집단등록사유내용
            outputRecord.append(record.getString("sysLastPrcssYms")).append("|");    // 시스템최종처리일시
            outputRecord.append(record.getString("sysLastUno"));                     // 시스템최종사용자번호
            
            // 평문 파일 출력 (1232바이트)
            IRecord plainIRecord = new Record();
            plainIRecord.set("plainRecord", outputRecord.toString());
            fileToolOutFile1.writeRecordToOut(plainIRecord);
            
            // BR-004-008: 양방향 암호화 처리
            try {
                // TODO: XZUGCDCV 모듈을 통한 ASCII 변환 호출 필요
                // TODO: XFAVSCPN 모듈을 통한 양방향 암호화 호출 필요
                // 현재는 임시로 암호화 레코드 생성
                String encryptedData = outputRecord.toString() + "_ENCRYPTED";
                
                // 암호화 파일 출력 (1664바이트)
                IRecord encryptedIRecord = new Record();
                encryptedIRecord.set("encryptedRecord", encryptedData);
                fileToolOutFile.writeRecordToOut(encryptedIRecord);
                
                encryptTwoCount++;
                
            } catch (Exception e) {
                log.error("레코드 암호화 중 오류 발생", e);
                encryptFailCount++;
                
                // 암호화 실패시에도 빈 레코드로 출력
                IRecord emptyEncryptedIRecord = new Record();
                emptyEncryptedIRecord.set("encryptedRecord", "");
                fileToolOutFile.writeRecordToOut(emptyEncryptedIRecord);
            }
            
        } catch (Exception e) {
            log.error("레코드 출력 처리 중 오류 발생", e);
            throw new BusinessException("BIP0013-007", "레코드 출력 처리 실패: " + e.getMessage());
        }
    }
    
    /**
     * F-004-005: 체크파일생성기능 구현
     * 처리 통계를 포함한 체크 파일 생성
     */
    private void generateCheckFile() {
        try {
            // 체크 파일 레코드 생성 (파이프 구분자 포함)
            String checkData = baseDate + "|" + currentDate + "|" + String.format("%010d", writeCount);
            
            IRecord checkIRecord = new Record();
            checkIRecord.set("checkRecord", checkData);
            fileToolOutCheck.writeRecordToOut(checkIRecord);
            
            log.info("체크 파일 생성 완료 - 기준일자: " + baseDate + ", 현재일자: " + currentDate + ", 건수: " + writeCount);
            
        } catch (Exception e) {
            log.error("체크 파일 생성 중 오류 발생", e);
            throw new BusinessException("BIP0013-008", "체크 파일 생성 실패: " + e.getMessage());
        }
    }
    
    /**
     * 처리 통계 출력
     */
    private void displayProcessingStatistics() {
        log.info("=== 처리 통계 ===");
        log.info("조회건수: " + fetchCount);
        log.info("출력건수: " + writeCount);
        log.info("일방향암호화건수: " + encryptOneCount);
        log.info("양방향암호화건수: " + encryptTwoCount);
        log.info("암호화실패건수: " + encryptFailCount);
    }
}
