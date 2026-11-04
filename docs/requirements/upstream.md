# Upstream

How this copy keeps its agent tooling out of what goes to `meta/haptics-studio`.

A tooling-layer file is any path `origin/main` adds or changes against `upstream/main`, or a path `LAYER` in the script names. Private text is what `PRIVATE` in the script names: our accounts, `_tooling`, this host's home, register IDs and tracey markers. Both are deny lists, so a file or a text they do not name passes.

r[upstream.check-passes-clean+2]
`scripts/upstream_pr_check.sh <branch>` shall exit 0 when no commit on the branch since `upstream/main` touches a tooling-layer file or carries private text.

r[upstream.check-refuses-layer]
`scripts/upstream_pr_check.sh <branch>` shall exit non-zero and name the files when any commit on the branch since `upstream/main` touches a tooling-layer file, including a file a later commit removes or renames, and a file that only a merge commit changes against its first parent. A PR publishes every commit, so a clean final diff does not make the branch clean.

r[upstream.check-refuses-private-name+2]
`scripts/upstream_pr_check.sh <branch>` shall exit non-zero and show the line when a commit message or a changed line on the branch since `upstream/main`, in a text or a binary file, carries private text in any case.
