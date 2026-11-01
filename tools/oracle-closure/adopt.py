#!/usr/bin/env python3
"""adopt.py: the drafts of a stem over its stub in the working tree, once the gate reads zero defects.

The last pass's draft of each stem sits at .build-draft/drafts/<stem>.swift after draftcheck.py ran.
This splices those bodies over the stub's `portMissing` functions with draftcheck's own splice, matched by Raven line,
and deletes the generated header line, which adopts the file so skeleton.py leaves it alone from then on.
In a file already adopted, a draft replaces only a function whose body is still the marker pair of the skeleton, the TODO line and the `portMissing` call.
A function with a hand body keeps it.
A replaced function keeps its hand signature line when that line differs from the draft's, and takes the draft body under it.
A stem with no draft on disk is skipped and reported.
The gate after an adoption is `swift build` and `swift test --no-parallel`, and manifest.py rereads the marker state.

Usage:
  .venv/bin/python adopt.py --stem g_cmds
  .venv/bin/python adopt.py --game     # every game stem with a draft on disk
  .venv/bin/python adopt.py --unit mp-cgame --stem cg_draw
"""

from __future__ import annotations

import argparse
import re
import sys

import closure as C
from align import stub
from draftcheck import DRAFTS, body_name, functions, splice
from reexport import REPO
from skeleton import LOGIC, NOTE, stub_path, target_of


# The func line of a function, after any attribute and access word, `private func CG_DrawHealth(_ menuHUD: MenuDef) {`.
FUNC_LINE = re.compile(r"^(?:@\S+ )*(?:(?:private|fileprivate|public|internal) )?func ")


def hand_signatures(hand: list[str], draft: list[str]) -> list[str]:
    """The draft with the func line of each function taken from the hand function of the same Raven line, when the two lines differ.
    A person can change a signature in an adopted file, and the draft body goes under the hand signature."""
    h = functions(hand)
    out = list(draft)
    for raven, (a, b) in functions(draft).items():
        if raven not in h:
            continue
        mine = next((i for i in range(a, b + 1) if FUNC_LINE.match(out[i])), None)
        theirs = next((line for line in hand[h[raven][0]:h[raven][1] + 1] if FUNC_LINE.match(line)), None)
        if mine is not None and theirs is not None:
            out[mine] = theirs
    return out


def adopt(stem: str) -> str:
    """One stem spliced and adopted in the working tree. The report line comes back."""
    target = stub_path(stem)
    draft_path = C.written(DRAFTS) / f"{stem}.swift"
    if not draft_path.exists():
        return f"{stem}: no draft on disk, skipped"
    hand = target.read_text().split("\n")
    header = NOTE.format(stem=stem)
    draft = draft_path.read_text().split("\n")
    keep: set[int] = set()
    if hand[0] != header:
        # An adopted file keeps each function whose body is no longer the marker pair of the skeleton.
        keep = {raven for raven, (a, b) in functions(hand).items() if not stub(body_name(hand, a, b, raven), hand[a:b + 1])}
        draft = hand_signatures(hand, draft)
    out, _, replaced = splice(hand, draft, keep)
    # The header line and the blank line after it go, which is the adoption of rule 13.
    if out[0] == header:
        out = out[2:] if len(out) > 1 and out[1] == "" else out[1:]
    target.write_text("\n".join(out))
    markers = sum(1 for line in out if "portMissing(" in line)
    return f"{stem}: {replaced} of {len(functions(hand))} functions spliced, {len(keep)} hand functions kept, adopted, {markers} portMissing lines"


def main() -> None:
    parser = argparse.ArgumentParser()
    C.unit_argument(parser)
    parser.add_argument("--stem", help="the Raven files to adopt, g_cmds,g_main")
    parser.add_argument("--game", action="store_true", help=f"every stem under Sources/{LOGIC} with a draft on disk")
    args = parser.parse_args()
    if args.game:
        stems = sorted(p.stem for p in C.written(DRAFTS).glob("*.swift") if target_of(p.stem) == LOGIC)
    elif args.stem:
        stems = args.stem.split(",")
    else:
        parser.error("one of --stem or --game")
    for stem in stems:
        print(adopt(stem))


if __name__ == "__main__":
    sys.exit(main())
