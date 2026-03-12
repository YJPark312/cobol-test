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
 * 관계회사집단미등록계열등록 기능 유닛.
 * <pre>
 * 유닛 설명 : 관계회사집단의 미등록 계열사 등록 및 관리 기능을 담당하는 기능 유닛
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
@BizUnit(value = "관계회사집단미등록계열등록", type = "FU")
public class FURelCoGrpUnregAffReg extends com.kbstar.sqc.base.FunctionUnit {

	@BizUnitBind private DUTSKIPA110 duTSKIPA110;
	@BizUnitBind private DUTSKIPA113 duTSKIPA113;

	/**
	 * 관계회사집단미등록계열등록처리.
	 * <pre>
	 * 메소드 설명 : 처리구분에 따른 관계회사집단 미등록 계열사 등록 처리
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
	@BizMethod("관계회사집단미등록계열등록처리")
	public IDataSet processUnregAffReg(IDataSet requestData, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);
		log.debug("관계회사집단미등록계열등록처리 시작");
		
		IDataSet responseData = new DataSet();
		
		try {
			// 입력 파라미터 검증
			validateInputParams(requestData);
			
			String prcssDstcd = requestData.getString("prcssDstcd");
			
			// 처리구분에 따른 분기 처리
			switch (prcssDstcd) {
				case "01":
					responseData = processKisDataInquiry(requestData, onlineCtx);
					break;
				case "11":
					responseData = processRelEntpStatusInquiry(requestData, onlineCtx);
					break;
				case "12":
					responseData = processUnregAffUpdate(requestData, onlineCtx);
					break;
				case "13":
					responseData = processUnregAffInsert(requestData, onlineCtx);
					break;
				default:
					throw new BusinessException("B3000070", "UKII0291", "유효하지 않은 처리구분코드입니다.");
			}
			
			log.debug("관계회사집단미등록계열등록처리 완료");
			
		} catch (BusinessException e) {
			log.error("관계회사집단미등록계열등록처리 비즈니스 오류", e);
			throw e;
		} catch (Exception e) {
			log.error("관계회사집단미등록계열등록처리 시스템 오류", e);
			throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
		}
		
		return responseData;
	}

	/**
	 * 입력파라미터검증.
	 * <pre>
	 * 메소드 설명 : 필수 입력 파라미터 검증
	 * </pre>
	 * @param requestData 요청정보 DataSet 객체
	 */
	private void validateInputParams(IDataSet requestData) {
		String prcssDstcd = requestData.getString("prcssDstcd");
		String corpClctGroupCd = requestData.getString("corpClctGroupCd");
		String corpClctRegiCd = requestData.getString("corpClctRegiCd");
		
		if (prcssDstcd == null || prcssDstcd.trim().isEmpty()) {
			throw new BusinessException("B2700109", "UKII0438", "처리구분코드는 필수입니다.");
		}
		
		if (corpClctGroupCd == null || corpClctGroupCd.trim().isEmpty()) {
			throw new BusinessException("B3600552", "UKII0282", "기업집단그룹코드는 필수입니다.");
		}
		
		if (corpClctRegiCd == null || corpClctRegiCd.trim().isEmpty()) {
			throw new BusinessException("B3600552", "UKII0282", "기업집단등록코드는 필수입니다.");
		}
	}

	/**
	 * 한국신용평가데이터조회처리.
	 * <pre>
	 * 메소드 설명 : 한국신용평가 데이터 조회 및 고객식별자 해결
	 * </pre>
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	private IDataSet processKisDataInquiry(IDataSet requestData, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);
		log.debug("한국신용평가데이터조회처리 시작");
		
		IDataSet responseData = new DataSet();
		
		// TODO: 외부 테이블 접근 구현 필요 - THKABCA11, THKABCB01 (한국신용평가 데이터)
		// 원래 코드: IDataSet kisResult = duThkipa171.selectKisGroupData(requestData, onlineCtx);
		// 외부 테이블이므로 개발자가 외부 시스템 연동 또는 내부 테이블 매핑 구현 필요
		IDataSet kisResult = new DataSet();
		kisResult.put("output", null); // TODO: 실제 한국신용평가 데이터 조회 구현 필요
		
		// 고객식별자 해결 및 관계기업 정보 조회
		IRecordSet kisRecords = kisResult.getRecordSet("output");
		// createRecordSet 대신 DataSet 사용
		IDataSet processedDataSet = new DataSet();
		int processedCount = 0;
		
		for (int i = 0; i < kisRecords.getRecordCount(); i++) {
			IRecord kisRecord = kisRecords.getRecord(i);
			
			// 고객식별자로 법인등록번호 해결
			IDataSet custResolveReq = new DataSet();
			custResolveReq.put("altrCustIdnfr", kisRecord.getString("custIdnfr"));
			
			// TODO: 외부 테이블 접근 구현 필요 - THKAAABPCB (KB고객기본)
			// 원래 코드: IDataSet custResolveResult = duThkipa171.resolveCustIdentifier(custResolveReq, onlineCtx);
			// 외부 테이블이므로 개발자가 외부 시스템 연동 또는 내부 테이블 매핑 구현 필요
			IDataSet custResolveResult = new DataSet();
			custResolveResult.put("cprno", "TODO_CPRNO"); // TODO: 실제 법인등록번호 조회 구현 필요
			custResolveResult.put("exmtnCustIdnfr", "TODO_EXMTN_CUST_IDNFR"); // TODO: 실제 고객식별자 해결 구현 필요
			
			// 관계기업 중복 확인
			IDataSet relEntpReq = new DataSet();
			relEntpReq.put("exmtnCustIdnfr", custResolveResult.getString("exmtnCustIdnfr"));
			
			IDataSet relEntpResult = duTSKIPA110.selectCorpGrpBasicInfo(relEntpReq, onlineCtx);
			
			// 처리된 데이터를 응답에 추가 - DataSet.put() 사용
			responseData.put("altrCustIdnfr_" + i, kisRecord.getString("custIdnfr"));
			responseData.put("kisHanglEntpName_" + i, kisRecord.getString("kisHanglEntpName"));
			responseData.put("cprno_" + i, custResolveResult.getString("cprno"));
			responseData.put("exmtnCustIdnfr_" + i, custResolveResult.getString("exmtnCustIdnfr"));
			responseData.put("dstcd_" + i, relEntpResult.getRecordSet("resultSet") != null && 
				relEntpResult.getRecordSet("resultSet").getRecordCount() > 0 ? "Y" : "N");
			responseData.put("chkYn_" + i, "N");
			responseData.put("basezYr_" + i, requestData.getString("stlaccYr"));
			
			processedCount++;
		}
		
		responseData.put("totalNoitm", processedCount);
		responseData.put("prsntNoitm", Math.min(processedCount, 1000));
		responseData.put("processedCount", processedCount);
		responseData.put("output", kisRecords);
		
		log.debug("한국신용평가데이터조회처리 완료 - 처리건수: " + processedCount);
		return responseData;
	}

	/**
	 * 관계기업현황조회처리.
	 * <pre>
	 * 메소드 설명 : 관계기업 현황 조회 처리
	 * </pre>
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	private IDataSet processRelEntpStatusInquiry(IDataSet requestData, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);
		log.debug("관계기업현황조회처리 시작");
		
		// 미등록기업정보 조회
		IDataSet unregResult = duTSKIPA113.select(requestData, onlineCtx);
		
		log.debug("관계기업현황조회처리 완료");
		return unregResult;
	}

	/**
	 * 미등록계열사수정처리.
	 * <pre>
	 * 메소드 설명 : 미등록 계열사 정보 수정 처리
	 * </pre>
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	private IDataSet processUnregAffUpdate(IDataSet requestData, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);
		log.debug("미등록계열사수정처리 시작");
		
		IDataSet responseData = new DataSet();
		
		// 미등록기업정보 수정
		IDataSet updateResult = duTSKIPA113.update(requestData, onlineCtx);
		
		responseData.put("resultCode", "00");
		responseData.put("resultMessage", "수정이 완료되었습니다.");
		responseData.put("processedCount", updateResult.getInt("processedCount"));
		
		log.debug("미등록계열사수정처리 완료");
		return responseData;
	}

	/**
	 * 미등록계열사등록처리.
	 * <pre>
	 * 메소드 설명 : 미등록 계열사 정보 신규 등록 처리
	 * </pre>
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	private IDataSet processUnregAffInsert(IDataSet requestData, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);
		log.debug("미등록계열사등록처리 시작");
		
		IDataSet responseData = new DataSet();
		
		// 미등록기업정보 등록
		IDataSet insertResult = duTSKIPA113.insert(requestData, onlineCtx);
		
		responseData.put("resultCode", "00");
		responseData.put("resultMessage", "등록이 완료되었습니다.");
		responseData.put("processedCount", insertResult.getInt("processedCount"));
		
		log.debug("미등록계열사등록처리 완료");
		return responseData;
	}
}
