"""store.py: the table cache of the sweeps, one SQLite file in WAL mode.

A generation is a named set of fact kinds that one key covers.
The store saves the rows of a generation in one transaction, with the key and the hash of each input file, and gives them back only under the same key.
The schema names facts about functions, parameters, fields, and locals, and no project, source root, target language, or C type.
"""

from __future__ import annotations

import contextlib
import hashlib
import json
import sqlite3
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Callable, Iterable, Iterator

# The version of SCHEMA. A change to a table or a column takes the next number, and a store of another version is made again.
SCHEMA_VERSION = 2

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
CREATE TABLE IF NOT EXISTS boundary_overloads (fact TEXT NOT NULL, function TEXT NOT NULL, parameter TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS reads (fact TEXT NOT NULL, seq INTEGER NOT NULL, root TEXT NOT NULL, path TEXT NOT NULL, written INTEGER NOT NULL,
    value_type TEXT NOT NULL, cite TEXT NOT NULL, at INTEGER NOT NULL, name TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS rulings (fact TEXT NOT NULL, ruling TEXT NOT NULL, function TEXT NOT NULL, parameter TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS locals (key TEXT NOT NULL, file TEXT NOT NULL, function TEXT NOT NULL, fact TEXT NOT NULL, name TEXT NOT NULL,
    cursor_kind TEXT, cursor_buffer TEXT, cursor_is_global INTEGER, walked TEXT, index_name TEXT);
CREATE INDEX IF NOT EXISTS locals_by_function ON locals (file, function);
CREATE TABLE IF NOT EXISTS signatures (seq INTEGER NOT NULL, file TEXT NOT NULL, name TEXT NOT NULL, kind TEXT NOT NULL, target TEXT NOT NULL,
    text TEXT NOT NULL, forward TEXT, reason TEXT, source TEXT NOT NULL, destination TEXT NOT NULL, state TEXT NOT NULL, peer TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS signatures_by_name ON signatures (name);
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


def read_row(i: int, read) -> tuple:
    """One read as a row. The path is a JSON list, and the name is the one the read carries, short or long."""
    return (i, read.root, json.dumps(list(read.path)), int(read.write), read.swift, read.cite, int(read.at), read.name)


def reads(rows: list[tuple]) -> dict:
    from table import Read

    out = {}
    for _, root, path, written, value_type, cite, at, name in rows:
        read = Read(root, tuple(json.loads(path)), value_type, bool(written), cite, at=bool(at))
        read.name = name
        out[read.key] = read
    return out


# The fact kinds by name, each the name of the Table attribute it holds.
KINDS: dict[str, Kind] = {
    **{kind: pairs("parameters", ("function", "parameter"))
       for kind in ("nullable", "hopped", "readonly_text", "indexed_params", "array_handoffs", "stores_through", "null_arms")},
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
    # The ruled rows a sweep starts from, each as the ruling's name, the function, and the parameter.
    "rulings": Kind("rulings", ("ruling", "function", "parameter"), lambda value: list(value), lambda rows: {tuple(row) for row in rows}),
    "reads": Kind("reads", ("seq", "root", "path", "written", "value_type", "cite", "at", "name"),
                  lambda value: [read_row(i, read) for i, read in enumerate(value.values())], reads, order="seq"),
    **{kind: pairs("boundary_overloads", ("function", "parameter")) for kind in ("buffer_traps", "text_traps")},
    "file_walks": Kind("file_walks", ("seq", "pointer", "walked", "index_name"),
                       lambda value: [(i, pointer) + walk for i, (pointer, walk) in enumerate(value.items())],
                       lambda rows: {pointer: (walked, index) for _, pointer, walked, index in rows}, order="seq"),
}


# The generation of the signature rows. Its key covers the input key and the hash of every destination file the rows read.
SIGNATURES = "signatures"


# MARK: - The key

@dataclass(frozen=True)
class Keys:
    """The keys of the two generations, and the hash of each file they cover, by the file's name.

    `base` covers every input file and every tool module.
    `adoption` covers the base key, the first line of every stub, and the salt, so a stub edit leaves the base generation alone."""

    base: str
    adoption: str
    files: dict[str, str]
    stubs: dict[str, str]


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def file_hash(path: Path) -> str:
    """The hash of a file's bytes, and the empty name for a file that does not exist, so its creation changes the hash."""
    return digest(path.read_bytes()) if path.exists() else ""


def named(path: Path, root: Path) -> str:
    """The name the store keeps for a file: relative to the root inside it, and absolute outside it."""
    path = path.resolve()
    return str(path.relative_to(root.resolve())) if path.is_relative_to(root.resolve()) else str(path)


def combined(hashes: dict[str, str], *extra: str) -> str:
    return digest("\n".join([f"{name} {value}" for name, value in sorted(hashes.items())] + list(extra)).encode())


def keys(inputs: Iterable[Path], tools: Iterable[Path], stubs: Iterable[Path], root: Path, salt: str = "",
         values: dict[str, str] | None = None) -> Keys:
    """The keys of one input set. A file that does not exist hashes as the empty name, so its creation changes the key.
    `values` are named inputs that are no file, and the base key covers each one beside the files, under its own name."""
    files = {named(path, root): file_hash(path) for path in [*inputs, *tools]}
    files |= {name: digest(text.encode()) for name, text in (values or {}).items()}
    lines = {named(path, root): digest(path.read_bytes().split(b"\n", 1)[0]) if path.exists() else "" for path in stubs}
    base = combined(files)
    return Keys(base=base, adoption=combined(lines, base, salt), files=files, stubs=lines)


class Store:
    """One open store file. A save is one transaction, and a load is one read transaction.
    Every open writes the schema version to meta and deletes a store of another version, so a reader such as lookup.py does this too."""

    def __init__(self, path: Path) -> None:
        self.path = Path(path)
        try:
            self.db = self.open()
        except sqlite3.DatabaseError as error:
            # The file is no store, so it holds no fact worth more than one sweep.
            print(f"store.py: {self.path} is corrupt ({error}), so it is deleted and made again", file=sys.stderr)
            self.delete()
            self.db = self.open()
        version = self.meta("schema")
        fresh = self.db.execute("SELECT COUNT(*) FROM meta").fetchone()[0] == 0
        if version != str(SCHEMA_VERSION) and not fresh:
            print(f"store.py: {self.path} holds schema version {version}, not {SCHEMA_VERSION}, so it is deleted and made again", file=sys.stderr)
            self.db.close()
            self.delete()
            self.db = self.open()
        with self.db:
            self.db.execute("INSERT OR REPLACE INTO meta VALUES ('schema', ?)", (str(SCHEMA_VERSION),))

    def open(self) -> sqlite3.Connection:
        db = sqlite3.connect(self.path)
        try:
            db.execute("PRAGMA journal_mode=WAL")
            db.execute("PRAGMA synchronous=NORMAL")
            db.executescript(SCHEMA)
        except sqlite3.DatabaseError:
            db.close()
            raise
        return db

    def delete(self) -> None:
        """Delete the store file with its WAL files."""
        for suffix in ("", "-wal", "-shm"):
            Path(f"{self.path}{suffix}").unlink(missing_ok=True)

    def close(self) -> None:
        self.db.close()

    def __enter__(self) -> Store:
        return self

    def __exit__(self, *exc) -> None:
        self.close()

    def key(self, generation: str) -> str | None:
        """The key the saved rows of a generation stand under, or None when the store holds no such generation."""
        return self.meta(f"key:{generation}")

    def load(self, generation: str, key: str) -> dict | None:
        """The facts of a generation by kind, or None when the store holds them under another key or not at all."""
        with self.snapshot():
            if self.key(generation) != key:
                return None
            kinds = self.meta(f"kinds:{generation}") or ""
            facts = {kind: self.read(kind) for kind in kinds.split(",") if kind}
        return facts

    @contextlib.contextmanager
    def snapshot(self) -> Iterator[None]:
        """One read transaction, so every read inside it sees the rows of one save, whatever another process saves meanwhile."""
        self.db.execute("BEGIN")
        try:
            yield
        finally:
            self.db.commit()

    def save(self, generation: str, key: str, files: dict[str, str], facts: dict) -> None:
        """Replace the rows of every kind in `facts`, the file hashes, and the key of the generation, in one transaction."""
        with self.db:
            for kind, value in facts.items():
                self.write(kind, value)
            self.db.execute("DELETE FROM files WHERE generation = ?", (generation,))
            self.db.executemany("INSERT INTO files VALUES (?, ?, ?)", [(generation, path, digest) for path, digest in files.items()])
            self.db.execute("INSERT OR REPLACE INTO meta VALUES (?, ?)", (f"kinds:{generation}", ",".join(facts)))
            self.db.execute("INSERT OR REPLACE INTO meta VALUES (?, ?)", (f"key:{generation}", key))

    def changed(self, generation: str, files: dict[str, str]) -> list[str]:
        """The names of the files whose hash differs from the one the generation was saved with, a new file and a gone file too, in name order."""
        saved = self.files(generation)
        return sorted(name for name in set(saved) | set(files) if saved.get(name) != files.get(name))

    def files(self, generation: str) -> dict[str, str]:
        """The hash of each file a generation was saved with, by the file's name."""
        return dict(self.db.execute("SELECT path, hash FROM files WHERE generation = ?", (generation,)).fetchall())

    def rehashed(self, generation: str, root: Path) -> list[str]:
        """The names of the saved files of a generation whose bytes on disk differ from the saved hash, a gone file too, in name order.
        A reader that cannot compute the key of the generation checks this part of it, with no parse."""
        return self.changed(generation, {name: file_hash(Path(root) / name) for name in self.files(generation)})

    # MARK: - The local facts of one function

    def load_locals(self, key: str, file: str, function: str):
        """The local facts of one function as a LocalFacts, or None when the store holds none for it under this key."""
        from table import Cursor, Local, LocalFacts

        rows = self.db.execute("SELECT fact, name, cursor_kind, cursor_buffer, cursor_is_global, walked, index_name FROM locals "
                               "WHERE key = ? AND file = ? AND function = ? ORDER BY rowid", (key, file, function)).fetchall()
        if not rows:
            return None
        facts = LocalFacts(rows={}, written=set(), single_writes=set(), addressed=set())
        sets = {"written": facts.written, "single": facts.single_writes, "addressed": facts.addressed}
        for fact, name, kind, buffer, is_global, walked, index in rows:
            if fact == "row":
                cursor = Cursor(kind, buffer, bool(is_global)) if kind is not None else None
                facts.rows[name] = Local(cursor=cursor, table=(walked, index) if walked is not None else None)
            elif fact in sets:
                sets[fact].add(name)
        return facts

    def save_locals(self, key: str, file: str, function: str, facts) -> None:
        """Replace the local facts of one function. A `swept` row marks a function whose facts are all empty."""
        rows = [("swept", "", None, None, None, None, None)]
        for name, local in facts.rows.items():
            cursor = local.cursor
            walk = local.table or (None, None)
            rows.append(("row", name, cursor and cursor.kind, cursor and cursor.buffer,
                         None if cursor is None else int(cursor.is_global)) + tuple(walk))
        rows += [("written", name) + (None,) * 5 for name in facts.written]
        rows += [("single", name) + (None,) * 5 for name in facts.single_writes]
        rows += [("addressed", name) + (None,) * 5 for name in facts.addressed]
        with self.db:
            self.db.execute("DELETE FROM locals WHERE file = ? AND function = ?", (file, function))
            self.db.executemany("INSERT INTO locals VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [(key, file, function) + row for row in rows])

    # MARK: - The signatures of the destination files

    SIGNATURE_COLUMNS = ("file", "name", "kind", "target", "text", "forward", "reason", "source", "destination", "state", "peer")

    def save_signatures(self, key: str, files: dict[str, str], rows: list[dict]) -> None:
        """Replace every signature row, in the order given, with the generation's key and the hash of each file the rows were read from."""
        with self.db:
            self.db.execute("DELETE FROM signatures")
            self.db.executemany(f"INSERT INTO signatures VALUES (?, {', '.join('?' for _ in self.SIGNATURE_COLUMNS)})",
                                [(i,) + tuple(row[c] for c in self.SIGNATURE_COLUMNS) for i, row in enumerate(rows)])
            self.db.execute("DELETE FROM files WHERE generation = ?", (SIGNATURES,))
            self.db.executemany("INSERT INTO files VALUES (?, ?, ?)", [(SIGNATURES, path, hashed) for path, hashed in files.items()])
            self.db.execute("INSERT OR REPLACE INTO meta VALUES (?, ?)", (f"key:{SIGNATURES}", key))

    def signatures(self, name: str) -> list[dict] | None:
        """The signature rows of one name in saved order, or None when the store holds no signature rows.
        The caller checks the saved file hashes with `rehashed` before it trusts the rows."""
        with self.snapshot():
            if self.key(SIGNATURES) is None:
                return None
            rows = self.db.execute(f"SELECT {', '.join(self.SIGNATURE_COLUMNS)} FROM signatures WHERE name = ? ORDER BY seq", (name,)).fetchall()
        return [dict(zip(self.SIGNATURE_COLUMNS, row)) for row in rows]

    def drop_locals(self) -> None:
        """Delete the local facts of every function, because the generation they stand on was swept again."""
        with self.db:
            self.db.execute("DELETE FROM locals")

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
