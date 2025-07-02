extends Control

var quest_label: Label
signal quest_closed


func _ready():
	quest_label = $QuestPlace/MarginContainer2/Label

func _process(delta):
	pass

func _set_label(new_text: String):
	quest_label.text = new_text

func _on_ok_button_pressed():
	self.visible = false
	quest_closed.emit()

func appear():
	animate_quest_window()
	self.visible = true

func animate_quest_window():
	var start_y = self.position.y
	var up_y = start_y - 10

	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", up_y, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", start_y, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
