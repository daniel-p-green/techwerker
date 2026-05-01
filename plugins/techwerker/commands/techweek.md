---
description: Show Techwerker status, refresh events, build a portfolio, or make a day plan.
argument-hint: [city] [portfolio|day YYYY-MM-DD|interests]
---

Use this as the main Techwerker command after setup.

Ask for the city if it is missing, using the calendar labels: New York, Boston, or San Francisco (coming soon). Default to a quick status view unless the user asks for a portfolio, day plan, or preference update.

For status:

```bash
techweek cockpit --city <city>
```

If sync is stale or missing:

```bash
techweek sync --city <city>
techweek diff --city <city>
techweek cockpit --city <city>
```

For a broader event portfolio:

```bash
techweek sync --city <city>
techweek interests --city <city>
techweek portfolio --city <city>
techweek apply-queue --city <city>
```

For a practical day plan, require or infer a `YYYY-MM-DD` date:

```bash
techweek day-plan --city <city> <date>
```

For preference updates:

```bash
techweek interests --city <city>
techweek preferences --city <city> show
```

Summarize only the useful next action: profile gaps, interesting event clusters, pending RSVP queue, accepted/waitlisted state, or the next `/techweek-rsvp` target.
