#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/assets/techwerker-demo.gif"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

FFMPEG="${FFMPEG:-ffmpeg}"
if ! command -v "$FFMPEG" >/dev/null 2>&1; then
  if [ -x /opt/homebrew/opt/ffmpeg@6/bin/ffmpeg ]; then
    FFMPEG=/opt/homebrew/opt/ffmpeg@6/bin/ffmpeg
  else
    echo "ffmpeg is required" >&2
    exit 1
  fi
fi

FONT="/System/Library/Fonts/SFNSMono.ttf"
if [ ! -f "$FONT" ]; then
  FONT="/System/Library/Fonts/Monaco.ttf"
fi

cat >"$TMP_DIR/chat1.txt" <<'EOF'
User
Set up Techwerker for New York.

Codex
Using Techwerker. I will collect reusable basics,
city filters, and keep the profile local.
EOF

cat >"$TMP_DIR/out1.txt" <<'EOF'
Tool: techweek setup --city "New York"

city=nyc-2026
profile=ready, non-secret only
filters=AI; Noon, Evening
formats=Networking, Panel / Fireside Chat
submit_policy=pause before final submit
EOF

cat >"$TMP_DIR/chat2.txt" <<'EOF'
User
Build a fast live RSVP queue.

Codex
I will fetch the official calendar directly, filter
to AI noon/evening Partiful links, and avoid the full queue.
EOF

cat >"$TMP_DIR/out2.txt" <<'EOF'
Tool: techweek live-queue --city "New York" \
  --topics AI --time-slots noon,evening --limit 3

1. 12:00 [Flatiron] AI Founders Lunch
2. 18:00 [Chelsea] AI Operators Dinner
3. 19:00 [SoHo] Applied AI Meetup

wrote live-queue.json
EOF

cat >"$TMP_DIR/chat3.txt" <<'EOF'
User
Work the first event, but don't submit.

Codex
I will prepare the answer sheet, open Partiful,
use Computer Use first, and pause.
EOF

cat >"$TMP_DIR/out3.txt" <<'EOF'
Tool: techweek answers --city "New York" 1 --write

Answer sheet:
Name, email, phone, company, role,
country, LinkedIn, goal

Tool: techweek open --city "New York" 1
Opened Partiful target.
EOF

cat >"$TMP_DIR/chat4.txt" <<'EOF'
Codex
Computer Use filled reusable answers.
Unknown required fields are recorded and skipped.
EOF

cat >"$TMP_DIR/browser4.txt" <<'EOF'
partiful.com/e/...

RSVP form

Name        Demo Attendee
Email       demo@example.com
Phone       demo phone
Company     Example Co
Title       Founder
LinkedIn    linkedin.com/in/example

Submit button visible
Status: paused before submit
EOF

cat >"$TMP_DIR/filter.txt" <<EOF
[0:v]drawbox=x=34:y=28:w=1212:h=664:color=0xf7f7f8:t=fill,
drawbox=x=34:y=28:w=1212:h=44:color=0xffffff:t=fill,
drawbox=x=58:y=45:w=10:h=10:color=0xff5f56:t=fill,
drawbox=x=78:y=45:w=10:h=10:color=0xffbd2e:t=fill,
drawbox=x=98:y=45:w=10:h=10:color=0x27c93f:t=fill,
drawtext=fontfile='$FONT':text='Codex  /  Techwerker':x=528:y=43:fontsize=18:fontcolor=0x111827,
drawbox=x=58:y=92:w=544:h=548:color=0xffffff:t=fill,
drawbox=x=626:y=92:w=596:h=548:color=0x0f172a:t=fill,
drawbox=x=58:y=92:w=544:h=42:color=0x111827:t=fill,
drawbox=x=626:y=92:w=596:h=42:color=0x182235:t=fill,
drawtext=fontfile='$FONT':text='Codex chat':x=80:y=108:fontsize=17:fontcolor=0xf9fafb,
drawtext=fontfile='$FONT':text='Techwerker workspace':x=650:y=108:fontsize=17:fontcolor=0xf9fafb,
drawtext=fontfile='$FONT':text='Tech Week without the Werk.':x=455:y=660:fontsize=21:fontcolor=0x047857,
drawtext=fontfile='$FONT':textfile='$TMP_DIR/chat1.txt':x=86:y=160:fontsize=20:line_spacing=8:fontcolor=0x111827:enable='between(t,0,3)',
drawtext=fontfile='$FONT':textfile='$TMP_DIR/out1.txt':x=654:y=156:fontsize=19:line_spacing=8:fontcolor=0xf9fafb:enable='between(t,0,3)',
drawtext=fontfile='$FONT':textfile='$TMP_DIR/chat2.txt':x=86:y=160:fontsize=20:line_spacing=8:fontcolor=0x111827:enable='between(t,3,6)',
drawtext=fontfile='$FONT':textfile='$TMP_DIR/out2.txt':x=654:y=156:fontsize=20:line_spacing=8:fontcolor=0xf9fafb:enable='between(t,3,6)',
drawtext=fontfile='$FONT':textfile='$TMP_DIR/chat3.txt':x=86:y=160:fontsize=20:line_spacing=8:fontcolor=0x111827:enable='between(t,6,9)',
drawtext=fontfile='$FONT':textfile='$TMP_DIR/out3.txt':x=654:y=156:fontsize=19:line_spacing=7:fontcolor=0xf9fafb:enable='between(t,6,9)',
drawtext=fontfile='$FONT':textfile='$TMP_DIR/chat4.txt':x=86:y=160:fontsize=20:line_spacing=8:fontcolor=0x111827:enable='between(t,9,12)',
drawbox=x=650:y=156:w=548:h=420:color=0xffffff:t=fill:enable='between(t,9,12)',
drawbox=x=650:y=156:w=548:h=38:color=0xe5e7eb:t=fill:enable='between(t,9,12)',
drawtext=fontfile='$FONT':textfile='$TMP_DIR/browser4.txt':x=676:y=176:fontsize=20:line_spacing=8:fontcolor=0x111827:enable='between(t,9,12)'
[v]
EOF

"$FFMPEG" -y \
  -f lavfi -i color=c=0xe5e7eb:s=1280x720:d=12:r=12 \
  -filter_complex_script "$TMP_DIR/filter.txt" \
  -map '[v]' -an "$TMP_DIR/demo.mp4" >/dev/null 2>&1

"$FFMPEG" -y -i "$TMP_DIR/demo.mp4" \
  -vf "fps=12,scale=960:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=96[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5" \
  -loop 0 "$OUT" >/dev/null 2>&1

echo "wrote $OUT"
