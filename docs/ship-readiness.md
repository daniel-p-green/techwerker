# Ship Readiness

Techwerker is ready to share as a **public beta / open-source Codex workflow demo**, not as a guaranteed RSVP bot.

## Current Release Label

- Audience: discerning reviewers, early adopters, and Codex users comfortable with a local workflow.
- Promise: plan Tech Week, build a realistic RSVP queue, reuse non-secret form basics, and let Codex work official Partiful flows after event-specific authorization.
- Constraint: live RSVP form work is Mac-first today because Browser Use in Codex Desktop is the primary path and Computer Use is a macOS fallback.

## Evidence Required Before Broad Sharing

- Deterministic repo gate passes: `./scripts/check.sh`.
- Release gate passes: `techweek release-check --city all --json` with zero failures and only expected San Francisco pending warnings.
- Fresh-user acceptance passes from an empty `HOME`.
- Demo video is square, silent-first, and privacy-reviewed.
- Installed plugin cache matches the repo copy.
- One real, explicitly authorized Partiful proof exists and is not repeated as a routine test.

## Non-Negotiable Safety Stops

Techwerker must stop for credentials, one-time codes, payment, captchas, unknown factual required fields, and ambiguous final confirmations. It must not invent factual personal data.

## Reviewer Cold-Read Test

Show the square demo without sound. A reviewer should be able to say, within 20 seconds:

1. This helps Codex find a Tech Week event from plain English.
2. It uses the official Tech Week and Partiful path.
3. It fills repeated form fields but stops for facts it does not know.
4. It reached a visible pending/request state after authorization.

If that does not happen, revise the demo before posting.
