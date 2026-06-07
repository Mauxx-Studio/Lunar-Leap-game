extends VBoxContainer

@onready var ship: OrbitalObject3D = $"../../../EarthSystem/Earth/Ship"
var update:bool = false

@onready var speed_label: Label = $SpeedLabel
@onready var altittude_label: Label = $AltittudeLabel
@onready var periapsis_label: Label = $PeriapsisLabel
@onready var apoapsis_label: Label = $ApoapsisLabel

func _process(_delta: float) -> void:
	if update: return
	if ship.get_periapsis().length() == 0: return
	
	var vel = ship.get_velocity().length()
	speed_label.text = "Speed = " + magnitude_to_string(vel, "m/s")  
	
	var alt = ship.position.length() - ship.attractor.radius
	altittude_label.text = "Altitude = " + magnitude_to_string(alt, "m") 
	
	var peri:float = ship.get_periapsis().length()
	if ship.attractor: peri-= ship.attractor.radius
	periapsis_label.text = "Periapsis = " + magnitude_to_string(peri, "m")
	
	if ship._is_eliptic():
		var apo: float = ship.get_apoapsis().length() 
		if ship.attractor: apo -= ship.attractor.radius
		apoapsis_label.text = "Apoapsis = " + magnitude_to_string(apo, "m")
	else: apoapsis_label.text = "Orbit not elliptical"

func magnitude_to_string(value:float, unit:String) -> String:
	var _sign:String = "  "
	if value < 0: _sign ="- "
	value = absf(value)
	if value > 10_000_000:
		value /= 1e6
		unit = " M" + unit
	elif value > 10_000:
		value /= 1_000
		unit = " k" + unit
	else: unit = " " + unit
	return _sign + "%.2f" %value + unit

func _on_ship_orbit_changed() -> void:
	update = false
