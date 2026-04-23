extends Area3D

@onready var ship: OrbitalObject3D = $"../../../EarthSystem/Earth/Ship"
@onready var visible_world: Node3D = $"../.."
@onready var icon: Node3D = $Icon
@onready var camera_3d: Camera3D = %Camera3D

func _process(_delta: float) -> void:
	# Update the icon orientation and size
	icon.update(ship.get_velocity(), position, camera_3d.global_position)

func get_trajectory(segments:int) -> Array[Vector3]:
	var result = ship.get_trajectory(segments)
	for i in result.size():
		result[i] *= visible_world.v_scale
	return result
