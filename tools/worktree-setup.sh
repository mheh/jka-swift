#!/bin/bash
# This script prepares a worktree for the gate, and a second run changes nothing.
# Usage: `tools/worktree-setup.sh [--tools]`, from a folder in the worktree.
# With no flag, the script prints one line that says whether the worktree is clean.
# `--tools` gives the generators and `snapshot.py` what they need: the `oracle` and `jka-rust` submodules, the Python environment of the main tree,
# the `extract.json` of each unit that has a snapshot, and the manifests and the type stones of each of those units.
# The submodules borrow their objects from the main tree's `.git/modules`, so the checkout downloads almost nothing.
# The script never removes a submodule checkout.

set -u

TOOLS=0
for ARG in "$@"; do
    case "$ARG" in
        --tools) TOOLS=1 ;;
        *)
            echo "usage: $0 [--tools]" >&2
            exit 2
            ;;
    esac
done

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "$0: not in a git worktree" >&2
    exit 2
}
cd "$ROOT" || exit 2

if [ "$TOOLS" -eq 0 ]; then
    # A submodule that is not checked out does not make the worktree dirty.
    CHANGES=$(git status --porcelain | wc -l | tr -d ' ')
    if [ "$CHANGES" -eq 0 ]; then
        echo "---- clean: $ROOT"
    else
        echo "---- not clean, $CHANGES paths: $ROOT"
    fi
    exit 0
fi

# The first entry of the list is the main tree.
MAIN=$(git worktree list --porcelain | sed -n 's/^worktree //p' | head -n 1)
if [ -z "$MAIN" ] || [ ! -d "$MAIN" ]; then
    echo "$0: found no main tree" >&2
    exit 2
fi

STATUS=0
for NAME in oracle jka-rust; do
    REFERENCE=$MAIN/.git/modules/$NAME
    if [ -d "$REFERENCE" ]; then
        git submodule update --init --reference "$REFERENCE" "$NAME" > /dev/null 2>&1
    else
        git submodule update --init "$NAME" > /dev/null 2>&1
    fi
    if [ $? -eq 0 ]; then
        echo "---- submodule $NAME: $(git -C "$NAME" rev-parse --short HEAD 2>/dev/null)"
    else
        echo "---- submodule $NAME: the update failed"
        STATUS=1
    fi
done

CLOSURE=tools/oracle-closure
if [ -e "$CLOSURE/.venv" ] || [ -L "$CLOSURE/.venv" ]; then
    echo "---- .venv: present"
elif [ -d "$MAIN/$CLOSURE/.venv" ]; then
    ln -s "$MAIN/$CLOSURE/.venv" "$CLOSURE/.venv"
    echo "---- .venv: linked to the main tree"
else
    echo "---- .venv: absent, and the main tree has none"
    STATUS=1
fi

# Only `extract.py <unit>` makes `out/extract/<unit>/extract.json`, and git ignores `out/`, so a new worktree has none.
# `skeleton.py` reads the `.c` enums of a stub from that file, and it stops when the file is absent.
# The full output of an extract goes to `out/extract/<unit>.log`.
for UNIT in mp-game mp-cgame mp-ui mp-engine-ded; do
    if [ -f "$CLOSURE/out/extract/$UNIT/extract.json" ]; then
        echo "---- extract $UNIT: present"
        continue
    fi
    mkdir -p "$CLOSURE/out/extract"
    if (cd "$CLOSURE" && .venv/bin/python extract.py "$UNIT") > "$CLOSURE/out/extract/$UNIT.log" 2>&1 \
        && [ -f "$CLOSURE/out/extract/$UNIT/extract.json" ]; then
        echo "---- extract $UNIT: written"
    else
        echo "---- extract $UNIT: the extract failed, see $CLOSURE/out/extract/$UNIT.log"
        STATUS=1
    fi
done

# Git ignores `.claude/`, so a new worktree has no manifest and no stone, and a body writer reads both.
# A manifest that is present stays as it is. After a change to a stub line, run `manifest.py` again by hand.
# A stone folder that holds its index stays as it is. After a change to a view, run `rosetta.py --unit <unit>` again by hand.
# The first `manifest.py` run of a unit sweeps the table, so it also writes `table.sqlite` and the store of the unit under `out/`.
# The full output of each run goes to `out/setup/`.
mkdir -p "$CLOSURE/out/setup"
for UNIT in mp-game mp-cgame mp-ui mp-engine-ded; do
    # The manifests of `mp-game` are at the root of the folder, and each other unit has a folder of its own name.
    FOLDER=.claude/manifest
    if [ "$UNIT" != mp-game ]; then
        FOLDER=$FOLDER/$UNIT
    fi
    if ls "$FOLDER"/*.md > /dev/null 2>&1; then
        echo "---- manifest $UNIT: present"
        continue
    fi
    if (cd "$CLOSURE" && .venv/bin/python manifest.py --unit "$UNIT") > "$CLOSURE/out/setup/manifest-$UNIT.log" 2>&1 \
        && ls "$FOLDER"/*.md > /dev/null 2>&1; then
        echo "---- manifest $UNIT: written"
    else
        echo "---- manifest $UNIT: the run failed, see $CLOSURE/out/setup/manifest-$UNIT.log"
        STATUS=1
    fi
done

for UNIT in mp-game mp-cgame mp-ui mp-engine-ded; do
    # The stones of `mp-game` are at the root of the folder, and each other unit has a folder of its own name.
    FOLDER=.claude/rosetta
    if [ "$UNIT" != mp-game ]; then
        FOLDER=$FOLDER/$UNIT
    fi
    if [ -f "$FOLDER/index.md" ]; then
        echo "---- rosetta $UNIT: present"
        continue
    fi
    if (cd "$CLOSURE" && .venv/bin/python rosetta.py --unit "$UNIT") > "$CLOSURE/out/setup/rosetta-$UNIT.log" 2>&1 \
        && [ -f "$FOLDER/index.md" ]; then
        echo "---- rosetta $UNIT: written"
    else
        echo "---- rosetta $UNIT: the run failed, see $CLOSURE/out/setup/rosetta-$UNIT.log"
        STATUS=1
    fi
done
exit $STATUS
