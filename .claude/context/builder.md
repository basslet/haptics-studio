# builder context — haptics-studio

Node and TypeScript, no venv: this replaces the global Python mechanics.

- `scripts/install_deps.sh` puts the submodule on the pinned commit, installs this worktree's `node_modules` and builds the native SDK. Each worktree has its own; never copy or move one.
- Full suite: `bash tests/run_all.sh`. A subset: call `jest` with `-c ./main/jest.config.js` or `-c ./frontend/jest.config.js`.
- A Rust change belongs in `basslet/haptics-sdk`, not here (`CLAUDE.md` "Sibling repo").
