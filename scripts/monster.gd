extends Node2D

@export var move_speed := 220.0
@export var target_path: NodePath
@export var game_state_path: NodePath

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

var target: Node2D = null
var game_state: Node = null

func _ready() -> void:
	if sprite != null:
		sprite.play("default")
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
	if not (body is CharacterBody2D):
		return
	if game_state != null and game_state.has_method("lose_life"):
		game_state.lose_life(1)
	queue_free()
