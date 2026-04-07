# 05. 데이터셋 API & 코딩 가이드 매핑

---

# z-KESA (COBOL) → n-KESA (Java) Framework Mapping
## Complete, Exhaustive Data Handling & Coding Guidelines

---

## PART 1: DATA TYPE MAPPINGS

---

### [Data Type] - PIC X(n) → String
- z-KESA: `PIC X(n)`
- n-KESA: `String`
- z-KESA Detail: Fixed-length alphanumeric field. Space-padded on the right. Examples from copybooks: `PIC X(008)` (program ID), `PIC X(015)` (account number), `PIC X(040)` (customer name), `PIC X(100)` (content field). Comparison with `SPACE` or `= SPACES` tests for empty value.
- n-KESA Detail: Java `String`. Retrieved via `record.getString("fieldName")` or `dataset.getString("fieldName")`. Null/blank check via `StringUtils.isBlank()` (null, "", and whitespace-only all return true) or `StringUtils.isEmpty()` (null and "" only).
- Mapping Rule: `PIC X(n)` → `String`. Strip trailing spaces using `String.trim()` or `StringUtils.trimToEmpty()`. Blank check `IF field = SPACE` → `StringUtils.isBlank(dataset.getString("fieldName"))`. String equality `IF field = 'ABC'` → `"ABC".equals(dataset.getString("fieldName"))` (constant on left side per coding standard).

---

### [Data Type] - PIC 9(n) → long
- z-KESA: `PIC 9(n)` (unsigned integer, DISPLAY format)
- n-KESA: `long`
- z-KESA Detail: Unsigned integer in zoned decimal (DISPLAY) format. Examples: `PIC 9(006)` (line number), `PIC 9(007)` (serial number), `PIC 9(015)` (withdrawal amount). Cannot hold negative values.
- n-KESA Detail: `long` type. Retrieved via `record.getLong("fieldName")` or `dataset.getLong("fieldName")`. Java `int` max is 2^31-1 (2,147,483,647) which is insufficient for financial amounts; `long` max is 2^63-1 (9,223,372,036,854,775,807). For amounts, use `long` or `BigDecimal`.
- Mapping Rule: `PIC 9(n)` → `long`. `IRecord.getLong("fieldName")`, `IDataSet.getLong("fieldName")`. For amounts: `PIC 9(15)` (amount field) → `long` for integer amounts. Never use Java `int` for amounts.

---

### [Data Type] - PIC S9(n) → long / BigDecimal
- z-KESA: `PIC S9(n)` (signed integer, DISPLAY format with sign)
- n-KESA: `long` or `BigDecimal`
- z-KESA Detail: Signed integer. The `S` prefix adds a sign. `LEADING SEPARATE` stores sign as a separate leading character. Example: `PIC S9(005) LEADING SEPARATE` (SQL return code), `PIC S9(n)` (signed amounts). Sign representation varies: LEADING SEPARATE, TRAILING (default), SEPARATE CHARACTER.
- n-KESA Detail: `long` for integer signed values. `BigDecimal` when precision matters or for financial calculations. Retrieved via `getLong()` or `getBigDecimal()`.
- Mapping Rule: `PIC S9(n)` → `long`. `PIC S9(n) LEADING SEPARATE` → `long` (sign already embedded in numeric value). For SQL codes: `PIC S9(005) LEADING SEPARATE` → `int` or `long`. Negative values handled natively in Java.

---

### [Data Type] - PIC S9(n)V9(m) → BigDecimal
- z-KESA: `PIC S9(n)V9(m)` (signed decimal with implied decimal point)
- n-KESA: `BigDecimal`
- z-KESA Detail: Signed fixed-point decimal. `V` marks the implied decimal point position (no actual decimal point stored). Example: `PIC S9(00004)V9(5) COMP-3` (interest rate - 4 integer digits, 5 decimal places). `PIC S9(6)V9(12) COMP-3` (high-precision calculations).
- n-KESA Detail: `java.math.BigDecimal`. Retrieved via `record.getBigDecimal("fieldName")`. Must use `BigDecimal.valueOf(double)` or `new BigDecimal("string")` for construction — never `new BigDecimal(double)` which produces inaccurate results. Used for interest rates, fees, financial ratios.
- Mapping Rule: `PIC S9(n)V9(m)` → `BigDecimal`. Scale = m (decimal places). `PIC S9(4)V9(5)` → `BigDecimal` with scale 5. Construction: `BigDecimal.valueOf(0.1)` or `new BigDecimal("0.1")` — never `new BigDecimal(0.1)`. `float` and `double` arithmetic PROHIBITED for financial calculations due to precision errors.

---

### [Data Type] - PIC 9(n)V9(m) → BigDecimal
- z-KESA: `PIC 9(n)V9(m)` (unsigned decimal with implied decimal point)
- n-KESA: `BigDecimal`
- z-KESA Detail: Unsigned fixed-point decimal. Example: `9(n)V9(3)` for unsigned amounts with 3 decimal places.
- n-KESA Detail: `BigDecimal` (always positive; Java BigDecimal can represent both signs but values should be constrained by business logic).
- Mapping Rule: `PIC 9(n)V9(m)` → `BigDecimal` (non-negative). Scale = m decimal places.

---

### [Data Type] - PIC 9(n) COMP / PIC 9(n) COMP-4 → int / long
- z-KESA: `PIC 9(n) COMP` or `COMP-4` (BINARY integer)
- n-KESA: `int` or `long`
- z-KESA Detail: Binary (2's complement) storage format. Most CPU-efficient numeric format. Performance guideline: BINARY (COMP) is fastest; 1–8 digits preferred over 9 digits; subscript/index variables should use `PIC 9(4) USAGE BINARY` or `PIC 9(4) COMP`. Example: `01 SUB1 PIC 9(4) USAGE BINARY` for array subscripts.
- n-KESA Detail: `int` (for small counters/indices), `long` (for larger values). Java primitives; no object overhead.
- Mapping Rule: `PIC 9(n) COMP` (n ≤ 4) → `int`. `PIC 9(n) COMP` (n > 4) → `long`. Loop counter/index variables → `int i`. Performance note: Java native `int`/`long` are already binary — no conversion needed.

---

### [Data Type] - PIC S9(n) COMP-3 / PACKED-DECIMAL → BigDecimal / long
- z-KESA: `PIC S9(n) COMP-3` or `PACKED-DECIMAL` (Packed Decimal)
- n-KESA: `BigDecimal` or `long`
- z-KESA Detail: Packed decimal format — 2 digits per byte plus sign nibble. Heavily used for DB table numeric columns. Examples from DBIO copybooks: `PIC S9(00007) COMP-3` (product contract sequence), `PIC S9(00002) COMP-3` (serial number), `PIC S9(00010) COMP-3` (financial amounts). Performance guideline: sign must be specified (`S`), digit count should be odd, max 15 digits for optimal performance.
- n-KESA Detail: `BigDecimal` for decimal fields; `long` for integer-only packed fields. DB retrieval via `IRecord.getBigDecimal()` or `IRecord.getLong()`.
- Mapping Rule: `PIC S9(n) COMP-3` (no `V`) → `long`. `PIC S9(n)V9(m) COMP-3` → `BigDecimal` with scale m. Scale preservation: `setScale(m, RoundingMode.XXX)`.

---

### [Data Type] - PIC S9(n)V9(m) COMP-3 → BigDecimal
- z-KESA: `PIC S9(n)V9(m) COMP-3` (signed packed decimal with decimal places)
- n-KESA: `BigDecimal`
- z-KESA Detail: Signed packed decimal with implied decimal point. Example: `PIC S9(00004)V9(5) COMP-3` (interest rate — 적용금리), `PIC S9(6)V9(12) COMP-3` (high-precision exponentiation value). Critical for interest rate, fee, and ratio calculations.
- n-KESA Detail: `BigDecimal`. Scale matches the `V9(m)` part. Arithmetic operations: `add()`, `subtract()`, `multiply()`, `divide()` with `MathContext.DECIMAL64` for division.
- Mapping Rule: `PIC S9(n)V9(m) COMP-3` → `BigDecimal` with `setScale(m, RoundingMode.HALF_UP)`. Store as `BigDecimal`; retrieve with `record.getBigDecimal("fieldName")`.

---

### [Data Type] - COMP-1 / COMP-2 → double (avoid for finance)
- z-KESA: `COMP-1` (single-precision float), `COMP-2` (double-precision float)
- n-KESA: `double` (only for non-financial scientific calculations)
- z-KESA Detail: Floating-point. Performance note: floating-point faster for large exponentiation. Example: `COMPUTE A = (1.0E0 + B) ** C` converts to floating-point for performance. NOT used for financial amounts.
- n-KESA Detail: `double` — explicitly PROHIBITED for financial calculations. `float` and `double` arithmetic produce inaccurate results (e.g., `0.1 - 0.01 = 0.09000000000000001`). Use `BigDecimal` for all monetary and rate calculations.
- Mapping Rule: COMP-1/COMP-2 → `double` only for scientific/technical non-financial use. Any financial/rate field using COMP-1/COMP-2 → must be refactored to `BigDecimal`.

---

### [Data Structure] - OCCURS n TIMES → IRecordSet
- z-KESA: `OCCURS n TIMES` (table/array)
- n-KESA: `IRecordSet`
- z-KESA Detail: Defines a repeating group (table/array). Examples: `OCCURS nn TIMES PIC X(13)` (array of strings), `05 TAB1 OCCURS 1000 INDEXED BY TABINDX` (indexed table with multiple sub-fields). Subscripted access via `fieldName(WK-I)`. 2D array: `fieldName(i, j)`. 3D array: `fieldName(i, j, k)`. `OCCURS DEPENDING ON` (variable-length) — guideline: avoid.
- n-KESA Detail: `IRecordSet` — represents a 2D table (rows × columns). Created via `new RecordSet("col1", "col2", ...)` or `new RecordSet(new String[]{"col1", "col2"})`. Retrieved from `IDataSet` via `dataset.getRecordSet("key")`. Row count: `rs.getRecordCount()`. Row access: `rs.getRecord(i)` (0-indexed).
- Mapping Rule: `OCCURS n TIMES` with sub-fields → `IRecordSet` where each occurrence is one `IRecord` row. Single-value array `OCCURS n TIMES PIC X(m)` → `IRecordSet` with one column or `List<String>`. `WK-ARRAY(WK-I)` → `rs.getRecord(WK_I - 1).getString("col")` (COBOL 1-indexed → Java 0-indexed).

---

### [Data Structure] - REDEFINES → Type conversion / dual-view logic
- z-KESA: `REDEFINES` (overlaying one field definition over another)
- n-KESA: Explicit type conversion or separate variable
- z-KESA Detail: `REDEFINES` overlays the same memory with different data interpretations. Example: `03 WK-JUMIN-NO PIC X(13). 03 WK-JUMIN-REDF REDEFINES WK-JUMIN-NO.` — allows treating the same bytes as both a 13-char string and a structured sub-field. Types marked 'R' (재정의) in copybook type classification.
- n-KESA Detail: No direct equivalent. Implement as: (1) Store raw value as `String`, then parse/format as needed; (2) Use separate variables with explicit copy/conversion; (3) Use `substring()` for positional extraction.
- Mapping Rule: `REDEFINES` → analyze business purpose. If used for sub-field parsing: use `String.substring(start, end)`. If used for numeric/character dual view: store as `String`, convert with `Long.parseLong()` or `new BigDecimal()` as needed. Avoid `REDEFINES` for type aliasing — use strongly-typed Java objects.

---

### [Data Structure] - 88-Level Condition Names → boolean / constants
- z-KESA: `88 COND-NAME VALUE 'xx'`
- n-KESA: String constant comparison or enum
- z-KESA Detail: Level-88 defines named boolean conditions. Examples: `88 COND-XPFA2001-OK VALUE '00'`, `88 COND-XPFA2001-ERROR VALUE '09'`, `88 COND-XPFA2001-ABNORMAL VALUE '98'`, `88 COND-XPFA2001-SYSERROR VALUE '99'`. Used as `IF COND-XPFA2001-OK` or `IF NOT COND-XPFA2001-OK`.
- n-KESA Detail: Java string comparison using constants. Define as `public static String STAT_OK = "00"`, `STAT_ERROR = "09"`, etc. in a constants class. Compare: `"00".equals(returnStat)`.
- Mapping Rule: `88 COND-X-OK VALUE '00'` → define constant `public static String STAT_OK = "00"`. `IF COND-X-OK` → `STAT_OK.equals(returnCode)`. `IF NOT COND-X-OK` → `!STAT_OK.equals(returnCode)`. Pattern for return code check: `if (!STAT_OK.equals(result.getString("rStat"))) { throw new BusinessException(...); }`.

---

## PART 2: STATEMENT MAPPINGS

---

### [Statement] - MOVE → put() / set()
- z-KESA: `MOVE source TO target`
- n-KESA: `dataset.put("key", value)` / `record.set("key", value)`
- z-KESA Detail: Assigns value from source to target. Handles type conversions automatically (numeric truncation, space-padding). Used pervasively: `MOVE CO-STAT-OK TO XPFA2001-R-STAT`, `MOVE YNFA2001-ACNO TO XDFA9202-I-ACNO`, `MOVE 'Y' TO WK-SET-YN(1)`. `MOVE CORRESPONDING` moves matching sub-fields in group items.
- n-KESA Detail: `IDataSet.put(String key, Object value)` for scalar fields in DataSet. `IRecord.set(String headerName, Object value)` for fields within a RecordSet row. `IDataSet.putAll(Map map)` for bulk copy from Map. `IDataSet.putRecordSet(String id, IRecordSet rs)` for RecordSet registration.
- Mapping Rule: `MOVE A TO B` → `responseData.put("b", requestData.getString("a"))`. `MOVE 'Y' TO flag` → `responseData.put("flag", "Y")`. `MOVE CORR group1 TO group2` → `responseData.putAll(sourceDs.toMap())` or field-by-field `put()`. `MOVE ZERO TO field` → `responseData.put("field", 0L)` or `BigDecimal.ZERO`.

---

### [Statement] - INITIALIZE → new DataSet() / clear()
- z-KESA: `INITIALIZE varname1 varname2`
- n-KESA: `new DataSet()` / `record.clear()` / field-by-field initialization
- z-KESA Detail: Resets variables to their default values: alphabetic/alphanumeric fields to SPACES, numeric fields to ZEROS. Critical usage: `INITIALIZE WK-AREA XDFA9202-CA` (working area and interface params), `INITIALIZE XPFA2001-OUT XPFA2001-RETURN` (output and return areas). Guideline: CO-AREA (constants) must NOT be initialized. WK-AREA and all interface areas MUST be initialized in S1000-INITIALIZE-RTN.
- n-KESA Detail: `IDataSet responseData = new DataSet()` creates a new empty DataSet (equivalent to initializing output area). `record.clear()` sets all record field values to null. For re-initializing existing DataSet fields, re-assign: `responseData.put("field", "")` or `responseData.put("amount", BigDecimal.ZERO)`.
- Mapping Rule: `INITIALIZE output-CA` → `IDataSet responseData = new DataSet()` at method start. `INITIALIZE WK-AREA` (work variables) → declare fresh local variables in Java method scope (Java local variables are initialized on declaration). Interface parameter re-use between calls → create new DataSet per call: `IDataSet param = new DataSet()`.

---

### [Statement] - STRING → StringBuilder / String.format() / concatenation
- z-KESA: `STRING src1 DELIMITED SIZE src2 DELIMITED ',' INTO target`
- n-KESA: `StringBuilder` with `append()`
- z-KESA Detail: Concatenates multiple source strings into one target, with optional delimiters. `DELIMITED SIZE` uses full field length; `DELIMITED BY char` stops at delimiter character.
- n-KESA Detail: `StringBuilder sb = new StringBuilder(capacity)` (capacity must be set upfront per performance guideline — "크기를 설정하지 않은 StringBuffer 사용 금지"). Then `sb.append(part1).append(part2)`. String `+` operator is PROHIBITED (creates new instance per operation → memory explosion).
- Mapping Rule: `STRING A DELIMITED SIZE B DELIMITED SIZE INTO C` → `StringBuilder sb = new StringBuilder(expectedLength); sb.append(a.trim()); sb.append(b.trim()); String c = sb.toString();`. `STRING A DELIMITED ',' INTO C` → `String c = a.substring(0, a.indexOf(','))`. NEVER use `c = a + b + c` (String + prohibited).

---

### [Statement] - UNSTRING → String.split() / substring()
- z-KESA: `UNSTRING src DELIMITED ',' INTO field1 field2`
- n-KESA: `String.split()` / `StringUtils` methods / `substring()`
- z-KESA Detail: Splits a source string into multiple target fields using a delimiter. The inverse of STRING. Used for parsing composite fields into components.
- n-KESA Detail: `String[] parts = source.split(",")` for delimiter-based split. `source.substring(start, end)` for positional extraction. `nexcore.framework.core.util.StringUtils` for null-safe string operations (use instead of raw `String` API for `isEmpty()`, `substring()`, `contains()`, `trim()`, `indexOf()`).
- Mapping Rule: `UNSTRING src DELIMITED ',' INTO f1 f2` → `String[] parts = src.split(",", -1); String f1 = parts[0]; String f2 = parts.length > 1 ? parts[1] : "";`. Positional UNSTRING → `String f1 = src.substring(0, 8); String f2 = src.substring(8, 16)`. Always use `StringUtils` methods for null safety.

---

### [Statement] - INSPECT → String.replace() / replaceAll()
- z-KESA: `INSPECT field REPLACING ALL 'A' BY 'B'` / `TALLYING cnt FOR ALL 'X'`
- n-KESA: `String.replace()` / `String.replaceAll()` / `StringUtils`
- z-KESA Detail: `INSPECT REPLACING`: replaces occurrences of character/string. `INSPECT TALLYING`: counts occurrences. `INSPECT CONVERTING`: character-by-character translation (e.g., ASCII ↔ EBCDIC via ZUGCDCV utility).
- n-KESA Detail: `str.replace("A", "B")` for literal replacement. `str.replaceAll("regex", "replacement")` for regex-based replacement. Count occurrences: `StringUtils.countMatches(str, "X")` or loop with `indexOf()`.
- Mapping Rule: `INSPECT f REPLACING ALL 'A' BY 'B'` → `f = f.replace("A", "B")`. `INSPECT f TALLYING cnt FOR ALL ' '` → `cnt = f.length() - f.replace(" ", "").length()`. `INSPECT CONVERTING 'abc' TO 'ABC'` → `f = f.toUpperCase()` or custom character mapping. Use `StringUtils` where available for null safety.

---

## PART 3: CONTROL FLOW MAPPINGS

---

### [Control Flow] - EVALUATE → switch / if-else chain
- z-KESA: `EVALUATE expr WHEN val1 ... WHEN val2 ... WHEN OTHER ... END-EVALUATE`
- n-KESA: `switch (expr) { case val1: ... break; default: ... }` or `if-else` chain
- z-KESA Detail: Multi-branch conditional. Must close with `END-EVALUATE` (mandatory per coding standard). `EVALUATE TRUE WHEN condition` is equivalent to if-else chains. Examples: `EVALUATE XPFA9990-I-MDIA-CPBK-NAME(WK-I)(1:2) WHEN 'V1' ... WHEN 'V2' ... END-EVALUATE`, `EVALUATE XcalledPgm-R-STAT WHEN COND-KEYDUP ... WHEN OTHER ...`. `EVALUATE TRUE` pattern used for complex conditions.
- n-KESA Detail: Java `switch` for simple value matching. `if-else if-else` for complex conditions. Per coding guideline: every `switch` MUST have a `default` case. Code value comments required: `case "V1": // 화면`. Condition code values must be annotated in comments. Multi-condition if: each condition on its own line, aligned.
- Mapping Rule: `EVALUATE expr WHEN 'V1' ... WHEN 'V2' ... WHEN OTHER ...` → `switch(expr) { case "V1": ...; break; case "V2": ...; break; default: ...; break; }`. `EVALUATE TRUE WHEN (condition1) ... WHEN (condition2)` → `if (condition1) { ... } else if (condition2) { ... } else { ... }`. Always include `default` (n-KESA guideline requires it). Add code-value comments per n-KESA guideline.

---

### [Control Flow] - IF / END-IF → if { } (always with braces)
- z-KESA: `IF condition ... END-IF` (must close with `END-IF` per coding standard)
- n-KESA: `if (condition) { ... }` (always with curly braces)
- z-KESA Detail: Conditional execution. Coding standard: `IF` must always close with `END-IF`. `ELSE` clause supported. Common patterns: `IF field = SPACE`, `IF NOT COND-X-OK`, `IF value NOT = CO-STAT-OK`. Condition variables (88-level) used as boolean proxies.
- n-KESA Detail: Java `if` statement. Per n-KESA guideline: "if 및 루프는 항상 중괄호로 묶는다" (always use curly braces). "비어있는 if문 사용 금지" (no empty if blocks). "조건식에 부정을 사용하지 않는다" (avoid negation in conditions — prefer positive conditions). Multi-condition if: split conditions to separate lines aligned. Code value comments required.
- Mapping Rule: `IF field = SPACE` → `if (StringUtils.isBlank(ds.getString("field")))`. `IF NOT COND-X-OK` → `if (!STAT_OK.equals(ds.getString("rStat")))`. `IF value = CO-STAT-OK ... ELSE ...` → `if (STAT_OK.equals(rStat)) { ... } else { ... }`. Always include `{ }`.

---

### [Control Flow] - PERFORM VARYING → for loop
- z-KESA: `PERFORM VARYING idx FROM 1 BY 1 UNTIL idx > n`
- n-KESA: `for (int i = 0; i < n; i++) { ... }`
- z-KESA Detail: Counter-controlled loop. `FROM 1 BY 1 UNTIL idx > n` = classic 1-based loop. Example: `PERFORM VARYING WK-J FROM 1 BY 1 UNTIL WK-J > XPFA9990-I-CUPLD-NOITM`, `PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > XPFA9990-I-MDIA-NOITM`. Array access inside: `field(WK-I)`. Index subscript performance guideline: use BINARY type (COMP).
- n-KESA Detail: Standard Java `for` loop. Per n-KESA performance guideline: "for 루프의 조건에 method 호출 금지" — pre-store loop bound: `int count = rs.getRecordCount(); for (int i = 0; i < count; i++)`. "for 루프의 내용에서 루프 제어 변수를 변경하지 않는다" (do not modify loop control variable inside loop). "조건이 없는 for 루프를 사용하지 않는다" (no infinite for loops).
- Mapping Rule: `PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > maxCount` → `int count = rs.getRecordCount(); for (int i = 0; i < count; i++) { IRecord r = rs.getRecord(i); ... }`. COBOL index is 1-based; Java is 0-based: `COBOL WK-I` → `Java i` (WK-I=1 maps to i=0). Pre-store `getRecordCount()` result before loop (performance guideline).

---

### [Control Flow] - PERFORM VARYING with OCCURS array access
- z-KESA: `PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > n ... field(WK-I) ... END-PERFORM`
- n-KESA: `for` loop with `IRecord` access
- z-KESA Detail: Standard pattern for iterating over OCCURS arrays. Example: `PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > XPFA9990-I-MDIA-NOITM` with `EVALUATE XPFA9990-I-MDIA-CPBK-NAME(WK-I)(1:2)` for array element access.
- n-KESA Detail: `IRecordSet` for-each or indexed for loop. For-each: `for (IRecord r : rs) { r.getString("col1"); r.getInt("col2"); }`. Indexed: `for (int i = 0; i < count; i++) { IRecord r = rs.getRecord(i); }`.
- Mapping Rule: `PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > N ... array(WK-I) ...` → `int n = rs.getRecordCount(); for (int i = 0; i < n; i++) { IRecord r = rs.getRecord(i); String val = r.getString("columnName"); }`. For-each alternative: `for (IRecord r : rs) { String val = r.getString("columnName"); }`.

---

### [Control Flow] - PERFORM UNTIL → while loop
- z-KESA: `PERFORM UNTIL condition`
- n-KESA: `while (!condition) { ... }`
- z-KESA Detail: Condition-controlled loop. Test is at top (UNTIL means: loop WHILE NOT condition). Example: `PERFORM UNTIL EOF-Y OR STOP-Y` (batch main processing loop) — loops until end-of-file or stop flag is set. Inside: READ file, process, write, COMMIT.
- n-KESA Detail: Java `while` loop. Per n-KESA guideline: no infinite while loops ("조건이 없는 for 루프를 사용하지 않는다" applies equally). "while sleep 대신 wait notify를 사용한다" for thread waiting scenarios.
- Mapping Rule: `PERFORM UNTIL EOF-Y OR STOP-Y` → `while (!eofFlag && !stopFlag) { ... }`. `PERFORM UNTIL condition` (check at top) → `while (!condition) { ... }`. Batch file processing loop → `while ((line = reader.readLine()) != null) { processRecord(line); }`.

---

### [Control Flow] - PERFORM PARAGRAPH THRU → method call
- z-KESA: `PERFORM SnnNN-XXXXX-RTN THRU SnnNN-XXXXX-EXT`
- n-KESA: private method call
- z-KESA Detail: Calls a named paragraph (subroutine). Standard structure: `S0000-MAIN-RTN`, `S1000-INITIALIZE-RTN`, `S2000-VALIDATION-RTN`, `S3000-PROCESS-RTN`, `S9000-FINAL-RTN`. Each paragraph ends with `EXIT.`. Called via `PERFORM Snnnn-XXX-RTN THRU Snnnn-XXX-EXT`. Must close with `THRU Sxxxx-~-EXT`.
- n-KESA Detail: Java private method. Clean separation: initialize logic → `private void initialize()`, validation → `private void validate(IDataSet input)`, process → `private IDataSet process(IDataSet input, IOnlineContext ctx)`.
- Mapping Rule: `PERFORM S1000-INITIALIZE-RTN THRU S1000-INITIALIZE-EXT` → `initialize(requestData, onlineCtx)` private method call. `PERFORM S2000-VALIDATION-RTN THRU S2000-VALIDATION-EXT` → `validate(requestData)`. Main PARAGRAPH structure → PM method body with calls to private methods.

---

## PART 4: IDataSet FULL API

---

### [n-KESA API] - IDataSet: Creation
- z-KESA: WORKING-STORAGE / LINKAGE SECTION area declarations
- n-KESA: `IDataSet`
- z-KESA Detail: Data areas declared statically in WORKING-STORAGE or LINKAGE SECTION. Common areas: YCCOMMON-CA (framework common area), YNJI4719-CA (input), YPJI4719-CA (output), XDFA9202-CA (interface param).
- n-KESA Detail:
  - `IDataSet responseData = new DataSet()` — create new empty DataSet (use for output/response)
  - `IDataSet newDs = new DataSet()` — create parameter DataSet for sub-call
  - Do NOT call constructor with `new DataSet(someParam)` — always empty constructor
  - Method signature always receives `IDataSet requestData` as input parameter
- Mapping Rule: Output area (YPJI-CA) → `IDataSet responseData = new DataSet()`. Input area (YNJI-CA) → received as `requestData` parameter. Interface parameter area (XPFA-CA) → `IDataSet param = new DataSet()` constructed fresh per call.

---

### [n-KESA API] - IDataSet: put / get scalar fields
- z-KESA: `MOVE value TO field` / reading `fieldname`
- n-KESA: `put()` / `getString()` / `getLong()` / `getBigDecimal()`
- z-KESA Detail: Field access is direct by field name within the copybook structure.
- n-KESA Detail:
  - `void put(String key, Object value)` — insert/update any field value
  - `String getString(String key)` — retrieve as String
  - `long getLong(String key)` — retrieve as long
  - `int getInt(String key)` — retrieve as int
  - `float getFloat(String key)` — retrieve as float
  - `double getDouble(String key)` — retrieve as double
  - `BigDecimal getBigDecimal(String key)` — retrieve as BigDecimal
  - `byte[] getByteArray(String key)` — retrieve as byte array
  - `boolean containsKey(String key)` — check if field exists
  - `boolean remove(String key)` — remove field (returns true if existed)
  - `int size()` — number of fields
- Mapping Rule: `MOVE 'KB0' TO group-co-cd` → `responseData.put("groupCoCd", "KB0")`. Field name convention: COBOL KEBAB-CASE `GROUP-CO-CD` → Java camelCase `groupCoCd`. `MOVE WK-AMT TO output-field` → `responseData.put("outputField", wkAmt)` where `wkAmt` is a local Java variable.

---

### [n-KESA API] - IDataSet: putAll / toMap / clone
- z-KESA: `MOVE CORRESPONDING` / manual field-by-field copy
- n-KESA: `putAll()` / `toMap()` / `clone()`
- z-KESA Detail: COBOL `MOVE CORRESPONDING` copies matching-named sub-fields between group items. No direct bulk DataSet copy.
- n-KESA Detail:
  - `void putAll(Map map)` — copy all entries from a Java Map into DataSet
  - `Map<String, Object> toMap()` — export DataSet fields as a new Map (useful for SQL parameters)
  - `IDataSet clone()` — deep clone of entire DataSet including all RecordSets
  - Parameter passing options: (1) pass original `givenDs` directly (not recommended — caller may modify); (2) build new `newDs` with only needed fields; (3) `IDataSet newDs = givenDs.clone()` for full copy
- Mapping Rule: `MOVE CORR input TO output` → `responseData.putAll(requestData.toMap())` (copies all scalar fields). Selective copy → field-by-field `put()`. Sub-call parameter → `IDataSet param = new DataSet(); param.put("acno", requestData.getString("acno"))` (selective, option 2). Avoid passing `requestData` directly to sub-methods that may modify it.

---

### [n-KESA API] - IDataSet: RecordSet registration and retrieval
- z-KESA: OCCURS array embedded in output area
- n-KESA: `put(id, IRecordSet)` / `getRecordSet(id)` / `putRecordSet(id, IRecordSet)`
- z-KESA Detail: Array data (OCCURS) is part of copybook output area. No separate registration step needed in COBOL.
- n-KESA Detail:
  - `response.put("result", recordSet)` — register RecordSet with a key name
  - `IRecordSet rs = response.getRecordSet("result")` — retrieve RecordSet by key
  - `dataset.putRecordSet("result", recordSet)` — register without deep-copy (shared reference warning: modifying rs through dataset1 also modifies dataset2's view)
  - `dataset.remove("result")` — remove RecordSet (removes the RecordSet object and all its records)
  - `responseData.put("acnNoitm", acnList.getRecordCount())` — also put record count as scalar field
- Mapping Rule: OCCURS output in YPJI copybook → `responseData.put("listKey", recordSet)` and `responseData.put("listKeyNoitm", rs.getRecordCount())`. Always register record count separately. Never share RecordSet between DataSets without `clone()`.

---

## PART 5: IRecordSet FULL API

---

### [n-KESA API] - IRecordSet: Creation
- z-KESA: `OCCURS n TIMES` table definition in copybook
- n-KESA: `new RecordSet(...)`
- z-KESA Detail: Table structure defined statically via `OCCURS`. Column names match the sub-field names under the OCCURS clause.
- n-KESA Detail:
  - `IRecordSet rs = new RecordSet("name", "price", "desc")` — create with named headers (varargs)
  - `IRecordSet rs = new RecordSet(new String[]{"name", "price", "desc"})` — create with String array
  - `IRecordSet rs = new RecordSet()` — create empty (headers added separately with `addHeader()`)
  - `IRecordSet rs = new RecordSet(map)` — create from a Map (Map keys become headers)
  - `IRecordSet rs = dbSelect("selectId", paramDs)` — create from DB query result (DataUnit API)
  - `rs.addHeader(new RecordHeader("columnName"))` — add column to existing RecordSet
  - `rs.addHeader(index, new RecordHeader("colName"))` — insert column at position
  - `rs.setHeader(index, new RecordHeader("newName"))` — replace column at position
  - `rs.setHeader("oldName", new RecordHeader("newName"))` — replace column by name
- Mapping Rule: COBOL OCCURS table → `new RecordSet("col1", "col2", ...)` with column names matching COBOL sub-field names (converted to camelCase). DB result → `dbSelect("sqlId", paramDs)` automatically returns `IRecordSet`.

---

### [n-KESA API] - IRecordSet: Record count and retrieval
- z-KESA: `OCCURS n TIMES` — count via a separate counter field; access via subscript `(WK-I)`
- n-KESA: `getRecordCount()` / `getRecord(i)`
- z-KESA Detail: COBOL output areas include a companion count field (e.g., `XPFA9990-I-CUPLD-NOITM` for array count). Array accessed via `array(subscript)` where subscript is 1-based.
- n-KESA Detail:
  - `int getRecordCount()` — total number of records (rows) in RecordSet
  - `IRecord getRecord(int i)` — get record at 0-based index i
  - `IRecord removeRecord(int i)` — remove and return record at index i
  - `IRecord newRecord()` — add new empty record at end, return reference
  - `IRecord newRecord(int i)` — insert new empty record at index i (between i-1 and i)
  - `rs.addRecord(IRecord r)` — add an existing record (use after `removeRecord()` from another RS)
  - `rs.addRecord(int i, IRecord r)` — insert record at position i
  - Pre-store count before loop: `int count = rs.getRecordCount();` (performance guideline)
- Mapping Rule: `XPFA-I-NOITM` (item count field) → `rs.getRecordCount()`. `array(WK-I)` (1-indexed) → `rs.getRecord(WK_I - 1)` (0-indexed). Never call `getRecordCount()` inside loop condition (performance guideline).

---

### [n-KESA API] - IRecordSet: Record addition
- z-KESA: `MOVE value TO array-field(WK-I)` within PERFORM loop
- n-KESA: `rs.newRecord()` then `record.set()`
- z-KESA Detail: Fill array element by moving values to subscripted fields inside a loop.
- n-KESA Detail:
  - `IRecord record = rs.newRecord()` — adds new row at end, returns reference
  - `record.set("name", "JOHN")` — set field value by column name (preferred)
  - `record.set(0, "JOHN")` — set by column index (not recommended — fragile if columns change)
  - `IRecord record = rs.newRecord(2)` — insert at row index 2
  - After `newRecord()`, record has null values — must be filled before use
- Mapping Rule: COBOL array-fill loop → Java: `IRecord r = rs.newRecord(); r.set("col1", value1); r.set("col2", value2);`. Batch DB insert pattern: for each row in source RS, create record in output RS with `newRecord()` and populate.

---

### [n-KESA API] - IRecordSet: Record removal
- z-KESA: No direct equivalent (OCCURS is fixed-size)
- n-KESA: `removeRecord(int i)`
- z-KESA Detail: OCCURS tables are fixed-size; removal is simulated by zeroing/spacing values.
- n-KESA Detail:
  - `rs.removeRecord(int i)` — remove record at index i, returns removed `IRecord`
  - Index is 0-based (same as `java.util.List`)
  - CAUTION: removing shifts subsequent records — account for index changes in loops
  - Removing N consecutive records from index start: loop `rs.removeRecord(start)` N times (same index each time)
  - Removing from end backwards: `for (int i = n-1; i >= 0; i--) rs.removeRecord(start + i)` (recommended — easier to reason about)
- Mapping Rule: No COBOL equivalent. When filtering records: iterate, collect indices to remove, then remove in reverse-index order to avoid shifting issues. Pattern: `for (int i = rs.getRecordCount() - 1; i >= 0; i--) { if (shouldRemove(rs.getRecord(i))) { rs.removeRecord(i); } }`.

---

### [n-KESA API] - IRecordSet: Clone / copy
- z-KESA: Manual field-by-field `MOVE` between two array areas
- n-KESA: `rs.clone()` / `rs.clone(headerNames)`
- z-KESA Detail: Copying between arrays requires explicit PERFORM loop with MOVE statements.
- n-KESA Detail:
  - `IRecordSet clone1 = source.clone()` — full deep clone (all headers and all records)
  - `IRecordSet clone2 = source.clone(new String[]{"acno", "acnBal"})` — partial clone with selected columns only
  - CRITICAL: Two DataSets cannot share the same RecordSet object via `put()` — changes propagate. Always `clone()` when same RS goes to multiple DataSets.
  - `IRecord r = rs.getRecord(0).clone()` — clone a single record for insertion into another RS
- Mapping Rule: `MOVE CORR array1 TO array2` → `IRecordSet copy = source.clone()`. Adding to different DataSet: `dataset2.put("result", recordSet.clone())`. Moving records between RS: `IRecord r = rs1.removeRecord(i); rs2.addRecord(r)`. Copying records: `IRecord r = rs1.getRecord(i).clone(); rs2.addRecord(r)`.

---

### [n-KESA API] - IRecordSet: Sort
- z-KESA: External SORT utility / SORT statement (Batch) / sequential ordered access
- n-KESA: `DataSetUtils.sort()`
- z-KESA Detail: COBOL SORT requires a separate SORT work file and SD (Sort Description). In-memory sorting of OCCURS tables requires custom PERFORM loop logic.
- n-KESA Detail:
  - `import nexcore.framework.core.util.DataSetUtils`
  - `IRecordSet newRs = DataSetUtils.sort(rs, "ADDRESS", true)` — sort by one column (true=ascending)
  - `IRecordSet newRs = DataSetUtils.sort(rs, new String[]{"empNo", "ADDRESS"}, new boolean[]{true, false})` — multi-column sort
  - `IRecordSet newRs = DataSetUtils.sort(rs, "empNo", "-ADDRESS")` — shorthand: no prefix = ascending, "-" prefix = descending
  - `IRecordSet sort(IRecordSet rs, int sortingIndex, boolean ascending)` — sort by column index
  - `IRecordSet sort(IRecordSet rs, int[] sortingIndices, boolean[] ascendings)` — multi-column by index
  - Sort returns a NEW object — original RS is unchanged
- Mapping Rule: `SORT` statement → `DataSetUtils.sort(rs, "colName", true/false)`. Always capture return value (new sorted RS). Cannot sort in-place. Must import `nexcore.framework.core.util.DataSetUtils`.

---

### [n-KESA API] - IRecordSet: forEach / for-each iteration
- z-KESA: `PERFORM VARYING idx FROM 1 BY 1 UNTIL idx > count`
- n-KESA: Enhanced for-each loop or indexed for loop
- z-KESA Detail: Standard PERFORM VARYING loop for iterating array elements.
- n-KESA Detail:
  - `for (IRecord r : rs) { r.getString("col1"); r.getInt("col2"); }` — enhanced for-each (clean, preferred for read-only)
  - `int count = rs.getRecordCount(); for (int i = 0; i < count; i++) { IRecord r = rs.getRecord(i); }` — indexed for (needed when index matters)
  - Performance: pre-store `getRecordCount()` before loop — never call inside condition check
- Mapping Rule: Read-only iteration → enhanced for-each. When index needed (e.g., positional insert/remove, COBOL subscript arithmetic) → indexed for loop. `PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > cnt` → `int cnt = rs.getRecordCount(); for (int i = 0; i < cnt; i++)` with `WK-I = i + 1` mapping if needed.

---

### [n-KESA API] - IRecordSet: Map/List conversion
- z-KESA: No direct equivalent
- n-KESA: `getRecordMap(i)` / `getRecordMaps()`
- z-KESA Detail: Not applicable in COBOL.
- n-KESA Detail:
  - `Map<String, Object> getRecordMap(int i)` — convert record at index i to Map
  - `List<Map<String, Object>> getRecordMaps()` — convert entire RecordSet to List of Maps
  - Used when interfacing with non-framework APIs that expect Map/List format
- Mapping Rule: When passing RS data to Map-expecting APIs → `rs.getRecordMaps()`. When processing single record as Map → `rs.getRecordMap(i)`.

---

## PART 6: IRecord FULL API

---

### [n-KESA API] - IRecord: Field value get/set
- z-KESA: Direct field reference within OCCURS structure
- n-KESA: `record.getString()` / `record.set()`
- z-KESA Detail: Sub-fields under OCCURS accessed by name with subscript: `FIELD-NAME(WK-I)`.
- n-KESA Detail:
  - `Object get(String headerName)` — get value as Object
  - `Object get(int index)` — get value by column index
  - `Object set(String headerName, Object value)` — set value by column name (preferred)
  - `Object set(int index, Object value)` — set value by column index (not recommended)
  - `String getString(String headerName)` — get as String
  - `short getShort(String headerName)` — get as short
  - `int getInt(String headerName)` — get as int
  - `long getLong(String headerName)` — get as long
  - `float getFloat(String headerName)` — get as float
  - `double getDouble(String headerName)` — get as double
  - `BigDecimal getBigDecimal(String headerName)` — get as BigDecimal
  - `byte[] getByteArray(String headerName)` — get as byte array
  - `IRecordSet getRecordSet(String headerName)` — get nested RecordSet
  - `Object getObject(String headerName)` — get as generic Object
  - `int size()` — number of columns
  - `boolean contains(Object key)` — check if column exists
  - `void clear()` — set all values to null
  - `Set<String> keySet()` — all column names (for Map-style iteration)
- Mapping Rule: COBOL `field(WK-I)` → `record.getString("field")` after `IRecord record = rs.getRecord(i)`. For typed access: `record.getLong("amount")` for amounts, `record.getBigDecimal("rate")` for interest rates, `record.getString("acno")` for account numbers.

---

### [n-KESA API] - IRecord: Map interaction
- z-KESA: MOVE CORRESPONDING between group items
- n-KESA: Map-to-Record iteration
- z-KESA Detail: `MOVE CORRESPONDING` copies all fields with matching names between two group items.
- n-KESA Detail: Add Map content to new record: `IRecord record = rs.newRecord(); for (String key : map.keySet()) { record.set(key, map.get(key)); }`. Preferred: iterate by record headers (not map keys) to avoid mismatched-key exception: `for (String key : record.keySet()) { if (map.containsKey(key)) { record.set(key, map.get(key)); } }`. Update existing record from Map: get record, then loop similarly.
- Mapping Rule: `MOVE CORR mapGroup TO recordGroup` → loop over `record.keySet()`, check `map.containsKey(key)`, set values. Never iterate map keys against record if map has extra keys — causes exception.

---

## PART 7: MAP / DATASET CONVERSION

---

### [n-KESA API] - Map ↔ IDataSet conversion
- z-KESA: No equivalent (COBOL data is typed/fixed)
- n-KESA: `putAll(Map)` / `toMap()`
- z-KESA Detail: Not applicable.
- n-KESA Detail:
  - `dataset.putAll(Map map)` — import all Map entries into DataSet (object references, not deep copies)
  - `Map<String, Object> dataset.toMap()` — export all scalar fields from DataSet as new Map (useful for SQL bind parameters)
  - SQL bind parameters accept Map format; `toMap()` bridges DataSet to SQL layer
- Mapping Rule: DataSet → SQL param: `Map<String, Object> sqlParam = requestData.toMap()`. Map from external system → DataSet: `dataset.putAll(externalMap)`. Note: `putAll()` does shallow copy — object references shared.

---

## PART 8: NULL HANDLING

---

### [Guideline] - Null 처리 가이드
- z-KESA: Spaces (`SPACE`/`SPACES`) and zeros (`ZERO`/`ZEROS`) serve as "empty" sentinels; no null concept
- n-KESA: `StringUtils.isBlank()` / `StringUtils.isEmpty()` / `StringUtils.equals()`
- z-KESA Detail: `IF field = SPACE` tests for all-space string (empty). `IF field = ZERO` tests for zero numeric. No null pointer risk in COBOL — fields always have a value (spaces or zeros after INITIALIZE).
- n-KESA Detail:
  - `import nexcore.framework.core.util.StringUtils`
  - `StringUtils.isEmpty(str)` → true if str is `null` or `""` (empty string)
  - `StringUtils.isBlank(str)` → true if str is `null`, `""`, `" "`, `"   "` (any whitespace-only)
  - `StringUtils.equals(var1, var2)` → true if both null, or `var1.equals(var2)` — null-safe equality
  - "Array를 return하는 경우 null 대신 비어있는 array를 return" (return empty array instead of null)
  - `String` API methods should use `StringUtils` equivalents for null safety: `isEmpty()`, `substring()`, `contains()`, `trim()`, `indexOf()`
  - `record.toString()` direct use prohibited (except for logging) — DataSet internals may undergo conversion
- Mapping Rule: `IF field = SPACE` → `StringUtils.isBlank(record.getString("field"))`. `IF field NOT = SPACE` → `!StringUtils.isBlank(record.getString("field"))`. Two-field comparison `IF A = B` → `StringUtils.equals(a, b)`. Return types: never return null from a method returning array/collection — return empty collection instead.

---

## PART 9: BIGDECIMAL ARITHMETIC

---

### [Guideline] - BigDecimal 생성 (Creation)
- z-KESA: Literal value assigned to COMP-3 field (e.g., `VALUE 0`, `VALUE 1.234567891`)
- n-KESA: `BigDecimal.valueOf()` or `new BigDecimal("string")`
- z-KESA Detail: COBOL COMP-3 stores exact decimal values internally — no floating-point imprecision.
- n-KESA Detail:
  - CORRECT: `BigDecimal a = BigDecimal.valueOf(0.1)` — uses double's canonical string form
  - CORRECT: `BigDecimal b = new BigDecimal("0.01")` — uses exact String representation
  - WRONG: `BigDecimal a = new BigDecimal(0.1)` — uses double's imprecise binary representation → `0.09000000000000001` result
  - Rule: NEVER pass a `double` literal directly to `new BigDecimal()` constructor
- Mapping Rule: `01 A PIC S9(6)V9(12) COMP-3 VALUE 0.` → `BigDecimal a = BigDecimal.ZERO;`. Literal value → `BigDecimal.valueOf(literalDouble)` or `new BigDecimal("literalString")`. From long: `BigDecimal.valueOf(longValue)`. From String: `new BigDecimal(stringValue)`.

---

### [Guideline] - BigDecimal 더하기 (Addition)
- z-KESA: `COMPUTE C = A + B` or `ADD A TO B GIVING C`
- n-KESA: `BigDecimal.add()`
- z-KESA Detail: COBOL arithmetic with COMP-3 is exact. `COMPUTE` statement handles mixed types automatically.
- n-KESA Detail: `public BigDecimal add(BigDecimal augend)`. Example: `BigDecimal c = a.add(b)` for `0.03 + 0.001`.
- Mapping Rule: `COMPUTE C = A + B` → `BigDecimal c = a.add(b)`. `ADD AMT1 TO TOTAL` → `total = total.add(amt1)`.

---

### [Guideline] - BigDecimal 빼기 (Subtraction)
- z-KESA: `COMPUTE C = A - B` or `SUBTRACT A FROM B GIVING C`
- n-KESA: `BigDecimal.subtract()`
- z-KESA Detail: `SUBTRACT AMT FROM BALANCE GIVING RESULT`.
- n-KESA Detail: `public BigDecimal subtract(BigDecimal subtrahend)`. Example: `BigDecimal c = a.subtract(b)` for `0.03 - 0.001`.
- Mapping Rule: `COMPUTE C = A - B` → `BigDecimal c = a.subtract(b)`. `SUBTRACT A FROM B` → `b = b.subtract(a)`.

---

### [Guideline] - BigDecimal 곱하기 (Multiplication)
- z-KESA: `COMPUTE C = A * B` or `MULTIPLY A BY B GIVING C`
- n-KESA: `BigDecimal.multiply()`
- z-KESA Detail: `MULTIPLY RATE BY BALANCE GIVING INTEREST`. Guideline: group repeated multiplication factors for performance.
- n-KESA Detail: `public BigDecimal multiply(BigDecimal multiplicand)`. Example: `BigDecimal c = a.multiply(b)` for `0.03 * 0.001`.
- Mapping Rule: `COMPUTE C = A * B` → `BigDecimal c = a.multiply(b)`. `COMPUTE INTEREST = BALANCE * RATE` → `BigDecimal interest = balance.multiply(rate)`.

---

### [Guideline] - BigDecimal 나누기 (Division)
- z-KESA: `COMPUTE C = A / B` or `DIVIDE A BY B GIVING C`
- n-KESA: `BigDecimal.divide()` with `MathContext`
- z-KESA Detail: COBOL DIVIDE requires ROUNDED or truncation behavior. Unlimited precision may cause issues without size constraints.
- n-KESA Detail: `public BigDecimal divide(BigDecimal divisor, int scale, RoundingMode roundingMode)`. Example: `BigDecimal c = a.divide(b, MathContext.DECIMAL64)` for `1 / 0.03 = 33.33333333333333`. CRITICAL: division MUST specify `MathContext` to avoid `ArithmeticException` on non-terminating decimals. Guideline: "나누기 연산시에는 오차 최소화를 위해 가능한 가장 나중에 나눗셈을 하도록 하십시요" — perform division as late as possible to minimize rounding error accumulation.
- Mapping Rule: `COMPUTE C = A / B` → `BigDecimal c = a.divide(b, MathContext.DECIMAL64)`. With explicit scale: `a.divide(b, scale, RoundingMode.HALF_UP)`. Never `a.divide(b)` alone — throws exception for non-terminating results.

---

### [Guideline] - BigDecimal 소수점 처리 (Scale / Rounding)
- z-KESA: `ROUNDED` clause on COMPUTE / implicit truncation at V position
- n-KESA: `BigDecimal.setScale(int, RoundingMode)`
- z-KESA Detail: `COMPUTE X ROUNDED = A * B` rounds result. `V9(n)` definition implicitly truncates to n decimal places.
- n-KESA Detail: `public BigDecimal setScale(int newScale, RoundingMode roundingMode)`. Rounding modes:
  - `RoundingMode.UP` — away from zero (12.3→13, -12.3→-13)
  - `RoundingMode.DOWN` — toward zero / truncate (12.3→12, -12.3→-12)
  - `RoundingMode.CEILING` — toward +∞ (12.3→13, -12.3→-12)
  - `RoundingMode.FLOOR` — toward -∞ (12.3→12, -12.3→-13)
  - `RoundingMode.HALF_UP` — round half up / 반올림 (12.5→13, 12.3→12)
  - `RoundingMode.HALF_DOWN` — round half down (12.5→12, 12.6→13)
  - Example: `c.setScale(0, RoundingMode.DOWN)` truncates to integer (33.333... → 33)
- Mapping Rule: `COMPUTE X ROUNDED = ...` → `result.setScale(scale, RoundingMode.HALF_UP)` (standard rounding). COBOL `V9(5)` truncation → `setScale(5, RoundingMode.DOWN)`. Interest rate rounding → use bank-standard rounding mode per business rule.

---

## PART 10: 정수형 금액 처리 (Integer Amount Handling)

---

### [Guideline] - 정수형 금액 처리 (Integer Amounts)
- z-KESA: `PIC 9(15)` or `PIC S9(15)` for amounts (DISPLAY format)
- n-KESA: `long` for integer amounts
- z-KESA Detail: Large integer amounts declared as `PIC 9(015)` (e.g., `XPFA2001-I-DRWOT-AMT PIC 9(015)` — withdrawal amount). Amounts without decimal places are pure integers.
- n-KESA Detail: `long` type required. Java `int` max = 2^31-1 = 2,147,483,647 — insufficient for KRW amounts (e.g., 1 billion KRW = 1,000,000,000 exceeds int). `long` max = 2^63-1 = 9,223,372,036,854,775,807. "MMI에 long 타입이 없으므로 금액 항목은 반드시 BigDecimal 로 정의" — in MMI (screen interface) definition, since `long` is unavailable, define amount fields as `BigDecimal`. In internal Java code, `long` is acceptable for integer amounts.
- Mapping Rule: `PIC 9(15)` (integer amount) → `long` in Java internal variables. MMI amount fields → `BigDecimal` (required by MMI type system). `IRecord.getLong("drwotAmt")` for retrieval. `responseData.put("drwotAmt", drwotAmt)` for storage. Never use `int` for amounts.

---

### [Guideline] - 실수형 금액 처리 (Decimal Amounts)
- z-KESA: `PIC S9(n)V9(m) COMP-3` for decimal amounts (rates, fees, interest)
- n-KESA: `BigDecimal` mandatory
- z-KESA Detail: Interest rates, fees, ratios use COMP-3 with V decimal positions. float/double equivalent does not exist in COBOL financial calculations — COMP-3 is always exact.
- n-KESA Detail: `BigDecimal` mandatory for: interest rates (금리), fees (수수료), ratios, any amount with decimal places. `float` and `double` PROHIBITED — produce floating-point errors. Example of error: `double c = 0.1 - 0.01 = 0.09000000000000001` (wrong). Correct: `BigDecimal c = BigDecimal.valueOf(0.1).subtract(BigDecimal.valueOf(0.01))` = `0.09`.
- Mapping Rule: `PIC S9(n)V9(m) COMP-3` (rate/fee field) → `BigDecimal`. `getBigDecimal("plyIrt")` for interest rate. All arithmetic on decimal amounts → BigDecimal chain: `a.add(b)`, `a.subtract(b)`, `a.multiply(b)`, `a.divide(b, MathContext.DECIMAL64)`.

---

## PART 11: 상수 클래스 작성 규칙

---

### [Guideline] - 상수 패키지 명명규칙 (Constants Package Naming)
- z-KESA: `CO-` prefix for constant variables in WORKING-STORAGE CONSTANT AREA (`01 CO-AREA`)
- n-KESA: `consts` sub-package
- z-KESA Detail: Constants declared in `CO-AREA` with `CO-` prefix: `CO-PGM-ID`, `CO-STAT-OK`, `CO-STAT-ERROR`, `CO-STAT-ABNORMAL`, `CO-STAT-SYSERROR`, `CO-B9900000`, `CO-UKJI0000`. Never initialized in INITIALIZE statement (CO-AREA is excluded from INITIALIZE).
- n-KESA Detail: Package naming: base package + `.consts` suffix (e.g., `com.kbstar.sqc.fa.consts`). Class naming follows constant class naming rules. Package is per-component — "상수 클래스는 반드시 동일 컴포넌트 내에서만 사용 가능" (constants class can only be used within same component — referencing another component's constants causes compile error during deployment).
- Mapping Rule: `01 CO-AREA.` → `package com.kbstar.sqc.[appcode].consts;`. Each logical constant group → separate constants class. Never reference constants from another component's `consts` package.

---

### [Guideline] - 상수 클래스 명명규칙 (Constants Class Naming)
- z-KESA: `CO-` prefix variables in WORKING-STORAGE
- n-KESA: `C` prefix class, `public static` (NOT `public static final`)
- z-KESA Detail: Constants in COBOL are implicitly final (VALUE clause sets them once). Program-level constants stored in CO-AREA.
- n-KESA Detail:
  - Class declaration: `public class CSampleConsts { ... }` — prefix `C`
  - Members: `public static String CONST1 = "11";` — `public static`, NOT `public static final`
  - CRITICAL RULE: "상수 클래스는 class로 작성하고 반드시 public static으로 하십시요. (public static final 금지)" — `final` is PROHIBITED
  - Reason for no `final`: Java compiler inlines `static final` values at compile time. If the constant value changes and only the constants class is redeployed, callers still use the old inlined value. Without `final`, callers read the value at runtime from the class — correct value is always used.
  - Constants naming: ALL UPPERCASE with `_` separators, optionally numbers: `STAT_OK`, `STAT_ERROR`, `ERR_CODE_B1050001`
- Mapping Rule: `03 CO-STAT-OK PIC X(002) VALUE '00'` → `public static String STAT_OK = "00";`. `03 CO-PGM-ID PIC X(008) VALUE 'AFA2001'` → `public static String PGM_ID = "AFA2001";`. `03 CO-B9900000 PIC X(008) VALUE 'B9900000'` → `public static String ERR_B9900000 = "B9900000";`.

---

### [Guideline] - 상수 작성 주의사항 (Constants Usage Warning)
- z-KESA: CO-AREA constants accessible throughout the program
- n-KESA: Constants class scope is component-only
- z-KESA Detail: COBOL constants are program-scoped — accessible everywhere in the program without restriction.
- n-KESA Detail: "타 컴포넌트의 상수 클래스를 참조하면 배포 과정에서 컴파일 에러가 발생합니다" — cross-component constant reference causes deployment compile error. Use string literals or define local constants when cross-component constant sharing appears necessary.
- Mapping Rule: Keep each component's constants strictly within its own `consts` package. Do not import constants from other components. If a constant value is needed cross-component, pass it as a `String` parameter or define independently in each component.

---

## PART 12: 주석 작성 규칙

---

### [Guideline] - 주석 작성 (Comment Rules)
- z-KESA: `*` in column 7 for line comment; `*@` for framework-recognized comments
- n-KESA: Javadoc `/** */`, block `/* */`, single-line `//`
- z-KESA Detail: `*` in column 7-8 = standard comment. `*@` in column 7-8 = framework info comment (extracted by PreCompile). PARAGRAPH comments placed on line above `~-RTN.`. Pseudo-code comments for processing flow inside S3000. Error comments: error code on right side of ERROR macro line.
- n-KESA Detail:
  - Class Javadoc: above class declaration — program description, version history, `@author`, `@since`
  - Method Javadoc: above each method — description, `@param requestData`, `@param onlineCtx`, `@return`, input/output field list
  - Single-line: `//` on same line or line above
  - Multi-line: `/* ... */` above the code block
  - Error comment: `// Bxxxxxxx: 에러 메시지 코드. // Uxxxxxxx: 조치 메시지 코드.` on same line as throw
  - Conditional comment: code value annotations in if/switch: `if (!"1".equals(cashaltr) && //1 : 현금`
  - Multi-condition alignment: each condition on its own line, `||` or `&&` at start of continuation line
- Mapping Rule: `*@ 초기화 루틴` (PARAGRAPH comment) → method-level Javadoc `/** initialize routine */`. `*@ 조회처리` (processing comment) → single-line `// 조회처리` before the relevant code block. `#ERROR CO-B1050001` → `throw new BusinessException("B1050001", "U1050001", e); // B1050001: 에러메시지`. Code value comments required in all conditional branches.

---

## PART 13: 금기 규칙 (Prohibited Practices)

---

### [Guideline] - 금기 규칙 (Absolute Prohibitions)
- z-KESA: `DISPLAY` prohibited; `EXEC CICS` prohibited; `EXEC SQL` prohibited; `GOBACK` prohibited (online); `CALL` prohibited (use #DYCALL); `GO TO` restricted
- n-KESA: Corresponding Java prohibitions
- z-KESA Detail:
  - `DISPLAY` prohibited → use `#USRLOG` macro
  - `EXEC CICS` prohibited → use framework MACRO
  - `EXEC SQL` prohibited → use DBIO or SQLIO
  - `GOBACK` prohibited in online programs → use `#ERROR` or `#OKEXIT`
  - `CALL` prohibited → use `#DYCALL` macro
  - `GO TO` restricted — PARAGRAPH-internal GO TO only
  - `IF` must close with `END-IF`; `IN-LINE PERFORM` must close with `END-PERFORM`; `EVALUATE` must close with `END-EVALUATE`

- n-KESA Detail (all are absolute "금기 규칙"):
  - `System.exit()` — PROHIBITED: "어떠한 이유로도 component가 전체 시스템을 종료시켜서는 안된다"
  - `java.lang.Runtime` object usage — PROHIBITED: performance impact and unsafe process creation
  - `java.lang.Thread` inheritance — PROHIBITED: "Java는 다중 상속 지원하지 않음. start되지 않는 Thread instance는 심각한 메모리 손실 초래." Use `java.lang.Runnable` interface instead
  - `System.out` / `System.err` — PROHIBITED: "어떠한 이유로도 직접적인 출력 허용되지 않음. 반드시 logger를 사용"
  - `printStackTrace()` — PROHIBITED: "직접적인 호출 금지. Logger의 debug와 error 메소드를 사용"
  - Password in source code — PROHIBITED: "모든 password는 source code 또는 preferences xml에 직접 노출해서는 안됨"
  - `record.toString()` for value extraction — PROHIBITED except for logging: "DataSet 내 Field, RecordSet, Record 클래스의 toString() 직접 사용금지"
  - `COMMIT`/`ROLLBACK` in XSQL — PROHIBITED: "프레임워크에서 트랜잭션을 관리. 개별 XSQL 문에 COMMIT/ROLLBACK 구문은 절대 사용 금지"
  - Unit CALL DEPTH exceeding 30 — PROHIBITED: "유닛의 CALL DEPTH 최대값(30)을 넘어서는 안된다"
  - Singleton unit class member fields — PROHIBITED (except `@BizUnitBind`): "유닛 클래스 내 멤버필드 사용은 금지"

- Mapping Rule: `DISPLAY var` → `log.debug("fieldName: {}", value)` using ILog. `EXEC SQL ... END-EXEC` → call DM method with `@BizMethod` using XSQL. Direct CALL → callSharedMethod API or PM/FM invocation through framework. Inline error print → `log.error(...)` with BusinessException throw.

---

## PART 14: 성능 주의사항 (Performance Guidelines)

---

### [Guideline] - 메모리 사용 성능 (Memory Performance)
- z-KESA: String handling via MOVE (efficient, direct memory copy); no dynamic memory allocation
- n-KESA: StringBuilder with pre-set capacity; no String + concatenation
- z-KESA Detail: COBOL string operations are direct memory operations — no GC overhead. MOVE is highly efficient. `INITIALIZE` minimal overhead at group level.
- n-KESA Detail:
  - "String의 + 연산 금지: String은 immutable 객체이므로 + 연산을 1번할 때마다 새로운 instance가 1개씩 생성됨" — every `+` creates a new String instance; multiple concatenations → exponential memory growth
  - "크기를 설정하지 않은 StringBuffer의 사용 금지: 정확한 크기를 예상할 수 없다면 넉넉하게 설정" — always specify initial capacity: `new StringBuilder(256)`
  - "static Map/List의 사용: static으로 선언된 Map/List는 해당 class의 instance가 소멸되더라도 내용이 항상 남아있음. Singleton/Multition이 아닌 경우 사용해서는 안됨"
  - Unit CALL DEPTH max 30: "유닛의 CALL DEPTH 최대값(30)을 넘어서는 안됨"
- Mapping Rule: String building → always `StringBuilder sb = new StringBuilder(estimatedLength)` then `sb.append()`. Never `str = str + part`. Pre-estimate capacity or use generous default (256, 512). Static collections → use only for true static configuration data in Singleton classes.

---

### [Guideline] - 속도 성능 (Speed Performance)
- z-KESA: BINARY(COMP) for subscripts; avoid OCCURS DEPENDING ON; group INITIALIZE; constant GROUP for compiler optimization
- n-KESA: Pre-store loop bounds; pre-size Map/List; no Runtime.gc()
- z-KESA Detail: COBOL performance rules: BINARY(COMP) fastest for loop subscripts; COMP-3 good for calculations; avoid mismatched data types in operations (causes type conversion overhead); group repeated constants in parentheses for compiler optimization; PERFORM VARYING with INDEXED BY is faster than subscript.
- n-KESA Detail:
  - "Runtime.gc() 호출 금지: garbage collection은 사용자가 임의로 제어해서는 안됨. JVM full GC 동안 정지됨"
  - "for 루프의 조건에 method 호출 금지: `for (int i=0; i<map.size(); i++)` → 매번 method 호출하여 속도 저하. 반드시 다른 변수에 저장한 다음 사용" → `int size = map.size(); for (int i = 0; i < size; i++)`
  - "Map/List의 초기화에 크기를 지정: 크기를 미리 지정하지 않으면 객체가 추가될 때마다 메모리 할당이 일어나 속도 저하. 적절한 초기 크기와 증가 값을 지정" → `new HashMap<>(initialCapacity)`, `new ArrayList<>(initialCapacity)`
  - 나누기 연산: perform as late as possible — "나누기 연산시에는 오차 최소화를 위해 가능한 가장 나중에 나눗셈을 하도록"
- Mapping Rule: `PERFORM VARYING WK-I FROM 1 BY 1 UNTIL WK-I > COUNT` → pre-store: `int count = rs.getRecordCount(); for (int i = 0; i < count; i++)`. Map with known size → `new HashMap<>(expectedSize)`. List with known size → `new ArrayList<>(expectedSize)`. COBOL COMPUTE sequence (multiply before divide) → preserve same arithmetic order in Java BigDecimal chain.

---

### [Guideline] - Java 기본 주의사항 (Java Basic Guidelines)
- z-KESA: Structured programming; top-down flow; no ALTER; restricted GO TO
- n-KESA: Structured Java coding rules
- z-KESA Detail: COBOL guidelines: EVALUATE/PERFORM for structured code; top-down flow; no backward branching; no ALTER; no PERFORM with GO TO inside. INITIALIZE at group level (minimize per-variable). Remove unused variables.
- n-KESA Detail:
  - **String**: Use `StringUtils` (framework) for null safety — `isEmpty()`, `substring()`, `contains()`, `trim()`, `indexOf()` etc.
  - **Cloneable**: Always call `super.clone()` when implementing `clone()`
  - **Null**: Return empty array/collection, never null, from array-returning methods
  - **Loop**: Do not modify loop control variable inside loop body; no infinite loops
  - **If**: Always use `{ }` braces; no empty if blocks; prefer positive conditions over negation (`if (!isTrue())` → bad)
  - **Comparison**: Never use `==` or `!=` for Object comparison (especially String); never compare class names via `getName()`; put constant on LEFT of `equals()`: `"value".equals(variable)` not `variable.equals("value")`
  - **Declaration**: Non-static string constants should be `static` variables, not repeated literals
  - **Thread**: Never call `Thread.stop()` or `Thread.suspend()`; no `this` as lock in `synchronized` block; use `wait`/`notify` instead of `while(sleep)`
  - **Exception**: No `instanceof` in catch to distinguish exceptions; never extend/create `Error`, `Exception`, `RuntimeException`, or `Throwable` directly; catch only specific exceptions needed; no catch-all `catch(Throwable e)` or `catch(Exception e)` without specific handling
- Mapping Rule: COBOL `EVALUATE` (multi-branch) → Java `switch` or `if-else` always with `default` / `else` branch. `IF condition = SPACE` → `"value".equals(variable)` (constant left). COBOL error `#ERROR CO-B1050001` → `throw new BusinessException("B1050001", "U1050001", e)`. Catch: `catch(BusinessException e) { throw e; } catch(Exception e) { throw new BusinessException("errCode", "treatCode", "msg", e); }`.

---

## PART 15: PROGRAM STRUCTURE MAPPING

---

### [Structure] - WORKING-STORAGE SECTION → Local variables + DataSet
- z-KESA: `WORKING-STORAGE SECTION` with CO-AREA, WK-AREA, interface areas
- n-KESA: Local variables in method scope + constants class + DataSet
- z-KESA Detail: Structure:
  - `01 CO-AREA` (CONSTANT AREA) — program constants with `CO-` prefix; NOT initialized by INITIALIZE
  - `01 WK-AREA` (WORKING AREA) — temporary work variables with `WK-` prefix; MUST be initialized
  - Interface parameter areas (`01 XPxx-CA`, `01 XDxx-CA`) — MUST be initialized
  - DBIO/SQLIO interface areas (COPY YCDBIOCA, COPY YCDBSQLA)
  - TABLE ACCESS interface areas (`01 TKxx-KEY`, `01 TRxx-REC`)
- n-KESA Detail: Java method scope: all local variables declared at method start. Constants → `CSampleConsts` class with `public static String`. Work variables → local `String`, `long`, `BigDecimal` variables. Interface params → `IDataSet param = new DataSet()` per sub-call. DBIO → DBIO unit class injected via `@BizUnitBind`. RecordSet results → local `IRecordSet rs` variables.
- Mapping Rule: `01 CO-AREA` → `CSampleConsts` constants class. `01 WK-AREA` → local Java variables (`String wkAccno`, `long wkAmt`, `BigDecimal wkRate`). `01 XPFA-CA` (PC interface) → `IDataSet pcParam = new DataSet()`. `COPY YCDBIOCA` (DBIO interface) → DBIO unit class reference via `@BizUnitBind private DBIOClassName dbioName`.

---

### [Structure] - LINKAGE SECTION + PROCEDURE DIVISION USING → Method signature
- z-KESA: `LINKAGE SECTION` + `PROCEDURE DIVISION USING YCCOMMON-CA YNxx-CA`
- n-KESA: `public IDataSet methodName(IDataSet requestData, IOnlineContext onlineCtx)`
- z-KESA Detail: `LINKAGE SECTION` declares parameters received from caller. First is always `YCCOMMON-CA` (framework Common Area). Then input copybook `YNxx-CA` and output copybook `YPxx-CA`. PROCEDURE DIVISION USING lists them in order.
- n-KESA Detail: Standard method signature for ALL business methods (PM, FM, DM, DBM): `public IDataSet methodName(IDataSet requestData, IOnlineContext onlineCtx)`. `requestData` = input data (equivalent to `YNxx-CA`). `onlineCtx` = context including CommonArea (equivalent to `YCCOMMON-CA`). Return `IDataSet responseData` (equivalent to `YPxx-CA`). CommonArea accessed via `getCommonArea(onlineCtx)`.
- Mapping Rule: `01 YCCOMMON-CA` → `IOnlineContext onlineCtx` + `CommonArea ca = getCommonArea(onlineCtx)`. `01 YNxx-CA` (input) → `IDataSet requestData`. `01 YPxx-CA` (output) → `IDataSet responseData = new DataSet()`.

---

### [Structure] - S0000 to S9000 PARAGRAPH structure → Method body structure
- z-KESA: Four-paragraph structure: S1000-INITIALIZE, S2000-VALIDATION, S3000-PROCESS, S9000-FINAL
- n-KESA: Method body with four logical sections
- z-KESA Detail:
  - `S0000-MAIN-RTN` → calls all four paragraphs in sequence
  - `S1000-INITIALIZE-RTN` → INITIALIZE WK-AREA, interface areas; set initial status; #GETOUT for output area
  - `S2000-VALIDATION-RTN` → input field validation; #ERROR on failure
  - `S3000-PROCESS-RTN` → business logic; #DYCALL sub-programs; #DYDBIO for DB access; MOVE results to output
  - `S9000-FINAL-RTN` → `#OKEXIT CO-STAT-OK` for normal termination
- n-KESA Detail: PM method body structure:
  ```
  IDataSet responseData = new DataSet();       // initialize (S1000 equivalent)
  // TODO 입력값 검증                           // validation (S2000 equivalent)
  try {
      // TODO 업무 로직 작성                    // process (S3000 equivalent)
      // TODO 출력 값 설정
  } catch(BusinessException e) { throw e; }   // error handling
  catch(Exception e) { throw new BusinessException(...); }
  return responseData;                         // final return (S9000 equivalent)
  ```
- Mapping Rule: `S1000-INITIALIZE-RTN` → `IDataSet responseData = new DataSet()` + local variable declarations. `S2000-VALIDATION-RTN` → input validation before `try` block (or first in `try`). `S3000-PROCESS-RTN` → inside `try { }` block. `S9000-FINAL-RTN` → `return responseData`. `#ERROR` → `throw new BusinessException("errCode", "treatCode")`. `#OKEXIT` → `return responseData`.

---

### [Structure] - #DYCALL (Dynamic Call) → Framework unit method call
- z-KESA: `#DYCALL PGM-NAME YCCOMMON-CA XPGM-CA`
- n-KESA: `@BizUnitBind` injected unit + method call
- z-KESA Detail: `#DYCALL` invokes another COBOL program dynamically. Always passes `YCCOMMON-CA` as first parameter. Interface area `XPxx-CA` as second. Result checked via `IF NOT COND-X-OK` using 88-level condition.
- n-KESA Detail: Same-component unit calls via `@BizUnitBind` injection: `@BizUnitBind private FUXxx fuXxx;` then `IDataSet result = fuXxx.methodName(param, onlineCtx)`. Cross-component: `callSharedMethod***` API. Result check: `if (!STAT_OK.equals(result.getString("rStat"))) { throw new BusinessException(...); }`.
- Mapping Rule: `#DYCALL DFA9202 YCCOMMON-CA XDFA9202-CA` → inject `@BizUnitBind private DUFAxx duFAxx;` and call `IDataSet result = duFAxx.select(param, onlineCtx)`. Error check: `IF XDFA9202-R-STAT NOT = CO-STAT-OK` → `if (!STAT_OK.equals(result.getString("rStat"))) { throw new BusinessException("B1212345", "U1234"); }`.

---

### [Structure] - #DYDBIO (DBIO Call) → DBIO unit method call
- z-KESA: `#DYDBIO SELECT-CMD-Y TKFACO13-KEY TRFACO13-REC`
- n-KESA: DBIO unit `@BizMethod` call (SELECT, INSERT, UPDATE, DELETE)
- z-KESA Detail: DBIO commands: SELECT-CMD-N/Y, INSERT-CMD-Y, UPDATE-CMD-Y, DELETE-CMD-Y, LKUPDT-CMD-Y, OPEN-CMD-n, FETCH-CMD-n, CLOSE-CMD-n, SELFST-CMD-n. Result codes: 00=OK, 01=KEYDUP, 02=NOTFOUND, 09=error, 98/99=system error.
- n-KESA Detail: DBIO class (DBM) methods: `select(param, ctx)`, `selectForUpdate(param, ctx)`, `insert(param, ctx)`, `update(param, ctx)`, `delete(param, ctx)`. Result checked by return code. `COND-DBIO-OK` → return stat `"00"`. `COND-DBIO-MRNF` → `"02"`. `COND-DBIO-DUPM` → `"01"`.
- Mapping Rule: `#DYDBIO SELECT-CMD-Y TKFAEC03 TRFAEC03` → `IDataSet result = dbioFaec03.select(param, onlineCtx)`. `#DYDBIO INSERT-CMD-Y` → `dbio.insert(param, onlineCtx)`. `#DYDBIO UPDATE-CMD-Y` → `dbio.update(param, onlineCtx)`. `#DYDBIO DELETE-CMD-Y` → `dbio.delete(param, onlineCtx)`. EVALUATE result codes → `switch` on return stat value.

---

### [Structure] - Error handling: #ERROR → BusinessException
- z-KESA: `#ERROR CO-BERRCODE CO-UTREATCODE CO-STAT-ERROR`
- n-KESA: `throw new BusinessException("errCode", "treatCode")`
- z-KESA Detail: `#ERROR` macro: sets error code and treat code in YCCOMMON-CA, sets STAT to error value, immediately returns to caller. `#CSTMSG` macro sets custom message before `#ERROR`. Three-parameter form: `#ERROR errMsgCode treatMsgCode statusCode`. Error processing at point of failure — "오류발생 위치에서 발행".
- n-KESA Detail: `throw new BusinessException("B1050001", "U1050001")` — two parameters. With custom message: `throw new BusinessException("Bxxxxxxx", "Uxxxxxxx", "맞춤메시지", e)`. Caught and re-thrown: `catch(BusinessException e) { throw e; }`. Wrapped: `catch(Exception e) { throw new BusinessException("errCode", "treatCode", "msg", e); }`. Error comment format: `// Bxxxxxxx: 에러 메시지 코드. // Uxxxxxxx: 조치 메시지 코드.`
- Mapping Rule: `#ERROR CO-B1050001 CO-UKFA5002 CO-STAT-ERROR` → `throw new BusinessException("B1050001", "UKFA5002");`. With preceding `#CSTMSG` (custom message) → `throw new BusinessException("B1050001", "UKFA5002", customMsg)`. EVALUATE for multi-code error → `switch(errCase) { case ...: throw new BusinessException(...); }`.

---

### [Structure] - SQLIO (SQL I/O) → DU (DataUnit) with XSQL
- z-KESA: `SQLIO` programs for complex SELECT queries via `#DYDBIO` or EXEC SQL in SQLIO
- n-KESA: `DU` (DataUnit) with `.xsql` file; `dbSelect()` / `dbSelectPage()` API
- z-KESA Detail: SQLIO handles multi-row fetch, complex WHERE conditions, JOINs. Called via `#DYDBIO OPEN-CMD-n / FETCH-CMD-n / CLOSE-CMD-n` for cursor-based retrieval. Results returned in SQLIO record copybook area.
- n-KESA Detail: DM (DataUnit) with XSQL file. SQL written in `.xsql` file. `IRecordSet rs = dbSelect("sqlId", paramDs)` returns all rows. `dbSelectPage("sqlId", paramDs, pageNum, pageSize)` for pagination. Bind variables: `#acno:VARCHAR#` (DB2 requires explicit type). Result column names: use quoted column names in SQL matching camelCase mapping.
- Mapping Rule: `SQLIO OPEN/FETCH/CLOSE` cursor pattern → `IRecordSet rs = dbSelect("selectId", param)` (fetches all). Cursor-based streaming → DM SELECT_ALL method with `dbSelect`. Paged fetch → `dbSelect("selectId", param, pageNo, pageSize)`. SQL bind: `#acno:VARCHAR#` (DB2) or `#acno#` (Oracle).

---

## QUICK REFERENCE TABLE

| COBOL (z-KESA) | Java (n-KESA) | Note |
|---|---|---|
| `PIC X(n)` | `String` | `getString()`, `StringUtils.isBlank()` |
| `PIC 9(n)` | `long` | `getLong()`, never `int` for amounts |
| `PIC S9(n)` | `long` | signed integer |
| `PIC S9(n)V9(m)` | `BigDecimal` | `getBigDecimal()`, scale=m |
| `PIC 9(n) COMP` | `int`/`long` | binary integer |
| `PIC S9(n) COMP-3` | `long` or `BigDecimal` | packed decimal |
| `PIC S9(n)V9(m) COMP-3` | `BigDecimal` | financial rate/fee |
| `OCCURS n TIMES` | `IRecordSet` | 0-indexed vs COBOL 1-indexed |
| `REDEFINES` | `substring()` / explicit convert | no direct equivalent |
| `88 COND VALUE '00'` | `String STAT_OK = "00"` | `public static` (not final) |
| `MOVE A TO B` | `ds.put("b", a)` / `r.set("b", a)` | |
| `INITIALIZE area` | `new DataSet()` / local var declaration | |
| `STRING ... INTO` | `new StringBuilder(size).append()` | NO String + |
| `UNSTRING src DELIMITED` | `src.split()` / `substring()` | `StringUtils` for null safety |
| `INSPECT REPLACING` | `str.replace()` | |
| `EVALUATE ... END-EVALUATE` | `switch` / `if-else` | always `default` |
| `IF ... END-IF` | `if () { }` | always `{ }` |
| `PERFORM VARYING FROM 1 BY 1` | `for (int i=0; i<count; i++)` | pre-store count |
| `PERFORM UNTIL cond` | `while (!cond) { }` | |
| `PERFORM S1000 THRU S1000-EXT` | private method call | |
| `COMPUTE A = B + C` | `BigDecimal c = b.add(c)` | |
| `ADD A TO B` | `b = b.add(a)` | |
| `SUBTRACT A FROM B` | `b = b.subtract(a)` | |
| `MULTIPLY A BY B GIVING C` | `c = a.multiply(b)` | |
| `DIVIDE A BY B GIVING C` | `c = a.divide(b, MathContext.DECIMAL64)` | must specify MathContext |
| `ROUNDED` | `.setScale(n, RoundingMode.HALF_UP)` | |
| `#DYCALL PGM CA XCAPG` | `@BizUnitBind` + method call | |
| `#DYDBIO CMD KEY REC` | DBIO unit method | |
| `#ERROR B U STAT` | `throw new BusinessException("B","U")` | |
| `#OKEXIT STAT-OK` | `return responseData` | |
| `DISPLAY` | `log.debug()/log.info()` | PROHIBITED direct |
| `CO-AREA` | `CSampleConsts` class | `public static`, NO `final` |
| `WK-AREA` | local Java variables | method scope |
| `= SPACE` | `StringUtils.isBlank()` | null-safe |
| `NOT = SPACE` | `!StringUtils.isBlank()` | |
| `IF A = B` (string) | `StringUtils.equals(a, b)` | null-safe |
| `EXEC SQL` | XSQL in DU | PROHIBITED direct |
| `GOBACK` | `return responseData` | online only |
| `System.exit()` | — | PROHIBITED |
| `Thread` inherit | use `Runnable` | PROHIBITED |
| `System.out/err` | `log.debug/error()` | PROHIBITED |
| `printStackTrace()` | `log.error()` | PROHIBITED |
| `String +` | `StringBuilder.append()` | PROHIBITED |
| `new BigDecimal(double)` | `BigDecimal.valueOf(double)` | PROHIBITED form |
| `float`/`double` for finance | `BigDecimal` | PROHIBITED |
| `int` for amounts | `long` or `BigDecimal` | PROHIBITED |
| `rs.getRecordCount()` in loop | pre-store count | performance |
| `static Map/List` | avoid unless Singleton | memory leak risk |

---

**Summary of what was read and mapped:**

- z-KESA (`/Users/soyeon/Projects/cobol-test/참고자료/framework/z-kesa/z-kesa_full.txt`, 29,099 lines): Sections 3.2–3.5 (coding method), WORKING-STORAGE patterns, PROCEDURE DIVISION structure, DBIO/SQLIO usage, PERFORM VARYING/UNTIL examples, EVALUATE patterns, data type table (lines 1730–1800), COMP-3 copybook examples (lines 7123–7179), performance guidelines 3.19 (lines 14534–14700), and forbidden command list.

- n-KESA (`/Users/soyeon/Projects/cobol-test/참고자료/framework/n-kesa/n-kesa_full.txt`, 13,936 lines): Section 3.2 데이터셋 사용 (lines 2750–3120): full IDataSet, IRecordSet, IRecord API. Section 3.3 기타 코딩 가이드 (lines 3121–3535): Null처리, BigDecimal arithmetic (add/subtract/multiply/divide/setScale), all RoundingMode values, 상수 클래스 작성 규칙, 주석 작성, 금기 규칙, 성능 주의사항.