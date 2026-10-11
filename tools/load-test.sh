#!/bin/sh
# This script runs the smallest load test of the Swift jampgame under the OpenJK dedicated server.
# It builds the library, copies it into a mod folder under a scratch homepath, and loads mp/ffa1.
# The server log goes to /tmp/jka-load/server.log, and the script prints its tail.
# Extra arguments go to the server before the map command, for example `tools/load-test.sh +set g_log ""`.
# FRAMES=N holds the server for N frames after the map load before the quit, at sv_fps 40, so FRAMES=2400 is one minute.
# notes/2026-10-09/load-test.md records the result of the first round.

set -u

ROOT=$(cd "$(dirname "$0")/.." && pwd)
HOME_PATH=/tmp/jka-load/home
MOD=swift
BASE_PATH="$HOME/Library/Application Support/Steam/steamapps/common/Jedi Academy/SWJKJA.app/Contents"
LOG=/tmp/jka-load/server.log
FRAMES=${FRAMES:-0}
# The alarm covers the map load and the held frames, with a margin for the quit.
ALARM=$((60 + FRAMES / 20))

# Build the library.
(cd "$ROOT" && swift build) || exit 1

# Start from an empty homepath, because a run writes banip.txt and the next run reads it.
rm -rf "$HOME_PATH"

# Copy the library with the engine's name into the mod folder.
mkdir -p "$HOME_PATH/$MOD"
cp -f "$ROOT/.build/debug/libjampgame.dylib" "$HOME_PATH/$MOD/jampgamearm64.dylib"

# Run the server once, hold it for FRAMES frames, and stop.
# A trap inside G_ShutdownGame can stop the engine's own exit, so an alarm ends the process.
perl -e 'alarm shift; exec @ARGV' "$ALARM" "$ROOT/.build/openjk/openjkded.arm64" \
    +set fs_homepath "$HOME_PATH" \
    +set fs_basepath "$BASE_PATH" \
    +set fs_game "$MOD" \
    +set dedicated 1 \
    +set sv_pure 0 \
    +set vm_game 0 \
    "$@" \
    +map mp/ffa1 \
    +wait "$FRAMES" \
    +quit \
    > "$LOG" 2>&1
STATUS=$?

tail -n 40 "$LOG"
echo "---- exit status $STATUS"
exit $STATUS
