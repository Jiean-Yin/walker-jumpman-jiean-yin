# Gate V — visual QC report

Frames sampled: 26  ·  BLOCKER: 0  ·  MAJOR: 0

Regional text-contrast checks (all declared regions required): B06. Whole-frame dimming/scene color is not text contrast; empty-frame, fill and declared safe-area checks remain active. Visual content review remains required.

Clean — no BLOCKER/MAJOR defects. ✓
---

# Additional QC (recorded by Claude Code, 2026-09-26)

**Export:** `exports/landscape/claude-liam-walker-jumpman-jiean-yin-walkthrough.mp4`, H.264 3840×2160 30 fps + AAC 48 kHz stereo, 192.1 s, 16,219,929 bytes, SHA-256 `06606492d6c6edee40d70dd671191cd836228a2fbc9eaf4cb6985c9309f0159a` (matches `.verified.json`, status `ready`).

| Check | Result |
|---|---|
| Gate T (typography) | PASS. Gameplay B02–B06 and still composite B08 skipped by the raw-footage rule; our labels on them measured separately: gameplay label 52 px text height at x 1360–2597, y 118–169; B08 labels 55 px and 45 px; all ≥ 41 px and inside title-safe (192–3648 × 108–2052). |
| Gate V (frames) | Clean. Per-beat declarations with written reasons: `full_bleed` B02–B06 (real gameplay is edge to edge); `sparse_by_design` B01 (hesitant writer), B09 (Form A card); `contrast_regions` B06 (game's dimming scrim behind results/pause card). |
| Coverage (`./art godot-waikthrough --check`) | FAIL on exactly one item: `focus-loss-pause` (implemented, not filmed; explicit partial walkthrough agreed by Jiean Yin). All other evidence verified on a scratch copy with only that entry removed: 4 captures native 3840×2160, hashes match, input logs present, beat references valid. |
| No retiming | Final-film frames at B04 f85/f212, B05 f177, B06 f208 match their source clip frames within 1 frame at a constant offset (ffmpeg seek precision); no drift across beats. |
| Outro audio | Voice present (mean −25.9 dB in the first 4.5 s of BOUT); last 1.0 s is digital silence (−91 dB). No jingle, no game audio. |
| Labels present | B00 / BHTF reconstructed-interface labels; B07 actual-source + reconstructed-editor label; B02–B06 scripted-input label; B08 held-frames label. |
| Advisory (not blocking) | §8.10: B09 narration overlaps its card text (0.82). Accepted: the credits card is meant to be read. |

**Known presentation limits:** B07 displays tabs as two spaces and wraps two long lines (marked on screen); the outro title wraps as "Spear-/Carrier's". The results card's "1 retries" is the starter's text (reported as a defect in the verdict).

# Human review — Jiean Yin

Jiean Yin watched the final export (SHA-256 `06606492…159a`) and reported in the Claude Code session on 2026-09-27: **"The file is fine."** No defects were reported, so no re-render was made.

*Recorded by Claude Code from Jiean's message. The itemised checklist below was not filled item by item; Jiean may add detail.*

- Watched the complete film start to finish:
- Narration intelligible throughout:
- Gameplay matches what the narration says (B02–B06):
- Labels readable:
- Opening/closing order correct:
- Anything wrong or misleading: none reported
