extends ShipEngine

var fire_part_max_time:float = 0.3
var fire_max_radius:float = 0.32
var steam_part_max_time:float = 2
var fire_glow_max_energy:float = 1.5

@onready var fire_particles: GPUParticles3D = $Engine/engine_nozzle_center/FireParticles
@onready var steam_particles: GPUParticles3D = $Engine/engine_nozzle_center/SteamParticles
@onready var fire_glow: OmniLight3D = $Engine/engine_nozzle_center/FireGlow

func _process(_delta: float) -> void:
	if engine_on and _thrust > 0:
		set_intensity(_thrust)
	else:
		set_intensity(0.0)

func set_intensity(i:float) -> void:
	if i == 0.0:
		fire_particles.emitting = false
		steam_particles.emitting = false
		fire_glow.visible = false
		return
	fire_particles.emitting = true
	steam_particles.emitting = true
	fire_glow.visible = true
	fire_particles.lifetime = i * fire_part_max_time
	fire_particles.amount_ratio = 0.5 * i + 0.5
	fire_particles.process_material.emission_sphere_radius = i * fire_max_radius
	steam_particles.amount_ratio = i + 0.05
	fire_glow.light_energy = i * fire_glow_max_energy
