extends StaticBody3D

var particles := preload("res://scenes/splash_particles.tscn")

@onready var animation_player := $MainMesh/AnimationPlayer

func interact():
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
