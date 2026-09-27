# PROMPTS — Extending Walker Jumpman: The Spear-Carrier's Climb

## 1. The human requests that produced this film (Jiean Yin → Claude Code)

Paraphrased from the Claude Code session, in order. The full session transcript is kept by Jiean.

1. "Read through the whole project and understand the structure and purpose of it… explain the result in a rendered film using Brutalist's Godot workflow." (assignment brief pasted in full)
2. Clone Brutalist to a separate folder; later, "Go with A, use C:\dev" (work outside `Documents` because Windows Controlled Folder Access blocks Python/Node there).
3. "Yes, go ahead with all five" (ffmpeg, Python packages in a private 3.11 environment, Remotion, Kokoro voice model, font).
4. "Merged, check and start the film setup" → tag `film-source-v1`.
5. "Use your title, pick Hola, and agree to the partial walkthrough" (title chosen from Claude's suggestion; focus-loss pause not filmed).

## 2. Prompts shown on screen

**B00 — walker opening (illustrative reconstruction, labelled on screen, not a transcript).** No single prompt like this was typed; it summarises the change brief in the form the skill requires:

> Please use Walker to convert my game design document about extending walker-jumpman — a helmeted spear-carrier and a four-landing climb with spike traps — into a playable Godot project. Keep the single jump, the controls and the quick retry.

**BHTF — Your Turn (suggested prompt for the viewer):**

> Use Walker on my walker-jumpman copy: add one new landing after the finish plateau without touching tuning.gd. First change only the level JSON and run the tests — show me what breaks before you fix anything.

## 3. Generation settings

- **Narration:** Kokoro `am_onyx` (local, free, $0.00), speed 1.0, via `runtime/scripts/generate_audio_kokoro.py`. Measured durations are in `beat_sheet.json` (`voice_duration_s`, `actual_duration_s`).
- **Scenes:** Remotion via `runtime/scripts/remotion_scenes.py` (`--scale=2 --image-format=png --crf=16`), with props exactly as in `beat_sheet.json`.
- **No paid generation, no AI video, no voice cloning, no music.**
