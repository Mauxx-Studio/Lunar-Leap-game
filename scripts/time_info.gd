extends VBoxContainer

@onready var time_t: Label = $Time
@onready var time_scale: Label = $HBoxContainer/TimeScale

func _process(_delta: float) -> void:
	var time: float = OrbitalManager.get_current_time()
	
	var time_s = str(int(fmod(time, 60))).pad_zeros(2) + " s"
	if time >= 60:
		var time_m = str(int(fmod(time/60, 60))).pad_zeros(2)
		time_s = time_m + ":" +time_s
	if time >= 3600:
		var time_h = str(int(fmod(time/3600, 24))).pad_zeros(2)
		time_s = time_h + ":" +time_s
	if time >= 86400:
		var time_d = str(int(time/86400))
		time_s = time_d + " d- " +time_s
	
	var str1 = "Time :  " + time_s
	
	time_t.text = str1
	
	var str2 = "Time scale : %.0f" % OrbitalManager.get_time_scale()
	
	time_scale.text = str2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("raise_time_scale"):
		OrbitalManager.set_time_scale(OrbitalManager.get_time_scale() * 2, not GameManager.get_is_inertial())
	if event.is_action_pressed("low_time_scale"):
		var t_s = OrbitalManager.get_time_scale() / 2
		t_s = max(1.0, t_s)
		OrbitalManager.set_time_scale(t_s)

func _on_ts_low_button_down() -> void:
	var t_s = OrbitalManager.get_time_scale() / 2
	t_s = maxf(t_s, 1)
	OrbitalManager.set_time_scale(t_s)

func _on_ts_raise_button_down() -> void:
	OrbitalManager.set_time_scale(OrbitalManager.get_time_scale() * 2)
