#!/usr/bin/env bash
# upstream_pr_check.sh <branch>: refuse a branch bound for meta/haptics-studio if it
# carries a fork-layer file. A PR publishes every commit on its branch, so this reads
# all commits since upstream/main, not only the final diff.
# Exit: 0 clean, 1 refused, 2 usage; a git failure (unknown branch, no upstream remote) exits non-zero.
set -euo pipefail

# r[impl fork.upstream-check-passes-clean]
# r[impl fork.upstream-check-refuses-layer]
check() {
  local files hits
  files="$(git log --format= --name-only "upstream/main..$1" --)"
  hits="$(printf '%s\n' "$files" | grep -E '^(CLAUDE\.md|\.claude/|\.config/tracey/|\.mcp\.json|\.githooks/|docs/|tests/|scripts/checks/|scripts/(install_deps|upstream_pr_check)\.sh|\.gitmodules)' | sort -u || true)"
  if [ -n "$hits" ]; then
    echo "upstream_pr_check: $1 carries fork-layer files; start the branch from upstream/main:" >&2
    printf '  %s\n' "$hits" >&2
    exit 1
  fi
  echo "upstream_pr_check: $1 carries no fork-layer file"
}

[ "$#" -eq 1 ] || { echo "usage: upstream_pr_check.sh <branch>" >&2; exit 2; }
check "$1"
