#!/usr/bin/env node
// check_doc_links.js: exit 0 when every repo path a doc names exists and every doc page starts with its navigation block.
// Checks relative markdown links and `backticked/paths` that start at a top-level repo directory,
// in tracked *.md files and in comment lines of tracked source files.
// Checks that each page a reader opens starts with the block doc_nav.js generates, has no second copy of it,
// and has no old navigation line first or last. --fix writes the block and drops the others first.
// shortcut: the block and old lines are found by their shape. A hand-edited block row without bold survives --fix,
// a page's own table with the block's exact header is taken for a block, and an old line counts only first or last
// on the page; match on the block's group names if a hand edit or an older branch hits one of these.
// shortcut: external URLs and #anchors are not fetched or checked; add that if broken web links keep slipping in.
// shortcut: no Markdown parser. Links with a title, <angle brackets>, parentheses in the target, a leading / or a ?query,
// fenced code lines, block-comment lines without a leading *, and docstring bodies are not read correctly; upgrade to a parser when one of them fires.
const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const { navBlock } = require('./doc_nav');

const args = process.argv.slice(2);
const fix = args.includes('--fix');
const root = path.resolve(args.find((a) => a !== '--fix') || path.join(__dirname, '..'));
const tracked = execFileSync('git', ['ls-files', '-z'], { cwd: root, encoding: 'utf8' }).split('\0').filter(Boolean);
const topDirs = new Set(tracked.filter((f) => f.includes('/')).map((f) => f.split('/')[0]));
const srcExt = /\.(ts|tsx|js|jsx|kt|java|swift|cs|py|sh|md)$/;
const commentLine = /^\s*(\/\/|\/\*|\*|#|"""|--)/;

const exists = (p) => fs.existsSync(path.join(root, p.replace(/\/+$/, '')));
const errors = [];

// Pages a reader opens: not the agent notes, the journal, or the release notes the app shows.
const pages = tracked.filter(
  (f) => f.endsWith('.md') && !/(^|\/)AGENTS\.md$|^release-notes\.md$|^docs\/journal\//.test(f) && fs.existsSync(path.join(root, f)),
);
// Links joined by " · ": the navigation line pages carried first and last before the block.
const navLine = /^\[[^\]]*\]\([^)]*\)( · \[[^\]]*\]\([^)]*\))+$/;
// Where a copy of the block starts; its exact header, so a table of the page's own is not taken for it.
const blockAt = (lines, i) => lines[i] === '| | |' && lines[i + 1] === '| :--- | :--- |';
const fixHint = 'run node scripts/check_doc_links.js --fix';
for (const file of pages) {
  const block = navBlock(file);
  let text = fs.readFileSync(path.join(root, file), 'utf8').replace(/\r\n/g, '\n');
  if (fix) {
    const lines = text.split('\n');
    for (let i = lines.length - 1; i >= 0; i--) {
      if (!blockAt(lines, i)) continue;
      let end = i + 2;
      while (lines[end]?.startsWith('| **')) end++;
      lines.splice(i, end - i);
    }
    const body = lines.join('\n').replace(/^\n+|\s+$/g, '').split('\n');
    if (navLine.test(body[0].trim())) body.shift();
    if (navLine.test(body.at(-1)?.trim())) body.pop();
    text = `${block}\n\n${body.join('\n').replace(/^\n+|\s+$/g, '')}\n`;
    fs.writeFileSync(path.join(root, file), text);
  }
  const lines = text.split('\n');
  const top = text.startsWith(`${block}\n\n`) ? block.split('\n').length : 0;
  if (!top) {
    const what = text.startsWith('| | |') ? 'navigation block differs from the generated one' : 'no navigation block at the top';
    errors.push(`${file}:1: ${what}; ${fixHint}`);
  }
  lines.forEach((l, i) => i > 0 && blockAt(lines, i) && errors.push(`${file}:${i + 1}: second navigation block; ${fixHint}`));
  // The old line sat first and last on the page; elsewhere a line of links is the page's own.
  const filled = lines.flatMap((l, i) => (i >= top && l.trim() ? [i] : []));
  for (const i of new Set([filled[0], filled.at(-1)])) {
    if (navLine.test(lines[i]?.trim())) errors.push(`${file}:${i + 1}: leftover navigation line; ${fixHint}`);
  }
}

for (const file of tracked.filter((f) => srcExt.test(f) && fs.existsSync(path.join(root, f)))) {
  const isMd = file.endsWith('.md');
  const lines = fs.readFileSync(path.join(root, file), 'utf8').split('\n');
  lines.forEach((line, i) => {
    if (!isMd && !commentLine.test(line)) return;
    const where = `${file}:${i + 1}`;
    for (const [, target] of line.matchAll(/\]\(([^)\s]+)\)/g)) {
      if (/^([a-z][a-z0-9+.-]*:|#)/i.test(target)) continue;
      let rel = target.split('#')[0];
      try {
        rel = decodeURIComponent(rel);
      } catch {} // a malformed %-escape stays as written and is reported as missing
      if (rel && !fs.existsSync(path.resolve(root, path.dirname(file), rel))) errors.push(`${where}: broken link ${target}`);
    }
    for (const [, p] of line.matchAll(/`([\w.-]+(?:\/[\w.@-]+)+\/?)`/g)) {
      if (topDirs.has(p.split('/')[0]) && !exists(p)) errors.push(`${where}: no such path ${p}`);
    }
  });
}

if (errors.length) {
  console.error(errors.join('\n'));
  process.exit(1);
}
