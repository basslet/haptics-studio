# haptics-studio — Claude Code Guide

The operator's long-term copy of Meta's Haptics Studio: an Electron and TypeScript desktop app with a Rust native SDK, for designing haptics from audio on macOS and Windows.

## Sibling repo

[`basslet/haptics-sdk`](https://github.com/basslet/haptics-sdk) holds the Rust native SDK, this repo's submodule `third-party/haptics-sdk`. It is a private copy of `meta/meta-haptics-sdk` with its own `CLAUDE.md`, requirements and suite.

- A Rust change happens there. This repo then moves the submodule pointer to the merged commit in a second PR.
- This repo's tracey covers only its own TypeScript and shell. Rust requirements are traced in the SDK repo, because `tracey-lint` cannot see inside a submodule.
- Each checkout from before `.gitmodules` named that repo, linked worktrees included, runs `git submodule sync --recursive` once.

## Copy model

`basslet/haptics-studio` is a private copy with the full history of `meta/haptics-studio`, not a GitHub fork: GitHub keeps every fork of a public repo public. A change for Meta needs a real public fork, and creating one is the operator's decision (`DEBT-2026-11-04-no-public-fork` in `docs/backlog/DEBT.md`).

- `upstream` is `https://github.com/meta/haptics-studio.git`, read only. `origin` is `basslet/haptics-studio`.
- `origin/main` is `upstream/main` plus the tooling layer: `CLAUDE.md`, `.claude/`, `.config/tracey/`, `.mcp.json`, `.githooks/`, `docs/`, `tests/`, `scripts/install_deps.sh`, `scripts/upstream_pr_check.sh`, `scripts/check_sdk_pin.sh`, `.gitmodules` (it names the SDK copy, not Meta's repo), the pointer `third-party/haptics-sdk`, the checkout token in `.github/workflows/test.yml`, and the marked block at the end of `.gitignore`. `build.files` in `package.json` is an allow-list, so the packaged app ships none of it.
- No mass reformat and no style edits to upstream's files: each one conflicts at every sync.

## Sync from Meta

Sync the SDK repo first (its `CLAUDE.md`), then this one. Sync through a PR with a merge commit, never a squash: a squash loses the merge base and the next sync conflicts on everything.

```bash
git fetch upstream
git switch -c sync/upstream-<date> origin/main
git merge upstream/main     # may stop with a conflict on third-party/haptics-sdk; the next lines resolve it
git -C third-party/haptics-sdk fetch origin
git -C third-party/haptics-sdk checkout <sdk-commit>   # the commit merged in the SDK repo
git add third-party/haptics-sdk
git commit                  # finishes a stopped merge, or records the pointer after a clean one; skip if nothing changed
scripts/install_deps.sh
bash tests/run_all.sh
git push -u origin sync/upstream-<date>
```

The pointer always ends on the SDK repo's merged commit, never on Meta's. A conflict in `.gitmodules` keeps our URL.

## Work bound for Meta

A PR publishes every commit on its branch, so these branches start from `upstream/main`, never from `origin/main`.

```bash
git switch --no-track -c <topic> upstream/main
yarn test:all
```

From a checkout of `origin/main`, which holds the check and needs only the branch name:

```bash
scripts/upstream_pr_check.sh <topic>
```

`tests/run_all.sh` and the push receipt do not exist on such a branch, and it pushes to the public fork, not to `origin`. Such a branch never moves the submodule pointer: Meta cannot read the SDK copy. Meta imports PRs by hand and requires its CLA (`CONTRIBUTING.md`).

## New clone

```bash
git clone https://github.com/basslet/haptics-studio.git && cd haptics-studio
git remote add upstream https://github.com/meta/haptics-studio.git && git fetch upstream
git remote set-url --push upstream no-push   # upstream is read only
gh repo set-default basslet/haptics-studio   # without it, gh targets Meta's public repo
git config core.hooksPath .githooks          # the pre-push guard
scripts/install_deps.sh                      # needs read access to the private SDK repo
```

## Environment

- Node 24 or later, yarn 1, Rust stable with the `aarch64-apple-darwin` and `x86_64-apple-darwin` targets.
- This repo has no venv: `.claude/context/builder.md` holds the Node mechanics.
- `scripts/install_deps.sh` puts the submodule on the pinned commit, installs `node_modules` and builds the native SDK from that commit, and stamps the commit in `native/bin/.sdk-commit`. Run it after any move of the pointer: `tests/run_all.sh` refuses to start otherwise. Plain `yarn install` fails under `_tooling/bin` on `PATH` (`_tooling` `DEBT-2026-11-04-cc-shadows-c-compiler`).

## Suite

`bash tests/run_all.sh` runs both Jest suites, the main-process typecheck, `tests/shell/`, and `_tooling/bin/tracey-gate`; a green run on a clean tree writes the push receipt `.githooks/pre-push` asks for.

`.github/workflows/test.yml` is upstream's CI, on `macos-latest`. It runs the Jest suites and `yarn audit:ci`, and each run spends paid minutes while the repo is private. Its checkout reads the private SDK with the repo secret `SDK_CHECKOUT_TOKEN`, a read-only token the operator holds and rotates (`DEBT-2026-11-04-sdk-checkout-token-expiry`); a PR from a fork or from Dependabot gets no secret, so its checkout fails.

## Code conventions

- Match the surrounding code; ESLint does not run (`DEBT-2026-11-04-lint-broken-upstream`).
- Requirement markers in TypeScript: `// r[impl <id>]` or `// r[verify <id>]` directly above a function. A shell script uses `#`.
- 400 lines per file and 60 per function apply to the files this copy adds, not to upstream's.

## Registers (park ⇒ register, can't verify ⇒ register)

Two tracked files, both governed by the global "Two registers" rule:

| File | Holds | Row is written |
|---|---|---|
| `docs/backlog/DEBT.md` | Parked debt — out of scope, known follow-up, deliberately unfixed | In the PR that parks it |
| `docs/backlog/EXPECTATIONS.md` | What the next live run must show for a change not verified against a real run before merge | In the PR that ships the change |

Never delete a row; retire it by strike-through naming the closing PR and date. Reviewers reject a PR that defers or parks without its row.
