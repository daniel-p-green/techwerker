---
name: Techwerker
description: Use when the user asks to plan Tech Week, sync NYC/Boston/SF Tech Week calendars, rank Tech Week events, build an oversignup portfolio, manage a Partiful RSVP queue, fill repeated RSVP information, or make Tech Week less of a chore.
version: 0.1.0
---

# Techwerker

Use this skill to manage Tech Week as a fill-once, Codex-operated RSVP workflow. The CLI is the private engine; the user-facing experience should stay conversational. Do not ask the user to run commands, copy event IDs, open links, or manually fill forms when Browser Use or Computer Use can do it.

The workflow is:

1. If the user asks "what can you do?", explain capabilities plainly: fill once, rank events, build an RSVP queue, fill repetitive Tech Week/Partiful forms with Browser Use and Computer Use, remember non-secret answers, and track RSVP state.
2. If the user wants to get started, ask for the city using the calendar's labels: New York, Boston, or San Francisco (coming soon).
3. Start `techweek setup` privately once per city, then collect only the missing non-secret profile and preference fields in chat.
4. Sync the live Tech Week calendar privately when needed.
5. Extract available facets, hosts, locations, and location clusters.
6. Learn or update the user's profile and preferences.
7. Present a short curated set of recommended events in normal language. Do not expose internal event ids unless debugging.
8. When the user says "yes", "get on the list", "sign me up", or equivalent for a specific recommendation, treat that as authorization to attempt the RSVP/list join for that event.
9. Use Browser Use for calendar/link inspection and Computer Use for Partiful form filling. The user should not be asked to open the page or fill fields.
10. Collapse accepted, waitlisted, and backup events into a practical day plan.

## CLI

Prefer the `techweek` command when it is on PATH. If PATH is stale, use the bundled script relative to this `SKILL.md`:

```bash
scripts/techweek
```

Common commands:

```bash
techweek setup --city nyc
techweek setup --city nyc --interactive
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
techweek missing-fields --city nyc add <event-id> "What are you building?"
techweek missing-fields --city nyc resolve <event-id> "What are you building?" "Reusable or event-specific answer"
techweek missing-fields --city nyc show
techweek open --city nyc <event-id>
techweek state --city nyc <event-id> needs-user-answer
techweek state --city nyc <event-id> needs-user-submit
techweek day-plan --city nyc 2026-06-03
techweek export --city nyc --format md
techweek demo-reset --city nyc
```

These commands are for agent execution, not user instructions. Run them yourself and summarize results. In normal operation, never tell the user "run `techweek ...`" or ask them to provide an event id. Translate user intent to the appropriate command and browser/computer action.

State is stored outside the workspace:

```text
~/.codex/data/tech-week/<city>-<year>/
```

`cockpit` is the default command center. It summarizes sync status, recent changes, profile readiness, form memory, RSVP states, and next apply targets.

`setup` is the first-run wizard. In non-interactive runs it initializes files and prints missing fields. In interactive runs it prompts for non-secret profile fields, interests, host priorities, location preferences, signup aggressiveness, and RSVP mode.

For a brand-new user, prefer `/techweek-setup`. First ask for the city using the calendar's labels: New York, Boston, or San Francisco (coming soon). Then collect the common RSVP basics once: name, email, phone number, company, role/title, country, LinkedIn profile, and optional goal of attending. Finally ask lightweight city-specific preferences: topics to prioritize, neighborhoods/location clusters to prefer, event types to prioritize or avoid, and start times to prefer or avoid.

For demos, demo profile values are acceptable. Still run the same setup flow so the product promise is clear: the user gives information once, and Techwerker reuses it for every relevant form.

For recording prep, use `techweek demo-reset --city <city>` privately when you need a clean safe local state. It seeds the fake `Justin Buildman` profile/preferences and clears local RSVP queue/state files. Do not expose this as a normal user-facing feature unless the user is explicitly preparing a demo.

Use the simplified slash command surface:

- `/techweek-setup` for first-time city, profile, and preference setup.
- `/techweek` for status, sync, portfolio planning, interests, and day plans.
- `/techweek-rsvp` for one live RSVP target with Computer Use first.

## Safety Boundary

Never submit an RSVP, application, waitlist form, or "Going" action unless the user explicitly authorizes final submission for that run or that event.

Default mode is `assisted`: open the page, fill obvious visible fields, ask for missing required answers, and stop before final submit. Use `full-auto` only when the user explicitly says final submission is allowed. Phrases like "get on the list" and "sign me up" authorize attempting the RSVP/list join for the selected event, including clicking the relevant final "Get on the list", "Join waitlist", "RSVP", "Continue", or confirmation button if no credentials, payment, one-time code, or unknown required field blocks the flow.

Do not store Partiful credentials, one-time codes, payment details, or passwords.

## Browser Strategy

Use direct HTTP/calendar parsing for the Tech Week calendar whenever possible. The visual calendar lazy-loads, but the CLI can fetch the structured event data faster than clicking filters or scrolling.

Use Browser Use for Tech Week calendar inspection and simple page structure. Use Computer Use first for Partiful because the RSVP UI is often authenticated, visual, and modal-heavy. If Playwright can fill a simple Partiful form cleanly, that is acceptable, but switch to Computer Use as soon as the flow becomes modal-heavy, authenticated, visual-only, or brittle.

For live RSVP runs, prefer:

```bash
techweek live-queue --city <city> --topics AI --time-slots noon,evening --limit 10
```

Then work one event at a time from `live-queue.json` privately. Present event names, timing, location, and why they match. Hide ids unless debugging.

For RSVP sessions:

1. For live RSVP work, run `techweek live-queue --city <city> --topics AI --time-slots noon,evening --limit 10` and choose the best target that matches the user's request. For planned portfolio work, run `techweek apply-queue --city <city>`.
2. Run `techweek answers --city <city> <event-id> --write`.
3. Open or navigate to the event yourself.
4. Fill visible fields from `rsvp-profile.json`, `form-memory.json`, and the generated answer sheet.
5. If a required field is unknown, record it with `techweek missing-fields add`, ask the user only for that missing answer, and offer to save it as reusable or event-specific memory.
6. If the user answers, save it with `techweek missing-fields resolve`. If they do not answer, leave the event in `needs-user-answer` and move to the next queue item if appropriate.
7. Mark state `filled`, `needs-user-submit`, `applied`, or `waitlisted` only after the visible page state justifies it.
8. Stop only for credentials, one-time codes, payment, unknown required answers, or absent user authorization for final submission.

Use `form-memory` for repeated Partiful labels and custom questions:

```bash
techweek form-memory --city nyc map "LinkedIn URL" linkedin
techweek form-memory --city nyc remember "What are you building?" "Reusable non-secret answer"
techweek form-memory --city nyc remember "Why do you want to attend?" "Event-specific answer" --event-id <event-id>
```

Use `missing-fields` when Partiful asks something not covered by profile or form memory:

```bash
techweek missing-fields --city nyc add <event-id> "What are you building?"
techweek missing-fields --city nyc resolve <event-id> "What are you building?" "I build practical AI workflow tools." --reusable
techweek missing-fields --city nyc show
```

Events with no `externalHref` are `invite-only-or-missing-link`, not broken.

## Portfolio Strategy

Use a default `signup_multiplier` of 3. The goal is roughly three plausible applications per intended day/time slot, then choosing after waitlist and acceptance outcomes are known.

Prefer high-signal events that are close enough to chain. Do not optimize a final route before acceptances exist; first create options, then use `day-plan` to collapse the route.

Use sub-agents only when the user explicitly asks for parallel agent work. Good delegated side tasks include ranking a bounded set of AI events, summarizing host quality, or reviewing a generated portfolio. The main agent owns profile, RSVP state, and final-submit safety.
