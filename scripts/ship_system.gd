extends Node3D

@export var engine_thrust:float
@export var thrust_change_rate:float = 4

var _autorotate: bool
var _autorotation: Callable
var _is_rotating: bool

@onready var ship: OrbitalObject3D = $".."

func _process(_delta: float) -> void:
	
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
