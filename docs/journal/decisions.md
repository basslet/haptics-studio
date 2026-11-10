# Decisions

- No Contributor License Agreement. Contributions are licensed under the repository license, which keeps contributing simple.
- Doc pages link directly across the three repositories (Studio, SDK, examples), which read as one suite.
- Every page a reader opens starts with one navigation block for the whole suite, with the current page marked, and has none at the bottom (#32). `scripts/doc_nav.js` generates it and `yarn docs:lint` checks it, so pages cannot drift apart. Because `scripts/doc_nav.js` is the same file in all three repositories, each repository's lint, which proves its own entries exist, proves them for the other two as well; `node scripts/doc_nav.js --compare` shows that the copies match. `AGENTS.md`, the journal and `release-notes.md`, which the app shows under View > Show Changelog, carry no block.
- This project publishes no Quest build of the companion app; the docs link to Meta's download.
- Download and platform text stay placeholders until signed builds exist, so the docs never state an unverified value.
