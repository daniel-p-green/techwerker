# Techwerker

Unofficial local Codex helper for managing dense Tech Week calendars, signup queues, repeated RSVP form fields, and RSVP state.

Techwerker is a utility for attendees. It is not affiliated with, endorsed by, or sponsored by Tech Week, a16z, Partiful, or any event host.

The deterministic state engine is `scripts/techweek`. Persistent state lives in:

```text
~/.codex/data/tech-week/<city>-<year>/
```

Core commands:

- `/techweek-setup`
- `/techweek-cockpit`
- `/techweek-profile`
- `/techweek-interests`
- `/techweek-portfolio`
- `/techweek-rsvp`
- `/techweek-day`

Default RSVP mode is assisted: fill known fields, then pause before final submission.

The public surface is intentionally practical: calendar triage, oversignup portfolio management, and safer Partiful handoff. It does not store credentials or submit RSVPs unless explicitly authorized for a run.
