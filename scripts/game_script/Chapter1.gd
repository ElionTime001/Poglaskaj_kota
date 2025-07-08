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
@export var windows: Control
@export var show_numbers: Control
@export var badges : Control

var current_moment : String

var buttons_recquired_for_loss_aversion = {}


func _ready():
	interface.button_dropped.connect(check_if_proceed)
	
func story_proceed(button_name:=""):
	current_moment = Flags.get_state_name()
	match current_moment:
		"intro":
			#intro logic
			#aktywowanie po kliknięciu kłota
			if Flags.get_flag("intro_dialogue_completed"):
				await get_tree().create_timer(1).timeout
				Flags.change_flag("cat_clickable", false)
				dialogue_player.play_dialogue("intro_after_clicked")
				await dialogue_player.dialogue_finished
				await get_tree().create_timer(0.5).timeout
				speech_bubble.play_dialogue("tutorial_1")
				Flags.change_flag("interface_clickable", true)
				#Interface Add tutorial
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
				for_the_player.node_disappear_ingame("coin")
				await speech_bubble.dialogue_finished
				await get_tree().create_timer(0.2).timeout
				display_quest_change("Dodaj do interfejsu darmową walutę (0/1)")
				
				#czekanie na drop
				
				await wait_for_specific_button_dropped("freeCurrency")
				#for_the_player.node_disappear_ingame("coin")
				await add_statistics("freeCurrency")
				#await get_tree().create_timer(0.5).timeout
				dialogue_player.play_dialogue("tutorial_1_dragged")
				Flags.change_state("first_quest")
				await dialogue_player.dialogue_finished
				await get_tree().create_timer(0.2).timeout
				display_quest_change("Dodaj do interfejsu elementy, które zachęcają graczy do regularnego powrotu do gry (0/2)")
				await quest_alert.quest_closed
				speech_bubble.play_dialogue("menu_tutorial")
				await speech_bubble.dialogue_finished
				for_the_player.node_appear_ingame("arrow_menu", false)
				await interface.menu_clicked
				for_the_player.node_disappear_ingame("arrow_menu", false)
				
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
				#AFTER BOTH CONDITIONS ARE GOOD! Otherwise logic in check if proceed
				print("SUCCESS FIRST QUEST!")
				await get_tree().create_timer(0.5).timeout
				dialogue_player.play_dialogue("fomo_question_1", false)
				await dialogue_player.dialogue_finished
				answers.change_visible("answer_3", false)
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
					await dialogue_player.dialogue_finished
					answers.change_visible("answer_3", true)
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
				dialogue_player.play_dialogue("fomo_end", false)
				Flags.change_state("second_quest")
				await dialogue_player.dialogue_finished
				story_proceed()
				
			else:
				print("Not first quest success yet")
		"second_quest":
			
			if !Flags.get_flag("shop_to_complete"):
				#TUTAJ WSTĘP I WEJŚCIE DO SKLEPU
				print("In second quest")
				await get_tree().create_timer(0.2).timeout
				dialogue_player.play_dialogue("story_1")
				await dialogue_player.dialogue_finished
				var shop = item_box.shop_button
				await get_tree().create_timer(0.2).timeout
				item_box.make_invisible(shop)
				interface.make_button_visible(shop, false)
				for_the_player.node_appear_ingame("arrow_shop", false)
				Flags.change_flag("shop_to_complete", true)
				#WEJŚCIE DO SKLEPU
				await wait_for_specific_button_dropped("shop",true)
				for_the_player.node_disappear_ingame("arrow_shop", false)
				await get_tree().create_timer(0.2).timeout
				speech_bubble.play_dialogue("story_2")
				await speech_bubble.dialogue_finished
				for_the_player.node_appear_ingame("arrow_add", false)
				await get_tree().create_timer(0.2).timeout
				speech_bubble.play_dialogue("shop_tutorial")
				await speech_bubble.dialogue_finished
				for_the_player.node_disappear_ingame("arrow_add", false)
				display_quest_change("Spróbuj wypełnić sklep przynajmniej trzema produktami (0/3)")
				await quest_alert.quest_closed
				
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
				Flags.change_flag("shop_completed",true)
				dialogue_player.play_dialogue("shop_after_all_gathered")
				await dialogue_player.dialogue_finished
				await wait_for_specific_button_dropped("paidCurrencyButton", false, true)
				dialogue_player.play_dialogue("paid_currency_chosen")
				shop.change_for_coins()
				await appear_badge("ease")
				await shop.shop_closed
				await get_tree().create_timer(0.2).timeout
				dialogue_player.play_dialogue("story_almost_end")
				await dialogue_player.dialogue_finished
				display_quest_change("Spróbuj wypełnić do końca wszystkie statystyki w menu.")
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
		"tutorial_interface":
				match button.name:
					"freeCurrency":
						#await add_statistics(button.name)
						pass
					_:
						dialogue_player.play_dialogue("incorrect_auto_response_interface")
						await dialogue_player.dialogue_finished
						interface.return_button(button)
		"first_quest":
			var were_dailies_added = Flags.get_flag("dailies_added")
			var was_login_added = Flags.get_flag("login_added")
			match button.name: 
				"dailies":
					buttons_recquired_for_loss_aversion[button.name] = false
					Flags.change_flag("dailies_added",true)
					
					await add_statistics(button.name)
					windows.open_window(button.name)
					
					if was_login_added:
						dialogue_player.play_dialogue("dailies_login")
						await dialogue_player.dialogue_finished
						menu.make_quest_change(increment_quest_progress(menu.get_quest_text()),true, true)
						await windows.window_closed
						story_proceed()
					else:
						menu.make_quest_change(increment_quest_progress(menu.get_quest_text()),true, true)
						dialogue_player.play_dialogue("dailies_not_login")
						#O wyrabianiu nawyków
						
						await windows.window_closed
						await get_tree().create_timer(0.2).timeout
						dialogue_player.play_dialogue("wyrabianie_nawyku")
						await dialogue_player.dialogue_finished
						
				"login":
					buttons_recquired_for_loss_aversion[button.name] = false
					Flags.change_flag("login_added",true)
					
					await add_statistics(button.name)
					windows.open_window(button.name)
					
					if were_dailies_added:
						menu.make_quest_change(increment_quest_progress(menu.get_quest_text()),true, true)
						dialogue_player.play_dialogue("login_dailies")
						await dialogue_player.dialogue_finished
						await windows.window_closed
						story_proceed()
					else:
						menu.make_quest_change(increment_quest_progress(menu.get_quest_text()),true, true)
						dialogue_player.play_dialogue("login_not_dailies")
						#O wyrabianiu nawyku
						await windows.window_closed
						await get_tree().create_timer(0.2).timeout
						dialogue_player.play_dialogue("wyrabianie_nawyku")
						await dialogue_player.dialogue_finished
				_:
					#ewentualnie można tutaj dać bardziej custom rzeczy
					dialogue_player.play_dialogue("incorrect_auto_response_quest_1")
					await dialogue_player.dialogue_finished
					interface.return_button(button)
					
		"second_quest":
			match button.name: 
				"paidCurrency":
					await add_statistics(button.name)
					windows.open_window(button.name)
					#await windows.window_closed
					dialogue_player.play_dialogue("paid_currency")
					await dialogue_player.dialogue_finished
				"energy":
					await add_statistics(button.name)
					buttons_recquired_for_loss_aversion[button.name] = false
					windows.open_window(button.name)
					dialogue_player.play_dialogue("energy")
					await dialogue_player.dialogue_finished
					await appear_badge("time")
					#BADGE APPEAR
				"skinCollection":
					await add_statistics(button.name)
					dialogue_player.play_dialogue("skin_collection")
					windows.open_window(button.name)
					await dialogue_player.dialogue_finished
				"gatcha":
					await add_statistics(button.name)
					buttons_recquired_for_loss_aversion[button.name] = false
					windows.open_window(button.name)
					dialogue_player.play_dialogue("gatcha_added")
					await dialogue_player.dialogue_finished
				"gatchaAd":
					buttons_recquired_for_loss_aversion[button.name] = false
					var is_gatcha_finished = Flags.get_flag("gatcha_quest_finished")
					if is_gatcha_finished:
						await add_statistics(button.name)
						windows.open_window(button.name)
						dialogue_player.play_dialogue("gatcha_ad_yes")
					else:
						dialogue_player.play_dialogue("gatcha_ad_no")
						await dialogue_player.dialogue_finished
						interface.return_button(button)
				"pig":
					await add_statistics(button.name)
					windows.open_window(button.name)
					var sunk_cost = Flags.get_flag("sunk_cost_fallacy_explained")
					
					if !sunk_cost:
						await get_tree().create_timer(0.2).timeout
						dialogue_player.play_dialogue("sunk_cost_fallacy", false)
						await dialogue_player.dialogue_finished
						answers.change_visible("answer_3", false)
						answers.change_label("answer_1", "Tak")
						answers.change_label("answer_2", "Nie")
						answers.visible = true
						var answer = await answers.answer_chosen
						answers.visible =  false
						match answer:
							"1":
								dialogue_player.play_dialogue("sunk_cost_fallacy_yes", false)
							"2":
								dialogue_player.play_dialogue("sunk_cost_fallacy_no", false)
						await dialogue_player.dialogue_finished
						Flags.change_flag("sunk_cost_fallacy_explained", true)
						
					await get_tree().create_timer(0.2).timeout
					dialogue_player.play_dialogue("money_pig", false)
					await dialogue_player.dialogue_finished
					answers.change_visible("answer_3", true)
					answers.change_label("answer_1", "FOMO")
					answers.change_label("answer_2", "Sunk Cost Fallacy")
					answers.change_label("answer_3", "Wyrabianie nawyków")
					answers.visible = true
					var answer = await answers.answer_chosen
					answers.visible =  false
					match answer:
						"1":
							dialogue_player.play_dialogue("pig_fomo", false)
						_:
							dialogue_player.play_dialogue("pig_wrong", false)
					await dialogue_player.dialogue_finished
					dialogue_player.play_dialogue("money_pig_after_fomo", false)
					await dialogue_player.dialogue_finished
					answers.visible = true
					answer = await answers.answer_chosen
					answers.visible =  false
					match answer:
						"2":
							dialogue_player.play_dialogue("pig_2_sunk_cost", false)
						_:
							dialogue_player.play_dialogue("pig_2_wrong", false)
					await dialogue_player.dialogue_finished
					await get_tree().create_timer(0.2).timeout
					dialogue_player.play_dialogue("pig_sunk_cost_after")
					await dialogue_player.dialogue_finished
				"achievements":
					await add_statistics(button.name)
					windows.open_window(button.name)
					dialogue_player.play_dialogue("achievements")
					await dialogue_player.dialogue_finished
				"catCollection":
					await add_statistics(button.name)
					windows.open_window(button.name)
					dialogue_player.play_dialogue("cat_collection")
					await dialogue_player.dialogue_finished
				"specialOffer":
					var is_shop_finished = Flags.get_flag("shop_completed")
					if is_shop_finished:
						windows.open_window(button.name)
						await add_statistics(button.name)
						buttons_recquired_for_loss_aversion[button.name] = false
						dialogue_player.play_dialogue("special_offer_yes")
						#tu może jeszcze pytanie o Sunk Cost?
						await dialogue_player.dialogue_finished
						await windows.window_closed
						await get_tree().create_timer(0.5).timeout
						dialogue_player.play_dialogue("free_reward")
						await dialogue_player.dialogue_finished
						#should have a flag for not activating buttons??!!!
						Flags.is_choosing_answer = true
						while true:
							var clicked_button = await interface.interface_button_clicked
							print(button.name)
							match clicked_button.name:
								"shop":
									dialogue_player.play_dialogue("free_reward_correct")
									await dialogue_player.dialogue_finished
									#SHOULD OPEN SHOP HERE!!!
									break
								_:
									dialogue_player.play_dialogue("free_reward_again")
									await dialogue_player.dialogue_finished
						Flags.is_choosing_answer = false
					else:
						dialogue_player.play_dialogue("special_offer_no")
						await dialogue_player.dialogue_finished
						interface.return_button(button)
				"battlePass":
					
					await add_statistics(button.name)
					windows.open_window(button.name)
					buttons_recquired_for_loss_aversion[button.name] = false
					dialogue_player.play_dialogue("battle_pass")
					await dialogue_player.dialogue_finished
					#LOSS AVERSION
					#loss_aversion
					await windows.window_closed
					await get_tree().create_timer(0.5).timeout
					dialogue_player.play_dialogue("loss_aversion")
					await dialogue_player.dialogue_finished
					#które elementy mogą wywołać loss aversion?
					#choosing
					Flags.is_choosing_answer = true
					while !all_clicked(buttons_recquired_for_loss_aversion):
							var clicked_button = await interface.interface_button_clicked
							print(button.name)
							if buttons_recquired_for_loss_aversion.has(clicked_button.name):
								if buttons_recquired_for_loss_aversion[clicked_button.name]:
									pass #play "To już było, wybierz coś innego
								else:
									match clicked_button.name:
										"login":
											speech_bubble.play_dialogue("loss_version_default")
											await speech_bubble.dialogue_finished
											buttons_recquired_for_loss_aversion[clicked_button.name] = true
										 	#DODAĆ RESZTĘ dailies, login, ads x2, battle_pass, energia i opisy
										"dailies":
											speech_bubble.play_dialogue("loss_version_default")
											await speech_bubble.dialogue_finished
											buttons_recquired_for_loss_aversion[clicked_button.name] = true
										"gatchaAd":
											speech_bubble.play_dialogue("loss_version_default")
											await speech_bubble.dialogue_finished
											buttons_recquired_for_loss_aversion[clicked_button.name] = true
										"specialOffer":
											speech_bubble.play_dialogue("loss_version_default")
											await speech_bubble.dialogue_finished
											buttons_recquired_for_loss_aversion[clicked_button.name] = true
										"gatcha":
											speech_bubble.play_dialogue("loss_version_default")
											await speech_bubble.dialogue_finished
											buttons_recquired_for_loss_aversion[clicked_button.name] = true
										"energy":
											dialogue_player.play_dialogue("loss_aversion_energy")
											await dialogue_player.dialogue_finished
											buttons_recquired_for_loss_aversion[clicked_button.name] = true
										"battlePass":
											speech_bubble.play_dialogue("loss_aversion_battle_pass")
											await speech_bubble.dialogue_finished
											buttons_recquired_for_loss_aversion[clicked_button.name] = true
							else:
								pass # Tutaj daj coś jak "hmmm, inne"
					Flags.is_choosing_answer = false
					await get_tree().create_timer(0.2).timeout
					dialogue_player.play_dialogue("loss_eversion_end")
					await dialogue_player.dialogue_finished
				"onlineLeaderboard":
					await add_statistics(button.name)
					windows.open_window(button.name)
					dialogue_player.play_dialogue("online_leaderboard")
					await dialogue_player.dialogue_finished
					await appear_badge("online")
		_:
			print("Nothing of note")

func gatcha_sidequest_proceed(gatcha_node = null):
	var skins_gatcha = Flags.get_flag("skins_gatcha")
	var characters_gatcha = Flags.get_flag("characters_gatcha")
	var first_entered = Flags.get_flag("gatcha_first_entered")
	
	var sunk_cost_fallacy_explained = Flags.get_flag("sunk_cost_fallacy_explained")
	
	if !skins_gatcha or !characters_gatcha:
		if !first_entered:
			if !sunk_cost_fallacy_explained:
				await get_tree().create_timer(0.2).timeout
				dialogue_player.play_dialogue("sunk_cost_fallacy", false)
				await dialogue_player.dialogue_finished
				answers.change_visible("answer_3", false)
				answers.change_label("answer_1", "Tak")
				answers.change_label("answer_2", "Nie")
				answers.visible = true
				var answer = await answers.answer_chosen
				answers.visible =  false
				match answer:
					"1":
						dialogue_player.play_dialogue("sunk_cost_fallacy_yes", false)
					"2":
						dialogue_player.play_dialogue("sunk_cost_fallacy_no", false)
				await dialogue_player.dialogue_finished
				Flags.change_flag("sunk_cost_fallacy_explained", true)
				dialogue_player.play_dialogue("gatcha_sunk", false)
				await dialogue_player.dialogue_finished
			else:
				await get_tree().create_timer(0.2).timeout
				dialogue_player.play_dialogue("gatcha_not_sunk", false)
				await dialogue_player.dialogue_finished
			await get_tree().create_timer(0.2).timeout
			dialogue_player.play_dialogue("gatcha")
			await dialogue_player.dialogue_finished
			display_quest_change("Dodaj dwa elementy do gatcha (0/2)", false)
			Flags.change_flag("gatcha_first_entered", true)
			await quest_alert.quest_closed
	else:
		await get_tree().create_timer(0.2).timeout
		dialogue_player.play_dialogue("gatcha_finished", false)
		await dialogue_player.dialogue_finished
		answers.change_visible("answer_3", false)
		answers.change_label("answer_1", "Tak")
		answers.change_label("answer_2", "Nie")
		answers.visible = true
		var answer = await answers.answer_chosen
		answers.visible =  false
		match answer:
			"1":
				dialogue_player.play_dialogue("gatcha_finished_yes", false)
			"2":
				dialogue_player.play_dialogue("gatcha_finished_no", false)
		await dialogue_player.dialogue_finished
		await get_tree().create_timer(0.2).timeout
		dialogue_player.play_dialogue("gatcha_finished_explanation", true)
		Flags.change_flag("gatcha_quest_finished", true)
		await dialogue_player.dialogue_finished
		await appear_badge("random")
	
func display_quest_change(new_line: String, is_current:= true):
	menu.make_quest_change(new_line, is_current)
	quest_alert._set_label(new_line)
	quest_alert.appear()

func increment_quest_progress(quest_text: String) -> String:
	var start_idx := quest_text.find("(")
	var end_idx := quest_text.find(")")

	if start_idx == -1 or end_idx == -1:
		push_warning("No progress found!")
		return quest_text

	# Extract "X/Y"
	var progress := quest_text.substr(start_idx + 1, end_idx - start_idx - 1)
	var parts := progress.split("/")

	if parts.size() != 2:
		push_warning("Progress format invalid!")
		return quest_text

	var current := int(parts[0])
	var total := int(parts[1])

	current += 1
	if current > total:
		current = total

	var new_progress := "(" + str(current) + "/" + str(total) + ")"

	# Replace old "(X/Y)" with new one
	var updated := quest_text.substr(0, start_idx) + new_progress + quest_text.substr(end_idx + 1)

	return updated

func all_clicked(flags):
	for key in flags.keys():
		if !flags[key]:
			return false
	return true

func add_statistics(panel_name):
	var panel_data = DataFiles.read_panel_data(panel_name)
	var mon = panel_data["money"]
	var hab = panel_data["habit"]
	var ir = panel_data["annoyance"]
	menu.add_values_to_progress_bars(int(mon),int(hab),int(ir))
	await show_numbers.appear_disappear(str(mon),str(hab),str(ir))
	
func appear_badge(name_badge: String):
	menu.unlock_badge(name_badge)
	badges.appear(name_badge)
	await badges.badge_window_closed
