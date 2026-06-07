@tool
extends ShipComponent

const FUEL_OX_relation:float = 3.6

@export var fuel_capacity:float:
	set(v):
		oxidizer_capacity = v * FUEL_OX_relation
		fuel_capacity = v
@export var oxidizer_capacity:float

var fuel_mass
var oxidizer_mass
