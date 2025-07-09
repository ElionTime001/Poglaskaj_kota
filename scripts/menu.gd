extends Control

signal quest_done(quest_name)

@export var badges_interface : Control
@export var controller : Node

var quest_current: Control
var quest_persistent: Control

var money_label: TextureProgressBar
var clients_label: TextureProgressBar
var annoyance_label: TextureProgressBar

var badges = []
var unlocked = {"time": false, "ease" : false, "online" : false, "random" : false}
var badge_buttons

func _ready():
	quest_current = $Quest_current
	quest_persistent = $Quest_persistent
	
	money_label = $money
	clients_label = $money/clients
	annoyance_label = $money/annoyance
	
	badges = get_tree().get_nodes_in_group("badges_menu")
	badge_buttons = get_tree().get_nodes_in_group("buttons_in_menu")
	
	for button in badge_buttons:
		button.clicked.connect(badge_clicked)

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

func unlock_badge(badge_name):
	for badge in badges:
		if badge.name == badge_name:
			badge.modulate = Color.WHITE
			unlocked[badge_name] = true

func badge_clicked(name_badge):
	if unlocked[name_badge.name]:
		badges_interface.appear(name_badge.name)
	else:
		pass

func check_if_game_finished():
	var money_maxed := false
	var clinets_maxed := false
	var annoyance_maxed := false
	if money_label.value >= money_label.max_value:
		money_maxed = true
	if clients_label.value >= clients_label.max_value:
		clinets_maxed = true
	if annoyance_label.value >= annoyance_label.max_value:
		annoyance_maxed = true
	
	if annoyance_maxed and clinets_maxed and money_maxed:
		print("Game has finished")
		controller.story_end()
	else:
		print("Game hasn't finished yet")
		
func erase_the_cat_traces():
	money_label.value -= 40
	annoyance_label.value -= 5
