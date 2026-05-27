extends VBoxContainer

## Decuelve una funcion aoutorotation(velocity, position) -> Basis. esta genera una basis con el eje Y alineado con la direccion pedida y el eje X con el plano de la orbita
signal attitude_contorller(auto:bool, autorotation: Callable)
signal direction_controller(auto:bool, auto_direction: Callable)

var attitude_direction: int

enum direction{
	UNDEFINED,
	PROGRADE,
	RETROGRADE,
	NORMAL,
	ANTINORMAL
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("raise_time_scale"):
		if OrbitalManager.get_time_scale() > 16:
			var buttons = get_children()
			for i in buttons.size():
				buttons[i].button_pressed = false

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

func rotate_radial_in(vel:Vector3, pos:Vector3) -> Basis:
	var i = vel.normalized()
	var k = - i.cross(pos).normalized()
	var j = k.cross(i)
	return Basis(i, j, k).orthonormalized()

func rotate_radial_out(vel:Vector3, pos:Vector3) -> Basis:
	var i = -vel.normalized()
	var k = i.cross(pos).normalized()
	var j = k.cross(i)
	return Basis(i, j, k).orthonormalized()

func direcion_prograde(vel:Vector3, _pos:Vector3) -> Vector3:
	return vel.normalized()

func direcion_retrograde(vel:Vector3, _pos:Vector3) -> Vector3:
	return - vel.normalized()

func direcion_normal(vel:Vector3, pos:Vector3) -> Vector3:
	return pos.cross(vel).normalized()

func direcion_antinormal(vel:Vector3, pos:Vector3) -> Vector3:
	return - pos.cross(vel).normalized()

func direcion_radial_out(vel:Vector3, pos:Vector3) -> Vector3:
	return vel.cross(direcion_normal(vel,pos)).normalized()

func direcion_radial_in(vel:Vector3, pos:Vector3) -> Vector3:
	return - vel.cross(direcion_normal(vel,pos)).normalized()


func _on_prograde_toggled(toggled_on: bool) -> void:
	attitude_contorller.emit(toggled_on, rotate_prograde)
	direction_controller.emit(toggled_on, direcion_prograde)

func _on_retrograde_toggled(toggled_on: bool) -> void:
	attitude_contorller.emit(toggled_on, rotate_retrograde)
	direction_controller.emit(toggled_on, direcion_retrograde)

func _on_normal_toggled(toggled_on: bool) -> void:
	attitude_contorller.emit(toggled_on, rotate_normal)
	direction_controller.emit(toggled_on, direcion_normal)

func _on_anti_n_toggled(toggled_on: bool) -> void:
	attitude_contorller.emit(toggled_on, rotate_anti_n)
	direction_controller.emit(toggled_on, direcion_antinormal)

func _on_radial_in_toggled(toggled_on: bool) -> void:
	attitude_contorller.emit(toggled_on, rotate_radial_in)
	direction_controller.emit(toggled_on, direcion_radial_in)

func _on_radial_out_toggled(toggled_on: bool) -> void:
	attitude_contorller.emit(toggled_on, rotate_radial_out)
	direction_controller.emit(toggled_on, direcion_radial_out)
