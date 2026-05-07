---
description: Explain Techwerker, recommend Tech Week events, refresh status, or make a day plan.
argument-hint: [city] [portfolio|day YYYY-MM-DD|interests]
---

Use this as the main Techwerker command after setup. Techwerker takes the work out of Tech Week: the user gives profile and preference information once, then Codex uses the local state and in-app Browser Use to find events and handle repetitive RSVP forms.

Keep the platform promise clear when relevant: planning and local state work as normal Codex plugin behavior, while live RSVP automation is Mac-first today because Computer Use fallback is macOS-only.

If the user asks "what can you do?", "how does this work?", or similar, do not print commands. Explain:

- Techwerker syncs and parses dense Tech Week calendars.
- It remembers non-secret RSVP basics locally: name, email, phone, company, role, country, LinkedIn, and reusable answers.
- It recommends events based on topics, format, time, geography, and commute realism.
- It builds a practical overlap-aware oversignup queue because many events are waitlisted or host-approved.
- It treats saved time windows as hard filters unless the user asks to see outside-window options.
- It works under-covered date/time slots first, then collapses accepted options into a realistic neighborhood-aware day plan.
- When the user says "get on the list", "sign me up", or "click RSVP", Codex prepares the RSVP context, classifies visible form labels, uses saved and visible prefilled values, drafts safe generic answers when approved, clicks scoped RSVP/list controls for the selected event, records unknown questions, and updates RSVP state.

Use this concise response shape:

> Techwerker takes the work out of Tech Week. You give me your basic RSVP details and event preferences once, then I can review the calendar, find good events, build enough backup options for waitlists, avoid ridiculous cross-town hops, and work through the repetitive signup pages for you. Once you pick an event, I can click the RSVP/list flow for that event and only stop for things I should not handle: login codes, payment details, captchas, or required questions I cannot answer from saved or visible form values.

Ask for the city if it is missing, using the calendar labels: New York, Boston, or San Francisco. Default to a curated recommendation view unless the user explicitly asks for diagnostics/status, a day plan, or preference updates. If San Francisco is still 404 at `https://tech-week.com/calendar/san-francisco`, treat it as pending rather than empty or broken.

For plain-English event requests such as "find me a cool AI event on Tuesday afternoon near Williamsburg" or "near SoHo", privately run:

```bash
techweek ask --city <city> "<request>" --json
```

Use the parsed date, time slot, topic, location anchor, nearby clusters, and commute metadata to recommend events in normal language. Treat neighborhoods as geography, not just keywords: Williamsburg should prefer Brooklyn first and nearby Brooklyn/Queens options second; SoHo should prefer SoHo/LES first and nearby Downtown Manhattan options second.

For recommendations, privately run the needed sync/status/portfolio commands, then show a short list of 3-6 options with:

- event name,
- date/time,
- neighborhood or location cluster,
- why it matches,
- whether it helps cover an under-covered time slot or creates a commute tradeoff,
- RSVP/list status if known.

Do not show event ids, raw queue output, file paths, or command strings in the normal response. The user should be able to say "yes", "that one", "skip it", "show me more hackathons", or "get on the list" without touching ids.

For internal status, use:

```bash
techweek onboarding-context --city <city> --json
techweek city-status --city all
techweek release-check --city all
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

For actual RSVP work, use `/techweek-rsvp` behavior: build a narrow live queue, write the answer sheet, run `techweek rsvp-context --json`, classify visible fields with `techweek answer-field --json`, pass `--visible-value` for non-sensitive Partiful prefilled values, navigate the official Partiful page with Browser Use `iab`, fill modal-heavy Partiful pages in the in-app browser, draft safe generic answers only under the answer strategy, click scoped RSVP/list/Continue controls after event-specific authorization, and stop for credentials, one-time codes, payment, captchas, unknown required fields, or a final confirmation that does not clearly belong to the selected event.
