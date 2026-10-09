"""The partition rule of merge.py for a tree macro that a shared .c body reads."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import merge  # noqa: E402
from merge import Header, Placed, partition_shared  # noqa: E402


def constants(tree: str, macros: list[tuple[str, str]]) -> Placed:
    rel = f"{tree}/game/q_shared/constants.h"
    header = Header(module=f"{tree}-game", tree=tree, rel=rel, identity="game/q_shared/constants.h",
                    macros=[(n, f"// Source: {rel}", t) for n, t in macros])
    return Placed(identity=header.identity, target=merge.TREE_TARGET[tree], header=header)


class TreeMacroOfASharedBody(unittest.TestCase):
    def setUp(self) -> None:
        self.folder = tempfile.TemporaryDirectory()
        body = Path(self.folder.name) / "q_shared.c"
        body.write_text("char big[BIG_INFO_STRING];\nint f(int x) { return SQR(x); }\n")
        self.patch = mock.patch.object(merge, "SHARED_BODIES", [body])
        self.patch.start()

    def tearDown(self) -> None:
        self.patch.stop()
        self.folder.cleanup()

    def test_only_an_mp_macro_the_body_reads_is_shared(self) -> None:
        # given an MP constants file with a macro SP lacks, one the body never reads, and a function-like macro
        mp = {"game/q_shared/constants.h": constants("mp", [
            ("MAX_INFO_STRING", "#define MAX_INFO_STRING 1024"),
            ("BIG_INFO_STRING", "#define BIG_INFO_STRING 8192"),
            ("UNREAD", "#define UNREAD 1"),
            ("SQR", "#define SQR(x) ((x)*(x))"),
        ])}
        sp = {"game/q_shared/constants.h": constants("sp", [("MAX_INFO_STRING", "#define MAX_INFO_STRING 1024")])}

        # when the partition runs
        _, shared_macros = partition_shared(mp, sp)

        # then the read object-like macro joins the shared names, and the other two stay in the tree
        self.assertEqual(shared_macros["game/q_shared/constants.h"], {"MAX_INFO_STRING", "BIG_INFO_STRING"})


if __name__ == "__main__":
    unittest.main()
