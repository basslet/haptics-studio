# Validation expectations — haptics-studio

What was not verified against a real run before merge. One row per claim. A
row is closable only by an artifact that could have falsified it. Never delete
a row — retire it by strike-through naming the PR/date that closed it.

| ID | What the next real run must show | Artifact and field | Source | Status |
|---|---|---|---|---|
| VE-2026-11-04-ci-private-submodule | The checkout step of the `Tests` workflow fetches the private `basslet/haptics-sdk` with the credential the operator chose, and the job gets past that step. | The first `Tests` run after the token line, its checkout step log | `.gitmodules` repointed to that repo. Run 41861038969 on PR #1, 2026-11-04: FAILED, `fatal: repository 'https://github.com/basslet/haptics-sdk/' not found`; `main` is green with Meta's URL. The operator chose a token in the repo secret `SDK_CHECKOUT_TOKEN`, 2026-11-04 | OPEN |
| VE-2026-11-04-upstream-sync | The first sync from Meta, after the SDK repo's, ends with `third-party/haptics-sdk` on that repo's merged commit and `tests/run_all.sh` green. | That sync PR's `git ls-tree HEAD third-party/haptics-sdk` and the suite's exit code | `CLAUDE.md` "Sync from Meta"; never run | OPEN |
