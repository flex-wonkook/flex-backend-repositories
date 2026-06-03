#!/usr/bin/env bash
# Re-pin every submodule to its remote default-branch HEAD, WITHOUT cloning.
# Mirrors the flex-frontend-repositories sync model (lazy submodules, pin-to-HEAD).
#
# Usage:
#   bin/refresh-pins.sh            # re-pin all
#   bin/refresh-pins.sh <name>...  # re-pin only the given submodule(s)
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

names=("$@")
if [ "${#names[@]}" -eq 0 ]; then
  # all submodule names from .gitmodules
  while IFS= read -r key; do
    names+=("$(printf '%s' "$key" | sed -E 's/^submodule\.(.*)\.url$/\1/')")
  done < <(git config -f .gitmodules --get-regexp '^submodule\..*\.url$' | awk '{print $1}')
fi

changed=0
for name in "${names[@]}"; do
  url=$(git config -f .gitmodules "submodule.$name.url")
  path=$(git config -f .gitmodules "submodule.$name.path")
  sha=$(git ls-remote "$url" HEAD 2>/dev/null | head -1 | cut -f1)
  if [ -z "$sha" ]; then
    echo "skip (no HEAD): $name"
    continue
  fi
  git update-index --add --cacheinfo "160000,$sha,$path"
  echo "pinned $path -> $sha"
  changed=$((changed + 1))
done

echo "---"
echo "re-pinned $changed submodule(s). Review: git status / git diff --cached"
echo "Commit with: git commit -am 'chore: refresh pins'"
