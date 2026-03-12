package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단그룹코드조회.
 * <pre>
 * 유닛 설명 : 이중 검색 모드를 지원하는 기업집단 그룹코드 조회 기능 유닛
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
@BizUnit(value = "기업집단그룹코드조회", type = "FU")
public class FUCorpGrpCodeInq extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPA111 duTSKIPA111;

    /**
     * 기업집단조회처리.
     * <pre>
     * 메소드 설명 : 처리구분에 따른 이중 검색 모드로 기업집단 정보 조회
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성
     * ---------------------------------------------------------------------------------
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *	- field : prcssDstcd [처리구분코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctName [기업집단명] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *	- field : totalNoitm [총건수] (bigDecimal)
     *	- field : prsntNoitm [현재건수] (bigDecimal)
     *	- recordSet : grid1 [기업집단 정보 LIST]
     *		- field : corpClctRegiCd [기업집단등록코드] (string)
     *		- field : corpClctGroupCd [기업집단그룹코드] (string)
     *		- field : corpClctName [기업집단명] (string)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단조회처리")
    public IDataSet inquireCorpGroup(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            // 강화된 입력값 검증
            validateInput(requestData);
            
            String prcssDstcd = requestData.getString("prcssDstcd");
            IDataSet searchResult = null;
            
            // 검색 모드 결정 및 실행
            if ("01".equals(prcssDstcd)) {
                // 비즈니스 룰 BR-019-002: 기업집단코드 정확한 검색
                searchResult = executeExactSearch(requestData, onlineCtx);
            } else if ("02".equals(prcssDstcd)) {
                // 비즈니스 룰 BR-019-003: 기업집단명 패턴 검색
                searchResult = executePatternSearch(requestData, onlineCtx);
            }

            // 비즈니스 룰 BR-019-004: 검색결과 처리
            responseData = processSearchResults(searchResult, onlineCtx);
            
            log.debug("기업집단조회 완료 - 처리구분: " + prcssDstcd + 
                     ", 조회건수: " + responseData.get("prsntNoitm"));

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B2900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 강화된 입력값 검증.
     */
    private void validateInput(IDataSet requestData) {
        String prcssDstcd = requestData.getString("prcssDstcd");
        
        // 처리구분코드 필수 검증
        if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
            throw new BusinessException("B3000070", "UKIP0007", "처리구분코드를 입력하여 주시기 바랍니다.");
        }
        
        // 처리구분코드 값 범위 검증
        if (!"01".equals(prcssDstcd) && !"02".equals(prcssDstcd)) {
            throw new BusinessException("B3000070", "UKIP0007", "처리구분코드는 01 또는 02만 입력 가능합니다.");
        }
        
        // 검색 모드별 필수값 검증
        if ("01".equals(prcssDstcd)) {
            // 정확한 검색: 기업집단그룹코드 필수
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드를 입력하여 주시기 바랍니다.");
            }
            if (corpClctGroupCd.length() != 3) {
                throw new BusinessException("B3600552", "UKIP0001", "기업집단그룹코드는 3자리여야 합니다.");
            }
        } else if ("02".equals(prcssDstcd)) {
            // 패턴 검색: 기업집단명 필수
            String corpClctName = requestData.getString("corpClctName");
            if (corpClctName == null || corpClctName.trim().isEmpty()) {
                throw new BusinessException("B3600552", "UKIP0002", "기업집단명을 입력하여 주시기 바랍니다.");
            }
            if (corpClctName.length() > 100) {
                throw new BusinessException("B3600552", "UKIP0002", "기업집단명은 100자 이내로 입력하여 주시기 바랍니다.");
            }
        }
    }

    /**
     * 정확한 검색 실행.
     * 비즈니스 룰 BR-019-002 구현
     */
    private IDataSet executeExactSearch(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet searchReq = new DataSet();
        searchReq.put("groupCoCd", "001");
        searchReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        
        return duTSKIPA111.selectByCode(searchReq, onlineCtx);
    }

    /**
     * 패턴 검색 실행.
     * 비즈니스 룰 BR-019-003 구현
     */
    private IDataSet executePatternSearch(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet searchReq = new DataSet();
        searchReq.put("groupCoCd", "001");
        searchReq.put("corpClctName", requestData.getString("corpClctName"));
        
        return duTSKIPA111.selectByName(searchReq, onlineCtx);
    }

    /**
     * 검색결과 처리.
     * 비즈니스 룰 BR-019-004 구현
     */
    private IDataSet processSearchResults(IDataSet searchResult, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        
        int totalCount = searchResult.getInt("totalNoitm");
        int presentCount = Math.min(totalCount, 1000); // 최대 1000건 제한
        
        responseData.put("totalNoitm", totalCount);
        responseData.put("prsntNoitm", presentCount);
        responseData.put("grid1", searchResult.get("grid1"));
        
        return responseData;
    }
}
