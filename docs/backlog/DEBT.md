# Parked debt — haptics-studio

Anything out of scope, a known follow-up, or deliberately not fixed. Never
delete a row — retire it by strike-through naming the PR/date that closed it.

| ID | What and where | Where parked | Repay trigger | Status |
|---|---|---|---|---|
| DEBT-2026-11-04-no-public-fork | No public fork of `meta/haptics-studio` exists, so a change for Meta has nowhere to go, and whether this copy stays standalone or becomes a fork is open. | `chore/claude-setup`, 2026-11-04, while the operator's colleagues give feedback | The operator decides fork or standalone | OPEN |
| DEBT-2026-11-04-lint-broken-upstream | `yarn main:lint` and `yarn frontend:lint` exit 2 with "No files matching the pattern", so ESLint checks nothing and `tests/run_all.sh` does not call it. | `chore/claude-setup`, 2026-11-04 | Upstream fixes the scripts, or this copy starts changing `main/src` or `frontend/src` in earnest | OPEN |
| DEBT-2026-11-04-frontend-typecheck-red | `yarn frontend:typecheck` exits 2 on upstream's code, so `tests/run_all.sh` runs only `yarn main:typecheck`. | `chore/claude-setup`, 2026-11-04 | Upstream fixes it, or this copy starts changing `frontend/src` in earnest | OPEN |
| DEBT-2026-11-04-audit-not-local | `yarn audit:ci` needs the network, so `tests/run_all.sh` skips it and only `.github/workflows/test.yml` runs it. | `chore/claude-setup`, 2026-11-04 | A dependency change that must be audited before its PR | OPEN |
| DEBT-2026-11-04-no-e2e-in-suite | `yarn test:e2e` (Playwright) needs a packaged build, so `tests/run_all.sh` does not run it. | `chore/claude-setup`, 2026-11-04 | The first change to the packaged app's behaviour | OPEN |
| DEBT-2026-11-04-meta-branding | `build.appId` `com.meta.HapticsStudio`, author Meta Platforms and `assets/logo-*.png` remain, and `licenses.md` is not audited. The code is MIT; a trademark grant is not established. | `chore/claude-setup`, 2026-11-04 | Before any public release or public repo | OPEN |
| DEBT-2026-11-04-leftover-public-fork | `basslet/haptics-studio-public-fork` is a public fork of `meta/haptics-studio` with nothing of ours in it, renamed aside so that this private copy could take the name, because the `gh` login lacks the `delete_repo` scope. | this setup, 2026-11-04 | The operator runs `_tooling/tmp/local_run.sh` or deletes it on the repo's settings page | OPEN |
