//TKIPMG01 JOB CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.DY.A110.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPA110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DATG,KIPA110'
//UNLDDN1  DD  DSN=KIP.DY.A110.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT "그룹회사코드"            , CHAR('#')
       , "심사고객식별자"          , CHAR('#')
       , "대표사업자번호"          , CHAR('#')
       , CHAR(REPLACE(REPLACE(
         CASE
         WHEN 대표업체명 LIKE '%#%'
         THEN REPLACE("대표업체명",'#','')
         ELSE "대표업체명"
         END, '[','［'),']','］'),48) 대표업체명 , CHAR('#')
       , "기업신용평가등급구분"    , CHAR('#')
       , "기업규모구분"            , CHAR('#')
       , "표준산업분류코드"        , CHAR('#')
       , "고객관리부점코드"        , CHAR('#')
       , "총여신금액"              , CHAR('#')
       , "여신잔액"                , CHAR('#')
       , "담보금액"                , CHAR('#')
       , "연체금액"                , CHAR('#')
       , "전년총여신금액"          , CHAR('#')
       , "기업집단그룹코드"        , CHAR('#')
       , "기업집단등록코드"        , CHAR('#')
       , "법인그룹연결등록구분"    , CHAR('#')
       , "법인그룹연결등록일시"    , CHAR('#')
       , "법인그룹연결직원번호"    , CHAR('#')
       , "기업여신정책구분"        , CHAR('#')
       , "기업여신정책일련번호"    , CHAR('#')
       , "기업여신정책내용"        , CHAR('#')
       , "조기경보사후관리구분"    , CHAR('#')
       , "시설자금한도"            , CHAR('#')
       , "시설자금잔액"            , CHAR('#')
       , "운전자금한도"            , CHAR('#')
       , "운전자금잔액"            , CHAR('#')
       , "투자금융한도"            , CHAR('#')
       , "투자금융잔액"            , CHAR('#')
       , "기타자금한도금액"        , CHAR('#')
       , "기타자금잔액"            , CHAR('#')
       , "파생상품거래한도"        , CHAR('#')
       , "파생상품거래잔액"        , CHAR('#')
       , "파생상품신용거래한도"    , CHAR('#')
       , "파생상품담보거래한도"    , CHAR('#')
       , "포괄신용공여설정한도"    , CHAR('#')
       , "시스템최종처리일시"      , CHAR('#')
       , "시스템최종사용자번호"    , CHAR('#')
  FROM   DB2DBA.THKIPA110
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//
//
//
//*---------------------------------------------------------------
//* STEP_01 : DELETE DB UNLOAD SAM FILE
//*---------------------------------------------------------------
//DELETE01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE KIP.SY.A112.UNLOAD
  DELETE KIP.SY.A113.UNLOAD
  DELETE KIP.SY.A130.UNLOAD
  DELETE KIP.SY.B110.UNLOAD
  DELETE KIP.SY.B112.UNLOAD
  DELETE KIP.SY.B113.UNLOAD
  DELETE KIP.SY.B114.UNLOAD
  DELETE KIP.SY.B116.UNLOAD
  DELETE KIP.SY.B118.UNLOAD
  DELETE KIP.SY.B119.UNLOAD
  DELETE KIP.SY.B131.UNLOAD
  DELETE KIP.SY.B132.UNLOAD
  DELETE KIP.SY.C110.UNLOAD
  DELETE KIP.SY.C120.UNLOAD
  DELETE KIP.SY.C121.UNLOAD
  DELETE KIP.SY.C130.UNLOAD
  DELETE KIP.SY.C131.UNLOAD
  DELETE KIP.SY.C140.UNLOAD
  DELETE KIP.SY.M510.UNLOAD
  DELETE KIP.SY.M511.UNLOAD
  DELETE KIP.SY.M512.UNLOAD
  DELETE KIP.SY.M513.UNLOAD
  DELETE KIP.SY.M514.UNLOAD
  DELETE KIP.SY.M516.UNLOAD
  DELETE KIP.SY.M517.UNLOAD
  SET  MAXCC = 00
/*
//*---------------------------------------------------------------
//KIPA112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPA112'
//UNLDDN1  DD  DSN=KIP.SY.A112.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                   , CHAR('#')
       , 심사고객식별자                 , CHAR('#')
       , 기업집단그룹코드               , CHAR('#')
       , 기업집단등록코드               , CHAR('#')
       , CHAR(일련번호)                 , CHAR('#')
       , 대표사업자번호                 , CHAR('#')
       , CASE
         WHEN 대표업체명 = ' '
         THEN CHAR(' ')
         ELSE SUBSTR(REPLACE(대표업체명,']',''),1,48)
         END  대표업체명                , CHAR('#')
       , 등록변경거래구분               , CHAR('#')
       , 수기변경구분                   , CHAR('#')
       , 등록부점코드                   , CHAR('#')
       , 등록일시                       , CHAR('#')
       , 등록직원번호                   , CHAR('#')
       , CASE
         WHEN 등록직원명 = ' '
         THEN CHAR(' ')
         ELSE SUBSTR( 등록직원명 ,1,38)
         END  등록직원명                , CHAR('#')
       , 시스템최종처리일시             , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPA112
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPA113'
//UNLDDN1  DD  DSN=KIP.SY.A113.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                   ,CHAR('#')
       , 대체고객식별자                 ,CHAR('#')
       , 기준년도                       ,CHAR('#')
       , 등록년월일                     ,CHAR('#')
       , CASE
         WHEN LENGTH(RTRIM(업체명)) > 38
         THEN CHAR('  ')
         ELSE SUBSTR(업체명,1,38)
         END
       , CHAR('#')
       , 기업집단등록코드               ,CHAR('#')
       , 기업집단그룹코드               ,CHAR('#')
       , 고객식별자                     ,CHAR('#')
       , 등록부점코드                   ,CHAR('#')
       , 등록직원번호                   ,CHAR('#')
       , 시스템최종처리일시             ,CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPA113
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPA130'
//UNLDDN1  DD  DSN=KIP.SY.A130.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                   , CHAR('#')
       , 기업집단그룹코드               , CHAR('#')
       , 기업집단등록코드               , CHAR('#')
       , 등록년월일                     , CHAR('#')
       , 고객식별자                     , CHAR('#')
       , CASE
         WHEN LENGTH(RTRIM(업체명 )) > 40
         THEN CHAR(' ')
         ELSE SUBSTR(업체명 ,1,40)
         END  업체명                    , CHAR('#')
       , 평가기준년                     , CHAR('#')
       , "평가대상여부1"                , CHAR('#')
       , 전년                           , CHAR('#')
       , "평가대상여부2"                , CHAR('#')
       , 전전년                         , CHAR('#')
       , "평가대상여부3"                , CHAR('#')
       , 등록부점코드                   , CHAR('#')
       , 등록직원번호                   , CHAR('#')
       , 시스템최종처리일시             , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPA130
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB110'
//UNLDDN1  DD  DSN=KIP.SY.B110.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                   , CHAR('#')
       , 기업집단그룹코드               , CHAR('#')
       , 기업집단등록코드               , CHAR('#')
       , 평가년월일                     , CHAR('#')
       , CASE
         WHEN 기업집단명 = ' '
         THEN CHAR(' ')
         ELSE SUBSTR( 기업집단명 ,1,70)
         END  기업집단명                , CHAR('#')
       , 주채무계열여부                 , CHAR('#')
       , 기업집단평가구분               , CHAR('#')
       , 평가확정년월일                 , CHAR('#')
       , 평가기준년월일                 , CHAR('#')
       , 기업집단처리단계구분           , CHAR('#')
       , 등급조정구분                   , CHAR('#')
       , 조정단계번호구분               , CHAR('#')
       , CASE
         WHEN "안정성재무산출값1" = 0
         THEN CHAR('0.0')
         ELSE CHAR("안정성재무산출값1")
         END                              , CHAR('#')
       , CASE
         WHEN "안정성재무산출값2" = 0
         THEN CHAR('0.0')
         ELSE CHAR("안정성재무산출값2")
         END                              , CHAR('#')
       , CASE
         WHEN "수익성재무산출값1" = 0
         THEN CHAR('0.0')
         ELSE CHAR("수익성재무산출값1")
         END                              , CHAR('#')
       , CASE
         WHEN "수익성재무산출값2" = 0
         THEN CHAR('0.0')
         ELSE CHAR("수익성재무산출값2")
         END                              , CHAR('#')
       , CASE
         WHEN "현금흐름재무산출값" = 0
         THEN CHAR('0.0')
         ELSE CHAR("현금흐름재무산출값")
         END                              , CHAR('#')
       , CASE
         WHEN "재무점수" = 0
         THEN CHAR('0.0')
         ELSE CHAR("재무점수")
         END                              , CHAR('#')
       , CASE
         WHEN "비재무점수" = 0
         THEN CHAR('0.0')
         ELSE CHAR("비재무점수")
         END                              , CHAR('#')
       , CASE
         WHEN "결합점수" = 0
         THEN CHAR('0.0')
         ELSE CHAR("결합점수")
         END                              , CHAR('#')
       , 예비집단등급구분               , CHAR('#')
       , 최종집단등급구분               , CHAR('#')
       , 구등급매핑등급                 , CHAR('#')
       , 유효년월일                     , CHAR('#')
       , 평가직원번호                   , CHAR('#')
       , CASE
         WHEN 평가직원명 = ' '
         THEN CHAR(' ')
         ELSE SUBSTR( 평가직원명 ,1,40)
         END  평가직원명                , CHAR('#')
       , 평가부점코드                   , CHAR('#')
       , 관리부점코드                   , CHAR('#')
       , 시스템최종처리일시             , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPB110
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB112  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB112'
//UNLDDN1  DD  DSN=KIP.SY.B112.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드             , CHAR('#')
       , 기업집단그룹코드         , CHAR('#')
       , 기업집단등록코드         , CHAR('#')
       , 평가년월일               , CHAR('#')
       , 분석지표분류구분         , CHAR('#')
       , 재무분석보고서구분       , CHAR('#')
       , 재무항목코드             , CHAR('#')
       , CHAR(기준년재무비율)     , CHAR('#')
       , CHAR(기준년산업평균값)   , CHAR('#')
       , CHAR(기준년항목금액)     , CHAR('#')
       , CHAR(기준년구성비율)     , CHAR('#')
       , CHAR(기준년증감률)       , CHAR('#')
       , CHAR("N1년전재무비율")   , CHAR('#')
       , CHAR("N1년전산업평균값") , CHAR('#')
       , CHAR("N1년전항목금액")   , CHAR('#')
       , CHAR("N1년전구성비율")   , CHAR('#')
       , CHAR("N1년전증감률" )    , CHAR('#')
       , CHAR("N2년전재무비율")   , CHAR('#')
       , CHAR("N2년전산업평균값") , CHAR('#')
       , CHAR("N2년전항목금액")   , CHAR('#')
       , CHAR("N2년전구성비율")   , CHAR('#')
       , CHAR("N2년전증감률")     , CHAR('#')
       , 시스템최종처리일시       , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPB112
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB113  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB113'
//UNLDDN1  DD  DSN=KIP.SY.B113.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 기업집단그룹코드       , CHAR('#')
       , 기업집단등록코드       , CHAR('#')
       , 평가년월일             , CHAR('#')
       , 재무분석보고서구분     , CHAR('#')
       , 재무항목코드           , CHAR('#')
       , 사업부문번호           , CHAR('#')
       , CASE
         WHEN 사업부문구분명 = ' '
         THEN CHAR(' ')
         ELSE SUBSTR( 사업부문구분명 ,1,30)
         END  사업부문구분명    , CHAR('#')
       , CHAR(기준년항목금액)   , CHAR('#')
       , CHAR(기준년비율 )      , CHAR('#')
       , CHAR(기준년업체수)     , CHAR('#')
       , CHAR("N1년전항목금액") , CHAR('#')
       , CHAR("N1년전비율")     , CHAR('#')
       , CHAR("N1년전업체수")   , CHAR('#')
       , CHAR("N2년전항목금액") , CHAR('#')
       , CHAR("N2년전비율")     , CHAR('#')
       , CHAR("N2년전업체수")   , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPB113
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB114  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB114'
//UNLDDN1  DD  DSN=KIP.SY.B114.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                      , CHAR('#')
       , 기업집단그룹코드                  , CHAR('#')
       , 기업집단등록코드                  , CHAR('#')
       , 평가년월일                        , CHAR('#')
       , 기업집단항목평가구분              , CHAR('#')
       , 항목평가결과구분                  , CHAR('#')
       , 직전항목평가결과구분              , CHAR('#')
       , 시스템최종처리일시                , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPB114
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB116  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB116'
//UNLDDN1  DD  DSN=KIP.SY.B116.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                           , CHAR('#')
       , 기업집단그룹코드                       , CHAR('#')
       , 기업집단등록코드                       , CHAR('#')
       , 평가년월일                             , CHAR('#')
       , CHAR(일련번호)                         , CHAR('#')
       , 심사고객식별자                         , CHAR('#')
       , CASE
         WHEN LENGTH(RTRIM( 법인명 )) > 40
         THEN CHAR('  ')
         ELSE SUBSTR(법인명 ,1,40)
         END                                      , CHAR('#')
       , 설립년월일                             , CHAR('#')
       , 한신평기업공개구분                     , CHAR('#')
       , CASE
         WHEN LENGTH(RTRIM(대표자명 )) > 40
         THEN CHAR(' ')
         ELSE SUBSTR(대표자명 ,1,40)
         END  대표자명                          , CHAR('#')
       , CASE
         WHEN LENGTH(RTRIM(업종명)) > 40
         THEN CHAR(' ')
         ELSE SUBSTR(업종명 ,1,40)
         END  업종명                            , CHAR('#')
       , 결산기준월                             , CHAR('#')
       , CHAR(총자산금액)                       , CHAR('#')
       , CHAR(매출액)                           , CHAR('#')
       , CHAR(자본총계금액)                     , CHAR('#')
       , CHAR(순이익)                           , CHAR('#')
       , CHAR(영업이익)                         , CHAR('#')
       , CHAR(금융비용)                         , CHAR('#')
       , CHAR("EBITDA금액")                     , CHAR('#')
       , CHAR("기업집단부채비율")               , CHAR('#')
       , CHAR("차입금의존도율")                 , CHAR('#')
       , CHAR(순영업현금흐름금액)               , CHAR('#')
       , 시스템최종처리일시                     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPB116
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB118  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB118'
//UNLDDN1  DD  DSN=KIP.SY.B118.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드              , CHAR('#')
       , 기업집단그룹코드          , CHAR('#')
       , 기업집단등록코드          , CHAR('#')
       , 평가년월일                , CHAR('#')
       , CASE
         WHEN 등급조정구분 = ' '
         THEN CHAR('0')
         ELSE 등급조정구분
         END  등급조정구분         , CHAR('#')
       , CASE
         WHEN 등급조정사유내용 = ' '
         THEN CHAR(' ')
         ELSE CHAR(SUBSTR(RTRIM(등급조정사유내용), 1, 300))
         END  등급조정사유내용     , CHAR('#')
       , 시스템최종처리일시        , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPB118
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB119  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB119'
//UNLDDN1  DD  DSN=KIP.SY.B119.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT  그룹회사코드          , CHAR('#')
       ,  기업집단그룹코드      , CHAR('#')
       ,  기업집단등록코드      , CHAR('#')
       ,  평가년월일            , CHAR('#')
       ,  모델계산식대분류구분  , CHAR('#')
       ,  모델계산식소분류코드  , CHAR('#')
       ,  CHAR(재무비율산출값)  , CHAR('#')
       ,  시스템최종처리일시    , CHAR('#')
       ,  시스템최종사용자번호
  FROM   DB2DBA.THKIPB119
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB131  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB131'
//UNLDDN1  DD  DSN=KIP.SY.B131.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                   , CHAR('#')
       , 기업집단그룹코드               , CHAR('#')
       , 기업집단등록코드               , CHAR('#')
       , 평가년월일                     , CHAR('#')
       , CHAR(재적위원수)               , CHAR('#')
       , CHAR(출석위원수)               , CHAR('#')
       , CHAR(승인위원수)               , CHAR('#')
       , CHAR(불승인위원수)             , CHAR('#')
       , 합의구분                       , CHAR('#')
       , 종합승인구분                   , CHAR('#')
       , 승인년월일                     , CHAR('#')
       , 승인부점코드                   , CHAR('#')
       , 시스템최종처리일시             , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPB131
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB132  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB132'
//UNLDDN1  DD  DSN=KIP.SY.B132.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                   , CHAR('#')
       , 기업집단그룹코드               , CHAR('#')
       , 기업집단등록코드               , CHAR('#')
       , 평가년월일                     , CHAR('#')
       , 승인위원직원번호               , CHAR('#')
       , 승인위원구분                   , CHAR('#')
       , 승인구분                       , CHAR('#')
       , 시스템최종처리일시             , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPB132
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPC110'
//UNLDDN1  DD  DSN=KIP.SY.C110.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드             , CHAR('#')
       , 기업집단그룹코드         , CHAR('#')
       , 기업집단등록코드         , CHAR('#')
       , 결산년월                 , CHAR('#')
       , 심사고객식별자           , CHAR('#')
       , CASE
         WHEN LENGTH(RTRIM(법인명)) > 40
         THEN CHAR(' ')
         ELSE SUBSTR(법인명 ,1,40)
         END  법인명              , CHAR('#')
       , 모기업고객식별자         , CHAR('#')
       , CASE
         WHEN LENGTH(RTRIM(모기업명)) > 30
         THEN CHAR(' ')
         ELSE SUBSTR(모기업명 ,1,30)
         END  모기업명            , CHAR('#')
       , 최상위지배기업여부       , CHAR('#')
       , 연결재무제표존재여부     , CHAR('#')
       , 개별재무제표존재여부     , CHAR('#')
       , 재무제표반영여부         , CHAR('#')
       , 시스템최종처리일시       , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPC110
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC120  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPC120'
//UNLDDN1  DD  DSN=KIP.SY.C120.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,500),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드            , CHAR('#')
       , 기업집단그룹코드        , CHAR('#')
       , 기업집단등록코드        , CHAR('#')
       , 재무분석결산구분        , CHAR('#')
       , 기준년                  , CHAR('#')
       , 결산년                  , CHAR('#')
       , 재무분석보고서구분      , CHAR('#')
       , 재무항목코드            , CHAR('#')
       , 재무분석자료원구분      , CHAR('#')
       , CHAR(재무제표항목금액)  , CHAR('#')
       , CHAR(재무항목구성비율)  , CHAR('#')
       , CHAR(결산년합계업체수)  , CHAR('#')
       , 시스템최종처리일시      , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPC120
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC121  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPC121'
//UNLDDN1  DD  DSN=KIP.SY.C121.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,500),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 기업집단그룹코드       , CHAR('#')
       , 기업집단등록코드       , CHAR('#')
       , 재무분석결산구분       , CHAR('#')
       , 기준년                 , CHAR('#')
       , 결산년                 , CHAR('#')
       , 재무분석보고서구분     , CHAR('#')
       , 재무항목코드           , CHAR('#')
       , 재무분석자료원구분     , CHAR('#')
       , CHAR(기업집단재무비율) , CHAR('#')
       , CHAR(분자값)           , CHAR('#')
       , CHAR(분모값)           , CHAR('#')
       , CHAR(결산년합계업체수) , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPC121
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC130  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPC130'
//UNLDDN1  DD  DSN=KIP.SY.C130.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,100),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 기업집단그룹코드       , CHAR('#')
       , 기업집단등록코드       , CHAR('#')
       , 재무분석결산구분       , CHAR('#')
       , 기준년                 , CHAR('#')
       , 결산년                 , CHAR('#')
       , 재무분석보고서구분     , CHAR('#')
       , 재무항목코드           , CHAR('#')
       , CHAR(재무제표항목금액) , CHAR('#')
       , CHAR(재무항목구성비율) , CHAR('#')
       , CHAR(결산년합계업체수) , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPC130
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC131  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPC131'
//UNLDDN1  DD  DSN=KIP.SY.C131.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(100,50),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 기업집단그룹코드       , CHAR('#')
       , 기업집단등록코드       , CHAR('#')
       , 재무분석결산구분       , CHAR('#')
       , 기준년                 , CHAR('#')
       , 결산년                 , CHAR('#')
       , 재무분석보고서구분     , CHAR('#')
       , 재무항목코드           , CHAR('#')
       , CHAR(기업집단재무비율) , CHAR('#')
       , CHAR(분자값)           , CHAR('#')
       , CHAR(분모값)           , CHAR('#')
       , CHAR(결산년합계업체수) , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPC131
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPC140  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPC140'
//UNLDDN1  DD  DSN=KIP.SY.C140.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,500),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드           , CHAR('#')
       , 기업집단그룹코드       , CHAR('#')
       , 기업집단등록코드       , CHAR('#')
       , 심사고객식별자         , CHAR('#')
       , 재무분석결산구분       , CHAR('#')
       , 기준년                 , CHAR('#')
       , 결산년                 , CHAR('#')
       , 재무분석보고서구분     , CHAR('#')
       , 재무항목코드           , CHAR('#')
       , 재무분석자료원구분     , CHAR('#')
       , CHAR(재무제표항목금액) , CHAR('#')
       , CHAR(재무항목구성비율) , CHAR('#')
       , 시스템최종처리일시     , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPC140
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM510  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPM510'
//UNLDDN1  DD  DSN=KIP.SY.M510.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,500),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드               , CHAR('#')
       , 기업신용평가모델구분       , CHAR('#')
       , 모형규모구분               , CHAR('#')
       , 모델적용년월일             , CHAR('#')
       , 모델계산식대분류구분       , CHAR('#')
       , 모델계산식소분류코드       , CHAR('#')
       , 계산유형구분               , CHAR('#')
       , CHAR(SUBSTR(RTRIM(분자계산식내용), 1, 260)) , CHAR('#')
       , CHAR(SUBSTR(RTRIM(분모계산식내용), 1, 260)) , CHAR('#')
       , CASE
         WHEN 최종계산식내용 = ' '
         THEN CHAR(' ')
         ELSE CHAR(SUBSTR(RTRIM(최종계산식내용), 1, 100))
         END  최종계산식내용        , CHAR('#')
       , 시스템최종처리일시         , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPM510
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM511  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPM511'
//UNLDDN1  DD  DSN=KIP.SY.M511.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,500),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드               , CHAR('#')
       , 기업신용평가모델구분       , CHAR('#')
       , 모형규모구분               , CHAR('#')
       , 모델적용년월일             , CHAR('#')
       , 모델계산식대분류구분       , CHAR('#')
       , 모델계산식소분류코드       , CHAR('#')
       , 변환유형구분               , CHAR('#')
       , CASE
         WHEN 변환계산식내용 = ' '
         THEN CHAR(' ')
         ELSE CHAR(RTRIM(변환계산식내용),110)
         END  변환계산식내용        , CHAR('#')
       , 시스템최종처리일시         , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPM511
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM512  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPM512'
//UNLDDN1  DD  DSN=KIP.SY.M512.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,500),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드               , CHAR('#')
       , 기업신용평가모델구분       , CHAR('#')
       , 모형규모구분               , CHAR('#')
       , 모델적용년월일             , CHAR('#')
       , 모델계산식대분류구분       , CHAR('#')
       , 모델계산식소분류코드       , CHAR('#')
       , 변환유형구분               , CHAR('#')
       , CASE
         WHEN 변환계산식내용 = ' '
         THEN CHAR(' ')
         ELSE CHAR(RTRIM(변환계산식내용), 110)
         END  변환계산식내용        , CHAR('#')
       , 시스템최종처리일시         , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPM512
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM513  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPM513'
//UNLDDN1  DD  DSN=KIP.SY.M513.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,500),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드               , CHAR('#')
       , 기업신용평가모델구분       , CHAR('#')
       , 모형규모구분               , CHAR('#')
       , 모델적용년월일             , CHAR('#')
       , 모델계산식대분류구분       , CHAR('#')
       , 모델계산식소분류코드       , CHAR('#')
       , 계산유형구분               , CHAR('#')
       , CASE
         WHEN 최종계산식내용 = ' '
         THEN CHAR(' ')
         ELSE CHAR(RTRIM(최종계산식내용), 120)
         END  최종계산식내용        , CHAR('#')
       , 시스템최종처리일시         , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPM513
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM514  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPM514'
//UNLDDN1  DD  DSN=KIP.SY.M514.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,500),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드               , CHAR('#')
       , 기업신용평가모델구분       , CHAR('#')
       , 모형규모구분               , CHAR('#')
       , 모델적용년월일             , CHAR('#')
       , 모델계산식대분류구분       , CHAR('#')
       , 모델계산식소분류코드       , CHAR('#')
       , CHAR(하한값)               , CHAR('#')
       , CHAR(상한값)               , CHAR('#')
       , CHAR("점수변환가중치1값"), CHAR('#')
       , CHAR("점수변환가중치2값"), CHAR('#')
       , 계산유형구분               , CHAR('#')
       , CASE
         WHEN 최종계산식내용 = ' '
         THEN CHAR(' ')
         ELSE CHAR(RTRIM(최종계산식내용), 120)
         END  최종계산식내용        , CHAR('#')
       , 시스템최종처리일시         , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPM514
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM516  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPM516'
//UNLDDN1  DD  DSN=KIP.SY.M516.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,500),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드         , CHAR('#')
       , 적용년월일           , CHAR('#')
       , 비재무항목번호       , CHAR('#')
       , CHAR(비재무항목점수) , CHAR('#')
       , CHAR(가중치최상점수) , CHAR('#')
       , CHAR(가중치상점수  ) , CHAR('#')
       , CHAR(가중치중점수  ) , CHAR('#')
       , CHAR(가중치하점수  ) , CHAR('#')
       , CHAR(가중치최하점수) , CHAR('#')
       , 시스템최종처리일시   , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPM516
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPM517  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPM517'
//UNLDDN1  DD  DSN=KIP.SY.M517.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,500),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드        , CHAR('#')
       , 적용년월일          , CHAR('#')
       , CHAR(하한구간평점)  , CHAR('#')
       , CHAR(상한구간평점)  , CHAR('#')
       , 예비집단등급구분    , CHAR('#')
       , 신예비집단등급구분  , CHAR('#')
       , 시스템최종처리일시  , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPM517
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*----------------------------------------------------------------*/
//* STEP_21 : 자료　기업집단서버NDM전송처리                    */
//*----------------------------------------------------------------*/
//****JOBPARM SYSAFF=ZAPH
//NDMPROC1  EXEC PGM=DMBATCH,COND=(4,LT)
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMPH.NETMAP
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMPH.MSG
//DMPUBLIB  DD DISP=SHR,DSN=NDM.PBAT.PROC
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
  SIGNON USERID=(KIP000N,) CASE=YES ESF=NO
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.A112.UNLOAD           -
         &TODSN=tskipa112.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.A113.UNLOAD           -
         &TODSN=tskipa113.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.A130.UNLOAD           -
         &TODSN=tskipa130.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B110.UNLOAD           -
         &TODSN=tskipb110.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B112.UNLOAD           -
         &TODSN=tskipb112.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B113.UNLOAD           -
         &TODSN=tskipb113.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B114.UNLOAD           -
         &TODSN=tskipb114.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B116.UNLOAD           -
         &TODSN=tskipb116.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B118.UNLOAD           -
         &TODSN=tskipb118.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B119.UNLOAD           -
         &TODSN=tskipb119.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B131.UNLOAD           -
         &TODSN=tskipb131.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.B132.UNLOAD           -
         &TODSN=tskipb132.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.C110.UNLOAD           -
         &TODSN=tskipc110.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.C120.UNLOAD           -
         &TODSN=tskipc120.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.C121.UNLOAD           -
         &TODSN=tskipc121.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.C130.UNLOAD           -
         &TODSN=tskipc130.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.C131.UNLOAD           -
         &TODSN=tskipc131.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.C140.UNLOAD           -
         &TODSN=tskipc140.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M510.UNLOAD           -
         &TODSN=tskipm510.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M511.UNLOAD           -
         &TODSN=tskipm511.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M512.UNLOAD           -
         &TODSN=tskipm512.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M513.UNLOAD           -
         &TODSN=tskipm513.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M514.UNLOAD           -
         &TODSN=tskipm514.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M516.UNLOAD           -
         &TODSN=tskipm516.dat
    SUBMIT PROC=TKIPSCE1 MAXDELAY=UNLIMITED  -
         &FRDSN=KIP.SY.M517.UNLOAD           -
         &TODSN=tskipm517.dat
  SIGNOFF
/*
//
//
//
//
//****JOBPARM SYSAFF=ZADA
//NDMPROC   EXEC PGM=DMBATCH,PARM=(YYSLYNN)
//STEPLIB   DD DISP=SHR,DSN=MVS.NDMDA.LINKLIB
//DMNETMAP  DD DISP=SHR,DSN=MVS.NDMDA.NETMAP
//DMMSGFIL  DD DISP=SHR,DSN=MVS.NDMDA.MSG
//DMPUBLIB  DD DISP=SHR,DSN=NDM.BEAI.EGIP.PROC
//*DMPUBLIB  DD DISP=SHR,DSN=NDM.DTMP.PROC
//DMPRINT   DD  SYSOUT=*
//SYSIN     DD  *
//
//
//
//
//*---------------------------------------------------------------
//KIPA110  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPA110'
//UNLDDN1  DD  DSN=KIP.SY.A110.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                , CHAR('#')
       , 심사고객식별자              , CHAR('#')
       , 대표사업자번호              , CHAR('#')
       , CHAR(REPLACE(REPLACE(REPLACE(
         CASE
         WHEN 대표업체명 = ' '
         THEN CHAR(' ')
         ELSE SUBSTR(TRIM(대표업체명) ,1,48)
         END, '#', ''),'[','［'),']','］'),48)
         대표업체명   , CHAR('#')
       , 기업신용평가등급구분        , CHAR('#')
       , 기업규모구분                , CHAR('#')
       , 표준산업분류코드            , CHAR('#')
       , 고객관리부점코드            , CHAR('#')
       , CHAR(총여신금액)            , CHAR('#')
       , CHAR(여신잔액)              , CHAR('#')
       , CHAR(담보금액)              , CHAR('#')
       , CHAR(연체금액)              , CHAR('#')
       , CHAR(전년총여신금액)        , CHAR('#')
       , 기업집단그룹코드            , CHAR('#')
       , 기업집단등록코드            , CHAR('#')
       , 법인그룹연결등록구분        , CHAR('#')
       , 법인그룹연결등록일시        , CHAR('#')
       , 법인그룹연결직원번호        , CHAR('#')
       , 기업여신정책구분            , CHAR('#')
       , CHAR(기업여신정책일련번호)  , CHAR('#')
       , CASE
         WHEN 기업여신정책내용 = ' '
         THEN CHAR(' ')
         ELSE SUBSTR( 기업여신정책내용 ,1,100)
         END  기업여신정책내용       , CHAR('#')
       , 조기경보사후관리구분        , CHAR('#')
       , CHAR(시설자금한도)          , CHAR('#')
       , CHAR(시설자금잔액)          , CHAR('#')
       , CHAR(운전자금한도)          , CHAR('#')
       , CHAR(운전자금잔액)          , CHAR('#')
       , CHAR(투자금융한도)          , CHAR('#')
       , CHAR(투자금융잔액)          , CHAR('#')
       , CHAR(기타자금한도금액)      , CHAR('#')
       , CHAR(기타자금잔액)          , CHAR('#')
       , CHAR(파생상품거래한도)      , CHAR('#')
       , CHAR(파생상품거래잔액)      , CHAR('#')
       , CHAR(파생상품신용거래한도)  , CHAR('#')
       , CHAR(파생상품담보거래한도)  , CHAR('#')
       , CHAR(포괄신용공여설정한도 ) , CHAR('#')
       , 시스템최종처리일시          , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPA110
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPB111  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPB111'
//UNLDDN1  DD  DSN=KIP.SY.B111.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                   , CHAR('#')
       , 기업집단그룹코드               , CHAR('#')
       , 기업집단등록코드               , CHAR('#')
       , 평가년월일                     , CHAR('#')
       , CHAR(일련번호)                 , CHAR('#')
       , 장표출력여부                   , CHAR('#')
       , 연혁년월일                     , CHAR('#')
       , CHAR(REPLACE(REPLACE(REPLACE(
         CASE
         WHEN 연혁내용 = ' '
         THEN CHAR(' ')
         ELSE TRIM(연혁내용)
         END, '#', ''),'[','［'),']','］')
         ,198) AS   연혁내용           , CHAR('#')
       , 시스템최종처리일시             , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPB111
  WHERE  그룹회사코드  = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA120  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPA120'
//UNLDDN1  DD  DSN=KIP.SY.A120.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(1000,500),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                   , CHAR('#')
       , 기준년월                       , CHAR('#')
       , 심사고객식별자                 , CHAR('#')
       , 대표사업자번호                 , CHAR('#')
       , CASE
         WHEN 대표업체명 = ' '
         THEN CHAR(' ')
         ELSE REPLACE(SUBSTR( 대표업체명 ,1,48),']','')
         END  대표업체명                , CHAR('#')
       , 기업신용평가등급구분           , CHAR('#')
       , 기업규모구분                   , CHAR('#')
       , 표준산업분류코드               , CHAR('#')
       , 고객관리부점코드               , CHAR('#')
       , CHAR(총여신금액)               , CHAR('#')
       , CHAR(여신잔액)                 , CHAR('#')
       , CHAR(담보금액)                 , CHAR('#')
       , CHAR(연체금액)                 , CHAR('#')
       , CHAR(전년총여신금액)           , CHAR('#')
       , 기업집단그룹코드               , CHAR('#')
       , 기업집단등록코드               , CHAR('#')
       , 법인그룹연결등록구분           , CHAR('#')
       , 법인그룹연결등록일시           , CHAR('#')
       , 법인그룹연결직원번호           , CHAR('#')
       , 기업여신정책구분               , CHAR('#')
       , CHAR(기업여신정책일련번호)     , CHAR('#')
       , CASE
         WHEN 기업여신정책내용 = ' '
         THEN CHAR(' ')
         ELSE SUBSTR( 기업여신정책내용 ,1,100)
         END  기업여신정책내용          , CHAR('#')
       , 조기경보사후관리구분           , CHAR('#')
       , CHAR(시설자금한도)             , CHAR('#')
       , CHAR(시설자금잔액)             , CHAR('#')
       , CHAR(운전자금한도)             , CHAR('#')
       , CHAR(운전자금잔액)             , CHAR('#')
       , CHAR(투자금융한도)             , CHAR('#')
       , CHAR(투자금융잔액)             , CHAR('#')
       , CHAR(기타자금한도금액)         , CHAR('#')
       , CHAR(기타자금잔액)             , CHAR('#')
       , CHAR(파생상품거래한도)         , CHAR('#')
       , CHAR(파생상품거래잔액)         , CHAR('#')
       , CHAR(파생상품신용거래한도)     , CHAR('#')
       , CHAR(파생상품담보거래한도)     , CHAR('#')
       , CHAR(포괄신용공여설정한도)     , CHAR('#')
       , 시스템최종처리일시             , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPA120
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA121  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPA121'
//UNLDDN1  DD  DSN=KIP.SY.A121.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(500,100),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                   , CHAR('#')
       , 기준년월                       , CHAR('#')
       , 기업집단그룹코드               , CHAR('#')
       , 기업집단등록코드               , CHAR('#')
       , CASE
         WHEN 기업집단명 = ' '
         THEN CHAR(' ')
         ELSE SUBSTR( 기업집단명 ,1,68)
         END  기업집단명             , CHAR('#')
       , 주채무계열그룹여부             , CHAR('#')
       , 기업군관리그룹구분             , CHAR('#')
       , 기업여신정책구분               , CHAR('#')
       , CHAR(기업여신정책일련번호)     , CHAR('#')
       , CASE
         WHEN 기업여신정책내용 = ' '
         THEN CHAR(' ')
         ELSE SUBSTR( 기업여신정책내용 ,1,100)
         END  기업여신정책내용          , CHAR('#')
       , CHAR(총여신금액)               , CHAR('#')
       , 시스템최종처리일시             , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPA121
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
//*---------------------------------------------------------------
//KIPA111  EXEC PGM=INZUTILB,REGION=0M,DYNAMNBR=99,
//         PARM='DAPG,KIPA111'
//UNLDDN1  DD  DSN=KIP.SY.A111.UNLOAD,DISP=(NEW,CATLG,DELETE),
//         UNIT=3390,SPACE=(CYL,(10,10),RLSE)
//LOADDDN1 DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  UNLOAD TABLESPACE DB2 YES LOCK NO QUIESCE NO  QUIESCECAT NO
  SELECT 그룹회사코드                   , CHAR('#')
       , 기업집단그룹코드               , CHAR('#')
       , 기업집단등록코드               , CHAR('#')
       , CHAR(REPLACE(REPLACE(
         CASE
         WHEN 기업집단명 = ' '
         THEN CHAR(' ')
         ELSE SUBSTR(TRIM(기업집단명) ,1,50)
         END ,'마인드웨어웤스','마인드웨어웍스')
             ,'크린랲'        ,'크린랩'))
         AS 기업집단명                  , CHAR('#')
       , 주채무계열그룹여부             , CHAR('#')
       , CASE
         WHEN 기업군관리그룹구분 = ' '
         THEN CHAR('00')
         ELSE 기업군관리그룹구분
         END  기업군관리그룹구분        , CHAR('#')
       , 기업여신정책구분               , CHAR('#')
       , CHAR(기업여신정책일련번호)     , CHAR('#')
       , CASE
         WHEN 기업여신정책내용 = ' '
         THEN CHAR(' ')
         ELSE CHAR(SUBSTR(기업여신정책내용 ,1,100))
         END  기업여신정책내용          , CHAR('#')
       , CHAR(총여신금액)               , CHAR('#')
       , 시스템최종처리일시             , CHAR('#')
       , 시스템최종사용자번호
  FROM   DB2DBA.THKIPA111
  WHERE 그룹회사코드 = 'KB0'
  WITH UR
  OUTDDN (UNLDDN1)
  LOADDDN LOADDDN1
/*
