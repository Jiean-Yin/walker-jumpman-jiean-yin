# CAPTURE — walker-jumpman-jiean-yin walkthrough

## Game revision captured

| Field | Value |
|---|---|
| Repository | https://github.com/Jiean-Yin/walker-jumpman-jiean-yin |
| Tag / commit | `film-source-v1` = `eb851a678ce4a5a998d1824745678a6d2526f03e` |
| Engine | Godot 4.7.2.stable.official.ed1daf0bf, Compatibility/OpenGL 3.3, NVIDIA GeForce RTX 3070 Ti Laptop GPU |
| OS | Windows 11 Home 10.0.26200 |
| `build_id` | `74c10e5894dffe6e6a6ce27c7f3840d5cf932b2f92ac6d429fae74478b3dc987` |

**Build-id method:** SHA-256 of `capture/source-snapshot.txt`, which is `git ls-tree -r film-source-v1 godot | sort -k4` (20 files: mode, type, blob SHA-1, path). Anyone can recompute it from the tag.

## Isolated copy

The game files were exported with `git archive film-source-v1 godot` into `C:\dev\capture\film-source-v1\` (not linked to the repository). Two harness files were added to that copy only, under `godot/tests/`:
- `capture_driver.gd` (SHA-256 `29edd840197d88bb6ae42edf460e09a33191a67ae0fc793a9f1d58685dd09134`), copied here as `capture/capture_driver.gd`
- `probe_movie.gd`, a size probe only

No game source file was changed. The repository and its open instance were not touched.

## Why a SubViewport, not Movie Maker

A probe with Godot Movie Maker (`--write-movie … --fixed-fps 30 --resolution 3840x2160`) recorded only **1280×720**, because the laptop screen is 1920×1080 and the window is clamped (`PROBE screen=(1920, 1080) window=(1924, 1050)`). That is not native 4K.

The driver therefore instantiates the real main scene `res://game/main.tscn` inside a **3840×2160 SubViewport** with `size_2d_override = 640×360` and `size_2d_override_stretch = true`. This is the same logical canvas and stretch the game uses (`canvas_items`, 640×360). All game art is vector drawing (`draw_rect`, `draw_colored_polygon`, `draw_line`, font text), so each frame is rasterized natively at 3840×2160, not enlarged from a smaller recording. The logical resolution is 640×360.

## Timing

- Command: `Godot_v4.7.2-stable_win64_console.exe --path godot --fixed-fps 30 --script res://tests/capture_driver.gd -- <run-id> <out-dir>`
- `--fixed-fps 30` gives every engine frame exactly 1/30 s of game time, independent of wall-clock speed (frame saving is slower than real time). Physics runs at the project's 60 Hz, 2 ticks per frame. This is offline rendering and **not evidence of real-time frame rate**.
- Each frame: advance one engine frame, then `RenderingServer.force_draw(false)`, then save the SubViewport texture as PNG.
- First attempt: the driver waited on `RenderingServer.frame_post_draw`. run-02 **stalled at frame 216** when Windows stopped drawing the (covered or unresponsive) window. It was stopped and discarded. The driver was changed to force-draw, and **all four runs were re-captured** with the same driver version (run-01 included), so every capture comes from one script.

## Input path

- Keys: `Input.parse_input_event(InputEventKey)` (the action state `player.gd` polls) **and** `SubViewport.push_input(event)` (so `session.gd`'s `_unhandled_input` receives Enter/Esc/R/M/F3). Jumps are press-then-release on the next frame.
- Mouse: `InputEventMouseMotion` then `InputEventMouseButton` press/release pushed into the SubViewport at the START button's logical position (320, 232).
- The driver may observe the player's position to choose inputs, as the route fixture does (jump at x marks, only when on the floor). It never teleports the player, sets state, uses `test_control`, or edits velocity.
- **One harness setting:** `session.test_mode = true`. Its only effect is to disable the automatic pause on window focus loss, so an unattended capture is not paused by the OS. Consequence: the focus-loss pause feature is **not filmed**. It is verified by the automated test `focus-loss-pauses`. Jiean Yin explicitly agreed to this partial walkthrough on 2026-09-26.
- Every input is logged with frame, seconds, physics tick, state, position and deaths: `capture/run-0N-inputs.jsonl`.
- Each run asserts its expected outcomes and quits nonzero on failure (`capture/run-0N/summary.json`). All 16 expectations passed.

## Captures

| Run | Content | Frames (s) | Capture file SHA-256 |
|---|---|---|---|
| run-01 | Menu, mouse click START, run/turn/jump, F3 collider overlay | 368 (12.267) | `46c049da9682d0aa1c5fad66f32d8bea0d7f4602c262b138701d663bcc672831` |
| run-02 | Starter course with 0 deaths, Esc pause, Enter resume, R restart | 338 (11.267) | `bf130ab1ec735f66897f783f3d1f6a4d22f5e78ef25ff09553d78f32f3d9681e` |
| run-03 | Spike death, gap death (fall pop-up), spike death and R mid-death | 342 (11.400) | `9b96fc5f809955021450efb9defc44abf19a26224db0453724abad8e79c251d2` |
| run-04 | L2 standstill-hop death, full climb to relocated finish, results, replay, pause, main menu | 806 (26.867) | `1870376828060992c4a9779bf87569fabc92761c3b0eed18bbeb609e9832da55` |

PNG frames were encoded with `ffmpeg -framerate 30 -i %05d.png -c:v libx264 -preset slow -crf 10 -pix_fmt yuv420p -r 30`. Frame counts were verified with `ffprobe -count_frames`. The PNG frame folders are kept locally until final evidence is verified; they are not committed.

## From capture to film

Gameplay beats B02–B06 are exact frame ranges of the capture files (`select=between(n,F0,F1-1)`, `setpts=N/30/TB`), with no speed change. The only addition is a burned label: "Scripted input · real Godot render · film-source-v1" (56 px, top centre). Each beat's narration was padded with silence to the clip's exact frame count, so the compositor ratio is 1.000000 (no retime, slow-down, or center-cut).

| Beat | Capture | Frames |
|---|---|---|
| B02 | run-01 | 0–367 |
| B03 | run-02 | 0–337 |
| B04 | run-03 | 0–341 |
| B05 | run-04 | 90–379 |
| B06 | run-04 | 380–805 |

Frames 0–89 of run-04 (the starter section, already shown in B03) are not used in the film.

The game is silent, so there is no game audio to keep or mute. No sound effects were added.
