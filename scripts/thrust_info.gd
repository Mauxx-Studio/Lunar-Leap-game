extends Label

@onready var ship_v: Area3D = $"../../../EarthV/ShipV"

func _process(_delta: float) -> void:
	var str0: String = "Thrust = "
	str0 += "%.2f %%" %(ship_v.thrust)
	text = str0
