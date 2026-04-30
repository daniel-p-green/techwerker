---
description: Work through Tech Week Partiful RSVP queue in assisted mode.
argument-hint: [city] [event-id|next] [--allow-submit only if explicitly requested]
---

Work the Tech Week RSVP queue safely.

Default to assisted mode. Never submit, RSVP, join waitlist, or click a final confirmation button unless the user explicitly authorizes final submission for this run or this specific event.

Use this flow:

1. Determine city, defaulting to `nyc`.
2. If no event id is provided, run `techweek apply-queue --city <city> --limit 10` and pick the next unresolved event.
3. Run `techweek answers --city <city> <event-id> --write`.
4. Open the event URL with `techweek open --city <city> <event-id>` or navigate the in-app browser to the printed Partiful URL.
5. Use Browser/Playwright first to inspect visible labels and inputs.
6. Fill clear fields from `rsvp-profile.json`, `field_aliases`, `form-memory.json`, and the generated answer sheet.
7. If a required field is unknown, pause and ask the user once. Offer to save reusable values to the profile, reusable custom answers to `techweek form-memory remember`, and event-only values with `--event-id`.
8. When the page is filled but not submitted, run `techweek state --city <city> <event-id> needs-user-submit --note "filled assisted form; awaiting user submit"` or `filled` if the user still needs to review.

Useful form-memory commands:

```bash
techweek form-memory --city <city> lookup "Visible Partiful label" --event-id <event-id>
techweek form-memory --city <city> map "LinkedIn URL" linkedin
techweek form-memory --city <city> remember "What are you building?" "Reusable non-secret answer"
techweek form-memory --city <city> remember "Why do you want to attend?" "Event-specific answer" --event-id <event-id>
```

Use Computer Use only if the browser DOM is not enough because the authenticated Partiful UI is visual-only or modal-heavy.

If the event has no external link, mark it `needs-review` and move to the next queue item.
