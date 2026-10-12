#!/usr/bin/env bash
set -euo pipefail

# Build a CS-Cart manual installation package from the repository source.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$ROOT/dist"
OUTPUT="$ROOT/dist/vendor_card-install.zip"
rm -f "$OUTPUT"

(
    cd "$ROOT"
    zip -q -r "$OUTPUT" app js var -x '*/.DS_Store' -x '*/__MACOSX/*'
)

unzip -tq "$OUTPUT"
printf 'Created: %s\n' "$OUTPUT"
