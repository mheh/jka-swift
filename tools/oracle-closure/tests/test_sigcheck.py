"""sigcheck.py and the three error exits of the signature batch: skeleton.py and merge.py on an absent extract.json, and reexport.py on a failed probe.

The tests write their own Swift files and store in a temporary folder, so they need no generator run and no build.
"""

from __future__ import annotations

import contextlib
import io
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest import mock

HERE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(HERE))

import merge  # noqa: E402
import reexport  # noqa: E402
import sigcheck  # noqa: E402
import skeleton  # noqa: E402
from store import Store, combined, digest  # noqa: E402

NORMALIZER = sigcheck.Normalizer({"JKAShared", "JKAMP"}, {"vec_t": ["Float"], "byte": ["UInt8"], "memtag_t": ["Int32"]})


def same(one: str, other: str) -> bool:
    return NORMALIZER.canonical(one) == NORMALIZER.canonical(other)


class Spelling(unittest.TestCase):
    def test_spelling_that_does_not_change_the_type_compares_equal(self) -> None:
        table = "public func VectorNormalize(_ v: inout JKAShared.vec3_t) -> Float"
        # a module prefix, an access word, an attribute, white space, and a typealias of the package
        self.assertTrue(same(table, "func VectorNormalize(_ v: inout vec3_t) -> vec_t"))
        self.assertTrue(same(table, "@discardableResult  private func VectorNormalize( _ v :inout  vec3_t )->Float"))
        self.assertTrue(same("func Z_TagFree(_ eTag: Int32)", "func Z_TagFree(_ eTag: JKAShared.memtag_t)"))
        self.assertTrue(same("nonisolated(unsafe) public func f(_ b: Slots<byte>)", "func f(_ b: Slots<JKAShared.byte>)"))

    def test_spelling_that_changes_the_type_or_the_call_compares_unequal(self) -> None:
        table = "func BotAvoidSpots(_ spots: Slots<JKAMP.BotAvoidspot>?, _ n: Int32) -> Int32"
        # an optional, an inout, a return, and a default
        self.assertFalse(same(table, "func BotAvoidSpots(_ spots: Slots<BotAvoidspot>, _ n: Int32) -> Int32"))
        self.assertFalse(same(table, "func BotAvoidSpots(_ spots: inout Slots<BotAvoidspot>?, _ n: Int32) -> Int32"))
        self.assertFalse(same(table, "func BotAvoidSpots(_ spots: Slots<BotAvoidspot>?, _ n: Int32) -> Int"))
        self.assertFalse(same(table, "func BotAvoidSpots(_ spots: Slots<BotAvoidspot>? = nil, _ n: Int32) -> Int32"))

    def test_a_parameter_name_keeps_its_spelling_when_a_typealias_has_the_name(self) -> None:
        # the name `byte` is a parameter here, and the type after it is the alias
        self.assertFalse(same("func f(_ byte: byte)", "func f(_ UInt8: byte)"))
        self.assertTrue(same("func f(_ byte: byte)", "func f(_ byte: UInt8)"))


class Declarations(unittest.TestCase):
    def test_a_declaration_reads_through_line_breaks_and_comments_to_its_brace(self) -> None:
        lines = [
            "// func Pmove(_ old: Int32) is a comment and no declaration",
            "public func Pmove(",
            "    _ pmove: JKAMP.Pmove,  // the move",
            "    _ count: Int32",
            ") -> Int32 {",
            "    return 0",
            "}",
        ]
        found = sigcheck.declarations(lines, "Pmove")
        self.assertEqual([d.line for d in found], [2])
        self.assertTrue(same(found[0].text, "func Pmove(_ pmove: JKAMP.Pmove, _ count: Int32) -> Int32"))

    def test_a_declaration_with_no_body_ends_at_its_closing_parenthesis(self) -> None:
        lines = ["protocol P {", "    func run(_ x: Int32)", "    var y: Int32 { get }", "}"]
        found = sigcheck.declarations(lines, "run")
        self.assertEqual(found[0].text, "func run(_ x: Int32)")


class Check(unittest.TestCase):
    def setUp(self) -> None:
        folder = tempfile.TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        self.root = Path(folder.name)
        sources = self.root / "Sources"
        (sources / "JKAShared").mkdir(parents=True)
        (sources / "JKAMP_Logic").mkdir()
        (sources / "JKAShared" / "aliases.swift").write_text("public typealias vec_t = Float\n")
        self.stub = sources / "JKAMP_Logic" / "g_one.swift"
        self.stub.write_text("\n".join([
            "func Same(_ v: vec3_t) -> vec_t {}",
            "func Differs(_ n: Int8) {}",
            "func Named(_ n: Int8) {}",
            "func Hole(_ m: [vec3_t]) {}",
            "",
        ]))
        # A function the skeleton found no line for lives in another file.
        (sources / "JKAShared" / "elsewhere.swift").write_text("public func Moved(_ n: Int32) {}\n")
        self.store = self.root / "table.sqlite"
        project = {"output": {"root": "Sources"}, "targets": {"mp-game": {"store": "table.sqlite"}}}
        for patch in (mock.patch.object(sigcheck, "REPO", self.root), mock.patch.object(sigcheck, "SOURCES", sources),
                      mock.patch.object(sigcheck, "PROJECT", project), mock.patch.object(sigcheck, "NOT_PORTED", {"Gone": "a reason"}),
                      mock.patch.object(sigcheck, "SIGNATURE_EXCEPTIONS", {"Named": ("mp-game", "row SG1 of the ledger")})):
            patch.start()
            self.addCleanup(patch.stop)

    def save(self, names: dict[str, str], reasons: dict[str, str] | None = None, destinations: dict[str, str] | None = None) -> None:
        reasons = reasons or {}
        destinations = destinations or {}
        rows = []
        for line, (name, text) in enumerate(names.items(), 1):
            rows.append({"file": "g_one.c", "name": name, "kind": "function", "target": "JKAMP_Logic", "text": text, "forward": None,
                         "reason": reasons.get(name), "source": f"oracle/codemp/game/g_one.c:{line}-{line}",
                         "destination": destinations.get(name, f"JKAMP_Logic/g_one.swift:{line}"), "state": "ported", "peer": ""})
        files = {str(self.stub): digest(self.stub.read_bytes())}
        with Store(self.store) as store:
            store.save_signatures(combined(files, "input-key-1"), files, rows)

    def run_check(self) -> tuple[int, str, str]:
        out, err = io.StringIO(), io.StringIO()
        with mock.patch.object(sys, "argv", ["sigcheck.py"]), contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
            status = sigcheck.main()
        return status, out.getvalue(), err.getvalue()

    def test_a_difference_the_table_does_not_name_fails_and_prints_both_forms(self) -> None:
        # given a stub with one equal function, one difference, one named difference, one hole, and one function of NOT_PORTED
        self.save({"Same": "func Same(_ v: JKAShared.vec3_t) -> Float", "Differs": "func Differs(_ n: Int32)",
                   "Named": "func Named(_ n: Int32)", "Hole": "func Hole() -> Never", "Gone": "func Gone()"},
                  reasons={"Hole": "No table row for `float[3][3] m`."})

        # when the check runs
        status, out, err = self.run_check()

        # then the unnamed difference fails the check, the named one prints its row, and the counts name the hole and the function of NOT_PORTED
        self.assertEqual(status, 1)
        self.assertIn("differs mp-game Differs", out)
        self.assertIn("table  func Differs(_ n: Int32)", out)
        self.assertIn("named   mp-game Named  row SG1 of the ledger", out)
        self.assertNotIn("Same", out)
        self.assertIn("5 function rows, 1 equal, 1 holes, 1 not ported, 1 named, 1 differ, 0 stale entries", err)

    def test_named_differences_alone_pass(self) -> None:
        self.save({"Same": "func Same(_ v: JKAShared.vec3_t) -> Float", "Named": "func Named(_ n: Int32)"})
        status, out, _ = self.run_check()
        self.assertEqual(status, 0)
        self.assertEqual(out.splitlines(), ["named   mp-game Named  row SG1 of the ledger"])

    def test_an_entry_that_no_longer_differs_is_stale_and_fails(self) -> None:
        # given a named function whose Swift line has the table's type again
        self.save({"Named": "func Named(_ n: Int8)"})
        status, out, _ = self.run_check()
        self.assertEqual(status, 1)
        self.assertIn("stale   mp-game Named", out)

    def test_a_row_with_no_swift_line_compares_with_the_declaration_of_another_file(self) -> None:
        self.save({"Moved": "func Moved(_ n: Int32)", "Lost": "func Lost()", "Named": "func Named(_ n: Int32)"},
                  destinations={"Moved": "", "Lost": ""})
        status, out, _ = self.run_check()
        self.assertEqual(status, 1)
        self.assertNotIn("Moved", out)
        self.assertIn("differs mp-game Lost\n  swift  missing  no Swift declaration", out)

    def test_a_stub_changed_after_the_rows_makes_the_check_stop_with_exit_2(self) -> None:
        self.save({"Same": "func Same(_ v: JKAShared.vec3_t) -> Float"})
        self.stub.write_text(self.stub.read_text() + "func Hand() {}\n")
        status, out, err = self.run_check()
        self.assertEqual((status, out), (2, ""))
        self.assertIn("Run skeleton.py --signatures --unit mp-game", err)


class ExtractManifest(unittest.TestCase):
    def test_skeleton_stops_on_an_absent_extract_json(self) -> None:
        with tempfile.TemporaryDirectory() as folder:
            # given a tool folder whose out/extract holds no manifest of the unit
            with mock.patch.object(skeleton, "__file__", str(Path(folder) / "skeleton.py")):
                with self.assertRaises(SystemExit) as stop:
                    skeleton.Skeleton.collect_file_enums(SimpleNamespace())
        self.assertIn("Run extract.py", str(stop.exception))

    def test_merge_stops_on_a_module_folder_with_no_extract_json(self) -> None:
        with tempfile.TemporaryDirectory() as folder:
            # given the folder that a check run of extract.py leaves, with headers and no manifest
            (Path(folder) / "mp-game").mkdir()
            with mock.patch.object(merge, "EXTRACT", Path(folder)):
                with self.assertRaises(SystemExit) as stop:
                    merge.load_tree("mp", ["mp-game"])
        self.assertIn("extract.json. Run extract.py mp-game first.", str(stop.exception))


class Probe(unittest.TestCase):
    def test_a_failed_build_that_names_no_declaration_gives_its_first_error_line(self) -> None:
        failed = subprocess.CompletedProcess(["swift", "build"], 1, stdout="Compiling\n/x/Sources/A/a.swift:3:1: error: no such module\n", stderr="")
        with mock.patch.object(reexport.subprocess, "run", return_value=failed):
            names, failure = reexport.probe()
        self.assertEqual(names, set())
        self.assertEqual(failure, "/x/Sources/A/a.swift:3:1: error: no such module")

    def test_a_passing_build_gives_no_failure(self) -> None:
        passed = subprocess.CompletedProcess(["swift", "build"], 0, stdout="Build complete!\n", stderr="")
        with mock.patch.object(reexport.subprocess, "run", return_value=passed):
            self.assertEqual(reexport.probe(), (set(), None))

    def test_the_run_exits_1_when_the_probe_build_fails_with_no_names(self) -> None:
        # given a run that writes nothing and a probe build that fails for another reason
        patches = (mock.patch.object(reexport, "emit", return_value={}), mock.patch.object(reexport, "write", return_value=0),
                   mock.patch.object(reexport, "probe", return_value=(set(), "error: the build fails")),
                   mock.patch.object(sys, "argv", ["reexport.py"]))
        err = io.StringIO()
        with contextlib.ExitStack() as stack:
            for patch in patches:
                stack.enter_context(patch)
            stack.enter_context(contextlib.redirect_stdout(io.StringIO()))
            stack.enter_context(contextlib.redirect_stderr(err))
            status = reexport.main()
        self.assertEqual(status, 1)
        self.assertIn("names no generated declaration: error: the build fails", err.getvalue())


if __name__ == "__main__":
    unittest.main()
