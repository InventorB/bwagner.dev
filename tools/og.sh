#!/usr/bin/env bash
# Regenerates site/assets/img/og.jpg (the link-preview card) from tools/og.html.
# Needs Google Chrome and macOS `sips`. Run from anywhere: ./tools/og.sh
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
chrome="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
tmp="$(mktemp -d)"
port=8799

# og.html uses the site's fonts and photos, so serve it from inside site/
cp "$root/tools/og.html" "$root/site/_og.html"
cp "$root/tools/og-photo.webp" "$root/site/_og-photo.webp"
python3 -m http.server "$port" --bind 127.0.0.1 --directory "$root/site" >/dev/null 2>&1 &
server=$!
trap 'kill $server 2>/dev/null; wait $server 2>/dev/null || true; rm -f "$root/site/_og.html" "$root/site/_og-photo.webp"; rm -rf "$tmp"' EXIT
sleep 1

"$chrome" --headless=new --disable-gpu --hide-scrollbars --no-first-run \
  --user-data-dir="$tmp/profile" --virtual-time-budget=3000 \
  --window-size=1200,630 --screenshot="$tmp/og.png" "http://127.0.0.1:$port/_og.html" 2>/dev/null

sips -s format jpeg -s formatOptions 85 "$tmp/og.png" --out "$root/site/assets/img/og.jpg" >/dev/null
echo "Wrote site/assets/img/og.jpg"
