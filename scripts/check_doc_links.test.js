// Run with: yarn docs:lint
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
  const env = { ...process.env, HOME: dir }; // no global git config
  execFileSync('git', ['init', '-q'], { cwd: dir, env });
  execFileSync('git', ['add', '-A'], { cwd: dir, env });
  const r = spawnSync('node', [script, dir], { encoding: 'utf8', env: { ...process.env, HOME: dir } });
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

test('names the line for a malformed percent-escape instead of crashing', () => {
  const r = lint({ ...ok, 'README.md': '[a](100%.md)' });
  assert.strictEqual(r.status, 1);
  assert.match(r.stderr, /README\.md:1: broken link 100%\.md/);
  assert.doesNotMatch(r.stderr, /URIError/);
});

test('ignores backticked text that does not start at a repo directory', () => {
  const r = lint({ ...ok, 'README.md': 'Send `application/json` and `text/plain`.' });
  assert.strictEqual(r.status, 0, r.stderr);
});
