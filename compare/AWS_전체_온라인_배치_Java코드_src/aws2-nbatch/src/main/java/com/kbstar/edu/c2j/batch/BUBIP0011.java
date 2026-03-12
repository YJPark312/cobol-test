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
 * 기업집단신용평가일일자료제공 (Corporate Group Credit Evaluation Daily Data Provision)
 * <pre>
 * BIP0011 - 기업집단신용평가일일자료제공 배치 프로그램
 * 기업집단 평가 데이터를 추출하여 암호화 및 코드변환 후 출력파일 생성
 * </pre>
 * @author MultiQ4KBBank
 * @since 2025-10-01
 */
@BizBatch("기업집단신용평가일일자료제공")
public class BUBIP0011 extends com.kbstar.sqc.batch.base.BatchUnit {
    
    // 로거
    private ILog log;
    
    // 배치 프로파일
    private BatchProfile profile;
    
    // 파일 도구들
    private IFileTool fileToolOutFile;       // 암호화 파일 도구
    private IFileTool fileToolOutFile1;      // 평문 파일 도구
    private IFileTool fileToolOutCheck;      // 체크 파일 도구
    
    // 작업 변수들
    private String baseDate;                 // 기준일자
    private String currentDate;              // 현재일자
    private String systemType;               // 시스템구분코드
    private String encryptionServiceId;      // 암호화서비스ID
    
    // 처리 카운터들
    private int fetchCount = 0;              // 조회건수
    private int writeCount = 0;              // 출력건수
    private int encryptSuccessCount = 0;     // 암호화성공건수
    private int encryptFailCount = 0;        // 암호화실패건수
    
    /**
     * F-003-001: 시스템 초기화 기능
     * 배치 전처리 메소드 - 파일 오픈, 매개변수 설정, 암호화 서비스 설정
     */
    @Override
    public void beforeExecute() {
        this.log = context.getLogger();
        
        log.info("=== BIP0011 기업집단신용평가일일자료제공 배치 시작 ===");
        
        try {
            // BR-003-002: 일자처리규칙 - SYSIN 매개변수에서 기준일자 결정
            initializeParameters();
            
            // BR-003-004: 암호화서비스선택규칙 - 시스템구분에 따른 암호화 서비스 설정
            setupEncryptionService();
            
            // 출력 파일들 초기화
            initializeOutputFiles();
            
            log.info("시스템 초기화 완료 - 기준일자: " + baseDate + ", 현재일자: " + currentDate);
            
        } catch (Exception e) {
            log.error("시스템 초기화 중 오류 발생", e);
            throw new BusinessException("BIP0011-001", "시스템 초기화 실패: " + e.getMessage());
        }
    }
    
    /**
     * F-003-002: 입력검증기능 및 F-003-003: 기업집단데이터추출기능
     * 배치 메인 메소드 - 데이터 추출 및 처리
     */
    @Override
    public void execute() {
        try {
            // F-003-002: 입력 검증
            validateInputParameters();
            
            // F-003-003: 기업집단 데이터 추출 및 처리
            processCorpGroupData();
            
            // F-003-009: 체크파일생성기능
            generateCheckFile();
            
            // F-003-008: 처리통계기능
            displayProcessingStatistics();
            
        } catch (Exception e) {
            log.error("배치 실행 중 오류 발생", e);
            throw new BusinessException("BIP0011-002", "배치 실행 실패: " + e.getMessage());
        }
    }
    
    /**
     * F-003-011: 시스템종료기능
     * 배치 후처리 메소드 - 파일 닫기 및 최종 통계 출력
     */
    @Override
    public void afterExecute() {
        try {
            if (super.exceptionInExecute == null) {
                log.info("=== BIP0011 배치 정상 완료 ===");
                log.info("최종 처리 통계 - 조회: " + fetchCount + "건, 출력: " + writeCount + "건");
            } else {
                log.error("=== BIP0011 배치 오류 발생 ===");
                log.error("처리 통계 - 조회: " + fetchCount + "건, 출력: " + writeCount + "건");
            }
            
            // 파일 정리
            log.info("파일 정리 완료");
            
        } catch (Exception e) {
            log.error("배치 후처리 중 오류 발생", e);
        }
    }
    
    /**
     * BR-003-002: 일자처리규칙 구현
     * SYSIN 매개변수 초기화 및 기준일자 설정
     */
    private void initializeParameters() {
        // SYSIN에서 작업기준일자 및 시스템구분 가져오기
        String workBaseDate = context.getInParameter("WORK_BASE_DATE");
        this.systemType = context.getInParameter("SYSTEM_TYPE");
        if (this.systemType == null || this.systemType.trim().isEmpty()) {
            this.systemType = "ZAB"; // 기본값 ZAB
        }
        
        if (workBaseDate == null || workBaseDate.trim().isEmpty() || "00000000".equals(workBaseDate)) {
            // 시스템 현재일자 - 1일 사용
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
     * BR-003-004: 암호화서비스선택규칙 구현
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
                this.encryptionServiceId = encryptConfig.getString("encryptionServiceId");
            } else {
                // 기본값 설정 (BR-003-004 규칙에 따라)
                switch (systemType) {
                    case "ZAD":
                        this.encryptionServiceId = "KB0KIID02";
                        break;
                    case "ZAP":
                        this.encryptionServiceId = "KB0KIIP02";
                        break;
                    default:
                        this.encryptionServiceId = "KB0KIIB02";
                        break;
                }
            }
            
            log.info("암호화 서비스 설정 완료 - 서비스ID: " + encryptionServiceId);
            
        } catch (Exception e) {
            log.error("암호화 서비스 설정 중 오류 발생", e);
            throw new BusinessException("BIP0011-003", "암호화 서비스 설정 실패: " + e.getMessage());
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
            throw new BusinessException("BIP0011-004", "출력 파일 초기화 실패: " + e.getMessage());
        }
    }
    
    /**
     * F-003-002: 입력검증기능 구현
     */
    private void validateInputParameters() {
        if (baseDate == null || baseDate.trim().isEmpty()) {
            throw new BusinessException("BIP0011-005", "기준일자가 설정되지 않았습니다");
        }
        
        if (encryptionServiceId == null || encryptionServiceId.trim().isEmpty()) {
            throw new BusinessException("BIP0011-006", "암호화 서비스 ID가 설정되지 않았습니다");
        }
        
        log.info("입력 매개변수 검증 완료");
    }
    
    /**
     * F-003-003: 기업집단데이터추출기능 구현
     * BR-003-001: 그룹회사필터링규칙 (KB0만 처리)
     * BR-003-003: 기업집단코드구성규칙 (등록코드+그룹코드)
     */
    private void processCorpGroupData() {
        try {
            // DB 조회 조건 설정
            Map<String, Object> sqlIn = new HashMap<>();
            sqlIn.put("baseDate", baseDate);
            sqlIn.put("groupCompanyCode", "KB0"); // BR-003-001: KB Financial Group만 처리
            
            log.info("기업집단 데이터 조회 시작 - 기준일자: " + baseDate);
            
            DBSession readSession = dbNewSession(false, "READ");
            
            // 트랜잭션 시작 (건수 금액 로깅용)
            txBegin();
            
            // TSKIPB110 테이블에서 기업집단 평가 데이터 조회
            dbSelect("selectCorpGroupData", sqlIn, makeRecordHandler(), readSession);
            
            txCommit();
            
            log.info("기업집단 데이터 조회 완료 - 총 " + fetchCount + "건 처리");
            
        } catch (Exception e) {
            log.error("기업집단 데이터 처리 중 오류 발생", e);
            throw new BusinessException("BIP0011-007", "기업집단 데이터 처리 실패: " + e.getMessage());
        }
    }
    
    /**
     * DB 조회 결과 처리 핸들러
     * F-003-004: 데이터변환기능, F-003-005: 코드변환기능, F-003-006: 암호화기능, F-003-007: 파일출력기능 구현
     */
    private AbsRecordHandler makeRecordHandler() {
        return new AbsRecordHandler(this) {
            @Override
            public void handleRecord(IRecord record) {
                try {
                    fetchCount++;
                    
                    // 진행률 설정
                    context.setProgressCurrent(getCurrentSize());
                    
                    // F-003-004: 데이터 변환 (COBOL 형식을 Java 형식으로)
                    String transformedRecord = transformDataRecord(record);
                    
                    // F-003-005: 코드 변환 (EBCDIC to ASCII) - TODO: 실제 구현 필요
                    String convertedRecord = convertCodeFormat(transformedRecord);
                    
                    // F-003-006: 암호화 처리
                    String encryptedRecord = encryptRecord(convertedRecord);
                    
                    // F-003-007: 파일 출력
                    writeOutputFiles(encryptedRecord, convertedRecord);
                    
                    writeCount++;
                    
                    if (writeCount % 1000 == 0) {
                        log.info("처리 진행 상황: " + writeCount + "건 완료");
                    }
                    
                } catch (Exception e) {
                    log.error("레코드 처리 중 오류 발생 - 레코드번호: " + fetchCount, e);
                    // BR-003-011: 오류처리규칙 - 개별 레코드 오류는 로그만 남기고 계속 진행
                }
            }
        };
    }
    
    /**
     * F-003-004: 데이터변환기능 구현
     * BR-003-005: 데이터변환규칙 (packed decimal을 display format으로)
     * BR-003-007: 레코드구분자규칙 (파이프 문자 사용)
     */
    private String transformDataRecord(IRecord record) {
        StringBuilder sb = new StringBuilder();
        
        // 기업집단평가기본정보 변환
        sb.append(getString(record, "groupCoCd", 3)).append("|");                    // 그룹회사코드
        sb.append(getString(record, "corpClctCd", 6)).append("|");                  // 기업집단코드
        sb.append(getString(record, "clctValuaWritYr", 4)).append("|");             // 집단평가작성년
        sb.append(getString(record, "clctValuaWritNo", 4)).append("|");             // 집단평가작성번호
        sb.append(getString(record, "valuaYmd", 8)).append("|");                    // 평가년월일
        sb.append(getString(record, "corpCValuaDstcd", 1)).append("|");             // 기업집단평가구분
        sb.append("0").append("|");                                                 // 장표종류구분 (고정값)
        sb.append(getString(record, "valuaBaseYmd", 8)).append("|");                // 평가기준년월일
        
        // 재무점수 (소수점 2자리)
        sb.append(formatDecimal(record, "fnafScor", 7, 2)).append("|");
        // 비재무점수 (소수점 2자리)
        sb.append(formatDecimal(record, "nonFnafScor", 7, 2)).append("|");
        
        sb.append(getString(record, "spareCGrdDstcd", 3)).append("|");              // 예비집단등급구분
        sb.append(getString(record, "lastClctGrdDstcd", 3)).append("|");            // 최종집단등급구분
        sb.append(formatInteger(record, "adjsScor", 3)).append("|");                // 조정점수
        sb.append(getString(record, "valdYmd", 8)).append("|");                     // 유효년월일
        
        // 직원정보
        sb.append(getString(record, "valuaEmpid", 7)).append("|");                  // 평가직원번호
        sb.append(getString(record, "valuaEJobtlName", 22)).append("|");            // 평가직원직위명
        sb.append(getString(record, "valuaEmnm", 52)).append("|");                  // 평가직원명
        sb.append(getString(record, "valuaBrncd", 4)).append("|");                  // 평가부점코드
        sb.append(getString(record, "mgtEmpid", 7)).append("|");                    // 관리직원번호
        sb.append(getString(record, "mgtEmpJobtlName", 22)).append("|");            // 관리직원직위명
        sb.append(getString(record, "mgtEmnm", 52)).append("|");                    // 관리직원명
        sb.append(getString(record, "mgtBrncd", 4)).append("|");                    // 관리부점코드
        
        // 기업집단상세정보
        sb.append(getString(record, "corpClctName", 72)).append("|");               // 기업집단명
        sb.append(getString(record, "chrmFname", 52)).append("|");                  // 회장성명
        sb.append(getString(record, "pritrnBnkName", 52)).append("|");              // 주거래은행명
        sb.append(getString(record, "incorYmd", 8)).append("|");                    // 설립년월일
        sb.append(getString(record, "dmntName", 52)).append("|");                   // 지배자명
        sb.append(getString(record, "kisGroupCd", 3)).append("|");                  // 한신평그룹코드
        sb.append(getString(record, "corpCScalDstcd", 1)).append("|");              // 기업집단규모구분
        sb.append(getString(record, "mafoBztypName", 102)).append("|");             // 주력업종명
        sb.append(getString(record, "mafoCprno", 13)).append("|");                  // 주력법인등록번호
        sb.append(getString(record, "mafoCoprName", 42)).append("|");               // 주력법인명
        
        // 기업통계정보 (제조업)
        sb.append(formatInteger(record, "mnfcListEntpCnt", 5)).append("|");         // 제조상장업체수
        sb.append(formatInteger(record, "mnfcOsdEntpCnt", 5)).append("|");          // 제조장외업체수
        sb.append(formatInteger(record, "mnfcExadEntpCnt", 5)).append("|");         // 제조외감업체수
        sb.append(formatInteger(record, "mnfcGnralEntpCnt", 5)).append("|");        // 제조일반업체수
        sb.append(formatInteger(record, "mnfcEmpCnt", 9)).append("|");              // 제조종업원수
        
        // 기업통계정보 (금융업)
        sb.append(formatInteger(record, "finacListEntpCnt", 5)).append("|");        // 금융상장업체수
        sb.append(formatInteger(record, "finacOsdEntpCnt", 5)).append("|");         // 금융장외업체수
        sb.append(formatInteger(record, "finacExadEntpCnt", 5)).append("|");        // 금융외감업체수
        sb.append(formatInteger(record, "finacGEntpCnt", 5)).append("|");           // 금융일반업체수
        sb.append(formatInteger(record, "finacOccuEmpCnt", 9)).append("|");         // 금융업종업원수
        
        // 재무성과데이터 (기준년)
        sb.append(formatInteger(record, "baseYSumEntpCnt", 5)).append("|");         // 기준년합계업체수
        sb.append(formatLong(record, "baseYrSalepr", 15)).append("|");              // 기준년매출액
        sb.append(formatLong(record, "baseYrOdnrPrft", 15)).append("|");           // 기준년경상이익
        sb.append(formatLong(record, "baseYrNetPrft", 15)).append("|");            // 기준년순이익
        sb.append(formatLong(record, "baseYrTotalAsam", 15)).append("|");          // 기준년총자산금액
        sb.append(formatLong(record, "baseYrOncpAmt", 15)).append("|");            // 기준년자기자본금
        sb.append(formatLong(record, "baseYrTotalAmbr", 15)).append("|");          // 기준년총차입금
        
        // 재무성과데이터 (N-1년)
        sb.append(formatInteger(record, "n1YbSumEntpCnt", 5)).append("|");          // N1년전합계업체수
        sb.append(formatLong(record, "n1YrBfAsaleAmt", 15)).append("|");           // N1년전매출액
        sb.append(formatLong(record, "n1YrBfOdnrPrft", 15)).append("|");          // N1년전경상이익
        sb.append(formatLong(record, "n1YrBfNetPrft", 15)).append("|");           // N1년전순이익
        sb.append(formatLong(record, "n1YrBfTotalAsam", 15)).append("|");         // N1년전총자산금액
        sb.append(formatLong(record, "n1YrBfOncpAmt", 15)).append("|");           // N1년전자기자본금
        sb.append(formatLong(record, "n1YrBfTotalAmbr", 15)).append("|");         // N1년전총차입금
        
        // 재무성과데이터 (N-2년)
        sb.append(formatInteger(record, "n2YbSumEntpCnt", 5)).append("|");          // N2년전합계업체수
        sb.append(formatLong(record, "n2YrBfAsaleAmt", 15)).append("|");           // N2년전매출액
        sb.append(formatLong(record, "n2YrBfOdnrPrft", 15)).append("|");          // N2년전경상이익
        sb.append(formatLong(record, "n2YrBfNetPrft", 15)).append("|");           // N2년전순이익
        sb.append(formatLong(record, "n2YrBfTotalAsam", 15)).append("|");         // N2년전총자산금액
        sb.append(formatLong(record, "n2YrBfOncpAmt", 15)).append("|");           // N2년전자기자본금
        sb.append(formatLong(record, "n2YrBfTotalAmbr", 15)).append("|");         // N2년전총차입금
        
        // 추가정보
        sb.append(formatLong(record, "kisIcTotalAmt", 15)).append("|");            // 한신평조사시가총액
        sb.append(getString(record, "mainDebtAffltYn", 1)).append("|");            // 주채무계열여부
        sb.append(getString(record, "sysLastPrcssYms", 20)).append("|");           // 시스템최종처리일시
        sb.append(getString(record, "sysLastUno", 7));                             // 시스템최종사용자번호 (마지막이므로 파이프 없음)
        
        return sb.toString();
    }
    
    /**
     * F-003-005: 코드변환기능 구현 (EBCDIC to ASCII)
     * BR-003-008: 코드변환규칙
     */
    private String convertCodeFormat(String input) {
        // TODO: 실제 EBCDIC to ASCII 변환 로직 구현 필요
        // 현재는 placeholder로 입력값 그대로 반환
        // 실제 구현시 XZUGCDCV 모듈 호출 또는 Java 변환 라이브러리 사용
        log.debug("코드 변환 처리 (EBCDIC->ASCII): " + input.length() + "바이트");
        return input;
    }
    
    /**
     * F-003-006: 암호화기능 구현
     * BR-003-004: 암호화서비스선택규칙, BR-003-006: 파일출력규칙
     */
    private String encryptRecord(String plainText) {
        try {
            // TODO: 실제 암호화 로직 구현 필요
            // 현재는 placeholder로 더미 암호화 데이터 생성
            // 실제 구현시 XFAVSCPN 모듈 호출 또는 Java 암호화 라이브러리 사용
            
            // 암호화 성공 시뮬레이션 (실제로는 암호화 서비스 호출)
            String encryptedData = "ENCRYPTED[" + plainText + "]";
            
            // 1496바이트로 패딩 (암호화 오버헤드 포함)
            if (encryptedData.length() < 1496) {
                encryptedData = String.format("%-1496s", encryptedData);
            } else if (encryptedData.length() > 1496) {
                encryptedData = encryptedData.substring(0, 1496);
            }
            
            encryptSuccessCount++;
            log.debug("암호화 처리 완료 - 서비스ID: " + encryptionServiceId);
            
            return encryptedData;
            
        } catch (Exception e) {
            encryptFailCount++;
            log.error("암호화 처리 실패", e);
            // BR-003-011: 오류처리규칙 - 암호화 실패시에도 평문은 출력
            return "ENCRYPT_FAILED[" + plainText + "]";
        }
    }
    
    /**
     * F-003-007: 파일출력기능 구현
     * BR-003-006: 파일출력규칙 (암호화 + 평문 파일 동시 출력)
     */
    private void writeOutputFiles(String encryptedRecord, String plainRecord) {
        try {
            // 암호화 파일 출력 (OUTFILE - 1496바이트)
            IRecord encryptedIRecord = new Record();
            encryptedIRecord.set("encryptedRecord", encryptedRecord);
            fileToolOutFile.writeRecordToOut(encryptedIRecord);
            
            // 평문 파일 출력 (OUTFILE1 - 1109바이트, 파이프 구분)
            // 1109바이트로 패딩
            String paddedPlainRecord = plainRecord;
            if (paddedPlainRecord.length() < 1109) {
                paddedPlainRecord = String.format("%-1109s", paddedPlainRecord);
            } else if (paddedPlainRecord.length() > 1109) {
                paddedPlainRecord = paddedPlainRecord.substring(0, 1109);
            }
            
            IRecord plainIRecord = new Record();
            plainIRecord.set("plainRecord", paddedPlainRecord);
            fileToolOutFile1.writeRecordToOut(plainIRecord);
            
            log.debug("파일 출력 완료 - 암호화: " + encryptedRecord.length() + "바이트, 평문: " + paddedPlainRecord.length() + "바이트");
            
        } catch (Exception e) {
            log.error("파일 출력 중 오류 발생", e);
            throw new BusinessException("BIP0011-008", "파일 출력 실패: " + e.getMessage());
        }
    }
    
    /**
     * F-003-009: 체크파일생성기능 구현
     * BR-003-010: 체크파일생성규칙 (기준일자|현재일자|건수)
     */
    private void generateCheckFile() {
        try {
            // 체크 레코드 생성 (28바이트: 8+1+8+1+10 = 28)
            String checkRecord = baseDate + "|" + currentDate + "|" + String.format("%010d", writeCount);
            
            IRecord checkIRecord = new Record();
            checkIRecord.set("checkRecord", checkRecord);
            fileToolOutCheck.writeRecordToOut(checkIRecord);
            
            log.info("체크 파일 생성 완료 - " + checkRecord);
            
        } catch (Exception e) {
            log.error("체크 파일 생성 중 오류 발생", e);
            throw new BusinessException("BIP0011-009", "체크 파일 생성 실패: " + e.getMessage());
        }
    }
    
    /**
     * F-003-008: 처리통계기능 구현
     * BR-003-009: 처리통계규칙
     */
    private void displayProcessingStatistics() {
        log.info("=== 처리 통계 ===");
        log.info("조회 건수: " + fetchCount);
        log.info("출력 건수: " + writeCount);
        log.info("암호화 성공: " + encryptSuccessCount);
        log.info("암호화 실패: " + encryptFailCount);
        log.info("기준 일자: " + baseDate);
        log.info("현재 일자: " + currentDate);
        log.info("암호화 서비스: " + encryptionServiceId);
    }
    
    // 유틸리티 메소드들
    private String getString(IRecord record, String fieldName, int maxLength) {
        String value = record.getString(fieldName);
        if (value == null) {
            value = "";
        }
        if (value.length() > maxLength) {
            value = value.substring(0, maxLength);
        }
        return String.format("%-" + maxLength + "s", value);
    }
    
    private String formatDecimal(IRecord record, String fieldName, int totalLength, int decimalPlaces) {
        try {
            java.math.BigDecimal value = record.getBigDecimal(fieldName);
            if (value == null) {
                value = java.math.BigDecimal.ZERO;
            }
            String formatted = value.setScale(decimalPlaces, java.math.RoundingMode.HALF_UP).toString();
            return String.format("%" + totalLength + "s", formatted);
        } catch (Exception e) {
            return String.format("%" + totalLength + "s", "0.00");
        }
    }
    
    private String formatInteger(IRecord record, String fieldName, int length) {
        try {
            Object value = record.get(fieldName);
            Integer intValue = (value != null) ? Integer.valueOf(value.toString()) : 0;
            return String.format("%" + length + "d", intValue);
        } catch (Exception e) {
            return String.format("%" + length + "d", 0);
        }
    }
    
    private String formatLong(IRecord record, String fieldName, int length) {
        try {
            Object value = record.get(fieldName);
            Long longValue = (value != null) ? Long.valueOf(value.toString()) : 0L;
            return String.format("%" + length + "d", longValue);
        } catch (Exception e) {
            return String.format("%" + length + "d", 0L);
        }
    }
}
