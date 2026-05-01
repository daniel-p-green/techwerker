# Techwerker

**Takes the work out of Tech Week.**

Techwerker is a local Codex plugin for Tech Week attendees. It helps you find worthwhile events, remember the RSVP details you keep retyping, and get through repetitive Tech Week and Partiful signup flows with Codex.

You tell it what you care about once. Then you can ask for things like:

```text
What can you do?
Get started.
Find the best AI hackathons for me.
Yes, get me on the list for that one.
Make me a day plan for June 3.
```

Techwerker handles the busywork: searching the calendar, narrowing the options, opening the right pages, filling known fields, and tracking what happened.

> Techwerker is not affiliated with, endorsed by, or sponsored by Tech Week, a16z, Partiful, or any event host.

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
3. Techwerker finds events that match your preferences.
4. When you say “get me on the list,” Codex works through the signup page for you.
5. If a form asks something new, Techwerker asks once and can remember the answer for next time.

It does not store passwords, one-time codes, or payment details.

## See It Work

![Techwerker demo](assets/techwerker-demo.gif)

Example:

```text
You: Find AI hackathons in New York.

Techwerker: I found a few strong matches. The best fit is a consumer AI hackathon in Chelsea on Saturday morning.

You: Yes, get me on the list.

Techwerker: I’ll open the event, fill the RSVP fields I know, and stop if it needs a login code or a custom answer.
```

## Install

In Codex:

```bash
codex plugin marketplace add daniel-p-green/techwerker
```

Then enable the `Techwerker` plugin if Codex does not enable it automatically.

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
- a required question it has not seen before,
- an unclear final confirmation.

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

Local state is stored outside the repo:

```text
~/.codex/data/tech-week/<city>-<year>/
```

## License

MIT
