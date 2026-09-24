import re, glob, os
G="/Users/milohehmsoth/Developer/Milo/jka-swift/oracle/codemp/game/"
def strip_comments(t):
    return re.sub(r"//[^\n]*|/\*.*?\*/", "", t, flags=re.S)
def params_of(sig):
    out=[]
    depth=0; cur=""
    for ch in sig:
        if ch=="(" : depth+=1
        if ch==")" : depth-=1
        if ch=="," and depth==0: out.append(cur); cur=""
        else: cur+=ch
    out.append(cur)
    names=[]
    for p in out:
        p=p.strip()
        if p in ("void",""): continue
        m=re.search(r"(\w+)\s*(\[[^\]]*\])*\s*$", p)
        # param name if more than one word
        words=re.findall(r"\w+", p)
        if "(" in p:  # fn pointer
            m2=re.search(r"\(\s*\*\s*(\w+)\s*\)", p); names.append(m2.group(1) if m2 else "")
        elif len(words)>=2 and m and not re.fullmatch(r"(int|float|char|void|qboolean|unsigned|const|struct|\w+_t)", m.group(1)): names.append(m.group(1))
        else: names.append("")
    return names
FUNC=re.compile(r"^[A-Za-z_][\w \t\*]*?\b(\w+)\s*\(([^;{}]*)\)\s*;", re.M)
DEF=re.compile(r"^[A-Za-z_][\w \t\*]*?\b(\w+)\s*\(([^;{}]*)\)\s*\{", re.M)
protos={}
for h in glob.glob(G+"*.h")+glob.glob(G+"*.c"):
    t=strip_comments(open(h,errors="replace").read())
    for m in FUNC.finditer(t):
        protos.setdefault(m.group(1),[]).append((os.path.basename(h), params_of(m.group(2))))
defs={}
for c in sorted(glob.glob(G+"*.c")):
    t=strip_comments(open(c,errors="replace").read())
    for m in DEF.finditer(t):
        if m.group(1) in ("if","while","for","switch","return","sizeof"): continue
        defs.setdefault(m.group(1),(os.path.basename(c), params_of(m.group(2))))
import sys
diff=[]
for fn,(cfile,dp) in defs.items():
    for hfile,pp in protos.get(fn,[]):
        if len(pp)==len(dp):
            for i,(a,b) in enumerate(zip(pp,dp)):
                if a!=b and b:
                    diff.append((fn,i,cfile,b,hfile,a))
print(len(diff))
import pickle; pickle.dump((diff,defs), open("/tmp/jka-audit/diff.pkl","wb"))
for d in diff[:10]: print(d)
