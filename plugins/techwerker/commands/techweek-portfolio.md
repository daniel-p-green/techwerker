---
description: Sync calendars and build an oversignup event portfolio.
argument-hint: [city|live|all] [optional portfolio notes]
---

Build a Tech Week event portfolio.

If no city is specified, use `live` to refresh NYC and Boston. If the user names SF, run it and report pending/404 cleanly if the calendar has not launched.

Run:

```bash
techweek sync --city <city-or-live>
techweek diff --city <city>
techweek interests --city <city>
techweek portfolio --city <city>
techweek apply-queue --city <city>
```

Use the default oversignup model: roughly three plausible applications per intended day/time slot. Favor high-signal events, open signup links, preferred topics/hosts, and location clusters that make real movement possible.

After generation, summarize:

- event count and sync status
- new/changed/removed highlights from diff
- portfolio path
- pending apply queue count
- top targets by day/time slot

Do not open Partiful pages unless the user asks to start RSVP work.

