#!/usr/bin/env python3
"""compare.py: what a hand file changed against the drafts of its Raven file, or what a snapshot holds against the stored drafts.

The default form reads the alignment of the stem's hand file that align.py wrote, and prints each hand line in state `edited` or `hand`.
Each difference is one line with Raven's file and line, the function, and the role of the draft line, then the draft text and the hand text.
A hand line with no statement takes the line of the statement above it in its function, or the function's Source line.
A rewritten function prints one line with its Source line and no texts.
`--counts` prints the count of each state for each function.
`--against` compares the stored line rows of the stem with the draft file of a snapshot folder, by function and line row, and prints each differing line.

The command exits 0 when nothing differs, 1 when a line differs, and 2 when the store, the alignment, or the snapshot is missing or stale.

Usage:
  .venv/bin/python compare.py --stem bg_pmove
  .venv/bin/python compare.py --stem bg_pmove --counts
  .venv/bin/python compare.py --stem bg_pmove --against ~/.cache/jka-swift/snapshot-stage-two-step4
"""

from __future__ import annotations

import argparse
import difflib
import sys
from pathlib import Path

import store as S
from align import STATES, counts, printed
from bodies import LANGUAGE
from draftcheck import SOURCE_LINE
from printer import stem_text


class Missing(Exception):
    """An input the comparison needs is missing or stale. The message names it and the command that makes it."""


def line_rows(store: S.Store, key: str, stem: str, names: list[str]) -> dict[str, list[tuple]]:
    """The line rows of each function of the stem under the key, by function name."""
    out = {}
    for function in names:
        rows = store.lowered_lines(key, LANGUAGE, stem, function)
        if rows is None:
            raise Missing(f"the store holds no line rows for {function} of {stem}, so run bodies.py --stem {stem}")
        out[function] = rows
    return out


def start_lines(store: S.Store, stem: str, names: list[str]) -> dict[tuple[str, int], int]:
    """Raven's first line of each statement of the stem, by its function and its seq."""
    return {(function, row["seq"]): row["start_line"] for function in names for row in store.syntax("statements", stem, function)}


def alignment(store: S.Store, key: str, path: Path, name: str) -> list[tuple]:
    """The alignment rows of the hand file, which must stand under the key and the hash of the file on disk."""
    if store.aligned(name) != (S.file_hash(path), key):
        raise Missing(f"the alignment of {name} is missing or stale, so run align.py")
    return store.alignments(name)


def compare_stem(store: S.Store, key: str, stem: str, names: list[str], path: Path, name: str) -> tuple[list[str], int]:
    """The printed differences of the hand file against the drafts of the stem, and the exit code."""
    rows = alignment(store, key, path, name)
    hand = path.read_text().splitlines()
    drafts = {(function, row[0]): line for function, lines in line_rows(store, key, stem, names).items()
              for line, row in zip(*printed(lines))}
    starts = start_lines(store, stem, names)
    out: list[str] = []
    source = None
    anchor = None
    function = None
    for owner, number, line_seq, statement_seq, role, state in rows:
        if owner != function:
            function, anchor = owner, None
        found = SOURCE_LINE.match(hand[number - 1])
        if found:
            source, anchor = int(found.group(1)), None
        if statement_seq is not None:
            anchor = statement_seq
        if state == "same":
            continue
        cited = starts.get((owner, anchor), source) if anchor is not None else source
        if state == "rewritten":
            if found:
                out.append(f"{stem}.c:{cited} {owner} rewritten")
            continue
        draft = drafts.get((owner, line_seq), "") if line_seq is not None else ""
        out += [f"{stem}.c:{cited} {owner} {role or 'hand'}", f"    draft: {draft.strip()}".rstrip(), f"    hand: {hand[number - 1].strip()}".rstrip()]
    return out, 1 if any(row[5] != "same" for row in rows) else 0


def compare_counts(store: S.Store, key: str, path: Path, name: str) -> tuple[list[str], int]:
    """The count of each state for each function of the hand file, in the order of the file, and the exit code."""
    rows = alignment(store, key, path, name)
    functions = list(dict.fromkeys(row[0] for row in rows))
    out = []
    for function in functions:
        found = counts([row for row in rows if row[0] == function])
        out.append(f"{function}: " + ", ".join(f"{found[state]} {state}" for state in STATES))
    return out, 1 if any(row[5] != "same" for row in rows) else 0


def compare_against(store: S.Store, key: str, stem: str, names: list[str], folder: Path) -> tuple[list[str], int]:
    """The printed differences of the draft file of the stem in a snapshot folder against the stored line rows, and the exit code.
    The draft file is `bodies/<stem>.swift` under the folder, the form snapshot.py writes, or `<stem>.swift` beside it."""
    snapshot = folder / "bodies" / f"{stem}.swift"
    if not snapshot.exists():
        snapshot = folder / f"{stem}.swift"
    if not snapshot.exists():
        raise Missing(f"the snapshot folder {folder} holds no draft of {stem}")
    functions = line_rows(store, key, stem, names)
    stored = stem_text(list(functions.values())).splitlines()
    # The function, the line row, and the statement of each stored line, and None for the blank line after a function and the footer.
    origins: list[tuple[str, tuple] | None] = []
    for function, rows in functions.items():
        origins += [(function, row) for row in printed(rows)[1]] + [None]
    origins.append(None)
    assert len(origins) == len(stored), "the stored text and its origins differ in length"
    starts = start_lines(store, stem, names)
    lines = snapshot.read_text().splitlines()
    out: list[str] = []
    matcher = difflib.SequenceMatcher(None, stored, lines, autojunk=False)
    for tag, i1, i2, j1, j2 in matcher.get_opcodes():
        if tag == "equal":
            continue
        for k in range(max(i2 - i1, j2 - j1)):
            i = i1 + k if i1 + k < i2 else None
            origin = origins[i if i is not None else max(i1 - 1, 0)]
            if origin is None:
                where = f"{stem}.c layout"
            else:
                function, row = origin
                cited = starts.get((function, row[1]), "") if row[1] is not None else ""
                where = f"{stem}.c:{cited} {function} {row[2]}".replace(".c: ", ".c ")
            mine = stored[i] if i is not None else ""
            theirs = lines[j1 + k] if j1 + k < j2 else ""
            out += [where, f"    stored: {mine}".rstrip(), f"    snapshot: {theirs}".rstrip()]
    return out, 1 if out else 0


def main() -> None:
    from closure import REPO
    from printer import lowered_key
    from skeleton import stub_path
    from table import STORE

    parser = argparse.ArgumentParser()
    parser.add_argument("--stem", required=True, help="the stem to compare, bg_pmove")
    parser.add_argument("--counts", action="store_true", help="print the count of each state for each function")
    parser.add_argument("--against", type=Path, help="a snapshot folder whose draft of the stem to compare with the stored line rows")
    args = parser.parse_args()
    if not STORE.exists():
        print(f"compare.py: no store at {STORE}, so run bodies.py first", file=sys.stderr)
        sys.exit(2)
    with S.Store(STORE) as store:
        key = lowered_key(store)
        names = [function for file, function in store.read("functions") if file == args.stem]
        path = stub_path(args.stem)
        try:
            if store.key(S.LOWERED) != key:
                raise Missing("the lowered rows are stale or missing, so run bodies.py to lower them again")
            if not names:
                raise Missing(f"the store holds no function of the stem {args.stem}")
            if args.against:
                lines, code = compare_against(store, key, args.stem, names, args.against)
            elif args.counts:
                lines, code = compare_counts(store, key, path, str(path.relative_to(REPO)))
            else:
                lines, code = compare_stem(store, key, args.stem, names, path, str(path.relative_to(REPO)))
        except Missing as missing:
            print(f"compare.py: {missing}", file=sys.stderr)
            sys.exit(2)
    if lines:
        print("\n".join(lines), flush=True)
    sys.exit(code)


if __name__ == "__main__":
    main()
