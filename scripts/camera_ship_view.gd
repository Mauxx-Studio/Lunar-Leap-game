extends Camera3D

@export var zoom_speed:float = 0.03
@export var rotate_speed:float = 0.002

var is_rotating:bool = false
var last_mouse_pos: Vector2 = Vector2.ZERO

@onready var camera_pivot: Node3D = $".."
@onready var capsule: RigidBody3D = $"../../Capsule"

func _process(_delta: float) -> void:
	camera_pivot.position = capsule.position

func _input(event: InputEvent) -> void:
	if not GameManager.current_cam == self: return
	if event.is_action_pressed("rotate_camera"):
		is_rotating = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_released("rotate_camera"):
		is_rotating = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if is_rotating and event is InputEventMouseMotion:
		var mouse_delta: Vector2 = -event.relative
		camera_pivot.rotate_y(mouse_delta.x * rotate_speed)
		camera_pivot.rotate_object_local(Vector3.RIGHT, mouse_delta.y * rotate_speed)
	
	if event.is_action_pressed("zoom_in",true):
		position.z *= (1 - zoom_speed)
	if event.is_action_pressed("zoom_out",true):
		position.z *= (1 + zoom_speed)
