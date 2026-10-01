# This reads game-draftcheck.log from the folder of this script.
# It prints the totals, the per-stem table, the defect classes with top stems, and one example line per class.
import re, collections, os
HERE = os.path.dirname(os.path.abspath(__file__))
STEM = re.compile(r"^(\w+): (\d+) of (\d+) hand functions replaced, (\d+) holes, (\d+) cascade errors, (\d+) defects$")
DEFECT = re.compile(r"^  (\w+)\.swift:(\d+): (.*)$")
TOTAL = re.compile(r"^total: (\d+) holes, (\d+) cascade errors, (\d+) defects$")
rows, defects, total, cur = {}, [], None, None
for line in open(os.path.join(HERE, "game-draftcheck.log")):
    line = line.rstrip("\n")
    m = STEM.match(line)
    if m:
        cur = m.group(1)
        rows[cur] = dict(fn=int(m.group(3)), holes=int(m.group(4)), cascade=int(m.group(5)), defects=int(m.group(6)))
        continue
    m = TOTAL.match(line)
    if m:
        total = tuple(int(x) for x in m.groups())
        continue
    m = DEFECT.match(line)
    if m and m.group(1) == cur:
        defects.append((cur, f"{m.group(1)}.swift:{m.group(2)}", m.group(3)))
print("stems", len(rows), "functions", sum(r["fn"] for r in rows.values()))
print("holes", sum(r["holes"] for r in rows.values()), "cascade", sum(r["cascade"] for r in rows.values()), "defects", sum(r["defects"] for r in rows.values()), "defect lines", len(defects))
print("log total line", total)
print("stems with a defect count that differs from the defect lines:")
by_stem = collections.Counter(s for s, _, _ in defects)
for s, r in rows.items():
    if by_stem[s] != r["defects"]:
        print("  ", s, r["defects"], by_stem[s])
print("\n## Per stem")
print("| Stem | Functions | Holes | Defects |\n|---|---|---|---|")
for s, r in sorted(rows.items(), key=lambda kv: -kv[1]["defects"]):
    print(f"| {s} | {r['fn']} | {r['holes']} | {r['defects']} |")
def norm(msg):
    msg = re.sub(r"'[^']*'", "'X'", msg)
    msg = re.sub(r"\b\d+\b", "N", msg)
    return msg
cls = collections.Counter(); ex = {}; stems = collections.defaultdict(collections.Counter)
for s, loc, msg in defects:
    k = norm(msg); cls[k] += 1; stems[k][s] += 1
    ex.setdefault(k, f"{loc}: {msg}")
print("\n## Defect classes", len(cls))
print("| Count | Message | Top stems |\n|---|---|---|")
for k, c in cls.most_common():
    top = ", ".join(f"{s} {n}" for s, n in stems[k].most_common(3))
    print(f"| {c} | {k} | {top} |")
print("\n## Examples")
for k, c in cls.most_common(10):
    print(f"{c}\t{k}\n\teg {ex[k]}")
