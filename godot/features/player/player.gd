extends CharacterBody2D

const Tuning = preload("res://features/player/tuning.gd")
var tuning = Tuning.new()
var enabled: bool = false
var tick: int = 0
var last_floor_tick: int = -1000
var jump_request_tick: int = -1000
var opportunity_consumed: bool = false
var require_jump_release: bool = true
var facing: float = 1.0
var jumps: int = 0
var test_control: bool = false
var test_axis: float = 0.0
var test_jump_pressed: bool = false
var test_jump_held: bool = false
# Presentation only: none of these values affect movement or collision.
var dead: bool = false
var death_ticks: int = 0
var spear_angle: float = 0.0
var show_collider: bool = false
const RUN_SPEAR_ANGLE := deg_to_rad(25.0)
const DEATH_HOP_SPEED := 300.0
const DEATH_FALL_ACCEL := 900.0
# A fall death happens below the visible screen, so its hop is drawn from the
# playfield's bottom edge instead, with a higher pop so it can be seen.
const FALL_HOP_SPEED := 450.0
const FALL_HOP_ACCEL := 1100.0
var death_from_fall: bool = false
var death_draw_base: float = 0.0

func _ready() -> void:
	name = "Player"
	collision_layer = 2
	collision_mask = 1
	floor_snap_length = 1.0
	var shape := RectangleShape2D.new()
	shape.size = Vector2(18, 28)
	var collider := CollisionShape2D.new()
	collider.shape = shape
	collider.position = Vector2(0, -14)
	add_child(collider)

func reset_at(spawn: Vector2) -> void:
	position = spawn
	velocity = Vector2.ZERO
	last_floor_tick = -1000
	jump_request_tick = -1000
	opportunity_consumed = false
	require_jump_release = true
	test_jump_pressed = false
	jumps = 0
	dead = false
	death_ticks = 0
	death_from_fall = false
	death_draw_base = 0.0
	spear_angle = 0.0
	queue_redraw()

## from_fall: the body fell past the level's fall boundary (off-screen).
## visible_bottom_y: world y of the playfield's bottom edge, for the fall pop-up.
func die(from_fall: bool = false, visible_bottom_y: float = 0.0) -> void:
	dead = true
	death_ticks = 0
	death_from_fall = from_fall
	# Start the drawn body just below the visible edge (head at the edge).
	death_draw_base = (visible_bottom_y + 28.0 - position.y) if from_fall else 0.0
	queue_redraw()

## Drawing-only vertical offset of the death hop, relative to the body. The body
## itself stays frozen where it died, so the hop can never trigger hazards, the
## fall boundary, or delay the session's retry timer.
func death_offset() -> float:
	if not dead:
		return 0.0
	var t := float(death_ticks) / 60.0
	if death_from_fall:
		return death_draw_base - FALL_HOP_SPEED * t + FALL_HOP_ACCEL * t * t
	return -DEATH_HOP_SPEED * t + DEATH_FALL_ACCEL * t * t

func _physics_process(delta: float) -> void:
	if dead:
		death_ticks += 1
		queue_redraw()
		return
	if not enabled:
		return
	tick += 1
	var axis := test_axis if test_control else Input.get_axis("move_left", "move_right")
	var held := test_jump_held if test_control else Input.is_action_pressed("jump")
	var pressed := test_jump_pressed if test_control else Input.is_action_just_pressed("jump")
	test_jump_pressed = false
	if not held:
		require_jump_release = false
	if is_on_floor() and velocity.y >= 0.0:
		last_floor_tick = tick
		opportunity_consumed = false
	if pressed and not require_jump_release:
		jump_request_tick = tick
	var rate: float = tuning.acceleration if not is_zero_approx(axis) else tuning.deceleration
	velocity.x = move_toward(velocity.x, axis * tuning.speed, rate * delta)
	if not is_zero_approx(axis):
		facing = signf(axis)
	velocity.y = minf(velocity.y + tuning.gravity * delta, tuning.terminal_velocity)
	if not opportunity_consumed and tick - last_floor_tick <= tuning.coyote_ticks and tick - jump_request_tick <= tuning.buffer_ticks:
		velocity.y = tuning.jump_velocity
		opportunity_consumed = true
		jump_request_tick = -1000
		jumps += 1
	move_and_slide()
	position.x = maxf(position.x, 10.0)
	# Spear tilts toward the movement while running; upright when idle or airborne.
	var running := is_on_floor() and absf(velocity.x) > 8
	spear_angle = lerpf(spear_angle, RUN_SPEAR_ANGLE if running else 0.0, 0.3)
	queue_redraw()

func _draw() -> void:
	var ink := Color("25354a")
	var tunic := Color("f2c230")
	var tunic_shade := Color("c99a1c")
	var helmet := Color("2f6fb0")
	var helmet_shine := Color("6fa3d6")
	var skin := Color("f3cfa5")
	var running := is_on_floor() and absf(velocity.x) > 8 and not dead
	var stride := sin(float(tick) * 0.7) * 2.0 if running else 0.0
	var hop := death_offset()
	# Drawn once facing right, then mirrored, so left and right cannot drift apart.
	draw_set_transform(Vector2(0, hop), 0.0, Vector2(facing, 1.0))
	# Legs: a stepping foot lifts (shortens upward), so no foot is ever drawn
	# below the collider's floor line at y = 0.
	draw_rect(Rect2(-6, -5, 5, 5 - maxf(stride, 0.0)), ink)
	draw_rect(Rect2(1, -5, 5, 5 - maxf(-stride, 0.0)), ink)
	# Tunic with outline and belt
	draw_rect(Rect2(-8, -17, 16, 13), ink)
	draw_rect(Rect2(-7, -16, 14, 11), tunic)
	draw_rect(Rect2(-7, -9, 14, 2), tunic_shade)
	# Face strip under the helmet
	draw_rect(Rect2(-7, -21, 14, 5), ink)
	draw_rect(Rect2(-6, -20, 12, 3), skin)
	if dead:
		for x in [-2.0, 3.0]:
			draw_line(Vector2(x - 1, -20), Vector2(x + 1, -18), ink, 1.0)
			draw_line(Vector2(x - 1, -18), Vector2(x + 1, -20), ink, 1.0)
	else:
		draw_rect(Rect2(3, -20, 2, 2), ink)
	# Dome helmet; the brim reaches forward, so the silhouette shows facing too.
	draw_colored_polygon(PackedVector2Array([Vector2(-8, -20), Vector2(-8, -24), Vector2(-5, -28), Vector2(5, -28), Vector2(8, -24), Vector2(9, -20)]), ink)
	draw_colored_polygon(PackedVector2Array([Vector2(-7, -21), Vector2(-7, -24), Vector2(-4, -27), Vector2(4, -27), Vector2(7, -24), Vector2(8, -21)]), helmet)
	draw_rect(Rect2(-3, -26, 4, 1), helmet_shine)
	if not dead:
		# Thin decorative spear: no collision. Pivot is the front hand.
		var hand := Vector2(8, -12)
		var up := Vector2(sin(spear_angle), -cos(spear_angle))
		var side := Vector2(-up.y, up.x)
		var tip_base := hand + up * 22.0
		draw_line(hand - up * 6.0, tip_base, Color("b89b6a"), 1.0)
		draw_colored_polygon(PackedVector2Array([tip_base + side * 2.0, tip_base + up * 6.0, tip_base - side * 2.0]), Color("8a94a6"))
		draw_rect(Rect2(hand.x - 1.5, hand.y - 1.5, 3, 3), skin)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	if show_collider:
		# Debug overlay: the real 18×28 collision box, at the real body position.
		draw_rect(Rect2(-9, -28, 18, 28), Color(0.0, 0.85, 0.85, 0.9), false, 1.0)
