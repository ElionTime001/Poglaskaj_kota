extends "res://scripts/window_scirpt.gd"

@export var quest_finished_1: TextureRect
@export var quest_finished_2: TextureRect
@export var quest_finished_3: TextureRect

@export var claim : TextureRect

var quest_done_1 := false
var quest_done_2 := false
var quest_done_3 := false

var checkmarks = []

var rewards_to_give = {"dailies_1": false, "dailies_2": false, "dailies_3": false}

signal give_rewards(name, amount)

func _ready():
	#await get_tree().create_timer(1).timeout
	#appear_and_scale(quest_finished_1)
	checkmarks = [quest_finished_1,quest_finished_2,quest_finished_3]

func _process(delta):
	pass

func check_mission(checkmark_name: String):
	for check in checkmarks:
		if check.name == checkmark_name:
			appear_and_scale(check)
			break

func check_quests():
	var amount_of_pats = Flags.amount_of_pats
	var energy_used_up = Flags.amount_of_energy_used
	
	print("amounts of pats: " + str(amount_of_pats) + " , amount of energy: " + str(energy_used_up))
	if !quest_done_1:
		check_mission("checkmark_1")
		rewards_to_give["dailies_1"] = true
		quest_done_1 = true

	if !quest_done_3:
		if amount_of_pats >= 10:
			check_mission("checkmark_3")
			rewards_to_give["dailies_3"] = true
			quest_done_3 = true
	
	if !quest_done_2:
		if energy_used_up >=5:
			check_mission("checkmark_2")
			rewards_to_give["dailies_2"] = true
			quest_done_2 = true
	give_out_rewards()

func give_out_rewards():
	for key in rewards_to_give:
		var value = rewards_to_give[key]
		if value == true:
			match key:
				"dailies_1":
					await get_tree().create_timer(0.5).timeout
					give_rewards.emit("freeCurrency", "10")
					rewards_to_give["dailies_1"] = false
					await claim.window_closed
				"dailies_2":
					await get_tree().create_timer(0.5).timeout
					give_rewards.emit("freeCurrency", "30")
					rewards_to_give["dailies_2"] = false
					await claim.window_closed
				"dailies_3":
					await get_tree().create_timer(0.5).timeout
					give_rewards.emit("paidCurrency", "1")
					rewards_to_give["dailies_3"] = false
					await claim.window_closed
			

func appear_and_scale(my_panel):
	my_panel.scale = Vector2(1.5, 1.5)  # 150% size
	my_panel.modulate.a = 0.0  # fully transparent

	var tween = create_tween()
	tween.tween_property(my_panel, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(my_panel, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
