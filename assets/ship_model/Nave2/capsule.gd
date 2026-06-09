extends ShipController

signal kill_autorotate()

@export var thrust_change_rate: float = 2.0
@export var angular_velocity_limit:float = 0.1

var inertial:bool
var engine_on: bool
var thrust:float

var _autorotate: bool
var _autodirection: Callable
var _rotation:float = 0.0
var _stabilize:bool

@onready var ship: OrbitalObject3D = $"../../../EarthSystem/Earth/Ship"
@onready var ship_view: Node3D = $".."
@onready var reaction_wheel: Node = $ReactionWheel

func _ready() -> void:
	find_components(self,self)
	find_engines()
	update_ship_mass()
	ship.mass = get_ship_mass()

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
	if _stabilize:
		stabilize_ship()
	
		# Variation of thrust
	if Input.is_action_pressed("raise_thrust"):
		raise_thrust(_delta)
		set_engines_thrust(thrust)
	if Input.is_action_pressed("low_thrust"):
		low_thrust(_delta)
		set_engines_thrust(thrust)

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
	var local_dir:Vector3 = basis.inverse() * direction
	var omg:Vector3 = basis.inverse() * angular_velocity
	var rot:Vector3 = Vector3.UP.cross(local_dir)
	reaction_wheel.stabilize_by_axis(omg.y, Vector3.UP)
	reaction_wheel.rotate_by_axis(rot.x,omg.x,Vector3.RIGHT)
	reaction_wheel.rotate_by_axis(rot.z,omg.z,Vector3.BACK)

func stabilize_ship() -> void:
	var omg:Vector3 = basis.inverse() * angular_velocity
	reaction_wheel.stabilize_by_axis(omg.x, Vector3.RIGHT)
	reaction_wheel.stabilize_by_axis(omg.y, Vector3.UP)
	reaction_wheel.stabilize_by_axis(omg.z, Vector3.BACK)

func _on_attitude_container_direction_controller(auto: bool, auto_direction: Callable) -> void:
	_autorotate = auto
	_autodirection = auto_direction
	_rotation = 0.0


func _on_stabilize_toggled(toggled_on: bool) -> void:
	_stabilize = toggled_on
	if !toggled_on: set_autorotate(false)
