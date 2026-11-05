#!/usr/bin/env bash
# check_sdk_pin.sh: exit 0 when the stamp names the commit this tree pins and no native binary is newer than it.
# scripts/install_deps.sh writes the stamp after a forced native build.
set -euo pipefail
cd "$(dirname "$0")/.."
refuse() { echo "check_sdk_pin: $1; run scripts/install_deps.sh" >&2; exit 1; }
case "$(git submodule status third-party/haptics-sdk)" in
  -*) refuse "third-party/haptics-sdk is not initialised" ;;
  +*|U*) refuse "third-party/haptics-sdk is off the commit this tree pins" ;;
esac
pin="$(git rev-parse HEAD:third-party/haptics-sdk)"
[ "$(cat native/bin/.sdk-commit 2>/dev/null || true)" = "$pin" ] || refuse "the native SDK was not built from the pinned commit"
# shortcut: any one binary passes, even another platform's or one copied in with an old time; in install_deps.sh yarn rebuilds a missing one. Check each path if this script gets another caller.
[ -n "$(find native/bin -name HapticsSDK.node)" ] || refuse "there is no native SDK binary"
[ -z "$(find native/bin -name HapticsSDK.node -newer native/bin/.sdk-commit)" ] || refuse "a native SDK binary is newer than the stamp"
