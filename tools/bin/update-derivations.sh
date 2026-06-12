#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
SEARCH_PATHS=("$ROOT/modules/derivations")

if ! command -v nix-prefetch-github &>/dev/null; then
  echo ":: nix-prefetch-github not found. Install it with:"
  echo "   nix shell nixpkgs#nix-prefetch-scripts -c bash"
  exit 1
fi

for dir in "${SEARCH_PATHS[@]}"; do
  [[ -d "$dir" ]] || continue

  for file in "$dir"/*.nix; do
    [[ -f "$file" ]] || continue

    name="$(basename "$file" .nix)"
    echo ":: $name"

    owner=$(grep -oP 'owner\s*=\s*"\K[^"]+' "$file" | head -1 || true)
    repo=$(grep -oP 'repo\s*=\s*"\K[^"]+'  "$file" | head -1 || true)

    if [[ -z "$owner" || -z "$repo" ]]; then
      echo "   skip (no fetchFromGitHub owner/repo)"
      continue
    fi

    old_rev=$(grep -oP 'rev\s*=\s*"\K[^"]+' "$file" | head -1 || true)

    result=$(nix-prefetch-github "$owner" "$repo" 2>/dev/null)
    new_rev=$(echo "$result" | jq -r '.rev // empty')
    new_hash=$(echo "$result" | jq -r '.hash // empty')

    if [[ -z "$new_rev" || -z "$new_hash" ]]; then
      echo "   fail (nix-prefetch-github returned no result)"
      continue
    fi

    if [[ "$old_rev" == "$new_rev" ]]; then
      echo "   up-to-date ($(echo "$new_rev" | head -c 12))"
      continue
    fi

    echo "   $old_rev -> $new_rev"
    sed -i "s|rev = \"$old_rev\"|rev = \"$new_rev\"|" "$file"

    old_hash=$(grep -oP '(?:sha256|hash)\s*=\s*"\K[^"]+' "$file" | head -1 || true)
    if [[ -n "$old_hash" ]]; then
      sed -i "s|$old_hash|$new_hash|" "$file"
    fi

    echo "   updated (hash: $new_hash)"
  done
done
