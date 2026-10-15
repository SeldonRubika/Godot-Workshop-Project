extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.respawn_position = body.global_position
