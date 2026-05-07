# Techwerker

**Tech Week without the Werk.**

Unofficial local Codex helper for managing dense Tech Week calendars, signup queues, repeated RSVP form fields, and RSVP state.

Techwerker turns Tech Week chaos into a fill-once workflow: review dense calendars, select higher-signal events, build an overlap-aware RSVP portfolio, keep days location-aware, reuse non-secret attendee details locally, complete tedious repeated form fields, and hand repetitive RSVP/list work to Codex after the user authorizes a selected event. It helps plan and work the RSVP queue safely; it does not guarantee acceptance or bypass host rules.

Users can ask in plain English, such as "find me a cool AI event on Tuesday afternoon near Williamsburg" or "near SoHo." Techwerker maps that to Tech Week dates, time slots, topics, city neighborhood clusters, and nearby commute-aware alternatives before recommending events.

Techwerker is a utility for attendees. It is not affiliated with, endorsed by, or sponsored by Tech Week, a16z, Partiful, or any event host.

The deterministic state engine is `scripts/techweek`. Persistent state lives in:

```text
~/.codex/data/tech-week/<city>-<year>/
```

First-time signup flow:

1. Choose the calendar city label: New York, Boston, or San Francisco.
2. Save reusable non-secret RSVP basics: name, email, phone number, company, role/title, country, and LinkedIn profile.
3. Optionally save a default goal-of-attending answer.
4. Rank city-specific filters: topics, neighborhoods, event types to prioritize or avoid, and preferred start times.
5. Use the portfolio and RSVP queue from that saved profile, with several attempts per target time slot to account for waitlists and low acceptance.
6. Collapse accepted/waitlisted options into a realistic day plan that avoids unnecessary cross-city commuting.

Codex can use clearly visible browser/account values as suggestions during setup, and it can use visible non-sensitive Partiful prefilled values for the current RSVP without making the user retype them. Techwerker should ask before saving any visible value as reusable memory. It may draft generic motivation/comment answers from event and profile context after approval, but it must not invent factual personal data. Do not infer or store credentials, one-time codes, payment details, captcha answers, or private notes.

Core commands:

- `/techweek-setup`
- `/techweek`
- `/techweek-rsvp`

For non-developers in the Codex app for Mac, those commands are optional. The intended public flow is to enable the plugin, then ask in normal language:

```text
Use Techwerker. What can you do?
Get started with New York Tech Week.
Find me a cool AI event on Tuesday afternoon near Williamsburg.
Yes, get me on the list for that one.
```

The CLI and event ids are private implementation details for Codex to use behind the scenes.

New York and Boston are launched when their public calendar pages are parseable. San Francisco is supported as a first-class pending city; if `https://tech-week.com/calendar/san-francisco` still returns 404, the helper reports pending status instead of inventing events.

Default RSVP mode is assisted: build a narrow live queue when speed matters, generate an RSVP context packet, navigate the official Partiful page with Browser Use `iab`, fill known/saved/visible prefilled fields in the in-app browser, then click scoped RSVP/list/Continue controls for the selected event after authorization.

Calendar planning and local state helpers are ordinary Codex plugin behavior. Live Partiful RSVP filling is Mac-first today because it depends on Codex Desktop's in-app Browser Use tab, with Computer Use available only as a macOS desktop fallback for explicit external-browser debugging. Non-Mac users can still use planning, profile memory, portfolios, and RSVP state, but this release does not promise desktop form-control fallback outside macOS.

The public surface is intentionally practical: first-time signup setup, calendar triage, overlap-aware oversignup portfolio management, neighborhood-aware day planning, repeated identity-entry relief, and safer Partiful handoff. It does not store credentials, and it only completes RSVP/list actions after event-specific authorization such as "get me on the list" or "click RSVP."

For release diagnostics, agents can run `techweek city-status --city all` and `techweek release-check --city all` privately, then summarize the result.

See the root README for install instructions, safety notes, and the public user story.
