// doc_nav.js: the navigation block every documentation page starts with (layout C of basslet/haptics-studio#32).
// List an entry only once its page exists. Links into another repository point at its default branch.
const path = require('path').posix;

const SDK = 'https://github.com/basslet/haptics-sdk';
const EXAMPLES = 'https://github.com/basslet/haptics-studio-examples';

// [group, [[label, target]]]: a target is a path in this repository or a URL.
const NAV = [
  [
    'Haptics Studio',
    [
      ['Getting Started', 'README.md'],
      ['Design & Integration', 'docs/design-and-integration.md'],
      ['Architecture', 'docs/architecture.md'],
    ],
  ],
  ['Haptics SDK', [['Overview', SDK]]],
  [
    'Haptics Studio Examples',
    [
      ['Overview', EXAMPLES],
      ['Guidelines', `${EXAMPLES}/blob/main/1%20Design%20Guidelines/README.md`],
      ['Examples', `${EXAMPLES}/blob/main/2%20Design%20Examples/README.md`],
      ['Code', `${EXAMPLES}/blob/main/3%20Integration%20%26%20Code%20Snippets/README.md`],
      ['Knowledge', `${EXAMPLES}/blob/main/4%20Knowledge%20Base/README.md`],
      ['Skills', `${EXAMPLES}/blob/main/5%20Skills/README.md`],
    ],
  ],
  [
    'General',
    [
      ['Code of Conduct', 'CODE_OF_CONDUCT.md'],
      ['Contributing', 'CONTRIBUTING.md'],
      ['License', 'LICENSE'],
      ['Security', 'SECURITY.md'],
    ],
  ],
];

const isUrl = (target) => target.startsWith('https:');

// The block for `page`, a path from the repository root. The page's own entry, or else that of the nearest
// ancestor README with one, is bold, marked ▸ and not a link; other paths are relative to the page.
const navBlock = (page) => {
  const own = NAV.flatMap(([, entries]) => entries.map(([, target]) => target)).filter((t) => !isUrl(t));
  const ancestors = [page];
  for (let dir = path.dirname(page); ; dir = path.dirname(dir)) {
    ancestors.push(path.join(dir, 'README.md'));
    if (dir === '.') break;
  }
  const here = ancestors.find((p) => own.includes(p));
  const entry = ([label, target]) =>
    target === here ? `**▸ ${label}**` : `[${label}](${isUrl(target) ? target : path.relative(path.dirname(page), target)})`;
  const rows = NAV.map(([group, entries]) => `| **${group}** | ${entries.map(entry).join(' · ')} |`);
  return ['| | |', '| :--- | :--- |', ...rows].join('\n');
};

module.exports = { navBlock };
