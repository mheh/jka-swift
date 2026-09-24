"""Q1: parse soundness of the two unity units."""
import sys, re, ctypes, collections, json
sys.path.insert(0, "/Users/milohehmsoth/Developer/Milo/jka-swift/tools/oracle-closure")
import closure as C
import clang.cindex as ci
from clang.cindex import CursorKind, TypeKind
from pathlib import Path

lib = ci.conf.lib
lib.clang_isInvalidDeclaration.argtypes = [ci.Cursor]
lib.clang_isInvalidDeclaration.restype = ctypes.c_uint
class RangeList(ctypes.Structure):
    _fields_ = [("count", ctypes.c_uint), ("ranges", ctypes.POINTER(ci.SourceRange))]
lib.clang_getSkippedRanges.argtypes = [ctypes.c_void_p, ctypes.c_void_p]
lib.clang_getSkippedRanges.restype = ctypes.POINTER(RangeList)
lib.clang_getFile.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
lib.clang_getFile.restype = ctypes.c_void_p

def invalid(c): return bool(lib.clang_isInvalidDeclaration(c))

ORACLE = C.ORACLE.resolve()
def rel(p):
    try: return str(Path(p).resolve().relative_to(ORACLE))
    except Exception: return str(p)

def skipped_lines(tu, path):
    f = lib.clang_getFile(tu.obj, str(path).encode())
    if not f: return None
    rl = lib.clang_getSkippedRanges(tu.obj, f)
    out = set()
    for i in range(rl.contents.count):
        r = rl.contents.ranges[i]
        for ln in range(r.start.line, r.end.line + 1):
            out.add(ln)
    return out

def strip_c(text):
    # blank comments and string/char literals, keep newlines
    out = []; i = 0; n = len(text)
    while i < n:
        c = text[i]
        if text.startswith("//", i):
            j = text.find("\n", i); j = n if j < 0 else j
            out.append(" " * (j - i)); i = j
        elif text.startswith("/*", i):
            j = text.find("*/", i + 2); j = n if j < 0 else j + 2
            out.append("".join(ch if ch == "\n" else " " for ch in text[i:j])); i = j
        elif c in "\"'":
            j = i + 1
            while j < n and text[j] != c:
                if text[j] == "\\": j += 1
                if j < n and text[j] == "\n": break
                j += 1
            out.append(c + " " * (j - i - 1) + (c if j < n else "")); i = j + 1
        else:
            out.append(c); i += 1
    return "".join(out)

def text_definitions(path, skipped):
    raw = C.parsed_bytes(path).decode("utf-8", "replace").replace("\r\n", "\n")
    lines = strip_c(raw).split("\n")
    kept = []
    cont = False
    for ln, line in enumerate(lines, 1):
        # drop preprocessor lines (with continuations) and skipped lines
        if (skipped and ln in skipped) or cont or line.lstrip().startswith("#"):
            cont = line.rstrip().endswith("\\") and (cont or line.lstrip().startswith("#"))
            kept.append("")
            continue
        kept.append(line)
    text = "\n".join(kept)
    names = []
    depth = 0; i = 0; n = len(text)
    while i < n:
        c = text[i]
        if c == "{":
            if depth == 0:
                j = i - 1
                while j >= 0 and text[j].isspace(): j -= 1
                if j >= 0 and text[j] == ")":
                    # find matching (
                    d = 0; k = j
                    while k >= 0:
                        if text[k] == ")": d += 1
                        elif text[k] == "(":
                            d -= 1
                            if d == 0: break
                        k -= 1
                    m = re.search(r"(\w+)\s*$", text[:k])
                    if m and m.group(1) not in ("if", "while", "for", "switch"):
                        names.append((m.group(1), text[:i].count("\n") + 1))
            depth += 1
        elif c == "}":
            depth = max(0, depth - 1)
        i += 1
    return names

parse = C.Parse()
units = {"game": (parse.game, [parse.game_folder]), "cgame": (parse.cgame, [parse.game_folder, parse.cgame_folder, (C.ORACLE / "codemp/ui").resolve()])}
report = {}
for uname, (tu, folders) in units.items():
    print(f"==== unit {uname}")
    diags = list(tu.diagnostics)
    sev = collections.Counter(d.severity for d in diags)
    print("severity counts", dict(sev))
    errs = [d for d in diags if d.severity >= ci.Diagnostic.Error]
    byfile = collections.Counter(rel(d.location.file.name) if d.location.file else "<none>" for d in errs)
    print("errors by file:")
    for f, n in byfile.most_common(): print(f"  {n:5d} {f}")
    cat = collections.Counter(re.sub(r"'[^']*'", "'X'", d.spelling) for d in errs)
    print("errors by message:")
    for m, n in cat.most_common(40): print(f"  {n:5d} {m}")
    # function definitions and errors inside bodies
    fdefs = []
    for cur in tu.cursor.get_children():
        if cur.kind == CursorKind.FUNCTION_DECL and cur.is_definition() and cur.location.file:
            fdefs.append(cur)
    inv_f = [c for c in fdefs if invalid(c)]
    print("invalid function definitions:", len(inv_f))
    for c in inv_f[:40]: print("   ", rel(c.location.file.name), c.location.line, c.spelling)
    # errors inside a function body extent
    byfn = collections.defaultdict(list)
    spans = collections.defaultdict(list)
    for c in fdefs:
        spans[str(Path(c.location.file.name).resolve())].append((c.extent.start.line, c.extent.end.line, c))
    for d in errs:
        if not d.location.file: continue
        p = str(Path(d.location.file.name).resolve())
        for s, e, c in spans.get(p, []):
            if s <= d.location.line <= e:
                byfn[(rel(p), c.spelling)].append((d.location.line, d.spelling)); break
    print("function bodies with an error inside:", len(byfn))
    for (f, fn), ds in sorted(byfn.items()):
        print(f"   {f} {fn}: {len(ds)} e.g. {ds[0][0]}: {ds[0][1]}")
    # per .c file counts
    print("per-file definition counts (ast vs text):")
    ast_by = collections.defaultdict(list)
    for c in fdefs:
        ast_by[str(Path(c.location.file.name).resolve())].append((c.spelling, c.location.line))
    tot_a = tot_t = 0
    for folder in folders:
        glob = sorted(folder.glob("*.c"))
        for p in glob:
            p = p.resolve()
            sk = skipped_lines(tu, p)
            if sk is None: continue  # not in unit
            tnames = text_definitions(p, sk)
            anames = ast_by.get(str(p), [])
            tot_a += len(anames); tot_t += len(tnames)
            tset = collections.Counter(n for n, _ in tnames); aset = collections.Counter(n for n, _ in anames)
            if tset != aset:
                print(f"   MISMATCH {rel(p)} ast={len(anames)} text={len(tnames)} text-only={sorted((tset-aset).elements())} ast-only={sorted((aset-tset).elements())}")
    print("total ast", tot_a, "text", tot_t)
    # records: invalid, negative size, error inside extent
    recs = []
    for cur in tu.cursor.walk_preorder():
        if cur.kind in (CursorKind.STRUCT_DECL, CursorKind.UNION_DECL) and cur.is_definition():
            recs.append(cur)
    bad = []
    errs_at = collections.defaultdict(list)
    for d in errs:
        if d.location.file: errs_at[str(Path(d.location.file.name).resolve())].append(d)
    for r in recs:
        p = str(Path(r.location.file.name).resolve()) if r.location.file else ""
        inside = [d for d in errs_at.get(p, []) if r.extent.start.line <= d.location.line <= r.extent.end.line]
        badfields = [f.spelling for f in r.get_children() if f.kind == CursorKind.FIELD_DECL and (invalid(f) or f.type.kind == TypeKind.INVALID)]
        if invalid(r) or r.type.get_size() < 0 or inside or badfields:
            bad.append((rel(p), r.location.line, r.spelling or r.type.spelling, invalid(r), r.type.get_size(), len(inside), badfields, inside[0].spelling if inside else ""))
    print("records total", len(recs), "bad", len(bad))
    for b in bad[:60]: print("   ", b)
    report[uname] = {"recs_bad": [b[2] for b in bad]}

# views coverage: record names the views reach, and whether each is bad in either unit
from views import Generator
gen = Generator(parse, None)
names = set(gen.views)
print("views", len(names))
for uname in units:
    hit = [n for n in report[uname]["recs_bad"] if n in names or n.replace("struct ", "") in names]
    print(uname, "bad records the views cover:", hit)
# compare field counts of view records between headers TU and each unit
def fields_of(tu):
    out = {}
    for cur in tu.cursor.get_children():
        if cur.kind == CursorKind.TYPEDEF_DECL:
            d = cur.underlying_typedef_type.get_declaration()
            if d.kind in (CursorKind.STRUCT_DECL, CursorKind.UNION_DECL):
                dd = d.get_definition()
                if dd is not None:
                    out.setdefault(cur.spelling, [(f.spelling, f.type.get_canonical().spelling, f.type.get_size()) for f in dd.get_children() if f.kind == CursorKind.FIELD_DECL])
        elif cur.kind == CursorKind.STRUCT_DECL and cur.is_definition():
            out.setdefault(cur.spelling, [(f.spelling, f.type.get_canonical().spelling, f.type.get_size()) for f in cur.get_children() if f.kind == CursorKind.FIELD_DECL])
    return out
hf = fields_of(parse.headers)
for uname, (tu, _) in units.items():
    uf = fields_of(tu)
    diff = 0; missing = 0
    for n in sorted(names):
        if n not in uf: missing += 1; continue
        a = [(x, s) for x, _, s in hf.get(n, [])]; b = [(x, s) for x, _, s in uf[n]]
        if a != b:
            diff += 1
            print(f"  {uname} view record differs from headers: {n} headers={len(a)} unit={len(b)} first={[x for x in a if x not in b][:3]} / {[x for x in b if x not in a][:3]}")
    print(uname, "view records missing in unit:", missing, "differing:", diff)
print("headers unit errors:", len([d for d in parse.headers.diagnostics if d.severity >= ci.Diagnostic.Error]))
