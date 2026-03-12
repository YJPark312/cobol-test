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
 * 기업집단승인결의록명세 DU 클래스.
 * <pre>
 * 클래스 설명 : 기업집단승인결의록명세(TSKIPB131) 테이블에 대한 데이터 접근 단위
 * 테이블 정보:
 * - 테이블명: TSKIPB131 (기업집단승인결의록명세)
 * - 설명: 기업집단평가시스템의 기업집단신용평가 승인결의록에 대한 정보를 관리
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
@BizUnit(value = "기업집단승인결의록명세", type = "DU")
public class DUTSKIPB131 extends com.kbstar.sqc.base.DataUnit {

    public DUTSKIPB131() {
        super();
    }

    /**
     * 기업집단승인결의록명세 단건 조회.
     * <pre>
     * 메소드 설명 : 기업집단 식별정보로 승인결의록 요약정보를 조회
     * 조회 조건:
     * - 그룹회사코드
     * - 기업집단그룹코드
     * - 기업집단등록코드
     * - 평가년월일
     * 
     * 조회 결과:
     * - 평가부점명
     * - 재적위원수, 출석위원수, 승인위원수, 불승인위원수
     * - 합의구분코드, 종합승인구분코드
     * - 종전등급, 승인부점명, 승인년월일
     * </pre>
     * 
     * @param requestData 요청 데이터
     * @param onlineCtx 온라인 컨텍스트
     * @return 조회 결과
     */
    @BizMethod("승인결의록명세조회")
    public IDataSet select(IDataSet requestData, IOnlineContext onlineCtx) {
        ILog log = getLog(onlineCtx);
        log.debug("기업집단승인결의록명세 단건 조회 시작");
        
        IDataSet responseData = new DataSet();
        
        try {
            // 입력 파라미터 설정
            IDataSet queryParam = new DataSet();
            queryParam.put("groupCoCd", requestData.getString("groupCoCd"));
            queryParam.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            queryParam.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            queryParam.put("valuaYmd", requestData.getString("valuaYmd"));
            
            // 데이터베이스 조회 실행
            IRecordSet resultSet = dbSelect("select", queryParam, onlineCtx);
            
            // 결과 데이터 설정
            if (resultSet.getRecordCount() > 0) {
                IRecord resultRecord = resultSet.getRecord(0);
                
                // 승인위원회 요약정보 설정
                responseData.put("valuaBrnName", resultRecord.getString("valuaBrnName"));
                responseData.put("enrlCmmbCnt", resultRecord.getString("enrlCmmbCnt"));
                responseData.put("attndCmmbCnt", resultRecord.getString("attndCmmbCnt"));
                responseData.put("athorCmmbCnt", resultRecord.getString("athorCmmbCnt"));
                responseData.put("notAthorCmmbCnt", resultRecord.getString("notAthorCmmbCnt"));
                responseData.put("mtagDstcd", resultRecord.getString("mtagDstcd"));
                responseData.put("cmpreAthorDstcd", resultRecord.getString("cmpreAthorDstcd"));
                responseData.put("prevGrd", resultRecord.getString("prevGrd"));
                responseData.put("athorBrnName", resultRecord.getString("athorBrnName"));
                responseData.put("athorYmd", resultRecord.getString("athorYmd"));
                responseData.put("olGmGrdDstcd", resultRecord.getString("olGmGrdDstcd"));
                
                // BR-044-004: 위원회구성원수검증
                validateCommitteeMemberCount(responseData);
            }
            
            log.debug("기업집단승인결의록명세 단건 조회 완료");
            
        } catch (BusinessException e) {
            log.error("기업집단승인결의록명세 조회 업무 오류: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("기업집단승인결의록명세 조회 시스템 오류: " + e.getMessage());
            throw new BusinessException("B3900001", "UKII0185", "데이터베이스 연결 문제에 대해 시스템 관리자에게 문의하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }
    
    /**
     * 위원회 구성원수 검증.
     * 
     * @param responseData 응답 데이터
     */
    private void validateCommitteeMemberCount(IDataSet responseData) {
        try {
            int enrlCmmbCnt = Integer.parseInt(responseData.getString("enrlCmmbCnt"));
            int attndCmmbCnt = Integer.parseInt(responseData.getString("attndCmmbCnt"));
            int athorCmmbCnt = Integer.parseInt(responseData.getString("athorCmmbCnt"));
            int notAthorCmmbCnt = Integer.parseInt(responseData.getString("notAthorCmmbCnt"));
            
            // BR-044-004: 위원회구성원수검증
            if (enrlCmmbCnt < attndCmmbCnt) {
                throw new BusinessException("B3100001", "UKIP0010", "위원회 구성원수 데이터를 확인하고 데이터 관리자에게 문의하여 주시기 바랍니다.");
            }
            
            if ((athorCmmbCnt + notAthorCmmbCnt) != attndCmmbCnt) {
                throw new BusinessException("B3100002", "UKIP0011", "승인결정 데이터 일관성을 확인하고 데이터 관리자에게 문의하여 주시기 바랍니다.");
            }
            
        } catch (NumberFormatException e) {
            throw new BusinessException("B3100001", "UKIP0010", "위원회 구성원수 데이터를 확인하고 데이터 관리자에게 문의하여 주시기 바랍니다.");
        }
    }
}
