# Decisions — haptics-studio

## 2026-11-04 — decision: the SDK is its own repo, traced at its own root

- what: `basslet/haptics-sdk` carries the Rust requirements, markers, suite and registers; this repo consumes it as the submodule `third-party/haptics-sdk` and traces only its own TypeScript and shell.
- why: the operator's decision. A Rust requirement then fits one PR, and `tracey-lint` cannot see files inside a submodule. The cost is a second PR when this repo must move its pointer.
- refs: `CLAUDE.md` "Sibling repo"; `_tooling` `scripts/checks/probe_tracey.sh` cases R1-R6.
