// doc_nav.js: the navigation block every documentation page of the three Haptics repositories starts with
// (layout C of basslet/haptics-studio#32). The same file in basslet/haptics-studio, basslet/haptics-sdk and
// basslet/haptics-studio-examples: change it in one, copy it to the other two, then run
// `node scripts/doc_nav.js --compare [branch]`, which names every repository whose copy on that branch (main) differs.
// List an entry only once its page exists; mark it 'local' while the page is not on its repository's main yet.
const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path').posix;

const REPOS = ['haptics-studio', 'haptics-sdk', 'haptics-studio-examples'];

// [group, repository (null: the page's own), [[label, path from that repository's root, 'local'?]]].
// A 'local' entry shows only on its own repository's pages: a page not on main yet, or an SDK sub-point (#32).
const NAV = [
  [
    'Haptics Studio',
    'haptics-studio',
    [
      ['Getting Started', 'README.md'],
      ['Design & Integration', 'docs/design-and-integration.md', 'local'],
      ['Architecture', 'docs/architecture.md', 'local'],
    ],
  ],
  ['Haptics SDK', 'haptics-sdk', [['Overview', 'README.md']]],
  [
    'Haptics Studio Examples',
    'haptics-studio-examples',
    [
      ['Overview', 'README.md'],
      ['Guidelines', '1 Design Guidelines/README.md'],
      ['Examples', '2 Design Examples/README.md'],
      ['Code', '3 Integration & Code Snippets/README.md'],
      ['Knowledge', '4 Knowledge Base/README.md'],
      ['Skills', '5 Skills/README.md'],
    ],
  ],
  [
    'General',
    null,
    [
      ['Code of Conduct', 'CODE_OF_CONDUCT.md'],
      ['Contributing', 'CONTRIBUTING.md'],
      ['License', 'LICENSE'],
      ['Security', 'SECURITY.md'],
    ],
  ],
];

const encode = (p) => p.split('/').map(encodeURIComponent).join('/');

// The block for `page`, a path from the root of `repo`. The page's own entry, or else that of the nearest ancestor
// README with one, is bold, marked ▸ and not a link. Links within `repo` are relative to the page; links into another
// repository go to its main branch, and to its root for its README.
const navBlock = (page, repo) => {
  if (!REPOS.includes(repo)) throw new Error(`unknown repository ${repo}`);
  const own = NAV.flatMap(([, r, entries]) => ((r ?? repo) === repo ? entries.map(([, p]) => p) : []));
  const ancestors = [page];
  for (let dir = path.dirname(page); ; dir = path.dirname(dir)) {
    ancestors.push(path.join(dir, 'README.md'));
    if (dir === '.') break;
  }
  const here = ancestors.find((p) => own.includes(p));
  const rows = NAV.map(([group, r, entries]) => {
    const target = r ?? repo;
    const shown = target === repo ? entries : entries.filter(([, , local]) => !local);
    const entry = ([label, p]) => {
      if (target !== repo) return `[${label}](https://github.com/basslet/${target}${p === 'README.md' ? '' : `/blob/main/${encode(p)}`})`;
      return p === here ? `**▸ ${label}**` : `[${label}](${encode(path.relative(path.dirname(page), p))})`;
    };
    return `| **${group}** | ${shown.map(entry).join(' · ')} |`;
  });
  return ['| | |', '| :--- | :--- |', ...rows].join('\n');
};

// Compares this file with the copy on `ref` of each repository; gh must be signed in while they are private.
const compare = (ref) => {
  const mine = fs.readFileSync(__filename, 'utf8').replace(/\r\n/g, '\n');
  let same = true;
  for (const repo of REPOS) {
    let problem = null;
    try {
      const url = `repos/basslet/${repo}/contents/scripts/doc_nav.js?ref=${encodeURIComponent(ref)}`;
      const theirs = execFileSync('gh', ['api', '-H', 'Accept: application/vnd.github.raw', url], { encoding: 'utf8', stdio: 'pipe' });
      if (theirs.replace(/\r\n/g, '\n') !== mine) problem = 'differs from this copy';
    } catch (e) {
      problem = `cannot be read: ${String(e.stderr || e.message).trim().split('\n')[0]}`;
    }
    if (problem) {
      console.error(`${repo}: scripts/doc_nav.js on ${ref} ${problem}`);
      same = false;
    }
  }
  return same;
};

if (require.main === module) {
  if (process.argv[2] !== '--compare') {
    console.error('usage: node scripts/doc_nav.js --compare [branch]');
    process.exit(2);
  }
  process.exit(compare(process.argv[3] || 'main') ? 0 : 1);
}

module.exports = { navBlock };
