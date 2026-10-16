extends CanvasLayer

@export var life: Control
@export var bloup_bloup: ColorRect
@export var coin_text: RichTextLabel
var coin_amount = 0


func _ready() -> void:
	for coin: Coins in get_tree().get_nodes_in_group(&"coins"):
		coin.picked_up.connect(add_coin)
	for player: Player in get_tree().get_nodes_in_group(&"Player"):
		life.set_ui_max(player.max_hp)
		player.took_damage.connect(life.update_life_ui)


func add_coin():
	coin_amount += 1
	coin_text.text = "[color=yellow]x%s" % coin_amount


func _on_main_menu_bloup_bloup(toggled_on: bool) -> void:
	bloup_bloup.visible = toggled_on
