extends Control

signal quest_done(quest_name)

var quest_current: Control
var quest_persistent: Control

var money_label: TextureProgressBar
var clients_label: TextureProgressBar
var annoyance_label: TextureProgressBar

func _ready():
	quest_current = $Quest_current
	quest_persistent = $Quest_persistent
	
	money_label = $money
	clients_label = $money/clients
	annoyance_label = $money/annoyance

func make_quest_finished(quest_name: String, is_current:= true):
	var quest 
	if is_current:
		quest = quest_current
	else:
		quest = quest_persistent
	quest._quest_finished(quest_name)
	quest_done.emit(quest_name)

func make_quest_change(new_text: String, is_current:= true, is_updated:=false):
	var quest 
	if is_current:
		quest = quest_current
	else:
		quest = quest_persistent
		
	if is_updated:
		quest.change_quest_label(new_text)
	else:
		quest.visible = true
		quest._quest_restarted(new_text)
		
	

func _on_close_item_box_pressed():
	self.visible = false
