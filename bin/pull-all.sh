#!/usr/bin/env bash
# Update every INITIALIZED submodule to its remote default branch (fast-forward only), in parallel.
# Lazy/uninitialized submodules ('-' in `git submodule status`) are skipped.
# Local changes are never clobbered — non-fast-forward repos are reported and left as-is.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

git submodule status | awk '$1 !~ /^-/ {print $2}' | xargs -P 8 -I R sh -c '
  d="R"
  def=$(git -C "$d" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed "s#^origin/##")
  [ -z "$def" ] && def=$(git -C "$d" remote show origin 2>/dev/null | sed -n "s/.*HEAD branch: //p")
  [ -z "$def" ] && def=main
  git -C "$d" fetch --quiet origin "$def" 2>/dev/null || { echo "FETCH-FAIL  $d"; exit 0; }
  git -C "$d" checkout --quiet "$def" 2>/dev/null || { echo "SKIP        $d (no $def / detached / local changes)"; exit 0; }
  if git -C "$d" merge --ff-only --quiet "origin/$def" 2>/dev/null; then
    echo "ok          $d ($def)"
  else
    echo "SKIP        $d (not fast-forward — local commits/changes)"
  fi
'
echo "---"
echo "init된 서브모듈을 각 default branch 최신으로 갱신 완료."
echo "부모 핀까지 최신화하려면: bin/refresh-pins.sh && git commit -am 'chore: refresh pins'"
