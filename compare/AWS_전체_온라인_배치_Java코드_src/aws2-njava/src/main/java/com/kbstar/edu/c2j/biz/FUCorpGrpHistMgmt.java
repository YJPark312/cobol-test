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
 * 기업집단연혁관리 FU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단의 연혁 및 주석 데이터를 저장하고 관리하는 기능 단위
 * 비즈니스 기능:
 * - 다중그리드 데이터 입력 지원을 통한 포괄적 기업집단 연혁관리
 * - 기업집단 연혁사건 및 주석데이터의 실시간 저장 및 관리
 * - 시간순 정렬 및 내용관리를 통한 구조화된 연혁데이터 조직화
 * - 자동 검증 및 트랜잭션 데이터베이스 운영을 통한 데이터 무결성 유지
 * - 최적화된 데이터베이스 접근 및 배치 운영을 통한 확장 가능한 연혁처리
 * - 구조화된 연혁문서화 및 관리부점 추적을 통한 규제 준수 지원
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
@BizUnit(value = "기업집단연혁관리", type = "FU")
public class FUCorpGrpHistMgmt extends com.kbstar.sqc.base.FunctionUnit {

	@BizUnitBind private DUTSKIPB110 duTSKIPB110;
	@BizUnitBind private DUTSKIPB111 duTSKIPB111;
	@BizUnitBind private DUTSKIPB130 duTSKIPB130;

	/**
	 * 기업집단연혁관리 메인 처리.
	 * <pre>
	 * 메소드 설명 : 기업집단의 연혁 및 주석 데이터를 저장하고 관리하는 메인 기능
	 * 비즈니스 규칙:
	 * - BR-038-001: 기업집단파라미터검증규칙
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
	 * 처리 흐름:
	 * 1. 기업집단 파라미터 검증
	 * 2. 기존 연혁 및 주석 데이터 삭제 (BR-038-009)
	 * 3. 연혁 데이터 처리 및 저장 (BR-038-002, BR-038-006)
	 * 4. 주석 데이터 처리 및 저장 (BR-038-003, BR-038-006)
	 * 5. 관리부점 정보 업데이트 (BR-038-005)
	 * 6. 처리 결과 집계 및 반환
	 * </pre>
	 * 
	 * @param requestData 요청 데이터
	 * @param onlineCtx 온라인 컨텍스트
	 * @return 처리 결과 데이터
	 * @author MultiQ4KBBank
	 * @since 2025-10-01
	 */
	@BizMethod("기업집단연혁관리")
	public IDataSet manageCorpGrpHistory(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		ILog log = getLog(onlineCtx);

		try {
			log.debug("기업집단연혁관리 FU 처리 시작");

			// 입력 파라미터 추출
			String corpClctGroupCd = requestData.getString("corpClctGroupCd");
			String corpClctRegiCd = requestData.getString("corpClctRegiCd");
			String valuaYmd = requestData.getString("valuaYmd");
			String mgtBrncd = requestData.getString("mgtBrncd");
			int prsntNoitm1 = requestData.getInt("prsntNoitm1");
			int totalNoitm2 = requestData.getInt("totalNoitm2");

			IRecordSet historyGrid = requestData.getRecordSet("historyGrid");
			IRecordSet commentaryGrid = requestData.getRecordSet("commentaryGrid");

			// BR-038-009: 데이터베이스정리규칙 - 기존 데이터 삭제
			_deleteExistingData(corpClctGroupCd, corpClctRegiCd, valuaYmd, onlineCtx);

			// BR-038-002: 연혁항목처리규칙 - 연혁 데이터 처리
			int processedHistoryCount = _processHistoryData(corpClctGroupCd, corpClctRegiCd, valuaYmd, 
															prsntNoitm1, historyGrid, onlineCtx);

			// BR-038-003: 주석구분규칙 - 주석 데이터 처리
			int processedCommentaryCount = _processCommentaryData(corpClctGroupCd, corpClctRegiCd, valuaYmd, 
																  totalNoitm2, commentaryGrid, onlineCtx);

			// BR-038-005: 관리부점업데이트규칙 - 관리부점 정보 업데이트
			_updateManagementBranch(corpClctGroupCd, corpClctRegiCd, valuaYmd, mgtBrncd, onlineCtx);

			// 처리 결과 집계
			int totalProcessed = processedHistoryCount + processedCommentaryCount;

			// 응답 데이터 구성
			responseData.put("totalNoitm", totalProcessed);
			responseData.put("prsntNoitm", processedHistoryCount);
			responseData.put("returnCd", "00");
			responseData.put("returnMsg", "기업집단연혁관리가 성공적으로 완료되었습니다.");

			log.debug("기업집단연혁관리 FU 처리 완료 - 연혁: " + processedHistoryCount + 
					  "건, 주석: " + processedCommentaryCount + "건");

		} catch (BusinessException e) {
			log.error("기업집단연혁관리 FU 비즈니스 오류", e);
			throw e;
		} catch (Exception e) {
			log.error("기업집단연혁관리 FU 시스템 오류", e);
			throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
		}

		return responseData;
	}

	/**
	 * 기존 데이터 삭제 처리.
	 * <pre>
	 * BR-038-009: 데이터베이스정리규칙
	 * - 중복을 방지하기 위해 새 데이터를 삽입하기 전에 기존 레코드를 제거
	 * </pre>
	 */
	private void _deleteExistingData(String corpClctGroupCd, String corpClctRegiCd, String valuaYmd, 
									 IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);
		log.debug("기존 데이터 삭제 시작");

		try {
			// 기존 연혁 데이터 삭제
			IDataSet deleteHistReq = new DataSet();
			deleteHistReq.put("corpClctGroupCd", corpClctGroupCd);
			deleteHistReq.put("corpClctRegiCd", corpClctRegiCd);
			deleteHistReq.put("valuaYmd", valuaYmd);

			// 기존 DU 클래스의 delete 메소드 활용 (WP-037 패턴 적용)
			duTSKIPB111.delete(deleteHistReq, onlineCtx);

			// 기존 주석 데이터 삭제
			IDataSet deleteComtReq = new DataSet();
			deleteComtReq.put("corpClctGroupCd", corpClctGroupCd);
			deleteComtReq.put("corpClctRegiCd", corpClctRegiCd);
			deleteComtReq.put("valuaYmd", valuaYmd);

			duTSKIPB130.delete(deleteComtReq, onlineCtx);

			log.debug("기존 데이터 삭제 완료");

		} catch (Exception e) {
			log.error("기존 데이터 삭제 오류", e);
			throw new BusinessException("B3800010", "UKII0182", "기존 데이터 삭제 중 오류가 발생했습니다.", e);
		}
	}

	/**
	 * 연혁 데이터 처리.
	 * <pre>
	 * BR-038-002: 연혁항목처리규칙
	 * BR-038-006: 일련번호할당규칙
	 * - 장표출력플래그가 '1'인 항목만 데이터베이스에 저장
	 * - 일련번호가 1부터 시작하여 순차적으로 할당
	 * </pre>
	 */
	private int _processHistoryData(String corpClctGroupCd, String corpClctRegiCd, String valuaYmd,
									int prsntNoitm1, IRecordSet historyGrid, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);
		log.debug("연혁 데이터 처리 시작 - 처리대상: " + prsntNoitm1 + "건");

		int processedCount = 0;
		int serialNo = 1;

		try {
			if (historyGrid != null && historyGrid.getRecordCount() > 0) {
				// BR-038-008: 그리드처리규칙 - 현재 항목 수로 처리 제한
				int processLimit = Math.min(prsntNoitm1, historyGrid.getRecordCount());

				for (int i = 0; i < processLimit; i++) {
					IRecord histRecord = historyGrid.getRecord(i);
					String shetOutptYn = histRecord.getString("shetOutptYn");

					// BR-038-002: 연혁항목처리규칙 - 장표출력플래그 '1'인 항목만 처리
					if ("1".equals(shetOutptYn)) {
						IDataSet insertReq = new DataSet();
						insertReq.put("groupCoCd", "001"); // 기본값
						insertReq.put("corpClctGroupCd", corpClctGroupCd);
						insertReq.put("corpClctRegiCd", corpClctRegiCd);
						insertReq.put("valuaYmd", valuaYmd);
						insertReq.put("serno", serialNo); // BR-038-006: 일련번호할당
						insertReq.put("shetOutptYn", shetOutptYn);
						insertReq.put("ordvlYmd", histRecord.getString("ordvlYmd"));
						insertReq.put("ordvlCtnt", histRecord.getString("ordvlCtnt"));

						// 기존 DU 클래스의 insert 메소드 재사용
						duTSKIPB111.insert(insertReq, onlineCtx);
						
						processedCount++;
						serialNo++;
					}
				}
			}

			log.debug("연혁 데이터 처리 완료 - 처리건수: " + processedCount);

		} catch (Exception e) {
			log.error("연혁 데이터 처리 오류", e);
			throw new BusinessException("B3800011", "UKII0182", "연혁 데이터 처리 중 오류가 발생했습니다.", e);
		}

		return processedCount;
	}

	/**
	 * 주석 데이터 처리.
	 * <pre>
	 * BR-038-003: 주석구분규칙
	 * BR-038-006: 일련번호할당규칙
	 * - 개요 주석 유형에 대해 분류코드 '01' 사용
	 * - 일련번호가 1부터 시작하여 순차적으로 할당
	 * </pre>
	 */
	private int _processCommentaryData(String corpClctGroupCd, String corpClctRegiCd, String valuaYmd,
									   int totalNoitm2, IRecordSet commentaryGrid, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);
		log.debug("주석 데이터 처리 시작 - 처리대상: " + totalNoitm2 + "건");

		int processedCount = 0;
		int serialNo = 1;

		try {
			if (commentaryGrid != null && commentaryGrid.getRecordCount() > 0) {
				// BR-038-008: 그리드처리규칙 - 총 항목 수로 처리 제한
				int processLimit = Math.min(totalNoitm2, commentaryGrid.getRecordCount());

				for (int i = 0; i < processLimit; i++) {
					IRecord comtRecord = commentaryGrid.getRecord(i);

					IDataSet insertReq = new DataSet();
					insertReq.put("groupCoCd", "001"); // 기본값
					insertReq.put("corpClctGroupCd", corpClctGroupCd);
					insertReq.put("corpClctRegiCd", corpClctRegiCd);
					insertReq.put("valuaYmd", valuaYmd);
					insertReq.put("corpCComtDstcd", "01"); // BR-038-003: 주석구분규칙 - 개요 주석
					insertReq.put("serno", serialNo); // BR-038-006: 일련번호할당
					insertReq.put("comtCtnt", comtRecord.getString("comtCtnt"));

					// 기존 DU 클래스의 insert 메소드 재사용
					duTSKIPB130.insert(insertReq, onlineCtx);
					
					processedCount++;
					serialNo++;
				}
			}

			log.debug("주석 데이터 처리 완료 - 처리건수: " + processedCount);

		} catch (Exception e) {
			log.error("주석 데이터 처리 오류", e);
			throw new BusinessException("B3800012", "UKII0182", "주석 데이터 처리 중 오류가 발생했습니다.", e);
		}

		return processedCount;
	}

	/**
	 * 관리부점 정보 업데이트.
	 * <pre>
	 * BR-038-005: 관리부점업데이트규칙
	 * - 기업집단 기본 레코드의 관리부점 정보를 업데이트
	 * </pre>
	 */
	private void _updateManagementBranch(String corpClctGroupCd, String corpClctRegiCd, String valuaYmd,
										 String mgtBrncd, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);
		log.debug("관리부점 정보 업데이트 시작");

		try {
			IDataSet updateReq = new DataSet();
			updateReq.put("groupCoCd", "001"); // 기본값
			updateReq.put("corpClctGroupCd", corpClctGroupCd);
			updateReq.put("corpClctRegiCd", corpClctRegiCd);
			updateReq.put("valuaYmd", valuaYmd);
			updateReq.put("mgtBrncd", mgtBrncd);

			// 기존 DU 클래스의 update 메소드 재사용
			duTSKIPB110.update(updateReq, onlineCtx);

			log.debug("관리부점 정보 업데이트 완료 - 관리부점코드: " + mgtBrncd);

		} catch (Exception e) {
			log.error("관리부점 정보 업데이트 오류", e);
			throw new BusinessException("B3800013", "UKII0182", "관리부점 정보 업데이트 중 오류가 발생했습니다.", e);
		}
	}
}
