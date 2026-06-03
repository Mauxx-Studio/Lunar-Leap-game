extends SpaceShip

signal kill_autorotate()

@export var thrust_change_rate: float = 2.0
@export var angular_velocity_limit:float = 0.1

var inertial:bool
var engine_on: bool
var thrust:float

var _autorotate: bool
var _autodirection: Callable
var _rotation:float = 0.0
var _factor_torque:float

@onready var ship: OrbitalObject3D = $"../../../EarthSystem/Earth/Ship"
@onready var ship_view: Node3D = $".."
@onready var reaction_wheel: Node = $ReactionWheel

func _ready() -> void:
	find_components(self,self)
	find_engines()
	update_ship_mass()
	ship.mass = get_ship_mass()
	axis_lock_linear_x = true
	axis_lock_linear_y = true
	axis_lock_linear_z = true

func _physics_process(_delta: float) -> void:
	if not inertial:
		if not engine_on or thrust == 0:
			linear_velocity = Vector3.ZERO
			position= Vector3.ZERO 
			inertial = true
			GameManager.set_inertial(true)
		var ts:= OrbitalManager.get_time_scale()
		var a = (get_total_thrust() + ship.get_force()) / ship_mass
		var v = ship.get_velocity() + a * _delta * ts
		var p = ship.position + v * _delta * ts
		ship.calcule_orbit(p,v)
	if inertial:
		if engine_on and thrust > 0:
			OrbitalManager.set_time_scale(1)
			GameManager.set_inertial(false)
			inertial = false
			linear_velocity = Vector3.ZERO
			position= Vector3.ZERO
	if _autorotate:
		var dir = _autodirection.call(ship.get_velocity(), ship.position)
		rotate_ship_to(dir)
	
		# Variation of thrust
	if Input.is_action_pressed("raise_thrust"):
		raise_thrust(_delta)
		set_engines_thrust(thrust)
	if Input.is_action_pressed("low_thrust"):
		low_thrust(_delta)
		set_engines_thrust(thrust)

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

func set_autorotate(on:bool)-> void:
	_autorotate = on
	if not on: kill_autorotate.emit()

func get_autorotate() -> bool:
	return _autorotate

func rotate_ship_to(direction:Vector3) -> void:
	var local_dir = basis.inverse() * direction
	var angl = Vector3.UP.angle_to(local_dir)
	if angl > 3.12:
		apply_torque(basis * Vector3.RIGHT * reaction_wheel.torque)
		print("aplicado torque aux")
		return
	var rot = basis * Vector3.UP.cross(local_dir)
	if _rotation == 0.0:
		_rotation = angl
		if angl > 0.1: _factor_torque = 1.0
		else: _factor_torque = 0.4
	if angl > 3.0/4.0 *_rotation:
		apply_torque(rot.normalized() * reaction_wheel.torque * _factor_torque)
		return
	if angl < 1.0/4.0 *_rotation:
		apply_torque(-angular_velocity.normalized() * reaction_wheel.torque * _factor_torque)
	if angl < 0.005 or angular_velocity.length() < 0.01: _rotation = 0.0

func _on_attitude_container_direction_controller(auto: bool, auto_direction: Callable) -> void:
	set_autorotate(auto)
	print(auto)
	_autodirection = auto_direction
	_rotation = 0.0
