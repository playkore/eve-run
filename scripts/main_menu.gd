extends Control

@export var level01_scene := "res://scenes/levels/level01.tscn"

@onready var level01_button: Button = $CenterContainer/VBoxContainer/Level01Button

func _ready() -> void:
	level01_button.pressed.connect(_on_level01_pressed)

func _on_level01_pressed() -> void:
	get_tree().change_scene_to_file(level01_scene)
