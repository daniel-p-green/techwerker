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
- sensitive private notes

The default profile and form-memory templates explicitly mark those categories as `do_not_store`.

## RSVP Safety

Techwerker defaults to assisted mode:

1. open the event page,
2. fill known fields,
3. ask for missing required fields,
4. pause before final RSVP, waitlist, submit, or "Going" actions.

Do not use final auto-submit unless you explicitly authorize it for a specific run.

## Reporting Issues

Open a GitHub issue for bugs or unsafe behavior. Do not include credentials, profile data, private event links, or personal contact information in public issues.
