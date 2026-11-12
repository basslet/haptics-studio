| | |
| :--- | :--- |
| **Haptics Studio** | [Overview](../README.md) · [Design & Integration](design-and-integration/README.md) · [Source Code](building.md) · **▸ Architecture** |
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
5.  Export — The final haptic data is exported in one or more formats (see [Export Formats](design-and-integration/README.md#export-formats)).

## Other Top-Level Directories

```
Haptics-Studio/
├── native/                  # Build output of the native extensions (not tracked)
├── e2e/                     # End-to-end tests (Playwright)
├── scripts/                 # Build and utility scripts
└── package.json             # Scripts, dependencies, build config

```

## Formats and Specifications

The `.haptic` file format and the actuator configuration files (`.acf`) are specified in the Haptics SDK: [.haptic file specification](https://github.com/basslet/haptics-sdk/blob/main/resources/haptic-file-spec.md) and [ACF specification](https://github.com/basslet/haptics-sdk/blob/main/resources/acf/README.md).
