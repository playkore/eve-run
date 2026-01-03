extends StaticBody2D

@export var background_path: NodePath
@export var polygon_path: NodePath

func _ready() -> void:
	var background = get_node_or_null(background_path) as Sprite2D
	var polygon = get_node_or_null(polygon_path) as CollisionPolygon2D
	if background == null or polygon == null:
		return
	var texture = background.texture
	if texture == null:
		return
	background.centered = false
	var size = texture.get_size()
	polygon.polygon = PackedVector2Array([
		Vector2.ZERO,
		Vector2(size.x, 0.0),
		Vector2(size.x, size.y),
		Vector2(0.0, size.y)
	])
	polygon.build_mode = CollisionPolygon2D.BUILD_SEGMENTS
