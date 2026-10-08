#!/usr/bin/env python3
"""printer.py: the text of the drafts from the line rows of the lowering, and nothing else.

The printer reads line rows alone and never reorders one.
It indents a body row by its depth, four spaces a depth, and joins a trailing row onto the line before it with one space.
It drops the module qualifiers of a body row, so `JKAMP.BgEntity` prints as `BgEntity`, and a header row keeps the stub's own bytes.
The functions of a stem print with one blank line after each, and the footer counts the holes, one for each line row with the role note.

Its own command prints from the store with no parse and no libclang.
It computes the lowered key again from the files the store lists and the declaration lines of the Swift files, and it stops with one line
on standard error when the key differs from the stored key, or when a function has no line rows.

Usage:
  .venv/bin/python printer.py --stem bg_pmove                       # prints every draft of one file from the store
  .venv/bin/python printer.py --only PM_AddTouchEnt,BG_SabersOff   # prints the drafts of the named functions from the store
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

import store as S
from draft_classification import INDENT

# A module qualifier appears only to break a genuine ambiguity, the short-name rule of porting-rules.md, and no body line has one.
QUALIFIER = re.compile(r"\b(JKAMP|JKAShared)\.(?=[A-Za-z_])")


def short_named(line: str) -> str:
    """A body line with every module qualifier dropped, so `var ent: BgEntity? = nil` reads as Raven wrote it."""
    return QUALIFIER.sub("", line)


def function_lines(rows: list[tuple]) -> list[str]:
    """The printed lines of one function from its line rows, each row as its seq, its statement seq, its role, its depth, and its text."""
    out: list[str] = []
    for _, _, role, depth, text in rows:
        if role == "header":
            out.append(text)
        elif role == "trailing":
            out[-1] += f" {short_named(text)}"
        else:
            out.append(INDENT * depth + short_named(text))
    return out


def stem_text(functions: list[list[tuple]]) -> str:
    """The text of the functions from their line rows: each function and a blank line after it, then the footer of the hole count."""
    holes = sum(1 for rows in functions for row in rows if row[2] == "note")
    return "".join("\n".join(function_lines(rows)) + "\n\n" for rows in functions) + f"// {holes} holes\n"


def lowered_key(store: S.Store) -> str:
    """The lowered key of the files on disk, computed with no parse.
    The adoption part takes the stored base key, the first line of each stub the store lists, and the salt of a generated stub.
    The base part, the C inputs and the tool modules, is the stored key, because only a parse can compute it again."""
    # bodies.py imports this module, so its names come in at the call.
    from bodies import HERE, SOURCES, lowered_keys
    from closure import PROJECT, REPO
    from skeleton import NOTE

    stubs = {name: S.digest((REPO / name).read_bytes().split(b"\n", 1)[0]) if (REPO / name).exists() else "" for name in store.files("adoption")}
    adoption = S.combined(stubs, store.key("base") or "", NOTE)
    key, _ = lowered_keys(adoption, SOURCES, [HERE / name for name in PROJECT["store"]["lowering"]], REPO)
    return key


def store_text(path: Path, stem: str | None = None, only: list[str] | None = None) -> str:
    """The text of every function of one stem, or of the named functions, from the line rows of the store at the path.
    The read stops with one line on standard error when the store is missing, its lowered key is stale, or a function has no rows."""
    from bodies import LANGUAGE

    if not path.exists():
        raise SystemExit(f"printer.py: no store at {path}, so run bodies.py first")
    with S.Store(path) as store:
        key = lowered_key(store)
        if store.key(S.LOWERED) != key:
            raise SystemExit("printer.py: the lowered rows are stale or missing, so run bodies.py to lower them again")
        # The functions of the base facts stand in the order of the parse, which is the order bodies.py prints.
        functions = store.read("functions")
        if stem is not None:
            chosen = [(file, name) for file, name in functions if file == stem]
            if not chosen:
                raise SystemExit(f"printer.py: the store holds no function of the stem {stem}")
        else:
            first = {}
            for file, name in functions:
                first.setdefault(name, (file, name))
            missing = [name for name in only or [] if name not in first]
            if missing:
                raise SystemExit(f"printer.py: the store holds no function named {', '.join(missing)}")
            chosen = [first[name] for name in only or []]
        rows = []
        for file, name in chosen:
            lines = store.lowered_lines(key, LANGUAGE, file, name)
            if lines is None:
                raise SystemExit(f"printer.py: the store holds no line rows for {name} of {file}, so run bodies.py --stem {file}")
            rows.append(lines)
    return stem_text(rows)


def main() -> None:
    from table import STORE

    parser = argparse.ArgumentParser()
    parser.add_argument("--only", help="comma-separated function names to print")
    parser.add_argument("--stem", help="print every draft of one .c file")
    args = parser.parse_args()
    if not (args.only or args.stem):
        parser.error("give --only or --stem")
    text = store_text(STORE, only=args.only.split(",")) if args.only else store_text(STORE, stem=args.stem)
    print(text, end="", flush=True)


if __name__ == "__main__":
    main()
