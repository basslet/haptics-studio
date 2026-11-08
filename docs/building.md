[Getting Started](../README.md) · [Design & Integration](design-and-integration.md) · [Architecture](architecture.md) · [Contributing](../CONTRIBUTING.md) · [Haptics SDK](https://github.com/basslet/haptics-sdk) · [Haptics Studio Examples](https://github.com/basslet/haptics-studio-examples)

# Building Haptics Studio

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

```

### Testing

``` bash
# Run all unit tests
yarn test:all

# Run end-to-end tests (requires a packaged build)
yarn test:e2e:prepare:mac   # or test:e2e:prepare:win
yarn test:e2e

```


[Getting Started](../README.md) · [Design & Integration](design-and-integration.md) · [Architecture](architecture.md) · [Contributing](../CONTRIBUTING.md) · [Haptics SDK](https://github.com/basslet/haptics-sdk) · [Haptics Studio Examples](https://github.com/basslet/haptics-studio-examples)
