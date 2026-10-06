#!/usr/bin/env python3
"""lookup.py: the one question a blind transcriptor may ask about a type or a function.

Reads the generated stones under .claude/rosetta and the manifests under .claude/manifest, no libclang, so an answer
is instant. A `fn` or `sig` answer comes from the signature rows that skeleton.py writes into the table store,
while every Swift stub the rows were read from has the hash the store saved, and from the manifests otherwise.
A stale stub is named on standard error. Prints the Swift spelling of a C type, one field of a viewed struct, or the manifest row of a function.

Usage:
  python3 tools/oracle-closure/lookup.py gentity_t              # the view and every field
  python3 tools/oracle-closure/lookup.py gentity_t r            # one field, with its own stone when it is a struct
  python3 tools/oracle-closure/lookup.py entityShared_t absmin  # one field
  python3 tools/oracle-closure/lookup.py weapon_t               # a scalar, a typedef, or an enum
  python3 tools/oracle-closure/lookup.py fn CanDamage           # the manifest row: oracle range, Swift stub line, state
  python3 tools/oracle-closure/lookup.py sig Pmove              # the signature the table gives the function today
  python3 tools/oracle-closure/lookup.py sig pm_stopspeed       # the stub entry of a file-scope variable
"""

from __future__ import annotations

import re
import sys
import tomllib
from pathlib import Path

from store import SIGNATURES, Store

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
ROSETTA = REPO / ".claude" / "rosetta"
MANIFEST = REPO / ".claude" / "manifest"
with (HERE / "project.toml").open("rb") as _f:
    STORE = REPO / tomllib.load(_f)["store"]["path"]


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


def stored(name: str) -> list[dict] | None:
    """The signature rows of a name from the store, or None when no store exists or a Swift stub changed after the rows were saved.
    The input part of the key needs a parse, so a generator run checks it and this reader does not."""
    if not STORE.exists():
        return None
    with Store(STORE) as store:
        stale = store.rehashed(SIGNATURES, REPO)
        if stale:
            shown = ", ".join(stale[:5]) + (f", and {len(stale) - 5} more" if len(stale) > 5 else "")
            print(f"lookup.py: the signature rows in the store are stale, {len(stale)} Swift stubs changed: {shown}. "
                  f"Run skeleton.py to write them again.", file=sys.stderr)
            return None
        return store.signatures(name)


def signature_cell(row: dict) -> str:
    cell = f"`{row['text']}`"
    if row["forward"] is not None:
        cell += f" Forward: `{row['forward']}`"
    return cell + f" TODO: Port signature. {row['reason']}" if row["reason"] is not None else cell


def answers(name: str, source: str | None) -> list[tuple[str, list[str]]] | None:
    """Each row of a name as its file and its cells, as the manifest prints them, from the source the caller names.
    No source takes the store when it matches and the manifests otherwise."""
    rows = stored(name) if source in (None, "store") else None
    if rows is None and source == "store":
        return None
    if rows is None:
        return [(f"{path.stem}.c", [cell(line, i) for i in range(len(line.split("|")) - 2)]) for path, line in manifest_rows(name)]
    out = []
    for row in rows:
        if row["kind"] == "variable":
            cells = [f"`{row['name']}`", f"`{row['source']}`", row["state"], signature_cell(row)]
        else:
            static = " static" if row["kind"] == "static function" else ""
            cells = [f"`{row['name']}`{static}", f"`{row['source']}`", f"`{row['destination']}`" if row["destination"] else "missing",
                     row["state"], f"`{row['peer']}`" if row["peer"] else "none", signature_cell(row)]
        out.append((row["file"], cells))
    return out


def function(name: str, source: str | None = None) -> int:
    hits = answers(name, source) or []
    for file, cells in hits:
        print(f"{file}  {cells[0]}  oracle {cells[1]}  swift {cells[2]}  {cells[3]}")
        print(f"  {cells[5]}")
    return 0 if hits else 1


def signature(name: str, source: str | None = None) -> int:
    """The stub line the table gives a function or a file-scope variable today. An adopted file keeps its old line, so this is the fresh one.
    `source` is `store` or `manifest` to read one of them alone, and None reads the store while it matches the manifests."""
    hits = answers(name, source) or []
    for file, cells in hits:
        # A function row ends in its signature, and a variable row ends in its entry.
        print(f"{file}  {cells[-1]}")
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
