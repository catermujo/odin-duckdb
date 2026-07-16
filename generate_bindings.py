#!/usr/bin/env python3

from __future__ import annotations

import json
import re
import subprocess
from pathlib import Path
from typing import Any


BASE = Path(__file__).resolve().parent
HEADER = BASE / "duckdb" / "src" / "include" / "duckdb.h"
BINDING = BASE / "raw" / "duckdb.odin"
OUTPUT = BASE / "raw" / "duckdb_api.generated.odin"
RESERVED_PARAMETER_NAMES = {"context"}


def load_ast() -> dict[str, Any]:
    result = subprocess.run(
        [
            "clang",
            "-Xclang",
            "-ast-dump=json",
            "-fsyntax-only",
            "-x",
            "c",
            str(HEADER),
        ],
        check=True,
        capture_output=True,
        text=False,
    )
    return json.loads(result.stdout)


def index_nodes(node: Any, nodes: dict[str, dict[str, Any]]) -> None:
    if not isinstance(node, dict):
        return
    node_id = node.get("id")
    if isinstance(node_id, str):
        nodes[node_id] = node
    for child in node.get("inner", []):
        index_nodes(child, nodes)


def find_decl_ref(
    node: Any, nodes: dict[str, dict[str, Any]], kinds: set[str]
) -> dict[str, Any] | None:
    if not isinstance(node, dict):
        return None
    for key in ("ownedTagDecl", "decl"):
        ref = node.get(key)
        if isinstance(ref, dict) and ref.get("kind") in kinds:
            return nodes.get(ref.get("id"))
    for child in node.get("inner", []):
        found = find_decl_ref(child, nodes, kinds)
        if found is not None:
            return found
    return None


def find_proto(node: Any) -> dict[str, Any] | None:
    if not isinstance(node, dict):
        return None
    if node.get("kind") == "FunctionProtoType":
        return node
    for child in node.get("inner", []):
        found = find_proto(child)
        if found is not None:
            return found
    return None


def type_qual(node: dict[str, Any]) -> str:
    return node.get("type", {}).get("qualType", "")


def render_type(qual_type: str) -> str:
    q = " ".join(qual_type.strip().split())
    if q in {"struct ArrowSchema *", "struct ArrowArray *"}:
        return "rawptr"
    if q in {"const char *", "char const *"}:
        return "cstring"
    if q in {"void *", "const void *", "void const *"}:
        return "rawptr"
    if q.endswith("*"):
        return "^" + render_type(q[:-1].strip())
    array_match = re.fullmatch(r"(.+)\[(\d+)\]", q)
    if array_match:
        return f"[{array_match.group(2)}]{render_type(array_match.group(1))}"
    if q.startswith("const ") or q.startswith("volatile "):
        return render_type(q.split(" ", 1)[1])
    if q == "void":
        return "void"
    if q == "bool" or q == "_Bool":
        return "bool"
    if q == "char":
        return "c.char"
    if q == "signed char":
        return "c.schar"
    if q == "unsigned char":
        return "c.uchar"
    if q == "short" or q == "short int":
        return "c.short"
    if q == "unsigned short" or q == "unsigned short int":
        return "c.ushort"
    if q == "int":
        return "c.int"
    if q == "unsigned" or q == "unsigned int":
        return "c.uint"
    if q == "long":
        return "c.long"
    if q == "unsigned long":
        return "c.ulong"
    if q == "long long":
        return "c.longlong"
    if q == "unsigned long long":
        return "c.ulonglong"
    if q == "float":
        return "c.float"
    if q == "double":
        return "c.double"
    if q in {
        "int8_t",
        "uint8_t",
        "int16_t",
        "uint16_t",
        "int32_t",
        "uint32_t",
        "int64_t",
        "uint64_t",
    }:
        return f"c.{q}"
    if q in {"size_t", "ptrdiff_t"}:
        return f"c.{q}"
    if q.startswith("enum "):
        tag = q.removeprefix("enum ")
        return "duckdb_type" if tag == "DUCKDB_TYPE" else tag
    if q.startswith("struct "):
        tag = q.removeprefix("struct ")
        if tag.startswith("_"):
            return "rawptr"
        if "(anonymous" in tag:
            raise ValueError(f"anonymous struct field needs explicit handling: {q}")
        return tag
    if q.startswith("union "):
        raise ValueError(f"anonymous union field needs explicit handling: {q}")
    if q == "__int128" or q == "unsigned __int128":
        raise ValueError(f"unsupported C integer type: {q}")
    return q


def render_proc(
    node: dict[str, Any], nodes: dict[str, dict[str, Any]], named_params: bool
) -> str:
    params: list[str] = []
    if named_params:
        qual_type = type_qual(node)
        result_type = render_type(re.split(r"\s*\(", qual_type, maxsplit=1)[0])
        params_nodes = [
            item for item in node.get("inner", []) if item.get("kind") == "ParmVarDecl"
        ]
        for index, param in enumerate(params_nodes):
            name = param.get("name") or f"arg{index}"
            if name in RESERVED_PARAMETER_NAMES:
                name = f"{name}_"
            params.append(f"{name}: {render_type(type_qual(param))}")
    else:
        proto = find_proto(node)
        if proto is None:
            raise ValueError(f"missing function prototype for {node.get('name')}")
        proto_types = [type_qual(item) for item in proto.get("inner", [])]
        if not proto_types:
            raise ValueError(f"empty function prototype for {node.get('name')}")
        result_type = render_type(proto_types[0])
        for index, param_type in enumerate(proto_types[1:]):
            params.append(f"arg{index}: {render_type(param_type)}")
    result = '^proc "c" (' + ", ".join(params) + ")"
    if result_type != "void":
        result += f" -> {result_type}"
    return result


def render_function_pointer(qual_type: str) -> str | None:
    match = re.fullmatch(
        r"(.+?)\s*\(\s*\*\s*\)\((.*)\)", " ".join(qual_type.strip().split())
    )
    if match is None:
        return None
    result_type = render_type(match.group(1))
    params = match.group(2).strip()
    param_types = (
        [] if params in {"", "void"} else [item.strip() for item in params.split(",")]
    )
    result = '^proc "c" (' + ", ".join(render_type(item) for item in param_types) + ")"
    if result_type != "void":
        result += f" -> {result_type}"
    return result


def render_enum(name: str, enum_decl: dict[str, Any]) -> list[str]:
    lines = [f"{name} :: enum c.int {{"]
    for item in enum_decl.get("inner", []):
        if item.get("kind") != "EnumConstantDecl":
            continue
        value = item.get("value")
        if value is None:
            lines.append(f"    {item['name']},")
        else:
            lines.append(f"    {item['name']} = {value},")
    lines.extend(["}", ""])
    return lines


def render_record(
    name: str, record_decl: dict[str, Any], nodes: dict[str, dict[str, Any]]
) -> list[str]:
    lines = [f"{name} :: struct {{"]
    for field in record_decl.get("inner", []):
        if field.get("kind") != "FieldDecl":
            continue
        field_name = field.get("name")
        if not field_name:
            raise ValueError(f"unnamed field in {name}")
        function_pointer = render_function_pointer(type_qual(field))
        if function_pointer is not None:
            field_type = function_pointer
        elif find_proto(field) is not None:
            field_type = render_proc(field, nodes, named_params=False)
        else:
            field_type = render_type(type_qual(field))
        lines.append(f"    {field_name}: {field_type},")
    lines.extend(["}", ""])
    return lines


def main() -> None:
    ast = load_ast()
    nodes: dict[str, dict[str, Any]] = {}
    index_nodes(ast, nodes)
    existing_text = BINDING.read_text()
    existing_types = set(
        re.findall(r"^\s*([A-Za-z_][A-Za-z0-9_]*) ::", existing_text, re.MULTILINE)
    )
    existing_functions = set(
        re.findall(r"^\s+([A-Za-z_][A-Za-z0-9_]*) :: proc", existing_text, re.MULTILINE)
    )
    existing_c_functions = {f"duckdb_{name}" for name in existing_functions}

    lines = [
        "// Generated from duckdb/src/include/duckdb.h. Do not edit.",
        "package duckdb_raw",
        "",
        'import "core:c"',
        "",
        'when LINK == "system" {',
        '    foreign import duckdb_api "system:duckdb"',
        "} else {",
        "    foreign import duckdb_api {LIB_PATH}",
        "}",
        "",
    ]
    typedefs = [
        item
        for item in ast.get("inner", [])
        if item.get("kind") == "TypedefDecl"
        and (
            item.get("name", "").startswith("duckdb_")
            or item.get("name") in {"idx_t", "sel_t"}
        )
    ]
    for item in typedefs:
        name = item["name"]
        if name in existing_types:
            continue
        qual_type = type_qual(item)
        enum_decl = find_decl_ref(item, nodes, {"EnumDecl"})
        if enum_decl is not None:
            lines.extend(render_enum(name, enum_decl))
            continue
        if find_proto(item) is not None:
            lines.append(f"{name} :: {render_proc(item, nodes, named_params=False)}")
            lines.append("")
            continue
        if re.search(r"struct _duckdb_[A-Za-z0-9_]+ \*$", qual_type):
            lines.extend(
                [f"{name} :: ^struct {{", "    internal_ptr: rawptr,", "}", ""]
            )
            continue
        record_decl = find_decl_ref(item, nodes, {"RecordDecl"})
        if record_decl is not None:
            lines.extend(render_record(name, record_decl, nodes))
            continue
        lines.extend([f"{name} :: {render_type(qual_type)}", ""])

    for item in ast.get("inner", []):
        if (
            item.get("kind") != "RecordDecl"
            or item.get("name") != "duckdb_extension_access"
        ):
            continue
        if item["name"] not in existing_types:
            lines.extend(render_record(item["name"], item, nodes))

    functions = [
        item
        for item in ast.get("inner", [])
        if item.get("kind") == "FunctionDecl"
        and item.get("name", "").startswith("duckdb_")
        and item.get("name") not in existing_c_functions
    ]
    if functions:
        lines.extend(
            [
                '@(default_calling_convention = "c", link_prefix = "duckdb_")',
                "foreign duckdb_api {",
            ]
        )
        for function in functions:
            alias = function["name"].removeprefix("duckdb_")
            proc = render_proc(function, nodes, named_params=True)
            proc = proc.removeprefix('^proc "c" ')
            lines.append(f"    {alias} :: proc{proc} ---")
        lines.extend(["}", ""])

    OUTPUT.write_text("\n".join(lines))
    print(f"generated {OUTPUT} ({len(functions)} new functions)")


if __name__ == "__main__":
    main()
