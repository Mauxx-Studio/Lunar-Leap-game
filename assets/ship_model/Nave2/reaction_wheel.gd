extends Node

@export var torque:float = 1000
@export var angular_velocity_limit:float = 0.1

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

func stabilize_by_axis(omg:float, axis:Vector3):
	var cap_basis:Basis = capsule.basis
	var rel_torque:Vector3 = cap_basis * axis * (-sign(omg))
	capsule.apply_torque(rel_torque * torque)

func rotate_by_axis(rot:float, omg:float, axis:Vector3) -> void:
	var cap_basis:Basis = capsule.basis
	if sign(rot * omg) > 0:
		if absf(omg) > angular_velocity_limit and absf(rot) > absf(5*omg): return
	var torque_axis:Vector3
	if absf(rot) > 0.5:
		torque_axis = cap_basis * axis * sign(rot)
	else:
		torque_axis = cap_basis * axis * minf(1,(rot - 5 * omg))
	capsule.apply_torque(torque_axis * torque)
