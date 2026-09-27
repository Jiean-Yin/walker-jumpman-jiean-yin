extends RefCounted
## Fixed input route through the real level. No position/velocity edits.
## Starter marks (x 138-712) are unchanged. The last four were added for the
## 03 / CLIMB extension: onto L1, over L2's near-edge spikes onto L2, onto L3,
## then off L3 before its far-edge spikes onto the L4 finish plateau.
var jump_marks: Array[float] = [138.0, 292.0, 424.0, 548.0, 712.0, 930.0, 1090.0, 1230.0, 1375.0]
var next_jump: int = 0

func step(player: CharacterBody2D) -> void:
	player.test_control = true
	player.test_axis = 1.0
	player.test_jump_held = false
	if next_jump < jump_marks.size() and player.position.x >= jump_marks[next_jump] and player.is_on_floor():
		player.test_jump_pressed = true
		next_jump += 1
