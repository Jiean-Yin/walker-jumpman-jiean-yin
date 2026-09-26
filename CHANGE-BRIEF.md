# CHANGE-BRIEF — walker-jumpman-jiean-yin

**Starter:** [nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman) "First Steps" (commit `9387542`)
**Author:** Jiean Yin
**Written:** 2026-09-26, before any implementation
**Engine:** Godot 4.7.2.stable (Windows 11)

> The original predictions below are kept as written. Later corrections go in
> [Revisions](#revisions) at the bottom; earlier text is not rewritten.

## 1. Character concept

One guy with red color and blue helmet. Hold a spear in front of him, accompanied by the placement of eyes, to indicate which way is the front side. While the guy moves, the spear points a bit toward the direction of movement, compared to holding it up while idle. Jumping and falling remain the same as the idle status. When the character dies, the eyes change to an "XX" shape and he loses his spear. The body rises up a bit and then falls out of the screen, like Mario. The collider remains untouched, and the spear is just decoration used for direction pointing.

## 2. New level section

~~Double jump to higher places, and horizontal dash ability to move across new sections with gaps and spikes above.~~
*(First idea, dropped 2026-09-26 before implementation: double jump and dash would change the movement contract and contradict the starter's `fixed-jump-and-no-double` test and GDD §13. The movement stays the starter's single jump; the challenge comes from the layout.)*

**Concept: "03 / CLIMB".** A staircase of four new landings that climbs higher and higher after the original course. Some landings have spike traps right next to the safe landing area. Same single jump, so each landing asks: *how far, and when?*

Candidate side view (not to scale; world y goes down, floor top = 320):

```text
                                                        FINISH
                                              [ L4  y=224  ]|>
                              [ L3 y=240 ^^]
              [^^ L2 y=272 ]
      [ L1 y=288 ]
====|                                                          (gaps = fall = retry)
 original course ends x=960
```

| Landing | Candidate rect (x, top y, width) | Rise / gap from previous | Decision it asks |
|---|---|---|---|
| L1 — first step up | x 1008–1104, y 288 | +32 px / 48 px gap from the original end (x 960) | Can I read a higher landing? (Clean teaching jump, no spikes.) |
| L2 — land past the spikes | x 1136–1248, y 272; **spikes on the near edge** x 1136–1160 | +16 px / 32 px gap | Commit to a full-speed jump; a short hop lands on the spikes. |
| L3 — stop, then jump early | x 1296–1424, y 240; **spikes on the far edge** x 1400–1424 | +32 px / 48 px gap | Land and control momentum; then take off *before* the spikes, not at the edge. |
| L4 — finish plateau | x 1440–1600, y 224; finish flag near x 1560 | +16 px / 16 px gap past L3's spikes | Clear L3's spikes and reach the relocated finish. |

- **Finish moves** from x 916 to the top of L4, so the player must complete the whole new section to win. The level width grows from 960 to about 1600.
- **The original 0–960 section stays unchanged** apart from removing the old finish, so the original route and its tests remain usable.
- **Failure/retry is the starter's:** a spike or a missed landing (falling past y=430) leads to the same automatic retry at the spawn point. No checkpoints are added.
- **Design limits:** rises ≤ 32 px and horizontal jump distances with at least ~20 px spare, compared with the starter's theoretical single-jump reach. The highest landing (y=224) stays well below the top HUD bar (screen y 74).
- These numbers are **candidates from a continuous-physics estimate**, not tested. If a jump proves impossible or unfair, I revise the geometry, never the jump strength.

## 3. What must remain unchanged

Controls, movement/jump tuning, collision behavior, retry, pause, and completion, unless I explicitly justify a necessary change. The numbers in tuning.gd, the 18×28 collider, the 0.55 s retry.

## 4. Predicted failure cases

| # | Prediction | How I will check it |
|---|---|---|
| ~~F1~~ | ~~Double jump timing is unclear, or it triggers or fails when it shouldn't.~~ | ~~Play it myself carefully to diagnose at what time or place the character performs as expected, and work with Claude to debug.~~ |
| ~~F2~~ | ~~Dashing can cause problems, such as being interrupted by existing objects.~~ | ~~Rewrite the dash logic to stop on collision, if possible.~~ |
| F3 | I may make a gap too short or too long, which makes the challenge meaningless: too short and the jump carries no risk; too long and it is impossible or unfair with the single jump. | An updated route test must reach every new landing and the finish through normal input, and a test must show that walking without jumping cannot win. In my own playtest I record deaths per landing: a landing that never kills me across my first runs is probably too easy; one I still cannot clear after about ten tries is probably too hard. If so, I change the geometry, never the jump strength. |
| F4 | The death animation (XX eyes, spear lost, body rises then falls off the screen) may still be playing when the automatic retry (0.55 s) or a fast manual retry (R) happens. The character could respawn still showing the dead pose, control could be delayed, or the animation could move the real body and cause a second death or a false fall. | A test triggers a death, then presses R immediately: the player must be at the spawn point, drawn in the alive pose, with the death counted exactly once. The existing `twenty-retries` check must still respawn within 60 ticks. In my playtest I press R in the middle of the death animation several times and note what I see. |

*F1 and F2 belonged to the dropped double-jump/dash idea and were replaced by F3 and F4 on 2026-09-26, before implementation.*

## Revisions

<!-- Added after implementation. Original predictions above stay unchanged. -->
