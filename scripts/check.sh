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
            "facets": {"topics": [{"label": "AI"}], "types": [{"label": "Breakfast"}]},
        },
        {
            "id": "2",
            "city": "nyc",
            "date": "2026-06-01",
            "time": "12:30:00",
            "timeSlot": "noon",
            "name": "AI Noon Matchmaking",
            "company": "Fixture Host",
            "location": "Flatiron",
            "locationCluster": "Flatiron/NoMad",
            "externalHref": "https://partiful.com/e/noon-ai",
            "isInviteOnly": False,
            "facets": {"topics": [{"label": "AI"}], "types": [{"label": "Matchmaking"}]},
        },
        {
            "id": "3",
            "city": "nyc",
            "date": "2026-06-01",
            "time": "18:00:00",
            "timeSlot": "evening",
            "name": "AI Evening Panel",
            "company": "Fixture Host",
            "location": "Chelsea",
            "locationCluster": "Chelsea/West Side",
            "externalHref": "https://partiful.com/e/evening-ai",
            "isInviteOnly": False,
            "facets": {"topics": [{"label": "AI"}], "types": [{"label": "Panel / Fireside Chat"}]},
        },
        {
            "id": "4",
            "city": "nyc",
            "date": "2026-06-01",
            "time": "18:30:00",
            "timeSlot": "evening",
            "name": "AI External Event",
            "company": "Fixture Host",
            "location": "Chelsea",
            "locationCluster": "Chelsea/West Side",
            "externalHref": "https://example.com/e/not-partiful",
            "isInviteOnly": False,
            "facets": {"topics": [{"label": "AI"}], "types": [{"label": "Networking"}]},
        },
        {
            "id": "5",
            "city": "nyc",
            "date": "2026-06-01",
            "time": "18:45:00",
            "timeSlot": "evening",
            "name": "Fintech Evening",
            "company": "Fixture Host",
            "location": "Chelsea",
            "locationCluster": "Chelsea/West Side",
            "externalHref": "https://partiful.com/e/fintech",
            "isInviteOnly": False,
            "facets": {"topics": [{"label": "Fintech"}], "types": [{"label": "Networking"}]},
        },
    ],
}
(root / "latest.json").write_text(json.dumps(latest), encoding="utf-8")
(root / "rsvp-state.json").write_text(json.dumps({"3": {"state": "applied"}}), encoding="utf-8")

boston_root = pathlib.Path(sys.argv[1]) / ".codex" / "data" / "tech-week" / "boston-2026"
boston_root.mkdir(parents=True)
boston_latest = dict(latest)
boston_latest["city"] = "boston"
boston_latest["events"] = [
    {
        **latest["events"][0],
        "id": "bos-1",
        "city": "boston",
        "name": "Fixture Boston AI Breakfast",
        "time": "18:00:00",
        "timeSlot": "evening",
        "location": "Kendall Square",
        "externalHref": "https://partiful.com/e/boston-ai",
    }
]
(boston_root / "latest.json").write_text(json.dumps(boston_latest), encoding="utf-8")

sf_root = pathlib.Path(sys.argv[1]) / ".codex" / "data" / "tech-week" / "san-francisco-2026"
sf_root.mkdir(parents=True)
sf_latest = dict(latest)
sf_latest["city"] = "san-francisco"
sf_latest["events"] = [
    {
        **latest["events"][1],
        "id": "sf-1",
        "city": "san-francisco",
        "name": "Fixture SF AI Lunch",
        "location": "SoMa",
        "locationCluster": "SoMa",
    }
]
(sf_root / "latest.json").write_text(json.dumps(sf_latest), encoding="utf-8")
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek portfolio --city nyc --limit 1 >/dev/null
HOME="$tmp_home" plugins/techwerker/scripts/techweek profile --city "New York" set country "United States" | grep -q 'country=saved'
HOME="$tmp_home" plugins/techwerker/scripts/techweek profile --city nyc missing | grep -q 'profile=missing display_name'
HOME="$tmp_home" plugins/techwerker/scripts/techweek preferences --city nyc set-list topics "AI, B2B" | grep -q 'topics=AI, B2B'
HOME="$tmp_home" plugins/techwerker/scripts/techweek preferences --city nyc set-list neighborhoods "Flatiron, Chelsea" | grep -q 'neighborhoods=Flatiron, Chelsea'
HOME="$tmp_home" plugins/techwerker/scripts/techweek preferences --city nyc set-list preferred_formats "Networking, Panel / Fireside Chat" | grep -q 'preferred_formats=Networking, Panel / Fireside Chat'
HOME="$tmp_home" plugins/techwerker/scripts/techweek portfolio --city Boston --limit 1 >/dev/null
HOME="$tmp_home" plugins/techwerker/scripts/techweek preferences --city Boston set-list neighborhoods "Cambridge, Kendall Square" | grep -q 'neighborhoods=Cambridge, Kendall Square'
HOME="$tmp_home" plugins/techwerker/scripts/techweek live-queue --city "New York" --topics AI --time-slots noon,evening --limit 3 --from-cache | grep -q '^2 '
HOME="$tmp_home" plugins/techwerker/scripts/techweek live-queue --city "New York" --topics AI --time-slots noon,evening --limit 3 --from-cache | grep -q 'queue=1 shown / 1 matched'
HOME="$tmp_home" plugins/techwerker/scripts/techweek live-queue --city Boston --topics AI --time-slots noon,evening --limit 3 --from-cache | grep -q '^bos-1 '
HOME="$tmp_home" plugins/techwerker/scripts/techweek live-queue --city "San Francisco" --topics AI --time-slots noon --limit 3 --from-cache | grep -q '^sf-1 '
test -f "$tmp_home/.codex/data/tech-week/nyc-2026/live-queue.json"
test -f "$tmp_home/.codex/data/tech-week/san-francisco-2026/live-queue.json"
test ! -f "$tmp_home/.codex/data/tech-week/san-francisco-2026/portfolio.json"
test ! -f "$tmp_home/.codex/data/tech-week/san-francisco-2026/rsvp-profile.json"
test ! -f "$tmp_home/.codex/data/tech-week/san-francisco-2026/form-memory.json"
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
