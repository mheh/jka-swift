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
from table import Param

from draft_calls import Calls
# Hole stands under the Port-note the drafter writes, so it lives beside the classification that writes one.
from draft_classification import Classification, Hole
from draft_declarations import Declarations
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
                self.overloads.setdefault(name, []).append(params)
                r = re.search(r"->\s*(.+?)\s*\{?\s*$", line[end + 1:])
                self.returns.setdefault(name, r.group(1) if r else "Void")
                if FILE_FUNC.match(line):
                    self.homes.setdefault(name, set()).add(target)



class Drafter(Statements, Expressions, Calls, Declarations, Classification):
    """The one drafter of a function body. The state of a draft lives here, and each concern module gives the class its methods."""

    def __init__(self, sk: Skeleton, registry: Registry) -> None:
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
        # The parameters and the local declarations of the function being drafted, by name, for the let and the guard rules.
        self.params_by_name: dict[str, Param] = {}
        self.lets: set[str] = set()
        # A conversion every numeric leaf of the expression being drafted takes: "Double" under a double literal, or an unsigned type.
        self.leaf_wrap: str | None = None
        # The scratch closures open around the statement being drafted, innermost last: None, "flag", or "value".
        self.scratch_modes: list[str | None] = []
        # The game fields a bg body reaches, by root kind, field path, and write, each with the callback the channel carries.
        self.reads = sk.table.reads
        # The locals of the function being drafted that Raven typed `gentity_t *` and the draft holds as `JKAMP.BgEntity`.
        self.game_entities: set[str] = set()
        # The text kind of each argument of the call being drafted, by position, so one overload takes the whole call.
        self.call_kinds: dict[int, str] = {}
        # Raven's `siegeTeam_t **teamPtr` locals of the function being drafted, by his name, with the record the pointee stands for.
        self.chosen_locals: dict[str, str] = {}

    # MARK: - One function

    def draft(self, fn: Function) -> list[str]:
        header = self.sk.stub(fn)
        if not fn.mapped or not header[-1].startswith("}"):
            return header
        self.fn = fn
        self.source = self.sk.source(fn.stem)
        self.bytes = C.parsed_bytes(C.ORACLE / ORACLE_DIR / f"{fn.stem}.c")
        self.names = {c.spelling: p.name for c, p in zip(fn.cur.get_arguments(), fn.params)}
        self.params_by_name = {c.spelling: p for c, p in zip(fn.cur.get_arguments(), fn.params)}
        self.scratch_names: dict[str, int] = {}
        # The Swift statement each of Raven's labels gives its gotos, `break rest` or `continue backAgain`.
        self.goto_forms: dict[str, str] = {}
        # The vector each pointer-to-float local of the function stands for, by Raven's name.
        self.aliases: dict[str, ci.Cursor] = {}
        self.game_entities = set()
        self.local_holes = set()
        self.optional_entities: set[str] = set()
        self.after_com_error = False
        self.charbuf_locals: set[str] = set()
        # Raven's `byte *b` and `char *dest` locals that only ever hold a raw allocation, which Swift holds as UnsafeMutableRawPointer.
        self.raw_locals = self.raw_local_names(fn.cur)
        # Raven's `const char *token` that only holds parsed text is a String.
        self.text_locals, self.optional_texts = self.text_local_names(fn.cur)
        # His `char *p` over a named buffer is a read cursor, a TextCursor, or a write cursor, the byte offset of row 47.
        # Raven's `for (it = table + 1; it->name; it++)` walks a table by pointer, and the draft walks it by index, `table[itIndex]`.
        self.cursor_locals, self.offset_cursors, self.table_cursors = self.local_facts(fn)
        # The slot text each copy stands for inside the one call being drafted, `fxAxis[2]` for `fxAxis2`.
        self.slot_copies: dict[str, str] = {}
        self.aliased_positions: dict[int, str] = {}
        # Raven's `animation_t *animations` local that only ever holds a table of records, which Swift holds as the Slots over it.
        self.slots_locals = self.slots_local_names(fn.cur)
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
        self.inout_locals = {c.spelling for c, p in zip(fn.cur.get_arguments(), fn.params) if (p.swift or "").startswith("inout ")}
        # Raven assigns a parameter of his own. A Swift parameter is immutable, so the body opens with a mutable copy, after the declarations.
        self.param_copies = [p.name for c, p in zip(fn.cur.get_arguments(), fn.params) if c.spelling in self.written and c.spelling not in self.inout_locals]
        body = [c for c in fn.cur.get_children() if c.kind == CursorKind.COMPOUND_STMT][-1]
        # A view read Raven names more than once is one local, by his text of the read, once the draft declares it.
        self.hoisted: dict[str, str] = {}
        self.hoists = self.shared_reads(body)
        lines = header[:-3]
        lines += self.block_body(body, 1)
        lines.append("}")
        return lines


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
    for fn in fns:
        print("\n".join(drafter.draft(fn)))
        print()
    print(f"// {drafter.holes} holes", flush=True)


if __name__ == "__main__":
    main()
