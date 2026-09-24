"""Q2: proof scope and consequence."""
import sys, re, collections
sys.path.insert(0, "/Users/milohehmsoth/Developer/Milo/jka-swift/tools/oracle-closure")
import closure as C
import clang.cindex as ci
from clang.cindex import CursorKind, TypeKind
from pathlib import Path
from skeleton import Skeleton
from overlay import OVERLAY

parse = C.Parse()
sk = Skeleton(parse)
T = sk.table
ui = C.parse_tu("mp-ui", None, unity=True, overlay=OVERLAY)
GAME = parse.game_folder; CG = parse.cgame_folder; UI = (C.ORACLE / "codemp/ui").resolve()

def unwrap(c):
    while c.kind in (CursorKind.UNEXPOSED_EXPR, CursorKind.PAREN_EXPR) and list(c.get_children()):
        c = list(c.get_children())[0]
    return c

def text_of(c, data):
    return data[c.extent.start.offset:c.extent.end.offset].decode("utf-8", "replace").strip()

def shape(callee, pname):
    fn = sk.by_name.get(callee)
    if fn is None: return None
    for p in fn.params:
        if p.name == pname: return (p.swift, p.kind)
    return ("<no stub param>", fn.reason)

def trap_shape(callee, pname):
    for cur in parse.game.cursor.get_children():
        pass
    return None

# game definitions of traps, for shape
trap_defs = {}
for cur in parse.game.cursor.get_children():
    if cur.kind == CursorKind.FUNCTION_DECL and cur.is_definition() and cur.spelling.startswith("trap_") and cur.location.file \
            and Path(cur.location.file.name).resolve().parent == GAME:
        trap_defs[cur.spelling] = cur
def any_shape(callee, pname):
    s = shape(callee, pname)
    if s is not None: return s
    d = trap_defs.get(callee)
    if d is None: return None
    ps = list(d.get_arguments())
    for i, p in enumerate(ps):
        if p.spelling == pname:
            m = T.param(p, ps[i + 1] if i + 1 < len(ps) else None, traps=True, owner=callee)
            return (m.swift, m.kind) if m else ("<unmapped>", None)
    return None

def def_params(ref):
    d = ref.get_definition()
    if d is None and ref.spelling in sk.by_name:
        d = sk.by_name[ref.spelling].cur
    if d is None and ref.spelling in trap_defs:
        d = trap_defs[ref.spelling]
    return list(d.get_arguments()) if d is not None else None

sites = []   # dicts
edges = []   # (caller, caller_param) -> (callee, def_name), with site
units = [("game", parse.game, {GAME}, True), ("cgame", parse.cgame, {GAME, CG}, True),
         ("cgame:ui_shared", parse.cgame, {UI}, False), ("ui", ui, {UI}, False), ("ui:bg-arm", ui, {GAME}, False)]
for uname, tu, folders, swept in units:
    for cur in tu.cursor.get_children():
        if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file:
            continue
        path = Path(cur.location.file.name).resolve()
        if path.parent not in folders or path.suffix != ".c":
            continue
        if uname == "ui:bg-arm" and not path.name.startswith("bg_"):
            continue
        data = C.parsed_bytes(path)
        # locals assigned NULL or 0 anywhere
        null_locals = set()
        for n in cur.walk_preorder():
            if n.kind == CursorKind.VAR_DECL and n.semantic_parent is not None and n.semantic_parent.kind == CursorKind.FUNCTION_DECL:
                kids = [k for k in n.get_children() if k.kind.is_expression()]
                if kids and text_of(unwrap(kids[-1]), data) in ("NULL", "0") and T.takes_null(n.type):
                    null_locals.add(n.spelling)
            if n.kind == CursorKind.BINARY_OPERATOR:
                k = list(n.get_children())
                if len(k) == 2 and data[k[0].extent.end.offset:k[1].extent.start.offset].decode("utf-8", "replace").strip() == "=":
                    l = unwrap(k[0])
                    if l.kind == CursorKind.DECL_REF_EXPR and l.referenced is not None and l.referenced.kind == CursorKind.VAR_DECL \
                            and T.takes_null(l.type) and text_of(unwrap(k[1]), data) in ("NULL", "0"):
                        null_locals.add(l.spelling)
        for node in cur.walk_preorder():
            if node.kind != CursorKind.CALL_EXPR or node.referenced is None or node.referenced.kind != CursorKind.FUNCTION_DECL:
                continue
            ref = node.referenced
            proto = list(ref.get_arguments())
            dps = def_params(ref)
            args = list(node.get_children())[1:]
            for i, arg in enumerate(args):
                if i >= len(proto) or not T.takes_null(proto[i].type):
                    continue
                text = text_of(arg, data)
                u = unwrap(arg)
                pname = proto[i].spelling
                dname = dps[i].spelling if dps is not None and i < len(dps) else None
                kind = None
                if text in ("NULL", "0"):
                    kind = "literal"
                elif re.search(r"\bNULL\b", text) and u.kind in (CursorKind.CSTYLE_CAST_EXPR, CursorKind.CONDITIONAL_OPERATOR) or re.fullmatch(r"\(\s*[\w\s\*]+\)\s*\(?\s*(NULL|0)\s*\)?", text):
                    kind = "cast-or-ternary"
                elif u.kind == CursorKind.DECL_REF_EXPR and u.referenced is not None and u.referenced.kind == CursorKind.PARM_DECL:
                    edges.append(((cur.spelling, u.spelling), (ref.spelling, dname), (uname, path.stem, cur.spelling, node.location.line, text)))
                    continue
                elif u.kind == CursorKind.DECL_REF_EXPR and u.spelling in null_locals and u.referenced is not None \
                        and u.referenced.kind == CursorKind.VAR_DECL and u.referenced.semantic_parent is not None \
                        and u.referenced.semantic_parent.kind == CursorKind.FUNCTION_DECL:
                    kind = "local-set-null"
                if kind:
                    sites.append(dict(unit=uname, swept=swept, stem=path.stem, caller=cur.spelling, line=node.location.line,
                                      callee=ref.spelling, i=i, proto=pname, def_=dname, kind=kind, text=text,
                                      call=" ".join(text_of(node, data).split())[:140]))

nullable = T.nullable
print("sweep nullable pairs", len(nullable), "called", len(T.called))
def report(title, rows):
    print(f"==== {title}: {len(rows)}")
    for r in rows[:60]:
        print("  ", r)

# A. literal NULL seen by the sweep, keyed under the prototype name, while the definition names the parameter differently
mism = [s for s in sites if s["kind"] == "literal" and s["swept"] and s["def_"] and s["proto"] != s["def_"]
        and (s["callee"], s["def_"]) not in nullable]
report("A literal NULL under a prototype name the definition does not use (pair lost)",
       sorted({(s["callee"], s["proto"], s["def_"], any_shape(s["callee"], s["def_"]), f'{s["stem"]}:{s["line"]}', s["call"]) for s in mism}))
# B. ui scope
uim = [s for s in sites if not s["swept"] and s["def_"] and (s["callee"], s["def_"]) not in nullable and s["kind"] == "literal"
       and (s["callee"] in sk.by_name)]
report("B literal NULL from ui call sites into a game-module function, pair not nullable",
       sorted({(s["unit"], s["callee"], s["def_"], any_shape(s["callee"], s["def_"]), f'{s["stem"]}:{s["line"]}', s["call"]) for s in uim}))
# C. cast or ternary NULL
cm = [s for s in sites if s["kind"] == "cast-or-ternary" and s["def_"] and (s["callee"], s["def_"]) not in nullable and (s["callee"] in sk.by_name or s["callee"] in trap_defs)]
report("C NULL in a cast or a ternary arm, pair not nullable",
       sorted({(s["unit"], s["callee"], s["def_"], any_shape(s["callee"], s["def_"]), f'{s["stem"]}:{s["line"]}', s["text"]) for s in cm}))
# D. local set to NULL and passed
lm = [s for s in sites if s["kind"] == "local-set-null" and s["def_"] and (s["callee"], s["def_"]) not in nullable and s["callee"] in sk.by_name]
lm_pairs = sorted({(s["callee"], s["def_"]) for s in lm})
print(f"==== D local set to NULL somewhere in the caller, passed as the argument, pair not nullable: sites {len(lm)} pairs {len(lm_pairs)}")
for p in lm_pairs[:40]:
    ex = next(s for s in lm if (s["callee"], s["def_"]) == p)
    print("  ", p, any_shape(*p), f'{ex["unit"]} {ex["stem"]}:{ex["line"]} {ex["caller"]}', ex["call"])
# E. transitive: a nullable parameter forwarded as the argument
base = set(nullable) | {(s["callee"], s["def_"]) for s in sites if s["def_"] and s["kind"] in ("literal", "cast-or-ternary")}
closure_set = set(base)
grew = True
while grew:
    grew = False
    for (src, dst, site) in edges:
        if dst[1] and src in closure_set and dst not in closure_set:
            closure_set.add(dst); grew = True
trans = sorted(p for p in closure_set - base if p[0] in sk.by_name)
print(f"==== E pairs a nullable parameter reaches by forwarding, not nullable in the sweep: {len(trans)}")
for p in trans[:80]:
    ex = next(e for e in edges if e[1] == p and e[0] in closure_set)
    print("  ", p, any_shape(*p), "via", ex[0], ex[2])
# F. nullable pairs whose Swift shape is still a value
vals = []
for (callee, pname) in sorted(nullable):
    s = any_shape(callee, pname)
    if s and s[0] and not s[0].endswith("?") and s[1] not in (None,):
        vals.append((callee, pname, s))
kinds = collections.Counter(v[2][1] for v in vals)
print(f"==== F nullable pairs whose Swift parameter is not optional: {len(vals)} by kind {dict(kinds)}")
for v in vals: print("  ", v)
# Missed-pair folds in the corpus: a plain comment that claims the proof
allmiss = {(s["callee"], s["def_"]) for s in mism + uim + cm + lm} | set(trans)
print("==== G silent folds over a missed pair (plain comment, no Port-note) in the corpus")
D = Path("/tmp/jka-analysis/drafts")
drafts = {p.stem: p.read_text() for p in D.glob("*.swift")}
for callee, pname in sorted(allmiss):
    fn = sk.by_name.get(callee)
    if fn is None: continue
    text = drafts.get(fn.stem, "")
    m = re.search(r"^func " + re.escape(callee) + r"\(.*?(?=^/// Source:|\Z)", text, re.S | re.M)
    if not m: continue
    body = m.group(0)
    for kw in (f"Raven's NULL test on {pname} has no form here, and the arm it guards is gone.", f"Raven tests `{pname}` for NULL here", f"Raven guards a NULL `{pname}` here"):
        c = body.count(kw)
        if c: print(f"   {fn.stem} {callee} {pname}: {c} x '{kw[:60]}'")

# H. the pm global: bg functions that read it, and entries from outside Pmove
for uname, tu in (("game", parse.game), ("cgame", parse.cgame), ("ui", ui)):
    graph = collections.defaultdict(set); reads = set(); file_of = {}; sites_of = collections.defaultdict(list)
    for cur in tu.cursor.get_children():
        if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file: continue
        file_of[cur.spelling] = Path(cur.location.file.name).resolve()
        for n in cur.walk_preorder():
            if n.kind == CursorKind.DECL_REF_EXPR and n.spelling == "pm" and n.referenced is not None and n.referenced.kind == CursorKind.VAR_DECL \
                    and n.referenced.semantic_parent is not None and n.referenced.semantic_parent.kind == CursorKind.TRANSLATION_UNIT:
                reads.add(cur.spelling)
            if n.kind == CursorKind.CALL_EXPR and n.referenced is not None:
                graph[cur.spelling].add(n.referenced.spelling)
                sites_of[(cur.spelling, n.referenced.spelling)].append(n.location.line)
    R = set(); stack = ["Pmove"]
    while stack:
        f = stack.pop()
        if f in R: continue
        R.add(f); stack += list(graph.get(f, ()))
    rev = collections.defaultdict(set)
    for f, cs in graph.items():
        for c in cs: rev[c].add(f)
    Pstar = set(); stack = list(reads)
    while stack:
        f = stack.pop()
        if f in Pstar: continue
        Pstar.add(f); stack += list(rev.get(f, ()))
    outside = sorted(f for f in Pstar - R)
    entries = sorted((f, c, sites_of[(f, c)][0]) for f in outside for c in graph[f] if c in Pstar and c in reads | Pstar and f not in reads)
    print(f"==== H unit {uname}: functions reading pm {len(reads)}, reachable from Pmove {len(R)}, pm-reading closure outside Pmove {len(outside)}")
    direct_out = sorted(f for f in reads - R)
    print("   read pm and not reachable from Pmove:", [(f, file_of[f].name) for f in direct_out])
    ext = sorted({(f, file_of[f].name, c, sites_of[(f, c)][0]) for f in outside for c in graph[f] if c in (reads - R) and not file_of[f].name.startswith("bg_")})
    print("   non-bg callers of those:", ext[:40])
