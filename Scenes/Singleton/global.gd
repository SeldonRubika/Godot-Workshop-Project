extends Node

var respawn_position := Vector2.ZERO
signal respawn(new_hp:int)
func restart():
	var player : Player = get_tree().get_first_node_in_group(&"Player")
	player.hp = player.max_hp
	player.global_position = respawn_position
	player.stop_velocity = true
	get_tree().create_timer(.2).timeout.connect(func():player.stop_velocity = false)
	respawn.emit(player.max_hp)
