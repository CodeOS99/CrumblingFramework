extends CharacterBody3D

@export var movement_area: MeshInstance3D
@export var movement_speed := 2.0

@onready var animation_player := $MainMesh/AnimationPlayer

var particles := preload("res://scenes/splash_particles.tscn")

var target_position: Vector3
var is_moving := false

func _ready() -> void:
	choose_new_target()

func _physics_process(delta: float) -> void:
	if is_moving and movement_area and animation_player.speed_scale == 2:
		var direction = (target_position - global_position).normalized()
		direction.y = 0
		
		if direction.length() > .01:
			var target_rotation = atan2(direction.x, direction.z)
			target_rotation -= deg_to_rad(-180)
			rotation.y = lerp_angle(rotation.y, target_rotation, 10.0*delta)
		
		velocity = direction*movement_speed
		move_and_slide()
		
		var distance_xz = Vector2(target_position.x - global_position.x, target_position.z - global_position.z).length()
		
		if distance_xz < .5:
			choose_new_target()

func choose_new_target():
	if not movement_area:
		return # idk i messed up or something
	var mesh = movement_area.mesh # BoxMesh probabl
	var box_size = mesh.size
	var area_transform = movement_area.global_transform
	
	var local_x = randf_range(-box_size.x/2, box_size.x/2)
	var local_z = randf_range(-box_size.z/2, box_size.z/2)
	
	target_position = area_transform * Vector3(local_x, 0, local_z)
	target_position.y = global_position.y
	
	is_moving = true

func interact():
	var i = particles.instantiate()
	get_tree().root.add_child(i)
	i.global_position = self.global_position
	i.global_position.x -= 2.27
	i.emitting = true
	animation_player.speed_scale = 8
	$MainMesh.rotation.z = deg_to_rad(-180)
	$MainMesh.rotation.x = 0
	$MainMesh.rotation.y = 0
	$MainMesh.position = Vector3(2.587, 0.217, -0.281)
	
	var t = get_tree().create_timer(4)
	t.timeout.connect(func():
		$DeadMesh.visible = true
		$MainMesh.visible = false
	)
