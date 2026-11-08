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

