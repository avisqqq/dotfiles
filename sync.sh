#!/usr/bin/env bash
set -euo pipefail

# Detect repo root (directory where script lives)
REPO="$(cd "$(dirname "$0")" && pwd)"
SRC="$REPO/config"
DEST="$HOME/.config"
MAP_FILE="$REPO/.sync-map"

MODE="${1:-}"
DRY_RUN_FLAG=""

if [[ "${2:-}" == "--dry-run" ]]; then
    DRY_RUN_FLAG="--dry-run"
fi

usage() {
    echo "Usage:"
    echo "  $0 export [--dry-run]"
    echo "  $0 import [--dry-run]"
    exit 1
}

[[ "$MODE" == "export" || "$MODE" == "import" ]] || usage
[[ -f "$MAP_FILE" ]] || { echo "Missing .sync-map"; exit 1; }

mkdir -p "$SRC"

sync_export() {
    while read -r name; do
        [[ -z "$name" || "$name" =~ ^# ]] && continue

        echo "Exporting $name"

        mkdir -p "$SRC/$name"

        rsync -a --delete $DRY_RUN_FLAG \
            "$DEST/$name/" \
            "$SRC/$name/"
    done < "$MAP_FILE"

    if [[ -z "$DRY_RUN_FLAG" ]]; then
        git -C "$REPO" add .
        git -C "$REPO" commit -m "dotfiles update $(date '+%F %T')" || true
        git -C "$REPO" push
    fi
}

sync_import() {
    if [[ -z "$DRY_RUN_FLAG" ]]; then
        git -C "$REPO" pull --rebase
    fi

    while read -r name; do
        [[ -z "$name" || "$name" =~ ^# ]] && continue

        echo "Importing $name"

        mkdir -p "$DEST/$name"

        rsync -a --delete $DRY_RUN_FLAG \
            "$SRC/$name/" \
            "$DEST/$name/"
    done < "$MAP_FILE"
}

if [[ "$MODE" == "export" ]]; then
    sync_export
else
    sync_import
fi
