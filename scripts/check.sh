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

echo "== bundled script sync =="
cmp -s plugins/techwerker/scripts/techweek plugins/techwerker/skills/tech-week-concierge/scripts/techweek

echo "== cli smoke =="
plugins/techwerker/scripts/techweek --help >/dev/null
grep -q 'DEFAULT_BASE_URL = "https://tech-week.com/calendar"' plugins/techwerker/scripts/techweek
grep -q '"rsvp_mode": "assisted"' plugins/techwerker/scripts/techweek
if grep -q 'full-auto' plugins/techwerker/scripts/techweek plugins/techwerker/skills/tech-week-concierge/scripts/techweek; then
  echo "unsupported full-auto RSVP mode found" >&2
  exit 1
fi

echo "== slash command surface =="
expected_commands="techweek-rsvp.md
techweek-setup.md
techweek.md"
actual_commands="$(find plugins/techwerker/commands -maxdepth 1 -type f -name '*.md' -exec basename {} \; | sort)"
if [ "$actual_commands" != "$expected_commands" ]; then
  echo "unexpected slash commands:" >&2
  echo "$actual_commands" >&2
  exit 1
fi

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
            "name": "Synthetic AI Breakfast",
            "company": "Synthetic Host",
            "location": "Midtown",
            "locationCluster": "Midtown",
            "externalHref": "https://partiful.com/e/synthetic",
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
            "company": "Synthetic Host",
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
            "company": "Synthetic Host",
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
        "name": "Synthetic Boston AI Breakfast",
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
        "name": "Synthetic SF AI Lunch",
        "location": "SoMa",
        "locationCluster": "SoMa",
    }
]
(sf_root / "latest.json").write_text(json.dumps(sf_latest), encoding="utf-8")
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek portfolio --city nyc --limit 1 >/dev/null
python3 - "$tmp_home/.codex/data/tech-week/nyc-2026/portfolio.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

assert data["strategy"]["signupMultiplier"] == 3
assert data["strategy"]["maxClustersPerDay"] == 2
assert "waitlist" in data["strategy"]["riskModel"]
assert "nearby location clusters" in data["strategy"]["locationModel"]
assert data["coverage"]["recommendedAttemptsPerBucket"] == 3
assert data["coverage"]["buckets"]
assert "commuteRelation" in data["events"][0]
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek profile --city "New York" set country "United States" | grep -q 'country=saved'
HOME="$tmp_home" plugins/techwerker/scripts/techweek profile --city nyc missing | grep -q 'profile=missing display_name'
HOME="$tmp_home" plugins/techwerker/scripts/techweek preferences --city nyc set-list topics "AI, B2B" | grep -q 'topics=AI, B2B'
HOME="$tmp_home" plugins/techwerker/scripts/techweek preferences --city nyc set-list neighborhoods "Flatiron, Chelsea" | grep -q 'neighborhoods=Flatiron, Chelsea'
HOME="$tmp_home" plugins/techwerker/scripts/techweek preferences --city nyc set-list preferred_formats "Networking, Panel / Fireside Chat" | grep -q 'preferred_formats=Networking, Panel / Fireside Chat'
HOME="$tmp_home" plugins/techwerker/scripts/techweek preferences --city nyc set-list time_windows "12:00-15:00, 17:00-21:00" | grep -q 'time_windows=12:00-15:00, 17:00-21:00'
HOME="$tmp_home" plugins/techwerker/scripts/techweek onboarding-context --city nyc --from-cache --json >"$tmp_home/onboarding-context.json"
python3 - "$tmp_home/onboarding-context.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

assert data["city"] == "nyc"
assert data["ready"] is False
assert "display_name" in data["profileCollection"]["missingRequired"]
assert "reusable RSVP basics once" in data["profileCollection"]["compactBatchPrompt"]
assert "visible prefilled values" in data["defaultPlan"]["forms"]
assert data["preferenceQuestions"]["timeWindows"]["presets"]["Evening"] == "17:00-21:00"
assert "unknown required field" in data["stopConditions"]
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek portfolio --city nyc --limit 10 >"$tmp_home/time-window-portfolio.txt"
if grep -q '2026-06-01:morning' "$tmp_home/time-window-portfolio.txt"; then
  cat "$tmp_home/time-window-portfolio.txt"
  echo "portfolio included morning despite noon/evening time windows" >&2
  exit 1
fi
grep -q '2026-06-01:noon' "$tmp_home/time-window-portfolio.txt"
HOME="$tmp_home" plugins/techwerker/scripts/techweek portfolio --city Boston --limit 1 >/dev/null
HOME="$tmp_home" plugins/techwerker/scripts/techweek preferences --city Boston set-list neighborhoods "Cambridge, Kendall Square" | grep -q 'neighborhoods=Cambridge, Kendall Square'
HOME="$tmp_home" plugins/techwerker/scripts/techweek demo-reset --city Boston --no-sync --keep-state | grep -q 'profile=demo Justin Buildman'
HOME="$tmp_home" plugins/techwerker/scripts/techweek live-queue --city "New York" --topics AI --time-slots noon,evening --limit 3 --from-cache | grep -q '^2 '
HOME="$tmp_home" plugins/techwerker/scripts/techweek live-queue --city "New York" --topics AI --time-slots noon,evening --limit 3 --from-cache | grep -q 'queue=1 shown / 1 matched'
HOME="$tmp_home" plugins/techwerker/scripts/techweek ask --city "New York" "find me a cool AI event on Monday evening near Flatiron" --json >"$tmp_home/plain-ask.json"
python3 - "$tmp_home/plain-ask.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

query = data["query"]
assert query["dates"] == ["2026-06-01"]
assert query["timeSlots"] == ["evening"]
assert "AI" in query["topicFilters"]
assert query["locationAnchors"] == ["Flatiron/NoMad"]
assert "Midtown" in query["nearbyClusters"]["Flatiron/NoMad"]
assert data["matchedCount"] >= 1
event = data["events"][0]
assert event["timeSlot"] == "evening"
assert event["locationCluster"] == "Chelsea/West Side"
assert event["commuteRelation"] == "nearby"
assert "nearby" in "\n".join(event["queryReasons"])
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek ask --city "New York" "find me a cool AI event on Tuesday afternoon near Flatiron" --json >"$tmp_home/tuesday-afternoon-ask.json"
python3 - "$tmp_home/tuesday-afternoon-ask.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

query = data["query"]
assert query["dates"] == ["2026-06-02"]
assert query["timeSlots"] == ["afternoon"]
assert query["locationAnchors"] == ["Flatiron/NoMad"]
assert "Chelsea/West Side" in query["nearbyClusters"]["Flatiron/NoMad"]
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek ask --city "New York" "find me a cool AI event on Monday evening near Brooklyn" --json >"$tmp_home/brooklyn-ask.json"
python3 - "$tmp_home/brooklyn-ask.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

query = data["query"]
assert query["dates"] == ["2026-06-01"]
assert query["timeSlots"] == ["evening"]
assert query["locationAnchors"] == ["Brooklyn"]
assert "Queens" in query["nearbyClusters"]["Brooklyn"]
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek ask --city "New York" "find me an AI event on Monday evening near Soho" --json >"$tmp_home/soho-ask.json"
python3 - "$tmp_home/soho-ask.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

query = data["query"]
assert query["locationAnchors"] == ["SoHo/LES"]
assert "Financial District/Tribeca" in query["nearbyClusters"]["SoHo/LES"]
PY
python3 - "$tmp_home" <<'PY'
import json
import os
import subprocess
import sys

env = dict(os.environ, HOME=sys.argv[1])
checks = [
    ("find me an AI event on Tuesday afternoon near Bryant Park", "Midtown"),
    ("find me an AI event on Tuesday afternoon near Lower Manhattan", "Financial District/Tribeca"),
    ("find me an AI event on Tuesday afternoon near UWS", "Uptown/Central Park"),
    ("find me an AI event on Tuesday afternoon near Columbus Circle", "Midtown"),
    ("find me an AI event on Tuesday afternoon near Times Square", "Midtown"),
    ("find me an AI event on Tuesday afternoon near Brooklyn Navy Yard", "Brooklyn"),
    ("find me an AI event on Tuesday afternoon near Jackson Heights", "Queens"),
]
for text, expected in checks:
    output = subprocess.check_output(
        ["plugins/techwerker/scripts/techweek", "ask", "--city", "New York", text, "--json"],
        env=env,
        text=True,
    )
    data = json.loads(output)
    actual = data["query"]["locationAnchors"]
    assert actual == [expected], (text, expected, actual)
    assert data["query"]["timeSlots"] == ["afternoon"], text
    assert "AI" in data["query"]["topicFilters"], text
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek ask --city "New York" "find me an AI event on Tuesday afternoon near Bryant Park" --json >"$tmp_home/parallel-ask-1.json" &
ask_pid_1=$!
HOME="$tmp_home" plugins/techwerker/scripts/techweek ask --city "New York" "find me an AI event on Tuesday afternoon near UWS" --json >"$tmp_home/parallel-ask-2.json" &
ask_pid_2=$!
wait "$ask_pid_1"
wait "$ask_pid_2"
python3 - "$tmp_home/parallel-ask-1.json" "$tmp_home/parallel-ask-2.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    first = json.load(f)
with open(sys.argv[2], encoding="utf-8") as f:
    second = json.load(f)

assert first["query"]["locationAnchors"] == ["Midtown"]
assert second["query"]["locationAnchors"] == ["Uptown/Central Park"]
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek live-queue --city Boston --topics AI --time-slots noon,evening --limit 3 --from-cache | grep -q '^bos-1 '
HOME="$tmp_home" plugins/techwerker/scripts/techweek live-queue --city "San Francisco" --topics AI --time-slots noon --limit 3 --from-cache | grep -q '^sf-1 '
HOME="$tmp_home" plugins/techwerker/scripts/techweek city-status --city all --from-cache --json >"$tmp_home/city-status.json"
python3 - "$tmp_home/city-status.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

by_city = {row["city"]: row for row in data["cities"]}
assert set(by_city) == {"nyc", "boston", "san-francisco"}
assert by_city["nyc"]["status"] == "launched"
assert by_city["boston"]["status"] == "launched"
assert by_city["san-francisco"]["status"] == "launched"
assert by_city["nyc"]["calendarUrl"] == "https://tech-week.com/calendar/nyc"
assert by_city["nyc"]["localOpenLinkCount"] >= 1
PY
pending_home="$(mktemp -d)"
HOME="$pending_home" plugins/techwerker/scripts/techweek city-status --city san-francisco --from-cache --json >"$tmp_home/sf-pending.json"
python3 - "$tmp_home/sf-pending.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

row = data["cities"][0]
assert row["city"] == "san-francisco"
assert row["status"] == "pending"
assert row["localEventCount"] == 0
assert row["calendarUrl"] == "https://tech-week.com/calendar/san-francisco"
PY
rm -rf "$pending_home"
test -f "$tmp_home/.codex/data/tech-week/nyc-2026/live-queue.json"
test -f "$tmp_home/.codex/data/tech-week/san-francisco-2026/live-queue.json"
test ! -f "$tmp_home/.codex/data/tech-week/san-francisco-2026/portfolio.json"
test ! -f "$tmp_home/.codex/data/tech-week/san-francisco-2026/rsvp-profile.json"
test ! -f "$tmp_home/.codex/data/tech-week/san-francisco-2026/form-memory.json"
HOME="$tmp_home" plugins/techwerker/scripts/techweek demo-reset --city nyc --no-sync --keep-state | grep -q 'profile=demo Justin Buildman'
answer_sheet_path="$(HOME="$tmp_home" plugins/techwerker/scripts/techweek answers --city nyc 2 --write)"
test -f "$answer_sheet_path"
context_path="$tmp_home/rsvp-context.json"
HOME="$tmp_home" plugins/techwerker/scripts/techweek rsvp-context --city nyc 2 --json >"$context_path"
python3 - "$context_path" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

assert data["eventUrl"] == "https://partiful.com/e/noon-ai"
assert data["event"]["isPartiful"] is True
assert data["profile"]["ready"] is True
profile_policy = data["profile"]["collectionPolicy"]
assert "email" in profile_policy["collectOnceFields"]
assert "Visible browser account" in "\n".join(profile_policy["allowedSources"])
assert "one-time codes" in profile_policy["doNotInferOrStore"]
assert data["preferences"]["rsvpMode"] == "assisted"
assert data["answerSheetExists"] is True
sequence = "\n".join(data["recommendedToolSequence"])
assert "rsvp-context" in sequence
assert "answer-field" in sequence
assert "Browser Use iab" in sequence
assert "Computer Use" in sequence
assert "Authorized RSVP loop" in sequence
assert "captcha" in data["safety"]["stopConditions"]
assert "click RSVP" in data["safety"]["authorizationPhrases"]
assert "visible confirmation" in data["safety"]["finalSubmitPolicy"]
policy = data["rsvpActionPolicy"]
assert policy["requiresEventSpecificAuthorization"] is True
assert "click RSVP" in policy["authorizationPhrases"]
assert "RSVP" in policy["authorizedActionLabels"]
assert "Continue" in policy["authorizedActionLabels"]
assert "needs-user-submit" in policy["finalStateGuidance"]
assert "user has not authorized" in policy["needsUserSubmitPolicy"]
assert policy["browserTabPolicy"]["mode"] == "controlled-tab-queue"
assert "active RSVP target" in policy["browserTabPolicy"]["activation"]
assert "Mac-first today" in data["platformPolicy"]["liveRsvp"]
assert data["platformPolicy"]["primaryLiveTool"] == "Browser Use iab"
assert "macOS only" in data["platformPolicy"]["fallbackLiveTool"]
assert policy["platformPolicy"] == data["platformPolicy"]
strategy = data["answerStrategy"]
assert "event-specific saved answer" in strategy["sourcePrecedence"]
assert strategy["generatedPolicy"]["mode"] == "draft-first"
assert "visible prefilled value" in strategy["sourcePrecedence"][0]
assert "visiblePrefill" in strategy["fieldClasses"]
assert "visiblePrefill" in strategy["defaults"]
assert "motivation" in strategy["fieldClasses"]["generatedGeneric"]
assert "password" in strategy["fieldClasses"]["sensitiveStop"]
PY
answer_path="$tmp_home/answer-field.json"
HOME="$tmp_home" plugins/techwerker/scripts/techweek answer-field --city nyc 2 "Email" --json >"$answer_path"
python3 - "$answer_path" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

assert data["action"] == "fill_from_profile"
assert data["profileKey"] == "email"
assert data["value"] == "justin@demo.example"
PY
python3 - "$tmp_home" <<'PY'
import json
import os
import subprocess
import sys

env = dict(os.environ, HOME=sys.argv[1])
checks = [
    ("What is your email?", "email", "justin@demo.example"),
    ("What is your LinkedIn?", "linkedin", "linkedin.com/in/justin-buildman"),
    ("Current role?", "title", "Founder"),
    ("Company name", "company", "Buildman Labs"),
]
for label, profile_key, value in checks:
    output = subprocess.check_output(
        ["plugins/techwerker/scripts/techweek", "answer-field", "--city", "nyc", "2", label, "--json"],
        env=env,
        text=True,
    )
    data = json.loads(output)
    assert data["action"] == "fill_from_profile", (label, data)
    assert data["profileKey"] == profile_key, (label, data)
    assert data["value"] == value, (label, data)
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek form-memory --city nyc remember "What are you building?" "Reusable build answer" >/dev/null
HOME="$tmp_home" plugins/techwerker/scripts/techweek answer-field --city nyc 2 "What are you building?" --json >"$answer_path"
python3 - "$answer_path" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

assert data["action"] == "fill_saved_answer"
assert data["scope"] == "reusable"
assert data["value"] == "Reusable build answer"
assert data["record"]["source"] == "user"
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek form-memory --city nyc remember "What are you building?" "Event build answer" --event-id 2 >/dev/null
HOME="$tmp_home" plugins/techwerker/scripts/techweek answer-field --city nyc 2 "What are you building?" --json >"$answer_path"
python3 - "$answer_path" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

assert data["action"] == "fill_saved_answer"
assert data["scope"] == "event"
assert data["value"] == "Event build answer"
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek answer-field --city nyc 2 "Why do you want to attend?" --json >"$answer_path"
python3 - "$answer_path" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

assert data["action"] == "draft_generic_answer"
assert data["answerClass"] == "motivation"
assert data["approvalRequired"] is True
assert data["mayAutoFillGenerated"] is False
assert data["draftContext"]["event"]["name"] == "AI Noon Matchmaking"
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek form-memory --city nyc approve-generated motivation >/dev/null
HOME="$tmp_home" plugins/techwerker/scripts/techweek form-memory --city nyc remember "Why do you want to attend?" "Generated motivation answer" --event-id 2 --source generated --answer-class motivation >/dev/null
HOME="$tmp_home" plugins/techwerker/scripts/techweek form-memory --city nyc show >"$tmp_home/form-memory.json"
python3 - "$tmp_home/form-memory.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

assert "motivation" in data["generated_answer_policy"]["approved_classes"]
record = data["event_answers"]["2"]["why do you want to attend"]
assert record["source"] == "generated"
assert record["answerClass"] == "motivation"
assert record["scope"] == "event"
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek missing-fields --city nyc clear 2 >/dev/null
HOME="$tmp_home" plugins/techwerker/scripts/techweek answer-field --city nyc 2 "Dietary restrictions" --json >"$answer_path"
python3 - "$answer_path" "$tmp_home/.codex/data/tech-week/nyc-2026/rsvp-state.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
with open(sys.argv[2], encoding="utf-8") as f:
    state = json.load(f)

assert data["action"] == "ask_user"
assert data["fieldClass"] == "factual_unknown"
assert data["recordedMissingField"] is True
assert state["2"]["state"] == "needs-user-answer"
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek answer-field --city nyc 2 "OTP code" --json >"$answer_path"
python3 - "$answer_path" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

assert data["action"] == "stop"
assert data["fieldClass"] == "sensitive"
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek answer-field --city nyc 2 "What is your full name for building security?" --visible-value "Daniel Green" --visible-source previous-response --json --no-record-missing >"$answer_path"
python3 - "$answer_path" "$tmp_home/.codex/data/tech-week/nyc-2026/rsvp-state.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
with open(sys.argv[2], encoding="utf-8") as f:
    state = json.load(f)

assert data["action"] == "use_visible_value"
assert data["fieldClass"] == "visible_prefill"
assert data["source"] == "visible"
assert data["visibleSource"] == "previous-response"
assert data["shouldSave"] is False
assert data["recordedMissingField"] is False
assert state["2"]["state"] == "needs-user-answer"
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek answer-field --city nyc 2 "OTP code" --visible-value "123456" --json --no-record-missing >"$answer_path"
python3 - "$answer_path" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

assert data["action"] == "stop"
assert data["fieldClass"] == "sensitive"
PY
HOME="$tmp_home" plugins/techwerker/scripts/techweek missing-fields --city nyc clear 2 >/dev/null
tmp_bin="$tmp_home/bin"
mkdir -p "$tmp_bin"
cat >"$tmp_bin/open" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$@" >"${TECHWERKER_OPEN_LOG:?}"
SH
chmod +x "$tmp_bin/open"
open_log="$tmp_home/open.log"
TECHWERKER_OPEN_LOG="$open_log" PATH="$tmp_bin:$PATH" HOME="$tmp_home" plugins/techwerker/scripts/techweek open --city nyc 2 | grep -q 'https://partiful.com/e/noon-ai'
test ! -f "$open_log"
TECHWERKER_OPEN_LOG="$open_log" PATH="$tmp_bin:$PATH" HOME="$tmp_home" plugins/techwerker/scripts/techweek open --city nyc 2 --no-browser | grep -q 'https://partiful.com/e/noon-ai'
test ! -f "$open_log"
TECHWERKER_OPEN_LOG="$open_log" PATH="$tmp_bin:$PATH" HOME="$tmp_home" plugins/techwerker/scripts/techweek open --city nyc 2 --system-browser | grep -q 'https://partiful.com/e/noon-ai'
grep -q 'https://partiful.com/e/noon-ai' "$open_log"
HOME="$tmp_home" plugins/techwerker/scripts/techweek apply-queue --city nyc --limit 1 | grep -q '^2 '
HOME="$tmp_home" plugins/techwerker/scripts/techweek missing-fields --city nyc add 2 "What are you building?" >/dev/null
if HOME="$tmp_home" plugins/techwerker/scripts/techweek apply-queue --city nyc --limit 1 | grep -q '^2 '; then
  echo "missing field event stayed in apply queue" >&2
  exit 1
fi
HOME="$tmp_home" plugins/techwerker/scripts/techweek missing-fields --city nyc resolve 2 "What are you building?" "Fixture answer" --reusable >/dev/null
HOME="$tmp_home" plugins/techwerker/scripts/techweek apply-queue --city nyc --limit 1 | grep -q '^2 '
HOME="$tmp_home" plugins/techwerker/scripts/techweek release-check --city all --skip-live --json >"$tmp_home/release-check.json"
python3 - "$tmp_home/release-check.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

assert data["ok"] is True
assert data["summary"]["fail"] == 0
checks = {row["name"]: row for row in data["checks"]}
assert checks["script-copy-sync"]["status"] == "pass"
assert checks["city-status"]["status"] == "pass"
assert checks["public-hygiene"]["status"] == "pass"
assert checks["release-artifacts"]["status"] == "pass"
assert checks["fresh-user-acceptance"]["status"] == "pass"
assert checks["portfolio-sanity:nyc"]["status"] == "pass"
assert checks["portfolio-sanity:boston"]["status"] == "pass"
assert checks["portfolio-sanity:san-francisco"]["status"] == "warn"
artifact_details = checks["release-artifacts"]["details"]
assert artifact_details["demoGifBytes"] > 1
assert artifact_details["reviewerVideoBytes"] > 1
assert artifact_details["expectations"]["codexManifestIsPublicReady"] is True
assert artifact_details["expectations"]["readmeHasNonDeveloperInstall"] is True
assert artifact_details["expectations"]["readmeLinksEvidence"] is True
assert artifact_details["expectations"]["readmeLinksReviewerVideo"] is True
assert artifact_details["expectations"]["shipReadinessHasColdReview"] is True
assert artifact_details["expectations"]["evidenceHasLiveProof"] is True
assert artifact_details["expectations"]["evidenceUsesElevenLabs"] is True
assert artifact_details["expectations"]["launchUsesConversationalFlow"] is True
assert artifact_details["expectations"]["demoVideoUsesElevenLabs"] is True
assert artifact_details["expectations"]["demoVideoSquareSource"] is True
assert artifact_details["expectations"]["assetManifestPrivacyReviewed"] is True
assert artifact_details["expectations"]["fixtureHasDuplicateCta"] is True
assert artifact_details["expectations"]["fixtureHasActiveModal"] is True
assert artifact_details["expectations"]["fixtureHasUnknownRequired"] is True
assert artifact_details["expectations"]["variantFixtureHasCoverage"] is True
nyc_details = checks["portfolio-sanity:nyc"]["details"]
assert nyc_details["outsideTimeWindowLeaks"] == []
assert nyc_details["missingCommuteMetadata"] == []
city_rows = checks["city-status"]["details"]["cities"]
assert {row["city"] for row in city_rows} == {"nyc", "boston", "san-francisco"}
PY

echo "== rsvp click-through docs =="
if git grep -nE 'pause before final RSVP|pause before final submission|stop before final submit|Stop before final RSVP' -- README.md SECURITY.md docs plugins/techwerker ':!plugins/techwerker/scripts' ':!plugins/techwerker/skills/tech-week-concierge/scripts' >/tmp/techwerker-check-rsvp-docs.txt 2>/dev/null; then
  cat /tmp/techwerker-check-rsvp-docs.txt
  echo "stale RSVP stop-before-submit language found" >&2
  exit 1
fi
git grep -q 'does not invent factual personal data' README.md plugins/techwerker/README.md
git grep -q 'Do not silently gather user identity details' plugins/techwerker/skills/tech-week-concierge/SKILL.md
git grep -q 'Generated answers are limited to low-stakes motivation/comment prompts' SECURITY.md
git grep -q 'San Francisco' README.md plugins/techwerker/README.md
git grep -q 'pending' README.md plugins/techwerker/README.md
git grep -q 'Reviewer proof lives in' README.md
git grep -q 'Tuesday afternoon near Williamsburg' README.md plugins/techwerker/README.md plugins/techwerker/skills/tech-week-concierge/SKILL.md plugins/techwerker/commands/techweek.md
git grep -q 'not a Flatiron-only trick' plugins/techwerker/skills/tech-week-concierge/SKILL.md
git grep -q 'techweek ask --city' plugins/techwerker/skills/tech-week-concierge/SKILL.md plugins/techwerker/commands/techweek.md
git grep -q 'Mac-first' README.md SECURITY.md plugins/techwerker/README.md plugins/techwerker/skills/tech-week-concierge/SKILL.md plugins/techwerker/references/partiful-rsvp-runbook.md
grep -q 'data-active-rsvp-modal="true"' fixtures/partiful-rsvp-fixture.html
test "$(grep -c 'Get on the list' fixtures/partiful-rsvp-fixture.html)" -ge 2
grep -q 'What are you building?' fixtures/partiful-rsvp-fixture.html
grep -q 'needs-user-answer' fixtures/partiful-rsvp-fixture.html
for variant in duplicate-cta already-pending waitlist-confirmed custom-required visible-prefill otp-stop captcha-stop payment-stop optional-generic; do
  grep -q "data-fixture-variant=\"$variant\"" fixtures/partiful-rsvp-variants.html
done
grep -q 'Rebuild x Eleven Labs Hackathon' docs/release-evidence.md docs/demo-script.md docs/demo-video/index.html
grep -q 'https://partiful.com/e/5gz90KPGpE1XoK3GZtoW' docs/release-evidence.md docs/demo-video/index.html README.md
grep -q 'Final visible state: `Pending`' docs/release-evidence.md
grep -q 'do not repeat real RSVP submissions' docs/release-evidence.md
grep -q 'Reviewer Cold-Read Test' docs/ship-readiness.md
grep -q 'Privacy review' docs/demo-video/ASSET-MANIFEST.md
git grep -q 'What can you do?' docs/launch-copy.md
git grep -q 'non-developers using the Codex app for Mac' README.md
git grep -q 'techwerker-poster.jpg' plugins/techwerker/.codex-plugin/plugin.json
if git grep -n 'pause before final submit' plugins/techwerker/.codex-plugin/plugin.json README.md docs plugins/techwerker ':!plugins/techwerker/scripts' ':!plugins/techwerker/skills/tech-week-concierge/scripts' >/tmp/techwerker-check-plugin-stale.txt 2>/dev/null; then
  cat /tmp/techwerker-check-plugin-stale.txt
  echo "stale plugin marketplace language found" >&2
  exit 1
fi
test -s assets/techwerker-demo.gif
test -s assets/techwerker-reviewer-demo.mp4
ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0:s=x assets/techwerker-reviewer-demo.mp4 | grep -q '^1080x1080$'
test -s docs/demo-video/DESIGN.md
test -s docs/demo-video/index.html
test -s docs/demo-video/assets/elevenlabs-event-crop.png
test -s docs/demo-video/assets/elevenlabs-pending-proof.png
test -s plugins/techwerker/assets/techwerker-poster.jpg
scripts/fresh-user-acceptance.sh | grep -q 'fresh-user-acceptance=pass'
if git grep -nE 'use Computer Use first|paused before submit|submit_policy=pause before final submit' -- scripts/render-demo-gif.sh docs/demo-video README.md docs plugins/techwerker ':!plugins/techwerker/scripts' ':!plugins/techwerker/skills/tech-week-concierge/scripts' >/tmp/techwerker-check-demo-stale.txt 2>/dev/null; then
  cat /tmp/techwerker-check-demo-stale.txt
  echo "stale demo rendering language found" >&2
  exit 1
fi

echo "== public hygiene grep =="
if git grep -nE '/Users/danielgreen|gho_|Token:|password=|api[_-]?key|SECRET|PRIVATE KEY' -- README.md SECURITY.md docs plugins/techwerker ':!scripts/check.sh' ':!plugins/techwerker/scripts' ':!plugins/techwerker/skills/tech-week-concierge/scripts' >/tmp/techwerker-check-grep.txt 2>/dev/null; then
  cat /tmp/techwerker-check-grep.txt
  echo "public hygiene grep failed" >&2
  exit 1
fi

rm -f /tmp/techwerker-check-grep.txt /tmp/techwerker-check-rsvp-docs.txt
find plugins/techwerker -type d -name __pycache__ -prune -exec rm -rf {} +

echo "ok"
