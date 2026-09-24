"""Draft every stem to /tmp/jka-analysis/drafts/<stem>.swift, and list every hole and crash."""
import sys, traceback, re
sys.path.insert(0, "/Users/milohehmsoth/Developer/Milo/jka-swift/tools/oracle-closure")
import closure as C
from skeleton import Skeleton
from bodies import Drafter, Registry

sk = Skeleton(C.Parse())
drafter = Drafter(sk, Registry())
holes = open("/tmp/jka-analysis/holes.tsv", "w")
crashes = open("/tmp/jka-analysis/crashes.txt", "w")
summary = open("/tmp/jka-analysis/summary.tsv", "w")
NOTE = re.compile(r"^\s*// Port-note: (.*)$")
for stem in sorted(sk.files):
    before = drafter.holes
    out = []
    nfn = 0
    for fn in sk.files[stem]:
        nfn += 1
        try:
            lines = drafter.draft(fn)
        except Exception as e:
            crashes.write(f"{stem}\t{fn.name}\t{type(e).__name__}: {e}\n")
            crashes.write("".join(traceback.format_exc().splitlines(keepends=True)[-6:]) + "\n")
            lines = [f"// CRASH {fn.name}: {type(e).__name__}: {e}"]
        for i, line in enumerate(lines):
            m = NOTE.match(line)
            if m:
                nxt = lines[i + 1].strip() if i + 1 < len(lines) else ""
                holes.write(f"{stem}\t{fn.name}\t{m.group(1)}\t{nxt}\n")
        out += lines + [""]
    open(f"/tmp/jka-analysis/drafts/{stem}.swift", "w").write("\n".join(out))
    summary.write(f"{stem}\t{nfn}\t{drafter.holes - before}\n")
    print(stem, nfn, drafter.holes - before, flush=True)
print("total holes", drafter.holes)
