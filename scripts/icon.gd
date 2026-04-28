extends Node3D

@onready var cone: CSGCylinder3D = $Cone

const RELATION: float = 120

func update(ship_velocity: Vector3, ship_position: Vector3, camera_g_position: Vector3) -> void:
	#var i_icon = ship_velocity.normalized()
	#var j_icon = ship_position.cross(i_icon).normalized()
	#basis = Basis(i_icon,j_icon,i_icon.cross(j_icon))
	
	var camera_distance = (camera_g_position - global_position).length()
	cone.radius = 0.5 * camera_distance / RELATION
	cone.height = 2.5 * camera_distance / RELATION
