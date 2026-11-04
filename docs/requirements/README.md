# Requirements

This repo's requirements, traced with tracey. Set up by
`_tooling/bin/tracey-init`. How to write a requirement and mark the code and
tests that cover it: the `requirements` skill
(`_tooling/.claude/skills/requirements/SKILL.md`). Look requirements up with
the tracey MCP tools rather than reading these files whole.

Requirements go in `docs/requirements/<area>.md`. This file is part of the
tracey spec too (`.config/tracey/config.styx` includes
`docs/requirements/**/*.md`): a requirement ID at column 0 here, outside a
code fence, defines a real requirement.

## Gate

`_tooling/templates/run_all.sh.tmpl`, which `bootstrap.sh` writes as
`tests/run_all.sh`, already carries this block.

`tests/run_all.sh` calls `_tooling/bin/tracey-gate`. Add this block to it; it
sets the script's failure variable `rc` to 1 unless an earlier failure already
set it (rename it if yours differs). Without a `_tooling` checkout it warns
instead of failing under sbxx (`IS_SANDBOX`) and in CI (`CI` or
`GITHUB_ACTIONS`); the local run stays the gate. The
block assumes `tests/run_all.sh`: it finds the repo from the script's own
directory, not from where it is run; if the script has already cd'd so that a
relative `$0` no longer names a file from there, it falls back to the git repo
of the current directory. A stale `$0` that names another file still wins (a
worktree three levels below its main checkout, a nested repo); place the block
before any `cd` if that can happen:

```bash
# >>> tracey gate (from _tooling templates/tracey/requirements-README.md)
# shortcut: trusts any file at $0's relative path (DEBT-2026-10-11-tracey-gate-block-stale-dollar0)
_tracey_top="$({ { [ -f "$0" ] && cd "$(dirname "$0")/.."; } 2>/dev/null || true; } && { git rev-parse --show-toplevel 2>/dev/null || pwd; })"
if [ -f "$_tracey_top/.config/tracey/config.styx" ]; then
  echo "== tracey =="
  _tracey_gate="${TOOLING_ROOT:-$HOME/Repositories/_tooling}/bin/tracey-gate"
  if [ -x "$_tracey_gate" ]; then
    "$_tracey_gate" "$_tracey_top" || { [ "${rc:-0}" -ne 0 ] || rc=1; }
  elif [ -n "${IS_SANDBOX:-}${CI:-}${GITHUB_ACTIONS:-}" ]; then
    echo "  WARN: $_tracey_gate not found (sandbox or CI); requirement gate skipped"
  else
    echo "  FAIL: $_tracey_gate not found; set TOOLING_ROOT"; [ "${rc:-0}" -ne 0 ] || rc=1
  fi
fi
# <<< tracey gate
```

From 20 requirements on, the gate fails on an uncovered requirement (no
`impl` marker) unless `.config/tracey/uncovered-allowed` lists its ID, one per
line with a `#` comment giving the reason: verify-only (the code is in a "Not
traced" script), or planned (the brief that builds it). It fails as well on a
listed ID that is covered or gone, so the list shrinks as code lands. The
current uncovered IDs: `tracey query --json uncovered | jq -r
'.bySection[].rules[].id.base'`.

## Not traced

Scripts without an extension, which tracey cannot see, that stay that way.
One line each, with the reason. Rename any other one to `.sh`.

- (none)
