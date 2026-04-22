extends Area3D

@onready var ship: OrbitalObject3D = $"../../../EarthSystem/Earth/Ship"
@onready var visible_world: Node3D = $"../.."

func get_trajectory(segments:int) -> Array[Vector3]:
	var result = ship.get_trajectory(segments)
	for i in result.size():
		result[i] *= visible_world.v_scale
	return result
