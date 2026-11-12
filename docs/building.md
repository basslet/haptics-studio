| | |
| :--- | :--- |
| **Haptics Studio** | [Overview](../README.md) · [Design & Integration](design-and-integration/README.md) · **▸ Source Code** · [Architecture](architecture.md) |
| **Haptics SDK** | [Overview](https://github.com/basslet/haptics-sdk) · [Getting Started](https://github.com/basslet/haptics-sdk/blob/main/docs/getting-started.md) · [Documentation](https://github.com/basslet/haptics-sdk/blob/main/docs/README.md) |
| **Haptics Studio Examples** | [Overview](https://github.com/basslet/haptics-studio-examples) · [Guidelines](https://github.com/basslet/haptics-studio-examples/blob/main/1%20Design%20Guidelines/README.md) · [Examples](https://github.com/basslet/haptics-studio-examples/blob/main/2%20Design%20Examples/README.md) · [Code](https://github.com/basslet/haptics-studio-examples/blob/main/3%20Integration%20%26%20Code%20Snippets/README.md) · [Knowledge](https://github.com/basslet/haptics-studio-examples/blob/main/4%20Knowledge%20Base/README.md) · [Skills](https://github.com/basslet/haptics-studio-examples/blob/main/5%20Skills/README.md) |
| **General** | [Code of Conduct](../CODE_OF_CONDUCT.md) · [Contributing](../CONTRIBUTING.md) · [License](../LICENSE) · [Security](../SECURITY.md) |

# Source Code

How to build, run and test Haptics Studio from source, and where to start when you change it. How the parts fit together is in [Architecture](architecture.md); where the app stores its data is in [Application Data](../main/README.md#application-data), and the project and clip formats are in [Core Data Models](../shared/README.md#core-data-models).

## Setup

### Prerequisites

  * Node.js 24.x LTS (<https://nodejs.org/>)
  * Yarn (install globally: `npm install -g yarn`)
  * Rust: Install Rust by following the instructions on https://rustup.rs/.

**macOS setup (recommended):**

``` bash
brew install nvm
nvm install 24
nvm alias default 24
npm install -g yarn

```

**Windows setup:**

``` bash
choco install nodejs-lts
npm install -g yarn

```

### Quick Start

``` bash
# Clone the repository
git clone https://github.com/basslet/haptics-studio haptics-studio
cd haptics-studio

# Install dependencies (also builds native extensions)
yarn install

# Run in development mode
yarn start:dev

```

This starts both the Electron backend and the webpack dev server. The app will open automatically. The frontend is also accessible at http://localhost:8080 for browser-based development.

## Building from Source

### Development

Run the Electron app with hot-reloading frontend:

``` bash
yarn start:dev

```

Or run the backend and frontend separately (recommended for development):

``` bash
# Terminal 1 — Frontend (with hot reload)
yarn frontend:start:dev

# Terminal 2 — Backend
yarn main:start:dev

```

Enable developer messages for debugging:

``` bash
DEVELOPER_MESSAGES=true yarn start:dev

```

### Production Build

``` bash
# Build everything for production
yarn build:prod

# Build and package for macOS
yarn buildAndPackage:mac

# Build and package for Windows
yarn buildAndPackage:win

```

Packaged artifacts appear in `./dist/`:

  * macOS: `.dmg` installer
  * Windows: `.exe` NSIS installer

### Native Extensions

The Rust NAPI addon (`HapticsSdkNapi`) is built automatically during `yarn install`. To rebuild it manually:

``` bash
yarn native:update

```

Binaries are placed in `./native/bin/`.

`yarn install` keeps a binary that already exists. After the SDK pin moves, run `scripts/install_deps.sh`: it puts the submodule on the pin and rebuilds the binary when it was not built from that commit.

### Linting & Type Checking

``` bash
yarn frontend:lint        # ESLint — frontend
yarn main:lint            # ESLint — backend
yarn frontend:typecheck   # TypeScript — frontend
yarn main:typecheck       # TypeScript — backend
yarn docs:lint            # Doc links and the navigation block on each page

```

After adding a page, or an entry to the navigation block in `scripts/doc_nav.js`, run `node scripts/check_doc_links.js --fix`. It writes the block on every page. `scripts/doc_nav.js`, `scripts/check_doc_links.js` and their tests are the same files in Haptics Studio, the Haptics SDK and Haptics Studio Examples: copy a change to the other two, and `node scripts/doc_nav.js --compare` names each repository whose copy on `main` differs.

### Testing

``` bash
# Run all unit tests
yarn test:all

# Run end-to-end tests (requires a packaged build)
yarn test:e2e:prepare:mac   # or test:e2e:prepare:win
yarn test:e2e

```

## Extending Studio

We welcome contributions\! Here's where to look depending on what you'd like to do:

### Add a New UI Feature

The frontend lives in `frontend/src/`. Start with the relevant component directory:

| Area                       | Directory                       | Key files                                                  |
| :------------------------: | :-----------------------------: | :--------------------------------------------------------: |
| Envelope editor            | `components/editor/envelope/`   | `HapticEnvelope.tsx`, `AudioEnvelope.tsx`, `PlotArea.tsx`  |
| Clip list / navigator      | `components/editor/leftpanel/`  | `LeftPanel.tsx`, `Navigator.tsx`, `NavigatorClip.tsx`      |
| Analysis & design controls | `components/editor/rightpanel/` | `RightPanel.tsx`, `AudioAnalyzer.tsx`, `DetailEditing.tsx` |
| Timeline                   | `components/editor/timeline/`   | `Timeline.tsx`, `TimelinePlot.tsx`                         |
| Home screen                | `components/home/`              | `Landing.tsx`                                              |
| Redux state                | `state/`                        | `store.ts`, `reducers.ts`, `selectors.ts`, `actions.ts`    |
| Custom hooks               | `hooks/`                        | 22 hooks for editor interactions, audio playback, etc.     |

### Add a New Export Format

1.  Define the format in `shared/ipc-types.ts` — add to the `ExportFormat` union type.
2.  Implement the export logic in `main/src/common/utils/export.ts`.
3.  Wire up the IPC handler in `main/src/listeners/clips/clipExport.ts`.
4.  Add UI controls in `frontend/src/components/common/ExportDialog.tsx`.

### Support a New Platform for Playback

Runtime playback on new platforms is best handled in the Haptics SDK repository (<https://github.com/basslet/haptics-sdk>), not in Haptics Studio. The SDK is responsible for loading `.haptic` files and rendering them through each platform's native haptic API.

If you need to add a new rendering target for preview within Studio (e.g., a new actuator profile), add an `.acf` file to `main/actuators/` and a render settings entry in `main/renderers/`.

### Add a New Companion App

The companion app protocol is documented in [companion/README.md](../companion/README.md). To build a new companion app for a different platform:

1.  Implement UDP broadcast listening on port 9998 to discover desktop instances.
2.  Connect via Socket.IO to the discovered host on port 9999 with query params: `deviceId`, `name`, `model`, `version`.
3.  Handle the pairing flow (`auth_required` → `auth_request` → `auth_granted`).
4.  Listen for `clip_update` and `current_project` events to receive haptic data.
5.  Request specific formats via `get_ahap`, `get_android`, or `get_clip` depending on your platform.
6.  Use the Haptics SDK (or platform-native APIs) to play the received haptic data.

The VR companion app (`companion/quest/`) and mobile examples (`companion/ios/`, `companion/android/`) are good references.
