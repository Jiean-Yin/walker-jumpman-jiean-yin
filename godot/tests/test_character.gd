extends SceneTree
## Character-identity checks (added by walker-jumpman-jiean-yin).
## The starter's test_game.gd / test_keyboard.gd stay unchanged as the regression baseline.
const Game = preload("res://game/session.gd")
const Tuning = preload("res://features/player/tuning.gd")
var game: Node2D
var results: Array[Dictionary] = []
var failures: int = 0

func _initialize() -> void:
	call_deferred("run")

func steps(n: int) -> void:
	for i in range(n):
		await physics_frame
		await process_frame

func key(code: Key, pressed: bool) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.physical_keycode = code
	event.pressed = pressed
	Input.parse_input_event(event)
	await steps(1)

func check(id: String, passed: bool, observation: Dictionary) -> void:
	results.append({"id": id, "status": "PASS" if passed else "FAIL", "observed": observation})
	if not passed:
		failures += 1
	print(JSON.stringify(results.back()))

func fresh() -> void:
	if is_instance_valid(game):
		game.queue_free()
		await process_frame
	game = Game.new()
	game.test_mode = true
	root.add_child(game)
	game.start_session()
	game.player.test_control = true
	await steps(3)

func collider_shape() -> CollisionShape2D:
	for child in game.player.get_children():
		if child is CollisionShape2D:
			return child
	return null

func die_on_spike() -> void:
	# Same real spike contact the starter's actual-spike-collision check uses.
	game.player.position = Vector2(330, 310)
	await steps(4)

func run() -> void:
	await fresh()
	var shape := collider_shape()
	var rect := shape.shape as RectangleShape2D
	check("collider-unchanged", rect.size == Vector2(18, 28) and shape.position == Vector2(0, -14), {"size": str(rect.size), "offset": str(shape.position)})
	var t = Tuning.new()
	var expected := {"speed": 160.0, "acceleration": 1280.0, "deceleration": 1920.0, "jump_velocity": -320.0, "gravity": 960.0, "terminal_velocity": 480.0, "coyote_ticks": 6, "buffer_ticks": 6}
	var tuning_ok := true
	var observed := {}
	for name in expected:
		observed[name] = t.get(name)
		tuning_ok = tuning_ok and is_equal_approx(float(t.get(name)), float(expected[name]))
	check("tuning-unchanged", tuning_ok, observed)

	# Facing follows the last nonzero input; the drawing mirrors from this value.
	game.player.test_axis = -1
	await steps(4)
	var facing_left: float = game.player.facing
	game.player.test_axis = 1
	await steps(4)
	check("facing-follows-input", facing_left == -1.0 and game.player.facing == 1.0, {"after_left": facing_left, "after_right": game.player.facing})

	# Spear pose: tilted while running on the floor, upright when idle or airborne.
	await steps(15)
	var run_angle: float = rad_to_deg(game.player.spear_angle)
	game.player.test_axis = 0
	await steps(20)
	var idle_angle: float = rad_to_deg(game.player.spear_angle)
	game.player.test_jump_pressed = true
	await steps(20)
	var air_angle: float = rad_to_deg(game.player.spear_angle)
	check("spear-pose", run_angle > 20.0 and idle_angle < 1.0 and air_angle < 1.0 and not game.player.is_on_floor(), {"running_deg": run_angle, "idle_deg": idle_angle, "airborne_deg": air_angle})

	# F4: the death hop is drawn only; the real body stays frozen.
	await fresh()
	await die_on_spike()
	var died_at: Vector2 = game.player.position
	var dead_flag: bool = game.player.dead
	await steps(12)
	check("death-sets-dead-pose", game.state == Game.State.DYING and dead_flag and game.player.dead, {"state": game.state, "dead": game.player.dead})
	check("death-hop-visual-only", game.player.position == died_at and game.player.death_offset() != 0.0, {"body": str(game.player.position), "died_at": str(died_at), "drawn_offset": game.player.death_offset()})

	# The hop must leave the screen before the unchanged 0.55 s automatic retry.
	var ticks := 0
	var offscreen_tick := -1
	while game.state == Game.State.DYING and ticks < 65:
		if offscreen_tick < 0 and game.player.position.y + game.player.death_offset() - 28.0 > 335.0:
			offscreen_tick = game.player.death_ticks
		await steps(1)
		ticks += 1
	check("death-hop-finishes-before-retry", offscreen_tick > 0 and game.state == Game.State.PLAYING and not game.player.dead and game.player.death_offset() == 0.0, {"hidden_at_death_tick": offscreen_tick, "state": game.state, "dead_after_retry": game.player.dead})

	# Revision after my playtest: a gap death happens below the screen, so its hop
	# is drawn from the playfield's bottom edge and must rise into view.
	await fresh()
	game.player.position = Vector2(480, 300)  # over the starter's first gap (x 448-512)
	var fall_ticks := 0
	while game.state == Game.State.PLAYING and fall_ticks < 90:
		await steps(1)
		fall_ticks += 1
	var fell_at: Vector2 = game.player.position
	var highest_head := 1000.0
	var hidden_again_tick := -1
	var fall_retry_ticks := 0
	while game.state == Game.State.DYING and fall_retry_ticks < 65:
		var head: float = game.player.position.y + game.player.death_offset() - 28.0
		highest_head = minf(highest_head, head)
		if highest_head < 335.0 and hidden_again_tick < 0 and head > 335.0:
			hidden_again_tick = game.player.death_ticks
		if fall_retry_ticks == 5:
			check("fall-death-body-frozen", game.player.position == fell_at and game.player.death_from_fall, {"body": str(game.player.position), "fell_at": str(fell_at), "from_fall": game.player.death_from_fall})
		await steps(1)
		fall_retry_ticks += 1
	check("fall-death-hop-visible", fell_at.y > float(game.level.fall_y) and highest_head < 335.0 - 20.0 and hidden_again_tick > 0 and game.state == Game.State.PLAYING and game.deaths == 1, {"fell_at_y": fell_at.y, "highest_drawn_head_y": highest_head, "hidden_again_at_death_tick": hidden_again_tick, "state": game.state, "deaths": game.deaths})

	# F4: a fast manual retry (real R key) in the middle of the death animation.
	await fresh()
	game.player.test_control = false
	await die_on_spike()
	await steps(5)
	var deaths_before: int = game.deaths
	await key(KEY_R, true)
	await key(KEY_R, false)
	check("fast-retry-clears-dead-pose", game.state == Game.State.PLAYING and not game.player.dead and game.player.death_ticks == 0 and game.player.position.distance_to(Vector2(64, 320)) < 1 and game.deaths == deaths_before and deaths_before == 1, {"state": game.state, "dead": game.player.dead, "position": str(game.player.position), "deaths": game.deaths})
	await steps(40)
	check("no-phantom-death-after-fast-retry", game.state == Game.State.PLAYING and game.deaths == 1, {"state": game.state, "deaths": game.deaths})

	# F3 debug overlay toggles presentation only.
	var state_before: int = game.state
	var pos_before: Vector2 = game.player.position
	await key(KEY_F3, true)
	await key(KEY_F3, false)
	var shown: bool = game.player.show_collider
	await key(KEY_F3, true)
	await key(KEY_F3, false)
	check("collider-overlay-toggle", shown and not game.player.show_collider and game.state == state_before and game.player.position.distance_to(pos_before) < 0.01, {"shown_after_first_press": shown, "state": game.state})

	var report := {"scope": "Character identity checks; not human playtesting", "engine": Engine.get_version_info().string, "created_at": Time.get_datetime_string_from_system(true), "results": results, "failures": failures}
	var out := ProjectSettings.globalize_path("res://../evidence")
	DirAccess.make_dir_recursive_absolute(out)
	var file := FileAccess.open(out + "/character-" + str(Time.get_unix_time_from_system()) + ".json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "  "))
	file.close()
	print("CHARACTER TESTS: %d checks / %d failures" % [results.size(), failures])
	game.queue_free()
	await process_frame
	quit(1 if failures else 0)
