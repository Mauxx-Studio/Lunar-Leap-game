extends HBoxContainer

signal attitude_contorller(direction: int)

var attitude_direction: int

enum direction{
	UNDEFINED,
	PROGRADE,
	RETROGRADE,
	NORMAL,
	ANTINORMAL
}

func _on_prograde_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		attitude_direction = direction.UNDEFINED
	if toggled_on:
		attitude_direction = direction.PROGRADE
	attitude_contorller.emit(attitude_direction)

func _on_retrograde_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		attitude_direction = direction.UNDEFINED
	if toggled_on:
		attitude_direction = direction.RETROGRADE
	attitude_contorller.emit(attitude_direction)

func _on_normal_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		attitude_direction = direction.UNDEFINED
	if toggled_on:
		attitude_direction = direction.NORMAL
	attitude_contorller.emit(attitude_direction)

func _on_anti_n_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		attitude_direction = direction.UNDEFINED
	if toggled_on:
		attitude_direction = direction.ANTINORMAL
	attitude_contorller.emit(attitude_direction)
