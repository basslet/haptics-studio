#!/usr/bin/env node
// check_doc_links.js: exit 0 when every repo path a doc names exists and every doc page starts with its navigation block.
// Checks relative markdown links and `backticked/paths` that start at a top-level repo directory,
// in tracked *.md files and in comment lines of tracked source files.
// Checks that each page a reader opens starts with the block doc_nav.js generates and has no old navigation line.
// --fix writes the block and drops old navigation lines first.
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
  (f) => f.endsWith('.md') && !/^(AGENTS\.md|release-notes\.md|docs\/journal\/)/.test(f) && fs.existsSync(path.join(root, f)),
);
// Links joined by " · ": the navigation line pages carried before the block.
const navLine = /^\[[^\]]*\]\([^)]*\)( · \[[^\]]*\]\([^)]*\))+$/;
const fixHint = 'run node scripts/check_doc_links.js --fix';
for (const file of pages) {
  const block = navBlock(file);
  let text = fs.readFileSync(path.join(root, file), 'utf8');
  if (fix) {
    const lines = text.split('\n');
    if (lines[0] === '| | |') while (lines[0]?.startsWith('|')) lines.shift();
    const body = lines.filter((l) => !navLine.test(l.trim())).join('\n');
    text = `${block}\n\n${body.replace(/^\n+|\s+$/g, '')}\n`;
    fs.writeFileSync(path.join(root, file), text);
  }
  if (!text.startsWith(`${block}\n\n`)) {
    const what = text.startsWith('| | |') ? 'navigation block differs from the generated one' : 'no navigation block at the top';
    errors.push(`${file}:1: ${what}; ${fixHint}`);
  }
  text.split('\n').forEach((l, i) => navLine.test(l.trim()) && errors.push(`${file}:${i + 1}: leftover navigation line; ${fixHint}`));
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
