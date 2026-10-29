"""Seam E: the project file holds the units that the module files under modules/ held before it."""

from __future__ import annotations

import subprocess
import sys
import tomllib
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

REPO = HERE.parents[1]
# The last commit that holds the module files, which is the known fact the project file must match.
OLD = "95fb8c0"
PARSE_KEYS = ("name", "lang", "entry", "includes", "defines", "flags", "srcglob", "exclude")
# The source patterns a ruling added after the old commit, by unit and by the pattern each one follows.
# Row V10 of notes/2026-10-29/vehicle-npc-docket.md adds the four vehicle files that Raven's cgame build compiles a second time.
ADDED = {"mp-cgame": ("codemp/cgame/*.c", [f"codemp/game/{stem}.c" for stem in ("AnimalNPC", "FighterNPC", "SpeederNPC", "WalkerNPC")])}


def git(*args: str) -> str:
    return subprocess.run(["git", "-C", str(REPO), *args], capture_output=True, text=True, check=True).stdout


def old_specs() -> dict[str, dict]:
    """Every unit as its module file at the old commit spelled it, by name."""
    out: dict[str, dict] = {}
    for path in git("ls-tree", "--name-only", f"{OLD}:tools/oracle-closure/modules").split():
        if not path.endswith(".py"):
            continue
        scope: dict = {}
        exec(git("show", f"{OLD}:tools/oracle-closure/modules/{path}"), scope)
        out[scope["SPEC"]["name"]] = scope["SPEC"]
    return out


class ProjectFile(unittest.TestCase):
    def test_every_unit_carries_the_parse_profile_of_its_old_module_file(self) -> None:
        # given the project file and the module files of the old commit
        with (HERE / "project.toml").open("rb") as f:
            units = tomllib.load(f)["units"]
        old = old_specs()

        # then the project file names the same units, each with the same parse profile
        self.assertEqual(set(units), set(old))
        for name, spec in old.items():
            expected = {key: spec[key] for key in PARSE_KEYS if key in spec}
            if name in ADDED:
                after, added = ADDED[name]
                at = expected["srcglob"].index(after) + 1
                expected["srcglob"] = expected["srcglob"][:at] + added + expected["srcglob"][at:]
            actual = {key: units[name][key] for key in PARSE_KEYS if key in units[name]}
            self.assertEqual(actual, expected, name)

    def test_the_parse_reads_the_unit_file_lists_of_the_old_module_files(self) -> None:
        # given the parse of one run, built from the project file
        import closure as C

        parse = C.Parse()
        old = old_specs()
        oracle = REPO / "oracle"

        # then each unity parse includes exactly the .c files the old globs name
        for tu, name in ((parse.game, "mp-game"), (parse.cgame, "mp-cgame")):
            included = {Path(inc.include.name).resolve() for inc in tu.get_includes() if inc.depth == 1 and inc.include.name.endswith(".c")}
            patterns = old[name]["srcglob"] + (ADDED[name][1] if name in ADDED else [])
            expected = {p.resolve() for g in patterns for p in oracle.glob(g)}
            self.assertTrue(expected, name)
            self.assertEqual(included, expected, name)


if __name__ == "__main__":
    unittest.main()
