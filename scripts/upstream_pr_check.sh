#!/usr/bin/env bash
# upstream_pr_check.sh <branch>: refuse a branch bound for meta/haptics-studio if it carries
# a tooling-layer file or private text. A PR publishes every commit on its branch,
# so this reads all commits since upstream/main, not only the final diff, and a merge commit's
# change against its first parent. Run it from a checkout of origin/main: the branch has no copy.
# Exit: 0 clean, 1 refused, 2 usage; a git failure (unknown branch, no upstream or origin remote) exits non-zero.
# shortcut: a merge of newer upstream/main that touches a refused path is refused too; rebase the branch.
# shortcut: an honest change for Meta to the SDK pointer or to a file this copy edits is refused too; read that diff by hand, and narrow the list when the first one is bound for Meta.
# shortcut: a patch's unchanged context lines are scanned too, so a private word in Meta's own text would refuse a clean branch; Meta's history held none at 88565a8, so scan only + and - lines when one appears.
set -euo pipefail
export LC_ALL=C   # a non-UTF-8 byte must not hide a line from grep

# Paths a tool writes whether or not origin/main holds them yet, at any depth and in any case.
# What origin/main itself adds or changes is read from git.
LAYER='(^|/)(CLAUDE|CLAUDE\.local|AGENTS)\.md$|(^|/)\.(claude|serena|githooks)/|(^|/)\.config/tracey/|(^|/)\.mcp\.json$|^(docs|tests|tmp)/|^third-party/haptics-sdk$'
# The left edge keeps Meta's dev_tooling and CVE-2026-... clear.
PRIVATE='basslet|/Users/dbu|gitty-healer|(^|[^[:alnum:]])(_tooling|(DEBT|VE)-20[0-9])|r\[(impl|verify) '

# r[impl upstream.check-passes-clean+2]
# r[impl upstream.check-refuses-layer]
# r[impl upstream.check-refuses-private-name+3]
check() {
  local files copy hits named
  files="$(git log -z --diff-merges=first-parent --no-renames --format= --name-only "upstream/main..$1" -- | tr '\0' '\n')"
  copy="$(git diff -z --name-only upstream/main...origin/main | tr '\0' '\n')"
  hits="$( { printf '%s\n' "$files" | grep -iE "$LAYER" || true
    comm -12 <(printf '%s\n' "$files" | sort -u) <(printf '%s\n' "$copy" | sort -u); } | sed '/^$/d' | sort -u)"
  if [ -n "$hits" ]; then
    echo "upstream_pr_check: $1 carries tooling-layer files; start the branch from upstream/main:" >&2
    printf '  %s\n' "$hits" >&2
    exit 1
  fi
  # --text: neither a binary file nor a branch's own -diff attribute hides a line. grep's 1 is no match;
  # any other failure, git's included, stops the script.
  named="$(git log -p --text --diff-merges=first-parent --format=%B "upstream/main..$1" -- | tr -d '\0' | { grep -iE "$PRIVATE" || [ $? -eq 1 ]; })"
  if [ -n "$named" ]; then
    echo "upstream_pr_check: $1 carries private text in a commit message or a patch:" >&2
    printf '  %s\n' "$named" >&2
    exit 1
  fi
  echo "upstream_pr_check: $1 carries no tooling-layer file and no private text"
}

[ "$#" -eq 1 ] || { echo "usage: upstream_pr_check.sh <branch>" >&2; exit 2; }
check "$1"
