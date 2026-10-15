extends Node2D

@export var player_spawn_pos : Vector2
@export var set_player_pos := true

func _ready() -> void:
	if set_player_pos:
		var player : Player = get_tree().get_first_node_in_group(&"Player")
		player.global_position = player_spawn_pos
