extends Node2D

@export var move_speed := 200.0

# Scaling parameters based on the JSON specification
const HORIZON_Y := 960.0  # 50% of 1920
const MIN_SCALE := 0.1
const MAX_SCALE := 0.8
const MIN_Y := 960.0  # Horizon (50% of height)
const MAX_Y := 1824.0  # Bottom of walkable area (95% of height)

@onready var boy: Node2D = $Boy
@onready var boy_animation: AnimationPlayer = $Boy/AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = $Boy/NavigationAgent2D

var target_position: Vector2
var is_navigating := false

func _ready() -> void:
	# Wait for navigation to be ready
	await get_tree().physics_frame
	navigation_agent.velocity_computed.connect(_on_velocity_computed)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		target_position = event.position
		navigation_agent.target_position = target_position
		is_navigating = true

func _physics_process(delta: float) -> void:
	if is_navigating and not navigation_agent.is_navigation_finished():
		var next_position = navigation_agent.get_next_path_position()
		var direction = (next_position - boy.global_position).normalized()

		# Update character facing direction
		if direction.x != 0.0:
			boy.scale.x = abs(boy.scale.x) * (-1.0 if direction.x > 0.0 else 1.0)

		# Calculate desired velocity
		var desired_velocity = direction * move_speed

		# Use navigation agent's avoidance
		navigation_agent.velocity = desired_velocity

		# Play walk animation
		if boy_animation.current_animation != "run":
			boy_animation.play("run")
	else:
		is_navigating = false
		# Stop animation when idle
		if boy_animation.current_animation != "RESET":
			boy_animation.play("RESET")

	# Update character scale based on depth (y position)
	_update_character_scale()

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	boy.global_position += safe_velocity * get_physics_process_delta_time()

func _update_character_scale() -> void:
	# Calculate scale based on Y position (depth)
	var depth_ratio = clamp((boy.position.y - MIN_Y) / (MAX_Y - MIN_Y), 0.0, 1.0)
	var scale_value = lerp(MIN_SCALE, MAX_SCALE, depth_ratio)

	# Preserve the sign of scale.x for flipping
	var sign_x = sign(boy.scale.x)
	boy.scale = Vector2(scale_value * sign_x, scale_value)
