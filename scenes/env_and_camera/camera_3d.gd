extends Camera3D

@onready var camera_pivot: Node3D = $".."

@export var zoom_speed:float = 0.03
@export var rotate_speed:float = 0.002

var is_rotating:bool = false
var last_mouse_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	make_current()
	
	if not InputMap.has_action("zoom_in"):
		InputMap.add_action("zoom_in")
		var wheel_up = InputEventMouseButton.new()
		wheel_up.button_index = MOUSE_BUTTON_WHEEL_UP
		InputMap.action_add_event("zoom_in",wheel_up)
	if not InputMap.has_action("zoom_out"):
		InputMap.add_action("zoom_out")
		var wheel_up = InputEventMouseButton.new()
		wheel_up.button_index = MOUSE_BUTTON_WHEEL_DOWN
		InputMap.action_add_event("zoom_out",wheel_up)
	if not InputMap.has_action("rotate_camera"):
		InputMap.add_action("rotate_camera")
		var wheel_up = InputEventMouseButton.new()
		wheel_up.button_index = MOUSE_BUTTON_MIDDLE
		InputMap.action_add_event("rotate_camera",wheel_up)

func _input(event: InputEvent) -> void:
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
