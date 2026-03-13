package com.kbstar.kip.enbipba.consts;

/**
 * 기업집단신용평가이력관리 상수 클래스
 *
 * <p>COBOL AIPBA30/DIPA301의 CO-AREA 및 CO-ERROR-AREA에 해당하는
 * 모든 상태코드, 에러코드, 조치코드, 도메인 상수를 중앙 관리한다.</p>
 *
 * <p>주의: 핫 디플로이를 위해 {@code final} 키워드 사용 금지.
 * {@code public static}만 사용한다.</p>
 *
 * @author conversion-agent
 * @version 1.0
 * @since 2026-03-13
 */
public class CCorpEvalConsts {

    // ----------------------------------------------------------------
    // 프로그램 ID
    // ----------------------------------------------------------------
    /** AIPBA30 프로그램 ID */
    public static String PGM_ID_AIPBA30 = "AIPBA30";

    /** DIPA301 프로그램 ID */
    public static String PGM_ID_DIPA301 = "DIPA301";

    // ----------------------------------------------------------------
    // 처리 결과 상태코드 (CO-AREA)
    // ----------------------------------------------------------------
    /** 정상 (CO-STAT-OK) */
    public static String STAT_OK = "00";

    /** Not Found (CO-STAT-NOTFND) */
    public static String STAT_NOTFND = "02";

    /** 오류 (CO-STAT-ERROR) */
    public static String STAT_ERROR = "09";

    /** 비정상 (CO-STAT-ABNORMAL) */
    public static String STAT_ABNORMAL = "98";

    /** 시스템오류 (CO-STAT-SYSERROR) */
    public static String STAT_SYSERROR = "99";

    // ----------------------------------------------------------------
    // 에러메시지 코드 (CO-ERROR-AREA)
    // ----------------------------------------------------------------
    /** 필수항목 오류입니다 (CO-B3800004) */
    public static String ERR_B3800004 = "B3800004";

    /** DB 에러(SQLIO 에러) (CO-B3900002) - AIPBA30 */
    public static String ERR_B3900002 = "B3900002";

    /** 데이터를 검색할 수 없습니다 (CO-B3900009) - DIPA301 */
    public static String ERR_B3900009 = "B3900009";

    /** 이미 등록되어있는 정보입니다 (CO-B4200023) - DIPA301 */
    public static String ERR_B4200023 = "B4200023";

    /** 데이터를 삭제할 수 없습니다 (CO-B4200219) - DIPA301 */
    public static String ERR_B4200219 = "B4200219";

    // ----------------------------------------------------------------
    // 조치메시지 코드 (CO-ERROR-AREA)
    // ----------------------------------------------------------------
    /** 필수입력항목을 확인해 주세요 (CO-UKIF0072) */
    public static String TREAT_UKIF0072 = "UKIF0072";

    /** DB 오류 조치 (CO-UKII0182) */
    public static String TREAT_UKII0182 = "UKII0182";

    /** 기업집단그룹코드 입력 후 다시 거래하세요 (CO-UKIP0001) */
    public static String TREAT_UKIP0001 = "UKIP0001";

    /** 기업집단등록코드 입력 후 다시 거래하세요 (CO-UKIP0002) */
    public static String TREAT_UKIP0002 = "UKIP0002";

    /** 평가일자 입력 후 다시 거래하세요 (CO-UKIP0003) */
    public static String TREAT_UKIP0003 = "UKIP0003";

    /** 처리구분코드를 입력해 주십시오 (CO-UKIP0007) */
    public static String TREAT_UKIP0007 = "UKIP0007";

    /** 평가기준일 입력 후 다시 거래하세요 (CO-UKIP0008) */
    public static String TREAT_UKIP0008 = "UKIP0008";

    // ----------------------------------------------------------------
    // 도메인 상수
    // ----------------------------------------------------------------
    /** 비계약업무구분코드 - 신평 ('060') */
    public static String NON_CTRC_BZWK_DSTCD = "060";

    /** 기업집단처리단계구분 - 확정 ('6') */
    public static String CORP_CP_STGE_DSTCD_DEFINS = "6";

    /** 기업집단처리단계구분 - 해당무 ('0') */
    public static String CORP_CP_STGE_DSTCD_NONE = "0";

    /** 기업집단평가구분 - 해당무 ('0') */
    public static String CORP_C_VALUA_DSTCD_NONE = "0";

    /** 등급조정구분 - 해당무 ('0') */
    public static String GRD_ADJS_DSTCD_NONE = "0";

    /** 조정단계번호구분 - 해당무 ('00') */
    public static String ADJS_STGE_NO_DSTCD_NONE = "00";

    /** 예비집단등급구분 - 해당무 ('000') */
    public static String SPARE_C_GRD_DSTCD_NONE = "000";

    /** 최종집단등급구분 - 해당무 ('000') */
    public static String LAST_CLCT_GRD_DSTCD_NONE = "000";

    /** 처리구분 - 신규평가 ('01') */
    public static String PRCSS_DSTCD_NEW = "01";

    /** 처리구분 - 확정취소 ('02') */
    public static String PRCSS_DSTCD_CANCEL = "02";

    /** 처리구분 - 삭제 ('03') */
    public static String PRCSS_DSTCD_DELETE = "03";

    /** 폼 ID 접두어 ('V1') */
    public static String FORM_ID_PREFIX = "V1";

    /** 데이터 존재 여부 - 존재 ('Y') */
    public static String DATA_YN_EXISTS = "Y";

    /** 데이터 존재 여부 - 미존재 ('N') */
    public static String DATA_YN_NOT_EXISTS = "N";

    /** 최대 건수 (CO-MAX-100) */
    public static int MAX_100 = 100;

}
