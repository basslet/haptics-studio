| | |
| :--- | :--- |
| **Haptics Studio** | [Getting Started](../README.md) · [Design & Integration](design-and-integration.md) · **▸ Architecture** |
| **Haptics SDK** | [Overview](https://github.com/basslet/haptics-sdk) · [Getting Started](https://github.com/basslet/haptics-sdk/blob/main/docs/getting-started.md) · [Documentation](https://github.com/basslet/haptics-sdk/blob/main/docs/README.md) |
| **Haptics Studio Examples** | [Overview](https://github.com/basslet/haptics-studio-examples) · [Guidelines](https://github.com/basslet/haptics-studio-examples/blob/main/1%20Design%20Guidelines/README.md) · [Examples](https://github.com/basslet/haptics-studio-examples/blob/main/2%20Design%20Examples/README.md) · [Code](https://github.com/basslet/haptics-studio-examples/blob/main/3%20Integration%20%26%20Code%20Snippets/README.md) · [Knowledge](https://github.com/basslet/haptics-studio-examples/blob/main/4%20Knowledge%20Base/README.md) · [Skills](https://github.com/basslet/haptics-studio-examples/blob/main/5%20Skills/README.md) |
| **General** | [Code of Conduct](../CODE_OF_CONDUCT.md) · [Contributing](../CONTRIBUTING.md) · [License](../LICENSE) · [Security](../SECURITY.md) |

# Architecture

Details live next to the code: [main process](../main/README.md), [renderer](../frontend/README.md), [shared code and data models](../shared/README.md), [companion apps](../companion/README.md).

## Architecture Overview

Haptics Studio is a cross-platform Electron application with a TypeScript codebase, split into two processes that communicate over IPC:

```
┌──────────────────────────────────────────────────────────────┐
│                   Electron Main Process                      │
│                                                              │
│  main.ts → MainApplication (singleton)                       │
│    ├── IPC Listeners — clips, project, files, device, etc.   │
│    ├── Actions — audio analysis, file ops, project CRUD      │
│    ├── HapticsSdkNapi — Rust NAPI addon (DSP & rendering)    │
│    ├── Project — in-memory state, auto-save every 500 ms     │
│    ├── WSServer — Socket.IO (:9999) for device preview       │
│    ├── ADB Device Manager — USB discovery & port forwarding  │
│    └── FFmpeg — audio format conversion (WASM)               │
│                                                              │
├──────────────────────────── IPC ─────────────────────────────┤
│                                                              │
│                  Electron Renderer Process                   │
│                                                              │
│  React 17 + Redux Toolkit + Konva (canvas)                   │
│    ├── Home — project browser, sample library, tutorials     │
│    └── Editor                                                │
│          ├── Envelope Canvas — breakpoint editing (Konva)    │
│          ├── Left Panel — clip list, groups, drag & drop     │
│          ├── Right Panel — analysis params, design controls  │
│          └── Timeline — scrubber, zoom                       │
└──────────────────────────────────────────────────────────────┘

```

### Data Flow

This is how audio becomes a haptic experience:

```
Audio File (.wav/.mp3)
     │
     ▼
┌─────────────────┐
│  HapticsSdkNapi │    Rust NAPI addon — Offline Audio-to-Haptics DSP engine
│  Audio Analysis │    Decodes audio → runs offline analysis
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   HapticData    │    Amplitude + frequency envelopes
│   (in memory)   │    The core data model for all haptics
└────────┬────────┘
         │
   ┌─────┴──────┐
   ▼            ▼
┌────────┐  ┌──────────┐
│Envelope│  │ Project  │
│ Editor │  │  (.hasp) │    Auto-saved every 500ms
│(Konva) │  └─────┬────┘
└───┬────┘        │
    │    user     │
    │    edits    │
    ▼             ▼
┌─────────────────────┐
│       Export        │
│  .haptic  .ahap     │
│  .wav     Android   │
└─────────────────────┘

```

1.  Import — An audio file is loaded and decoded via the Haptics SDK.
2.  Analyze — The Offline Audio-to-Haptics DSP engine extracts amplitude and frequency envelopes, producing haptic data.
3.  Edit — The envelope editor renders the haptic data on a canvas. Users add, move, and delete breakpoints. Each edit triggers an IPC call that updates the in-memory project.
4.  Preview — Haptic data is rendered to device-specific formats and streamed over WebSocket to a companion app on Quest or mobile.
5.  Export — The final haptic data is exported in one or more formats (see [Export Formats](design-and-integration.md#export-formats)).

## Other Top-Level Directories

```
Haptics-Studio/
├── native/                  # Build output of the native extensions (not tracked)
├── e2e/                     # End-to-end tests (Playwright)
├── scripts/                 # Build and utility scripts
└── package.json             # Scripts, dependencies, build config

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
