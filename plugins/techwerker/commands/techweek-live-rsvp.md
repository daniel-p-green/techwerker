---
description: Build a narrow live RSVP queue and work one Partiful event with Computer Use first.
argument-hint: [city] [topics/time slots] [--allow-submit only if explicitly requested]
---

Work one live Tech Week RSVP target quickly and safely.

Default to assisted mode. Never submit, RSVP, join waitlist, or click a final confirmation button unless the user explicitly authorizes final submission for this run or this specific event.

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

Use Browser/Playwright only for the Tech Week calendar or simple static inspection. If Partiful becomes modal-heavy, authenticated, or visually ambiguous, stay with Computer Use instead of fighting DOM/accessibility refs.

Work one event at a time. Do not load or print the full portfolio queue during a live RSVP run.
