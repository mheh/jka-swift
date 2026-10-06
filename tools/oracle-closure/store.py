"""store.py: the table cache of the sweeps, one SQLite file in WAL mode.

A generation is a named set of fact kinds that one key covers.
The store saves the rows of a generation in one transaction, with the key and the hash of each input file, and gives them back only under the same key.
The schema names facts about functions, parameters, fields, and locals, and no project, source root, target language, or C type.
"""

from __future__ import annotations

import sqlite3
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Callable, Iterable

SCHEMA = """
CREATE TABLE IF NOT EXISTS meta (name TEXT PRIMARY KEY, value TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS files (generation TEXT NOT NULL, path TEXT NOT NULL, hash TEXT NOT NULL, PRIMARY KEY (generation, path));
CREATE TABLE IF NOT EXISTS parameters (fact TEXT NOT NULL, function TEXT NOT NULL, parameter TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS functions (fact TEXT NOT NULL, seq INTEGER NOT NULL, file TEXT NOT NULL, name TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS fields (fact TEXT NOT NULL, record TEXT NOT NULL, field TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS handoffs (fact TEXT NOT NULL, seq INTEGER NOT NULL, callee TEXT NOT NULL, parameter TEXT NOT NULL,
    held TEXT NOT NULL, caller TEXT NOT NULL, caller_parameter TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS cursors (fact TEXT NOT NULL, seq INTEGER NOT NULL, file TEXT NOT NULL, function TEXT NOT NULL, name TEXT NOT NULL,
    kind TEXT NOT NULL, buffer TEXT NOT NULL, is_global INTEGER NOT NULL);
CREATE TABLE IF NOT EXISTS alias_writes (fact TEXT NOT NULL, buffer TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS trap_overloads (fact TEXT NOT NULL, trap TEXT NOT NULL, parameter TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS file_walks (fact TEXT NOT NULL, seq INTEGER NOT NULL, pointer TEXT NOT NULL, walked TEXT NOT NULL, index_name TEXT NOT NULL);
"""


@dataclass(frozen=True)
class Kind:
    """One fact kind: the table that holds it, its columns after `fact`, and the two maps between the value and the rows.
    `order` names the column that keeps the order of a list, or is None for a set."""

    table: str
    columns: tuple[str, ...]
    encode: Callable[[Any], Iterable[tuple]]
    decode: Callable[[list[tuple]], Any]
    order: str | None = None


def pairs(table: str, columns: tuple[str, str]) -> Kind:
    """A set of pairs, one row each."""
    return Kind(table, columns, lambda value: list(value), lambda rows: {tuple(row) for row in rows})


def names(table: str, column: str, blanks: tuple[str, ...] = ()) -> Kind:
    """A set of names, one row each, with an empty value in each column of `blanks`."""
    return Kind(table, blanks + (column,), lambda value: [("",) * len(blanks) + (name,) for name in value],
                lambda rows: {row[-1] for row in rows})


def sequence(table: str, columns: tuple[str, ...]) -> Kind:
    """A list of tuples, one row each, in its own order."""
    return Kind(table, ("seq",) + columns, lambda value: [(i,) + tuple(item) for i, item in enumerate(value)],
                lambda rows: [tuple(row[1:]) for row in rows], order="seq")


def handoff_row(i: int, callee: str, parameter: str, table: bool | tuple[str, str]) -> tuple:
    """One hand-off as a row: `held` is `table` for a table of the caller's own, `none` for no table, and `parameter` for a caller's parameter."""
    if isinstance(table, tuple):
        return (i, callee, parameter, "parameter") + table
    return (i, callee, parameter, "table" if table else "none", "", "")


def handoff(row: tuple) -> tuple[str, str, bool | tuple[str, str]]:
    _, callee, parameter, held, caller, caller_parameter = row
    return (callee, parameter, (caller, caller_parameter) if held == "parameter" else held == "table")


def cursors(rows: list[tuple]) -> dict:
    from table import Cursor

    return {(f, function, name): Cursor(kind, buffer, bool(is_global)) for _, f, function, name, kind, buffer, is_global in rows}


# The fact kinds by name, each the name of the Table attribute it holds.
KINDS: dict[str, Kind] = {
    **{kind: pairs("parameters", ("function", "parameter"))
       for kind in ("nullable", "hopped", "readonly_text", "indexed_params", "array_handoffs", "stores_through")},
    **{kind: names("functions", "name", blanks=("seq", "file")) for kind in ("called", "store_swept", "null_returns")},
    # The bodies of the swept unit keep the order of the parse.
    "functions": sequence("functions", ("file", "name")),
    "indexed_fields": pairs("fields", ("record", "field")),
    "handoffs": Kind("handoffs", ("seq", "callee", "parameter", "held", "caller", "caller_parameter"),
                     lambda value: [handoff_row(i, *item) for i, item in enumerate(value)],
                     lambda rows: [handoff(row) for row in rows], order="seq"),
    "cursors": Kind("cursors", ("seq", "file", "function", "name", "kind", "buffer", "is_global"),
                    lambda value: [(i,) + key + (c.kind, c.buffer, int(c.is_global)) for i, (key, c) in enumerate(value.items())],
                    cursors, order="seq"),
    "alias_writes": names("alias_writes", "buffer"),
    **{kind: pairs("trap_overloads", ("trap", "parameter")) for kind in ("buffer_traps", "text_traps")},
    "file_walks": Kind("file_walks", ("seq", "pointer", "walked", "index_name"),
                       lambda value: [(i, pointer) + walk for i, (pointer, walk) in enumerate(value.items())],
                       lambda rows: {pointer: (walked, index) for _, pointer, walked, index in rows}, order="seq"),
}


class Store:
    """One open store file. A save is one transaction."""

    def __init__(self, path: Path) -> None:
        self.db = sqlite3.connect(path)
        self.db.execute("PRAGMA journal_mode=WAL")
        self.db.execute("PRAGMA synchronous=NORMAL")
        self.db.executescript(SCHEMA)

    def key(self, generation: str) -> str | None:
        """The key the saved rows of a generation stand under, or None when the store holds no such generation."""
        return self.meta(f"key:{generation}")

    def load(self, generation: str, key: str) -> dict | None:
        """The facts of a generation by kind, or None when the store holds them under another key or not at all."""
        if self.key(generation) != key:
            return None
        kinds = self.meta(f"kinds:{generation}") or ""
        return {kind: self.read(kind) for kind in kinds.split(",") if kind}

    def save(self, generation: str, key: str, files: dict[str, str], facts: dict) -> None:
        """Replace the rows of every kind in `facts`, the file hashes, and the key of the generation, in one transaction."""
        with self.db:
            for kind, value in facts.items():
                self.write(kind, value)
            self.db.execute("DELETE FROM files WHERE generation = ?", (generation,))
            self.db.executemany("INSERT INTO files VALUES (?, ?, ?)", [(generation, path, digest) for path, digest in files.items()])
            self.db.execute("INSERT OR REPLACE INTO meta VALUES (?, ?)", (f"kinds:{generation}", ",".join(facts)))
            self.db.execute("INSERT OR REPLACE INTO meta VALUES (?, ?)", (f"key:{generation}", key))

    def meta(self, name: str) -> str | None:
        row = self.db.execute("SELECT value FROM meta WHERE name = ?", (name,)).fetchone()
        return row[0] if row else None

    # MARK: - The rows of each kind

    def write(self, kind: str, value: Any) -> None:
        """Replace the rows of one kind."""
        spec = KINDS[kind]
        self.db.execute(f"DELETE FROM {spec.table} WHERE fact = ?", (kind,))
        marks = ", ".join("?" for _ in range(len(spec.columns) + 1))
        self.db.executemany(f"INSERT INTO {spec.table} (fact, {', '.join(spec.columns)}) VALUES ({marks})",
                            [(kind,) + tuple(row) for row in spec.encode(value)])

    def read(self, kind: str) -> Any:
        spec = KINDS[kind]
        order = f" ORDER BY {spec.order}" if spec.order else ""
        rows = self.db.execute(f"SELECT {', '.join(spec.columns)} FROM {spec.table} WHERE fact = ?{order}", (kind,)).fetchall()
        return spec.decode(rows)
