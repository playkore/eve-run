extends StaticBody2D

@export var background_path: NodePath
@export var camera_path: NodePath

func _ready() -> void:
	var background = get_node_or_null(background_path) as Sprite2D
	if background == null:
		return
	_sync_camera_limits(background)

func _sync_camera_limits(background: Sprite2D) -> void:
	var camera: Camera2D = null
	if camera_path != NodePath():
		camera = get_node_or_null(camera_path) as Camera2D
	if camera == null:
		camera = get_viewport().get_camera_2d()
	if camera == null:
		return
	var texture = background.texture
	if texture == null:
		return
	var size = texture.get_size() * background.scale
	var top_left = background.global_position
	if background.centered:
		top_left -= size * 0.5
	camera.limit_left = int(floor(top_left.x))
	camera.limit_top = int(floor(top_left.y))
	camera.limit_right = int(ceil(top_left.x + size.x))
	camera.limit_bottom = int(ceil(top_left.y + size.y))
