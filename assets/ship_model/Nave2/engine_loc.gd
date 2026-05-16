extends Node3D

@export var vectorial_angle:float = 15

var aux_axis:Vector3

@onready var engine: Node3D = $Engine

func _ready() -> void:
	aux_axis = position
	aux_axis.y = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attitude_down"):
		engine.rotation.x = deg_to_rad(vectorial_angle)
	if event.is_action_pressed("attitude_up"):
		engine.rotation.x = - deg_to_rad(vectorial_angle)
	if event.is_action_released("attitude_up") or event.is_action_released("attitude_down"):
		engine.rotation.x = 0.0
	
	if event.is_action_pressed("attitude_right"):
		engine.rotation.z = deg_to_rad(vectorial_angle)
	if event.is_action_pressed("attitude_left"):
		engine.rotation.z = - deg_to_rad(vectorial_angle)
	if event.is_action_released("attitude_left") or event.is_action_released("attitude_right"):
		engine.rotation.z = 0.0
	
	if event.is_action_pressed("attitude_rot_right"):
		engine.rotate(aux_axis, -deg_to_rad(vectorial_angle))
	if event.is_action_pressed("attitude_rot_left"):
		engine.rotate(aux_axis, deg_to_rad(vectorial_angle))
	if event.is_action_released("attitude_rot_right") or event.is_action_released("attitude_rot_left"):
		engine.rotation = Vector3.ZERO
	
