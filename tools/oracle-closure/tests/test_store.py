"""Seam A: a fact the store saves comes back from the store equal to the original."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

from store import Store  # noqa: E402


class RoundTrip(unittest.TestCase):
    def setUp(self) -> None:
        self.folder = tempfile.TemporaryDirectory()
        self.path = Path(self.folder.name) / "table.sqlite"

    def tearDown(self) -> None:
        self.folder.cleanup()

    def round_trip(self, generation: str, facts: dict) -> dict | None:
        Store(self.path).save(generation, "key-1", {"codemp/game/g_main.c": "aa11"}, facts)
        return Store(self.path).load(generation, "key-1")

    def test_parameter_facts(self) -> None:
        # given every fact kind that names a parameter of a function
        facts = {
            "nullable": {("G_Damage", "inflictor"), ("trap_Trace", "mins")},
            "hopped": {("G_RadiusDamage", "ignore")},
            "readonly_text": {("G_Find", "match")},
            "indexed_params": {("BG_AnimLength", "animations")},
            "array_handoffs": {("G_RadiusList", "ent_list")},
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


if __name__ == "__main__":
    unittest.main()
