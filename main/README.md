| | |
| :--- | :--- |
| **Haptics Studio** | [Overview](../README.md) · [Design & Integration](../docs/design-and-integration/README.md) · [Source Code](../docs/building.md) · [Architecture](../docs/architecture.md) |
| **Haptics SDK** | [Overview](https://github.com/basslet/haptics-sdk) · [Getting Started](https://github.com/basslet/haptics-sdk/blob/main/docs/getting-started.md) · [Documentation](https://github.com/basslet/haptics-sdk/blob/main/docs/README.md) |
| **Haptics Studio Examples** | [Overview](https://github.com/basslet/haptics-studio-examples) · [Guidelines](https://github.com/basslet/haptics-studio-examples/blob/main/1%20Design%20Guidelines/README.md) · [Examples](https://github.com/basslet/haptics-studio-examples/blob/main/2%20Design%20Examples/README.md) · [Code](https://github.com/basslet/haptics-studio-examples/blob/main/3%20Integration%20%26%20Code%20Snippets/README.md) · [Knowledge](https://github.com/basslet/haptics-studio-examples/blob/main/4%20Knowledge%20Base/README.md) · [Skills](https://github.com/basslet/haptics-studio-examples/blob/main/5%20Skills/README.md) |
| **General** | [Code of Conduct](../CODE_OF_CONDUCT.md) · [Contributing](../CONTRIBUTING.md) · [License](../LICENSE) · [Security](../SECURITY.md) |

# Main Process

## Project Structure

```
├── main/                    # Electron main process (backend)
│   ├── src/
│   │   ├── main.ts          # ← Entry point
│   │   ├── application.ts   # App lifecycle, window, menu, ADB polling
│   │   ├── hapticsSdk.ts    # Rust NAPI bridge — DSP, rendering, validation
│   │   ├── wsServer.ts      # Socket.IO server for device preview
│   │   ├── device.ts        # ADB device discovery & USB forwarding
│   │   ├── updater.ts       # Auto-updater (electron-updater)
│   │   ├── ffmpeg.ts        # Audio conversion (FFmpeg WASM)
│   │   ├── listeners/       # IPC handlers (clips, project, files, device…)
│   │   ├── actions/         # Business logic (analysis, files, project)
│   │   ├── common/          # Shared utils, project model, configs, logger
│   │   └── menu/            # Native application menu
│   ├── actuators/           # Actuator profiles (.acf) for rendering
│   ├── renderers/           # Render settings per device/format
│   ├── samples/             # Built-in haptic sample packs & tutorials
│   ├── configs/             # Environment configs (dev, prod, test)
│   └── test/                # Backend unit tests

```

## Application Data

The app stores configuration and logs in the following locations:

| Platform    | Path                                            |
| :---------: | :---------------------------------------------: |
| macOS       | `~/Library/Application Support/Haptics Studio/` |
| Windows     | `%APPDATA%/Haptics Studio/`                     |
| Development | The `logs` and `configs` folders inside `main/`, in the working directory; crash dumps and Electron's own data go to the path above with a `-development` suffix |
