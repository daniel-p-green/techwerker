---
description: Build a narrow live RSVP queue and work one Partiful event safely.
argument-hint: [city] [topics/time slots] [--allow-submit only if explicitly requested]
---

Work one Tech Week RSVP target quickly and safely. This replaces the old separate live RSVP and planned queue commands.

Default to assisted mode. Never submit, RSVP, join waitlist, or click a final confirmation button unless the user explicitly authorizes final submission for this run or this specific event.

Default live-run filters are AI plus Noon and Evening, Partiful-only, limit 10. If the user gives different topics, time slots, or limit, use those.

Use this flow:

1. Determine city. If missing, ask for the calendar label: New York, Boston, or San Francisco (coming soon).
2. Build a narrow live queue from the official Tech Week calendar, not the cached portfolio:

```bash
techweek live-queue --city <city> --topics AI --time-slots noon,evening --limit 10
```

3. Pick the printed first target unless the user chooses a backup.
4. Generate the answer sheet:

```bash
techweek answers --city <city> <event-id> --write
```

5. Open the target:

```bash
techweek open --city <city> <event-id>
```

6. Use Computer Use first for the Partiful page. Treat Partiful as visual/modal-heavy by default.
7. Fill clear fields from `rsvp-profile.json`, `field_aliases`, `form-memory.json`, and the generated answer sheet.
8. If a required field is unknown, record it and move on:

```bash
techweek missing-fields --city <city> add <event-id> "Visible Partiful label"
techweek state --city <city> <event-id> needs-user-answer --note "missing required Partiful answer"
```

9. When all required fields are filled but not submitted, run:

```bash
techweek state --city <city> <event-id> needs-user-submit --note "filled assisted Partiful form; awaiting user submit"
```

Use the planned portfolio queue only when the user explicitly asks to work the saved queue:

```bash
techweek apply-queue --city <city> --limit 10
```

Useful memory commands:

```bash
techweek form-memory --city <city> lookup "Visible Partiful label" --event-id <event-id>
techweek form-memory --city <city> map "LinkedIn URL" linkedin
techweek form-memory --city <city> remember "What are you building?" "Reusable non-secret answer"
techweek form-memory --city <city> remember "Why do you want to attend?" "Event-specific answer" --event-id <event-id>
techweek missing-fields --city <city> show
techweek missing-fields --city <city> add <event-id> "What are you building?"
techweek missing-fields --city <city> resolve <event-id> "What are you building?" "Reusable non-secret answer" --reusable
```

Use Browser/Playwright only for the Tech Week calendar or simple static inspection. Do not keep fighting DOM/accessibility refs if the Partiful modal is visual-only, authenticated, slow, or modal-heavy. Switch to Computer Use and keep moving.

Work one event at a time. Do not load or print the full portfolio queue during a live RSVP run.
