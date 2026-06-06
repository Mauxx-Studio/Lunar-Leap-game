extends Node

@export var torque:float = 1000
@export var angular_velocity_limit:float = 0.1

var direction_func:Callable
var _auto: bool = false

@onready var capsule: RigidBody3D = $".."
@onready var ship: OrbitalObject3D = $"../../../../EarthSystem/Earth/Ship"

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("attitude_down"):
		capsule.set_autorotate(false)
		capsule.apply_torque(capsule.basis * Vector3(torque, 0, 0))
	if Input.is_action_pressed("attitude_up"):
		capsule.set_autorotate(false)
		capsule.apply_torque(capsule.basis * Vector3(-torque, 0, 0))
	if Input.is_action_pressed("attitude_right"):
		capsule.set_autorotate(false)
		capsule.apply_torque(capsule.basis * Vector3(0, 0, torque))
	if Input.is_action_pressed("attitude_left"):
		capsule.set_autorotate(false)
		capsule.apply_torque(capsule.basis * Vector3(0, 0, -torque))
	if Input.is_action_pressed("attitude_rot_right"):
		capsule.set_autorotate(false)
		capsule.apply_torque(capsule.basis * Vector3(0, torque, 0))
	if Input.is_action_pressed("attitude_rot_left"):
		capsule.set_autorotate(false)
		capsule.apply_torque(capsule.basis * Vector3(0, -torque, 0))

func rotate_ship_to(direction:Vector3) -> void:
	var local_dir = capsule.basis.inverse() * direction
	var angl = Vector3.UP.angle_to(local_dir)
	var rot = Vector3.UP.cross(local_dir)
	print("rot: ", rot, "  ang: ", rad_to_deg(angl))
	if capsule.angular_velocity.length() < angular_velocity_limit:
		capsule.apply_torque(rot * torque)
		print("aplicado torque")

func start_rotation(direcion_sp: Callable):
	direction_func = direcion_sp
	_auto = true

func kill_rotation():
	_auto = false

func stabilize_by_axis(omg:float, axis:Vector3):
	var cap_basis:Basis = capsule.basis
	capsule.apply_torque(cap_basis * axis * (-sign(omg)) * torque)

func rotate_by_axis(rot:float, omg:float, axis:Vector3) -> void:
	var cap_basis:Basis = capsule.basis
	if sign(rot * omg) > 0:
		if absf(omg) > angular_velocity_limit and absf(rot) > absf(5*omg): return
	var torque_axis:float
	if absf(rot) > 0.5:
		torque_axis = sign(rot) * torque
	else:
		torque_axis = minf(1,(rot - 5 * omg)) * torque
	capsule.apply_torque(cap_basis * axis * torque_axis)
