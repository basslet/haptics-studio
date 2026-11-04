# SDK

How this repo uses the Rust native SDK, its submodule `third-party/haptics-sdk`. The SDK's own requirements live in `basslet/haptics-sdk`.

r[sdk.suite-refuses-stale-pin]
`scripts/check_sdk_pin.sh`, which `tests/run_all.sh` calls before any test, shall exit non-zero when `third-party/haptics-sdk` is uninitialised, is off the commit this tree pins, or `native/bin/.sdk-commit` does not name that commit.

The Jest suites load the built binary, and `yarn` skips the build whenever a binary exists, so a moved pointer would otherwise pass the suite on the old SDK.
