extends Label

@onready var ship_v: Area3D = $"../../../EarthV/ShipV"
@onready var progress_bar: ProgressBar = $"../ProgressBar"


func _process(_delta: float) -> void:
	var str0: String = "Thrust = "
	str0 += "%.2f %%" %(ship_v.thrust)
	text = str0
	
	progress_bar.value = ship_v.thrust
