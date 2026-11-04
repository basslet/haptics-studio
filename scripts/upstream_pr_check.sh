#!/usr/bin/env bash
# upstream_pr_check.sh <branch>: refuse a branch bound for meta/haptics-studio if it carries
# a tooling-layer file or names our private repos. A PR publishes every commit on its branch,
# so this reads all commits since upstream/main, not only the final diff, and a merge commit's
# change against its first parent. Run it from a checkout of origin/main: the branch has no copy.
# Exit: 0 clean, 1 refused, 2 usage; a git failure (unknown branch, no upstream remote) exits non-zero.
set -euo pipefail

LAYER='(^|/)CLAUDE\.md$|(^|/)\.claude/|^\.config/tracey/|^\.mcp\.json$|^\.githooks/|^docs/|^tests/|^\.serena/|^\.gitignore$|^\.gitmodules$|^third-party/haptics-sdk$|^\.github/workflows/test\.yml$|^scripts/(install_deps|upstream_pr_check|check_sdk_pin)\.sh$'

# r[impl upstream.check-passes-clean]
# r[impl upstream.check-refuses-layer]
# r[impl upstream.check-refuses-private-name]
check() {
  local files hits named
  files="$(git log --diff-merges=first-parent --no-renames --format= --name-only "upstream/main..$1" --)"
  hits="$(printf '%s\n' "$files" | grep -E "$LAYER" | sort -u || true)"
  if [ -n "$hits" ]; then
    echo "upstream_pr_check: $1 carries tooling-layer files; start the branch from upstream/main:" >&2
    printf '  %s\n' "$hits" >&2
    exit 1
  fi
  named="$(git log -p --diff-merges=first-parent --format=%B "upstream/main..$1" -- | grep 'basslet/' || true)"
  if [ -n "$named" ]; then
    echo "upstream_pr_check: $1 names our private repos in a commit message or a changed line:" >&2
    printf '  %s\n' "$named" >&2
    exit 1
  fi
  echo "upstream_pr_check: $1 carries no tooling-layer file and names no private repo"
}

[ "$#" -eq 1 ] || { echo "usage: upstream_pr_check.sh <branch>" >&2; exit 2; }
check "$1"
