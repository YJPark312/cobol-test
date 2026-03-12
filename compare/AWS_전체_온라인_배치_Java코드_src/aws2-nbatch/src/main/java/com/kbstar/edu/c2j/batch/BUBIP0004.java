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
import nexcore.framework.batch.appbase.fio.IFileTool;

/**
 * 지주사전송파일변환 (Holding Company Transmission File Conversion)
 * <pre>
 * 관계기업기본정보 고객정보암호화 변환 및 전송파일 생성
 * - A110: 관계기업기본정보 (Related Company Basic Information)
 * - A111: 기업집단그룹정보 (Corporate Group Information)
 * - 고객고유번호 일방향 암호화 (Customer unique number one-way encryption)
 * - 전체 레코드 양방향 암호화 (Complete record two-way encryption)
 * - 고객정보제공통지 등록 (Customer information provision notification)
 * </pre>
 * @author MultiQ4KBBank
 * @since 2025-10-01
 */
@BizBatch("지주사전송파일변환")
public class BUBIP0004 extends com.kbstar.sqc.batch.base.BatchUnit {

    private ILog log;
    private BatchProfile profile;
    private int commitCount = 1000; // BR-002-008: 1000건마다 커밋
    private IFileTool a110FileTool;
    private IFileTool a110ChkFileTool;
    private IFileTool a111FileTool;
    private IFileTool a111ChkFileTool;
    
    // 입력 파라미터
    private String groupCoCd = "KB0"; // BR-002-001: KB Financial Group
    private String workBaseDate;
    private String systemTypeCd;
    
    // 암호화 서비스 ID (BE-002-003)
    private String oneWayEncryptionServiceId;
    private String twoWayEncryptionServiceId;
    
    // 처리 카운터
    private long a110RecordCount = 0;
    private long a111RecordCount = 0;
    private long a110ValidationId = 1; // BR-002-011: 검증ID 순차 생성
    private long a111ValidationId = 1;

    public BUBIP0004() {
        super();
    }

    /**
     * F-002-001: Initialize Processing Environment
     * 배치 전처리 - 시스템 파라미터 초기화 및 입력 요구사항 검증
     */
    @Override
    public void beforeExecute() {
        this.log = context.getLogger();
        this.profile = context.getBatchProfile();
        
        // SYSIN 파라미터 읽기
        workBaseDate = context.getInParameter("WORK_BASE_DATE");
        systemTypeCd = context.getInParameter("SYSTEM_TYPE_CD");
        
        log.info("=== BIP0004 지주사전송파일변환 시작 ===");
        log.info("작업기준일자: " + workBaseDate);
        log.info("시스템구분코드: " + systemTypeCd);
        log.info("그룹회사코드: " + groupCoCd);
        
        // 입력 파라미터 검증
        if (workBaseDate == null || workBaseDate.trim().isEmpty()) {
            throw new BusinessException("EBM02001", "UBM02001", "작업기준일자가 누락되었습니다");
        }
        
        if (systemTypeCd == null || systemTypeCd.trim().isEmpty()) {
            throw new BusinessException("EBM02001", "UBM02001", "시스템구분코드가 누락되었습니다");
        }
        
        // 출력 파일 오픈 (A110.DAT, A110.CHK, A111.DAT, A111.CHK)
        try {
            a110FileTool = getFileTool("A110_DAT");
            a110ChkFileTool = getFileTool("A110_CHK");
            a111FileTool = getFileTool("A111_DAT");
            a111ChkFileTool = getFileTool("A111_CHK");
            log.info("출력 파일 오픈 완료");
        } catch (Exception e) {
            throw new BusinessException("EBM01001", "UBM01001", "파일 오픈 오류: " + e.getMessage());
        }
        
        // 암호화 서비스 ID 조회 (THKIIK923)
        initializeEncryptionServices();
        
        log.info("배치 초기화 완료");
    }

    /**
     * 배치 메인 처리
     * F-002-002: Process Related Company Information (A110)
     * F-002-003: Process Corporate Group Information (A111)
     */
    @Override
    public void execute() {
        
        // A110: 관계기업기본정보 처리
        processRelatedCompanyInfo();
        
        // A111: 기업집단그룹정보 처리
        processCorporateGroupInfo();
        
        // 처리 결과 출력
        log.info("=== 처리 완료 ===");
        log.info("A110 처리건수: " + a110RecordCount);
        log.info("A111 처리건수: " + a111RecordCount);
    }

    /**
     * 배치 후처리 - 파일 닫기 및 통계 출력
     */
    @Override
    public void afterExecute() {
        try {
            // 체크섬 파일 생성
            generateChecksumFiles();
            
            log.info("출력 파일 처리 완료");
        } catch (Exception e) {
            log.error("파일 처리 오류: " + e.getMessage());
        }
        
        if (super.exceptionInExecute == null) {
            log.info("=== BIP0004 배치 정상 완료 ===");
        } else {
            log.error("=== BIP0004 배치 오류 발생 ===");
        }
    }

    /**
     * 암호화 서비스 ID 초기화
     * THKIIK923 테이블에서 암호화 서비스 ID 조회
     */
    private void initializeEncryptionServices() {
        Map<String, Object> sqlIn = new HashMap<>();
        sqlIn.put("systemTypeCd", systemTypeCd);
        
        try {
            DBSession readSession = dbNewSession(false, "READ");
            IRecord encryptionConfig = dbSelectSingle("selectEncryptionServiceIds", sqlIn, readSession);
            
            oneWayEncryptionServiceId = encryptionConfig.getString("oneWayServiceId");
            twoWayEncryptionServiceId = encryptionConfig.getString("twoWayServiceId");
            
            log.info("일방향 암호화 서비스 ID: " + oneWayEncryptionServiceId);
            log.info("양방향 암호화 서비스 ID: " + twoWayEncryptionServiceId);
            
        } catch (Exception e) {
            throw new BusinessException("EBM03001", "UBM03001", "암호화 서비스 ID 조회 오류: " + e.getMessage());
        }
    }

    /**
     * F-002-002: Process Related Company Information
     * 관계기업기본정보 처리 (A110)
     */
    private void processRelatedCompanyInfo() {
        log.info("=== A110 관계기업기본정보 처리 시작 ===");
        
        Map<String, Object> sqlIn = new HashMap<>();
        sqlIn.put("groupCoCd", groupCoCd);
        sqlIn.put("workBaseDate", workBaseDate);
        
        DBSession readSession = dbNewSession(false, "READ");
        
        // 전체 건수 조회
        IRecord totalRec = dbSelectSingle("selectA110TotalCount", sqlIn, readSession);
        long totalCount = totalRec.getLong("totalCnt");
        log.info("A110 전체 처리 대상 건수: " + totalCount);
        
        // 본 처리
        dbSelect("selectRelatedCompanyInfo", sqlIn, makeA110Handler(), readSession);
        
        log.info("=== A110 관계기업기본정보 처리 완료 ===");
    }

    /**
     * F-002-003: Process Corporate Group Information
     * 기업집단그룹정보 처리 (A111)
     */
    private void processCorporateGroupInfo() {
        log.info("=== A111 기업집단그룹정보 처리 시작 ===");
        
        Map<String, Object> sqlIn = new HashMap<>();
        sqlIn.put("groupCoCd", groupCoCd);
        
        DBSession readSession = dbNewSession(false, "READ");
        
        // 전체 건수 조회
        IRecord totalRec = dbSelectSingle("selectA111TotalCount", sqlIn, readSession);
        long totalCount = totalRec.getLong("totalCnt");
        log.info("A111 전체 처리 대상 건수: " + totalCount);
        
        // 본 처리
        dbSelect("selectCorporateGroupInfo", sqlIn, makeA111Handler(), readSession);
        
        log.info("=== A111 기업집단그룹정보 처리 완료 ===");
    }

    /**
     * A110 레코드 처리 핸들러
     */
    private AbsRecordHandler makeA110Handler() {
        return new AutoCommitRecordHandler(this) {
            @Override
            public void handleRecord(IRecord record) {
                try {
                    // BR-002-002: 개인고객 제외 (고객고유번호구분 '01' 제외)
                    String custUniqNoDstic = record.getString("custUniqNoDstic");
                    if ("01".equals(custUniqNoDstic)) {
                        return; // 개인고객 제외
                    }
                    
                    // A110 레코드 처리
                    processA110Record(record);
                    
                    // 처리 건수 로깅
                    if (a110RecordCount % commitCount == 0) {
                        log.info("A110 처리 진행: " + a110RecordCount + "건");
                    }
                    
                } catch (Exception e) {
                    log.error("A110 레코드 처리 오류: " + e.getMessage());
                    throw new BusinessException("EBM01002", "UBM01002", "A110 레코드 처리 오류: " + e.getMessage());
                }
            }
        };
    }

    /**
     * A111 레코드 처리 핸들러
     */
    private AbsRecordHandler makeA111Handler() {
        return new AutoCommitRecordHandler(this) {
            @Override
            public void handleRecord(IRecord record) {
                try {
                    // A111 레코드 처리
                    processA111Record(record);
                    
                    // 처리 건수 로깅
                    if (a111RecordCount % commitCount == 0) {
                        log.info("A111 처리 진행: " + a111RecordCount + "건");
                    }
                    
                } catch (Exception e) {
                    log.error("A111 레코드 처리 오류: " + e.getMessage());
                    throw new BusinessException("EBM01002", "UBM01002", "A111 레코드 처리 오류: " + e.getMessage());
                }
            }
        };
    }

    /**
     * A110 개별 레코드 처리
     * BR-002-003: 개인고객 데이터 마스킹
     * BR-002-004: 고객명 콤마 치환
     * BR-002-005: 고객고유번호 일방향 암호화
     * BR-002-006: 레코드 양방향 암호화
     * BR-002-007: 법인등록번호 할당
     */
    private void processA110Record(IRecord record) throws Exception {
        String custUniqNoDstic = record.getString("custUniqNoDstic");
        String custUniqNo = record.getString("custUniqNo");
        String rpsntCustNm = record.getString("rpsntCustNm");
        String rpsntBzno = record.getString("rpsntBzno");
        
        // BR-002-003: 개인고객 데이터 마스킹
        String maskedCustNm = rpsntCustNm;
        String maskedBzno = rpsntBzno;
        if ("01".equals(custUniqNoDstic)) {
            maskedCustNm = "";
            maskedBzno = "";
        }
        
        // BR-002-004: 콤마 치환
        maskedCustNm = maskedCustNm.replace(",", " ");
        
        // BR-002-007: 법인등록번호 할당
        String corpRegNo = "01".equals(custUniqNoDstic) ? "" : custUniqNo;
        
        // F-002-004: 고객고유번호 일방향 암호화
        String encryptedCustUniqNo = applyOneWayEncryption(custUniqNo);
        
        // BR-002-012: CSV 형식으로 레코드 구성
        StringBuilder csvRecord = new StringBuilder();
        csvRecord.append(record.getString("groupCoCd")).append(",");
        csvRecord.append(record.getString("exmtnCustIdnfr")).append(",");
        csvRecord.append(record.getString("custMgtNo")).append(",");
        csvRecord.append(encryptedCustUniqNo).append(",");
        csvRecord.append(custUniqNoDstic).append(",");
        csvRecord.append(maskedBzno).append(",");
        csvRecord.append(maskedCustNm).append(",");
        csvRecord.append(record.getString("corpCvGrdDstcd")).append(",");
        csvRecord.append(record.getString("corpScalDstic")).append(",");
        csvRecord.append(record.getString("stndIClsfiCd")).append(",");
        csvRecord.append(record.getString("custMgtBrncd")).append(",");
        csvRecord.append(record.getString("totalLnbzAmt")).append(",");
        csvRecord.append(record.getString("lnbzBal")).append(",");
        csvRecord.append(record.getString("scurtyAmt")).append(",");
        csvRecord.append(record.getString("amov")).append(",");
        csvRecord.append(record.getString("pyyTotalLnbzAmt")).append(",");
        csvRecord.append(record.getString("coprGcRegiDstc")).append(",");
        csvRecord.append(record.getString("coprGcRegiYms")).append(",");
        csvRecord.append(record.getString("coprGCnslEmpid")).append(",");
        csvRecord.append(record.getString("affltCgRegiDstcd")).append(",");
        csvRecord.append(record.getString("kisGroupCd"));
        
        // F-002-005: 전체 레코드 양방향 암호화
        String encryptedRecord = applyTwoWayEncryption(csvRecord.toString());
        
        // A110.DAT 파일 쓰기
        IRecord outputRecord = new Record();
        outputRecord.set("data", encryptedRecord);
        a110FileTool.writeRecordToOut(outputRecord);
        
        // F-002-006: 고객정보제공통지 등록
        insertCustomerNotification(record.getString("exmtnCustIdnfr"));
        
        a110RecordCount++;
        a110ValidationId++; // BR-002-011: 검증ID 순차 생성
    }

    /**
     * A111 개별 레코드 처리
     * BR-002-004: 기업집단명 콤마 치환
     * BR-002-006: 레코드 양방향 암호화
     */
    private void processA111Record(IRecord record) throws Exception {
        String rpsntCustNm = record.getString("rpsntCustNm");
        
        // BR-002-004: 콤마 치환
        rpsntCustNm = rpsntCustNm.replace(",", " ");
        
        // BR-002-012: CSV 형식으로 레코드 구성
        StringBuilder csvRecord = new StringBuilder();
        csvRecord.append(record.getString("groupCoCd")).append(",");
        csvRecord.append(record.getString("corpClctRegiCd")).append(",");
        csvRecord.append(record.getString("corpClctGroupCd")).append(",");
        csvRecord.append(rpsntCustNm).append(",");
        csvRecord.append(record.getString("mainDaGroupYn"));
        
        // F-002-005: 전체 레코드 양방향 암호화
        String encryptedRecord = applyTwoWayEncryption(csvRecord.toString());
        
        // A111.DAT 파일 쓰기
        IRecord outputRecord = new Record();
        outputRecord.set("data", encryptedRecord);
        a111FileTool.writeRecordToOut(outputRecord);
        
        a111RecordCount++;
        a111ValidationId++; // BR-002-011: 검증ID 순차 생성
    }

    /**
     * F-002-004: Apply Customer Unique Number Encryption
     * 고객고유번호 일방향 암호화 (솔트 포함)
     */
    private String applyOneWayEncryption(String custUniqNo) {
        // TODO: 실제 암호화 서비스 호출 구현 필요
        // XFAVSCPN 유틸리티 호출 (암호화 코드 3: 일방향 솔트 포함)
        // 현재는 플레이스홀더로 구현
        log.debug("일방향 암호화 적용: " + custUniqNo + " -> [ENCRYPTED_44_BYTES]");
        return "[ENCRYPTED_CUSTOMER_UNIQUE_NUMBER_44_BYTES]";
    }

    /**
     * F-002-005: Apply Record Encryption
     * 전체 레코드 양방향 암호화
     */
    private String applyTwoWayEncryption(String record) {
        // TODO: 실제 암호화 서비스 호출 구현 필요
        // XFAVSCPN 유틸리티 호출 (암호화 코드 1: 양방향)
        // 현재는 플레이스홀더로 구현
        log.debug("양방향 암호화 적용: " + record.length() + "바이트 -> [ENCRYPTED_RECORD]");
        return "[ENCRYPTED_RECORD_" + record.length() + "_BYTES]";
    }

    /**
     * F-002-006: Generate Customer Notification
     * 고객정보제공통지 등록 (THKJLG001)
     * BR-002-009: 고객정보제공통지 규칙
     * BR-002-010: 통지일자 계산 규칙
     */
    private void insertCustomerNotification(String exmtnCustIdnfr) {
        try {
            // BR-002-010: 통지일자 계산
            String notificationDate = calculateNotificationDate(workBaseDate);
            
            Map<String, Object> sqlIn = new HashMap<>();
            sqlIn.put("groupCoCd", "KB0");
            sqlIn.put("usageGroupCoCd", "KFG");
            sqlIn.put("exmtnCustIdnfr", exmtnCustIdnfr);
            sqlIn.put("custMgtNo", "00000");
            sqlIn.put("provisionNo", "014"); // 그룹통합리스크관리
            sqlIn.put("managerNo", "03");
            sqlIn.put("infoProvisionPurpose", "001");
            sqlIn.put("infoProvisionItems", "기업심사, 관계기업 등록정보");
            sqlIn.put("systemUser", "BIP0004");
            sqlIn.put("notificationDate", notificationDate);
            
            DBSession writeSession = dbNewSession(true, "WRITE");
            dbUpdate("insertCustomerNotification", sqlIn, writeSession);
            
        } catch (Exception e) {
            // BR-002-009: 중복 통지는 정상 처리 (SQLCODE +803/-803)
            if (e.getMessage().contains("803") || e.getMessage().contains("duplicate")) {
                log.debug("중복 고객정보제공통지 스킵: " + exmtnCustIdnfr);
            } else {
                log.error("고객정보제공통지 등록 오류: " + e.getMessage());
            }
        }
    }

    /**
     * BR-002-010: Notification Date Calculation Rule
     * 통지일자 계산 규칙
     */
    private String calculateNotificationDate(String baseDate) {
        if (baseDate.compareTo("20160301") < 0) {
            return "20150529";
        } else if (baseDate.compareTo("20160301") >= 0 && baseDate.compareTo("20161231") <= 0) {
            return "20160301";
        } else {
            return baseDate.substring(0, 4) + "0101";
        }
    }

    /**
     * 체크섬 파일 생성
     * A110.CHK, A111.CHK 파일 생성
     */
    private void generateChecksumFiles() throws Exception {
        // A110.CHK 생성
        StringBuilder a110Checksum = new StringBuilder();
        a110Checksum.append("A110,").append(a110RecordCount).append(",").append(a110ValidationId - 1);
        IRecord a110ChkRecord = new Record();
        a110ChkRecord.set("data", a110Checksum.toString());
        a110ChkFileTool.writeRecordToOut(a110ChkRecord);
        
        // A111.CHK 생성
        StringBuilder a111Checksum = new StringBuilder();
        a111Checksum.append("A111,").append(a111RecordCount).append(",").append(a111ValidationId - 1);
        IRecord a111ChkRecord = new Record();
        a111ChkRecord.set("data", a111Checksum.toString());
        a111ChkFileTool.writeRecordToOut(a111ChkRecord);
        
        log.info("체크섬 파일 생성 완료");
        log.info("A110.CHK: " + a110Checksum.toString());
        log.info("A111.CHK: " + a111Checksum.toString());
    }
}
