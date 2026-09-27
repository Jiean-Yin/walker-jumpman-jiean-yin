# FRICTIONAL — honest log, walker-jumpman-jiean-yin

> **How this log was written.** Entries 1–11 were organized retrospectively on
> 2026-09-26 by Claude Code from the session transcript, commits, and evidence
> files. The **"What happened"** lines are factual records. The **"Expected"** and
> **"Learned / still unsure"** lines are Jiean's own words. Entries with only a
> "What happened" line are factual records with no personal note added.
>
> **H** = Jiean (human), **AI** = Claude Code.

## 1. Reading the starter and choosing the toolchain

- **What happened:** AI read the whole repository and reported that Godot was not unzipped and Brutalist was not in the checkout. H unzipped Godot 4.7.2 to `C:\Godot` (the same build the starter used). H asked where Brutalist should go; AI checked the assignment text and the starter README, and recommended a sibling folder. H approved; AI cloned it (commit `6a8380a`) and found the `godot-waikthrough` skill and its Windows gaps (no ffmpeg, `python3` not usable in Git Bash).
- **Expected:** AI will automatically choose some places most convenient to its work, or look for what I already implemented.
- **Learned / still unsure:** At least I have the right and obligation to know where and how AI make changes.

## 2. First level idea: double jump and dash (dropped)

- **What happened:** H's first brief proposed double jump and a horizontal dash. AI pointed out that this changes the movement contract, contradicts the starter test `fixed-jump-and-no-double` and GDD §13, and would require weakening an expected result. H chose to keep the single jump and make the challenge from layout. The dropped idea and its predictions F1–F2 remain struck through in `CHANGE-BRIEF.md` (`cc5d2d8`).
- **Expected:** I first considered extra functions as one or two more extended coding works to implement in existing abilities.
- **Learned / still unsure:** First, I need to read the instructions and requirements more carefully. Then, I also need to learn more about the original works before making changes.

## 3. Writing predictions before code

- **What happened:** H wrote the character concept and predictions F3 (gap too short/long) and F4 (death animation vs fast retry); AI structured the markdown and proposed candidate landing geometry from the starter's physics. The brief was committed alone on `main` before any code (`cc5d2d8`).
- **Expected:** Adding some extra cool staff that makes the existing game more interesting and challenging.
- **Learned / still unsure:** As an active game player, my thoughts are limited to gameplay performance and my own playing habits. As a developer, I should pay more attention to the exact stats and changing points. Also, adding functions for testing only to help debugging.

## 4. Baseline test run hung once

- **What happened:** The first headless mechanics run hung for more than 5 minutes without writing a report. AI stopped it and reran with a 60 s limit: 25/25 in seconds. Three later runs never reproduced it. Cause unknown (first-launch overhead is only a guess). Baseline: 34/34 (`0273848`, `evidence/mechanics-1790464698.06.json`).
- **Expected:** I have run it myself, so I thought the test had passed based on my playing experience.
- **Learned / still unsure:** Playing something through terminal or third party APPs may require higher permission than running it directly. Maybe running through the terminal behaves differently… I don't know the real cause.

## 5. Pull request opened against the instructor's repository

- **What happened:** The first PR went to `nikbearbrown/walker-jumpman` ([#2](https://github.com/nikbearbrown/walker-jumpman/pull/2)) because GitHub defaults a fork's PR base to the parent. AI detected it via the GitHub API when checking the merge. H closed it unmerged and reopened it on the own repository ([Jiean-Yin/walker-jumpman-jiean-yin#1](https://github.com/Jiean-Yin/walker-jumpman-jiean-yin/pull/1)). Nothing reached the instructor's code.
- **Expected:** Since I alreay forked and am working on my own repository, every new changes should go to mine.
- **Learned / still unsure:** Software works may contradict to human insights and I need to pay more attention especially to the result and double check.

## 6. Character colors: red → yellow

- **What happened:** H's concept used a red character. AI noted the spikes are red (`#d24e42`) and the GDD asks for strong player/hazard separation. H changed the tunic to yellow; AI added a dark outline for contrast on the cream background. H approved a long thin decorative spear that extends outside the collider.
- **Expected:** Randomly pick a different color to distinguish.
- **Learned / still unsure:** Designs should based on actual experience.

## 7. Leg drawn into the floor (found by AI)

- **What happened:** AI's close-up screenshots showed the running leg drawn about 2 px into the floor, inherited from the starter's stride formula. AI changed it so a lifted foot shortens upward. Before/after: `evidence/character-screens-1790468107/` vs `evidence/character-screens-1790468333/` (`3b306ba`).
- **Expected:** Small changes I may ignored and may cause problems in the future.
- **Learned / still unsure:** A quick check and fix to every small mistake guarantee the smooth proceeding of work.

## 8. Fall death was invisible (found by H while playing)

- **What happened:** While playing, H noticed that falling into a gap showed no death animation. Cause: the fall boundary (y=430) is below the visible screen. H asked for it to be visible; AI drew the fall death popping up from the playfield's bottom edge without changing physics or retry timing. New checks `fall-death-body-frozen` and `fall-death-hop-visible` pass (head reaches y=289, hidden again before the retry) (`3b306ba`).
- **Expected:** Adding a small animation everytime the character was found death.
- **Learned / still unsure:** I did not fully understood the falling code logic, and it turns out that falling to death happened somewhere lower than the visible scene. Good to have AI to quickly diagonise that.

## 9. Moving the finish broke the route test, as predicted

- **What happened:** AI changed only the level data and ran the unmodified tests: `complete-real-route` failed (the old route fell into the new gap at x 1001), kept as `evidence/mechanics-1790469727.493.json`. The route fixture was then extended with four jump marks; the assertion was not changed. The route completed on the first try: 9 jumps, 0 deaths, 567 ticks (`cdbb39d`).

## 10. Hard-coded drawing produced invisible spikes

- **What happened:** After the data-only change, stills showed spikes drawn at floor height while their collision sat on top of L2 and L3 (invisible hazards), the flag inside L4, the progress bar full too early, and no background after x 960 (`evidence/level-screens-1790469914/`). AI made one `spike_triangles()` function feed both collision and drawing and moved the other drawing onto level data (`evidence/level-screens-1790469975/`, check `spikes-drawn-where-they-collide`).


## 11. Tooling friction on Windows

- **What happened:** Git warns "LF will be replaced by CRLF" on every commit (`core.autocrlf=true`), so the starter's source-hash manifest cannot be regenerated byte-for-byte; `build-manifest.json` was left as the starter's. Pillow is not installed, so AI inspected screenshots one at a time instead of making contact sheets.


## 12. Windows blocked the film tools inside `Documents` (film stage, 2026-09-26)

- **What happened:** Creating Brutalist's Python environment failed with a misleading "file not found". AI traced it to Windows Defender **Controlled Folder Access** being on: git, Godot and the Claude app may write in `Documents`, but Python, Node and Git Bash tools may not. AI did not change the security setting. H chose option A: keep the protection on and work in `C:\dev`. Film records were later copied into the repo through git itself.
- **Expected:** *TO FILL (optional)*
- **Learned / still unsure:** *TO FILL (optional)*

## 13. Brutalist on Windows: four portability problems

- **What happened:**
  1. `./setup` exits because its ElevenLabs guard matches Brutalist's own example reels; AI ran the same checks one by one instead (all ready except LaTeX, which is not needed).
  2. Brutalist calls `python3`, which is not usable in Git Bash; AI added a `python3.exe` copy inside the private environment only.
  3. Scene renders failed because Windows `subprocess` cannot find `npx` (`npx.cmd`); AI made a one-line **local** patch (`shutil.which`), documented in the film's `BUILD-PROMPT.md`.
  4. Review mode cannot draw its timecode with a Windows font path; AI used the final export, which does not burn a timecode, instead.
- **Expected:** *TO FILL (optional)*
- **Learned / still unsure:** *TO FILL (optional)*

## 14. Native 4K capture on a 1080p laptop

- **What happened:** Godot's Movie Maker recorded only 1280×720, because the window is clamped to the 1920×1080 screen. AI switched to rendering the real main scene inside a 3840×2160 SubViewport, which is native 4K because the art is vector drawing. The first run-02 capture **stalled at frame 216** when Windows stopped drawing the window. AI changed the driver to force-render each frame and re-captured all four runs with the same driver. All 16 capture expectations passed (`youtube/…/capture/run-0N/summary.json`).
- **Expected:** *TO FILL (optional)*
- **Learned / still unsure:** *TO FILL (optional)*

## 15. Script corrections before rendering

- **What happened:**
  - **Sync:** B02's narration mentioned the mouse click about 4 s after it happened, and B05 spent 7 s on already-shown footage. AI reordered B02 and re-cut B05/B06 from later frames. No footage was retimed.
  - **Fact-check:** AI's own draft said the extension was made "with Walker" (the toolkit was never installed) and that Jiean chose "every design decision" (some were Claude's proposals that Jiean approved). Both were corrected before rendering (`FACTCHECK.md`).
- **Expected:** *TO FILL (optional)*
- **Learned / still unsure:** *TO FILL (optional)*

## 16. Quality gates blocked the first two final exports

- **What happened:**
  - **Gate T** flagged the game's own HUD in gameplay beats, a too-small label, clipped code, and a composite outside the title-safe box.
  - **Gate V** flagged edge-to-edge gameplay, sparse text cards, and the game's dimming scrim.

  AI fixed the real defects: labels enlarged and moved, the code line wrapped and marked, the duplicate brand label removed, and the composite re-laid out. For the rest it used the checkers' own per-beat declarations, each with a written reason (raw footage, `full_bleed`, `sparse_by_design`, `contrast_regions`). The third export passed; SHA-256 `06606492…159a`. The coverage check still fails on exactly one item: focus-loss pause, not filmed, an explicit partial walkthrough agreed by H. H watched the film: "The file is fine."
- **Expected:** *TO FILL (optional)*
- **Learned / still unsure:** *TO FILL (optional)*

## Open questions

*From my structured playtest on 2026-09-26 (revision `eb851a6`), worded by Claude from my description and reviewed by me; see [TEST-REPORT.md §6](TEST-REPORT.md#6-human-playtest-session-record-jiean).*

- **Is L2 hard because of habit, or unfair?** I died 5 times at L2's near-edge spikes in about 10 minutes, holding D to go fast, because the jumping habit I had built on the earlier gaps no longer worked there. I think that is the intended challenge, but I only know it for myself, an experienced player who was deliberately rushing. Would a newcomer read "land past the spikes" before dying, or only after?
- **Should the jump before L2 be signposted better?** The label "Land past the spikes. Jump before them." appears at the start of section 03. I don't know whether players read it while running at full speed.
- **Is the full restart acceptable?** A full run is under 20 seconds, so restarting from the spawn point did not frustrate me. A slower or newer player might take several times longer per attempt, and the same death at L2 could then feel tedious. I left the starter's no-checkpoint rule unchanged.
- **Is my playtest representative?** I am the only human tester. My play style (rushing, holding one key) found the L2 difficulty; a careful player might never die there, or might die somewhere else.

