extends Node

@export var dialogue_player: Control
@export var speech_bubble: Control
@export var item_box : Control
@export var interface: Control
@export var answers: Control
@export var shop: Control
@export var menu: Control
@export var quest_alert: Control
@export var for_the_player : Control

var current_moment : String


func _ready():
	interface.button_dropped.connect(check_if_proceed)
	
	
func story_proceed(button_name:=""):
	current_moment = Flags.get_state_name()
	match current_moment:
		"intro":
			#intro logic
			#aktywowanie po kliknięciu kłota
			if Flags.get_flag("intro_dialogue_completed"):
				Flags.change_flag("cat_clickable", false)
				dialogue_player.play_dialogue("intro_after_clicked")
				await dialogue_player.dialogue_finished
				await get_tree().create_timer(0.5).timeout
				speech_bubble.play_dialogue("tutorial_1")
				Flags.change_flag("interface_clickable", true)
				Flags.change_state("tutorial_interface")
				interface.show_menu()
				for_the_player.node_appear_ingame("arrow_add", false)
			else: #sam początek
				speech_bubble.play_dialogue("intro")
				Flags.change_flag("cat_clickable", true)
				Flags.change_flag("intro_dialogue_completed", true)
				print("completed the first dialogue and clicked the cat")
		"tutorial_interface":
			#for the tutorial and free currency
			var was_currency_placed = Flags.get_flag("free_currency_placed")
			var was_currency_clicked = Flags.get_flag("free_currency_clicked")
			
			if !was_currency_placed and !was_currency_clicked:
				#Przed klikknięciem free currency
				for_the_player.node_disappear_ingame("arrow_add", false)
				for_the_player.node_appear_ingame("coin")
				Flags.change_flag("interface_clickable", false)
				Flags.change_flag("free_currency_clickable", true)
				await get_tree().create_timer(0.3).timeout
				speech_bubble.play_dialogue("tutorial_1_5")
				await wait_for_specific_button_clicked("freeCurrency")
				Flags.change_flag("free_currency_clicked", true)
				
				# PO KLIKNIĘCIU FREE CURRENCY
				speech_bubble.play_dialogue("tutorial_1_clicked")
				Flags.change_flag("dragging_locked", false)
				
				#czekanie na drop
				await wait_for_specific_button_dropped("freeCurrency")
				for_the_player.node_disappear_ingame("coin")
				await get_tree().create_timer(0.5).timeout
				dialogue_player.play_dialogue("tutorial_1_dragged")
				Flags.change_state("first_quest")
				await dialogue_player.dialogue_finished
				menu.make_quest_change("Dodaj do interfejsu elementy, które zachęcają graczy do regularnego powrotu do gry (0/2)")
				quest_alert._set_label("Dodaj do interfejsu elementy, które zachęcają graczy do regularnego powrotu do gry (0/2)")
				quest_alert.visible = true
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
				await get_tree().create_timer(0.5).timeout
				dialogue_player.play_dialogue("fomo_question_1", false)
				await dialogue_player.dialogue_finished
				answers.change_visible("answer_3")
				answers.visible = true
				var answer = await answers.answer_chosen
				answers.visible =  false
				#Tak
				if answer == "1":
					dialogue_player.play_dialogue("fomo_answer_1_yes", false)
					await dialogue_player.dialogue_finished
				elif answer == "2":
					dialogue_player.play_dialogue("fomo_answer_1_no", false)
					await dialogue_player.dialogue_finished
				await get_tree().create_timer(0.2).timeout
				dialogue_player.play_dialogue("fomo_question_2", false)
				await dialogue_player.dialogue_finished
				answers.visible = true
				answer = await answers.answer_chosen
				answers.visible =  false
				if answer == "1":
					await get_tree().create_timer(0.2).timeout
					dialogue_player.play_dialogue("fomo_answer_2_yes", false)
					answers.change_visible("answer_3")
					answers.change_label("answer_1", "Zadania Codzienne")
					answers.change_label("answer_2", "Nagrody za Logowanie")
					answers.change_label("answer_3", "Oba")
					answers.visible = true
					answer = await answers.answer_chosen
					answers.visible =  false
					match answer:
						"1":
							dialogue_player.play_dialogue("fomo_answer_2_maybe", false)
						"2":
							dialogue_player.play_dialogue("fomo_answer_2_maybe", false)
						"3":
							dialogue_player.play_dialogue("fomo_answer_3_both", false)
				elif answer == "2":
					dialogue_player.play_dialogue("fomo_answer_2_no", false)
				await dialogue_player.dialogue_finished
				await get_tree().create_timer(0.2).timeout
				dialogue_player.play_dialogue("fomo_end")
				Flags.change_state("second_quest")
				await dialogue_player.dialogue_finished
				story_proceed()
				
			else:
				print("Not first quest success yet")
		"second_quest":
			if !Flags.get_flag("shop_to_complete"):
				print("In second quest")
				await get_tree().create_timer(0.2).timeout
				dialogue_player.play_dialogue("story_1")
				await dialogue_player.dialogue_finished
				var shop = item_box.shop_button
				await get_tree().create_timer(0.2).timeout
				item_box.make_invisible(shop)
				interface.make_button_visible(shop, false)
				Flags.change_flag("shop_to_complete", true)
				await wait_for_specific_button_dropped("shop",true)
				await get_tree().create_timer(0.2).timeout
				speech_bubble.play_dialogue("story_2")
				
			else:
				match button_name:
					"paidCurrency":
						Flags.change_flag("currency_added",true)
					"energy":
						Flags.change_flag("energy_added",true)
					"skinCollection":
						Flags.change_flag("outfits_added",true)
						
			var currency_flag = Flags.get_flag("currency_added")
			var energy_flag = Flags.get_flag("energy_added")
			var outfits_flag = Flags.get_flag("outfits_added")
			
			if currency_flag and energy_flag and outfits_flag:
				dialogue_player.play_dialogue("shop_after_all_gathered")
				await dialogue_player.dialogue_finished
				await wait_for_specific_button_dropped("paidCurrencyButton", false, true)
				dialogue_player.play_dialogue("paid_currency_chosen")
				await shop.shop_closed
				await get_tree().create_timer(0.2).timeout
				dialogue_player.play_dialogue("story_almost_end")
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
			
func wait_for_specific_button_dropped(target_name: String, clicked:=false, in_shop:=false):
	while true:
		var button
		if clicked:
			button = await interface.interface_button_clicked
		elif in_shop:
			button = await shop.button_has_been_clicked
		else:
			button = await interface.button_dropped
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
		"second_quest":
			match button.name: 
				"paidCurrency":
					dialogue_player.play_dialogue("paid_currency")
				"energy":
					dialogue_player.play_dialogue("energy")
					await dialogue_player.dialogue_finished
				"skinCollection":
					dialogue_player.play_dialogue("outfits")
		_:
			print("Nothing of note")
