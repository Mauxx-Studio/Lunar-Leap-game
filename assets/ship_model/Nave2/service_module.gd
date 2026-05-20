extends ShipComponent

func find_engines() -> Array:
	var engines: Array
	var children = find_children("*")
	for i in children.size():
		if children[i].has_method("engine_on"):
			engines.append(children[i])
	return engines
