---
description: Show the current Tech Week command center.
argument-hint: [city] [--date YYYY-MM-DD]
---

Use the Tech Week cockpit as the default starting point.

Default city is `nyc` unless the user names another city. Run:

```bash
techweek cockpit --city <city>
```

If the user gives a date, run:

```bash
techweek cockpit --city <city> --date <YYYY-MM-DD>
```

Use the output to decide the next action:

- If sync is stale or missing, run `techweek sync --city <city>`.
- If portfolio targets are missing, run `techweek portfolio --city <city>`.
- If profile fields are missing and the user wants RSVP help, run `/techweek-profile`.
- If the user wants fast live RSVP action, run `/techweek-live-rsvp`.
- If apply queue is non-empty and the user wants to work a planned portfolio queue, run `/techweek-rsvp`.
- If the user is choosing where to go today, run `/techweek-day`.

Keep this as the lightweight command center. Do not require Gmail, Calendar, route estimation, sub-agents, or final-submit automation unless the user explicitly asks for those optional integrations.
