extends Label

@onready var ship_system: Node3D = $"../../../../EarthSystem/Earth/Ship/ShipSystem"
@onready var progress_bar: ProgressBar = $"../ProgressBar"
@onready var capsule: RigidBody3D = $"../../../Capsule"



func _process(_delta: float) -> void:
	var str0: String = "Thrust = "
	str0 += "%.2f %%" %(capsule.thrust * 100)
	text = str0
	
	progress_bar.value = capsule.thrust
