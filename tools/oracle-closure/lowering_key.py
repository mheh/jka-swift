"""lowering_key.py: the key of the lowered generation and the language of its rows.

The key covers the adoption key, the declaration lines of every Swift file under Sources/, and the lowering modules of project.toml.
A Swift file counts by its declaration lines alone, so a body edit under a signature keeps the key.
bodies.py computes the key from its parse, and printer.py, align.py, and compare.py compute it with no parse, so the key lives here and not in a drafter module."""

from __future__ import annotations

import re
from pathlib import Path

import closure as C
import store as S

FUNC_HEAD = re.compile(r"func\s+`?(\w+)`?\s*\(")
# A file-scope `var`, `let`, or `func` of a Swift file: at column 0, after its modifiers. A method sits indented under its type.
MODIFIERS = r"(?:(?:public|package|internal|private|fileprivate|nonisolated\(unsafe\)|@\w+(?:\([^)]*\))?)\s+)*"
VAR_LINE = re.compile(MODIFIERS + r"(?:var|let)\s+`?(\w+)`?")
HERE = Path(__file__).resolve().parent
# The language of the lowered rows, a column value of every row the lowering writes.
LANGUAGE = C.PROJECT["project"]["target_language"]


def declaration_line(line: str) -> bool:
    """True for a line the registry reads a declaration from: a file-scope `var` or `let`, or a line that holds a `func` head."""
    return VAR_LINE.match(line) is not None or (FUNC_HEAD.search(line) is not None and "func " in line.split("//")[0])


def lowered_keys(adoption: str, sources: Path, modules: list[Path], root: Path) -> tuple[str, dict[str, str]]:
    """The key of the lowered generation and the hash of each file it covers, by the file's name."""
    files = {S.named(path, root): S.digest("\n".join(line for line in path.read_text().splitlines() if declaration_line(line)).encode())
             for path in sorted(sources.rglob("*.swift"))}
    files |= {S.named(path, root): S.file_hash(path) for path in modules}
    return S.combined(files, adoption), files


def lowering_modules() -> list[Path]:
    """The lowering modules that project.toml lists, as paths."""
    return [HERE / name for name in C.PROJECT["store"]["lowering"]]
