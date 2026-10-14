extends CanvasLayer

@export var life: Control

func _ready() -> void:
	for player : Player in get_tree().get_nodes_in_group(&"Player"):
		life.set_ui_max(player.max_hp)
		player.took_damage.connect(life.update_life_ui)
