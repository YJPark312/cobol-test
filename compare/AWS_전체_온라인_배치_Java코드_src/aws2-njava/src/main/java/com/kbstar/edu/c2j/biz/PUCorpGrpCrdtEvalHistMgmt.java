package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;
import com.kbstar.sqc.common.CommonArea;

/**
 * 기업집단신용평가이력관리 관리 PU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단의 신용평가 이력 관리 및 모니터링을 담당하는 온라인 거래 처리 단위
 * 포함된 AS 모듈: AIPBA30, AIP4A40, AIP4A34
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
@BizUnit(value = "기업집단신용평가이력관리", type = "PU")
public class PUCorpGrpCrdtEvalHistMgmt extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FUCorpGrpCrdtDataProc fuCorpGrpCrdtDataProc;
    @BizUnitBind private FUCorpGrpCrdtEvalHistProc fuCorpGrpCrdtEvalHistProc;

    /**
     * 거래코드: KIP11A30E0
     * 거래명: 기업집단신용평가이력관리
     * <pre>
     * 메소드 설명 : 기업집단의 신용평가 이력을 관리하는 온라인 거래
     * 비즈니스 기능:
     * - 신규평가, 확정취소, 평가삭제 처리
     * - 기업집단 신용평가 이력 데이터 관리
     * - 평가 프로세스 상태 관리
     * 
     * 입력 파라미터:
     * - field : prcssDstcd [처리구분코드] (string)
     * - field : corpClctGroupCd [기업집단그룹코드] (string)
     * - field : corpClctName [기업집단명] (string)
     * - field : valuaYmd [평가년월일] (string)
     * - field : valuaBaseYmd [평가기준년월일] (string)
     * - field : corpClctRegiCd [기업집단등록코드] (string)
     * 
     * 출력 파라미터:
     * - field : totalNoitm [총건수] (int)
     * - field : prsntNoitm [현재건수] (int)
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단신용평가이력관리")
    public IDataSet pmKIP11A30E0(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        // CommonArea 객체 참조
        CommonArea ca = getCommonArea(onlineCtx);
        
        // BR-052-001: 처리구분코드 필수 검증
        String prcssDstcd = requestData.getString("prcssDstcd");
        if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
            // TODO: 에러코드 B3800004, 조치메시지 UKIF0072 확인 필요
            throw new BusinessException("B3800004", "UKIF0072", "처리구분코드를 입력해주세요.");
        }
        
        // BR-052-002: 기업집단그룹코드 필수 검증
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            // TODO: 에러코드 B3800004, 조치메시지 UKIP0001 확인 필요
            throw new BusinessException("B3800004", "UKIP0001", "기업집단그룹코드를 입력해주세요.");
        }
        
        // BR-052-003: 평가년월일 필수 검증
        String valuaYmd = requestData.getString("valuaYmd");
        if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
            // TODO: 에러코드 B3800004, 조치메시지 UKIP0003 확인 필요
            throw new BusinessException("B3800004", "UKIP0003", "평가년월일을 입력해주세요.");
        }
        
        // BR-052-004: 기업집단등록코드 필수 검증
        String corpClctRegiCd = requestData.getString("corpClctRegiCd");
        if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
            // TODO: 에러코드 B3800004, 조치메시지 UKIP0002 확인 필요
            throw new BusinessException("B3800004", "UKIP0002", "기업집단등록코드를 입력해주세요.");
        }
        
        // BR-052-005: 신규평가시 평가기준년월일 필수 검증
        if ("01".equals(prcssDstcd)) {
            String valuaBaseYmd = requestData.getString("valuaBaseYmd");
            if (valuaBaseYmd == null || valuaBaseYmd.trim().isEmpty()) {
                // TODO: 에러코드 B3800004, 조치메시지 UKIP0008 확인 필요
                throw new BusinessException("B3800004", "UKIP0008", "평가기준년월일을 입력해주세요.");
            }
        }
        
        try {
            // FU 호출 - 기업집단신용평가이력처리
            responseData = fuCorpGrpCrdtEvalHistProc.processCorpGrpCrdtEvalHist(requestData, onlineCtx);
            
            // 성공 상태 반환
            responseData.put("statusCode", "00");
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            // 일반 시스템 오류
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 거래코드: KIP04A4040
     * 거래명: 기업집단신용등급모니터링
     * <pre>
     * 메소드 설명 : 기업집단의 신용등급을 모니터링하는 온라인 거래
     * 비즈니스 기능:
     * - 기업집단 신용등급 조회 및 모니터링
     * - 평가 기준년월 기반 데이터 조회
     * - 신용등급 변동 추적
     * 
     * 입력 파라미터:
     * - field : inquryBaseYm [조회기준년월] (string)
     * - field : corpClctGroupCd [기업집단그룹코드] (string)
     * 
     * 출력 파라미터:
     * - field : totalNoitm [총건수] (int)
     * - field : prsntNoitm [현재건수] (int)
     * - recordSet : LIST [기업집단평가기본 테이블 LIST]
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단신용등급모니터링")
    public IDataSet pmKIP04A4040(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        // CommonArea 객체 참조
        CommonArea ca = getCommonArea(onlineCtx);
        
        // BR-016-001: 조회기준년월 필수 검증 (AS Level)
        String inquryBaseYm = requestData.getString("inquryBaseYm");
        if (inquryBaseYm == null || inquryBaseYm.trim().isEmpty()) {
            // TODO: 에러코드 B3800004, 조치메시지 UKIP0003 확인 필요
            throw new BusinessException("B3800004", "UKIP0003", "조회기준년월을 입력해주세요.");
        }
        
        try {
            // F-016-001: 기업집단신용등급조회 기능 단위 호출
            responseData = fuCorpGrpCrdtDataProc.getCorpGrpCrdtRating(requestData, onlineCtx);
            
            // BR-016-009: 화면 포맷 식별자 설정 ('V1' + 화면번호)
            // nKESA 프레임워크 표준 화면번호 획득 방식 적용
            String screenNo = ca.getBiCom().getScrenNo();
            if (screenNo == null || screenNo.trim().isEmpty()) {
                screenNo = "0000"; // 기본값 설정
            }
            String formatId = "V1" + screenNo;
            // TODO: 화면번호 설정 방법 확인 필요
            responseData.put("formatId", formatId);
            
            // BR-016-007: 성공 상태 반환
            responseData.put("statusCode", "00");
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            // 일반 시스템 오류
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * 거래코드: KIP04A3440
     * 거래명: 기업집단신용평가이력조회
     * <pre>
     * 메소드 설명 : 기업집단의 신용평가 이력을 조회하는 온라인 거래
     * 비즈니스 기능:
     * - 기업집단 신용평가 이력 데이터 조회
     * - 처리구분별 이력 정보 제공
     * - 평가 프로세스 추적
     * 
     * 입력 파라미터:
     * - field : prcssDstcd [처리구분코드] (string)
     * - field : corpClctGroupCd [기업집단그룹코드] (string)
     * - field : corpClctName [기업집단명] (string)
     * - field : valuaYmd [평가년월일] (string)
     * - field : corpClctRegiCd [기업집단등록코드] (string)
     * - field : prcssStgeCtnt [처리단계내용] (string)
     * 
     * 출력 파라미터:
     * - field : totalNoitm [총건수] (int)
     * - field : prsntNoitm [현재건수] (int)
     * - recordSet : LIST [기업집단평가이력 LIST]
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단신용평가이력조회")
    public IDataSet pmKIP04A3440(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        // CommonArea 객체 참조
        CommonArea ca = getCommonArea(onlineCtx);
        
        // BR-030-001: 처리구분코드 필수 검증 (AS Level)
        String prcssDstcd = requestData.getString("prcssDstcd");
        if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
            // TODO: 에러코드 B3000070, 조치메시지 UKIP0001 확인 필요
            throw new BusinessException("B3000070", "UKIP0001", "처리구분코드를 입력해주세요.");
        }
        
        // BR-030-002: 필수 필드 검증
        String corpClctGroupCd = requestData.getString("corpClctGroupCd");
        if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
            // TODO: 에러코드 B3800004, 조치메시지 UKIP0001 확인 필요
            throw new BusinessException("B3800004", "UKIP0001", "기업집단그룹코드를 입력해주세요.");
        }
        
        String corpClctName = requestData.getString("corpClctName");
        if (corpClctName == null || corpClctName.trim().isEmpty()) {
            // TODO: 에러코드 B3800004, 조치메시지 UKIP0006 확인 필요
            throw new BusinessException("B3800004", "UKIP0006", "기업집단명을 입력해주세요.");
        }
        
        try {
            // F-030-001: 기업집단신용평가이력조회 기능 단위 호출
            responseData = fuCorpGrpCrdtEvalHistProc.getCorpGrpCrdtEvalHist(requestData, onlineCtx);
            
            // 성공 상태 반환
            responseData.put("statusCode", "00");
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            // 일반 시스템 오류
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

}
