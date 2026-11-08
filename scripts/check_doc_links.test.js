// Run with: node --test scripts/
const test = require('node:test');
const assert = require('node:assert');
const { execFileSync, spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');

const script = path.join(__dirname, 'check_doc_links.js');

// Builds a throwaway git repo from { 'path': 'content' } and runs the lint on it.
const lint = (files) => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'doclinks-'));
  for (const [f, content] of Object.entries(files)) {
    fs.mkdirSync(path.dirname(path.join(dir, f)), { recursive: true });
    fs.writeFileSync(path.join(dir, f), content);
  }
  execFileSync('git', ['init', '-q'], { cwd: dir });
  execFileSync('git', ['add', '-A'], { cwd: dir });
  const r = spawnSync('node', [script, dir], { encoding: 'utf8' });
  fs.rmSync(dir, { recursive: true, force: true });
  return r;
};

const ok = { 'companion/ios/a.txt': 'x' };

test('passes when links and paths exist', () => {
  const r = lint({ ...ok, 'README.md': 'See [ios](companion/ios/a.txt) and `companion/ios/`.' });
  assert.strictEqual(r.status, 0, r.stderr);
});

test('fails on a missing backticked path', () => {
  const r = lint({ ...ok, 'README.md': 'See `companion/mobile/`.' });
  assert.strictEqual(r.status, 1);
  assert.match(r.stderr, /README\.md:1: no such path companion\/mobile\//);
});

test('fails on a broken relative link and ignores URLs and anchors', () => {
  const r = lint({ ...ok, 'README.md': '[a](https://x.io/nope) [b](#top) [c](missing.md)' });
  assert.strictEqual(r.status, 1);
  assert.match(r.stderr, /broken link missing\.md/);
  assert.doesNotMatch(r.stderr, /x\.io|#top/);
});

test('in source files only comment lines are checked', () => {
  const code = 'const p = `companion/gone/`;\n// see `companion/gone/`\n';
  const r = lint({ ...ok, 'src/a.ts': code });
  assert.strictEqual(r.status, 1);
  assert.match(r.stderr, /src\/a\.ts:2:/);
  assert.doesNotMatch(r.stderr, /src\/a\.ts:1:/);
});
