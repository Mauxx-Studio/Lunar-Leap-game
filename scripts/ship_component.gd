class_name ShipComponent

extends RigidBody3D

@export var component_name : String = "Component"

var controller: ShipController
var parent_component: ShipComponent
var children_components: Array[ShipComponent] = []
var children_engines: Array[ShipEngine] = []

var position_to_parent:Vector3

var has_children_component:bool
var has_children_engine:bool

func _ready() -> void:
	await get_tree().process_frame
	gravity_scale = 0.0
	_component_ready()

# Función virtual para que los componentes la sobreescriban
func _component_ready() -> void:
	pass

func is_connected_to_ship() -> bool:    # Devuelve true si este componente está conectado a la nave
	return get_controller() != null

func get_controller() -> ShipComponent:     # Devuelve la nave principal (el componente base)
	return controller

func get_children_components() -> Array[ShipComponent]:
	return children_components

func update_component() -> void:
	has_children_component = true if children_components.size() > 0 else false
	
	find_children_engines()
	set_position_to_parent()

func find_children_engines():
	children_engines = []
	has_children_engine = false
	for c in children_components:
		if c is ShipEngine:
			children_engines.append(c)
			has_children_engine = true

func set_position_to_parent():
	var prnt:Node = get_parent()
	position_to_parent = position
	while(prnt != parent_component):
		if prnt is Node3D:
			position_to_parent += prnt.position
		prnt = prnt.get_parent()
