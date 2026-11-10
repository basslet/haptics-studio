| | |
| :--- | :--- |
| **Haptics Studio** | [Getting Started](README.md) · [Design & Integration](docs/design-and-integration.md) · [Architecture](docs/architecture.md) |
| **Haptics SDK** | [Overview](https://github.com/basslet/haptics-sdk) |
| **Haptics Studio Examples** | [Overview](https://github.com/basslet/haptics-studio-examples) · [Guidelines](https://github.com/basslet/haptics-studio-examples/blob/main/1%20Design%20Guidelines/README.md) · [Examples](https://github.com/basslet/haptics-studio-examples/blob/main/2%20Design%20Examples/README.md) · [Code](https://github.com/basslet/haptics-studio-examples/blob/main/3%20Integration%20%26%20Code%20Snippets/README.md) · [Knowledge](https://github.com/basslet/haptics-studio-examples/blob/main/4%20Knowledge%20Base/README.md) · [Skills](https://github.com/basslet/haptics-studio-examples/blob/main/5%20Skills/README.md) |
| **General** | [Code of Conduct](CODE_OF_CONDUCT.md) · [Contributing](CONTRIBUTING.md) · [License](LICENSE) · **▸ Security** |

# Security and Privacy

## Reporting a Vulnerability

Do not report a vulnerability in a public issue. Open this repository's **Security** tab and choose **Report a vulnerability**, which keeps the report private. If that button is not shown, open an issue asking [@basslet](https://github.com/basslet) for a private contact, without giving any details of the problem.

Haptics Studio is maintained by volunteers in their free time, so handling is best effort, with no promised response time or bounty.

## Privacy: No Telemetry

This open-source build contains no telemetry transmission. These statements come from reading the source; traffic from a running app has not been captured. Run these commands in a clone to check the source yourself:

```bash
# Analytics has no address to send to, and events only reach the local log
git grep -n "ENDPOINT: ''" -- main/src/analytics.ts
# Crash dumps stay on your computer
git grep -n "uploadToServer" -- main/src/crashReporter.ts
# Automatic updates are off
git grep -n "FEED_URL: undefined" -- main/src/common/constants.ts
# HTTP calls in the app's code: two read local media files, one imports a type
git grep -nE "(^|[^a-zA-Z.])fetch\(|axios|https\.(get|request)|http\.(get|request)|net\.request|XMLHttpRequest" -- main/src frontend/src ':!*.test.*'
```

What can leave your computer or reach it:

- **Google Fonts.** The About and Acknowledgments windows load the Work Sans font from Google, so Google receives your IP address when you open them (`git grep -n "fonts.googleapis" -- main/assets`). No project or usage data is sent.
- **The local network announcement.** From the moment it starts, the app announces your computer's hostname and port over UDP so companion apps can find it, pausing while a companion app is connected. The announcement stays on the local network (`git grep -n "hostname" -- main/src/wsServer.ts`).
- **The companion connection.** The app listens on port 9999 on all network interfaces. A paired device can fetch any clip in the open project over that unencrypted connection, including its audio file, its name and the file's path on your computer.
- **Spell-check dictionaries.** On Windows, Electron's documentation says its spell checker downloads dictionaries from a Google server by default, and this app does not change that default. This comes from the documentation and has not been observed in this app.
- **Links you click.** They open in your browser.

Limits of this statement:

- It covers the desktop app's source in `main/`, `frontend/` and `shared/`, not Meta's own *Meta Haptics Studio* build or code from dependencies.
- It does not cover the companion apps in `companion/`, which the commands above do not search, or Meta's Quest app. The Quest project includes Unity and Meta's XR SDK, whose own reporting has not been audited.
- The app's "Data Preferences" menu item offers no real choice: `hasConsent` is always true, and nothing is sent either way.
- The app grants its own local pages every browser permission they request, so no permission prompt appears inside the app (`git grep -n "setPermissionRequestHandler" -- main/src`). Its main window shows only those local pages.
