#!/bin/sh
# This script builds the dedicated server of the OpenJK fork at the pinned submodule commit, the reference host of every referee step.
# The build sets -ffp-contract=off, because Raven's x86 build fused no multiply and add, and the script fails if the binary holds a fused instruction.
# Usage: `tools/build-referee-host.sh`. JOBS=N sets the build jobs, 2 by default.
# The binary is `.build/openjk-nocontract/openjkded.arm64`, out of tree, and the script writes nothing into `openjk/`.

set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
SRC=$ROOT/openjk
OUT=$ROOT/.build/openjk-nocontract
JOBS=${JOBS:-2}

if [ ! -f "$SRC/CMakeLists.txt" ]; then
    echo "$0: the openjk submodule is not checked out: $SRC" >&2
    exit 2
fi

# The configuration of notes/2026-10-09/engine-build.md, with the dedicated server as the only target.
cmake -S "$SRC" -B "$OUT" -DCMAKE_BUILD_TYPE=Release \
    -DBuildSPEngine=OFF -DBuildSPGame=OFF -DBuildSPRdVanilla=OFF \
    -DBuildJK2SPEngine=OFF -DBuildJK2SPGame=OFF -DBuildJK2SPRdVanilla=OFF \
    -DBuildMPEngine=OFF -DBuildMPDed=ON -DBuildMPRdVanilla=OFF -DBuildMPRend2=OFF \
    -DBuildMPGame=OFF -DBuildMPCGame=OFF -DBuildMPUI=OFF \
    -DMakeApplicationBundles=OFF \
    -DCMAKE_C_FLAGS=-ffp-contract=off \
    -DCMAKE_CXX_FLAGS=-ffp-contract=off
cmake --build "$OUT" --config Release -j "$JOBS"

BIN=$OUT/openjkded.arm64
if [ ! -f "$BIN" ]; then
    echo "$0: the build wrote no binary: $BIN" >&2
    exit 1
fi

# A fused multiply and add rounds once where Raven's build rounds twice, so the reference holds none.
FUSED=$(otool -tv "$BIN" | grep -cE '[[:space:]]f(n)?m(add|sub)[[:space:]]' || true)
if [ "$FUSED" -ne 0 ]; then
    echo "$0: the binary holds $FUSED fused multiply and add instructions: $BIN" >&2
    exit 1
fi
echo "---- reference host: $BIN, no fused multiply and add"
