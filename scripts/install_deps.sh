#!/usr/bin/env bash
# install_deps.sh: put the submodule on the pinned SDK commit, install this worktree's
# node_modules and build the native SDK from that commit.
# _tooling/bin/cc, the `cc <repo>` session launcher, shadows the C compiler on PATH and
# breaks the Rust link step, so it comes off PATH here.
# shortcut: delete the PATH line when _tooling repays DEBT-2026-11-04-cc-shadows-c-compiler.
set -euo pipefail
PATH="$(printf %s "$PATH" | tr : '\n' | grep -v '/_tooling/bin/*$' | paste -sd: -)"
export PATH
cd "$(dirname "$0")/.."
# The update moves a committed, unpinned SDK change off HEAD; this leaves its commit on screen.
git submodule status third-party/haptics-sdk
git submodule update --init --recursive
refuse_sdk_changes() {
  [ -z "$(git status --porcelain --ignore-submodules=none -- third-party/haptics-sdk)" ] || {
    echo "install_deps: third-party/haptics-sdk holds changes this tree does not pin; commit and pin them, or restore them" >&2
    exit 1
  }
}
# r[impl sdk.install-refuses-uncommitted-sdk]
refuse_sdk_changes
yarn install --frozen-lockfile
# r[impl sdk.install-refuses-sdk-changed-by-yarn]
refuse_sdk_changes
# r[impl sdk.install-builds-the-pin]
# yarn skips the native build whenever a binary exists, so whatever the pin check refuses needs the force.
if ! bash scripts/check_sdk_pin.sh 2>/dev/null; then
  yarn native:update
  # r[impl sdk.install-refuses-sdk-changed-by-yarn]
  refuse_sdk_changes
  mkdir -p native/bin
  git rev-parse HEAD:third-party/haptics-sdk > native/bin/.sdk-commit
fi
