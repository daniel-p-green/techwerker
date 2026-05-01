---
name: Techwerker
description: Use when the user asks to plan Tech Week, sync NYC/Boston/SF Tech Week calendars, rank Tech Week events, build an oversignup portfolio, manage a Partiful RSVP queue, fill repeated RSVP information, or make Tech Week less of a chore.
version: 0.1.0
---

# Techwerker

Use this skill to manage Tech Week as an event portfolio, not a static calendar. The workflow is:

1. Ask the user to choose a city using the calendar's labels: New York, Boston, or San Francisco (coming soon).
2. Start with `techweek setup` once per city.
3. Use `techweek cockpit` as the regular command center.
4. Sync the live Tech Week calendar when needed.
5. Extract available facets, hosts, locations, and location clusters.
6. Learn or update the user's profile and preferences.
7. Build a geography-aware oversignup portfolio because many events are waitlisted or host-approved.
8. Work the Partiful RSVP queue in assisted mode.
9. Collapse accepted, waitlisted, and backup events into a practical day plan.

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
```

State is stored outside the workspace:

```text
~/.codex/data/tech-week/<city>-<year>/
```

`cockpit` is the default command center. It summarizes sync status, recent changes, profile readiness, form memory, RSVP states, and next apply targets.

`setup` is the first-run wizard. In non-interactive runs it initializes files and prints missing fields. In interactive runs it prompts for non-secret profile fields, interests, host priorities, location preferences, signup aggressiveness, and RSVP mode.

For a brand-new user, prefer `/techweek-setup`. First ask for the city using the calendar's labels: New York, Boston, or San Francisco (coming soon). Then collect the common RSVP basics once: name, email, phone number, company, role/title, country, LinkedIn profile, and optional goal of attending. Finally ask lightweight city-specific preferences: topics to prioritize, neighborhoods/location clusters to prefer, event types to prioritize or avoid, and start times to prefer or avoid.

Use the simplified slash command surface:

- `/techweek-setup` for first-time city, profile, and preference setup.
- `/techweek` for status, sync, portfolio planning, interests, and day plans.
- `/techweek-rsvp` for one live RSVP target with Computer Use first.

## Safety Boundary

Never submit an RSVP, application, waitlist form, or "Going" action unless the user explicitly authorizes final submission for that run or that event.

Default mode is `assisted`: open the page, fill obvious visible fields, ask for missing required answers, and stop before final submit. Use `full-auto` only when the user explicitly says final submission is allowed.

Do not store Partiful credentials, one-time codes, payment details, or passwords.

## Browser Strategy

Use direct HTTP/calendar parsing for the Tech Week calendar whenever possible. The visual calendar lazy-loads, but the CLI can fetch the structured event data faster than clicking filters or scrolling.

Use Computer Use first for Partiful because the RSVP UI is often authenticated, visual, and modal-heavy. Use Browser/Playwright only for Tech Week calendar parsing, simple static page inspection, or non-Partiful pages. If Partiful becomes modal-heavy or accessibility refs are poor, do not keep fighting DOM automation.

For live RSVP runs, prefer:

```bash
techweek live-queue --city <city> --topics AI --time-slots noon,evening --limit 10
```

Then work one event at a time from `live-queue.json`.

For RSVP sessions:

1. For live RSVP work, run `techweek live-queue --city <city> --topics AI --time-slots noon,evening --limit 10` and choose the first target. For planned portfolio work, run `techweek apply-queue --city <city>`.
2. Run `techweek answers --city <city> <event-id> --write`.
3. Open the event with `techweek open --city <city> <event-id>` or navigate the in-app browser to `externalHref`.
4. Fill visible fields from `rsvp-profile.json`, `form-memory.json`, and `answer-sheets/<event-id>.md`.
5. If a required field is unknown, record it with `techweek missing-fields add`, ask once, and offer to save the answer as reusable or event-specific memory.
6. If the user answers, save it with `techweek missing-fields resolve`. If they do not answer, leave the event in `needs-user-answer` and move to the next queue item.
7. Mark state `filled` or `needs-user-submit` only after all required fields are resolved.
8. Stop before final submit unless explicitly authorized.

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
