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

echo "== missing field smoke =="
tmp_home="$(mktemp -d)"
trap 'rm -rf "$tmp_home" /tmp/techwerker-check-grep.txt' EXIT
python3 - "$tmp_home" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1]) / ".codex" / "data" / "tech-week" / "nyc-2026"
root.mkdir(parents=True)
latest = {
    "city": "nyc",
    "year": 2026,
    "syncedAt": "2026-04-30T00:00:00+00:00",
    "meta": {},
    "events": [
        {
            "id": "1",
            "city": "nyc",
            "date": "2026-06-01",
            "time": "09:00:00",
            "timeSlot": "morning",
            "name": "Fixture AI Breakfast",
            "company": "Fixture Host",
            "location": "Midtown",
            "locationCluster": "Midtown",
            "externalHref": "https://partiful.com/e/fixture",
            "isInviteOnly": False,
            "facets": {},
        }
    ],
}
(root / "latest.json").write_text(json.dumps(latest), encoding="utf-8")
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek portfolio --city nyc --limit 1 >/dev/null
HOME="$tmp_home" plugins/techwerker/scripts/techweek apply-queue --city nyc --limit 1 | grep -q '^1 '
HOME="$tmp_home" plugins/techwerker/scripts/techweek missing-fields --city nyc add 1 "What are you building?" >/dev/null
if HOME="$tmp_home" plugins/techwerker/scripts/techweek apply-queue --city nyc --limit 1 | grep -q '^1 '; then
  echo "missing field event stayed in apply queue" >&2
  exit 1
fi
HOME="$tmp_home" plugins/techwerker/scripts/techweek missing-fields --city nyc resolve 1 "What are you building?" "Fixture answer" --reusable >/dev/null
HOME="$tmp_home" plugins/techwerker/scripts/techweek apply-queue --city nyc --limit 1 | grep -q '^1 '

echo "== public hygiene grep =="
if git grep -nE '/Users/danielgreen|gho_|Token:|password=|api[_-]?key|SECRET|PRIVATE KEY' -- ':!scripts/check.sh' >/tmp/techwerker-check-grep.txt 2>/dev/null; then
  cat /tmp/techwerker-check-grep.txt
  echo "public hygiene grep failed" >&2
  exit 1
fi

rm -f /tmp/techwerker-check-grep.txt
find plugins/techwerker -type d -name __pycache__ -prune -exec rm -rf {} +

echo "ok"
