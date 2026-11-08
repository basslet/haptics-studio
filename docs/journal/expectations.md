# Expectations

| Claim | Disproved by | Where to look |
|---|---|---|
| First Steps work as written for `.wav`, `.mp3`, `.ogg`, `.aiff` and `.aif` in a built app. | A format or step failing. | A built app, following `README.md` |
| Meta's published Quest app pairs with a build of this source and plays a clip. | A failed pairing. | A Quest headset and a built app |
| USB preview works for Quest with no network. | No connection. | A Quest headset over USB, network off |
| `SECURITY.md` lists every destination a running build contacts, on macOS and Windows, including whether the Windows spell-check dictionary download happens. | A traffic capture showing another host. | Traffic capture of a running build on each platform |
| The Report a vulnerability button appears once the repository is public and the feature is on. | The command in the next column not showing enabled. | `gh api repos/basslet/haptics-studio/private-vulnerability-reporting` |
| GitHub keeps the Code of conduct entry for the pointer file. | A null `.files.code_of_conduct` once `CODE_OF_CONDUCT.md` is the pointer. Run it then, and delete this row. | `gh api repos/basslet/haptics-studio/community/profile` |
