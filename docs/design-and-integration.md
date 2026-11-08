[Getting Started](../README.md) · [Design & Integration](design-and-integration.md) · [Architecture](architecture.md) · [Contributing](../CONTRIBUTING.md)

# Design & Integration

Haptics Studio turns audio into haptic clips. The Haptics SDK plays those clips in your app.

## For Designers

Start with [First Steps](../README.md#first-steps). For design guidance and sample projects you can open in Haptics Studio, see [Haptics Studio Examples](https://github.com/basslet/haptics-studio-examples).

## For Developers

Export clips as `.haptic` files and load them with the [Haptics SDK](https://github.com/basslet/haptics-sdk), which also covers the file format and actuator configuration. To work on Haptics Studio itself, see [Architecture](architecture.md) and [Building](building.md).

## Relationship to Haptics SDK

Haptics Studio works alongside the Haptics SDK (<https://github.com/basslet/haptics-sdk>), which is a separate open-source project:

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

## Companion Apps

Companion apps play your clips on a real device while you edit them on the desktop. Both must be on the same network or, for Meta Quest, connected by USB.

| Device     | App                                                                                  |
| :--------: | :----------------------------------------------------------------------------------: |
| Meta Quest | [Download from Meta](https://www.meta.com/experiences/6759764157450104/)              |
| iOS        | [Sample code](../companion/ios/README.md), built with Xcode                           |
| Android    | [Sample code](../companion/android/README.md), built with Android Studio              |

The iOS and Android apps have no store release, so using them today means building them yourself. How the apps talk to the desktop is in [companion/README.md](../companion/README.md).

[Getting Started](../README.md) · [Design & Integration](design-and-integration.md) · [Architecture](architecture.md) · [Contributing](../CONTRIBUTING.md)
