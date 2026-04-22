extends DirectionalLight3D

func _process(_delta: float) -> void:
	var t = OrbitalManager.get_current_time()
	rotation = Vector3(0, 2 * PI * t/(3600*24*365.25), 0)
