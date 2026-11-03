#!/bin/bash
# Compiles every merged target as C with its dependency include directories, and fails on the first target that does not compile.
# It compiles with Clang modules and the module maps of the deps, as SwiftPM does, so an include of a dep's header imports the dep's whole module.
# Run after merge.py. The one argument is the directory the merge wrote, out/merge by default, or ../../Sources for the package.
set -u
here=$(cd "$(dirname "$0")" && pwd)
# The triples of the layout check, read from extract.py so the two lists cannot drift apart.
triples=$("$here/.venv/bin/python" -c "import sys; sys.path.insert(0, '$here'); import extract; print(' '.join(extract.TRIPLES))")
# The targets whose headers include a C library header, which take the include path of the SDK, read from rulings.py.
sdk_targets=$("$here/.venv/bin/python" -c "import sys; sys.path.insert(0, '$here'); import rulings; print(' '.join(sorted(rulings.SDK_TARGETS)))")
sdk=$(xcrun --show-sdk-path 2>/dev/null)
cd "${1:-$here/out/merge}" || exit 1
cache=$(mktemp -d)
trap 'rm -rf "$cache"' EXIT
status=0
for target in CJKAShared CJKAMP CJKAMP_Game CJKAMP_CGame CJKAMP_UI CJKAMP_Ded CJKASP CJKASP_Game CJKASP_CGame CJKASP_UI; do
    [ -d "$target/include" ] || continue
    flags=(-I "$target/include" -I CJKAShared/include)
    case "$target" in
        CJKAMP*) flags+=(-I CJKAMP/include) ;;
        CJKASP*) flags+=(-I CJKASP/include) ;;
    esac
    # The target's own headers are the module it builds, and every dep is an imported module.
    modules=(-fmodules -fmodules-cache-path="$cache" -fmodule-name="$target")
    # Every triple of packet row 6. The headers include no system header beyond Clang's own stddef.h, so a foreign triple needs no SDK.
    errors=0
    for triple in $triples; do
        system=()
        mode=("${modules[@]}")
        if [[ " $sdk_targets " == *" $target "* ]]; then
            if [[ "$triple" == *-apple-* ]]; then
                # The SDK's module maps build only from the SDK as the system root, as SwiftPM passes it.
                system=(-isysroot "$sdk")
            else
                # The SDK's module maps build only for an Apple triple, so a target that reads the SDK compiles as text on another triple.
                system=(-isystem "$sdk/usr/include")
                mode=()
                # The SDK's headers name 64-bit ARM __arm64__, which Clang defines only on an Apple triple.
                case "$triple" in aarch64-*) system+=(-D__arm64__) ;; esac
            fi
        fi
        n=$(clang -target "$triple" -ffreestanding -fsyntax-only -x c -std=gnu11 -Wno-everything -ferror-limit=0 "${flags[@]}" ${mode[@]+"${mode[@]}"} ${system[@]+"${system[@]}"} "$target/$target.c" 2>&1 | grep -c ' error: ')
        [ "$n" -eq 0 ] || echo "  $target on $triple: $n errors"
        errors=$((errors + n))
    done
    asserts=$(grep -c _Static_assert "$target/layout_asserts.h")
    printf '%-14s %5s asserts  %s errors\n' "$target" "$asserts" "$errors"
    [ "$errors" -eq 0 ] || status=1
done
exit $status
