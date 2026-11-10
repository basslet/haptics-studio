| | |
| :--- | :--- |
| **Haptics Studio** | **▸ Getting Started** · [Design & Integration](../docs/design-and-integration.md) · [Architecture](../docs/architecture.md) |
| **Haptics SDK** | [Overview](https://github.com/basslet/haptics-sdk) |
| **Haptics Studio Examples** | [Overview](https://github.com/basslet/haptics-studio-examples) · [Guidelines](https://github.com/basslet/haptics-studio-examples/blob/main/1%20Design%20Guidelines/README.md) · [Examples](https://github.com/basslet/haptics-studio-examples/blob/main/2%20Design%20Examples/README.md) · [Code](https://github.com/basslet/haptics-studio-examples/blob/main/3%20Integration%20%26%20Code%20Snippets/README.md) · [Knowledge](https://github.com/basslet/haptics-studio-examples/blob/main/4%20Knowledge%20Base/README.md) · [Skills](https://github.com/basslet/haptics-studio-examples/blob/main/5%20Skills/README.md) |
| **General** | [Code of Conduct](../CODE_OF_CONDUCT.md) · [Contributing](../CONTRIBUTING.md) · [License](../LICENSE) · [Security](../SECURITY.md) |

# Renderer

## Project Structure

```
├── frontend/                # Electron renderer process (UI)
│   └── src/
│       ├── components/
│       │   ├── editor/
│       │   │   ├── envelope/    # Haptic envelope canvas
│       │   │   ├── leftpanel/   # Clip list, groups, navigator
│       │   │   ├── rightpanel/  # Analysis params, design controls
│       │   │   └── timeline/    # Timeline scrubber, zoom
│       │   ├── home/            # Landing page, project browser
│       │   ├── tutorial/        # In-app guided tutorials
│       │   └── common/          # Shared UI components
│       ├── state/               # Redux store
│       ├── hooks/               # Custom React hooks
│       └── styles/              # Shared Styles

```
