"""
Neo4j COBOL 검색 툴
환경변수: NEO4J_URI=bolt://neo4j:7687, NEO4J_USER=neo4j, NEO4J_PASSWORD=c2j-pilot-2024
"""

import os
from neo4j import GraphDatabase

_driver = None

def _get_driver():
    global _driver
    if _driver is None:
        _driver = GraphDatabase.driver(
            os.environ.get("NEO4J_URI", "bolt://neo4j:7687"),
            auth=(
                os.environ.get("NEO4J_USER", "neo4j"),
                os.environ.get("NEO4J_PASSWORD", "c2j-pilot-2024"),
            ),
        )
    return _driver


def search_cobol_by_keyword(
    keyword: str,
    node_labels: list[str] | None = None,
    limit: int = 20,
) -> list[dict]:
    """
    COBOL 노드에서 키워드로 텍스트 검색합니다 (name, content 속성 대상).

    Args:
        keyword: 검색할 키워드 (대소문자 무시)
        node_labels: 검색할 노드 레이블 목록.
                     None이면 CobolProgram, CobolParagraph, CobolCopybook, CobolJCL 전체 검색.
                     사용 가능: CobolProgram, CobolParagraph, CobolCopybook,
                                CobolJCL, SqlTable, CommonUtility
        limit: 반환할 최대 결과 수

    Returns:
        [{ "label", "name", "matched_property", "properties": {file_path, program_type,
           lines_of_code, description, program, line_start, line_end, source_type, node_id} }]
    """
    if node_labels is None:
        node_labels = ["CobolProgram", "CobolParagraph", "CobolCopybook", "CobolJCL"]

    driver = _get_driver()
    results = []

    with driver.session() as session:
        for label in node_labels:
            query = f"""
                MATCH (n:{label})
                WHERE toLower(toString(n.name)) CONTAINS toLower($kw)
                   OR toLower(toString(n.content)) CONTAINS toLower($kw)
                RETURN labels(n)[0] AS label, n AS node,
                       CASE
                         WHEN toLower(toString(n.name)) CONTAINS toLower($kw) THEN 'name'
                         ELSE 'content'
                       END AS matched_property
                LIMIT $limit
            """
            for row in session.run(query, kw=keyword, limit=limit):
                props = dict(row["node"])
                results.append({
                    "label": row["label"],
                    "name": props.get("name"),
                    "matched_property": row["matched_property"],
                    "properties": {
                        k: v for k, v in props.items()
                        if k in ("file_path", "program_type", "lines_of_code",
                                 "description", "program", "line_start", "line_end",
                                 "source_type", "node_id")
                    },
                })

    seen, unique = set(), []
    for r in results:
        key = (r["label"], r["name"])
        if key not in seen:
            seen.add(key)
            unique.append(r)

    return unique[:limit]


def run_cypher_query(cypher: str, params: dict | None = None, limit: int = 50) -> list[dict]:
    """
    Cypher 쿼리를 직접 실행합니다. 복잡한 그래프 패턴 검색에 사용합니다.

    Args:
        cypher: 실행할 Cypher 쿼리 (읽기 전용 MATCH/RETURN)
        params: 쿼리 파라미터 딕셔너리 (예: {"name": "BIP0091"})
        limit: 쿼리에 LIMIT이 없을 경우 자동으로 추가할 최대 수

    Returns:
        쿼리 결과 행 목록

    ## 스키마
    노드 레이블 & 주요 속성:
      CobolProgram    : name, program_type(BATCH), lines_of_code, file_path, content,
                        description, sections, divisions, macros_used, sql_table_count,
                        sql_block_count, error_codes, author, date_written, source_type, node_id
      CobolParagraph  : name, program, content, line_start, line_end, calls, performs, macros, node_id
      CobolCopybook   : name, file_path, content, description, lines_of_code, node_id
      CobolJCL        : name, file_path, content, description, node_id
      SqlTable        : name
      CommonUtility   : name
      CobolFrameworkRule, JavaUtility, MappingRule, ReferenceChunk, ReferenceDocument

    관계 타입 (건수):
      (CobolProgram)-[:CONTAINS]->(CobolParagraph)         3765
      (CobolProgram)-[:COPIES]->(CobolCopybook)             998
      (CobolProgram)-[:USES_MACRO]->(CobolFrameworkRule)    962
      (CobolProgram)-[:CALLS]->(CobolProgram)                47
      (CobolProgram)-[:READS]->(SqlTable)                    18
      (CobolProgram)-[:CALLS_UTILITY]->(CommonUtility)       15
      (CobolProgram)-[:JAVA_TARGET]->(JavaUtility)           15
      (CobolProgram)-[:WRITES]->(SqlTable)                   12
      (CobolJCL)-[:COPIES]->(CobolCopybook)                   6
      (CommonUtility)-[:CONVERTS_TO]->(JavaUtility)
      (MappingRule)-[:MAPS_FROM]->(CommonUtility)
      (MappingRule)-[:MAPS_TO]->(JavaUtility)
      (ReferenceChunk)-[:PART_OF]->(ReferenceDocument)

    ## 예시
    # 특정 프로그램의 단락 목록
    MATCH (p:CobolProgram {name: 'BIP0091'})-[:CONTAINS]->(para:CobolParagraph)
    RETURN para.name, para.line_start, para.line_end

    # SQL 테이블을 읽는 프로그램
    MATCH (p:CobolProgram)-[:READS]->(t:SqlTable {name: 'SOME_TABLE'})
    RETURN p.name, p.program_type

    # 호출 체인 (depth 3)
    MATCH path = (p:CobolProgram {name: 'BIP0091'})-[:CALLS*1..3]->(t:CobolProgram)
    RETURN [n IN nodes(path) | n.name] AS call_chain

    # PERFORM이 많은 단락
    MATCH (p:CobolProgram)-[:CONTAINS]->(para:CobolParagraph)
    WHERE size(para.performs) >= 3
    RETURN p.name, para.name, size(para.performs) AS perform_count
    ORDER BY perform_count DESC
    """
    if "LIMIT" not in cypher.upper():
        cypher = cypher.rstrip().rstrip(";") + f"\nLIMIT {limit}"

    driver = _get_driver()
    with driver.session() as session:
        rows = []
        for record in session.run(cypher, **(params or {})):
            row = {}
            for key in record.keys():
                val = record[key]
                if hasattr(val, "_properties"):
                    row[key] = {
                        "labels": list(val.labels) if hasattr(val, "labels") else [],
                        "type": val.type if hasattr(val, "type") else None,
                        "properties": dict(val._properties),
                    }
                else:
                    row[key] = val
            rows.append(row)
        return rows


def search_reference_documents(
    keyword: str,
    doc_type: str | None = None,
    limit: int = 10,
) -> list[dict]:
    """
    사내 규격 가이드, 공통 모듈 가이드, 프레임워크 룰, 매핑 룰을 GraphDB에서 검색합니다.
    변환 검증 시 에이전트들이 참조하는 문서 전용 검색 툴입니다.

    Args:
        keyword: 검색할 키워드 (대소문자 무시)
        doc_type: 문서 유형 필터.
                  None이면 전체 문서 유형 검색.
                  사용 가능: "reference"       — ReferenceChunk, ReferenceDocument
                             "framework_rule"  — CobolFrameworkRule
                             "mapping_rule"    — MappingRule
                             "java_utility"    — JavaUtility
        limit: 반환할 최대 결과 수

    Returns:
        [{ "label", "name", "doc_type", "matched_property",
           "properties": {content, description, source_doc, chunk_index, node_id} }]
    """
    # doc_type → 검색 대상 레이블 매핑
    label_map: dict[str, list[str]] = {
        "reference":      ["ReferenceChunk", "ReferenceDocument"],
        "framework_rule": ["CobolFrameworkRule"],
        "mapping_rule":   ["MappingRule"],
        "java_utility":   ["JavaUtility"],
    }

    if doc_type is not None:
        if doc_type not in label_map:
            raise ValueError(
                f"doc_type '{doc_type}' 은 지원하지 않습니다. "
                f"사용 가능: {list(label_map.keys())}"
            )
        target_labels = label_map[doc_type]
    else:
        target_labels = [lbl for lbls in label_map.values() for lbl in lbls]

    driver  = _get_driver()
    results = []

    with driver.session() as session:
        for label in target_labels:
            query = f"""
                MATCH (n:{label})
                WHERE toLower(toString(n.name))        CONTAINS toLower($kw)
                   OR toLower(toString(n.content))     CONTAINS toLower($kw)
                   OR toLower(toString(n.description)) CONTAINS toLower($kw)
                RETURN labels(n)[0] AS label, n AS node,
                       CASE
                         WHEN toLower(toString(n.name))    CONTAINS toLower($kw) THEN 'name'
                         WHEN toLower(toString(n.content)) CONTAINS toLower($kw) THEN 'content'
                         ELSE 'description'
                       END AS matched_property
                LIMIT $limit
            """
            for row in session.run(query, kw=keyword, limit=limit):
                props = dict(row["node"])
                results.append({
                    "label":            row["label"],
                    "name":             props.get("name"),
                    "doc_type":         doc_type or "all",
                    "matched_property": row["matched_property"],
                    "properties": {
                        k: v for k, v in props.items()
                        if k in ("content", "description", "source_doc",
                                 "chunk_index", "node_id", "file_path",
                                 "rule_type", "target_language")
                    },
                })

    # 중복 제거
    seen, unique = set(), []
    for r in results:
        key = (r["label"], r["name"])
        if key not in seen:
            seen.add(key)
            unique.append(r)

    return unique[:limit]


def get_cobol_dependencies(
    program_name: str,
    direction: str = "both",
    depth: int = 3,
) -> dict:
    """
    특정 CobolProgram의 호출/의존 관계를 탐색합니다.

    Args:
        program_name: CobolProgram name (부분 일치 가능, 예: "BIP0091")
        direction: "calls"     — 이 프로그램이 호출/참조하는 대상
                   "called_by" — 이 프로그램을 호출/참조하는 대상
                   "both"      — 양방향
        depth: CALLS 관계 탐색 깊이 (기본 3, 최대 5 권장)

    Returns:
        {
          "program":    { name, program_type, lines_of_code, file_path, description, author },
          "calls":      [{ name, program_type, loc }],
          "called_by":  [{ name, program_type, loc }],
          "sql_tables": { "reads": [table_name, ...], "writes": [table_name, ...] },
          "copybooks":  [copybook_name, ...],
          "macros":     [macro_name, ...],
        }
    """
    driver = _get_driver()

    with driver.session() as session:
        rows = list(session.run(
            "MATCH (p:CobolProgram) WHERE toLower(p.name) CONTAINS toLower($name) "
            "RETURN p LIMIT 5",
            name=program_name,
        ))
        if not rows:
            return {"error": f"CobolProgram '{program_name}'을 찾을 수 없습니다."}

        node = dict(rows[0]["p"])
        exact_name = node["name"]
        result = {
            "program": {k: node[k] for k in
                        ("name", "program_type", "lines_of_code", "file_path",
                         "description", "author", "date_written")
                        if k in node},
            "calls": [],
            "called_by": [],
            "sql_tables": {"reads": [], "writes": []},
            "copybooks": [],
            "macros": [],
        }

        if direction in ("calls", "both"):
            q = f"""
                MATCH (p:CobolProgram {{name: $name}})-[:CALLS*1..{depth}]->(t:CobolProgram)
                RETURN DISTINCT t.name AS name, t.program_type AS program_type,
                       t.lines_of_code AS loc
            """
            result["calls"] = [dict(r) for r in session.run(q, name=exact_name)]

        if direction in ("called_by", "both"):
            q = f"""
                MATCH (s:CobolProgram)-[:CALLS*1..{depth}]->(p:CobolProgram {{name: $name}})
                RETURN DISTINCT s.name AS name, s.program_type AS program_type,
                       s.lines_of_code AS loc
            """
            result["called_by"] = [dict(r) for r in session.run(q, name=exact_name)]

        for rel in ("READS", "WRITES"):
            q = f"MATCH (p:CobolProgram {{name: $name}})-[:{rel}]->(t:SqlTable) RETURN t.name AS name"
            result["sql_tables"][rel.lower()] = [r["name"] for r in session.run(q, name=exact_name)]

        q = "MATCH (p:CobolProgram {name: $name})-[:COPIES]->(c:CobolCopybook) RETURN c.name AS name"
        result["copybooks"] = [r["name"] for r in session.run(q, name=exact_name)]

        q = "MATCH (p:CobolProgram {name: $name})-[:USES_MACRO]->(m:CobolFrameworkRule) RETURN m.name AS name"
        result["macros"] = [r["name"] for r in session.run(q, name=exact_name)]

    return result
