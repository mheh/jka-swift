#!/bin/sh
# This script runs one `.rec` file on two dedicated hosts with the same Swift jampgame and compares their `REF STEP` streams.
# Usage: `tools/host-referee.sh <file.rec> [host A] <host B> [extra args to both hosts]`.
# Host A and host B are paths to dedicated server binaries. Host A is the reference host `.build/openjk-nocontract/openjkded.arm64` by default.
# `tools/build-referee-host.sh` builds the reference host.
# FRAMES=N grants N frames after the map load, 4000 by default. Set N above the last frame of the file.
# The logs and the filtered streams go to SCRATCH, /tmp/referee-scratch/ by default, and the script exits 0 when the run is green.
# The script deletes SCRATCH at the start of a run, so SCRATCH must name a folder that holds nothing else, and it refuses a SCRATCH that names or holds the repository.
# BASE_PATH sets the folder of the game assets, the Steam copy by default.
# notes/2026-11-03/dedicated-referee-docket.md section 3 gives the command lines and the green test.

set -u

if [ $# -lt 2 ]; then
    echo "usage: $0 <file.rec> [host A] <host B> [extra args]" >&2
    exit 2
fi

ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
REFERENCE=$ROOT/.build/openjk-nocontract/openjkded.arm64
REC=$1
shift
# An extra arg starts with `+`, so a second path names host B and the first names host A.
if [ $# -ge 2 ] && [ "${2#+}" = "$2" ]; then
    HOST_A=$1
    HOST_B=$2
    shift 2
else
    HOST_A=$REFERENCE
    HOST_B=$1
    shift
fi
SCRATCH=${SCRATCH:-/tmp/referee-scratch}
MOD=swift
BASE_PATH=${BASE_PATH:-"$HOME/Library/Application Support/Steam/steamapps/common/Jedi Academy/SWJKJA.app/Contents"}
FRAMES=${FRAMES:-4000}
GAMETYPE=${GAMETYPE:-0}
# The run deletes SCRATCH, so SCRATCH must not be the repository, a folder in it, or a folder that holds it.
# The reference build lives in the repository, so this test also keeps it out of SCRATCH.
case "$SCRATCH" in
    /*) ;;
    *) SCRATCH=$(pwd -P)/$SCRATCH ;;
esac
# Resolve the links of SCRATCH, or of its parent when SCRATCH does not exist yet, so /tmp and /private/tmp compare equal.
if [ -d "$SCRATCH" ]; then
    SCRATCH=$(cd "$SCRATCH" && pwd -P)
else
    SCRATCH_PARENT=$(cd "$(dirname "$SCRATCH")" 2>/dev/null && pwd -P) || {
        echo "$0: the parent of SCRATCH does not exist: $SCRATCH" >&2
        exit 2
    }
    SCRATCH=${SCRATCH_PARENT%/}/$(basename "$SCRATCH")
fi
if [ "$SCRATCH" = "/" ]; then
    echo "$0: SCRATCH is the root folder" >&2
    exit 2
fi
case "$SCRATCH/" in
    "$ROOT/"*)
        echo "$0: SCRATCH is in the repository: $SCRATCH" >&2
        exit 2
        ;;
esac
case "$ROOT/" in
    "$SCRATCH/"*)
        echo "$0: SCRATCH holds the repository: $SCRATCH" >&2
        exit 2
        ;;
esac

# The alarm covers the map load, the granted frames, and the quit.
ALARM=$((120 + FRAMES / 10))

for FILE in "$REC" "$HOST_A" "$HOST_B"; do
    if [ ! -f "$FILE" ]; then
        echo "$0: missing: $FILE" >&2
        if [ "$FILE" = "$REFERENCE" ]; then
            echo "$0: run tools/build-referee-host.sh to build the reference host" >&2
        fi
        exit 2
    fi
done
if [ ! -d "$BASE_PATH" ]; then
    echo "$0: missing base path: $BASE_PATH" >&2
    exit 2
fi

# The replayer reads only the seed of the header, so the command line sets the map and sv_fps from the header.
HEADER=$(head -n 1 "$REC")
case "$HEADER" in
    "REFREC v1 "*) ;;
    *)
        echo "$0: not a REFREC v1 file: $REC" >&2
        exit 2
        ;;
esac
MAP=$(printf '%s\n' "$HEADER" | tr ' ' '\n' | sed -n 's/^map=//p')
FPS=$(printf '%s\n' "$HEADER" | tr ' ' '\n' | sed -n 's/^fps=//p')
if [ -z "$MAP" ] || [ -z "$FPS" ]; then
    echo "$0: the header has no map= or fps= field: $HEADER" >&2
    exit 2
fi

# Build the game module.
(cd "$ROOT" && swift build --product jampgame) || exit 1

# Start from empty homepaths, because a run writes banip.txt and the next run reads it.
rm -rf "$SCRATCH"
mkdir -p "$SCRATCH"
# Raven's main joins argv with spaces and no quotes, null/win_main.cpp:1425, so a Raven host splits a path at a space.
# A link with no space in its path gives both hosts the same base path.
ln -s "$BASE_PATH" "$SCRATCH/basepath"
for SIDE in a b; do
    mkdir -p "$SCRATCH/$SIDE/$MOD"
    cp -f "$ROOT/.build/debug/libjampgame.dylib" "$SCRATCH/$SIDE/$MOD/jampgamearm64.dylib"
    # The replayer reads the file through FS_ReadFile as a qpath, so the file goes into the mod folder.
    cp -f "$REC" "$SCRATCH/$SIDE/$MOD/$(basename "$REC")"
done
SUM_A=$(shasum "$SCRATCH/a/$MOD/jampgamearm64.dylib" | cut -d ' ' -f 1)
SUM_B=$(shasum "$SCRATCH/b/$MOD/jampgamearm64.dylib" | cut -d ' ' -f 1)
if [ "$SUM_A" != "$SUM_B" ]; then
    echo "$0: the two module copies differ" >&2
    exit 1
fi

# Run one host on the file and write its log.
# The fork takes `dedicated 1` and `ttycon 0`. Raven forces `dedicated` to 2 and has no `ttycon`, so a Raven host takes neither.
run_host() {
    HOST=$1
    SIDE=$2
    shift 2
    case "$(basename "$HOST")" in
        openjkded*) FORK_ARGS="+set dedicated 1 +set ttycon 0" ;;
        *) FORK_ARGS="" ;;
    esac
    # A trap inside G_ShutdownGame can stop the engine's own exit, so an alarm ends the process.
    # FORK_ARGS stays unquoted, so each word is one argument.
    # The fork registers g_maxForceRank with the default 7 and Raven with 6, so the line sets it on both hosts.
    perl -e 'alarm shift; exec @ARGV' "$ALARM" "$HOST" \
        +set fs_homepath "$SCRATCH/$SIDE" \
        +set fs_basepath "$SCRATCH/basepath" \
        +set fs_game "$MOD" \
        $FORK_ARGS \
        +set sv_pure 0 \
        +set vm_game 0 \
        +set sv_fps "$FPS" \
        +set sv_maxclients 32 \
        +set g_gametype "$GAMETYPE" \
        +set bot_enable 0 \
        +set g_maxForceRank 7 \
        +set sv_stepper 1 \
        +set sv_replayInputs "$(basename "$REC")" \
        "$@" \
        +map "$MAP" \
        +ref_step "$FRAMES" \
        +wait 5 \
        +quit \
        > "$SCRATCH/$SIDE.log" 2>&1
    echo "---- host $SIDE exit status $?"
}

START=$(date +%s)
run_host "$HOST_A" a "$@"
run_host "$HOST_B" b "$@"
END=$(date +%s)

# grep -o drops a timestamp prefix and every line that is not a referee line.
for SIDE in a b; do
    grep -o 'REF READY.*' "$SCRATCH/$SIDE.log" > "$SCRATCH/$SIDE.ready"
    grep -o 'REF STEP.*' "$SCRATCH/$SIDE.log" > "$SCRATCH/$SIDE.steps"
done

echo "---- REF READY diff"
diff "$SCRATCH/a.ready" "$SCRATCH/b.ready"
READY_STATUS=$?
echo "---- REF STEP diff"
diff "$SCRATCH/a.steps" "$SCRATCH/b.steps" | head -n 20
STEP_STATUS=$(diff "$SCRATCH/a.steps" "$SCRATCH/b.steps" > /dev/null; echo $?)

STEPS_A=$(wc -l < "$SCRATCH/a.steps" | tr -d ' ')
STEPS_B=$(wc -l < "$SCRATCH/b.steps" | tr -d ' ')
END_A=$(grep -c 'REF REPLAY END' "$SCRATCH/a.log")
END_B=$(grep -c 'REF REPLAY END' "$SCRATCH/b.log")
echo "---- header: $HEADER"
echo "---- module shasum: $SUM_A"
echo "---- frames granted: $FRAMES, host a: $STEPS_A, host b: $STEPS_B"
echo "---- REF REPLAY END, host a: $END_A, host b: $END_B"
echo "---- wall time: $((END - START)) s"

# The green test of section 3: equal REF READY lines, one REF STEP line per granted frame on each side with no diff, and REF REPLAY END on both sides.
if [ "$READY_STATUS" -eq 0 ] && [ -s "$SCRATCH/a.ready" ] \
    && [ "$STEP_STATUS" -eq 0 ] && [ "$STEPS_A" -eq "$FRAMES" ] && [ "$STEPS_B" -eq "$FRAMES" ] \
    && [ "$END_A" -ge 1 ] && [ "$END_B" -ge 1 ]; then
    echo "---- green"
    exit 0
fi
echo "---- not green"
exit 1
