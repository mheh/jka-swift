"""store.py: the table cache of the sweeps, one SQLite file in WAL mode.

A generation is a named set of fact kinds that one key covers.
The store saves the rows of a generation in one transaction, with the key and the hash of each input file, and gives them back only under the same key.
The schema names facts about functions, parameters, fields, and locals, and no project, source root, target language, or C type.
"""

from __future__ import annotations

import sqlite3
from pathlib import Path

SCHEMA = """
CREATE TABLE IF NOT EXISTS meta (name TEXT PRIMARY KEY, value TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS files (generation TEXT NOT NULL, path TEXT NOT NULL, hash TEXT NOT NULL, PRIMARY KEY (generation, path));
CREATE TABLE IF NOT EXISTS parameters (fact TEXT NOT NULL, function TEXT NOT NULL, parameter TEXT NOT NULL);
"""

# The fact kinds that name one parameter of one function, each a set of (function, parameter) pairs.
PARAMETER_FACTS = ("nullable", "hopped", "readonly_text", "indexed_params", "array_handoffs", "stores_through")


class Store:
    """One open store file. Every method opens no file of its own, and a save is one transaction."""

    def __init__(self, path: Path) -> None:
        self.db = sqlite3.connect(path)
        self.db.execute("PRAGMA journal_mode=WAL")
        self.db.execute("PRAGMA synchronous=NORMAL")
        self.db.executescript(SCHEMA)

    def key(self, generation: str) -> str | None:
        """The key the saved rows of a generation stand under, or None when the store holds no such generation."""
        row = self.db.execute("SELECT value FROM meta WHERE name = ?", (f"key:{generation}",)).fetchone()
        return row[0] if row else None

    def load(self, generation: str, key: str) -> dict | None:
        """The facts of a generation by kind, or None when the store holds them under another key or not at all."""
        if self.key(generation) != key:
            return None
        row = self.db.execute("SELECT value FROM meta WHERE name = ?", (f"kinds:{generation}",)).fetchone()
        kinds = row[0].split(",") if row and row[0] else []
        return {kind: self.read(kind) for kind in kinds}

    def save(self, generation: str, key: str, files: dict[str, str], facts: dict) -> None:
        """Replace the rows of every kind in `facts`, the file hashes, and the key of the generation, in one transaction."""
        with self.db:
            for kind, value in facts.items():
                self.clear(kind)
                self.write(kind, value)
            self.db.execute("DELETE FROM files WHERE generation = ?", (generation,))
            self.db.executemany("INSERT INTO files VALUES (?, ?, ?)", [(generation, path, digest) for path, digest in files.items()])
            self.db.execute("INSERT OR REPLACE INTO meta VALUES (?, ?)", (f"kinds:{generation}", ",".join(facts)))
            self.db.execute("INSERT OR REPLACE INTO meta VALUES (?, ?)", (f"key:{generation}", key))

    # MARK: - The rows of each kind

    def clear(self, kind: str) -> None:
        if kind in PARAMETER_FACTS:
            self.db.execute("DELETE FROM parameters WHERE fact = ?", (kind,))
            return
        raise KeyError(f"store.py: no fact kind {kind}")

    def write(self, kind: str, value) -> None:
        if kind in PARAMETER_FACTS:
            self.db.executemany("INSERT INTO parameters VALUES (?, ?, ?)", [(kind, f, p) for f, p in value])
            return
        raise KeyError(f"store.py: no fact kind {kind}")

    def read(self, kind: str):
        if kind in PARAMETER_FACTS:
            return {(f, p) for f, p in self.db.execute("SELECT function, parameter FROM parameters WHERE fact = ?", (kind,))}
        raise KeyError(f"store.py: no fact kind {kind}")
