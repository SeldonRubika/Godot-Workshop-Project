extends Node

var option_enable_checkpoint : bool = false
var option_attack_mouse : bool = false

var respawn_position := Vector2.ZERO:
	set(a):
		respawn_position =a
signal respawn(new_hp:int)

func restart():
	var player : Player = get_tree().get_first_node_in_group(&"Player")
	player.hp = player.max_hp
	player.global_position = respawn_position
	player.stop_velocity = true
	get_tree().create_timer(.2).timeout.connect(func():player.stop_velocity = false)
	respawn.emit(player.max_hp)
