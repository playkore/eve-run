extends Node2D

@onready var eve = $Eve
@onready var joystick = $VirtualJoystick

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	var move_vector = joystick.get_move_vector()
	eve.set_move_vector(move_vector)
