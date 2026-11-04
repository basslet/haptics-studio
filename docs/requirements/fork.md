# Fork

How this copy keeps its agent tooling out of what goes to `meta/haptics-studio`.

r[fork.upstream-check-passes-clean]
`scripts/upstream_pr_check.sh <branch>` shall exit 0 when no commit on the branch since `upstream/main` touches a fork-layer file.

r[fork.upstream-check-refuses-layer]
`scripts/upstream_pr_check.sh <branch>` shall exit non-zero and name the files when any commit on the branch since `upstream/main` touches a fork-layer file, including a file a later commit removes. A PR publishes every commit, so a clean final diff does not make the branch clean.
