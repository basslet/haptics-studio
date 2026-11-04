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
# origin/main is upstream/main plus what the copy changes, a path no pattern names included.
for path in .gitmodules .gitignore .github/workflows/test.yml scripts/install_deps.sh scripts/later_tool.sh; do commit "$path"; done
git update-ref refs/remotes/origin/main HEAD
M=r

# r[verify upstream.check-passes-clean+2]
test_code_only_branch_passes() {
  git switch -qc clean upstream/main
  commit main/src/b.ts
  commit scripts/build_native.js
  commit main/test/docs/tests/c.ts
  mkdir -p main/src
  echo 'dev_tooling /Users/other' > main/src/c2.ts
  git add -A
  git commit -qm "near a private name"
  bash "$CHECK" clean >/dev/null || fail "a branch with only code changes was refused"
}

# r[verify upstream.check-refuses-layer]
test_each_layer_path_refused() {
  local path i=0
  for path in CLAUDE.md main/CLAUDE.md .claude/STATUS.md main/.claude/settings.local.json \
    .config/tracey/config.styx .mcp.json .githooks/pre-push docs/a.md tests/a.sh .serena/project.yml \
    .gitignore .gitmodules .github/workflows/test.yml scripts/install_deps.sh scripts/later_tool.sh \
    tmp/local_run.sh CLAUDE.local.md AGENTS.md Claude.md .Claude/x.md main/.mcp.json main/.serena/project.yml \
    main/.githooks/pre-push main/.config/tracey/config.styx \
    '.claude/plans/é.md' 'docs/é.md' 'main/é/CLAUDE.md' '.claude/a"b.md'; do
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

# r[verify upstream.check-refuses-private-name+2]
test_private_name_in_a_changed_line_refused() {
  git switch -qc named-line upstream/main
  mkdir -p main/src
  echo 'see basslet/haptics-sdk' > main/src/g.ts
  git add -A
  git commit -qm code
  refused_naming named-line 'basslet/haptics-sdk'
}

# r[verify upstream.check-refuses-private-name+2]
test_private_name_in_a_message_refused() {
  git switch -qc named-message upstream/main
  commit main/src/h.ts 'taken from basslet/haptics-sdk'
  refused_naming named-message 'basslet/haptics-sdk'
}

# r[verify upstream.check-refuses-private-name+2]
test_each_private_text_refused() {
  local text i=0
  for text in 'github.com/Basslet/x' '@basslet' 'see _tooling/bin/tracey-gate' 'DEBT-2026-11-04-no-public-fork' \
    'VE-2026-11-04-ci-private-submodule' '/Users/dbu/Repositories' 'gitty-healer' \
    "// ${M}[impl a.b]" "// ${M}[verify a.b]"; do
    i=$((i + 1))
    git switch -qc "text-$i" upstream/main
    mkdir -p main/src
    printf '%s\n' "$text" > main/src/g.ts
    git add -A
    git commit -qm code
    refused_naming "text-$i" "$text"
  done
}

# r[verify upstream.check-refuses-private-name+2]
test_private_name_git_or_grep_would_hide_refused() {
  mkdir -p main/src
  git switch -qc in-binary upstream/main
  printf 'a\0basslet/x\0b\n' > main/src/blob.bin
  git add -A
  git commit -qm code
  refused_naming in-binary 'basslet/x'
  git switch -qc in-attr upstream/main
  mkdir -p main/src
  printf '*.ts -diff\n' > .gitattributes
  echo 'see basslet/x' > main/src/k.ts
  git add -A
  git commit -qm code
  refused_naming in-attr 'basslet/x'
  git switch -qc in-latin1 upstream/main
  mkdir -p main/src
  printf 'caf\351 basslet/x\n' > main/src/l.ts
  git add -A
  git commit -qm code
  refused_naming in-latin1 'basslet/x'
}

test_unknown_branch_refused() {
  if bash "$CHECK" no-such-branch >/dev/null 2>&1; then fail "an unknown branch passed"; fi
}

# Runs last: it removes an object.
test_scan_git_cannot_finish_refused() {
  git switch -qc unreadable upstream/main
  mkdir -p main/src
  echo unreadable > main/src/m.ts
  git add -A
  git commit -qm code
  local blob
  blob="$(git rev-parse HEAD:main/src/m.ts)"
  rm -f ".git/objects/${blob:0:2}/${blob:2}"
  if bash "$CHECK" unreadable >/dev/null 2>&1; then fail "a scan git could not finish passed"; fi
}

test_no_origin_main_refused() {
  git switch -qc no-origin upstream/main
  local copy
  copy="$(git rev-parse origin/main)"
  git update-ref -d refs/remotes/origin/main
  if bash "$CHECK" no-origin >/dev/null 2>&1; then fail "a run without origin/main passed"; fi
  git update-ref refs/remotes/origin/main "$copy"
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
test_each_private_text_refused
test_private_name_git_or_grep_would_hide_refused
test_unknown_branch_refused
test_no_origin_main_refused
test_scan_git_cannot_finish_refused
echo "ok: upstream_pr_check"
