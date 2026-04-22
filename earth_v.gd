extends Area3D

@onready var csg_sphere_3d: CSGSphere3D = $CSGSphere3D

func set_radius(r:float) -> void:
	csg_sphere_3d.radius = r

func _process(_delta: float) -> void:
	var t = OrbitalManager.get_current_time()
	csg_sphere_3d.rotation = Vector3(0,t/(3600*24)*2*PI,0)
