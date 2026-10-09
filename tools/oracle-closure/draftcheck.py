#!/usr/bin/env python3
"""draftcheck.py: the compile gate of bodies.py, over one Raven file or over many.

The drafts of one file replace the hand bodies of its Swift file in a mirror of the package under .build-draft/, and the
mirror builds the game product. No file of the working tree changes. The report separates three counts: the holes the
draft left, the errors that follow from a hole, because a local the hole declared is missing, and the errors that stand
on their own, which are the draft's defects. One line reports each stem, and a total line closes the run. The build log
stays at .build-draft/build.log and holds the log of the last build. A run parses and sweeps once, splices every stem
into the mirror, and builds once per pass. Each error goes to the stem whose file the compiler names.

In an adopted stem, a hand function that align.py marks `hand`, `edited`, or `rewritten` stays as a person ported it.
The draft splices only over a `stub` or a `same` body, and the stem's line counts the hand functions kept.
A defect on a line that a statement drafted makes that statement a hole on the next pass, with the compiler's message in its Port-note.
Each stem with such a defect drafts again for the next pass, until no such defect is left, or until the run's passes reach PASSES.
The stem's line counts these compile holes among its holes and also apart.
The last pass's draft of each stem stays at .build-draft/drafts/<stem>.swift.
The compile holes of the last pass go to the `rejected` table of the store under the lowered key, by file, function, and seq,
and `bodies.py --compile-holes` and `printer.py --compile-holes` print them.

Usage:
  .venv/bin/python draftcheck.py --stem bg_pmove
  .venv/bin/python draftcheck.py --stem bg_pmove,bg_misc
  .venv/bin/python draftcheck.py --all      # every bg stem
  .venv/bin/python draftcheck.py --game     # every game stem under Sources/JKAMP_GameLogic
  .venv/bin/python draftcheck.py --every    # the bg stems, the game stems, and the shared stems under Sources/JKAShared
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

import closure as C
from bodies import LANGUAGE, Drafter, Registry, lowered_key
from layout import COMPILE_NOTE, port_note
from printer import function_lines
from reexport import REPO
from skeleton import BG, LOGIC, SHARED, Skeleton, stub_path, target_of

MIRROR = REPO / ".build-draft" / "tree"
SCRATCH = REPO / ".build-draft" / "scratch"
LOG = REPO / ".build-draft" / "build.log"
# The last pass's draft of each stem, the text a transcriptor reads, with every hole the passes made.
DRAFTS = REPO / ".build-draft" / "drafts"
SOURCE_LINE = re.compile(r"/// Source: oracle/codemp/game/\w+\.c:(\d+)$")
# skeleton.py writes this doc line above the /// Source: line of a forward, and the forward shares the Source line of the hand body.
FORWARD_DOC = re.compile(r"^/// A caller that passes .* reaches `\w+` through this forward, and a NULL caller passes the optional\.$")
# swiftc writes `path:line:col: error: message`.
# The build system writes a parse error as `error: path:line:col message`, with a FixIt record after the message at times.
# Each form keeps the path, so an error in a hand file, jampgame.swift, reads under that file and not under the stem's.
ERROR = re.compile(r"^(?:(/[^:]*\.swift):(\d+):\d+: error: (.*)|error: (/[^:]*\.swift):(\d+):\d+ (.*?)(?:: FixIt\(.*)?)$")
# swiftc colours its diagnostics when it sees a terminal, and the escape sits before `error:`, so the count strips it first.
# It also wraps a diagnostic group's name in a link escape, which the Port-note of a compile hole must not carry.
ANSI = re.compile(r"\x1b\[[0-9;]*m|\x1b\]8;[^\x1b]*\x1b\\")
MISSING = re.compile(r"cannot find '(\w+)' in scope")
# The first words of the Port-note of a compile hole, the first of its three lines.
COMPILE_PREFIX = port_note(COMPILE_NOTE.split("{}")[0])
MARKER = re.compile(r'^portMissing\("(\w+)"')
# The cap on the passes of one run. Each pass after the first makes a hole of each statement the last build rejected.
PASSES = 24


def functions(lines: list[str]) -> dict[int, tuple[int, int]]:
    """Each function of a Swift file by its Raven line: the index of its /// Source: line and of its closing brace."""
    out: dict[int, tuple[int, int]] = {}
    i = 0
    while i < len(lines):
        m = SOURCE_LINE.match(lines[i])
        # A forward stays in place, so the draft replaces the hand body only.
        if m and i > 0 and FORWARD_DOC.match(lines[i - 1]):
            m = None
        if m and i + 1 < len(lines) and not lines[i + 1].startswith("/// Source"):
            j = i + 1
            while j < len(lines) and lines[j] != "}":
                if re.match(r"^(private |public )?(let|var) ", lines[j]) or lines[j].startswith("/// Source"):
                    break
                j += 1
            if j < len(lines) and lines[j] == "}":
                out[int(m.group(1))] = (i, j)
                i = j
        i += 1
    return out


def kept(hand: list[str], drafts: list[tuple[str, list[tuple]]]) -> set[int]:
    """The Raven line of each hand function that align.py marks `hand`, `edited`, or `rewritten` against the line rows of its draft.
    A person ported such a function, so the gate builds the drafts beside it and never splices over it.
    A function whose every line is `stub` or `same` is not in the set."""
    # align.py imports this module, so the import waits for the call.
    from align import align_text

    marked = {row[1] for row in align_text(hand, drafts).rows if row[5] in ("hand", "edited", "rewritten")}
    # An alignment row counts hand lines from 1, and a span holds the index of its Source line and of its closing brace.
    out = {raven for raven, (start, end) in functions(hand).items() if marked & set(range(start + 1, end + 2))}
    return out


def hand_due(sk: Skeleton, stem: str, hand: list[str]) -> dict[tuple[str, str, int], str]:
    """The compile holes the hand file of the stem holds, by file, function, and seq, each with the compiler's message of its Port-note.
    A compile hole is the gate's own text and not a person's, so the draft the alignment reads holds the same holes.
    The `Raven wrote:` line names the statement by its text, and every statement of the function with that text takes the hole."""
    out: dict[tuple[str, str, int], str] = {}
    for i, line in enumerate(hand[:-2]):
        note = line.strip()
        marker = MARKER.match(hand[i + 2].strip())
        if not note.startswith(COMPILE_PREFIX) or not note.endswith('".') or marker is None:
            continue
        text = hand[i + 1].strip().removeprefix("// Raven wrote: ")
        for row in sk.table.store.syntax("statements", stem, marker.group(1)):
            if " ".join(row["text"].split()) == text:
                out[(stem, marker.group(1), row["seq"])] = note[len(COMPILE_PREFIX):-2]
    return out


def splice(hand: list[str], draft: list[str], keep: set[int] | None = None) -> tuple[list[str], list[int | None], int]:
    """The hand file with each function's lines replaced by the draft's, matched by Raven line.
    A function whose Raven line is in `keep` stays as the hand wrote it.
    Beside it comes the index of the draft line each spliced line came from, or None for a hand line."""
    h, d = functions(hand), functions(draft)
    keep = keep or set()
    starts = {a: k for k, (a, _) in h.items()}
    out: list[str] = []
    origins: list[int | None] = []
    i = 0
    replaced = 0
    while i < len(hand):
        k = starts.get(i)
        if k is not None and k in d and k not in keep:
            a, b = d[k]
            out += draft[a:b + 1]
            origins += range(a, b + 1)
            i = h[k][1] + 1
            replaced += 1
            continue
        out.append(hand[i])
        origins.append(None)
        i += 1
    return out, origins, replaced


def mirror() -> None:
    """The package of .build-draft/tree, a copy of the working tree's Sources, Tests, and Package.swift."""
    MIRROR.mkdir(parents=True, exist_ok=True)
    # The manifest names the test targets too, so the mirror carries Tests, and the build stays on the one product.
    for tree in ("Sources", "Tests"):
        subprocess.run(["rsync", "-a", "--delete", str(REPO / tree) + "/", str(MIRROR / tree) + "/"], check=True)
    subprocess.run(["rsync", "-a", str(REPO / "Package.swift"), str(MIRROR / "Package.swift")], check=True)


class Stem:
    """One stem of a run: its hand file, its mirror file, the hand functions it keeps, and the state of its last draft."""

    def __init__(self, sk: Skeleton | None, registry: Registry | None, stem: str, path: Path, target: Path) -> None:
        self.sk, self.registry, self.stem, self.target = sk, registry, stem, target
        self.hand = path.read_text().splitlines()
        # The statements the builds rejected so far, by file, function, and seq, each with the message of its first error by line.
        self.due: dict[tuple[str, str, int], str] = {}
        self.keep: set[int] = set()
        self.passes = 0
        self.capped = False
        self.cascades = 0
        self.defects: list[str] = []

    def lines(self) -> tuple[list[str], list[tuple[str, str, int] | None], int, int, set[str]]:
        """The draft of the stem over its due compile holes, the key of each line, its holes, its compile holes, and its hole names."""
        # The drafter counts the holes of one draft, so each pass takes its own over the run's one skeleton and registry.
        drafter = Drafter(self.sk, self.registry, self.due)
        draft: list[str] = []
        keys: list[tuple[str, str, int] | None] = []
        for fn in self.sk.files[self.stem]:
            # The printer prints the rows of each draft, the text bodies.py prints, and each printed line keeps the seq of its statement.
            drafter.draft(fn)
            _, rows = drafter.rows()
            draft += function_lines(rows)
            # The body is seq 0, and no hole stands for a whole body, so a line of the body's own keeps no key.
            keys += [(self.stem, fn.cur.spelling, row[1]) if row[1] else None for row in rows if row[2] != "trailing"]
            draft.append("")
            keys.append(None)
            # The printer prints one line for each row that is not trailing, so the keys stand beside the lines they name.
            assert len(keys) == len(draft), f"draftcheck.py: the keys of {fn.cur.spelling} of {self.stem} do not match its printed lines"
        return draft, keys, drafter.holes, drafter.compile_holes, drafter.hole_names

    def write(self) -> None:
        """The stem drafted again over its due compile holes and spliced into its mirror file."""
        self.passes += 1
        self.draft, self.keys, self.holes, self.compile_holes, self.hole_names = self.lines()
        spliced, self.origins, self.replaced = splice(self.hand, self.draft, self.keep)
        if "import Foundation" not in spliced:
            # A stub written before Foundation joined the stub imports gets it in the mirror, so libc math resolves.
            first = next((i for i, line in enumerate(spliced) if line.startswith("import ")), 0)
            spliced.insert(first, "import Foundation")
            self.origins.insert(first, None)
        self.target.write_text("\n".join(spliced) + "\n")


def build() -> str:
    """The game product built in the mirror. The build log goes to LOG, and its text comes back."""
    done = subprocess.run(["swift", "build", "--package-path", str(MIRROR), "--scratch-path", str(SCRATCH), "--product", "jampgame"],
                          capture_output=True, text=True)
    LOG.write_text(done.stdout + done.stderr)
    return done.stdout + done.stderr


def attribute(output: str, stems: list[Stem]) -> tuple[dict[str, dict[tuple[str, str, int], list[tuple[int, str]]]], list[str]]:
    """Each error of one build under the stem whose mirror file the compiler names, or under the run when it names no such file.
    Each stem's cascades and defects take the counts of this build, and the statements each stem's draft lost to a defect come back by stem."""
    by_target = {s.target.resolve(): s for s in stems}
    rejected: dict[str, dict[tuple[str, str, int], list[tuple[int, str]]]] = {s.stem: {} for s in stems}
    for s in stems:
        s.cascades = 0
        s.defects = []
    others: list[str] = []
    summaries: list[str] = []
    # The compiler reports one error under more than one job at times, so each error line counts once.
    for line in dict.fromkeys(ANSI.sub("", raw) for raw in output.splitlines()):
        m = ERROR.match(line)
        if m is None:
            if line.startswith("error:"):
                summaries.append(line)
            continue
        source, number, message = m.group(1, 2, 3) if m.group(1) else m.group(4, 5, 6)
        owner = by_target.get(Path(source).resolve())
        name = MISSING.search(message)
        if name:
            # A missing name that a hole swallowed is a cascade of the stem whose draft made the hole.
            holder = owner if owner is not None and name.group(1) in owner.hole_names else next((s for s in stems if name.group(1) in s.hole_names), None)
            if holder is not None:
                holder.cascades += 1
                continue
        text = f"{Path(source).name}:{number}: {message}"
        if owner is None:
            others.append(text)
            continue
        owner.defects.append(text)
        # A defect on a line a statement of the draft wrote rejects that statement, and a defect elsewhere stays a defect.
        index = int(number) - 1
        if 0 <= index < len(owner.origins) and owner.origins[index] is not None:
            key = owner.keys[owner.origins[index]]
            if key is not None and key not in owner.due:
                rejected[owner.stem].setdefault(key, []).append((int(number), message.strip()))
    if summaries and not others and not any(s.defects or s.cascades for s in stems):
        # An error outside a Swift file is the build's own, and it stands as a defect so a broken mirror never reads clean.
        others += summaries
    return rejected, others


def run(stems: list[Stem], make=build) -> tuple[int, list[str]]:
    """Every stem of the run spliced into the mirror and one build per pass.
    A stem with a new compile hole drafts again on the next pass, and a stem with none keeps its draft as it stands.
    The passes and the defects in no stem's file come back."""
    pending = list(stems)
    passes = 0
    while True:
        passes += 1
        for s in pending:
            s.write()
        rejected, others = attribute(make(), stems)
        pending = [s for s in stems if rejected[s.stem]]
        if not pending:
            break
        if passes == PASSES:
            for s in pending:
                s.capped = True
            break
        for s in pending:
            for key, found in rejected[s.stem].items():
                s.due[key] = min(found)[1]
    return passes, others


def gate(sk: Skeleton, registry: Registry, stems: list[str], lowered: str) -> tuple[list[Stem], int, list[str]]:
    """The stems of the run drafted, spliced into the mirror together, and built there, pass by pass.
    Each stem's line and its defects go to stdout after the last pass, and the mirror holds the hand text again at the end.
    The compile holes of the last pass go to the store under the lowered key."""
    # The hand functions of an adopted stem stay, each classed against the draft that holds the compile holes the hand file holds.
    from align import adopted

    states: list[Stem] = []
    for stem in stems:
        path = stub_path(stem)
        s = Stem(sk, registry, stem, path, MIRROR / path.relative_to(REPO))
        if adopted(stem):
            first = Drafter(sk, registry, hand_due(sk, stem, s.hand))
            drafts = []
            for fn in sk.files[stem]:
                first.draft(fn)
                drafts.append((fn.cur.spelling, first.rows()[1]))
            s.keep = kept(s.hand, drafts)
        states.append(s)
    passes, others = run(states)
    DRAFTS.mkdir(parents=True, exist_ok=True)
    for s in states:
        sk.table.store.save_rejected(lowered, LANGUAGE, s.stem, [(function, seq, message) for (_, function, seq), message in sorted(s.due.items())])
        (DRAFTS / f"{s.stem}.swift").write_text("\n".join(s.draft) + "\n")
        cap = f", the cap of {PASSES} passes hit" if s.capped else ""
        print(f"{s.stem}: {s.replaced} of {len(functions(s.hand))} hand functions replaced, {len(s.keep)} kept, {s.holes} holes, {s.cascades} cascade errors, "
              f"{len(s.defects)} defects, {s.compile_holes} compile holes over {s.passes} passes{cap}")
        for line in s.defects:
            print(f"  {line}")
        subprocess.run(["rsync", "-a", str(stub_path(s.stem)), str(s.target)], check=True)
    if others:
        print(f"other files: {len(others)} defects")
        for line in others:
            print(f"  {line}")
    print(f"run: {passes} passes, {passes} builds")
    return states, passes, others


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--stem", action="append", default=[], help="the Raven files to draft and build, bg_pmove,bg_misc")
    parser.add_argument("--all", action="store_true", help="every Raven file the skeleton holds under Sources/JKAMP_BG")
    parser.add_argument("--game", action="store_true", help="every Raven file the skeleton holds under Sources/JKAMP_GameLogic")
    parser.add_argument("--every", action="store_true", help="the files of --all and of --game, and every Raven file the skeleton holds under Sources/JKAShared")
    args = parser.parse_args()
    if not (args.stem or args.all or args.game or args.every):
        parser.error("give --stem, --all, --game, or --every")
    sk = Skeleton(C.Parse())
    registry = Registry()
    targets = set()
    if args.all or args.every:
        targets.add(BG)
    if args.game or args.every:
        targets.add(LOGIC)
    if args.every:
        targets.add(SHARED)
    stems = [stem for group in args.stem for stem in group.split(",")]
    stems += sorted(stem for stem in sk.files if target_of(stem) in targets and stem not in stems)
    mirror()
    lowered, _ = lowered_key(sk)
    states, _, others = gate(sk, registry, stems, lowered)
    holes = sum(s.holes for s in states)
    cascades = sum(s.cascades for s in states)
    defects = sum(len(s.defects) for s in states) + len(others)
    compile_holes = sum(s.compile_holes for s in states)
    capped = [s.stem for s in states if s.capped]
    print(f"build log: {LOG}")
    print(f"total: {holes} holes, {cascades} cascade errors, {defects} defects, {compile_holes} compile holes")
    if capped:
        print(f"the cap of {PASSES} passes hit: {', '.join(capped)}")
    sys.exit(1 if defects else 0)


if __name__ == "__main__":
    main()
