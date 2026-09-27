extends SceneTree
## Film capture driver for walker-jumpman-jiean-yin (runs on an isolated copy of film-source-v1).
##
## - Instantiates the real main scene (res://game/main.tscn) inside a 3840x2160 SubViewport
##   whose 2D canvas is the game's 640x360 logical size, stretched (same as the game's
##   canvas_items stretch). The game's art is vector drawing, so frames are native 4K.
## - Drives the game only through input events: Input.parse_input_event() (action state the
##   player polls) and SubViewport.push_input() (the session's _unhandled_input). No
##   teleporting, no test_control, no direct state changes.
## - The only harness setting: session.test_mode = true, which disables the automatic pause
##   on window focus loss so an unattended capture is not paused by the OS. (Focus-loss pause
##   is verified by the automated test `focus-loss-pauses`, not filmed.)
## - Saves every rendered frame as PNG and logs each input against frame and physics tick.
## - Asserts the expected outcomes; quits nonzero on any failure.
##
## Usage: godot --path godot --fixed-fps 30 --script res://tests/capture_driver.gd -- <segment> <out_dir>
const W := 3840
const H := 2160
const FPS := 30
var sub: SubViewport
var game: Node
var player: CharacterBody2D
var frame: int = 0
var out_dir: String
var segment: String
var log_lines: Array[String] = []
var held: Dictionary = {}
var failed: String = ""
var notes: Array[String] = []

func _initialize() -> void:
	call_deferred("run")

# ---------------------------------------------------------------- input helpers

func _key_event(code: Key, pressed: bool) -> InputEventKey:
	var e := InputEventKey.new()
	e.keycode = code
	e.physical_keycode = code
	e.pressed = pressed
	return e

func log_event(kind: String, detail: String) -> void:
	var state: int = game.state if is_instance_valid(game) else -1
	var entry := {"frame": frame, "t_s": snappedf(float(frame) / FPS, 0.001), "physics_tick": player.tick if is_instance_valid(player) else -1,
		"event": kind, "detail": detail, "state": state,
		"x": snappedf(player.position.x, 0.01) if is_instance_valid(player) else null,
		"y": snappedf(player.position.y, 0.01) if is_instance_valid(player) else null,
		"deaths": game.deaths if is_instance_valid(game) else null}
	log_lines.append(JSON.stringify(entry))

func key_down(code: Key, label: String) -> void:
	var e := _key_event(code, true)
	Input.parse_input_event(e)
	sub.push_input(e)
	held[code] = true
	log_event("press", label)

func key_up(code: Key, label: String) -> void:
	var e := _key_event(code, false)
	Input.parse_input_event(e)
	sub.push_input(e)
	held.erase(code)
	log_event("release", label)

func tap(code: Key, label: String) -> void:
	key_down(code, label)
	await frames(1)
	key_up(code, label)

func release_all() -> void:
	for code in held.keys():
		key_up(code, OS.get_keycode_string(code))

func click_logical(pos: Vector2, label: String) -> void:
	# The HUD button is defined in 640x360 logical coordinates; the SubViewport maps its
	# 2D override, so the event position is given in the viewport's pixel space.
	var p := pos * float(W) / 640.0
	var motion := InputEventMouseMotion.new()
	motion.position = p
	motion.global_position = p
	sub.push_input(motion)
	await frames(1)
	for pressed in [true, false]:
		var b := InputEventMouseButton.new()
		b.button_index = MOUSE_BUTTON_LEFT
		b.pressed = pressed
		b.position = p
		b.global_position = p
		sub.push_input(b)
	log_event("mouse_click", label + " at logical " + str(pos))

# ---------------------------------------------------------------- frame helpers

func capture_frame() -> void:
	# Advance one engine frame (fixed 1/30 s of game time: input flush, 2 physics ticks),
	# then render explicitly. Waiting for the window's own draw stalls if Windows stops
	# drawing a minimized or covered window, so the SubViewport is force-drawn instead.
	await process_frame
	RenderingServer.force_draw(false)
	var img := sub.get_texture().get_image()
	var err := img.save_png(out_dir + "/frames/%05d.png" % frame)
	if err != OK:
		fail("could not save frame %d" % frame)
	frame += 1

func frames(n: int) -> void:
	for i in range(n):
		await capture_frame()

func until(cond: Callable, max_frames: int, what: String) -> bool:
	var n := 0
	while not cond.call():
		if n >= max_frames:
			fail("timed out waiting for: " + what)
			return false
		await capture_frame()
		n += 1
	return true

func fail(msg: String) -> void:
	if failed == "":
		failed = msg
		log_event("FAIL", msg)
		push_error("CAPTURE FAIL: " + msg)

func expect(cond: bool, msg: String) -> void:
	if not cond:
		fail("expectation failed: " + msg)
	else:
		notes.append("OK: " + msg)

## Hold right and jump at each mark (only when on the floor), like the route fixture,
## but through real input events. Stops holding when `stop_x` is reached or the attempt ends.
func run_route(marks: Array, stop_x: float, max_frames: int) -> void:
	var next := 0
	key_down(KEY_D, "D (move right)")
	var n := 0
	while game.state == game.State.PLAYING and player.position.x < stop_x and n < max_frames:
		if next < marks.size() and player.position.x >= marks[next] and player.is_on_floor():
			await tap(KEY_SPACE, "Space (jump) at mark %d" % int(marks[next]))
			next += 1
			n += 1
			continue
		await capture_frame()
		n += 1
	if held.has(KEY_D):
		key_up(KEY_D, "D (move right)")

# ---------------------------------------------------------------- segments

const ORIGINAL_MARKS := [138.0, 292.0, 424.0, 548.0, 712.0]
const ALL_MARKS := [138.0, 292.0, 424.0, 548.0, 712.0, 930.0, 1090.0, 1230.0, 1375.0]

func seg_character() -> void:
	await frames(45)  # main menu
	await click_logical(Vector2(320, 232), "mouse click on START button")
	await frames(2)
	expect(game.state == game.State.PLAYING, "mouse click on the START button starts the game")
	await frames(20)
	# Over the first step onto flat ground (x 208-320).
	await run_route([138.0], 250.0, 120)
	await until(func(): return absf(player.velocity.x) < 1.0, 30, "stop after running right")
	await frames(40)  # idle facing right
	key_down(KEY_A, "A (move left)")
	await frames(14)
	key_up(KEY_A, "A (move left)")
	await frames(35)  # idle facing left
	expect(player.facing == -1.0, "facing left after moving left")
	await tap(KEY_SPACE, "Space (jump in place, facing left)")
	await frames(45)
	await tap(KEY_F3, "F3 (show collider)")
	await frames(20)
	expect(player.show_collider, "F3 shows the collider outline")
	key_down(KEY_D, "D (move right)")
	await frames(12)
	key_up(KEY_D, "D (move right)")
	await frames(20)
	await tap(KEY_SPACE, "Space (jump in place, collider shown)")
	await frames(45)
	await tap(KEY_F3, "F3 (hide collider)")
	await frames(25)
	expect(not player.show_collider and game.deaths == 0, "collider hidden again, no deaths")

func seg_original() -> void:
	await frames(25)
	await tap(KEY_ENTER, "Enter (start)")
	await frames(15)
	await run_route(ORIGINAL_MARKS, 900.0, 400)
	await until(func(): return absf(player.velocity.x) < 1.0, 30, "stop at end of original section")
	expect(game.deaths == 0 and player.position.x > 880.0 and player.position.x < 951.0, "original section crossed with 0 deaths, standing before the new gap")
	await frames(25)
	await tap(KEY_ESCAPE, "Esc (pause)")
	await frames(50)
	expect(game.state == game.State.PAUSED, "Esc pauses")
	await tap(KEY_ENTER, "Enter (resume)")
	await frames(20)
	expect(game.state == game.State.PLAYING, "Enter resumes")
	await tap(KEY_R, "R (manual retry)")
	await frames(35)
	expect(game.state == game.State.PLAYING and player.position.distance_to(Vector2(64, 320)) < 1.0 and game.deaths == 0, "R restarts at spawn without counting a death")

func seg_failure() -> void:
	await frames(20)
	await tap(KEY_ENTER, "Enter (start)")
	await frames(15)
	# 1) Spike death: clear the step, then do NOT jump at the spikes.
	await run_route([138.0], 400.0, 200)
	expect(game.state == game.State.DYING and game.death_reason == "Watch the spikes", "walking into the spikes kills")
	release_all()
	await until(func(): return game.state == game.State.PLAYING, 60, "automatic retry after spike death")
	await frames(20)
	# 2) Gap death: clear the spikes, then do NOT jump at the first gap.
	await run_route([138.0, 292.0], 600.0, 250)
	expect(game.state == game.State.DYING and game.death_reason == "Missed the landing", "falling into the gap kills")
	release_all()
	await until(func(): return game.state == game.State.PLAYING, 60, "automatic retry after gap death")
	await frames(20)
	# 3) Fast manual retry: spike death, then R in the middle of the death animation.
	await run_route([138.0], 400.0, 200)
	expect(game.state == game.State.DYING, "second spike death")
	release_all()
	await frames(8)
	await tap(KEY_R, "R (retry mid-death)")
	await frames(35)
	expect(game.state == game.State.PLAYING and not player.dead and game.deaths == 3, "R mid-death respawns alive; 3 deaths counted")

func seg_climb() -> void:
	await frames(20)
	await tap(KEY_ENTER, "Enter (start)")
	await frames(15)
	# Attempt 1: onto L1, stop, then jump from a standstill -> short of L2's safe area.
	await run_route(ALL_MARKS.slice(0, 6), 1052.0, 500)
	await until(func(): return absf(player.velocity.x) < 1.0 and player.is_on_floor(), 40, "stop on L1")
	await frames(20)
	key_down(KEY_D, "D (move right)")
	await tap(KEY_SPACE, "Space (standstill jump from L1)")
	await until(func(): return game.state != game.State.PLAYING, 90, "short hop outcome")
	release_all()
	expect(game.state == game.State.DYING and game.death_reason == "Watch the spikes" and player.position.x > 1130.0 and player.position.x < 1165.0, "standstill hop from L1 lands on L2's near-edge spikes")
	await until(func(): return game.state == game.State.PLAYING, 60, "automatic retry after L2 death")
	await frames(20)
	# Attempt 2: full-speed route over all four new landings to the relocated finish.
	await run_route(ALL_MARKS, 1700.0, 700)
	release_all()
	expect(game.state == game.State.COMPLETE and game.deaths == 1, "full route reaches the relocated finish (1 earlier death)")
	await frames(100)  # results card
	await tap(KEY_ENTER, "Enter (play again)")
	await frames(35)
	expect(game.state == game.State.PLAYING and game.deaths == 0 and player.position.distance_to(Vector2(64, 320)) < 1.0, "replay starts a fresh session")
	await tap(KEY_ESCAPE, "Esc (pause)")
	await frames(30)
	await tap(KEY_M, "M (main menu)")
	await frames(50)
	expect(game.state == game.State.MENU, "M returns to the main menu")

# ---------------------------------------------------------------- main

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 2:
		push_error("usage: -- <segment> <out_dir>")
		quit(2)
		return
	segment = args[0]
	out_dir = args[1]
	DirAccess.make_dir_recursive_absolute(out_dir + "/frames")
	sub = SubViewport.new()
	sub.size = Vector2i(W, H)
	sub.size_2d_override = Vector2i(640, 360)
	sub.size_2d_override_stretch = true
	sub.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(sub)
	game = load("res://game/main.tscn").instantiate()
	game.test_mode = true
	sub.add_child(game)
	await process_frame
	player = game.player
	log_event("segment_start", segment)
	match segment:
		"run-01": await seg_character()
		"run-02": await seg_original()
		"run-03": await seg_failure()
		"run-04": await seg_climb()
		_: fail("unknown segment " + segment)
	release_all()
	log_event("segment_end", "frames=%d failed=%s" % [frame, failed])
	var f := FileAccess.open(out_dir + "/inputs.jsonl", FileAccess.WRITE)
	f.store_string("\n".join(log_lines) + "\n")
	f.close()
	var summary := {"segment": segment, "frames": frame, "fps": FPS, "size": [W, H], "engine": Engine.get_version_info().string, "failed": failed, "checks": notes}
	var s := FileAccess.open(out_dir + "/summary.json", FileAccess.WRITE)
	s.store_string(JSON.stringify(summary, "  "))
	s.close()
	print("CAPTURE %s: %d frames, %s" % [segment, frame, "FAILED: " + failed if failed != "" else "all expectations met"])
	game.queue_free()
	await process_frame
	quit(1 if failed != "" else 0)
