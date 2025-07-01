extends Control

var quest_label: Label


func _ready():
	quest_label = $QuestPlace/MarginContainer2/Label

func _process(delta):
	pass

func _set_label(new_text: String):
	quest_label.text = new_text

func _on_ok_button_pressed():
	self.visible = false
