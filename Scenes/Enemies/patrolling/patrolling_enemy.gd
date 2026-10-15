extends EnemyBase

@export var patrol_points : Array[float] = []
var point_index := 0


func get_direction():
	var target := patrol_points[point_index]
	var new_dir := (target-global_position.x)
	if abs(global_position.x-target) < 1:
		point_index = (point_index+1)%(patrol_points.size())
	return max(min(new_dir,1),-1)
