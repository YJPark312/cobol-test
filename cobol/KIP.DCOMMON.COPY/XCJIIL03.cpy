      ******************************************************************
      * 1. COPY NAME   : XCJIIL03                                      *
      * 2. COPY TYPE   : X ( PARAMETER COPY )                          *
      * 3. DESCRIPTION :만기일/역만기일 산출 COPYBOOK            *
      * -------------------------------------------------------------- *
      * 4. 항목설명   :                                              *
      *                                                                *
      *    **-------  RETURN정보       BYTE ----------**             *
      *    STAT                        : 상태코드                    *
      *      OK                        :  정상                       *
      *      ERROR                     :  오류                       *
      *      ABNORMAL                  :  비정상                     *
      *      SYSERROR                  :  시스템오류                 *
      *    LINE                        : 에러라인                    *
      *    ERRCD                       : 오류코드                    *
      *    TREAT-CD                    : 조치코드                    *
      *    SQL-CD                      : SQLCODE                       *
      *                                                                *
      *    **------- 입력　정보        ---------------**             *
      *    GROUP-CO-CD                 : 그룹회사코드                *
      *    DSTCD                       : 구분코드                    *
      *    YMD                         : 년월일                      *
      *    NODAY-NOMN                  : 일수월수                    *
      *    SPARE                       : 예비                        *
      *                                                                *
      *    **------- 출력　정보        ---------------**             *
      *    YMD                         : 년월일(만기일/역만기일) *
      *    SPARE                       : 예비                        *
      ******************************************************************
      * 5. HISTORY      :                                              *
      *     NO    DATE     USER     DESCRIPTION                        *
      *    ==== ======== ======== ==================================== *
      *    0001 20080414 김부경 최초 작성                        *
      ******************************************************************
           03  XCJIIL03-RETURN.
               05  XCJIIL03-R-STAT               PIC  X(002).
                   88  COND-XCJIIL03-OK        VALUE  '00'.
                   88  COND-XCJIIL03-ERROR     VALUE  '09'.
                   88  COND-XCJIIL03-ABNORMAL  VALUE  '98'.
                   88  COND-XCJIIL03-SYSERROR  VALUE  '99'.
               05  XCJIIL03-R-LINE               PIC  9(006).
               05  XCJIIL03-R-ERRCD              PIC  X(008).
               05  XCJIIL03-R-TREAT-CD           PIC  X(008).
               05  XCJIIL03-R-SQL-CD             PIC  S9(005)
                                                      LEADING SEPARATE.
           03  XCJIIL03-IN.
               05  XCJIIL03-I-GROUP-CO-CD        PIC  X(003).
               05  XCJIIL03-I-DSTCD              PIC  X(001).
               05  XCJIIL03-I-YMD                PIC  X(008).
               05  XCJIIL03-I-NODAY-NOMN         PIC  9(005).
               05  XCJIIL03-I-SPARE              PIC  X(050).
           03  XCJIIL03-OUT.
               05  XCJIIL03-O-YMD                PIC  X(008).
               05  XCJIIL03-O-SPARE              PIC  X(050).
      *=================================================================
      * END OF COPYBOOK XCJIIL03
      *=================================================================

