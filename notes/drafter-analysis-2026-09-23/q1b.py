import sys, collections
sys.path.insert(0, "/Users/milohehmsoth/Developer/Milo/jka-swift/tools/oracle-closure")
import closure as C
import clang.cindex as ci
from clang.cindex import CursorKind
from pathlib import Path
from overlay import OVERLAY
tu = C.parse_tu("mp-game", None, unity=True, overlay=OVERLAY)
targets = {("bg_pmove.c", 1917), ("w_force.c", 1243), ("bg_saber.c", 2921), ("NPC_AI_Rancor.c", 300), ("NPC_AI_Stormtrooper.c", 750)}
errlines = collections.defaultdict(set)
for d in tu.diagnostics:
    if d.severity >= ci.Diagnostic.Error and "arguments to function call" in d.spelling:
        errlines[Path(d.location.file.name).name].add(d.location.line)
stat = collections.Counter()
for cur in tu.cursor.get_children():
    if cur.kind != CursorKind.FUNCTION_DECL or not cur.is_definition() or not cur.location.file: continue
    fname = Path(cur.location.file.name).name
    for n in cur.walk_preorder():
        if not n.location.file: continue
        key = (fname, n.location.line)
        if key in targets and n.kind in (CursorKind.CALL_EXPR, CursorKind.UNEXPOSED_EXPR, CursorKind.DECL_REF_EXPR):
            ref = n.referenced
            print(key, n.kind.name, repr(n.spelling), ref.kind.name if ref else None, len(list(n.get_children())), n.type.spelling)
        if n.kind == CursorKind.CALL_EXPR and n.location.line in errlines.get(fname, ()):
            ref = n.referenced
            stat[(ref is not None and ref.kind == CursorKind.FUNCTION_DECL)] += 1
print("CALL_EXPR nodes on error lines, referenced is a FUNCTION_DECL:", dict(stat))
print("error call diagnostics:", sum(len(v) for v in errlines.values()))
