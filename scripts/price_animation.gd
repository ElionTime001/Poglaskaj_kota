extends Panel

var original_scale := Vector2.ONE

func _ready():
	await get_tree().process_frame

	# Set pivot to center
	pivot_offset = size * 0.5

	animate_panel()

func animate_panel():
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
