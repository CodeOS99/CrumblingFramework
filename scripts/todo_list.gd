extends Label

const INIT_T = .3
var t = INIT_T

func _process(delta: float) -> void:
	t -= delta
	if t<= 0:
		if text[-1] == "█":
			text = text.replace(" █", "")
		else:
			text += " █"
		
		t= INIT_T
