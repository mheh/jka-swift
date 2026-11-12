"""The ui tables of tables.py, in the form of the cgame tables."""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import tables  # noqa: E402


class UiTables(unittest.TestCase):
    def test_the_ui_file_holds_the_five_tables_in_the_ui_target(self) -> None:
        # given the output of the ui
        output = next(o for o in tables.OUTPUTS if o.name == "ui_tables.c")
        text = tables.emit(output).decode("latin-1")

        # then it compiles in the ui target, and each static table takes the tool's declaration line before Raven's bytes
        self.assertEqual((output.target, output.header), ("CJKAMP_UI", "ui_tables.h"))
        self.assertEqual(sum(1 for p in output.pieces if p.source and p.table), 5)
        self.assertIn("datpadmovedata_t datapadMoveData[6][16] =\n// Source: oracle/codemp/ui/ui_main.c:415-523\n", text)
        self.assertIn("serverFilter_t serverFilters[2] = {\n// Source: oracle/codemp/ui/ui_main.c:897-899\n", text)
        self.assertIn("bind_t g_bindings[] =\n// Source: oracle/codemp/ui/ui_shared.c:5191-5292\n", text)


if __name__ == "__main__":
    unittest.main()
