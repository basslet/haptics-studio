# Upstream

How this copy keeps its agent tooling out of what goes to `meta/haptics-studio`.

r[upstream.check-passes-clean]
`scripts/upstream_pr_check.sh <branch>` shall exit 0 when no commit on the branch since `upstream/main` touches a tooling-layer file or names `basslet/`.

r[upstream.check-refuses-layer]
`scripts/upstream_pr_check.sh <branch>` shall exit non-zero and name the files when any commit on the branch since `upstream/main` touches a tooling-layer file, including a file a later commit removes or renames, and a file that only a merge commit changes against its first parent. A PR publishes every commit, so a clean final diff does not make the branch clean.

r[upstream.check-refuses-private-name]
`scripts/upstream_pr_check.sh <branch>` shall exit non-zero and show the line when a commit message or a changed line on the branch since `upstream/main` names `basslet/`.
