# Techwerker

**Tech Week without the Werk.**

Unofficial local Codex helper for managing dense Tech Week calendars, signup queues, repeated RSVP form fields, and RSVP state.

Techwerker turns Tech Week chaos into a fill-once workflow: find higher-signal events, build a smart RSVP queue, reuse non-secret attendee details locally, and hand repetitive browser work to Codex while keeping final submission under user control.

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

The public surface is intentionally practical: calendar triage, oversignup portfolio management, repeated identity-entry relief, and safer Partiful handoff. It does not store credentials or submit RSVPs unless explicitly authorized for a run.

See the root README for install instructions, demo script, safety notes, and launch copy.
