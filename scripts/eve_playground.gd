extends Node2D

@export var joystick_radius := 90.0
@export var joystick_deadzone := 12.0
@export var joystick_color := Color(1.0, 1.0, 1.0, 0.25)

@onready var eve = $Eve

var is_moving := false
var joystick_active := false
var joystick_id := -1
var joystick_origin := Vector2.ZERO
var joystick_current := Vector2.ZERO

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and not joystick_active:
			_start_joystick(event.position, event.index)
		elif not event.pressed and event.index == joystick_id:
			_stop_joystick()
	elif event is InputEventScreenDrag:
		if joystick_active and event.index == joystick_id:
			_update_joystick(event.position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_joystick(event.position, -1)
		else:
			_stop_joystick()
	elif event is InputEventMouseMotion:
		if joystick_active and joystick_id == -1 and (event.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
			_update_joystick(event.position)

func _physics_process(_delta: float) -> void:
	var move_vector := Vector2.ZERO
	if is_moving:
		var input_vector = joystick_current - joystick_origin
		var distance = input_vector.length()
		if distance >= joystick_deadzone:
			if distance > joystick_radius:
				input_vector = input_vector.normalized() * joystick_radius
				distance = joystick_radius
			move_vector = input_vector.normalized() * (distance / joystick_radius)

	eve.set_move_vector(move_vector)

func _start_joystick(position: Vector2, touch_id: int) -> void:
	joystick_active = true
	joystick_id = touch_id
	joystick_origin = position
	joystick_current = position
	is_moving = true
	queue_redraw()

func _update_joystick(position: Vector2) -> void:
	joystick_current = position
	queue_redraw()

func _stop_joystick() -> void:
	if not joystick_active:
		return
	joystick_active = false
	joystick_id = -1
	is_moving = false
	queue_redraw()

func _draw() -> void:
	if joystick_active:
		draw_circle(joystick_origin, joystick_radius, joystick_color)
