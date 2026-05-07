#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VIDEO_DIR="$ROOT/docs/demo-video"
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

if [ ! -f "$VIDEO_DIR/index.html" ]; then
  echo "missing HyperFrames composition: $VIDEO_DIR/index.html" >&2
  exit 1
fi

mkdir -p "$ROOT/assets"

(
  cd "$VIDEO_DIR"
  npm run check
  npx --yes hyperframes@0.5.3 render --output "$MP4" --quality standard
)

"$FFMPEG" -y -i "$MP4" \
  -vf "fps=10,scale=960:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=96[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5" \
  -loop 0 "$GIF" >/dev/null 2>&1

echo "wrote $MP4"
echo "wrote $GIF"
