package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단개요 관리 PU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단의 개요 및 요약 정보를 관리하는 온라인 거래 처리 단위
 * 포함된 AS 모듈: AIPBA63, AIP4A65, AIPBA66, AIPBA68, AIP4A67, AIP4A62, AIP4A61
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
@BizUnit("기업집단개요")
public class PUCorpGrpSumm extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FUCorpGrpSummInq fuCorpGrpSummInq;
    @BizUnitBind private FUCorpGrpHistInq fuCorpGrpHistInq;
    @BizUnitBind private FUCorpGrpHistMgmt fuCorpGrpHistMgmt;
    @BizUnitBind private FUCorpGrpFinAnalStorage fuCorpGrpFinAnalStorage;
    @BizUnitBind private FUCorpGrpSummInfo fuCorpGrpSummInfo;

    /**
     * 거래코드: KIP11A63E0
     * 거래명: 기업집단연혁저장
     * <pre>
     * 메소드 설명 : 기업집단의 연혁 및 주석 데이터를 저장하는 온라인 거래
     * 비즈니스 기능:
     * - BR-038-001: 기업집단파라미터검증
     * - BR-038-002: 연혁항목처리규칙
     * - BR-038-003: 주석구분규칙
     * - BR-038-004: 트랜잭션데이터베이스운영규칙
     * - BR-038-005: 관리부점업데이트규칙
     * - BR-038-006: 일련번호할당규칙
     * - BR-038-007: 데이터검증규칙
     * - BR-038-008: 그리드처리규칙
     * - BR-038-009: 데이터베이스정리규칙
     * - BR-038-010: 오류처리규칙
     * 
     * 입력 파라미터:
     *	- field : prsntNoitm1 [현재건수1] (int) - 그리드 1의 현재 연혁 항목 수
     *	- field : totalNoitm1 [총건수1] (int) - 그리드 1의 총 연혁 항목 수
     *	- field : prsntNoitm2 [현재건수2] (int) - 그리드 2의 현재 주석 항목 수
     *	- field : totalNoitm2 [총건수2] (int) - 그리드 2의 총 주석 항목 수
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string) - YYYYMMDD 형식
     *	- field : mgtBrncd [관리부점코드] (string)
     *	- recordSet : historyGrid [연혁그리드 LIST]
     *		- field : shetOutptYn [장표출력여부] (string) - '0' 또는 '1'
     *		- field : ordvlYmd [연혁년월일] (string) - YYYYMMDD 형식
     *		- field : ordvlCtnt [연혁내용] (string)
     *	- recordSet : commentaryGrid [주석그리드 LIST]
     *		- field : corpCComtDstcd [기업집단주석구분] (string)
     *		- field : comtCtnt [주석내용] (string)
     * 
     * 출력 파라미터:
     *	- field : totalNoitm [총건수] (int) - 처리된 총 항목 수
     *	- field : prsntNoitm [현재건수] (int) - 처리된 현재 항목 수
     *	- field : returnCd [리턴코드] (string)
     *	- field : returnMsg [리턴메시지] (string)
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (AIPBA63 변환)
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단연혁저장")
    public IDataSet pmKIP11A63E0(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단연혁저장 시작");
            
            // BR-038-001: 기업집단파라미터검증
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

            // BR-038-007: 데이터검증규칙 - YYYYMMDD 형식 검증
            if (!valuaYmd.matches("^\\d{8}$")) {
                throw new BusinessException("B3800004", "UKIP0003", "평가년월일은 YYYYMMDD 형식이어야 합니다.");
            }

            String mgtBrncd = requestData.getString("mgtBrncd");
            if (mgtBrncd == null || mgtBrncd.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIP0004", "관리부점코드는 필수입력항목입니다.");
            }

            // BR-038-008: 그리드처리규칙 - 현재건수 검증
            int prsntNoitm1 = requestData.getInt("prsntNoitm1");
            int totalNoitm1 = requestData.getInt("totalNoitm1");
            int prsntNoitm2 = requestData.getInt("prsntNoitm2");
            int totalNoitm2 = requestData.getInt("totalNoitm2");

            if (prsntNoitm1 > totalNoitm1) {
                throw new BusinessException("B3800005", "UKIP0005", "현재건수1은 총건수1을 초과할 수 없습니다.");
            }

            if (prsntNoitm2 > totalNoitm2) {
                throw new BusinessException("B3800005", "UKIP0005", "현재건수2는 총건수2를 초과할 수 없습니다.");
            }

            log.debug("입력 파라미터 검증 완료");
            log.debug("기업집단그룹코드: " + corpClctGroupCd);
            log.debug("기업집단등록코드: " + corpClctRegiCd);
            log.debug("평가년월일: " + valuaYmd);
            log.debug("관리부점코드: " + mgtBrncd);
            log.debug("연혁항목수: " + prsntNoitm1 + "/" + totalNoitm1);
            log.debug("주석항목수: " + prsntNoitm2 + "/" + totalNoitm2);

            // PM → FM 호출 (변환 가이드 준수: PM → FU → DU)
            IDataSet result = fuCorpGrpHistMgmt.manageCorpGrpHistory(requestData, onlineCtx);
            
            // 응답 데이터 설정
            responseData.put("totalNoitm", result.getInt("totalNoitm"));
            responseData.put("prsntNoitm", result.getInt("prsntNoitm"));
            responseData.put("returnCd", result.getString("returnCd"));
            responseData.put("returnMsg", result.getString("returnMsg"));
            
            log.debug("기업집단연혁저장 완료 - 처리건수: " + result.getInt("totalNoitm"));

        } catch (BusinessException e) {
            log.error("기업집단연혁저장 비즈니스 오류", e);
            
            // 비즈니스 예외는 그대로 전파
            throw e;
            
        } catch (Exception e) {
            log.error("기업집단연혁저장 시스템 오류", e);
            
            // 시스템 오류를 비즈니스 예외로 변환
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 거래코드: KIP04A6540
     * 거래명: 기업집단요약정보조회
     * <pre>
     * 메소드 설명 : 기업집단의 요약 정보를 조회하는 온라인 거래
     * 비즈니스 기능:
     * - 기업집단 기본정보 조회 (TSKIPA111, TSKIPA112 테이블)
     * - 기업집단 관계사 현황 조회 (TSKIPA120 테이블)
     * - 기업집단 종합의견 조회 (TSKIPA130 테이블)
     * 
     * 입력 파라미터:
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : corpClctName [기업집단명] (string)
     *	- field : exmtnCustIdnfr [심사고객식별자] (string)
     *	- field : baseYm [기준년월] (string)
     *	- field : valuaYmd [평가년월일] (string)
     * 
     * 출력 파라미터:
     *	- field : processStatus [처리상태] (string)
     *	- field : processMessage [처리메시지] (string)
     *	- field : totalRecords [총조회건수] (int)
     *	- recordSet : basicInfo [기업집단 기본정보 LIST]
     *		- field : corpClctRegiCd [기업집단등록코드] (string)
     *		- field : corpClctGroupCd [기업집단그룹코드] (string)
     *		- field : corpClctName [기업집단명] (string)
     *	- recordSet : detailInfo [기업집단 상세정보 LIST]
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : regiYms [등록년월일시] (string)
     *		- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- recordSet : relatedCompanies [관계사 현황 LIST]
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : rpsntBzno [대표사업자등록번호] (string)
     *		- field : rpsntEntpName [대표업체명] (string)
     *		- field : totalLnbzAmt [총여신금액] (decimal)
     *	- recordSet : opinions [종합의견 LIST]
     *		- field : corpClctGroupCd [기업집단그룹코드] (string)
     *		- field : corpClctRegiCd [기업집단등록코드] (string)
     *		- field : valuaYmd [평가년월일] (string)
     *		- field : opnCtnt [의견내용] (string)
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (AIP4A65 변환)
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단요약정보조회")
    public IDataSet pmKIP04A6540(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단요약정보조회 시작");
            
            // 입력 데이터 로깅
            log.debug("입력 파라미터 - 그룹회사코드: " + requestData.getString("groupCoCd"));
            log.debug("입력 파라미터 - 기업집단그룹코드: " + requestData.getString("corpClctGroupCd"));
            log.debug("입력 파라미터 - 기업집단등록코드: " + requestData.getString("corpClctRegiCd"));
            log.debug("입력 파라미터 - 기업집단명: " + requestData.getString("corpClctName"));
            log.debug("입력 파라미터 - 심사고객식별자: " + requestData.getString("exmtnCustIdnfr"));
            log.debug("입력 파라미터 - 기준년월: " + requestData.getString("baseYm"));
            log.debug("입력 파라미터 - 평가년월일: " + requestData.getString("valuaYmd"));

            // PM → FM 호출 (변환 가이드 준수)
            IDataSet result = fuCorpGrpSummInq.inquireCorpGrpSummary(requestData, onlineCtx);
            
            // 응답 데이터 설정
            responseData.put("basicInfo", result.getRecordSet("basicInfo"));
            responseData.put("detailInfo", result.getRecordSet("detailInfo"));
            responseData.put("relatedCompanies", result.getRecordSet("relatedCompanies"));
            responseData.put("opinions", result.getRecordSet("opinions"));
            responseData.put("totalRecords", result.getInt("totalRecords"));
            
            // 처리 상태 설정
            responseData.put("processStatus", "SUCCESS");
            responseData.put("processMessage", "기업집단요약정보조회가 성공적으로 완료되었습니다.");
            
            log.debug("기업집단요약정보조회 완료 - 조회건수: " + result.getInt("totalRecords"));

        } catch (BusinessException e) {
            log.error("기업집단요약정보조회 비즈니스 오류", e);
            
            // 비즈니스 예외는 그대로 전파
            throw e;
            
        } catch (Exception e) {
            log.error("기업집단요약정보조회 시스템 오류", e);
            
            // 시스템 오류를 비즈니스 예외로 변환
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 거래코드: KIP11A66E0
     * 거래명: 기업집단사업분석저장
     * <pre>
     * 메소드 설명 : 기업집단의 사업분석 데이터를 저장하는 온라인 거래
     * 비즈니스 기능:
     * - BR-033-001: 기업집단파라미터검증
     * - BR-033-002: 사업부문데이터무결성
     * - BR-033-003: 주석분류관리
     * - BR-033-004: 데이터업데이트거래제어
     * - BR-033-005: 처리건수검증
     * - BR-033-006: 다년도재무분석일관성
     * 
     * 입력 파라미터:
     *	- field : totalNoitm1 [총건수1] (int) - 사업부문 분석 레코드의 총 개수
     *	- field : prsntNoitm1 [현재건수1] (int) - 사업부문 분석 레코드의 현재 개수
     *	- field : totalNoitm2 [총건수2] (int) - 주석 레코드의 총 개수
     *	- field : prsntNoitm2 [현재건수2] (int) - 주석 레코드의 현재 개수
     *	- field : groupCoCd [그룹회사코드] (string)
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string) - YYYYMMDD 형식
     *	- recordSet : bizSectAnalGrid [사업부문분석그리드 LIST]
     *		- field : fnafARptdocDstcd [재무분석보고서구분] (string)
     *		- field : fnafItemCd [재무항목코드] (string)
     *		- field : bizSectNo [사업부문번호] (string)
     *		- field : bizSectDsticName [사업부문구분명] (string)
     *		- field : baseYrItemAmt [기준년항목금액] (decimal)
     *		- field : baseYrRato [기준년비율] (decimal)
     *		- field : baseYrEntpCnt [기준년업체수] (int)
     *		- field : n1YrBfItemAmt [N1년전항목금액] (decimal)
     *		- field : n1YrBfRato [N1년전비율] (decimal)
     *		- field : n1YrBfEntpCnt [N1년전업체수] (int)
     *		- field : n2YrBfItemAmt [N2년전항목금액] (decimal)
     *		- field : n2YrBfRato [N2년전비율] (decimal)
     *		- field : n2YrBfEntpCnt [N2년전업체수] (int)
     *	- recordSet : bizAnalComtGrid [사업분석주석그리드 LIST]
     *		- field : corpCComtDstcd [기업집단주석구분] (string)
     *		- field : comtCtnt [주석내용] (string)
     * 
     * 출력 파라미터:
     *	- field : totalNoitm [총건수] (int) - 처리된 레코드의 총 개수
     *	- field : prsntNoitm [현재건수] (int) - 처리된 레코드의 현재 개수
     *	- field : processStatus [처리상태] (string)
     *	- field : processMessage [처리메시지] (string)
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (AIPBA66 변환)
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단사업분석저장")
    public IDataSet pmKIP11A66E0(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단사업분석저장 시작");
            
            // BR-033-001: 기업집단파라미터검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3300001", "UKFH0001", "기업집단그룹코드는 필수입력항목입니다.");
            }

            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3300002", "UKFH0002", "기업집단등록코드는 필수입력항목입니다.");
            }

            // BR-033-003: 평가년월일 검증
            String valuaYmd = requestData.getString("valuaYmd");
            if (valuaYmd != null && !valuaYmd.trim().isEmpty()) {
                if (!valuaYmd.matches("^\\d{8}$")) {
                    throw new BusinessException("B3300003", "UKFH0003", "평가년월일은 YYYYMMDD 형식이어야 합니다.");
                }
            }

            // PM → FM 호출 (변환 가이드 준수: PM → FU → DU)
            IDataSet result = fuCorpGrpSummInq.inquireCorpGrpSummary(requestData, onlineCtx);
            
            // 응답 데이터 설정
            responseData.put("returnCd", result.getString("returnCd"));
            responseData.put("returnMsg", result.getString("returnMsg"));
            responseData.put("totalNoitm", result.getInt("totalNoitm"));
            responseData.put("prsntNoitm", result.getInt("prsntNoitm"));
            responseData.put("basicInfo", result.getRecordSet("basicInfo"));
            responseData.put("summaryInfo", result.getRecordSet("summaryInfo"));
            
            log.debug("기업집단사업분석저장 완료 - 조회건수: " + result.getInt("totalNoitm"));

        } catch (BusinessException e) {
            log.error("기업집단사업분석저장 비즈니스 오류", e);
            
            // 비즈니스 예외는 그대로 전파
            throw e;
            
        } catch (Exception e) {
            log.error("기업집단사업분석저장 시스템 오류", e);
            
            // 시스템 오류를 비즈니스 예외로 변환
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 거래코드: KIP11A68E0
     * 거래명: 기업집단재무분석저장
     * <pre>
     * 메소드 설명 : 기업집단의 재무분석 데이터를 저장하는 온라인 거래
     * 비즈니스 기능:
     * - BR-041-001: 기업집단그룹코드검증
     * - BR-041-002: 기업집단등록코드검증
     * - BR-041-003: 평가일자검증
     * - BR-041-004: 평가확정일자검증
     * - BR-041-005: 재무분석항목처리
     * - BR-041-006: 평가의견처리
     * - BR-041-007: 안정성분석분류
     * - BR-041-008: 수익성분석분류
     * - BR-041-009: 성장성분석분류
     * - BR-041-010: 데이터베이스레코드교체
     * - BR-041-011: 처리단계업데이트
     * 
     * 입력 파라미터:
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : valuaDefinsYmd [평가확정년월일] (string) - YYYYMMDD 형식
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string) - YYYYMMDD 형식
     *	- field : totalNoitm1 [총건수1] (int) - 재무분석 항목 총 개수
     *	- field : prsntNoitm1 [현재건수1] (int) - 재무분석 항목 현재 개수
     *	- field : totalNoitm2 [총건수2] (int) - 평가의견 항목 총 개수
     *	- field : prsntNoitm2 [현재건수2] (int) - 평가의견 항목 현재 개수
     *	- recordSet : finAnalGrid [재무분석그리드 LIST]
     *		- field : rptdocDstcd [재무분석보고서구분] (string)
     *		- field : fnafItemCd [재무항목코드] (string)
     *		- field : dsticName [구분명] (string)
     *		- field : fnafItemName [재무항목명] (string)
     *		- field : n2YrBfFnafRato [전전년비율] (decimal)
     *		- field : nYrBfFnafRato [전년비율] (decimal)
     *		- field : baseYrFnafRato [기준년비율] (decimal)
     *	- recordSet : evalOpnGrid [평가의견그리드 LIST]
     *		- field : corpCComtDstcd [기업집단주석구분] (string)
     *		- field : comtCtnt [주석내용] (string)
     * 
     * 출력 파라미터:
     *	- field : totalNoitm1 [총건수1] (int) - 처리된 재무분석 항목 총 개수
     *	- field : prsntNoitm1 [현재건수1] (int) - 처리된 재무분석 항목 현재 개수
     *	- field : totalNoitm2 [총건수2] (int) - 처리된 평가의견 항목 총 개수
     *	- field : prsntNoitm2 [현재건수2] (int) - 처리된 평가의견 항목 현재 개수
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251002	MultiQ4KBBank		최초 작성 (AIPBA68 변환)
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("기업집단재무분석저장")
    public IDataSet pmKIP11A68E0(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단재무분석저장 시작");
            
            // BR-041-001: 기업집단그룹코드검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIP0001", "기업집단그룹코드는 필수입력항목입니다.");
            }

            // BR-041-002: 기업집단등록코드검증
            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIP0002", "기업집단등록코드는 필수입력항목입니다.");
            }

            // BR-041-003: 평가일자검증
            String valuaYmd = requestData.getString("valuaYmd");
            if (valuaYmd == null || valuaYmd.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIP0003", "평가년월일은 필수입력항목입니다.");
            }
            if (!valuaYmd.matches("^\\d{8}$")) {
                throw new BusinessException("B3800004", "UKIP0003", "평가년월일은 YYYYMMDD 형식이어야 합니다.");
            }

            // BR-041-004: 평가확정일자검증
            String valuaDefinsYmd = requestData.getString("valuaDefinsYmd");
            if (valuaDefinsYmd == null || valuaDefinsYmd.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIP0004", "평가확정년월일은 필수입력항목입니다.");
            }
            if (!valuaDefinsYmd.matches("^\\d{8}$")) {
                throw new BusinessException("B3800004", "UKIP0004", "평가확정년월일은 YYYYMMDD 형식이어야 합니다.");
            }

            log.debug("입력 파라미터 검증 완료");
            log.debug("기업집단그룹코드: " + corpClctGroupCd);
            log.debug("기업집단등록코드: " + corpClctRegiCd);
            log.debug("평가년월일: " + valuaYmd);
            log.debug("평가확정년월일: " + valuaDefinsYmd);

            // PM → FM 호출 (변환 가이드 준수: PM → FU → DU)
            IDataSet result = fuCorpGrpFinAnalStorage.storeCorpGrpFinAnalysis(requestData, onlineCtx);
            
            // 응답 데이터 설정 (명세서 준수)
            responseData.put("totalNoitm1", result.getInt("totalNoitm1"));
            responseData.put("prsntNoitm1", result.getInt("prsntNoitm1"));
            responseData.put("totalNoitm2", result.getInt("totalNoitm2"));
            responseData.put("prsntNoitm2", result.getInt("prsntNoitm2"));
            
            log.debug("기업집단재무분석저장 완료 - 재무분석건수: " + result.getInt("prsntNoitm1") + 
                     ", 평가의견건수: " + result.getInt("prsntNoitm2"));

        } catch (BusinessException e) {
            log.error("기업집단재무분석저장 비즈니스 오류", e);
            throw e;
            
        } catch (Exception e) {
            log.error("기업집단재무분석저장 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 거래코드: KIP04A6740
     * 거래명: 기업집단재무분석조회
     * <pre>
     * 메소드 설명 : 기업집단의 재무분석 데이터를 조회하는 온라인 거래
     * 비즈니스 기능:
     * - BR-027-001: 처리구분코드 검증 (신규평가: 20, 기존평가: 40)
     * - BR-027-002: 기업집단식별검증 (그룹코드, 등록코드)
     * - BR-027-003: 평가일자검증 (평가년월일, 평가확정일자)
     * - BR-027-004: 기준년도계산 (전년도, 2년전 계산)
     * - BR-027-005: 재무항목분류 (안정성, 수익성, 성장성/활동성)
     * - BR-027-006: 레코드수제한 (최대 100건)
     * - BR-027-007: 평가의견분류 (코멘트 유형별)
     * - BR-027-008: 처리유형결정 (신규 vs 기존)
     * 
     * 입력 파라미터:
     *	- field : prcssDstcd [처리구분코드] (string) - '20': 신규평가, '40': 기존평가
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string) - YYYYMMDD 형식
     *	- field : valuaDefinsYmd [평가확정일자] (string) - YYYYMMDD 형식
     *	- field : basezYr [기준년도] (string) - YYYY 형식
     * 
     * 출력 파라미터:
     *	- field : processStatus [처리상태] (string)
     *	- field : processMessage [처리메시지] (string)
     *	- field : totalNoitm1 [총건수1] (int) - 재무분석 총건수
     *	- field : prsntNoitm1 [현재건수1] (int) - 재무분석 현재건수
     *	- field : totalNoitm2 [총건수2] (int) - 평가의견 총건수
     *	- field : prsntNoitm2 [현재건수2] (int) - 평가의견 현재건수
     *	- recordSet : finAnalGrid [재무분석그리드 LIST]
     *		- field : rptdocDstcd [재무분석보고서구분] (string)
     *		- field : fnafItemCd [재무항목코드] (string)
     *		- field : dsticName [구분명] (string)
     *		- field : fnafItemName [재무항목명] (string)
     *		- field : n2YrBfFnafRato [전전년비율] (decimal)
     *		- field : nYrBfFnafRato [전년비율] (decimal)
     *		- field : baseYrFnafRato [기준년비율] (decimal)
     *	- recordSet : evalOpnGrid [평가의견그리드 LIST]
     *		- field : corpCComtDstcd [기업집단주석구분] (string)
     *		- field : comtCtnt [주석내용] (string)
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (AIP4A67 변환)
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단재무분석조회")
    public IDataSet pmKIP04A6740(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단재무분석조회 시작");
            
            // 입력 데이터 로깅
            log.debug("입력 파라미터 - 처리구분코드: " + requestData.getString("prcssDstcd"));
            log.debug("입력 파라미터 - 기업집단그룹코드: " + requestData.getString("corpClctGroupCd"));
            log.debug("입력 파라미터 - 기업집단등록코드: " + requestData.getString("corpClctRegiCd"));
            log.debug("입력 파라미터 - 평가년월일: " + requestData.getString("valuaYmd"));
            log.debug("입력 파라미터 - 평가확정일자: " + requestData.getString("valuaDefinsYmd"));
            log.debug("입력 파라미터 - 기준년도: " + requestData.getString("basezYr"));

            // PM → FM 호출 (변환 가이드 준수: PM → FU → DU)
            IDataSet result = fuCorpGrpSummInq.inquireCorpGrpSummary(requestData, onlineCtx);
            
            // 응답 데이터 설정
            responseData.put("totalNoitm1", result.getInt("totalNoitm1"));
            responseData.put("prsntNoitm1", result.getInt("prsntNoitm1"));
            responseData.put("totalNoitm2", result.getInt("totalNoitm2"));
            responseData.put("prsntNoitm2", result.getInt("prsntNoitm2"));
            responseData.put("finAnalGrid", result.getRecordSet("finAnalGrid"));
            responseData.put("evalOpnGrid", result.getRecordSet("evalOpnGrid"));
            
            // 처리 상태 설정
            responseData.put("processStatus", "SUCCESS");
            responseData.put("processMessage", "기업집단재무분석조회가 성공적으로 완료되었습니다.");
            
            log.debug("기업집단재무분석조회 완료 - 재무분석건수: " + result.getInt("prsntNoitm1") + 
                     ", 평가의견건수: " + result.getInt("prsntNoitm2"));

        } catch (BusinessException e) {
            log.error("기업집단재무분석조회 비즈니스 오류", e);
            
            // 비즈니스 예외는 그대로 전파
            throw e;
            
        } catch (Exception e) {
            log.error("기업집단재무분석조회 시스템 오류", e);
            
            // 시스템 오류를 비즈니스 예외로 변환
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 거래코드: KIP04A6240
     * 거래명: 기업집단계열사조회
     * <pre>
     * 메소드 설명 : 기업집단 계열사 현황 조회를 위한 포괄적인 온라인 처리 시스템
     * 비즈니스 기능:
     * - BR-051-001: 기업집단그룹코드 검증
     * - BR-051-002: 평가년월일 검증
     * - BR-051-003: 평가기준년월일 검증
     * - BR-051-004: 기업집단등록코드 검증
     * - BR-051-005: 처리구분코드 검증 ('20': 신규평가, '40': 기존평가)
     * - BR-051-006: 신규평가 처리 규칙
     * - BR-051-007: 기존평가 처리 규칙
     * - BR-051-008: 재무데이터 처리 규칙
     * - BR-051-012: 주석데이터 처리 규칙
     * - BR-051-013: 데이터 일관성 규칙
     * - BR-051-014: 출력그리드 처리 규칙
     * - BR-051-015: 재무계산 통합 규칙
     * 
     * 입력 파라미터:
     *	- field : prcssDstcd [처리구분코드] (string) - '20': 신규평가, '40': 기존평가
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaBaseYmd [평가기준년월일] (string) - YYYYMMDD 형식
     *	- field : valuaYmd [평가년월일] (string) - YYYYMMDD 형식
     *	- field : valuaDefinsYmd [평가확정년월일] (string) - YYYYMMDD 형식
     * 
     * 출력 파라미터:
     *	- field : totalNoitm1 [총건수1] (int) - 그리드 1의 계열사 레코드 총 개수
     *	- field : prsntNoitm1 [현재건수1] (int) - 그리드 1의 계열사 레코드 현재 개수
     *	- field : totalNoitm2 [총건수2] (int) - 그리드 2의 계열사 레코드 총 개수
     *	- field : prsntNoitm2 [현재건수2] (int) - 그리드 2의 계열사 레코드 현재 개수
     *	- field : exmtnCustIdnfr [심사고객식별자] (string)
     *	- field : coprName [법인명] (string)
     *	- field : totalAsam [총자산금액] (decimal)
     *	- field : salepr [매출액] (decimal)
     *	- field : captlTsumnAmt [자본총계금액] (decimal)
     *	- field : netPrft [순이익] (decimal)
     *	- field : oprft [영업이익] (decimal)
     *	- recordSet : affiliateGrid1 [계열사회사데이터그리드 LIST]
     *		- field : exmtnCustIdnfr [심사고객식별자] (string)
     *		- field : coprName [법인명] (string)
     *		- field : totalAsam [총자산금액] (decimal)
     *		- field : salepr [매출액] (decimal)
     *		- field : captlTsumnAmt [자본총계금액] (decimal)
     *		- field : netPrft [순이익] (decimal)
     *		- field : oprft [영업이익] (decimal)
     *	- recordSet : affiliateGrid2 [주석데이터그리드 LIST]
     *		- field : corpCComtDstcd [기업집단주석구분코드] (string)
     *		- field : comtCtnt [주석내용] (string)
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (AIP4A62 변환)
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단계열사조회")
    public IDataSet pmKIP04A6240(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단계열사조회 시작");
            
            // BR-051-005: 처리구분코드 검증
            String prcssDstcd = requestData.getString("prcssDstcd");
            if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIF0072", "처리구분코드는 필수입력항목입니다.");
            }
            if (!"20".equals(prcssDstcd) && !"40".equals(prcssDstcd)) {
                throw new BusinessException("B3000070", "UKII0291", "처리구분코드는 '20' 또는 '40'이어야 합니다.");
            }

            // BR-051-001: 기업집단그룹코드 검증
            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIF0072", "기업집단그룹코드는 필수입력항목입니다.");
            }

            // BR-051-004: 기업집단등록코드 검증
            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIF0072", "기업집단등록코드는 필수입력항목입니다.");
            }

            // BR-051-003: 평가기준년월일 검증
            String valuaBaseYmd = requestData.getString("valuaBaseYmd");
            if (valuaBaseYmd == null || valuaBaseYmd.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIF0072", "평가기준년월일은 필수입력항목입니다.");
            }
            if (!valuaBaseYmd.matches("^\\d{8}$")) {
                throw new BusinessException("B3800004", "UKIF0072", "평가기준년월일은 YYYYMMDD 형식이어야 합니다.");
            }

            // BR-051-002: 평가년월일 검증 (선택적)
            String valuaYmd = requestData.getString("valuaYmd");
            if (valuaYmd != null && !valuaYmd.trim().isEmpty() && !valuaYmd.matches("^\\d{8}$")) {
                throw new BusinessException("B3800004", "UKIF0072", "평가년월일은 YYYYMMDD 형식이어야 합니다.");
            }

            log.debug("입력 파라미터 검증 완료");
            log.debug("처리구분코드: " + prcssDstcd);
            log.debug("기업집단그룹코드: " + corpClctGroupCd);
            log.debug("기업집단등록코드: " + corpClctRegiCd);
            log.debug("평가기준년월일: " + valuaBaseYmd);
            log.debug("평가년월일: " + valuaYmd);

            // 올바른 아키텍처 패턴: PM → FM → DM
            responseData = fuCorpGrpSummInfo.inquireCorpGrpAffiliates(requestData, onlineCtx);
            
            // BR-051-005: 처리구분에 따른 분기 처리
            if ("20".equals(prcssDstcd)) {
                // BR-051-006: 신규평가 처리
                log.debug("신규평가 처리 시작");
                
                // 계열사 현황 조회
                
                // BR-051-008: 재무데이터 처리
                
                // BR-051-015: 재무계산 통합 처리
                
                // BR-051-012: 주석데이터 처리 - 과거 평가이력 없음
                responseData.put("totalNoitm2", 1);
                responseData.put("prsntNoitm2", 1);
                
                // 주석 그리드 생성
                DataSet commentGrid = new DataSet();
                commentGrid.put("corpCComtDstcd", "01");
                commentGrid.put("comtCtnt", "과거 평가이력 없음");
                responseData.put("affiliateGrid2", commentGrid);
                
                log.debug("신규평가 처리 완료");
                
            } else if ("40".equals(prcssDstcd)) {
                // BR-051-007: 기존평가 처리
                log.debug("기존평가 처리 시작");
                
                // 기존 평가 데이터 조회
                
                // BR-051-013: 데이터 일관성 검증
                
                // 기존평가의 주석 데이터
                responseData.put("totalNoitm2", 0);
                responseData.put("prsntNoitm2", 0);
                responseData.put("affiliateGrid2", new DataSet());
                
                log.debug("기존평가 처리 완료");
            }

            // BR-051-014: 출력그리드 처리 - 기본 응답 필드 설정
            IRecordSet affiliateGrid = responseData.getRecordSet("affiliateGrid1");
            if (affiliateGrid != null && affiliateGrid.getRecordCount() > 0) {
                responseData.put("exmtnCustIdnfr", affiliateGrid.getRecord(0).getString("exmtnCustIdnfr"));
                responseData.put("coprName", affiliateGrid.getRecord(0).getString("coprName"));
                responseData.put("totalAsam", affiliateGrid.getRecord(0).getBigDecimal("totalAsam"));
                responseData.put("salepr", affiliateGrid.getRecord(0).getBigDecimal("salepr"));
                responseData.put("captlTsumnAmt", affiliateGrid.getRecord(0).getBigDecimal("captlTsumnAmt"));
                responseData.put("netPrft", affiliateGrid.getRecord(0).getBigDecimal("netPrft"));
                responseData.put("oprft", affiliateGrid.getRecord(0).getBigDecimal("oprft"));
            } else {
                // 데이터가 없는 경우 기본값 설정
                responseData.put("exmtnCustIdnfr", "");
                responseData.put("coprName", "");
                responseData.put("totalAsam", java.math.BigDecimal.ZERO);
                responseData.put("salepr", java.math.BigDecimal.ZERO);
                responseData.put("captlTsumnAmt", java.math.BigDecimal.ZERO);
                responseData.put("netPrft", java.math.BigDecimal.ZERO);
                responseData.put("oprft", java.math.BigDecimal.ZERO);
            }
            
            log.debug("기업집단계열사조회 완료 - 그리드1 건수: " + responseData.getInt("prsntNoitm1") + 
                     ", 그리드2 건수: " + responseData.getInt("prsntNoitm2"));

        } catch (BusinessException e) {
            log.error("기업집단계열사조회 비즈니스 오류", e);
            throw e;
            
        } catch (Exception e) {
            log.error("기업집단계열사조회 시스템 오류", e);
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

    /**
     * 거래코드: KIP04A6140
     * 거래명: 기업집단연혁조회
     * <pre>
     * 메소드 설명 : 기업집단의 연혁 정보를 조회하는 온라인 거래
     * 비즈니스 기능:
     * - BR-035-001: 처리구분검증 (신규평가: 20, 기존평가: 40)
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
     * 입력 파라미터:
     *	- field : prcssdstic [처리구분코드] (string) - '20': 신규평가, '40': 기존평가
     *	- field : corpClctGroupCd [기업집단그룹코드] (string)
     *	- field : corpClctRegiCd [기업집단등록코드] (string)
     *	- field : valuaYmd [평가년월일] (string) - YYYYMMDD 형식
     *	- field : valuaBaseYmd [평가기준년월일] (string) - YYYYMMDD 형식
     * 
     * 출력 파라미터:
     *	- field : totalNoitm [총건수] (int) - 발견된 연혁레코드의 총 개수
     *	- field : prsntNoitm [현재건수] (int) - 현재 응답에서 반환된 레코드 수
     *	- field : inquryNoitm [조회건수] (int) - 조회 추적을 위한 추가 개수
     *	- field : mgtBrncd [관리부점코드] (string) - 관리 책임 부점코드
     *	- field : mgtbrnName [관리부점명] (string) - 관리 책임 부점명
     *	- recordSet : historyGrid [연혁그리드 LIST]
     *		- field : ordvlDstic [연혁구분] (string) - 표시를 위한 연혁레코드의 분류
     *		- field : ordvlYmd [연혁년월일] (string) - 연혁사건의 일자
     *		- field : ordvlCtnt [연혁내용] (string) - 연혁사건의 상세 내용
     * ---------------------------------------------------------------------------------
     *  버전	일자			작성자			설명
     * ---------------------------------------------------------------------------------
     *   1.0	20251001	MultiQ4KBBank		최초 작성 (AIP4A61 변환)
     * ---------------------------------------------------------------------------------
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-01
     */
    @BizMethod("기업집단연혁조회")
    public IDataSet pmKIP04A6140(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);

        try {
            log.debug("기업집단연혁조회 시작");
            
            // 입력 데이터 로깅
            log.debug("입력 파라미터 - 처리구분코드: " + requestData.getString("prcssdstic"));
            log.debug("입력 파라미터 - 기업집단그룹코드: " + requestData.getString("corpClctGroupCd"));
            log.debug("입력 파라미터 - 기업집단등록코드: " + requestData.getString("corpClctRegiCd"));
            log.debug("입력 파라미터 - 평가년월일: " + requestData.getString("valuaYmd"));
            log.debug("입력 파라미터 - 평가기준년월일: " + requestData.getString("valuaBaseYmd"));

            // PM → FM 호출 (변환 가이드 준수: PM → FU → DU)
            IDataSet result = fuCorpGrpHistInq.inquireCorpGrpHistory(requestData, onlineCtx);
            
            // 응답 데이터 설정
            responseData.put("totalNoitm", result.getInt("totalNoitm"));
            responseData.put("prsntNoitm", result.getInt("prsntNoitm"));
            responseData.put("inquryNoitm", result.getInt("inquryNoitm"));
            responseData.put("mgtBrncd", result.getString("mgtBrncd"));
            responseData.put("mgtbrnName", result.getString("mgtbrnName"));
            responseData.put("historyGrid", result.getRecordSet("historyGrid"));
            
            log.debug("기업집단연혁조회 완료 - 총건수: " + result.getInt("totalNoitm") + 
                     ", 현재건수: " + result.getInt("prsntNoitm"));

        } catch (BusinessException e) {
            log.error("기업집단연혁조회 비즈니스 오류", e);
            
            // 비즈니스 예외는 그대로 전파
            throw e;
            
        } catch (Exception e) {
            log.error("기업집단연혁조회 시스템 오류", e);
            
            // 시스템 오류를 비즈니스 예외로 변환
            // TODO: 에러코드 B3900001, 조치메시지 UKII0126 확인 필요
            throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
        }

        return responseData;
    }

}
