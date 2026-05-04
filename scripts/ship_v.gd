extends Area3D

@export var engine_thrust:float

@onready var ship: OrbitalObject3D = $"../../../../EarthSystem/Earth/Ship"
@onready var ship_system: Node3D = $"../../../../EarthSystem/Earth/Ship/ShipSystem"
@onready var icon: Node3D = $Icon
@onready var camera_map_view: Camera3D = %CameraMapView

func _process(_delta: float) -> void:
	basis = ship_system.basis
	# Update the icon orientation and size
	icon.update(ship.get_velocity(), position, camera_map_view.global_position)

func get_trajectory(segments:int) -> Array[Vector3]:
	var result = ship.get_trajectory(segments)
	for i in result.size():
		result[i] *= GameManager.view_scale
	return result
 
func _on_ship_has_new_attractor(attractor: OrbitalObject3D) -> void:
	var new_parent = attractor.related_to
	if new_parent is Node3D:
		reparent(new_parent)
	
