// Run with: yarn docs:lint. The same file in all three Haptics repositories, like doc_nav.js.
const test = require('node:test');
const assert = require('node:assert');
const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { navBlock } = require('./doc_nav');

// Written by hand, so a generator bug cannot pass by agreeing with itself.
test('marks the page or its nearest ancestor README, links within the repository relative and the others on main', () => {
  const ios = navBlock('1 Design Guidelines/Apple iOS/README.md', 'haptics-studio-examples');
  assert.match(
    ios,
    /^\| \*\*Haptics Studio Examples\*\* \| \[Overview\]\(\.\.\/\.\.\/README\.md\) · \*\*▸ Guidelines\*\* · \[Examples\]\(\.\.\/\.\.\/2%20Design%20Examples\/README\.md\) · \[Code\]\(\.\.\/\.\.\/3%20Integration%20%26%20Code%20Snippets\/README\.md\) · /m,
  );
  // Design & Integration and Architecture are not on Studio's main yet, so only Studio's own pages list them.
  assert.match(ios, /^\| \*\*Haptics Studio\*\* \| \[Getting Started\]\(https:\/\/github\.com\/basslet\/haptics-studio\) \|$/m);
  assert.match(ios, /^\| \*\*General\*\* \| \[Code of Conduct\]\(\.\.\/\.\.\/CODE_OF_CONDUCT\.md\) · /m);
  assert.match(
    navBlock('docs/building.md', 'haptics-studio'),
    /^\| \*\*Haptics Studio\*\* \| \*\*▸ Getting Started\*\* · \[Design & Integration\]\(design-and-integration\.md\) · \[Architecture\]\(architecture\.md\) \|$/m,
  );
  for (const [, url] of navBlock('README.md', 'haptics-sdk').matchAll(/\]\((https:[^)]+)\)/g)) {
    assert.match(url, /^https:\/\/github\.com\/basslet\/[\w-]+(\/blob\/main\/.+)?$/, 'another repository is linked on its default branch');
  }
  assert.throws(() => navBlock('README.md', 'haptics'), /unknown repository haptics/);
});

test('--compare names each repository whose copy on main differs or cannot be read', { skip: process.platform === 'win32' && 'the gh stub is a shell script' }, () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'docnav-'));
  const gh = ['#!/bin/sh', 'case "$*" in', '  *haptics-sdk/*) echo old ;;', "  *haptics-studio-examples/*) echo 'HTTP 404' >&2; exit 1 ;;", `  *) cat '${path.join(__dirname, 'doc_nav.js')}' ;;`, 'esac'];
  fs.writeFileSync(path.join(dir, 'gh'), `${gh.join('\n')}\n`, { mode: 0o755 });
  const env = { ...process.env, PATH: `${dir}:${process.env.PATH}`, HOME: dir, GH_TOKEN: 'dummy' };
  const r = spawnSync('node', [path.join(__dirname, 'doc_nav.js'), '--compare'], { encoding: 'utf8', env });
  fs.rmSync(dir, { recursive: true, force: true });
  assert.strictEqual(r.status, 1);
  assert.match(r.stderr, /^haptics-sdk: scripts\/doc_nav\.js on main differs from this copy$/m);
  assert.match(r.stderr, /^haptics-studio-examples: scripts\/doc_nav\.js on main cannot be read: HTTP 404$/m);
  assert.doesNotMatch(r.stderr, /^haptics-studio:/m);
});
