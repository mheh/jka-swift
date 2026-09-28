# This reads game-stems.txt and draftcheck-game-1.log through draftcheck-game-6.log from /tmp/jka-hole.
# It writes game-defects.tsv, and it prints the missing stems, the totals, the top ten stems by defects, and the top ten defect classes.
import re, collections
stem_fn = dict(l.split() for l in open("/tmp/jka-hole/game-stems.txt"))
LINE = re.compile(r"^(\w+): \d+ of \d+ hand functions replaced, (\d+) holes, (\d+) cascade errors, (\d+) defects$")
rows, defects, cur = {}, [], None
for n in range(1, 7):
    for line in open(f"/tmp/jka-hole/draftcheck-game-{n}.log"):
        line = line.rstrip("\n")
        m = LINE.match(line)
        if m:
            cur = m.group(1); rows[cur] = m.groups()[1:]
            defects = [x for x in defects if x[0] != cur]
            continue
        if cur and line.startswith("  ") and not line.startswith("  /") and not line.startswith("  error:"):
            defects.append((cur, line.strip()))
        elif not line.startswith("  "):
            cur = None if not m else cur
with open("/tmp/jka-hole/game-defects.tsv", "w") as f:
    f.write("stem\tfunctions\tholes\tcascade\tdefects\n")
    for s, n in stem_fn.items():
        h, c, d = rows.get(s, ("-", "-", "-"))
        f.write(f"{s}\t{n}\t{h}\t{c}\t{d}\n")
print("missing", [s for s in stem_fn if s not in rows])
print("rows", len(rows), "holes", sum(int(r[0]) for r in rows.values()), "cascade", sum(int(r[1]) for r in rows.values()), "defects", sum(int(r[2]) for r in rows.values()), "defect lines", len(defects))
top = sorted(rows.items(), key=lambda kv: -int(kv[1][2]))[:10]
print("top10", [(s, stem_fn[s], r[2]) for s, r in top])
def norm(msg):
    msg = re.sub(r"'[^']*'", "'X'", msg)
    msg = re.sub(r"\b\d+\b", "N", msg)
    return msg
cls = collections.Counter(); ex = {}
for s, d in defects:
    loc, msg = d.split(": ", 1) if ": " in d else ("", d)
    k = norm(msg); cls[k] += 1; ex.setdefault(k, f"{s} {loc}: {msg}")
print("classes", len(cls))
for k, c in cls.most_common(10):
    print(f"{c}\t{k}\n\teg {ex[k]}")
