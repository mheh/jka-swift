"""The clash by case of `extract.py`: two names of one folder that are equal when lowercased take their lines in their file names."""

from __future__ import annotations

import sys
import unittest
from pathlib import Path
from types import SimpleNamespace

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))


class CaseClash(unittest.TestCase):
    @staticmethod
    def decl(name: str, line: int, reldir: str = "code/ui/ui_public", kind: str = "typedef"):
        import extract

        d = extract.Decl.__new__(extract.Decl)
        d.kind, d.name, d.reldir, d.forward_only, d.clash = kind, name, reldir, False, False
        d.start = SimpleNamespace(line=line)
        return d

    def test_two_names_equal_when_lowercased_take_their_lines(self) -> None:
        # given `uiimport_t` and `uiImport_t` of code/ui/ui_public.h, and a third name of the folder
        import extract

        decls = [self.decl("uiimport_t", 11), self.decl("uiImport_t", 151), self.decl("uiMenuCommand_t", 253)]

        # when the clash rule runs
        extract.mark_case_clashes(decls)

        # then each name of the clash takes its line, and the other name keeps its file
        self.assertEqual([d.filename for d in decls], [
            "code/ui/ui_public/uiimport_t_11.h",
            "code/ui/ui_public/uiImport_t_151.h",
            "code/ui/ui_public/uiMenuCommand_t.h",
        ])

    def test_two_names_of_two_folders_do_not_clash(self) -> None:
        # given two names equal when lowercased in two folders
        import extract

        decls = [self.decl("uiimport_t", 11), self.decl("uiImport_t", 151, reldir="codemp/ui/ui_public")]

        # when the clash rule runs
        extract.mark_case_clashes(decls)

        # then each name keeps its file
        self.assertEqual([d.filename for d in decls], ["code/ui/ui_public/uiimport_t.h", "codemp/ui/ui_public/uiImport_t.h"])


if __name__ == "__main__":
    unittest.main()
