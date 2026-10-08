#!/usr/bin/env python3
"""draftcheck.py: the compile gate of bodies.py, over one Raven file or over many.

The drafts of one file replace the hand bodies of its Swift file in a mirror of the package under .build-draft/, and the
mirror builds the game product. No file of the working tree changes. The report separates three counts: the holes the
draft left, the errors that follow from a hole, because a local the hole declared is missing, and the errors that stand
on their own, which are the draft's defects. One line reports each stem, and a total line closes the run. The build log
stays at .build-draft/build.log and holds the log of the last stem. A run of several stems parses and sweeps once, and
each stem after the first costs a draft and a build alone.

A defect on a line that a statement drafted makes that statement a hole on the next pass, with the compiler's message in its Port-note.
The stem drafts and builds again until no such defect is left, or until the passes reach PASSES.
The stem's line counts these compile holes among its holes and also apart.
The last pass's draft of each stem stays at .build-draft/drafts/<stem>.swift.
The compile holes of the last pass go to the `rejected` table of the store under the lowered key, by file, function, and seq,
and `bodies.py --compile-holes` and `printer.py --compile-holes` print them.

Usage:
  .venv/bin/python draftcheck.py --stem bg_pmove
  .venv/bin/python draftcheck.py --stem bg_pmove,bg_misc
  .venv/bin/python draftcheck.py --all      # every bg stem
  .venv/bin/python draftcheck.py --game     # every game stem under Sources/JKAMP_GameLogic
  .venv/bin/python draftcheck.py --every    # the bg stems and the game stems
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

import closure as C
from bodies import LANGUAGE, Drafter, Registry, lowered_key
from printer import function_lines
from reexport import REPO
from skeleton import BG, LOGIC, Skeleton, stub_path, target_of

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
# The cap on the drafts of one stem. Each pass after the first makes a hole of each statement the last build rejected.
PASSES = 8


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


def splice(hand: list[str], draft: list[str]) -> tuple[list[str], list[int | None], int]:
    """The hand file with each function's lines replaced by the draft's, matched by Raven line.
    Beside it comes the index of the draft line each spliced line came from, or None for a hand line."""
    h, d = functions(hand), functions(draft)
    starts = {a: k for k, (a, _) in h.items()}
    out: list[str] = []
    origins: list[int | None] = []
    i = 0
    replaced = 0
    while i < len(hand):
        k = starts.get(i)
        if k is not None and k in d:
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


def gate(sk: Skeleton, registry: Registry, stem: str, lowered: str) -> tuple[int, int, int, int, int, bool]:
    """One stem drafted, spliced into the mirror, and built there, pass by pass. The stem's line and its defects go to stdout.
    The holes, the cascade errors, the defects, the holes the passes made, the passes, and whether the passes hit the cap come back.
    The mirror holds the hand text of the stub again at the end, so the draft of one stem never stands in the build of the next.
    The compile holes of the last pass go to the store under the lowered key."""
    path = stub_path(stem)
    hand = path.read_text().splitlines()
    target = MIRROR / path.relative_to(REPO)
    # The statements the builds rejected so far, by file, function, and seq, each with the message of its first error by line.
    due: dict[tuple[str, str, int], str] = {}
    capped = False
    passes = 0
    while True:
        passes += 1
        # The drafter counts the holes of one draft, so each pass takes its own over the run's one skeleton and registry.
        drafter = Drafter(sk, registry, due)
        draft: list[str] = []
        keys: list[tuple[str, str, int] | None] = []
        for fn in sk.files[stem]:
            # The printer prints the rows of each draft, the text bodies.py prints, and each printed line keeps the seq of its statement.
            drafter.draft(fn)
            _, rows = drafter.rows(sk.table.store.syntax("statements", stem, fn.cur.spelling))
            draft += function_lines(rows)
            # The body is seq 0, and no hole stands for a whole body, so a line of the body's own keeps no key.
            keys += [(stem, fn.cur.spelling, row[1]) if row[1] else None for row in rows if row[2] != "trailing"]
            draft.append("")
            keys.append(None)
        spliced, origins, replaced = splice(hand, draft)
        if "import Foundation" not in spliced:
            # A stub written before Foundation joined the stub imports gets it in the mirror, so libc math resolves.
            first = next((i for i, line in enumerate(spliced) if line.startswith("import ")), 0)
            spliced.insert(first, "import Foundation")
            origins.insert(first, None)
        target.write_text("\n".join(spliced) + "\n")
        build = subprocess.run(["swift", "build", "--package-path", str(MIRROR), "--scratch-path", str(SCRATCH), "--product", "jampgame"],
                               capture_output=True, text=True)
        LOG.write_text(build.stdout + build.stderr)
        cascades = 0
        defects: list[str] = []
        summaries: list[str] = []
        rejected: dict[tuple[str, str, int], list[tuple[int, str]]] = {}
        # The compiler reports one error under more than one job at times, so each error line counts once.
        for line in dict.fromkeys(ANSI.sub("", raw) for raw in (build.stdout + build.stderr).splitlines()):
            m = ERROR.match(line)
            if m is None:
                if line.startswith("error:"):
                    summaries.append(line)
                continue
            source, number, message = m.group(1, 2, 3) if m.group(1) else m.group(4, 5, 6)
            name = MISSING.search(message)
            if name and name.group(1) in drafter.hole_names:
                cascades += 1
                continue
            defects.append(f"{Path(source).name}:{number}: {message}")
            # A defect on a line a statement of the draft wrote rejects that statement, and a defect elsewhere stays a defect.
            index = int(number) - 1
            if Path(source).resolve() == target.resolve() and 0 <= index < len(origins) and origins[index] is not None:
                key = keys[origins[index]]
                if key is not None and key not in due:
                    rejected.setdefault(key, []).append((int(number), message.strip()))
        if summaries and not defects and not cascades:
            # An error outside a Swift file is the build's own, and it stands as a defect so a broken mirror never reads clean.
            defects += summaries
        if not rejected:
            break
        if passes == PASSES:
            capped = True
            break
        for key, found in rejected.items():
            due[key] = min(found)[1]
    sk.table.store.save_rejected(lowered, LANGUAGE, stem, [(function, seq, message) for (_, function, seq), message in sorted(due.items())])
    DRAFTS.mkdir(parents=True, exist_ok=True)
    (DRAFTS / f"{stem}.swift").write_text("\n".join(draft) + "\n")
    cap = f", the cap of {PASSES} passes hit" if capped else ""
    print(f"{stem}: {replaced} of {len(functions(hand))} hand functions replaced, {drafter.holes} holes, {cascades} cascade errors, {len(defects)} defects, "
          f"{drafter.compile_holes} compile holes over {passes} passes{cap}")
    for line in defects:
        print(f"  {line}")
    subprocess.run(["rsync", "-a", str(path), str(target)], check=True)
    return drafter.holes, cascades, len(defects), drafter.compile_holes, passes, capped


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--stem", action="append", default=[], help="the Raven files to draft and build, bg_pmove,bg_misc")
    parser.add_argument("--all", action="store_true", help="every Raven file the skeleton holds under Sources/JKAMP_BG")
    parser.add_argument("--game", action="store_true", help="every Raven file the skeleton holds under Sources/JKAMP_GameLogic")
    parser.add_argument("--every", action="store_true", help="the files of --all and of --game")
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
    stems = [stem for group in args.stem for stem in group.split(",")]
    stems += sorted(stem for stem in sk.files if target_of(stem) in targets and stem not in stems)
    mirror()
    lowered, _ = lowered_key(sk)
    holes = 0
    cascades = 0
    defects = 0
    compile_holes = 0
    capped: list[str] = []
    for stem in stems:
        counts = gate(sk, registry, stem, lowered)
        holes += counts[0]
        cascades += counts[1]
        defects += counts[2]
        compile_holes += counts[3]
        if counts[5]:
            capped.append(stem)
    print(f"build log: {LOG}")
    print(f"total: {holes} holes, {cascades} cascade errors, {defects} defects, {compile_holes} compile holes")
    if capped:
        print(f"the cap of {PASSES} passes hit: {', '.join(capped)}")
    sys.exit(1 if defects else 0)


if __name__ == "__main__":
    main()
