extends Area3D

@export var engine_thrust:float

var inertial:bool = true
var thrust:float = 0.0
var engine_on: bool = false

var _direction: Vector3 = Vector3(0, 1, 0)
var _mass: float

var _autorotate: bool
var _autorotation: Callable
var _is_rotating

var tween_autorot: Tween

@onready var ship: OrbitalObject3D = $"../../../EarthSystem/Earth/Ship"
@onready var visible_world: Node3D = $"../.."
@onready var icon: Node3D = $Icon
@onready var camera_3d: Camera3D = %Camera3D

func _ready() -> void:
	_mass = ship.mass
	create_tween()

func _process(_delta: float) -> void:
	if engine_on and thrust > 0: inertial = false
	if not inertial:
		var _ts = OrbitalManager.get_time_scale()
		#_direction = ship.get_velocity().normalized()
		var a = (ship.get_force() + basis * _direction * thrust * engine_thrust / 100) / _mass
		var v = ship.get_velocity() + a * _delta * _ts
		print(ship.get_velocity().angle_to(basis * _direction))
		var p = ship.position + v * _delta * _ts
		ship.calcule_orbit(p, v)
		if not engine_on or thrust == 0: inertial = true
	
	# Update the icon orientation and size
	icon.update(ship.get_velocity(), position, camera_3d.global_position)
	# Variation of thrust
	if Input.is_action_pressed("raise_thrust"):
		raise_thrust()
	if Input.is_action_pressed("low_thrust"):
		low_thrust()
	
	# attitude control
	var ang:float = 1
	if Input.is_action_pressed("attitude_down"):
		basis = basis.rotated(Vector3.LEFT, ang * _delta)
	if Input.is_action_pressed("attitude_up"):
		basis = basis.rotated(Vector3.LEFT, - ang * _delta)
	if Input.is_action_pressed("attitude_left"):
		basis = basis.rotated(Vector3.UP, ang * _delta)
	if Input.is_action_pressed("attitude_right"):
		basis = basis.rotated(Vector3.UP, - ang * _delta)
	if Input.is_action_pressed("attitude_rot_left"):
		basis = basis.rotated(Vector3.BACK, ang * _delta)
	if Input.is_action_pressed("attitude_rot_right"):
		basis = basis.rotated(Vector3.BACK, - ang * _delta)
	
	# attitude auto
	if _autorotate:
		var new_basis = _autorotation.call(ship.get_velocity(), ship.position)
		smooth_rotate_2(new_basis)
	else : _is_rotating = false


func _input(event: InputEvent) -> void:
	# Engine turn on or off with the same key
	if event.is_action_pressed("engine_on_off"):
		engine_on = not engine_on

func get_trajectory(segments:int) -> Array[Vector3]:
	var result = ship.get_trajectory(segments)
	for i in result.size():
		result[i] *= GameManager.view_scale
	return result

# relative thrust, varies between 0 and 100 %
func raise_thrust() -> void:
	thrust *= 1.05
	if thrust == 0: thrust = 5
	thrust = min(thrust, 100)

func low_thrust() -> void:
	thrust *= 0.95
	if thrust < 5: thrust = 0.0
	thrust = max(0.0, thrust)

func _align_basis_to(current_basis:Basis, target_direction_y: Vector3) -> Basis:
	var new_basis = current_basis
	var new_y:Vector3 = target_direction_y.normalized()
	
	new_basis.y = new_y
	new_basis.x = -new_basis.z.cross(new_y).normalized()
	new_basis.z = new_basis.x.cross(new_y)
	new_basis = new_basis.orthonormalized()
	
	return new_basis
 
func _on_ship_has_new_attractor(attractor: OrbitalObject3D) -> void:
	var new_parent = attractor.related_to
	if new_parent is Node3D:
		reparent(new_parent)


func _on_attitude_container_attitude_contorller(auto:bool, autorotation: Callable) -> void:
	_autorotate = auto
	_autorotation = autorotation

func smooth_rotate(new_basis:Basis) -> Basis:
	var rot1 = basis.y.angle_to(new_basis.y)
	if rot1 < .1:
		var rot2 = basis.x.angle_to(new_basis.x)
		if rot2 < 0.1:
			_is_rotating = false
			return new_basis
		return basis.rotated(basis.y, 0.05)
		
	var axis: Vector3
	if absf(rot1 - PI) <0.1 : axis = basis.z
	else: axis = basis.y.cross(new_basis.y).normalized()
	
	print(rot1)
	return basis.rotated(axis, 0.05)

func smooth_rotate_2(new_basis:Basis, duration: float = 1.5) -> void:
	if tween_autorot and tween_autorot.is_running():
		tween_autorot.kill()
	
	tween_autorot = create_tween()
	
	var target_qua = new_basis.get_rotation_quaternion()
	
	tween_autorot.tween_property(self, "quaternion", target_qua, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	
