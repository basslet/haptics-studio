[Getting Started](README.md) · [Design & Integration](docs/design-and-integration.md) · [Architecture](docs/architecture.md) · [Contributing](CONTRIBUTING.md)

# Security and Privacy

## Reporting a Vulnerability

Do not report a vulnerability in a public issue. Open this repository's **Security** tab and choose **Report a vulnerability**, which keeps the report private. If that button is not shown, ask [@basslet](https://github.com/basslet) on GitHub for a way to reach them, without giving details.

Haptics Studio is maintained by volunteers in their free time, so handling is best effort, with no promised response time or bounty.

## Privacy: No Telemetry

This open-source build contains no telemetry transmission. Run these commands in a clone to check the source yourself:

```bash
# Analytics has no address to send to, and events only reach the local log
git grep -n "ENDPOINT: ''" -- main/src/analytics.ts
# Crash dumps stay on your computer
git grep -n "uploadToServer" -- main/src/crashReporter.ts
# Automatic updates are off
git grep -n "FEED_URL: undefined" -- main/src/common/constants.ts
# Network calls in the app's code: two read local media files, one imports a type
git grep -nE "(^|[^a-zA-Z.])fetch\(|axios|https\.(get|request)|http\.(get|request)|net\.request|XMLHttpRequest" -- main/src frontend/src ':!*.test.*'
```

What does leave your computer:

- **Google Fonts.** The About and Acknowledgments windows load the Work Sans font from Google, so Google receives your IP address when you open them (`git grep -n "fonts.googleapis" -- main/assets`). No project or usage data is sent.
- **Your local network.** From the moment it starts, the app announces your computer's hostname and port over UDP so companion apps can find it, pausing while a companion app is connected. Companion apps connect over unencrypted Socket.IO (`git grep -n "hostname" -- main/src/wsServer.ts`). Clips you preview travel over that connection.
- **Links you open.** Links to documentation and videos open in your browser.

Limits of this statement:

- It covers this repository's source, not Meta's own *Meta Haptics Studio* build or code from dependencies.
- The app's "Data Preferences" menu item offers no real choice: `hasConsent` is always true, and nothing is sent either way.
- The app window grants every permission it is asked for (`git grep -n "setPermissionRequestHandler" -- main/src`), so no separate permission prompt appears inside the app.

[Getting Started](README.md) · [Design & Integration](docs/design-and-integration.md) · [Architecture](docs/architecture.md) · [Contributing](CONTRIBUTING.md)
