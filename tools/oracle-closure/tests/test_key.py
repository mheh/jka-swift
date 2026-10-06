"""Seam B: the whole-input key and its two generations."""

from __future__ import annotations

import contextlib
import io
import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest import mock

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

from store import Store, keys  # noqa: E402


class Key(unittest.TestCase):
    def setUp(self) -> None:
        self.folder = tempfile.TemporaryDirectory()
        self.root = Path(self.folder.name)
        for rel, text in {
            "src/g_main.c": "int level;\n",
            "src/g_local.h": "#define MAX 4\n",
            "tool/table.py": "RULE = 1\n",
            "out/g_main.swift": "// Generated stub\nfunc G_InitGame() {}\n",
            "out/bg_misc.swift": "// Adopted by hand\nfunc BG_Misc() {}\n",
        }.items():
            (self.root / rel).parent.mkdir(parents=True, exist_ok=True)
            (self.root / rel).write_text(text)

    def tearDown(self) -> None:
        self.folder.cleanup()

    def compute(self):
        return keys(
            inputs=[self.root / "src/g_main.c", self.root / "src/g_local.h"],
            tools=[self.root / "tool/table.py"],
            stubs=[self.root / "out/g_main.swift", self.root / "out/bg_misc.swift"],
            root=self.root,
        )

    def test_the_key_is_stable_over_two_computations(self) -> None:
        # given one fixed input set, computed twice
        first, second = self.compute(), self.compute()

        # then both generations have the same key
        self.assertEqual(first.base, second.base)
        self.assertEqual(first.adoption, second.adoption)

    def test_a_one_byte_change_changes_the_key_and_the_store_names_the_file(self) -> None:
        # given a store that holds the facts of the input set
        before = self.compute()
        store = Store(self.root / "table.sqlite")
        self.addCleanup(store.close)
        store.save("base", before.base, before.files, {"called": {"G_InitGame"}})

        # when one byte of one input file changes
        (self.root / "src/g_local.h").write_text("#define MAX 5\n")
        after = self.compute()

        # then the key changes, the store holds nothing under it, and the store names the file
        self.assertNotEqual(after.base, before.base)
        self.assertIsNone(store.load("base", after.base))
        self.assertEqual(store.changed("base", after.files), ["src/g_local.h"])

    def test_a_stub_first_line_changes_the_adoption_generation_alone(self) -> None:
        # given the keys of the input set
        before = self.compute()

        # when a body line of a stub changes, the keys stay
        (self.root / "out/g_main.swift").write_text("// Generated stub\nfunc G_InitGame() { level = 0 }\n")
        body = self.compute()
        self.assertEqual((body.base, body.adoption), (before.base, before.adoption))

        # when the first line of a stub changes, the adoption key changes and the base key stays
        (self.root / "out/g_main.swift").write_text("// Adopted by hand\nfunc G_InitGame() { level = 0 }\n")
        adopted = self.compute()
        self.assertEqual(adopted.base, before.base)
        self.assertNotEqual(adopted.adoption, before.adoption)

    def test_a_deleted_input_file_changes_the_key_and_the_store_names_the_file(self) -> None:
        # given a store that holds the facts of the input set
        before = self.compute()
        store = Store(self.root / "table.sqlite")
        self.addCleanup(store.close)
        store.save("base", before.base, before.files, {"called": {"G_InitGame"}})

        # when one input file is deleted
        (self.root / "src/g_local.h").unlink()
        after = self.compute()

        # then the key changes, the store holds nothing under it, and the store names the file
        self.assertNotEqual(after.base, before.base)
        self.assertIsNone(store.load("base", after.base))
        self.assertEqual(store.changed("base", after.files), ["src/g_local.h"])

    def test_a_tool_module_change_changes_both_generations(self) -> None:
        # given the keys of the input set
        before = self.compute()

        # when a listed tool module changes
        (self.root / "tool/table.py").write_text("RULE = 2\n")
        after = self.compute()

        # then both keys change
        self.assertNotEqual(after.base, before.base)
        self.assertNotEqual(after.adoption, before.adoption)

    def test_a_named_value_is_an_input_of_the_base_key(self) -> None:
        # given a store that holds the facts of the input set with one named value
        def compute(views: str):
            return keys(inputs=[self.root / "src/g_main.c"], tools=[], stubs=[], root=self.root, values={"(the view set)": views})

        before = compute("Entity\nPlayerState")
        store = Store(self.root / "table.sqlite")
        self.addCleanup(store.close)
        store.save("base", before.base, before.files, {"called": {"G_InitGame"}})

        # when the value changes
        after = compute("Entity")

        # then the base key changes and the store names the value
        self.assertNotEqual(after.base, before.base)
        self.assertEqual(store.changed("base", after.files), ["(the view set)"])


class Unit:
    """A parse unit with no file on disk and no include, so the key of a Table reads the declarations alone."""

    spelling = "(unity)"

    def get_includes(self) -> list:
        return []


class DeclarationKey(unittest.TestCase):
    """The base key covers the lines of the generated declarations that the views read, and no other line of them."""

    def setUp(self) -> None:
        import table

        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        self.root = Path(self.folder.name)
        self.declarations = self.root / "JKAMP/Generated/anims.swift"
        self.callbacks = self.root / "JKAMP_Game/Generated/Views/Callbacks.swift"
        self.declarations.parent.mkdir(parents=True)
        self.callbacks.parent.mkdir(parents=True)
        self.declarations.write_text("// Generated\n\n/// Source: anims.h:6\npublic typealias animNumber_t = Int32\n"
                                     "public let FACE_TALK0: animNumber_t = Int32(truncatingIfNeeded: CJKAMP.FACE_TALK0.rawValue)\n")
        self.callbacks.write_text("// Generated\npublic typealias EntityPain = @convention(c) (OpaquePointer?, OpaquePointer?, Int32) -> Void\n")
        for patch in (mock.patch.object(table, "OUTPUT", self.root), mock.patch.object(table, "HERE", self.root)):
            patch.start()
            self.addCleanup(patch.stop)
        self.table = table.Table.__new__(table.Table)
        self.table.parse = SimpleNamespace(game=Unit(), cgame=Unit(), headers=Unit())
        self.table.views = SimpleNamespace(views={})

    def edit(self, path: Path, old: str, new: str) -> None:
        path.write_text(path.read_text().replace(old, new))

    def test_a_change_to_a_line_the_views_do_not_read_keeps_the_key(self) -> None:
        # given the keys of the declarations
        before = self.table.input_keys()

        # when a comment, a value, and a type annotation change
        self.edit(self.declarations, "anims.h:6", "anims.h:7")
        self.edit(self.declarations, "Int32(truncatingIfNeeded: CJKAMP.FACE_TALK0.rawValue)", "0")
        self.edit(self.declarations, "FACE_TALK0: animNumber_t", "FACE_TALK0: Int32")
        after = self.table.input_keys()

        # then both keys stay
        self.assertEqual((after.base, after.adoption), (before.base, before.adoption))

    def test_a_changed_name_changes_the_key_and_the_store_names_the_file(self) -> None:
        # given a store that holds the facts under the keys of the declarations
        before = self.table.input_keys()
        store = Store(self.root / "table.sqlite")
        self.addCleanup(store.close)
        store.save("base", before.base, before.files, {"called": {"G_InitGame"}})

        # when a declared name changes
        self.edit(self.declarations, "FACE_TALK0", "FACE_TALK9")
        after = self.table.input_keys()

        # then the base key changes and the store names the file
        self.assertNotEqual(after.base, before.base)
        self.assertEqual(store.changed("base", after.files), [str(self.declarations.resolve())])

    def test_a_deleted_declaration_file_makes_the_base_facts_stale_and_the_table_names_it(self) -> None:
        import table

        # given a store that holds the base facts under the keys of the declarations
        before = self.table.input_keys()
        self.table.store = Store(self.root / "table.sqlite")
        self.addCleanup(self.table.store.close)
        self.table.store.save("base", before.base, before.files, {"called": {"G_InitGame"}})

        # when a declaration file the key covered is deleted
        self.callbacks.unlink()
        after = self.table.input_keys()

        # then the store holds no base facts under the new key, and the stale line names the file
        self.assertIsNone(self.table.store.load("base", after.base))
        err = io.StringIO()
        with contextlib.redirect_stderr(err), mock.patch.object(table, "REBUILD", False):
            self.table.stale("base", after.files)
        self.assertEqual(err.getvalue(), f"table.py: the base facts are stale, 1 files changed: {self.callbacks.resolve()}\n")

    def test_a_changed_callback_signature_changes_the_key(self) -> None:
        # given the keys of the declarations
        before = self.table.input_keys()

        # when the C signature of a callback typealias changes
        self.edit(self.callbacks, "Int32) -> Void", "Int32) -> Int32")

        # then the base key changes
        self.assertNotEqual(self.table.input_keys().base, before.base)


if __name__ == "__main__":
    unittest.main()
