# Techwerker

Unofficial local Codex helper for managing dense Tech Week calendars, signup queues, repeated RSVP form fields, and RSVP state.

Techwerker is a utility for attendees. It is not affiliated with, endorsed by, or sponsored by Tech Week, a16z, Partiful, or any event host.

## What It Does

- Syncs launched Tech Week city calendars.
- Detects new, changed, and removed events.
- Extracts topics, hosts, locations, clusters, and time slots.
- Builds an oversignup portfolio because many events use waitlists.
- Maintains lightweight RSVP state.
- Stores reusable non-secret RSVP profile fields.
- Stores repeated form-label mappings and custom answer memory.
- Opens Partiful links and supports assisted form filling through Codex browser tools.
- Pauses before final RSVP submission unless explicitly authorized for a run.

## Install

From Codex:

```bash
codex plugin marketplace add daniel-p-green/techwerker
```

Then enable the `Techwerker` plugin in Codex if it is not enabled automatically.

## Quick Start

For terminal use from a clone, install the CLI shim:

```bash
./scripts/install-cli.sh
```

```bash
techweek setup --city nyc
techweek cockpit --city nyc
techweek portfolio --city nyc
techweek apply-queue --city nyc
```

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

## Supported Calendars

Current aliases:

- `nyc`
- `boston`
- `sf` / `san-francisco`
- `live` for currently launched calendars
- `all` for known cities, including pending calendars

San Francisco may report pending until that calendar launches.

## Safety

Techwerker does not store Partiful credentials, passwords, one-time codes, or payment details.

Default RSVP behavior is assisted mode: fill known fields, then pause before final submission.

Full auto-submit should only be used with explicit per-run authorization.

## Repo Layout

```text
.agents/plugins/marketplace.json
plugins/techwerker/.codex-plugin/plugin.json
plugins/techwerker/commands/
plugins/techwerker/skills/tech-week-concierge/
plugins/techwerker/scripts/techweek
```

## License

MIT
