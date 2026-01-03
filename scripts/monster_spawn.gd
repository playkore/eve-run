extends Node2D

@export var spawn_interval := 5.0
@export var monster_scene: PackedScene
@export var target_path := NodePath("../Eve/CharacterBody2D")
@export var game_state_path := NodePath("../GameState")
@export var glow_intensity := 10.0

@onready var sprite: Sprite2D = $Sprite2D

var elapsed := 0.0
var timer: Timer = null

func _ready() -> void:
	if spawn_interval <= 0.0:
		return
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_spawn_monster)
	_reset_glow()

func _process(delta: float) -> void:
	if spawn_interval <= 0.0:
		return
	elapsed = min(elapsed + delta, spawn_interval)
	_update_glow()

func _spawn_monster() -> void:
	if monster_scene == null:
		return
	var monster = monster_scene.instantiate()
	monster.set("target_path", target_path)
	monster.set("game_state_path", game_state_path)
	monster.global_position = global_position
	get_tree().current_scene.add_child(monster)
	elapsed = 0.0
	_reset_glow()

func _update_glow() -> void:
	if sprite == null:
		return
	var progress = 0.0 if spawn_interval <= 0.0 else clamp(elapsed / spawn_interval, 0.0, 1.0)
	var brightness = 1.0 + glow_intensity * progress
	sprite.modulate = Color(brightness, brightness, brightness, 1.0)

func _reset_glow() -> void:
	if sprite == null:
		return
	sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
