# Decisions

- No Contributor License Agreement. Contributions are licensed under the repository license, which keeps contributing simple.
- Doc pages link directly across the three repositories (Studio, SDK, examples), which read as one suite.
- Every page a reader opens starts with one navigation block for the whole suite, with the current page marked, and has none at the bottom (#32). `AGENTS.md`, the journal and `release-notes.md`, which the app shows under View > Show Changelog, carry no block. `scripts/doc_nav.js` generates it and `yarn docs:lint` checks it; both scripts and their tests are the same files in all three repositories, so the pages of all three cannot drift apart. Each repository's lint proves that its own entries exist on the branch it runs on. Links from the other repositories go to `main` and may 404 until that branch merges, which the maintainers accept until the repositories open. The SDK's Documentation sub-pages are not in the block; the SDK's Documentation page lists them.
- This project publishes no Quest build of the companion app; the docs link to Meta's download.
- Download and platform text stay placeholders until signed builds exist, so the docs never state an unverified value.
