---
description: Create or update reusable Tech Week Partiful profile fields.
argument-hint: [city] [optional notes]
---

Set up the user's reusable non-secret Tech Week RSVP profile.

Use `techweek profile --city <city> init` first. If the user did not specify a city, default to `nyc`.

Then inspect `~/.codex/data/tech-week/<city>-<year>/rsvp-profile.json` and identify missing useful fields:

- display_name
- email
- phone
- company
- title
- linkedin
- website
- one_liner
- why_attending
- comment_template

Ask only for values that are actually missing or likely needed for Partiful forms. Do not ask for or store passwords, payment details, one-time codes, or Partiful credentials.

If the user provides answers, update `rsvp-profile.json` directly and show the profile path plus remaining blanks. Keep the profile portable across NYC, Boston, and future SF by copying the same answer values into the requested city profile when needed.

