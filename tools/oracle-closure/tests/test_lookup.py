"""Seam D: lookup.py sig and fn print the same text from the store as from the manifests.

The fast tests write their own manifests, Swift stubs, and store in a temporary folder, so they need no generator run.
The slow test writes the signature rows of the real parse through the skeleton, so it runs only with SLOW=1 in the environment.
"""

from __future__ import annotations

import contextlib
import io
import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import lookup  # noqa: E402
from manifest import Manifest  # noqa: E402
from store import Store, combined, digest  # noqa: E402

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
        self.stubs = [root / "JKAMP_BG/bg_pmove.swift", root / "JKAMP_GameLogic/g_combat.swift"]
        for stub in self.stubs:
            stub.parent.mkdir()
            stub.write_text(f"// Adopted\nfunc {stub.stem}() {{}}\n")
        for patch in (mock.patch.object(lookup, "MANIFEST", manifests), mock.patch.object(lookup, "STORE", self.store)):
            patch.start()
            self.addCleanup(patch.stop)

        # given manifests that print the rows as manifest.py prints them,
        # and a store that holds the same rows with the hash of each Swift stub they were read from
        rows = []
        for file in sorted(set(FUNCTIONS) | set(VARIABLES)):
            lines = [Manifest.function_row(row) for row in FUNCTIONS.get(file, [])]
            lines += [Manifest.variable_row(row) for row in VARIABLES.get(file, [])]
            (manifests / f"{Path(file).stem}.md").write_text("\n".join(lines) + "\n")
            rows += FUNCTIONS.get(file, []) + VARIABLES.get(file, [])
        files = {str(stub): digest(stub.read_bytes()) for stub in self.stubs}
        with Store(self.store) as store:
            store.save_signatures(combined(files, "input-key-1"), files, rows)

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

    def test_a_changed_swift_stub_makes_the_store_stale_and_lookup_names_the_file(self) -> None:
        # when a Swift stub changes after the store saved its rows
        self.stubs[1].write_text(self.stubs[1].read_text() + "func G_Hand() {}\n")

        # then the store answers nothing, and standard error names the stub and the generator that writes the rows again
        err = io.StringIO()
        with contextlib.redirect_stderr(err):
            self.assertIsNone(lookup.answers("Pmove", "store"))
        self.assertIn(str(self.stubs[1]), err.getvalue())
        self.assertNotIn(str(self.stubs[0]), err.getvalue())
        self.assertIn("skeleton.py", err.getvalue())

        # and a question with no source reads the manifests
        with contextlib.redirect_stderr(io.StringIO()):
            self.assertEqual(self.printed(lookup.signature, "Pmove", None), self.printed(lookup.signature, "Pmove", "manifest"))

    def test_a_deleted_swift_stub_makes_the_store_stale(self) -> None:
        # when a Swift stub the rows were read from is deleted
        self.stubs[0].unlink()

        # then the store answers nothing, and standard error names the stub
        err = io.StringIO()
        with contextlib.redirect_stderr(err):
            self.assertIsNone(lookup.answers("Pmove", "store"))
        self.assertIn(str(self.stubs[0]), err.getvalue())

    def test_a_store_with_no_signatures_rows_warns_and_the_manifests_answer(self) -> None:
        # given a store that holds no signatures rows
        self.store.unlink()
        with Store(self.store):
            pass

        # when a question reads the store first
        err = io.StringIO()
        with contextlib.redirect_stderr(err):
            status, printed = self.printed(lookup.signature, "Pmove", None)

        # then standard error says the manifests answer, and the answer is the manifest text
        self.assertIn("the store holds no signatures rows", err.getvalue())
        self.assertIn("manifests", err.getvalue())
        self.assertEqual((status, printed), self.printed(lookup.signature, "Pmove", "manifest"))


@unittest.skipUnless(os.environ.get("SLOW") == "1", "slow: one parse and one warm sweep of the real tree, run with SLOW=1")
class SkeletonRows(unittest.TestCase):
    def test_the_skeleton_writes_rows_that_lookup_prints_as_the_manifests_print_them(self) -> None:
        import closure as C
        from skeleton import stub_path
        from store import named

        folder = tempfile.TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        root = Path(folder.name)
        manifests = root / "manifest"
        manifests.mkdir()
        for patch in (mock.patch.object(lookup, "MANIFEST", manifests), mock.patch.object(lookup, "STORE", root / "table.sqlite")):
            patch.start()
            self.addCleanup(patch.stop)

        # given the manifests of three files, and the signature rows the skeleton writes into an empty store
        manifest = Manifest(C.Parse())
        for stem in ("bg_pmove", "g_combat", "q_math"):
            (manifests / f"{stem}.md").write_text("\n".join(manifest.file(stem)) + "\n")
        manifest.skeleton.save_signatures(lookup.STORE)

        # then the generation stands under the input key and the hash of every stub the rows read
        stems = sorted(set(manifest.skeleton.files) | set(manifest.skeleton.variables))
        with Store(lookup.STORE) as store:
            files = dict(store.db.execute("SELECT path, hash FROM files WHERE generation = 'signatures'").fetchall())
            self.assertEqual(set(files), {named(stub_path(stem), C.REPO) for stem in stems})
            self.assertEqual(store.key("signatures"), combined(files, manifest.skeleton.table.keys.adoption))

        # and lookup prints the same text from the store as from the manifests
        for name in ("Pmove", "G_Damage", "MatrixMultiply", "pm_stopspeed"):
            expected = Signatures.printed(self, lookup.signature, name, "manifest")
            self.assertEqual(expected[0], 0, name)
            self.assertEqual(Signatures.printed(self, lookup.signature, name, "store"), expected, name)


if __name__ == "__main__":
    unittest.main()
