# Partiful RSVP Runbook

Use assisted mode by default. Use Computer Use first for Partiful because the RSVP surface is often visual, authenticated, and modal-heavy.

1. Confirm the event URL comes from Tech Week `externalHref`.
2. Load the user's `rsvp-profile.json` and the event answer sheet.
3. Inspect visible labels and required fields with Computer Use.
4. Fill only fields with clear mappings or user-provided answers.
5. For unknown required fields, record `needs-user-answer`, pause once for a compact batch of answers, then skip the event until resolved.
6. Offer to save reusable answers to `rsvp-profile.json`; save event-only answers in the answer sheet or form memory.
7. Stop before final RSVP, submit, join waitlist, or going action unless the user explicitly authorized final submission for this run.

Use Browser/Playwright for Tech Week calendar parsing and simple static page inspection. Do not keep fighting DOM/accessibility refs inside Partiful modals.

Field mapping defaults:

- name, your name -> `display_name`
- email -> `email`
- phone -> `phone`
- company, organization -> `company`
- role, title, job title -> `title`
- LinkedIn -> `linkedin`
- website -> `website`
- why are you interested -> `why_attending`
- comment -> `comment_template`
