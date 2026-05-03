extends Label

@onready var ship: OrbitalObject3D = $"../../../EarthSystem/Earth/Ship"
var update:bool = false

func _process(_delta: float) -> void:
	if update: return
	if ship.get_periapsis().length() == 0: return
	
	var vel = ship.get_velocity().length()
	var str0:String = "Speed = " + magnitude_to_string(vel, "m/s")  
	
	var peri:float = ship.get_periapsis().length()
	if ship.attractor: peri-= ship.attractor.radius
	var str1: String = "Periapsis = " + magnitude_to_string(peri, "m")
	
	var apo: float = ship.get_apoapsis().length() 
	if ship.attractor: apo -= ship.attractor.radius
	var str2: String = "Apoapsis = " + magnitude_to_string(apo, "m")
	
	text = str0 + "\n" +str1 + "\n" + str2
	
	update = true

func magnitude_to_string(value:float, unit:String) -> String:
	if value > 10_000_000:
		value /= 1e6
		unit = " M" + unit
	elif value > 10_000:
		value /= 1_000
		unit = " k" + unit
	else: unit = " " + unit
	return "%.2f" %value + unit

func _on_ship_orbit_changed() -> void:
	update = false
