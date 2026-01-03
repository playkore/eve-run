extends Node2D

@export var move_speed := 500.0

@onready var eve: Node2D = $Eve
@onready var eve_sprite: AnimatedSprite2D = $Eve/AnimatedSprite2D

var target_position := Vector2.ZERO
var is_moving := false
var is_pressing := false

func _ready() -> void:
	eve_sprite.play("standing")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_pressing = true
			_start_move(event.position)
		else:
			is_pressing = false
			_stop_move()
	elif event is InputEventScreenTouch:
		if event.pressed:
			is_pressing = true
			_start_move(event.position)
		else:
			is_pressing = false
			_stop_move()
	elif event is InputEventMouseMotion and is_pressing:
		_start_move(event.position)

func _physics_process(delta: float) -> void:
	if not is_moving:
		return

	var to_target = target_position - eve.global_position
	var distance = to_target.length()
	if distance <= 1.0:
		eve.global_position = target_position
		_stop_move()
		return

	var direction = to_target / distance
	# Rotate Eve towards the current target while moving.
	# Sprite faces down by default, so add a 90-degree offset.
	eve.rotation = direction.angle() + PI / 2.0
	var step = move_speed * delta
	if step >= distance:
		eve.global_position = target_position
		_stop_move()
		return

	eve.global_position += direction * step

func _start_move(position: Vector2) -> void:
	target_position = position
	is_moving = true
	_rotate_towards_target()
	if eve_sprite.animation != "running":
		eve_sprite.play("running")

func _stop_move() -> void:
	if not is_moving:
		return
	is_moving = false
	if eve_sprite.animation != "standing":
		eve_sprite.play("standing")

func _rotate_towards_target() -> void:
	var to_target = target_position - eve.global_position
	if to_target.length_squared() > 0.0:
		# Sprite faces down by default, so add a 90-degree offset.
		eve.rotation = to_target.angle() + PI / 2.0
