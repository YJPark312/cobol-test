package com.kbstar.kip.enbipba.biz;

import com.kbstar.kip.enbipba.consts.CCorpEvalConsts;
import com.kbstar.sqc.framework.context.CommonArea;
import com.kbstar.sqc.framework.context.IOnlineContext;
import com.kbstar.sqc.framework.data.IDataSet;
import com.kbstar.sqc.framework.data.impl.DataSet;
import com.kbstar.sqc.framework.exception.BusinessException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.NullAndEmptySource;
import org.junit.jupiter.params.provider.ValueSource;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.lang.reflect.Field;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * PUCorpEvalHistory ProcessUnit 테스트.
 *
 * <p>COBOL AIPBA30.cbl (AS 프로그램) 변환 결과 검증.
 * ProcessUnit의 protected 메서드(getCommonArea, getLog)를 test-subclass 패턴으로 override하고,
 * DUCorpEvalHistoryA를 Mock으로 대체하여 PM 로직만 단독 검증한다.</p>
 *
 * <p>테스트 전략:
 * <ul>
 *   <li>4개 필수항목 null/blank 입력검증 (COBOL S2000-VALIDATION-RTN 대응)</li>
 *   <li>DU 정상 호출 및 응답 조립 검증</li>
 *   <li>BusinessException 전파 검증</li>
 *   <li>일반 Exception → BusinessException 래핑 검증</li>
 *   <li>폼ID 조립 검증</li>
 * </ul>
 * </p>
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("PUCorpEvalHistory ProcessUnit PM 메서드 테스트")
class PUCorpEvalHistoryTest {

    /**
     * PUCorpEvalHistory test subclass.
     *
     * ProcessUnit.getCommonArea() 가 protected이므로 @Spy + doReturn() 방식으로는
     * 컴파일 타임에 접근 불가능하다. 따라서 subclass에서 override하여 반환값을 제어한다.
     */
    static class TestablePUCorpEvalHistory extends PUCorpEvalHistory {

        private CommonArea commonAreaStub;

        void setCommonAreaStub(CommonArea ca) {
            this.commonAreaStub = ca;
        }

        @Override
        protected CommonArea getCommonArea(IOnlineContext onlineCtx) {
            return commonAreaStub;
        }
    }

    @Mock
    private DUCorpEvalHistoryA duCorpEvalHistoryA;

    @Mock
    private IOnlineContext onlineCtx;

    @Mock
    private CommonArea commonArea;

    private TestablePUCorpEvalHistory puCorpEvalHistory;

    @BeforeEach
    void setUp() throws Exception {
        puCorpEvalHistory = new TestablePUCorpEvalHistory();
        puCorpEvalHistory.setCommonAreaStub(commonArea);

        // @BizUnitBind 주입 필드를 리플렉션으로 설정
        Field duField = PUCorpEvalHistory.class.getDeclaredField("duCorpEvalHistoryA");
        duField.setAccessible(true);
        duField.set(puCorpEvalHistory, duCorpEvalHistoryA);

        // CommonArea 기본 stub
        lenient().when(commonArea.getGroupCoCd()).thenReturn("004");
        lenient().when(commonArea.getUserEmpid()).thenReturn("E12345");
        lenient().when(commonArea.getScreenNo()).thenReturn("IPBA30");
    }

    /**
     * 기본 정상 입력 DataSet 생성 헬퍼.
     */
    private IDataSet buildValidRequest() {
        IDataSet req = new DataSet();
        req.put("prcssDstcd",       "01");
        req.put("corpClctGroupCd",  "001");
        req.put("valuaYmd",         "20260313");
        req.put("corpClctRegiCd",   "R01");
        req.put("corpClctName",     "테스트기업집단");
        req.put("valuaStdYmd",      "20260101");
        return req;
    }

    /**
     * DU 정상 응답 DataSet 생성 헬퍼.
     */
    private IDataSet buildDuSuccessResponse() {
        IDataSet resp = new DataSet();
        resp.put("totalNoitm", "00001");
        resp.put("nowNoitm",   "00001");
        return resp;
    }

    // ===========================================================================
    // 정상 처리 검증
    // ===========================================================================

    @Nested
    @DisplayName("정상 처리 시나리오 검증")
    class NormalFlowTest {

        @Test
        @DisplayName("[정상] 4개 필수항목 모두 입력 → DU 호출 → 응답 조립 성공")
        void whenAllRequiredFieldsProvided_shouldSucceed() {
            IDataSet request = buildValidRequest();
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenReturn(buildDuSuccessResponse());

            IDataSet result = puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx);

            assertNotNull(result, "응답 DataSet은 null이어서는 안 된다");
            verify(duCorpEvalHistoryA, times(1)).manageCorpEvalHistory(any(), eq(onlineCtx));
        }

        @Test
        @DisplayName("[정상] DU 응답 totalNoitm/nowNoitm 응답에 복사 검증 (COBOL MOVE XDIPA301-OUT TO YPIPBA30-CA 대응)")
        void whenDuReturnsNoitm_shouldCopyToResponse() {
            IDataSet request = buildValidRequest();
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenReturn(buildDuSuccessResponse());

            IDataSet result = puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx);

            assertEquals("00001", result.getString("totalNoitm"),
                    "DU 응답의 totalNoitm이 PM 응답에 복사되어야 한다");
            assertEquals("00001", result.getString("nowNoitm"),
                    "DU 응답의 nowNoitm이 PM 응답에 복사되어야 한다");
        }

        @Test
        @DisplayName("[정상] DU 응답 null → 기본값 '00000' 설정 검증")
        void whenDuReturnsNull_shouldSetDefaultNoitm() {
            IDataSet request = buildValidRequest();
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any())).thenReturn(null);

            IDataSet result = puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx);

            assertEquals("00000", result.getString("totalNoitm"),
                    "DU null 응답 시 totalNoitm 기본값 '00000'");
            assertEquals("00000", result.getString("nowNoitm"),
                    "DU null 응답 시 nowNoitm 기본값 '00000'");
        }

        @Test
        @DisplayName("[정상] 폼ID 설정 검증 - COBOL MOVE 'V1' + BICOM-SCREN-NO 대응")
        void whenProcessSucceeds_shouldSetFormId() {
            IDataSet request = buildValidRequest();
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenReturn(buildDuSuccessResponse());

            IDataSet result = puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx);

            String formId = result.getString("formId");
            assertNotNull(formId, "formId는 설정되어야 한다");
            assertTrue(formId.startsWith("V1"),
                    "COBOL MOVE 'V1' TO WK-FMID(1:2) 대응: formId는 'V1'로 시작해야 한다");
        }

        @Test
        @DisplayName("[정상] DU 호출 파라미터 - prcssDstcd 전달 검증")
        void whenCalled_shouldPassPrcssDstcdToDu() {
            IDataSet request = buildValidRequest();
            request.put("prcssDstcd", "03");
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenReturn(buildDuSuccessResponse());

            puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx);

            verify(duCorpEvalHistoryA).manageCorpEvalHistory(
                    argThat(ds -> "03".equals(ds.getString("prcssDstcd"))),
                    eq(onlineCtx)
            );
        }

        @Test
        @DisplayName("[정상] CommonArea groupCoCd DU 파라미터로 전달 검증")
        void whenCalled_shouldPassGroupCoCdFromCommonAreaToDu() {
            IDataSet request = buildValidRequest();
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenReturn(buildDuSuccessResponse());

            puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx);

            verify(duCorpEvalHistoryA).manageCorpEvalHistory(
                    argThat(ds -> "004".equals(ds.getString("groupCoCd"))),
                    eq(onlineCtx)
            );
        }
    }

    // ===========================================================================
    // 입력값 검증 (S2000-VALIDATION-RTN) - 4개 필수항목
    // ===========================================================================

    @Nested
    @DisplayName("입력값 검증 - 4개 필수항목 체크 (COBOL S2000-VALIDATION-RTN 대응)")
    class ValidationTest {

        @Test
        @DisplayName("[검증] prcssDstcd null → BusinessException(B3800004/UKIP0007) 발생")
        void whenPrcssDstcdIsNull_shouldThrowB3800004() {
            IDataSet request = buildValidRequest();
            request.put("prcssDstcd", null);

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertAll("처리구분 null 입력 시 에러코드/조치코드 COBOL 동등성 검증",
                    () -> assertEquals(CCorpEvalConsts.ERR_B3800004, ex.getErrorCode(),
                            "COBOL B3800004 에러코드 대응"),
                    () -> assertEquals(CCorpEvalConsts.TREAT_UKIP0007, ex.getActionCode(),
                            "COBOL UKIP0007 조치코드 대응")
            );
        }

        @Test
        @DisplayName("[검증] prcssDstcd 공백 문자열 → BusinessException(B3800004/UKIP0007) 발생")
        void whenPrcssDstcdIsBlank_shouldThrowB3800004() {
            IDataSet request = buildValidRequest();
            request.put("prcssDstcd", "   ");

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B3800004, ex.getErrorCode());
            assertEquals(CCorpEvalConsts.TREAT_UKIP0007, ex.getActionCode());
        }

        @Test
        @DisplayName("[검증] prcssDstcd 빈문자열 → BusinessException(B3800004/UKIP0007) 발생")
        void whenPrcssDstcdIsEmpty_shouldThrowB3800004() {
            IDataSet request = buildValidRequest();
            request.put("prcssDstcd", "");

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B3800004, ex.getErrorCode());
        }

        @Test
        @DisplayName("[검증] corpClctGroupCd null → BusinessException(B3800004/UKIP0001) 발생")
        void whenCorpClctGroupCdIsNull_shouldThrowUkip0001() {
            IDataSet request = buildValidRequest();
            request.put("corpClctGroupCd", null);

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertAll("기업집단그룹코드 null 입력 시 에러코드/조치코드 COBOL 동등성 검증",
                    () -> assertEquals(CCorpEvalConsts.ERR_B3800004, ex.getErrorCode(),
                            "COBOL B3800004 에러코드 대응"),
                    () -> assertEquals(CCorpEvalConsts.TREAT_UKIP0001, ex.getActionCode(),
                            "COBOL UKIP0001 조치코드 대응")
            );
        }

        @Test
        @DisplayName("[검증] corpClctGroupCd 공백 → BusinessException(B3800004/UKIP0001) 발생")
        void whenCorpClctGroupCdIsBlank_shouldThrowUkip0001() {
            IDataSet request = buildValidRequest();
            request.put("corpClctGroupCd", "  ");

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B3800004, ex.getErrorCode());
            assertEquals(CCorpEvalConsts.TREAT_UKIP0001, ex.getActionCode());
        }

        @Test
        @DisplayName("[검증] valuaYmd null → BusinessException(B3800004/UKIP0003) 발생")
        void whenValuaYmdIsNull_shouldThrowUkip0003() {
            IDataSet request = buildValidRequest();
            request.put("valuaYmd", null);

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertAll("평가년월일 null 입력 시 에러코드/조치코드 COBOL 동등성 검증",
                    () -> assertEquals(CCorpEvalConsts.ERR_B3800004, ex.getErrorCode()),
                    () -> assertEquals(CCorpEvalConsts.TREAT_UKIP0003, ex.getActionCode(),
                            "COBOL UKIP0003 조치코드 대응")
            );
        }

        @Test
        @DisplayName("[검증] valuaYmd 공백 → BusinessException(B3800004/UKIP0003) 발생")
        void whenValuaYmdIsBlank_shouldThrowUkip0003() {
            IDataSet request = buildValidRequest();
            request.put("valuaYmd", "        ");

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B3800004, ex.getErrorCode());
            assertEquals(CCorpEvalConsts.TREAT_UKIP0003, ex.getActionCode());
        }

        @Test
        @DisplayName("[검증] corpClctRegiCd null → BusinessException(B3800004/UKIP0002) 발생")
        void whenCorpClctRegiCdIsNull_shouldThrowUkip0002() {
            IDataSet request = buildValidRequest();
            request.put("corpClctRegiCd", null);

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertAll("기업집단등록코드 null 입력 시 에러코드/조치코드 COBOL 동등성 검증",
                    () -> assertEquals(CCorpEvalConsts.ERR_B3800004, ex.getErrorCode()),
                    () -> assertEquals(CCorpEvalConsts.TREAT_UKIP0002, ex.getActionCode(),
                            "COBOL UKIP0002 조치코드 대응")
            );
        }

        @Test
        @DisplayName("[검증] corpClctRegiCd 공백 → BusinessException(B3800004/UKIP0002) 발생")
        void whenCorpClctRegiCdIsBlank_shouldThrowUkip0002() {
            IDataSet request = buildValidRequest();
            request.put("corpClctRegiCd", "   ");

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B3800004, ex.getErrorCode());
            assertEquals(CCorpEvalConsts.TREAT_UKIP0002, ex.getActionCode());
        }

        @Test
        @DisplayName("[검증] 4개 필수항목 검증 순서 - prcssDstcd → corpClctGroupCd → valuaYmd → corpClctRegiCd")
        void validationOrder_prcssDstcdFirst() {
            // 4개 모두 null인 경우 첫 번째 항목(prcssDstcd)에서 오류 발생해야 함
            IDataSet request = new DataSet();
            request.put("prcssDstcd",      null);
            request.put("corpClctGroupCd", null);
            request.put("valuaYmd",        null);
            request.put("corpClctRegiCd",  null);

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertEquals(CCorpEvalConsts.TREAT_UKIP0007, ex.getActionCode(),
                    "COBOL SPACE 체크 순서: prcssDstcd가 첫 번째로 검증되어야 한다");
        }

        @Test
        @DisplayName("[검증] prcssDstcd만 정상이고 corpClctGroupCd null → UKIP0001 발생 (2번째 검증)")
        void validationOrder_corpClctGroupCdSecond() {
            IDataSet request = new DataSet();
            request.put("prcssDstcd",      "01");
            request.put("corpClctGroupCd", null);
            request.put("valuaYmd",        null);
            request.put("corpClctRegiCd",  null);

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertEquals(CCorpEvalConsts.TREAT_UKIP0001, ex.getActionCode(),
                    "두 번째 검증 항목(corpClctGroupCd)에서 오류 발생해야 한다");
        }

        @Test
        @DisplayName("[검증] 검증 통과 후 DU 미호출 검증 - 검증 실패 시 DU 절대 호출 안됨")
        void whenValidationFails_shouldNotCallDu() {
            IDataSet request = buildValidRequest();
            request.put("prcssDstcd", null);

            assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            verify(duCorpEvalHistoryA, never()).manageCorpEvalHistory(any(), any());
        }
    }

    // ===========================================================================
    // 예외 처리 검증 (COBOL try-catch 패턴 대응)
    // ===========================================================================

    @Nested
    @DisplayName("예외 처리 검증 (COBOL S0000 try-catch 패턴 대응)")
    class ExceptionHandlingTest {

        @Test
        @DisplayName("[예외전파] DU에서 BusinessException 발생 → PM에서 그대로 re-throw")
        void whenDuThrowsBusinessException_shouldRethrow() {
            IDataSet request = buildValidRequest();
            BusinessException duEx = new BusinessException(
                    CCorpEvalConsts.ERR_B4200023,
                    CCorpEvalConsts.TREAT_UKII0182,
                    "이미 등록된 정보");
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any())).thenThrow(duEx);

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertSame(duEx, ex, "DU BusinessException은 동일 객체로 re-throw 되어야 한다");
            assertEquals(CCorpEvalConsts.ERR_B4200023, ex.getErrorCode());
        }

        @Test
        @DisplayName("[예외래핑] DU에서 일반 Exception 발생 → BusinessException(B3900002) 래핑")
        void whenDuThrowsRuntimeException_shouldWrapToB3900002() {
            IDataSet request = buildValidRequest();
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenThrow(new RuntimeException("예상치 못한 오류"));

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B3900002, ex.getErrorCode(),
                    "일반 Exception은 B3900002로 래핑되어야 한다");
            assertEquals(CCorpEvalConsts.TREAT_UKII0182, ex.getActionCode());
            assertNotNull(ex.getCause(), "래핑된 예외의 cause가 존재해야 한다");
        }

        @Test
        @DisplayName("[예외래핑] NullPointerException → BusinessException(B3900002) 래핑")
        void whenNpeOccurs_shouldWrapToB3900002() {
            IDataSet request = buildValidRequest();
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenThrow(new NullPointerException("null 참조"));

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B3900002, ex.getErrorCode());
            assertTrue(ex.getCause() instanceof NullPointerException);
        }

        @Test
        @DisplayName("[예외전파] DU BusinessException 에러코드 보존 검증 (COBOL #ERROR 에러코드 재발행 패턴)")
        void whenDuThrowsB4200219_shouldPreserveErrorCode() {
            IDataSet request = buildValidRequest();
            request.put("prcssDstcd", "03");
            BusinessException duEx = new BusinessException(
                    CCorpEvalConsts.ERR_B4200219,
                    CCorpEvalConsts.TREAT_UKII0182,
                    "삭제 불가");
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any())).thenThrow(duEx);

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B4200219, ex.getErrorCode(),
                    "COBOL DC 에러코드 재발행 패턴: DU의 B4200219가 PM에 그대로 전파되어야 한다");
        }
    }

    // ===========================================================================
    // CommonArea null 처리 검증
    // ===========================================================================

    @Nested
    @DisplayName("CommonArea null 처리 검증")
    class CommonAreaNullTest {

        @Test
        @DisplayName("[CommonArea null] getGroupCoCd() null → 빈문자열로 처리 후 DU 호출")
        void whenCommonAreaGroupCoCdIsNull_shouldUseEmptyString() {
            when(commonArea.getGroupCoCd()).thenReturn(null);
            when(commonArea.getUserEmpid()).thenReturn(null);
            when(commonArea.getScreenNo()).thenReturn(null);

            IDataSet request = buildValidRequest();
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenReturn(buildDuSuccessResponse());

            assertDoesNotThrow(() -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx),
                    "CommonArea 값이 null이어도 NPE 없이 처리되어야 한다");
        }

        @Test
        @DisplayName("[CommonArea null] screenNo null → formId는 'V1' 접두어만 포함")
        void whenScreenNoIsNull_formIdShouldStartWithV1() {
            when(commonArea.getScreenNo()).thenReturn(null);
            IDataSet request = buildValidRequest();
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenReturn(buildDuSuccessResponse());

            IDataSet result = puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx);

            String formId = result.getString("formId");
            assertNotNull(formId);
            assertTrue(formId.startsWith("V1"),
                    "screenNo null이어도 formId는 'V1'로 시작해야 한다");
        }

        @Test
        @DisplayName("[CommonArea null] commonArea 자체가 null → NPE 없이 처리")
        void whenCommonAreaIsNull_shouldUseEmptyStrings() {
            puCorpEvalHistory.setCommonAreaStub(null);
            IDataSet request = buildValidRequest();
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenReturn(buildDuSuccessResponse());

            assertDoesNotThrow(() -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx),
                    "CommonArea 자체가 null이어도 NPE 없이 처리되어야 한다");
        }
    }

    // ===========================================================================
    // COBOL 동등성 검증 (YNIPBA30 입력 → XDIPA301 전달)
    // ===========================================================================

    @Nested
    @DisplayName("COBOL 동등성 검증 - 입출력 매핑")
    class CobolEquivalenceTest {

        @Test
        @DisplayName("[COBOL 동등성] YNIPBA30-CA 필드 → DU 파라미터 매핑 검증")
        void cobolInputMapping_shouldPassAllFieldsToDu() {
            IDataSet request = buildValidRequest();
            request.put("prcssDstcd",      "01");
            request.put("corpClctGroupCd", "ABC");
            request.put("valuaYmd",        "20260313");
            request.put("corpClctRegiCd",  "XYZ");
            request.put("corpClctName",    "테스트집단명");
            request.put("valuaStdYmd",     "20260101");

            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenReturn(buildDuSuccessResponse());

            puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx);

            verify(duCorpEvalHistoryA).manageCorpEvalHistory(
                    argThat(ds ->
                            "01".equals(ds.getString("prcssDstcd")) &&
                            "ABC".equals(ds.getString("corpClctGroupCd")) &&
                            "20260313".equals(ds.getString("valuaYmd")) &&
                            "XYZ".equals(ds.getString("corpClctRegiCd")) &&
                            "테스트집단명".equals(ds.getString("corpClctName"))
                    ),
                    eq(onlineCtx)
            );
        }

        @Test
        @DisplayName("[COBOL 동등성] YPIPBA30-CA 출력 - totalNoitm/nowNoitm 필드 응답 확인")
        void cobolOutputMapping_shouldIncludeTotalAndNowNoitm() {
            IDataSet request = buildValidRequest();
            IDataSet duResp = new DataSet();
            duResp.put("totalNoitm", "00003");
            duResp.put("nowNoitm",   "00002");
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any())).thenReturn(duResp);

            IDataSet result = puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx);

            assertAll("COBOL YPIPBA30-CA 출력 필드 동등성 검증",
                    () -> assertEquals("00003", result.getString("totalNoitm"),
                            "COBOL YPIPBA30-TOTAL-NOITM PIC 9(005) 대응"),
                    () -> assertEquals("00002", result.getString("nowNoitm"),
                            "COBOL YPIPBA30-PRSNT-NOITM PIC 9(005) 대응")
            );
        }

        @Test
        @DisplayName("[COBOL 동등성] 처리구분 '01' 신규평가 정상 흐름 전체 검증")
        void cobolEquivalence_newEvalHappyPath() {
            IDataSet request = buildValidRequest();
            request.put("prcssDstcd", CCorpEvalConsts.PRCSS_DSTCD_NEW);
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenReturn(buildDuSuccessResponse());

            IDataSet result = puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx);

            assertNotNull(result);
            assertNotNull(result.getString("formId"));
            assertTrue(result.getString("formId").startsWith(CCorpEvalConsts.FORM_ID_PREFIX));
            verify(duCorpEvalHistoryA, times(1)).manageCorpEvalHistory(any(), any());
        }

        @Test
        @DisplayName("[COBOL 동등성] 처리구분 '03' 삭제 정상 흐름 전체 검증")
        void cobolEquivalence_deleteHappyPath() {
            IDataSet request = buildValidRequest();
            request.put("prcssDstcd", CCorpEvalConsts.PRCSS_DSTCD_DELETE);
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenReturn(buildDuSuccessResponse());

            IDataSet result = puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx);

            assertNotNull(result);
            verify(duCorpEvalHistoryA, times(1)).manageCorpEvalHistory(
                    argThat(ds -> "03".equals(ds.getString("prcssDstcd"))),
                    any()
            );
        }
    }

    // ===========================================================================
    // 경계값 테스트 - 필수항목
    // ===========================================================================

    @Nested
    @DisplayName("필수항목 경계값 테스트")
    class BoundaryValueTest {

        @ParameterizedTest(name = "prcssDstcd = ''{0}'' → 검증 실패 (null/empty)")
        @NullAndEmptySource
        @DisplayName("[경계값] prcssDstcd null/empty → BusinessException 발생")
        void whenPrcssDstcdIsNullOrEmpty_shouldThrow(String value) {
            IDataSet request = buildValidRequest();
            request.put("prcssDstcd", value);

            assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));
        }

        @ParameterizedTest(name = "corpClctGroupCd = ''{0}'' → 검증 실패 (null/empty)")
        @NullAndEmptySource
        @DisplayName("[경계값] corpClctGroupCd null/empty → BusinessException 발생")
        void whenCorpClctGroupCdIsNullOrEmpty_shouldThrow(String value) {
            IDataSet request = buildValidRequest();
            request.put("corpClctGroupCd", value);

            assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));
        }

        @ParameterizedTest(name = "valuaYmd = ''{0}'' → 검증 실패 (null/empty)")
        @NullAndEmptySource
        @DisplayName("[경계값] valuaYmd null/empty → BusinessException 발생")
        void whenValuaYmdIsNullOrEmpty_shouldThrow(String value) {
            IDataSet request = buildValidRequest();
            request.put("valuaYmd", value);

            assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));
        }

        @ParameterizedTest(name = "corpClctRegiCd = ''{0}'' → 검증 실패 (null/empty)")
        @NullAndEmptySource
        @DisplayName("[경계값] corpClctRegiCd null/empty → BusinessException 발생")
        void whenCorpClctRegiCdIsNullOrEmpty_shouldThrow(String value) {
            IDataSet request = buildValidRequest();
            request.put("corpClctRegiCd", value);

            assertThrows(BusinessException.class,
                    () -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx));
        }

        @ParameterizedTest(name = "prcssDstcd = ''{0}'' → 정상 처리")
        @ValueSource(strings = {"01", "02", "03"})
        @DisplayName("[경계값] 유효한 처리구분 '01'/'02'/'03' → 정상 처리")
        void whenValidPrcssDstcd_shouldNotThrowValidationError(String prcssDstcd) {
            IDataSet request = buildValidRequest();
            request.put("prcssDstcd", prcssDstcd);
            when(duCorpEvalHistoryA.manageCorpEvalHistory(any(), any()))
                    .thenReturn(buildDuSuccessResponse());

            assertDoesNotThrow(() -> puCorpEvalHistory.pmAipba30Xxxx01(request, onlineCtx),
                    "유효한 처리구분 '" + prcssDstcd + "'는 검증 통과해야 한다");
        }
    }
}
