#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MP4="$ROOT/assets/techwerker-reviewer-demo.mp4"
GIF="$ROOT/assets/techwerker-demo.gif"
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

if [ ! -f "$MP4" ]; then
  echo "missing reviewer MP4: $MP4" >&2
  exit 1
fi

mkdir -p "$ROOT/assets"

"$FFMPEG" -y -i "$MP4" \
  -vf "fps=8,scale=720:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=80[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5" \
  -loop 0 "$GIF" >/dev/null 2>&1

echo "wrote $GIF"
