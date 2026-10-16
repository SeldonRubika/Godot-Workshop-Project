extends Area2D

@export var next_level: PackedScene = null
@export var current_level: Level


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.ui.end_black_screen.show()
		Global.achievement.got_achievement(preload("uid://df1ulm860rbyv"))
		await Global.achievement.available
		if check_if_all_enemy_died():
			Global.achievement.got_achievement(preload("uid://dvvdrdjq6rmgg"))
			await Global.achievement.available
		if !current_level.failed_no_death:
			Global.achievement.got_achievement(preload("uid://b3f1ulhhmfrec"))
			await Global.achievement.available
		if !current_level.failed_no_hit:
			Global.achievement.got_achievement(preload("uid://lcut3uwb35uc"))
			await Global.achievement.available
		Global.ui.end_black_screen.hide()
		if next_level == null:
			get_tree().reload_current_scene.call_deferred()
		else:
			next_level.instantiate()
			get_parent().queue_free()


func check_if_all_enemy_died():
	for monster in get_tree().get_nodes_in_group(&"monster"):
		if monster.has_been_killed == false:
			return false
	return true
