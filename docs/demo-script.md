# Techwerker Demo Script

Use this for a live Codex or screen-recorded demo. Keep all profile values sanitized.

## Setup

Use a clean or disposable profile state when recording:

```bash
techweek setup --city nyc --no-interactive
```

Narration:

> Techwerker keeps local state outside the repo and starts by setting up preferences, profile fields, and form memory.

## Cockpit

```bash
techweek cockpit --city nyc
```

Show:

- total event count,
- open links vs. needs review,
- missing profile fields,
- apply queue count,
- recent calendar changes.

Narration:

> This is the command center. It tells me what changed, what is ready, and what still needs attention.

## Portfolio

```bash
techweek portfolio --city nyc --limit 5
```

Show:

- ranked events by time slot,
- location clusters,
- oversignup strategy.

Narration:

> Tech Week is waitlist-heavy, so the goal is not one perfect calendar. The goal is a good options portfolio.

## Apply Queue

```bash
techweek apply-queue --city nyc --limit 3
```

Show:

- next events to work through,
- Partiful links,
- clear queue count.

Narration:

> Instead of remembering what I opened or applied to, I work from a queue.

## Browser / Computer Use Handoff

Pick one event from the queue:

```bash
techweek answers --city nyc <event-id> --write
techweek open --city nyc <event-id> --no-browser
```

Then use Codex browser tools or Computer Use to:

1. open the Partiful URL,
2. inspect visible fields,
3. fill only known non-secret fields from local profile/form memory,
4. stop before final submission.

Narration:

> Codex can fill the repetitive parts, but Techwerker pauses before the irreversible RSVP action.

## Recording Rules

- Do not show real email, phone, LinkedIn, or private profile values.
- Do not submit an RSVP in the demo.
- Do not show private accepted-event locations.
- If a form asks for a custom answer, use placeholder text or skip it.
