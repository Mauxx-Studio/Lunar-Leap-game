extends Node3D

@onready var engine: CSGCylinder3D = $engine
@onready var flame: CSGCylinder3D = $flame

func set_flame(thrust:float):
	flame.height = thrust / 50 + 0.02  # thrust varia de 0 a 100, height de 0 a 2
	flame.position.y = engine.position.y - engine.height / 2 - flame.height / 2
	flame.material.emission_energy_multiplier = thrust / 100 + 0.05
	
