#!/usr/bin/env bash
# tests/run_all.sh: the full local suite, adapted for Node from _tooling/templates/run_all.sh.tmpl.
#
# Runs both Jest suites, the main-process typecheck, the fork's shell tests and the tracey
# gate. After a green run on a clean tree it writes the push receipt that .githooks/pre-push
# requires (_tooling/lib/receipt.sh). It takes no arguments, so every run is the full suite;
# for a subset call jest directly. TEST_WORKERS sets the frontend Jest workers: default 8,
# 0 = serial, capped at 8; the main suite is always serial (--runInBand in package.json).
#
# Not run here: eslint and the frontend typecheck (both red upstream), yarn audit:ci (needs
# the network; CI runs it), Playwright e2e. docs/backlog/DEBT.md holds a row for each red or
# missing check.
set -euo pipefail
PATH="$PATH:/opt/homebrew/bin:$HOME/.local/bin"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

if [ "$#" -gt 0 ]; then
  echo "usage: bash tests/run_all.sh (no arguments; for a subset call jest directly)" >&2
  exit 2
fi
if ! yarn -s check --integrity >/dev/null 2>&1; then
  echo "tests/run_all.sh: node_modules is missing or stale; run scripts/install_deps.sh" >&2
  exit 1
fi

WORKERS="${TEST_WORKERS:-8}"
case "$WORKERS" in
  ''|*[!0-9]*|???*)
    echo "tests/run_all.sh: TEST_WORKERS='${WORKERS}' is not a worker count; using 8" >&2
    WORKERS=8 ;;
esac
if [ "$WORKERS" -gt 8 ]; then
  echo "tests/run_all.sh: TEST_WORKERS=${WORKERS} capped at 8" >&2
  WORKERS=8
fi
if [ "$WORKERS" -eq 0 ]; then WORKERS=1; fi

RECEIPT_LIB="${TOOLING_ROOT:-$HOME/Repositories/_tooling}/lib/receipt.sh"
REASON="receipt helper not found: ${RECEIPT_LIB}"
BEFORE=""
if [ -f "$RECEIPT_LIB" ]; then
  # shellcheck source=/dev/null
  . "$RECEIPT_LIB"
  REASON="$(receipt_reason_before "$@")"
  if [ -z "$REASON" ]; then BEFORE="$(git rev-parse 'HEAD^{tree}')"; fi
fi

RC=0
yarn -s test:all --maxWorkers="$WORKERS" || RC=$?
yarn -s main:typecheck || { [ "$RC" -ne 0 ] || RC=1; }
for t in tests/fork/test_*.sh; do
  bash "$t" || { [ "$RC" -ne 0 ] || RC=1; }
done

# >>> tracey gate (from _tooling templates/tracey/requirements-README.md)
# shortcut: trusts any file at $0's relative path (DEBT-2026-10-11-tracey-gate-block-stale-dollar0)
_tracey_top="$({ { [ -f "$0" ] && cd "$(dirname "$0")/.."; } 2>/dev/null || true; } && { git rev-parse --show-toplevel 2>/dev/null || pwd; })"
if [ -f "$_tracey_top/.config/tracey/config.styx" ]; then
  echo "== tracey =="
  _tracey_gate="${TOOLING_ROOT:-$HOME/Repositories/_tooling}/bin/tracey-gate"
  if [ -x "$_tracey_gate" ]; then
    "$_tracey_gate" "$_tracey_top" || { [ "${RC:-0}" -ne 0 ] || RC=1; }
  elif [ -n "${IS_SANDBOX:-}${CI:-}${GITHUB_ACTIONS:-}" ]; then
    echo "  WARN: $_tracey_gate not found (sandbox or CI); requirement gate skipped"
  else
    echo "  FAIL: $_tracey_gate not found; set TOOLING_ROOT"; [ "${RC:-0}" -ne 0 ] || RC=1
  fi
fi
# <<< tracey gate

if [ -f "$RECEIPT_LIB" ]; then
  echo "tests/run_all.sh: $(receipt_finish "$RC" "$BEFORE" "$REASON")"
else
  echo "tests/run_all.sh: no receipt: ${REASON}"
fi
exit "$RC"
