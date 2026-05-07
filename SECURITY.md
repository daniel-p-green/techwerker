# Security

Techwerker is a local attendee helper. It is not an official Tech Week, a16z, Partiful, or event-host service.

## Local State

Runtime state is written under:

```text
~/.codex/data/tech-week/<city>-<year>/
```

That state may include event snapshots, RSVP state, preferences, non-secret RSVP profile fields, form-memory mappings, and generated exports.

## What Not To Store

Do not store:

- Partiful credentials
- passwords
- one-time codes
- payment details
- captcha solutions
- sensitive private notes

The default profile and form-memory templates explicitly mark those categories as `do_not_store`.

## RSVP Safety

Techwerker defaults to assisted mode:

1. open the event page,
2. fill known, saved, or visibly prefilled non-sensitive fields,
3. ask for missing required fields,
4. click scoped RSVP, waitlist, Continue, submit, or "Going" actions only after event-specific authorization.

Live RSVP automation is Mac-first today: Browser Use in the Codex Desktop in-app browser is the primary path, and Computer Use is only a macOS desktop fallback for explicitly selected external-browser debugging. Planning, local state, and answer-memory helpers remain ordinary Codex plugin behavior.

Phrases like "get me on the list", "sign me up", or "click RSVP" for a selected event authorize Techwerker to complete that event's normal RSVP/list flow.

Visible Partiful account values or previous responses may be used for the current active form when they are non-sensitive, but should not be saved as reusable memory without user approval.

Generated answers are limited to low-stakes motivation/comment prompts and default to draft-first. Techwerker must not invent factual personal data such as phone numbers, email addresses, dietary restrictions, accessibility needs, credentials, payment details, or one-time codes.

Even with authorization, Techwerker should stop for credentials, one-time codes, payment details, captchas, unknown required fields, or a final confirmation that does not clearly belong to the selected event.

## Reporting Issues

Open a GitHub issue for bugs or unsafe behavior. Do not include credentials, profile data, private event links, or personal contact information in public issues.
