#!/usr/bin/env python3
"""draftcheck.py: the compile gate of bodies.py, over one Raven file or over many.

The drafts of one file replace the hand bodies of its Swift file in a mirror of the package under .build-draft/, and the
mirror builds the game product. No file of the working tree changes. The report separates three counts: the holes the
draft left, the errors that follow from a hole, because a local the hole declared is missing, and the errors that stand
on their own, which are the draft's defects. One line reports each stem, and a total line closes the run. The build log
stays at .build-draft/build.log and holds the log of the last build. A run parses and sweeps once, splices every stem
into the mirror, and builds once per pass. Each error goes to the stem whose file the compiler names.

In an adopted stem, a hand function that align.py marks `hand`, `edited`, or `rewritten` stays as a person ported it.
Each run writes one row per spliced function to the `splices` table with the hash of the body it wrote.
A hand body with the hash of its row is a draft the gate wrote, so the gate splices over it whatever align.py says.
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
  .venv/bin/python draftcheck.py --unit mp-cgame          # every cgame stem under Sources/JKAMP_CGameLogic, the logic target built

A unit whose logic target is not in the package yet has no product to build, so a run of that unit drafts each stem,
writes the draft under out/<unit>/.build-draft/drafts/, counts its holes, and builds nothing.
The cgame has its logic target and no shell yet, so its run builds that target in the mirror.
"""

from __future__ import annotations

import argparse
import hashlib
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
# A stem of the unit cites the unit's folder, and a borrowed stem cites its own folder, the game folder for the cgame copy of a vehicle file.
FOLDERS = "|".join(re.escape(folder) for folder in dict.fromkeys([C.GAME_DIR, *C.BORROWED.values()]))
SOURCE_LINE = re.compile(rf"/// Source: oracle/(?:{FOLDERS})/\w+\.c:(\d+)$")
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
PASSES = 48


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


FUNC_NAME = re.compile(r"^(?:[a-z@()]+ )*func (\w+)")


def body_name(lines: list[str], start: int, end: int, raven: int) -> str:
    """The Swift name of the function whose span is `start` to `end`, or its Raven line when no `func` line stands in the span."""
    for line in lines[start:end + 1]:
        m = FUNC_NAME.match(line)
        if m:
            return m.group(1)
    return str(raven)


def body_hash(lines: list[str], start: int, end: int) -> str:
    """The hash of the lines of one function, from its Source line to its closing brace."""
    return hashlib.sha256("\n".join(lines[start:end + 1]).encode()).hexdigest()


def spliced_rows(draft: list[str], hand: list[str], keep: set[int]) -> list[tuple[str, str]]:
    """The name and the body hash of each draft function the splice wrote over a hand function, for the `splices` table."""
    h = functions(hand)
    return [(body_name(draft, a, b, k), body_hash(draft, a, b)) for k, (a, b) in functions(draft).items() if k in h and k not in keep]


def kept(hand: list[str], drafts: list[tuple[str, list[tuple]]], splices: dict[str, str] | None = None) -> set[int]:
    """The Raven line of each hand function that align.py marks `hand`, `edited`, or `rewritten` against the line rows of its draft.
    A person ported such a function, so the gate builds the drafts beside it and never splices over it.
    A function whose every line is `stub` or `same` is not in the set.
    A function whose body hash equals its row in `splices` is a draft the gate wrote, so it is not in the set, whatever align.py says."""
    # align.py imports this module, so the import waits for the call.
    from align import align_text

    marked = {row[1] for row in align_text(hand, drafts).rows if row[5] in ("hand", "edited", "rewritten")}
    # An alignment row counts hand lines from 1, and a span holds the index of its Source line and of its closing brace.
    out = {raven for raven, (start, end) in functions(hand).items() if marked & set(range(start + 1, end + 2))}
    splices = splices or {}
    drafted = {raven for raven, (start, end) in functions(hand).items()
               if splices.get(body_name(hand, start, end, raven)) == body_hash(hand, start, end)}
    return out - drafted


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


# The access word of a func line, after any attribute, `private func CG_Viewpos_f()`.
ACCESS = re.compile(r"^((?:@\S+ )*)((?:private|fileprivate|public|internal) )?(func \w+)")


def hand_access(hand: list[str], draft: list[str]) -> list[str]:
    """The draft with the access of each func line taken from the hand func line of the same Raven line and name.
    The skeleton spells Raven's static as `private`, and an adopted file can make the function internal for a hand table in another file.
    The draft keeps the hand's access, because only the hand file knows that table, `commands` of cg_local.swift."""
    h = functions(hand)
    out = list(draft)
    for raven, (a, b) in functions(draft).items():
        if raven not in h:
            continue
        mine = next((i for i in range(a, b + 1) if ACCESS.match(out[i])), None)
        theirs = next((ACCESS.match(line) for line in hand[h[raven][0]:h[raven][1] + 1] if ACCESS.match(line)), None)
        if mine is None or theirs is None:
            continue
        m = ACCESS.match(out[mine])
        if m.group(3) == theirs.group(3):
            out[mine] = m.group(1) + (theirs.group(2) or "") + out[mine][m.end(1) + len(m.group(2) or ""):]
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
        self.draft = hand_access(self.hand, self.draft)
        spliced, self.origins, self.replaced = splice(self.hand, self.draft, self.keep)
        if "import Foundation" not in spliced:
            # A stub written before Foundation joined the stub imports gets it in the mirror, so libc math resolves.
            first = next((i for i, line in enumerate(spliced) if line.startswith("import ")), 0)
            spliced.insert(first, "import Foundation")
            self.origins.insert(first, None)
        self.target.write_text("\n".join(spliced) + "\n")


# The game builds its product. The cgame has no shell target yet, so its run builds the logic target of its stubs.
BUILT = ["--product", "jampgame"] if C.UNIT == C.PROJECT["sweep"]["unit"] else ["--target", LOGIC]


def build() -> str:
    """The product of the unit built in the mirror, or its logic target. The build log goes to LOG, and its text comes back."""
    done = subprocess.run(["swift", "build", "--package-path", str(MIRROR), "--scratch-path", str(SCRATCH), *BUILT],
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
            s.keep = kept(s.hand, drafts, sk.table.store.splices(str(path.relative_to(REPO))))
        states.append(s)
    passes, others = run(states)
    DRAFTS.mkdir(parents=True, exist_ok=True)
    for s in states:
        sk.table.store.save_rejected(lowered, LANGUAGE, s.stem, [(function, seq, message) for (_, function, seq), message in sorted(s.due.items())])
        sk.table.store.save_splices(str(stub_path(s.stem).relative_to(REPO)), spliced_rows(s.draft, s.hand, s.keep))
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


def draft_only(sk: Skeleton, registry: Registry, stems: list[str]) -> None:
    """The drafts of a unit whose logic target is not in the package yet, with no build, so the run counts the holes alone.
    Each stem's draft goes to the drafts folder under out/<unit>/, beside the stubs skeleton.py wrote there."""
    print(f"draftcheck.py: the package holds no target {LOGIC}, so the run drafts {len(stems)} stems and builds nothing")
    drafts = C.written(DRAFTS)
    drafts.mkdir(parents=True, exist_ok=True)
    functions_total = bodies_total = holes_total = 0
    for stem in stems:
        path = stub_path(stem)
        if not path.exists():
            raise SystemExit(f"draftcheck.py: no stub at {path.relative_to(REPO)}, so run skeleton.py --unit {C.UNIT} first")
        draft, _, holes, _, _ = Stem(sk, registry, stem, path, path).lines()
        (drafts / f"{stem}.swift").write_text("\n".join(draft) + "\n")
        fns = sk.files[stem]
        bodies = sum(1 for fn in fns if fn.mapped)
        functions_total += len(fns)
        bodies_total += bodies
        holes_total += holes
        print(f"{stem}: {len(fns)} functions, {bodies} bodies drafted, {len(fns) - bodies} signature markers, {holes} holes")
    print(f"drafts: {drafts.relative_to(REPO)}")
    print(f"total: {len(stems)} stems, {functions_total} functions, {bodies_total} bodies drafted, {holes_total} holes, no build")


def main() -> None:
    parser = argparse.ArgumentParser()
    C.unit_argument(parser)
    parser.add_argument("--stem", action="append", default=[], help="the Raven files to draft and build, bg_pmove,bg_misc")
    parser.add_argument("--all", action="store_true", help="every Raven file the skeleton holds under Sources/JKAMP_BG")
    parser.add_argument("--game", action="store_true", help=f"every Raven file the skeleton holds under Sources/{LOGIC}")
    parser.add_argument("--every", action="store_true", help="the files of --all and of --game, and every Raven file the skeleton holds under Sources/JKAShared")
    args = parser.parse_args()
    if not (args.stem or args.all or args.game or args.every) and C.UNIT != C.PROJECT["sweep"]["unit"]:
        # A unit other than the game holds no bg or shared stem of its own, so its run with no choice gates every stem of its logic target.
        args.game = True
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
    if C.STAGED:
        draft_only(sk, registry, stems)
        return
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
