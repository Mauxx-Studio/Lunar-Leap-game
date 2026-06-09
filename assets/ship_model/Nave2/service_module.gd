@tool
extends ShipComponent

const FUEL_OX_relation:float = 3.6

@export var fuel_capacity:float:
	set(v):
		oxidizer_capacity = v * FUEL_OX_relation
		fuel_capacity = v
@export var oxidizer_capacity:float

var fuel_mass:float
var oxidizer_mass:float

func _ready() -> void:
	fuel_mass = fuel_capacity
	oxidizer_mass = oxidizer_capacity
