---
description: Explain Techwerker, recommend Tech Week events, refresh status, or make a day plan.
argument-hint: [city] [portfolio|day YYYY-MM-DD|interests]
---

Use this as the main Techwerker command after setup. Techwerker takes the work out of Tech Week: the user gives profile and preference information once, then Codex uses the local state, Browser Use, and Computer Use to find events and handle repetitive RSVP forms.

If the user asks "what can you do?", "how does this work?", or similar, do not print commands. Explain:

- Techwerker syncs and parses dense Tech Week calendars.
- It remembers non-secret RSVP basics locally: name, email, phone, company, role, country, LinkedIn, and reusable answers.
- It recommends events based on topics, format, time, and geography.
- It builds a practical oversignup queue because many events are waitlisted or host-approved.
- When the user says "get on the list" or "sign me up", Codex opens the event, fills the Tech Week/Partiful forms with Browser Use and Computer Use, records unknown questions, and updates RSVP state.

Use this concise response shape:

> Techwerker takes the work out of Tech Week. You give me your basic RSVP details and event preferences once, then I can find good events, narrow them down, and work through the repetitive signup pages for you. I only stop for things I should not handle: login codes, payment details, or required questions I have not seen before.

Ask for the city if it is missing, using the calendar labels: New York, Boston, or San Francisco (coming soon). Default to a curated recommendation view unless the user explicitly asks for diagnostics/status, a day plan, or preference updates.

For recommendations, privately run the needed sync/status/portfolio commands, then show a short list of 3-6 options with:

- event name,
- date/time,
- neighborhood or location cluster,
- why it matches,
- RSVP/list status if known.

Do not show event ids, raw queue output, file paths, or command strings in the normal response. The user should be able to say "yes", "that one", "skip it", "show me more hackathons", or "get on the list" without touching ids.

For internal status, use:

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
