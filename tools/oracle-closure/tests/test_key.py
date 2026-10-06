"""Seam B: the whole-input key and its two generations."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

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

    def test_a_tool_module_change_changes_both_generations(self) -> None:
        # given the keys of the input set
        before = self.compute()

        # when a listed tool module changes
        (self.root / "tool/table.py").write_text("RULE = 2\n")
        after = self.compute()

        # then both keys change
        self.assertNotEqual(after.base, before.base)
        self.assertNotEqual(after.adoption, before.adoption)


if __name__ == "__main__":
    unittest.main()
