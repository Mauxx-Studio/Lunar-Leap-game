extends Node

const LIMIT_SCALE_TIME = 8

var view_scale: float = 0.000001

var current_cam: Node

var _is_inertial: bool = true

func set_inertial(v:bool):
	if not v: OrbitalManager.limit_time_scale()
	_is_inertial = v

func get_is_inertial() -> bool:
	return _is_inertial
