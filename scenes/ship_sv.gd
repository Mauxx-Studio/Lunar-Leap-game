extends Node3D

@onready var ship_system: Node3D = $"../../../EarthSystem/Earth/Ship/ShipSystem"

func _process(_delta: float) -> void:
	basis = ship_system.basis
