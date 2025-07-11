extends Label

var tween: Tween

func _ready():
	tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", position.y - 10, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", position.y, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
