| | |
| :--- | :--- |
| **Haptics Studio** | **▸ Getting Started** · [Design & Integration](docs/design-and-integration.md) · [Architecture](docs/architecture.md) |
| **Haptics SDK** | [Overview](https://github.com/basslet/haptics-sdk) |
| **Haptics Studio Examples** | [Overview](https://github.com/basslet/haptics-studio-examples) · [Guidelines](https://github.com/basslet/haptics-studio-examples/blob/main/1%20Design%20Guidelines/README.md) · [Examples](https://github.com/basslet/haptics-studio-examples/blob/main/2%20Design%20Examples/README.md) · [Code](https://github.com/basslet/haptics-studio-examples/blob/main/3%20Integration%20%26%20Code%20Snippets/README.md) · [Knowledge](https://github.com/basslet/haptics-studio-examples/blob/main/4%20Knowledge%20Base/README.md) · [Skills](https://github.com/basslet/haptics-studio-examples/blob/main/5%20Skills/README.md) |
| **General** | [Code of Conduct](CODE_OF_CONDUCT.md) · [Contributing](CONTRIBUTING.md) · [License](LICENSE) · [Security](SECURITY.md) |

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./assets/logo-dark.png">
  <source media="(prefers-color-scheme: light)" srcset="./assets/logo-light.png">
  <img alt="Logo" src="./assets/logo-light.png">
</picture>

Design, audition, and export haptic experiences from audio — on macOS and Windows.

License: MIT | Platforms: macOS, Windows | Built with Electron

Haptics Studio is an open-source desktop application for designing advanced haptics. Automatically generate a haptic clip from an audio file, fine-tune it with a visual envelope editor, preview it in real time on Meta Quest or mobile devices, and export to every major haptic format — all from one tool.

Note: Haptics Studio is the open-source project. Meta Haptics Studio (<https://developers.meta.com/horizon/resources/haptics-studio/>) is a distribution of this project maintained and published by Meta, with additional Meta branding and documentation. This is similar to the relationship between Chromium and Google Chrome, or Code - OSS and Visual Studio Code. The source code in this repository is available to everyone under the MIT license.

## Features

  * Audio-to-Haptics Conversion — Generate haptic clips from .wav or .mp3 files (tunable digital signal processing).
  * Visual Envelope Editor — Edit amplitude and frequency envelopes with precision controls.
  * Real-Time Device Preview — Audition haptics instantly on Meta Quest headsets (via USB or Wi-Fi) and mobile devices through a companion app.
  * Multi-Format Export — Export to .haptic (universal JSON format), .ahap (Apple Core Haptics), Android haptic arrays, and .wav rendered audio.
  * Project Management — Organize clips into groups, add markers and notes, and save everything as a .hasp project file.
  * Sample Library & Tutorials — Built-in haptic packs and guided tutorials to get you started quickly.

## Who It Is By

Haptics Studio was created by the Meta Haptics team (formerly Lofelt) and released by Meta under the MIT license. This repository is maintained by a community of contributors. It is not affiliated with, endorsed by, or supported by Meta Platforms, Inc.

## Requirements

Haptics Studio is built for macOS and Windows. Minimum versions will be listed here with the first ready-to-install version.

## Download

Ready-to-install versions are not available yet. They will appear on the [Releases](https://github.com/basslet/haptics-studio/releases) page.

Previewing on a headset or phone needs a companion app; see [Companion apps](docs/design-and-integration.md#companion-apps).

## First Steps

1.  Add a clip from an audio file (`.wav`, `.mp3`, `.ogg`, `.aiff` or `.aif`). Haptics Studio analyzes it and generates a haptic clip.
2.  Fine-tune the clip in the envelope editor.
3.  Preview it on a device through a companion app.
4.  Export it. [Design & Integration](docs/design-and-integration.md) explains the formats and what to do next.

## Privacy

This open-source build contains no telemetry transmission; [SECURITY.md](SECURITY.md) shows how to check.

## Help

File a [GitHub issue](https://github.com/basslet/haptics-studio/issues) with your app version, your operating system and any logs; the [Application Data](main/README.md#application-data) table shows where the app keeps them. Haptics Studio is maintained by volunteers in their free time, so help is best effort, with no promised response time.

## Related Projects

[Haptics Studio](https://github.com/basslet/haptics-studio) — design haptics · [Haptics SDK](https://github.com/basslet/haptics-sdk) — play them in your app · [Haptics Studio Examples](https://github.com/basslet/haptics-studio-examples) — sample projects and design guidance

## License

This project is licensed under the MIT License — see the LICENSE file for details.
