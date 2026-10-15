extends Control

@export var hp_bar: TextureProgressBar
@export var hp_bar_highlight: TextureProgressBar
@export var ease_in := false
func update_life_ui(new_life:int):
	var tween = create_tween()
	if ease_in:
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(hp_bar,"value",new_life,.4)
	tween.tween_property(hp_bar_highlight,"value",new_life,.2)

func set_ui_max(max_hp):
	hp_bar.max_value = max_hp
	hp_bar.value = max_hp
	hp_bar_highlight.max_value = max_hp
	hp_bar_highlight.value = max_hp
