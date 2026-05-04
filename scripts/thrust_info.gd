extends Label

@onready var ship_system: Node3D = $"../../../../EarthSystem/Earth/Ship/ShipSystem"
@onready var progress_bar: ProgressBar = $"../ProgressBar"


func _process(_delta: float) -> void:
	var str0: String = "Thrust = "
	str0 += "%.2f %%" %(ship_system.thrust)
	text = str0
	
	progress_bar.value = ship_system.thrust
