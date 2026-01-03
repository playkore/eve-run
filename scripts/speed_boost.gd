extends Area2D

@export var boost_distance := 100.0
@export var boost_speed := 1000.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	var eve = body.get_parent()
	if eve != null and eve.has_method("apply_speed_boost"):
		eve.apply_speed_boost(boost_distance, boost_speed)
