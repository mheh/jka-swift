"""Group Port-notes by root cause and measure cascades. Reads holes.tsv, summary.tsv,
crashes.txt under /tmp/jka-analysis. Writes nothing outside /tmp/jka-analysis."""
import re, csv, collections

HOLES = "/tmp/jka-analysis/holes.tsv"
SUMMARY = "/tmp/jka-analysis/summary.tsv"

BACKTICK = re.compile(r"`[^`]*`")
CASCADE_RE = re.compile(r"^A (read of|store into) `([^`]+)`, a local the draft left as a hole\.$")

# The five templates the drafter emits without incrementing its hole counter
# (draft_calls.py:228, draft_calls.py:290, draft_statements.py:592,
# draft_expressions.py:226, draft_expressions.py:359).
NOTE_ONLY_TEMPLATES = {
    "Raven passes NULL for X, and the callee reads NULL as the zero vector.",
    "Raven passes the record's address to a X, and the format reads the text at that address.",
    "Raven's loop has a continue, and the step below does not run for it. The transcriptor moves the step.",
    "Raven tests X for NULL here. Swift holds it as a value, so the test has no form and reads true.",
    "Raven guards a NULL X here. Swift holds it as a value, so the guard has no form and reads false.",
}

def normalize(text):
    return BACKTICK.sub("X", text)

rows = []
with open(HOLES, newline="", encoding="utf-8") as f:
    for line in f:
        line = line.rstrip("\n")
        parts = line.split("\t")
        # Some Raven-wrote payloads contain literal tabs from the C source; keep first 3 fields exact,
        # fold the remainder back into the 4th (next-line) field.
        if len(parts) < 4:
            parts += [""] * (4 - len(parts))
        stem, fn, note, nxt = parts[0], parts[1], parts[2], "\t".join(parts[3:])
        rows.append({"stem": stem, "fn": fn, "note": note, "next": nxt, "norm": normalize(note)})

print("==== total rows:", len(rows))

# ---------- Task 1: normalized reason counts, whole tree ----------
reason_counts = collections.Counter(r["norm"] for r in rows)
print("\n==== TASK 1: normalized reason counts (whole tree), all reasons, sorted desc ====")
for reason, n in reason_counts.most_common():
    print(f"{n}\t{reason}")

# ---------- classify note-only vs hole-counted, sanity check against summary.tsv ----------
summary = {}
with open(SUMMARY, newline="", encoding="utf-8") as f:
    for line in f:
        stem, nfn, nholes = line.rstrip("\n").split("\t")
        summary[stem] = (int(nfn), int(nholes))

def is_note_only(row):
    return row["norm"] in NOTE_ONLY_TEMPLATES

note_only_rows = [r for r in rows if is_note_only(r)]
hole_rows = [r for r in rows if not is_note_only(r)]
print(f"\n==== note-only rows: {len(note_only_rows)}   hole-counted rows: {len(hole_rows)}")
print(f"==== 1626 - 1265 = {1626-1265} (expected gap)")

per_stem_holes_tsv = collections.Counter(r["stem"] for r in rows)
per_stem_hole_rows = collections.Counter(r["stem"] for r in hole_rows)
mismatches = []
for stem in per_stem_holes_tsv:
    tsv_n = per_stem_holes_tsv[stem]
    summary_n = summary.get(stem, (0, 0))[1]
    computed_n = per_stem_hole_rows[stem]
    if computed_n != summary_n:
        mismatches.append((stem, tsv_n, summary_n, computed_n))
print(f"\n==== per-stem hole-count mismatches against summary.tsv (stem, holes.tsv_rows, summary_holes, computed_hole_rows): {len(mismatches)}")
for m in mismatches:
    print(" ", m)

# ---------- Task 2: cascades ----------
# rows list preserves file order; rows for one (stem, fn) are contiguous.
groups = collections.defaultdict(list)  # (stem, fn) -> list of global indices, in order
for i, r in enumerate(rows):
    groups[(r["stem"], r["fn"])].append(i)

cascades = []  # list of dicts: idx, local, origin_idx (or None)
unmatched = 0
for i, r in enumerate(rows):
    m = CASCADE_RE.match(r["note"])
    if not m:
        continue
    local = m.group(2)
    group_idx = groups[(r["stem"], r["fn"])]
    pos = group_idx.index(i)
    origin_idx = None
    for j in reversed(group_idx[:pos]):
        cand = rows[j]
        if CASCADE_RE.match(cand["note"]):
            continue  # never treat another cascade as the origin
        if cand["norm"] in NOTE_ONLY_TEMPLATES:
            continue  # a note-only row never adds to local_holes, so it cannot be a true origin
        name_in_backticks = bool(re.search(rf"`{re.escape(local)}`", cand["note"]))
        name_in_next = bool(re.search(rf"\b{re.escape(local)}\b", cand["next"]))
        if name_in_backticks or name_in_next:
            origin_idx = j
            break
    if origin_idx is None:
        unmatched += 1
    cascades.append({"idx": i, "local": local, "origin_idx": origin_idx})

print(f"\n==== TASK 2: cascade rows found: {len(cascades)}, unmatched (no origin found): {unmatched}")

by_origin_reason = collections.defaultdict(lambda: {"origins": set(), "cascades": 0})
for c in cascades:
    if c["origin_idx"] is None:
        continue
    oreason = rows[c["origin_idx"]]["norm"]
    by_origin_reason[oreason]["origins"].add(c["origin_idx"])
    by_origin_reason[oreason]["cascades"] += 1

print("\n---- per origin reason: origin holes, cascades caused, mean cascades/origin ----")
table = []
for reason, d in by_origin_reason.items():
    no = len(d["origins"])
    nc = d["cascades"]
    table.append((nc, reason, no, nc / no if no else 0))
for nc, reason, no, mean in sorted(table, reverse=True):
    print(f"origins={no}\tcascades={nc}\tmean={mean:.2f}\t{reason}")

print("\n---- ten functions with the most cascades ----")
fn_cascade_counts = collections.Counter()
for c in cascades:
    r = rows[c["idx"]]
    fn_cascade_counts[(r["stem"], r["fn"])] += 1
for (stem, fn), n in fn_cascade_counts.most_common(10):
    print(f"{n}\t{stem}\t{fn}")

# ---------- Task 3: per stem, top 3 origin reasons ----------
print("\n==== TASK 3: per stem, top three origin reasons (by origins+cascades) ====")
per_stem_origin_reason = collections.defaultdict(lambda: collections.defaultdict(lambda: {"origins": set(), "cascades": 0}))
for c in cascades:
    if c["origin_idx"] is None:
        continue
    orow = rows[c["origin_idx"]]
    d = per_stem_origin_reason[orow["stem"]][orow["norm"]]
    d["origins"].add(c["origin_idx"])
    d["cascades"] += 1
for stem in sorted(per_stem_origin_reason):
    entries = []
    for reason, d in per_stem_origin_reason[stem].items():
        no = len(d["origins"])
        nc = d["cascades"]
        entries.append((no + nc, no, nc, reason))
    entries.sort(reverse=True)
    print(f"\n{stem}:")
    for total, no, nc, reason in entries[:3]:
        print(f"  origins={no} cascades={nc} total={total}\t{reason}")

# ---------- Task 4: whole tree, top 5 root causes (origins + cascades) ----------
print("\n==== TASK 4: whole tree, top five root causes (origin count + cascades caused) ====")
closure = collections.Counter()
origin_only_counts = collections.Counter()
for r in rows:
    if CASCADE_RE.match(r["note"]):
        continue
    closure[r["norm"]] += 1
    origin_only_counts[r["norm"]] += 1
for reason, d in by_origin_reason.items():
    closure[reason] += d["cascades"]
top5 = closure.most_common(5)
for reason, total in top5:
    no = origin_only_counts[reason]
    nc = by_origin_reason.get(reason, {"cascades": 0})["cascades"]
    print(f"total={total}\tbase_occurrences={no}\tcascades_saved={nc}\t{reason}")

# ---------- Task 5: gap accounting, per stem ----------
print("\n==== TASK 5: gap accounting per stem (holes.tsv rows - summary.tsv holes = note-only rows) ====")
per_stem_note_only = collections.defaultdict(collections.Counter)
for r in note_only_rows:
    per_stem_note_only[r["stem"]][r["norm"]] += 1
grand_gap = 0
grand_noteonly = 0
for stem in sorted(summary):
    tsv_n = per_stem_holes_tsv.get(stem, 0)
    summary_n = summary[stem][1]
    gap = tsv_n - summary_n
    noteonly_n = sum(per_stem_note_only[stem].values())
    grand_gap += gap
    grand_noteonly += noteonly_n
    flag = "" if gap == noteonly_n else "  <== MISMATCH"
    if tsv_n:
        print(f"{stem}\ttsv_rows={tsv_n}\tsummary_holes={summary_n}\tgap={gap}\tnote_only={noteonly_n}{flag}")
print(f"\nGRAND TOTAL gap={grand_gap} note_only={grand_noteonly}")

print("\n---- note-only reasons overall, with counts ----")
for reason, n in collections.Counter(r["norm"] for r in note_only_rows).most_common():
    print(f"{n}\t{reason}")

# ---------- Task 5b: nine gate stems, every Port-note ----------
GATE_STEMS = ["bg_pmove", "bg_misc", "bg_slidemove", "bg_saber", "bg_panimate",
              "bg_saga", "bg_g2_utils", "bg_vehicleLoad", "bg_saberLoad"]
print("\n==== TASK 5b: gate stems, every Port-note (stem | function | note | next line) ====")
gate_total = 0
for stem in GATE_STEMS:
    stem_rows = [r for r in rows if r["stem"] == stem]
    gate_total += len(stem_rows)
    print(f"\n-- {stem}: {len(stem_rows)} Port-notes, summary holes={summary.get(stem, (0,0))[1]}")
    for r in stem_rows:
        print(f"  fn={r['fn']}\tnote={r['note']}\tnext={r['next']}")
print(f"\nGATE TOTAL: {gate_total}")
