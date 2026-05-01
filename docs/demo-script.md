# Techwerker Demo Script

Use this for a live Codex or screen-recorded demo. Keep all profile values sanitized.

Recommended recording setup:

- Use Spark if available for the live RSVP run; the work is command orchestration plus visual form interaction, so speed matters more than deep code reasoning.
- Keep Computer Use available and logged into the browser session you expect to use for Partiful.
- Use Browser/direct parsing for the Tech Week calendar, not visual scrolling.

Opening frame:

> Techwerker turns Tech Week chaos into a fill-once workflow: find the events worth your time, build a smart RSVP queue, and let Codex remove the repetitive signup drag.

## Setup

Use a clean or disposable profile state when recording:

```bash
techweek setup --city nyc --no-interactive
```

Narration:

> The repeated work is identity entry and preference recall, so Techwerker starts by keeping local, non-secret profile and form memory outside the repo.

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

> This is the command center. It turns a noisy event universe into a short operational view: what changed, what is ready, and what still needs attention.

## Portfolio

```bash
techweek portfolio --city nyc --limit 5
```

Show:

- ranked events by time slot,
- location clusters,
- oversignup strategy.

Narration:

> The wedge is filtering. Tech Week is waitlist-heavy, so the goal is not one perfect calendar. The goal is a good options portfolio of events worth trying for.

## Apply Queue

```bash
techweek apply-queue --city nyc --limit 3
```

Show:

- next events to work through,
- Partiful links,
- clear queue count.

Narration:

> Instead of manually remembering every open signup, I work from a queue with state.

## Live RSVP Handoff

For the live RSVP demo, use the narrow queue instead of the full portfolio queue:

```bash
techweek live-queue --city "New York" --topics AI --time-slots noon,evening --limit 3
techweek answers --city nyc <event-id> --write
techweek open --city nyc <event-id> --no-browser
```

Then use Computer Use for the Partiful page:

1. open the Partiful URL,
2. inspect visible fields,
3. fill only known non-secret fields from local profile/form memory,
4. stop before final submission.

Narration:

> This is the Codex proof point: direct calendar parsing, local state, Computer Use, and human approval working together on messy real-world knowledge work. Codex can fill the repetitive parts, and Techwerker pauses before the irreversible RSVP action.

## Recording Rules

- Do not show real email, phone, LinkedIn, or private profile values.
- Do not submit an RSVP in the demo.
- Do not show private accepted-event locations.
- If a form asks for a custom answer, use placeholder text or skip it.
