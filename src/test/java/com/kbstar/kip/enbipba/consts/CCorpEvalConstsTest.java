package com.kbstar.kip.enbipba.consts;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * CCorpEvalConsts 상수 클래스 테스트.
 *
 * <p>COBOL AIPBA30/DIPA301의 CO-AREA 및 CO-ERROR-AREA에 해당하는 상수값이
 * COBOL 원본과 동일한지 동등성 검증을 수행한다.</p>
 */
@DisplayName("CCorpEvalConsts 상수 클래스 테스트")
class CCorpEvalConstsTest {

    @Nested
    @DisplayName("프로그램 ID 상수 검증")
    class ProgramIdConstsTest {

        @Test
        @DisplayName("AIPBA30 프로그램 ID - COBOL CO-PGM-ID 대응 값 검증")
        void pgmIdAipba30_shouldBeAipba30() {
            assertEquals("AIPBA30", CCorpEvalConsts.PGM_ID_AIPBA30,
                    "COBOL CO-PGM-ID 'AIPBA30' 과 일치해야 한다");
        }

        @Test
        @DisplayName("DIPA301 프로그램 ID - COBOL CO-PGM-ID 대응 값 검증")
        void pgmIdDipa301_shouldBeDipa301() {
            assertEquals("DIPA301", CCorpEvalConsts.PGM_ID_DIPA301,
                    "COBOL CO-PGM-ID 'DIPA301' 과 일치해야 한다");
        }
    }

    @Nested
    @DisplayName("처리 결과 상태코드 상수 검증 (COBOL CO-AREA 대응)")
    class StatusCodeConstsTest {

        @Test
        @DisplayName("정상 상태코드 - COBOL CO-STAT-OK '00' 동등성 검증")
        void statOk_shouldBe00() {
            assertEquals("00", CCorpEvalConsts.STAT_OK,
                    "COBOL CO-STAT-OK = '00' 과 일치해야 한다");
        }

        @Test
        @DisplayName("NotFound 상태코드 - COBOL CO-STAT-NOTFND '02' 동등성 검증")
        void statNotfnd_shouldBe02() {
            assertEquals("02", CCorpEvalConsts.STAT_NOTFND,
                    "COBOL CO-STAT-NOTFND = '02' 과 일치해야 한다");
        }

        @Test
        @DisplayName("오류 상태코드 - COBOL CO-STAT-ERROR '09' 동등성 검증")
        void statError_shouldBe09() {
            assertEquals("09", CCorpEvalConsts.STAT_ERROR,
                    "COBOL CO-STAT-ERROR = '09' 과 일치해야 한다");
        }

        @Test
        @DisplayName("비정상 상태코드 - COBOL CO-STAT-ABNORMAL '98' 동등성 검증")
        void statAbnormal_shouldBe98() {
            assertEquals("98", CCorpEvalConsts.STAT_ABNORMAL,
                    "COBOL CO-STAT-ABNORMAL = '98' 과 일치해야 한다");
        }

        @Test
        @DisplayName("시스템오류 상태코드 - COBOL CO-STAT-SYSERROR '99' 동등성 검증")
        void statSyserror_shouldBe99() {
            assertEquals("99", CCorpEvalConsts.STAT_SYSERROR,
                    "COBOL CO-STAT-SYSERROR = '99' 과 일치해야 한다");
        }

        @Test
        @DisplayName("상태코드 간 유일성 검증 - 각 상태코드가 서로 다른 값을 가져야 한다")
        void statusCodes_shouldBeDistinct() {
            assertNotEquals(CCorpEvalConsts.STAT_OK, CCorpEvalConsts.STAT_NOTFND);
            assertNotEquals(CCorpEvalConsts.STAT_OK, CCorpEvalConsts.STAT_ERROR);
            assertNotEquals(CCorpEvalConsts.STAT_OK, CCorpEvalConsts.STAT_ABNORMAL);
            assertNotEquals(CCorpEvalConsts.STAT_OK, CCorpEvalConsts.STAT_SYSERROR);
            assertNotEquals(CCorpEvalConsts.STAT_ERROR, CCorpEvalConsts.STAT_ABNORMAL);
            assertNotEquals(CCorpEvalConsts.STAT_ERROR, CCorpEvalConsts.STAT_SYSERROR);
        }
    }

    @Nested
    @DisplayName("에러메시지 코드 상수 검증 (COBOL CO-ERROR-AREA 대응)")
    class ErrorCodeConstsTest {

        @Test
        @DisplayName("필수항목 오류코드 - COBOL CO-B3800004 동등성 검증")
        void errB3800004_shouldBeCorrect() {
            assertEquals("B3800004", CCorpEvalConsts.ERR_B3800004,
                    "COBOL CO-B3800004 = 'B3800004' 과 일치해야 한다");
        }

        @Test
        @DisplayName("DB 에러코드(SQLIO) - COBOL CO-B3900002 동등성 검증")
        void errB3900002_shouldBeCorrect() {
            assertEquals("B3900002", CCorpEvalConsts.ERR_B3900002,
                    "COBOL CO-B3900002 = 'B3900002' 과 일치해야 한다");
        }

        @Test
        @DisplayName("DB 검색 불가 오류코드 - COBOL CO-B3900009 동등성 검증")
        void errB3900009_shouldBeCorrect() {
            assertEquals("B3900009", CCorpEvalConsts.ERR_B3900009,
                    "COBOL CO-B3900009 = 'B3900009' 과 일치해야 한다");
        }

        @Test
        @DisplayName("이미 등록된 정보 오류코드 - COBOL CO-B4200023 동등성 검증")
        void errB4200023_shouldBeCorrect() {
            assertEquals("B4200023", CCorpEvalConsts.ERR_B4200023,
                    "COBOL CO-B4200023 = 'B4200023' 과 일치해야 한다");
        }

        @Test
        @DisplayName("삭제 불가 오류코드 - COBOL CO-B4200219 동등성 검증")
        void errB4200219_shouldBeCorrect() {
            assertEquals("B4200219", CCorpEvalConsts.ERR_B4200219,
                    "COBOL CO-B4200219 = 'B4200219' 과 일치해야 한다");
        }

        @Test
        @DisplayName("에러코드 PIC X(8) 길이 검증 - COBOL PIC X(008) 대응")
        void errorCodes_shouldBe8Characters() {
            assertEquals(8, CCorpEvalConsts.ERR_B3800004.length(), "에러코드는 8자리여야 한다");
            assertEquals(8, CCorpEvalConsts.ERR_B3900002.length(), "에러코드는 8자리여야 한다");
            assertEquals(8, CCorpEvalConsts.ERR_B3900009.length(), "에러코드는 8자리여야 한다");
            assertEquals(8, CCorpEvalConsts.ERR_B4200023.length(), "에러코드는 8자리여야 한다");
            assertEquals(8, CCorpEvalConsts.ERR_B4200219.length(), "에러코드는 8자리여야 한다");
        }
    }

    @Nested
    @DisplayName("조치메시지 코드 상수 검증 (COBOL CO-ERROR-AREA 대응)")
    class TreatCodeConstsTest {

        @Test
        @DisplayName("필수입력항목 확인 조치코드 - COBOL CO-UKIF0072 동등성 검증")
        void treatUkif0072_shouldBeCorrect() {
            assertEquals("UKIF0072", CCorpEvalConsts.TREAT_UKIF0072,
                    "COBOL CO-UKIF0072 = 'UKIF0072' 과 일치해야 한다");
        }

        @Test
        @DisplayName("DB 오류 조치코드 - COBOL CO-UKII0182 동등성 검증")
        void treatUkii0182_shouldBeCorrect() {
            assertEquals("UKII0182", CCorpEvalConsts.TREAT_UKII0182,
                    "COBOL CO-UKII0182 = 'UKII0182' 과 일치해야 한다");
        }

        @Test
        @DisplayName("그룹코드 입력 조치코드 - COBOL CO-UKIP0001 동등성 검증")
        void treatUkip0001_shouldBeCorrect() {
            assertEquals("UKIP0001", CCorpEvalConsts.TREAT_UKIP0001);
        }

        @Test
        @DisplayName("등록코드 입력 조치코드 - COBOL CO-UKIP0002 동등성 검증")
        void treatUkip0002_shouldBeCorrect() {
            assertEquals("UKIP0002", CCorpEvalConsts.TREAT_UKIP0002);
        }

        @Test
        @DisplayName("평가일자 입력 조치코드 - COBOL CO-UKIP0003 동등성 검증")
        void treatUkip0003_shouldBeCorrect() {
            assertEquals("UKIP0003", CCorpEvalConsts.TREAT_UKIP0003);
        }

        @Test
        @DisplayName("처리구분코드 입력 조치코드 - COBOL CO-UKIP0007 동등성 검증")
        void treatUkip0007_shouldBeCorrect() {
            assertEquals("UKIP0007", CCorpEvalConsts.TREAT_UKIP0007);
        }

        @Test
        @DisplayName("평가기준일 입력 조치코드 - COBOL CO-UKIP0008 동등성 검증")
        void treatUkip0008_shouldBeCorrect() {
            assertEquals("UKIP0008", CCorpEvalConsts.TREAT_UKIP0008);
        }

        @Test
        @DisplayName("조치코드 PIC X(8) 길이 검증 - COBOL PIC X(008) 대응")
        void treatCodes_shouldBe8Characters() {
            assertEquals(8, CCorpEvalConsts.TREAT_UKIF0072.length());
            assertEquals(8, CCorpEvalConsts.TREAT_UKII0182.length());
            assertEquals(8, CCorpEvalConsts.TREAT_UKIP0001.length());
            assertEquals(8, CCorpEvalConsts.TREAT_UKIP0002.length());
            assertEquals(8, CCorpEvalConsts.TREAT_UKIP0003.length());
            assertEquals(8, CCorpEvalConsts.TREAT_UKIP0007.length());
            assertEquals(8, CCorpEvalConsts.TREAT_UKIP0008.length());
        }
    }

    @Nested
    @DisplayName("도메인 상수 검증")
    class DomainConstsTest {

        @Test
        @DisplayName("비계약업무구분코드 - COBOL 하드코딩 '060' 동등성 검증")
        void nonCtrcBzwkDstcd_shouldBe060() {
            assertEquals("060", CCorpEvalConsts.NON_CTRC_BZWK_DSTCD,
                    "COBOL MOVE '060' TO JICOM-NON-CTRC-BZWK-DSTCD 대응 값이어야 한다");
        }

        @Test
        @DisplayName("기업집단처리단계구분 확정값 - COBOL 하드코딩 '6' 동등성 검증")
        void corpCpStgeDstcdDefins_shouldBe6() {
            assertEquals("6", CCorpEvalConsts.CORP_CP_STGE_DSTCD_DEFINS,
                    "COBOL WHEN '6' (확정 처리단계) 대응 값이어야 한다");
        }

        @Test
        @DisplayName("처리구분 신규평가 - COBOL WHEN '01' 동등성 검증")
        void prcssDstcdNew_shouldBe01() {
            assertEquals("01", CCorpEvalConsts.PRCSS_DSTCD_NEW,
                    "COBOL EVALUATE WHEN '01' 신규평가 대응 값이어야 한다");
        }

        @Test
        @DisplayName("처리구분 확정취소 - COBOL WHEN '02' 동등성 검증")
        void prcssDstcdCancel_shouldBe02() {
            assertEquals("02", CCorpEvalConsts.PRCSS_DSTCD_CANCEL,
                    "COBOL EVALUATE WHEN '02' 확정취소 대응 값이어야 한다");
        }

        @Test
        @DisplayName("처리구분 삭제 - COBOL WHEN '03' 동등성 검증")
        void prcssDstcdDelete_shouldBe03() {
            assertEquals("03", CCorpEvalConsts.PRCSS_DSTCD_DELETE,
                    "COBOL EVALUATE WHEN '03' 삭제 대응 값이어야 한다");
        }

        @Test
        @DisplayName("폼ID 접두어 - COBOL MOVE 'V1' 동등성 검증")
        void formIdPrefix_shouldBeV1() {
            assertEquals("V1", CCorpEvalConsts.FORM_ID_PREFIX,
                    "COBOL MOVE 'V1' TO WK-FMID(1:2) 대응 값이어야 한다");
        }

        @Test
        @DisplayName("데이터 존재 여부 - Y/N 값 검증")
        void dataYn_shouldBeYandN() {
            assertEquals("Y", CCorpEvalConsts.DATA_YN_EXISTS);
            assertEquals("N", CCorpEvalConsts.DATA_YN_NOT_EXISTS);
            assertNotEquals(CCorpEvalConsts.DATA_YN_EXISTS, CCorpEvalConsts.DATA_YN_NOT_EXISTS);
        }

        @Test
        @DisplayName("최대 건수 - COBOL CO-MAX-100 = 100 동등성 검증")
        void maxCount_shouldBe100() {
            assertEquals(100, CCorpEvalConsts.MAX_100,
                    "COBOL CO-MAX-100 PIC 9(003) VALUE 100 대응 값이어야 한다");
        }

        @Test
        @DisplayName("해당무 초기값 상수들 - 각 PIC 크기에 맞는 값 검증")
        void noneConstants_shouldMatchPicSize() {
            assertEquals("0", CCorpEvalConsts.CORP_CP_STGE_DSTCD_NONE, "PIC X(1) 해당무");
            assertEquals("0", CCorpEvalConsts.CORP_C_VALUA_DSTCD_NONE, "PIC X(1) 해당무");
            assertEquals("0", CCorpEvalConsts.GRD_ADJS_DSTCD_NONE, "PIC X(1) 해당무");
            assertEquals("00", CCorpEvalConsts.ADJS_STGE_NO_DSTCD_NONE, "PIC X(2) 해당무");
            assertEquals("000", CCorpEvalConsts.SPARE_C_GRD_DSTCD_NONE, "PIC X(3) 해당무");
            assertEquals("000", CCorpEvalConsts.LAST_CLCT_GRD_DSTCD_NONE, "PIC X(3) 해당무");
        }

        @Test
        @DisplayName("처리구분 상수들의 유일성 검증")
        void prcssDstcdConstants_shouldBeDistinct() {
            assertNotEquals(CCorpEvalConsts.PRCSS_DSTCD_NEW, CCorpEvalConsts.PRCSS_DSTCD_CANCEL);
            assertNotEquals(CCorpEvalConsts.PRCSS_DSTCD_NEW, CCorpEvalConsts.PRCSS_DSTCD_DELETE);
            assertNotEquals(CCorpEvalConsts.PRCSS_DSTCD_CANCEL, CCorpEvalConsts.PRCSS_DSTCD_DELETE);
        }
    }

    @Nested
    @DisplayName("상수 클래스 구조 검증 (핫 디플로이 요건)")
    class ClassStructureTest {

        @Test
        @DisplayName("상수 클래스 인스턴스화 가능 여부 검증 (final 클래스 아님)")
        void constantsClass_shouldBeInstantiable() {
            // n-KESA 가이드: final 키워드 사용 금지 (핫 디플로이를 위해)
            // public static 필드만 사용 - 컴파일 시 인라이닝 방지
            assertDoesNotThrow(() -> new CCorpEvalConsts(),
                    "핫 디플로이를 위해 CCorpEvalConsts는 final 클래스가 아니어야 한다");
        }

        @Test
        @DisplayName("public static 필드 non-null 검증")
        void allPublicStaticFields_shouldNotBeNull() {
            assertNotNull(CCorpEvalConsts.PGM_ID_AIPBA30);
            assertNotNull(CCorpEvalConsts.PGM_ID_DIPA301);
            assertNotNull(CCorpEvalConsts.STAT_OK);
            assertNotNull(CCorpEvalConsts.STAT_NOTFND);
            assertNotNull(CCorpEvalConsts.STAT_ERROR);
            assertNotNull(CCorpEvalConsts.STAT_ABNORMAL);
            assertNotNull(CCorpEvalConsts.STAT_SYSERROR);
            assertNotNull(CCorpEvalConsts.ERR_B3800004);
            assertNotNull(CCorpEvalConsts.ERR_B3900002);
            assertNotNull(CCorpEvalConsts.ERR_B3900009);
            assertNotNull(CCorpEvalConsts.ERR_B4200023);
            assertNotNull(CCorpEvalConsts.ERR_B4200219);
            assertNotNull(CCorpEvalConsts.TREAT_UKIF0072);
            assertNotNull(CCorpEvalConsts.TREAT_UKII0182);
            assertNotNull(CCorpEvalConsts.NON_CTRC_BZWK_DSTCD);
            assertNotNull(CCorpEvalConsts.PRCSS_DSTCD_NEW);
            assertNotNull(CCorpEvalConsts.PRCSS_DSTCD_CANCEL);
            assertNotNull(CCorpEvalConsts.PRCSS_DSTCD_DELETE);
        }
    }
}
