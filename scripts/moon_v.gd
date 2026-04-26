
extends Area3D

@onready var csg_sphere_3d: CSGSphere3D = $CSGSphere3D
@onready var moon: OrbitalObject3D = $"../../../EarthSystem/Earth/Moon"
@onready var visible_world: Node3D = $"../.."

func set_radius(r:float) -> void:
	csg_sphere_3d.radius = r

func get_trajectory(segments:int)-> Array[Vector3]:
	var result = moon.get_trajectory(segments)
	for i in result.size():
		result[i] *= GameManager.view_scale
	return result

func _process(_delta: float) -> void:
	var t = OrbitalManager.get_current_time()
	csg_sphere_3d.rotation = Vector3(0,t/2324977.4*2*PI,0)
