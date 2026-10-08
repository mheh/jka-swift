#!/usr/bin/env python3
"""printer.py: the text of the drafts from the line rows of the lowering, and nothing else.

The printer reads line rows alone and never reorders one.
It indents a body row by its depth, four spaces a depth, and joins a trailing row onto the line before it with one space.
It drops the module qualifiers of a body row, so `JKAMP.BgEntity` prints as `BgEntity`, and a header row keeps the stub's own bytes.
The functions of a stem print with one blank line after each, and the footer counts the holes, one for each line row with the role note.

Its own command prints from the store with no parse and no libclang.
It computes the lowered key again from the files the store lists and the declaration lines of the Swift files, and it stops with one line
on standard error when the key differs from the stored key, or when a function has no line rows.
A stem whose stub the store lists and that holds no function prints the footer alone, as bodies.py prints it.
With --compile-holes, each statement the last draftcheck run rejected prints as a compile hole in the place of its lines.
A rejected declaration or a rejected statement that opens a closure changes the draft of the statements after it, which the rows cannot show.
For such a function the printer stops with one line on standard error, and bodies.py --compile-holes prints it.

Usage:
  .venv/bin/python printer.py --stem bg_pmove                       # prints every draft of one file from the store
  .venv/bin/python printer.py --only PM_AddTouchEnt,BG_SabersOff   # prints the drafts of the named functions from the store
  .venv/bin/python printer.py --stem bg_pmove --compile-holes       # prints the statements draftcheck rejected as compile holes
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

import store as S
from layout import COMPILE_NOTE, INDENT, port_note
from lowering_key import LANGUAGE, lowered_keys, lowering_modules

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


def holed(rows: list[tuple], statements: list[dict], rejected: dict[int, str], function: str) -> list[tuple]:
    """The line rows of one function with the lines of each rejected statement replaced by the three lines of its compile hole.

    `statements` are the statement rows of the function, and `rejected` holds the compiler's message by the seq of each rejected statement.
    The lines of a statement are its own rows and the rows of the statements inside it, with the blank rows between them.
    A deeper row inside those lines goes with them too, for example the loop step the drafter writes before a `continue`.
    A statement inside a rejected statement goes with it, and a statement drafted twice, a loop step, is a hole at each copy."""
    parent = {row["seq"]: row["parent_seq"] for row in statements}
    text = {row["seq"]: row["text"] for row in statements}

    def top(seq: int | None) -> int | None:
        """The outermost rejected statement that holds the statement, itself included, or None."""
        found = None
        while seq is not None:
            if seq in rejected:
                found = seq
            seq = parent.get(seq)
        return found

    cite = [row[4].removeprefix("/// Source: ") for row in rows if row[2] == "header" and row[4].startswith("/// Source: ")][-1]
    out: list[tuple] = []
    i = 0
    while i < len(rows):
        seq = top(rows[i][1])
        if seq is None:
            out.append(rows[i])
            i += 1
            continue
        depth = rows[i][3]
        last = i
        for j in range(i + 1, len(rows)):
            if top(rows[j][1]) == seq or (rows[j][2] != "blank" and rows[j][3] > depth):
                last = j
            elif rows[j][2] != "blank":
                break
        out += [(0, seq, "note", depth, port_note(COMPILE_NOTE.format(rejected[seq]))),
                (0, seq, "raven", depth, "// Raven wrote: " + " ".join(text[seq].split())),
                (0, seq, "marker", depth, f'portMissing("{function}", source: "{cite}")')]
        i = last + 1
    return [(n,) + row[1:] for n, row in enumerate(out)]


def lowered_key(store: S.Store) -> str:
    """The lowered key of the files on disk, computed with no parse.
    The adoption part takes the stored base key, the first line of each stub the store lists, and the salt of a generated stub.
    The base part, the C inputs and the tool modules, is the stored key, because only a parse can compute it again."""
    from closure import REPO
    from reexport import SOURCES
    from skeleton import NOTE

    stubs = {name: S.digest((REPO / name).read_bytes().split(b"\n", 1)[0]) if (REPO / name).exists() else "" for name in store.files("adoption")}
    adoption = S.combined(stubs, store.key("base") or "", NOTE)
    key, _ = lowered_keys(adoption, SOURCES, lowering_modules(), REPO)
    return key


def known(store: S.Store, stem: str) -> bool:
    """True when the store lists the stub of the stem, so a stem with no function prints the footer alone, as bodies.py prints it."""
    from closure import REPO
    from skeleton import stub_path

    return str(stub_path(stem).relative_to(REPO)) in store.files("adoption")


def store_text(path: Path, stem: str | None = None, only: list[str] | None = None, compile_holes: bool = False) -> str:
    """The text of every function of one stem, or of the named functions, from the line rows of the store at the path.
    The read stops with one line on standard error when the store is missing, its lowered key is stale, or a function has no rows.
    With `compile_holes`, each statement draftcheck rejected under the key prints as a compile hole."""
    if not path.exists():
        raise SystemExit(f"printer.py: no store at {path}, so run bodies.py first")
    with S.Store(path, reader=True) as store:
        key = lowered_key(store)
        if store.key(S.LOWERED) != key:
            raise SystemExit("printer.py: the lowered rows are stale or missing, so run bodies.py to lower them again")
        # The functions of the base facts stand in the order of the parse, which is the order bodies.py prints.
        functions = store.read("functions")
        if stem is not None:
            chosen = [(file, name) for file, name in functions if file == stem]
            if not chosen and not known(store, stem):
                raise SystemExit(f"printer.py: the store holds no stub and no function of the stem {stem}")
        else:
            first = {}
            for file, name in functions:
                first.setdefault(name, (file, name))
            missing = [name for name in only or [] if name not in first]
            if missing:
                raise SystemExit(f"printer.py: the store holds no function named {', '.join(missing)}")
            chosen = [first[name] for name in only or []]
        due = store.rejected(key, LANGUAGE) if compile_holes else {}
        rows = []
        for file, name in chosen:
            lines = store.lowered_lines(key, LANGUAGE, file, name)
            if lines is None:
                raise SystemExit(f"printer.py: the store holds no line rows for {name} of {file}, so run bodies.py --stem {file}")
            rejected = {seq: message for (owner, function, seq), message in due.items() if (owner, function) == (file, name)}
            if rejected:
                statements = store.syntax("statements", file, name)
                kinds = {row["seq"]: row["kind"] for row in statements}
                forms = {row[0]: row[1] for row in store.lowered_rows(LANGUAGE, file, name)}
                # The drafter drafts the statements after a rejected closure outside it, and every later use of a rejected local as a hole.
                changing = sorted(seq for seq in rejected if forms.get(seq) in ("scratch", "choice") or kinds.get(seq) == "DECL_STMT")
                if changing:
                    raise SystemExit(f"printer.py: the rejected statement {changing[0]} of {name} changes the statements after it, "
                                     "so bodies.py --compile-holes prints it")
                lines = holed(lines, statements, rejected, name)
            rows.append(lines)
    return stem_text(rows)


def main() -> None:
    from table import STORE

    parser = argparse.ArgumentParser()
    parser.add_argument("--only", help="comma-separated function names to print")
    parser.add_argument("--stem", help="print every draft of one .c file")
    parser.add_argument("--compile-holes", action="store_true", help="print each statement the last draftcheck run rejected as a compile hole")
    args = parser.parse_args()
    if not (args.only or args.stem):
        parser.error("give --only or --stem")
    if args.only:
        text = store_text(STORE, only=args.only.split(","), compile_holes=args.compile_holes)
    else:
        text = store_text(STORE, stem=args.stem, compile_holes=args.compile_holes)
    print(text, end="", flush=True)


if __name__ == "__main__":
    main()
