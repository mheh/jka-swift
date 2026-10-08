#!/usr/bin/env python3
"""bodies.py: a first Swift draft of each function body, translated statement by statement from Raven's AST.

The draft encodes the rules of docs/transcription.md that a machine can apply without judgment: views for `->`, `true`
and `false` for qtrue and qfalse, `!= 0` and `!= nil` where C tests a number or a pointer, `i = 0; while ...; i += 1`
for a `for` loop, `+= 1` for a `++` statement, `&` on an argument a Swift `inout` parameter takes, and Raven's comments
and blank lines in their places. A statement the draft cannot translate keeps its C text in a `// Raven wrote:` line
under a Port-note, and a `portMissing` call marks the place, so the draft compiles as far as it goes and a transcriptor
finds every hole by one grep.

The draft goes to stdout, never into Sources/. The stub header comes from skeleton.py, so the signature is the table's.

The emit lives in five modules by concern: draft_statements.py, draft_expressions.py, draft_calls.py, draft_declarations.py, and draft_classification.py.
The Drafter here is their one entry, it holds the state of a draft, and each concern gives it a set of methods.

Usage:
  .venv/bin/python bodies.py --only PM_AddTouchEnt,BG_SabersOff   # prints the drafts of the named functions
  .venv/bin/python bodies.py --stem bg_pmove                       # prints every draft of one file
"""

from __future__ import annotations

import argparse
import re

import clang.cindex as ci
from clang.cindex import CursorKind

from reexport import SOURCES
import closure as C
from skeleton import ORACLE_DIR, Function, Skeleton
from table import Cursor, Param

from draft_calls import Calls
# Hole stands under the Port-note the drafter writes, so it lives beside the classification that writes one.
from draft_classification import ROLE_MARK, STATEMENT_MARK, TRAILING, Classification, Hole
from draft_declarations import Declarations, short_named
from draft_expressions import Expressions
from draft_statements import Statements

WRAPPERS = {CursorKind.UNEXPOSED_EXPR, CursorKind.PAREN_EXPR}

FUNC_LINE = re.compile(r"func\s+`?(\w+)`?\s*\((.*)\)")
FUNC_HEAD = re.compile(r"func\s+`?(\w+)`?\s*\(")
# A file-scope `var`, `let`, or `func` of a Swift file: at column 0, after its modifiers. A method sits indented under its type.
MODIFIERS = r"(?:(?:public|package|internal|private|fileprivate|nonisolated\(unsafe\)|@\w+(?:\([^)]*\))?)\s+)*"
VAR_LINE = re.compile(MODIFIERS + r"(?:var|let)\s+`?(\w+)`?")
# The type annotation of a file-scope variable, up to its initializer or its computed body.
VAR_TYPE = re.compile(r"\s*:\s*([^={]+)")
FILE_FUNC = re.compile(MODIFIERS + r"func\s")


def split_params(text: str) -> list[str]:
    """The parameter list of one Swift `func` line, split at the commas outside brackets."""
    out: list[str] = []
    depth = 0
    start = 0
    for i, ch in enumerate(text):
        if ch in "([<":
            depth += 1
        elif ch in ")]>":
            depth -= 1
        elif ch == "," and depth == 0:
            out.append(text[start:i].strip())
            start = i + 1
    tail = text[start:].strip()
    if tail:
        out.append(tail)
    return out


class Registry:
    """The `inout` positions of every hand and generated Swift function under Sources/, so a call to a trap or a q_shared function
    takes `&` where the Swift signature asks for it."""

    def __init__(self) -> None:
        self.params: dict[str, list[tuple[str, str]]] = {}
        # The parameters of each function by the Swift target that holds it,
        # so a bg body calls the channel's forward and a game body calls the game function.
        self.target_params: dict[tuple[str, str], list[tuple[str, str]]] = {}
        # The Swift return type of each function, so a call to one that returns a value takes no bind.
        self.returns: dict[str, str] = {}
        # Every overload's parameters, so an argument converts only when no overload takes it as it is.
        self.overloads: dict[str, list[list[tuple[str, str]]]] = {}
        # The Swift targets that hold each file-scope function and variable, so a bg body that reaches a game-only name keeps a hole.
        self.homes: dict[str, set[str]] = {}
        # The Swift type of each file-scope variable that spells one, so a store reads whether the source is a Slots.
        self.var_types: dict[str, str] = {}
        for path in SOURCES.rglob("*.swift"):
            target = path.relative_to(SOURCES).parts[0]
            for line in path.read_text().splitlines():
                v = VAR_LINE.match(line)
                if v is not None:
                    self.homes.setdefault(v.group(1), set()).add(target)
                    spelled = VAR_TYPE.match(line[v.end():])
                    if spelled is not None:
                        self.var_types.setdefault(v.group(1), spelled.group(1).strip())
                m = FUNC_HEAD.search(line)
                if m is None or "func " not in line.split("//")[0]:
                    continue
                # The parameter list ends at the parenthesis that balances the first, so a tuple return stays outside it.
                depth = 0
                end = None
                for i in range(m.end() - 1, len(line)):
                    if line[i] == "(":
                        depth += 1
                    elif line[i] == ")":
                        depth -= 1
                        if depth == 0:
                            end = i
                            break
                if end is None:
                    continue
                name = m.group(1)
                params = []
                for p in split_params(line[m.end():end]):
                    label, _, swift = p.partition(":")
                    params.append((label.split()[-1].strip("`"), swift.strip()))
                self.params.setdefault(name, params)
                self.target_params.setdefault((target, name), params)
                self.overloads.setdefault(name, []).append(params)
                r = re.search(r"->\s*(.+?)\s*\{?\s*$", line[end + 1:])
                self.returns.setdefault(name, r.group(1) if r else "Void")
                if FILE_FUNC.match(line):
                    self.homes.setdefault(name, set()).add(target)



class Drafter(Statements, Expressions, Calls, Declarations, Classification):
    """The one drafter of a function body. The state of a draft lives here, and each concern module gives the class its methods."""

    def __init__(self, sk: Skeleton, registry: Registry, compile_due: dict[tuple[str, str, int, int], str] | None = None) -> None:
        self.sk = sk
        self.views = sk.table.views
        # The one owner of the type question, which the table holds.
        self.types = sk.table.types
        self.registry = registry
        self.holes = 0
        # The locals a hole declares, so a later error on one of them counts as a cascade of the hole, not a new defect.
        self.hole_names: set[str] = set()
        # The same names of the function being drafted alone, because another function is free to hold a local of that name.
        self.local_holes: set[str] = set()
        # Lines an expression asks to go above its statement: a Port-note, or a scratch local for a NULL output argument.
        self.pending: list[str] = []
        # The last test of each logical operator already drafted, by its span, so a chain writes a repeated test once.
        self.logical_tails: dict[tuple[str, int, int], tuple[str, ci.Cursor]] = {}
        # The parameters and the local declarations of the function being drafted, by name, for the let and the guard rules.
        self.params_by_name: dict[str, Param] = {}
        self.lets: set[str] = set()
        # A conversion every numeric leaf of the expression being drafted takes: "Double" under a double literal, or an unsigned type.
        self.leaf_wrap: str | None = None
        # The scratch closures open around the statement being drafted, innermost last: None, "flag", or "value".
        self.scratch_modes: list[str | None] = []
        # The step clause of each loop open around the statement being drafted, innermost last, and None for a loop with no step.
        self.loop_steps: list[ci.Cursor | None] = []
        # The game fields a bg body reaches, by root kind, field path, and write, each with the callback the channel carries.
        self.reads = sk.table.reads
        # The locals of the function being drafted that Raven typed `gentity_t *` and the draft holds as `JKAMP.BgEntity`.
        self.game_entities: set[str] = set()
        # The text kind of each argument of the call being drafted, by position, so one overload takes the whole call.
        self.call_kinds: dict[int, str] = {}
        # The conversion letter each argument of the call being drafted feeds in the callee's format string, by position, with the argument.
        self.call_format: dict[int, tuple[ci.Cursor, str]] = {}
        # Raven's `siegeTeam_t **teamPtr` locals of the function being drafted, by his name, with the record the pointee stands for.
        self.chosen_locals: dict[str, str] = {}
        # Raven's `char *` locals from a CHARBUF_ALLOCS call, and his walked record pointer parameters with their stores and steps.
        self.charbuf_allocs: dict[str, ci.Cursor] = {}
        self.param_walks: dict[str, list[tuple[int, int, list[tuple[int, int, int]]]]] = {}
        self.param_walk_heads: list[str] = []
        # The statements the compile gate rejected on an earlier pass, by their key, each with the compiler's message for its hole.
        self.compile_due: dict[tuple[str, str, int, int], str] = compile_due or {}
        self.compile_holes = 0
        # The key of each statement mark, by its number, and the number of each key, for the statements this drafter drafted.
        self.statement_keys: list[tuple[str, str, int, int]] = []
        self.statement_numbers: dict[tuple[str, str, int, int], int] = {}
        # The key of the statement that drafted each line of the last draft, or None for a line no statement drafted.
        self.line_keys: list[tuple[str, str, int, int] | None] = []
        # The role of each line of the last draft, one of ROLES, and Raven's comment at the end of the line, or None for a line with none.
        self.line_roles: list[str] = []
        self.line_trailing: list[str | None] = []

    # MARK: - One function

    def draft(self, fn: Function) -> list[str]:
        header = self.sk.stub(fn)
        if not fn.mapped or not header[-1].startswith("}"):
            # The stub stands as the skeleton wrote it, and only its closing brace is no header line.
            self.line_keys = [None] * len(header)
            self.line_roles = ["header"] * (len(header) - 1) + ["frame"]
            self.line_trailing = [None] * len(header)
            return header
        self.fn = fn
        self.source = self.sk.source(fn.stem)
        self.bytes = C.parsed_bytes(C.ORACLE / ORACLE_DIR / f"{fn.stem}.c")
        self.names = {c.spelling: p.name for c, p in zip(fn.cur.get_arguments(), fn.params)}
        self.params_by_name = {c.spelling: p for c, p in zip(fn.cur.get_arguments(), fn.params)}
        self.scratch_names: dict[str, int] = {}
        # The spans of Raven's `a - b` that stand as an array index, where the Slots index form, an Int, has a seat.
        self.index_spans: set[tuple[int, int]] = set()
        for node in fn.cur.walk_preorder():
            kids = list(node.get_children()) if node.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR else []
            difference = self.unwrap(kids[1]) if len(kids) == 2 else None
            if difference is not None and difference.kind == CursorKind.BINARY_OPERATOR and len(list(difference.get_children())) == 2:
                parts = list(difference.get_children())
                self.index_spans.add((self.unwrap(parts[0]).extent.start.offset, self.unwrap(parts[1]).extent.end.offset))
        # The Swift statement each of Raven's labels gives its gotos, `break rest` or `continue backAgain`.
        self.goto_forms: dict[str, str] = {}
        # The vector each pointer-to-float local of the function stands for, by Raven's name.
        self.aliases: dict[str, ci.Cursor] = {}
        self.game_entities = set()
        self.local_holes = set()
        self.optional_entities: set[str] = set()
        self.after_com_error = False
        # Raven's `char *buf` locals that only ever hold a CHARBUF_ALLOCS call at one constant size, which Swift holds as a CharBuf of that size.
        self.charbuf_allocs = self.charbuf_alloc_names(fn.cur)
        self.charbuf_locals: set[str] = set(self.charbuf_allocs)
        # Raven's vector parameters a caller passes NULL to and the body only reads, which cross as optional values.
        self.optional_vectors = {c.spelling for c, p in zip(fn.cur.get_arguments(), fn.params)
                                 if p.kind in ("vec3_opt", "axis_opt", "vec3_mut_opt", "axis_mut_opt")}
        # His `char *p` over a named buffer is a read cursor, a TextCursor, or a write cursor, the byte offset of row 47.
        # Raven's `for (it = table + 1; it->name; it++)` walks a table by pointer, and the draft walks it by index, `table[itIndex]`.
        self.cursor_locals, self.offset_cursors, self.table_cursors = self.local_facts(fn)
        # Raven's `animation_t *animations` local that only ever holds a table of records, which Swift holds as the Slots over it.
        self.slots_locals = self.slots_local_names(fn.cur)
        # Raven's `short temp` locals, by his name, with the narrow storage Swift keeps for each, so a store truncates and a read widens.
        self.narrow_locals = self.narrow_local_names(fn.cur)
        # The scan of the raw locals spells a store through `expr`, and that spelling reads the four facts above, so they come first.
        # Raven's `byte *b` and `char *dest` locals that only ever hold a raw allocation, which Swift holds as UnsafeMutableRawPointer.
        self.raw_locals = self.raw_local_names(fn.cur) - self.charbuf_locals
        # Raven's `const char *token` that only holds parsed text is a String.
        self.text_locals, self.optional_texts = self.text_local_names(fn.cur)
        # The slot text each copy stands for inside the one call being drafted, `fxAxis[2]` for `fxAxis2`.
        self.slot_copies: dict[str, str] = {}
        # The copy that stands in for each earlier aliased argument of the one call being drafted, keyed by the argument's extent and position.
        self.aliased_positions: dict[tuple[int, int, int], str] = {}
        # Raven's `siegeTeam_t **teamPtr` that only holds the address of a file-scope variable he chooses between.
        self.chosen_locals = self.chosen_local_names(fn.cur)
        facts = self.sk.table.locals_of(fn.stem, fn.cur.spelling)
        self.lets = facts.single_writes
        if any(self.record_local(c) is not None for c in fn.cur.walk_preorder()):
            # A closure cannot initialize a let of the enclosing body, so a body with a scratch record keeps every local a var.
            self.lets = set()
        self.written = facts.written
        self.addressed = facts.addressed
        self.has_scratch = any(self.record_local(c) is not None for c in fn.cur.walk_preorder())
        # A store inside an expression lifts to its own line before the statement, except where the line would run at the wrong time:
        # a loop test, the right side of `&&` or `||`, an arm of `?:`. The count holds how many of those enclose the expression.
        self.lift_blocked = 0
        # The stores already lifted, by their extent, so a second draft of one expression lifts no store twice.
        self.lifted: set[tuple[int, int]] = set()
        self.inout_locals = {c.spelling for c, p in zip(fn.cur.get_arguments(), fn.params) if (p.swift or "").startswith("inout ")}
        # Raven assigns a parameter of his own. A Swift parameter is immutable, so the body opens with a mutable copy, after the declarations.
        # Raven walks his own record pointer parameter over a table, `from` of G_Find, and an index stands for it once a store or a step reaches it.
        self.param_walks = self.parameter_walk_writes(fn.cur)
        self.param_walk_heads = list(self.param_walks)
        self.param_copies = [p.name for c, p in zip(fn.cur.get_arguments(), fn.params)
                             if c.spelling in self.written and c.spelling not in self.inout_locals and c.spelling not in self.param_walks]
        # Raven steps his own `const char *` parameter through its bytes, so the mutable copy is a read cursor over the String's bytes.
        walked = [(c.spelling, p.name) for c, p in zip(fn.cur.get_arguments(), fn.params) if p.kind == "cstring" and c.spelling in self.written]
        self.cursor_params = {name for _, name in walked}
        for raven, _ in walked:
            self.cursor_locals[raven] = Cursor("read", raven, False)
        body = [c for c in fn.cur.get_children() if c.kind == CursorKind.COMPOUND_STMT][-1]
        # A view read Raven names more than once is one local, by his text of the read, once the draft declares it.
        self.hoisted: dict[str, str] = {}
        self.hoists = self.shared_reads(body)
        lines = header[:-3]
        # The signature keeps the spelling of the transcription tables, and every body line reads its types by their short names.
        lines += [short_named(line) for line in self.block_body(body, 1)]
        lines.append("}")
        # Each line gives up its statement mark and its role here.
        # line_keys keeps the statement beside the line for the compile gate, and line_roles keeps the role.
        # A line with no role of its own is a header line, the closing brace, a blank line, or a line of its statement's own text.
        clean: list[str] = []
        self.line_keys = []
        self.line_roles = []
        self.line_trailing = []
        head = len(header) - 3
        for i, line in enumerate(lines):
            mark = STATEMENT_MARK.search(line)
            key = self.statement_keys[int(mark.group(1))] if mark else None
            named = ROLE_MARK.search(line)
            role = "header" if i < head else "frame" if i == len(lines) - 1 else named.group(1) if named else None
            for part in ROLE_MARK.sub("", STATEMENT_MARK.sub("", line)).split("\n"):
                text, _, comment = part.partition(TRAILING)
                clean.append(f"{text} {comment}" if comment else text)
                self.line_keys.append(key)
                self.line_roles.append(role or ("blank" if not text.strip() else "own"))
                self.line_trailing.append(comment or None)
        return clean


def printed(drafter: Drafter, fns: list[Function]) -> str:
    """The text a run of bodies.py prints for the functions: each draft and a blank line after it, then the footer of the hole count."""
    text = "".join("\n".join(drafter.draft(fn)) + "\n\n" for fn in fns)
    return text + f"// {drafter.holes} holes\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--only", help="comma-separated function names to print")
    parser.add_argument("--stem", help="print every draft of one .c file")
    args = parser.parse_args()
    sk = Skeleton(C.Parse())
    drafter = Drafter(sk, Registry())
    if args.only:
        fns = [sk.by_name[n] for n in args.only.split(",")]
    elif args.stem:
        fns = sk.files[args.stem]
    else:
        parser.error("give --only or --stem")
    print(printed(drafter, fns), end="", flush=True)


if __name__ == "__main__":
    main()
