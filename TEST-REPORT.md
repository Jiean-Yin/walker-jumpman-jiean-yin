# TEST-REPORT — walker-jumpman-jiean-yin

| Field | Value |
|---|---|
| Game-source revision tested | `eb851a6` (merge of PR #3; game files identical to `cdbb39d`) |
| Engine | Godot 4.7.2.stable.official.ed1daf0bf (regular build, Compatibility/OpenGL 3.3) |
| Machine | Windows 11 Home 10.0.26200, NVIDIA GeForce RTX 3070 Ti Laptop GPU |
| Starter | [nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman) `9387542` |
| Brief | [CHANGE-BRIEF.md](CHANGE-BRIEF.md), committed `cc5d2d8` before any code |

> **Who produced what.** Automated results below were run by Claude Code and are
> reproducible from the commands listed. Sections marked **HUMAN PLAYTEST** are
> Jiean Yin's own observations from playing with normal controls. An automated
> input route is not a human playtest and is never counted as one here.

## 1. Baseline (unchanged starter, before any gameplay change)

Commit `0273848`. Same engine build as the starter's macOS report.

| Suite | Result | Evidence |
|---|---|---|
| Mechanics (`test_game.gd`) | 25/25 pass | `evidence/mechanics-1790464698.06.json` |
| Keyboard (`test_keyboard.gd`) | 9/9 pass (run twice) | `evidence/keyboard-1790464716.276.json`, `evidence/keyboard-1790464730.984.json` |
| Visual route (`capture_game.gd`) | completed, 0 deaths | `evidence/screens-1790464758/` |

Jump rise 56.07 px, worst automatic retry 34 ticks, and route 325 ticks: identical to the starter's report.
The starter's own evidence files are preserved unchanged.

## 2. Results by check

### Startup and controls

- **Automated:** keyboard suite 9/9 on the final source (Enter start, A/D move, Space jump, Esc pause, Enter resume, R retry, Enter replay, P then M menu, restart from menu), `evidence/keyboard-1790470197.526.json`. Controls and `tuning.gd` are unchanged; `tuning-unchanged` passes.
- **HUMAN PLAYTEST (Jiean):** The project started and the controls worked with the real keyboard ("other functions work pretty well"); see section 6.

### Character appearance

- **Automated:** `collider-unchanged` (18×28 at (0, −14)), `facing-follows-input`, `spear-pose` (≈25° running, ≈0° idle and airborne), `death-sets-dead-pose`, `death-hop-visual-only`, `fall-death-body-frozen`, `fall-death-hop-visible`, `fast-retry-clears-dead-pose`: character suite 12/12, `evidence/character-1790470201.723.json`.
- **Stills with the collider outline (F3):** `evidence/character-screens-1790470232/` covers idle and running facing right and left, rising, falling, spike death, and fall death. The body stays inside the 18×28 box. The thin spear is decoration and extends outside it (about 12 px above the helmet when upright, about 11 px ahead when running), as stated in the brief.
- **HUMAN PLAYTEST (Jiean):** I used the F3 overlay while playing; it worked. Earlier play led to revision R1 (invisible fall death). No other appearance problem was noted.

### Extended route

- **Automated (scripted input through `test_control`, not human play):** `route-stands-on-all-new-landings` records standing on L1, L2, L3 and L4, then completing at (1558, 224) with 0 deaths in 567 ticks. `walking-without-jumping-cannot-progress` fails from the original end, L1, L2 and L3, so every new landing requires a jump. `finish-relocated-onto-L4` passes. Level suite 12/12, `evidence/level-1790470218.857.json`.
- **HUMAN PLAYTEST (Jiean):** I held **D** the whole time to move right and finish as fast as possible. In about 10 minutes of quick testing I died **5 times at L2**, on the spikes beside the corner where I should land. The gap there is smaller, and the spike needs a careful jump, but I kept using the jumping habit I had built on the earlier gaps. I did reach both spike landings and the relocated finish. See section 6.

### Failure and recovery

- **Automated:** `L2-short-hop-lands-on-spikes` (dies at x 1147), `L3-late-jump-clips-far-spikes` (jump at x 1391 dies), `L2-safe-area-is-safe`; the starter's `actual-spike-collision`, `fall-boundary`, `respawn`, `twenty-retries` (worst 34 ticks) and `replay-idempotent` all pass; `no-phantom-death-after-fast-retry` passes.
- **HUMAN PLAYTEST (Jiean):** Five real spike deaths at L2 each gave the automatic retry. I pressed R in the middle of a death and used Enter to replay after completing; both worked. Gap deaths were observed earlier (R1).

### Camera and presentation

- **Automated:** `next-landing-visible-at-takeoff` (each new landing is on screen at its takeoff), `finish-in-view-at-completion`, `new-landings-below-top-hud` (highest landing top y=224, flag top y=154, HUD bottom edge y=74), `progress-bar-uses-relocated-finish` (0.999 at completion), `progress-not-full-at-old-finish` (0.57 at x 916).
- **Stills:** `evidence/level-screens-1790469975/` (whole level with collider outline) and `evidence/screens-1790470221/` (menu, spike failure, jump, completion).
- **HUMAN PLAYTEST (Jiean):** No visibility or readability problem was reported. Camera and text were not commented on separately.

## 3. Automated checks: commands, failures, and updated tests

From the repository root, with `G=C:/Godot/Godot_v4.7.2-stable_win64_console.exe`:

```bash
$G --headless --path godot --script res://tests/test_game.gd       # starter mechanics + route
$G --headless --path godot --script res://tests/test_keyboard.gd   # starter keyboard
$G --headless --path godot --script res://tests/test_character.gd  # added: character
$G --headless --path godot --script res://tests/test_level.gd      # added: level extension
$G --path godot --script res://tests/capture_game.gd               # screenshots (opens a window)
$G --path godot --script res://tests/capture_character.gd
$G --path godot --script res://tests/capture_level.gd
```

**Final run on the tested source:**

| Suite | Checks | Result | Evidence |
|---|---:|---|---|
| Starter mechanics | 25 | all pass | `evidence/mechanics-1790470196.29.json` |
| Starter keyboard | 9 | all pass | `evidence/keyboard-1790470197.526.json` |
| Character (added) | 12 | all pass | `evidence/character-1790470201.723.json` |
| Level extension (added) | 12 | all pass | `evidence/level-1790470218.857.json` |
| **Total** | **58** | **all pass** | |

**Failures recorded along the way (kept, not deleted):**

| When | What failed | Why | Response |
|---|---|---|---|
| First baseline attempt | Mechanics run hung for more than 5 minutes, no report | Unknown; three later runs, including the same command, never reproduced it | Reran with a 60 s limit: 25/25. Cause left unexplained. |
| Level data changed, tests unmodified | `complete-real-route` **FAIL**: the old route fell into the new 960→1008 gap at x 1001 (`evidence/mechanics-1790469727.493.json`); `capture_game.gd` assertion also failed | The route fixture's jump marks ended at x 712, for the old finish | Updated the fixture (below) |

**What changed in the tests, and why nothing was weakened:**

- `route_driver.gd`: the starter's five jump marks (x 138–712) are unchanged; four were added (930, 1090, 1230, 1375) for L1–L4. The assertion in `complete-real-route` is unchanged (state COMPLETE with 0 deaths, within 900 ticks).
- `capture_game.gd`: output moved from `evidence/screens/` to `evidence/screens-<unix-time>/`, so the starter's screenshots are never overwritten. No assertion changed.
- No starter assertion or tolerance was edited or removed. `fixed-jump-and-no-double` still passes; the single jump is unchanged.
- **Limitation of the fixtures:** the route and the new level checks drive the player through `test_control` (scripted input), and some checks place the player at a position, like the starter's spike check. The starter's coyote/buffer checks seed timing state. These are mechanical checks, not evidence of how a person plays.

## 4. Inspect-and-revise cycles

| # | Observation (who, how) | Cause | Change | Check afterwards |
|---|---|---|---|---|
| R1 | **Jiean's playtest:** dying in a gap showed no death animation | The fall boundary is y=430, below the visible screen (bottom bar starts at y=335) | The fall death is drawn popping up from the playfield's bottom edge; body, fall boundary and 0.55 s retry unchanged (`3b306ba`) | `fall-death-hop-visible`: drawn head reaches y=289, hidden again at death tick 25 (retry at 34); still `evidence/character-screens-1790469163/09-fall-death-popup.png` |
| R2 | **Claude's screenshot review:** the running leg was drawn about 2 px into the floor | The starter's stride formula grows a leg downward | A lifted foot now shortens upward (`3b306ba`) | Before/after: `evidence/character-screens-1790468107/02-run-right-collider.png` vs `evidence/character-screens-1790468333/02-run-right-collider.png` |
| R3 | **Stills after the data-only level change:** spikes drawn at floor height while their collision sat on the landing tops; flag inside L4; progress bar full at x≈1000; background ending at x 960 | Drawing code hard-coded to the starter's layout (y=320, 852, 960) | One `spike_triangles()` function feeds collision and drawing; flag, label, background and progress come from level data (`cdbb39d`) | `spikes-drawn-where-they-collide`; before `evidence/level-screens-1790469914/`, after `evidence/level-screens-1790469975/` |

The structured playtest (section 6) led to no further change: the 5 deaths at L2 came from the intended decision. Its open questions are recorded in [FRICTIONAL.md](FRICTIONAL.md#open-questions).

## 5. Known limitations and uncertainties

- Jumping and falling use the idle pose (a design choice); airborne state is shown by motion only.
- The spear is decoration outside the collider; players could read the tip as touching a spike when it does not.
- Death restarts the whole 1600-px level; no checkpoints (starter rule kept).
- Gap sizes were chosen from a continuous-physics estimate with about 20 px margin. They are verified reachable by script, but fairness for new players is untested beyond Jiean's own play.
- One human tester (the author). No other players were observed.
- Verified on Windows only. The macOS launcher (`walker-jumpman.command`) was not tested.
- `evidence/build-manifest.json` is still the starter's; source hashes were not regenerated because Windows line-ending conversion (`core.autocrlf=true`) changes file bytes.
- The starter's terrain hatch lines can extend a few pixels past a platform's right edge (cosmetic, starter behavior).
- F3 (collider outline) is a debug key added by this project; it changes display only.

## 6. HUMAN PLAYTEST session record (Jiean)

**Tester:** Jiean Yin (the author), experienced with this style of platformer. **Revision:** `eb851a6`. **Date:** 2026-09-26. **Controls:** normal keyboard.

**Approach:** "I am pretty familiar with this kind of gaming style, and am sure I will not die if playing with extra care." So I tested the fastest way instead: holding **D** continuously and trying to finish quickly.

**Observed:**
- In about 10 minutes of quick testing I died **5 times at L2**, on the near-edge spikes beside the corner where I should land. In my words: the gap got smaller, and the spike beside the landing corner requires a careful jump, while I kept following the jumping habit I had got used to on the earlier gaps.
- I specifically tried the **F3** collider overlay, pressing **R in the middle of a death**, and **Enter to replay** after finishing. All worked, and felt fun.
- Other functions worked well.
- A full run takes under 20 seconds, so restarting from the spawn point after a death did not feel frustrating.

**Interpretation (separate from observation):** the L2 trap changed how I had to play. The jump habit that worked on the earlier, wider gaps kept landing me on the spikes until I adjusted. By the geometry, L2's near-edge spikes catch a jump that lands short, meaning it takes off too early or too slowly (check `L2-short-hop-lands-on-spikes`). This is evidence against F3's worry that the challenge would be meaningless. It is one experienced tester's session, not evidence about new players. I did not change the geometry after this session, because the deaths came from the intended decision, not from an unfair or unreadable jump.
