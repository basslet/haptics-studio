# Shared Code and Data Models

## Project Structure

```
├── shared/                  # Shared between main & renderer
│   ├── ipc-channels.ts      # Typed IPC channel definitions
│   ├── ipc-types.ts         # IPC payload type definitions
│   └── typed-ipc.ts         # Type-safe IPC wrappers

```

## Core Data Models

### Project File (.hasp)

A `.hasp` file is a JSON document containing all clips, groups, and project metadata:

```
ProjectContent
  ├── version          — Semantic version (major.minor.patch)
  ├── metadata         — Name, description, slug, category
  ├── state            — Active clip ID, session ID
  ├── clips[]          — Array of haptic clips (see below)
  └── groups[]         — Clip grouping / folder hierarchy

```

### Haptic Clip

Each clip contains audio analysis settings, the resulting haptic data, and editor state:

```
Clip
  ├── name, notes, markers
  ├── audioAsset       — Source audio file reference
  ├── waveform         — Audio waveform visualization data
  ├── settings         — DSP analysis parameters (OATH)
  └── haptic           — HapticData (the core output)
        ├── signals.continuous.envelopes.amplitude[]  →  {time, amplitude, emphasis?}
        ├── signals.continuous.envelopes.frequency[]  →  {time, frequency}
        └── metadata (editor info, source, tags, description)

```

