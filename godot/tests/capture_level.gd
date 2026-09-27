extends SceneTree
## Stills of the whole level, one camera stop at a time, with the player parked
## out of the way. Used to compare what is drawn with where the collision is.
## Presentation stills (physics paused), not gameplay or human playtesting.
const Game = preload("res://game/session.gd")

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var output := ProjectSettings.globalize_path("res://../evidence/level-screens-" + str(int(Time.get_unix_time_from_system())))
	DirAccess.make_dir_recursive_absolute(output)
	var game: Node2D = Game.new()
	game.test_mode = true
	root.add_child(game)
	await physics_frame
	game.start_session()
	await physics_frame
	# Freeze the session so the camera stays where this script puts it.
	game.set_physics_process(false)
	game.player.enabled = false
	game.player.show_collider = true
	var width: float = float(game.level.width)
	var stops: Array[float] = [320.0, 960.0, width - 320.0]
	for i in range(stops.size()):
		game.camera.position.x = clampf(stops[i], 320.0, width - 320.0)
		game.player.position = Vector2(game.camera.position.x - 300.0, 120.0)
		game.hud.queue_redraw()
		game.queue_redraw()
		await process_frame
		await RenderingServer.frame_post_draw
		var name := "%02d-camera-x%d" % [i + 1, int(game.camera.position.x)]
		var error := root.get_texture().get_image().save_png(output + "/" + name + ".png")
		assert(error == OK)
		print("Captured: " + name)
	game.queue_free()
	await process_frame
	quit()
