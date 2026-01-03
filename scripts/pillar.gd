@tool
extends StaticBody2D

@export var radius := 24.0:
	set(value):
		radius = value
		_sync_shape()
		queue_redraw()

@export var color := Color(0.85, 0.85, 0.85, 1.0):
	set(value):
		color = value
		queue_redraw()

@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_sync_shape()

func _sync_shape() -> void:
	if not is_instance_valid(collision):
		return
	var shape = collision.shape
	if shape == null:
		shape = CircleShape2D.new()
		collision.shape = shape
	shape.radius = radius

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)
