#!/usr/bin/env python3
"""
graphdb_search.py — C2J Pipeline GraphDB CLI
graphdb-search-agent가 execute 도구로 호출하는 전용 검색 스크립트.

사용법:
  python3 graphdb_search.py keyword <키워드> [--labels <Label1,Label2>] [--limit N]
  python3 graphdb_search.py cypher "<Cypher 쿼리>" [--limit N]
  python3 graphdb_search.py deps <프로그램명> [--direction both|calls|called_by] [--depth N]
  python3 graphdb_search.py guide <토픽> [--limit N]
  python3 graphdb_search.py mapping <키워드> [--status O|△|X|-] [--limit N]
  python3 graphdb_search.py fields <모듈명> [--direction INPUT|OUTPUT|ALL]
  python3 graphdb_search.py programs [--keyword <키워드>] [--limit N]
  python3 graphdb_search.py schema
"""

import argparse
import json
import sys
import os

# neo4j_tools.py 위치: 프로젝트 루트 (/app/c2j-cli-app)
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", ".."))
from neo4j_tools import (
    search_cobol_by_keyword,
    run_cypher_query,
    get_cobol_dependencies,
    search_reference_documents,
    _get_driver,
)


# ── 출력 헬퍼 ──────────────────────────────────────────────────────────────────

def _print(data, indent=2):
    """결과를 JSON으로 출력 (에이전트가 파싱하기 쉽도록)."""
    print(json.dumps(data, ensure_ascii=False, indent=indent, default=str))


def _truncate(text: str, max_len: int = 500) -> str:
    """긴 content 발췌."""
    if not text:
        return ""
    return text[:max_len] + "..." if len(text) > max_len else text


# ── subcommand 핸들러 ──────────────────────────────────────────────────────────

def cmd_keyword(args):
    """
    이름·내용 키워드 검색.
    --labels: 콤마 구분 레이블 (예: CobolProgram,CobolParagraph)
    기본 검색 대상: CobolProgram, CobolParagraph, CobolCopybook, CobolJCL
    """
    labels = [l.strip() for l in args.labels.split(",")] if args.labels else None
    results = search_cobol_by_keyword(args.keyword, node_labels=labels, limit=args.limit)
    _print({"count": len(results), "results": results})


def cmd_cypher(args):
    """Cypher 쿼리 직접 실행."""
    results = run_cypher_query(args.query, limit=args.limit)
    _print({"count": len(results), "results": results})


def cmd_deps(args):
    """프로그램 의존성 탐색 (CALLS 관계 + SQL/Copybook/Macro)."""
    result = get_cobol_dependencies(
        args.program,
        direction=args.direction,
        depth=args.depth,
    )
    _print(result)


def cmd_guide(args):
    """
    가이드 문서·프레임워크 규칙 검색.
    CobolFrameworkRule, JavaFrameworkRule, ReferenceChunk, ReferenceDocument,
    ConversionRule 을 함께 검색한다.
    """
    driver = _get_driver()
    kw = args.keyword
    limit = args.limit
    results = []

    with driver.session() as session:
        # CobolFrameworkRule
        for row in session.run(
            "MATCH (n:CobolFrameworkRule) "
            "WHERE toLower(n.name) CONTAINS toLower($kw) "
            "   OR toLower(n.description) CONTAINS toLower($kw) "
            "RETURN 'CobolFrameworkRule' AS label, n.name AS name, "
            "       n.description AS description, n.category AS category "
            "LIMIT $limit",
            kw=kw, limit=limit,
        ):
            results.append(dict(row))

        # JavaFrameworkRule
        for row in session.run(
            "MATCH (n:JavaFrameworkRule) "
            "WHERE toLower(n.name) CONTAINS toLower($kw) "
            "   OR toLower(n.description) CONTAINS toLower($kw) "
            "RETURN 'JavaFrameworkRule' AS label, n.name AS name, "
            "       n.description AS description "
            "LIMIT $limit",
            kw=kw, limit=limit,
        ):
            results.append(dict(row))

        # ConversionRule
        for row in session.run(
            "MATCH (n:ConversionRule) "
            "WHERE toLower(n.cobol_pattern) CONTAINS toLower($kw) "
            "   OR toLower(n.java_pattern)  CONTAINS toLower($kw) "
            "   OR toLower(n.description)   CONTAINS toLower($kw) "
            "RETURN 'ConversionRule' AS label, n.rule_id AS name, "
            "       n.rule_type AS category, n.cobol_pattern AS cobol_pattern, "
            "       n.java_pattern AS java_pattern, n.description AS description "
            "LIMIT $limit",
            kw=kw, limit=limit,
        ):
            results.append(dict(row))

        # ReferenceChunk
        for row in session.run(
            "MATCH (n:ReferenceChunk) "
            "WHERE toLower(n.content) CONTAINS toLower($kw) "
            "RETURN 'ReferenceChunk' AS label, n.chunk_id AS name, "
            "       left(n.content, 500) AS content, n.source_file AS source_file, "
            "       n.section AS section "
            "LIMIT $limit",
            kw=kw, limit=limit,
        ):
            results.append(dict(row))

    _print({"count": len(results), "results": results})


def cmd_mapping(args):
    """
    COBOL→Java 매핑 규칙 검색.
    --status: O(1:1) / △(부분) / X(미구현) / -(사용불가) / all(전체, 기본)
    """
    driver = _get_driver()
    kw = args.keyword
    limit = args.limit
    status_filter = args.status

    base = (
        "MATCH (m:MappingRule) "
        "WHERE (toLower(m.zkesa_module)  CONTAINS toLower($kw) "
        "    OR toLower(m.function_name) CONTAINS toLower($kw) "
        "    OR toLower(m.nkesa_method)  CONTAINS toLower($kw)) "
    )
    if status_filter and status_filter != "all":
        base += "AND m.mapping_status = $status "
        params = {"kw": kw, "status": status_filter, "limit": limit}
    else:
        params = {"kw": kw, "limit": limit}

    base += (
        "RETURN m.rule_id AS rule_id, m.zkesa_module AS zkesa_module, "
        "       m.zkesa_no AS zkesa_no, m.function_name AS function_name, "
        "       m.nkesa_method AS nkesa_method, m.mapping_status AS mapping_status, "
        "       m.category AS category "
        "ORDER BY m.mapping_status, m.zkesa_module "
        "LIMIT $limit"
    )

    results = []
    with driver.session() as session:
        for row in session.run(base, **params):
            results.append(dict(row))

    _print({"count": len(results), "results": results})


def cmd_fields(args):
    """
    CommonUtility 모듈의 입출력 FieldMapping 조회.
    --direction: INPUT / OUTPUT / ALL (기본 ALL)
    """
    driver = _get_driver()
    module_id = args.module_id
    direction = args.direction.upper() if args.direction else "ALL"

    if direction == "ALL":
        rel_filter = "HAS_INPUT_FIELD|HAS_OUTPUT_FIELD"
    elif direction == "INPUT":
        rel_filter = "HAS_INPUT_FIELD"
    elif direction == "OUTPUT":
        rel_filter = "HAS_OUTPUT_FIELD"
    else:
        print(f"[ERROR] direction은 INPUT / OUTPUT / ALL 중 하나여야 합니다: {direction}", file=sys.stderr)
        sys.exit(1)

    cypher = (
        f"MATCH (cu:CommonUtility)-[r:{rel_filter}]->(f:FieldMapping) "
        "WHERE cu.module_id = $module_id "
        "RETURN type(r) AS direction, f.cobol_field AS cobol_field, "
        "       f.pic_type AS pic_type, f.java_key AS java_key, "
        "       f.java_type AS java_type, f.description AS description "
        "ORDER BY direction, f.field_id"
    )

    results = []
    with driver.session() as session:
        for row in session.run(cypher, module_id=module_id):
            results.append(dict(row))

    if not results:
        # module_id 부분 일치 재시도
        cypher2 = (
            f"MATCH (cu:CommonUtility)-[r:{rel_filter}]->(f:FieldMapping) "
            "WHERE toLower(cu.module_id) CONTAINS toLower($module_id) "
            "RETURN cu.module_id AS module_id, type(r) AS direction, "
            "       f.cobol_field AS cobol_field, f.pic_type AS pic_type, "
            "       f.java_key AS java_key, f.java_type AS java_type, "
            "       f.description AS description "
            "ORDER BY cu.module_id, direction, f.field_id "
            "LIMIT 100"
        )
        with driver.session() as session:
            for row in session.run(cypher2, module_id=module_id):
                results.append(dict(row))

    _print({"module_id": module_id, "direction": direction, "count": len(results), "fields": results})


def cmd_programs(args):
    """
    CobolProgram 목록 조회 (키워드 필터 가능).
    COBOL 소스 content는 제외하고 메타 정보만 반환.
    """
    kw = args.keyword or ""
    limit = args.limit

    cypher = (
        "MATCH (p:CobolProgram) "
        + ("WHERE toLower(p.name) CONTAINS toLower($kw) " if kw else "")
        + "RETURN p.name AS name, p.program_type AS program_type, "
        "       p.lines_of_code AS lines_of_code, p.description AS description, "
        "       p.file_path AS file_path, p.author AS author "
        "ORDER BY p.name "
        "LIMIT $limit"
    )

    driver = _get_driver()
    results = []
    with driver.session() as session:
        for row in session.run(cypher, kw=kw, limit=limit):
            results.append(dict(row))

    _print({"count": len(results), "results": results})


def cmd_schema(_args):
    """GraphDB 스키마 요약 출력 (노드 레이블별 건수)."""
    driver = _get_driver()
    counts = {}
    labels = [
        "CobolProgram", "CobolParagraph", "CobolCopybook", "CobolJCL",
        "SqlTable", "CommonUtility", "CobolFrameworkRule", "JavaFrameworkRule",
        "JavaUtility", "MappingRule", "FieldMapping", "ConversionRule",
        "ReferenceChunk", "ReferenceDocument",
    ]
    with driver.session() as session:
        for label in labels:
            try:
                row = session.run(f"MATCH (n:{label}) RETURN count(n) AS cnt").single()
                counts[label] = row["cnt"] if row else 0
            except Exception:
                counts[label] = -1  # 노드가 없거나 레이블 없음

    _print({"node_counts": counts})


# ── argparse 설정 ──────────────────────────────────────────────────────────────

def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="graphdb_search.py",
        description="C2J Pipeline GraphDB CLI — graphdb-search-agent 전용",
    )
    sub = p.add_subparsers(dest="command", required=True)

    # keyword
    kw = sub.add_parser("keyword", help="이름·내용 키워드 검색")
    kw.add_argument("keyword", help="검색 키워드")
    kw.add_argument("--labels", default=None,
                    help="콤마 구분 노드 레이블 (예: CobolProgram,CobolParagraph)")
    kw.add_argument("--limit", type=int, default=20, help="최대 결과 수 (기본 20)")

    # cypher
    cy = sub.add_parser("cypher", help="Cypher 쿼리 직접 실행")
    cy.add_argument("query", help="실행할 Cypher 쿼리")
    cy.add_argument("--limit", type=int, default=50, help="자동 LIMIT (기본 50)")

    # deps
    dp = sub.add_parser("deps", help="프로그램 의존성 탐색")
    dp.add_argument("program", help="CobolProgram name (부분 일치 가능)")
    dp.add_argument("--direction", choices=["calls", "called_by", "both"],
                    default="both", help="탐색 방향 (기본 both)")
    dp.add_argument("--depth", type=int, default=3, help="CALLS 관계 탐색 깊이 (기본 3)")

    # guide
    gd = sub.add_parser("guide", help="가이드 문서·프레임워크 규칙 검색")
    gd.add_argument("keyword", help="검색 키워드 (예: 에러처리, BizUnit)")
    gd.add_argument("--limit", type=int, default=20, help="최대 결과 수 (기본 20)")

    # mapping
    mp = sub.add_parser("mapping", help="COBOL→Java 매핑 규칙 검색")
    mp.add_argument("keyword", help="검색 키워드 (모듈명, 함수명 등)")
    mp.add_argument("--status", default="all",
                    help="mapping_status 필터: O / △ / X / - / all (기본 all)")
    mp.add_argument("--limit", type=int, default=50, help="최대 결과 수 (기본 50)")

    # fields
    fd = sub.add_parser("fields", help="CommonUtility 모듈 입출력 FieldMapping 조회")
    fd.add_argument("module_id", help="모듈명 (예: CJICN01)")
    fd.add_argument("--direction", choices=["INPUT", "OUTPUT", "ALL"],
                    default="ALL", help="INPUT / OUTPUT / ALL (기본 ALL)")

    # programs
    pg = sub.add_parser("programs", help="CobolProgram 목록 조회")
    pg.add_argument("--keyword", default="", help="프로그램명 필터 (선택)")
    pg.add_argument("--limit", type=int, default=200, help="최대 결과 수 (기본 200)")

    # schema
    sub.add_parser("schema", help="GraphDB 노드 레이블별 건수 확인")

    return p


# ── 진입점 ─────────────────────────────────────────────────────────────────────

HANDLERS = {
    "keyword":  cmd_keyword,
    "cypher":   cmd_cypher,
    "deps":     cmd_deps,
    "guide":    cmd_guide,
    "mapping":  cmd_mapping,
    "fields":   cmd_fields,
    "programs": cmd_programs,
    "schema":   cmd_schema,
}

if __name__ == "__main__":
    parser = build_parser()
    args = parser.parse_args()
    try:
        HANDLERS[args.command](args)
    except Exception as e:
        print(json.dumps({"error": str(e)}, ensure_ascii=False), file=sys.stderr)
        sys.exit(1)
