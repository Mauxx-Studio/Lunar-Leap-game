extends Node3D

const SOLAR_PANEL_MODULE = preload("uid://gw2q58di15wr")
@onready var panel_holder_hinge: Node3D = $solar_panel_hole1/solar_panel_holder/panel_holder_hinge
@onready var solar_panel_holder: MeshInstance3D = $solar_panel_hole1/solar_panel_holder
@onready var sun_directional_light_3d: DirectionalLight3D = $"../../../../../../Sun_inclination/SunDirectionalLight3D"

var panels: Array[MeshInstance3D]
var deployed:bool = true

func _ready() -> void:
	for i in 10:
		add_panels()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("deploy_panels"):
		if not deployed: deploy()
	if event.is_action_pressed("retract_panels"):
		if deployed: retract()

func _process(_delta: float) -> void:
	if deployed: rotate_to_sun()
	else: rotate_to_0()

func rotate_to_sun():
	var sun_dir = global_basis.inverse() * (sun_directional_light_3d.global_basis * Vector3.FORWARD)
	sun_dir.x = 0
	var panel_dir = solar_panel_holder.basis * Vector3.FORWARD
	var rot = sun_dir.angle_to(panel_dir)
	if rot < 0.02: return
	if sun_dir.cross(panel_dir).x > 0: rot = -rot
	rot += solar_panel_holder.rotation.x
	var tween = create_tween()
	tween.tween_property(solar_panel_holder,"rotation:x", rot, 2.0)

func rotate_to_0():
	var tween = create_tween()
	tween.tween_property(solar_panel_holder,"rotation:x", 0.0, 2.0)

func add_panels() -> void:
	var index:int = panels.size()
	panels.append(SOLAR_PANEL_MODULE.instantiate())
	if index == 0:
		panel_holder_hinge.add_child(panels[0])
	else:
		panels[index].rotate_x(PI)
		panels[index - 1].get_hinge().add_child(panels[index])
	return

func retract() -> void:
	deployed = false
	var tween = create_tween()
	tween.set_parallel(true)
	for i in panels.size():
		var target_rotation_y = -PI
		if i == 0: target_rotation_y /= -2
		tween.tween_property(panels[i],"rotation:y",target_rotation_y, 3.0)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property(panels[0], "rotation:y", 0.0, 1.5)
	await tween2.finished
	var tween3 = create_tween()
	tween3.tween_property(solar_panel_holder,"position:x", -0.35, 2.0)
	return

func deploy() -> void:
	var tween0 = create_tween()
	tween0.tween_property(solar_panel_holder, "position:x", 0.0, 1.5)
	await tween0.finished
	var tween = create_tween()
	tween.tween_property(panels[0],"rotation:y", PI/2, 1.5)
	await tween.finished
	var tween2 = create_tween()
	tween2.set_parallel()
	for i in panels.size():
		tween2.tween_property(panels[i],"rotation:y", 0.0, 3.0)
	await tween2.finished
	deployed = true
	return

func is_deployed() -> bool:
	return deployed
