package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단연혁조회 FU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단의 연혁 정보를 조회하고 관리하는 기능 단위
 * 비즈니스 기능:
 * - 처리구분에 따른 연혁데이터 검색 (신규평가/기존평가)
 * - 외부 신용평가 시스템 통합
 * - 계열사 개수 관리
 * - 관리부점 정보 해결
 * - 연혁데이터 시간순 정렬 및 페이지네이션
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
@BizUnit(value = "기업집단연혁조회", type = "FU")
public class FUCorpGrpHistInq extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPB110 duTSKIPB110;
    @BizUnitBind private DUTSKIPB111 duTSKIPB111;

    /**
     * 기업집단연혁조회 메인 처리.
     * <pre>
     * 메소드 설명 : 처리구분에 따라 기업집단 연혁정보를 조회하는 메인 기능
     * 비즈니스 규칙:
     * - BR-035-001: 처리구분검증 ('20': 신규평가, '40': 기존평가)
     * - BR-035-002: 기업집단파라미터검증
     * - BR-035-003: 평가일자일관성
     * - BR-035-004: 처리유형데이터소스선택
     * - BR-035-005: 연혁데이터시간순정렬
     * - BR-035-006: 최대레코드수제한 (500건)
     * - BR-035-007: 신규평가외부데이터통합
     * - BR-035-008: 기존평가최대일자선택
     * - BR-035-009: 계열사개수관리
     * - BR-035-010: 부점정보해결
     * 
     * 처리 흐름:
     * 1. 입력 파라미터 검증
     * 2. 처리구분에 따른 분기 처리
     * 3. 연혁데이터 검색 및 정렬
     * 4. 계열사 정보 조회
     * 5. 관리부점 정보 해결
     * 6. 응답 데이터 생성
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 처리 결과 데이터
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단연혁조회")
    public IDataSet inquireCorpGrpHistory(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단연혁조회 FU 처리 시작");

            // BR-035-001: 처리구분검증
            String prcssdstic = requestData.getString("prcssdstic");
            if (prcssdstic == null || prcssdstic.trim().isEmpty()) {
                // TODO: 에러코드 B3000070, 조치메시지 UKIP0007 확인 필요
                throw new BusinessException("B3000070", "UKIP0007", "처리구분코드는 필수입력항목입니다.");
            }
            
            if (!"20".equals(prcssdstic) && !"40".equals(prcssdstic)) {
                // TODO: 에러코드 B3000070, 조치메시지 UKIP0007 확인 필요
                throw new BusinessException("B3000070", "UKIP0007", "처리구분코드는 '20'(신규평가) 또는 '40'(기존평가)이어야 합니다.");
            }

            // BR-035-002: 기업집단파라미터검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                // TODO: 에러코드 B3800004, 조치메시지 UKIP0001 확인 필요
                throw new BusinessException("B3800004", "UKIP0001", "기업집단그룹코드는 필수입력항목입니다.");
            }

            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                // TODO: 에러코드 B3800004, 조치메시지 UKIP0001 확인 필요
                throw new BusinessException("B3800004", "UKIP0001", "기업집단등록코드는 필수입력항목입니다.");
            }

            String valuaYmd = requestData.getString("valuaYmd");
            if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
                // TODO: 에러코드 B3800004, 조치메시지 UKIP0003 확인 필요
                throw new BusinessException("B3800004", "UKIP0003", "평가년월일은 필수입력항목입니다.");
            }

            // BR-035-003: 평가일자일관성 - YYYYMMDD 형식 검증
            if (!valuaYmd.matches("^\\d{8}$")) {
                // TODO: 에러코드 B3800004, 조치메시지 UKIP0003 확인 필요
                throw new BusinessException("B3800004", "UKIP0003", "평가년월일은 YYYYMMDD 형식이어야 합니다.");
            }

            log.debug("입력 파라미터 검증 완료 - 처리구분: " + prcssdstic);

            // BR-035-004: 처리유형데이터소스선택
            IDataSet historyResult;
            if ("20".equals(prcssdstic)) {
                // 신규평가 처리
                historyResult = _processNewEvaluation(requestData, onlineCtx);
            } else {
                // 기존평가 처리
                historyResult = _processExistingEvaluation(requestData, onlineCtx);
            }

            // BR-035-009: 계열사개수관리 (기본 정보에서 조회)
            IDataSet basicInfoReq = new DataSet();
            basicInfoReq.put("corpClctGroupCd", corpClctGroupCd);
            basicInfoReq.put("corpClctRegiCd", corpClctRegiCd);
            basicInfoReq.put("valuaYmd", valuaYmd);
            
            IDataSet basicInfoResult = duTSKIPB110.select(basicInfoReq, onlineCtx);

            // BR-035-010: 부점정보해결
            String mgtBrncd = "";
            String mgtbrnName = "";
            if (basicInfoResult != null && basicInfoResult.getRecordSet("LIST") != null 
                && basicInfoResult.getRecordSet("LIST").getRecordCount() > 0) {
                IRecord basicInfo = basicInfoResult.getRecordSet("LIST").getRecord(0);
                mgtBrncd = basicInfo.getString("mgtBrncd");
                // TODO: 부점명 해결 로직 - 부점기본정보 테이블 조회 필요
                mgtbrnName = "관리부점"; // 임시값
            }

            // 응답 데이터 구성
            responseData.put("totalNoitm", historyResult.getInt("totalNoitm"));
            responseData.put("prsntNoitm", historyResult.getInt("prsntNoitm"));
            responseData.put("inquryNoitm", historyResult.getInt("totalNoitm")); // 조회건수는 총건수와 동일
            responseData.put("mgtBrncd", mgtBrncd);
            responseData.put("mgtbrnName", mgtbrnName);
            responseData.put("historyGrid", historyResult.getRecordSet("historyGrid"));

            log.debug("기업집단연혁조회 FU 처리 완료 - 총건수: " + historyResult.getInt("totalNoitm"));

        } catch (BusinessException e) {
            log.error("기업집단연혁조회 FU 비즈니스 오류", e);
            throw e;
        } catch (Exception e) {
            log.error("기업집단연혁조회 FU 시스템 오류", e);
            // TODO: 에러코드 B3900001, 조치메시지 UKII0126 확인 필요
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 신규평가 연혁데이터 처리.
     * <pre>
     * BR-035-007: 신규평가외부데이터통합
     * - 내부 연혁데이터 우선 조회
     * - 데이터 없을 시 외부 시스템 통합 (TODO)
     * </pre>
     */
    private IDataSet _processNewEvaluation(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        
        // 신규평가용 연혁데이터 조회 (평가확정일자 = SPACE)
        IDataSet histReq = new DataSet();
        histReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        histReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        histReq.put("valuaYmd", requestData.getString("valuaYmd"));
        histReq.put("valuaDefinsYmd", ""); // 신규평가는 확정일자 없음
        
        IDataSet histResult = duTSKIPB111.selectNewEvalHistory(histReq, onlineCtx);
        
        // 내부 데이터가 없으면 외부 시스템 통합
        if (histResult.getRecordSet("historyGrid") == null || 
            histResult.getRecordSet("historyGrid").getRecordCount() == 0) {
            log.debug("내부 연혁데이터 없음 - 외부 시스템 통합 필요");
            // TODO: 외부 한국신용평가 시스템(IAB0953) 통합 로직
            // 현재는 빈 결과 반환
            histResult.put("totalNoitm", 0);
            histResult.put("prsntNoitm", 0);
        }
        
        return histResult;
    }

    /**
     * 기존평가 연혁데이터 처리.
     * <pre>
     * BR-035-008: 기존평가최대일자선택
     * - 최대 평가일자 기준으로 연혁데이터 조회
     * </pre>
     */
    private IDataSet _processExistingEvaluation(IDataSet requestData, IOnlineContext onlineCtx) {
        // 기존평가용 연혁데이터 조회 (최대 평가일자 기준)
        IDataSet histReq = new DataSet();
        histReq.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
        histReq.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
        histReq.put("valuaYmd", requestData.getString("valuaYmd"));
        
        return duTSKIPB111.select(histReq, onlineCtx);
    }
}
