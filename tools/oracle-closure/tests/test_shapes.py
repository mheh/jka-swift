"""The shape rules of the drafter, each shown on a function of the real parse that holds the shape.

This test drafts functions of the real parse, so it runs only with SLOW=1 in the environment.
The test reads a copy of the working store in a temporary folder, and the working store stays as it is.
"""

from __future__ import annotations

import os
import sqlite3
import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

@unittest.skipUnless(os.environ.get("SLOW") == "1", "slow: one parse and the drafts of the real tree, run with SLOW=1")
class Shapes(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        import closure as C
        import table
        from bodies import Drafter, Registry
        from skeleton import Skeleton

        cls.folder = tempfile.TemporaryDirectory()
        store = Path(cls.folder.name) / "table.sqlite"
        if table.STORE.exists():
            with sqlite3.connect(table.STORE) as source, sqlite3.connect(store) as copy:
                source.backup(copy)
        cls.sk = Skeleton(C.Parse(), path=store)
        cls.drafter = Drafter(cls.sk, Registry())

    @classmethod
    def tearDownClass(cls) -> None:
        cls.sk.table.store.close()
        cls.folder.cleanup()

    def draft(self, name: str) -> list[str]:
        """The stripped lines of the draft of the named function."""
        return [line.strip() for line in self.drafter.draft(self.sk.by_name[name])]

    def test_a_stepped_buffer_parameter_walks_a_write_cursor_declared_at_the_head(self) -> None:
        # given COM_SkipPath, which steps and reads its `char *pathname` parameter
        lines = self.draft("COM_SkipPath")

        # then the index stands at the head, and the reads and the step go through it
        self.assertIn("var pathnameIndex: Int32 = 0", lines)
        self.assertIn("while pathname[pathnameIndex] != 0 {", lines)
        self.assertIn("pathnameIndex += 1", lines)

        # and a call before the first step takes the buffer itself
        self.assertIn("if strlen(s) >= MAX_INFO_STRING {", self.draft("Info_RemoveKey"))

    def test_an_output_text_and_a_string_local_read_as_text_and_as_bytes(self) -> None:
        # given COM_ParseString, which tests `s[0]` on its `char **` output, and SkipBracedSection, which reads `token[1]`
        # then the output is the String itself, and the local reads its bytes
        self.assertIn("if s.isEmpty {", self.draft("COM_ParseString"))
        self.assertIn("if CharBuf(token)[1] == 0 {", self.draft("SkipBracedSection"))

    def test_a_return_in_a_void_function_drops_the_value(self) -> None:
        # given Q_strlwr, which Raven writes as `return s1` and the table makes void
        lines = self.draft("Q_strlwr")

        # then the return carries no value
        self.assertIn("return", lines)
        self.assertNotIn("return s1", lines)

    def test_a_simd_index_and_a_narrow_local_convert_to_the_swift_type(self) -> None:
        # given COM_ParseVec4, which indexes its `vec4_t` with an int, and Q_strrchr, which stores its int parameter in a char
        # then the index is an Int, and the local truncates the parameter
        self.assertIn("(c)[Int(i)] = f", self.draft("COM_ParseVec4"))
        self.assertIn("let cc: CChar = CChar(truncatingIfNeeded: c)", self.draft("Q_strrchr"))

    def test_a_shared_state_variable_names_its_home_in_the_stub(self) -> None:
        # given com_token, a file-scope state variable of the shared stem q_shared
        var = next(v for v in self.sk.variables["q_shared"] if v.name == "com_token")

        # then the rule 3 note names a file-scope variable of the stub in the `rng` shape
        note = next(line for line in self.sk.variable_entry(var) if line.startswith("// Rule 3:"))
        self.assertIn("a file-scope variable of this stub at Raven's line, the `rng` shape of q_math", note)

class Slots(unittest.TestCase):
    """The V35 and W14 rule, `slot_store_place`, on small C functions parsed in the test, so the class runs without SLOW=1."""

    PRELUDE = "struct rec { int a; };\nstruct lv { struct rec *clients; };\nstruct lv level;\nint use(int v);\nvoid g(void *v);\n"

    def probe(self, body: str, name: str = "p"):
        """The Declarations rule over one function, with the value draft and the record test replaced by plain stand-ins."""
        import clang.cindex as ci
        from clang.cindex import CursorKind, TypeKind
        from draft_classification import Classification
        from draft_declarations import Declarations
        from draft_expressions import Expressions

        class Probe(Declarations):
            operator_or_none = Classification.operator_or_none
            binary_op = Expressions.binary_op
            unwrap = Expressions.unwrap

            def expr(self, cur):
                return "x"

            def record_local(self, cur):
                kids = [v for v in cur.get_children() if v.kind == CursorKind.VAR_DECL] if cur.kind == CursorKind.DECL_STMT else []
                return kids[0] if len(kids) == 1 and kids[0].type.get_canonical().kind == TypeKind.RECORD else None

        text = self.PRELUDE + body
        unit = ci.Index.create().parse("probe.c", unsaved_files=[("probe.c", text)])
        self.assertEqual([d.spelling for d in unit.diagnostics if d.severity >= 3], [])
        fn = [c for c in unit.cursor.get_children() if c.kind == CursorKind.FUNCTION_DECL and c.spelling == "f"][0]
        local = [c for c in fn.walk_preorder() if c.kind == CursorKind.VAR_DECL and c.spelling == name][0]
        rule = Probe()
        rule.fn = type("Fn", (), {"cur": fn})()
        rule.bytes = text.encode()
        return rule, local

    def test_a_local_stored_in_straight_line_code_before_its_reads_is_let_or_var(self) -> None:
        # given the SortRanks shape, two locals with no initializer and one slot-address store each, read after both stores
        shape = "int f(int a, int b) { struct rec *ca, *cb; ca = &level.clients[a]; cb = &level.clients[b]; return use(ca->a) + use(cb->a); }"
        rule, local = self.probe(shape, "ca")

        # then one store gives let
        self.assertEqual(rule.slot_store_place(local), "let")

        # and a second store gives var
        rule, local = self.probe("int f(int a) { struct rec *p; p = &level.clients[a]; p = &level.clients[0]; return use(p->a); }")
        self.assertEqual(rule.slot_store_place(local), "var")

    def test_a_local_stored_first_in_a_loop_body_that_opens_a_scratch_record_is_closure(self) -> None:
        # given the Pickup_Powerup shape, a record local opens the loop body before the one store, and every read stays in the body
        shape = (
            "int f(int n) { struct rec *p; int i; i = 0; "
            "while (i < n) { struct rec tr; p = &level.clients[i]; if (use(p->a)) { return use(tr.a); } i++; } return 0; }"
        )
        rule, local = self.probe(shape)

        # then the local is a closure local
        self.assertEqual(rule.slot_store_place(local), "closure")

    def test_a_read_before_the_first_store_leaves_the_local_optional(self) -> None:
        # given a read that stands before the first store
        rule, local = self.probe("int f(int a) { struct rec *p; int x; x = use(p->a); p = &level.clients[a]; return x; }")

        # then the local stays optional
        self.assertIsNone(rule.slot_store_place(local))

        # and so does a local that reads itself in the right side of its first store
        rule, local = self.probe("int f(int a) { struct rec *p; p = &level.clients[p->a]; return use(p->a); }")
        self.assertIsNone(rule.slot_store_place(local))

    def test_a_stacked_implicit_cast_over_a_read_ends_the_walk_up_at_the_call(self) -> None:
        # given a read under two implicit casts of one extent, the argument of a call
        rule, local = self.probe("int f(int a) { struct rec *p; p = &level.clients[a]; g(p); return 0; }")
        parents, refs = rule.slot_refs(local)
        read = refs[-1]
        self.assertEqual(parents[read].kind.name, "UNEXPOSED_EXPR")
        self.assertEqual(parents[parents[read]].kind.name, "UNEXPOSED_EXPR")

        # then the walk up skips both casts and stops at the call, with the outer cast as the child
        up, child = rule.slot_parent(parents, read)
        self.assertEqual(up.kind.name, "CALL_EXPR")
        self.assertEqual(child, parents[parents[read]])

        # and the store before the call gives let
        self.assertEqual(rule.slot_store_place(local), "let")

if __name__ == "__main__":
    unittest.main()
