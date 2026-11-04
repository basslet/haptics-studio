# Decisions — haptics-studio

## 2026-11-04 — decision: a private copy, not a fork, until the operator's colleagues report

- what: `basslet/haptics-studio` is a private copy of `meta/haptics-studio`'s `main`, not a GitHub fork. Fork or standalone stays open until the colleagues report back.
- why: the operator's decision, 2026-11-04, after a public fork was created and then set aside. A copy can become public later; a fork's network cannot be rejoined once left.
- refs: `basslet/haptics-studio` `docs/backlog/DEBT.md` `DEBT-2026-11-04-no-public-fork`.

## 2026-11-04 — decision: the SDK is its own repo, traced at its own root

- what: `basslet/haptics-sdk` carries the Rust requirements, markers, suite and registers; this repo consumes it as the submodule `third-party/haptics-sdk` and traces only its own TypeScript and shell.
- why: the operator's decision. A Rust requirement then fits one PR, and `tracey-lint` cannot see files inside a submodule. The cost is a second PR when this repo must move its pointer.
- refs: `CLAUDE.md` "Sibling repo"; `_tooling` `scripts/checks/probe_tracey.sh` cases R1-R6.
