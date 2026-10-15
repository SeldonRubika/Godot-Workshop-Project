extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player and !Global.option_enable_checkpoint:
		Global.respawn_position = body.global_position
