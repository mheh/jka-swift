#!/usr/bin/env python3
"""draftcheck.py: the compile gate of bodies.py, over one Raven file or over many.

The drafts of one file replace the hand bodies of its Swift file in a mirror of the package under .build-draft/, and the
mirror builds the game product. No file of the working tree changes. The report separates three counts: the holes the
draft left, the errors that follow from a hole, because a local the hole declared is missing, and the errors that stand
on their own, which are the draft's defects. One line reports each stem, and a total line closes the run. The build log
stays at .build-draft/build.log and holds the log of the last stem. A run of several stems parses and sweeps once, and
each stem after the first costs a draft and a build alone. An adopted stem has no generated header line, and the run skips it
with a one-line note.

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

import closure as C
from bodies import Drafter, Registry
from reexport import REPO
from skeleton import BG, LOGIC, NOTE, Skeleton, stub_path, target_of

MIRROR = REPO / ".build-draft" / "tree"
SCRATCH = REPO / ".build-draft" / "scratch"
LOG = REPO / ".build-draft" / "build.log"
SOURCE_LINE = re.compile(r"/// Source: oracle/codemp/game/\w+\.c:(\d+)$")
# swiftc writes `path:line:col: error: message`.
# The build system writes a parse error as `error: path:line:col message`, with a FixIt record after the message at times.
ERROR = re.compile(r"^(?:/.*\.swift:(\d+):\d+: error: (.*)|error: /.*\.swift:(\d+):\d+ (.*?)(?:: FixIt\(.*)?)$")
# swiftc colours its diagnostics when it sees a terminal, and the escape sits before `error:`, so the count strips it first.
ANSI = re.compile(r"\x1b\[[0-9;]*m")
MISSING = re.compile(r"cannot find '(\w+)' in scope")


def functions(lines: list[str]) -> dict[int, tuple[int, int]]:
    """Each function of a Swift file by its Raven line: the index of its /// Source: line and of its closing brace."""
    out: dict[int, tuple[int, int]] = {}
    i = 0
    while i < len(lines):
        m = SOURCE_LINE.match(lines[i])
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


def splice(hand: list[str], draft: list[str]) -> tuple[list[str], int]:
    """The hand file with each function's lines replaced by the draft's, matched by Raven line."""
    h, d = functions(hand), functions(draft)
    starts = {a: k for k, (a, _) in h.items()}
    out: list[str] = []
    i = 0
    replaced = 0
    while i < len(hand):
        k = starts.get(i)
        if k is not None and k in d:
            a, b = d[k]
            out += draft[a:b + 1]
            i = h[k][1] + 1
            replaced += 1
            continue
        out.append(hand[i])
        i += 1
    return out, replaced


def mirror() -> None:
    """The package of .build-draft/tree, a copy of the working tree's Sources, Tests, and Package.swift."""
    MIRROR.mkdir(parents=True, exist_ok=True)
    # The manifest names the test targets too, so the mirror carries Tests, and the build stays on the one product.
    for tree in ("Sources", "Tests"):
        subprocess.run(["rsync", "-a", "--delete", str(REPO / tree) + "/", str(MIRROR / tree) + "/"], check=True)
    subprocess.run(["rsync", "-a", str(REPO / "Package.swift"), str(MIRROR / "Package.swift")], check=True)


def adopted(stem: str) -> bool:
    """A stub file without the generated header line is adopted, the same test skeleton.py makes."""
    return stub_path(stem).read_text().split("\n", 1)[0] != NOTE.format(stem=stem)


def gate(sk: Skeleton, registry: Registry, stem: str) -> tuple[int, int, int]:
    """One stem drafted, spliced into the mirror, and built there. The stem's line and its defects go to stdout, and the three counts come back.
    The mirror holds the hand text of the stub again at the end, so the draft of one stem never stands in the build of the next."""
    # The drafter counts the holes of one draft, so each stem takes its own over the run's one skeleton and registry.
    drafter = Drafter(sk, registry)
    draft: list[str] = []
    for fn in sk.files[stem]:
        draft += drafter.draft(fn)
        draft.append("")
    path = stub_path(stem)
    hand = path.read_text().splitlines()
    spliced, replaced = splice(hand, draft)
    target = MIRROR / path.relative_to(REPO)
    if "import Foundation" not in spliced:
        # A stub written before Foundation joined the stub imports gets it in the mirror, so libc math resolves.
        first = next((i for i, line in enumerate(spliced) if line.startswith("import ")), 0)
        spliced.insert(first, "import Foundation")
    target.write_text("\n".join(spliced) + "\n")
    build = subprocess.run(["swift", "build", "--package-path", str(MIRROR), "--scratch-path", str(SCRATCH), "--product", "jampgame"],
                           capture_output=True, text=True)
    LOG.write_text(build.stdout + build.stderr)
    cascades = 0
    defects: list[str] = []
    summaries: list[str] = []
    # The compiler reports one error under more than one job at times, so each error line counts once.
    for line in dict.fromkeys(ANSI.sub("", raw) for raw in (build.stdout + build.stderr).splitlines()):
        m = ERROR.match(line)
        if m is None:
            if line.startswith("error:"):
                summaries.append(line)
            continue
        number, message = (m.group(1), m.group(2)) if m.group(1) else (m.group(3), m.group(4))
        name = MISSING.search(message)
        if name and name.group(1) in drafter.hole_names:
            cascades += 1
        else:
            defects.append(f"{target.name}:{number}: {message}")
    if summaries and not defects and not cascades:
        # An error outside a Swift file is the build's own, and it stands as a defect so a broken mirror never reads clean.
        defects += summaries
    print(f"{stem}: {replaced} of {len(functions(hand))} hand functions replaced, {drafter.holes} holes, {cascades} cascade errors, {len(defects)} defects")
    for line in defects:
        print(f"  {line}")
    subprocess.run(["rsync", "-a", str(path), str(target)], check=True)
    return drafter.holes, cascades, len(defects)


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
    holes = 0
    cascades = 0
    defects = 0
    for stem in stems:
        if adopted(stem):
            print(f"{stem}: adopted, skipped")
            continue
        counts = gate(sk, registry, stem)
        holes += counts[0]
        cascades += counts[1]
        defects += counts[2]
    print(f"build log: {LOG}")
    print(f"total: {holes} holes, {cascades} cascade errors, {defects} defects")
    sys.exit(1 if defects else 0)


if __name__ == "__main__":
    main()
