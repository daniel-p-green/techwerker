# Demo Asset Manifest

This manifest exists because the demo uses screenshots from an authenticated local browser session. Keep the public repo safe by reviewing every generated visual asset before release.

## Assets

- `assets/techwerker-reviewer-demo.mp4`
  - Purpose: square X/Twitter live proof cut.
  - Format: 1080x1080 MP4.
  - Source: viewport capture of the official `Camp AI: Agents at Work` Partiful flow.
  - Privacy review: no real email, phone, LinkedIn, profile page, OTP, payment detail, or private message is intentionally visible. Sample public demo fields may appear where needed.
- `assets/techwerker-demo.gif`
  - Purpose: README preview generated from the square live proof MP4.
  - Format: 960x960 GIF.
  - Privacy review: generated from the reviewed MP4.
- `assets/readme/02-ask.jpg`
- `assets/readme/03-calendar.jpg`
- `assets/readme/04-partiful.jpg`
- `assets/readme/06-pending.jpg`
  - Purpose: README still frames showing the actual demo arc.
  - Format: 1080x1080 JPG frames exported from `assets/techwerker-reviewer-demo.mp4`.
  - Privacy review: generated from the reviewed MP4; no real email, phone, LinkedIn, profile page, OTP, payment detail, or private message is intentionally visible. Sample public demo fields may appear where needed.
- `docs/demo-video/assets/tech-week-home-style.png`
  - Purpose: public Tech Week homepage style/reference frame.
  - Source: public `https://www.tech-week.com/` homepage.
- `docs/demo-video/assets/elevenlabs-event-crop.png`
  - Purpose: historical styled-demo Partiful frame for `Rebuild x Eleven Labs Hackathon`.
  - Privacy review: cropped to avoid browser/account header and profile details.
- `docs/demo-video/assets/elevenlabs-pending-proof.png`
  - Purpose: historical styled-demo visible Partiful `Pending` proof badge.
  - Privacy review: badge-only crop; no contact or profile values are visible.

## Release Rule

Do not publish new generated screenshots, GIFs, or videos until this manifest is updated and the asset is checked for accidental personal data.
Use Browser Use or a controlled browser viewport for fresh official-site capture, then use HyperFrames only for pacing, captions, crops, and reviewer-safe packaging.
