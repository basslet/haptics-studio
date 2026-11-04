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

## In flight

| workstream | state | owner | blocked on |
|---|---|---|---|
| Tooling layer | PR #1 open from `chore/claude-setup`; needs `_tooling` `feat/tracey-lint-comments` merged for the gate to read `.ts` markers | this session | the checkout step's first run with the token; architect re-review; `_tooling` PR |

## Unowned

- Requirements for the app itself: only the upstream check is traced.

## Next action

Read the checkout step of PR #1's `Tests` run with the token, then the architect re-reviews and the outside review runs. Each push to PR #1 spends paid CI minutes.

## Standing risks / not verified

- CI's token has not run yet, and the sync from Meta has never run: `docs/backlog/EXPECTATIONS.md`. The token's expiry is unknown: `DEBT-2026-11-04-sdk-checkout-token-expiry`.
- ESLint, the frontend typecheck, `yarn audit:ci` and Playwright are outside the suite; Meta's branding remains: `docs/backlog/DEBT.md`.
