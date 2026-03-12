package com.kbstar.edu.c2j.batch;

import java.io.OutputStream;
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
import nexcore.framework.core.util.StringUtils;
import nexcore.framework.batch.appbase.fio.IFileTool;

/**
 * 기업집단재무데이터추출 배치.
 * <pre>
 * 기업집단재무데이터추출 배치 처리
 * </pre>
 * @author MultiQ4KBBank
 * @since 2025-10-01
 */
@BizBatch("기업집단재무데이터추출 배치")
public class BUBIIRD05 extends com.kbstar.sqc.batch.base.BatchUnit {
    
    private ILog log;
    private BatchProfile profile;
    private int commitCount;
    private String baseYear;
    private String gijunYmd;
    private String outFilename;
    private OutputStream fileOutStream;
    private IFileTool fileToolWrite;
    
    public BUBIIRD05() {
        super();
    }

    /**
     * 배치 전처리 메소드
     */
    @Override
    public void beforeExecute() {
        this.log = context.getLogger();
        this.profile = context.getBatchProfile();
        this.commitCount = profile == null || profile.getCommitCount() == 0 ? 100 : profile.getCommitCount();
        
        // 파일 레이아웃 로딩
        this.fileToolWrite = getFileTool("FIOBUBIIRD05");
        
        // 출력 파일 설정
        this.outFilename = context.getInParameter("OUTPUT_FILE");
        if (StringUtils.isEmpty(this.outFilename)) {
            throw new BusinessException("B0100880", "UAAS0001", "배치 작업 필수 파라미터 누락 (OUTPUT_FILE)");
        }
        
        // 출력 파일 오픈
        this.fileOutStream = fileOpenOutputStream(this.outFilename);
        
        // FileTool 초기화
        fileToolWrite.setOutputStream(this.fileOutStream);
        fileToolWrite.initialize();
        
        // SYSIN 파라미터에서 기준년도 추출
        String sysinParam = context.getInParameter("SYSIN");
        if (sysinParam != null && sysinParam.length() >= 4) {
            this.baseYear = sysinParam.substring(0, 4);
        } else {
            this.baseYear = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy"));
        }
        
        // 기준년월일 계산 (BR-001-006)
        String currentYear = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy"));
        if (baseYear.equals(currentYear)) {
            this.gijunYmd = java.time.LocalDate.now().minusDays(1).format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd"));
        } else {
            this.gijunYmd = baseYear + "1231";
        }
        
        log.info("기준년도: " + baseYear);
        log.info("기준년월일: " + gijunYmd);
    }

    /**
     * 배치 메인 메소드
     */
    @Override
    public void execute() {
        Map<String, Object> sqlIn = new HashMap<>();
        sqlIn.put("baseYear", baseYear);
        
        log.info("기업집단평가데이터 조회 시작");
        
        DBSession readSession = dbNewSession(false, "READ");
        dbSelect("selectCorpGroupEval", sqlIn, makeHandler(), readSession);
        
        log.info("기업집단평가데이터 조회 완료");
    }
    
    private AbsRecordHandler makeHandler() {
        return new AbsRecordHandler(this) {
            public void handleRecord(IRecord record) {
                try {
                    context.setProgressCurrent(getCurrentSize());
                    
                    String corpClctGroupCd = record.getString("corpClctGroupCd");
                    String corpClctRegiCd = record.getString("corpClctRegiCd");
                    String valuaYmd = record.getString("valuaYmd");
                    String valuaBaseYmd = record.getString("valuaBaseYmd");
                    String finalCorpClctCreditRating = record.getString("finalCorpClctCreditRating");
                    
                    // 재무제표데이터 조회 (F-001-003)
                    Map<String, Object> financialParams = new HashMap<>();
                    financialParams.put("corpClctGroupCd", corpClctGroupCd);
                    financialParams.put("corpClctRegiCd", corpClctRegiCd);
                    financialParams.put("baseYear", baseYear);
                    
                    IRecord financialRecord = dbSelectSingle("selectFinancialData", financialParams);
                    
                    // 재무비율데이터 조회 (F-001-004)
                    IRecord ratioRecord = dbSelectSingle("selectRatioData", financialParams);
                    
                    // 재무데이터 로깅 (비즈니스 목적: 재무제표,비율추출)
                    if (financialRecord != null) {
                        log.info("재무데이터 - 총자산:" + financialRecord.getString("totalAssets") + 
                                ", 자기자본:" + financialRecord.getString("equityCapital") +
                                ", 매출액:" + financialRecord.getString("salesRevenue"));
                    }
                    if (ratioRecord != null) {
                        log.info("비율데이터 - 부채비율:" + ratioRecord.getString("debtRatio"));
                    }
                    
                    // 출력레코드 생성 (F-001-005: BE-001-004 형식, 60바이트 고정길이)
                    Map<String, Object> outputData = new HashMap<>();
                    outputData.put("gijunYmd", gijunYmd);
                    outputData.put("corpClctCd", corpClctRegiCd + corpClctGroupCd); // BR-001-007
                    outputData.put("valuaBaseYmd", valuaBaseYmd);
                    outputData.put("valuaYmd", valuaYmd);
                    outputData.put("finalCreditRating", finalCorpClctCreditRating);
                    outputData.put("reserved1", ""); // 예비필드 (향후 확장용)
                    outputData.put("reserved2", ""); // 예비필드 (향후 확장용)
                    
                    // 파일 쓰기
                    IRecord outputRecord = new Record();
                    for (Map.Entry<String, Object> entry : outputData.entrySet()) {
                        outputRecord.set(entry.getKey(), entry.getValue());
                    }
                    fileToolWrite.writeRecordToOut(outputRecord);
                    
                } catch (Exception e) {
                    log.error("[에러발생] Position=" + getCurrentSize() + ", record=" + record.toString().trim(), e);
                    throw new BusinessException("B0100880", "UAAS0001", "기업집단재무데이터추출 중 에러가 발생하였습니다", e);
                }
            }
        };
    }

    /**
     * 배치 후처리 메소드
     */
    @Override
    public void afterExecute() {
        // 파일 스트림 닫기
        if (fileOutStream != null) {
            try {
                fileOutStream.close();
            } catch (Exception e) {
                log.error("파일 스트림 닫기 실패", e);
            }
        }
        
        if (super.exceptionInExecute == null) {
            log.info("배치 정상 완료");
        } else {
            log.info("배치 오류 발생");
        }
    }
}
