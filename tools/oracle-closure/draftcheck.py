#!/usr/bin/env python3
"""draftcheck.py: the compile gate of bodies.py, one Raven file at a time.

The drafts of one file replace the hand bodies of its Swift file in a mirror of the package under .build-draft/, and the
mirror builds the game product. No file of the working tree changes. The report separates three counts: the holes the
draft left, the errors that follow from a hole, because a local the hole declared is missing, and the errors that stand
on their own, which are the draft's defects. The build log stays at .build-draft/build.log.

Usage:
  .venv/bin/python draftcheck.py --stem bg_pmove
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys

from bodies import OVERLAY, Drafter, Registry
from reexport import REPO
from skeleton import Skeleton, stub_path

MIRROR = REPO / ".build-draft" / "tree"
SCRATCH = REPO / ".build-draft" / "scratch"
LOG = REPO / ".build-draft" / "build.log"
SOURCE_LINE = re.compile(r"/// Source: oracle/codemp/game/\w+\.c:(\d+)$")
ERROR = re.compile(r"^/.*\.swift:(\d+):\d+: error: (.*)$")
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


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--stem", required=True, help="the Raven file to draft and build, bg_pmove")
    args = parser.parse_args()
    sk = Skeleton(overlay=OVERLAY)
    drafter = Drafter(sk, Registry())
    draft: list[str] = []
    for fn in sk.files[args.stem]:
        draft += drafter.draft(fn)
        draft.append("")
    path = stub_path(args.stem)
    hand = path.read_text().splitlines()
    spliced, replaced = splice(hand, draft)
    MIRROR.mkdir(parents=True, exist_ok=True)
    # The manifest names the test targets too, so the mirror carries Tests, and the build stays on the one product.
    for tree in ("Sources", "Tests"):
        subprocess.run(["rsync", "-a", "--delete", str(REPO / tree) + "/", str(MIRROR / tree) + "/"], check=True)
    subprocess.run(["rsync", "-a", str(REPO / "Package.swift"), str(MIRROR / "Package.swift")], check=True)
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
        name = MISSING.search(m.group(2))
        if name and name.group(1) in drafter.hole_names:
            cascades += 1
        else:
            defects.append(f"{target.name}:{m.group(1)}: {m.group(2)}")
    if summaries and not defects and not cascades:
        # An error outside a Swift file is the build's own, and it stands as a defect so a broken mirror never reads clean.
        defects += summaries
    print(f"{args.stem}: {replaced} of {len(functions(hand))} hand functions replaced, {drafter.holes} holes, {cascades} cascade errors, {len(defects)} defects")
    for line in defects:
        print(f"  {line}")
    print(f"build log: {LOG}")
    sys.exit(1 if defects else 0)


if __name__ == "__main__":
    main()
