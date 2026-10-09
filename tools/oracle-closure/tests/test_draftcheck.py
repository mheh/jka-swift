"""The compile gate keeps the hand functions of an adopted stem.

Each test aligns a hand file with the line rows of one function written by hand, so no test parses.
"""

from __future__ import annotations

import contextlib
import io
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

# The line rows of G_X, each as its seq, its statement seq, its role, its depth, and its text.
ROWS = [(0, None, "header", 0, "/// Source: oracle/codemp/game/g_x.c:4"),
        (1, None, "header", 0, "func G_X(_ ent: Int32) -> Int32 {"),
        (2, 1, "own", 1, "var total: Int32 = 0"),
        (3, 2, "own", 1, "total = ent * 2"),
        (4, 3, "own", 1, "return total"),
        (5, None, "frame", 0, "}")]
DRAFT = ["/// Source: oracle/codemp/game/g_x.c:4",
         "func G_X(_ ent: Int32) -> Int32 {",
         "    var total: Int32 = 0",
         "    total = ent * 2",
         "    return total",
         "}"]
STUB = ["/// Source: oracle/codemp/game/g_x.c:4",
        "func G_X(_ ent: Int32) -> Int32 {",
        "    // TODO: Port G_X",
        '    portMissing("G_X", source: "oracle/codemp/game/g_x.c:4")',
        "}"]


class OneBuild(unittest.TestCase):
    def test_two_stems_build_once_per_pass_and_each_defect_goes_to_its_stem(self) -> None:
        import tempfile

        import draftcheck

        class Fake(draftcheck.Stem):
            # The draft of G_X, with the compile holes the builds rejected as Port-note lines in place of their statements.
            def lines(self):
                draft = ["/// Source: oracle/codemp/game/g_x.c:4", "func G_X(_ ent: Int32) -> Int32 {"]
                keys = [None, None]
                for seq, text in ((1, "var total: Int32 = 0"), (2, "total = ent * 2"), (3, "return total")):
                    draft.append(f"    // hole {seq}" if (self.stem, "G_X", seq) in self.due else f"    {text}")
                    keys.append((self.stem, "G_X", seq))
                return draft + ["}", ""], keys + [None, None], 0, len(self.due), set()

        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            stems = []
            for name in ("g_a", "g_b"):
                (root / f"{name}.hand").write_text("\n".join(STUB) + "\n")
                stems.append(Fake(None, None, name, root / f"{name}.hand", root / f"{name}.swift"))
            builds: list[str] = []

            # given the mirror file opens with import Foundation, and the first build rejects seq 2 of g_a and seq 3 of g_b, and the second build is clean
            def make() -> str:
                builds.append("".join(s.target.read_text() for s in stems))
                if len(builds) > 1:
                    return ""
                return f"{root}/g_a.swift:5:5: error: bad a\n{root}/g_b.swift:6:5: error: bad b\n"

            passes, others = draftcheck.run(stems, make)
        self.assertEqual((passes, len(builds), others), (2, 2, []))
        self.assertEqual(set(stems[0].due), {("g_a", "G_X", 2)})
        self.assertEqual(set(stems[1].due), {("g_b", "G_X", 3)})
        self.assertEqual([s.defects for s in stems], [[], []])
        self.assertEqual([s.passes for s in stems], [2, 2])


class Kept(unittest.TestCase):
    def kept(self, hand: list[str]) -> set[int]:
        from draftcheck import kept

        with contextlib.redirect_stderr(io.StringIO()):
            return kept(hand, [("G_X", ROWS)])

    def test_a_stub_body_and_a_same_body_are_not_kept(self) -> None:
        self.assertEqual(self.kept(STUB), set())
        self.assertEqual(self.kept(DRAFT), set())

    def test_an_edited_body_a_hand_body_and_a_rewritten_body_are_kept(self) -> None:
        edited = DRAFT[:3] + ["    total = ent * 3"] + DRAFT[4:]
        inserted = DRAFT[:4] + ["    total += 1"] + DRAFT[4:]
        rewritten = DRAFT[:2] + ["    let a = ent", "    let b = a << 1", "    let c = b | 0", "    return c", "}"]
        for hand in (edited, inserted, rewritten):
            self.assertEqual(self.kept(hand), {4})

    def test_the_splice_keeps_a_kept_function_and_replaces_the_rest(self) -> None:
        from draftcheck import splice

        edited = DRAFT[:3] + ["    total = ent * 3"] + DRAFT[4:]
        out, origins, replaced = splice(edited, DRAFT, {4})
        self.assertEqual((out, replaced), (edited, 0))
        self.assertTrue(all(origin is None for origin in origins))
        out, _, replaced = splice(STUB, DRAFT, set())
        self.assertEqual((out, replaced), (DRAFT, 1))


    def test_a_body_with_the_hash_of_its_splice_row_is_a_draft_and_not_kept(self) -> None:
        from draftcheck import kept, spliced_rows

        # given an earlier draft the gate spliced over the stub, which reads as edited against the newer rows
        older = DRAFT[:3] + ["    total = ent * 3"] + DRAFT[4:]
        splices = dict(spliced_rows(older, STUB, set()))
        self.assertEqual(list(splices), ["G_X"])

        # then the body with the row's hash is spliced over, and a body a person changed after it stays
        with contextlib.redirect_stderr(io.StringIO()):
            self.assertEqual(kept(older, [("G_X", ROWS)], splices), set())
            touched = older[:4] + ["    total += 1"] + older[4:]
            self.assertEqual(kept(touched, [("G_X", ROWS)], splices), {4})

    def test_a_store_keeps_one_splice_row_per_function(self) -> None:
        import tempfile

        from store import Store

        with tempfile.TemporaryDirectory() as tmp:
            store = Store(Path(tmp) / "table.sqlite")
            store.save_splices("Sources/X/g_x.swift", [("G_X", "a"), ("G_Y", "b")])
            store.save_splices("Sources/X/g_x.swift", [("G_X", "c")])
            self.assertEqual(store.splices("Sources/X/g_x.swift"), {"G_X": "c", "G_Y": "b"})
            store.close()

if __name__ == "__main__":
    unittest.main()
