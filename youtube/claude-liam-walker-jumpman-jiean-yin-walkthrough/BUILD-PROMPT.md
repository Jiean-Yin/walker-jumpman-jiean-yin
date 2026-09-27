# BUILD-PROMPT — how to rebuild this film

Paste into Claude Code with Brutalist available. Paths are this machine's; adjust as needed.

```text
godot-waikthrough walker <path to walker-jumpman-jiean-yin checkout>

Read skills/make/godot-waikthrough/SKILL.md, references/capture-and-coverage.md, riff,
ai-explainer, RENDER-TARGETS.md, PIPELINE-SAFETY.md and OUTRO-LOCK.md first.
Film the game at tag film-source-v1 only, on an isolated `git archive` copy.
Capture with capture/capture_driver.gd (real main scene in a 3840x2160 SubViewport,
input events only, --fixed-fps 30), runs run-01..run-04, and verify each summary.json.
Use beat_sheet.json as the script; narration is Liam in for Bear (Kokoro am_onyx).
Gameplay beats are exact capture frame ranges with the scripted-input label; pad each
gameplay narration with silence to its clip's frame count (no retiming). B08 is the
labelled before/after held-frame composite from the repo's evidence stills.
Outro: ClaudeTitleOutro, exact title, @NikBearBrown, voiced title + "At Nik Bear Brown."
plus a 1.0 s silent tail. Keep the partial-walkthrough note for focus-loss pause.
Run ./art godot-waikthrough --check, render 4K, then watch and QC the final export.
Do not publish.
```

## Commands actually used (Windows, Git Bash)

```bash
# environment
export VIRTUAL_ENV=/c/dev/brutalist.art/.venv PYTHONIOENCODING=utf-8 PYTHONUTF8=1
export PATH="/c/dev/brutalist.art/.venv/Scripts:<ffmpeg bin>:$PATH"
# capture (in C:\dev\capture\film-source-v1)
Godot_v4.7.2-stable_win64_console.exe --path godot --fixed-fps 30 --script res://tests/capture_driver.gd -- run-0N <reel>/capture/run-0N
# audio, scenes, check, render (in C:\dev\brutalist.art)
python3 runtime/scripts/generate_audio_kokoro.py <reel>
python3 runtime/scripts/remotion_scenes.py <reel>
./art godot-waikthrough --check <reel>
./art final <reel> --height 2160 --fps 30 --out <reel>/exports/landscape
```

**Local Brutalist patch (Windows portability, not upstream):** `runtime/scripts/remotion_scenes.py` runs `npx` by bare name, which Windows `subprocess` cannot resolve (`npx.cmd`). It was changed to `shutil.which("npx") or "npx"`. No other toolkit file was edited.
