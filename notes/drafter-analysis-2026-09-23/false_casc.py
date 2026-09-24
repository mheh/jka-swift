import re, glob, os, collections
exec(open(__file__.rsplit("/", 1)[0] + "/cascades.py").read().split("total = ")[0])
ORACLE="/Users/milohehmsoth/Developer/Milo/jka-swift/"
def fn_text(src):
    path, line = src.rsplit(":",1)
    lines = open(ORACLE+path, errors="replace").read().split("\n")
    i = int(line)-1
    # read until a line that is exactly "}" at col 0
    out=[]
    for j in range(i, len(lines)):
        out.append(lines[j])
        if lines[j].startswith("}"): break
    return "\n".join(out)
# need source per func: re-scan
srcs={}
for path in sorted(glob.glob("/tmp/jka-analysis/drafts/*.swift")):
    stem=os.path.basename(path)[:-6]
    L=open(path).read().split("\n")
    for i,l in enumerate(L):
        m=SRC.match(l)
        if m:
            nm=re.search(r"func\s+`?(\w+)", L[i+1]) if i+1<len(L) else None
            srcs[(stem, nm.group(1) if nm else "?")]=m.group(1)
flag=collections.Counter()
for f in funcs:
    names = {CASC.match(h["reason"]).group(2) for h in f["holes"] if CASC.match(h["reason"])}
    if not names: continue
    src = srcs.get((f["stem"], f["name"]))
    if not src: continue
    text = fn_text(src)
    for x in names:
        decls = re.findall(r"(?m)^\s*(?:static\s+|const\s+|unsigned\s+|struct\s+)*[A-Za-z_]\w*\s+[\w\s\*,\[\]]*?\**\b%s\b\s*(?:\[[^\]]*\])*\s*[;=,]" % re.escape(x), text)
        n = sum(1 for h in f["holes"] if CASC.match(h["reason"]) and CASC.match(h["reason"]).group(2)==x)
        if len(decls) >= 2:
            print(f["stem"], f["name"], x, "decls:", len(decls), "cascades:", n)
            for d in decls: print("    ", d.strip()[:100])
