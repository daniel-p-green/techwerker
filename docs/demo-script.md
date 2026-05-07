# Techwerker Reviewer Walkthrough

Use this for a live Codex walkthrough or screen recording. Keep all profile values sanitized and keep the story conversational. The shareable social cut is square, silent-first, and minimal-text; let the official calendar, Partiful page, form handling, and Pending proof carry the story.

Recommended recording setup:

- Use Codex Desktop on Mac with Browser Use in the in-app browser.
- Use direct calendar parsing for Tech Week, not visual scrolling.
- Keep Computer Use available only as an explicit macOS external-browser fallback.

Opening frame:

> Techwerker turns Tech Week chaos into a fill-once workflow: find the events worth your time, build a smart RSVP queue, and let Codex remove the repetitive signup drag.

## Setup

Use a clean or disposable profile state when recording:

```text
/techweek-setup
```

Narration:

> The repeated work is identity entry and preference recall, so Techwerker starts by keeping local, non-secret profile and form memory outside the repo.

## Cockpit

```text
/techweek New York
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

```text
/techweek Find me an ElevenLabs AI hackathon on Saturday morning near SoHo.
```

Show:

- natural-language parsing,
- official Tech Week calendar source,
- neighborhood cluster fit,
- the selected `Rebuild x Eleven Labs Hackathon` recommendation.

Narration:

> The wedge is not only filtering. Codex turns a normal sentence into date, time, topic, and neighborhood constraints, then picks a concrete official event.

## Apply Queue

```text
/techweek New York RSVP queue
```

Show:

- next events to work through,
- Partiful links,
- clear queue count.

Narration:

> Instead of manually remembering every open signup, I work from a queue with state.

## Live RSVP Handoff

For the live RSVP demo, use the narrow queue instead of the full portfolio queue:

```text
/techweek-rsvp New York
```

Then let Codex work the official Partiful page in the in-app browser:

1. confirm the selected event,
2. open `https://partiful.com/e/5gz90KPGpE1XoK3GZtoW`,
3. inspect visible fields,
4. fill known, saved, or visibly prefilled non-sensitive fields,
5. ask for any unknown required factual answer,
6. click scoped RSVP/list/Continue controls if the selected event is authorized,
7. stop for credentials, one-time codes, payment, captchas, or ambiguous final confirmation.

Narration:

> This is the Codex proof point: direct calendar parsing, local state, Browser Use, and event-specific authorization working together on messy real-world knowledge work. Codex can remove the repetitive parts while still stopping for the things it should not guess or bypass.

Reviewer target:

- Event: `Rebuild x Eleven Labs Hackathon - #NYTechWeek`
- Official Partiful URL: `https://partiful.com/e/5gz90KPGpE1XoK3GZtoW`
- Expected demo ending after approved run: visible Partiful `Pending`, with local state marked `applied` only after confirmation.

## Recording Rules

- Do not show real email, phone, LinkedIn, or private profile values.
- Do not submit a real RSVP unless the user explicitly approves that exact event during the walkthrough.
- Do not show private accepted-event locations.
- If a form asks for a custom factual answer, ask once and save it only with the user's chosen scope.
