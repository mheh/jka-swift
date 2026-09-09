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
    # Every triple of packet row 6. The headers include no system header beyond Clang's own stddef.h, so a foreign triple needs no SDK.
    errors=0
    for triple in i686-pc-windows-msvc i686-pc-linux-gnu x86_64-pc-windows-msvc x86_64-pc-linux-gnu x86_64-apple-macosx arm64-apple-macosx; do
        n=$(clang -target "$triple" -ffreestanding -fsyntax-only -x c -std=gnu11 -Wno-everything -ferror-limit=0 "${flags[@]}" "$target/$target.c" 2>&1 | grep -c ' error: ')
        [ "$n" -eq 0 ] || echo "  $target on $triple: $n errors"
        errors=$((errors + n))
    done
    asserts=$(grep -c _Static_assert "$target/layout_asserts.h")
    printf '%-14s %5s asserts  %s errors\n' "$target" "$asserts" "$errors"
    [ "$errors" -eq 0 ] || status=1
done
exit $status
