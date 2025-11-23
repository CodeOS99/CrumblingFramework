extends StaticBody3D

var particles := preload("res://scenes/splash_particles.tscn")

@onready var floating_label = preload("res://scenes/floating_up_label_3d.tscn")
@onready var animation_player := $MainMesh/AnimationPlayer

func interact():
	if not animation_player.speed_scale == 2:
		return
	self.remove_from_group("bug")
	var i = particles.instantiate()
	get_tree().root.add_child(i)
	i.global_position = self.global_position
	i.global_position.x -= 2.27
	i.emitting = true
	animation_player.speed_scale = 8
	
	var t = get_tree().create_timer(4)
	t.timeout.connect(func():
		$DeadMesh.visible = true
		$MainMesh.visible = false
	)
	Globals.bug_killed()
	var l = floating_label.instantiate()
	add_child(l)
	l.global_position = self.global_position
	l.text = str(Globals.killed_bugs) + " out of " + str(Globals.total_bugs)
