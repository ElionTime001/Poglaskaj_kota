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
				dialogue_player.play_dialogue("intro_after_clicked")
				await dialogue_player.dialogue_finished
				await get_tree().create_timer(0.5).timeout
				speech_bubble.play_dialogue("tutorial_1")
				Flags.change_state("first_quest")
			else:
				speech_bubble.play_dialogue("intro")
				Flags.change_flag("cat_clickable", true)
				Flags.change_flag("intro_dialogue_completed", true)
				print("completed the first dialogue and clicked the cat")
		"first_quest":
			#first quest logic
			print("congrats, you're in the first quest")


func value_change():
	pass
