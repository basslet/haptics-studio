# Debt

| What | Where | When to act |
|---|---|---|
| Vulnerability reporting must be turned on. `SECURITY.md` names the Report a vulnerability button, which GitHub documents for public repositories. | Repository settings, `SECURITY.md` | When the repository opens |
| There is a single conduct contact, so a report about that person has no independent reviewer. | `CONTRIBUTING.md` | When a second maintainer is named |
| `basslet/haptics-studio-examples` must open with or before Studio, or the app's Learning link fails for outsiders. The same goes for `basslet/haptics-sdk` and the README's links. | Opening order of the three repositories | When the repositories open |
| Dependabot alerts on this repository have not been triaged. | Repository security tab | Before the repository opens |
| The README's feature list says ".wav or .mp3" and `docs/architecture.md` says ".wav/.mp3", while First Steps lists more formats. | `README.md`, `docs/architecture.md` | The next edit of those pages |
| `docs/design-and-integration.md` has engineer text (the Method column, "Rust NAPI binding") on a page designers read. | `docs/design-and-integration.md` | The next edit of that page |
| The navigation block lists only the SDK's Overview, because its Getting Started and Documentation pages are not on the SDK's `main` yet. | `scripts/doc_nav.js` | When those pages reach the SDK's `main` |
| Nothing runs `node scripts/doc_nav.js --compare` on its own, so a copy left stale in one repository goes unnoticed until someone runs it. | `scripts/doc_nav.js`, CI | When the three repositories are public: run it daily in CI, which then needs no token |
| Design & Integration and Architecture show only on Studio's own pages: they are marked `local` because they are not on `main` yet. | `scripts/doc_nav.js` | When `integration/docs-refactor` merges into `main`: drop `local` from both and copy the file to the other two repositories |
