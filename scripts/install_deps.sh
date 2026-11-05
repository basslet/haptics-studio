#!/usr/bin/env bash
# install_deps.sh: put the submodule on the pinned SDK commit, install this worktree's
# node_modules and build the native SDK from that commit.
set -euo pipefail
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
refuse_sdk_changes
yarn install --frozen-lockfile
refuse_sdk_changes
# yarn skips the native build whenever a binary exists, so whatever the pin check refuses needs the force.
if ! bash scripts/check_sdk_pin.sh 2>/dev/null; then
  yarn native:update
  refuse_sdk_changes
  mkdir -p native/bin
  git rev-parse HEAD:third-party/haptics-sdk > native/bin/.sdk-commit
fi
