# SOURCES — walker-jumpman-jiean-yin

## Starter

- **walker-jumpman "First Steps"** by Nik Bear Brown, [nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman), commit `9387542` (2026-09-10).
  This project is an extension of that starter, not a new game. The starter supplied the Godot project, the movement controller and tuning, session/retry/pause/completion logic, HUD, level loader, the original 0–960 px course, the design package (`GAME-BRIEF.md`, `GDD.md`, `LEVEL-DESIGN.md`, `PRODUCTION-PLAN.md`, `PLAYTEST-PLAN.md`, `ASSET-PLAN.md`, `DESIGN-REVIEW.md`, `DESIGN-STATUS.json`, `BUILD-REPORT.md`, `design/`), the original tests and fixtures, and the original evidence in `evidence/`.
  Those starter documents and evidence files are kept as the starter's historical record and are not rewritten here.

## My additions (Jiean Yin, with Claude Code)

| Area | Files | Summary |
|---|---|---|
| Character identity | `godot/features/player/player.gd`, `godot/game/session.gd` | Helmeted spear-carrier drawing, mirrored facing, spear poses, XX-eyes death with visual-only hop, visible fall death, F3 collider outline |
| Level extension "03 / CLIMB" | `godot/levels/first_steps.json`, `godot/game/session.gd`, `godot/ui/hud.gd` | Four new landings (L1–L4), two spike traps, finish moved to x 1560; spikes/flag/label/background/progress drawn from level data |
| Tests and captures | `godot/tests/test_character.gd`, `godot/tests/test_level.gd`, `godot/tests/capture_character.gd`, `godot/tests/capture_level.gd`; edits to `godot/tests/route_driver.gd`, `godot/tests/capture_game.gd` | 24 added checks; route fixture extended; per-run screenshot folders |
| Documentation | `CHANGE-BRIEF.md`, `TEST-REPORT.md`, `FRICTIONAL.md`, `SOURCES.md`, README changes | Predictions, test record, honest log, credits |
| Evidence | new files in `evidence/` dated from 2026-09-26 | Test reports and screenshots from this project's runs |

## Assets

- **No imported art, audio, or fonts.** The character, terrain, spikes, flag and background are original geometric drawing in GDScript (`draw_rect`, `draw_colored_polygon`, `draw_line`), as in the starter.
- **Font:** Godot's built-in default theme font (`ThemeDB.fallback_font`), shipped inside the engine, as in the starter. No font file is added to the project.
- No paid asset-generation service or purchased API credits were used.

## Tools

| Tool | Version / identity | Use |
|---|---|---|
| Godot Engine | 4.7.2.stable.official.ed1daf0bf (Windows, regular build) | Game engine, headless tests, rendered captures |
| Claude Code (Anthropic) | Claude desktop app, model Claude Opus 5.5, via Northeastern access | Code implementation, tests, captures, drafting documents (see below) |
| Git / GitHub | — | Version control; one branch and pull request per step, merged with merge commits |
| Brutalist | [nikbearbrown/brutalist.art](https://github.com/nikbearbrown/brutalist.art) commit `6a8380ae169cca81e0633664a65c958f5c12ab4b`, used from a local copy at `C:\dev\brutalist.art` | `godot-waikthrough` skill in `walker` mode: beat-sheet pipeline, Remotion scenes (ClaudeComposerAsk, BrutalistHesitantWriter, ClaudeCodeBeat, FormACard, ClaudeVerdictArtifact, ClaudeTitleOutro), compositor, Gate T / Gate V checks, export receipt. **One local Windows patch** (`remotion_scenes.py`: resolve `npx.cmd` via `shutil.which`); not upstream. |
| Kokoro (kokoro-onnx 0.6.1, model v1.0) | voice `am_onyx` ("Liam, in for Bear"), local, free | Film narration; no voice cloning, no paid TTS |
| Remotion | 4.x (npm, via Brutalist's `runtime/remotion`) | Rendering the Claude-style bookend and card scenes at 4K |
| FFmpeg | 9.0.2 full build (Gyan, via winget) | Capture encoding, frame-exact clip trims, labels, held-frame composite, final encode |
| Python | 3.11.4 in a private virtual environment | Running Brutalist's scripts |

The film's full source, script and evidence are in [youtube/claude-liam-walker-jumpman-jiean-yin-walkthrough/](youtube/claude-liam-walker-jumpman-jiean-yin-walkthrough/). The mascot, fonts (EB Garamond, Inter) and Claude-style scene designs are Brutalist's own bundled assets; no other media was imported into the film.

## Human and AI contributions

**Jiean Yin decided, checked, or changed:**
- the character concept (red→yellow tunic, blue helmet, spear showing facing, XX-eyes Mario-style death), the color change to yellow to separate the character from the red spikes, and approval of a long thin decorative spear;
- the level idea (a climb to higher landings with spikes close to the landing areas) and the decision to keep the single jump after dropping the original double-jump/dash idea;
- the predictions in `CHANGE-BRIEF.md`, including F3 (gap sizing) and F4 (death animation vs fast retry);
- the playtest observation that gap deaths showed no animation, which led to revision R1;
- keeping the "FIRST STEPS" header; the project rename; the branch-and-PR workflow; reviewing each diff and merging each PR.

**Claude Code contributed:**
- the drawing code, death/fall-death logic, level-data drawing fixes, route update, and all added tests and capture scripts;
- candidate landing geometry computed from the starter's physics (reviewed by Jiean);
- finding the leg-in-floor defect (revision R2) from screenshots;
- drafting the structure and wording of these documents from the session record. Personal observations and learning in `TEST-REPORT.md` and `FRICTIONAL.md` are Jiean's.

**Film — Jiean Yin decided or checked:**
- the episode title (chosen from Claude's suggestion) and the greeting language ("Hola");
- agreeing to an explicit partial walkthrough (focus-loss pause not filmed);
- the workaround location outside `Documents` (option A, `C:\dev`) and approval of every install;
- watching the final export and approving it ("The file is fine").

**Film — Claude Code contributed:**
- **Script and beat sheet:** all narration, beat structure, scene props and on-screen text, including correcting two of its own overstatements before rendering (FACTCHECK.md).
- **Visuals:** the capture driver and the four gameplay captures (scripted input, real engine), clip trims and labels, the before/after composite, and Remotion scene renders.
- **Narration:** generated with the local Kokoro voice `am_onyx` ("Liam, in for Bear"). It is not a clone of any real person's voice.
- QC: Gate T/V fixes, per-beat declarations with reasons, and spot checks for retiming and outro silence.

**Rejected or changed from AI suggestions:**
I kept "FIRST STEPS" instead of AI's suggested header change, and renamed the project. Manually decided to drop double jump and dash after analysis with AI.
Add Expected/Learned lines to FRICTIONAL.md.