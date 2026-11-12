| | |
| :--- | :--- |
| **Haptics Studio** | **▸ Overview** · [Design & Integration](docs/design-and-integration/README.md) · [Source Code](docs/building.md) · [Architecture](docs/architecture.md) |
| **Haptics SDK** | [Overview](https://github.com/basslet/haptics-sdk) · [Getting Started](https://github.com/basslet/haptics-sdk/blob/main/docs/getting-started.md) · [Documentation](https://github.com/basslet/haptics-sdk/blob/main/docs/README.md) |
| **Haptics Studio Examples** | [Overview](https://github.com/basslet/haptics-studio-examples) · [Guidelines](https://github.com/basslet/haptics-studio-examples/blob/main/1%20Design%20Guidelines/README.md) · [Examples](https://github.com/basslet/haptics-studio-examples/blob/main/2%20Design%20Examples/README.md) · [Code](https://github.com/basslet/haptics-studio-examples/blob/main/3%20Integration%20%26%20Code%20Snippets/README.md) · [Knowledge](https://github.com/basslet/haptics-studio-examples/blob/main/4%20Knowledge%20Base/README.md) · [Skills](https://github.com/basslet/haptics-studio-examples/blob/main/5%20Skills/README.md) |
| **General** | [Code of Conduct](CODE_OF_CONDUCT.md) · [Contributing](CONTRIBUTING.md) · [License](LICENSE) · [Security](SECURITY.md) |

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./assets/logo-dark.png">
  <source media="(prefers-color-scheme: light)" srcset="./assets/logo-light.png">
  <img alt="Haptics Studio" src="./assets/logo-light.png">
</picture>

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A suite of a desktop application and companion apps for designing and managing advanced haptics across your software projects. The no-code visual editor generates haptics from audio, previews them in real time on phones and VR headsets, and exports to every major haptic format, all from one interface.

![The Haptics Studio editor](assets/editor-overview.gif)

**One workspace** for your entire haptics process: design from scratch, or turn your audio assets into haptics for fast, expressive effects and intuitive UI feedback.

**Audition haptics** in real time on iOS, Android and Meta Quest devices for rapid design and iteration.

**Author once, play on many platforms.** Export to `.haptic` (universal JSON format), `.ahap` (Apple Core Haptics), Android haptic arrays and `.wav` rendered audio.

**Manage complex projects** with batch import and export. Organize clips into groups, add markers and notes, and save everything as a `.hasp` project file.

**Build like a pro** with the included examples, guided tutorials and haptic packs built by experts.

## Download

Ready-to-install versions are not available yet. They will appear on the [Releases](https://github.com/basslet/haptics-studio/releases) page. Until then, [build Haptics Studio from source](docs/building.md).

Haptics Studio is built for macOS and Windows. Minimum versions will be listed here with the first ready-to-install version.

Previewing on a headset or phone needs a companion app; see [Companion apps](docs/design-and-integration/README.md#companion-apps).

## First Steps... help! I'm new to haptics

- [Design & Integration](docs/design-and-integration/README.md): get started, learn the editor, and basic design and integration tips.
- [Architecture](docs/architecture.md): the technology stack and the data architecture.

Start with [Getting Started](docs/design-and-integration/getting-started.md) and the [Haptics Guidelines](docs/design-and-integration/haptics-guidelines.md).

We are expanding the documentation, with in-depth guides such as accessibility in [Haptics Studio Examples](https://github.com/basslet/haptics-studio-examples). Check back for more.

## About this Project

Teams that get haptics right in one app or game tend to bring them to every title they ship. What they want is to design haptics once, deploy them to every platform they support, and give their whole user base the same experience. That is what the team behind Haptics Studio and the Haptics SDK has been working on since 2014: a cross-platform haptics standard and the tools to use it.

- **Lofelt.** The team founded Lofelt in 2014, building hardware and software for designing and playing back advanced haptics on mobile devices.
- **Meta.** Lofelt joined Meta in 2022. There the team matured the software and shipped it alongside Meta Quest, where gaming and VR studios used it extensively.
- **Open source.** In 2025, Meta released Haptics Studio and the Haptics SDK as open source, opening them up to other platforms such as iOS and Android.

Haptics Studio is the open-source project. [Meta Haptics Studio](https://developers.meta.com/horizon/resources/haptics-studio/) is a distribution of it, maintained and published by Meta with its own branding and documentation, much like Chromium and Google Chrome. This repository is not affiliated with, endorsed by, or supported by Meta Platforms, Inc.

Daniel ([@basslet](https://github.com/basslet)), co-founder of Lofelt, maintains the project together with former Lofelt team members. For questions, or if you'd like to work with us, [open an issue](https://github.com/basslet/haptics-studio/issues).
