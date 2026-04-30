# Techwerker

**Tech Week without the Werk.**

Techwerker is an unofficial local Codex helper for managing dense Tech Week calendars, RSVP queues, repeated Partiful fields, and RSVP state.

It is built for attendees who want a better workflow than manually scanning hundreds of events, opening the same signup forms, and remembering which waitlists they already joined.

Techwerker is also a public demo of Codex as a practical workflow assistant: it filters a noisy event universe, remembers non-secret attendee details locally, works through RSVP queues, and hands repetitive browser tasks to Codex while keeping final submission under user control.

> Techwerker is not affiliated with, endorsed by, or sponsored by Tech Week, a16z, Partiful, or any event host.

## Why This Exists

Tech Week calendars are high-volume, fast-changing, and waitlist-heavy. The real workflow drag is not any single form. It is repeatedly deciding what is worth attending, entering the same identity details, tracking waitlists, and remembering which signup pages still need action.

Techwerker does not pretend to perfectly plan your whole week upfront. It helps you:

- find higher-signal events faster,
- build an oversignup portfolio,
- keep RSVP state straight,
- reuse non-secret form answers,
- hand off Partiful pages to Codex browser tools,
- stop before final submit unless you explicitly allow it.

## See It Work

![Techwerker demo](assets/techwerker-demo.gif)

App-style demo flow:

```bash
techweek setup --city nyc --no-interactive
techweek cockpit --city nyc
techweek portfolio --city nyc --limit 5
techweek apply-queue --city nyc --limit 3
```

Example cockpit output:

```text
# Tech Week Cockpit: nyc-2026
synced=2026-04-30T20:56:18+00:00 events=1221 open_links=1054 needs_review=167
portfolio_targets=83 apply_queue_pending=83
profile=missing display_name, email, company, title, linkedin
form_memory=22 mappings, 0 reusable answers, 0 event answers
```

For the RSVP handoff, Codex opens the next Partiful page, fills known fields from local profile/form memory, asks once for unknown required fields, and pauses before final submission. The point is not that event forms are hard. The point is that obvious workflow drag accumulates fast in the wild, and Codex can remove it when code, browser tools, local state, and human approval work together.

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

```bash
techweek setup --city nyc
techweek cockpit --city nyc
techweek portfolio --city nyc
techweek apply-queue --city nyc
```

Inside Codex, the same workflow is available through `/techweek-setup`, `/techweek-cockpit`, `/techweek-portfolio`, and `/techweek-rsvp`.

For first-time profile and preference entry:

```bash
techweek setup --city nyc --interactive
```

Persistent local state lives outside the repo:

```text
~/.codex/data/tech-week/<city>-<year>/
```

## Plugin Commands

- `/techweek-setup`
- `/techweek-cockpit`
- `/techweek-profile`
- `/techweek-interests`
- `/techweek-portfolio`
- `/techweek-rsvp`
- `/techweek-day`

## Safety

Techwerker stores local helper state only. It does not store Partiful credentials, passwords, one-time codes, or payment details.

Default RSVP behavior is assisted mode: fill known fields, then pause before final submission.

Full auto-submit should only be used with explicit per-run authorization.

See [SECURITY.md](SECURITY.md) for details.

## Limitations

- Locations may be hidden by Partiful until acceptance.
- RSVP acceptance and waitlist status still need to be tracked manually unless you update state yourself.
- Browser/Computer Use handoff depends on your logged-in browser session and visible page state.
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
