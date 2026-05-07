# Techwerker

**Takes the work out of Tech Week.**

Techwerker is a local Codex plugin for Tech Week attendees. It helps Codex review dense Tech Week calendars, select a realistic RSVP portfolio, open official Partiful pages, complete tedious repeated forms, and work the RSVP queue safely.

You tell it what you care about once. Then you can ask for things like:

```text
What can you do?
Get started.
Find me a cool AI event on Tuesday afternoon near Williamsburg.
Find the best AI hackathons for me.
Yes, get me on the list for that one.
Make me a day plan for June 3.
```

Techwerker handles the busywork: searching the calendar, building enough good options per time slot to survive waitlists, avoiding unrealistic neighborhood hops, opening the right pages, filling known or visibly prefilled fields, clicking the scoped RSVP/list controls you authorized, and tracking what happened.

It understands plain-English planning requests. “Tuesday afternoon near Williamsburg” becomes a real date/time/location query with New York neighborhood awareness, not just a text search. The same pattern works for supported neighborhoods across the city, such as SoHo, Chelsea, Midtown, Union Square, Tribeca, Brooklyn, Queens, and Upper Manhattan.

It does not guarantee event acceptance or bypass host rules. It gives Codex a safer, faster workflow for planning and authorized RSVP attempts.

> Techwerker is not affiliated with, endorsed by, or sponsored by Tech Week, a16z, Partiful, or any event host.

## Compatibility

Techwerker's calendar planning and local RSVP state helpers are ordinary Codex plugin workflows. The live Partiful RSVP flow is Mac-first today: it relies on Codex Desktop's in-app Browser Use tab for official Partiful pages, visible form filling, and scoped click-through, with Computer Use available only as a macOS desktop fallback for explicit external-browser debugging. Non-Mac users can still use the planning and local-state helpers, but this release does not promise desktop form-control fallback outside macOS.

## Why Use It

Tech Week is fun, but the signup process is a lot of work:

- too many events to scan by hand,
- waitlists and approval flows everywhere,
- the same RSVP fields over and over,
- hidden locations until you are accepted,
- too many tabs and links to track.

Techwerker turns that into a chat flow inside Codex.

## How It Works

1. You choose a city: New York, Boston, or San Francisco.
2. You enter basic non-secret RSVP info once: name, email, phone, company, role, country, LinkedIn, and interests.
3. Techwerker builds an overlap-aware portfolio with backups for each date/time slot, because many events waitlist or reject.
4. It keeps the plan location-aware so accepted events can turn into a realistic day instead of a cross-city scramble.
5. When you say “get me on the list,” Codex works through the official signup page and clicks RSVP/Continue for that event when it is safe to do so.
6. If a form asks something new, Techwerker asks once and can remember the answer for next time.

New York and Boston are treated as launched calendar cities when their public pages are parseable. San Francisco is first-class too, but if `https://tech-week.com/calendar/san-francisco` returns 404, Techwerker reports it as pending instead of pretending there are events.

Codex may notice visible account details or previous Partiful responses in the active form. Techwerker can use those visible non-sensitive values for the current RSVP, but should ask before saving them as reusable memory. It can draft harmless answers to generic prompts like “Why do you want to attend?” from the event and your saved preferences, but it does not invent factual personal data. It does not store passwords, one-time codes, payment details, captcha answers, or private notes.

## See It Work

![Techwerker demo](assets/techwerker-demo.gif)

The square X/Twitter demo artifact is [assets/techwerker-reviewer-demo.mp4](assets/techwerker-reviewer-demo.mp4). It uses the official NYC calendar and the `Rebuild x Eleven Labs Hackathon` Partiful page: `https://partiful.com/e/5gz90KPGpE1XoK3GZtoW`.

Example:

```text
You: Find me an ElevenLabs AI hackathon near SoHo.

Techwerker: Best match: Rebuild x Eleven Labs Hackathon on Saturday in Chinatown / SoHo-LES.

You: Yes, get me on the list.

Techwerker: I’ll open the official Partiful page, fill the RSVP fields I know, click through the scoped RSVP/list flow for that event, and stop if it needs a login code or an unknown factual answer.
```

Reviewer proof lives in [docs/release-evidence.md](docs/release-evidence.md): the current deterministic gates, live Partiful proof, and the exact non-claims that keep the public beta honest.

## Install

For non-developers using the Codex app for Mac, the intended flow is:

1. Install the `Techwerker` plugin from this GitHub repo using Codex's plugin install flow.
2. Enable the plugin in Codex if it is not enabled automatically.
3. Open the in-app browser when Codex needs to work official Tech Week or Partiful pages.
4. Ask Codex in normal language. You should not need to run commands or copy event IDs.

If you are comfortable with Terminal, the install command is:

```bash
codex plugin marketplace add daniel-p-green/techwerker
```

## Start

Inside Codex, ask:

```text
Use Techwerker. What can you do?
```

Then:

```text
Get started.
```

## Safety

Techwerker keeps helper state locally on your machine. It stores only non-secret RSVP details and preferences.

It should stop and ask you when a page needs:

- a login or one-time code,
- a payment detail,
- a captcha,
- a required question it has not seen before,
- a final confirmation that does not clearly belong to the selected event.

## For Developers

The optional terminal helper is available if you want to inspect or debug the underlying workflow:

```bash
./scripts/install-cli.sh
techweek setup --city "New York" --interactive
techweek cockpit --city "New York"
```

Validate the repo with:

```bash
./scripts/check.sh
```

Release-readiness diagnostics are available to developers with `techweek city-status --city all` and `techweek release-check --city all`.

Local state is stored outside the repo:

```text
~/.codex/data/tech-week/<city>-<year>/
```

## License

MIT
