extends Node2D
class_name Level

@export var player_spawn_pos: Vector2
@export var set_player_pos := true

var failed_no_hit := false
var failed_no_death := false
@export var max_coin = 14
var coin_amount = 0


func _ready() -> void:
	for coin: Coins in get_tree().get_nodes_in_group(&"coins"):
		coin.picked_up.connect(add_coin)
	if set_player_pos:
		var player: Player = get_tree().get_first_node_in_group(&"Player")
		player.global_position = player_spawn_pos
		player.took_damage.connect(
			func(_hp):
				failed_no_hit = true,
		)
		player.death.connect(
			func():
				failed_no_death = true,
		)


func add_coin():
	coin_amount += 1
	if coin_amount == max_coin:
		Global.achievement.got_achievement(preload("uid://b4dddvwn6pax2"))
