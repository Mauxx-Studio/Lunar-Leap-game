extends HBoxContainer

signal attitude_contorller(auto:bool, autorotation: Callable)

var attitude_direction: int

enum direction{
	UNDEFINED,
	PROGRADE,
	RETROGRADE,
	NORMAL,
	ANTINORMAL
}

func rotate_prograde(vel: Vector3, pos: Vector3) -> Basis:
	var j = vel.normalized()
	var k = - j.cross(pos).normalized()
	var i = j.cross(k)
	return Basis(i, j, k).orthonormalized()

func rotate_retrograde(vel: Vector3, pos: Vector3) -> Basis:
	var j = - vel.normalized()
	var k = j.cross(pos).normalized()
	var i = j.cross(k)
	return Basis(i, j, k).orthonormalized()

func rotate_normal(vel: Vector3, pos: Vector3) -> Basis:
	var k = - vel.normalized()
	var j = k.cross(pos).normalized()
	var i = j.cross(k)
	return Basis(i, j, k).orthonormalized()

func rotate_anti_n(vel: Vector3, pos: Vector3) -> Basis:
	var k = vel.normalized()
	var j = k.cross(pos).normalized()
	var i = j.cross(k)
	return Basis(i, j, k).orthonormalized()

func _on_prograde_toggled(toggled_on: bool) -> void:
	attitude_contorller.emit(toggled_on, rotate_prograde)

func _on_retrograde_toggled(toggled_on: bool) -> void:
	attitude_contorller.emit(toggled_on, rotate_retrograde)

func _on_normal_toggled(toggled_on: bool) -> void:
	attitude_contorller.emit(toggled_on, rotate_normal)

func _on_anti_n_toggled(toggled_on: bool) -> void:
	attitude_contorller.emit(toggled_on, rotate_anti_n)
