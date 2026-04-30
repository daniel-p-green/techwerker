---
description: Run first-time Techwerker signup setup for city, RSVP profile, and event filters.
argument-hint: [city]
---

Run first-time Techwerker profile onboarding.

First ask the user which Tech Week city they want to plan, using the calendar's labels:

- New York (`nyc`)
- Boston (`boston`)
- San Francisco (`san-francisco`, coming soon)

Do not assume a city in chat onboarding. If the user chooses San Francisco, explain that support is present but the calendar may stay pending until San Francisco launches.

After the city is chosen, start with:

```bash
techweek setup --city <city> --no-interactive
techweek profile --city <city> missing
techweek interests --city <city>
```

Collect only the basic non-secret fields Tech Week RSVP forms commonly ask for:

- name (`display_name`)
- email (`email`)
- phone number (`phone`)
- company (`company`)
- role / title (`title`)
- country (`country`)
- LinkedIn profile (`linkedin`)
- goal of attending (`why_attending`, optional)

Ask for the missing required fields in one compact batch. Include the optional goal-of-attending question, but make clear it can be skipped.

Then ask for lightweight event preferences from the selected city's available calendar options:

- top topics to prioritize
- neighborhoods or location clusters to prefer
- event types to prioritize or avoid
- start times to prefer or avoid

For New York, the visible calendar filters include:

- Topics: AI, AR / VR, B2B, B2C / Consumer, Climate, Creators, Crypto / Web3, Cybersecurity, Deep Tech, Defense, Engineering, Fintech, Fundraising / Investing, Gaming, GTM, Hardware, Healthcare / Healthtech, HR / Hiring, Infrastructure, International / Expansion, Media / Entertainment, SaaS, Women-focused
- Neighborhoods: Bronx, Brooklyn, Central Park, Chelsea, Chinatown, East Village, Financial District, Flatiron, Gramercy Park, Greenwich Village, Hudson Yards, Kips Bay, Koreatown, Long Island, Lower East Side, Meatpacking District, Midtown, Murray Hill, Nomad, Queens, SoHo, Tribeca, Union Square, Upper Manhattan, Upper West Side, Virtual (NYC), West Village
- Types: Breakfast, Brunch or Lunch, Dinner, Experiential, Hackathon, Happy Hour, Matchmaking, Networking, Panel / Fireside Chat, Pitch Event / Demo Day, Roundtable / Workshop
- Start time: Morning, Noon, Afternoon, Evening

For Boston, the visible calendar filters include:

- Topics: AI, AR / VR, B2B, B2C / Consumer, Climate, Creators, Crypto / Web3, Cybersecurity, Deep Tech, Defense, Engineering, Fintech, Fundraising / Investing, Gaming, GTM, Hardware, Healthcare / Healthtech, HR / Hiring, Infrastructure, International / Expansion, Media / Entertainment, SaaS, Women-focused
- Neighborhoods: Allston, Back Bay, Bay Village, Beacon Hill, Brighton, Brookline, Cambridge, Charlestown, Chelsea, Chinatown, Downtown, East Boston, Everett, Fenway-Kenmore, Kendall Square, North End, Roxbury, Seaport District, Somerville, South Boston, South End, Virtual (BOS), Watertown, West End
- Types: Breakfast, Brunch or Lunch, Dinner, Experiential, Hackathon, Happy Hour, Matchmaking, Networking, Panel / Fireside Chat, Pitch Event / Demo Day, Roundtable / Workshop
- Start time: Morning, Noon, Afternoon, Evening

Treat these as city-specific examples, not global defaults. Prefer options from `techweek interests --city <city>` when available.

When saving start-time preferences, map calendar labels to time windows:

- Morning: `08:00-12:00`
- Noon: `12:00-15:00`
- Afternoon: `15:00-17:00`
- Evening: `17:00-21:00`

Save answers with:

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

Save preference answers with:

```bash
techweek preferences --city <city> set-list topics "<topic 1>, <topic 2>"
techweek preferences --city <city> set-list neighborhoods "<neighborhood 1>, <neighborhood 2>"
techweek preferences --city <city> set-list preferred_formats "<type to prioritize 1>, <type to prioritize 2>"
techweek preferences --city <city> set-list excluded_formats "<type to avoid 1>, <type to avoid 2>"
techweek preferences --city <city> set-list time_windows "08:00-12:00, 12:00-17:00"
```

After saving, run:

```bash
techweek profile --city <city> missing
techweek preferences --city <city> show
```

Show the profile path and any remaining missing fields. Do not ask for or store passwords, payment details, one-time codes, Partiful credentials, or other secrets.
