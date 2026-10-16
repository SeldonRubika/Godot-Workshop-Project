extends Camera2D


func _ready() -> void:
	Global.camera = self


var og_pos: Vector2
var start := 0.0
var duration := 0.0
var intensity := 3.0


func screen_shake(time, intensity_arg := 1.0):
	start = 0
	duration = time
	intensity = intensity_arg


func _process(delta: float) -> void:
	start += delta
	if start < duration:
		var player = get_tree().get_first_node_in_group(&"Player")
		global_position = player.global_position + Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity),
		)
