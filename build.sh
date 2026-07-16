#!/usr/bin/env bash

set -euo pipefail

BASE="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$BASE/duckdb"
BUILD_DIR="$BASE/build_shared"
REMOTE="https://github.com/duckdb/duckdb.git"
REVISION=71f0c7a0bf10f60087b7bd42f524ae556c5a1967

clone_at_revision() {
    local dir="$1"
    local revision="$2"
    local remote="$3"
    shift 3
    [ -d "$dir" ] && return
    git clone "$@" "$remote" "$dir"
    if ! git -C "$dir" checkout --detach "$revision"; then
        git -C "$dir" fetch origin "$revision"
        git -C "$dir" checkout --detach FETCH_HEAD
    fi
}

clone_at_revision "$SOURCE_DIR" "$REVISION" "$REMOTE" --depth=1 --no-tags
python3 "$BASE/generate_bindings.py"

linux_arch_dir() {
    case "$(uname -m)" in
        x86_64 | amd64) echo "linux_x64" ;;
        aarch64 | arm64) echo "linux_arm64" ;;
        *) echo "linux_$(uname -m)" ;;
    esac
}

darwin_arch_dir() {
    case "$(uname -m)" in
        x86_64 | amd64) echo "darwin_x64" ;;
        aarch64 | arm64) echo "darwin_arm64" ;;
        *) echo "darwin_$(uname -m)" ;;
    esac
}

case "$(uname -s)" in
    Darwin)
        CPU=$(sysctl -n hw.ncpu 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)
        OUTPUT_DIR="$BASE/$(darwin_arch_dir)"
        SOURCE_LIB="$BUILD_DIR/src/libduckdb.dylib"
        LIB_NAME=libduckdb.dylib
        ;;
    Linux)
        CPU=$(nproc)
        OUTPUT_DIR="$BASE/$(linux_arch_dir)"
        SOURCE_LIB="$BUILD_DIR/src/libduckdb.so"
        LIB_NAME=libduckdb.so
        ;;
    *)
        echo "Unsupported host OS: $(uname -s)" >&2
        exit 1
        ;;
esac

echo "Configuring shared build..."
cmake -S "$SOURCE_DIR" -B "$BUILD_DIR" \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHELL=OFF \
    -DBUILD_UNITTESTS=OFF \
    -DENABLE_UNITTEST_CPP_TESTS=OFF \
    -DBUILD_BENCHMARKS=OFF \
    -DDISABLE_BUILTIN_EXTENSIONS=ON

echo "Building shared project..."
cmake --build "$BUILD_DIR" --target duckdb --config Release -j"$CPU"

mkdir -p "$OUTPUT_DIR"
cp "$SOURCE_LIB" "$OUTPUT_DIR/$LIB_NAME"

echo "Shared build completed successfully!"
