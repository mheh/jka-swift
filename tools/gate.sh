#!/bin/bash
# This script runs the full gate of a worktree and prints one result line for each step, 40 lines at most.
# Usage: `tools/gate.sh [--only a,b,c] [--skip a,b,c] [--snap-out] [--out DIR] [--jobs N] [--rec FILE] [--referee-args "<+set args>"]`, from a worktree root.
# The steps are build, release, test, tooltests, snap-game, snap-cgame, snap-ded, linux, referee, and stubs.
# The full output of a step goes to `$OUT/<step>.txt`, and the summary goes to stdout and to `$OUT/summary.txt`.
# OUT is `/tmp/gate-<branch>-<short head>` by default.
# A failed step does not stop the later steps, and the script exits 1 at the end if a step failed.
# `--snap-out` writes a new snapshot of each unit that differs to `$OUT/snap-<unit>`. The script never writes into `~/.cache`.
# `tools/worktree-setup.sh --tools` prepares a new worktree for the tooltests step and the snapshot steps.
# The referee step uses these variables: REFEREE_HOST for the reference host, REFEREE_HOST_B for the Swift host, and REFEREE_REC for the `.rec` file.
# Without REFEREE_REC or `--rec`, the step looks for `corpus-ffa1.rec` in the worktree, the main tree, and the scratch folders of earlier runs under `/tmp`.

set -u

STEPS="build release test tooltests snap-game snap-cgame snap-ded linux referee stubs"
ONLY=""
SKIP=""
SNAP_OUT=0
OUT=""
JOBS=${JOBS:-6}
REC=${REFEREE_REC:-}
REFEREE_ARGS=""

while [ $# -gt 0 ]; do
    case "$1" in
        --only) ONLY=$2; shift 2 ;;
        --skip) SKIP=$2; shift 2 ;;
        --snap-out) SNAP_OUT=1; shift ;;
        --out) OUT=$2; shift 2 ;;
        --jobs) JOBS=$2; shift 2 ;;
        --rec) REC=$2; shift 2 ;;
        --referee-args) REFEREE_ARGS=$2; shift 2 ;;
        *)
            echo "usage: $0 [--only a,b,c] [--skip a,b,c] [--snap-out] [--out DIR] [--jobs N] [--rec FILE] [--referee-args \"<+set args>\"]" >&2
            exit 2
            ;;
    esac
done

# A name that is not a step is an error, or a wrong name makes a gate that tests nothing.
for NAME in $(printf '%s' "$ONLY,$SKIP" | tr ',' ' '); do
    case " $STEPS " in
        *" $NAME "*) ;;
        *)
            echo "$0: not a step: $NAME" >&2
            exit 2
            ;;
    esac
done

ROOT=$(pwd -P)
if [ ! -f "$ROOT/Package.swift" ] || [ ! -f "$ROOT/tools/gate.sh" ]; then
    echo "$0: run from a worktree root" >&2
    exit 2
fi
BRANCH=$(git rev-parse --abbrev-ref HEAD | tr '/' '-')
HEAD_SHORT=$(git rev-parse --short HEAD)
MAIN=$(git worktree list --porcelain | sed -n 's/^worktree //p' | head -n 1)
CACHE=$HOME/.cache/jka-swift
CLOSURE=$ROOT/tools/oracle-closure
OUT=${OUT:-/tmp/gate-$BRANCH-$HEAD_SHORT}
case "$OUT" in
    /*) ;;
    *) OUT=$ROOT/$OUT ;;
esac
case "$OUT/" in
    "$CACHE/"*)
        echo "$0: OUT is in the snapshot cache: $OUT" >&2
        exit 2
        ;;
esac
mkdir -p "$OUT" || exit 2
SUMMARY=$OUT/summary.txt
# The referee script deletes its scratch folder, so the folder is not OUT and not in a worktree.
SCRATCH=/tmp/gate-referee-scratch-$BRANCH-$HEAD_SHORT

say() {
    printf '%s\n' "$1" | tee -a "$SUMMARY"
}

wanted() {
    if [ -n "$ONLY" ]; then
        case ",$ONLY," in
            *",$1,"*) ;;
            *) return 1 ;;
        esac
    fi
    case ",$SKIP," in
        *",$1,"*) return 1 ;;
    esac
    return 0
}

# MARK: - Steps

# Each `run_` function writes the full output of its step to stdout.
# Each `result_` function reads `$OUT/<step>.txt` and prints the one result line.

run_build() {
    swift build -j "$JOBS"
}

run_release() {
    swift build -c release -j "$JOBS"
}

result_build() {
    # A compiler error follows a line and column number, and a source excerpt with a variable named `error` does not.
    ERRORS=$(grep -c -E '[0-9]: error:|^error:' "$1")
    LAST=$(grep -E 'Compiling|Build complete|error:' "$1" | tail -n 1 | cut -c 1-110)
    echo "$ERRORS error lines, last: $LAST"
}

run_test() {
    swift test --no-parallel -j "$JOBS"
}

# Swift Testing prints `Test run with N tests in M suites passed after S seconds.`, and XCTest prints `Executed N tests, with F failures`.
result_test() {
    RAW=$(grep -E 'Test run with [0-9]+ tests?' "$1" | sed -E 's/^[^A-Za-z]*//')
    XCTEST=$(grep -E 'Executed [0-9]+ tests?, with [0-9]+ failures?' "$1" | tail -n 1 | sed -E 's/^[^A-Za-z]*//')
    if [ -z "$RAW" ] && [ -z "$XCTEST" ]; then
        echo "found no summary line"
        return
    fi
    # Each test bundle prints its own summary line, so the count is the sum of the lines.
    LINES=$(printf '%s' "$RAW" | grep -c .)
    TOTAL=$(printf '%s\n' "$RAW" | sed -n -E 's/.*Test run with ([0-9]+) tests?.*/\1/p' | awk '{ n += $1 } END { print n + 0 }')
    TOTAL=$((TOTAL + $(printf '%s\n' "$XCTEST" | sed -n -E 's/.*Executed ([0-9]+) tests?.*/\1/p' | awk '{ n += $1 } END { print n + 0 }')))
    # A failed test prints one `Test <name> failed after` line, and the sort removes a second line for the same test.
    FAILED=$(grep -E 'Test .* failed after' "$1" | grep -v -E 'Test run with|Test case passing' | sed -E -e 's/^[^A-Za-z]*//' -e 's/ failed after.*//' | sort -u | wc -l | tr -d ' ')
    FAILED=$((FAILED + $(printf '%s\n' "$XCTEST" | sed -n -E 's/.*with ([0-9]+) failures?.*/\1/p' | awk '{ n += $1 } END { print n + 0 }')))
    NOT_PASSED=$(printf '%s\n' "$RAW" | grep -c ' failed after')
    echo "$((TOTAL - FAILED)) passed, $FAILED failed, raw: $LINES \`Test run with\` lines, $NOT_PASSED of them failed, last: $(printf '%s\n' "$RAW" | tail -n 1)"
}

run_tooltests() {
    cd "$CLOSURE" && .venv/bin/python -m unittest discover -s tests
}

result_tooltests() {
    RAN=$(grep -E '^Ran [0-9]+ tests?' "$1" | tail -n 1)
    VERDICT=$(grep -E '^(OK|FAILED)' "$1" | tail -n 1)
    echo "${RAN:-found no Ran line}, ${VERDICT:-no verdict}"
}

# The check compares a new snapshot in a temporary folder with the cache folder, so the cache is read only.
run_snap() {
    UNIT=$1
    FOLDER=$2
    cd "$CLOSURE" || return 2
    .venv/bin/python snapshot.py --check "$CACHE/$FOLDER" --unit "$UNIT"
    CHECK=$?
    if [ "$CHECK" -ne 0 ] && [ "$SNAP_OUT" -eq 1 ]; then
        echo "---- new snapshot: $OUT/snap-$UNIT"
        .venv/bin/python snapshot.py --unit "$UNIT" --out "$OUT/snap-$UNIT"
    fi
    return $CHECK
}

run_snap_game() { run_snap mp-game snapshot-stage-two-shared; }
run_snap_cgame() { run_snap mp-cgame snapshot-mp-cgame; }
run_snap_ded() { run_snap mp-engine-ded snapshot-mp-engine-ded; }

# `diff -r` prints one `diff -r` line for each file that differs and one `Only in` line for each file that one side lacks.
result_snap() {
    NAMES=$(sed -n -E -e 's/^diff -r .*\/([^/ ]+)$/\1/p' -e 's/^Only in [^:]*: (.*)$/\1/p' "$1")
    COUNT=$(printf '%s' "$NAMES" | grep -c .)
    if [ "$COUNT" -eq 0 ]; then
        if [ "$2" -eq 0 ]; then
            echo "no difference"
        else
            echo "the check failed with no diff line: $(tail -n 1 "$1" | cut -c 1-100)"
        fi
        return
    fi
    SHOWN=$(printf '%s\n' "$NAMES" | head -n 12 | tr '\n' ' ')
    MORE=""
    [ "$COUNT" -gt 12 ] && MORE="and $((COUNT - 12)) more"
    NEW=""
    [ -d "$OUT/$3" ] && NEW=", new snapshot: $OUT/$3"
    echo "$COUNT files differ: $SHOWN$MORE$NEW"
}

# `tools/linux-check.sh` uses a different image and also runs the tests on two platforms, so this step calls docker directly.
run_linux() {
    docker run --rm -v "$PWD":/src -v jka-linux-build:/build -w /src swift:6.4-noble swift build --build-path /build/out
}

find_reference_host() {
    if [ -n "${REFEREE_HOST:-}" ]; then
        echo "$REFEREE_HOST"
        return
    fi
    for TREE in "$ROOT" "$MAIN" /tmp/jka-rulings-13; do
        if [ -f "$TREE/.build/openjk-nocontract/openjkded.arm64" ]; then
            echo "$TREE/.build/openjk-nocontract/openjkded.arm64"
            return
        fi
    done
}

find_rec() {
    if [ -n "$REC" ]; then
        echo "$REC"
        return
    fi
    for FILE in "$ROOT/corpus-ffa1.rec" "$MAIN/corpus-ffa1.rec" "$CACHE/corpus-ffa1.rec" /tmp/referee-scratch*/a/swift/corpus-ffa1.rec; do
        if [ -f "$FILE" ]; then
            echo "$FILE"
            return
        fi
    done
}

run_referee() {
    HOST_A=$(find_reference_host)
    HOST_B=${REFEREE_HOST_B:-$ROOT/.build/debug/jampded}
    FOUND=$(find_rec)
    if [ -z "$HOST_A" ]; then
        echo "---- gate: found no reference host, run tools/build-referee-host.sh or set REFEREE_HOST"
        return 2
    fi
    if [ -z "$FOUND" ]; then
        echo "---- gate: found no .rec file, set REFEREE_REC or give --rec"
        return 2
    fi
    # The file can be in a scratch folder that a later referee run deletes, so the run uses a copy in OUT.
    cp -f "$FOUND" "$OUT/$(basename "$FOUND")" || return 2
    echo "---- gate: rec $FOUND"
    echo "---- gate: host a $HOST_A"
    echo "---- gate: host b $HOST_B"
    echo "---- gate: extra args: $REFEREE_ARGS"
    # The referee script builds only the game module, so this line builds the Swift host.
    swift build --product jampded -j "$JOBS" || return 1
    # REFEREE_ARGS stays unquoted, so each word is one argument.
    FRAMES=2400 SCRATCH=$SCRATCH "$ROOT/tools/host-referee.sh" "$OUT/$(basename "$FOUND")" "$HOST_A" "$HOST_B" $REFEREE_ARGS
}

# A run with zero kills tested no combat, so the line gives the kill count of the reference host in plain words.
result_referee() {
    if grep -q '^---- green' "$1"; then
        COLOR=green
    else
        COLOR=red
    fi
    if [ ! -f "$SCRATCH/a.steps" ] || [ ! -f "$SCRATCH/b.steps" ]; then
        echo "$COLOR, the hosts did not run: $(grep -E 'gate:|missing|usage' "$1" | tail -n 1 | cut -c 1-110)"
        return
    fi
    EQUAL=$(awk 'NR == FNR { a[FNR] = $0; next } a[FNR] == $0 { n++ } END { print n + 0 }' "$SCRATCH/a.steps" "$SCRATCH/b.steps")
    FIRST=$(head -n 1 "$SCRATCH/a.steps" | sed -n 's/.*ck=//p')
    LAST=$(tail -n 1 "$SCRATCH/a.steps" | sed -n 's/.*ck=//p')
    KILLS=$(grep -c 'Kill:' "$SCRATCH/a.log")
    echo "$COLOR, $EQUAL equal REF STEP lines of 2400, first ck $FIRST, last ck $LAST, kills in the reference log: $KILLS"
}

run_stubs() {
    grep -rn 'portMissing(' Sources | grep -v 'func portMissing('
    echo "---- TODO: Port"
    grep -rn 'TODO: Port' Sources
    return 0
}

result_stubs() {
    MISSING=$(sed '/^---- TODO: Port$/,$d' "$1" | wc -l | tr -d ' ')
    TODO=$(sed '1,/^---- TODO: Port$/d' "$1" | wc -l | tr -d ' ')
    echo "$MISSING portMissing( lines apart from the definition, $TODO TODO: Port lines"
}

# MARK: - Run

: > "$SUMMARY"
say "gate: branch $BRANCH, head $HEAD_SHORT, jobs $JOBS"
say "output: $OUT"
FAILED_STEPS=""
GATE_START=$(date +%s)
for NAME in $STEPS; do
    if ! wanted "$NAME"; then
        say "$(printf '%-10s %-7s' "$NAME" skipped)"
        continue
    fi
    FILE=$OUT/$NAME.txt
    FUNCTION=$(printf '%s' "$NAME" | tr '-' '_')
    START=$(date +%s)
    # The subshell keeps a `cd` of the step out of the loop.
    (cd "$ROOT" && "run_$FUNCTION") > "$FILE" 2>&1
    STATUS=$?
    SECONDS_USED=$(($(date +%s) - START))
    case "$NAME" in
        release | linux) RESULT=$(result_build "$FILE") ;;
        snap-game) RESULT=$(result_snap "$FILE" "$STATUS" snap-mp-game) ;;
        snap-cgame) RESULT=$(result_snap "$FILE" "$STATUS" snap-mp-cgame) ;;
        snap-ded) RESULT=$(result_snap "$FILE" "$STATUS" snap-mp-engine-ded) ;;
        *) RESULT=$("result_$FUNCTION" "$FILE") ;;
    esac
    if [ "$STATUS" -eq 0 ]; then
        WORD=ok
    else
        WORD=FAILED
        FAILED_STEPS="$FAILED_STEPS $NAME"
    fi
    say "$(printf '%-10s %-7s %5ss  exit %s  %s' "$NAME" "$WORD" "$SECONDS_USED" "$STATUS" "$RESULT")"
done
TOTAL=$(($(date +%s) - GATE_START))
if [ -z "$FAILED_STEPS" ]; then
    say "gate: all steps that ran are ok, total $TOTAL s"
    exit 0
fi
say "gate: FAILED:$FAILED_STEPS, total $TOTAL s"
exit 1
