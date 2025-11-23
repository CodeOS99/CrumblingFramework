extends Area3D

func _on_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
	if body.is_in_group("player"):
		body.global_position = Vector3(6.45, 7.613, -0.179)
