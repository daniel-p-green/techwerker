# Strategy Confidence

This document is the release confidence boundary for Techwerker. It prevents the demo, README, and agent instructions from drifting into a claim the project cannot prove.

## Confidence Claim

We can be 100% confident in this bounded strategy when the release gates pass:

- Techwerker plans from official Tech Week calendar data when it is parseable.
- Techwerker collects non-secret RSVP basics once and reuses them locally.
- Techwerker answers plain-English city/date/time/topic/neighborhood requests with configured location awareness.
- Techwerker builds waitlist-aware, overlap-aware, location-aware RSVP portfolios.
- Techwerker uses Codex Desktop Browser Use as the primary official Partiful path.
- Techwerker clicks RSVP/list/Continue controls only after event-specific authorization and visible event confirmation.
- Techwerker stops for credentials, one-time codes, payment, captchas, unknown factual required fields, ambiguous confirmations, or unavailable city calendars.

We are not claiming 100% universal RSVP completion. Partiful, Tech Week, host policies, auth state, captchas, payment flows, hidden locations, and Codex app/browser capability can change outside this repo.

## Loopholes And Fixes

| Loophole | Proper fix | Gate or evidence |
| --- | --- | --- |
| Tech Week city page changes, redirects, or 404s. | Classify city status live; NYC/Boston must be parseable, San Francisco may be first-class pending. | `city-status`, `release-check --city all --json` |
| Calendar data is stale. | Use sync/city-status freshness and live release checks; treat stale cache as a diagnostic, not proof of live correctness. | `city-status`, sync age in release output |
| Plain-English location request only works for one neighborhood. | Maintain city neighborhood aliases and nearby cluster expansion. | `plain-ask-sanity` for NYC/Boston/SF aliases |
| Portfolio ignores user time windows or creates bad commutes. | Treat saved time windows as hard filters and require commute metadata/coverage buckets. | `portfolio-sanity` |
| Partiful duplicate buttons cause wrong global clicks. | Use one active RSVP modal, confirm active URL/title, and scoped/visual Browser Use actions. | `rsvp-context`, Partiful fixture duplicate CTA coverage |
| Partiful opens multiple host-question steps after Continue. | Re-inspect after every click and classify every newly visible field with `answer-field` before clicking again. | Camp AI live proof, `rsvpActionPolicy` |
| Partiful shows a backend error or a CTA repeats without visible progress. | Stop, record the exact visible state, and avoid repeated blind clicks in no-progress states. | `STOP_CONDITIONS`, runbook wording |
| Partiful asks a factual field Codex does not know. | Classify as `ask_user`, mark `needs-user-answer`, save event-only unless user approves reusable memory. | `answer-field`, missing-field smoke, fixture coverage |
| A form asks a legal/factual attestation such as 21+. | Treat it as a factual user answer, not generated text; reuse only from saved user-provided memory. | `answer-field` age/attestation checks |
| Codex invents personal data. | Factual fields can only come from user profile, user answer, saved memory, or visible non-sensitive prefill. | `answer-field`, `fresh-user-acceptance`, public hygiene checks |
| Low-stakes motivation answers become unsafe auto-fill. | Generated generic answers are draft-first unless a class is approved. | `answerStrategy`, release-check RSVP sanity |
| Login, OTP, captcha, or payment appears. | Stop immediately and require the user/site to handle it. | `STOP_CONDITIONS`, variant fixture coverage |
| User authorization is ambiguous. | Only selected-event phrases such as "get me on the list" authorize click-through; otherwise use `needs-user-submit`. | `rsvpActionPolicy`, docs checks |
| Browser Use routes to an external browser or cannot control the current surface. | Keep Browser Use in-app browser as primary; inspect plugin/skill routing if it drifts; use Computer Use only as macOS fallback for an intentionally selected external browser/debug path. | Skill/runbook wording, Mac-first docs, installed-cache parity |
| Computer Use cannot control Codex itself. | Do not depend on Computer Use to drive Codex app internals; use it for desktop capture controls or explicit external-browser fallback only. | Demo script and platform policy |
| Demo asset leaks personal data or private event info. | Maintain reviewed cropped assets, no private profile values, and a release asset manifest. | `ASSET-MANIFEST.md`, release artifact gate |
| Branding looks official or too close to the Tech Week mark. | Use `Techwerker` as a distinct, unofficial wordmark and keep "not affiliated" language visible in public assets. | README disclaimer, ship-readiness brand boundary, demo disclaimer |
| Demo looks like a pitch instead of proof. | Show official calendar, official Partiful, field handling, authorized click, visible Pending, and local state. | Demo video, cold-read test |
| Public copy overclaims "guaranteed signup bot." | Use public-beta/open-source workflow demo positioning and explicit non-claims. | README, SECURITY, release evidence, public hygiene grep |
| Installed plugin differs from repo. | Release gate compares installed cache and global skill copies to the repo. | `installed-cache-parity` |

## Final Bar

The strategy is release-ready only when:

1. `./scripts/check.sh` passes.
2. `techweek release-check --city all --json` has zero failures and only expected San Francisco pending warnings.
3. `git diff --check` passes.
4. The demo video and GIF are privacy-reviewed and legible without sound.
5. One real, explicitly authorized Partiful proof remains documented, and real submissions are not repeated as routine tests.

That gives factual confidence in the public-beta promise. It does not remove the need to stop cleanly when a live site presents a new auth, payment, captcha, or unknown required-answer state.
