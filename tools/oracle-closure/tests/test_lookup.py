"""Seam D: lookup.py sig and fn print the same text from the store as from the manifests.

The test writes its own manifests and its own store in a temporary folder, so it needs no manifest.py run.
"""

from __future__ import annotations

import contextlib
import io
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import lookup  # noqa: E402
from manifest import Manifest  # noqa: E402
from store import Store  # noqa: E402

# A bg function, a game function with a forward, a function with a signature marker and no jka-rust match,
# a static function with no Swift line, and a file-scope variable.
FUNCTIONS = {
    "bg_pmove.c": [
        {"file": "bg_pmove.c", "name": "Pmove", "kind": "function", "target": "JKAMP_BG", "text": "public func Pmove(_ pmove: JKAMP.Pmove)",
         "forward": None, "reason": None, "source": "oracle/codemp/game/bg_pmove.c:11167-11215", "destination": "JKAMP_BG/bg_pmove.swift:9342",
         "state": "ported", "peer": "crates/mp/bg/src/bg_pmove.rs:10449-10499"},
    ],
    "g_combat.c": [
        {"file": "g_combat.c", "name": "G_Damage", "kind": "function", "target": "JKAMP_GameLogic",
         "text": "func G_Damage(_ targ: Entity, _ dir: inout JKAShared.vec3_t?)", "forward": "func G_Damage(_ targ: Entity, _ dir: inout JKAShared.vec3_t)",
         "reason": None, "source": "oracle/codemp/game/g_combat.c:4577-5715", "destination": "JKAMP_GameLogic/g_combat.swift:3650",
         "state": "ported", "peer": "crates/mp/game/src/g_combat.rs:4823-5888"},
        {"file": "g_combat.c", "name": "G_LocationDamage", "kind": "static function", "target": "JKAMP_GameLogic", "text": "private func G_LocationDamage()",
         "forward": None, "reason": None, "source": "oracle/codemp/game/g_combat.c:4100-4120", "destination": "", "state": "marker", "peer": ""},
    ],
    "q_math.c": [
        {"file": "q_math.c", "name": "MatrixMultiply", "kind": "function", "target": "JKAShared", "text": "public func MatrixMultiply() -> Never",
         "forward": None, "reason": "No table row for `float[3][3] in1`.", "source": "oracle/codemp/game/q_math.c:1293-1312",
         "destination": "JKAShared/q_math.swift:963", "state": "ported", "peer": ""},
    ],
}
VARIABLES = {
    "bg_pmove.c": [
        {"file": "bg_pmove.c", "name": "pm_stopspeed", "kind": "variable", "target": "JKAMP_BG", "text": "let pm_stopspeed: Float = 100",
         "forward": None, "reason": None, "source": "oracle/codemp/game/bg_pmove.c:41", "destination": "", "state": "let", "peer": ""},
    ],
}
NAMES = ("Pmove", "G_Damage", "G_LocationDamage", "MatrixMultiply", "pm_stopspeed")
# A variable row has no Swift line and no jka-rust cell, so `fn` asks about the functions alone.
FUNCTION_NAMES = NAMES[:-1]


class Signatures(unittest.TestCase):
    def setUp(self) -> None:
        folder = tempfile.TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        root = Path(folder.name)
        manifests = root / "manifest"
        manifests.mkdir()
        self.store = root / "table.sqlite"
        for patch in (mock.patch.object(lookup, "MANIFEST", manifests), mock.patch.object(lookup, "STORE", self.store)):
            patch.start()
            self.addCleanup(patch.stop)

        # given manifests that print the rows as manifest.py prints them, and a store that holds the same rows under their key
        rows = []
        for file in sorted(set(FUNCTIONS) | set(VARIABLES)):
            lines = [Manifest.function_row(row) for row in FUNCTIONS.get(file, [])]
            lines += [Manifest.variable_row(row) for row in VARIABLES.get(file, [])]
            (manifests / f"{Path(file).stem}.md").write_text("\n".join(lines) + "\n")
            rows += FUNCTIONS.get(file, []) + VARIABLES.get(file, [])
        with Store(self.store) as store:
            store.save_signatures(lookup.manifest_key(), rows)

    def printed(self, question, name: str, source: str) -> tuple[int, str]:
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            status = question(name, source=source)
        return status, out.getvalue()

    def test_sig_prints_the_same_text_from_the_store_as_from_the_manifests(self) -> None:
        for name in NAMES:
            # given the text the manifests give
            status, expected = self.printed(lookup.signature, name, "manifest")
            self.assertEqual(status, 0, name)
            self.assertTrue(expected.strip(), name)

            # then the store gives the same text
            self.assertEqual(self.printed(lookup.signature, name, "store"), (0, expected), name)

    def test_fn_prints_the_same_text_from_the_store_as_from_the_manifests(self) -> None:
        for name in FUNCTION_NAMES:
            # given the text the manifests give
            status, expected = self.printed(lookup.function, name, "manifest")
            self.assertEqual(status, 0, name)

            # then the store gives the same text
            self.assertEqual(self.printed(lookup.function, name, "store"), (0, expected), name)

    def test_the_store_answers_nothing_once_a_manifest_changes(self) -> None:
        # when a manifest on disk changes after the store saved its rows
        path = lookup.MANIFEST / "bg_pmove.md"
        path.write_text(path.read_text() + "\n")

        # then the store holds no rows for the manifests on disk, and a question with no source reads the manifests
        self.assertIsNone(lookup.answers("Pmove", "store"))
        self.assertEqual(self.printed(lookup.signature, "Pmove", None), self.printed(lookup.signature, "Pmove", "manifest"))


if __name__ == "__main__":
    unittest.main()
