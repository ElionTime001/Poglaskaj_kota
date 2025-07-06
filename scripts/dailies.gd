extends "res://scripts/window_scirpt.gd"

@export var quest_finished_1: TextureRect
@export var quest_finished_2: TextureRect
@export var quest_finished_3: TextureRect

var checkmarks = []

func _ready():
	#await get_tree().create_timer(1).timeout
	#appear_and_scale(quest_finished_1)
	checkmarks = [quest_finished_1,quest_finished_2,quest_finished_3]

func _process(delta):
	pass

func check_mission(checkmark_name: String):
	for check in checkmarks:
		if check.name == checkmark_name:
			appear_and_scale(check)
			break

func appear_and_scale(my_panel):
	my_panel.scale = Vector2(1.5, 1.5)  # 150% size
	my_panel.modulate.a = 0.0  # fully transparent

	var tween = create_tween()
	tween.tween_property(my_panel, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(my_panel, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
