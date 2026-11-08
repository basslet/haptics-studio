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

## Documentation

  * [Building from source](docs/building.md)
  * [Architecture](docs/architecture.md)
  * [Companion apps](companion/README.md)

## Export Formats

| Format          | Extension                 | Description                                                   | Method                                       |
| :-------------: | :-----------------------: | :-----------------------------------------------------------: | :------------------------------------------: |
| Haptic Clip     | `.haptic`                 | Cross-platform JSON — the canonical haptic interchange format | Direct serialization of `HapticData`         |
| Core Haptics    | `.ahap`                   | Apple Core Haptics format for iOS/macOS                       | `hapticDataToSplitAhap()` via native SDK     |
| Android         | `.json` / `.kt` / `.java` | Android-compatible amplitude + timing arrays                  | `getAmplitudeAndTimingArrays()`              |
| Rendered Audio  | `.wav`                    | Haptic signal rendered through an actuator profile            | `renderHapticDataToAudio()` + `.acf` profile |
| Project Package | `.zip`                    | Complete bundle: `.hasp` project + audio + all exports        | Archive utility                              |

### Actuator Profiles

Rendered .wav output is shaped by actuator characteristic files (`.acf`) in `main/actuators/`:

| Profile              | Device                    |
| :------------------: | :-----------------------: |
| `meta_quest_pro.acf` | Meta Quest Pro controller |

## Relationship to Haptics SDK

Haptics Studio works alongside the Meta Haptics SDK (<https://github.com/basslet/haptics-sdk>), which is a separate open-source project:

|               | Haptics Studio                                       | Haptics SDK                                    |
| :-----------: | :--------------------------------------------------: | :--------------------------------------------: |
| Purpose       | Design haptic clips                                  | Play haptic clips in your app                  |
| Role          | Authoring tool (desktop app)                         | Runtime library (Unity / Unreal / Native)      |
| Formats       | Imports audio, exports .haptic, .ahap, Android, .wav | Loads .haptic files and renders them on device |
| Where it runs | macOS / Windows desktop                              | Quest                                          |

How they connect:

1.  Design a haptic clip in Haptics Studio.
2.  Export it as a .haptic file (the cross-platform interchange format).
3.  Integrate the .haptic file into your app using the Haptics SDK.
4.  Play the clip at runtime — the SDK handles platform-specific rendering.

The native DSP engine that powers Haptics Studio's audio analysis and rendering is built from the same Haptics SDK core library (`HapticsSdkNapi` is a Rust NAPI binding to the SDK).

## License

This project is licensed under the MIT License — see the LICENSE file for details.
