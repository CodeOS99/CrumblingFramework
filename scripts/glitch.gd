extends StaticBody3D
var floating_label = preload("res://scenes/floating_up_label_3d.tscn")

func _ready() -> void:
	Globals.total_glitches += 1

func interact():
	# I tried to make the glitches disappear slowly when removed but i sort of messed something up so...
	Globals.removed_glitch()
	var l = floating_label.instantiate()
	l.global_position = global_position
	l.text_to_display = "Glitch removed!\n" + str(Globals.removed_glitches) + " out of " + str(Globals.total_glitches)
	get_tree().root.add_child(l)

	queue_free()
