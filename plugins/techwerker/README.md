# Techwerker

**Tech Week without the Werk.**

Unofficial local Codex helper for managing dense Tech Week calendars, signup queues, repeated RSVP form fields, and RSVP state.

Techwerker turns Tech Week chaos into a fill-once workflow: find higher-signal events, build a smart RSVP queue, reuse non-secret attendee details locally, and hand repetitive browser work to Codex while keeping final submission under user control.

Techwerker is a utility for attendees. It is not affiliated with, endorsed by, or sponsored by Tech Week, a16z, Partiful, or any event host.

The deterministic state engine is `scripts/techweek`. Persistent state lives in:

```text
~/.codex/data/tech-week/<city>-<year>/
```

First-time signup flow:

1. Choose the calendar city label: New York, Boston, or San Francisco (coming soon).
2. Save reusable non-secret RSVP basics: name, email, phone number, company, role/title, country, and LinkedIn profile.
3. Optionally save a default goal-of-attending answer.
4. Rank city-specific filters: topics, neighborhoods, event types to prioritize or avoid, and preferred start times.
5. Use the portfolio and RSVP queue from that saved profile.

Core commands:

- `/techweek-first-use`
- `/techweek-setup`
- `/techweek-cockpit`
- `/techweek-profile`
- `/techweek-interests`
- `/techweek-portfolio`
- `/techweek-rsvp`
- `/techweek-live-rsvp`
- `/techweek-day`

Default RSVP mode is assisted: build a narrow live queue when speed matters, fill known fields with Computer Use first on Partiful, then pause before final submission.

The public surface is intentionally practical: first-time signup setup, calendar triage, oversignup portfolio management, repeated identity-entry relief, and safer Partiful handoff. It does not store credentials or submit RSVPs unless explicitly authorized for a run.

See the root README for install instructions, demo script, safety notes, and launch copy.
