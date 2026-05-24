extends ShipComponent

@export var thrust_change_rate: float = 2.0

var inertial:bool
var engines: Array
var engine_on: bool
var thrust:float

var _last_position: Vector3
var _last_velocity: Vector3

@onready var ship: OrbitalObject3D = $"../../EarthSystem/Earth/Ship"
@onready var ship_view: Node3D = $ShipView


func _ready() -> void:
	engines = find_engines()
	#axis_lock_linear_x = true
	#axis_lock_linear_y = true
	#axis_lock_linear_z = true

func _physics_process(_delta: float) -> void:
	if not inertial:
		var pos = ship.position + position - _last_position
		var vel = ship.get_velocity() + linear_velocity - _last_velocity
		ship.calcule_orbit(pos, vel)
		_last_position = position
		_last_velocity = linear_velocity
		var _ts = OrbitalManager.get_time_scale()
		if not engine_on or thrust == 0:
			inertial = true
			GameManager.set_inertial(true)
	if inertial:
		if engine_on and thrust > 0:
			position = Vector3.ZERO
			linear_velocity = Vector3.ZERO
			
			print("hecho  ")
			_last_position = Vector3.ZERO
			_last_velocity = Vector3.ZERO
			GameManager.set_inertial(false)
			inertial = false
	
	
	# Variation of thrust
	if Input.is_action_pressed("raise_thrust"):
		raise_thrust(_delta)
		set_engines_thrust(thrust)
	if Input.is_action_pressed("low_thrust"):
		low_thrust(_delta)
		set_engines_thrust(thrust)

func _process(_delta: float) -> void:
	ship_view.basis = basis.inverse()

func find_engines() -> Array:
	var engs: Array
	var children = find_children("*")
	for i in children.size():
		if children[i].has_method("set_engine_on"):
			engs.append(children[i])
	return engs

func set_engines_thrust(t:float) -> void:
	if engines.size() == 0: return
	for i in engines.size():
		engines[i].set_thrust(t)

func set_engines_on(on:bool) -> void:
	if engines.size() == 0: return
	for i in engines.size():
		engines[i].set_engine_on(on)

func _input(event: InputEvent) -> void:
	# Engine turn on or off with the same key
	if event.is_action_pressed("engine_on_off"):
		engine_on = not engine_on
		set_engines_on(engine_on)

# relative thrust, varies between 0 and 100 %
func raise_thrust(delta:float) -> void:
	var change = delta * thrust_change_rate
	thrust *= 1 + change
	if thrust == 0: thrust = change * .1
	thrust = min(thrust, 1)

func low_thrust(delta:float) -> void:
	var change = delta * thrust_change_rate
	thrust *= 1 - change
	if thrust < change * .1: thrust = 0.0
	thrust = max(0.0, thrust)
