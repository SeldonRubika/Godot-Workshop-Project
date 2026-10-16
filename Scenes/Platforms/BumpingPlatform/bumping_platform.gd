extends Area2D
@export var bump_timer: Timer
@export var sprite_2d: Sprite2D
@export var collision_shape_2d: CollisionShape2D

@export var jump_power := 500
const sprites: Array[Texture2D] = [
	preload("uid://ctvh271yr428t"),
	preload("uid://cwxx0vqth62qb"),
	preload("uid://dd21oosn7cr33"),
]
var bumping := false
var bump_index = 0


func _process(_delta: float) -> void:
	if monitoring:
		if has_overlapping_bodies() and bumping == false:
			var bodies = get_overlapping_bodies()
			for body in bodies:
				if body is Player:
					body.velocity.y -= jump_power
			bumping = true
			bump_timer.start()


func _on_bump_timer_timeout() -> void:
	if bumping:
		if bump_index == -1:
			bump_timer.stop()
			monitoring = true
			collision_shape_2d.set_deferred("disabled", false)
			bumping = false
		elif bump_index >= sprites.size() - 1:
			bump_index = -1
			monitoring = false
			collision_shape_2d.set_deferred("disabled", true)
			return
		bump_index += 1
		sprite_2d.texture = sprites[bump_index]
