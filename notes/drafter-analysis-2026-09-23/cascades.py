import re, glob, collections, os
SRC = re.compile(r"^/// Source: (\S+)$")
NOTE = re.compile(r"^(\s*)// Port-note: (.*)$")
WROTE = re.compile(r"^\s*// Raven wrote: (.*)$")
CASC = re.compile(r"^A (read of|store into) `(\w+)`, a local the draft left as a hole\.$")
funcs = []
for path in sorted(glob.glob("/tmp/jka-analysis/drafts/*.swift")):
    stem = os.path.basename(path)[:-6]
    lines = open(path).read().split("\n")
    cur = None
    for i, line in enumerate(lines):
        m = SRC.match(line)
        if m:
            nm = re.search(r"func\s+`?(\w+)", lines[i+1]) if i+1 < len(lines) else None
            cur = {"stem": stem, "name": nm.group(1) if nm else "?", "holes": []}
            funcs.append(cur)
            continue
        m = NOTE.match(line)
        if m and cur is not None:
            w = WROTE.match(lines[i+1]) if i+1 < len(lines) else None
            if w:
                cur["holes"].append({"reason": m.group(2), "raven": w.group(1), "line": i+1, "indent": len(m.group(1))})
total = sum(len(f["holes"]) for f in funcs)
casc = [(f, h) for f in funcs for h in f["holes"] if CASC.match(h["reason"])]
print("holes with Raven wrote:", total, "cascades:", len(casc))
# origin per cascade
origin_count = collections.Counter()
orphan = []
chains = collections.Counter()
for f in funcs:
    for k, h in enumerate(f["holes"]):
        m = CASC.match(h["reason"])
        if not m: continue
        x = m.group(2)
        pat = re.compile(r"\b%s\b" % re.escape(x))
        org = None
        for j in range(k):
            if pat.search(f["holes"][j]["raven"]):
                org = j; break
        if org is None:
            orphan.append((f["stem"], f["name"], x, h["raven"][:120]))
            continue
        # follow to root origin (non-cascade)
        root = org
        seen=set()
        while CASC.match(f["holes"][root]["reason"]) and root not in seen:
            seen.add(root)
            y = CASC.match(f["holes"][root]["reason"]).group(2)
            p2 = re.compile(r"\b%s\b" % re.escape(y))
            nxt = next((j for j in range(root) if p2.search(f["holes"][j]["raven"])), None)
            if nxt is None: break
            root = nxt
        r = f["holes"][root]
        origin_count[(f["stem"], f["name"], r["reason"][:90], r["raven"][:100])] += 1
        chains[re.sub(r"`[^`]*`", "`X`", r["reason"])[:100]] += 1
print("orphans (no earlier hole names the local):", len(orphan))
for o in orphan[:15]: print("  ", o)
print("---- top origins")
for k, v in origin_count.most_common(15): print(v, k)
print("---- root reason of cascades")
for k, v in chains.most_common(15): print(v, k)
print("---- biggest swallowed statements (by ; count in Raven text)")
big = sorted(((h["raven"].count(";"), f["stem"], f["name"], h["reason"][:90]) for f in funcs for h in f["holes"]), reverse=True)
for b in big[:12]: print(b)
print("sum of ; in holes whose statement is compound (count>=3):", sum(b[0] for b in big if b[0]>=3), "holes:", sum(1 for b in big if b[0]>=3))
second=0
for f in funcs:
    for k,h in enumerate(f["holes"]):
        m=CASC.match(h["reason"])
        if not m: continue
        pat=re.compile(r"\b%s\b"%re.escape(m.group(2)))
        org=next((j for j in range(k) if pat.search(f["holes"][j]["raven"])),None)
        if org is not None and CASC.match(f["holes"][org]["reason"]): second+=1
print("cascades whose origin is itself a cascade:", second)
fn_all=sum(1 for f in funcs if f["holes"] and all(CASC.match(h["reason"]) or j==0 for j,h in enumerate(f["holes"])) and len(f["holes"])>5)
print("functions where every hole after the first is a cascade (and >5 holes):", fn_all)
