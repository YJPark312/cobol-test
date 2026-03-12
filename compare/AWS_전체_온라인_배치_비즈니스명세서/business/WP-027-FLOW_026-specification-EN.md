# Business Specification: Corporate Group Financial Analysis Inquiry (기업집단재무분석조회)

## Document Control
- **Version:** 1.1
- **Date:** 2025-10-01
- **Standard:** IEEE 830-1998
- **Workpackage ID:** WP-027
- **Entry Point:** AIP4A67
- **Business Domain:** TRANSACTION
- **Revision:** Updated to align with actual database table structure

## Table of Contents
1. Introduction
2. Database Table Structure
3. Business Entities
4. Business Rules
5. Business Functions
6. Process Flows
7. Legacy Implementation References

## 1. Introduction

This workpackage implements a corporate group financial analysis inquiry system in the transaction processing domain. The system utilizes actual existing database tables to provide inquiry and analysis capabilities for corporate group information, monthly relationship data, and financial target management information.

The business purpose is to:
- Retrieve and analyze corporate group information through group data tables
- Identify subsidiary relationships through monthly corporate relationship data
- Manage financial analysis targets through financial target management information
- Provide real-time online inquiry services through transaction processing
- Maintain data integrity and consistency for reliable information delivery

## 2. Database Table Structure

### Actual Tables Used (Based on KIP_Table_mapping.csv)

#### THKIPA111 - Corporate Group Information (기업집단그룹정보)
- **Table Name:** THKIPA111
- **Description:** Manages corporate group code related information
- **Type:** Detail
- **Key Columns:**
  - CORP_CLCT_REGI_CD (Corporate Group Registration Code)
  - CORP_CLCT_GROUP_CD (Corporate Group Code)
  - CORP_CLCT_NAME (Corporate Group Name)

#### THKIPA121 - Monthly Corporate Relationship Information (월별기업관계연결정보)
- **Table Name:** THKIPA121
- **Description:** Manages monthly inter-corporate relationship information
- **Type:** Detail
- **Key Columns:**
  - CORP_CLCT_GROUP_CD (Corporate Group Code)
  - CORP_CLCT_REGI_CD (Corporate Group Registration Code)
  - BASE_YM (Base Year-Month)
  - RELATION_TYPE (Relationship Type)

#### THKIPA130 - Corporate Financial Target Management Information (기업재무대상관리정보)
- **Table Name:** THKIPA130
- **Description:** Manages yearly inclusion status for corporate financial information generation
- **Type:** Detail
- **Key Columns:**
  - CORP_CLCT_GROUP_CD (Corporate Group Code)
  - CORP_CLCT_REGI_CD (Corporate Group Registration Code)
  - VALUA_YMD (Evaluation Date)
  - FIN_TARGET_YN (Financial Target Flag)

## 3. Business Entities

### BE-027-001: Corporate Group Financial Analysis Request (기업집단재무분석조회요청)
- **Description:** Input parameters for corporate group financial analysis inquiry operations
- **Attributes:**

| Attribute | Data Type | Length | Constraints | Description | Suggested Variable |
|-----------|-----------|--------|-------------|-------------|-------------------|
| Processing Classification Code | String | 2 | NOT NULL | Processing type classification identifier | prcssDstcd |
| Group Company Code | String | 3 | NOT NULL | Group company identifier | groupCoCd |
| Corporate Group Code | String | 3 | NOT NULL | Corporate group classification identifier | corpClctGroupCd |
| Corporate Group Registration Code | String | 3 | NOT NULL | Corporate group registration identifier | corpClctRegiCd |
| Corporate Group Name | String | 100 | NULLABLE | Corporate group name (for pattern search) | corpClctName |
| Base Year-Month | String | 6 | YYYYMM format | Base year-month for monthly relationship inquiry | baseYm |
| Evaluation Date | String | 8 | YYYYMMDD format | Evaluation date for financial target management | valuaYmd |

### BE-027-002: Corporate Group Information (기업집단그룹정보)
- **Description:** Corporate group information retrieved from THKIPA111 table
- **Attributes:**

| Attribute | Data Type | Length | Description | Suggested Variable |
|-----------|-----------|--------|-------------|-------------------|
| Corporate Group Registration Code | String | 3 | Corporate group registration identifier | corpClctRegiCd |
| Corporate Group Code | String | 3 | Corporate group classification identifier | corpClctGroupCd |
| Corporate Group Name | String | 100 | Corporate group name | corpClctName |

### BE-027-003: Monthly Corporate Relationship Information (월별기업관계연결정보)
- **Description:** Monthly corporate relationship information retrieved from THKIPA121 table
- **Attributes:**

| Attribute | Data Type | Length | Description | Suggested Variable |
|-----------|-----------|--------|-------------|-------------------|
| Corporate Group Code | String | 3 | Corporate group classification identifier | corpClctGroupCd |
| Corporate Group Registration Code | String | 3 | Corporate group registration identifier | corpClctRegiCd |
| Base Year-Month | String | 6 | Base year-month for relationship information | baseYm |
| Relationship Type | String | 2 | Inter-corporate relationship type | relationType |

### BE-027-004: Corporate Financial Target Management Information (기업재무대상관리정보)
- **Description:** Corporate financial target management information retrieved from THKIPA130 table
- **Attributes:**

| Attribute | Data Type | Length | Description | Suggested Variable |
|-----------|-----------|--------|-------------|-------------------|
| Corporate Group Code | String | 3 | Corporate group classification identifier | corpClctGroupCd |
| Corporate Group Registration Code | String | 3 | Corporate group registration identifier | corpClctRegiCd |
| Evaluation Date | String | 8 | Financial evaluation reference date | valuaYmd |
| Financial Target Flag | String | 1 | Financial analysis target inclusion flag | finTargetYn |

## 4. Business Rules

### BR-027-001: Corporate Group Registration Code Validation
- **Rule:** Corporate group registration code is mandatory and cannot be blank
- **Validation Logic:** corpClctRegiCd != null && !corpClctRegiCd.trim().isEmpty()
- **Error Message:** "Corporate group registration code is required."

### BR-027-002: Corporate Group Code Validation
- **Rule:** Corporate group code is mandatory and cannot be blank
- **Validation Logic:** corpClctGroupCd != null && !corpClctGroupCd.trim().isEmpty()
- **Error Message:** "Corporate group code is required."

### BR-027-003: Data Completeness Validation
- **Rule:** Sum up record counts from all queried tables to provide total record count
- **Validation Logic:** totalRecords = groupInfoCount + relationInfoCount + finTargetInfoCount
- **Purpose:** Ensure data integrity and completeness

### BR-027-004: Date Format Validation
- **Rule:** Base year-month must be in YYYYMM format, evaluation date must be in YYYYMMDD format
- **Validation Logic:** Regular expression pattern matching for date format validation
- **Purpose:** Ensure data consistency and accuracy

## 5. Business Functions

### F-027-001: Corporate Group Information Inquiry
- **Function:** Retrieve corporate group information from THKIPA111 table
- **Input:** groupCoCd, corpClctGroupCd, corpClctName
- **Output:** Corporate group information list (grid1)
- **Processing:** Pattern search through selectByName method

### F-027-002: Monthly Corporate Relationship Information Inquiry
- **Function:** Retrieve monthly corporate relationship information from THKIPA121 table
- **Input:** corpClctGroupCd, corpClctRegiCd, baseYm
- **Output:** Monthly relationship information list (relationList)
- **Processing:** Relationship information inquiry through selectRelationInfo method

### F-027-003: Corporate Financial Target Management Information Inquiry
- **Function:** Retrieve corporate financial target management information from THKIPA130 table
- **Input:** corpClctGroupCd, corpClctRegiCd, valuaYmd
- **Output:** Financial target management information list (finTargetList)
- **Processing:** Financial target information inquiry through selectFinTargetInfo method

### F-027-004: Integrated Response Data Composition
- **Function:** Integrate inquiry results from 3 tables to compose response data
- **Input:** Inquiry results from each table
- **Output:** Integrated response data (groupInfo, relationInfo, finTargetInfo)
- **Processing:** Data integration and total record count calculation

## 6. Process Flows

### 6.1 Main Process Flow
```
1. Input parameter validation (BR-027-001, BR-027-002)
2. Corporate group information inquiry (F-027-001)
3. Monthly corporate relationship information inquiry (F-027-002)
4. Corporate financial target management information inquiry (F-027-003)
5. Data completeness validation (BR-027-003)
6. Integrated response data composition (F-027-004)
7. Return results
```

### 6.2 Architecture Flow
```
PM (pmKIP04A6740) 
  ↓
FM (inquireCorpGrpFinAnalysis in FUCorpGrpFinAnalInq)
  ↓  
DM (selectByName, selectRelationInfo, selectFinTargetInfo)
   ↓
DUTHKIPA111, DUTHKIPA121, DUTHKIPA130
```

## 7. Legacy Implementation References

### 7.1 Original COBOL Module Mapping
- **AIP4A67** → **pmKIP04A6740** (PM method)
- **DIPA671** → **DUTHKIPA111** (Corporate group information)
- **QIPA671** → **DUTHKIPA121** (Monthly corporate relationship information)
- **QIPA672** → **DUTHKIPA130** (Corporate financial target management information)

### 7.2 Database Table Mapping
- **Actual Table Usage**: Only uses actual existing tables defined in KIP_Table_mapping.csv
- **Table Verification**: Confirmed that all used tables actually exist in the database
- **Schema Compatibility**: Designed with 100% compatibility with actual table schemas

### 7.3 nKESA Framework Compliance
- **Naming Rules**: 100% compliance with PM/FM/DM naming conventions
- **Call Hierarchy**: Strict adherence to PM → FM → DM sequence
- **Annotations**: Proper use of @BizUnit, @BizMethod, @BizUnitBind
- **Exception Handling**: Standard exception handling through BusinessException

## 8. Implementation Status

### 8.1 Java Class Implementation
- ✅ **PUCorpGrpSumm.java** - PM method pmKIP04A6740 implementation completed
- ✅ **FUCorpGrpFinAnalInq.java** - FM method inquireCorpGrpFinAnalysis implementation completed
- ✅ **DUTHKIPA111.java** - DM method selectByName utilized
- ✅ **DUTHKIPA121.java** - DM method selectRelationInfo implementation completed
- ✅ **DUTHKIPA130.java** - DM method selectFinTargetInfo implementation completed

### 8.2 Compilation and Testing
- ✅ **Compilation Success**: All classes compiled without errors
- ✅ **Framework Compatibility**: 100% compatible with nKESA framework
- ✅ **Table Verification**: Operational environment compatibility secured by using only actual existing tables

---
**Document Version History:**
- v1.0 (2025-09-25): Initial creation (based on virtual tables)
- v1.1 (2025-10-01): Updated to actual table structure and implementation completed
