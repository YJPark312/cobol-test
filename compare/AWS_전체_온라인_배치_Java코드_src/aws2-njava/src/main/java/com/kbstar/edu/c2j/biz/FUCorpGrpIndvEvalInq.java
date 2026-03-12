package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.RecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;
import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * 기업집단개별평가조회.
 * <pre>
 * 유닛 설명 : 기업집단 구성원의 개별평가결과를 조회하고 처리하는 기능 유닛
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
@BizUnit(value = "기업집단개별평가조회", type = "FU")
public class FUCorpGrpIndvEvalInq extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA110 duTSKIPA110;  // 관계기업기본정보 (WP-017 명세서 기준)

    /**
     * 개별평가결과조회처리.
     * <pre>
     * 메소드 설명 : 기업집단 구성원의 개별평가결과를 조회하고 점수 계산 및 등급조정 처리를 수행
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : totalNoitm [총건수] (numeric)
     *	- field : prsntNoitm [현재건수] (numeric)
     *	- recordSet : grid1 [개별평가결과 LIST]
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("개별평가결과조회처리")
    public IDataSet retrieveIndvEvalResults(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // BR-017-002: WP-017 명세서에 따른 개별평가 데이터 조회
            // 실제 사용 테이블: TSKIPA110 (관계기업기본정보)
            IDataSet evalData = duTSKIPA110.selectCorpGrpBasicInfo(requestData, onlineCtx);
            IRecordSet rawRecords = (IRecordSet) evalData.get("recordSet");
            
            if (rawRecords == null || rawRecords.getRecordCount() == 0) {
                // 조회 결과 없음
                responseData.put("totalNoitm", 0);
                responseData.put("prsntNoitm", 0);
                responseData.put("grid1", new RecordSet());
                return responseData;
            }

            // BR-017-004: 점수 계산 및 형식화
            // BR-017-005: 등급조정 상태 처리
            IRecordSet processedRecords = processEvaluationData(rawRecords);
            
            // BR-017-006: 결과집합 제한 (최대 100건)
            int totalCount = processedRecords.getRecordCount();
            int presentCount = Math.min(totalCount, 100);
            
            IRecordSet limitedRecords = new RecordSet();
            for (int i = 0; i < presentCount; i++) {
                limitedRecords.addRecord(processedRecords.getRecord(i));
            }
            
            responseData.put("totalNoitm", totalCount);
            responseData.put("prsntNoitm", presentCount);
            responseData.put("grid1", limitedRecords);
            
            log.debug("개별평가결과조회 완료 - 총건수: " + totalCount + ", 현재건수: " + presentCount);

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B2900042", "UKII0182", "시스템 오류", e);
        }

        return responseData;
    }

    /**
     * 평가 데이터 처리 (BR-017-004, BR-017-005).
     */
    private IRecordSet processEvaluationData(IRecordSet rawRecords) {
        IRecordSet processedRecords = new RecordSet();
        
        for (int i = 0; i < rawRecords.getRecordCount(); i++) {
            IRecord rawRecord = rawRecords.getRecord(i);
            IRecord processedRecord = processedRecords.newRecord();
            
            // 기본 정보 복사
            processedRecord.set("exmtnCustIdnfr", rawRecord.getString("exmtnCustIdnfr"));
            processedRecord.set("brwrName", rawRecord.getString("brwrName"));
            processedRecord.set("crdtVRptdocNo", rawRecord.getString("crdtVRptdocNo"));
            processedRecord.set("valuaYmd", rawRecord.getString("valuaYmd"));
            processedRecord.set("bsnsCrdtGrdDstcd", rawRecord.getString("bsnsCrdtGrdDstcd"));
            processedRecord.set("vldYmd", rawRecord.getString("vldYmd"));
            processedRecord.set("stlaccBaseYmd", rawRecord.getString("stlaccBaseYmd"));
            processedRecord.set("mdlScaleDstcd", rawRecord.getString("mdlScaleDstcd"));
            processedRecord.set("fnafBsnsDstcd", rawRecord.getString("fnafBsnsDstcd"));
            processedRecord.set("nonFnafBsnsDstcd", rawRecord.getString("nonFnafBsnsDstcd"));
            
            // BR-017-004: 점수 계산 및 형식화
            processedRecord.set("fnafMdelValscr", formatScore(rawRecord.get("fnafMdelValscr"), 15, 7));
            processedRecord.set("adjsAnFnafValscr", formatScore(rawRecord.get("adjsAnFnafValscr"), 9, 4));
            processedRecord.set("rprsMdelValscr", formatScore(rawRecord.get("rprsMdelValscr"), 9, 5));
            processedRecord.set("grdRstrcCnflCnt", rawRecord.get("grdRstrcCnflCnt"));
            
            // BR-017-005: 등급조정 정보 처리
            processedRecord.set("grdAdjsDstcd", rawRecord.getString("grdAdjsDstcd"));
            processedRecord.set("adjsStgeNoDstcd", rawRecord.getString("adjsStgeNoDstcd"));
            processedRecord.set("lastAplyYms", rawRecord.getString("lastAplyYms"));
            processedRecord.set("lastAplyEmpid", rawRecord.getString("lastAplyEmpid"));
            processedRecord.set("lastAplyBrncd", rawRecord.getString("lastAplyBrncd"));
            
            processedRecords.addRecord(processedRecord);
        }
        
        return processedRecords;
    }

    /**
     * 점수 형식화 처리 (BR-017-004).
     */
    private BigDecimal formatScore(Object scoreValue, int totalDigits, int decimalPlaces) {
        if (scoreValue == null) {
            return BigDecimal.ZERO;
        }
        
        try {
            BigDecimal score = new BigDecimal(scoreValue.toString());
            return score.setScale(decimalPlaces, RoundingMode.HALF_UP);
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }
}
