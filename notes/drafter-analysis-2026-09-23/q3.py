"""Q3: facts keyed by name, and the AST shape at the unity-parse call errors."""
import sys, re, collections
sys.path.insert(0, "/Users/milohehmsoth/Developer/Milo/jka-swift/tools/oracle-closure")
import closure as C
import clang.cindex as ci
from clang.cindex import CursorKind, TypeKind
from pathlib import Path
from skeleton import Skeleton
from fnsweep import ASSIGN_OPS

parse = C.Parse()
sk = Skeleton(parse)
T = sk.table
GAME = parse.game_folder; CG = parse.cgame_folder; UI = (C.ORACLE / "codemp/ui").resolve()

# 0. the AST at the call errors
print("==== 0 call-error sites in the game unit")
errs = [d for d in parse.game.diagnostics if d.severity >= ci.Diagnostic.Error and "arguments to function call" in d.spelling]
want = {(Path(d.location.file.name).name, d.location.line, d.location.column) for d in errs}
seen = collections.Counter()
examples = {}
for cur in parse.game.cursor.get_children():
    if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file: continue
    fname = Path(cur.location.file.name).name
    if not any(w[0] == fname for w in want): continue
    for n in cur.walk_preorder():
        key = (fname, n.location.line, n.location.column)
        if n.location.file and key in want and n.kind.is_expression():
            kids = list(n.get_children())
            ref = n.referenced
            desc = (n.kind.name, ref.kind.name if ref else None, ref.spelling if ref else None, len(kids), n.type.spelling)
            seen[desc[:2]] += 1
            examples.setdefault(desc[:2], (fname, n.location.line, desc))
print(" kinds at the error locations:", dict(seen))
for k, v in examples.items(): print("  ", v)
# does the NULL sweep's walk see a CALL_EXPR with a FUNCTION_DECL referenced at those lines
calls_at = collections.Counter()
for cur in parse.game.cursor.get_children():
    if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file: continue
    fname = Path(cur.location.file.name).name
    lines = {w[1] for w in want if w[0] == fname}
    if not lines: continue
    for n in cur.walk_preorder():
        if n.kind == CursorKind.CALL_EXPR and n.location.line in lines and n.referenced is not None and n.referenced.kind == CursorKind.FUNCTION_DECL:
            calls_at[(n.referenced.spelling, len(list(n.referenced.get_arguments())), len(list(n.get_children())) - 1)] += 1
print(" sweep-visible calls on those lines (callee, declared params, args):", dict(calls_at.most_common(20)))

# 1. one name, several stems
print("==== 1 names defined in more than one stem")
by = collections.defaultdict(list)
for stem, fns in sk.files.items():
    for fn in fns: by[fn.name].append(fn)
multi = {n: fs for n, fs in by.items() if len(fs) > 1}
def stores_of(cur, data):
    names = {p.spelling for p in cur.get_arguments()}; out = set()
    for node in cur.walk_preorder():
        if node.kind not in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR): continue
        kids = list(node.get_children())
        if len(kids) != 2: continue
        if data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip() not in ASSIGN_OPS: continue
        t = T.store_target(T.unwrapped(kids[0]), data)
        if t in names: out.add(t)
    return out
for n, fs in sorted(multi.items()):
    sigs = []
    for fn in fs:
        data = C.parsed_bytes(Path(fn.cur.location.file.name).resolve())
        own = stores_of(fn.cur, data)
        merged = {p for (o, p) in T.stores_through if o == n}
        sigs.append((fn.stem, fn.cur.location.line, [p.spelling for p in fn.cur.get_arguments()], sorted(own), [f"{p.name}:{p.swift}" for p in fn.params],
                     "static" if fn.cur.storage_class == ci.StorageClass.STATIC else "extern"))
    facts = {"nullable": sorted(p for (o, p) in T.nullable if o == n), "stores": sorted(p for (o, p) in T.stores_through if o == n),
             "indexed": sorted(p for (o, p) in T.indexed_params if o == n), "readonly_text": sorted(p for (o, p) in T.readonly_text if o == n),
             "called": n in T.called}
    print(f" {n}: {facts}")
    for s in sigs: print("     ", s)
# which definition a call or an address-of binds to in the unity unit
print("==== 1b references to a shared name, and the stem of the declaration they bind to")
bind = collections.Counter()
for cur in parse.game.cursor.get_children():
    if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file: continue
    path = Path(cur.location.file.name).resolve()
    if path.parent != GAME: continue
    for n in cur.walk_preorder():
        if n.kind == CursorKind.DECL_REF_EXPR and n.spelling in multi and n.referenced is not None:
            d = n.referenced.get_definition()
            target = Path(d.location.file.name).stem if d is not None and d.location.file else "<none>"
            bind[(path.stem, cur.spelling, n.spelling, target)] += 1
for k, v in sorted(bind.items()): print("  ", k, v)

# 2. names the cgame unit defines outside the game folder that a game-module function also has
print("==== 2 cgame-unit definitions outside the game folder with a game-module name")
cg_defs = {}
for cur in parse.cgame.cursor.get_children():
    if cur.kind == CursorKind.FUNCTION_DECL and cur.is_definition() and cur.location.file:
        p = Path(cur.location.file.name).resolve()
        if p.parent in (CG, UI) and cur.spelling in sk.by_name:
            cg_defs[cur.spelling] = (p.stem, [a.spelling for a in cur.get_arguments()], [a.spelling for a in sk.by_name[cur.spelling].cur.get_arguments()])
print("  count", len(cg_defs))
game_called = set()
game_null = set()
for cur in parse.game.cursor.get_children():
    if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file: continue
    if Path(cur.location.file.name).resolve().parent != GAME: continue
    for n in cur.walk_preorder():
        if n.kind == CursorKind.CALL_EXPR and n.referenced is not None and n.referenced.kind == CursorKind.FUNCTION_DECL:
            game_called.add(n.referenced.spelling)
only_cg_called = sorted(n for n in cg_defs if n not in game_called and n in T.called)
print("  game-module functions no game call reaches, 'called' only by the cgame unit's own function of that name:", only_cg_called)
diffparams = sorted((n, v) for n, v in cg_defs.items() if v[1] != v[2])
print("  same name, different parameter names:", len(diffparams))
for n, v in diffparams[:30]: print("    ", n, v)
cg_only_pairs = []
for (o, p) in sorted(T.nullable):
    if o in cg_defs:
        cg_only_pairs.append((o, p))
print("  nullable pairs on a name the cgame unit also defines:", cg_only_pairs[:40])
cg_idx = sorted((o, p) for (o, p) in T.indexed_params if o in cg_defs)
print("  indexed pairs on such a name:", cg_idx)

# 3. NEVER_NULL_VARS name on a parameter or a local
print("==== 3 a parameter or a local named pm in a game-module function")
for stem, fns in sorted(sk.files.items()):
    for fn in fns:
        decls = [c for c in fn.cur.walk_preorder() if c.kind in (CursorKind.PARM_DECL, CursorKind.VAR_DECL) and c.spelling == "pm"]
        if decls:
            print("  ", stem, fn.name, [(c.kind.name, c.type.spelling, c.location.line) for c in decls])

# 4. one name, two declarations in one function
print("==== 4 functions with two declarations of one name (param shadowed, sibling locals, local over a global)")
rows = []
globals_by_name = {c.spelling for c in parse.game.cursor.get_children() if c.kind == CursorKind.VAR_DECL}
for stem, fns in sorted(sk.files.items()):
    for fn in fns:
        decls = collections.defaultdict(list)
        for c in fn.cur.walk_preorder():
            if c.kind in (CursorKind.PARM_DECL, CursorKind.VAR_DECL) and c.semantic_parent is not None and c.semantic_parent.kind == CursorKind.FUNCTION_DECL \
                    and c.semantic_parent.spelling == fn.name:
                decls[c.spelling].append(c)
        data = C.parsed_bytes(Path(fn.cur.location.file.name).resolve())
        facts = T.locals_of(stem, fn.name)
        for name, ds in decls.items():
            shadow_global = name in globals_by_name and any(d.kind == CursorKind.VAR_DECL for d in ds)
            if len(ds) < 2 and not shadow_global: continue
            # per-declaration write counts
            counts = collections.Counter(); ref_global_writes = 0
            for n in fn.cur.walk_preorder():
                kids = list(n.get_children())
                tgt = None
                if n.kind in (CursorKind.BINARY_OPERATOR, CursorKind.COMPOUND_ASSIGNMENT_OPERATOR) and len(kids) == 2:
                    if data[kids[0].extent.end.offset:kids[1].extent.start.offset].decode("utf-8", "replace").strip() in ASSIGN_OPS:
                        tgt = T.unwrapped(kids[0])
                        while tgt.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR: tgt = T.unwrapped(list(tgt.get_children())[0])
                elif n.kind == CursorKind.UNARY_OPERATOR and kids and T.steps_or_addresses(n, kids[0], data):
                    tgt = T.unwrapped(kids[0])
                    while tgt.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR: tgt = T.unwrapped(list(tgt.get_children())[0])
                if tgt is not None and tgt.kind == CursorKind.DECL_REF_EXPR and tgt.spelling == name and tgt.referenced is not None:
                    r = tgt.referenced
                    idx = next((i for i, d in enumerate(ds) if d == r), None)
                    if idx is None: ref_global_writes += 1
                    else: counts[idx] += 1
            info = [(d.kind.name[:4], d.location.line, "init" if any(k.kind.is_expression() for k in d.get_children()) and d.kind == CursorKind.VAR_DECL else "", counts[i]) for i, d in enumerate(ds)]
            rows.append((stem, fn.name, name, info, ref_global_writes, name in facts.written, name in facts.single_writes, name in facts.addressed,
                         name in sk.table.locals_of(stem, fn.name).rows))
print("  count", len(rows))
kinds = collections.Counter()
for r in rows:
    stem, fname, name, info, gw, written, single, addressed, row = r
    parm = [i for i in info if i[0] == "PARM"]
    tag = []
    if parm and parm[0][3] == 0 and written: tag.append("param copy for an unassigned parameter")
    if any(i[0] == "VAR_" and i[2] == "" and i[3] == 0 for i in info) and single: tag.append("let for a local with no write of its own")
    if any(i[0] == "VAR_" and i[2] == "init" and i[3] == 0 for i in info) and written: tag.append("var for an initialized local never written")
    if gw and any(i[0] == "VAR_" for i in info): tag.append("global written beside a local of its name")
    if row: tag.append("cursor or table row keyed by the name")
    for t in tag: kinds[t] += 1
    print("  ", stem, fname, name, info, "globalwrites", gw, "written", written, "single", single, "addr", addressed, "|", "; ".join(tag))
print("  tags:", dict(kinds))
