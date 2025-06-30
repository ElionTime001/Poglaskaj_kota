extends Control

var label: Label
var check_ok: TextureRect
var check_not_ok: TextureRect

signal quest_finished(quest_name)

func _ready():
	label = $MarginContainer/Label
	check_not_ok = $check_not_ok
	check_ok = $check_ok

func _quest_finished(quest_name: String):
	check_ok.visible = true
	quest_finished.emit(quest_name)
	
func _quest_restarted(new_text: String):
	check_ok.visible = false
	change_quest_label(new_text)

func change_quest_label(new_text: String):
	label.text = new_text

func _process(delta):
	pass
