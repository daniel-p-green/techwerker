# Demo Asset Manifest

This manifest exists because the demo uses visual assets from an authenticated local browser session. Keep the public repo safe by reviewing every generated visual asset before release.

## Assets

- `assets/techwerker-reviewer-demo.mp4`
  - Purpose: square X/Twitter calendar-to-RSVP reviewer cut.
  - Format: 1080x1080 MP4.
  - Source: HyperFrames wrapper around an official Tech Week calendar capture plus a trimmed live screen recording of the official `Camp AI: Agents at Work` Partiful flow.
  - Editorial note: the shareable cut ends on visible `Pending`; the immediate RSVP removal/cleanup is documented in release evidence but edited out of the public video.
  - Privacy review: no real email, phone, LinkedIn, profile page, OTP, payment detail, or private message is intentionally visible. Sample public demo fields may appear where needed.
- `assets/techwerker-demo.gif`
  - Purpose: README preview generated from the square calendar-to-RSVP reviewer MP4.
  - Format: 960x960 GIF.
  - Privacy review: generated from the reviewed MP4.
- `assets/readme/02-ask.jpg`
- `assets/readme/03-calendar.jpg`
- `assets/readme/04-partiful.jpg`
- `assets/readme/06-pending.jpg`
  - Purpose: README still frames showing the full proof arc: official calendar, selected event, official Partiful form, and visible Pending.
  - Format: 1080x1080 JPG frames exported from `assets/techwerker-reviewer-demo.mp4`.
  - Privacy review: generated from the reviewed MP4; no real email, phone, LinkedIn, profile page, OTP, payment detail, or private message is intentionally visible. Sample public demo fields may appear where needed.
- `docs/demo-video/assets/calendar-to-partiful-flow.mp4`
  - Purpose: official Tech Week calendar to Partiful opening segment for the reviewer cut.
  - Source: browser capture of `https://www.tech-week.com/calendar/nyc`, search for `Camp AI`, visible matching row, then official Partiful event page.
  - Privacy review: public calendar/event pages only; no account details, contact fields, OTP, payment detail, or private message.
- `docs/demo-video/assets/camp-ai-live-proof.mp4`
  - Purpose: trimmed source clip for the live-first HyperFrames cut.
  - Source: official `Camp AI: Agents at Work` Partiful screen recording, ending before the removal/unsubscribe modal.
  - Privacy review: no real email, phone, LinkedIn, OTP, payment detail, or private message is intentionally visible.
- `docs/demo-video/assets/tech-week-home-style.png`
  - Purpose: public Tech Week homepage style/reference frame.
  - Source: public `https://www.tech-week.com/` homepage.
- `docs/demo-video/assets/camp-ai-event-crop.png`
  - Purpose: official Camp AI Partiful host-question proof frame.
  - Privacy review: sample/demo-safe visible form content only; no real phone, email, OTP, payment detail, or private message.
- `docs/demo-video/assets/camp-ai-pending-proof.png`
  - Purpose: visible Camp AI Partiful `Pending` proof badge.
  - Privacy review: cropped from the visible pending page; no contact fields or private message are visible.
- `docs/demo-video/assets/elevenlabs-event-crop.png`
  - Purpose: historical styled-demo Partiful frame for `Rebuild x Eleven Labs Hackathon`.
  - Privacy review: cropped to avoid browser/account header and profile details.
- `docs/demo-video/assets/elevenlabs-pending-proof.png`
  - Purpose: historical styled-demo visible Partiful `Pending` proof badge.
  - Privacy review: badge-only crop; no contact or profile values are visible.

## Release Rule

Do not publish new generated screenshots, GIFs, or videos until this manifest is updated and the asset is checked for accidental personal data.
Use Browser Use, the optional Codex Chrome plugin path when installed/enabled, or another controlled browser viewport for fresh official-site capture, then use HyperFrames only for pacing, captions, crops, and reviewer-safe packaging.
