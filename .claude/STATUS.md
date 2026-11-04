# haptics-studio — status

Artifact: none   Updated: 2026-11-04   Verified against: branch `chore/claude-setup`

## Goal

A private long-term copy of `meta/haptics-studio` that the operator's agents work in under the shared tooling, with its Rust SDK in the sibling repo `basslet/haptics-sdk`.

## Position

The copy holds upstream's `main`. `chore/claude-setup` adds the tooling layer, the requirements for the upstream check and the SDK pin, the repoint of `.gitmodules` to the SDK copy, and CI's token to read it. Whether this copy stays standalone or becomes a public fork is open with the operator's colleagues.

## Decisions taken

| date | decision | by |
|---|---|---|
| 2026-11-04 | A private copy, not a fork, until the colleagues report | operator |
| 2026-11-04 | The SDK is its own repo, traced at its own root | operator |
| 2026-11-04 | `.gitmodules` points at the SDK copy | agent |
| 2026-11-04 | CI reads the private SDK with a read-only token in the repo secret `SDK_CHECKOUT_TOKEN` | operator |
| 2026-11-04 | The token lists both private repos with Contents read-only | operator |
| 2026-11-04 | CI's checkout does not leave the token in `.git/config` | agent |
| 2026-11-04 | The upstream check reads what `origin/main` changes from git, plus a list of tool paths at any depth and in any case | agent |
| 2026-11-04 | It refuses our accounts, `_tooling`, this host's home, register IDs and tracey markers; no commit in Meta's history at `88565a8` matches | agent |
| 2026-11-04 | It stays a manual check until a public fork exists; a merge of newer Meta code touching a refused path stays refused, so rebase | agent |
| 2026-11-04 | The suite refuses a missing native binary or one newer than its stamp, as its own requirement | agent |
| 2026-11-04 | `install_deps.sh` refuses an SDK tree with changes this tree does not pin, so the stamp stays true | agent |
| 2026-11-04 | Pushes to PR #1 are grouped, because each spends paid CI minutes | agent |

## In flight

| workstream | state | owner | blocked on |
|---|---|---|---|
| Tooling layer | PR #1 open from `chore/claude-setup`; needs `_tooling` PR #133 (`feat/tracey-lint-comments`) merged first, because `tracey-lint` checks `.ts` markers only there and this repo's config cites that branch's probe cases | this session | architect re-review; `_tooling` PR #133 |

## Unowned

- Requirements for the app itself: only the upstream check is traced.

## Next action

The architect re-reviews PR #1, then `/ponytail-review` and `pr-review` run on it; `_tooling` PR #133 merges first. Each push to PR #1 spends paid CI minutes.

## Standing risks / not verified

- The sync from Meta has never run: `docs/backlog/EXPECTATIONS.md`. The token's expiry is unknown: `DEBT-2026-11-04-sdk-checkout-token-expiry`.
- ESLint, the frontend typecheck, `yarn audit:ci` and Playwright are outside the suite; Meta's branding remains: `docs/backlog/DEBT.md`.
