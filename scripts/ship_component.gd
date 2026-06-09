class_name ShipComponent

extends RigidBody3D

@export var component_name : String = "Component"

var controller: ShipController
var parent_component: ShipComponent
var children_components: Array[ShipComponent] = []

func _ready() -> void:
	await get_tree().process_frame
	gravity_scale = 0.0
	_component_ready()

# Función virtual para que los componentes la sobreescriban
func _component_ready() -> void:
	pass

func get_controller() -> ShipComponent:     # Devuelve la nave principal (el componente base)
	return controller

func is_connected_to_ship() -> bool:    # Devuelve true si este componente está conectado a la nave
	return get_controller() != null
	
