package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단사업분석저장 FU 클래스.
 * <pre>
 * 유닛 설명 : 기업집단의 사업분석 데이터를 저장하고 관리하는 기능 유닛
 * ---------------------------------------------------------------------------------
 *  버전	일자			작성자			설명
 * ---------------------------------------------------------------------------------
 *   1.0	20251001	MultiQ4KBBank		최초 작성
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank
 * @since 2025-10-01
 */
@BizUnit(value = "기업집단사업분석저장", type = "FU")
public class FUCorpGrpBizAnalStor extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPB113 duTSKIPB113;
    @BizUnitBind private DUTSKIPB130 duTSKIPB130;

    /**
     * 기업집단사업분석저장처리.
     * <pre>
     * 메소드 설명 : 기업집단의 사업분석 데이터를 저장하고 관리하는 처리
     * 비즈니스 기능:
     * - BR-033-001: 기업집단파라미터검증
     * - BR-033-002: 사업부문데이터무결성
     * - BR-033-003: 주석분류관리
     * - BR-033-004: 데이터업데이트거래제어
     * - BR-033-005: 처리건수검증
     * - BR-033-006: 다년도재무분석일관성
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단사업분석저장처리")
    public IDataSet storeCorpGrpBizAnalysis(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단사업분석저장처리 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // BR-033-001: 기업집단파라미터검증
            validateCorpGrpParameters(requestData);

            // BR-033-004: 데이터업데이트거래제어 - 기존 데이터 삭제
            deleteExistingData(requestData, onlineCtx);

            // BR-033-002: 사업부문데이터무결성 - 사업부문 분석 데이터 저장
            int processedBizSectCount = processBizSectAnalysisData(requestData, onlineCtx);

            // BR-033-003: 주석분류관리 - 사업분석 주석 데이터 저장
            int processedCommentCount = processBizAnalysisComments(requestData, onlineCtx);

            // BR-033-005: 처리건수검증
            int totalProcessed = processedBizSectCount + processedCommentCount;
            
            responseData.put("totalNoitm", totalProcessed);
            responseData.put("prsntNoitm", totalProcessed);
            
            log.debug("기업집단사업분석저장처리 완료 - 사업부문: " + processedBizSectCount + 
                     ", 주석: " + processedCommentCount);

        } catch (BusinessException e) {
            log.error("기업집단사업분석저장처리 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단사업분석저장처리 시스템 오류", e);
            throw new BusinessException("B3900009", "UKII0182", "시스템 오류가 발생했습니다.", e);
        }

        return responseData;
    }

    /**
     * 기업집단 파라미터 검증.
     * @param requestData 요청 데이터
     */
    private void validateCorpGrpParameters(IDataSet requestData) {
        // BR-033-001: 기업집단파라미터검증
        String groupCoCd = requestData.getString("groupCoCd");
        if (groupCoCd == null || groupCoCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0001", "그룹회사코드는 필수입력항목입니다.");
        }

        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0001", "기업집단그룹코드는 필수입력항목입니다.");
        }

        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0002", "기업집단등록코드는 필수입력항목입니다.");
        }

        String valuaYmd = requestData.getString("valuaYmd");
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            throw new BusinessException("B3800004", "UKIP0003", "평가년월일은 필수입력항목입니다.");
        }

        if (!valuaYmd.matches("^\\d{8}$")) {
            throw new BusinessException("B3800004", "UKIP0003", "평가년월일은 YYYYMMDD 형식이어야 합니다.");
        }
    }

    /**
     * 기존 데이터 삭제 처리.
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     */
    private void deleteExistingData(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기존 데이터 삭제 시작");

        try {
            // 기존 사업부문 분석 데이터 삭제
            IDataSet deleteReq = new DataSet();
            deleteReq.put("groupCoCd", requestData.getString("groupCoCd"));
            deleteReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            deleteReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            deleteReq.put("valuaYmd", requestData.getString("valuaYmd"));

            duTSKIPB113.deleteCorpGrpBizSectAnal(deleteReq, onlineCtx);
            duTSKIPB130.deleteCorpGrpComment(deleteReq, onlineCtx);

            log.debug("기존 데이터 삭제 완료");
        } catch (Exception e) {
            log.error("기존 데이터 삭제 오류", e);
            throw new BusinessException("B4200095", "UKJI0299", "기존 데이터 삭제 중 오류가 발생했습니다.", e);
        }
    }

    /**
     * 사업부문 분석 데이터 처리.
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리된 레코드 수
     */
    private int processBizSectAnalysisData(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("사업부문 분석 데이터 처리 시작");

        IRecordSet bizSectAnalGrid = requestData.getRecordSet("bizSectAnalGrid");
        if (bizSectAnalGrid == null || bizSectAnalGrid.getRecordCount() == 0) {
            log.debug("사업부문 분석 데이터가 없습니다.");
            return 0;
        }

        int processedCount = 0;
        
        for (int i = 0; i < bizSectAnalGrid.getRecordCount(); i++) {
            try {
                IDataSet insertReq = new DataSet();
                
                // 공통 파라미터 설정
                insertReq.put("groupCoCd", requestData.getString("groupCoCd"));
                insertReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
                insertReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
                insertReq.put("valuaYmd", requestData.getString("valuaYmd"));
                
                // 사업부문 분석 데이터 설정
                insertReq.put("fnafARptdocDstcd", bizSectAnalGrid.getString(i, "fnafARptdocDstcd"));
                insertReq.put("fnafItemCd", bizSectAnalGrid.getString(i, "fnafItemCd"));
                insertReq.put("bizSectNo", bizSectAnalGrid.getString(i, "bizSectNo"));
                insertReq.put("bizSectDsticName", bizSectAnalGrid.getString(i, "bizSectDsticName"));
                
                // BR-033-006: 다년도재무분석일관성 - 기준년 데이터
                insertReq.put("baseYrItemAmt", bizSectAnalGrid.getBigDecimal(i, "baseYrItemAmt"));
                insertReq.put("baseYrRato", bizSectAnalGrid.getBigDecimal(i, "baseYrRato"));
                insertReq.put("baseYrEntpCnt", bizSectAnalGrid.getInt(i, "baseYrEntpCnt"));
                
                // N-1년 데이터
                insertReq.put("n1YrBfItemAmt", bizSectAnalGrid.getBigDecimal(i, "n1YrBfItemAmt"));
                insertReq.put("n1YrBfRato", bizSectAnalGrid.getBigDecimal(i, "n1YrBfRato"));
                insertReq.put("n1YrBfEntpCnt", bizSectAnalGrid.getInt(i, "n1YrBfEntpCnt"));
                
                // N-2년 데이터
                insertReq.put("n2YrBfItemAmt", bizSectAnalGrid.getBigDecimal(i, "n2YrBfItemAmt"));
                insertReq.put("n2YrBfRato", bizSectAnalGrid.getBigDecimal(i, "n2YrBfRato"));
                insertReq.put("n2YrBfEntpCnt", bizSectAnalGrid.getInt(i, "n2YrBfEntpCnt"));

                duTSKIPB113.insertCorpGrpBizSectAnal(insertReq, onlineCtx);
                processedCount++;
                
            } catch (Exception e) {
                log.error("사업부문 분석 데이터 처리 오류 - 인덱스: " + i, e);
                throw new BusinessException("B4200095", "UKJI0299", "사업부문 분석 데이터 저장 중 오류가 발생했습니다.", e);
            }
        }

        log.debug("사업부문 분석 데이터 처리 완료 - 처리건수: " + processedCount);
        return processedCount;
    }

    /**
     * 사업분석 주석 데이터 처리.
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리된 레코드 수
     */
    private int processBizAnalysisComments(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("사업분석 주석 데이터 처리 시작");

        IRecordSet bizAnalComtGrid = requestData.getRecordSet("bizAnalComtGrid");
        if (bizAnalComtGrid == null || bizAnalComtGrid.getRecordCount() == 0) {
            log.debug("사업분석 주석 데이터가 없습니다.");
            return 0;
        }

        int processedCount = 0;
        
        for (int i = 0; i < bizAnalComtGrid.getRecordCount(); i++) {
            try {
                // BR-033-003: 주석분류관리
                String corpCComtDstcd = bizAnalComtGrid.getString(i, "corpCComtDstcd");
                if (corpCComtDstcd == null || corpCComtDstcd.trim().isEmpty()) {
                    throw new BusinessException("B3800004", "UKIP0004", "기업집단주석구분은 필수입력항목입니다.");
                }

                IDataSet insertReq = new DataSet();
                
                // 공통 파라미터 설정
                insertReq.put("groupCoCd", requestData.getString("groupCoCd"));
                insertReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
                insertReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
                insertReq.put("valuaYmd", requestData.getString("valuaYmd"));
                
                // 주석 데이터 설정
                insertReq.put("corpCComtDstcd", corpCComtDstcd);
                insertReq.put("comtCtnt", bizAnalComtGrid.getString(i, "comtCtnt"));

                duTSKIPB130.insertCorpGrpComment(insertReq, onlineCtx);
                processedCount++;
                
            } catch (Exception e) {
                log.error("사업분석 주석 데이터 처리 오류 - 인덱스: " + i, e);
                throw new BusinessException("B4200095", "UKJI0299", "사업분석 주석 데이터 저장 중 오류가 발생했습니다.", e);
            }
        }

        log.debug("사업분석 주석 데이터 처리 완료 - 처리건수: " + processedCount);
        return processedCount;
    }
}
