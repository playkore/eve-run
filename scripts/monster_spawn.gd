extends Node2D

@export var spawn_interval := 5.0
@export var monster_scene: PackedScene
@export var target_path := NodePath("../Eve/CharacterBody2D")
@export var game_state_path := NodePath("../GameState")

func _ready() -> void:
	if spawn_interval <= 0.0:
		return
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_spawn_monster)

func _spawn_monster() -> void:
	if monster_scene == null:
		return
	var monster = monster_scene.instantiate()
	monster.set("target_path", target_path)
	monster.set("game_state_path", game_state_path)
	monster.global_position = global_position
	get_tree().current_scene.add_child(monster)
