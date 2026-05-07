# Techwerker Reviewer Walkthrough

Use this for a live Codex walkthrough or screen recording. Keep all profile values sanitized and keep the story conversational. The shareable social cut is square, silent-first, live-first, and minimal-text; let the official Partiful page, multi-step form handling, and Pending proof carry the story. Keep cleanup in release evidence instead of the public cut.

Recommended recording setup:

- Use Codex Desktop on Mac with Browser Use in the in-app browser for the proved recording path.
- Optional alternate take: if the Codex Chrome plugin is installed/enabled, record the same flow in Chrome to show Codex using existing signed-in browser state. Do not redo the current shareable cut just to add this.
- Use Browser Use or the explicitly selected Chrome plugin path for the visible official Tech Week/Partiful work. Use Recordly or CleanShot X only for the screen capture layer; keep the final social cut square, silent-first, and readable without zooming.
- Use direct calendar parsing for Tech Week, not visual scrolling.
- Keep Computer Use available for desktop capture controls and only as an explicit macOS external-browser fallback.

Opening frame:

Start on the actual browser proof. Avoid logo tiles, fake product cards, and static screenshot montages. Keep the unofficial/not-affiliated disclaimer in the final card or a small corner label.

## Setup

Use a clean or disposable profile state when recording:

```text
/techweek-setup
```

Private prep command for this recording:

```bash
techweek demo-reset --city nyc --keep-state
```

Sample visible profile:

- Name: Justin Buildman
- Email: justin@demo.example
- Phone: 123-456-7981
- Company: Buildman Labs
- Title: Founder
- LinkedIn: linkedin.com/in/justin-buildman

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
/techweek Find me a cool AI event on Wednesday evening near Midtown.
```

Show:

- natural-language parsing,
- official Tech Week calendar source,
- neighborhood cluster fit,
- the selected `Camp AI: Agents at Work` recommendation.

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

Then let Codex work the official Partiful page in the selected browser surface:

1. confirm the selected event,
2. open `https://partiful.com/e/Fp5STyPH0McEt0awlWFD`,
3. inspect visible fields,
4. fill known, saved, or visibly prefilled non-sensitive fields,
5. ask for any unknown required factual answer,
6. if Partiful opens another host-question step after Continue, classify and fill those fields before clicking again,
7. click scoped RSVP/list/Continue controls if the selected event is authorized,
8. stop for credentials, one-time codes, payment, captchas, ambiguous final confirmation, site errors, or repeated no-progress click states.

Narration:

> This is the Codex proof point: direct calendar parsing, local state, browser control, and event-specific authorization working together on messy real-world knowledge work. Codex can remove the repetitive parts while still stopping for the things it should not guess or bypass.

Reviewer target:

- Event: `Camp AI: Agents at Work`
- Official Partiful URL: `https://partiful.com/e/Fp5STyPH0McEt0awlWFD`
- Expected demo ending after approved run: visible Partiful `Pending`, with local state marked `applied` only after confirmation.
- Cleanup after proof: click the visible `Pending` state, remove the RSVP only with explicit user authorization, confirm removal, and mark local state `cancelled`.

For a no-blur public recording, fill the sample profile values above and stop before transmitting them to a real event unless the user explicitly approves that exact final RSVP/list action during the recording.

## Recording Rules

- Do not show real email, phone, LinkedIn, or private profile values.
- Use the Justin Buildman sample profile for public recording if contact fields need to be visible.
- Do not submit a real RSVP unless the user explicitly approves that exact event during the walkthrough.
- Do not show private accepted-event locations.
- If a form asks for a custom factual answer, ask once and save it only with the user's chosen scope.
- Legal or factual attestations, such as a 21+ question, require a user answer before reuse.
