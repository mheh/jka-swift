#!/usr/bin/env python3
"""lookup.py: the one question a blind transcriptor may ask about a type or a function.

Reads the generated stones under .claude/rosetta and the manifests under .claude/manifest, no libclang, so an answer
is instant. Prints the Swift spelling of a C type, one field of a viewed struct, or the manifest row of a function.

Usage:
  python3 tools/oracle-closure/lookup.py gentity_t              # the view and every field
  python3 tools/oracle-closure/lookup.py gentity_t r            # one field, with its own stone when it is a struct
  python3 tools/oracle-closure/lookup.py entityShared_t absmin  # one field
  python3 tools/oracle-closure/lookup.py weapon_t               # a scalar, a typedef, or an enum
  python3 tools/oracle-closure/lookup.py fn CanDamage           # the manifest row: oracle range, Swift stub line, state
  python3 tools/oracle-closure/lookup.py sig Pmove              # the signature the table gives the function today
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
ROSETTA = REPO / ".claude" / "rosetta"
MANIFEST = REPO / ".claude" / "manifest"


def rows(path: Path) -> list[str]:
    return [line for line in path.read_text().split("\n") if line.startswith("| `")]


def cell(line: str, i: int) -> str:
    return line.split("|")[i + 1].strip()


def field_name(line: str) -> str:
    decl = cell(line, 0).strip("`")
    return re.split(r"[\s*]", decl)[-1].split("[")[0]


def stone(c_type: str, field: str | None) -> int:
    path = ROSETTA / f"{c_type}.md"
    if not path.exists():
        return 1
    header = [line for line in path.read_text().split("\n") if line.startswith("Swift view")]
    if field is None:
        print(header[0])
        for line in rows(path):
            print(f"  {cell(line, 0)}  ->  {cell(line, 1)}  {cell(line, 2)}".rstrip())
        return 0
    for line in rows(path):
        if field_name(line) == field:
            print(header[0])
            print(f"  {cell(line, 0)}  ->  {cell(line, 1)}  {cell(line, 2)}".rstrip())
            nested = re.search(r"`\w+: (?:\w+\.)?(\w+)\??`", cell(line, 1))
            if nested:
                for candidate in ROSETTA.glob("*.md"):
                    text = candidate.read_text()
                    if f"Swift view `" in text and f".{nested.group(1)}`" in text.split("\n")[4]:
                        print(f"  the field's own stone: python3 tools/oracle-closure/lookup.py {candidate.stem}")
            return 0
    print(f"lookup: {c_type} has no field {field}")
    return 1


def index(name: str) -> int:
    hits = [line for line in rows(ROSETTA / "index.md") if cell(line, 0) == f"`{name}`"]
    if not hits:
        return 1
    for line in hits:
        print(f"{cell(line, 0)}  ->  {cell(line, 1)}")
    return 0


def manifest_rows(name: str) -> list[tuple[Path, str]]:
    return [(path, line) for path in sorted(MANIFEST.glob("*.md")) for line in rows(path) if cell(line, 0).startswith(f"`{name}`")]


def function(name: str) -> int:
    hits = manifest_rows(name)
    for path, line in hits:
        print(f"{path.stem}.c  {cell(line, 0)}  oracle {cell(line, 1)}  swift {cell(line, 2)}  {cell(line, 3)}")
        print(f"  {cell(line, 5)}")
    return 0 if hits else 1


def signature(name: str) -> int:
    """The stub line the table gives the function today. An adopted file keeps its old line, so this is the fresh one."""
    hits = manifest_rows(name)
    for path, line in hits:
        print(f"{path.stem}.c  {cell(line, 5)}")
    if not hits:
        print(f"lookup: no function named {name} in the manifests")
    return 0 if hits else 1


def main() -> None:
    args = sys.argv[1:]
    if not args:
        print(__doc__)
        sys.exit(2)
    if args[0] == "fn" and len(args) == 2:
        sys.exit(function(args[1]) or 0)
    if args[0] == "sig" and len(args) == 2:
        sys.exit(signature(args[1]))
    if len(args) == 1:
        if stone(args[0], None) == 0 or index(args[0]) == 0:
            return
        print(f"lookup: no type named {args[0]}, and no view over it")
        sys.exit(1)
    if len(args) == 2:
        sys.exit(stone(args[0], args[1]))
    print(__doc__)
    sys.exit(2)


if __name__ == "__main__":
    main()
