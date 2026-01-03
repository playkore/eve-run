extends CanvasLayer

@export var game_state_path: NodePath

@onready var lives_label: Label = $LivesLabel

var game_state: Node = null

func _ready() -> void:
	if game_state_path != NodePath():
		game_state = get_node_or_null(game_state_path)
		if game_state != null and game_state.has_signal("lives_changed"):
			game_state.lives_changed.connect(_on_lives_changed)
		if game_state != null:
			_on_lives_changed(int(game_state.get("lives")))

func _on_lives_changed(value: int) -> void:
	lives_label.text = "Lives: %d" % value
