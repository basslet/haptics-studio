# Debt

| What | Where | When to act |
|---|---|---|
| Vulnerability reporting must be turned on. `SECURITY.md` names the Report a vulnerability button, which GitHub documents for public repositories. | Repository settings, `SECURITY.md` | When the repository opens |
| There is a single conduct contact, so a report about that person has no independent reviewer. | `CONTRIBUTING.md` | When a second maintainer is named |
| `basslet/haptics-studio-examples` must open with or before Studio, or the app's Learning link fails for outsiders. The same goes for `basslet/haptics-sdk` and the README's links. | Opening order of the three repositories | When the repositories open |
| Dependabot alerts on this repository have not been triaged. | Repository security tab | Before the repository opens |
| The README's feature list says ".wav or .mp3" and `docs/architecture.md` says ".wav/.mp3", while First Steps lists more formats. | `README.md`, `docs/architecture.md` | The next edit of those pages |
| `docs/design-and-integration/README.md` has engineer text (the Method column, "Rust NAPI binding") on a page designers read. | `docs/design-and-integration/README.md` | The next edit of that page |
| Nothing runs `node scripts/doc_nav.js --compare` on its own, so a copy left stale in one repository goes unnoticed until someone runs it. | `scripts/doc_nav.js`, CI | When the three repositories are public: run it daily in CI, which then needs no token |
| CI runs `actions/checkout@v4` and `actions/setup-node@v4`, which target Node.js 20; GitHub warns that Node.js 20 is deprecated and forces them onto Node.js 24 (run 42472182022). | `.github/workflows/test.yml` | The next edit of the workflow, or when GitHub removes Node.js 20 |
| The shared `--fix` finds the block by its shape. It removes rows starting with `\| **` that sit directly under the block with no blank line, even when they belong to the page's own table. The lint also reports a page's own table with the block's exact header as a second block. No page in the three repositories hits either case (outside review of basslet/haptics-sdk#25). | `scripts/check_doc_links.js` (shared) | The next change to the shared files: match the block's rows on its group names |
| `docs/design-and-integration/resources.md` says PWLE support in the Haptics SDK is in progress. | `docs/design-and-integration/resources.md` | When PWLE support reaches the SDK's `main` |
