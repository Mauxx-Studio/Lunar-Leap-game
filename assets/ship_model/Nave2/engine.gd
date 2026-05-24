extends ShipComponent

@export var engine_thrust:float = 0
@export var engine_on:bool = false
@export var _thrust:float = 0
@onready var engine_nozzle_center: Node3D = $Engine/engine_nozzle_center

func _physics_process(_delta: float) -> void:
	if engine_on:
		apply_force(global_basis * Vector3(0,_thrust * engine_thrust,0), engine_nozzle_center.position)

func set_engine_on(on:bool):
	engine_on = on

func set_thrust(t:float):
	_thrust = t
