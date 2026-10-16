extends Area2D
class_name Coins

signal picked_up
@export var pickup_particles: CPUParticles2D
@export var sprite_2d: Sprite2D
@export var pickup_sfx: AudioStreamPlayer2D
var picked := false


func _on_body_entered(body: Node2D) -> void:
	if body is Player && !picked:
		picked_up.emit()
		picked = true
		pickup_particles.emitting = true
		pickup_sfx.volume_linear = Global.sfx_volume
		pickup_sfx.pitch_scale = randf_range(.9, 1.1)
		pickup_sfx.play()
		sprite_2d.hide()
		await pickup_particles.finished
		queue_free()
