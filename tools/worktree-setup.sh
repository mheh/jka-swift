#!/bin/bash
# This script prepares a worktree for the gate, and a second run changes nothing.
# Usage: `tools/worktree-setup.sh [--tools]`, from a folder in the worktree.
# With no flag, the script prints one line that says whether the worktree is clean.
# `--tools` gives the generators and `snapshot.py` what they need: the `oracle` and `jka-rust` submodules and the Python environment of the main tree.
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

# The script makes no table, because `out/` and `table.sqlite` are the output of a sweep.
ABSENT=""
[ -e "$CLOSURE/out" ] || ABSENT="$ABSENT out/"
[ -e "$CLOSURE/table.sqlite" ] || ABSENT="$ABSENT table.sqlite"
if [ -n "$ABSENT" ]; then
    echo "---- absent in $CLOSURE:$ABSENT"
fi
exit $STATUS
