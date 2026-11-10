| | |
| :--- | :--- |
| **Haptics Studio** | **▸ Getting Started** · [Design & Integration](../docs/design-and-integration.md) · [Architecture](../docs/architecture.md) |
| **Haptics SDK** | [Overview](https://github.com/basslet/haptics-sdk) · [Getting Started](https://github.com/basslet/haptics-sdk/blob/main/docs/getting-started.md) · [Documentation](https://github.com/basslet/haptics-sdk/blob/main/docs/README.md) |
| **Haptics Studio Examples** | [Overview](https://github.com/basslet/haptics-studio-examples) · [Guidelines](https://github.com/basslet/haptics-studio-examples/blob/main/1%20Design%20Guidelines/README.md) · [Examples](https://github.com/basslet/haptics-studio-examples/blob/main/2%20Design%20Examples/README.md) · [Code](https://github.com/basslet/haptics-studio-examples/blob/main/3%20Integration%20%26%20Code%20Snippets/README.md) · [Knowledge](https://github.com/basslet/haptics-studio-examples/blob/main/4%20Knowledge%20Base/README.md) · [Skills](https://github.com/basslet/haptics-studio-examples/blob/main/5%20Skills/README.md) |
| **General** | [Code of Conduct](../CODE_OF_CONDUCT.md) · [Contributing](../CONTRIBUTING.md) · [License](../LICENSE) · [Security](../SECURITY.md) |

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
