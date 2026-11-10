| | |
| :--- | :--- |
| **Haptics Studio** | **▸ Getting Started** · [Design & Integration](../docs/design-and-integration.md) · [Architecture](../docs/architecture.md) |
| **Haptics SDK** | [Overview](https://github.com/basslet/haptics-sdk) · [Getting Started](https://github.com/basslet/haptics-sdk/blob/main/docs/getting-started.md) · [Documentation](https://github.com/basslet/haptics-sdk/blob/main/docs/README.md) |
| **Haptics Studio Examples** | [Overview](https://github.com/basslet/haptics-studio-examples) · [Guidelines](https://github.com/basslet/haptics-studio-examples/blob/main/1%20Design%20Guidelines/README.md) · [Examples](https://github.com/basslet/haptics-studio-examples/blob/main/2%20Design%20Examples/README.md) · [Code](https://github.com/basslet/haptics-studio-examples/blob/main/3%20Integration%20%26%20Code%20Snippets/README.md) · [Knowledge](https://github.com/basslet/haptics-studio-examples/blob/main/4%20Knowledge%20Base/README.md) · [Skills](https://github.com/basslet/haptics-studio-examples/blob/main/5%20Skills/README.md) |
| **General** | [Code of Conduct](../CODE_OF_CONDUCT.md) · [Contributing](../CONTRIBUTING.md) · [License](../LICENSE) · [Security](../SECURITY.md) |

# Companion Apps

## Project Structure

```
├── companion/               # Companion apps for device auditioning
│   ├── quest/               # Unity VR companion (Meta Quest)
│   ├── ios/                 # iOS mobile example
│   └── android/             # Android mobile example

```

## Companion Apps (Auditioning)

Haptics Studio includes companion apps that let you preview ("audition") haptic clips on real hardware in real time. The desktop app acts as a server; companion apps on VR headsets or mobile devices connect as clients, receive haptic data, and play it on the device's native haptic engine.

This repository ships three companion apps:

| App                        | Platform   | Technology  | Purpose                                         |
| :------------------------: | :--------: | :---------: | :---------------------------------------------: |
| VR Companion App           | Meta Quest | Unity (C\#) | Full-featured auditioning on Quest controllers  |
| iOS Mobile Example App     | iOS        | Swift       | Reference implementation for mobile auditioning |
| Android Mobile Example App | Android    | Kotlin      | Reference implementation for mobile auditioning |

### How Desktop and Companion Apps Relate

```
┌──────────────────────┐           ┌──────────────────────┐
│   Haptics Studio     │           │   Companion App      │
│   (Desktop)          │           │   (Quest / Mobile)   │
│                      │           │                      │
│  ┌────────────────┐  │  Socket   │  ┌────────────────┐  │
│  │  WSServer      │◄═╪═══════════╪═►│  SocketClient  │  │
│  │  (Socket.IO)   │  │   .IO     │  │  (connects)    │  │
│  └───────┬────────┘  │           │  └───────┬────────┘  │
│          │           │           │          │           │
│  ┌───────┴────────┐  │           │  ┌───────┴────────┐  │
│  │  Project Model │  │           │  │  Haptics SDK   │  │
│  │  (clips, audio)│  │           │  │  (playback)    │  │
│  └────────────────┘  │           │  └────────────────┘  │
│                      │           │                      │
│  ┌────────────────┐  │           │  ┌────────────────┐  │
│  │ HapticsSdkNapi │  │           │  │ Native Haptic  │  │
│  │ (DSP, render)  │  │           │  │ Engine         │  │
│  └────────────────┘  │           │  └────────────────┘  │
└──────────────────────┘           └──────────────────────┘

```

The desktop app is the source of truth — it holds the project, runs audio analysis, and generates all haptic formats. Companion apps are thin clients that request data, receive it over the wire, and play it using the platform's native haptic APIs.

### Communication Protocol

The desktop and companion apps communicate over a three-layer protocol:

#### 1\. Discovery (UDP Broadcast)

The desktop app continuously broadcasts its presence on the local network:

```
Desktop ──── UDP broadcast ────► port 9998
             {"hostname": "MyMac.local", "port": 9999}

```

Companion apps listen on port 9998, parse the broadcast to learn the desktop's IP address and WebSocket port, and present it in a connection list.

#### 2\. Connection (Socket.IO)

Once a host is selected, the companion app opens a Socket.IO connection:

```
Companion ──── Socket.IO connect ────► desktop:9999
               query: { deviceId, name, model, version }

```

The connection uses Socket.IO (Engine.IO v4) over HTTP with a 5-second ping interval.

USB alternative: For Android devices (e.g. Meta Quest) connected via USB, the ADB Device Manager on the desktop sets up port forwarding (`adb reverse`), allowing the companion app to connect to `localhost:9999` without network discovery.

#### 3\. Authentication (Pairing Code)

New devices must pair using a numeric code:

```
Desktop                              Companion
   │                                    │
   │──── "auth_required" ──────────────►│
   │     (display pairing code in UI)   │  User enters code
   │                                    │  shown on desktop
   │◄─── "auth_request" ────────────────│
   │     { authCode: "1234" }           │
   │                                    │
   │  [validate code]                   │
   │                                    │
   │──── "auth_request" ───────────────►│
   │     { status: "ok" }               │
   │                                    │
   │  Device saved to known list        │
   │  (auto-connects next time)         │

```

Previously paired devices skip this step and receive an `"auth_granted"` event immediately on connection.

### Data Over the Wire

Once connected and authenticated, the desktop pushes project and clip data to the companion app. All data is transmitted as JSON over Socket.IO events:

| Event               | Direction        | Payload                                                                              | Purpose                           |
| :-----------------: | :--------------: | :----------------------------------------------------------------------------------: | :-------------------------------: |
| `current_project`   | desktop → device | Clip list (names, IDs, MIME types), groups, current selection                        | Sync project state                |
| `clip_update`       | desktop → device | Full clip: HapticData JSON, waveform SVG, markers, settings                          | Push edits in real time           |
| `get_clip`          | device ↔ desktop | Request by clip ID → full clip data response                                         | On-demand clip fetch              |
| `get_audio`         | device ↔ desktop | Request by clip ID → audio as base64 data URI or binary buffer                       | Audio for synchronized playback   |
| `get_ahap`          | device ↔ desktop | Request by clip ID → AHAP JSON (Apple Core Haptics format)                           | iOS haptic playback               |
| `get_android`       | device ↔ desktop | Request by clip ID (+ optional gain, sampleRate) → amplitude\[\] + timing\[\] arrays | Android haptic playback           |
| `current_clip`      | desktop → device | `{ currentClipId }`                                                                  | Notify clip selection change      |
| `set_current_clip`  | device → desktop | `{ clipId }`                                                                         | Change selection from device      |
| `project_close`     | desktop → device | (empty)                                                                              | Notify project was closed         |
| `play_test_pattern` | desktop → device | (empty)                                                                              | Trigger a test buzz on the device |

Key data formats on the wire:

  * HapticData — The canonical haptic format: JSON with amplitude and frequency envelope arrays (`{time, amplitude, emphasis?}` and `{time, frequency}` breakpoints). Passed through `sanitizedEnvelopes()` before transmission.
  * AHAP — Apple Haptic and Audio Pattern format, generated server-side by `hapticDataToSplitAhap()`.
  * Android arrays — Parallel `amplitudes[]` (0-255) and `timings[]` (ms) arrays, generated by `getAmplitudeAndTimingArrays()`.
  * Audio — Complete audio file as a base64 data URI (`data:mime;base64,...`) or raw binary buffer. Not streamed — transferred as a whole file on demand.

### VR Companion App (Unity)

The VR companion app is a Unity project:

```
companion/quest/
└── Assets/Scripts/
    ├── NetworkHandler.cs    # UDP discovery + Socket.IO connection management
    ├── SocketClient.cs      # Socket.IO client wrapper (SocketIOUnity library)
    ├── Connection.cs        # Connection UI (host list, manual IP, pairing code entry)
    ├── HapticStudio.cs      # Data models (Clip, AudioData, ClipGroup, Project)
    ├── ClipPlayer.cs        # Haptic playback via Haptics SDK
    └── ...

```

| Module           | Responsibility                                                                                                        |
| :--------------: | :-------------------------------------------------------------------------------------------------------------------: |
| `NetworkHandler` | Listens for UDP broadcasts on port 9998, manages Socket.IO connections, handles auth flow, dispatches incoming events |
| `SocketClient`   | Wraps the SocketIOUnity library with typed event handling and automatic reconnection                                  |
| `Connection`     | UI panel for selecting discovered hosts, entering manual IP/port, and submitting pairing codes                        |
| `HapticStudio`   | C\# data model classes that mirror the desktop's TypeScript models: Clip, AudioData, ClipGroup, Project               |
| `ClipPlayer`     | Receives clip data from NetworkHandler, passes it to the Haptics SDK for playback on Quest controllers                |

### Mobile Example App

The mobile companion app is a reference implementation for iOS (`companion/ios/`) and Android (`companion/android/`). It demonstrates how to:

  * Discover a Haptics Studio instance on the local network
  * Connect and authenticate via Socket.IO
  * Request and receive haptic clips
  * Play haptics using the platform's native API (Core Haptics or Android's Vibrator API)

This is intended as a starting point for developers building their own auditioning tools or integrating Haptics Studio preview into custom workflows.
