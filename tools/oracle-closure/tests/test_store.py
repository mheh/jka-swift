"""Seam A: a fact the store saves comes back from the store equal to the original."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

from store import Store  # noqa: E402
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

    def test_trap_overloads(self) -> None:
        # given the trap parameters a caller fills with a buffer and the ones a caller hands a text
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
        Store(self.path).save_locals("key-1", "g_utils", "G_Find", full)
        Store(self.path).save_locals("key-1", "g_main", "G_InitGame", empty)

        # then the store gives back the same facts for each function
        store = Store(self.path)
        self.assertEqual(plain(store.load_locals("key-1", "g_utils", "G_Find")), plain(full))
        self.assertEqual(plain(store.load_locals("key-1", "g_main", "G_InitGame")), plain(empty))


if __name__ == "__main__":
    unittest.main()
