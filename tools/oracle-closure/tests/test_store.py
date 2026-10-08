"""Seam A: a fact the store saves comes back from the store equal to the original."""

from __future__ import annotations

import contextlib
import io
import os
import sqlite3
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

from store import Store, digest  # noqa: E402
from table import Cursor, Local, LocalFacts, Read  # noqa: E402


def plain(value):
    """A value with each object of a table class spelled as its class name and its public attributes, so two equal facts compare equal."""
    if isinstance(value, dict):
        return {k: plain(v) for k, v in value.items()}
    if isinstance(value, (list, tuple)):
        return type(value)(plain(v) for v in value)
    if isinstance(value, (set, frozenset)):
        return value
    if hasattr(value, "__dict__"):
        return (type(value).__name__, {k: plain(v) for k, v in vars(value).items() if not k.startswith("_")})
    return value


class RoundTrip(unittest.TestCase):
    def setUp(self) -> None:
        self.folder = tempfile.TemporaryDirectory()
        self.path = Path(self.folder.name) / "table.sqlite"

    def tearDown(self) -> None:
        self.folder.cleanup()

    def round_trip(self, generation: str, facts: dict) -> dict | None:
        with Store(self.path) as store:
            store.save(generation, "key-1", {"codemp/game/g_main.c": "aa11"}, facts)
        with Store(self.path) as store:
            return store.load(generation, "key-1")

    def test_parameter_facts(self) -> None:
        # given every fact kind that names a parameter of a function
        facts = {
            "nullable": {("G_Damage", "inflictor"), ("trap_Trace", "mins")},
            "hopped": {("G_RadiusDamage", "ignore")},
            "readonly_text": {("G_Find", "match")},
            "indexed_params": {("BG_AnimLength", "animations")},
            "array_handoffs": {("G_RadiusList", "ent_list")},
            "null_arms": {("G_Damage", "dir"), ("G_RadiusDamage", "ignore")},
        }

        # then the store gives back the same sets
        self.assertEqual(self.round_trip("base", facts), facts)

    def test_function_facts(self) -> None:
        # given the bodies in file order and the sets of function names
        facts = {
            "functions": [("g_utils", "G_Find"), ("bg_misc", "BG_CanItemBeGrabbed"), ("g_utils", "G_Spawn")],
            "called": {"G_Find", "trap_Trace", "Q_strncpyz"},
            "store_swept": {"G_Find", "G_Spawn"},
            "null_returns": {"G_NewString"},
        }

        # then the store gives back the bodies in the same order and the same sets
        self.assertEqual(self.round_trip("base", facts), facts)

    def test_field_facts(self) -> None:
        # given the (record, field) pairs a body indexes through the pointer
        facts = {"indexed_fields": {("pmove_t", "animations"), ("gclient_t", "saber")}}

        # then the store gives back the same set
        self.assertEqual(self.round_trip("base", facts), facts)

    def test_handoffs(self) -> None:
        # given hand-offs of a table of the caller's own and of a caller's parameter, in call order
        facts = {"handoffs": [
            ("BG_AnimLength", "animations", True),
            ("PM_SetAnim", "anims", ("PM_Animate", "animations")),
            ("BG_AnimLength", "animations", True),
        ]}

        # then the store gives back the same list in the same order
        self.assertEqual(self.round_trip("base", facts), facts)

    def test_cursors(self) -> None:
        # given a read cursor over a local buffer and a write cursor over a file-scope buffer
        facts = {"cursors": {
            ("g_cmds", "Cmd_Say_f", "p"): Cursor("read", "text", False),
            ("g_utils", "vtos", "s"): Cursor("write", "str", True),
        }}

        # then the store gives back cursors with the same kind, buffer, and scope
        self.assertEqual(plain(self.round_trip("base", facts)), plain(facts))

    def test_alias_writes(self) -> None:
        # given the file-scope buffers a write cursor points into
        facts = {"alias_writes": {"str", "text"}}

        # then the store gives back the same set
        self.assertEqual(self.round_trip("base", facts), facts)

    def test_file_walks(self) -> None:
        # given the file-scope pointers a body sets to a file-scope table, each with the table and the index that stands for it
        facts = {"file_walks": {"pushed_p": ("pushed", "pushed_pIndex"), "trace_p": ("traces", "trace_pIndex")}}

        # then the store gives back the same map
        self.assertEqual(self.round_trip("base", facts), facts)

    def test_boundary_overloads(self) -> None:
        # given the boundary function parameters a caller fills with a buffer and the ones a caller hands a text
        facts = {
            "buffer_traps": {("trap_FS_Read", "buffer"), ("trap_Cvar_VariableStringBuffer", "buffer")},
            "text_traps": {("trap_FS_Write", "buffer")},
        }

        # then the store gives back the same sets
        self.assertEqual(self.round_trip("base", facts), facts)

    def test_reads(self) -> None:
        # given a read with its short name, a write, and an indexed read that took its long name
        renamed = Read("entities", ("client", "saber"), "JKAMP_Game.SaberInfo?", False, "oracle/codemp/game/bg_saber.c:120", at=True)
        renamed.name = "bgEntityAtClientSaber"
        facts = {"reads": {
            ("level", ("time",), False): Read("level", ("time",), "Int32", False, "oracle/codemp/game/bg_pmove.c:88"),
            ("entity", ("client", "pers", "cmd"), True): Read("entity", ("client", "pers", "cmd"), "JKAMP.Usercmd", True, "oracle/codemp/game/bg_misc.c:7"),
            ("entities", ("client", "saber"), False): renamed,
        }}

        # then the store gives back reads with the same root, path, type, write, cite, index, and name
        self.assertEqual(plain(self.round_trip("base", facts)), plain(facts))

    def test_rulings(self) -> None:
        # given the ruled rows a sweep started from, each as the ruling, the function, and the parameter
        facts = {"rulings": {("NULLABLE", "G_Damage", "inflictor"), ("NULLABLE", "G_Damage", "dir")}}

        # then the store gives back the same set
        self.assertEqual(self.round_trip("base", facts), facts)

    def test_locals(self) -> None:
        # given the local facts of one function with every row shape, and of one function with no facts at all
        full = LocalFacts(
            rows={
                "p": Local(cursor=Cursor("read", "text", False)),
                "it": Local(table=("bg_itemlist", "itIndex")),
                "s": Local(cursor=Cursor("write", "str", True), table=("pushed", "sIndex")),
            },
            written={"p", "it", "count"},
            single_writes={"count"},
            addressed={"trace"},
        )
        empty = LocalFacts(rows={}, written=set(), single_writes=set(), addressed=set())
        with Store(self.path) as store:
            store.save_locals("key-1", "g_utils", "G_Find", full)
            store.save_locals("key-1", "g_main", "G_InitGame", empty)

        # then the store gives back the same facts for each function
        with Store(self.path) as store:
            self.assertEqual(plain(store.load_locals("key-1", "g_utils", "G_Find")), plain(full))
            self.assertEqual(plain(store.load_locals("key-1", "g_main", "G_InitGame")), plain(empty))


class Schema(unittest.TestCase):
    def test_the_schema_names_no_project_word(self) -> None:
        # given a new store file
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "table.sqlite"
            Store(path).close()

            # when the file is read with sqlite3 alone
            db = sqlite3.connect(path)
            tables = [name for (name,) in db.execute("SELECT name FROM sqlite_master WHERE type = 'table'")]
            words = tables + [column[1] for table in tables for column in db.execute(f"PRAGMA table_info({table})")]
            db.close()

        # then no table and no column carries a word of the project, its source, or its target language
        for word in words:
            for project_word in ("trap", "swift", "oracle", "raven", "jka", "game", "entity", "clang", "bg", "codemp", "rust", "vec3", "quake"):
                self.assertNotIn(project_word, word.lower(), word)


class Recovery(unittest.TestCase):
    def setUp(self) -> None:
        self.folder = tempfile.TemporaryDirectory()
        self.path = Path(self.folder.name) / "table.sqlite"

    def tearDown(self) -> None:
        self.folder.cleanup()

    def test_a_corrupt_file_is_deleted_and_opened_again(self) -> None:
        # given a store file of random bytes
        self.path.write_bytes(os.urandom(8192))

        # when the store opens it
        err = io.StringIO()
        with contextlib.redirect_stderr(err), Store(self.path) as store:
            store.save("base", "key-1", {}, {"called": {"G_Find"}})

        # then it says so on one line, and the new file holds what the store saved
        self.assertEqual(len(err.getvalue().splitlines()), 1)
        with Store(self.path) as store:
            self.assertEqual(store.load("base", "key-1"), {"called": {"G_Find"}})

    def test_a_store_of_an_older_schema_is_made_again(self) -> None:
        # given a store whose meta holds an older schema version
        with Store(self.path) as store:
            store.save("base", "key-1", {}, {"called": {"G_Find"}})
        db = sqlite3.connect(self.path)
        with db:
            db.execute("UPDATE meta SET value = '0' WHERE name = 'schema'")
        db.close()

        # when the store opens it
        err = io.StringIO()
        with contextlib.redirect_stderr(err), Store(self.path) as store:
            loaded = store.load("base", "key-1")

        # then it says so on one line and holds no facts, and the next open says nothing
        self.assertEqual(len(err.getvalue().splitlines()), 1)
        self.assertIsNone(loaded)
        err = io.StringIO()
        with contextlib.redirect_stderr(err), Store(self.path):
            pass
        self.assertEqual(err.getvalue(), "")

    def test_a_reader_open_of_a_store_of_this_version_keeps_its_bytes(self) -> None:
        # given a store that a writer saved and closed
        with Store(self.path) as store:
            store.save("base", "key-1", {}, {"called": {"G_Find"}})
        before = self.path.read_bytes()

        # when a reader opens it, loads the facts, and closes it
        with Store(self.path, reader=True) as store:
            loaded = store.load("base", "key-1")

        # then the reader saw the facts, and the file holds the bytes it held before
        self.assertEqual(loaded, {"called": {"G_Find"}})
        self.assertEqual(self.path.read_bytes(), before)

    def test_a_rejected_write_under_a_new_key_deletes_the_rows_of_every_file_under_the_old_key(self) -> None:
        # given rejected rows of two files under the old key
        with Store(self.path) as store:
            store.save_rejected("old", "swift", "g_a", [("G_A", 3, "boom")])
            store.save_rejected("old", "swift", "g_b", [("G_B", 5, "bang")])

            # when one file is gated again under a new key
            store.save_rejected("new", "swift", "g_a", [("G_A", 4, "crash")])

            # then the table holds the rows of the new key alone
            rows = store.db.execute("SELECT file, key FROM rejected").fetchall()
        self.assertEqual(rows, [("g_a", "new")])


class Snapshot(unittest.TestCase):
    def setUp(self) -> None:
        self.folder = tempfile.TemporaryDirectory()
        self.path = Path(self.folder.name) / "table.sqlite"

    def tearDown(self) -> None:
        self.folder.cleanup()

    def test_a_load_reads_one_generation_while_a_writer_saves_another(self) -> None:
        # given a store that holds two kinds of one generation under one key
        with Store(self.path) as store:
            store.save("base", "key-1", {}, {"called": {"G_Find"}, "store_swept": {"G_Spawn"}})

        # when a second store saves the generation again under another key between the reads of the two kinds
        reader = Store(self.path)
        self.addCleanup(reader.close)
        read = reader.read

        def read_then_write(kind: str):
            value = read(kind)
            if kind == "called":
                with Store(self.path) as writer:
                    writer.save("base", "key-2", {}, {"called": {"trap_Trace"}, "store_swept": {"trap_FS_Read"}})
            return value

        with mock.patch.object(reader, "read", read_then_write):
            loaded = reader.load("base", "key-1")

        # then the load gives both kinds as the first save left them, and the next load sees the second save
        self.assertEqual(loaded, {"called": {"G_Find"}, "store_swept": {"G_Spawn"}})
        self.assertIsNone(reader.load("base", "key-1"))
        self.assertEqual(reader.load("base", "key-2"), {"called": {"trap_Trace"}, "store_swept": {"trap_FS_Read"}})

    def test_a_signature_read_sees_the_rows_of_the_key_it_checked(self) -> None:
        # given a store that holds the signature rows of one set of manifests
        row = {"file": "g_utils.c", "name": "G_Find", "kind": "function", "target": "Game", "text": "func G_Find()", "forward": None,
               "reason": None, "source": "g_utils.c:1-9", "destination": "g_utils.swift:4", "state": "ported", "peer": ""}
        with Store(self.path) as store:
            store.save_signatures("key-1", {}, [row])

        # when a second store saves other rows under another key after the key check
        reader = Store(self.path)
        self.addCleanup(reader.close)
        key = reader.key

        def key_then_write(generation: str):
            value = key(generation)
            with Store(self.path) as writer:
                writer.save_signatures("key-2", {}, [row | {"text": "func G_Find(_ from: Entity?)"}])
            return value

        with mock.patch.object(reader, "key", key_then_write):
            rows = reader.signatures("G_Find")

        # then the read gives the rows of the key it checked
        self.assertEqual(rows, [row])


class Rehash(unittest.TestCase):
    def setUp(self) -> None:
        self.folder = tempfile.TemporaryDirectory()
        self.root = Path(self.folder.name)

    def tearDown(self) -> None:
        self.folder.cleanup()

    def test_the_store_names_each_saved_file_whose_bytes_changed_or_that_is_gone(self) -> None:
        # given a generation saved with the hashes of three files, one inside the root and two outside it
        inside = self.root / "src/g_main.swift"
        inside.parent.mkdir()
        outside = tempfile.TemporaryDirectory()
        self.addCleanup(outside.cleanup)
        kept, gone = Path(outside.name) / "kept.swift", Path(outside.name) / "gone.swift"
        for path in (inside, kept, gone):
            path.write_text(f"func {path.stem}() {{}}\n")
        files = {"src/g_main.swift": digest(inside.read_bytes()), str(kept): digest(kept.read_bytes()), str(gone): digest(gone.read_bytes())}
        store = Store(self.root / "table.sqlite")
        self.addCleanup(store.close)
        store.save_signatures("key-1", files, [])
        self.assertEqual(store.rehashed("signatures", self.root), [])

        # when one file changes and another is deleted
        inside.write_text("func g_main() { level = 0 }\n")
        gone.unlink()

        # then the store names both, with no parse and no key
        self.assertEqual(store.rehashed("signatures", self.root), sorted([str(gone), "src/g_main.swift"]))


if __name__ == "__main__":
    unittest.main()
