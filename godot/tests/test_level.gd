extends SceneTree
## 03 / CLIMB extension checks (added by walker-jumpman-jiean-yin).
## The starter's test_game.gd still runs the full route; these checks cover the
## new landings, the relocated finish, and drawing/physics consistency.
const Game = preload("res://game/session.gd")
const Route = preload("res://tests/route_driver.gd")
const NEW_LANDINGS := {"L1": 5, "L2": 6, "L3": 7, "L4": 8}  # indices into level.solids
var game: Node2D
var results: Array[Dictionary] = []
var failures: int = 0

func _initialize() -> void:
	call_deferred("run")

func steps(n: int) -> void:
	for i in range(n):
		await physics_frame
		await process_frame

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

func solid(i: int) -> Rect2:
	var e: Array = game.level.solids[i]
	return Rect2(e[0], e[1], e[2], e[3])

## Index of the solid the player is standing on, or -1.
func standing_on() -> int:
	if not game.player.is_on_floor():
		return -1
	var p: Vector2 = game.player.position
	for i in range(game.level.solids.size()):
		var r := solid(i)
		if absf(p.y - r.position.y) < 0.5 and p.x + 9 > r.position.x and p.x - 9 < r.end.x:
			return i
	return -1

## Walk right from a standing start with no jump; report how the attempt ends.
func walk_without_jumping(start: Vector2) -> Dictionary:
	await fresh()
	game.player.position = start
	await steps(2)
	game.player.test_axis = 1
	var ticks := 0
	var completed := false
	while game.state == Game.State.PLAYING and ticks < 400:
		await steps(1)
		ticks += 1
		completed = completed or game.state == Game.State.COMPLETE
	return {"start": str(start), "state": game.state, "reason": game.death_reason, "completed": completed, "end": str(game.player.position)}

func run() -> void:
	await fresh()
	var f: Array = game.level.finish
	var l4 := solid(NEW_LANDINGS.L4)
	check("finish-relocated-onto-L4", f[0] > 960 and is_equal_approx(f[1] + f[3], l4.position.y) and f[0] >= l4.position.x and f[0] + f[2] <= l4.end.x, {"finish": str(f), "L4": str(l4)})

	# Visual == physics: collision teeth equal the shared drawing function, and
	# every hazard stands on top of a solid.
	var mismatches: Array = []
	for h in range(game.hazard_areas.size()):
		var e: Array = game.level.hazards[h]
		var rect := Rect2(e[0], e[1], e[2], e[3])
		var drawn: Array = Game.spike_triangles(rect)
		var polys: Array = []
		for child in game.hazard_areas[h].get_children():
			if child is CollisionPolygon2D:
				var world := PackedVector2Array()
				for p in child.polygon:
					world.append(p + game.hazard_areas[h].position)
				polys.append(world)
		var supported := false
		for i in range(game.level.solids.size()):
			var r := solid(i)
			supported = supported or (is_equal_approx(rect.end.y, r.position.y) and rect.position.x >= r.position.x and rect.end.x <= r.end.x)
		if polys != drawn or not supported:
			mismatches.append({"hazard": str(e), "collision": str(polys), "drawn": str(drawn), "on_a_surface": supported})
	check("spikes-drawn-where-they-collide", mismatches.is_empty() and game.hazard_areas.size() == 3, {"hazards": game.hazard_areas.size(), "mismatches": mismatches})

	var hud_ok := true
	var heights := {}
	for name in NEW_LANDINGS:
		var top: float = solid(NEW_LANDINGS[name]).position.y
		heights[name] = top
		hud_ok = hud_ok and top - 28.0 > 74.0
	var pole_top: float = f[1] + f[3] - 70.0
	check("new-landings-below-top-hud", hud_ok and pole_top > 74.0, {"landing_tops": heights, "flag_pole_top": pole_top, "hud_bottom_edge": 74})

	# Normal input route: stand on every new landing, then finish, with no deaths.
	await fresh()
	var route = Route.new()
	var visited := {}
	var takeoff_views: Array = []
	var ticks := 0
	while game.state == Game.State.PLAYING and ticks < 900:
		var marks_before: int = route.next_jump
		route.step(game.player)
		if route.next_jump != marks_before and route.next_jump > 5:
			# At each new-section takeoff, the next landing must already be on screen.
			var target: Rect2 = solid(NEW_LANDINGS.values()[route.next_jump - 6])
			var view_right: float = game.camera.position.x + 320.0
			takeoff_views.append({"takeoff_x": snappedf(game.player.position.x, 0.1), "next_landing_x": target.position.x, "view_right_edge": view_right, "visible": target.position.x < view_right})
		await steps(1)
		ticks += 1
		var on := standing_on()
		for name in NEW_LANDINGS:
			if on == NEW_LANDINGS[name]:
				visited[name] = true
	var all_visited: bool = visited.size() == 4
	var all_visible := takeoff_views.size() == 4
	for v in takeoff_views:
		all_visible = all_visible and v.visible
	check("route-stands-on-all-new-landings", all_visited and game.state == Game.State.COMPLETE and game.deaths == 0, {"visited": visited.keys(), "state": game.state, "deaths": game.deaths, "ticks": ticks, "finish_position": str(game.player.position)})
	check("next-landing-visible-at-takeoff", all_visible, {"takeoffs": takeoff_views})
	check("finish-in-view-at-completion", game.camera.position.x + 320.0 >= float(f[0]) + float(f[2]), {"camera_x": game.camera.position.x, "finish_right": f[0] + f[2]})
	check("progress-bar-uses-relocated-finish", game.hud.progress() > 0.99, {"progress_at_completion": game.hud.progress()})
	game.player.position.x = 916.0
	check("progress-not-full-at-old-finish", game.hud.progress() < 0.6, {"progress_at_x916": game.hud.progress()})

	# Every new landing requires a jump: walking right from each surface fails.
	var walks := {}
	var all_fail := true
	for start in [["original-end", Vector2(800, 320)], ["L1", Vector2(1020, 288)], ["L2", Vector2(1170, 272)], ["L3", Vector2(1310, 240)]]:
		var result: Dictionary = await walk_without_jumping(start[1])
		walks[start[0]] = result
		all_fail = all_fail and result.state == Game.State.DYING and not result.completed
	check("walking-without-jumping-cannot-progress", all_fail, walks)

	# L2 near-edge trap: a jump from a standstill on L1 falls short onto the spikes.
	await fresh()
	game.player.position = Vector2(1060, 288)
	await steps(2)
	game.player.test_axis = 1
	game.player.test_jump_pressed = true
	var t2 := 0
	while game.state == Game.State.PLAYING and t2 < 90:
		await steps(1)
		t2 += 1
	check("L2-short-hop-lands-on-spikes", game.state == Game.State.DYING and game.death_reason == "Watch the spikes", {"state": game.state, "reason": game.death_reason, "died_at": str(game.player.position)})
	await fresh()
	game.player.position = Vector2(1210, 272)
	await steps(60)
	check("L2-safe-area-is-safe", game.state == Game.State.PLAYING and standing_on() == NEW_LANDINGS.L2, {"state": game.state, "standing_on": standing_on()})

	# L3 far-edge trap: running to the very edge and jumping late clips the spikes.
	await fresh()
	game.player.position = Vector2(1320, 240)
	await steps(2)
	game.player.test_axis = 1
	var jumped_at := -1.0
	var t3 := 0
	while game.state == Game.State.PLAYING and t3 < 120:
		if jumped_at < 0 and game.player.position.x >= 1390.0 and game.player.is_on_floor():
			game.player.test_jump_pressed = true
			jumped_at = game.player.position.x
		await steps(1)
		t3 += 1
	check("L3-late-jump-clips-far-spikes", game.state == Game.State.DYING and game.death_reason == "Watch the spikes", {"jumped_at_x": jumped_at, "state": game.state, "reason": game.death_reason, "died_at": str(game.player.position)})

	var report := {"scope": "03 / CLIMB level extension checks; not human playtesting", "engine": Engine.get_version_info().string, "created_at": Time.get_datetime_string_from_system(true), "results": results, "failures": failures}
	var out := ProjectSettings.globalize_path("res://../evidence")
	DirAccess.make_dir_recursive_absolute(out)
	var file := FileAccess.open(out + "/level-" + str(Time.get_unix_time_from_system()) + ".json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "  "))
	file.close()
	print("LEVEL TESTS: %d checks / %d failures" % [results.size(), failures])
	game.queue_free()
	await process_frame
	quit(1 if failures else 0)
