# Launch Copy

## Variant 1: Concise Utility

Techwerker: Tech Week without the Werk.

I made a local Codex plugin for Tech Week attendees:

- sync the calendar
- find higher-signal events
- build a narrow live RSVP queue
- reuse RSVP form answers
- track applied / waitlisted / accepted / skipped
- use Computer Use for Partiful and pause before final submit

Unofficial, local-first, attendee-focused.

https://github.com/daniel-p-green/techwerker

## Variant 2: Witty Tagline

Tech Week without the Werk.

Techwerker is a Codex helper for the actual attendee workflow:

1. sort through hundreds of events
2. oversignup because waitlists are real
3. stop retyping the same RSVP fields
4. work one Partiful target at a time
5. decide later when acceptances land

Not affiliated with Tech Week, a16z, Partiful, or hosts. Just a local helper.

https://github.com/daniel-p-green/techwerker

## Variant 3: Demo-First Thread

Tech Week has hundreds of events, hidden locations, waitlists, and a lot of repeated RSVP forms.

So I made Techwerker: Tech Week without the Werk.

It is a local Codex plugin that turns the chaos into a queue.

Demo:

```bash
techweek setup --city "New York"
techweek live-queue --city "New York" --topics AI --time-slots noon,evening --limit 3
techweek answers --city "New York" <event-id> --write
techweek open --city "New York" <event-id>
```

It fetches the live calendar, builds a narrow AI noon/evening queue, tracks RSVP state, and hands Partiful pages to Codex Computer Use for assisted form filling.

The important safety bit: it pauses before final submit by default.

Repo:
https://github.com/daniel-p-green/techwerker
