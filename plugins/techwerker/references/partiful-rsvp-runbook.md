# Partiful RSVP Runbook

Use assisted mode by default.

1. Confirm the event URL comes from Tech Week `externalHref`.
2. Load the user's `rsvp-profile.json` and the event answer sheet.
3. Inspect visible labels and required fields.
4. Fill only fields with clear mappings or user-provided answers.
5. For unknown required fields, pause and ask once.
6. Offer to save reusable answers to `rsvp-profile.json`; save event-only answers in the answer sheet or form memory.
7. Stop before final RSVP, submit, join waitlist, or going action unless the user explicitly authorized final submission for this run.

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

