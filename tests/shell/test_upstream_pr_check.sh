#!/usr/bin/env bash
# Tests scripts/upstream_pr_check.sh in a temp repo: no network, no real git config.
set -euo pipefail
CHECK="$(cd "$(dirname "$0")/../.." && pwd)/scripts/upstream_pr_check.sh"
T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT
export HOME="$T/home" GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.com GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.com
mkdir -p "$HOME" "$T/r"
cd "$T/r"
git init -q -b main .

fail() { echo "FAIL: $1"; exit 1; }
commit() { mkdir -p "$(dirname "$1")"; echo x >> "$1"; git add -A; git commit -qm "${2:-$1}"; }
refused_naming() {
  local out rc=0
  out="$(bash "$CHECK" "$1" 2>&1)" || rc=$?
  [ "$rc" -eq 1 ] || fail "$1 exited $rc, expected a refusal: $out"
  case "$out" in *"$2"*) ;; *) fail "$1: '$2' was not named: $out" ;; esac
}

commit main/src/a.ts
commit .gitmodules
git update-ref refs/remotes/upstream/main HEAD

# r[verify upstream.check-passes-clean]
test_code_only_branch_passes() {
  git switch -qc clean upstream/main
  commit main/src/b.ts
  commit scripts/build_native.js
  commit main/test/docs/tests/c.ts
  bash "$CHECK" clean >/dev/null || fail "a branch with only code changes was refused"
}

# r[verify upstream.check-refuses-layer]
test_each_layer_path_refused() {
  local path i=0
  for path in CLAUDE.md main/CLAUDE.md .claude/STATUS.md main/.claude/settings.local.json \
    .config/tracey/config.styx .mcp.json .githooks/pre-push docs/a.md tests/a.sh .serena/project.yml \
    .gitignore .gitmodules .github/workflows/test.yml \
    scripts/install_deps.sh scripts/upstream_pr_check.sh scripts/check_sdk_pin.sh; do
    i=$((i + 1))
    git switch -qc "layer-$i" upstream/main
    commit "$path"
    refused_naming "layer-$i" "$path"
  done
}

# r[verify upstream.check-refuses-layer]
test_file_a_later_commit_removes_refused() {
  git switch -qc removed upstream/main
  commit .claude/STATUS.md
  git rm -q .claude/STATUS.md
  git commit -qm "remove it again"
  refused_naming removed .claude/STATUS.md
}

# r[verify upstream.check-refuses-layer]
test_file_only_in_a_merge_commit_refused() {
  git switch -qc merge-side upstream/main
  commit main/src/e.ts
  git switch -qc merged upstream/main
  commit main/src/f.ts
  git merge -q --no-commit --no-ff merge-side >/dev/null
  echo x > CLAUDE.md
  git add CLAUDE.md
  git commit -qm "merge side"
  refused_naming merged CLAUDE.md
}

# r[verify upstream.check-refuses-layer]
test_submodule_pointer_refused() {
  git switch -qc pointer upstream/main
  git update-index --add --cacheinfo "160000,$(git rev-parse HEAD),third-party/haptics-sdk"
  git commit -qm "move the pointer"
  refused_naming pointer third-party/haptics-sdk
}

# r[verify upstream.check-refuses-layer]
test_renamed_layer_file_refused() {
  git switch -qc renamed upstream/main
  git mv .gitmodules modules.txt
  git commit -qm "rename"
  refused_naming renamed .gitmodules
}

# r[verify upstream.check-refuses-layer]
test_branch_from_origin_main_refused() {
  git switch -qc origin-main upstream/main
  commit CLAUDE.md
  git switch -qc topic origin-main
  commit main/src/d.ts
  refused_naming topic CLAUDE.md
}

# r[verify upstream.check-refuses-private-name]
test_private_name_in_a_changed_line_refused() {
  git switch -qc named-line upstream/main
  mkdir -p main/src
  echo 'see basslet/haptics-sdk' > main/src/g.ts
  git add -A
  git commit -qm code
  refused_naming named-line 'basslet/haptics-sdk'
}

# r[verify upstream.check-refuses-private-name]
test_private_name_in_a_message_refused() {
  git switch -qc named-message upstream/main
  commit main/src/h.ts 'taken from basslet/haptics-sdk'
  refused_naming named-message 'basslet/haptics-sdk'
}

test_unknown_branch_refused() {
  if bash "$CHECK" no-such-branch >/dev/null 2>&1; then fail "an unknown branch passed"; fi
}

test_code_only_branch_passes
test_each_layer_path_refused
test_file_a_later_commit_removes_refused
test_file_only_in_a_merge_commit_refused
test_submodule_pointer_refused
test_renamed_layer_file_refused
test_branch_from_origin_main_refused
test_private_name_in_a_changed_line_refused
test_private_name_in_a_message_refused
test_unknown_branch_refused
echo "ok: upstream_pr_check"
