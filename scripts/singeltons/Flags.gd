extends Node

var flag_names = ["intro_dialogue_completed", "cat_clickable"]
var states = ["intro"]
var flags = {}
var current_state

func _ready():

	for name in flag_names:
		flags[name] = false
	
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
