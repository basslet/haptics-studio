#!/usr/bin/env bash
# Tests scripts/install_deps.sh with a local submodule and a fake yarn: no network, no real git config.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT
export HOME="$T/home" GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null GIT_ALLOW_PROTOCOL=file
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.com GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.com
export YARN_LOG="$T/yarn.log"
mkdir -p "$HOME" "$T/bin" "$T/sdk" "$T/app/scripts"
cat > "$T/bin/yarn" <<'FAKE'
#!/usr/bin/env bash
echo "$*" >> "$YARN_LOG"
if [ "$1" = native:update ]; then
  mkdir -p native/bin/mac/development
  echo built > native/bin/mac/development/HapticsSDK.node
fi
FAKE
chmod +x "$T/bin/yarn"
export PATH="$T/bin:$PATH"
git -C "$T/sdk" init -q -b main .
echo one > "$T/sdk/f"
git -C "$T/sdk" add f
git -C "$T/sdk" commit -qm one
echo two > "$T/sdk/f"
git -C "$T/sdk" commit -qam two
cd "$T/app"
git init -q -b main .
git submodule --quiet add "$T/sdk" third-party/haptics-sdk
cp "$ROOT/scripts/install_deps.sh" "$ROOT/scripts/check_sdk_pin.sh" scripts/
printf 'native/bin\n' > .gitignore
git add -A
git commit -qm app
PIN="$(git rev-parse HEAD:third-party/haptics-sdk)"
SDK=third-party/haptics-sdk

fail() { echo "FAIL: $1"; exit 1; }
install() { : > "$YARN_LOG"; bash scripts/install_deps.sh >/dev/null 2>&1; }
refused() {
  local out rc=0 before
  before="$(cat native/bin/.sdk-commit)"
  : > "$YARN_LOG"
  out="$(bash scripts/install_deps.sh 2>&1)" || rc=$?
  [ "$rc" -eq 1 ] || fail "$1: exited $rc, expected a refusal: $out"
  case "$out" in *"$SDK holds changes"*) ;; *) fail "$1: the SDK was not named: $out" ;; esac
  [ ! -s "$YARN_LOG" ] || fail "$1: yarn ran before the refusal"
  [ "$(cat native/bin/.sdk-commit)" = "$before" ] || fail "$1: the stamp moved"
}

# r[verify sdk.install-builds-the-pin]
test_absent_stamp_builds_and_stamps_the_pin() {
  install || fail "a clean tree was refused"
  grep -qx native:update "$YARN_LOG" || fail "no forced build"
  [ "$(cat native/bin/.sdk-commit)" = "$PIN" ] || fail "the stamp does not name the pin"
  bash scripts/check_sdk_pin.sh || fail "the pin check refused the result"
}

# r[verify sdk.install-builds-the-pin]
test_tree_in_step_does_not_rebuild() {
  install || fail "a tree in step was refused"
  if grep -qx native:update "$YARN_LOG"; then fail "a tree in step was rebuilt"; fi
}

# r[verify sdk.install-builds-the-pin]
test_submodule_off_pin_goes_back_to_the_pin() {
  git -C "$SDK" checkout -q HEAD~1
  install || fail "a clean submodule off the pin was refused"
  [ "$(git -C "$SDK" rev-parse HEAD)" = "$PIN" ] || fail "the submodule did not return to the pin"
}

# r[verify sdk.install-refuses-uncommitted-sdk]
test_edited_sdk_refused() {
  echo edited > "$SDK/f"
  refused "an edited SDK file"
  git -C "$SDK" checkout -q -- f
}

# r[verify sdk.install-refuses-uncommitted-sdk]
test_ignore_setting_does_not_hide_an_edit() {
  git config "submodule.$SDK.ignore" dirty
  echo edited > "$SDK/f"
  refused "an edited SDK file under an ignore setting"
  git -C "$SDK" checkout -q -- f
  git config --unset "submodule.$SDK.ignore"
}

# r[verify sdk.install-refuses-uncommitted-sdk]
test_untracked_sdk_file_refused() {
  echo new > "$SDK/g"
  refused "an untracked SDK file"
  rm "$SDK/g"
}

# r[verify sdk.install-refuses-uncommitted-sdk]
test_staged_pointer_refused() {
  git update-index --cacheinfo "160000,$(git -C "$SDK" rev-parse HEAD~1),$SDK"
  refused "a staged pointer"
  git reset -q
  git submodule --quiet update
}

test_absent_stamp_builds_and_stamps_the_pin
test_tree_in_step_does_not_rebuild
test_submodule_off_pin_goes_back_to_the_pin
test_edited_sdk_refused
test_ignore_setting_does_not_hide_an_edit
test_untracked_sdk_file_refused
test_staged_pointer_refused
echo "ok: install_deps"
