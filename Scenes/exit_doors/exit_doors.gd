extends Area2D

@export var next_level : PackedScene= null

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if next_level == null:
			get_tree().reload_current_scene.call_deferred()
		else:
			next_level.instantiate()
			get_parent().queue_free()
