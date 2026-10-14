extends Node

func restart():
	get_tree().reload_current_scene.call_deferred()
