extends Area3D

@export var engine_thrust:float

var inertial:bool = true
var thrust:float = 0.0
var engine_on: bool = false

var _direction: Vector3 = Vector3(1, 0, 0)
var _mass: float

@onready var ship: OrbitalObject3D = $"../../../EarthSystem/Earth/Ship"
@onready var visible_world: Node3D = $"../.."
@onready var icon: Node3D = $Icon
@onready var camera_3d: Camera3D = %Camera3D

func _ready() -> void:
	_mass = ship.mass

func _process(_delta: float) -> void:
	if engine_on and thrust > 0: inertial = false
	if not inertial:
		var _ts = OrbitalManager.get_time_scale()
		_direction = ship.get_velocity().normalized()
		var a = (ship.get_force() + _direction * thrust * engine_thrust / 100) / _mass
		var v = ship.get_velocity() + a * _delta * _ts
		var p = ship.position + v * _delta * _ts
		ship.calcule_orbit(p, v)
		if not engine_on or thrust == 0: inertial = true
	
	# Update the icon orientation and size
	icon.update(ship.get_velocity(), position, camera_3d.global_position)
	# Variation of thrust
	if Input.is_action_pressed("raise_thrust"):
		raise_thrust()
		print(thrust)
	if Input.is_action_pressed("low_thrust"):
		low_thrust()
		print(thrust)

func _input(event: InputEvent) -> void:
	# Engine turn on or off with the same key
	if event.is_action_pressed("engine_on_off"):
		engine_on = not engine_on

func get_trajectory(segments:int) -> Array[Vector3]:
	var result = ship.get_trajectory(segments)
	for i in result.size():
		result[i] *= visible_world.v_scale
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
 
func _on_ship_has_new_attractor(attractor: OrbitalObject3D) -> void:
	var new_parent = attractor.related_to
	if new_parent is Node3D:
		reparent(new_parent)
