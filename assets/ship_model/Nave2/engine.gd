extends ShipEngine

@export var engine_thrust:float = 0
@export var engine_on:bool = false
@export var _thrust:float = 0

var applied_thrust:Vector3 = Vector3.ZERO

@onready var engine_nozzle_center: Node3D = $Engine/engine_nozzle_center


func _physics_process(_delta: float) -> void:
	if engine_on and _thrust > 0.0:
		var force:Vector3 = global_basis * Vector3(0,_thrust * engine_thrust,0)
		apply_force(force)
		applied_thrust = force
	else:
		applied_thrust = Vector3.ZERO

func set_engine_on(on:bool):
	engine_on = on

func set_thrust(t:float):
	_thrust = t
