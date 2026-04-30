#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_dir="${1:-$HOME/.local/bin}"
target="$target_dir/techweek"

mkdir -p "$target_dir"
ln -sf "$repo_root/plugins/techwerker/scripts/techweek" "$target"
chmod +x "$repo_root/plugins/techwerker/scripts/techweek"

echo "Installed techweek -> $target"
echo "Make sure $target_dir is on PATH."
