#!/bin/bash
# Compiles every merged target as C with its dependency include directories, and fails on the first target that does not compile.
# Run after merge.py. The one argument is the directory the merge wrote, out/merge by default, or ../../Sources for the package.
set -u
cd "${1:-$(dirname "$0")/out/merge}" || exit 1
status=0
for target in CJKAShared CJKAMP CJKAMP_Game CJKAMP_CGame CJKAMP_UI CJKASP CJKASP_Game CJKASP_CGame CJKASP_UI; do
    [ -d "$target/include" ] || continue
    flags=(-I "$target/include" -I CJKAShared/include)
    case "$target" in
        CJKAMP*) flags+=(-I CJKAMP/include) ;;
        CJKASP*) flags+=(-I CJKASP/include) ;;
    esac
    errors=$(clang -fsyntax-only -x c -std=gnu11 -Wno-everything -ferror-limit=0 "${flags[@]}" "$target/$target.c" 2>&1 | grep -c ' error: ')
    asserts=$(grep -c _Static_assert "$target/layout_asserts.h")
    printf '%-14s %5s asserts  %s errors\n' "$target" "$asserts" "$errors"
    [ "$errors" -eq 0 ] || status=1
done
exit $status
