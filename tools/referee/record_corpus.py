#!/usr/bin/env python3
"""record_corpus.py - record a bot-driven input corpus with the referee engine.

This script starts one patched openjkded with `sv_stepper` and `sv_recordInputs`.
It waits for `REF READY` and adds bots.
Then it grants frames one at a time with `ref_step 1` and waits for each `REF STEP` sentinel.
The engine makes bot usercmds once for each `SV_Frame` call.
At the end, the script quits the engine and verifies the recorded corpus.

The engine writes the record file through the quake file system, so the file lands at `<fs_homepath>/base/<name>`.
If `--copy-to` is given, the script copies the finished corpus there for use with `referee.py --replay`.

This script uses `ServerProc` and the protocol parsing from `referee.py` in the same directory.
It needs only the Python standard library.
"""

import argparse
import os
import shutil
import struct
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from referee import (ServerProc, ref_payload, parse_step,  # noqa: E402
                     ProtocolError, EngineDied, RefTimeout)

DEFAULT_LOGDIR = "/tmp/referee-scratch/logs"
DEFAULT_BOTS = "Desann:4,Alora:4,Tavion:4,Reelo:4"


def parse_ready(payload):
    """'READY map=.. seed=.. fps=.. es=.. er=.. ps=.. cmd=..' -> dict."""
    info = {}
    for tok in payload.split()[1:]:
        if "=" in tok:
            k, v = tok.split("=", 1)
            info[k] = v
    return info


def verify_corpus(path, cmd_size):
    """Parse a REFREC v1 file; return (header_line, per-client stats dict)."""
    with open(path, "rb") as f:
        data = f.read()
    nl = data.find(b"\n")
    if nl < 0 or not data.startswith(b"REFREC v1 "):
        raise SystemExit("corpus %s: bad header" % path)
    header = data[:nl].decode("ascii", "replace")
    off = nl + 1
    stats = {}  # client -> {"cmds": n, "userinfo": str, "disconnects": n,
    #                        "first_frame": f, "last_frame": f}
    while off + 8 <= len(data):
        frame, rtype, client, ln = struct.unpack_from("<IBBH", data, off)
        off += 8
        payload_len = cmd_size if rtype == 1 else ln if rtype == 2 else 0
        if off + payload_len > len(data):
            raise SystemExit("corpus %s: truncated record at offset %d"
                             % (path, off - 8))
        st = stats.setdefault(client, {"cmds": 0, "userinfo": None,
                                       "disconnects": 0,
                                       "first_frame": frame, "last_frame": frame})
        st["last_frame"] = frame
        if rtype == 1:
            st["cmds"] += 1
        elif rtype == 2:
            st["userinfo"] = data[off:off + payload_len].decode("ascii", "replace")
        elif rtype == 3:
            st["disconnects"] += 1
        else:
            raise SystemExit("corpus %s: unknown record type %d at offset %d"
                             % (path, rtype, off - 8))
        off += payload_len
    if off != len(data):
        raise SystemExit("corpus %s: %d trailing byte(s)" % (path, len(data) - off))
    return header, stats


def main():
    ap = argparse.ArgumentParser(description="Record a bot input corpus.")
    ap.add_argument("--engine", required=True,
                    help="path to the patched openjkded binary")
    ap.add_argument("--module", required=True,
                    help="game module copied into <home>/base")
    ap.add_argument("--basepath", required=True,
                    help="fs_basepath (game assets)")
    ap.add_argument("--home", required=True,
                    help="fs_homepath scratch dir (record file lands in its base/)")
    ap.add_argument("--map", default="mp/ffa1")
    ap.add_argument("--out", default="corpus-ffa1.rec",
                    help="record filename (relative, quake FS)")
    ap.add_argument("--copy-to", default=None,
                    help="where to copy the finished corpus "
                         "(no copy when absent)")
    ap.add_argument("--logdir", default=DEFAULT_LOGDIR,
                    help="folder for the engine log (default: %(default)s)")
    ap.add_argument("--set", dest="extra_set", nargs=2, action="append",
                    default=[], metavar=("NAME", "VALUE"),
                    help="extra server setting, passed as +set NAME VALUE (repeatable)")
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--frames", type=int, default=2400)
    ap.add_argument("--bots", default=DEFAULT_BOTS,
                    help="comma list of name:skill")
    ap.add_argument("--warmup", type=int, default=40,
                    help="frames stepped right after addbot before the count "
                         "check (part of --frames total)")
    ap.add_argument("--min-bots", type=int, default=2)
    ap.add_argument("--timeout", type=float, default=15.0)
    ap.add_argument("--boot-timeout", type=float, default=180.0)
    cfg = ap.parse_args()

    copy_to = cfg.copy_to

    for p, what in ((cfg.engine, "engine"), (cfg.module, "module"),
                    (cfg.basepath, "basepath")):
        if not os.path.exists(p):
            ap.error("%s not found: %s" % (what, p))

    os.makedirs(os.path.join(cfg.home, "base"), exist_ok=True)
    shutil.copy2(cfg.module, os.path.join(cfg.home, "base", "jampgamearm64.dylib"))
    rec_ospath = os.path.join(cfg.home, "base", cfg.out)
    if os.path.exists(rec_ospath):
        os.remove(rec_ospath)

    argv = [cfg.engine,
            "+set", "dedicated", "1",
            "+set", "sv_pure", "0",
            "+set", "com_timestamps", "0",
            "+set", "sv_fps", "40",
            "+set", "sv_stepper", "1",
            "+set", "sv_refSeed", str(cfg.seed),
            "+set", "sv_recordInputs", cfg.out,
            "+set", "bot_enable", "1",
            "+set", "fs_basepath", cfg.basepath,
            "+set", "fs_homepath", cfg.home]
    for name, value in cfg.extra_set:
        argv += ["+set", name, value]
    argv += ["+devmap", cfg.map]

    print("[record] launching engine (map %s, seed %d, out %s)"
          % (cfg.map, cfg.seed, rec_ospath))
    srv = ServerProc("record", argv, logdir=cfg.logdir)
    print("[record] pid %d, log %s" % (srv.pid, os.path.join(cfg.logdir, "record.log")))
    exit_code = 1
    try:
        payload, _ = srv.await_pattern("READY", cfg.boot_timeout)
        info = parse_ready(payload)
        print("[record] REF READY: %s" % payload)
        cmd_size = int(info.get("cmd", "0"))
        if cmd_size <= 0:
            raise ProtocolError("REF READY missing usercmd size (cmd=): %r" % payload)
        if int(info.get("seed", cfg.seed)) != cfg.seed:
            print("[record] WARNING: engine seed %s != requested %d"
                  % (info.get("seed"), cfg.seed))

        bots = []
        for spec in cfg.bots.split(","):
            spec = spec.strip()
            if not spec:
                continue
            name, _, skill = spec.partition(":")
            bots.append((name, skill or "4"))
        for name, skill in bots:
            srv.send("addbot %s %s" % (name, skill))
        print("[record] requested %d bot(s): %s"
              % (len(bots), ", ".join(n for n, _ in bots)))

        def step_one(timeout):
            srv.send("ref_step 1")
            payload, line = srv.await_pattern("STEP", timeout)
            return parse_step(payload, line)

        t0 = time.monotonic()
        stepped = 0
        # warmup: let addbot spawn-queue drain so we can sanity-check joins
        for _ in range(min(cfg.warmup, cfg.frames)):
            step_one(cfg.boot_timeout if stepped == 0 else cfg.timeout)
            stepped += 1
        srv.drain()
        joined = [n for n, _ in bots
                  if any(n.lower() in l.lower() and "entered the game" in l.lower()
                         for l in srv.recent)]
        errors = [l for l in srv.recent
                  if "error" in l.lower() or "can't find" in l.lower()
                  or "not defined" in l.lower()]
        for l in errors:
            print("[record] engine said: %s" % l)
        print("[record] joined after warmup (join messages seen): %s"
              % (", ".join(joined) or "<none detected -- will verify via corpus>"))

        while stepped < cfg.frames:
            st = step_one(cfg.timeout)
            stepped += 1
            if stepped % 400 == 0:
                print("[record] ... %d/%d frames (engine frame %d, t=%d, %.1fs)"
                      % (stepped, cfg.frames, st[0], st[1], time.monotonic() - t0))
        print("[record] %d frames stepped in %.1fs; quitting engine"
              % (stepped, time.monotonic() - t0))
        srv.send("quit")
        srv.proc.wait(timeout=15)

        if not os.path.exists(rec_ospath):
            raise SystemExit("record file was not written: %s" % rec_ospath)
        header, stats = verify_corpus(rec_ospath, cmd_size)
        print("[record] corpus header: %s" % header)
        print("[record] usercmd size: %d bytes" % cmd_size)
        active = 0
        for client in sorted(stats):
            st = stats[client]
            name = "?"
            if st["userinfo"]:
                # userinfo is an \key\value info string
                parts = st["userinfo"].split("\\")
                for i in range(1, len(parts) - 1, 2):
                    if parts[i] == "name":
                        name = parts[i + 1]
                        break
            print("[record]   client %d (%s): %d usercmds, frames %d..%d, "
                  "%d disconnect(s)"
                  % (client, name, st["cmds"], st["first_frame"],
                     st["last_frame"], st["disconnects"]))
            if st["cmds"] >= cfg.frames // 2:
                active += 1
        if active < cfg.min_bots:
            print("[record] FAIL: only %d client(s) with a substantial cmd "
                  "stream (need >= %d)" % (active, cfg.min_bots))
        else:
            if copy_to:
                shutil.copy2(rec_ospath, copy_to)
                print("[record] PASS: %d active bot(s); corpus copied to %s (%d bytes)"
                      % (active, copy_to, os.path.getsize(copy_to)))
            else:
                print("[record] PASS: %d active bot(s); corpus at %s (%d bytes)"
                      % (active, rec_ospath, os.path.getsize(rec_ospath)))
            exit_code = 0
    except (ProtocolError, EngineDied, RefTimeout) as e:
        print("[record] FATAL: %s" % e)
    finally:
        srv.shutdown()
    sys.exit(exit_code)


if __name__ == "__main__":
    main()
