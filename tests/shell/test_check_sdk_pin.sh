#!/usr/bin/env bash
# Tests scripts/check_sdk_pin.sh in a temp repo with a local submodule: no network, no real git config.
set -euo pipefail
SCRIPT="$(cd "$(dirname "$0")/../.." && pwd)/scripts/check_sdk_pin.sh"
T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT
export HOME="$T/home" GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.com GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.com
mkdir -p "$HOME" "$T/sdk" "$T/app/scripts"
git -C "$T/sdk" init -q -b main .
git -C "$T/sdk" commit -q --allow-empty -m one
git -C "$T/sdk" commit -q --allow-empty -m two
cd "$T/app"
git init -q -b main .
git -c protocol.file.allow=always submodule --quiet add "$T/sdk" third-party/haptics-sdk
cp "$SCRIPT" scripts/check_sdk_pin.sh
git add -A
git commit -qm app
PIN="$(git rev-parse HEAD:third-party/haptics-sdk)"

fail() { echo "FAIL: $1"; exit 1; }
BINARY=native/bin/mac/development/HapticsSDK.node
built() { mkdir -p "$(dirname "$BINARY")"; echo x > "$BINARY"; touch -t 202001010000 "$BINARY"; }
stamp() { mkdir -p native/bin; printf '%s\n' "$1" > native/bin/.sdk-commit; }
refused_with() {
  local out rc=0
  out="$(bash scripts/check_sdk_pin.sh 2>&1)" || rc=$?
  [ "$rc" -eq 1 ] || fail "exited $rc, expected a refusal naming '$1': $out"
  case "$out" in *"$1"*) ;; *) fail "'$1' was not named: $out" ;; esac
}

# r[verify sdk.suite-refuses-stale-pin]
test_in_step_passes() {
  built
  stamp "$PIN"
  bash scripts/check_sdk_pin.sh || fail "a tree in step with its pin was refused"
}

# r[verify sdk.suite-refuses-stale-pin]
test_absent_stamp_refused() {
  rm native/bin/.sdk-commit
  refused_with "not built from the pinned commit"
}

# r[verify sdk.suite-refuses-stale-pin]
test_stale_stamp_refused() {
  stamp 0000000000000000000000000000000000000000
  refused_with "not built from the pinned commit"
}

# r[verify sdk.suite-refuses-stale-pin]
test_submodule_off_pin_refused() {
  stamp "$PIN"
  git -C third-party/haptics-sdk checkout -q HEAD~1
  refused_with "off the commit"
  git -C third-party/haptics-sdk checkout -q "$PIN"
}

# r[verify sdk.suite-refuses-rebuilt-binary]
test_missing_binary_refused() {
  stamp "$PIN"
  rm "$BINARY"
  refused_with "no native SDK binary"
  built
}

# r[verify sdk.suite-refuses-rebuilt-binary]
test_binary_rebuilt_after_the_stamp_refused() {
  stamp "$PIN"
  touch -t 209901010000 "$BINARY"
  refused_with "newer than the stamp"
  built
}

# r[verify sdk.suite-refuses-stale-pin]
test_uninitialised_submodule_refused() {
  git submodule --quiet deinit -f third-party/haptics-sdk
  refused_with "not initialised"
}

test_in_step_passes
test_absent_stamp_refused
test_stale_stamp_refused
test_submodule_off_pin_refused
test_missing_binary_refused
test_binary_rebuilt_after_the_stamp_refused
test_uninitialised_submodule_refused
echo "ok: check_sdk_pin"
