# 업무 명세서: 기업집단재무분석조회 (Corporate Group Financial Analysis Inquiry)

## 문서 관리
- **버전:** 1.1
- **일자:** 2025-10-01
- **표준:** IEEE 830-1998
- **워크패키지 ID:** WP-027
- **진입점:** AIP4A67
- **업무 도메인:** TRANSACTION
- **수정사항:** 실제 데이터베이스 테이블 구조에 맞게 업데이트

## 목차
1. 개요
2. 데이터베이스 테이블 구조
3. 업무 엔티티
4. 업무 규칙
5. 업무 기능
6. 프로세스 흐름
7. 레거시 구현 참조

## 1. 개요

본 워크패키지는 트랜잭션 처리 도메인에서 기업집단 재무분석 조회 시스템을 구현합니다. 이 시스템은 실제 존재하는 데이터베이스 테이블들을 활용하여 기업집단의 그룹정보, 월별 관계연결정보, 재무대상관리정보를 조회하고 분석하는 기능을 제공합니다.

업무 목적은 다음과 같습니다:
- 기업집단 그룹정보를 통한 기본 정보 조회 및 분석
- 월별 기업관계연결정보를 통한 관계사 현황 파악
- 기업재무대상관리정보를 통한 재무분석 대상 관리
- 실시간 트랜잭션 처리를 통한 온라인 조회 서비스 제공
- 데이터 무결성 및 일관성 유지를 통한 신뢰성 있는 정보 제공

## 2. 데이터베이스 테이블 구조

### 사용되는 실제 테이블들 (KIP_Table_mapping.csv 기준)

#### THKIPA111 - 기업집단그룹정보
- **테이블명:** THKIPA111
- **설명:** 기업집단그룹코드관련 정보를 관리한다
- **타입:** 상세
- **주요 컬럼:**
  - CORP_CLCT_REGI_CD (기업집단등록코드)
  - CORP_CLCT_GROUP_CD (기업집단그룹코드)
  - CORP_CLCT_NAME (기업집단명)

#### THKIPA121 - 월별기업관계연결정보
- **테이블명:** THKIPA121
- **설명:** 월별 기업간 관계정보를 관리한다
- **타입:** 상세
- **주요 컬럼:**
  - CORP_CLCT_GROUP_CD (기업집단그룹코드)
  - CORP_CLCT_REGI_CD (기업집단등록코드)
  - BASE_YM (기준년월)
  - RELATION_TYPE (관계유형)

#### THKIPA130 - 기업재무대상관리정보
- **테이블명:** THKIPA130
- **설명:** 기업별 재무정보 생성시 년도별 포함여부를 관리한다
- **타입:** 상세
- **주요 컬럼:**
  - CORP_CLCT_GROUP_CD (기업집단그룹코드)
  - CORP_CLCT_REGI_CD (기업집단등록코드)
  - VALUA_YMD (평가년월일)
  - FIN_TARGET_YN (재무대상여부)

## 3. 업무 엔티티

### BE-027-001: 기업집단재무분석조회요청 (Corporate Group Financial Analysis Request)
- **설명:** 기업집단 재무분석 조회 작업을 위한 입력 파라미터
- **속성:**

| 속성 | 데이터 타입 | 길이 | 제약조건 | 설명 | 제안 변수 |
|------|-------------|------|----------|------|-----------|
| 처리구분코드 | String | 2 | NOT NULL | 처리 유형 분류 식별자 | prcssDstcd |
| 그룹회사코드 | String | 3 | NOT NULL | 그룹회사 식별자 | groupCoCd |
| 기업집단그룹코드 | String | 3 | NOT NULL | 기업집단 분류 식별자 | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | NOT NULL | 기업집단 등록 식별자 | corpClctRegiCd |
| 기업집단명 | String | 100 | NULLABLE | 기업집단명 (패턴검색용) | corpClctName |
| 기준년월 | String | 6 | YYYYMM 형식 | 월별 관계정보 조회 기준년월 | baseYm |
| 평가년월일 | String | 8 | YYYYMMDD 형식 | 재무대상관리 평가일자 | valuaYmd |

### BE-027-002: 기업집단그룹정보 (Corporate Group Information)
- **설명:** THKIPA111 테이블에서 조회되는 기업집단 그룹정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 설명 | 제안 변수 |
|------|-------------|------|------|-----------|
| 기업집단등록코드 | String | 3 | 기업집단 등록 식별자 | corpClctRegiCd |
| 기업집단그룹코드 | String | 3 | 기업집단 분류 식별자 | corpClctGroupCd |
| 기업집단명 | String | 100 | 기업집단명 | corpClctName |

### BE-027-003: 월별기업관계연결정보 (Monthly Corporate Relationship Information)
- **설명:** THKIPA121 테이블에서 조회되는 월별 기업관계연결정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 설명 | 제안 변수 |
|------|-------------|------|------|-----------|
| 기업집단그룹코드 | String | 3 | 기업집단 분류 식별자 | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | 기업집단 등록 식별자 | corpClctRegiCd |
| 기준년월 | String | 6 | 관계정보 기준년월 | baseYm |
| 관계유형 | String | 2 | 기업간 관계유형 | relationType |

### BE-027-004: 기업재무대상관리정보 (Corporate Financial Target Management Information)
- **설명:** THKIPA130 테이블에서 조회되는 기업재무대상관리정보
- **속성:**

| 속성 | 데이터 타입 | 길이 | 설명 | 제안 변수 |
|------|-------------|------|------|-----------|
| 기업집단그룹코드 | String | 3 | 기업집단 분류 식별자 | corpClctGroupCd |
| 기업집단등록코드 | String | 3 | 기업집단 등록 식별자 | corpClctRegiCd |
| 평가년월일 | String | 8 | 재무평가 기준일자 | valuaYmd |
| 재무대상여부 | String | 1 | 재무분석 대상 포함여부 | finTargetYn |

## 4. 업무 규칙

### BR-027-001: 기업집단등록코드 검증
- **규칙:** 기업집단등록코드는 필수 입력 항목이며 공백일 수 없음
- **검증 로직:** corpClctRegiCd != null && !corpClctRegiCd.trim().isEmpty()
- **오류 메시지:** "기업집단등록코드는 필수입력항목입니다."

### BR-027-002: 기업집단그룹코드 검증
- **규칙:** 기업집단그룹코드는 필수 입력 항목이며 공백일 수 없음
- **검증 로직:** corpClctGroupCd != null && !corpClctGroupCd.trim().isEmpty()
- **오류 메시지:** "기업집단그룹코드는 필수입력항목입니다."

### BR-027-003: 데이터 완전성 검증
- **규칙:** 조회된 모든 테이블의 데이터 건수를 합산하여 총 조회건수 제공
- **검증 로직:** totalRecords = groupInfoCount + relationInfoCount + finTargetInfoCount
- **목적:** 데이터 무결성 및 완전성 보장

### BR-027-004: 날짜 형식 검증
- **규칙:** 기준년월은 YYYYMM 형식, 평가년월일은 YYYYMMDD 형식이어야 함
- **검증 로직:** 정규식 패턴 매칭을 통한 날짜 형식 검증
- **목적:** 데이터 일관성 및 정확성 보장

## 5. 업무 기능

### F-027-001: 기업집단 그룹정보 조회
- **기능:** THKIPA111 테이블에서 기업집단 그룹정보를 조회
- **입력:** groupCoCd, corpClctGroupCd, corpClctName
- **출력:** 기업집단 그룹정보 목록 (grid1)
- **처리:** selectByName 메소드를 통한 패턴 검색

### F-027-002: 월별기업관계연결정보 조회
- **기능:** THKIPA121 테이블에서 월별 기업관계연결정보를 조회
- **입력:** corpClctGroupCd, corpClctRegiCd, baseYm
- **출력:** 월별 관계연결정보 목록 (relationList)
- **처리:** selectRelationInfo 메소드를 통한 관계정보 조회

### F-027-003: 기업재무대상관리정보 조회
- **기능:** THKIPA130 테이블에서 기업재무대상관리정보를 조회
- **입력:** corpClctGroupCd, corpClctRegiCd, valuaYmd
- **출력:** 재무대상관리정보 목록 (finTargetList)
- **처리:** selectFinTargetInfo 메소드를 통한 재무대상정보 조회

### F-027-004: 통합 응답 데이터 구성
- **기능:** 3개 테이블의 조회 결과를 통합하여 응답 데이터 구성
- **입력:** 각 테이블별 조회 결과
- **출력:** 통합된 응답 데이터 (groupInfo, relationInfo, finTargetInfo)
- **처리:** 데이터 통합 및 총 조회건수 계산

## 6. 프로세스 흐름

### 6.1 메인 프로세스 흐름
```
1. 입력 파라미터 검증 (BR-027-001, BR-027-002)
2. 기업집단 그룹정보 조회 (F-027-001)
3. 월별기업관계연결정보 조회 (F-027-002)
4. 기업재무대상관리정보 조회 (F-027-003)
5. 데이터 완전성 검증 (BR-027-003)
6. 통합 응답 데이터 구성 (F-027-004)
7. 결과 반환
```

### 6.2 아키텍처 흐름
```
PM (pmKIP04A6740) 
  ↓
FM (inquireCorpGrpFinAnalysis in FUCorpGrpFinAnalInq)
  ↓  
DM (selectByName, selectRelationInfo, selectFinTargetInfo)
   ↓
DUTHKIPA111, DUTHKIPA121, DUTHKIPA130
```

## 7. 레거시 구현 참조

### 7.1 원본 COBOL 모듈 매핑
- **AIP4A67** → **pmKIP04A6740** (PM 메소드)
- **DIPA671** → **DUTHKIPA111** (기업집단그룹정보)
- **QIPA671** → **DUTHKIPA121** (월별기업관계연결정보)
- **QIPA672** → **DUTHKIPA130** (기업재무대상관리정보)

### 7.2 데이터베이스 테이블 매핑
- **실제 테이블 사용**: KIP_Table_mapping.csv에 정의된 실제 존재하는 테이블들만 사용
- **테이블 검증**: 모든 사용 테이블이 실제 데이터베이스에 존재함을 확인
- **스키마 호환성**: 실제 테이블 스키마와 100% 호환되는 구조로 설계

### 7.3 nKESA 프레임워크 준수
- **명명 규칙**: PM/FM/DM 명명 규칙 100% 준수
- **호출 관계**: PM → FM → DM 순서 엄격히 준수
- **어노테이션**: @BizUnit, @BizMethod, @BizUnitBind 적절한 사용
- **예외 처리**: BusinessException을 통한 표준 예외 처리

## 8. 구현 완료 현황

### 8.1 Java 클래스 구현
- ✅ **PUCorpGrpSumm.java** - PM 메소드 pmKIP04A6740 구현 완료
- ✅ **FUCorpGrpFinAnalInq.java** - FM 메소드 inquireCorpGrpFinAnalysis 구현 완료
- ✅ **DUTHKIPA111.java** - DM 메소드 selectByName 활용
- ✅ **DUTHKIPA121.java** - DM 메소드 selectRelationInfo 구현 완료
- ✅ **DUTHKIPA130.java** - DM 메소드 selectFinTargetInfo 구현 완료

### 8.2 컴파일 및 테스트
- ✅ **컴파일 성공**: 모든 클래스 오류 없이 컴파일 완료
- ✅ **프레임워크 호환**: nKESA 프레임워크와 100% 호환
- ✅ **테이블 검증**: 실제 존재하는 테이블들만 사용하여 운영 환경 호환성 확보

---
**문서 버전 히스토리:**
- v1.0 (2025-09-25): 초기 작성 (가상 테이블 기반)
- v1.1 (2025-10-01): 실제 테이블 구조로 수정 및 구현 완료
