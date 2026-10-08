#!/usr/bin/env python3
"""snapshot.py: the text of every generator that reads the table, one file each, so one command proves that no printed byte moved.

The snapshot holds the text of `skeleton.py --only` and `manifest.py --only` for each stem, the files of `traps.py`, `channel.py`, and `views.py`,
and the text of `bodies.py --stem` for each stem of the bg target and the game target.
One run parses once and drafts every stem in the same process, so a snapshot costs one cold sweep at most and no generator writes into Sources/.
`--check` writes a new snapshot to a temporary folder and compares it with the given folder by `diff -r`.
The snapshot folder belongs to the caller and stays outside version control.

Usage:
  .venv/bin/python snapshot.py --out ~/.cache/jka-swift/snapshot-stage-two-step1
  .venv/bin/python snapshot.py --check ~/.cache/jka-swift/snapshot-stage-two-step1
"""

from __future__ import annotations

import argparse
import subprocess
import sys
import tempfile
from pathlib import Path

import closure as C
from bodies import Lowering, Registry
from channel import Channel
from manifest import Manifest
from printer import stem_text
from skeleton import BG, LOGIC, target_of
from traps import Traps
from views import Generator, indexed_fields, texts


def write(out: Path) -> int:
    """Write every generator text into the folder and give back the count of files."""
    parse = C.Parse()
    files: dict[str, str] = {}
    manifest = Manifest(parse)
    sk = manifest.skeleton
    for stem in sorted(set(sk.files) | set(sk.variables)):
        files[f"skeleton/{stem}.swift"] = "\n".join(sk.file(stem)) + "\n"
        files[f"manifest/{stem}.md"] = "\n".join(manifest.file(stem)) + "\n"
    files["traps/g_syscalls.swift"] = "\n".join(Traps(parse).emit()).rstrip() + "\n"
    channel = Channel(parse)
    files["channel/bg_strap.swift"] = "\n".join(channel.strap_file()).rstrip() + "\n"
    files["channel/bg_callbacks.swift"] = "\n".join(channel.callback_file()).rstrip() + "\n"
    files["channel/BgChannel.swift"] = "\n".join(channel.install_file()).rstrip() + "\n"
    gen = Generator(parse, None)
    gen.indexed_fields = indexed_fields(gen)
    for view, stems in texts(gen.emit()).items():
        for stem, text in stems.items():
            files[f"views/{view}/{stem}.swift"] = text
    # The drafts print from the lowered rows, as `bodies.py --stem` prints them, over the one skeleton and registry of this run.
    lowering = Lowering(sk, Registry())
    for stem in sorted(stem for stem in sk.files if target_of(stem) in (BG, LOGIC)):
        files[f"bodies/{stem}.swift"] = stem_text([lowering.lines(stem, fn.cur.spelling) for fn in sk.files[stem]])
    for name, text in files.items():
        path = out / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)
    return len(files)


def compare(expected: Path, actual: Path) -> int:
    """The exit code of `diff -r` over the two folders, 0 when they are equal and 1 when a file differs. The difference goes to stdout."""
    return subprocess.run(["diff", "-r", str(expected), str(actual)]).returncode


def main() -> None:
    ap = argparse.ArgumentParser()
    group = ap.add_mutually_exclusive_group(required=True)
    group.add_argument("--out", type=Path, help="the folder the snapshot goes to")
    group.add_argument("--check", type=Path, help="the folder of an earlier snapshot to compare a new one with")
    args = ap.parse_args()
    if args.out:
        count = write(args.out)
        print(f"snapshot.py: {count} files, {args.out}")
        return
    if not args.check.is_dir():
        sys.exit(f"snapshot.py: no snapshot folder at {args.check}")
    with tempfile.TemporaryDirectory() as folder:
        count = write(Path(folder))
        code = compare(args.check, Path(folder))
    print(f"snapshot.py: {count} files, " + ("no difference" if code == 0 else "a difference"))
    sys.exit(code)


if __name__ == "__main__":
    main()
