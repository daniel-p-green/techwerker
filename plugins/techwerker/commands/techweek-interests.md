---
description: Extract Tech Week topics, hosts, and locations, then update ranking preferences.
argument-hint: [city] [goals/preferences]
---

Build or update the user's Tech Week interest profile.

Default city is `nyc` unless the user names another city. Run:

```bash
techweek sync --city <city>
techweek interests --city <city>
```

Read the generated `interest-options.json` and the current `preferences.json`.

Use the user's stated goals plus the extracted facets, hosts, locations, clusters, and time slots to propose concise ranking preferences:

- topics
- priority_hosts
- neighborhoods
- avoid_clusters
- excluded_formats
- time_windows
- signup_multiplier
- target_events_per_slot

Write the updated `preferences.json` after the user gives enough direction or when the request clearly asks you to proceed. Keep defaults conservative: `signup_multiplier` should usually be 3, `target_events_per_slot` should usually be 1, and `cluster_first` should be true.

Report the top extracted topics/hosts/clusters and the preference file path.

