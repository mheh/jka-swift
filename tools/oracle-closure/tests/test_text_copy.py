"""Raven's `strcpy( token, "<NULL>" )` into the token of a parse call, row 1 of the walk 10 ledger, on small C functions parsed in the test."""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import clang.cindex as ci  # noqa: E402
from clang.cindex import CursorKind  # noqa: E402

from draft_classification import Classification  # noqa: E402
from draft_expressions import Expressions  # noqa: E402

PRELUDE = "char *COM_ParseExt(const char **p, int b);\nchar *strcpy(char *d, const char *s);\nstruct rec { char name[8]; };\n"


class Probe(Classification):
    binary_op = Expressions.binary_op
    unwrap = Expressions.unwrap
    strip = Expressions.strip
    unary_parts = Expressions.unary_parts

    def callee_returns(self, name, default=None):
        return {"COM_ParseExt": "String"}.get(name, default)


class TextCopy(unittest.TestCase):
    def probe(self, body: str, texts: set[str], optionals: set[str] = frozenset()):
        """The text copy rule over the one `strcpy` call of `f`, with the text locals the test names."""
        text = PRELUDE + body
        unit = ci.Index.create().parse("probe.c", unsaved_files=[("probe.c", text)])
        self.assertEqual([d.spelling for d in unit.diagnostics if d.severity >= 3], [])
        fn = [c for c in unit.cursor.get_children() if c.kind == CursorKind.FUNCTION_DECL and c.spelling == "f"][0]
        call = [c for c in fn.walk_preorder() if c.kind == CursorKind.CALL_EXPR and c.spelling == "strcpy"][0]
        rule = Probe()
        rule.fn = type("Fn", (), {"cur": fn})()
        rule.bytes = text.encode()
        rule.text_locals = set(texts)
        rule.optional_texts = set(optionals)
        return rule.text_copy(call)

    def test_a_copy_into_the_token_of_a_parse_call_is_a_new_value_of_the_local(self) -> None:
        # given the UI_ParseInfos shape, a token that holds the text of COM_ParseExt and takes Raven's "<NULL>"
        shape = 'void f(const char *buf) { char *token; token = COM_ParseExt(&buf, 0); if (!token[0]) { strcpy(token, "<NULL>"); } }'
        found = self.probe(shape, {"token"})

        # then the rule gives the local and the literal
        self.assertIsNotNone(found)
        self.assertEqual([found[0].spelling, found[1].kind], ["token", CursorKind.STRING_LITERAL])

    def test_a_local_that_also_points_at_a_field_keeps_the_call(self) -> None:
        # given a text local that one store points at a `char name[8]` field, so the copy writes the field
        shape = ('void f(const char *buf, struct rec *r) { char *token; token = COM_ParseExt(&buf, 0); token = r->name; '
                 'strcpy(token, "<NULL>"); }')

        # then the rule gives nothing
        self.assertIsNone(self.probe(shape, {"token"}))

    def test_an_optional_text_or_a_local_whose_address_a_call_takes_keeps_the_call(self) -> None:
        # given the same token as a String?, and the same token handed by address to a call
        shape = 'void f(const char *buf) { char *token; token = COM_ParseExt(&buf, 0); strcpy(token, "<NULL>"); }'
        addressed = 'void g(char **t);\nvoid f(const char *buf) { char *token; token = COM_ParseExt(&buf, 0); g(&token); strcpy(token, "<NULL>"); }'

        # then the rule gives nothing for either
        self.assertIsNone(self.probe(shape, {"token"}, {"token"}))
        self.assertIsNone(self.probe(addressed, {"token"}))


if __name__ == "__main__":
    unittest.main()
