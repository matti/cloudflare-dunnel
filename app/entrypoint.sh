#!/usr/bin/env bash

set -eEuo pipefail

_on_error() {
  trap '' ERR
  line_path=$(caller)
  line=${line_path% *}
  path=${line_path#* }

  echo ""
  echo "ERR $path:$line $BASH_COMMAND exited with $1"
  exit 1
}
trap '_on_error $?' ERR

_shutdown() {
  trap '' TERM INT

  kill 0
  wait

  exit 0
}

trap _shutdown TERM INT

rm -rf "$HOME/.cloudflared" || true
mkdir -p "$HOME/.cloudflared"

envsubst < /app/tunnel.template.json > "${HOME}/.cloudflared/${DUNNEL_ID}.json"

while true; do
  cloudflared tunnel run --url "$DUNNEL_UPSTREAM" "$DUNNEL_ID" &
  wait
  echo "cloudflared exited!"
  sleep 0.1
done
