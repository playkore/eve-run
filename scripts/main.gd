extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("run")
	_center_sprite()

func _center_sprite() -> void:
	animated_sprite.position = get_viewport_rect().size / 2.0
