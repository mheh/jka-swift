#!/usr/bin/env python3
"""align.py: the line map between a hand file and the drafts of its Raven file, one row per hand line of each function.

A hand function and a draft function match by their `/// Source:` line, as draftcheck.py splices them.
difflib compares the stripped lines of the two from the Source line to the closing brace.
An equal line is `same`, and a replaced line in a block of equal length on both sides is `edited`, each with the line row it matches.
A line the hand wrote in place of no draft line is `hand`, with no line row.
A function whose body is still the two lines the skeleton writes, the TODO line and the `portMissing` marker, is `stub`.
Else a function whose ratio is under RATIO is `rewritten`.
Every line of a `stub` or a `rewritten` function has no line row, no statement, and no role.

The store keeps the hash of each hand file and the lowered key beside its rows, and the command skips a file whose hash and key match.
The command reads the line rows of the store with no parse, so they must stand under the lowered key of the files on disk.

Usage:
  .venv/bin/python align.py --stem bg_pmove
  .venv/bin/python align.py --stem bg_pmove,bg_misc
  .venv/bin/python align.py --adopted      # every stem whose stub is adopted
"""

from __future__ import annotations

import argparse
import difflib
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

import store as S
from lowering_key import LANGUAGE
from draftcheck import FORWARD_DOC, SOURCE_LINE, functions
from printer import function_lines

STATES = ("same", "edited", "hand", "rewritten", "stub")
FUNC_NAME = re.compile(r"\bfunc\s+`?(\w+)`?")
# Under this ratio of matched lines the hand restructured the body, and a pairing of its lines with the draft's would mislead.
RATIO = 0.3


@dataclass
class Alignment:
    """The alignment rows of one hand file, each in the order of the store's alignment columns, with the counts the run reports."""

    rows: list[tuple] = field(default_factory=list)
    deleted: int = 0
    # Each rewritten function with the ratio of its match.
    rewritten: list[tuple[str, float]] = field(default_factory=list)


def printed(rows: list[tuple]) -> tuple[list[str], list[tuple]]:
    """The printed lines of one function and the line row that prints each one.
    A trailing row prints on the line before it, so it gives no line of its own."""
    lines = function_lines(rows)
    own = [row for row in rows if row[2] != "trailing"]
    assert len(own) == len(lines), "a line row prints no line or two"
    return lines, own


def stub(name: str, hand: list[str]) -> bool:
    """True when the body of the hand function, between its signature line and its closing brace,
    is the marker pair of the skeleton and nothing else."""
    body = [line.strip() for line in hand]
    return (len(body) >= 4 and body[-1] == "}" and body[-4].endswith("{") and body[-3] == f"// TODO: Port {name}"
            and body[-2].startswith(f'portMissing("{name}"'))


def align_function(name: str, hand: list[str], first: int, lines: list[str], rows: list[tuple], out: Alignment) -> None:
    """Align the hand lines of one function, the first at hand line `first`, with the printed lines of its draft and their rows."""
    if stub(name, hand):
        out.rows += [(name, first + j, None, None, None, "stub") for j in range(len(hand))]
        return
    matcher = difflib.SequenceMatcher(None, [line.strip() for line in lines], [line.strip() for line in hand], autojunk=False)
    ratio = matcher.ratio()
    if ratio < RATIO:
        out.rows += [(name, first + j, None, None, None, "rewritten") for j in range(len(hand))]
        out.rewritten.append((name, ratio))
        print(f"align.py: {name} is rewritten, ratio {ratio:.2f}", file=sys.stderr)
        return
    for tag, i1, i2, j1, j2 in matcher.get_opcodes():
        if tag == "equal" or tag == "replace" and i2 - i1 == j2 - j1:
            # A replaced block of equal length on both sides is the hand's edit of each line, line for line.
            state = "same" if tag == "equal" else "edited"
            for i, j in zip(range(i1, i2), range(j1, j2)):
                out.rows.append((name, first + j, rows[i][0], rows[i][1], rows[i][2], state))
        elif tag == "insert" or tag == "replace" and i2 - i1 != j2 - j1:
            # An unequal block has no line pairing to trust, so its hand lines are the hand's and its draft lines count as deleted.
            out.rows += [(name, first + j, None, None, None, "hand") for j in range(j1, j2)]
            out.deleted += i2 - i1
        elif tag == "delete":
            out.deleted += i2 - i1


def forwards(hand: list[str]) -> list[tuple[int, int]]:
    """Each forward of a hand file, the index of its Source line and of its closing brace.
    skeleton.py writes a forward under a doc line of its own, and the forward shares the Source line of the hand body."""
    out = []
    for i, line in enumerate(hand):
        if i > 0 and SOURCE_LINE.match(line) and FORWARD_DOC.match(hand[i - 1]):
            end = next((j for j in range(i + 1, len(hand)) if hand[j] == "}"), None)
            if end is not None:
                out.append((i, end))
    return out


def align_text(hand: list[str], drafts: list[tuple[str, list[tuple]]]) -> Alignment:
    """The alignment of the lines of one hand file with the line rows of each draft function, by function name.
    A forward, and a hand function whose Source line no draft function holds, is hand from its Source line to its brace."""
    out = Alignment()
    spans = functions(hand)
    matched = set()
    for name, rows in drafts:
        lines, own = printed(rows)
        for raven, (a, b) in functions(lines).items():
            if raven in spans:
                start, end = spans[raven]
                matched.add(raven)
                align_function(name, hand[start:end + 1], start + 1, lines[a:b + 1], own[a:b + 1], out)
    for start, end in [span for raven, span in spans.items() if raven not in matched] + forwards(hand):
        named = next((m.group(1) for m in map(FUNC_NAME.search, hand[start:end + 1]) if m), f"line {start + 1}")
        out.rows += [(named, j + 1, None, None, None, "hand") for j in range(start, end + 1)]
    return out


def align_stem(store: S.Store, key: str, stem: str, names: list[str], path: Path, name: str) -> Alignment | None:
    """Align the hand file at `path`, kept in the store as `name`, with the line rows of the functions of one stem under the key.
    The alignment is None when the file and the key match the stored ones, and the rows in the store stand."""
    hashed = S.file_hash(path)
    if store.aligned(name) == (hashed, key):
        return None
    drafts = []
    for function in names:
        rows = store.lowered_lines(key, LANGUAGE, stem, function)
        if rows is None:
            raise SystemExit(f"align.py: the store holds no line rows for {function} of {stem}, so run bodies.py --stem {stem}")
        drafts.append((function, rows))
    out = align_text(path.read_text().splitlines(), drafts)
    store.save_alignment(name, hashed, key, out.rows)
    if out.deleted:
        print(f"align.py: {name}: {out.deleted} draft lines deleted", file=sys.stderr)
    return out


def adopted(stem: str) -> bool:
    """True when the stub of the stem exists and its first line is no longer the generated header."""
    from skeleton import NOTE, stub_path

    path = stub_path(stem)
    return path.exists() and path.read_text().split("\n", 1)[0] != NOTE.format(stem=stem)


def counts(rows: list[tuple]) -> dict[str, int]:
    """The count of the alignment rows in each state."""
    return {state: sum(1 for row in rows if row[5] == state) for state in STATES}


def main() -> None:
    from closure import REPO
    from printer import lowered_key
    from skeleton import stub_path
    from table import STORE

    parser = argparse.ArgumentParser()
    parser.add_argument("--stem", help="comma-separated stems whose hand files to align, bg_pmove,bg_misc")
    parser.add_argument("--adopted", action="store_true", help="every stem of the store whose stub is adopted")
    args = parser.parse_args()
    if not (args.stem or args.adopted):
        parser.error("give --stem or --adopted")
    if not STORE.exists():
        print(f"align.py: no store at {STORE}, so run bodies.py first", file=sys.stderr)
        sys.exit(2)
    with S.Store(STORE) as store:
        key = lowered_key(store)
        if store.key(S.LOWERED) != key:
            print("align.py: the lowered rows are stale or missing, so run bodies.py to lower them again", file=sys.stderr)
            sys.exit(2)
        # The functions of the base facts stand in the order of the parse.
        names: dict[str, list[str]] = {}
        for file, function in store.read("functions"):
            names.setdefault(file, []).append(function)
        stems = args.stem.split(",") if args.stem else [stem for stem in names if adopted(stem)]
        total = dict.fromkeys(STATES, 0)
        for stem in stems:
            path = stub_path(stem)
            if stem not in names or not path.exists():
                print(f"align.py: the store holds no function of the stem {stem}, or its stub is missing", file=sys.stderr)
                sys.exit(2)
            name = str(path.relative_to(REPO))
            out = align_stem(store, key, stem, names[stem], path, name)
            found = counts(store.alignments(name))
            for state in STATES:
                total[state] += found[state]
            unchanged = ", unchanged" if out is None else ""
            print(f"{stem}: " + ", ".join(f"{found[state]} {state}" for state in STATES) + unchanged)
        print(f"total: {len(stems)} files, " + ", ".join(f"{total[state]} {state}" for state in STATES))


if __name__ == "__main__":
    main()
