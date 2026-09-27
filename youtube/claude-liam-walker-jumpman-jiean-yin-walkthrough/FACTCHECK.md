# FACTCHECK — Extending Walker Jumpman: The Spear-Carrier's Climb

Every spoken or on-screen claim, with its source. "Repo" = https://github.com/Jiean-Yin/walker-jumpman-jiean-yin at `film-source-v1` (`eb851a6`) unless stated otherwise.

| Beat | Claim | Source / check | Status |
|---|---|---|---|
| B00 | Jiean Yin extended Nik Bear Brown's walker-jumpman starter, following Walker's workflow, with Claude Code | Repo `SOURCES.md`; starter `nikbearbrown/walker-jumpman` `9387542`. "Walker" here means the brief → build → playtest → inspect → revise workflow; the Walker toolkit software was **not** installed. | OK after correction (was "with Walker and Claude Code") |
| B00 | The composer prompt is an illustrative reconstruction, not a transcript | Stated aloud and labelled on screen | OK |
| B00 | "Character redrawn; collider unchanged." / "Level extended; finish moved to the top." / "58 automated checks pass." | `test_character` `collider-unchanged`; `first_steps.json` finish [1560,168,24,56] on L4; TEST-REPORT §3 (25+9+12+12) | OK |
| B01 | Starter level one kept: two gaps, a spike, a flag; same jump, controls, retry | `first_steps.json` x 0–960 unchanged; `tuning.gd` unchanged (`tuning-unchanged`); starter 25/25 + 9/9. Controls unchanged except an added **F3** debug key (display only), shown in B02. | OK (F3 noted) |
| B01 | Spear-carrier replaces the blue block | Starter `player.gd` drew a blue rectangle with an orange band; repo `player.gd` `_draw` | OK |
| B01 | Four landings stepping upward, two guarded by spikes, flag moved to the top | `first_steps.json` solids 5–8 (tops y 288/272/240/224), hazards [1136,256] and [1400,224] | OK |
| B01 | No cherries, no sound, no new abilities | No cherry, audio or ability code in repo; `fixed-jump-and-no-double` passes | OK |
| B02 | A mouse click starts the game | run-01 input log frame 46; summary check "mouse click on the START button starts the game" | OK |
| B02 | Native 4K, scripted input, not a human playtest | CAPTURE.md (SubViewport 3840×2160; `verify_walkthrough.py` dimension check) | OK |
| B02 | Collision box still 18×28 | `player.gd` collider; check `collider-unchanged` | OK |
| B03 | Starter's own course, by Nik Bear Brown: two steps, a spike, two gaps | `STARTER-README.md`; starter level data | OK |
| B03 | Esc pauses, Enter resumes, R restarts at spawn, retry counter stays 0 | run-02 log frames 230/281/302; summary checks; visible "RETRIES 00" | OK |
| B04 | Spike death: X eyes, hop, back to start | run-03 frames 85–122; `player.gd` death drawing | OK |
| B04 | A gap death happens below the screen, so its hop is drawn from the bottom edge | `level.fall_y = 430`; HUD bottom bar at y=335; `session.gd` `player.die(fell, 335.0)`; check `fall-death-hop-visible` | OK |
| B04 | R mid-death respawns at once | run-03 frame 306; check "R mid-death respawns alive" | OK |
| B05 | A standstill jump from L1 lands on L2's near-edge spikes | run-04 frames 249–267 (death at x≈1149); test `L2-short-hop-lands-on-spikes` | OK |
| B05 | In Jiean's playtest, this trap cost five deaths | Repo TEST-REPORT §6: 5 deaths at L2 in about 10 minutes (Jiean was rushing, holding D, not jumping from a standstill; "this trap" = L2's near-edge spikes) | OK |
| B06 | Take off before L3's far-edge spikes, not at the edge | run-04 frame 554 takeoff x≈1377 (spikes start at x 1400); test `L3-late-jump-clips-far-spikes` | OK |
| B06 | Ten point one seconds, one retry | Results card at run-04 frame ~620: "10.1 seconds / 1 retries" (attempt time; 1 death this session) | OK |
| B06 | Enter plays again; M returns to the menu | run-04 frames 688 and 755; summary checks | OK |
| B07 | Starter drew spikes at a hard-coded floor height | Starter `session.gd` `_draw`: `Vector2(x,320),Vector2(x+4,304),…` | OK |
| B07 | Data-only change put collision on landing tops but drew spikes in the pillars | Repo `evidence/level-screens-1790469914/`; TEST-REPORT R3 | OK |
| B07 | One function builds the triangles; collision and drawing both use it | `session.gd` lines 78, 98–104, 221 (verbatim excerpt on screen) | OK |
| B08 | Held frames from 720p test evidence | `evidence/level-screens-1790469914/03-camera-x1280.png`, `…-1790469975/03-camera-x1280.png` (1280×720) | OK |
| B09 | 58 automated checks pass, 24 added | TEST-REPORT §3: 25 + 9 + 12 + 12; added = 12 + 12 | OK |
| B09 | One human played it: Jiean | TEST-REPORT §6; README limitations | OK |
| B09 | Jiean chose the character and the climb and made or approved every design decision; Claude Code wrote the code, tests, captures and this script | Repo `SOURCES.md` human/AI contributions | OK after correction (was "every design decision") |
| B09 | Game shown is film-source-v1 | CAPTURE.md build id; tag → `eb851a6` | OK |
| BVDT | Observed working: character, four landings, both traps, finish, retry, replay | B02–B06 captures; coverage.json | OK |
| BVDT | Defects: "1 retries"; jump looks like standing | Results card frame; `player.gd` (airborne uses idle pose) | OK |
| BVDT | Untested with newcomers; only human tester is the author | TEST-REPORT §5–6 | OK |
| BVDT | Focus-loss pause checked by a test, not shown | test `focus-loss-pauses`; coverage.json partial walkthrough | OK |
| BHTF | Suggested prompt, an invitation (not a claim of a past run) | Labelled "Reconstructed interface · suggested prompt" | OK |
| BOUT | Title and handle | OUTRO-LOCK | OK |

**Not claimed anywhere:** that the game is fun or fair, that newcomers understand the traps, real-time frame rate, or any human reviewer other than Jiean.
