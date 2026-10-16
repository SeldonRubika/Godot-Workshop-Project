extends EnemyBase

@export var wall_detector: RayCast2D


func get_direction():
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.target_position.x *= -1
	return direction
