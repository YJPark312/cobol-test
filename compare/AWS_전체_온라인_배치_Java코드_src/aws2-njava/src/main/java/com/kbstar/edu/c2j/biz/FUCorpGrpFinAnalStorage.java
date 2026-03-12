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
 * 기업집단재무분석저장 FU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단 재무분석 데이터 저장을 담당하는 기능 단위
 * 비즈니스 기능:
 * - 안정성 분석 저장 (재무항목코드: 3020, 3060, 3090, 2322)
 * - 수익성 분석 저장 (재무항목코드: 2120, 2251, 2286)
 * - 성장성 분석 저장 (재무항목코드: 1010, 1060, 4010, 4120)
 * - 평가의견 관리 (삭제 후 삽입)
 * - 처리단계 업데이트
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
@BizUnit(value = "기업집단재무분석저장", type = "FU")
public class FUCorpGrpFinAnalStorage extends com.kbstar.sqc.base.FunctionUnit {

	@BizUnitBind private DUTSKIPB110 duTSKIPB110;
	@BizUnitBind private DUTSKIPB112 duTSKIPB112;
	@BizUnitBind private DUTSKIPB130 duTSKIPB130;

	/**
	 * 기업집단재무분석저장.
	 * <pre>
	 * 메소드 설명 : 기업집단 재무분석 데이터를 저장하는 메인 기능
	 * 처리 순서:
	 * 1. 재무분석항목 처리 (안정성, 수익성, 성장성)
	 * 2. 평가의견 처리 (삭제 후 삽입)
	 * 3. 처리단계 업데이트
	 * 4. 결과 집계
	 * ---------------------------------------------------------------------------------
	 *  버전	일자			작성자			설명
	 * ---------------------------------------------------------------------------------
	 *   1.0	20251002	MultiQ4KBBank		최초 작성
	 * ---------------------------------------------------------------------------------
	 * </pre>
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	@BizMethod("기업집단재무분석저장")
	public IDataSet storeCorpGrpFinAnalysis(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		ILog log = getLog(onlineCtx);

		try {
			log.debug("기업집단재무분석저장 FU 시작");

			// 입력 파라미터 추출
			String corpClctGroupCd = requestData.getString("corpClctGroupCd");
			String corpClctRegiCd = requestData.getString("corpClctRegiCd");
			String valuaYmd = requestData.getString("valuaYmd");
			int totalNoitm1 = requestData.getInt("totalNoitm1");
			int prsntNoitm1 = requestData.getInt("prsntNoitm1");
			int totalNoitm2 = requestData.getInt("totalNoitm2");
			int prsntNoitm2 = requestData.getInt("prsntNoitm2");

			log.debug("처리 파라미터 - 재무분석항목: " + prsntNoitm1 + "/" + totalNoitm1);
			log.debug("처리 파라미터 - 평가의견항목: " + prsntNoitm2 + "/" + totalNoitm2);

			// BR-041-005: 재무분석항목처리
			if (totalNoitm1 > 0) {
				processFinancialAnalysisItems(requestData, onlineCtx);
				log.debug("재무분석항목 처리 완료");
			}

			// BR-041-006: 평가의견처리
			if (totalNoitm2 > 0) {
				processEvaluationOpinions(requestData, onlineCtx);
				log.debug("평가의견 처리 완료");
			}

			// BR-041-011: 처리단계업데이트
			updateProcessingStage(requestData, onlineCtx);
			log.debug("처리단계 업데이트 완료");

			// F-041-007: 결과집계및출력
			responseData.put("totalNoitm1", totalNoitm1);
			responseData.put("prsntNoitm1", prsntNoitm1);
			responseData.put("totalNoitm2", totalNoitm2);
			responseData.put("prsntNoitm2", prsntNoitm2);

			log.debug("기업집단재무분석저장 FU 완료");

		} catch (BusinessException e) {
			log.error("기업집단재무분석저장 FU 비즈니스 오류", e);
			throw e;
		} catch (Exception e) {
			log.error("기업집단재무분석저장 FU 시스템 오류", e);
			throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
		}

		return responseData;
	}

	/**
	 * 재무분석항목 처리.
	 * <pre>
	 * 메소드 설명 : 안정성, 수익성, 성장성 분석 데이터를 처리
	 * 처리 순서:
	 * 1. 안정성 분석 저장 (분류코드: 03)
	 * 2. 수익성 분석 저장 (분류코드: 02)
	 * 3. 성장성 분석 저장 (분류코드: 07)
	 * </pre>
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	private void processFinancialAnalysisItems(IDataSet requestData, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);

		try {
			IRecordSet finAnalGrid = requestData.getRecordSet("finAnalGrid");
			if (finAnalGrid == null || finAnalGrid.getRecordCount() == 0) {
				log.debug("재무분석 그리드 데이터 없음");
				return;
			}

			String corpClctGroupCd = requestData.getString("corpClctGroupCd");
			String corpClctRegiCd = requestData.getString("corpClctRegiCd");
			String valuaYmd = requestData.getString("valuaYmd");

			// 각 재무분석 항목 처리
			for (int i = 0; i < finAnalGrid.getRecordCount(); i++) {
				IRecord record = finAnalGrid.getRecord(i);
				String fnafItemCd = record.getString("fnafItemCd");

				// 분석지표분류구분 결정
				String anlsIClsfiDstcd = determineAnalysisClassification(fnafItemCd);
				if (anlsIClsfiDstcd != null) {
					// 기존 레코드 삭제 후 신규 삽입
					deleteExistingFinancialRecord(corpClctGroupCd, corpClctRegiCd, valuaYmd, 
						anlsIClsfiDstcd, fnafItemCd, onlineCtx);
					insertFinancialRecord(record, corpClctGroupCd, corpClctRegiCd, valuaYmd, 
						anlsIClsfiDstcd, onlineCtx);
				}
			}

			log.debug("재무분석항목 처리 완료 - 처리건수: " + finAnalGrid.getRecordCount());

		} catch (Exception e) {
			log.error("재무분석항목 처리 오류", e);
			throw new BusinessException("B4100001", "UKIP0010", "재무분석항목 처리 중 오류가 발생했습니다.", e);
		}
	}

	/**
	 * 분석지표분류구분 결정.
	 * <pre>
	 * 메소드 설명 : 재무항목코드에 따라 분석지표분류구분을 결정
	 * BR-041-007: 안정성분석분류 (3020, 3060, 3090, 2322 → 03)
	 * BR-041-008: 수익성분석분류 (2120, 2251, 2286 → 02)
	 * BR-041-009: 성장성분석분류 (1010, 1060, 4010, 4120 → 07)
	 * </pre>
	 * @param fnafItemCd 재무항목코드
	 * @return 분석지표분류구분
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	private String determineAnalysisClassification(String fnafItemCd) {
		if (fnafItemCd == null) return null;

		// BR-041-007: 안정성분석분류
		if ("3020".equals(fnafItemCd) || "3060".equals(fnafItemCd) || 
			"3090".equals(fnafItemCd) || "2322".equals(fnafItemCd)) {
			return "03";
		}
		// BR-041-008: 수익성분석분류
		else if ("2120".equals(fnafItemCd) || "2251".equals(fnafItemCd) || "2286".equals(fnafItemCd)) {
			return "02";
		}
		// BR-041-009: 성장성분석분류
		else if ("1010".equals(fnafItemCd) || "1060".equals(fnafItemCd) || 
				 "4010".equals(fnafItemCd) || "4120".equals(fnafItemCd)) {
			return "07";
		}

		return null;
	}

	/**
	 * 기존 재무분석 레코드 삭제.
	 * @param corpClctGroupCd 기업집단그룹코드
	 * @param corpClctRegiCd 기업집단등록코드
	 * @param valuaYmd 평가년월일
	 * @param anlsIClsfiDstcd 분석지표분류구분
	 * @param fnafItemCd 재무항목코드
	 * @param onlineCtx 온라인 컨텍스트
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	private void deleteExistingFinancialRecord(String corpClctGroupCd, String corpClctRegiCd, 
		String valuaYmd, String anlsIClsfiDstcd, String fnafItemCd, IOnlineContext onlineCtx) {
		
		IDataSet deleteData = new DataSet();
		deleteData.put("groupCoCd", "001"); // 기본 그룹회사코드
		deleteData.put("corpClctGroupCd", corpClctGroupCd);
		deleteData.put("corpClctRegiCd", corpClctRegiCd);
		deleteData.put("valuaYmd", valuaYmd);
		deleteData.put("anlsIClsfiDstcd", anlsIClsfiDstcd);
		deleteData.put("fnafItemCd", fnafItemCd);

		duTSKIPB112.delete(deleteData, onlineCtx);
	}

	/**
	 * 재무분석 레코드 삽입.
	 * @param record 재무분석 레코드
	 * @param corpClctGroupCd 기업집단그룹코드
	 * @param corpClctRegiCd 기업집단등록코드
	 * @param valuaYmd 평가년월일
	 * @param anlsIClsfiDstcd 분석지표분류구분
	 * @param onlineCtx 온라인 컨텍스트
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	private void insertFinancialRecord(IRecord record, String corpClctGroupCd, String corpClctRegiCd, 
		String valuaYmd, String anlsIClsfiDstcd, IOnlineContext onlineCtx) {
		
		IDataSet insertData = new DataSet();
		insertData.put("groupCoCd", "001"); // 기본 그룹회사코드
		insertData.put("corpClctGroupCd", corpClctGroupCd);
		insertData.put("corpClctRegiCd", corpClctRegiCd);
		insertData.put("valuaYmd", valuaYmd);
		insertData.put("anlsIClsfiDstcd", anlsIClsfiDstcd);
		insertData.put("fnafItemCd", record.getString("fnafItemCd"));
		insertData.put("baseYrFnafRato", Double.parseDouble(record.getString("baseYrFnafRato")));
		insertData.put("n1YrBfFnafRato", Double.parseDouble(record.getString("nYrBfFnafRato")));
		insertData.put("n2YrBfFnafRato", Double.parseDouble(record.getString("n2YrBfFnafRato")));

		duTSKIPB112.insert(insertData, onlineCtx);
	}

	/**
	 * 평가의견 처리.
	 * <pre>
	 * 메소드 설명 : 평가의견 데이터를 삭제 후 삽입으로 처리
	 * 처리 순서:
	 * 1. 기존 평가의견 삭제
	 * 2. 새로운 평가의견 삽입
	 * </pre>
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	private void processEvaluationOpinions(IDataSet requestData, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);

		try {
			String corpClctGroupCd = requestData.getString("corpClctGroupCd");
			String corpClctRegiCd = requestData.getString("corpClctRegiCd");
			String valuaYmd = requestData.getString("valuaYmd");

			// 기존 평가의견 삭제
			IDataSet deleteData = new DataSet();
			deleteData.put("corpClctGroupCd", corpClctGroupCd);
			deleteData.put("corpClctRegiCd", corpClctRegiCd);
			deleteData.put("valuaYmd", valuaYmd);
			duTSKIPB130.delete(deleteData, onlineCtx);

			// 새로운 평가의견 삽입
			IRecordSet evalOpnGrid = requestData.getRecordSet("evalOpnGrid");
			if (evalOpnGrid != null && evalOpnGrid.getRecordCount() > 0) {
				for (int i = 0; i < evalOpnGrid.getRecordCount(); i++) {
					IRecord record = evalOpnGrid.getRecord(i);
					
					IDataSet insertData = new DataSet();
					insertData.put("groupCoCd", "001"); // 기본 그룹회사코드
					insertData.put("corpClctGroupCd", corpClctGroupCd);
					insertData.put("corpClctRegiCd", corpClctRegiCd);
					insertData.put("valuaYmd", valuaYmd);
					insertData.put("corpCComtDstcd", record.getString("corpCComtDstcd"));
					insertData.put("serno", i + 1);
					insertData.put("comtCtnt", record.getString("comtCtnt"));

					duTSKIPB130.insert(insertData, onlineCtx);
				}
			}

			log.debug("평가의견 처리 완료 - 처리건수: " + 
				(evalOpnGrid != null ? evalOpnGrid.getRecordCount() : 0));

		} catch (Exception e) {
			log.error("평가의견 처리 오류", e);
			throw new BusinessException("B4100002", "UKIP0011", "평가의견 처리 중 오류가 발생했습니다.", e);
		}
	}

	/**
	 * 처리단계 업데이트.
	 * <pre>
	 * 메소드 설명 : 기업집단평가기본 테이블의 처리단계를 업데이트
	 * BR-041-011: 처리단계업데이트
	 * </pre>
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	private void updateProcessingStage(IDataSet requestData, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);

		try {
			IDataSet updateData = new DataSet();
			updateData.put("groupCoCd", "001"); // 기본 그룹회사코드
			updateData.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
			updateData.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
			updateData.put("valuaYmd", requestData.getString("valuaYmd"));

			duTSKIPB110.update(updateData, onlineCtx);
			log.debug("처리단계 업데이트 완료");

		} catch (Exception e) {
			log.error("처리단계 업데이트 오류", e);
			throw new BusinessException("B4100003", "UKIP0012", "처리단계 업데이트 중 오류가 발생했습니다.", e);
		}
	}
}
