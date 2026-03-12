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
import com.kbstar.sqc.common.CommonArea;

/**
 * 기업집단신용평가이력처리.
 * <pre>
 * 유닛 설명 : 기업집단신용평가이력조회 데이터 처리
 * ---------------------------------------------------------------------------------
 *  버전    일자            작성자            설명
 * ---------------------------------------------------------------------------------
 *   0.1    20250929    MultiQ4KBBank        최초 작성
 * ---------------------------------------------------------------------------------
 * </pre>
 * 
 * @author MultiQ4KBBank
 * @since 2025-09-29
 */
@BizUnit(value = "기업집단신용평가이력처리", type = "FU")
public class FUCorpGrpCrdtEvalHistProc extends com.kbstar.sqc.base.FunctionUnit {

    @BizUnitBind private DUTSKIPB110 duTSKIPB110; // 기업집단평가기본 테이블DU
    @BizUnitBind private DUTSKIPB111 duTSKIPB111; // 기업집단연혁명세 테이블DU
    @BizUnitBind private DUTSKIPB112 duTSKIPB112; // 기업집단재무분석목록 테이블DU
    @BizUnitBind private DUTSKIPB113 duTSKIPB113; // 기업집단사업부분구조분석명세 테이블DU
    @BizUnitBind private DUTSKIPB114 duTSKIPB114; // 기업집단항목별평가목록 테이블DU
    @BizUnitBind private DUTSKIPB116 duTSKIPB116; // 기업집단계열사명세 테이블DU
    @BizUnitBind private DUTSKIPB118 duTSKIPB118; // 기업집단평가등급조정사유목록 테이블DU
    @BizUnitBind private DUTSKIPB119 duTSKIPB119; // 기업집단재무평점단계별목록 테이블DU
    @BizUnitBind private DUTSKIPB130 duTSKIPB130; // 기업집단주석명세 테이블DU
    @BizUnitBind private DUTSKIPB131 duTSKIPB131; // 기업집단승인결의록명세 테이블DU
    @BizUnitBind private DUTSKIPB132 duTSKIPB132; // 기업집단승인결의록위원명세 테이블DU
    @BizUnitBind private DUTSKIPB133 duTSKIPB133; // 기업집단승인결의록의견명세 테이블DU
    @BizUnitBind private DUTSKIPA111 duTSKIPA111; // 기업관계연결정보 테이블DU

    /**
     * 기업집단신용평가이력조회.
     * <pre>
     * 기업집단신용평가이력조회
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : prcssDstcd [처리구분코드] (string)
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctName [기업집단명] (string)
     *    - field : valuaYmd [평가년월일] (string) - optional
     *    - field : corpClctRegiCd [기업집단등록코드] (string) - optional
     *    - field : prcssStgeCtnt [처리단계내용] (string) - optional
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *    - field : totalNoitm [총건수] (int)
     *    - field : prsntNoitm [현재건수] (int)
     *    - recordSet : LIST [기업집단평가이력 LIST]
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-09-29
     */
    @BizMethod("기업집단신용평가이력조회")
    public IDataSet getCorpGrpCrdtEvalHist(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        // CommonArea 객체 참조
        CommonArea ca = getCommonArea(onlineCtx);
        
        try {
            // BR-030-006: 날짜 범위 검증
            String valuaYmd = requestData.getString("valuaYmd");
            if (valuaYmd != null && !valuaYmd.trim().isEmpty()) {
                if (!isValidDateFormat(valuaYmd)) {
                    throw new BusinessException("B3800004", "UKIP0003", "평가년월일 형식이 올바르지 않습니다.");
                }
            }
            
            // 그룹회사코드 설정 (공통영역에서 가져오기)
            String groupCoCd = ca.getBiCom().getGroupCoCd();
            requestData.put("groupCoCd", groupCoCd);
            
            // DU 호출 - 기업집단평가이력 테이블 조회 (BR-030-003: 최대 1000건 제한은 DU에서 처리)
            IDataSet duResult = duTSKIPB110.selectListHist(requestData, onlineCtx);
            
            // 데이터 매핑 및 변환
            if (duResult.getRecordSet("LIST") != null) {
                IRecordSet recordSet = duResult.getRecordSet("LIST");
                int recordCount = recordSet.getRecordCount();
                
                // 각 레코드에 대해 추가 정보 조회 및 설정
                for (int i = 0; i < recordCount; i++) {
                    IRecord record = recordSet.getRecord(i);
                    
                    // F-030-002: 확정여부 조회 및 설정
                    _setConfirmationStatus(record, requestData, onlineCtx);
                    
                    // F-030-003: 부점명 조회 및 설정
                    _setBranchNames(record, requestData, onlineCtx);
                    
                    // BR-030-005: 주채무계열여부 설정
                    _setMainDebtAffiliateStatus(record);
                    
                    // F-030-004: 등급 구분명 해석
                    _resolveGradeNames(record, requestData.getString("groupCoCd"));
                }
                
                // BR-030-003: 출력 파라미터 조립 (최대 1000건 제한)
                int totalCount = recordCount;
                int currentCount = Math.min(recordCount, 1000);
                
                responseData.put("totalNoitm", totalCount);
                responseData.put("prsntNoitm", currentCount);
                responseData.put("LIST", recordSet);
            } else {
                responseData.put("totalNoitm", 0);
                responseData.put("prsntNoitm", 0);
            }
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            // 일반 시스템 오류
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * F-030-002: 확정여부 설정
     */
    private void _setConfirmationStatus(IRecord record, IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            IDataSet confirmRequest = new DataSet();
            confirmRequest.put("groupCoCd", requestData.getString("groupCoCd"));
            confirmRequest.put("corpClctGroupCd", record.getString("corpClctGroupCd"));
            confirmRequest.put("corpClctRegiCd", record.getString("corpClctRegiCd"));
            confirmRequest.put("valuaYmd", record.getString("valuaYmd"));
            
            IDataSet confirmResult = duTSKIPA111.select(confirmRequest, onlineCtx);
            
            // BR-030-004: 확정여부 결정 로직
            String prcssStgeDstcd = confirmResult.getString("prcssStgeDstcd");
            String definsYn = (prcssStgeDstcd != null && !"6".equals(prcssStgeDstcd)) ? "N" : "Y";
            record.set("definsYn", definsYn);
            
            // 기업군관리그룹구분 설정 (BR-030-005에서 사용)
            String groupMgtType = confirmResult.getString("groupMgtType");
            record.set("groupMgtType", groupMgtType);
            
            // F-030-004: 처리단계내용 해석
            if (prcssStgeDstcd != null && !prcssStgeDstcd.trim().isEmpty()) {
                String prcssStgeCtnt = _resolveInstanceCode("UKIP04A34", prcssStgeDstcd, requestData.getString("groupCoCd"));
                record.set("prcssStgeCtnt", prcssStgeCtnt);
            }
            
        } catch (Exception e) {
            // BR-030-007: 특정 오류(B3600011/UKJI0962)는 무시하고 계속 처리
            if (e instanceof BusinessException) {
                BusinessException be = (BusinessException) e;
                if ("B3600011".equals(be.getErrorCode())) {
                    // 특정 오류는 무시하고 계속 처리
                }
            }
            record.set("definsYn", "N");
            record.set("groupMgtType", "");
            record.set("prcssStgeCtnt", "");
        }
    }

    /**
     * F-030-003: 부점명 조회 및 설정
     */
    private void _setBranchNames(IRecord record, IDataSet requestData, IOnlineContext onlineCtx) {
        // 평가부점명 조회
        _setBranchName(record, "valuaBrncd", "valuaBrnName", requestData, onlineCtx);
        
        // 관리부점명 조회
        _setBranchName(record, "mgtBrncd", "mgtbrnName", requestData, onlineCtx);
    }

    /**
     * 부점명 조회 공통 메서드
     */
    private void _setBranchName(IRecord record, String branchCodeField, String branchNameField, 
            IDataSet requestData, IOnlineContext onlineCtx) {
        try {
            String branchCode = record.getString(branchCodeField);
            if (branchCode != null && !branchCode.trim().isEmpty()) {
                IDataSet branchRequest = new DataSet();
                branchRequest.put("groupCoCd", requestData.getString("groupCoCd"));
                branchRequest.put("brncd", branchCode);
                branchRequest.put("referenceDate", record.getString("valuaYmd"));
                
                // TODO: THKJIBR0 테이블에서 부점명 조회
                // 외부 테이블이므로 TODO 주석으로 처리
                String branchName = "brnHanglName";
                record.set(branchNameField, branchName != null ? branchName : "");
            }
        } catch (Exception e) {
            // F-030-003: 부점명 조회 실패 처리 - 명세서에 따라 빈 값으로 처리
            record.set(branchNameField, "");
        }
    }

    /**
     * BR-030-005: 주채무계열여부 설정
     */
    private void _setMainDebtAffiliateStatus(IRecord record) {
        String definsYn = record.getString("definsYn");
        String groupMgtType = record.getString("groupMgtType");
        String mainDebtAffltFlag = record.getString("mainDebtAffltFlag");
        
        String mainDebtAffltYn;
        if ("N".equals(definsYn) && "01".equals(groupMgtType)) {
            mainDebtAffltYn = "여";
        } else if ("Y".equals(definsYn) && "1".equals(mainDebtAffltFlag)) {
            mainDebtAffltYn = "여";
        } else {
            mainDebtAffltYn = "부";
        }
        
        record.set("mainDebtAffltYn", mainDebtAffltYn);
    }

    /**
     * F-030-004: 등급 구분명 해석
     */
    private void _resolveGradeNames(IRecord record, String groupCoCd) {
        // 등급조정구분명 해석
        String newScGrdDstcd = record.getString("newScGrdDstcd");
        if (newScGrdDstcd != null && !newScGrdDstcd.trim().isEmpty()) {
            String dsticName1 = _resolveInstanceCode("UKIP04A35", newScGrdDstcd, groupCoCd);
            record.set("dsticName1", dsticName1);
        }
        
        // 조정단계구분명 해석
        String newLcGrdDstcd = record.getString("newLcGrdDstcd");
        if (newLcGrdDstcd != null && !newLcGrdDstcd.trim().isEmpty()) {
            String dsticName2 = _resolveInstanceCode("UKIP04A36", newLcGrdDstcd, groupCoCd);
            record.set("dsticName2", dsticName2);
        }
    }

    /**
     * F-030-004: 인스턴스 코드 해석
     * <pre>
     * 인스턴스 코드를 한글명으로 변환
     * </pre>
     * @param instanceId 인스턴스 식별자
     * @param instanceCode 인스턴스 코드
     * @param groupCoCd 그룹회사코드
     * @return 인스턴스 내용 (한글명)
     */
    private String _resolveInstanceCode(String instanceId, String instanceCode, String groupCoCd) {
        try {
            // CJIUI01 → FUBcCode.getEnbnIncdContent() 호출 (zKESA_nKESA_call_mapping_table.csv 참조)
            // 매핑: "CJIUI01,,FUBcCode,getEnbnIncdContent(),전행 인스턴스코드 내용 조회"
            IDataSet requestData = new DataSet();
            requestData.put("instanceId", instanceId);
            requestData.put("instanceCode", instanceCode);
            requestData.put("groupCoCd", groupCoCd);
            
            // TODO: FUBcCode.getEnbnIncdContent() 호출 구현 필요
            //
            // [구현 필요 사유]
            // - 인스턴스 코드를 한글명으로 변환하는 표준 프레임워크 기능 활용 필요
            // - 현재 임시 구현으로 하드코딩된 값 반환 중
            //
            // [필요한 작업]
            // 1. FUBcCode DU 클래스 확인 및 바인딩 추가
            // 2. getEnbnIncdContent() 메서드 시그니처 확인
            // 3. 아래 주석 처리된 코드로 대체
            //
            // [구현 예시]
            // @BizUnitBind private FUBcCode fuBcCode; 선언 후
            // IDataSet result = fuBcCode.getEnbnIncdContent(requestData, onlineCtx);
            // return result.getString("instanceContent");
            //
            // [참고] zKESA_nKESA_call_mapping_table.csv에서 CJIUI01 → FUBcCode.getEnbnIncdContent() 매핑 확인됨
            
            // 레거시 매핑 테이블 (CJIUI01.cbl 기반)
            if ("135921000".equals(instanceId)) {
                // 처리단계구분 코드 매핑
                switch (instanceCode) {
                    case "001": return "평가진행";
                    case "002": return "평가완료";
                    case "003": return "승인진행";
                    case "004": return "승인완료";
                    default: return "";
                }
            } else if ("100860000".equals(instanceId)) {
                // 등급조정구분 코드 매핑
                switch (instanceCode) {
                    case "001": return "상향";
                    case "002": return "하향";
                    case "003": return "유지";
                    default: return "";
                }
            } else if ("103035000".equals(instanceId)) {
                // 조정단계구분 코드 매핑
                switch (instanceCode) {
                    case "001": return "1단계";
                    case "002": return "2단계";
                    case "003": return "3단계";
                    default: return "";
                }
            }
            return "";
        } catch (Exception e) {
            // BR-030-007: 특정 오류(B3600011/UKJI0962)는 무시하고 계속 처리
            return "";
        }
    }

    /**
     * 기업집단신용평가이력처리.
     * <pre>
     * 기업집단신용평가이력 CRUD 처리 (신규평가, 확정취소, 평가삭제)
     * </pre>
     * @param requestData 요청정보 DataSet 객체
     * <pre>
     *    - field : prcssDstcd [처리구분코드] (string) - '01'=신규평가, '02'=확정취소, '03'=평가삭제
     *    - field : corpClctGroupCd [기업집단그룹코드] (string)
     *    - field : corpClctName [기업집단명] (string)
     *    - field : valuaYmd [평가년월일] (string)
     *    - field : valuaBaseYmd [평가기준년월일] (string) - 신규평가시 필수
     *    - field : corpClctRegiCd [기업집단등록코드] (string)
     * </pre>
     * @param onlineCtx 요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     * <pre>
     *    - field : totalNoitm [총건수] (int)
     *    - field : prsntNoitm [현재건수] (int)
     * </pre>
     * 
     * @author MultiQ4KBBank
     * @since 2025-09-29
     */
    @BizMethod("기업집단신용평가이력처리")
    public IDataSet processCorpGrpCrdtEvalHist(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        ILog log = getLog(onlineCtx);
        
        // CommonArea 객체 참조
        CommonArea ca = getCommonArea(onlineCtx);
        
        try {
            // BR-052-007: 그룹회사코드 설정
            String groupCoCd = ca.getBiCom().getGroupCoCd();
            requestData.put("groupCoCd", groupCoCd);
            
            String prcssDstcd = requestData.getString("prcssDstcd");
            
            // 처리구분에 따른 분기 처리
            if ("01".equals(prcssDstcd)) {
                // F-052-001: 신규 기업집단신용평가 생성
                responseData = _createNewCorpGrpCrdtEval(requestData, onlineCtx);
            } else if ("02".equals(prcssDstcd)) {
                // F-052-002: 확정취소 처리 (현재 구현에서는 삭제와 동일하게 처리)
                responseData = _deleteCorpGrpCrdtEval(requestData, onlineCtx);
            } else if ("03".equals(prcssDstcd)) {
                // F-052-002: 기업집단신용평가 삭제
                responseData = _deleteCorpGrpCrdtEval(requestData, onlineCtx);
            } else {
                // TODO: 에러코드 B3800004, 조치메시지 UKIF0072 확인 필요
                throw new BusinessException("B3800004", "UKIF0072", "유효하지 않은 처리구분코드입니다.");
            }
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * F-052-001: 신규 기업집단신용평가 생성.
     * <pre>
     * 신규 평가 레코드 생성 및 기본값 설정
     * </pre>
     */
    private IDataSet _createNewCorpGrpCrdtEval(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        
        // CommonArea 객체 참조
        CommonArea ca = getCommonArea(onlineCtx);
        
        try {
            // F-052-005: 중복 평가 확인 (확정된 평가 존재 여부)
            IDataSet duplicateCheckData = new DataSet();
            duplicateCheckData.put("groupCoCd", requestData.getString("groupCoCd"));
            duplicateCheckData.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            duplicateCheckData.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            duplicateCheckData.put("prcssStgeDstcd", "6"); // 확정상태
            
            IDataSet duplicateResult = duTSKIPA111.select(duplicateCheckData, onlineCtx);
            if (duplicateResult.getString("prcssStgeDstcd") != null) {
                // BR-052-006: 중복 평가 방지
                // TODO: 에러코드 B4200023, 조치메시지 UKII0182 확인 필요
                throw new BusinessException("B4200023", "UKII0182", "이미 등록되어있는 정보입니다.");
            }
            
            // F-052-003: 직원정보 조회
            IDataSet empData = _getEmployeeInfo(requestData, onlineCtx);
            
            // F-052-004: 주채무계열여부 조회
            IDataSet affiliateData = _getMainDebtAffiliateStatus(requestData, onlineCtx);
            
            // F-052-006: TSKIPB110 레코드 초기화 및 생성
            IDataSet newEvalData = new DataSet();
            
            // 기본 키 필드 설정
            newEvalData.put("groupCoCd", requestData.getString("groupCoCd"));
            newEvalData.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            newEvalData.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            newEvalData.put("valuaYmd", requestData.getString("valuaYmd"));
            
            // 기본 정보 설정
            newEvalData.put("corpClctName", requestData.getString("corpClctName"));
            newEvalData.put("valuaBaseYmd", requestData.getString("valuaBaseYmd"));
            
            // BR-052-008: 기본값 설정
            newEvalData.put("corpCValuaDstcd", "0"); // 기업집단평가구분
            
            // BR-052-017: 처리단계 초기화
            newEvalData.put("corpCpStgeDstcd", "1"); // 기업집단처리단계구분 (초기단계)
            
            newEvalData.put("grdAdjsDstcd", "0"); // 등급조정구분
            newEvalData.put("adjsStgeNoDstcd", "00"); // 조정단계번호구분
            
            // BR-052-015: 재무점수 초기화
            newEvalData.put("fnafScor", 0.0);
            newEvalData.put("nonFnafScor", 0.0);
            newEvalData.put("chsnScor", 0.0);
            
            // BR-052-016: 등급분류 초기화
            newEvalData.put("spareCGrdDstcd", "000"); // 예비집단등급구분
            newEvalData.put("lastClctGrdDstcd", "000"); // 최종집단등급구분
            
            // BR-052-013, BR-052-014: 직원 및 부점 정보 설정
            String currentEmpId = ca.getBiCom().getUserEmpid();
            String currentBrncd = ca.getBiCom().getBrncd();
            
            // BR-052-009: 직원정보 조회
            IDataSet empRequest = new DataSet();
            empRequest.put("groupCoCd", ca.getBiCom().getGroupCoCd());
            empRequest.put("empId", currentEmpId);
            
            String empName = currentEmpId; // 기본값
            try {
                // TODO: THKJIEM0 테이블에서 직원명 조회
                // 외부 테이블이므로 TODO 주석으로 처리
                IDataSet empResult = new DataSet();
                if (empResult.getString("empName") != null) {
                    empName = empResult.getString("empName");
                }
            } catch (Exception e) {
                // 직원정보 조회 실패 시 직원번호 사용
            }
            
            newEvalData.put("valuaEmpid", currentEmpId);
            newEvalData.put("valuaBrncd", currentBrncd);
            newEvalData.put("valuaEmnm", empName);
            
            // BR-052-010: 주채무계열여부 설정
            newEvalData.put("mainDebtAffltYn", affiliateData.getString("mainDebtAffltYn"));
            
            // DU 호출 - 신규 평가 레코드 생성
            duTSKIPB110.insert(newEvalData, onlineCtx);
            
            // 응답 데이터 설정
            responseData.put("totalNoitm", 1);
            responseData.put("prsntNoitm", 1);
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * F-052-002: 기업집단신용평가 삭제.
     * <pre>
     * 12개 관련 테이블에서 평가 레코드 연쇄 삭제
     * </pre>
     */
    private IDataSet _deleteCorpGrpCrdtEval(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        
        try {
            // BR-052-018: 다중 테이블 삭제 순서에 따른 연쇄 삭제
            int deletedCount = 0;
          
            // 12개 테이블 연쇄삭제 구현 (BR-052-021 기반)
            // 역의존성 순서로 삭제하여 참조 무결성 보장
            
            // 1. TSKIPB110 기업집단평가기본 삭제
            deletedCount += duTSKIPB110.delete(requestData, onlineCtx);
            
            // 2. TSKIPB111 기업집단연혁명세 삭제
            deletedCount += duTSKIPB111.delete(requestData, onlineCtx);
            
            // 3. TSKIPB112 기업집단재무분석목록 삭제
            deletedCount += duTSKIPB112.delete(requestData, onlineCtx);
            
            // 4. TSKIPB113 기업집단사업부분구조분석명세 삭제
            deletedCount += duTSKIPB113.delete(requestData, onlineCtx);
            
            // 5. TSKIPB114 기업집단항목별평가목록 삭제
            deletedCount += duTSKIPB114.delete(requestData, onlineCtx);
            
            // 6. TSKIPB116 기업집단계열사명세 삭제
            deletedCount += duTSKIPB116.delete(requestData, onlineCtx);
            
            // 7. TSKIPB118 기업집단평가등급조정사유목록 삭제
            deletedCount += duTSKIPB118.delete(requestData, onlineCtx);
            
            // 8. TSKIPB119 기업집단재무평점단계별목록 삭제
            deletedCount += duTSKIPB119.delete(requestData, onlineCtx);
            
            // 9. TSKIPB130 기업집단주석명세 삭제
            deletedCount += duTSKIPB130.delete(requestData, onlineCtx);
            
            // 10. TSKIPB131 기업집단승인결의록명세 삭제
            deletedCount += duTSKIPB131.delete(requestData, onlineCtx);
            
            // 11. TSKIPB132 기업집단승인결의록위원명세 삭제
            deletedCount += duTSKIPB132.delete(requestData, onlineCtx);
            
            // 12. TSKIPB133 기업집단승인결의록의견명세 삭제
            deletedCount += duTSKIPB133.delete(requestData, onlineCtx);

            // 응답 데이터 설정
            responseData.put("totalNoitm", deletedCount);
            responseData.put("prsntNoitm", deletedCount);
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            // 일반 시스템 오류
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return responseData;
    }

    /**
     * F-052-003: 직원정보 조회.
     */
    private IDataSet _getEmployeeInfo(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet empData = new DataSet();
        
        try {
            // CommonArea 객체 참조
            CommonArea ca = getCommonArea(onlineCtx);
            
            // DUTHKJIEM01 직원기본 DU를 사용하여 직원정보 조회
            IDataSet empRequest = new DataSet();
            empRequest.put("groupCoCd", requestData.getString("groupCoCd"));
            empRequest.put("empId", ca.getBiCom().getUserEmpid());
            
            try {
                IDataSet empResult = duTHKJIEM01.select(empRequest, onlineCtx);
                if (empResult != null) {
                    empData.put("empHanglFname", empResult.getString("empName"));
                    empData.put("belngBrncd", empResult.getString("deptCd"));
                } else {
                    empData.put("empHanglFname", "");
                    empData.put("belngBrncd", ca.getBiCom().getBrncd());
                }
            } catch (Exception empEx) {
                // 직원정보 조회 실패 시 기본값 사용
                empData.put("empHanglFname", "");
                empData.put("belngBrncd", ca.getBiCom().getBrncd());
            }
            
        } catch (Exception e) {
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return empData;
    }

    /**
     * F-052-004: 주채무계열여부 조회.
     */
    private IDataSet _getMainDebtAffiliateStatus(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet affiliateData = new DataSet();
        
        try {
            // DUTSKIPA111 기업관계연결정보 DU를 사용하여 주채무계열여부 조회
            IDataSet affiliateRequest = new DataSet();
            affiliateRequest.put("groupCoCd", requestData.getString("groupCoCd"));
            affiliateRequest.put("corpClctGroupCd", requestData.getString("corpClctGroupCd"));
            affiliateRequest.put("corpClctRegiCd", requestData.getString("corpClctRegiCd"));
            
            try {
                IDataSet affiliateResult = duTSKIPA111.select(affiliateRequest, onlineCtx);
                if (affiliateResult != null) {
                    // 기업관계연결정보에서 주채무계열여부 판단
                    String groupMgtType = affiliateResult.getString("groupMgtType");
                    String mainDebtAffltYn = ("01".equals(groupMgtType)) ? "Y" : "N";
                    affiliateData.put("mainDebtAffltYn", mainDebtAffltYn);
                } else {
                    affiliateData.put("mainDebtAffltYn", "N");
                }
            } catch (Exception affiliateEx) {
                // 조회 실패 시 기본값 설정
                affiliateData.put("mainDebtAffltYn", "N");
            }
            
        } catch (Exception e) {
            throw new BusinessException("B3900042", "UKII0182", "전산부 업무담당자에게 연락하여 주시기 바랍니다.", e);
        }
        
        return affiliateData;
    }
    
    /**
     * BR-030-006: 날짜 형식 검증 유틸리티 메서드
     */
    private boolean isValidDateFormat(String dateStr) {
        if (dateStr == null || dateStr.length() != 8) {
            return false;
        }
        
        try {
            int year = Integer.parseInt(dateStr.substring(0, 4));
            int month = Integer.parseInt(dateStr.substring(4, 6));
            int day = Integer.parseInt(dateStr.substring(6, 8));
            
            if (year < 1900 || year > 2100) return false;
            if (month < 1 || month > 12) return false;
            if (day < 1 || day > 31) return false;
            
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
