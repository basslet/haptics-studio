#!/usr/bin/env bash
# install_deps.sh: install this worktree's node_modules and build the native SDK.
# _tooling/bin/cc, the `cc <repo>` session launcher, shadows the C compiler on PATH and
# breaks the Rust link step, so it comes off PATH here.
# shortcut: delete this script when _tooling repays DEBT-2026-11-04-cc-shadows-c-compiler.
set -euo pipefail
PATH="$(printf %s "$PATH" | tr : '\n' | grep -v '/_tooling/bin/*$' | paste -sd: -)"
export PATH
cd "$(dirname "$0")/.."
exec yarn install --frozen-lockfile
