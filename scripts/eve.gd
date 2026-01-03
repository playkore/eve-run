extends Node2D

@export var move_speed := 500.0
@export var acceleration := 2200.0
@export var deceleration := 2600.0

@onready var body: CharacterBody2D = $CharacterBody2D
@onready var sprite: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D

var input_vector := Vector2.ZERO

func _ready() -> void:
	sprite.play("standing")

func set_move_vector(vector: Vector2) -> void:
	input_vector = vector
	if input_vector.length() > 1.0:
		input_vector = input_vector.normalized()

func _physics_process(delta: float) -> void:
	var target_velocity = input_vector * move_speed
	var rate = acceleration if target_velocity.length_squared() > body.velocity.length_squared() else deceleration
	body.velocity = body.velocity.move_toward(target_velocity, rate * delta)

	if body.velocity.length_squared() > 1.0:
		# Sprite faces down by default, so add a 90-degree offset.
		body.rotation = body.velocity.angle() + PI / 2.0
		if sprite.animation != "running":
			sprite.play("running")
	else:
		body.velocity = Vector2.ZERO
		if sprite.animation != "standing":
			sprite.play("standing")

	body.move_and_slide()
