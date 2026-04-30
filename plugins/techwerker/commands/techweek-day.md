---
description: Build a practical Tech Week day plan from accepted, waitlisted, and backup events.
argument-hint: [city] [YYYY-MM-DD]
---

Build an on-the-fly Tech Week day plan.

Require or infer a date in `YYYY-MM-DD` format. Default city is `nyc`.

Run:

```bash
techweek day-plan --city <city> <date>
```

Prioritize actual state over theoretical score:

1. accepted
2. applied or waitlisted events that are likely backups
3. backup
4. target
5. opened or filled events awaiting user submit

Prefer high-signal accepted events and nearby backups over distant top-ranked events. Group by time slot and location cluster. Call out route risks when two appealing events are too far apart or overlap.

If the portfolio is missing, run `techweek portfolio --city <city>` first. If RSVP states are stale, ask the user for current accepted/waitlisted/rejected outcomes and update them with `techweek state`.

