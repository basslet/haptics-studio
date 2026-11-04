# Validation expectations — haptics-studio

What was not verified against a real run before merge. One row per claim. A
row is closable only by an artifact that could have falsified it. Never delete
a row — retire it by strike-through naming the PR/date that closed it.

| ID | What the next real run must show | Artifact and field | Source | Status |
|---|---|---|---|---|
| VE-2026-11-04-ci-private-submodule | `.github/workflows/test.yml`'s checkout step, with `submodules: recursive` and the default token, fetches the private `basslet/haptics-sdk`. | The first PR's `Tests` run, its checkout step log | `.gitmodules` repointed to that repo. Run 41861038969 on PR #1, 2026-11-04: FAILED, `fatal: repository 'https://github.com/basslet/haptics-sdk/' not found`; `main` is green with Meta's URL | OPEN: the fix is the operator's choice |
| VE-2026-11-04-upstream-sync | The first sync from Meta, after the SDK repo's, ends with `third-party/haptics-sdk` on that repo's merged commit and `tests/run_all.sh` green. | That sync PR's `git ls-tree HEAD third-party/haptics-sdk` and the suite's exit code | `CLAUDE.md` "Sync from Meta"; never run | OPEN |
