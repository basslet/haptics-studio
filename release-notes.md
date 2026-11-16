## Haptics Studio 2.5.0-beta.1

The first pre-release built from the open-source repository on GitHub. The macOS app and the Windows installer are not signed yet, so macOS and Windows warn before they open it.

### Changes

- The app has a new identifier, `io.github.basslet.hapticsstudio`.
- When a project links audio files outside its folder, Haptics Studio asks before it reads them, and it drops linked paths that are not audio files.
- Electron 45 and other dependencies are updated for security fixes.

### Bug Fixes

- Duplicating a group and then ungrouping it no longer corrupts the project.

## Haptics Studio 2.4.1

This release improves validation and handling of project files and linked media.

### Bug Fixes

- Improved how project files and linked media are validated and opened.
