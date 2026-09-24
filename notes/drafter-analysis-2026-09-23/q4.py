import sys, re, collections
sys.path.insert(0, "/Users/milohehmsoth/Developer/Milo/jka-swift/tools/oracle-closure")
import closure as C
from skeleton import Skeleton
from rulings import NEVER_NULL_VARS, PARAMS
parse = C.Parse()
sk = Skeleton(parse)
T = sk.table
GATE = {"bg_pmove", "bg_misc", "bg_slidemove", "bg_saber", "bg_panimate", "bg_saga", "bg_g2_utils", "bg_vehicleLoad", "bg_saberLoad"}
rows = [l.rstrip("\n").split("\t") for l in open("/tmp/jka-analysis/holes.tsv")]
cls = collections.Counter(); gate_cls = collections.Counter(); out = []
for r in rows:
    stem, fn, note = r[0], r[1], r[2]
    m = re.match(r"Raven (tests|guards a NULL) `([^`]+)`", note)
    if not m or not ("reads true" in note or "reads false" in note): continue
    name = m.group(2)
    f = next((x for x in sk.files.get(stem, []) if x.name == fn), None)
    params = {p.name: p for p in f.params} if f else {}
    if name.startswith("&"): c = "address, never NULL in C"
    elif name in NEVER_NULL_VARS and name not in params: c = "NEVER_NULL_VARS ruling"
    elif name in params:
        k = params[name].kind
        if (fn, name) in PARAMS: c = f"PARAMS ruling ({PARAMS[(fn, name)]}), sweep nullable={(fn, name) in T.nullable}"
        elif (fn, name) in T.nullable: c = f"sweep proved a caller passes NULL, shape {k} ignores it"
        elif fn not in T.called: c = f"no caller parsed, default shape {k}"
        else: c = f"param other {k}"
    else: c = "local, no proof"
    cls[c.split(" (")[0].split(", shape")[0].split(", default")[0]] += 1
    if stem in GATE: gate_cls[c] += 1; out.append((stem, fn, name, c))
print("all 84 notes by basis:", dict(cls))
print("gate:", dict(gate_cls))
for o in out: print("  ", o)
# silent folds in all stems: plain comment on a parameter, count, and how many of those pairs the sweep saw no call for
plain = 0
for p in __import__("pathlib").Path("/tmp/jka-analysis/drafts").glob("*.swift"):
    plain += p.read_text().count("has no form here, and the arm it guards is gone.")
print("plain-comment folds in corpus:", plain)
print("PM_SetVehicleAngles normal nullable:", ("PM_SetVehicleAngles", "normal") in T.nullable, "called:", "PM_SetVehicleAngles" in T.called)
print("WP_SaberSetColor called:", "WP_SaberSetColor" in T.called, "WP_ForcePowerUsable called:", "WP_ForcePowerUsable" in T.called, "G_Knockdown called:", "G_Knockdown" in T.called, "NPC_CheckEnemyStealth called:", "NPC_CheckEnemyStealth" in T.called)
