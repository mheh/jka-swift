#!/usr/bin/env python3
"""reflog2rec.py: a jka-rust referee input log as an engine recording.

A `.reflog` is the text input log of the jka-rust harness, `jka-rust/tools/referee-oracle/logs/*.reflog`, one `cmd` line per client per frame.
A `.rec` is the recording the OpenJK fork replays through fake clients, `openjk/codemp/server/sv_referee.cpp`, one header line and binary records.
The converter writes one type 2 record per client at frame 0 with the log's userinfo, then one type 1 record per `cmd` line, with the log's angles,
buttons, moves, weapon, and force selection in Raven's `usercmd_t` layout, and a type 3 record per client after the last frame.
The server time of a command is the frame's time at the log's `msec`, and the game clamps it into its own window on arrival.
A log on a mock map, such as `arena3`, has no BSP in the engine and does not convert.

Usage:
  python3 tools/reflog2rec.py jka-rust/tools/referee-oracle/logs/real-ffa1-items.reflog /tmp/jka-load/home/swift/reflog-real-ffa1-items.rec
"""

from __future__ import annotations

import struct
import sys
from pathlib import Path

# Raven's `usercmd_t` is 27 bytes of fields and one byte of padding, so the record is 28 bytes, the engine's `sizeof`.
USERCMD = struct.Struct("<iiiiiBBBBbbbx")
RECORD = struct.Struct("<IBBH")


def convert(source: Path, target: Path) -> tuple[str, int, int]:
    """Writes the recording and returns the map, the client count, and the command count."""
    header: dict[str, str] = {}
    userinfo: dict[int, str] = {}
    commands: list[tuple[int, int, bytes]] = []
    for line in source.read_text(encoding="latin-1").splitlines():
        if not line or line.startswith("#"):
            continue
        words = line.split(" ", 1)
        key = words[0]
        if key == "userinfo":
            number, text = words[1].split(" ", 1)
            userinfo[int(number)] = text
        elif key == "cmd":
            fields = words[1].split()
            frame, client = int(fields[0]), int(fields[1])
            angles = [int(fields[2]), int(fields[3]), int(fields[4])]
            buttons = int(fields[5])
            forward, right, up = int(fields[6]), int(fields[7]), int(fields[8])
            weapon, forcesel = int(fields[9]), int(fields[10])
            commands.append((frame, client, (angles, buttons, forward, right, up, weapon, forcesel)))
        else:
            header[key] = words[1] if len(words) > 1 else ""
    msec = int(header["msec"])
    fps = 1000 // msec
    out = bytearray(f"REFREC v1 map={header['map']} seed={header['seed']} fps={fps}\n".encode())
    for number in sorted(userinfo):
        text = userinfo[number].encode("latin-1")
        out += RECORD.pack(0, 2, number, len(text)) + text
    last = 0
    for frame, client, (angles, buttons, forward, right, up, weapon, forcesel) in commands:
        record_frame = frame + 1
        last = max(last, record_frame)
        server_time = int(header["starttime"]) + record_frame * msec
        out += RECORD.pack(record_frame, 1, client, 0)
        out += USERCMD.pack(server_time, angles[0], angles[1], angles[2], buttons, weapon, forcesel, 0, 0, forward, right, up)
    for number in sorted(userinfo):
        out += RECORD.pack(last + 1, 3, number, 0)
    target.write_bytes(out)
    return header["map"], len(userinfo), len(commands)


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__)
        return 2
    source, target = Path(sys.argv[1]), Path(sys.argv[2])
    game_map, clients, count = convert(source, target)
    print(f"{target}: map={game_map} clients={clients} commands={count}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
