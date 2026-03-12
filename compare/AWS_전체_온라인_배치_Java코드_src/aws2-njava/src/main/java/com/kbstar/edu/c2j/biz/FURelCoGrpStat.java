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
 * 관계회사집단현황 기능 유닛.
 * <pre>
 * 유닛 설명 : 관계회사집단현황 조회 및 관리 기능을 담당하는 기능 유닛
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
@BizUnit(value = "관계회사집단현황", type = "FU")
public class FURelCoGrpStat extends com.kbstar.sqc.base.FunctionUnit {

	@BizUnitBind private DUTSKIPA110 duTSKIPA110;
	@BizUnitBind private DUTSKIPA120 duTSKIPA120;

	/**
	 * 관계회사집단현황조회.
	 * <pre>
	 * 메소드 설명 : 처리구분에 따른 관계회사집단현황 조회 처리
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
	@BizMethod("관계회사집단현황조회")
	public IDataSet processRelCoGrpStat(IDataSet requestData, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);
		log.debug("관계회사집단현황조회 처리 시작");

		try {
			// 입력 파라미터 검증
			validateInputParameters(requestData);

			// 처리구분에 따른 분기 처리
			String prcssDstcd = requestData.getString("prcssDstcd");
			String baseDstic = requestData.getString("baseDstic");

			IDataSet result = new DataSet();

			switch (prcssDstcd) {
				case "R0": // 고객조회
					result = processCustomerInquiry(requestData, onlineCtx, baseDstic);
					break;
				case "R1": // 그룹명조회
					result = processGroupNameInquiry(requestData, onlineCtx, baseDstic);
					break;
				case "R2": // 여신금액조회
					result = processCreditAmountInquiry(requestData, onlineCtx, baseDstic);
					break;
				case "R3": // 그룹팝업조회
					result = processGroupPopupInquiry(requestData, onlineCtx);
					break;
				case "R4": // 기업집단신용평가유형조회
					result = processCreditEvaluationInquiry(requestData, onlineCtx, baseDstic);
					break;
				default:
					throw new BusinessException("B3000070", "UKII0126", "유효하지 않은 처리구분코드입니다.");
			}

			log.debug("관계회사집단현황조회 처리 완료");
			return result;

		} catch (BusinessException e) {
			log.error("관계회사집단현황조회 비즈니스 오류", e);
			throw e;
		} catch (Exception e) {
			log.error("관계회사집단현황조회 시스템 오류", e);
			throw new BusinessException("B3900009", "UKII0126", "시스템 처리 오류가 발생했습니다.", e);
		}
	}

	/**
	 * 입력 파라미터 검증.
	 */
	private void validateInputParameters(IDataSet requestData) {
		String prcssDstcd = requestData.getString("prcssDstcd");
		if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
			throw new BusinessException("B3000070", "UKII0126", "처리구분코드는 필수입니다.");
		}

		String baseYm = requestData.getString("baseYm");
		if (baseYm == null || baseYm.trim().isEmpty()) {
			throw new BusinessException("B3800004", "UKIP0007", "기준년월은 필수입니다.");
		}

		// 기준년월 형식 검증 (YYYYMM)
		if (!baseYm.matches("\\d{6}")) {
			throw new BusinessException("B3400001", "UKIP0012", "기준년월은 YYYYMM 형식이어야 합니다.");
		}
	}

	/**
	 * 고객조회 처리 (R0).
	 */
	private IDataSet processCustomerInquiry(IDataSet requestData, IOnlineContext onlineCtx, String baseDstic) {
		String exmtnCustIdnfr = requestData.getString("exmtnCustIdnfr");
		if (exmtnCustIdnfr == null || exmtnCustIdnfr.trim().isEmpty()) {
			throw new BusinessException("B3800004", "UKIP0001", "심사고객식별자는 필수입니다.");
		}

		if ("1".equals(baseDstic)) {
			// 현재월 데이터 조회 (TSKIPA110)
			return duTSKIPA110.selectCorpGrpBasicInfo(requestData, onlineCtx);
		} else {
			// 이력 데이터 조회 (TSKIPA120)
			return duTSKIPA120.selectMonthlyCompanyInfo(requestData, onlineCtx);
		}
	}

	/**
	 * 그룹명조회 처리 (R1).
	 */
	private IDataSet processGroupNameInquiry(IDataSet requestData, IOnlineContext onlineCtx, String baseDstic) {
		String corpClctName = requestData.getString("corpClctName");
		if (corpClctName == null || corpClctName.trim().isEmpty()) {
			throw new BusinessException("B3800004", "UKIP0004", "기업집단명은 필수입니다.");
		}

		// 와일드카드 패턴 처리
		String searchPattern = corpClctName.trim();
		if (!searchPattern.endsWith("%")) {
			searchPattern = searchPattern + "%";
		}
		requestData.put("corpClctName", searchPattern);

		if ("1".equals(baseDstic)) {
			// 현재월 데이터 조회
			return duTSKIPA110.selectCorpGrpBasicInfo(requestData, onlineCtx);
		} else {
			// 이력 데이터 조회
			return duTSKIPA120.selectHistoricalCompanyList(requestData, onlineCtx);
		}
	}

	/**
	 * 여신금액조회 처리 (R2).
	 */
	private IDataSet processCreditAmountInquiry(IDataSet requestData, IOnlineContext onlineCtx, String baseDstic) {
		String totalLnbzAmt1Str = requestData.getString("totalLnbzAmt1");
		String totalLnbzAmt2Str = requestData.getString("totalLnbzAmt2");

		if (totalLnbzAmt1Str == null || totalLnbzAmt2Str == null) {
			throw new BusinessException("B3800004", "UKIP0005", "여신금액 범위는 필수입니다.");
		}

		try {
			long totalLnbzAmt1 = Long.parseLong(totalLnbzAmt1Str);
			long totalLnbzAmt2 = Long.parseLong(totalLnbzAmt2Str);

			if (totalLnbzAmt1 > totalLnbzAmt2) {
				throw new BusinessException("B3400002", "UKIP0013", "여신금액1은 여신금액2보다 작거나 같아야 합니다.");
			}

			// 금액 변환 (×100,000,000)
			requestData.put("totalLnbzAmt1", totalLnbzAmt1 * 100000000L);
			requestData.put("totalLnbzAmt2", totalLnbzAmt2 * 100000000L);

		} catch (NumberFormatException e) {
			throw new BusinessException("B3400002", "UKIP0013", "여신금액은 유효한 숫자여야 합니다.");
		}

		if ("1".equals(baseDstic)) {
			// 현재월 데이터 조회
			return duTSKIPA110.selectCorpGrpBasicInfo(requestData, onlineCtx);
		} else {
			// 이력 데이터 조회
			return duTSKIPA120.selectHistoricalCompanyList(requestData, onlineCtx);
		}
	}

	/**
	 * 그룹팝업조회 처리 (R3).
	 */
	private IDataSet processGroupPopupInquiry(IDataSet requestData, IOnlineContext onlineCtx) {
		// 그룹 팝업 조회는 현재월 데이터만 사용
		return duTSKIPA110.selectCorpGrpBasicInfo(requestData, onlineCtx);
	}

	/**
	 * 기업집단신용평가유형조회 처리 (R4).
	 */
	private IDataSet processCreditEvaluationInquiry(IDataSet requestData, IOnlineContext onlineCtx, String baseDstic) {
		String corpGmGroupDstcd = requestData.getString("corpGmGroupDstcd");
		if (corpGmGroupDstcd == null || corpGmGroupDstcd.trim().isEmpty()) {
			throw new BusinessException("B3800004", "UKIP0006", "기업군관리그룹구분코드는 필수입니다.");
		}

		if ("1".equals(baseDstic)) {
			// 현재월 데이터 조회
			return duTSKIPA110.selectCorpGrpBasicInfo(requestData, onlineCtx);
		} else {
			// 이력 데이터 조회
			return duTSKIPA120.selectHistoricalCompanyList(requestData, onlineCtx);
		}
	}
}
