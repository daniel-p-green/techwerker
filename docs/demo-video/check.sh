#!/usr/bin/env bash
set -euo pipefail

TIMEOUT_SECONDS="${HYPERFRAMES_TIMEOUT_SECONDS:-45}"

run_hyperframes() {
  local command="$1"
  local success_pattern="$2"
  local tmp
  tmp="$(mktemp)"

  npx --yes hyperframes@0.5.3 "$command" >"$tmp" 2>&1 &
  local pid=$!
  local elapsed=0

  while kill -0 "$pid" 2>/dev/null; do
    if [ "$elapsed" -ge "$TIMEOUT_SECONDS" ]; then
      if grep -q "$success_pattern" "$tmp"; then
        kill "$pid" 2>/dev/null || true
        wait "$pid" 2>/dev/null || true
        cat "$tmp"
        rm -f "$tmp"
        echo "◇ accepted $command output after timeout"
        return 0
      fi

      kill "$pid" 2>/dev/null || true
      wait "$pid" 2>/dev/null || true
      cat "$tmp"
      rm -f "$tmp"
      echo "hyperframes $command timed out before success output" >&2
      return 1
    fi

    sleep 1
    elapsed=$((elapsed + 1))
  done

  local status=0
  wait "$pid" || status=$?
  cat "$tmp"
  rm -f "$tmp"
  return "$status"
}

run_hyperframes lint "0 error(s)"
run_hyperframes validate "No console errors"
run_hyperframes inspect "0 layout issues"
