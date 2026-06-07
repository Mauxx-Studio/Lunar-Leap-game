extends VBoxContainer


@onready var capsule: RigidBody3D = $"../../ShipView/Capsule"

@onready var thrust_info: Label = $ThrustInfo
@onready var thrust_progress_bar: ProgressBar = $ThrustProgressBar
@onready var engine_on: Label = $EngineOn

func _process(_delta: float) -> void:
	var str0: String = "Thrust = "
	str0 += "%.2f %%" %(capsule.thrust * 100)
	thrust_info.text = str0
	
	thrust_progress_bar.value = capsule.thrust
	
	if capsule.engine_on:
		engine_on.text = "Engine ON"
	else:
		engine_on.text = "Engine OFF"
