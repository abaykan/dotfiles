#!/usr/bin/env bash
set -e

OPENAPI_URL="$1"

if [ -z "$OPENAPI_URL" ]; then
  echo "Usage: bash a.sh <openapi.json URL>"
  exit 1
fi

# ambil scheme + host dari openapi url
BASE_URL="$(echo "$OPENAPI_URL" | sed -E 's|(https?://[^/]+).*|\1|')"

tmp=$(mktemp)

curl -kfsS "$OPENAPI_URL" -o "$tmp" || {
  echo "Gagal ambil openapi.json"
  exit 1
}

jq -r '
  .paths
  | to_entries[]
  | .key as $path
  | .value
  | to_entries[]
  | "\(.key|ascii_upcase) \($path)"
' "$tmp" | while read -r method path; do
    url="$BASE_URL$path"

    code=$(curl -k -s -o /dev/null -w "%{http_code}" -X "$method" "$url")

    if [ "$code" != "401" ]; then
        printf "[OPEN]   %-6s %s -> HTTP %s\n" "$method" "$url" "$code"
    else
        printf "[LOCKED] %-6s %s\n" "$method" "$url"
    fi
done

rm -f "$tmp"
