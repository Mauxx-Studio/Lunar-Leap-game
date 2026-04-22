
extends Node3D

@onready var earth: OrbitalObject3D = $"../EarthSystem/Earth"
@onready var moon: OrbitalObject3D = $"../EarthSystem/Earth/Moon"
@onready var ship: OrbitalObject3D = $"../EarthSystem/Earth/Ship"

@onready var earth_v: Node3D = $EarthV
@onready var moon_v: Node3D = $EarthV/MoonV
@onready var ship_v: Node3D = $EarthV/ShipV

@onready var directional_light_3d: DirectionalLight3D = $Node3D/DirectionalLight3D

@export var v_scale: float = 0.000001

var center_body: Node3D
var center_position: Vector3

func _ready() -> void:
	earth_v.set_radius(earth.radius * v_scale)
	moon_v.set_radius(moon.radius * v_scale)
	center_body = earth

func _process(_delta: float) -> void:
	center_position = center_position.lerp(center_body.position, _delta * 4)
	earth_v.position = (earth.position - center_position) * v_scale
	moon_v.position = moon.position * v_scale
	ship_v.position = ship.position * v_scale

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("raise_time_scale"):
		OrbitalManager.set_time_scale(OrbitalManager.get_time_scale() * 2)
	if event.is_action_pressed("low_time_scale"):
		var t_s = OrbitalManager.get_time_scale() / 2
		t_s = max(1.0, t_s)
		OrbitalManager.set_time_scale(t_s)

# Cambio de centro de camara a la Luna
func _on_moon_v_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			center_body = moon

# Cambio de centro de camara a la Tierra
func _on_earth_v_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			center_body = earth
