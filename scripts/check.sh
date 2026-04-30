#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

echo "== json manifests =="
python3 -m json.tool .agents/plugins/marketplace.json >/dev/null
python3 -m json.tool plugins/techwerker/.codex-plugin/plugin.json >/dev/null
python3 -m json.tool plugins/techwerker/.claude-plugin/plugin.json >/dev/null

echo "== python compile =="
PYTHONDONTWRITEBYTECODE=1 python3 -m py_compile \
  plugins/techwerker/scripts/techweek \
  plugins/techwerker/skills/tech-week-concierge/scripts/techweek

echo "== cli smoke =="
plugins/techwerker/scripts/techweek --help >/dev/null

echo "== public hygiene grep =="
if git grep -nE '/Users/danielgreen|gho_|Token:|password=|api[_-]?key|SECRET|PRIVATE KEY' -- ':!scripts/check.sh' >/tmp/techwerker-check-grep.txt 2>/dev/null; then
  cat /tmp/techwerker-check-grep.txt
  echo "public hygiene grep failed" >&2
  exit 1
fi

rm -f /tmp/techwerker-check-grep.txt
find plugins/techwerker -type d -name __pycache__ -prune -exec rm -rf {} +

echo "ok"
