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

cat >"$TMP_DIR/scene1.txt" <<'EOF'
$ codex
> Show my Techwerker cockpit

# Tech Week Cockpit: nyc-2026
synced=2026-04-30T20:56:18Z events=1221 open_links=1054
portfolio_targets=83 apply_queue_pending=83
profile=ready: name, email, company, title, linkedin
form_memory=22 mappings, 0 secrets stored
EOF

cat >"$TMP_DIR/scene2.txt" <<'EOF'
$ techweek portfolio --city nyc --limit 5

Top targets by slot:
09:00  AI infra breakfast        Flatiron    score 91
11:30  Founder office hours      SoHo        score 87
14:00  Applied AI demos          Union Sq    score 84
17:30  Operator happy hour       NoMad       score 81

Strategy: 3 plausible RSVP attempts per intended slot.
EOF

cat >"$TMP_DIR/scene3.txt" <<'EOF'
$ techweek apply-queue --city nyc --limit 3

1. AI infra breakfast        target   Partiful link ready
2. Founder office hours      target   Partiful link ready
3. Applied AI demos          target   needs review

$ techweek answers --city nyc ai-infra-breakfast --write
Wrote sanitized answer sheet from local profile/form memory.
EOF

cat >"$TMP_DIR/scene4.txt" <<'EOF'
Browser handoff

Open Partiful page
Inspect visible fields
Fill reusable non-secret answers
Ask once for unknown required fields

Status: filled
Next: pause before final RSVP submit
EOF

cat >"$TMP_DIR/filter.txt" <<EOF
[0:v]drawbox=x=56:y=54:w=1168:h=612:color=0x101828:t=fill,
drawbox=x=56:y=54:w=1168:h=46:color=0x182235:t=fill,
drawbox=x=82:y=72:w=12:h=12:color=0xff5f56:t=fill,
drawbox=x=104:y=72:w=12:h=12:color=0xffbd2e:t=fill,
drawbox=x=126:y=72:w=12:h=12:color=0x27c93f:t=fill,
drawtext=fontfile='$FONT':text='Techwerker':x=548:y=68:fontsize=20:fontcolor=0xe5e7eb,
drawtext=fontfile='$FONT':text='Tech Week without the Werk.':x=388:y=620:fontsize=24:fontcolor=0xa7f3d0,
drawtext=fontfile='$FONT':textfile='$TMP_DIR/scene1.txt':x=92:y=132:fontsize=25:line_spacing=9:fontcolor=0xf9fafb:enable='between(t,0,2.8)',
drawtext=fontfile='$FONT':textfile='$TMP_DIR/scene2.txt':x=92:y=132:fontsize=25:line_spacing=9:fontcolor=0xf9fafb:enable='between(t,2.8,5.6)',
drawtext=fontfile='$FONT':textfile='$TMP_DIR/scene3.txt':x=92:y=132:fontsize=25:line_spacing=9:fontcolor=0xf9fafb:enable='between(t,5.6,8.4)',
drawtext=fontfile='$FONT':textfile='$TMP_DIR/scene4.txt':x=92:y=132:fontsize=31:line_spacing=12:fontcolor=0xf9fafb:enable='between(t,8.4,11.2)'
[v]
EOF

"$FFMPEG" -y \
  -f lavfi -i color=c=0x060914:s=1280x720:d=11.2:r=12 \
  -filter_complex_script "$TMP_DIR/filter.txt" \
  -map '[v]' -an "$TMP_DIR/demo.mp4" >/dev/null 2>&1

"$FFMPEG" -y -i "$TMP_DIR/demo.mp4" \
  -vf "fps=12,scale=960:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=96[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5" \
  -loop 0 "$OUT" >/dev/null 2>&1

echo "wrote $OUT"
