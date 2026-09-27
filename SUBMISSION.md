# SUBMISSION — Assignment 1: Extend Walker Jumpman

| Field | Value |
|---|---|
| Assignment | Assignment 1 - Extend Walker Jumpman |
| Student | Jiean Yin |
| Project name | walker-jumpman-jiean-yin |
| GitHub repository/folder URL | https://github.com/Jiean-Yin/walker-jumpman-jiean-yin |
| Submitted commit SHA | Given in the Canvas submission note: the `main` commit that merges this file. A commit cannot contain its own SHA. |
| Game-source revision shown in the film | tag `film-source-v1` = `eb851a678ce4a5a998d1824745678a6d2526f03e` |
| Godot version and operating system | Godot 4.7.2.stable.official.ed1daf0bf (regular build, Compatibility renderer) · Windows 11 Home 10.0.26200 |
| Final film URL and filename | Attached to the Canvas submission (no course media storage was available): `claude-liam-walker-jumpman-jiean-yin-walkthrough.mp4` |
| Final film SHA-256 | `06606492d6c6edee40d70dd671191cd836228a2fbc9eaf4cb6985c9309f0159a` |

## Summary of my changes

- **New main character:** a helmeted spear-carrier (yellow tunic, blue dome helmet with a forward brim, eye and spear showing facing; the spear tilts while running). On death: XX eyes, the spear is lost, and a visual-only hop. Gap deaths pop up from the screen's bottom edge so they are visible. Collider (18×28), movement tuning, controls, retry, pause and completion are unchanged. Added an F3 debug outline of the real collider.
- **Level extension "03 / CLIMB":** four new landings climbing from y 288 to y 224. L2 has near-edge spikes (land past them); L3 has far-edge spikes (take off before them). The finish moved from x 916 to x 1560; the level is 960 → 1600 px. The original section is unchanged.
- **Consistency fix:** spikes, flag, label, background and progress bar are now drawn from the level data. One `spike_triangles()` function feeds both collision and drawing.
- **Verification:** 58/58 automated checks (starter 25 + 9, added 12 character + 12 level). The route fixture was extended without weakening any assertion, and the one expected failure is kept as evidence. My own structured playtest: 5 deaths at L2 while rushing. Three inspect-and-revise cycles are recorded.
- **Explainer film:** Brutalist `godot-waikthrough walker`, native 4K, real scripted-input engine captures, Liam narration. Sources and evidence are in `youtube/claude-liam-walker-jumpman-jiean-yin-walkthrough/`.

## Known limitations

- Jumping and falling use the idle pose; the spear is decoration outside the collider.
- The whole level restarts on death (starter rule kept); a full run takes me under 20 s.
- One human tester (the author); no evidence yet about new players.
- Tested on Windows only; the macOS launcher is untested.
- The results card says "1 retries" (starter pluralization).
- Film: focus-loss pause is implemented and tested but not filmed (explicit partial walkthrough). Gameplay footage is scripted input, not human play.

## Verification before submitting

- [ ] Fresh clone of the submitted commit runs and passes the test suites (see TEST-REPORT.md commands)
- [ ] `git diff film-source-v1 <submitted-commit> -- godot/ walker-jumpman.command` is empty (the film shows the submitted game source)
- [ ] Film attachment's SHA-256 matches the value above
- [ ] Source ZIP made from the same commit, without `.godot/`, credentials, or MP4/MP3 files
