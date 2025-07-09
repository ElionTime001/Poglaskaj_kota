extends Node

var flag_names = [
		#Intro flags
	"intro_dialogue_completed", "cat_clickable", "interface_clickable", "free_currency_clickable", "free_currency_clicked", "free_currency_placable", "free_currency_placed", "dragging_locked",
		#first quest flags
	"dailies_added", "login_added",
	#second chapter flags
	"shop_to_complete", "outfits_added", "energy_added", "currency_added", "shop_completed", "outfits_lost", "outfits_lost_cutscene_done", "gatcha_added_to_shop",
	#For gatcha
	"gatcha_quest_in_progress", "gatcha_quest_finished", "skins_gatcha", "characters_gatcha", "gatcha_first_entered", "gatcha_tried_pulling",
	"sunk_cost_fallacy_explained", "sunk_cost_fallacy_explained_here", "shop_quest_completed"]

var states = ["intro", "tutorial_interface", "first_quest", "second_quest", "open_world"]

var is_shop_active : bool
var is_gatcha_active : bool
var is_choosing_answer : bool

var was_energy_cutscene_done : bool

var flags = {}

var current_state

var amount_of_pats
var amount_of_energy_used

func _ready():
	
	is_shop_active = false
	is_gatcha_active = false
	is_choosing_answer = false
	was_energy_cutscene_done = false
	
	for name in flag_names:
		flags[name] = false
		
	flags["dragging_locked"] = true
	
	current_state = "intro"
	
	amount_of_pats = 0
	amount_of_energy_used = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_flag(key: String):
	return flags[key]

func get_state_name():
	return current_state

func change_flag(key: String, value: bool):
	flags[key] = value
	print("changed " + key + " to " + str(value))

func change_state(state_name: String):
	current_state = state_name
