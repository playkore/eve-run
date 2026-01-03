extends Node

signal lives_changed(value: int)

var _lives := 3

@export var lives := 3:
	set(value):
		_set_lives(value)
	get:
		return _lives

func _ready() -> void:
	_set_lives(_lives)

func lose_life(amount: int = 1) -> void:
	_set_lives(_lives - amount)

func add_life(amount: int = 1) -> void:
	_set_lives(_lives + amount)

func _set_lives(value: int) -> void:
	_lives = max(value, 0)
	lives_changed.emit(_lives)
