//TKIPDUMP JOB CLASS=T,MSGCLASS=X,NOTIFY=&SYSUID
//******************************************************************
//* 은행처리계(ZAPA) 조회 JCL (SYSTEM : DAPG, DB2APS)
//******************************************************************
//DUMP01   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DAPG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP12) -
      LIB('DB2APS.DSNC10.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
SELECT CB01.법인등록번호
     , VALUE(ADET.양방향고객암호화번호,' ')
     , VALUE(CA01.한신평그룹코드, ' ')
     , VALUE(CA01.한신평한글그룹명, ' ')
FROM  DB2DBA.THKABCB01 CB01
      LEFT OUTER JOIN DB2DBA.THKAAADET  ADET
      ON   ADET.그룹회사코드 = CB01.그룹회사코드
      AND  ADET.대체번호     = CB01.고객식별자
      LEFT OUTER JOIN DB2DBA.THKABCA01 CA01
      ON   CA01.그룹회사코드   = CB01.그룹회사코드
      AND  CA01.한신평그룹코드 = CB01.한신평그룹코드
WHERE CB01.그룹회사코드   = 'KB0'
AND   SUBSTR(CB01.사업자번호,4,5)
                            BETWEEN '81' AND '88'
AND   CB01.한신평그룹코드 <> '000'
AND   CB01.시스템최종처리일시
                            BETWEEN '20240218000000000000'
                                AND '20240219239999999999'
WITH UR;
/*
//
//
//
//
//
        SELECT COUNT(1)
  FROM   DB2DBA.THKIPB110
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPB111
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPB112
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPB113
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPB114
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPB116
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPB118
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPB119
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPB130
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPB131
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPB132
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPB133
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPC110
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPC120
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPC121
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPC130
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPC131
  WHERE 그룹회사코드 = 'KB0'
  AND  ((기업집단그룹코드 = '176' AND 기업집단등록코드 = '002')
     OR (기업집단그룹코드 = '866' AND 기업집단등록코드 = '003'))
  ;
/*
//
//
//
SELECT CB01.*
  FROM DB2DBA.THKABCA11 CA11
      ,DB2DBA.THKABCB01 CB01
 WHERE CB01.그룹회사코드   = CA11.그룹회사코드
   AND CB01.한신평업체코드 = CA11.한신평소속업체코드
   AND CA11.그룹회사코드   = 'KB0'
   AND CA11.한신평그룹코드 = '474'
   AND CA11.결산년
       = (SELECT MAX(결산년)
            FROM DB2DBA.THKABCA11
           WHERE
                 그룹회사코드   = 'KB0'
             AND 한신평그룹코드 = '474'
             AND 결산년        <= '2019'
             AND 외부감사대상여부구분 = '0'
         )
   AND CA11.외부감사대상여부구분 = '0'
   AND CA11.한신평작업시기구분
       = (SELECT MAX(한신평작업시기구분)
            FROM DB2DBA.THKABCA11
           WHERE
                 그룹회사코드   = 'KB0'
             AND 한신평그룹코드 = '474'
             AND 결산년         = '2019'
             AND 외부감사대상여부구분 = '0'
         )
/*
//
//
//
  SELECT *
  FROM   DB2DBA.THKIPA110
  WHERE  그룹회사코드   = 'KB0'
  AND    심사고객식별자 = '7012624638'
  ;
  SELECT *
  FROM   DB2DBA.THKIPB116
  WHERE  그룹회사코드   = 'KB0'
  AND    심사고객식별자 = '7012624638'
  ;
  SELECT B110.기업집단등록코드 || B110.기업집단그룹코드
       AS 기업집단코드
     , B110.기업집단명
     , B110.평가년월일
  FROM DB2DBA.THKIPB110 B110
     , (SELECT B116.그룹회사코드
             , B116.기업집단그룹코드
             , B116.기업집단등록코드
          FROM DB2DBA.THKIPB116 B116
             , DB2DBA.THKIPB110 B110
         WHERE B116.그룹회사코드 = 'KB0'
           AND B116.심사고객식별자 = '7012624638'
           AND B110.그룹회사코드     = B116.그룹회사코드
           AND B110.기업집단그룹코드 = B116.기업집단그룹코드
           AND B110.기업집단등록코드 = B116.기업집단등록코드
           AND B110.기업집단처리단계구분 = '6' --확정
        ORDER  BY B116.평가년월일 DESC
        FETCH  FIRST 1 ROWS ONLY
       ) X
 WHERE B110.그룹회사코드     = X.그룹회사코드
   AND B110.기업집단그룹코드 = X.기업집단그룹코드
   AND B110.기업집단등록코드 = X.기업집단등록코드
   AND B110.기업집단처리단계구분 = '6' --확정
 ;
  SELECT *
  FROM   DB2DBA.THKIPA112
  WHERE  그룹회사코드   = 'KB0'
  AND    심사고객식별자 = '7012624638'
  ;
/*
//
//
//
  SELECT *
  FROM   DB2DBA.THKIPB116
  WHERE  그룹회사코드   = 'KB0'
  AND    심사고객식별자 = '8013354493'
  AND    기업집단그룹코드 = 'X06'
  AND    기업집단등록코드 = 'GRS'
  ;
  DELETE
  FROM   DB2DBA.THKIPB116
  WHERE  그룹회사코드   = 'KB0'
  AND    심사고객식별자 = '7004837821'
  AND    기업집단그룹코드 = 'X06'
  AND    기업집단등록코드 = 'GRS'
  ;
  SELECT *
  FROM   DB2DBA.THKIPB116
  WHERE  그룹회사코드   = 'KB0'
  AND    심사고객식별자 = '7004837821'
  AND    기업집단그룹코드 = 'X06'
  AND    기업집단등록코드 = 'GRS'
  ;
/*
//
//
//
  SELECT *
  FROM   DB2DBA.THKIPB116
  WHERE  그룹회사코드 = 'KB0'
  AND    심사고객식별자 = '7002909920'
  ;
  SELECT B116.기업집단그룹코드
        ,B116.기업집단등록코드
        ,B116.평가년월일
        ,B116.일련번호
        ,VALUE(A111.기업집단명, ' ') 기업집단명
  FROM  DB2DBA.THKIPB116 B116
        LEFT OUTER JOIN DB2DBA.THKIPA111 A111
        ON   B116.그룹회사코드      = A111.그룹회사코드
        AND  B116.기업집단등록코드  = A111.기업집단등록코드
        AND  B116.기업집단그룹코드  = A111.기업집단그룹코드
  WHERE B116.그룹회사코드   = 'KB0'
  AND   B116.심사고객식별자 = '7002909920'
  ORDER BY  평가년월일 DESC
           ,일련번호   DESC
  ;
/*
//
//
//
//


  SELECT COUNT(1)
  FROM   DB2DBA.THKIPA110
  WHERE  그룹회사코드 = 'KB0'
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPA111
  WHERE  그룹회사코드 = 'KB0'
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPA112
  WHERE  그룹회사코드 = 'KB0'
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPA120
  WHERE  그룹회사코드 = 'KB0'
  ;
  SELECT COUNT(1)
  FROM   DB2DBA.THKIPA121
  WHERE  그룹회사코드 = 'KB0'
  ;
/*
//
//
