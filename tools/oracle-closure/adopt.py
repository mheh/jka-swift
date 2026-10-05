#!/usr/bin/env python3
"""adopt.py: the drafts of a stem over its stub in the working tree, once the gate reads zero defects.

The last pass's draft of each stem sits at .build-draft/drafts/<stem>.swift after draftcheck.py ran.
This splices those bodies over the stub's `portMissing` functions with draftcheck's own splice, matched by Raven line,
and deletes the generated header line, which adopts the file so skeleton.py leaves it alone from then on.
A stem with no draft on disk, or a stub already adopted, is skipped and reported.
The gate after an adoption is `swift build` and `swift test --no-parallel`, and manifest.py rereads the marker state.

Usage:
  .venv/bin/python adopt.py --stem g_cmds
  .venv/bin/python adopt.py --game     # every game stem with a draft on disk
"""

from __future__ import annotations

import argparse
import sys

from draftcheck import DRAFTS, functions, splice
from reexport import REPO
from skeleton import LOGIC, NOTE, stub_path, target_of


def adopt(stem: str) -> str:
    """One stem spliced and adopted in the working tree. The report line comes back."""
    target = stub_path(stem)
    draft_path = DRAFTS / f"{stem}.swift"
    if not draft_path.exists():
        return f"{stem}: no draft on disk, skipped"
    hand = target.read_text().split("\n")
    header = NOTE.format(stem=stem)
    if hand[0] != header:
        return f"{stem}: already adopted, skipped"
    draft = draft_path.read_text().split("\n")
    out, _, replaced = splice(hand, draft)
    # The header line and the blank line after it go, which is the adoption of rule 13.
    if out[0] == header:
        out = out[2:] if len(out) > 1 and out[1] == "" else out[1:]
    target.write_text("\n".join(out))
    markers = sum(1 for line in out if "portMissing(" in line)
    return f"{stem}: {replaced} of {len(functions(hand))} functions spliced, adopted, {markers} portMissing lines"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--stem", help="the Raven files to adopt, g_cmds,g_main")
    parser.add_argument("--game", action="store_true", help="every game stem with a draft on disk")
    args = parser.parse_args()
    if args.game:
        stems = sorted(p.stem for p in DRAFTS.glob("*.swift") if target_of(p.stem) == LOGIC)
    elif args.stem:
        stems = args.stem.split(",")
    else:
        parser.error("one of --stem or --game")
    for stem in stems:
        print(adopt(stem))


if __name__ == "__main__":
    sys.exit(main())
