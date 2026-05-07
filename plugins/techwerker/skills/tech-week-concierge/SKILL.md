---
name: Techwerker
description: Use when the user asks to plan Tech Week, sync NYC/Boston/SF Tech Week calendars, rank Tech Week events, build an oversignup portfolio, manage a Partiful RSVP queue, fill repeated RSVP information, or make Tech Week less of a chore.
version: 0.1.0
---

# Techwerker

Use this skill to manage Tech Week as a fill-once, Codex-operated RSVP workflow. The CLI is the private engine; the user-facing experience should stay conversational. Do not ask the user to run commands, copy event IDs, open links, or manually fill forms when Codex browser-control tools can do it.

First principle: Techwerker is a planning and RSVP operator, not just a form filler. The promise is that Codex can review the calendar, select a realistic portfolio, RSVP to chosen events, and complete tedious repeated forms with minimal user rote work. Because Tech Week events often have waitlists, low acceptance rates, overlapping times, and scattered locations, build enough high-quality options per date/time slot while keeping each day geographically realistic. The goal is optionality that can collapse into an actual schedule.

Platform principle: planning, local state, answer memory, and portfolio generation are normal Codex plugin behavior. The proved live RSVP path is Mac-first today because the primary path is Codex Desktop Browser Use `iab`. If the Codex Chrome plugin is installed/enabled, Chrome is an optional signed-in-browser path for users who want their existing Chrome tabs, cookies, and login state. Computer Use is only a macOS desktop fallback for explicit external-browser debugging.

The workflow is:

1. If the user asks "what can you do?", explain capabilities plainly: fill once, rank events, build an RSVP queue, fill repetitive Tech Week/Partiful forms with Codex's browser-control tools, remember non-secret answers, and track RSVP state.
2. If the user wants to get started, ask for the city using the calendar's labels: New York, Boston, or San Francisco. If San Francisco has not launched yet, treat it as pending instead of inventing events.
3. Run `techweek onboarding-context --city <city> --json` privately, then collect only the missing non-secret profile and preference fields in one compact chat batch.
4. Sync the live Tech Week calendar privately when needed.
5. Extract available facets, hosts, locations, and location clusters.
6. Learn or update the user's profile and preferences.
7. For plain-English requests such as "find me a cool AI event on Tuesday afternoon near Williamsburg" or "near SoHo", run `techweek ask --city <city> "<request>" --json` privately. Use the parsed date/time/topic/location constraints, nearby cluster expansion, and commute metadata to answer in normal language. Do not expose internal event ids unless debugging.
8. Present a short curated set of recommended events in normal language. Account for waitlist risk, overlaps, and location/neighborhood fit. Do not expose internal event ids unless debugging.
9. When the user says "yes", "get on the list", "sign me up", or equivalent for a specific recommendation, treat that as authorization to attempt the RSVP/list join for that event.
10. Use Browser Use `iab` for the proved calendar/link inspection, official Partiful navigation, visible form filling, and scoped click-through path. If the Chrome plugin is installed/enabled and the user wants existing signed-in Chrome state, Chrome may be used with the same active-tab and safety rules. Use Computer Use only as an optional macOS external-desktop fallback when the user is explicitly debugging that path.
11. Collapse accepted, waitlisted, and backup events into a practical day plan.

## CLI

Prefer the `techweek` command when it is on PATH. If PATH is stale, use the bundled script relative to this `SKILL.md`:

```bash
scripts/techweek
```

Common commands:

```bash
techweek setup --city nyc
techweek setup --city nyc --interactive
techweek onboarding-context --city nyc --json
techweek city-status --city all
techweek release-check --city all
techweek ask --city nyc "find me a cool AI event on Tuesday afternoon near Williamsburg" --json
techweek cockpit --city nyc
techweek cockpit --city nyc --date 2026-06-03
techweek sync --city live
techweek sync --city all
techweek diff --city nyc
techweek interests --city nyc
techweek profile --city nyc init
techweek profile --city nyc missing
techweek profile --city nyc set country "United States"
techweek preferences --city nyc show
techweek preferences --city nyc set-list topics "AI, B2B"
techweek preferences --city nyc set-list preferred_formats "Networking, Panel / Fireside Chat"
techweek form-memory --city nyc show
techweek portfolio --city nyc
techweek apply-queue --city nyc
techweek live-queue --city nyc --topics AI --time-slots noon,evening --limit 10
techweek answers --city nyc <event-id> --write
techweek rsvp-context --city nyc <event-id> --json
techweek answer-field --city nyc <event-id> "Visible Partiful label" --json
techweek missing-fields --city nyc add <event-id> "What are you building?"
techweek missing-fields --city nyc resolve <event-id> "What are you building?" "Reusable or event-specific answer"
techweek missing-fields --city nyc show
techweek open --city nyc <event-id>
techweek open --city nyc <event-id> --system-browser
techweek state --city nyc <event-id> needs-user-answer
techweek state --city nyc <event-id> applied
techweek state --city nyc <event-id> waitlisted
techweek day-plan --city nyc 2026-06-03
techweek export --city nyc --format md
techweek demo-reset --city nyc
techweek demo-reset --city nyc --persona daniel
```

These commands are for agent execution, not user instructions. Run them yourself and summarize results. In normal operation, never tell the user "run `techweek ...`" or ask them to provide an event id. Translate user intent to the appropriate command and browser/computer action.

State is stored outside the workspace:

```text
~/.codex/data/tech-week/<city>-<year>/
```

`cockpit` is the default command center. It summarizes sync status, recent changes, profile readiness, form memory, RSVP states, and next apply targets.

`setup` is the first-run wizard. In non-interactive runs it initializes files and prints missing fields. In interactive runs it prompts for non-secret profile fields, interests, host priorities, location preferences, signup aggressiveness, and RSVP mode.

For a brand-new user, prefer `/techweek-setup`. First ask for the city using the calendar's labels: New York, Boston, or San Francisco. Then run `techweek onboarding-context --city <city> --json` privately and use it to collect the common RSVP basics once: name, email, phone number, company, role/title, country, LinkedIn profile, and optional goal of attending. Finally ask lightweight city-specific preferences: topics to prioritize, neighborhoods/location clusters to prefer, event types to prioritize or avoid, and start times to prefer or avoid. If San Francisco is still 404 at `https://tech-week.com/calendar/san-francisco`, explain that the city is supported but pending calendar launch.

If the browser visibly shows account details, such as a Partiful display name, use them as suggestions during setup and ask before saving. During an RSVP form, if Partiful visibly prefilled a non-sensitive value from account details or previous responses, leave/use that value for the current RSVP instead of asking the user to retype it. Do not save visible values as reusable memory unless the user approves. Do not silently gather user identity details from unrelated browser pages, local files, memory, or private data sources. The reliable path is collect the small non-secret RSVP profile once, then reuse it.

For demos, demo profile values are acceptable. Still run the same setup flow so the product promise is clear: the user gives information once, and Techwerker reuses it for every relevant form.

For recording prep, use `techweek demo-reset --city <city>` privately when you need a clean safe local state. It seeds safe sample profile/preferences and clears local RSVP queue/state files. Use `--persona daniel` for the public reviewer recording profile with sample contact values. Do not expose this as a normal user-facing feature unless the user is explicitly preparing a demo.

Use the simplified slash command surface:

- `/techweek-setup` for first-time city, profile, and preference setup.
- `/techweek` for status, sync, portfolio planning, interests, and day plans.
- `/techweek-rsvp` for one live official Partiful target with Browser Use `iab`, or optional Chrome plugin control when installed/enabled and selected; Computer Use is only an optional macOS external-desktop fallback.

For release or debugging work, use `techweek city-status --city all` and `techweek release-check --city all` privately. These are diagnostics, not normal user-facing instructions.

## Safety Boundary

Never submit an RSVP, application, waitlist form, or "Going" action unless the user explicitly authorizes the RSVP/list action for that run or that selected event.

Default mode is `assisted`: open the page, fill obvious visible fields, ask for missing required answers, and click scoped RSVP/list/Continue controls after event-specific authorization. Phrases like "get on the list", "sign me up", and "click RSVP" authorize attempting the RSVP/list join for the selected event, including clicking the relevant "Get on the list", "Join waitlist", "RSVP", "Continue", "Submit", "Going", or confirmation button if no credentials, payment, captcha, one-time code, unknown required field, ambiguous selected-event confirmation, Partiful error, or repeated no-progress click state blocks the flow. Use `needs-user-submit` only when the form is filled but the user has not authorized that event's RSVP/list action.

Do not store Partiful credentials, one-time codes, payment details, or passwords.

## Browser Strategy

Use `https://www.tech-week.com/` as the public main site, `https://tech-week.com/calendar` as the calendar root, and city pages such as `https://tech-week.com/calendar/nyc` and `https://tech-week.com/calendar/boston`. Use direct HTTP/calendar parsing whenever possible. The visual calendar lazy-loads, but the CLI can fetch the structured event data faster than clicking filters or scrolling.

Use Browser Use with the in-app `iab` backend for the proved Tech Week calendar inspection, event-page navigation, visible-state checks, in-app form filling, and scoped RSVP/list click-through path. If the Codex Chrome plugin is installed/enabled and the user wants existing Chrome tabs, cookies, or login state, use Chrome as an optional signed-in-browser path with the same one-active-tab, scoped-click, and safety-stop rules. Use Computer Use only as an optional macOS fallback for desktop browsers/apps it is allowed to control when the user is explicitly debugging an external-browser path. If Computer Use cannot control the Codex app, continue with Browser Use `iab` or Chrome plugin control, whichever is the selected browser surface.

Match the user's natural manual workflow with a controlled tab queue. It is fine to open several candidate Partiful event pages in Browser Use tabs, or Chrome tabs when intentionally using the Chrome plugin, for inspection and comparison, but only one tab should be the active RSVP target at a time. Use plain event URLs for background staging tabs, add `?rsvp=true` or open the modal only for the selected active event, confirm the active tab URL/title matches the selected event before filling or clicking, then record state before switching to another tab.

For live RSVP runs, prefer:

```bash
techweek live-queue --city <city> --topics AI --time-slots noon,evening --limit 10
```

Then work one event at a time from `live-queue.json` privately. Present event names, timing, location, and why they match. Hide ids unless debugging.

For RSVP sessions:

1. For live RSVP work, run `techweek live-queue --city <city> --topics AI --time-slots noon,evening --limit 10` and choose the best target that matches the user's request. For planned portfolio work, run `techweek apply-queue --city <city>`.
2. Run `techweek answers --city <city> <event-id> --write`.
3. Run `techweek rsvp-context --city <city> <event-id> --json` and use its `eventUrl`, profile readiness, form memory, missing fields, `rsvpActionPolicy`, safety policy, and recommended tool sequence.
4. If the profile is missing required fields, collect the missing non-secret RSVP basics in chat before opening the form. Use visible browser/account values only as suggestions, and ask before saving or using them.
5. Navigate the selected Codex-controlled browser surface to `eventUrl`: Browser Use `iab` by default, or Chrome plugin control when installed/enabled and intentionally selected. Do not rely on `techweek open` to launch a browser; it prints and marks state only by default.
6. Inspect visible labels and controls on the official Partiful page. If Partiful repeats labels such as "Get on the list", scope to the visible selected event/modal instead of clicking a global text match.
7. For each visible field label, run `techweek answer-field --city <city> <event-id> "<visible label>" --json` privately and follow the returned action. If the active Partiful field already has a visible non-sensitive value, pass `--visible-value` and `--visible-source account|previous-response|form`.
8. Fill `fill_from_profile` and `fill_saved_answer` values with the selected Codex-controlled browser surface. Leave or use `use_visible_value` fields as-is for the current form and do not ask the user to retype them. Use Computer Use only after an explicit switch to a macOS desktop browser/app for fallback debugging.
9. For `draft_generic_answer`, generate a concise event-specific answer from the returned event/profile/preference context. If `approvalRequired` is true, ask before using it; if false, fill it.
10. For `ask_user`, ask only for that answer and save it with `missing-fields resolve` as event-only by default or reusable if the user says it should apply broadly.
11. For `stop`, pause immediately. Do not fill, generate, or store credentials, one-time codes, payment details, captchas, or sensitive private data.
12. If the user authorized the selected event, click one unique or scoped allowed Partiful action at a time, then re-inspect the visible state before the next click. Do not use a global text click when labels repeat.
13. If a new host-question step appears after Continue, classify every new visible field before clicking again. Legal or factual attestations such as "I am 21 years of age or older" require a user-provided or saved answer; do not generate them.
14. If Partiful shows an error such as "Something went wrong" or the same button repeats without visible progress, stop and record the exact state instead of pressing again.
15. If multiple Partiful tabs are open, record the event state before switching away from the active tab.
16. Mark state `applied` when Partiful visibly confirms RSVP/request/on-list status, `waitlisted` when it confirms waitlist/list status, `cancelled` when a previously submitted demo or RSVP is visibly removed after explicit user authorization, `needs-user-answer` for unresolved required fields, and `needs-user-submit` only when there is no authorization for the selected event action.
17. Stop only for credentials, one-time codes, payment, captcha, unknown required answers, Partiful errors/no-progress states, a final confirmation that does not clearly belong to the selected event, or absent user authorization for the RSVP/list action.

Use `form-memory` for repeated Partiful labels and custom questions:

```bash
techweek form-memory --city nyc map "LinkedIn URL" linkedin
techweek form-memory --city nyc remember "What are you building?" "Reusable non-secret answer"
techweek form-memory --city nyc remember "Why do you want to attend?" "Event-specific answer" --event-id <event-id>
techweek form-memory --city nyc approve-generated motivation
```

Use `missing-fields` when Partiful asks something not covered by profile or form memory:

```bash
techweek missing-fields --city nyc add <event-id> "What are you building?"
techweek missing-fields --city nyc resolve <event-id> "What are you building?" "I build practical AI workflow tools." --reusable
techweek missing-fields --city nyc show
```

Events with no `externalHref` are `invite-only-or-missing-link`, not broken.

## Plain-English Planning

Users should not need to know Tech Week facets, event ids, or command syntax. Translate natural requests into private `techweek ask` calls first, then respond conversationally.

For example, "find me a cool AI event on Tuesday afternoon near Williamsburg" means:

- topic intent: AI-related events,
- date intent: Tuesday of Tech Week,
- time intent: afternoon,
- location intent: Brooklyn plus nearby Brooklyn/Queens clusters,
- ranking intent: same cluster first, nearby clusters next, far hops excluded from the main recommendation unless the event is clearly worth flagging as an exception.

This is not a Flatiron-only trick. Use the configured city neighborhood aliases for the selected city, including NYC aliases such as Midtown, Bryant Park, Times Square, Columbus Circle, Hudson Yards, Kips Bay, Koreatown, NoMad, Flatiron, Gramercy, Union Square, Chelsea, Meatpacking, West Village, Greenwich Village, NoHo, Nolita, SoHo, Lower East Side, East Village, Chinatown, Lower Manhattan, Tribeca, FiDi, Williamsburg, Greenpoint, Bushwick, DUMBO, Fort Greene, Park Slope, Downtown Brooklyn, Brooklyn Navy Yard, Long Island City, Astoria, Jackson Heights, Queens, Central Park, Upper West Side, UWS, Upper East Side, Upper Manhattan, Bronx, Staten Island, and virtual events.

When answering, include the event name, day/time, neighborhood or cluster, why it matches, and whether the signup link is usable. Keep event ids and CLI mechanics out of the public response unless debugging.

## Portfolio Strategy

Use a default `signup_multiplier` of 3. The goal is roughly three plausible applications per intended day/time slot, then choosing after waitlist and acceptance outcomes are known.

Prefer high-signal events that are close enough to chain. Avoid portfolios that require far cross-city movement between adjacent time blocks unless the user explicitly values the event enough to tolerate it. By default, cluster each day around one or two location clusters, keep far-off events as intentional exceptions, and use `day-plan` to collapse accepted/waitlisted options into a realistic route.

Honor saved time-window preferences as hard filters for portfolio planning unless the user explicitly asks to see outside-window options. A "noon/evening" user should not get morning RSVP targets in the main queue.

For speed, work the most under-covered date/time slot first: fewer than the target RSVP attempts beats another redundant backup in an already-covered slot. Treat `applied` and `waitlisted` as attempts, `accepted`/`applied` as secured coverage, and `needs-user-answer` as blocked until resolved.

Use sub-agents only when the user explicitly asks for parallel agent work. Good delegated side tasks include ranking a bounded set of AI events, summarizing host quality, or reviewing a generated portfolio. The main agent owns profile, RSVP state, and final-submit safety.
