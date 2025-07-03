extends Node

var flag_names = [
		#Intro flags
	"intro_dialogue_completed", "cat_clickable", "interface_clickable", "free_currency_clickable", "free_currency_clicked", "free_currency_placable", "free_currency_placed", "dragging_locked",
		#first quest flags
	"dailies_added", "login_added",
	#second chapter flags
	"shop_to_complete", "outfits_added", "energy_added", "currency_added", "gatcha_quest_in_progress"]

var states = ["intro", "tutorial_interface", "first_quest", "second_quest", "open_world"]

var is_shop_active : bool
var is_gatcha_active : bool

var flags = {}

var current_state

func _ready():
	
	is_shop_active = false
	is_gatcha_active = false
	
	for name in flag_names:
		flags[name] = false
		
	flags["dragging_locked"] = true
	
	current_state = "intro"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_flag(key: String):
	return flags[key]

func get_state_name():
	return current_state

func change_flag(key: String, value: bool):
	flags[key] = value

func change_state(state_name: String):
	current_state = state_name
