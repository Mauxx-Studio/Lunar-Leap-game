class_name ShipComponent

extends RigidBody3D

@export var component_name : String = "Component"
@export var is_base_component : bool = false        # ← Marca la nave/capsula como base

var spaceship: SpaceShip
var parent_component: ShipComponent
var children_components: Array[ShipComponent] = []

func _ready() -> void:
	await get_tree().process_frame
	gravity_scale = 0.0
	_component_ready()

# Busca el primer ShipComponent hacia arriba en la jerarquía
func _find_parent_component() -> ShipComponent:
	if is_base_component:
		return null
	
	var current = get_parent()
	var count:int = 0
	
	while current != null and count < 30:
		if current is ShipComponent:
			current.children_components.append(self)
			return current
		current = current.get_parent()
		count += 1
	
	if parent_component == null and not is_base_component:    # Si no encontró ningún ShipComponent
		push_warning("%s no encontró ningún ShipComponent padre" % name)
	return null


# Función virtual para que los componentes la sobreescriban
func _component_ready() -> void:
	pass

func get_ship() -> ShipComponent:     # Devuelve la nave principal (el componente base)
	if is_base_component:
		return self
	if parent_component:
		return parent_component.get_ship()
	return null

func is_connected_to_ship() -> bool:    # Devuelve true si este componente está conectado a la nave
	return get_ship() != null
	
