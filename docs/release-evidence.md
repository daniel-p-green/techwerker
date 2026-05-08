# Techwerker Release Evidence

Use this as the compact reviewer proof packet for the public beta / open-source Codex workflow demo.

## Current Release Bar

- Deterministic gate: `techweek release-check --city all --json` returns zero failures.
- Repository gate: `./scripts/check.sh` and `git diff --check` pass.
- Confidence gate: `docs/strategy-confidence.md` names the known live-site, browser, auth, safety, demo, and overclaim loopholes, and ties each to a fix or explicit non-claim.
- City behavior: New York and Boston are treated as launched when parseable; San Francisco is first-class pending when its public calendar is unavailable.
- Browser path: Codex Desktop Browser Use is the proved primary live path for official Tech Week and Partiful pages.
- Optional Chrome path: when the Codex Chrome plugin is installed/enabled, Chrome can be used as a signed-in-browser path with the same selected-event authorization and safety stops.
- Platform path: live RSVP automation is Mac-first in the proved path today; Computer Use is only a macOS desktop fallback, while planning and local state remain general Codex plugin behavior.
- Fixture path: `fixtures/partiful-rsvp-fixture.html` covers duplicate Partiful CTAs, one active RSVP modal, safe visible prefill, a required unknown factual field, and scoped Continue behavior for repeatable Browser Use/Computer Use smoke tests.
- Variant fixture path: `fixtures/partiful-rsvp-variants.html` covers already-pending, waitlist, custom required, visible prefill, OTP, captcha, payment, and optional generic-answer cases.
- Fresh-user path: `scripts/fresh-user-acceptance.sh` proves install, empty local state, setup readiness, plain-English planning, RSVP context, and answer-field classification from a temporary home directory.
- Safety path: credentials, one-time codes, payment, captchas, unknown required factual fields, and ambiguous final confirmations stop the flow.

## Live Proof

On May 7, 2026, Codex used the official `Camp AI: Agents at Work` Partiful flow as the fresh reviewer demo target. The flow handled a multi-step host-question form, filled user-provided sample fields, used the user-provided 21+ answer, clicked the scoped authorized Continue path, reached visible Partiful `Pending`, and then removed the RSVP immediately after the proof with explicit user authorization. The public demo video now shows the full public proof arc: official New York Tech Week calendar, Camp AI selected, official Partiful page, host questions, scoped Continue, and visible `Pending`; the removal step is kept as release evidence rather than shareable footage.

Proof event:

- Event: `Camp AI: Agents at Work`
- Official Partiful URL: `https://partiful.com/e/Fp5STyPH0McEt0awlWFD`
- Official calendar source: `https://tech-week.com/calendar/nyc`
- Date/time: Wednesday, June 3, 2026, 5:30 PM-8:30 PM
- Location signal: Midtown / New York public Partiful page signal
- Final visible state: `Pending`
- Cleanup state: Partiful `Remove me` plus confirmation returned the page to `Get on the list`
- Local state transition: event marked `applied` only after visible pending confirmation, then `cancelled` after visible removal
- Form behavior proven: multi-step host questions; email, LinkedIn, company, role, 21+ attestation, and sponsor/demo preferences were filled from user-provided or event-specific answers. The flow did not require credentials, one-time codes, captcha, or payment.
- Re-run policy: do not repeat real RSVP submissions as routine tests; use fixture and non-mutating live checks unless the user explicitly approves a selected real event.

Earlier proof: on May 6, 2026, Codex also reached visible `Pending` on `Rebuild x Eleven Labs Hackathon - #NYTechWeek` at `https://partiful.com/e/5gz90KPGpE1XoK3GZtoW` after stopping for and receiving the user's required allergy answer. That remains historical evidence, but the launch demo should use the Camp AI recording because it shows the stronger multi-step Partiful path and immediate cleanup.

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
