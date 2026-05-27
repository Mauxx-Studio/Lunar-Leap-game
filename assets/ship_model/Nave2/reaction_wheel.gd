extends Node

@export var torque:float = 500
@export var angular_velocity_limit:float = 0.1

@onready var capsule: RigidBody3D = $".."

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
	
	#var local_dir_xy = local_dir
	#local_dir_xy.z = 0
	#var rot_z = local_dir_xy.signed_angle_to(Vector3.UP, Vector3.BACK)
	#var local_dir_yz = local_dir
	#local_dir_yz.x = 0
	#var rot_x = local_dir_yz.signed_angle_to(Vector3.UP, Vector3.RIGHT)
	#if absf(local_dir_xy.x) > 0.05:
		#var new_torque = Vector3(0, 0, -torque*rot_z)
		#print("rot_z: ",new_torque, "  dir: ", local_dir_xy)
		#capsule.apply_torque(capsule.basis * new_torque)
	#if absf(local_dir_yz.z) > 0.05:
		#var new_torque = Vector3(torque*rot_x, 0, 0)
		#print("rot_x: ",new_torque)
		#capsule.apply_torque(capsule.basis * new_torque)
	#capsule.apply_torque(capsule.basis * new_torque)
