# Partiful RSVP Runbook

Use assisted mode by default. Use Browser Use `iab` for the proved official event-page navigation, visible-state inspection, in-app browser form filling, controlled candidate tabs, and scoped click-through path. If the Codex Chrome plugin is installed/enabled and the user wants existing signed-in Chrome state, Chrome is an optional path with the same active-tab, scoped-click, and safety-stop rules. Live RSVP automation is Mac-first in the proved path today: Computer Use is only a macOS desktop fallback for explicit external-browser debugging, while planning/local state remain normal Codex plugin behavior.

Tech Week planning should be overlap-aware and location-aware before any RSVP work starts. Because waitlists and low acceptance rates are common, target several strong RSVP attempts per date/time slot, but keep each day clustered around a small number of realistic neighborhoods. The goal is optionality without creating a day that only works if the user teleports.

Saved time windows are hard filters for the main portfolio. Do not put morning events into the primary queue for a user who asked for noon/evening unless they explicitly ask to broaden the search.

Use tabs the way a human would stage work, with stricter execution rules: it is fine to open several candidate Partiful event tabs for inspection, but only one tab should have an active RSVP modal. Use plain event URLs for background staging tabs, add `?rsvp=true` or open the modal only for the selected active event, confirm URL/title against the selected event before filling or clicking, then record state before switching tabs.

1. Confirm the event URL comes from Tech Week `externalHref`.
2. Write the answer sheet with `techweek answers --city <city> <event-id> --write`.
3. Load `techweek rsvp-context --city <city> <event-id> --json`.
4. Navigate Browser Use `iab`, or Chrome plugin control when installed/enabled and intentionally selected, to `eventUrl` and inspect the current visible state.
5. Treat repeated labels such as multiple "Get on the list" buttons as ambiguous. Scope to the visible selected-event modal/card or switch to a visual action instead of clicking a global text match.
6. Inspect visible labels and required fields once the Partiful modal is open.
7. For each visible field, run `techweek answer-field --city <city> <event-id> "<visible label>" --json`. If the field is already visibly filled by Partiful account data or previous responses, pass `--visible-value "<visible value>" --visible-source account|previous-response|form`.
8. Fill `fill_from_profile` and `fill_saved_answer` values. Leave/use `use_visible_value` fields for the current RSVP without making the user retype them, but do not save those visible values unless the user approves. For `draft_generic_answer`, draft a concise event-specific answer and ask before using it unless that generated answer class is approved. For `ask_user`, ask only for that answer. For `stop`, pause immediately.
9. For unknown required fields, record `needs-user-answer`, pause once for a compact batch of answers, then skip the event until resolved.
10. Offer to save reusable answers only when they should apply broadly; save event-only answers by default. Generated answer classes such as `motivation` require explicit approval before future auto-fill.
11. If the user said "get me on the list", "sign me up", "click RSVP", or equivalent for the selected event, continue past filled fields and click the next unique or scoped "Get on the list", "RSVP", "Join waitlist", "Continue", "Submit", "Going", or equivalent action.
12. Re-inspect after every click. Continue only while the next visible action still belongs to the selected event and no stop condition appears.
13. If a new host-question step appears after Continue, classify every new field before clicking again. Treat legal/factual attestations such as 21+ questions as user-provided facts, not generated text.
14. If Partiful shows `Something went wrong`, a network/backend error, or the same CTA repeats without visible progress, stop and record the exact state instead of pressing again.
15. Mark `applied` for visible RSVP/request/on-list confirmation, `waitlisted` for visible waitlist/list confirmation, `cancelled` when a previously submitted demo or RSVP is visibly removed after explicit user authorization, and `needs-user-submit` only when the user has not authorized the selected event action.

Stop immediately for credentials, one-time codes, payment details, captchas, unknown required fields, Partiful errors/no-progress states, or a final confirmation that does not clearly belong to the selected event.

Use Browser Use for Tech Week calendar spot checks and in-app browser work, but keep the CLI/local state as the primary calendar engine. Use the Chrome plugin only when installed/enabled and useful for existing Chrome login state or tabs. Do not keep fighting DOM/accessibility refs inside Partiful modals; switch to visual actions in the selected browser surface first.

Field mapping defaults:

- name, your name -> `display_name`
- email -> `email`
- phone -> `phone`
- company, organization -> `company`
- role, current role, title, job title -> `title`
- LinkedIn -> `linkedin`
- website, GitHub link -> `website`
- why are you interested -> `why_attending`
- comment -> `comment_template`

Answer strategy:

- factual profile fields are filled only from saved profile or user-provided values
- visible non-sensitive prefilled values from Partiful account data or previous responses can be used for the current form
- event-specific saved answers override reusable answers
- generic motivation/comment prompts can be drafted from event and profile context
- generated answers are draft-first unless the user approved that class
- sensitive fields such as credentials, codes, payment, or captcha stop the flow
