extends CanvasLayer

@export var hp_bar: TextureProgressBar
@export var hp_bar_highlight: TextureProgressBar

func _ready() -> void:
	for player : Player in get_tree().get_nodes_in_group(&"Player"):
		player.took_damage.connect(update_life_ui)

func update_life_ui(new_life:int):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(hp_bar,"value",new_life,.4)
	tween.tween_property(hp_bar_highlight,"value",new_life,.2)
