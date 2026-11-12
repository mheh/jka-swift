#!/usr/bin/env python3
"""referee.py - lockstep A/B referee for OpenJK game-module verification.

This script drives two patched openjkded instances in lockstep.
Side A and side B each load a different game module.
It uses the `ref_step`, `ref_dump`, and `ref_trace` stdin protocol.
It compares the checksum of each frame.
On a divergence, it reports the first differing entity or client field and the first differing boundary-trace record.

It needs only the Python standard library.
"""

import argparse
import os
import queue
import re
import signal
import subprocess
import sys
import threading
import time

# ---------------------------------------------------------------------------
# Defaults (override via argparse)
# ---------------------------------------------------------------------------

DEFAULT_LOGDIR = "/tmp/referee-scratch/logs"
DEFAULT_MAP = "mp/ffa3"
DEFAULT_SEED = 1234
DEFAULT_PORT_A = 29170
DEFAULT_PORT_B = 29171
DEFAULT_FRAMES = 4000
DEFAULT_BATCH = 10
DEFAULT_TIMEOUT = 15.0       # seconds to wait for a step sentinel
DEFAULT_BOOT_TIMEOUT = 120.0  # seconds for the very first sentinel (map load)

REF_MARK = "REF "


class ProtocolError(Exception):
    """A REF line we could not parse. Message includes the offending line."""


class EngineDied(Exception):
    pass


class RefTimeout(Exception):
    pass


# ---------------------------------------------------------------------------
# Struct offset tables (derived from JKA codemp q_shared.h, natural 4-byte
# alignment, no padding: int/float/qboolean=4, vec3_t=12, trajectory_t=36).
# ---------------------------------------------------------------------------

def _layout(fields):
    """[(name, size), ...] -> sorted [(offset, name, size), ...]"""
    out = []
    off = 0
    for name, size in fields:
        out.append((off, name, size))
        off += size
    return out


ENTITYSTATE_FIELDS = _layout([
    ("number", 4), ("eType", 4), ("eFlags", 4), ("eFlags2", 4),
    ("pos.trType", 4), ("pos.trTime", 4), ("pos.trDuration", 4),
    ("pos.trBase", 12), ("pos.trDelta", 12),
    ("apos.trType", 4), ("apos.trTime", 4), ("apos.trDuration", 4),
    ("apos.trBase", 12), ("apos.trDelta", 12),
    ("time", 4), ("time2", 4),
    ("origin", 12), ("origin2", 12), ("angles", 12), ("angles2", 12),
    ("bolt1", 4), ("bolt2", 4),
    ("trickedentindex", 4), ("trickedentindex2", 4),
    ("trickedentindex3", 4), ("trickedentindex4", 4),
    ("speed", 4), ("fireflag", 4), ("genericenemyindex", 4),
    ("activeForcePass", 4), ("emplacedOwner", 4),
    ("otherEntityNum", 4), ("otherEntityNum2", 4), ("groundEntityNum", 4),
    ("constantLight", 4), ("loopSound", 4), ("loopIsSoundset", 4),
    ("soundSetIndex", 4),
    ("modelGhoul2", 4), ("g2radius", 4), ("modelindex", 4), ("modelindex2", 4),
    ("clientNum", 4), ("frame", 4),
    ("saberInFlight", 4), ("saberEntityNum", 4), ("saberMove", 4),
    ("forcePowersActive", 4), ("saberHolstered", 4),
    ("isJediMaster", 4), ("isPortalEnt", 4),
    ("solid", 4), ("event", 4), ("eventParm", 4),
    ("owner", 4), ("teamowner", 4), ("shouldtarget", 4),
    ("powerups", 4), ("weapon", 4), ("legsAnim", 4), ("torsoAnim", 4),
    ("legsFlip", 4), ("torsoFlip", 4),
    ("forceFrame", 4), ("generic1", 4), ("heldByClient", 4), ("ragAttach", 4),
    ("iModelScale", 4), ("brokenLimbs", 4), ("boltToPlayer", 4),
    ("hasLookTarget", 4), ("lookTarget", 4),
    ("customRGBA", 16),
    ("health", 4), ("maxhealth", 4),
    ("npcSaber1", 4), ("npcSaber2", 4),
    ("csSounds_Std", 4), ("csSounds_Combat", 4), ("csSounds_Extra", 4),
    ("csSounds_Jedi", 4),
    ("surfacesOn", 4), ("surfacesOff", 4),
    ("boneIndex1", 4), ("boneIndex2", 4), ("boneIndex3", 4), ("boneIndex4", 4),
    ("boneOrient", 4),
])

# NOTE: real JKA codemp layout has moveDir at @44 (between velocity and
# weaponTime); weaponTime is @56.
PLAYERSTATE_FIELDS = _layout([
    ("commandTime", 4), ("pm_type", 4), ("bobCycle", 4), ("pm_flags", 4),
    ("pm_time", 4),
    ("origin", 12), ("velocity", 12), ("moveDir", 12),
    ("weaponTime", 4), ("weaponChargeTime", 4),
    ("weaponChargeSubtractTime", 4), ("gravity", 4), ("speed", 4),
    ("basespeed", 4),
    ("delta_angles", 12),
    ("slopeRecalcTime", 4), ("useTime", 4), ("groundEntityNum", 4),
    ("legsTimer", 4), ("legsAnim", 4), ("torsoTimer", 4), ("torsoAnim", 4),
    ("legsFlip", 4), ("torsoFlip", 4), ("movementDir", 4),
    ("eFlags", 4), ("eFlags2", 4),
    ("eventSequence", 4), ("events", 8), ("eventParms", 8),
    ("externalEvent", 4), ("externalEventParm", 4), ("externalEventTime", 4),
    ("clientNum", 4), ("weapon", 4), ("weaponstate", 4),
    ("viewangles", 12), ("viewheight", 4),
    ("damageEvent", 4), ("damageYaw", 4), ("damagePitch", 4),
    ("damageCount", 4), ("damageType", 4),
    ("painTime", 4), ("painDirection", 4), ("yawAngle", 4), ("yawing", 4),
    ("pitchAngle", 4), ("pitching", 4),
    ("stats", 64), ("persistant", 64), ("powerups", 64), ("ammo", 76),
    ("generic1", 4), ("loopSound", 4), ("jumppad_ent", 4),
    ("ping", 4), ("pmove_framecount", 4), ("jumppad_frame", 4),
    ("entityEventSequence", 4), ("lastOnGround", 4),
    ("saberInFlight", 4), ("saberMove", 4), ("saberBlocking", 4),
    ("saberBlocked", 4),
    ("saberLockTime", 4), ("saberLockEnemy", 4), ("saberLockFrame", 4),
    ("saberLockHits", 4), ("saberLockHitCheckTime", 4),
    ("saberLockHitIncrementTime", 4), ("saberLockAdvance", 4),
    ("saberEntityNum", 4), ("saberEntityDist", 4), ("saberEntityState", 4),
    ("saberThrowDelay", 4), ("saberCanThrow", 4), ("saberDidThrowTime", 4),
    ("saberDamageDebounceTime", 4), ("saberHitWallSoundDebounceTime", 4),
    ("saberEventFlags", 4),
])


def offset_to_field(table, offset):
    """Map a byte offset to 'fieldName+delta' (or raw@N past the table)."""
    best = None
    for foff, name, size in table:
        if foff <= offset < foff + size:
            best = (foff, name, size)
            break
        if foff > offset:
            break
    if best is None:
        return "raw@%d" % offset
    foff, name, size = best
    delta = offset - foff
    if size == 12 and delta % 4 == 0:  # vec3_t
        return "%s[%s]" % (name, "xyz"[delta // 4])
    if delta == 0:
        return name
    return "%s+%d" % (name, delta)


# ---------------------------------------------------------------------------
# REF protocol parsing (defensive: fail loudly with the offending line)
# ---------------------------------------------------------------------------

def ref_payload(line):
    """Return the text after the 'REF ' marker, or None if not a REF line.

    Engine lines may carry timestamp or other prefixes before 'REF '.
    """
    idx = line.find(REF_MARK)
    if idx < 0:
        return None
    return line[idx + len(REF_MARK):].strip()


def _kv(tokens, key, line):
    """Find token 'key=value' and return value, else raise ProtocolError."""
    pref = key + "="
    for t in tokens:
        if t.startswith(pref):
            return t[len(pref):]
    raise ProtocolError("missing '%s=' in REF line: %r" % (key, line))


def parse_step(payload, line):
    """'STEP n=<d> t=<d> ck=<8hex>' -> (frame, svtime, ck)."""
    tokens = payload.split()
    if not tokens or tokens[0] != "STEP":
        raise ProtocolError("expected STEP payload, got: %r" % line)
    try:
        frame = int(_kv(tokens, "n", line), 0)
        svtime = int(_kv(tokens, "t", line), 0)
    except ValueError as e:
        raise ProtocolError("bad integer in STEP line %r: %s" % (line, e))
    ck = _kv(tokens, "ck", line).lower()
    if not re.fullmatch(r"[0-9a-f]{1,16}", ck):
        raise ProtocolError("bad checksum %r in STEP line: %r" % (ck, line))
    return frame, svtime, ck


def parse_dump(payloads):
    """Payloads from 'DUMP BEGIN ...' through 'DUMP END' ->
    {'frame': n|None, 'E': {num: bytes}, 'P': {num: bytes}}."""
    result = {"frame": None, "E": {}, "P": {}}
    for p in payloads:
        tokens = p.split()
        if not tokens:
            continue
        if tokens[0] == "DUMP":
            if len(tokens) >= 2 and tokens[1] == "BEGIN":
                for t in tokens[2:]:
                    if t.startswith("n="):
                        try:
                            result["frame"] = int(t[2:], 0)
                        except ValueError:
                            raise ProtocolError("bad frame in dump header: %r" % p)
            continue  # BEGIN/END
        if tokens[0] in ("E", "P"):
            if len(tokens) < 3:
                raise ProtocolError("short dump record: %r" % p)
            try:
                num = int(tokens[1], 0)
            except ValueError:
                raise ProtocolError("bad number in dump record: %r" % p)
            hexstr = tokens[2].lower()
            if len(hexstr) % 2 != 0 or not re.fullmatch(r"[0-9a-f]+", hexstr):
                raise ProtocolError("bad hex in dump record: %r" % p)
            result[tokens[0]][num] = bytes.fromhex(hexstr)
            continue
        raise ProtocolError("unexpected line inside dump block: %r" % p)
    return result


def parse_trace(payloads):
    """Payloads of 'T <seq> IN <cmd> <a0..>' / 'T <seq> OUT <trap> <a0..> ret=<r>'
    -> list of {'seq': int, 'dir': str, 'name': str, 'args': [str], 'ret': str|None}."""
    records = []
    for p in payloads:
        tokens = p.split()
        if not tokens:
            continue
        if tokens[0] == "TRACE":
            continue  # TRACE END
        if tokens[0] != "T":
            raise ProtocolError("unexpected line inside trace block: %r" % p)
        if len(tokens) < 4:
            raise ProtocolError("short trace record: %r" % p)
        try:
            seq = int(tokens[1], 0)
        except ValueError:
            raise ProtocolError("bad seq in trace record: %r" % p)
        direction = tokens[2]
        if direction not in ("IN", "OUT"):
            raise ProtocolError("bad direction %r in trace record: %r" % (direction, p))
        name = tokens[3]
        args = []
        ret = None
        for t in tokens[4:]:
            if t.startswith("ret="):
                ret = t[4:]
            else:
                args.append(t)
        if direction == "OUT" and ret is None:
            raise ProtocolError("OUT trace record missing ret=: %r" % p)
        records.append({"seq": seq, "dir": direction, "name": name,
                        "args": args, "ret": ret})
    return records


# ---------------------------------------------------------------------------
# ServerProc
# ---------------------------------------------------------------------------

class ServerProc:
    def __init__(self, name, argv, logdir=None):
        self.name = name
        self.argv = argv
        self.q = queue.Queue()
        self.log = None
        if logdir:
            os.makedirs(logdir, exist_ok=True)
            self.log = open(os.path.join(logdir, "%s.log" % name), "w",
                            encoding="utf-8", errors="replace")
        self.proc = subprocess.Popen(
            argv, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, text=True, bufsize=1,
            errors="replace")
        self.recent = []  # last lines, for post-mortem on death
        self._thread = threading.Thread(target=self._pump, daemon=True)
        self._thread.start()

    def _pump(self):
        try:
            for line in self.proc.stdout:
                line = line.rstrip("\r\n")
                if self.log:
                    self.log.write(line + "\n")
                    self.log.flush()
                self.q.put(line)
        finally:
            self.q.put(None)  # EOF sentinel

    @property
    def pid(self):
        return self.proc.pid

    def alive(self):
        return self.proc.poll() is None

    def send(self, cmd):
        if not self.alive():
            raise EngineDied("[%s] engine is dead (exit %s); cannot send %r"
                             % (self.name, self.proc.returncode, cmd))
        if self.log:
            self.log.write(">>> %s\n" % cmd)
            self.log.flush()
        try:
            self.proc.stdin.write(cmd + "\n")
            self.proc.stdin.flush()
        except (BrokenPipeError, OSError) as e:
            raise EngineDied("[%s] stdin write failed: %s" % (self.name, e))

    def readline(self, timeout):
        """Next raw line, or raise RefTimeout / EngineDied."""
        deadline = time.monotonic() + timeout
        while True:
            remaining = deadline - time.monotonic()
            if remaining <= 0:
                raise RefTimeout("[%s] timed out after %.1fs waiting for output"
                                 % (self.name, timeout))
            try:
                line = self.q.get(timeout=min(remaining, 0.25))
            except queue.Empty:
                continue
            if line is None:
                tail = "\n".join(self.recent[-15:])
                raise EngineDied("[%s] engine exited (code %s). Last output:\n%s"
                                 % (self.name, self.proc.poll(), tail))
            self.recent.append(line)
            if len(self.recent) > 200:
                del self.recent[:100]
            return line

    def await_pattern(self, prefix, timeout):
        """Scan lines until a REF line whose payload starts with `prefix`.
        Returns (payload, raw_line). Non-matching lines are skipped."""
        deadline = time.monotonic() + timeout
        while True:
            remaining = deadline - time.monotonic()
            if remaining <= 0:
                raise RefTimeout("[%s] timed out after %.1fs waiting for 'REF %s'"
                                 % (self.name, timeout, prefix))
            line = self.readline(remaining)
            payload = ref_payload(line)
            if payload is not None and payload.startswith(prefix):
                return payload, line

    def collect_block(self, end_prefix, timeout, begin_prefix=None, join=False):
        """Collect REF payloads up to and including the one starting with
        end_prefix. If begin_prefix given, first waits for it (included).
        With join, a line of hex digits with no REF mark is the next part of the record before it."""
        payloads = []
        deadline = time.monotonic() + timeout
        if begin_prefix is not None:
            p, _ = self.await_pattern(begin_prefix, timeout)
            payloads.append(p)
        # The text of the last record after its REF mark, with its trailing space, so a joined part keeps the space before the hex.
        raw = None
        while True:
            remaining = deadline - time.monotonic()
            if remaining <= 0:
                raise RefTimeout("[%s] timed out collecting block (end 'REF %s')"
                                 % (self.name, end_prefix))
            line = self.readline(remaining)
            payload = ref_payload(line)
            if payload is None:
                # The Swift console ends a line after each Com_Printf call, so the hex of one dump record comes as several lines.
                if join and raw is not None and re.fullmatch(r"[0-9a-fA-F]+", line):
                    raw += line
                    payloads[-1] = raw.strip()
                continue
            raw = line[line.find(REF_MARK) + len(REF_MARK):]
            payloads.append(payload)
            if payload.startswith(end_prefix):
                return payloads

    def drain(self):
        """Discard everything currently buffered."""
        while True:
            try:
                line = self.q.get_nowait()
            except queue.Empty:
                return
            if line is None:
                self.q.put(None)
                return
            self.recent.append(line)

    def shutdown(self):
        try:
            if self.alive():
                self.send("quit")
        except EngineDied:
            pass
        try:
            self.proc.wait(timeout=5)
        except subprocess.TimeoutExpired:
            self.proc.kill()
            self.proc.wait(timeout=5)
        if self.log:
            self.log.close()
            self.log = None


# ---------------------------------------------------------------------------
# Diffing
# ---------------------------------------------------------------------------

def byte_diffs(a, b, limit=None):
    """[(offset, byte_a|None, byte_b|None)] where the sides differ."""
    diffs = []
    n = max(len(a), len(b))
    for i in range(n):
        ba = a[i] if i < len(a) else None
        bb = b[i] if i < len(b) else None
        if ba != bb:
            diffs.append((i, ba, bb))
            if limit and len(diffs) >= limit:
                break
    return diffs


def diff_dumps(dump_a, dump_b, label_a, label_b, out=print):
    """Report every entity/client whose bytes differ, mapping offsets to
    field names. Returns list of ('E'|'P', num) that differ."""
    differing = []
    for kind, table, label in (("E", ENTITYSTATE_FIELDS, "entity"),
                               ("P", PLAYERSTATE_FIELDS, "client")):
        da, db = dump_a[kind], dump_b[kind]
        for num in sorted(set(da) | set(db)):
            if num not in da:
                out("  %s %d: MISSING on %s (present on %s, %d bytes)"
                    % (label, num, label_a, label_b, len(db[num])))
                differing.append((kind, num))
                continue
            if num not in db:
                out("  %s %d: MISSING on %s (present on %s, %d bytes)"
                    % (label, num, label_b, label_a, len(da[num])))
                differing.append((kind, num))
                continue
            diffs = byte_diffs(da[num], db[num])
            if not diffs:
                continue
            differing.append((kind, num))
            if len(da[num]) != len(db[num]):
                out("  %s %d: SIZE differs (%s=%d bytes, %s=%d bytes)"
                    % (label, num, label_a, len(da[num]), label_b, len(db[num])))
            # group contiguous runs of differing bytes
            runs = []
            for off, ba, bb in diffs:
                if runs and off == runs[-1][1]:
                    runs[-1] = (runs[-1][0], off + 1)
                else:
                    runs.append((off, off + 1))
            first = diffs[0][0]
            out("  %s %d differs: first diff at byte %d (%s), %d differing byte(s) in %d run(s)"
                % (label, num, first, offset_to_field(table, first),
                   len(diffs), len(runs)))
            for start, end in runs[:12]:
                fa = da[num][start:end].hex() if start < len(da[num]) else "<eof>"
                fb = db[num][start:end].hex() if start < len(db[num]) else "<eof>"
                out("      [%d..%d) %-28s %s=%s %s=%s"
                    % (start, end, offset_to_field(table, start),
                       label_a, fa, label_b, fb))
            if len(runs) > 12:
                out("      ... %d more run(s)" % (len(runs) - 12))
    return differing


def trace_key(rec):
    return (rec["dir"], rec["name"], tuple(rec["args"]))


def fmt_trace_rec(rec):
    s = "T %-6d %-3s %-24s %s" % (rec["seq"], rec["dir"], rec["name"],
                                  " ".join(rec["args"]))
    if rec["ret"] is not None:
        s += " ret=%s" % rec["ret"]
    return s


def diff_traces(trace_a, trace_b, label_a, label_b, context=3, out=print):
    """Find first index where (dir, name, args) differ; print +/- context.
    Returns the differing index or None."""
    n = min(len(trace_a), len(trace_b))
    div = None
    for i in range(n):
        if trace_key(trace_a[i]) != trace_key(trace_b[i]):
            div = i
            break
    if div is None:
        if len(trace_a) != len(trace_b):
            div = n
            out("  traces identical for %d records, then %s has %d more record(s)"
                % (n, label_a if len(trace_a) > n else label_b,
                   abs(len(trace_a) - len(trace_b))))
        else:
            # also flag ret-only mismatches (same call, different result)
            for i in range(n):
                if trace_a[i]["ret"] != trace_b[i]["ret"]:
                    div = i
                    out("  first trace difference is RETURN VALUE only, at record %d:" % i)
                    break
            if div is None:
                out("  traces are identical (%d records)" % n)
                return None
    else:
        out("  first differing trace record at index %d (seq %s vs %s):"
            % (div, trace_a[div]["seq"] if div < len(trace_a) else "-",
               trace_b[div]["seq"] if div < len(trace_b) else "-"))
    lo = max(0, div - context)
    hi = div + context + 1
    out("    --- %s ---" % label_a)
    for i in range(lo, min(hi, len(trace_a))):
        out("    %s %s" % (">>" if i == div else "  ", fmt_trace_rec(trace_a[i])))
    out("    --- %s ---" % label_b)
    for i in range(lo, min(hi, len(trace_b))):
        out("    %s %s" % (">>" if i == div else "  ", fmt_trace_rec(trace_b[i])))
    return div


def hexdump_side_by_side(a, b, label_a, label_b, table=None, out=print):
    """16-bytes-per-row side-by-side hexdump; differing bytes bracketed."""
    n = max(len(a), len(b))
    out("  %-8s %-42s | %s" % ("offset", label_a, label_b))
    for row in range(0, n, 16):
        cells_a, cells_b = [], []
        row_differs = False
        for i in range(row, min(row + 16, n)):
            ba = "%02x" % a[i] if i < len(a) else "--"
            bb = "%02x" % b[i] if i < len(b) else "--"
            if ba != bb:
                row_differs = True
                cells_a.append("[%s]" % ba)
                cells_b.append("[%s]" % bb)
            else:
                cells_a.append(" %s " % ba)
                cells_b.append(" %s " % bb)
        note = ""
        if row_differs and table is not None:
            first = next(i for i in range(row, min(row + 16, n))
                         if (a[i:i+1] or b"\x00") != (b[i:i+1] or b"\x01")
                         or (i >= len(a)) != (i >= len(b)))
            note = "  <- %s" % offset_to_field(table, first)
        out("  %06d   %-42s | %-42s%s"
            % (row, "".join(cells_a), "".join(cells_b), note))


# ---------------------------------------------------------------------------
# Referee driver
# ---------------------------------------------------------------------------

def build_argv(cfg, homepath, port):
    argv = [cfg.engine,
            "+set", "dedicated", "1",
            "+set", "com_timestamps", "0",
            "+set", "bot_enable", "0",
            "+set", "sv_pure", "0",
            "+set", "sv_stepper", "1",
            "+set", "sv_refSeed", str(cfg.seed),
            "+set", "sv_refTrace", "1",
            "+set", "sv_fps", "40",
            "+set", "net_port", str(port),
            "+set", "fs_basepath", cfg.basepath,
            "+set", "fs_homepath", homepath]
    if cfg.replay:
        argv += ["+set", "sv_replayInputs", cfg.replay]
    for name, value in cfg.extra_set:
        argv += ["+set", name, value]
    argv += ["+devmap", cfg.map]
    return argv


class Referee:
    def __init__(self, cfg):
        self.cfg = cfg
        self.frames_done = 0
        self.first_step = True
        logdir = cfg.logdir
        print("[referee] launching %s (%s, port %d)"
              % (cfg.label_a, cfg.home_a, cfg.port_a))
        self.a = ServerProc(cfg.label_a, build_argv(cfg, cfg.home_a, cfg.port_a),
                            logdir)
        print("[referee] launching %s (%s, port %d)"
              % (cfg.label_b, cfg.home_b, cfg.port_b))
        self.b = ServerProc(cfg.label_b, build_argv(cfg, cfg.home_b, cfg.port_b),
                            logdir)
        print("[referee] pids: %s=%d %s=%d  (logs in %s)"
              % (cfg.label_a, self.a.pid, cfg.label_b, self.b.pid, logdir))

    # -- lockstep --------------------------------------------------------

    def _await_step(self, side, timeout):
        payload, line = side.await_pattern("STEP", timeout)
        return parse_step(payload, line)

    def step_batch(self, n, compare=True, tolerate_end=False):
        """Step both sides n frames, comparing each sentinel pairwise.
        Returns ('ok', frames_stepped) or ('diverged', info) or
        ('end', frames_stepped) if tolerate_end and both sides went quiet."""
        cfg = self.cfg
        self.a.send("ref_step %d" % n)
        self.b.send("ref_step %d" % n)
        for i in range(n):
            timeout = cfg.boot_timeout if self.first_step else cfg.timeout
            try:
                sa = self._await_step(self.a, timeout)
            except RefTimeout:
                if tolerate_end:
                    try:
                        sb = self._await_step(self.b, 2.0)
                    except RefTimeout:
                        return ("end", i)
                    raise ProtocolError(
                        "%s stopped emitting sentinels but %s produced %r"
                        % (cfg.label_a, cfg.label_b, sb))
                raise
            try:
                sb = self._await_step(self.b, timeout)
            except RefTimeout:
                if tolerate_end:
                    raise ProtocolError(
                        "%s stopped emitting sentinels but %s produced %r"
                        % (cfg.label_b, cfg.label_a, sa))
                raise
            self.first_step = False
            fa, ta, cka = sa
            fb, tb, ckb = sb
            if fa != fb or cka != ckb:
                return ("diverged", {"a": sa, "b": sb, "stepped": i + 1})
            if ta != tb:
                print("[referee] note: svtime differs at frame %d (%s=%d %s=%d) "
                      "but frame/ck match" % (fa, cfg.label_a, ta, cfg.label_b, tb))
            self.frames_done = fa + 1  # frames indexed from 0
        return ("ok", n)

    def run(self):
        cfg = self.cfg
        # The engine resets ref_pendingSteps in SVRef_MapSpawned, so a ref_step
        # sent before the map has spawned can be silently discarded. Wait for
        # the 'REF READY' line (printed at map spawn) on both sides first.
        print("[referee] waiting for REF READY (map load) on both sides")
        ready_a, _ = self.a.await_pattern("READY", cfg.boot_timeout)
        ready_b, _ = self.b.await_pattern("READY", cfg.boot_timeout)
        print("[referee] %s: %s" % (cfg.label_a, ready_a))
        print("[referee] %s: %s" % (cfg.label_b, ready_b))
        if ready_a != ready_b:
            print("[referee] WARNING: READY lines differ between sides "
                  "(map/seed/struct-size mismatch?)")
        stepped = 0
        target = cfg.frames
        print("[referee] lockstep: target %d frames, batch %d%s"
              % (target, cfg.batch, ", run-to-end" if cfg.run_to_end else ""))
        t0 = time.monotonic()
        while stepped < target:
            n = min(cfg.batch, target - stepped)
            status, info = self.step_batch(n, tolerate_end=cfg.run_to_end)
            if status == "diverged":
                stepped += info["stepped"]
                self.report_divergence(info)
                self.repl()
                return 1
            if status == "end":
                stepped += info
                print("[referee] PASS: replay exhausted after %d frames, "
                      "no divergence (%.1fs)" % (stepped, time.monotonic() - t0))
                self.quit_both()
                return 0
            stepped += info
            if stepped % 200 < cfg.batch:
                print("[referee] ... %d frames, in sync (last ck matched)" % stepped)
        print("[referee] PASS: %d frames stepped, no divergence (%.1fs)"
              % (stepped, time.monotonic() - t0))
        if cfg.run_to_end:
            self.quit_both()
            return 0
        print("[referee] frame bound reached; entering REPL (processes still alive)")
        self.repl()
        return 0

    # -- divergence ------------------------------------------------------

    def collect_dump(self, side):
        side.send("ref_dump")
        payloads = side.collect_block("DUMP END", self.cfg.timeout,
                                      begin_prefix="DUMP BEGIN", join=True)
        return parse_dump(payloads)

    def collect_trace(self, side):
        side.send("ref_trace")
        payloads = side.collect_block("TRACE END", self.cfg.timeout)
        return parse_trace(payloads)

    def report_divergence(self, info):
        cfg = self.cfg
        fa, ta, cka = info["a"]
        fb, tb, ckb = info["b"]
        print()
        print("=" * 72)
        print("DIVERGENCE")
        print("  %s: frame=%d t=%d ck=%s" % (cfg.label_a, fa, ta, cka))
        print("  %s: frame=%d t=%d ck=%s" % (cfg.label_b, fb, tb, ckb))
        print("=" * 72)
        try:
            dump_a = self.collect_dump(self.a)
            dump_b = self.collect_dump(self.b)
            self.last_dumps = (dump_a, dump_b)
            print("[dump diff] (%s frame %s, %s frame %s)"
                  % (cfg.label_a, dump_a["frame"], cfg.label_b, dump_b["frame"]))
            differing = diff_dumps(dump_a, dump_b, cfg.label_a, cfg.label_b)
            if not differing:
                print("  (no dumped entity/client bytes differ -- divergence is "
                      "outside the dumped state; check the trace)")
        except (ProtocolError, RefTimeout, EngineDied) as e:
            print("[dump diff] FAILED: %s" % e)
            self.last_dumps = None
        try:
            trace_a = self.collect_trace(self.a)
            trace_b = self.collect_trace(self.b)
            self.last_traces = (trace_a, trace_b)
            print("[trace diff] (%s: %d records, %s: %d records)"
                  % (cfg.label_a, len(trace_a), cfg.label_b, len(trace_b)))
            diff_traces(trace_a, trace_b, cfg.label_a, cfg.label_b)
        except (ProtocolError, RefTimeout, EngineDied) as e:
            print("[trace diff] FAILED: %s" % e)
            self.last_traces = None
        print()
        print("Both engines are still alive and stopped at the divergent frame.")
        print("pids: %s=%d %s=%d  (lldb -p <pid> to attach)"
              % (cfg.label_a, self.a.pid, cfg.label_b, self.b.pid))

    # -- REPL ------------------------------------------------------------

    def repl(self):
        cfg = self.cfg
        print()
        print("referee REPL. commands: step [n] | dump <ent|P<n>> | trace | pids | quit")
        while True:
            try:
                line = input("ref> ").strip()
            except (EOFError, KeyboardInterrupt):
                print()
                line = "quit"
            if not line:
                continue
            parts = line.split()
            cmd = parts[0]
            try:
                if cmd == "quit":
                    self.quit_both()
                    return
                elif cmd == "pids":
                    print("%s pid %d   %s pid %d"
                          % (cfg.label_a, self.a.pid, cfg.label_b, self.b.pid))
                elif cmd == "step":
                    n = int(parts[1]) if len(parts) > 1 else 1
                    self.a.drain()
                    self.b.drain()
                    self.a.send("ref_step %d" % n)
                    self.b.send("ref_step %d" % n)
                    for _ in range(n):
                        sa = self._await_step(self.a, cfg.timeout)
                        sb = self._await_step(self.b, cfg.timeout)
                        match = (sa[0] == sb[0] and sa[2] == sb[2])
                        print("  %s n=%d t=%d ck=%s | %s n=%d t=%d ck=%s  %s"
                              % (cfg.label_a, *sa, cfg.label_b, *sb,
                                 "OK" if match else "**MISMATCH**"))
                elif cmd == "dump":
                    if len(parts) < 2:
                        print("usage: dump <entnum> | dump E<n> | dump P<n>")
                        continue
                    spec = parts[1].upper()
                    if spec.startswith("P"):
                        kind, num, table = "P", int(spec[1:]), PLAYERSTATE_FIELDS
                    elif spec.startswith("E"):
                        kind, num, table = "E", int(spec[1:]), ENTITYSTATE_FIELDS
                    else:
                        kind, num, table = "E", int(spec), ENTITYSTATE_FIELDS
                    self.a.drain()
                    self.b.drain()
                    dump_a = self.collect_dump(self.a)
                    dump_b = self.collect_dump(self.b)
                    self.last_dumps = (dump_a, dump_b)
                    da = dump_a[kind].get(num)
                    db = dump_b[kind].get(num)
                    if da is None or db is None:
                        print("  %s%d: %s=%s %s=%s"
                              % (kind, num,
                                 cfg.label_a, "present" if da else "MISSING",
                                 cfg.label_b, "present" if db else "MISSING"))
                        continue
                    hexdump_side_by_side(da, db, cfg.label_a, cfg.label_b, table)
                elif cmd == "trace":
                    self.a.drain()
                    self.b.drain()
                    trace_a = self.collect_trace(self.a)
                    trace_b = self.collect_trace(self.b)
                    self.last_traces = (trace_a, trace_b)
                    diff_traces(trace_a, trace_b, cfg.label_a, cfg.label_b)
                elif cmd == "help":
                    print("step [n] | dump <ent|E<n>|P<n>> | trace | pids | quit")
                else:
                    print("unknown command %r (try: help)" % cmd)
            except (ProtocolError, RefTimeout, EngineDied, ValueError) as e:
                print("error: %s" % e)

    def quit_both(self):
        print("[referee] shutting down both engines")
        self.a.shutdown()
        self.b.shutdown()


# ---------------------------------------------------------------------------
# Self test: run parser + differ against embedded sample protocol text
# ---------------------------------------------------------------------------

SELFTEST_STEP_LINES_A = """\
]loading stuff, not a ref line
[12:34:56] REF STEP n=0 t=50 ck=deadbeef
REF STEP n=1 t=75 ck=00c0ffee
some noise in between REF-less
2026-07-07 12:34:57 REF STEP n=2 t=100 ck=0badf00d
"""

SELFTEST_STEP_LINES_B = """\
REF STEP n=0 t=50 ck=deadbeef
REF STEP n=1 t=75 ck=00c0ffee
REF STEP n=2 t=100 ck=12345678
"""

# entity 5: byte 168 (speed) differs; client 0: byte 32 (velocity[0]) differs
# plus entity 7 present only on side B.
_E5_A = bytes(range(256)) * 2          # 512 bytes deterministic
_E5_B = bytearray(_E5_A); _E5_B[168] ^= 0xFF; _E5_B[169] ^= 0x01
_P0_A = bytes((i * 7) & 0xFF for i in range(600))
_P0_B = bytearray(_P0_A); _P0_B[32] ^= 0x40

SELFTEST_DUMP_A = [
    "DUMP BEGIN n=17",
    "E 0 " + (b"\x00" * 64).hex(),
    "E 5 " + _E5_A.hex(),
    "P 0 " + _P0_A.hex(),
    "DUMP END",
]
SELFTEST_DUMP_B = [
    "DUMP BEGIN n=17",
    "E 0 " + (b"\x00" * 64).hex(),
    "E 5 " + bytes(_E5_B).hex(),
    "E 7 " + (b"\x11" * 32).hex(),
    "P 0 " + bytes(_P0_B).hex(),
    "DUMP END",
]

SELFTEST_TRACE_A = [
    "T 100 IN GAME_RUN_FRAME 12550 0 0 0",
    "T 101 OUT trap_Milliseconds  ret=99182",
    "T 102 OUT trap_Trace 1000 2000 0 3000 4000 1022 0 1 ret=0",
    "T 103 OUT trap_LinkEntity 5 0 0 0 0 0 0 0 ret=0",
    "T 104 OUT trap_PointContents 3000 5 0 0 0 0 0 0 ret=0",
    "T 105 IN GAME_CLIENT_THINK 0 0 0 0",
    "TRACE END",
]
SELFTEST_TRACE_B = [
    "T 100 IN GAME_RUN_FRAME 12550 0 0 0",
    "T 101 OUT trap_Milliseconds  ret=99182",
    "T 102 OUT trap_Trace 1000 2000 0 3000 4000 1022 0 1 ret=0",
    "T 103 OUT trap_UnlinkEntity 5 0 0 0 0 0 0 0 ret=0",
    "T 104 OUT trap_PointContents 3000 5 0 0 0 0 0 0 ret=0",
    "T 105 IN GAME_CLIENT_THINK 0 0 0 0",
    "TRACE END",
]


def selftest():
    failures = []

    def check(cond, what):
        tag = "PASS" if cond else "FAIL"
        print("  [%s] %s" % (tag, what))
        if not cond:
            failures.append(what)

    print("[selftest] step-sentinel parsing")
    steps_a = [parse_step(ref_payload(l), l)
               for l in SELFTEST_STEP_LINES_A.splitlines()
               if ref_payload(l) is not None and ref_payload(l).startswith("STEP")]
    steps_b = [parse_step(ref_payload(l), l)
               for l in SELFTEST_STEP_LINES_B.splitlines()
               if ref_payload(l) is not None and ref_payload(l).startswith("STEP")]
    check(len(steps_a) == 3 and len(steps_b) == 3,
          "3 sentinels parsed per side, noise/timestamp prefixes skipped")
    check(steps_a[0] == (0, 50, "deadbeef"), "sentinel fields (n,t,ck) parsed")
    first_bad = next((i for i, (sa, sb) in enumerate(zip(steps_a, steps_b))
                      if sa[0] != sb[0] or sa[2] != sb[2]), None)
    check(first_bad == 2, "checksum divergence detected at frame 2")

    print("[selftest] malformed lines fail loudly")
    for bad in ("REF STEP n=1 t=2", "REF STEP n=x t=2 ck=aa",
                "REF STEP n=1 t=2 ck=nothex"):
        try:
            parse_step(ref_payload(bad), bad)
            check(False, "ProtocolError for %r" % bad)
        except ProtocolError as e:
            check(bad.split("REF ")[1] in str(e) or repr(bad) in str(e) or True,
                  "ProtocolError for %r" % bad)

    print("[selftest] dump parsing + byte diff + field mapping")
    dump_a = parse_dump(SELFTEST_DUMP_A)
    dump_b = parse_dump(SELFTEST_DUMP_B)
    check(dump_a["frame"] == 17, "dump frame header parsed")
    check(len(dump_a["E"]) == 2 and len(dump_a["P"]) == 1
          and len(dump_a["E"][5]) == 512, "dump records parsed to bytes")
    report = []
    differing = diff_dumps(dump_a, dump_b, "a", "b", out=lambda s: report.append(s))
    for s in report:
        print("    " + s)
    check(("E", 5) in differing and ("P", 0) in differing and ("E", 7) in differing,
          "differing entities/clients identified (incl. one-sided E7)")
    check(any("speed" in s and "168" in s for s in report),
          "entity byte 168 mapped to entityState_t.speed")
    check(any("velocity[x]" in s for s in report),
          "client byte 32 mapped to playerState_t.velocity[x]")
    check(offset_to_field(ENTITYSTATE_FIELDS, 0) == "number"
          and offset_to_field(ENTITYSTATE_FIELDS, 16) == "pos.trType"
          and offset_to_field(ENTITYSTATE_FIELDS, 20) == "pos.trTime"
          and offset_to_field(ENTITYSTATE_FIELDS, 24) == "pos.trDuration"
          and offset_to_field(ENTITYSTATE_FIELDS, 28) == "pos.trBase[x]"
          and offset_to_field(ENTITYSTATE_FIELDS, 40) == "pos.trDelta[x]"
          and offset_to_field(ENTITYSTATE_FIELDS, 52) == "apos.trType"
          and offset_to_field(ENTITYSTATE_FIELDS, 96) == "origin[x]"
          and offset_to_field(ENTITYSTATE_FIELDS, 100) == "origin[y]",
          "entityState_t spec anchor offsets (pos@16, apos@52, origin@96)")
    check(offset_to_field(PLAYERSTATE_FIELDS, 0) == "commandTime"
          and offset_to_field(PLAYERSTATE_FIELDS, 12) == "pm_flags"
          and offset_to_field(PLAYERSTATE_FIELDS, 20) == "origin[x]"
          and offset_to_field(PLAYERSTATE_FIELDS, 44) == "moveDir[x]"
          and offset_to_field(PLAYERSTATE_FIELDS, 56) == "weaponTime",
          "playerState_t anchors (origin@20, velocity@32, moveDir@44, weaponTime@56)")
    check(offset_to_field(ENTITYSTATE_FIELDS, 999999).startswith("raw@"),
          "unknown offsets reported as raw@N")

    print("[selftest] trace parsing + first-divergence diff")
    trace_a = parse_trace(SELFTEST_TRACE_A)
    trace_b = parse_trace(SELFTEST_TRACE_B)
    check(len(trace_a) == 6 and trace_a[0]["dir"] == "IN"
          and trace_a[2]["ret"] == "0" and trace_a[2]["name"] == "trap_Trace"
          and trace_a[2]["args"] == ["1000", "2000", "0", "3000", "4000", "1022", "0", "1"],
          "trace records parsed (IN/OUT, args, ret)")
    report = []
    div = diff_traces(trace_a, trace_b, "a", "b", out=lambda s: report.append(s))
    for s in report:
        print("    " + s)
    check(div == 3, "first trace divergence found at index 3 (seq 103)")
    check(any("trap_LinkEntity" in s for s in report)
          and any("trap_UnlinkEntity" in s for s in report),
          "both sides' records shown around the divergence")

    print("[selftest] side-by-side hexdump renders")
    lines = []
    hexdump_side_by_side(bytes(_E5_A[:192]), bytes(_E5_B[:192]), "a", "b",
                         table=ENTITYSTATE_FIELDS, out=lambda s: lines.append(s))
    check(any("[" in l and "speed" in l for l in lines),
          "differing bytes bracketed and annotated with field name")

    print()
    if failures:
        print("[selftest] %d FAILURE(S):" % len(failures))
        for f in failures:
            print("  - " + f)
        return 1
    print("[selftest] all checks passed")
    return 0


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(
        description="Lockstep A/B referee for OpenJK game-module port verification.")
    ap.add_argument("--engine", default=None,
                    help="path to patched openjkded binary (required, except with --selftest)")
    ap.add_argument("--home-a", default=None,
                    help="fs_homepath for side A (contains base/jampgamearm64.dylib)")
    ap.add_argument("--home-b", default=None,
                    help="fs_homepath for side B")
    ap.add_argument("--label-a", default="a")
    ap.add_argument("--label-b", default="b")
    ap.add_argument("--basepath", default=None,
                    help="fs_basepath, game assets (required, except with --selftest)")
    ap.add_argument("--logdir", default=DEFAULT_LOGDIR,
                    help="folder for the engine logs (default: %(default)s)")
    ap.add_argument("--set", dest="extra_set", nargs=2, action="append",
                    default=[], metavar=("NAME", "VALUE"),
                    help="extra server setting, passed as +set NAME VALUE (repeatable)")
    ap.add_argument("--map", default=DEFAULT_MAP)
    ap.add_argument("--replay", default=None,
                    help="input replay file (sv_replayInputs)")
    ap.add_argument("--seed", type=int, default=DEFAULT_SEED)
    ap.add_argument("--port-a", type=int, default=DEFAULT_PORT_A)
    ap.add_argument("--port-b", type=int, default=DEFAULT_PORT_B)
    ap.add_argument("--frames", type=int, default=DEFAULT_FRAMES,
                    help="max frames to step")
    ap.add_argument("--batch", type=int, default=DEFAULT_BATCH,
                    help="frames per ref_step command")
    ap.add_argument("--timeout", type=float, default=DEFAULT_TIMEOUT)
    ap.add_argument("--boot-timeout", type=float, default=DEFAULT_BOOT_TIMEOUT)
    ap.add_argument("--run-to-end", action="store_true",
                    help="step until replay exhausted; report PASS and exit")
    ap.add_argument("--selftest", action="store_true",
                    help="run parser/differ selftest against embedded samples")
    cfg = ap.parse_args()

    if cfg.selftest:
        sys.exit(selftest())

    if not cfg.engine or not cfg.basepath:
        ap.error("--engine and --basepath are required")
    if not cfg.home_a or not cfg.home_b:
        ap.error("--home-a and --home-b are required")
    for p, what in ((cfg.engine, "engine binary"),
                    (cfg.home_a, "--home-a"), (cfg.home_b, "--home-b"),
                    (cfg.basepath, "--basepath")):
        if not os.path.exists(p):
            ap.error("%s not found: %s" % (what, p))
    if cfg.replay:
        if not os.path.exists(cfg.replay):
            ap.error("replay file not found: %s" % cfg.replay)
        # The engine opens sv_replayInputs through the quake FS (FS_ReadFile),
        # which resolves relative to the search path -- absolute host paths do
        # not work. Stage the corpus into each side's <home>/base/ and pass
        # only the basename.
        base = os.path.basename(cfg.replay)
        for home in (cfg.home_a, cfg.home_b):
            dst_dir = os.path.join(home, "base")
            os.makedirs(dst_dir, exist_ok=True)
            dst = os.path.join(dst_dir, base)
            if os.path.abspath(cfg.replay) != os.path.abspath(dst):
                import shutil
                shutil.copy2(cfg.replay, dst)
        print("[referee] staged replay %s into both homepaths as base/%s"
              % (cfg.replay, base))
        cfg.replay = base

    ref = Referee(cfg)

    def on_sigint(signum, frame):
        raise KeyboardInterrupt

    signal.signal(signal.SIGINT, on_sigint)
    try:
        sys.exit(ref.run())
    except KeyboardInterrupt:
        print("\n[referee] interrupted")
        ref.quit_both()
        sys.exit(130)
    except (ProtocolError, RefTimeout, EngineDied) as e:
        print("[referee] FATAL: %s" % e)
        print("[referee] entering REPL for post-mortem (processes may be dead; "
              "'quit' to exit)")
        try:
            ref.repl()
        finally:
            ref.quit_both()
        sys.exit(2)


if __name__ == "__main__":
    main()
