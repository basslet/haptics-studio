# haptics-studio — status

Artifact: none   Updated: 2026-11-04   Verified against: branch `chore/claude-setup`

## Goal

A private long-term copy of `meta/haptics-studio` that the operator's agents work in under the shared tooling, with its Rust SDK in the sibling repo `basslet/haptics-sdk`.

## Position

The copy holds upstream's `main`. `chore/claude-setup` adds the tooling layer, the requirements for the upstream check, and the repoint of `.gitmodules` to the SDK copy. Whether this copy stays standalone or becomes a public fork is open with the operator's colleagues.

## Decisions taken

| date | decision | by |
|---|---|---|
| 2026-11-04 | A private copy, not a fork, until the colleagues report | operator |
| 2026-11-04 | The SDK is its own repo, traced at its own root | operator |
| 2026-11-04 | `.gitmodules` points at the SDK copy on this branch; the operator's choice for CI may undo it | agent |

## In flight

| workstream | state | owner | blocked on |
|---|---|---|---|
| Tooling layer | PR #1 open from `chore/claude-setup`; its CI fails at checkout (run 41861038969); needs `_tooling` `feat/tracey-lint-comments` merged for the gate to read `.ts` markers | this session | the operator's choice for CI; `_tooling` PR |

## Unowned

- Requirements for the app itself: only the upstream check is traced.

## Next action

The operator chooses how CI gets the private SDK. No pushes to PR #1 until then: each spends paid CI minutes.

## Standing risks / not verified

- CI cannot read the private SDK, and the sync from Meta has never run: `docs/backlog/EXPECTATIONS.md`.
- ESLint, the frontend typecheck, `yarn audit:ci` and Playwright are outside the suite; Meta's branding remains: `docs/backlog/DEBT.md`.
