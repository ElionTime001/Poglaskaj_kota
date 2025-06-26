extends Node

@export var dialogue_player: Control
@export var speech_bubble: Control

var current_moment : String


func _ready():
	pass
	
func story_proceed():
	current_moment = Flags.get_state_name()
	match current_moment:
		"intro":
			#intro logic
			if Flags.get_flag("intro_dialogue_completed"):
				#change state of intro to next
				pass
			else:
				print("completed the first dialogue and clicked the cat")
				speech_bubble.play_dialogue("intro")


func value_change():
	pass
