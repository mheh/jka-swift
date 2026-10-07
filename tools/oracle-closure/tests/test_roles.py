"""Seam G: every line of a draft has one role, and a hole is its note line, its Raven line, and its marker line.

This test drafts a function of the real parse, so it runs only with SLOW=1 in the environment.
PM_pitch_roll_for_slope, the function the docket names, holds noted holes alone and no Raven line.
SelectRandomDeathmatchSpawnPoint shows the five roles the docket names, so the test drafts it.
"""

from __future__ import annotations

import os
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))


@unittest.skipUnless(os.environ.get("SLOW") == "1", "slow: one parse and one draft of the real tree, run with SLOW=1")
class Roles(unittest.TestCase):
    def test_every_line_of_a_draft_has_one_role_and_a_hole_has_note_raven_marker(self) -> None:
        import closure as C
        from bodies import Drafter, Registry
        from draft_classification import ROLES
        from skeleton import Skeleton

        # given the draft of a function with holes, a lifted store, and a lifted note
        sk = Skeleton(C.Parse())
        drafter = Drafter(sk, Registry())
        lines = drafter.draft(sk.by_name["SelectRandomDeathmatchSpawnPoint"])
        roles = drafter.line_roles

        # then every line has one role of the set, and the draft shows the five roles of a hole and a lifted line
        self.assertEqual(len(roles), len(lines))
        self.assertTrue(set(roles) <= set(ROLES), set(roles) - set(ROLES))
        self.assertTrue({"lifted", "note", "raven", "marker", "own"} <= set(roles), set(roles))

        # and each Raven line of a hole stands between its note line and its marker line
        holes = [i for i, line in enumerate(lines) if line.lstrip().startswith("// Raven wrote:")]
        self.assertEqual(len(holes), 3)
        for i in holes:
            self.assertTrue(lines[i - 1].lstrip().startswith("// Port-note:"), lines[i - 1])
            self.assertEqual(roles[i - 1:i + 2], ["note", "raven", "marker"], lines[i - 1:i + 2])


if __name__ == "__main__":
    unittest.main()
