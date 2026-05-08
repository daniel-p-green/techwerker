---
description: Run first-time Techwerker setup for city, RSVP profile, and event filters.
argument-hint: [city]
---

Run first-time Techwerker onboarding. Techwerker takes the work out of Tech Week by collecting the reusable RSVP/profile information once, then using it later to fill repetitive Tech Week and Partiful forms.

First ask the user which Tech Week city they want to plan, using the calendar's labels:

- New York (`nyc`)
- Boston (`boston`)
- San Francisco (`san-francisco`, pending until the public calendar launches)

Do not assume a city in chat onboarding. If the user chooses San Francisco, explain that support is present but the calendar may stay pending until San Francisco launches.

After the city is chosen, initialize local state privately:

```bash
techweek onboarding-context --city <city> --json
techweek setup --city <city> --no-interactive
techweek profile --city <city> missing
techweek interests --city <city>
```

Use `onboarding-context` to keep first-run setup compact: collect reusable identity fields once, collect preferences once, and then let Codex handle calendar review, event selection, RSVP, and repeated forms privately.

Collect only the basic non-secret fields Tech Week RSVP forms commonly ask for:

- name (`display_name`)
- email (`email`)
- phone number (`phone`)
- company (`company`)
- role / title (`title`)
- country (`country`)
- LinkedIn profile (`linkedin`)
- goal of attending (`why_attending`, optional)

Ask for the missing required fields in one compact batch. Include the optional goal-of-attending question, but make clear it can be skipped. Explain that this optional answer can help Codex draft low-stakes "why do you want to attend?" responses later, but Codex will not invent factual personal data.

Then ask for lightweight event preferences from the selected city's available calendar options:

- top topics to prioritize
- neighborhoods or location clusters to prefer
- event types to prioritize or avoid
- start times to prefer or avoid
- how tightly to cluster each day geographically, defaulting to one or two location clusters per day

For New York and Boston, the visible calendar filters include these common options:

- Topics: AI, AR / VR, B2B, B2C / Consumer, Climate, Creators, Crypto / Web3, Cybersecurity, Deep Tech, Defense, Engineering, Fintech, Fundraising / Investing, Gaming, GTM, Hardware, Healthcare / Healthtech, HR / Hiring, Infrastructure, International / Expansion, Media / Entertainment, SaaS, Women-focused
- Types: Breakfast, Brunch or Lunch, Dinner, Experiential, Hackathon, Happy Hour, Matchmaking, Networking, Panel / Fireside Chat, Pitch Event / Demo Day, Roundtable / Workshop
- Start time: Morning, Noon, Afternoon, Evening

Use city-specific neighborhoods from `techweek interests --city <city>` when available. Known examples:

- New York: Bronx, Brooklyn, Central Park, Chelsea, Chinatown, East Village, Financial District, Flatiron, Gramercy Park, Greenwich Village, Hudson Yards, Kips Bay, Koreatown, Long Island, Lower East Side, Meatpacking District, Midtown, Murray Hill, Nomad, Queens, SoHo, Tribeca, Union Square, Upper Manhattan, Upper West Side, Virtual (NYC), West Village
- Boston: Allston, Back Bay, Bay Village, Beacon Hill, Brighton, Brookline, Cambridge, Charlestown, Chelsea, Chinatown, Downtown, East Boston, Everett, Fenway-Kenmore, Kendall Square, North End, Roxbury, Seaport District, Somerville, South Boston, South End, Virtual (BOS), Watertown, West End

Map start-time labels to time windows:

- Morning: `08:00-12:00`
- Noon: `12:00-15:00`
- Afternoon: `15:00-17:00`
- Evening: `17:00-21:00`

Save profile answers privately with:

```bash
techweek profile --city <city> set display_name "<name>"
techweek profile --city <city> set email "<email>"
techweek profile --city <city> set phone "<phone>"
techweek profile --city <city> set company "<company>"
techweek profile --city <city> set title "<role>"
techweek profile --city <city> set country "<country>"
techweek profile --city <city> set linkedin "<linkedin-url>"
techweek profile --city <city> set why_attending "<goal>"
```

Save preference answers privately with `techweek preferences --city <city> set-list <field> "<comma-separated values>"`. For the commute strategy, set `max_clusters_per_day` to `2` by default unless the user wants a tighter or looser day.

Do not ask for or store credentials, passwords, one-time codes, payment details, or anything Partiful-login-specific.

After setup, do not tell the user to run commands. Say that Techwerker is ready and offer natural next moves:

- find the best events for them,
- focus on a topic such as AI hackathons,
- get them on the list for recommended events,
- build a day plan.

Keep this command focused on initial configuration. Do not add Gmail, Calendar, routing, sub-agents, or auto-submit behavior here.
