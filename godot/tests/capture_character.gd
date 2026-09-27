extends SceneTree
## Close-up stills of each character pose, with and without the collider overlay.
## Scripted input through the real game (test_control); stills, not human playtesting.
const Game = preload("res://game/session.gd")
var game: Node2D
var output: String
var close_up: Camera2D

func _initialize() -> void:
	call_deferred("run")

func steps(n: int) -> void:
	for i in range(n):
		await physics_frame
		await process_frame

func capture(label: String) -> void:
	for overlay in [false, true]:
		game.player.show_collider = overlay
		game.player.queue_redraw()
		await process_frame
		await RenderingServer.frame_post_draw
		var name := label + ("-collider" if overlay else "")
		var error := root.get_texture().get_image().save_png(output + "/" + name + ".png")
		assert(error == OK)
		print("Captured: " + name)
	game.player.show_collider = false

func run() -> void:
	output = ProjectSettings.globalize_path("res://../evidence/character-screens-" + str(int(Time.get_unix_time_from_system())))
	DirAccess.make_dir_recursive_absolute(output)
	game = Game.new()
	game.test_mode = true
	root.add_child(game)
	await steps(2)
	game.start_session()
	var player: CharacterBody2D = game.player
	player.test_control = true
	# A camera on the player, 3x zoom, so the 18x28 body is inspectable.
	close_up = Camera2D.new()
	close_up.zoom = Vector2(3, 3)
	close_up.position = Vector2(0, -16)
	player.add_child(close_up)
	close_up.make_current()
	player.position = Vector2(200, 320)
	await steps(20)
	await capture("01-idle-right")
	player.test_axis = 1
	await steps(20)
	await capture("02-run-right")
	player.test_axis = -1
	await steps(20)
	await capture("03-run-left")
	player.test_axis = 0
	await steps(25)
	await capture("04-idle-left")
	player.test_jump_pressed = true
	await steps(8)
	await capture("05-jump-rising-left")
	player.test_axis = 1
	await steps(18)
	await capture("06-jump-falling-right")
	player.test_axis = 0
	await steps(30)
	# Real spike contact (same position as the starter's spike check).
	player.position = Vector2(330, 310)
	for i in range(10):
		await steps(1)
		if game.state == Game.State.DYING: break
	assert(game.state == Game.State.DYING)
	await steps(4)
	await capture("07-death-hop")
	await steps(12)
	await capture("08-death-falling")
	# Gap death at normal game zoom: the body falls off-screen, the hop pops up from the bottom.
	while game.state == Game.State.DYING:
		await steps(1)
	game.camera.make_current()
	player.position = Vector2(480, 300)
	while game.state == Game.State.PLAYING:
		await steps(1)
	await steps(10)
	await capture("09-fall-death-popup")
	await steps(12)
	await capture("10-fall-death-dropping")
	game.queue_free()
	await process_frame
	quit()
