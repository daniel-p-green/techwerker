---
description: Use Techwerker to get on the list for one Tech Week event.
argument-hint: [city] [topics/time slots] [--allow-submit only if explicitly requested]
---

Work one Tech Week RSVP target quickly and safely. Techwerker takes the work out of Tech Week: the user should not have to copy links, provide event ids, run commands, or fill repetitive fields.

Default to assisted mode. Never submit, RSVP, join waitlist, or click a final confirmation button unless the user explicitly authorizes final submission for this run or this specific event. Phrases like "get on the list", "sign me up", "join this one", or "yes, do it" for a selected event count as authorization to complete that RSVP/list action unless credentials, one-time codes, payment, captcha, unknown required fields, Partiful site errors/no-progress states, or ambiguous final confirmation block the flow.

Live RSVP automation is Mac-first today. Browser Use `iab` is the primary official Partiful path; Computer Use is only a macOS desktop fallback for explicit external-browser debugging.

Default live-run filters are AI plus Noon and Evening, Partiful-only, limit 10. If the user gives different topics, time slots, or limit, use those.

Use this flow:

1. Determine city. If missing, ask for the calendar label: New York, Boston, or San Francisco. If San Francisco is pending because `https://tech-week.com/calendar/san-francisco` returns 404, say that and do not fabricate an RSVP target.
2. Build a narrow live queue from the official Tech Week calendar, not the cached portfolio. Do this privately:

```bash
techweek live-queue --city <city> --topics AI --time-slots noon,evening --limit 10
```

3. Pick the best target matching the user's natural-language request. Do not ask the user for an event id.
4. Generate the answer sheet privately:

```bash
techweek answers --city <city> <event-id> --write
```

5. Generate the RSVP context packet privately:

```bash
techweek rsvp-context --city <city> <event-id> --json
```

6. If `profile.ready` is false, collect the missing non-secret RSVP basics in chat before opening the form. Use visible browser/account values only as suggestions, and ask before saving or using them.
7. Navigate Browser Use with the in-app `iab` backend to `eventUrl` from the context packet. Use Browser Use for inspection, visible-state checks, in-app browser filling, tab management, and scoped click-through.
8. Mirror the useful part of a manual workflow: open several candidate Partiful event pages in Browser Use tabs for inspection if helpful, but keep only one active RSVP modal. Use plain event URLs for staging tabs, add `?rsvp=true` or open the modal only for the selected active event, and confirm the active tab URL/title matches the selected event before filling or clicking.
9. Treat Partiful as visual/modal-heavy by default. Stay in Browser Use `iab`; use Computer Use only as an explicit macOS external-desktop fallback when debugging that path.
10. If Browser Use sees repeated controls such as multiple "Get on the list" buttons, do not use a naive global locator. Scope to the visible card/modal or switch to a visual Browser Use action.
11. For every visible field label, classify it privately. If Partiful already filled a non-sensitive value from account details or previous responses, include that visible value so Codex can use it without making the user retype it:

```bash
techweek answer-field --city <city> <event-id> "Visible Partiful label" --json
techweek answer-field --city <city> <event-id> "Visible Partiful label" --visible-value "<visible value>" --visible-source previous-response --json
```

12. Fill `fill_from_profile` and `fill_saved_answer` values directly. Leave/use `use_visible_value` fields for the current RSVP and ask before saving them as reusable memory. For `draft_generic_answer`, generate a concise event-specific answer from the returned context; ask before using it unless the generated answer class is already approved. For `ask_user`, ask the user only for that answer:

```bash
techweek missing-fields --city <city> add <event-id> "Visible Partiful label"
techweek state --city <city> <event-id> needs-user-answer --note "missing required Partiful answer"
```

13. Save user-approved custom answers with `missing-fields resolve` or `form-memory remember`. Use event-only by default; use reusable only when the user says the answer should apply across events. Use `form-memory approve-generated motivation` only when the user approves future generated answers for that class.
14. When all required fields are filled, use the context packet's `rsvpActionPolicy`. If the user authorized this selected event, do not stop at a filled form. Click the next unique or scoped Partiful action such as "Get on the list", "RSVP", "Join waitlist", "Continue", "Submit", or "Going" only when it clearly belongs to the selected event.
15. Re-inspect the visible page after every click. If a new host-question step appears after Continue, classify every new field before clicking again. Legal/factual attestations such as 21+ questions require user-provided or saved answers.
16. Stop if Partiful shows `Something went wrong`, a network/backend error, or the same CTA repeats without visible progress.
17. Continue the RSVP/list flow until Partiful visibly confirms applied/on-list/waitlist status or a stop condition appears.
18. Record state before switching away from the active event tab.
19. Mark final state privately from the visible result:

```bash
techweek state --city <city> <event-id> applied --note "visible Partiful confirmation"
techweek state --city <city> <event-id> waitlisted --note "visible Partiful waitlist/list confirmation"
techweek state --city <city> <event-id> cancelled --note "visible Partiful removal after explicit user authorization"
```

Use `needs-user-submit` only when the form is filled but the user has not authorized the RSVP/list action for this selected event.

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
techweek form-memory --city <city> approve-generated motivation
techweek missing-fields --city <city> show
techweek missing-fields --city <city> add <event-id> "What are you building?"
techweek missing-fields --city <city> resolve <event-id> "What are you building?" "Reusable non-secret answer" --reusable
```

Use Browser Use for the official Tech Week calendar, direct Partiful event-page navigation, controlled candidate tabs, visible-state inspection, in-app browser filling, and scoped click-through. Do not keep fighting brittle refs if the Partiful modal is visual-only, authenticated, slow, duplicate-button-heavy, or modal-heavy; switch to Browser Use visual actions first. Use Computer Use only as an explicit macOS external-desktop fallback.

Work one active RSVP modal at a time, even if multiple candidate event tabs are open. Do not load or print the full portfolio queue during a live RSVP run. Do not expose internal ids in the user-facing answer unless diagnosing a failure.

Stop and ask the user only for:

- credentials or one-time codes,
- payment details,
- captchas,
- an unknown required custom answer,
- Partiful site errors or repeated no-progress click states,
- a final confirmation that does not clearly belong to the selected event or absent authorization for the RSVP/list action.
