extends Node2D

@export var move_speed := 220.0
@export var target_path: NodePath

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var target: Node2D = null

func _ready() -> void:
	if sprite != null:
		sprite.play("default")
	if target_path != NodePath():
		target = get_node_or_null(target_path)

func _physics_process(delta: float) -> void:
	if target == null:
		return
	var to_target = target.global_position - global_position
	if to_target.length_squared() < 1.0:
		return
	global_position += to_target.normalized() * move_speed * delta
