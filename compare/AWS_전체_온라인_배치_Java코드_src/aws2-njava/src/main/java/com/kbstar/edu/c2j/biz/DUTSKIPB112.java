package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 기업집단재무분석목록 DU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단재무분석목록(TSKIPB112) 테이블에 대한 데이터 접근 단위
 * 테이블 정보:
 * - 테이블명: TSKIPB112 (기업집단재무분석목록)
 * - 설명: 기업집단평가시스템의 기업집단별 기업집단재무분석에 대한 목록
 * - 스키마: DB2DBA
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
@BizUnit(value = "기업집단재무분석목록", type = "DU")
public class DUTSKIPB112 extends com.kbstar.sqc.base.DataUnit {

	public DUTSKIPB112() {
		super();
	}

	/**
	 * 기업집단재무분석목록 단건 조회.
	 * <pre>
	 * 메소드 설명 : 기업집단 식별정보로 재무분석목록을 조회
	 * 조회 조건:
	 * - 그룹회사코드
	 * - 기업집단그룹코드
	 * - 기업집단등록코드
	 * - 평가년월일
	 * - 분석지표분류구분
	 * - 재무항목코드
	 * </pre>
	 * 
	 * @param requestData 요청 데이터
	 * @param onlineCtx 온라인 컨텍스트
	 * @return 조회 결과 데이터
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	@BizMethod("기업집단재무분석목록 조회")
	public IDataSet select(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		ILog log = getLog(onlineCtx);

		try {
			log.debug("기업집단재무분석목록 조회 시작");

			// 단건 조회
			IRecord record = dbSelectSingle("select", requestData, onlineCtx);
			if (record != null) {
				responseData.putAll(record);
				
				// 리스트 형태로도 제공
				IRecordSet recordSet = new nexcore.framework.core.data.RecordSet();
				recordSet.addRecord(record);
				responseData.put("LIST", recordSet);
				
				log.debug("기업집단재무분석목록 조회 성공 - 재무항목코드: " + record.getString("fnafItemCd"));
			} else {
				// 빈 리스트 설정
				IRecordSet emptyRecordSet = new nexcore.framework.core.data.RecordSet();
				responseData.put("LIST", emptyRecordSet);
				
				log.debug("기업집단재무분석목록 조회 결과 없음");
			}

		} catch (Exception e) {
			log.error("기업집단재무분석목록 조회 오류", e);
			throw new BusinessException("B3900009", "UKII0182", "데이터 조회 중 오류가 발생했습니다.", e);
		}

		return responseData;
	}

	/**
	 * 기업집단재무분석목록 목록 조회.
	 * <pre>
	 * 메소드 설명 : 기업집단 조건으로 재무분석목록을 조회
	 * 조회 조건:
	 * - 기업집단그룹코드 (선택)
	 * - 기업집단등록코드 (선택)
	 * - 평가년월일 범위 (선택)
	 * - 분석지표분류구분 (선택)
	 * </pre>
	 * 
	 * @param requestData 요청 데이터
	 * @param onlineCtx 온라인 컨텍스트
	 * @return 조회 결과 데이터
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	@BizMethod("기업집단재무분석목록 목록조회")
	public IDataSet selectList(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		ILog log = getLog(onlineCtx);

		try {
			log.debug("기업집단재무분석목록 목록조회 시작");

			// 목록 조회
			IRecordSet recordSet = dbSelect("selectList", requestData, onlineCtx);
			
			int totalCount = recordSet.getRecordCount();
			int presentCount = Math.min(totalCount, 1000);
			
			responseData.put("totalNoitm", totalCount);
			responseData.put("prsntNoitm", presentCount);
			responseData.put("LIST", recordSet);
			
			log.debug("기업집단재무분석목록 목록조회 완료 - 조회건수: " + totalCount);

		} catch (Exception e) {
			log.error("기업집단재무분석목록 목록조회 오류", e);
			throw new BusinessException("B3900009", "UKII0182", "데이터 조회 중 오류가 발생했습니다.", e);
		}

		return responseData;
	}

	/**
	 * 기업집단재무분석목록 등록.
	 * <pre>
	 * 메소드 설명 : 기업집단재무분석목록 데이터를 등록
	 * 등록 데이터:
	 * - 그룹회사코드
	 * - 기업집단그룹코드
	 * - 기업집단등록코드
	 * - 평가년월일
	 * - 분석지표분류구분
	 * - 재무항목코드
	 * - 기준년재무비율
	 * - N1년전재무비율
	 * - N2년전재무비율
	 * </pre>
	 * 
	 * @param requestData 요청 데이터
	 * @param onlineCtx 온라인 컨텍스트
	 * @return 처리 결과 데이터
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	@BizMethod("기업집단재무분석목록 등록")
	public IDataSet insert(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		ILog log = getLog(onlineCtx);

		try {
			log.debug("기업집단재무분석목록 등록 시작");

			// 등록 실행
			int result = dbInsert("insert", requestData, onlineCtx);
			
			responseData.put("processedCount", result);
			responseData.put("returnCd", "00");
			responseData.put("returnMsg", "기업집단재무분석목록 등록이 완료되었습니다.");
			
			log.debug("기업집단재무분석목록 등록 완료 - 처리건수: " + result);

		} catch (Exception e) {
			log.error("기업집단재무분석목록 등록 오류", e);
			throw new BusinessException("B3900010", "UKII0182", "데이터 등록 중 오류가 발생했습니다.", e);
		}

		return responseData;
	}

	/**
	 * 기업집단재무분석목록 수정.
	 * <pre>
	 * 메소드 설명 : 기업집단재무분석목록 데이터를 수정
	 * 수정 조건:
	 * - 그룹회사코드
	 * - 기업집단그룹코드
	 * - 기업집단등록코드
	 * - 평가년월일
	 * - 분석지표분류구분
	 * - 재무항목코드
	 * </pre>
	 * 
	 * @param requestData 요청 데이터
	 * @param onlineCtx 온라인 컨텍스트
	 * @return 처리 결과 데이터
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	@BizMethod("기업집단재무분석목록 수정")
	public IDataSet update(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		ILog log = getLog(onlineCtx);

		try {
			log.debug("기업집단재무분석목록 수정 시작");

			// 수정 실행
			int result = dbUpdate("update", requestData, onlineCtx);
			
			responseData.put("processedCount", result);
			responseData.put("returnCd", "00");
			responseData.put("returnMsg", "기업집단재무분석목록 수정이 완료되었습니다.");
			
			log.debug("기업집단재무분석목록 수정 완료 - 처리건수: " + result);

		} catch (Exception e) {
			log.error("기업집단재무분석목록 수정 오류", e);
			throw new BusinessException("B3900011", "UKII0182", "데이터 수정 중 오류가 발생했습니다.", e);
		}

		return responseData;
	}

	/**
	 * 기업집단재무분석목록 삭제.
	 * <pre>
	 * 메소드 설명 : 기업집단재무분석목록 데이터를 삭제
	 * 삭제 조건:
	 * - 그룹회사코드
	 * - 기업집단그룹코드
	 * - 기업집단등록코드
	 * - 평가년월일
	 * - 분석지표분류구분 (선택)
	 * - 재무항목코드 (선택)
	 * </pre>
	 * 
	 * @param requestData 요청 데이터
	 * @param onlineCtx 온라인 컨텍스트
	 * @return 처리 결과 데이터
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	@BizMethod("기업집단재무분석목록 삭제")
	public IDataSet delete(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		ILog log = getLog(onlineCtx);

		try {
			log.debug("기업집단재무분석목록 삭제 시작");

			// 삭제 실행
			int result = dbDelete("delete", requestData, onlineCtx);
			
			responseData.put("processedCount", result);
			responseData.put("returnCd", "00");
			responseData.put("returnMsg", "기업집단재무분석목록 삭제가 완료되었습니다.");
			
			log.debug("기업집단재무분석목록 삭제 완료 - 처리건수: " + result);

		} catch (Exception e) {
			log.error("기업집단재무분석목록 삭제 오류", e);
			throw new BusinessException("B3900012", "UKII0182", "데이터 삭제 중 오류가 발생했습니다.", e);
		}

		return responseData;
	}
}
