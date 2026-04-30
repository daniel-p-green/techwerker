---
description: Run first-time Tech Week profile and preference setup.
argument-hint: [city] [--interactive]
---

Run the lightweight Tech Week setup flow.

Default city is `nyc` unless the user names another city. Start with:

```bash
techweek setup --city <city>
```

If the user wants to fill answers directly in the terminal, use:

```bash
techweek setup --city <city> --interactive
```

Setup should initialize or update:

- `rsvp-profile.json`
- `preferences.json`
- `form-memory.json`
- `interest-options.json`
- `setup-summary.md`

Do not ask for or store credentials, passwords, one-time codes, payment details, or anything Partiful-login-specific.

After setup, show the next simple flow:

```bash
techweek cockpit --city <city>
techweek portfolio --city <city>
techweek apply-queue --city <city>
```

Keep this command focused on initial configuration. Do not add Gmail, Calendar, routing, sub-agent, or auto-submit behavior here.

