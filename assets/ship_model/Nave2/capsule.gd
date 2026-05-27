extends SpaceShip

@export var thrust_change_rate: float = 2.0

var inertial:bool
var engine_on: bool
var thrust:float

var _autorotate: bool
var _autorotation: Callable
var _autodirection: Callable

@onready var ship: OrbitalObject3D = $"../../EarthSystem/Earth/Ship"
@onready var ship_view: Node3D = $ShipView
@onready var reaction_wheel: Node = $ReactionWheel

func _ready() -> void:
	find_components(self,self)
	find_engines()
	update_ship_mass()
	ship.mass = get_ship_mass()

func _physics_process(_delta: float) -> void:
	if not inertial:
		OrbitalManager.set_time_scale(1)
		if not engine_on or thrust == 0:
			inertial = true
			GameManager.set_inertial(true)
		var a = (get_total_thrust() + ship.get_force()) / ship_mass
		var v = ship.get_velocity() + a * _delta
		var p = ship.position + v * _delta
		ship.calcule_orbit(p,v)
	if inertial:
		if engine_on and thrust > 0:
			GameManager.set_inertial(false)
			inertial = false
			linear_velocity = Vector3.ZERO
			position= Vector3.ZERO
	if _autorotate:
		var dir = _autodirection.call(ship.get_velocity(), ship.position)
		reaction_wheel.rotate_ship_to(dir)

func _process(_delta: float) -> void:
	ship_view.basis = basis.inverse()
	
		# Variation of thrust
	if Input.is_action_pressed("raise_thrust"):
		raise_thrust(_delta)
		set_engines_thrust(thrust)
	if Input.is_action_pressed("low_thrust"):
		low_thrust(_delta)
		set_engines_thrust(thrust)

func set_engines_thrust(t:float) -> void:
	if engines.size() == 0: return
	for i in engines.size():
		engines[i].set_thrust(t)

func set_engines_on(on:bool) -> void:
	if engines.size() == 0: return
	for i in engines.size():
		engines[i].set_engine_on(on)

func _input(event: InputEvent) -> void:
	# Engine turn on or off with the same key
	if event.is_action_pressed("engine_on_off"):
		engine_on = not engine_on
		set_engines_on(engine_on)

# relative thrust, varies between 0 and 100 %
func raise_thrust(delta:float) -> void:
	var change = delta * thrust_change_rate
	thrust *= 1 + change
	if thrust == 0: thrust = change * .1
	thrust = min(thrust, 1)

func low_thrust(delta:float) -> void:
	var change = delta * thrust_change_rate
	thrust *= 1 - change
	if thrust < change * .1: thrust = 0.0
	thrust = max(0.0, thrust)

func set_autorotate(on:bool)-> void:
	_autorotate = on

func get_autorotate() -> bool:
	return _autorotate


func _on_attitude_container_attitude_contorller(auto: bool, autorotation: Callable) -> void:
	_autorotate = auto
	_autorotation = autorotation

func _on_attitude_container_direction_controller(auto: bool, auto_direction: Callable) -> void:
	_autorotate = auto
	_autodirection = auto_direction
