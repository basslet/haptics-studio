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
commit() { mkdir -p "$(dirname "$1")"; echo x >> "$1"; git add -A; git commit -qm "$1"; }

commit main/src/a.ts
git update-ref refs/remotes/upstream/main HEAD

# r[verify fork.upstream-check-passes-clean]
test_code_only_branch_passes() {
  git switch -qc clean upstream/main
  commit main/src/b.ts
  bash "$CHECK" clean >/dev/null || fail "a branch with only code changes was refused"
}

# r[verify fork.upstream-check-refuses-layer]
test_layer_file_refused_and_named() {
  git switch -qc dirty upstream/main
  commit main/src/c.ts
  commit .claude/STATUS.md
  local out rc=0
  out="$(bash "$CHECK" dirty 2>&1)" || rc=$?
  [ "$rc" -eq 1 ] || fail "a branch with a fork-layer file exited $rc"
  case "$out" in *.claude/STATUS.md*) ;; *) fail "the file was not named: $out" ;; esac
  git rm -q .claude/STATUS.md
  git commit -qm "remove it again"
  if bash "$CHECK" dirty >/dev/null 2>&1; then fail "a removed fork-layer file stays in the history a PR publishes"; fi
}

# r[verify fork.upstream-check-refuses-layer]
test_submodule_repoint_refused() {
  git switch -qc repoint upstream/main
  commit .gitmodules
  local out rc=0
  out="$(bash "$CHECK" repoint 2>&1)" || rc=$?
  [ "$rc" -eq 1 ] || fail "a branch moving .gitmodules exited $rc"
  case "$out" in *.gitmodules*) ;; *) fail ".gitmodules was not named: $out" ;; esac
}

test_branch_from_fork_main_refused() {
  git switch -qc fork-main upstream/main
  commit CLAUDE.md
  git switch -qc topic fork-main
  commit main/src/d.ts
  if bash "$CHECK" topic >/dev/null 2>&1; then fail "a branch started from the fork's main passed"; fi
}

test_unknown_branch_refused() {
  if bash "$CHECK" no-such-branch >/dev/null 2>&1; then fail "an unknown branch passed"; fi
}

test_code_only_branch_passes
test_layer_file_refused_and_named
test_submodule_repoint_refused
test_branch_from_fork_main_refused
test_unknown_branch_refused
echo "ok: upstream_pr_check"
