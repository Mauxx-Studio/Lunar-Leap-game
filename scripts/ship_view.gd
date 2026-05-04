extends Node3D

const REMOTE = 300

@onready var ship: OrbitalObject3D = $"../../EarthSystem/Earth/Ship"
@onready var earth: OrbitalObject3D = $"../../EarthSystem/Earth"
@onready var moon: OrbitalObject3D = $"../../EarthSystem/Earth/Moon"

@onready var earth_sv: Node3D = $EarthSV
@onready var moon_sv: Node3D = $MoonSV

func _process(_delta: float) -> void:
	var earth_relative_pos = earth.global_position - ship.global_position
	earth_sv.position = earth_relative_pos.normalized() * REMOTE
	var rad = earth.radius * REMOTE / earth_relative_pos.length()
	earth_sv.set_radius(rad)
	
	var moon_realtive_pos = moon.global_position - ship.global_position
	moon_sv.position = moon_realtive_pos.normalized() * REMOTE
	var moon_rad = moon.radius * REMOTE / moon_realtive_pos.length()
	moon_sv.set_radius(moon_rad)
