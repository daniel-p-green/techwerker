# Techwerker Release Evidence

Use this as the compact reviewer proof packet for the public beta / open-source Codex workflow demo.

## Current Release Bar

- Deterministic gate: `techweek release-check --city all --json` returns zero failures.
- Repository gate: `./scripts/check.sh` and `git diff --check` pass.
- City behavior: New York and Boston are treated as launched when parseable; San Francisco is first-class pending when its public calendar is unavailable.
- Browser path: Codex Desktop Browser Use is the primary live path for official Tech Week and Partiful pages.
- Platform path: live RSVP automation is Mac-first today; Computer Use is only a macOS desktop fallback, while planning and local state remain general Codex plugin behavior.
- Fixture path: `fixtures/partiful-rsvp-fixture.html` covers duplicate Partiful CTAs, one active RSVP modal, safe visible prefill, a required unknown factual field, and scoped Continue behavior for repeatable Browser Use/Computer Use smoke tests.
- Variant fixture path: `fixtures/partiful-rsvp-variants.html` covers already-pending, waitlist, custom required, visible prefill, OTP, captcha, payment, and optional generic-answer cases.
- Fresh-user path: `scripts/fresh-user-acceptance.sh` proves install, empty local state, setup readiness, plain-English planning, RSVP context, and answer-field classification from a temporary home directory.
- Safety path: credentials, one-time codes, payment, captchas, unknown required factual fields, and ambiguous final confirmations stop the flow.

## Live Proof

On May 6, 2026, Codex started from the official New York calendar at `https://tech-week.com/calendar/nyc`, selected the ElevenLabs demo target, opened its official Partiful RSVP flow, filled known profile fields, stopped for a required factual allergy answer, continued only after the user supplied it, clicked the authorized scoped Continue path, and reached a visible Partiful `Pending` state.

Proof event:

- Event: `Rebuild x Eleven Labs Hackathon - #NYTechWeek`
- Official Partiful URL: `https://partiful.com/e/5gz90KPGpE1XoK3GZtoW`
- Official calendar source: `https://tech-week.com/calendar/nyc`
- Date/time: Saturday, June 6, 2026, 9:00 AM-9:00 PM
- Location signal: Chinatown / SoHo-LES cluster
- Final visible state: `Pending`
- Local state transition: event marked `applied` only after visible pending confirmation
- Form behavior proven: email, LinkedIn, company, and role were filled from user-provided profile data; the required allergy field stopped until the user supplied the answer.
- Re-run policy: do not repeat real RSVP submissions as routine tests; use fixture and non-mutating live checks unless the user explicitly approves a selected real event.

## Reviewer Walkthrough

The public walkthrough should show:

1. Ask `What can you do?`
2. Ask `Get started.`
3. Choose New York or Boston.
4. Save non-secret RSVP basics once.
5. Ask for AI/noon/evening recommendations.
6. Show overlap-aware, waitlist-aware, location-aware recommendations.
7. Say `yes, get me on the list` for one selected event.
8. Show Codex navigating the official Partiful page, filling known fields, stopping for unknowns, or reaching a visible applied/waitlisted/pending state.

## Non-Claims

Techwerker does not guarantee acceptance, bypass host rules, solve captchas, handle payment, store credentials, or invent factual personal data. It helps Codex plan and work the RSVP queue safely with less rote user effort.
