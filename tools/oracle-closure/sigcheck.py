#!/usr/bin/env python3
"""sigcheck.py: the check that each Swift function signature is the signature the table gives today.

The check reads the signature rows that skeleton.py saves into the store of each unit, as `lookup.py sig` does, and no manifest.
For each function row it finds the Swift declarations of the name in the file of the row's Swift line, and in every Swift file under
`Sources/` when the row has no Swift line, and compares the table's text with each one.
A comparison ignores spelling that does not change the type: white space, a line break in the parameter list, a trailing `{` or comment,
access words and other modifiers, attributes, a module prefix of a module of the package, and a typealias of the package.
A row with a `TODO: Port signature` reason has no table form, and a function of NOT_PORTED has no Swift function of Raven's shape, so the check skips both.
SIGNATURE_EXCEPTIONS of rulings.py names each difference that a ledger row keeps, and the check prints those with their row.

Usage:
  .venv/bin/python sigcheck.py                     # the units of `[targets]` in project.toml
  .venv/bin/python sigcheck.py --unit mp-cgame     # one unit, and the option repeats

Exit 0 when every difference is named, 1 when a difference is not named or a named entry no longer differs,
and 2 when the store of a unit is missing, holds no signature rows, or is stale. Run `skeleton.py --signatures --unit <unit>` for a stale store.
"""

from __future__ import annotations

import argparse
import re
import sys
import tomllib
from dataclasses import dataclass
from pathlib import Path

from rulings import NOT_PORTED, SIGNATURE_EXCEPTIONS
from store import SIGNATURES, Store

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
with (HERE / "project.toml").open("rb") as _f:
    PROJECT = tomllib.load(_f)
SOURCES = REPO / PROJECT["output"]["root"]

# The words before `func` that change no type of the declaration.
MODIFIERS = {"public", "internal", "private", "fileprivate", "open", "package", "final", "static", "class", "nonisolated", "override",
             "mutating", "nonmutating", "dynamic", "optional", "required", "convenience", "indirect", "unsafe"}
ATTRIBUTE = re.compile(r"@\w+(?:\([^()]*\))?")
TOKEN = re.compile(r"[A-Za-z_][A-Za-z_0-9]*|->|\.\.\.|\S")
# A typealias at file scope, whose right side the check reads as the same type.
ALIAS = re.compile(r"^(?:(?:public|internal|package)\s+)?typealias\s+(\w+)\s*=\s*([^/{]+?)\s*(?://.*)?$")


@dataclass
class Declaration:
    line: int
    text: str


@dataclass
class Difference:
    unit: str
    name: str
    swift: str
    hand: str
    table: str
    source: str


def strip_comment(line: str) -> str:
    """The line without a `//` comment that stands outside a string literal."""
    quoted = False
    for i, c in enumerate(line):
        if c == '"':
            quoted = not quoted
        elif not quoted and line.startswith("//", i):
            return line[:i]
    return line


def declarations(lines: list[str], name: str) -> list[Declaration]:
    """Each declaration of a function named `name` in the lines of one Swift file, from `func` to the `{` of its body or its end."""
    head = re.compile(r"\bfunc\s+" + re.escape(name) + r"\s*[<(]")
    out = []
    for i, line in enumerate(lines):
        code = strip_comment(line)
        m = head.search(code)
        if not m:
            continue
        text = ""
        depth = 0
        for j in range(i, min(i + 40, len(lines))):
            part = strip_comment(lines[j])
            if j == i:
                part = part[m.start():]
            end = None
            for k, c in enumerate(part):
                if c in "([":
                    depth += 1
                elif c in ")]":
                    depth -= 1
                elif c == "{" and depth == 0:
                    end = k
                    break
            if end is not None:
                text += part[:end]
                break
            text += part + " "
            # A declaration with no body, a protocol requirement, ends at the line that closes its parentheses.
            if depth == 0 and ")" in text and not part.rstrip().endswith(("->", ",", "(")) and j + 1 < len(lines) \
                    and not re.match(r"\s*(->|throws|rethrows|async|where|\{)", strip_comment(lines[j + 1])):
                break
        out.append(Declaration(i + 1, " ".join(text.split())))
    return out


def package_modules() -> set[str]:
    """The names of the targets under `Sources/`, which a module prefix names."""
    return {path.name for path in SOURCES.iterdir() if path.is_dir()}


def package_aliases() -> dict[str, list[str]]:
    """Each typealias at file scope under `Sources/` as its tokens, when every file that declares the name gives it the same right side."""
    found: dict[str, set[str]] = {}
    for path in SOURCES.rglob("*.swift"):
        for line in path.read_text(errors="replace").split("\n"):
            m = ALIAS.match(line)
            if m:
                found.setdefault(m.group(1), set()).add(" ".join(m.group(2).split()))
    return {name: TOKEN.findall(sides.pop()) for name, sides in found.items() if len(sides) == 1}


OPEN = {"(": ")", "[": "]", "<": ">"}


def closing(tokens: list[str], start: int) -> int:
    """The index of the token that closes the bracket at `start`, or the last index when the text ends first."""
    depth = 0
    for i in range(start, len(tokens)):
        if tokens[i] in OPEN:
            depth += 1
        elif tokens[i] in OPEN.values():
            depth -= 1
            if depth == 0:
                return i
    return len(tokens) - 1


def split_top(tokens: list[str]) -> list[list[str]]:
    """The tokens of a parameter list split at each comma outside a bracket."""
    out: list[list[str]] = [[]]
    depth = 0
    for token in tokens:
        if token in OPEN:
            depth += 1
        elif token in OPEN.values():
            depth -= 1
        if token == "," and depth == 0:
            out.append([])
        else:
            out[-1].append(token)
    return [part for part in out if part]


class Normalizer:
    """The canonical text of a signature, which keeps every token that changes the type and drops every spelling that does not."""

    def __init__(self, modules: set[str], aliases: dict[str, list[str]]) -> None:
        self.modules = modules
        self.aliases = aliases

    def type_tokens(self, tokens: list[str], seen: frozenset[str] = frozenset()) -> list[str]:
        out: list[str] = []
        i = 0
        while i < len(tokens):
            token = tokens[i]
            # A module prefix of the package names the same type as the bare name.
            if token in self.modules and i + 1 < len(tokens) and tokens[i + 1] == "." and (not out or out[-1] != "."):
                i += 2
                continue
            if token in self.aliases and token not in seen and (not out or out[-1] != "."):
                out += self.type_tokens(self.aliases[token], seen | {token})
            else:
                out.append(token)
            i += 1
        return out

    def canonical(self, text: str) -> str:
        """The signature as tokens: the modifiers before `func` and every attribute dropped, and each type spelled by its resolved tokens."""
        text = ATTRIBUTE.sub(" ", text)
        tokens = TOKEN.findall(text)
        while tokens and tokens[0] in MODIFIERS:
            tokens.pop(0)
            # `nonisolated(unsafe)` leaves its parenthesized word after the modifier.
            if tokens[:3] == ["(", "unsafe", ")"]:
                tokens = tokens[3:]
        if len(tokens) < 3 or tokens[0] != "func":
            return " ".join(tokens)
        start = tokens.index("(") if "(" in tokens else len(tokens)
        end = closing(tokens, start)
        out = tokens[:2] + self.type_tokens(tokens[2:start]) + ["("]
        # The labels and names of a parameter stay as they are, and its type and its default go through the resolver.
        for i, param in enumerate(split_top(tokens[start + 1:end])):
            if i:
                out.append(",")
            colon = param.index(":") if ":" in param else len(param)
            out += param[:colon] + self.type_tokens(param[colon:])
        return " ".join(out + [")"] + self.type_tokens(tokens[end + 1:]))


def rows_of(unit: str) -> list[dict] | None:
    """The signature rows of one unit from its store, or None after a line on standard error when the store cannot answer."""
    path = REPO / PROJECT["targets"][unit]["store"]
    if not path.exists():
        print(f"sigcheck.py: {unit} has no store at {path.relative_to(REPO)}. Run skeleton.py --signatures --unit {unit}.", file=sys.stderr)
        return None
    with Store(path, reader=True) as store:
        stale = store.rehashed(SIGNATURES, REPO)
        if stale:
            shown = ", ".join(stale[:5]) + (f", and {len(stale) - 5} more" if len(stale) > 5 else "")
            print(f"sigcheck.py: the signature rows of {unit} are stale, {len(stale)} Swift stubs changed: {shown}. "
                  f"Run skeleton.py --signatures --unit {unit}.", file=sys.stderr)
            return None
        with store.snapshot():
            if store.key(SIGNATURES) is None:
                print(f"sigcheck.py: the store of {unit} holds no signature rows. Run skeleton.py --signatures --unit {unit}.", file=sys.stderr)
                return None
            columns = Store.SIGNATURE_COLUMNS
            found = store.db.execute(f"SELECT {', '.join(columns)} FROM signatures ORDER BY seq").fetchall()
    return [dict(zip(columns, row)) for row in found]


class Checker:
    def __init__(self) -> None:
        self.normalizer = Normalizer(package_modules(), package_aliases())
        self.files: dict[Path, list[str]] = {}
        self.everywhere: dict[str, list[tuple[Path, Declaration]]] | None = None
        self.counts = {"rows": 0, "equal": 0, "holes": 0, "not ported": 0}

    def lines(self, path: Path) -> list[str]:
        if path not in self.files:
            self.files[path] = path.read_text(errors="replace").split("\n") if path.exists() else []
        return self.files[path]

    def anywhere(self, name: str) -> list[tuple[Path, Declaration]]:
        """Each declaration of the name in any Swift file under `Sources/`, for a row whose Swift line the skeleton did not find."""
        hits = []
        for path in sorted(SOURCES.rglob("*.swift")):
            text = self.lines(path)
            if any(f"func {name}" in line for line in text):
                hits += [(path, d) for d in declarations(text, name)]
        return hits

    def check(self, unit: str, row: dict) -> Difference | None:
        """The difference of one function row, or None when a declaration of the name has the table's type."""
        name = row["name"].split("::")[-1].split(".")[-1]
        self.counts["rows"] += 1
        if row["reason"] is not None:
            self.counts["holes"] += 1
            return None
        if row["name"] in NOT_PORTED:
            self.counts["not ported"] += 1
            return None
        found: list[tuple[Path, Declaration]] = []
        line = 0
        if row["destination"]:
            relative, line_text = row["destination"].rsplit(":", 1)
            path = SOURCES / relative
            line = int(line_text)
            found = [(path, d) for d in declarations(self.lines(path), name)]
        if not found:
            found = self.anywhere(name)
        table = self.normalizer.canonical(row["text"])
        if any(self.normalizer.canonical(d.text) == table for _, d in found):
            self.counts["equal"] += 1
            return None
        if not found:
            return Difference(unit, row["name"], "missing", "no Swift declaration", row["text"], row["source"])
        path, nearest = min(found, key=lambda pair: abs(pair[1].line - line))
        return Difference(unit, row["name"], f"{path.relative_to(REPO)}:{nearest.line}", nearest.text, row["text"], row["source"])


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--unit", action="append", choices=sorted(PROJECT["targets"]), help="a unit to check, and the option repeats")
    args = ap.parse_args()
    units = args.unit or list(PROJECT["targets"])
    checker = Checker()
    differences: list[Difference] = []
    for unit in units:
        rows = rows_of(unit)
        if rows is None:
            return 2
        for row in rows:
            if row["kind"] in ("function", "static function"):
                found = checker.check(unit, row)
                if found:
                    differences.append(found)
    named = [d for d in differences if d.name in SIGNATURE_EXCEPTIONS]
    new = [d for d in differences if d.name not in SIGNATURE_EXCEPTIONS]
    differing = {d.name for d in differences}
    # An entry whose function no longer differs in a unit of this run is stale, so the table cannot hide a later difference.
    checked = {row_name for row_name, (unit, _) in SIGNATURE_EXCEPTIONS.items() if unit in units}
    stale = sorted(checked - differing)
    for d in new:
        print(f"differs {d.unit} {d.name}\n  swift  {d.swift}  {d.hand}\n  table  {d.table}\n  raven  {d.source}")
    for d in named:
        print(f"named   {d.unit} {d.name}  {SIGNATURE_EXCEPTIONS[d.name][1]}")
    for name in stale:
        print(f"stale   {SIGNATURE_EXCEPTIONS[name][0]} {name}  the entry of SIGNATURE_EXCEPTIONS no longer differs")
    counts = checker.counts
    print(f"sigcheck.py: {counts['rows']} function rows, {counts['equal']} equal, {counts['holes']} holes, {counts['not ported']} not ported, "
          f"{len(named)} named, {len(new)} differ, {len(stale)} stale entries", file=sys.stderr)
    return 1 if new or stale else 0


if __name__ == "__main__":
    sys.exit(main())
