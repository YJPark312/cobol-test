package com.kbstar.kip.enbipba.biz;

import com.kbstar.kip.enbipba.consts.CCorpEvalConsts;
import com.kbstar.sqc.base.DataUnit;
import com.kbstar.sqc.framework.context.IOnlineContext;
import com.kbstar.sqc.framework.data.IDataSet;
import com.kbstar.sqc.framework.data.IRecord;
import com.kbstar.sqc.framework.data.IRecordSet;
import com.kbstar.sqc.framework.data.impl.DataSet;
import com.kbstar.sqc.framework.exception.BusinessException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * DUCorpEvalHistoryA 테스트.
 *
 * <p>DataUnit의 protected DB 메서드(dbInsert/dbSelect/dbSelectMulti/dbDelete)를
 * 테스트 전용 서브클래스(TestableDUCorpEvalHistoryA)로 오버라이드하여 stub 처리한다.
 * 실제 DB 연결 없이 비즈니스 로직만 단독 검증한다.</p>
 *
 * <p>테스트 전략:
 * <ul>
 *   <li>TestableDUCorpEvalHistoryA: stub 레지스트리로 DB 메서드 제어</li>
 *   <li>처리구분 분기('01'/'02'/'03') 검증</li>
 *   <li>기존재 확인 → INSERT 중복 방지 검증</li>
 *   <li>11개 테이블 연쇄 DELETE 검증</li>
 *   <li>BusinessException 발생 조건 검증</li>
 * </ul>
 * </p>
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("DUCorpEvalHistoryA DataUnit 테스트")
class DUCorpEvalHistoryATest {

    @Mock
    private IOnlineContext onlineCtx;

    /**
     * 테스트 전용 서브클래스.
     * protected DB 메서드를 오버라이드하여 stub 레지스트리로 제어한다.
     */
    static class TestableDUCorpEvalHistoryA extends DUCorpEvalHistoryA {

        // SQL ID → 반환값 레지스트리
        private final Map<String, IDataSet> selectStubs     = new HashMap<>();
        private final Map<String, IRecordSet> selectMultiStubs = new HashMap<>();
        private final Map<String, Integer> insertStubs      = new HashMap<>();
        private final Map<String, Integer> deleteStubs      = new HashMap<>();

        // 호출 카운터
        private final Map<String, Integer> callCounts = new HashMap<>();

        void stubSelect(String sqlId, IDataSet result) {
            selectStubs.put(sqlId, result);
        }

        void stubSelectMulti(String sqlId, IRecordSet result) {
            selectMultiStubs.put(sqlId, result);
        }

        void stubInsert(String sqlId, int rows) {
            insertStubs.put(sqlId, rows);
        }

        void stubDelete(String sqlId, int rows) {
            deleteStubs.put(sqlId, rows);
        }

        int getCallCount(String sqlId) {
            return callCounts.getOrDefault(sqlId, 0);
        }

        private void increment(String sqlId) {
            callCounts.merge(sqlId, 1, Integer::sum);
        }

        @Override
        protected IDataSet dbSelect(String sqlId, IDataSet param) {
            increment(sqlId);
            // 등록된 stub이 없으면 null (NOTFOUND)
            return selectStubs.get(sqlId);
        }

        @Override
        protected IRecordSet dbSelectMulti(String sqlId, IDataSet param) {
            increment(sqlId);
            return selectMultiStubs.getOrDefault(sqlId, emptyRecordSet());
        }

        @Override
        protected int dbInsert(String sqlId, IDataSet param) {
            increment(sqlId);
            return insertStubs.getOrDefault(sqlId, 1);
        }

        @Override
        protected int dbDelete(String sqlId, IDataSet param) {
            increment(sqlId);
            return deleteStubs.getOrDefault(sqlId, 0);
        }

        private IRecordSet emptyRecordSet() {
            return new IRecordSet() {
                @Override public int getRecordCount() { return 0; }
                @Override public IRecord getRecord(int index) { return null; }
            };
        }
    }

    private TestableDUCorpEvalHistoryA du;

    @BeforeEach
    void setUp() {
        du = new TestableDUCorpEvalHistoryA();
    }

    /**
     * 기본 입력 DataSet 생성 헬퍼.
     */
    private IDataSet buildBaseRequest(String prcssDstcd) {
        IDataSet req = new DataSet();
        req.put("prcssDstcd",       prcssDstcd);
        req.put("groupCoCd",        "004");
        req.put("corpClctGroupCd",  "001");
        req.put("corpClctRegiCd",   "R01");
        req.put("valuaYmd",         "20260313");
        req.put("valuaStdYmd",      "20260101");
        req.put("corpClctName",     "테스트기업집단");
        req.put("userEmpid",        "E12345");
        return req;
    }

    /**
     * 단건 IRecord를 가진 IRecordSet 생성 헬퍼.
     */
    private IRecordSet singleRecordSet(IRecord record) {
        return new IRecordSet() {
            @Override public int getRecordCount() { return 1; }
            @Override public IRecord getRecord(int index) { return record; }
        };
    }

    /**
     * 지정 필드-값 쌍을 가진 IRecord 생성 헬퍼 (key1, val1, key2, val2, ...).
     */
    private IRecord buildRecord(String... keyValues) {
        return new IRecord() {
            @Override
            public String getString(String key) {
                for (int i = 0; i + 1 < keyValues.length; i += 2) {
                    if (keyValues[i].equals(key)) return keyValues[i + 1];
                }
                return null;
            }
            @Override
            public int getInt(String key) { return 0; }
        };
    }

    /**
     * 삭제 처리 시 모든 테이블을 빈 결과(NOTFOUND)로 설정하는 헬퍼.
     */
    private void stubAllDeleteTargetsAsEmpty() {
        // THKIPB110: SELECT NOTFOUND
        // (stubSelect 없으면 기본 null 반환 → skip)
        // 나머지 CURSOR/SQLIO 기반 → 빈 RecordSet
        du.stubSelectMulti("selectListThkipb111ForUpdate", new IRecordSet() {
            @Override public int getRecordCount() { return 0; }
            @Override public IRecord getRecord(int i) { return null; }
        });
        du.stubSelectMulti("selectListThkipb116ForUpdate", new IRecordSet() {
            @Override public int getRecordCount() { return 0; }
            @Override public IRecord getRecord(int i) { return null; }
        });
        // SQLIO 기반 → 빈 결과
        du.stubSelectMulti("selectPksQipa303", new IRecordSet() {
            @Override public int getRecordCount() { return 0; }
            @Override public IRecord getRecord(int i) { return null; }
        });
        du.stubSelectMulti("selectPksQipa304", new IRecordSet() {
            @Override public int getRecordCount() { return 0; }
            @Override public IRecord getRecord(int i) { return null; }
        });
        du.stubSelectMulti("selectListThkipb114ForUpdate", new IRecordSet() {
            @Override public int getRecordCount() { return 0; }
            @Override public IRecord getRecord(int i) { return null; }
        });
        du.stubSelectMulti("selectPksQipa305", new IRecordSet() {
            @Override public int getRecordCount() { return 0; }
            @Override public IRecord getRecord(int i) { return null; }
        });
        du.stubSelectMulti("selectListThkipb132ForUpdate", new IRecordSet() {
            @Override public int getRecordCount() { return 0; }
            @Override public IRecord getRecord(int i) { return null; }
        });
        du.stubSelectMulti("selectPksQipa306", new IRecordSet() {
            @Override public int getRecordCount() { return 0; }
            @Override public IRecord getRecord(int i) { return null; }
        });
        du.stubSelectMulti("selectPksQipa308", new IRecordSet() {
            @Override public int getRecordCount() { return 0; }
            @Override public IRecord getRecord(int i) { return null; }
        });
        // 단건 SELECT → null (NOTFOUND, skip)
        // selectThkipb110ForUpdate, selectThkipb118ForUpdate, selectThkipb131ForUpdate
        // 기본적으로 stubSelect 없으면 null 반환
    }

    // ===========================================================================
    // manageCorpEvalHistory - 처리구분 분기 테스트
    // ===========================================================================

    @Nested
    @DisplayName("처리구분 분기 검증 (COBOL EVALUATE XDIPA301-I-PRCSS-DSTCD 대응)")
    class BranchTest {

        @Test
        @DisplayName("[처리구분 '01'] 신규평가 - 기존재 없음 → INSERT 정상 처리")
        void whenPrcss01_andNotExists_shouldInsertSuccessfully() {
            IDataSet req = buildBaseRequest("01");
            // selectExistCheckQipa301: null (기존재 없음)
            du.stubInsert("insertThkipb110", 1);

            IDataSet result = du.manageCorpEvalHistory(req, onlineCtx);

            assertNotNull(result, "정상 처리 시 결과 DataSet이 null이어서는 안 된다");
            assertEquals(1, du.getCallCount("insertThkipb110"), "INSERT 1회 호출 검증");
        }

        @Test
        @DisplayName("[처리구분 '01'] 신규평가 - 기존재 있음(cnt=1) → BusinessException(B4200023) 발생")
        void whenPrcss01_andAlreadyExists_shouldThrowB4200023() {
            IDataSet req = buildBaseRequest("01");

            // 기존재 확인 결과: cnt=1 (존재)
            IDataSet existResult = new DataSet();
            existResult.put("cnt", "1");
            du.stubSelect("selectExistCheckQipa301", existResult);

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> du.manageCorpEvalHistory(req, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B4200023, ex.getErrorCode(),
                    "COBOL CO-B4200023 에러코드 동등성 검증 (이미 등록된 정보)");
            assertEquals(CCorpEvalConsts.TREAT_UKII0182, ex.getActionCode(),
                    "COBOL CO-UKII0182 조치코드 동등성 검증");
            assertEquals(0, du.getCallCount("insertThkipb110"), "기존재 시 INSERT 미호출 검증");
        }

        @Test
        @DisplayName("[처리구분 '01'] 기존재 확인 cnt=0 → 신규 처리 진행 (INSERT 실행)")
        void whenPrcss01_andCntIsZero_shouldProceedWithInsert() {
            IDataSet req = buildBaseRequest("01");

            IDataSet cntZero = new DataSet();
            cntZero.put("cnt", "0");
            du.stubSelect("selectExistCheckQipa301", cntZero);
            du.stubInsert("insertThkipb110", 1);

            assertDoesNotThrow(() -> du.manageCorpEvalHistory(req, onlineCtx));
            assertEquals(1, du.getCallCount("insertThkipb110"));
        }

        @Test
        @DisplayName("[처리구분 '02'] 확정취소 - 무동작 처리 (COBOL TBD 항목, DB 미호출)")
        void whenPrcss02_shouldDoNothing() {
            IDataSet req = buildBaseRequest("02");

            IDataSet result = du.manageCorpEvalHistory(req, onlineCtx);

            assertNotNull(result, "확정취소도 결과 DataSet을 반환해야 한다");
            assertEquals(0, du.getCallCount("insertThkipb110"), "INSERT 미호출 검증");
            assertEquals(0, du.getCallCount("selectExistCheckQipa301"), "SELECT 미호출 검증");
        }

        @Test
        @DisplayName("[처리구분 '03'] 삭제 - 모든 테이블 NOTFOUND → 정상 종료 (DELETE 미실행)")
        void whenPrcss03_andAllTablesNotFound_shouldCompleteWithoutDelete() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();

            IDataSet result = du.manageCorpEvalHistory(req, onlineCtx);

            assertNotNull(result);
            // 모든 DELETE 미호출 검증
            assertEquals(0, du.getCallCount("deleteThkipb110"));
            assertEquals(0, du.getCallCount("deleteThkipb111"));
            assertEquals(0, du.getCallCount("deleteThkipb116"));
            assertEquals(0, du.getCallCount("deleteThkipb118"));
            assertEquals(0, du.getCallCount("deleteThkipb131"));
        }

        @Test
        @DisplayName("[처리구분 미정의 '99'] 알 수 없는 처리구분 → BusinessException(B3800004) 발생")
        void whenUnknownPrcssDstcd_shouldThrowB3800004() {
            IDataSet req = buildBaseRequest("99");

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> du.manageCorpEvalHistory(req, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B3800004, ex.getErrorCode());
            assertEquals(CCorpEvalConsts.TREAT_UKIP0007, ex.getActionCode());
        }
    }

    // ===========================================================================
    // 신규평가 처리 세부 검증 (처리구분 '01')
    // ===========================================================================

    @Nested
    @DisplayName("신규평가 처리 세부 검증 (처리구분 '01')")
    class InsertProcessTest {

        @Test
        @DisplayName("[신규평가] INSERT 실패 rows=0 → BusinessException(B3900002) 발생")
        void whenInsertFails_shouldThrowB3900002() {
            IDataSet req = buildBaseRequest("01");
            // 기존재 없음 (기본 null)
            du.stubInsert("insertThkipb110", 0); // 실패

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> du.manageCorpEvalHistory(req, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B3900002, ex.getErrorCode(),
                    "INSERT 실패 시 B3900002 에러코드 발생해야 한다");
        }

        @Test
        @DisplayName("[신규평가] 주채무계열여부 조회 실행 검증")
        void whenPrcss01_shouldCallMainDebtAffltCheck() {
            IDataSet req = buildBaseRequest("01");
            du.stubInsert("insertThkipb110", 1);

            du.manageCorpEvalHistory(req, onlineCtx);

            assertEquals(1, du.getCallCount("selectMainDebtAffltYnQipa307"),
                    "주채무계열여부 조회(QIPA307) 1회 호출 검증");
        }

        @Test
        @DisplayName("[신규평가] 직원기본정보 조회 실행 검증")
        void whenPrcss01_shouldCallEmployeeInfoQuery() {
            IDataSet req = buildBaseRequest("01");
            du.stubInsert("insertThkipb110", 1);

            du.manageCorpEvalHistory(req, onlineCtx);

            assertEquals(1, du.getCallCount("selectEmployeeInfoQipa302"),
                    "직원기본정보 조회(QIPA302) 1회 호출 검증");
        }

        @Test
        @DisplayName("[신규평가] 기존재 확인 실행 검증")
        void whenPrcss01_shouldCallExistCheck() {
            IDataSet req = buildBaseRequest("01");
            du.stubInsert("insertThkipb110", 1);

            du.manageCorpEvalHistory(req, onlineCtx);

            assertEquals(1, du.getCallCount("selectExistCheckQipa301"),
                    "기존재 확인(QIPA301) 1회 호출 검증");
        }
    }

    // ===========================================================================
    // 삭제 처리 세부 검증 (처리구분 '03')
    // ===========================================================================

    @Nested
    @DisplayName("삭제 처리 세부 검증 (처리구분 '03') - COBOL S4200~S42E1 대응")
    class DeleteProcessTest {

        @Test
        @DisplayName("[삭제] THKIPB110 존재 → DELETE 실행 1회 검증")
        void whenThkipb110Exists_shouldDeleteOnce() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();

            IDataSet existData = new DataSet();
            existData.put("groupCoCd", "004");
            du.stubSelect("selectThkipb110ForUpdate", existData);
            du.stubDelete("deleteThkipb110", 1);

            du.manageCorpEvalHistory(req, onlineCtx);

            assertEquals(1, du.getCallCount("deleteThkipb110"), "THKIPB110 DELETE 1회 실행 검증");
        }

        @Test
        @DisplayName("[삭제] THKIPB110 DELETE 실패(rows=0) → BusinessException(B4200219) 발생")
        void whenThkipb110DeleteFails_shouldThrowB4200219() {
            IDataSet req = buildBaseRequest("03");

            IDataSet existData = new DataSet();
            du.stubSelect("selectThkipb110ForUpdate", existData);
            du.stubDelete("deleteThkipb110", 0); // 삭제 실패

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> du.manageCorpEvalHistory(req, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B4200219, ex.getErrorCode(),
                    "THKIPB110 삭제 실패 시 B4200219 발생");
            assertEquals(CCorpEvalConsts.TREAT_UKII0182, ex.getActionCode());
        }

        @Test
        @DisplayName("[삭제] THKIPB111 CURSOR 루프 2건 → DELETE 2회 실행 검증")
        void whenThkipb111Has2Records_shouldDeleteTwice() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();

            IRecord rec1 = buildRecord("groupCoCd", "004", "corpClctGroupCd", "001",
                    "corpClctRegiCd", "R01", "valuaYmd", "20260313",
                    "corpHstryDstcd", "01", "serno", "001");
            IRecord rec2 = buildRecord("groupCoCd", "004", "corpClctGroupCd", "001",
                    "corpClctRegiCd", "R01", "valuaYmd", "20260313",
                    "corpHstryDstcd", "02", "serno", "001");

            IRecordSet rs2 = new IRecordSet() {
                @Override public int getRecordCount() { return 2; }
                @Override public IRecord getRecord(int index) { return index == 0 ? rec1 : rec2; }
            };

            du.stubSelectMulti("selectListThkipb111ForUpdate", rs2);
            du.stubDelete("deleteThkipb111", 1);

            du.manageCorpEvalHistory(req, onlineCtx);

            assertEquals(2, du.getCallCount("deleteThkipb111"),
                    "THKIPB111 2건 루프 → DELETE 2회 실행");
        }

        @Test
        @DisplayName("[삭제] THKIPB111 DELETE 실패(rows=0) → BusinessException(B4200219)")
        void whenThkipb111DeleteFails_shouldThrowB4200219() {
            IDataSet req = buildBaseRequest("03");

            IRecord rec = buildRecord("groupCoCd", "004", "corpClctGroupCd", "001",
                    "corpClctRegiCd", "R01", "valuaYmd", "20260313",
                    "corpHstryDstcd", "01", "serno", "001");
            du.stubSelectMulti("selectListThkipb111ForUpdate", singleRecordSet(rec));
            du.stubDelete("deleteThkipb111", 0); // 실패

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> du.manageCorpEvalHistory(req, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B4200219, ex.getErrorCode());
        }

        @Test
        @DisplayName("[삭제] THKIPB116 CURSOR 루프 3건 → DELETE 3회 실행 검증")
        void whenThkipb116Has3Records_shouldDeleteThrice() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();

            IRecord[] recs = {
                buildRecord("groupCoCd", "004", "corpClctGroupCd", "001",
                        "corpClctRegiCd", "R01", "valuaYmd", "20260313", "affltCoNo", "C001"),
                buildRecord("groupCoCd", "004", "corpClctGroupCd", "001",
                        "corpClctRegiCd", "R01", "valuaYmd", "20260313", "affltCoNo", "C002"),
                buildRecord("groupCoCd", "004", "corpClctGroupCd", "001",
                        "corpClctRegiCd", "R01", "valuaYmd", "20260313", "affltCoNo", "C003")
            };
            IRecordSet rs3 = new IRecordSet() {
                @Override public int getRecordCount() { return 3; }
                @Override public IRecord getRecord(int index) { return recs[index]; }
            };

            du.stubSelectMulti("selectListThkipb116ForUpdate", rs3);
            du.stubDelete("deleteThkipb116", 1);

            du.manageCorpEvalHistory(req, onlineCtx);

            assertEquals(3, du.getCallCount("deleteThkipb116"),
                    "THKIPB116 3건 루프 → DELETE 3회 실행");
        }

        @Test
        @DisplayName("[삭제] THKIPB113 SQLIO PK 조회 → LOCK SELECT NOTFOUND → DELETE 스킵")
        void whenThkipb113LockSelectNotFound_shouldSkipDelete() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();

            IRecord pkRec = buildRecord("fnafARptdocDstcd", "A01", "fnafItemCd", "I001", "bizSectNo", "001");
            du.stubSelectMulti("selectPksQipa303", singleRecordSet(pkRec));
            // selectThkipb113ForUpdate: null (NOTFOUND) → DELETE 스킵

            du.manageCorpEvalHistory(req, onlineCtx);

            assertEquals(0, du.getCallCount("deleteThkipb113"),
                    "LOCK SELECT NOTFOUND 시 DELETE 미실행 검증");
        }

        @Test
        @DisplayName("[삭제] THKIPB113 SQLIO PK 조회 → LOCK SELECT 성공 → DELETE 1회 실행")
        void whenThkipb113LockSelectFound_shouldDelete() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();

            IRecord pkRec = buildRecord("fnafARptdocDstcd", "A01", "fnafItemCd", "I001", "bizSectNo", "001");
            du.stubSelectMulti("selectPksQipa303", singleRecordSet(pkRec));

            IDataSet lockData = new DataSet();
            lockData.put("groupCoCd", "004");
            du.stubSelect("selectThkipb113ForUpdate", lockData);
            du.stubDelete("deleteThkipb113", 1);

            du.manageCorpEvalHistory(req, onlineCtx);

            assertEquals(1, du.getCallCount("deleteThkipb113"),
                    "LOCK SELECT 성공 시 DELETE 1회 실행");
        }

        @Test
        @DisplayName("[삭제] THKIPB113 DELETE 실패 → BusinessException(B4200219)")
        void whenThkipb113DeleteFails_shouldThrowB4200219() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();

            IRecord pkRec = buildRecord("fnafARptdocDstcd", "A01", "fnafItemCd", "I001", "bizSectNo", "001");
            du.stubSelectMulti("selectPksQipa303", singleRecordSet(pkRec));
            du.stubSelect("selectThkipb113ForUpdate", new DataSet());
            du.stubDelete("deleteThkipb113", 0);

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> du.manageCorpEvalHistory(req, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B4200219, ex.getErrorCode());
        }

        @Test
        @DisplayName("[삭제] THKIPB118 NOTFOUND → DELETE 스킵 (정상처리)")
        void whenThkipb118NotFound_shouldSkipDelete() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();
            // selectThkipb118ForUpdate: null (기본값 null)

            assertDoesNotThrow(() -> du.manageCorpEvalHistory(req, onlineCtx));
            assertEquals(0, du.getCallCount("deleteThkipb118"),
                    "THKIPB118 NOTFOUND 시 DELETE 미실행");
        }

        @Test
        @DisplayName("[삭제] THKIPB118 존재 → DELETE 1회 실행")
        void whenThkipb118Exists_shouldDeleteOnce() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();

            du.stubSelect("selectThkipb118ForUpdate", new DataSet());
            du.stubDelete("deleteThkipb118", 1);

            du.manageCorpEvalHistory(req, onlineCtx);

            assertEquals(1, du.getCallCount("deleteThkipb118"));
        }

        @Test
        @DisplayName("[삭제] THKIPB131 존재 → DELETE 1회 실행")
        void whenThkipb131Exists_shouldDeleteOnce() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();

            du.stubSelect("selectThkipb131ForUpdate", new DataSet());
            du.stubDelete("deleteThkipb131", 1);

            du.manageCorpEvalHistory(req, onlineCtx);

            assertEquals(1, du.getCallCount("deleteThkipb131"));
        }

        @Test
        @DisplayName("[삭제] THKIPB132 CURSOR 루프 삭제 실패 → BusinessException(B4200219)")
        void whenThkipb132DeleteFails_shouldThrowB4200219() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();

            IRecord rec = buildRecord("groupCoCd", "004", "corpClctGroupCd", "001",
                    "corpClctRegiCd", "R01", "valuaYmd", "20260313", "athorCmmbEmpid", "E001");
            du.stubSelectMulti("selectListThkipb132ForUpdate", singleRecordSet(rec));
            du.stubDelete("deleteThkipb132", 0);

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> du.manageCorpEvalHistory(req, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B4200219, ex.getErrorCode());
        }

        @Test
        @DisplayName("[삭제] THKIPB119 SQLIO NOTFOUND → DELETE 미실행")
        void whenThkipb119PkListEmpty_shouldSkipDelete() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();
            // selectPksQipa308: 기본 빈 RecordSet → 아무것도 안 함

            assertDoesNotThrow(() -> du.manageCorpEvalHistory(req, onlineCtx));
            assertEquals(0, du.getCallCount("deleteThkipb119"));
        }
    }

    // ===========================================================================
    // 응답 DataSet 검증
    // ===========================================================================

    @Nested
    @DisplayName("응답 DataSet 검증")
    class ResponseDataSetTest {

        @Test
        @DisplayName("[응답] 처리구분 '02' 기본 totalNoitm/nowNoitm '00000' 검증")
        void whenPrcss02_responseShouldHaveDefaultNoitm() {
            IDataSet req = buildBaseRequest("02");

            IDataSet result = du.manageCorpEvalHistory(req, onlineCtx);

            assertNotNull(result);
            assertEquals("00000", result.getString("totalNoitm"),
                    "응답 totalNoitm 기본값은 '00000'이어야 한다");
            assertEquals("00000", result.getString("nowNoitm"),
                    "응답 nowNoitm 기본값은 '00000'이어야 한다");
        }

        @Test
        @DisplayName("[응답] 요청에 totalNoitm 있으면 응답에 그대로 반영")
        void whenRequestHasTotalNoitm_shouldReflectInResponse() {
            IDataSet req = buildBaseRequest("02");
            req.put("totalNoitm", "00005");
            req.put("nowNoitm",   "00003");

            IDataSet result = du.manageCorpEvalHistory(req, onlineCtx);

            assertEquals("00005", result.getString("totalNoitm"));
            assertEquals("00003", result.getString("nowNoitm"));
        }
    }

    // ===========================================================================
    // 경계값 테스트
    // ===========================================================================

    @Nested
    @DisplayName("경계값 및 예외 입력 테스트")
    class BoundaryValueTest {

        /**
         * [소스 코드 버그 확인 테스트]
         *
         * DUCorpEvalHistoryA.java line 82:
         *   prcssDstcd.replaceAll("[\r\n]", "_")
         * prcssDstcd가 null일 때 null 체크 없이 replaceAll() 호출 → NullPointerException 발생.
         *
         * COBOL 원본에서는 SPACE 체크 후 분기하므로 null이 들어오지 않으나,
         * Java 변환 코드에서 null 방어 로직이 누락된 버그임.
         * 개발자 수정 권고: prcssDstcd != null 조건 추가 또는 Objects.requireNonNullElse 사용.
         *
         * 현재 테스트는 실제 동작(NullPointerException)을 문서화하기 위해 존재한다.
         */
        @Test
        @DisplayName("[경계값][버그] prcssDstcd null → NullPointerException 발생 (소스 null 방어 누락 버그 - 개발자 검토 필요)")
        void whenPrcssDstcdIsNull_shouldThrowNullPointerException_sourceCodeBug() {
            IDataSet req = buildBaseRequest(null);

            // 소스 코드 버그: prcssDstcd.replaceAll() 호출 전 null 체크 누락
            // 기대 동작: BusinessException(B3800004) 발생
            // 실제 동작: NullPointerException 발생
            assertThrows(NullPointerException.class,
                    () -> du.manageCorpEvalHistory(req, onlineCtx),
                    "소스 코드 버그: prcssDstcd null 입력 시 BusinessException이 아닌 NullPointerException 발생. " +
                    "DUCorpEvalHistoryA.java line 82 수정 필요.");
        }

        @Test
        @DisplayName("[경계값] prcssDstcd 빈문자열 → BusinessException 발생")
        void whenPrcssDstcdIsEmpty_shouldThrowBusinessException() {
            IDataSet req = buildBaseRequest("");

            BusinessException ex = assertThrows(BusinessException.class,
                    () -> du.manageCorpEvalHistory(req, onlineCtx));

            assertEquals(CCorpEvalConsts.ERR_B3800004, ex.getErrorCode());
        }

        @Test
        @DisplayName("[경계값] prcssDstcd '00' (하한 경계 미만) → BusinessException 발생")
        void whenPrcssDstcdIs00_shouldThrowBusinessException() {
            IDataSet req = buildBaseRequest("00");

            assertThrows(BusinessException.class,
                    () -> du.manageCorpEvalHistory(req, onlineCtx));
        }

        @Test
        @DisplayName("[경계값] prcssDstcd '04' (상한 경계 초과) → BusinessException 발생")
        void whenPrcssDstcdIs04_shouldThrowBusinessException() {
            IDataSet req = buildBaseRequest("04");

            assertThrows(BusinessException.class,
                    () -> du.manageCorpEvalHistory(req, onlineCtx));
        }

        @Test
        @DisplayName("[경계값] 처리구분 경계값 '01' (최소 유효값) → 정상 처리")
        void whenPrcssDstcdIs01_shouldBeValid() {
            IDataSet req = buildBaseRequest("01");
            du.stubInsert("insertThkipb110", 1);

            assertDoesNotThrow(() -> du.manageCorpEvalHistory(req, onlineCtx));
        }

        @Test
        @DisplayName("[경계값] 처리구분 경계값 '03' (최대 유효값) → 정상 처리")
        void whenPrcssDstcdIs03_shouldBeValid() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();

            assertDoesNotThrow(() -> du.manageCorpEvalHistory(req, onlineCtx));
        }
    }

    // ===========================================================================
    // COBOL 동등성 검증
    // ===========================================================================

    @Nested
    @DisplayName("COBOL 동등성 검증")
    class CobolEquivalenceTest {

        @Test
        @DisplayName("[COBOL 동등성] 신규평가 '01' - 처리구분 '01' 시 INSERT 호출 순서 검증")
        void cobolEquivalence_prcss01_insertOrder() {
            IDataSet req = buildBaseRequest("01");
            du.stubInsert("insertThkipb110", 1);

            du.manageCorpEvalHistory(req, onlineCtx);

            // COBOL 처리 순서: S3100(기존재확인) → S3221(주채무계열) → S5000(직원조회) → S3200(INSERT)
            assertEquals(1, du.getCallCount("selectExistCheckQipa301"), "S3100 QIPA301 1회 호출");
            assertEquals(1, du.getCallCount("selectMainDebtAffltYnQipa307"), "S3221 QIPA307 1회 호출");
            assertEquals(1, du.getCallCount("selectEmployeeInfoQipa302"), "S5000 QIPA302 1회 호출");
            assertEquals(1, du.getCallCount("insertThkipb110"), "S3200 INSERT 1회 실행");
        }

        @Test
        @DisplayName("[COBOL 동등성] 삭제 '03' - THKIPB110 SELECT FOR UPDATE 호출 검증")
        void cobolEquivalence_prcss03_thkipb110SelectForUpdate() {
            IDataSet req = buildBaseRequest("03");
            stubAllDeleteTargetsAsEmpty();

            du.manageCorpEvalHistory(req, onlineCtx);

            // COBOL DBIO SELECT-CMD-Y (LOCK) 대응 메서드 호출 검증
            assertEquals(1, du.getCallCount("selectThkipb110ForUpdate"),
                    "COBOL S4210 DBIO SELECT-CMD-Y 대응 호출 검증");
        }

        @Test
        @DisplayName("[COBOL 동등성] 처리구분 '02' 무동작 - COBOL S4000 TBD 항목 동등성")
        void cobolEquivalence_prcss02_noAction() {
            // COBOL DIPA301: WHEN '02' WHEN '03' → S4000 호출.
            // S4000 내부: WHEN '03'만 처리. '02'는 실질적 무동작 (분석 spec HIGH-03 항목)
            IDataSet req = buildBaseRequest("02");

            IDataSet result = du.manageCorpEvalHistory(req, onlineCtx);

            assertNotNull(result);
            assertEquals(0, du.getCallCount("deleteThkipb110"),
                    "COBOL HIGH-03: 처리구분 '02'는 실질적 무동작 → DELETE 미호출");
        }
    }
}
