extends Node3D

const REMOTE = 500

var visibles: Array
var relations:Dictionary

@onready var camera_ship_view: Camera3D = %CameraShipView

@onready var earth: OrbitalObject3D = $"../../../EarthSystem/Earth"
@onready var moon: OrbitalObject3D = $"../../../EarthSystem/Earth/Moon"
@onready var ship: OrbitalObject3D = $"../../../EarthSystem/Earth/Ship"

@onready var capsule: RigidBody3D = $".."

@onready var earth_sv: Node3D = $EarthSV
@onready var moon_sv: Node3D = $MoonSV

func _ready() -> void:
	var att:OrbitalObject3D = ship.attractor
	visibles = att.get_massive_orbiters()
	visibles.append(att)
	relations = {
		earth: earth_sv,
		moon: moon_sv
	}
	

func _process(_delta: float) -> void:
	_sort_visibles()
	var remote:float = REMOTE
	remote = minf(remote,3990)
	for i in visibles.size():
		remote = minf(remote,3990)
		remote = shrink_visible(visibles[i], relations[visibles[i]], remote)

func shrink_visible(object:OrbitalObject3D, visible_node:Node3D, remote:float) -> float:
	if not visible_node.has_method("set_radius"): return 0.0
	var rel_pos: Vector3
	if ship.attractor == object:
		rel_pos = - ship.position
	else:
		rel_pos = object.global_position - ship.global_position
	var h_rel = remote / (rel_pos.length() - object.radius)
	visible_node.set_radius(h_rel* object.radius)
	var pos = rel_pos * h_rel
	visible_node.position = pos
  
	return pos.length()


func _sort_visibles() -> void:
	if visibles.size() < 2: return
	var ship_pos = ship.global_position
	visibles.sort_custom(
		func(a: OrbitalObject3D, b: OrbitalObject3D) -> bool:
			return a.global_position.distance_squared_to(ship_pos) < \
			b.global_position.distance_squared_to(ship_pos)
	)
	
