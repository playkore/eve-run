extends Node2D

@export var move_speed := 500.0
@export var acceleration := 2200.0
@export var deceleration := 2600.0

@onready var body: CharacterBody2D = $CharacterBody2D
@onready var sprite: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D

var input_vector := Vector2.ZERO
var boost_remaining := 0.0
var boost_speed := 0.0
var boost_direction := Vector2.ZERO

func _ready() -> void:
	sprite.play("standing")

func set_move_vector(vector: Vector2) -> void:
	input_vector = vector
	if input_vector.length() > 1.0:
		input_vector = input_vector.normalized()

func _physics_process(delta: float) -> void:
	var target_velocity = input_vector * move_speed
	var is_boosting = boost_remaining > 0.0
	if is_boosting:
		target_velocity = boost_direction * boost_speed
		body.velocity = target_velocity
	else:
		var rate = acceleration if target_velocity.length_squared() > body.velocity.length_squared() else deceleration
		body.velocity = body.velocity.move_toward(target_velocity, rate * delta)

	if body.velocity.length_squared() > 1.0:
		# Sprite faces down by default, so add a 90-degree offset.
		body.rotation = body.velocity.angle() + PI / 2.0
		if is_boosting and sprite.sprite_frames.has_animation("boost"):
			if sprite.animation != "boost":
				sprite.play("boost")
		elif sprite.animation != "running":
			sprite.play("running")
	else:
		body.velocity = Vector2.ZERO
		if sprite.animation != "standing":
			sprite.play("standing")

	var previous_position = body.global_position
	body.move_and_slide()
	if is_boosting:
		var traveled = body.global_position.distance_to(previous_position)
		boost_remaining = max(boost_remaining - traveled, 0.0)

func apply_speed_boost(distance: float, speed: float) -> void:
	var direction = body.velocity.normalized()
	if direction.length_squared() == 0.0 and input_vector.length_squared() > 0.0:
		direction = input_vector.normalized()
	if direction.length_squared() == 0.0:
		return
	boost_direction = direction
	boost_remaining = distance
	boost_speed = speed
