extends Label

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
		time_s = time_d + " - " +time_s
	
	var str1 = "Time :  " + time_s
	
	var str2 = "Time scale : %.0f" % OrbitalManager.get_time_scale()
	
	text = str1 + "\n" + str2
