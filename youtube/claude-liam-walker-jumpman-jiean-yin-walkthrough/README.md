# Film records — "Extending Walker Jumpman: The Spear-Carrier's Climb"

Source, script and evidence for the explainer film. The film itself (`claude-liam-walker-jumpman-jiean-yin-walkthrough.mp4`, SHA-256 `06606492d6c6edee40d70dd671191cd836228a2fbc9eaf4cb6985c9309f0159a`) is submitted on Canvas; it is not stored in GitHub.

The film was built outside this repository, in `C:\dev\reels\claude-liam-walker-jumpman-jiean-yin-walkthrough\`, with Brutalist `6a8380a` (see [BUILD-PROMPT.md](BUILD-PROMPT.md)). These are copies of its text records.

| File | What it is |
|---|---|
| [beat_sheet.json](beat_sheet.json) | The script: every beat's narration, visuals, measured durations, labels and QC declarations |
| [coverage.json](coverage.json) | Feature-to-footage evidence map (the skill's contract): 20 implemented features, 6 planned |
| [CAPTURE.md](CAPTURE.md) | How gameplay was captured: isolated copy of `film-source-v1`, 4K SubViewport, input path, hashes |
| [capture/](capture/) | Capture driver, per-run input logs (`*-inputs.jsonl`), pass/fail summaries, source snapshot |
| [RIFF.md](RIFF.md) | What each gameplay beat shows, the interpretation, and its source |
| [SHOTLIST.md](SHOTLIST.md) | Visual for every beat, with on-screen labels |
| [FACTCHECK.md](FACTCHECK.md) | Every claim with its source, including two corrections made before rendering |
| [PROMPTS.md](PROMPTS.md) | Human requests that produced the film, and the on-screen prompts |
| [BUILD-PROMPT.md](BUILD-PROMPT.md) | How to rebuild it, including the local Windows patch to Brutalist |
| [TYPECHECK.md](TYPECHECK.md), [_qc/REPORT.md](_qc/REPORT.md), [_qc/contact_sheet.png](_qc/contact_sheet.png) | Gate T and Gate V results, additional checks, and the human review |
| [exports/landscape/…verified.json](exports/landscape/claude-liam-walker-jumpman-jiean-yin-walkthrough.verified.json) | Brutalist's export receipt: output SHA-256 plus hashes of every input clip and narration file |
| [_labels/](_labels/) | Exact text of the burned-in labels |

**Not in GitHub:** the capture MP4s (`capture/run-0N.mp4`, whose hashes are in `coverage.json` and `CAPTURE.md`), the PNG frame sequences, the narration MP3s and the rendered scene clips. They are kept locally in the build folder above.

The `capture_driver.gd` here has Windows line endings in a Windows checkout. Its recorded SHA-256 (`29edd840…`) is for the original LF file, which is exactly the blob stored in git.
