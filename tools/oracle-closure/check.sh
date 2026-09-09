#!/bin/bash
# Compiles every merged target as C with its dependency include directories, and fails on the first target that does not compile.
# Run from tools/oracle-closure after merge.py.
set -u
cd "$(dirname "$0")/out/merge" || exit 1
status=0
for target in CJKAShared CJKAMP CJKAMPGame CJKAMPCgame CJKAMPUi CJKASP CJKASPGame CJKASPCgame CJKASPUi; do
    [ -d "$target/include" ] || continue
    flags=(-I "$target/include" -I CJKAShared/include -I ../../glshim)
    case "$target" in
        CJKAMP*) flags+=(-I CJKAMP/include) ;;
        CJKASP*) flags+=(-I CJKASP/include) ;;
    esac
    errors=$(clang -fsyntax-only -x c -std=gnu11 -Wno-everything -ferror-limit=0 "${flags[@]}" "$target/include/layout_asserts.h" 2>&1 | grep -c ' error: ')
    asserts=$(grep -c _Static_assert "$target/include/layout_asserts.h")
    printf '%-14s %5s asserts  %s errors\n' "$target" "$asserts" "$errors"
    [ "$errors" -eq 0 ] || status=1
done
exit $status
