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
 * 관계회사집단현황 관리 PU 클래스.
 * <pre>
 * 클래스 설명 : 관계회사 집단의 현황 관리 및 조회를 담당하는 온라인 거래 처리 단위
 * 포함된 AS 모듈: AIPBA11, AIP4A10
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
@BizUnit("관계기업군현황")
public class PURelCoGrpStat extends com.kbstar.sqc.base.ProcessUnit {

    @BizUnitBind private FURelCoGrpStat fuRelCoGrpStat;

    /**
     * 거래코드: KIP11A11E0
     * 거래명: 관계기업군그룹등록
     * <pre>
     * 메소드 설명 : 관계기업군의 그룹 정보를 등록하는 온라인 거래
     * 비즈니스 기능:
     * - 관계기업군 그룹 정보 등록
     * - 기업집단 기본정보 관리
     * - 그룹 구성원 관리
     * 
     * 입력 파라미터:
     * - field : prcssDstcd [처리구분코드] (string)
     * - field : corpClctRegiCd [기업집단등록코드] (string)
     * - field : corpClctGroupCd [기업집단그룹코드] (string)
     * - field : corpClctName [기업집단명] (string)
     * - field : exmtnCustIdnfr [심사고객식별자] (string)
     * - field : rpsntBzno [대표사업자등록번호] (string)
     * - field : rpsntEntpName [대표업체명] (string)
     * - field : corpGmGroupDstcd [기업군관리그룹구분코드] (string)
     * - field : mainDaGroupYn [주채무계열그룹여부] (string)
     * 
     * 출력 파라미터:
     * - field : processStatus [처리상태] (string)
     * - field : processMessage [처리메시지] (string)
     * - recordSet : registrationData [등록데이터 LIST]
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("관계기업군그룹등록")
    public IDataSet pmKIP11A11E0(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("관계기업군그룹등록 처리 시작");

        try {
            // 입력 데이터 검증
            if (requestData == null) {
                throw new BusinessException("B2900001", "UKII0001", "요청 데이터가 없습니다.");
            }

            // 필수 필드 검증 (WP-041 프레임워크 API 호환성 적용)
            String prcssDstcd = requestData.getString("prcssDstcd");
            if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
                throw new BusinessException("B2900001", "UKII0001", "처리구분코드는 필수입니다.");
            }

            String corpClctRegiCd = requestData.getString("corpClctRegiCd");
            if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
                throw new BusinessException("B2900001", "UKII0001", "기업집단등록코드는 필수입니다.");
            }

            String corpClctGroupCd = requestData.getString("corpClctGroupCd");
            if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
                throw new BusinessException("B2900001", "UKII0001", "기업집단그룹코드는 필수입니다.");
            }

            String corpClctName = requestData.getString("corpClctName");
            if (corpClctName == null || corpClctName.trim().isEmpty()) {
                throw new BusinessException("B2900001", "UKII0001", "기업집단명은 필수입니다.");
            }

            String exmtnCustIdnfr = requestData.getString("exmtnCustIdnfr");
            if (exmtnCustIdnfr == null || exmtnCustIdnfr.trim().isEmpty()) {
                throw new BusinessException("B2900001", "UKII0001", "심사고객식별자는 필수입니다.");
            }

            String rpsntBzno = requestData.getString("rpsntBzno");
            if (rpsntBzno == null || rpsntBzno.trim().isEmpty()) {
                throw new BusinessException("B2900001", "UKII0001", "대표사업자등록번호는 필수입니다.");
            }

            String rpsntEntpName = requestData.getString("rpsntEntpName");
            if (rpsntEntpName == null || rpsntEntpName.trim().isEmpty()) {
                throw new BusinessException("B2900001", "UKII0001", "대표업체명은 필수입니다.");
            }

            String corpGmGroupDstcd = requestData.getString("corpGmGroupDstcd");
            if (corpGmGroupDstcd == null || corpGmGroupDstcd.trim().isEmpty()) {
                throw new BusinessException("B2900001", "UKII0001", "기업군관리그룹구분코드는 필수입니다.");
            }

            // 주채무계열그룹여부 검증
            String mainDaGroupYn = requestData.getString("mainDaGroupYn");
            if (mainDaGroupYn != null && !mainDaGroupYn.isEmpty() && 
                !mainDaGroupYn.equals("Y") && !mainDaGroupYn.equals("N")) {
                throw new BusinessException("B2900001", "UKII0001", "주채무계열그룹여부는 Y 또는 N이어야 합니다.");
            }

            // FU 클래스 호출
            IDataSet result = fuRelCoGrpStat.processRelCoGrpStat(requestData, onlineCtx);

            log.debug("관계기업군그룹등록 처리 완료");
            return result;

        } catch (BusinessException e) {
            log.error("관계기업군그룹등록 처리 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("관계기업군그룹등록 시스템 오류: " + e.getMessage());
            throw new BusinessException("B2900999", "UKII0999", "시스템 오류가 발생했습니다.");
        }
    }

    /**
     * 거래코드: KIP04A1040
     * 거래명: 관계기업군그룹현황조회
     * <pre>
     * 메소드 설명 : 관계기업군의 그룹 현황을 조회하는 온라인 거래
     * 비즈니스 기능:
     * - 관계기업군 그룹 현황 조회
     * - 다양한 조회 조건 지원
     * - 그룹별 통계 정보 제공
     * 
     * 입력 파라미터:
     * - field : prcssDstcd [처리구분코드] (string)
     * - field : baseYm [기준년월] (string)
     * - field : baseDstic [기준구분] (string)
     * - field : corpGmGroupDstcd [기업군관리그룹구분코드] (string)
     * - field : exmtnCustIdnfr [심사고객식별자] (string)
     * - field : corpClctName [기업집단명] (string)
     * - field : totalLnbzAmt1 [총여신금액1] (string)
     * - field : totalLnbzAmt2 [총여신금액2] (string)
     * 
     * 출력 파라미터:
     * - field : processStatus [처리상태] (string)
     * - field : processMessage [처리메시지] (string)
     * - recordSet : groupStatusData [그룹현황데이터 LIST]
     * </pre>
     * 
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * @author MultiQ4KBBank
     * @since 2025-10-02
     */
    @BizMethod("관계기업군그룹현황조회")
    public IDataSet pmKIP04A1040(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("관계기업군그룹현황조회 처리 시작");

        try {
            // 입력 데이터 검증
            if (requestData == null) {
                throw new BusinessException("B2900001", "UKII0001", "요청 데이터가 없습니다.");
            }

            // 필수 필드 검증
            String prcssDstcd = requestData.getString("prcssDstcd");
            if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
                throw new BusinessException("B3000070", "UKII0126", "처리구분코드는 필수입니다.");
            }

            String baseYm = requestData.getString("baseYm");
            if (baseYm == null || baseYm.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIP0007", "기준년월은 필수입니다.");
            }

            String baseDstic = requestData.getString("baseDstic");
            if (baseDstic == null || baseDstic.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIP0006", "기준구분은 필수입니다.");
            }

            String corpGmGroupDstcd = requestData.getString("corpGmGroupDstcd");
            if (corpGmGroupDstcd == null || corpGmGroupDstcd.trim().isEmpty()) {
                throw new BusinessException("B3800004", "UKIP0006", "기업군관리그룹구분코드는 필수입니다.");
            }

            // 처리구분별 추가 검증
            switch (prcssDstcd) {
                case "R0": // 고객조회
                    String exmtnCustIdnfr = requestData.getString("exmtnCustIdnfr");
                    if (exmtnCustIdnfr == null || exmtnCustIdnfr.trim().isEmpty()) {
                        throw new BusinessException("B3800004", "UKIP0001", "심사고객식별자는 필수입니다.");
                    }
                    break;
                case "R1": // 그룹명조회
                    String corpClctName = requestData.getString("corpClctName");
                    if (corpClctName == null || corpClctName.trim().isEmpty()) {
                        throw new BusinessException("B3800004", "UKIP0004", "기업집단명은 필수입니다.");
                    }
                    break;
                case "R2": // 여신금액조회
                    String totalLnbzAmt1 = requestData.getString("totalLnbzAmt1");
                    String totalLnbzAmt2 = requestData.getString("totalLnbzAmt2");
                    if (totalLnbzAmt1 == null || totalLnbzAmt2 == null) {
                        throw new BusinessException("B3800004", "UKIP0005", "여신금액 범위는 필수입니다.");
                    }
                    break;
                case "R3": // 그룹팝업조회
                    // 추가 검증 없음
                    break;
                case "R4": // 기업집단신용평가유형조회
                    // 기업군관리그룹구분코드는 이미 검증됨
                    break;
                default:
                    throw new BusinessException("B3000070", "UKII0126", "유효하지 않은 처리구분코드입니다.");
            }

            // FU 클래스 호출
            IDataSet result = fuRelCoGrpStat.processRelCoGrpStat(requestData, onlineCtx);

            log.debug("관계기업군그룹현황조회 처리 완료");
            return result;

        } catch (BusinessException e) {
            log.error("관계기업군그룹현황조회 처리 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("관계기업군그룹현황조회 시스템 오류: " + e.getMessage());
            throw new BusinessException("B2900999", "UKII0999", "시스템 오류가 발생했습니다.");
        }
    }

}
