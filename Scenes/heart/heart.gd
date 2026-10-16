extends Area2D

var index := 0
const TILE_0041 = preload("uid://tfp2utuxmvea")
const TILE_0042 = preload("uid://c5tvb1fwc1t2q")
@export var sprite_2d: Sprite2D
@export var heal := 33


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(-heal)
		queue_free()


func _on_sprite_timer_timeout() -> void:
	if index == 1:
		index = 0
		sprite_2d.texture = TILE_0042
	else:
		index = 1
		sprite_2d.texture = TILE_0041
