extends Node

@export var dialogue_player: Control
@export var speech_bubble: Control
@export var item_box : Control
@export var interface: Control

var current_moment : String


func _ready():
	interface.button_dropped.connect(check_if_proceed)
	
func story_proceed():
	current_moment = Flags.get_state_name()
	match current_moment:
		"intro":
			#intro logic
			if Flags.get_flag("intro_dialogue_completed"):
				Flags.change_flag("cat_clickable", false)
				dialogue_player.play_dialogue("intro_after_clicked")
				await dialogue_player.dialogue_finished
				await get_tree().create_timer(0.5).timeout
				speech_bubble.play_dialogue("tutorial_1")
				Flags.change_flag("interface_clickable", true)
				Flags.change_state("tutorial_interface")
			else:
				speech_bubble.play_dialogue("intro")
				Flags.change_flag("cat_clickable", true)
				Flags.change_flag("intro_dialogue_completed", true)
				print("completed the first dialogue and clicked the cat")
		"tutorial_interface":
			#for the tutorial and free currency
			var was_currency_placed = Flags.get_flag("free_currency_placed")
			var was_currency_clicked = Flags.get_flag("free_currency_clicked")
			
			if !was_currency_placed and !was_currency_clicked:
				Flags.change_flag("interface_clickable", false)
				Flags.change_flag("free_currency_clickable", true)
				await get_tree().create_timer(0.3).timeout
				speech_bubble.play_dialogue("tutorial_1_5")
				await wait_for_specific_button_clicked("freeCurrency")
				Flags.change_flag("free_currency_clicked", true)
				speech_bubble.play_dialogue("tutorial_1_clicked")
				await wait_for_specific_button_dropped("freeCurrency")
				await get_tree().create_timer(0.5).timeout
				dialogue_player.play_dialogue("tutorial_1_dragged")
				Flags.change_state("first_quest")
			elif was_currency_clicked:
				pass
				#here after clicking
			elif was_currency_placed:
				pass
				#here after placing
		"first_quest":
			#first quest logic
			print("congrats, you're in the first quest")
			var were_dailies_added = Flags.get_flag("dailies_added")
			var was_login_added = Flags.get_flag("login_added")
			print(were_dailies_added)
			print(was_login_added)
			
			if was_login_added and were_dailies_added:
				print("SUCCESS FIRST QUEST!")
		_:
			print("Story has nowhere to proceed")


func value_change():
	pass

func wait_for_specific_button_clicked(target_name: String):
	while true:
		var button = await item_box.item_clicked
		print(button.name)
		if button.name == target_name:
			print("Clicked the right one:", target_name)
			return button
			
func wait_for_specific_button_dropped(target_name: String):
	while true:
		var button = await interface.button_dropped
		print(button.name)
		if button.name == target_name:
			print("Dropped the right one:", target_name)
			return button

func check_if_proceed(button):
	current_moment = Flags.get_state_name()
	match current_moment:
		"first_quest":
			var were_dailies_added = Flags.get_flag("dailies_added")
			var was_login_added = Flags.get_flag("login_added")
			match button.name: 
				"dailies":
					Flags.change_flag("dailies_added",true)
					if was_login_added:
						dialogue_player.play_dialogue("dailies_login")
						await dialogue_player.dialogue_finished
						story_proceed()
					else:
						dialogue_player.play_dialogue("dailies_not_login")
				"login":
					Flags.change_flag("login_added",true)
					if were_dailies_added:
						dialogue_player.play_dialogue("login_dailies")
						await dialogue_player.dialogue_finished
						story_proceed()
					else:
						dialogue_player.play_dialogue("login_not_dailies")
		_:
			print("Nothing of note")
