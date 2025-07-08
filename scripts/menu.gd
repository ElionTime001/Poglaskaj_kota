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

func add_values_to_progress_bars(mon, hab, ir):
	money_label.value += mon
	clients_label.value += hab
	annoyance_label.value += ir

	money_label.value = clamp(money_label.value, money_label.min_value, money_label.max_value)
	clients_label.value = clamp(clients_label.value, clients_label.min_value, clients_label.max_value)
	annoyance_label.value = clamp(annoyance_label.value, annoyance_label.min_value, annoyance_label.max_value)

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
		
func get_quest_text(is_current:= true):
	var quest 
	if is_current:
		quest = quest_current
	else:
		quest = quest_persistent
	return quest.get_quest_label()

func _on_close_item_box_pressed():
	self.visible = false
