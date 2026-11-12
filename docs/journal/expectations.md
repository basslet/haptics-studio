# Expectations

| Claim | Disproved by | Where to look |
|---|---|---|
| Meta's published Quest app pairs with a build of this source and plays a clip. | A failed pairing. | A Quest headset and a built app |
| USB preview works for Quest with no network. | No connection. | A Quest headset over USB, network off |
| `SECURITY.md` lists every destination a running build contacts, on macOS and Windows, including whether the Windows spell-check dictionary download happens. | A traffic capture showing another host. | Traffic capture of a running build on each platform |
| The Report a vulnerability button appears once the repository is public and the feature is on. | The command in the next column not showing enabled. | `gh api repos/basslet/haptics-studio/private-vulnerability-reporting` |
| GitHub keeps the Code of conduct entry for the pointer file. | A null `.files.code_of_conduct` once `CODE_OF_CONDUCT.md` is the pointer. Run it then, and delete this row. | `gh api repos/basslet/haptics-studio/community/profile` |
| Every link in the navigation block to the SDK and Examples opens for a reader who is not signed in. | A 404 for any of them. | Each URL in `scripts/doc_nav.js`, opened signed out once the three repositories are public |
| Every link on the Resources page opens the documentation it names. Checked by research on 2026-11-12, except the FMOD anchor `#haptics-instrument` and the Wwise page, which did not load for it. The PlayStation entry says Sony publishes no public DualSense haptics documentation. The lint does not open web links. | A dead link, or a page about something else. | Open each link in `docs/design-and-integration/resources.md`. |
| A `.wav` export from Haptics Studio plays as haptics on a DualSense controller and feels like the clip, although it renders through the only actuator profile, `meta_quest_pro`. `docs/design-and-integration/resources.md` says it is untested. | No vibration, or a feel that does not match the clip. | A DualSense controller playing a `.wav` export through the platform's PCM haptics path |
