extends Area3D

@export var engine_thrust:float

var inertial:bool = true
var thrust:float = 0.0
var engine_on: bool = false

var _direction: Vector3 = Vector3(0, 1, 0)
var _mass: float

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
