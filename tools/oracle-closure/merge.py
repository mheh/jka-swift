#!/usr/bin/env python3
"""merge.py: partition the extract.py trees into the C targets the Swift package imports.

extract.py writes one complete tree per module under out/extract/<module>/. This script reads those trees and never touches the oracle.
It compares every emitted declaration across modules and trees by code identity: the declaration text with comments stripped and
whitespace collapsed. Two declarations with the same identity are one type. A type is shared only when every type it includes is shared
too, so the partition runs to a fixed point.

The targets it writes, each a SwiftPM C target with one translation unit and its include directory:
  CJKAShared    types and macros identical in MP and SP, under shared/<header>/<Type>.h
  CJKAMP        types every MP module agrees on, under codemp/...
  CJKAMP_Game, CJKAMP_CGame, CJKAMP_UI
                types one MP module emits, or that MP modules define differently, such as lerpFrame_t
  CJKASP, CJKASP_Game, CJKASP_CGame, CJKASP_UI
                the SP twins

Each target carries a forward header and a platform header named after the target, the umbrella <Target>.h, and module.modulemap
under include/, with layout_asserts.h and <Target>.c beside it, and the C++ only headers under cxx/ for reference.
A shared type keeps MP's comment text, cites both oracle lines, and must carry the same asserts in both parses.

Usage:
  .venv/bin/python merge.py                       # writes out/merge/
  .venv/bin/python merge.py --out ../../Sources   # writes Sources/<Target>/, the package's C targets
  .venv/bin/python merge.py --mp mp-game mp-bg --sp sp-game sp-bg
"""
from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
from collections import defaultdict
from dataclasses import dataclass, field, replace
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from extract import ABIS, TRIPLES, abi_blocks  # noqa: E402
from rulings import HAND_FILES, HAND_HEADERS  # noqa: E402

EXTRACT = HERE / "out" / "extract"

MP_MODULES = ["mp-game", "mp-bg", "mp-cgame", "mp-ui"]
SP_MODULES = ["sp-game", "sp-bg", "sp-cgame", "sp-ui"]
TREE_PREFIX = {"mp": "codemp/", "sp": "code/"}
# The bg run parses the bg_*.c files' own headers, bg_local.h and bg_saga.h, and never g_local.h, even though Raven's bg_*.c include
# it under QAGAME. That keeps the game-private types out of the tree target, and the bg types in it.
TARGET_OF_MODULE = {
    "mp-game": "CJKAMP_Game", "mp-cgame": "CJKAMP_CGame", "mp-ui": "CJKAMP_UI", "mp-bg": "CJKAMP",
    "sp-game": "CJKASP_Game", "sp-cgame": "CJKASP_CGame", "sp-ui": "CJKASP_UI", "sp-bg": "CJKASP",
}
TREE_TARGET = {"mp": "CJKAMP", "sp": "CJKASP"}
SHARED = "CJKAShared"
FORWARD: dict[str, list[str]] = {}
# The include directories a target may reach, in order.
TARGET_DEPS = {
    SHARED: [],
    "CJKAMP": [SHARED], "CJKAMP_Game": ["CJKAMP", SHARED], "CJKAMP_CGame": ["CJKAMP", SHARED], "CJKAMP_UI": ["CJKAMP", SHARED],
    "CJKASP": [SHARED], "CJKASP_Game": ["CJKASP", SHARED], "CJKASP_CGame": ["CJKASP", SHARED], "CJKASP_UI": ["CJKASP", SHARED],
}


# ------------------------------------------------------------------ reading an emitted file

@dataclass
class Header:
    """One file extract.py wrote, split into the parts merge.py rewrites and the body it compares."""
    module: str
    tree: str
    rel: str                       # path under the run root, codemp/game/q_shared/byte.h
    identity: str                  # the path without the tree prefix, game/q_shared/byte.h
    includes: list[str] = field(default_factory=list)      # quoted includes, as identities, forward.h excluded
    system: list[str] = field(default_factory=list)        # system includes, verbatim
    sources: list[str] = field(default_factory=list)       # the Source: lines
    body: str = ""                                         # everything else between the includes and the guard end
    macros: list[tuple[str, str, str]] = field(default_factory=list)   # (name, source line, text) for a constants file
    c: bool = True                                         # False when extract.py marked the file C++ only

    @property
    def is_constants(self) -> bool:
        return self.rel.endswith("/constants.h")

    @property
    def key(self) -> str:
        return code_key(self.body)

    def names(self) -> set[str]:
        """The type names this file declares, for the assert lookup: the stem, and the tag when the body opens with one."""
        out = {Path(self.rel).stem}
        m = re.search(r"^(struct|union|enum)\s+(\w+)\s*\{", strip_comments(self.body), re.M)
        if m:
            out.add(f"{m.group(1)} {m.group(2)}")
        for m in re.finditer(r"^typedef\s+(?:struct|union|enum)\s+(\w+)\s+\1;", self.body, re.M):
            out.add(m.group(1))
        return out


def strip_comments(text: str) -> str:
    return re.sub(r"/\*.*?\*/|//[^\n]*", " ", text, flags=re.S)


def code_key(text: str) -> str:
    return re.sub(r"\s+", " ", strip_comments(text)).strip()


def identity_of(rel: str, tree: str) -> str:
    prefix = TREE_PREFIX[tree]
    return rel[len(prefix):] if rel.startswith(prefix) else rel


def read_header(module: str, tree: str, root: Path, path: Path) -> Header:
    rel = str(path.relative_to(root))
    header = Header(module=module, tree=tree, rel=rel, identity=identity_of(rel, tree))
    body_lines: list[str] = []
    for line in path.read_text().splitlines():
        stripped = line.strip()
        if stripped.startswith("// Generated by") or re.match(r"#(ifndef|define) JKA_\w+$", stripped) or re.match(r"#endif // JKA_\w+$", stripped):
            continue
        m = re.match(r'#include "([^"]+)"', stripped)
        if m:
            inc = m.group(1)
            if inc == "forward.h" or inc == "platform.h":
                continue
            header.includes.append(identity_of(inc, tree))
            continue
        if re.match(r"#include <[^>]+>", stripped):
            header.system.append(stripped)
            continue
        if stripped.startswith("// Source:"):
            header.sources.append(stripped)
            continue
        body_lines.append(line)
    header.body = "\n".join(body_lines).strip("\n")
    if header.is_constants:
        header.macros = split_macros(path.read_text())
    return header


def split_macros(text: str) -> list[tuple[str, str, str]]:
    """A constants file is a sequence of `// Source:` lines, each followed by one macro, possibly continued with backslashes.
    A .c file's constants file also holds the enums that file declares for itself. An enum runs to its closing brace, blank lines
    inside it included, and its name is `enum` and its first enumerator, so it never matches a macro or a type of the tree."""
    out = []
    lines = text.splitlines()
    i = 0
    while i < len(lines):
        if lines[i].startswith("// Source:"):
            source = lines[i]
            j = i + 1
            block = []
            code = next((line for line in lines[j:] if line.strip() and not line.strip().startswith("//")), "")
            if re.match(r"\s*(typedef\s+)?enum\b", code):
                depth = 0
                opened = False
                while j < len(lines):
                    block.append(lines[j])
                    stripped = strip_comments(lines[j])
                    depth += stripped.count("{") - stripped.count("}")
                    opened = opened or "{" in stripped
                    j += 1
                    if opened and depth == 0 and ";" in stripped:
                        break
                first = re.search(r"\{\s*([A-Za-z_]\w*)", strip_comments("\n".join(block)))
                out.append((f"enum {first.group(1) if first else source}", source, "\n".join(block)))
                i = j
                continue
            while j < len(lines) and lines[j].strip():
                block.append(lines[j])
                j += 1
            m = re.match(r"\s*#\s*define\s+(\w+)", block[0]) if block else None
            if m:
                out.append((m.group(1), source, "\n".join(block)))
            i = j
        else:
            i += 1
    return out


def read_forward(root: Path) -> list[str]:
    """The forward declarations extract.py wrote for one run, without its guard, note, and includes."""
    path = root / "forward.h"
    if not path.exists():
        return []
    out = []
    for line in path.read_text().splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith(("//", "#")):
            continue
        out.append(stripped)
    return out


def read_platform(root: Path) -> list[str]:
    path = root / "platform.h"
    if not path.exists():
        return []
    return [l for l in path.read_text().splitlines() if l.startswith("#define ")]


def read_asserts(root: Path) -> dict[str, dict[str, list[str]]]:
    """The assert lines of one run, keyed by ABI and then by the type name in their message."""
    out: dict[str, dict[str, list[str]]] = defaultdict(lambda: defaultdict(list))
    path = root / "layout_asserts.h"
    if not path.exists():
        return out
    abi = ""
    for line in path.read_text().splitlines():
        block = re.match(r"#(?:el)?if .*// (\w+):", line)
        if block:
            abi = block.group(1)
            continue
        m = re.match(r'_Static_assert\(.*"([^".]+)(?:\.[^"]*)?"\);', line)
        if m and abi:
            out[abi][m.group(1)].append(line)
    return out


# ------------------------------------------------------------------ the partition

@dataclass
class Placed:
    """One type after the partition: where it lands, which header carries its text, and what it cites."""
    identity: str
    target: str
    header: Header
    extra_sources: list[str] = field(default_factory=list)
    conflict: str | None = None       # the module whose private copy this is, when modules disagree


def load_tree(tree: str, modules: list[str]) -> tuple[dict[str, dict[str, Header]], dict[str, list[str]], dict[str, dict[str, list[str]]]]:
    """headers[module][identity], platform[module], asserts[module][abi][name]."""
    headers: dict[str, dict[str, Header]] = {}
    platform: dict[str, list[str]] = {}
    asserts: dict[str, dict[str, dict[str, list[str]]]] = {}
    FORWARD.setdefault(tree, [])
    for module in modules:
        root = EXTRACT / module
        if not root.exists():
            sys.exit(f"missing {root}. Run extract.py {module} first.")
        headers[module] = {}
        manifest = json.loads((root / "extract.json").read_text()).get("files", {}) if (root / "extract.json").exists() else {}
        for path in root.rglob("*.h"):
            if path.name in ("forward.h", "platform.h", "all.h", "layout_asserts.h"):
                continue
            h = read_header(module, tree, root, path)
            h.c = manifest.get(h.rel, {}).get("c", True)
            headers[module][h.identity] = h
        platform[module] = read_platform(root)
        asserts[module] = read_asserts(root)
        for line in read_forward(root):
            if line not in FORWARD[tree]:
                FORWARD[tree].append(line)
    return headers, platform, asserts


def source_header(source_line: str) -> str:
    """The oracle header a `// Source: oracle/codemp/game/q_shared.h:2169` line names."""
    return source_line.split("Source:", 1)[1].strip().rsplit(":", 1)[0]


# The types the engine dereferences, from g_public.h and cg_public.h. Rule 12: never edited, and one size per pointer width,
# because sharedEntity_t holds pointers and is 864 bytes on a 32-bit triple and 976 on a 64-bit one by Raven's construction.
SEAM = ["sharedEntity_t", "entityShared_t", "entityState_t", "playerState_t", "usercmd_t", "trace_t", "gameState_t"]


def pointer_width(abi: str) -> str:
    return "32" if abi == "ilp32" else "64"


def check_seam_sizes(out: "Output", headers: dict[str, dict[str, Header]]) -> None:
    """Exits when a seam type, or a record it holds by value, has two sizes across the ABIs of one pointer width."""
    by_stem: dict[str, Header] = {}
    for per in headers.values():
        for identity, h in per.items():
            by_stem.setdefault(Path(identity).stem, h)
    names: set[str] = set()
    pending = list(SEAM)
    while pending:
        name = pending.pop()
        if name in names:
            continue
        names.add(name)
        h = by_stem.get(name)
        if h is None:
            continue
        # An include is a by-value dependency, because a pointer to a tagged record is satisfied by the forward header.
        pending += [Path(inc).stem for inc in h.includes if not inc.endswith("/constants.h")]
    sizes: dict[str, dict[str, str]] = defaultdict(dict)
    for target, per_abi in out.asserts.items():
        for abi, lines in per_abi.items():
            for line in lines:
                m = re.match(r'_Static_assert\(sizeof\((?:struct |union )?(\w+)\) == (\d+), ', line)
                if m and m.group(1) in names:
                    sizes[m.group(1)][abi] = m.group(2)
    bad = {}
    for name, t in sizes.items():
        for width in ("32", "64"):
            if len({size for abi, size in t.items() if pointer_width(abi) == width}) > 1:
                bad[name] = t
    if bad:
        for name, t in sorted(bad.items()):
            print(f"[error] seam type {name} has more than one size across the ABIs of one pointer width: {t}", file=sys.stderr)
        sys.exit("merge.py: a seam type must have one size per pointer width, rule 12")


def union_constants(tree: str, identity: str, versions: dict[str, Header]) -> Header:
    """One constants header per Raven header, with every macro any module of the tree saw, in Raven's line order."""
    bodies: dict[str, str] = {}
    macros: dict[str, tuple[str, str, str]] = {}
    for module, h in versions.items():
        for name, source, text in h.macros:
            key = code_key(text)
            if name in bodies and bodies[name] != key:
                sys.exit(f"merge.py: {tree} {identity}: macro {name} has two bodies across modules, and no rule places it")
            bodies[name] = key
            macros.setdefault(name, (name, source, text))
    carrier = replace(next(iter(versions.values())))
    carrier.macros = sorted(macros.values(), key=lambda m: int(m[1].rsplit(":", 1)[1]))
    return carrier


def partition_tree(tree: str, headers: dict[str, dict[str, Header]]) -> dict[str, Placed]:
    """Within one tree: every identity lands in the tree target, or in one module target when only one module emits it or modules disagree."""
    identities = set()
    for per in headers.values():
        identities |= set(per)
    placed: dict[str, Placed] = {}
    # The Raven headers each module's parse reached. A type from a header two modules see is a tree type even when only one
    # module's type closure reached it, because usercmd_t in q_shared.h is every module's type and only the game's closure holds it.
    seen_by: dict[str, set[str]] = defaultdict(set)
    for module, per in headers.items():
        for h in per.values():
            for source in h.sources:
                seen_by[source_header(source)].add(module)
    # Sorted, so the umbrella order is the same on every run.
    for identity in sorted(identities):
        versions = {m: per[identity] for m, per in headers.items() if identity in per}
        if next(iter(versions.values())).is_constants:
            carrier = next(iter(versions.values()))
            if carrier.sources and source_header(carrier.sources[0]).endswith(".c"):
                # The macros a .c file defines for itself belong to each module that compiles it, with that module's defines,
                # so bg_misc.c's MAX_POOL_SIZE is one value in the game and another in cgame. The bg parse is the game's, rule of
                # ported-types.md row 1, so it carries no copy of its own.
                for m, h in versions.items():
                    if m not in ("mp-bg", "sp-bg"):
                        placed[f"{identity}@{m}"] = Placed(identity, TARGET_OF_MODULE[m], h, conflict=m)
                continue
            # A constants file is a set of macros, not one declaration. Modules see different subsets because Raven guards some macros,
            # so the tree carries the union. A macro with two bodies has no rule yet and stops the merge.
            modules = list(versions)
            target = TARGET_OF_MODULE[modules[0]] if len(modules) == 1 else TREE_TARGET[tree]
            placed[identity] = Placed(identity, target, union_constants(tree, identity, versions))
            continue
        keys = {h.key for h in versions.values()}
        if len(keys) == 1:
            # Agreement. One module alone means a module-private header, and that module's target.
            carrier = next(iter(versions.values()))
            modules = list(versions)
            if len(modules) == 1:
                header = source_header(carrier.sources[0]) if carrier.sources else ""
                target = TREE_TARGET[tree] if len(seen_by.get(header, ())) > 1 else TARGET_OF_MODULE[modules[0]]
            else:
                target = TREE_TARGET[tree]
                # The includes of all agreeing versions are unioned, because a module may see one more forward typedef as a file.
                carrier = versions[modules[0]]
                for m in modules[1:]:
                    for inc in versions[m].includes:
                        if inc not in carrier.includes:
                            carrier.includes.append(inc)
            placed[identity] = Placed(identity, target, carrier)
        else:
            # Disagreement, such as lerpFrame_t in cg_local.h and ui_local.h. Each module keeps its own copy in its own target.
            for m, h in versions.items():
                placed[f"{identity}@{m}"] = Placed(identity, TARGET_OF_MODULE[m], h, conflict=m)
    # Closure: a tree-level type that includes a module-private type moves to that module's target.
    changed = True
    while changed:
        changed = False
        for p in list(placed.values()):
            if p.conflict is not None:
                continue
            for inc in p.header.includes:
                dep = placed.get(inc)
                if dep is None:
                    continue
                if dep.target != p.target and dep.target != TREE_TARGET[tree] and p.target == TREE_TARGET[tree]:
                    p.target = dep.target
                    changed = True
    return placed


RENAMED: list[str] = []


def drop_type_named_macros(tree: str, headers: dict[str, dict[str, Header]]) -> None:
    """A macro that names a type of the same tree goes away, because extract.py already rewrote that type to what the macro said.
    SP's g_shared.h defines thinkFunc_t as int under GAME_INCLUDE, and the modules that never see g_functions.h kept the macro."""
    type_names = set()
    for per in headers.values():
        for h in per.values():
            if not h.is_constants:
                type_names |= h.names()
    for module, per in headers.items():
        for h in per.values():
            if not h.is_constants:
                continue
            kept = []
            for n, src, text in h.macros:
                if n in type_names:
                    RENAMED.append(f"{tree} {module} {src[11:]} macro {n} dropped, the typedef of that name carries its meaning")
                else:
                    kept.append((n, src, text))
            h.macros = kept


def macro_names_in(text: str) -> set[str]:
    return set(re.findall(r"\b[A-Za-z_]\w*\b", strip_comments(text)))


def partition_shared(mp: dict[str, Placed], sp: dict[str, Placed]) -> tuple[set[str], dict[str, set[str]]]:
    """The identities shared by MP and SP, and per constants identity the shared macro names.
    A type is shared when both trees place it at tree level with the same code key, and every include and every used macro is shared."""
    shared_macros: dict[str, set[str]] = {}
    for identity, p in mp.items():
        if not p.header.is_constants or identity not in sp:
            continue
        mp_macros = {n: code_key(t) for n, _, t in p.header.macros}
        sp_macros = {n: code_key(t) for n, _, t in sp[identity].header.macros}
        shared_macros[identity] = {n for n in mp_macros if n in sp_macros and mp_macros[n] == sp_macros[n]}

    candidates = set()
    for identity, p in mp.items():
        q = sp.get(identity)
        if q is None or p.header.is_constants or p.conflict or q.conflict:
            continue
        if p.target != "CJKAMP" or q.target != "CJKASP" or not p.header.c or not q.header.c:
            continue
        if p.header.key == q.header.key:
            candidates.add(identity)

    all_macro_names: dict[str, str] = {}
    for identity, p in mp.items():
        if p.header.is_constants:
            for n, _, _ in p.header.macros:
                all_macro_names[n] = identity

    # The enumerators each enum header declares, so a macro body that names one is tied to that enum's placement.
    enumerator_of: dict[str, str] = {}
    for identity, p in mp.items():
        if p.header.is_constants or not re.search(r"\benum\b", strip_comments(p.header.body)):
            continue
        for m in re.finditer(r"^\s*([A-Za-z_]\w*)\s*(?:=|,|$)", strip_comments(p.header.body), re.M):
            enumerator_of.setdefault(m.group(1), identity)

    def macro_is_shared(name: str) -> bool:
        return name in shared_macros.get(all_macro_names.get(name, ""), set())

    changed = True
    while changed:
        changed = False
        for identity in list(candidates):
            h = mp[identity].header
            for inc in h.includes:
                if inc.endswith("/constants.h"):
                    continue
                if inc not in candidates:
                    candidates.discard(identity)
                    changed = True
                    break
            else:
                used = macro_names_in(h.body) & set(all_macro_names)
                for n in used:
                    if not macro_is_shared(n):
                        candidates.discard(identity)
                        changed = True
                        break
        # A shared macro whose body names a tree macro or a tree enumerator is a tree macro, because the Swift re-export of a shared
        # macro is an expression over the same names and JKAShared cannot see JKAMP.
        for identity, p in mp.items():
            if not p.header.is_constants or identity not in shared_macros:
                continue
            for n, _, text in p.header.macros:
                if n not in shared_macros[identity]:
                    continue
                for used in macro_names_in(text) - {n}:
                    if (used in all_macro_names and not macro_is_shared(used)) or (used in enumerator_of and enumerator_of[used] not in candidates):
                        shared_macros[identity].discard(n)
                        changed = True
                        break
    return candidates, shared_macros


# ------------------------------------------------------------------ writing

NOTE = "// Generated by tools/oracle-closure/merge.py from the extract.py trees. Raven's text, one declaration per file. Do not edit until adopted.\n"


def guard(path: str) -> str:
    return "JKA_" + re.sub(r"\W", "_", path).upper()


def wrap(path: str, includes: list[str], system: list[str], body_parts: list[str]) -> str:
    parts = [NOTE, f"#ifndef {guard(path)}", f"#define {guard(path)}", ""]
    parts += [f'#include "{inc}"' for inc in includes]
    if includes:
        parts.append("")
    parts += system
    if system:
        parts.append("")
    parts += body_parts
    parts += [f"#endif // {guard(path)}", ""]
    return "\n".join(parts)


class Output:
    def __init__(self, out_dir: Path):
        self.out_dir = out_dir
        self.files: dict[str, dict[str, str]] = defaultdict(dict)      # target -> rel path -> content
        self.location: dict[str, tuple[str, str]] = {}                 # identity (or identity@module) -> (target, rel path)
        self.asserts: dict[str, dict[str, list[str]]] = defaultdict(lambda: defaultdict(list))   # target -> abi -> lines
        self.tags: dict[str, list[str]] = defaultdict(list)
        self.order: dict[str, list[str]] = defaultdict(list)
        self.cxx: dict[str, list[str]] = defaultdict(list)
        self.units: dict[str, str] = {}                                # target -> the <Target>.c translation unit

    def path_for(self, target: str, tree: str | None, identity: str) -> str:
        if target == SHARED:
            return f"shared/{identity}"
        return f"{TREE_PREFIX[tree]}{identity}"

    def include_for(self, identity: str, tree: str, module: str | None) -> str | None:
        """Where an included identity landed: the module's private copy first, then the tree, then shared."""
        for key in ([f"{identity}@{module}"] if module else []) + [f"{identity}@{tree}", identity]:
            if key in self.location:
                return self.location[key][1]
        return None


def emit(out_dir: Path, mp_modules: list[str], sp_modules: list[str]) -> int:
    mp_headers, mp_platform, mp_asserts = load_tree("mp", mp_modules)
    sp_headers, sp_platform, sp_asserts = load_tree("sp", sp_modules)
    drop_type_named_macros("mp", mp_headers)
    drop_type_named_macros("sp", sp_headers)
    mp = partition_tree("mp", mp_headers)
    sp = partition_tree("sp", sp_headers)
    shared, shared_macros = partition_shared(mp, sp)

    out = Output(out_dir)

    # Where everything lands, before any text is written, so includes can be rewritten.
    for identity in shared:
        out.location[identity] = (SHARED, f"shared/{identity}")
    for tree, placed in (("mp", mp), ("sp", sp)):
        for key, p in placed.items():
            if p.identity in shared and p.conflict is None and not p.header.is_constants:
                continue
            rel = f"{TREE_PREFIX[tree]}{p.identity}"
            if p.conflict:
                out.location[f"{p.identity}@{p.conflict}"] = (p.target, rel)
            else:
                out.location[f"{p.identity}@{tree}"] = (p.target, rel)
                out.location.setdefault(p.identity, (p.target, rel))

    # Constants: the shared macros of a header go to CJKAShared, and the rest stay in the tree target.
    for tree, placed, tree_target in (("mp", mp, "CJKAMP"), ("sp", sp, "CJKASP")):
        for key, p in placed.items():
            if not p.header.is_constants:
                continue
            shared_names = shared_macros.get(p.identity, set()) if p.conflict is None else set()
            own = [(n, s, t) for n, s, t in p.header.macros if n not in shared_names]
            if own or p.conflict:
                rel = f"{TREE_PREFIX[tree]}{p.identity}"
                body = []
                for n, s, t in own:
                    body += [s, t, ""]
                out.files[p.target][rel] = wrap(rel, [], [], body)
                out.order[p.target].append(rel)
            if tree == "mp" and shared_names and p.conflict is None:
                rel = f"shared/{p.identity}"
                sp_sources = {n: s for n, s, _ in sp[p.identity].header.macros}
                body = []
                for n, s, t in p.header.macros:
                    if n in shared_names:
                        body += [s, sp_sources[n], t, ""]
                out.files[SHARED][rel] = wrap(rel, [], [], body)
                out.order[SHARED].append(rel)
                out.location[p.identity + "#shared"] = (SHARED, rel)

    # Types.
    for tree, placed, asserts in (("mp", mp, mp_asserts), ("sp", sp, sp_asserts)):
        for key, p in placed.items():
            h = p.header
            if h.is_constants:
                continue
            is_shared = p.identity in shared and p.conflict is None
            if is_shared and tree == "sp":
                continue
            target = SHARED if is_shared else p.target
            rel = out.location[p.identity if is_shared else (f"{p.identity}@{p.conflict}" if p.conflict else f"{p.identity}@{tree}")][1]
            includes = []
            for inc in h.includes:
                if inc.endswith("/constants.h"):
                    for cand in ([out.location.get(inc + "#shared")] if not is_shared else []) + [out.location.get(inc + "#shared")] if is_shared else [out.location.get(inc + "#shared"), (None, f"{TREE_PREFIX[tree]}{inc}")]:
                        if cand and cand[1] and cand[1] not in includes and (cand[0] is not None or any(f"{TREE_PREFIX[tree]}{inc}" in files for files in out.files.values())):
                            includes.append(cand[1])
                    continue
                target_rel = out.include_for(inc, tree, p.conflict or h.module)
                if target_rel and target_rel not in includes:
                    includes.append(target_rel)
            includes.append(f"{target}_forward.h")
            sources = list(h.sources)
            if is_shared:
                sources += [s for s in sp[p.identity].header.sources if s not in sources]
            body = sources + [h.body, ""]
            out.files[target][rel] = wrap(rel, sorted(includes), h.system, body)
            if not h.c:
                out.cxx[target].append(rel)
                continue
            out.order[target].append(rel)
            # Asserts follow the type. A shared type must agree in both parses.
            for name in h.names():
                for abi, table in asserts[h.module].items():
                    lines = table.get(name, [])
                    if is_shared:
                        sp_lines = sp_asserts[sp[p.identity].header.module].get(abi, {}).get(name, [])
                        if sp_lines and lines and sp_lines != lines:
                            print(f"[error] shared type {name} has different asserts in MP and SP for {abi}", file=sys.stderr)
                    out.asserts[target][abi] += lines
            m = re.search(r"^(struct|union|enum)\s+(\w+)\s*\{", strip_comments(h.body), re.M)
            if m:
                out.tags[target].append(f"{m.group(1)} {m.group(2)};")
            for m in re.finditer(r"^typedef\s+(struct|union|enum)\s+(\w+)\s+(\w+);", h.body, re.M):
                if m.group(2) != m.group(3):
                    out.tags[target].append(f"{m.group(1)} {m.group(2)};")
                    out.tags[target].append(m.group(0))

    # forward, platform, all, and asserts per target.
    for target in TARGET_DEPS:
        if target not in out.files and target not in out.tags:
            continue
        deps = TARGET_DEPS[target]
        forward = [f'#include "{d}_forward.h"' for d in deps] + [f'#include "{target}_platform.h"', ""]
        shared_lines = [l for l in FORWARD.get("mp", []) if l in FORWARD.get("sp", [])]
        if target == SHARED:
            forward += shared_lines
        elif target in TREE_TARGET.values():
            tree_key = "mp" if target == "CJKAMP" else "sp"
            forward += [l for l in FORWARD.get(tree_key, []) if l not in shared_lines]
        out.files[target][f"{target}_forward.h"] = wrap(f"{target}_forward.h", [], [], forward + [""])
        tree = "mp" if "MP" in target else "sp" if "SP" in target else None
        if tree is None:
            defines = sorted(set.intersection(*(set(v) for v in mp_platform.values())) & set.intersection(*(set(v) for v in sp_platform.values())))
        else:
            source = mp_platform if tree == "mp" else sp_platform
            defines = sorted(set().union(*(set(v) for v in source.values())))
            shared_defines = set.intersection(*(set(v) for v in mp_platform.values())) & set.intersection(*(set(v) for v in sp_platform.values()))
            defines = [d for d in defines if d not in shared_defines]
        out.files[target][f"{target}_platform.h"] = wrap(f"{target}_platform.h", [], [], ["// The spellings the parse supplied for the platform section Raven never wrote for this host."] + defines + [""])
        ordered = [f"{target}_forward.h"] + [r for r in out.order[target] if r.endswith("/constants.h")] + [r for r in out.order[target] if not r.endswith("/constants.h")]
        # A hand-written header beside the umbrella declares Raven's tables the target compiles as C storage, bg_tables.c for the MP tree.
        ordered += HAND_HEADERS.get(target, [])
        # The umbrella carries the target's name, because SwiftPM and the Swift importer read it as the module.
        umbrella = [
            "// Raven wrote typedef enum { ... }; with no name in bg_weapons.h and its kin, and the copies keep the text verbatim.",
            '#pragma clang diagnostic ignored "-Wmissing-declarations"',
            "",
        ] + [f'#include "{inc}"' for inc in [f"{d}.h" for d in deps] + ordered] + [""]
        out.files[target][f"{target}.h"] = wrap(f"{target}.h", [], [], umbrella)
        blocks = abi_blocks({abi: out.asserts[target][abi] for abi in ABIS if abi in out.asserts[target]}, list(TRIPLES))
        out.files[target]["layout_asserts.h"] = wrap("layout_asserts.h", [], ["#include <stddef.h>", f'#include "{target}.h"'], [""] + blocks + [""])
        out.files[target]["module.modulemap"] = "\n".join([
            "// Explicit, because the mirrored oracle directories sit beside the umbrella and SwiftPM's automatic layout does not allow that.",
            f"module {target} {{",
            f'    umbrella header "{target}.h"',
            "    export *",
            "}",
            "",
        ])
        out.units[target] = "\n".join([
            "// SwiftPM needs one translation unit per C target. This one compiles the umbrella and the layout asserts on every build.",
            f'#include "{target}.h"',
            '#include "layout_asserts.h"',
            "",
        ])

    check_seam_sizes(out, mp_headers)

    # Write.
    # The include directory holds only what the umbrella includes, because Clang warns on every header a module leaves out.
    # layout_asserts.h sits beside the translation unit, and a C++ only header sits under cxx/ for reference.
    for target, files in out.files.items():
        base = out_dir / target
        # The hand-written C storage and its header survive the rewrite, merge.py never generates them.
        kept = {rel: (base / rel).read_bytes() for rel in HAND_FILES.get(target, []) if (base / rel).exists()}
        if base.exists():
            shutil.rmtree(base)
        for rel, content in files.items():
            if rel == "layout_asserts.h":
                path = base / rel
            elif rel in out.cxx[target]:
                path = base / "cxx" / rel
            else:
                path = base / "include" / rel
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content)
        (base / f"{target}.c").write_text(out.units[target])
        for rel, data in kept.items():
            (base / rel).parent.mkdir(parents=True, exist_ok=True)
            (base / rel).write_bytes(data)
    manifest = {"shared": sorted(shared), "targets": {t: sorted(f for f in files) for t, files in out.files.items()}, "cxx_only": {t: sorted(v) for t, v in out.cxx.items()}}
    (HERE / "out" / "merge.json").write_text(json.dumps(manifest, indent=1))

    # Report.
    print(f"{'target':14} {'types':>6} {'C++ only':>9} {'constants':>10} {'asserts':>8}")
    for target in TARGET_DEPS:
        files = out.files.get(target, {})
        types = sum(1 for f in files if f.startswith(("shared/", "codemp/", "code/", "ui/")) and not f.endswith("/constants.h"))
        consts = sum(1 for f in files if f.endswith("/constants.h"))
        abis = out.asserts.get(target, {})
        per = max((len(v) for v in abis.values()), default=0)
        print(f"{target:14} {types:6} {len(out.cxx.get(target, [])):9} {consts:10} {per:8} x {len(abis)} ABIs")
    same_name = {p.identity for p in mp.values()} & {p.identity for p in sp.values()}
    split = sorted(i for i in same_name if i not in shared and not i.endswith("/constants.h"))
    print(f"{len(shared)} identities shared by MP and SP, {len(split)} same-named identities kept per tree")
    if RENAMED:
        print(f"{len(RENAMED)} macros dropped because a type of the same tree has their name:")
        for line in sorted(set(RENAMED)):
            print(f"  {line}")
    placed_all = list(mp.values()) + list(sp.values())
    conflicts = sorted({p.identity for p in placed_all if p.conflict and not p.identity.endswith("_c/constants.h")})
    if conflicts:
        print(f"{len(conflicts)} identities defined differently by two modules of one tree: {', '.join(conflicts)}")
    c_constants = {p.identity for p in placed_all if p.identity.endswith("_c/constants.h")}
    if c_constants:
        print(f"{len(c_constants)} .c files' own macros placed per module")
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--mp", nargs="+", default=MP_MODULES)
    ap.add_argument("--sp", nargs="+", default=SP_MODULES)
    ap.add_argument("--out", default=str(HERE / "out" / "merge"))
    args = ap.parse_args()
    out_dir = Path(args.out)
    out_dir.mkdir(parents=True, exist_ok=True)
    sys.exit(emit(out_dir, args.mp, args.sp))


if __name__ == "__main__":
    main()
