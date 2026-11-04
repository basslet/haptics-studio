# SDK

How this repo uses the Rust native SDK, its submodule `third-party/haptics-sdk`. The SDK's own requirements live in `basslet/haptics-sdk`.

r[sdk.suite-refuses-stale-pin]
`scripts/check_sdk_pin.sh`, which `tests/run_all.sh` calls before any test, shall exit non-zero when `third-party/haptics-sdk` is uninitialised, is off the commit this tree pins, or `native/bin/.sdk-commit` does not name that commit.

The Jest suites load the built binary, and `yarn` skips the build whenever a binary exists, so a moved pointer would otherwise pass the suite on the old SDK.

r[sdk.suite-refuses-rebuilt-binary]
`scripts/check_sdk_pin.sh` shall exit non-zero when `native/bin` holds no `HapticsSDK.node`, or holds one newer than `native/bin/.sdk-commit`.

A build by hand from another SDK commit leaves the stamp in place, so the stamp alone does not say what the binary holds.

r[sdk.install-builds-the-pin]
`scripts/install_deps.sh` shall leave `third-party/haptics-sdk` on the commit this tree pins, in a tree `scripts/check_sdk_pin.sh` accepts.

r[sdk.install-refuses-uncommitted-sdk]
`scripts/install_deps.sh` shall exit non-zero, without running `yarn` or moving the stamp, when `third-party/haptics-sdk` holds an edit, an untracked file or a staged pointer.

The stamp names the pinned commit, so a binary built from anything else would pass the pin check once the tree is restored.
