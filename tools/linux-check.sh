#!/bin/bash
# Builds and tests the tree inside the official Swift image, once per Linux platform, with a scratch directory per platform.
# Run from the repo root. Docker Desktop runs linux/amd64 under emulation on an arm64 Mac, so that pass is slower.
# The exit tests end a child process by a crash on purpose, and the Swift backtracer that runs on a crash hangs under emulation, so it is off.
set -u
status=0
for platform in linux/arm64 linux/amd64; do
    scratch=".build-${platform#linux/}"
    echo "---- $platform"
    docker run --rm --platform "$platform" -e SWIFT_BACKTRACE=enable=no -v "$PWD":/src -w /src swift:6.3-noble \
        sh -c "swift build --scratch-path $scratch && swift test --scratch-path $scratch" || status=1
done
exit $status
