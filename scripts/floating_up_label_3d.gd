extends Label3D

func _ready() -> void:
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", self.global_position + Vector3(0, 3, 0), 1.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	t.tween_interval(.15)
	t.tween_property(self, "modulate", Color(1, 1, 1, 0), .35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	t.finished.connect(func():
		self.queue_free())
