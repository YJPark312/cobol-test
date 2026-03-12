package com.kbstar.edu.c2j.biz;

import nexcore.framework.core.component.streotype.BizUnit;
import nexcore.framework.core.component.streotype.BizMethod;
import nexcore.framework.core.component.streotype.BizUnitBind;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.log.ILog;
import com.kbstar.sqc.base.BusinessException;

/**
 * 관계회사집단미등록계열등록 관리 PU 클래스.
 * <pre>
 * 클래스 설명 : 관계회사 집단의 미등록 계열기업 등록을 담당하는 온라인 거래 처리 단위
 * 포함된 AS 모듈: AIPBA17
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
@BizUnit("관계기업군미등록계열기업등록")
public class PURelCoGrpUnregAffReg extends com.kbstar.sqc.base.ProcessUnit {

	@BizUnitBind private FURelCoGrpUnregAffReg fuRelCoGrpUnregAffReg;

	/**
	 * 거래코드: KIP11A17E0
	 * 거래명: 관계기업군미등록계열등록
	 * <pre>
	 * 메소드 설명 : 관계기업군의 미등록 계열기업을 등록하는 온라인 거래
	 * 비즈니스 기능:
	 * - 미등록 계열기업 정보 등록
	 * - 계열기업 관계 설정
	 * - 등록 데이터 검증 및 저장
	 * 
	 * 입력 파라미터:
	 * - field : corpClctGroupCd [기업집단그룹코드] (string)
	 * - field : corpClctRegiCd [기업집단등록코드] (string)
	 * - field : exmtnCustIdnfr [심사고객식별자] (string)
	 * - field : rpsntBzno [대표사업자등록번호] (string)
	 * - field : rpsntEntpName [대표업체명] (string)
	 * 
	 * 출력 파라미터:
	 * - field : processStatus [처리상태] (string)
	 * - field : processMessage [처리메시지] (string)
	 * - recordSet : registrationResult [등록결과 LIST]
	 * </pre>
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 * @author MultiQ4KBBank
	 * @since 2025-10-02
	 */
	@BizMethod("관계기업군미등록계열등록")
	public IDataSet pmKIP11A17E0(IDataSet requestData, IOnlineContext onlineCtx) {
		ILog log = getLog(onlineCtx);
		log.debug("관계기업군미등록계열등록 거래 시작");
		
		IDataSet responseData = new DataSet();
		
		try {
			// FU 클래스의 비즈니스 로직 호출
			responseData = fuRelCoGrpUnregAffReg.processUnregAffReg(requestData, onlineCtx);
			
			log.debug("관계기업군미등록계열등록 거래 완료");
			
		} catch (BusinessException e) {
			log.error("관계기업군미등록계열등록 거래 비즈니스 오류", e);
			throw e;
		} catch (Exception e) {
			log.error("관계기업군미등록계열등록 거래 시스템 오류", e);
			throw new BusinessException("B3900001", "UKII0126", "업무관리자에게 문의하시기 바랍니다.", e);
		}
		
		return responseData;
	}

}
