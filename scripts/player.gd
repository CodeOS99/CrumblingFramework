class_name Player extends CharacterBody3D

var speed
const WALK_SPEED := 5.0
const SPRINT_SPEED := 8.0
const JUMP_VELOCITY := 15
const SENSITIVITY := 0.004

# bobbing
const BOB_FREQ := 2.4
const BOB_AMP := 0.08
var t_bob = 0.0

# fov
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var gravity = 20

var can_interact := false
var interact_body: Node3D

var curr_ray_coll: Node3D

@onready var head := $Head
@onready var camera := $Head/Camera3D
@onready var raycast := $Head/Camera3D/RayCast3D
@onready var interact_label := $CanvasLayer/HUD/InteractLabel

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Globals.player = self

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity*delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	var v_clamp = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * v_clamp
	camera.fov = lerp(camera.fov, target_fov, delta*8.0)
	
	move_and_slide()

func _process(delta: float) -> void:
	can_interact = false
	if raycast.is_colliding():
		curr_ray_coll = raycast.get_collider()
		if curr_ray_coll.is_in_group("bug"):
			can_interact = true
			interact_body = curr_ray_coll
		elif curr_ray_coll.is_in_group("glitch"):
			can_interact = true
			interact_body = curr_ray_coll
	
	interact_label.visible = can_interact
	
	if can_interact and Input.is_action_pressed("interact"):
		interact_body.interact()

func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ/2) * BOB_AMP
	return pos
