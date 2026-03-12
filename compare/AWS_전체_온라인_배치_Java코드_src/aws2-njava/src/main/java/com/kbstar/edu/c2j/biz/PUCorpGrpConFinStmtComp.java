package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단합산연결/합산재무제표구성 관리 PU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단의 합산연결/합산 재무제표 구성 및 관리를 담당하는 온라인 거래 처리 단위
 * 포함된 AS 모듈: AIP4A50, AIPBA51
 * ---------------------------------------------------------------------------------
 *  버전	일자			작성자			설명
 * ---------------------------------------------------------------------------------
 *   1.0	20251002	MultiQ4KBBank		최초 작성
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank
 * @since 2025-10-02
 */
@BizUnit("기업집단 합산연결/합산 재무제표 구성")
public class PUCorpGrpConFinStmtComp extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FUCorpGrpConFinStmtPrep fuCorpGrpConFinStmtPrep;
    @BizUnitBind private FUCorpGrpCrdtEvalStatInq fuCorpGrpCrdtEvalStatInq;
    @BizUnitBind private FUCorpGrpConFinStmtComp fuCorpGrpConFinStmtComp;

    /**
     * 거래코드: KIP04A5040
     * 거래명: 기업집단신용평가현황조회
     * <pre>
     * 메소드 설명 : 기업집단의 신용평가 현황을 조회하고 합산연결대상 정보를 제공하는 온라인 거래
     * 비즈니스 기능:
     * - 기업집단 신용평가 현황 데이터 조회 및 분석
     * - 합산연결대상 정보 처리 및 검증
     * - 재무제표 존재여부 확인 및 처리
     * - 다년도 재무분석 데이터 처리
     * - 모자회사 관계 관리 및 최상위지배기업 식별
     * - 레코드 수 제한 및 성능 최적화
     * 
     * 입력 파라미터:
     * - field : corpClctGroupCd [기업집단그룹코드] (string)
     * - field : corpClctRegiCd [기업집단등록코드] (string)
     * - field : valuaBaseYmd [평가기준년월일] (string)
     * - field : prcssDstic [처리구분] (string)
     * 
     * 출력 파라미터:
     * - field : returnCd [리턴코드] (string)
     * - field : returnMsg [리턴메시지] (string)
     * - field : totalNoitm1 [총건수] (int)
     * - field : prsntNoitm1 [현재건수] (int)
     * - recordSet : corpGrpStatusList [기업집단현황정보 LIST]
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단신용평가현황조회")
    public IDataSet pmKIP04A5040(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단신용평가현황조회 시작");
            
            // 입력 데이터 로깅
            log.debug("입력 파라미터 - 기업집단그룹코드: " + requestData.getString("corpClctGroupCd"));
            log.debug("입력 파라미터 - 기업집단등록코드: " + requestData.getString("corpClctRegiCd"));
            log.debug("입력 파라미터 - 평가기준년월일: " + requestData.getString("valuaBaseYmd"));
            log.debug("입력 파라미터 - 처리구분: " + requestData.getString("prcssDstic"));

            // 입력 파라미터 검증
            if (requestData == null) {
                throw new BusinessException("B3600552", "UKIP0001", "입력 데이터가 없습니다.");
            }
            
            // PM → FM 호출 (변환 가이드 준수)
            IDataSet result = fuCorpGrpConFinStmtComp.processCorpGrpConFinStmtComp(requestData, onlineCtx);
            
            // 응답 데이터 설정
            responseData.put("corpGrpStatusList", result.getRecordSet("corpGrpStatusList"));
            responseData.put("totalNoitm1", result.getInt("totalNoitm1"));
            responseData.put("prsntNoitm1", result.getInt("prsntNoitm1"));
            
            // 처리 상태 설정
            responseData.put("returnCd", "00");
            responseData.put("returnMsg", "정상처리되었습니다.");
            
            log.debug("기업집단신용평가현황조회 완료 - 총건수: " + result.getInt("totalNoitm1") + ", 현재건수: " + result.getInt("prsntNoitm1"));

        } catch (BusinessException e) {
            log.error("기업집단신용평가현황조회 비즈니스 오류", e);
            
            // 비즈니스 예외는 그대로 전파
            throw e;
            
        } catch (Exception e) {
            log.error("기업집단신용평가현황조회 시스템 오류", e);
            
            // 시스템 오류를 비즈니스 예외로 변환
            throw new BusinessException("B3900001", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 거래코드: KIP11A51E0
     * 거래명: 기업집단연결재무제표작성
     * <pre>
     * 메소드 설명 : 기업집단의 연결재무제표를 작성하고 합산연결대상을 선정하는 온라인 거래
     * 비즈니스 기능:
     * - 기업집단 연결재무제표 데이터 조회 및 작성
     * - 기업집단 기본정보 조회
     * - 연결재무제표 작성 프로세스 관리
     * 
     * 입력 파라미터:
     * - field : corpClctGroupCd [기업집단그룹코드] (string)
     * - field : corpClctRegiCd [기업집단등록코드] (string)
     * - field : valuaYmd [평가년월일] (string)
     * - field : valuaBaseYmd [평가기준년월일] (string)
     * 
     * 출력 파라미터:
     * - field : returnCd [리턴코드] (string)
     * - field : returnMsg [리턴메시지] (string)
     * - field : totalRecords [총조회건수] (int)
     * - recordSet : conFinStmtInfo [연결재무제표정보 LIST]
     * - recordSet : basicInfo [기업집단 기본정보 LIST]
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단연결재무제표작성")
    public IDataSet pmKIP11A51E0(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단연결재무제표작성 시작");
            
            // 입력 데이터 로깅
            log.debug("입력 파라미터 - 기업집단그룹코드: " + requestData.getString("corpClctGroupCd"));
            log.debug("입력 파라미터 - 기업집단등록코드: " + requestData.getString("corpClctRegiCd"));
            log.debug("입력 파라미터 - 평가년월일: " + requestData.getString("valuaYmd"));
            log.debug("입력 파라미터 - 평가기준년월일: " + requestData.getString("valuaBaseYmd"));

            // 입력 파라미터 검증
            if (requestData == null) {
                throw new BusinessException("B3600552", "UKIP0001", "입력 데이터가 없습니다.");
            }
            
            // PM → FM 호출 (변환 가이드 준수)
            IDataSet result = fuCorpGrpConFinStmtPrep.processCorpGrpConFinStmtPrep(requestData, onlineCtx);
            
            // 응답 데이터 설정
            responseData.put("conFinStmtInfo", result.getRecordSet("conFinStmtInfo"));
            responseData.put("basicInfo", result.getRecordSet("basicInfo"));
            responseData.put("totalRecords", result.getInt("totalRecords"));
            
            // 처리 상태 설정
            responseData.put("processStatus", "SUCCESS");
            responseData.put("processMessage", "기업집단연결재무제표작성이 성공적으로 완료되었습니다.");
            
            log.debug("기업집단연결재무제표작성 완료 - 조회건수: " + result.getInt("totalRecords"));

        } catch (BusinessException e) {
            log.error("기업집단연결재무제표작성 비즈니스 오류", e);
            
            // 비즈니스 예외는 그대로 전파
            throw e;
            
        } catch (Exception e) {
            log.error("기업집단연결재무제표작성 시스템 오류", e);
            
            // 시스템 오류를 비즈니스 예외로 변환
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }
        
        return responseData;
    }

}
