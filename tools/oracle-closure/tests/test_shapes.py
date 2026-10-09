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


if __name__ == "__main__":
    unittest.main()
