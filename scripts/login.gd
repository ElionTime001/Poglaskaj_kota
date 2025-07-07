extends "res://scripts/window_scirpt.gd"

@export var checkmark: TextureRect

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_mission():
	return appear_and_scale(checkmark)
		
			
func appear_and_scale(my_panel):
	my_panel.scale = Vector2(1.5, 1.5)  # 150% size
	my_panel.modulate.a = 0.0  # fully transparent

	var tween = create_tween()
	tween.tween_property(my_panel, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(my_panel, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	return tween
