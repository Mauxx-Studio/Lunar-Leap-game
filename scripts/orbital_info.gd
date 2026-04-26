extends Label

@onready var ship: OrbitalObject3D = $"../../../EarthSystem/Earth/Ship"
var update:bool = true

func _process(_delta: float) -> void:
	if update: return
	var str1: String = "Periapsis = %.0f" % (ship.get_periapsis().length() - ship.attractor.radius)
	text = str1
	update = false

func _on_ship_orbit_changed() -> void:
	update = true
