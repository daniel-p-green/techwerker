# Techwerker

**Takes the work out of Tech Week.**

Techwerker is an unofficial local Codex helper for managing dense Tech Week calendars, RSVP queues, repeated Partiful fields, and RSVP state.

It is built for attendees who want a better workflow than manually scanning 1,200+ events, opening the same signup forms, and remembering which waitlists they already joined.

Techwerker is also a public demo of Codex as a practical workflow assistant: it filters a noisy event universe, remembers non-secret attendee details locally, works through RSVP queues, and uses Browser Use plus Computer Use to handle repetitive Tech Week and Partiful form work.

> Techwerker is not affiliated with, endorsed by, or sponsored by Tech Week, a16z, Partiful, or any event host.

## Why This Exists

Tech Week calendars are high-volume, fast-changing, and waitlist-heavy. The real workflow drag is not any single form. It is repeatedly deciding what is worth attending, entering the same identity details, tracking waitlists, and remembering which signup pages still need action.

Techwerker does not pretend to perfectly plan your whole week upfront. It helps you:

- find higher-signal events faster,
- build an oversignup portfolio,
- keep RSVP state straight,
- reuse non-secret form answers,
- hand off Tech Week and Partiful pages to Browser Use and Computer Use,
- get on the list when you explicitly ask it to.

## See It Work

![Techwerker demo](assets/techwerker-demo.gif)

Chat-first demo flow:

```text
You: What can you do?
Techwerker: I can sync Tech Week, remember your non-secret RSVP basics, recommend events, and use Browser Use plus Computer Use to handle the repetitive signup forms.

You: Get started.
Techwerker: Which city: New York, Boston, or San Francisco?

You: Find the best AI hackathons for me.
Techwerker: Here are the strongest matches...

You: Yes, get me on the list for that one.
Techwerker: Opens the event, fills known fields, handles the Partiful flow, and records the outcome.
```

The optional CLI remains the private engine behind the plugin. During a normal Codex run, the user should not need to copy event IDs, paste links, run commands, or manually fill repeated RSVP fields.

Example internal cockpit output:

```text
# Tech Week Cockpit: nyc-2026
synced=2026-04-30T20:56:18+00:00 events=1221 open_links=1054 needs_review=167
portfolio_targets=83 apply_queue_pending=83 live_queue=3
profile=missing display_name, email, phone, company, title, country, linkedin
form_memory=22 mappings, 0 reusable answers, 0 event answers
```

For the RSVP handoff, Codex opens the event itself, uses Browser Use or Computer Use to fill known fields from local profile/form memory, asks once for unknown required fields, and updates local RSVP state. The point is not that event forms are hard. The point is that obvious workflow drag accumulates fast in the wild, and Codex can remove it when code, browser control, local state, and human intent work together.

## Install

### Codex Plugin

```bash
codex plugin marketplace add daniel-p-green/techwerker
```

Then enable the `Techwerker` plugin in Codex if it is not enabled automatically. The plugin commands work inside Codex; the terminal `techweek` command is optional and installed separately below.

### Optional Terminal CLI

From a clone, install the optional terminal command:

```bash
./scripts/install-cli.sh
```

This adds a `techweek` shim to `~/.local/bin` by default. Make sure that directory is on your `PATH`.

## Quick Start

Inside Codex, start with the chat-first setup:

```text
/techweek-setup
```

It asks the attendee to choose New York, Boston, or San Francisco (coming soon), collects name, email, phone number, company, role, country, LinkedIn profile, and an optional goal of attending, then saves reusable non-secret values locally.

For a fast live RSVP run, ask naturally:

```text
Find AI hackathons in New York and get me on the list for the best one.
```

That builds a narrow live queue from the official Tech Week calendar, defaults to relevant Partiful targets, and works one event at a time with Browser Use and Computer Use.

For broader planning, ask naturally:

```text
What can you do?
Find the best events for me.
Make me a day plan for June 3.
```

Optional terminal equivalent:

```bash
techweek setup --city "New York" --interactive
techweek live-queue --city "New York" --topics AI --time-slots noon,evening --limit 10
```

Persistent local state lives outside the repo:

```text
~/.codex/data/tech-week/<city>-<year>/
```

## Reusable RSVP Info

Techwerker stores non-secret profile fields locally so repeated Partiful forms do not start from scratch:

```bash
techweek profile --city nyc init
techweek profile --city nyc missing
techweek profile --city nyc set country "United States"
techweek profile --city nyc show
techweek preferences --city nyc show
```

The profile includes name, email, phone, company, title, country, LinkedIn, website, a one-line bio, a default why-attending answer, and a default comment template.

First-use preference setup can also save city-specific filters:

```bash
techweek preferences --city nyc set-list topics "AI, B2B"
techweek preferences --city nyc set-list neighborhoods "Flatiron, Chelsea"
techweek preferences --city nyc set-list preferred_formats "Networking, Panel / Fireside Chat"
techweek preferences --city nyc set-list excluded_formats "Hackathon"
techweek preferences --city nyc set-list time_windows "08:00-12:00, 12:00-17:00"
```

If Partiful asks a custom required question that Techwerker does not recognize, Techwerker records it as a missing field and asks once instead of blocking the RSVP queue:

```bash
techweek missing-fields --city nyc add <event-id> "What are you building?"
techweek missing-fields --city nyc resolve <event-id> "What are you building?" "I build practical AI workflow tools." --reusable
techweek missing-fields --city nyc show
```

Unresolved events are marked `needs-user-answer` and skipped by the apply queue until the missing answer is resolved. Optional unknown fields can be left blank.

## Plugin Commands

- `/techweek-setup`
- `/techweek`
- `/techweek-rsvp`

## Safety

Techwerker stores local helper state only. It does not store Partiful credentials, passwords, one-time codes, or payment details.

Default RSVP behavior is assisted mode: fill known fields, then pause before final submission.

Full auto-submit should only be used with explicit per-run authorization.

See [SECURITY.md](SECURITY.md) for details.

## Limitations

- Locations may be hidden by Partiful until acceptance.
- RSVP acceptance and waitlist status still need to be tracked manually unless you update state yourself.
- Partiful Computer Use handoff depends on your logged-in browser session and visible page state.
- San Francisco support is present, but the calendar may report pending until it launches.
- This is an attendee workflow helper, not an official calendar or RSVP client.

## Repo Layout

```text
.agents/plugins/marketplace.json
plugins/techwerker/.codex-plugin/plugin.json
plugins/techwerker/commands/
plugins/techwerker/skills/tech-week-concierge/
plugins/techwerker/scripts/techweek
scripts/check.sh
scripts/install-cli.sh
```

## Validate

```bash
./scripts/check.sh
```

## License

MIT
