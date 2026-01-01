extends Node2D

@export var move_speed := 120.0

@onready var boy: Node2D = $Boy
@onready var boy_animation: AnimationPlayer = $Boy/AnimationPlayer

func _ready() -> void:
	_center_boy()

func _process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		boy.position.x += direction * move_speed * delta
		if boy_animation.current_animation != "walk":
			boy_animation.play("walk")
		boy.scale.x = abs(boy.scale.x) * (-1.0 if direction > 0.0 else 1.0)
	else:
		if boy_animation.current_animation != "RESET":
			boy_animation.play("RESET")

func _center_boy() -> void:
	boy.position = get_viewport_rect().size / 2.0
