extends Node3D

const REMOTE = 1000

@onready var camera_ship_view: Camera3D = %CameraShipView

@onready var ship: OrbitalObject3D = $"../../EarthSystem/Earth/Ship"
@onready var earth: OrbitalObject3D = $"../../EarthSystem/Earth"
@onready var moon: OrbitalObject3D = $"../../EarthSystem/Earth/Moon"

@onready var earth_sv: Node3D = $EarthSV
@onready var moon_sv: Node3D = $MoonSV

func _process(_delta: float) -> void:
	shrink_visible(earth, earth_sv)
	shrink_visible(moon, moon_sv)


func shrink_visible(object:OrbitalObject3D, visible:Node3D):
	if not visible.has_method("set_radius"): return
	var rel_pos: Vector3
	if ship.attractor == object:
		rel_pos = - ship.position
	else:
		rel_pos = object.global_position - ship.global_position
	var h_rel = REMOTE / (rel_pos.length() - object.radius)
	visible.set_radius(h_rel* object.radius)
	var pos = rel_pos * h_rel
	visible.position = pos
