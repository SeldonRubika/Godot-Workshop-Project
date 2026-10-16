extends Node

var option_disable_checkpoint : bool = false
var option_attack_mouse : bool = false

var music_volume := 0.9
var sfx_volume := 0.9

var respawn_position := Vector2.ZERO:
	set(a):
		respawn_position =a

signal respawn(new_hp:int)
signal game_paused(on:bool)
signal game_started

func restart():
	var player : Player = get_tree().get_first_node_in_group(&"Player")
	player.hp = player.max_hp
	player.global_position = respawn_position
	player.stop_velocity = true
	get_tree().create_timer(.2).timeout.connect(func():player.stop_velocity = false)
	respawn.emit(player.max_hp)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = !get_tree().paused
		game_paused.emit(get_tree().paused)

func _ready() -> void:
	get_tree().paused = true
	game_started.connect(func():get_tree().paused = false)
