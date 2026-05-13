extends MeshInstance3D

@export var deploy_speed:float= 1

@onready var solar_panel_1: MeshInstance3D = $panel_holder_hinge/solar_panel_1
@onready var solar_panel_2: MeshInstance3D = $panel_holder_hinge/solar_panel_1/solar_panel_1_hinge/solar_panel_2
@onready var solar_panel_3: MeshInstance3D = $panel_holder_hinge/solar_panel_1/solar_panel_1_hinge/solar_panel_2/solar_panel_1_hinge_001/solar_panel_3
@onready var solar_panel_4: MeshInstance3D = $panel_holder_hinge/solar_panel_1/solar_panel_1_hinge/solar_panel_2/solar_panel_1_hinge_001/solar_panel_3/solar_panel_3_hinge/solar_panel_4
@onready var solar_panel_5: MeshInstance3D = $panel_holder_hinge/solar_panel_1/solar_panel_1_hinge/solar_panel_2/solar_panel_1_hinge_001/solar_panel_3/solar_panel_3_hinge/solar_panel_4/solar_panel_4_hinge_001/solar_panel_5
@onready var solar_panel_6: MeshInstance3D = $panel_holder_hinge/solar_panel_1/solar_panel_1_hinge/solar_panel_2/solar_panel_2_hinge/solar_panel_3/solar_panel_3_hinge/solar_panel_4/solar_panel_4_hinge/solar_panel_5/solar_panel_5_hinge/solar_panel_6
@onready var solar_panel_7: MeshInstance3D = $panel_holder_hinge/solar_panel_1/solar_panel_1_hinge/solar_panel_2/solar_panel_2_hinge/solar_panel_3/solar_panel_3_hinge/solar_panel_4/solar_panel_4_hinge/solar_panel_5/solar_panel_5_hinge/solar_panel_6/solar_panel_6_hinge/solar_panel_7
@onready var solar_panel_8: MeshInstance3D = $panel_holder_hinge/solar_panel_1/solar_panel_1_hinge/solar_panel_2/solar_panel_2_hinge/solar_panel_3/solar_panel_3_hinge/solar_panel_4/solar_panel_4_hinge/solar_panel_5/solar_panel_5_hinge/solar_panel_6/solar_panel_6_hinge/solar_panel_7/solar_panel_7_hinge/solar_panel_8

func _process(delta: float) -> void:
	pass

func deploy_panel(_delta:float, panel:Node3D) -> bool:
	if panel.rotation.y == 0: return false
	else:
		var rot = - _delta * sign(panel.rotation.y)
		if absf(rot) < _delta:
			panel.rotation.y = 0
			return false
		else:
			panel.rotate_y(rot)
			return true

func retract_odd_panel(_delta, panel: Node3D) -> bool:
	if panel.rotation.y == PI: return false
	else:
		var rot = - _delta * sign(panel.rotation.y)
		if abs(rot) < _delta:
			panel.rotation.y = PI
			return false
		else:
			panel.rotate_y(rot)
			return true
	
