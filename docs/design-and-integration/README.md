| | |
| :--- | :--- |
| **Haptics Studio** | [Overview](../../README.md) · **▸ Design & Integration** · [Source Code](../building.md) · [Architecture](../architecture.md) |
| **Haptics SDK** | [Overview](https://github.com/basslet/haptics-sdk) · [Getting Started](https://github.com/basslet/haptics-sdk/blob/main/docs/getting-started.md) · [Documentation](https://github.com/basslet/haptics-sdk/blob/main/docs/README.md) |
| **Haptics Studio Examples** | [Overview](https://github.com/basslet/haptics-studio-examples) · [Guidelines](https://github.com/basslet/haptics-studio-examples/blob/main/1%20Design%20Guidelines/README.md) · [Examples](https://github.com/basslet/haptics-studio-examples/blob/main/2%20Design%20Examples/README.md) · [Code](https://github.com/basslet/haptics-studio-examples/blob/main/3%20Integration%20%26%20Code%20Snippets/README.md) · [Knowledge](https://github.com/basslet/haptics-studio-examples/blob/main/4%20Knowledge%20Base/README.md) · [Skills](https://github.com/basslet/haptics-studio-examples/blob/main/5%20Skills/README.md) |
| **General** | [Code of Conduct](../../CODE_OF_CONDUCT.md) · [Contributing](../../CONTRIBUTING.md) · [License](../../LICENSE) · [Security](../../SECURITY.md) |

# Design & Integration

Haptics Studio turns audio into haptic clips. The Haptics SDK plays those clips in your app.

## Pages

- [Getting Started](getting-started.md): the basics of haptic design, installing the app, connecting a device, and your first project.
- [Feature Walkthrough](feature-walkthrough.md): every editing tool, one by one.
- [Haptics Guidelines](haptics-guidelines.md): what makes haptics work, on one page.
- [Resources](resources.md): haptics documentation for each platform and tool.

## For Designers

Start with [Getting Started](getting-started.md). For in-depth design guidance and sample projects you can open in Haptics Studio, see [Haptics Studio Examples](https://github.com/basslet/haptics-studio-examples).

## For Developers

Export clips as `.haptic` files and load them with the [Haptics SDK](https://github.com/basslet/haptics-sdk), which also covers the file format and actuator configuration. To work on Haptics Studio itself, see [Source Code](../building.md) and [Architecture](../architecture.md).

## Relationship to Haptics SDK

Haptics Studio works alongside the Haptics SDK (<https://github.com/basslet/haptics-sdk>), which is a separate open-source project:

|               | Haptics Studio                                       | Haptics SDK                                    |
| :-----------: | :--------------------------------------------------: | :--------------------------------------------: |
| Purpose       | Design haptic clips                                  | Play haptic clips in your app                  |
| Role          | Authoring tool (desktop app)                         | Runtime library (Unity / Unreal / Native)      |
| Formats       | Imports audio, exports .haptic, .ahap, Android, .wav | Loads .haptic files and renders them on device |
| Where it runs | macOS / Windows desktop                              | Windows, macOS, Linux, VR headsets and consoles |

How they connect:

1.  Design a haptic clip in Haptics Studio.
2.  Export it as a .haptic file (the cross-platform interchange format).
3.  Integrate the .haptic file into your app using the Haptics SDK.
4.  Play the clip at runtime — the SDK handles platform-specific rendering.

The native DSP engine that powers Haptics Studio's audio analysis and rendering is built from the same Haptics SDK core library (`HapticsSdkNapi` is a Rust NAPI binding to the SDK).

## Export Formats

| Format          | Extension                 | Description                                                   | Method                                       |
| :-------------: | :-----------------------: | :-----------------------------------------------------------: | :------------------------------------------: |
| Haptic Clip     | `.haptic`                 | Cross-platform JSON — the canonical haptic interchange format | Direct serialization of `HapticData`         |
| Core Haptics    | `.ahap`                   | Apple Core Haptics format for iOS/macOS                       | `hapticDataToSplitAhap()` via native SDK     |
| Android         | `.json`, or a Kotlin or Java snippet to copy | Android-compatible amplitude + timing arrays                  | `getAmplitudeAndTimingArrays()`              |
| Rendered Audio  | `.wav`                    | Haptic signal rendered through an actuator profile            | `renderHapticDataToAudio()` + `.acf` profile |
| Project Package | `.zip`                    | Complete bundle: `.hasp` project + audio + all exports        | Archive utility                              |

### Actuator Profiles

Rendered .wav output is shaped by actuator characteristic files (`.acf`) in `main/actuators/`:

| Profile              | Device                    |
| :------------------: | :-----------------------: |
| `meta_quest_pro.acf` | Meta Quest Pro controller |

## Companion Apps

Companion apps play your clips on a real device while you edit them on the desktop. Both must be on the same network or, for Meta Quest, connected by USB.

| Device     | App                                                                                  |
| :--------: | :----------------------------------------------------------------------------------: |
| Meta Quest | [Download from Meta](https://www.meta.com/experiences/6759764157450104/)              |
| iOS        | [Sample code](../../companion/ios/README.md), built with Xcode                           |
| Android    | [Sample code](../../companion/android/README.md), built with Android Studio              |

The iOS and Android apps have no store release, so using them today means building them yourself. How the apps talk to the desktop is in [companion/README.md](../../companion/README.md).
