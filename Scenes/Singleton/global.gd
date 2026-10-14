extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player : Player in get_tree().get_nodes_in_group(&"Player"):
		player.death.connect(restart)

func restart():
	get_tree().reload_current_scene.call_deferred()
