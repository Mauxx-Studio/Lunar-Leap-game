extends Node

@onready var camera_map_view: Camera3D = %CameraMapView
@onready var camera_ship_view: Camera3D = %CameraShipView
@onready var map_view: Node3D = $MapView
@onready var ship_view: Node3D = $ShipView

func _ready() -> void:
	map_view.show()
	ship_view.hide()
	camera_map_view.make_current()
	GameManager.current_cam = camera_map_view

func _on_change_view_button_down() -> void:
	if GameManager.current_cam == camera_ship_view:
		ship_view.hide()
		map_view.show()
		camera_ship_view.clear_current()
		camera_map_view.make_current()
		GameManager.current_cam = camera_map_view
	else:
		map_view.hide()
		ship_view.show()
		camera_map_view.clear_current()
		camera_ship_view.make_current()
		GameManager.current_cam = camera_ship_view
