extends CanvasLayer

@export var life: Control
@export var bloup_bloup: ColorRect

func _ready() -> void:
	for player : Player in get_tree().get_nodes_in_group(&"Player"):
		life.set_ui_max(player.max_hp)
		player.took_damage.connect(life.update_life_ui)


func _on_main_menu_bloup_bloup(toggled_on: bool) -> void:
	bloup_bloup.visible = toggled_on
