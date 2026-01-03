extends Node2D

@export var move_speed := 220.0
@export var target_path: NodePath
@export var game_state_path: NodePath

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var explosion_particles: GPUParticles2D = $ExplosionParticles

var target: Node2D = null
var game_state: Node = null
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	if sprite != null:
		sprite.play("default")
		var frames = sprite.sprite_frames
		if frames != null and frames.has_animation("default"):
			var count = frames.get_frame_count("default")
			if count > 0:
				sprite.frame = rng.randi_range(0, count - 1)
				sprite.frame_progress = rng.randf()
	if target_path != NodePath():
		target = get_node_or_null(target_path)
	if game_state_path != NodePath():
		game_state = get_node_or_null(game_state_path)
	if hitbox != null:
		hitbox.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if target == null:
		return
	var to_target = target.global_position - global_position
	if to_target.length_squared() < 1.0:
		return
	global_position += to_target.normalized() * move_speed * delta

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		if game_state != null and game_state.has_method("lose_life"):
			game_state.lose_life(1)
		_explode()
	elif body is StaticBody2D:
		_explode()

func _explode() -> void:
	if sprite != null:
		sprite.visible = false
	if hitbox != null:
		hitbox.monitoring = false
	move_speed = 0.0
	if explosion_particles != null:
		explosion_particles.restart()
		explosion_particles.emitting = true
		await get_tree().create_timer(explosion_particles.lifetime).timeout
	queue_free()
