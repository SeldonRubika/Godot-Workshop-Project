extends StaticBody2D
@export var entity_detector: ShapeCast2D
@export var crumble_timer: Timer
@export var sprite_2d: Sprite2D
@export var collision_shape_2d: CollisionShape2D

const sprites: Array[Texture2D] = [preload("uid://blc47xhtjanlr"),preload("uid://t0uqsu1gaqxc"),preload("uid://73oe5lqsletk")]
var crumbling := false
var crumble_index = 0;

func _process(_delta: float) -> void:
	if entity_detector.is_colliding() and crumbling == false:
		crumbling = true
		crumble_timer.start()


func _on_crumble_timer_timeout() -> void:
	if crumbling:
		if crumble_index == -1:
			var tween = get_tree().create_tween()
			tween.tween_property(self,"modulate",Color(modulate,1.0),.3)
			crumble_timer.stop()
			entity_detector.enabled = true
			collision_shape_2d.set_deferred("disabled",false)
			crumbling=false
		elif crumble_index >= sprites.size()-1:
			var tween = get_tree().create_tween()
			tween.tween_property(self,"modulate",Color(modulate,0.0),.3)
			crumble_index = -1
			entity_detector.enabled = false
			collision_shape_2d.set_deferred("disabled",true)
			return
		crumble_index += 1
		sprite_2d.texture = sprites[crumble_index]
