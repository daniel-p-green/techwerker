#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "$TMP_HOME"' EXIT

export HOME="$TMP_HOME"
export PATH="$TMP_HOME/.local/bin:$PATH"

"$ROOT/scripts/install-cli.sh" "$TMP_HOME/.local/bin" >/dev/null

STATE_ROOT="$TMP_HOME/.codex/data/tech-week/nyc-2026"
mkdir -p "$STATE_ROOT"

python3 - "$STATE_ROOT/latest.json" <<'PY'
import json
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
path.write_text(json.dumps({
    "city": "nyc",
    "year": 2026,
    "sourceUrl": "https://tech-week.com/calendar/nyc",
    "syncedAt": "2026-05-06T00:00:00+00:00",
    "meta": {"source": "fresh-user-acceptance-fixture"},
    "events": [
        {
            "id": "6365",
            "city": "nyc",
            "date": "2026-06-06",
            "time": "09:00:00",
            "timeSlot": "morning",
            "name": "Rebuild x Eleven Labs Hackathon - #NYTechWeek",
            "company": "Rebuild x ElevenLabs",
            "location": "Chinatown",
            "locationCluster": "SoHo/LES",
            "externalHref": "https://partiful.com/e/5gz90KPGpE1XoK3GZtoW",
            "isInviteOnly": False,
            "facets": {
                "topics": [{"label": "AI"}, {"label": "Hackathon"}],
                "types": [{"label": "Hackathon"}],
            },
        }
    ],
}), encoding="utf-8")
PY

techweek onboarding-context --city nyc --from-cache --json >"$TMP_HOME/onboarding-missing.json"
python3 - "$TMP_HOME/onboarding-missing.json" <<'PY'
import json
import sys

data = json.load(open(sys.argv[1], encoding="utf-8"))
assert data["ready"] is False
assert "display_name" in data["profileCollection"]["missingRequired"]
assert "reusable RSVP basics once" in data["profileCollection"]["compactBatchPrompt"]
PY

techweek profile --city nyc set display_name "Demo User" >/dev/null
techweek profile --city nyc set email "demo@example.test" >/dev/null
techweek profile --city nyc set phone "555-0100" >/dev/null
techweek profile --city nyc set company "Demo Co" >/dev/null
techweek profile --city nyc set title "Builder" >/dev/null
techweek profile --city nyc set country "United States" >/dev/null
techweek profile --city nyc set linkedin "linkedin.com/in/demo-user" >/dev/null
techweek profile --city nyc set one_liner "I build practical AI workflow tools." >/dev/null
techweek preferences --city nyc set-list topics "AI, Hackathon" >/dev/null
techweek preferences --city nyc set-list neighborhoods "SoHo, Chinatown" >/dev/null
techweek preferences --city nyc set-list preferred_formats "Hackathon" >/dev/null
techweek preferences --city nyc set-list time_windows "08:00-21:00" >/dev/null

techweek onboarding-context --city nyc --from-cache --json >"$TMP_HOME/onboarding-ready.json"
python3 - "$TMP_HOME/onboarding-ready.json" <<'PY'
import json
import sys

data = json.load(open(sys.argv[1], encoding="utf-8"))
assert data["ready"] is True
assert data["profileCollection"]["missingRequired"] == []
PY

techweek ask --city nyc "find me an ElevenLabs AI hackathon near SoHo" --json >"$TMP_HOME/ask.json"
python3 - "$TMP_HOME/ask.json" <<'PY'
import json
import sys

data = json.load(open(sys.argv[1], encoding="utf-8"))
assert data["matchedCount"] == 1
event = data["events"][0]
assert "Eleven Labs" in event["name"] or "ElevenLabs" in event["name"]
assert event["locationCluster"] == "SoHo/LES"
PY

answer_sheet="$(techweek answers --city nyc 6365 --write)"
test -f "$answer_sheet"

techweek rsvp-context --city nyc 6365 --json >"$TMP_HOME/rsvp-context.json"
python3 - "$TMP_HOME/rsvp-context.json" <<'PY'
import json
import sys

data = json.load(open(sys.argv[1], encoding="utf-8"))
assert data["eventUrl"] == "https://partiful.com/e/5gz90KPGpE1XoK3GZtoW"
assert data["profile"]["ready"] is True
assert data["platformPolicy"]["primaryLiveTool"] == "Browser Use iab"
assert data["rsvpActionPolicy"]["browserTabPolicy"]["mode"] == "controlled-tab-queue"
PY

techweek answer-field --city nyc 6365 "What is your email?" --json >"$TMP_HOME/email-field.json"
techweek answer-field --city nyc 6365 "Current role?" --json >"$TMP_HOME/role-field.json"
techweek answer-field --city nyc 6365 "Any allergies we should be aware of?" --json >"$TMP_HOME/allergy-field.json"
python3 - "$TMP_HOME/email-field.json" "$TMP_HOME/role-field.json" "$TMP_HOME/allergy-field.json" <<'PY'
import json
import sys

email = json.load(open(sys.argv[1], encoding="utf-8"))
role = json.load(open(sys.argv[2], encoding="utf-8"))
allergy = json.load(open(sys.argv[3], encoding="utf-8"))
assert email["action"] == "fill_from_profile"
assert email["profileKey"] == "email"
assert role["action"] == "fill_from_profile"
assert role["profileKey"] == "title"
assert allergy["action"] == "ask_user"
assert allergy["fieldClass"] == "factual_unknown"
PY

echo "fresh-user-acceptance=pass"
