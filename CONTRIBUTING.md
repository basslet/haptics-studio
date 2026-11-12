| | |
| :--- | :--- |
| **Haptics Studio** | [Overview](README.md) · [Design & Integration](docs/design-and-integration/README.md) · [Source Code](docs/building.md) · [Architecture](docs/architecture.md) |
| **Haptics SDK** | [Overview](https://github.com/basslet/haptics-sdk) · [Getting Started](https://github.com/basslet/haptics-sdk/blob/main/docs/getting-started.md) · [Documentation](https://github.com/basslet/haptics-sdk/blob/main/docs/README.md) |
| **Haptics Studio Examples** | [Overview](https://github.com/basslet/haptics-studio-examples) · [Guidelines](https://github.com/basslet/haptics-studio-examples/blob/main/1%20Design%20Guidelines/README.md) · [Examples](https://github.com/basslet/haptics-studio-examples/blob/main/2%20Design%20Examples/README.md) · [Code](https://github.com/basslet/haptics-studio-examples/blob/main/3%20Integration%20%26%20Code%20Snippets/README.md) · [Knowledge](https://github.com/basslet/haptics-studio-examples/blob/main/4%20Knowledge%20Base/README.md) · [Skills](https://github.com/basslet/haptics-studio-examples/blob/main/5%20Skills/README.md) |
| **General** | [Code of Conduct](CODE_OF_CONDUCT.md) · **▸ Contributing** · [License](LICENSE) · [Security](SECURITY.md) |

# Contributing to Haptics Studio

We want to make contributing to this project as easy and transparent as possible. Everyone taking part follows the [Code of Conduct](CODE_OF_CONDUCT.md).

## Pull Requests

We welcome your pull requests. They are reviewed and merged in this repository.

1. Fork the repository and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Make sure the tests and linters pass; see [Source Code](docs/building.md).
5. Keep code changes and documentation changes in separate commits, so code changes can be taken to other copies of this project without the docs.

## Where to Start in the Code

Build and test instructions are in [Source Code](docs/building.md); this section shows which files to open for common changes.

### Add a UI Feature

The frontend lives in `frontend/src/`. Start with the relevant component directory:

| Area                       | Directory                       | Key files                                                  |
| :--- | :--- | :--- |
| Envelope editor            | `components/editor/envelope/`   | `HapticEnvelope.tsx`, `AudioEnvelope.tsx`, `PlotArea.tsx`  |
| Clip list / navigator      | `components/editor/leftpanel/`  | `LeftPanel.tsx`, `Navigator.tsx`, `NavigatorClip.tsx`      |
| Analysis & design controls | `components/editor/rightpanel/` | `RightPanel.tsx`, `AudioAnalyzer.tsx`, `DetailEditing.tsx` |
| Timeline                   | `components/editor/timeline/`   | `Timeline.tsx`, `TimelinePlot.tsx`                         |
| Home screen                | `components/home/`              | `Landing.tsx`                                              |
| Redux state                | `state/`                        | `store.ts`, `reducers.ts`, `selectors.ts`, `actions.ts`    |
| Custom hooks               | `hooks/`                        | Hooks for editor interactions, audio playback, etc.        |

### Add an Export Format

1.  Define the format in `shared/ipc-types.ts` — add to the `ExportFormat` union type.
2.  Implement the export logic in `main/src/common/utils/export.ts`.
3.  Wire up the IPC handler in `main/src/listeners/clips/clipExport.ts`.
4.  Add UI controls in `frontend/src/components/common/ExportDialog.tsx`.

### Support a New Platform for Playback

Runtime playback on new platforms is best handled in the [Haptics SDK](https://github.com/basslet/haptics-sdk) repository, not in Haptics Studio. The SDK is responsible for loading `.haptic` files and rendering them through each platform's native haptic API.

If you need to add a new rendering target for preview within Studio (for example, a new actuator profile), add an `.acf` file to `main/actuators/` and a render settings entry in `main/renderers/`.

### Add a Companion App

A companion app finds the desktop, pairs with it and receives clips through the protocol in [`companion/`](companion). Implement that protocol on the new platform, then play the clips with the Haptics SDK or the platform's own haptics API.

The VR companion app (`companion/quest/`) and mobile examples (`companion/ios/`, `companion/android/`) are good references.

## Issues

We use GitHub issues to track bugs and requests. Please describe the problem clearly, with enough detail to reproduce it, and include the version you use and your operating system. The project is maintained by volunteers in their free time, so reviews and answers are best effort, with no promised response time.

## Security

Do not report security problems in a public issue. See [SECURITY.md](SECURITY.md).

## License

By contributing, you agree that your contributions are licensed under the [LICENSE](LICENSE) file in the root of this repository. No Contributor License Agreement is required.

## Relationship to Meta

This repository is independent of Meta; its origin is in [About this Project](README.md#about-this-project). Meta's internal process, its Contributor License Agreement and its bounty program do not apply here.
