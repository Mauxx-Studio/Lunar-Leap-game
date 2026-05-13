extends Node3D

@export var engine_thrust:float
@export var thrust_change_rate:float = 4

var inertial:bool = true
var thrust:float = 0.0
var engine_on: bool = false

var _direction: Vector3 = Vector3(0, 1, 0)
var _mass: float

var _autorotate: bool
var _autorotation: Callable
var _is_rotating: bool

@onready var ship: OrbitalObject3D = $".."
@onready var ship_model: Node3D = $"../../../../VisibleWorld/ShipView/ShipSV/ShipModel"

func _ready() -> void:
	_mass = ship.mass

func _process(_delta: float) -> void:
	if engine_on and thrust > 0: inertial = false
	if not inertial:
		var _ts = OrbitalManager.get_time_scale()
		if _ts > 8:
			OrbitalManager.set_time_scale(8)
			_ts = OrbitalManager.get_time_scale()
		var a = (ship.get_force() + basis * _direction * thrust * engine_thrust / 100) / _mass
		var v = ship.get_velocity() + a * _delta * _ts
		var p = ship.position + v * _delta * _ts
		if ship.get_velocity().length() > 10 : ship.calcule_orbit(p, v)
		if not engine_on or thrust == 0: inertial = true
	
	# Variation of thrust
	if Input.is_action_pressed("raise_thrust"):
		raise_thrust(_delta)
		if engine_on: ship_model.set_flame(thrust)
	if Input.is_action_pressed("low_thrust"):
		low_thrust(_delta)
		if engine_on: ship_model.set_flame(thrust)
	
	# attitude manual control
	var ang:float = 1
	if Input.is_action_pressed("attitude_down"):
		_autorotate = false
		basis = basis.rotated(basis.x, - ang * _delta)
	if Input.is_action_pressed("attitude_up"):
		_autorotate = false
		basis = basis.rotated(basis.x, ang * _delta)
	if Input.is_action_pressed("attitude_left"):
		_autorotate = false
		basis = basis.rotated(basis.z, ang * _delta)
	if Input.is_action_pressed("attitude_right"):
		_autorotate = false
		basis = basis.rotated(basis.z, - ang * _delta)
	if Input.is_action_pressed("attitude_rot_left"):
		_autorotate = false
		basis = basis.rotated(basis.y, - ang * _delta)
	if Input.is_action_pressed("attitude_rot_right"):
		_autorotate = false
		basis = basis.rotated(basis.y, ang * _delta)
	
	# attitude auto
	if _autorotate:
		if ship.position: 
			var new_basis = _autorotation.call(ship.get_velocity(), ship.position)
			smooth_rotate(new_basis)
	else : _is_rotating = false


func _input(event: InputEvent) -> void:
	# Engine turn on or off with the same key
	if event.is_action_pressed("engine_on_off"):
		engine_on = not engine_on
		if engine_on: ship_model.set_flame(thrust)
		else: ship_model.set_flame(0.0)

# relative thrust, varies between 0 and 100 %
func raise_thrust(delta:float) -> void:
	var change = delta * thrust_change_rate
	thrust *= 1 + change
	if thrust == 0: thrust = change * 10
	thrust = min(thrust, 100)

func low_thrust(delta:float) -> void:
	var change = delta * thrust_change_rate
	thrust *= 1 - change
	if thrust < change * 10: thrust = 0.0
	thrust = max(0.0, thrust)

func _align_basis_to(current_basis:Basis, target_direction_y: Vector3) -> Basis:
	var new_basis = current_basis
	var new_y:Vector3 = target_direction_y.normalized()
	
	new_basis.y = new_y
	new_basis.x = -new_basis.z.cross(new_y).normalized()
	new_basis.z = new_basis.x.cross(new_y)
	new_basis = new_basis.orthonormalized()
	
	return new_basis

func _on_attitude_container_attitude_contorller(auto:bool, autorotation: Callable) -> void:
	_autorotate = auto
	_autorotation = autorotation

func smooth_rotate(new_basis:Basis) -> void:
	var rot1 = basis.y.angle_to(new_basis.y)
	_is_rotating = rot1 > 0.01
	if not _is_rotating: return 
	var axis: Vector3
	if absf(rot1 - PI) < 0.1 : axis = basis.z.normalized()
	else: axis = basis.y.cross(new_basis.y).normalized()
	if rot1 < 0.05:
		if rot1 !=0: basis = basis.rotated(axis, rot1)
		var rot2 = basis.x.angle_to(new_basis.x)
		if rot2 < 0.05:
			_is_rotating = false
			if rot2 != 0: basis = basis.rotated(basis.y, -rot2)
		else:
			var axis2 = basis.x.cross(new_basis.x).normalized()
			basis = basis.rotated(axis2, 0.05)
	else: basis = basis.rotated(axis, 0.05)
