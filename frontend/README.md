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
