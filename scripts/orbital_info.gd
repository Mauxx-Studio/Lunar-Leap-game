extends Label

@onready var ship: OrbitalObject3D = $"../../../EarthSystem/Earth/Ship"
var update:bool = false

func _process(_delta: float) -> void:
	if update: return
	if ship.get_periapsis().length() == 0: return
	
	var str0:String = "Speed = %.2f m/s" % ship.get_velocity().length()  
	
	var peri:float = (ship.get_periapsis().length() - ship.attractor.radius)
	var peri_unit:String =""
	if peri > 10_000_000:
		peri /= 1e6
		peri_unit = " Mm"
	elif peri > 10_000:
		peri /= 10_000
		peri_unit = " km"
	else: peri_unit = " m"
	var str1: String = "Periapsis = %.2f" % peri + peri_unit
	
	var apo: float = ship.get_apoapsis().length() - ship.attractor.radius
	var apo_unit:String = ""
	if apo > 10_000_000:
		apo /= 1e6
		apo_unit = " Mm"
	elif apo > 10_000:
		apo /= 10_000
		apo_unit = " km"
	else: apo_unit = " m"
	var str2: String = "Apoapsis = %.2f" % apo + apo_unit
	
	text = str0 + "\n" +str1 + "\n" + str2
	
	update = true

func _on_ship_orbit_changed() -> void:
	update = false
