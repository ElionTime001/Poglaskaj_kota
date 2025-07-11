extends Control

var quest_label: Label
var label_at_the_top: Label
var label_with_link: RichTextLabel
signal quest_closed


func _ready():
	quest_label = $QuestPlace/MarginContainer2/Label
	label_at_the_top = $NewQuest
	label_with_link = $QuestPlace/MarginContainer2/Label2
	label_at_the_top.visible = false

func _process(delta):
	pass

func label_at_the_top_disappear():
	label_at_the_top.visible = false

func lable_with_link_at_the_end():
	quest_label.visible = false
	label_with_link.visible = true

func label_at_the_top_appear():
	label_at_the_top.visible = true

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
