class_name SpaceShip

extends ShipComponent

var components:Array[ShipComponent]
var comp_positions:Array[Vector3]
var engines:Array[ShipComponent]
var ship_center_of_mass:Vector3
var ship_mass:float

func update_ship_mass() ->void:
	ship_mass = mass
	for c in components:
		ship_mass += c.mass

func get_ship_mass() -> float:
	return ship_mass

func find_components(node:Node, current:ShipComponent):
	var children = node.get_children()
	if children.size() == 0: return
	for child in children:
		if child is ShipComponent:
			components.append(child)
			current.children_components.append(child)
			child.spaceship = self
			child.parent_component = current
			find_components(child,child)
		else:
			find_components(child, current)

func get_components() -> Array[ShipComponent]:
	return components

func find_engines() -> void:
	for component in components:
		if component is ShipEngine:
			engines.append(component)

func get_engines() -> Array[ShipComponent]:
	return engines  

func get_total_thrust() -> Vector3:
	var thrust:= Vector3.ZERO
	for e in engines:
		thrust += e.applied_thrust
	return thrust
