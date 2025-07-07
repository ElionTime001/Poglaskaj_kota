extends Control

var windows = []

@export var interface: Control
@export var dialogue_player: Control

@export var dailies: TextureRect
@export var button_claim: Button
@export var claim_window: TextureRect
@export var login: TextureRect

signal window_opened(window_name)
signal window_closed(window_name)
signal currency_claimed(type, number)

var was_login_already_opened := false
var was_dialogue_already_open := false

# Called when the node enters the scene tree for the first time.
func _ready():
	windows = get_tree().get_nodes_in_group("windows")
	
	for window in windows:
		window.visible = false
		window.window_closed.connect(on_window_closed)
		
		dailies.give_rewards.connect(_give_rewards)
		

func on_window_closed(window_name):
	match window_name:
		"claim":
			currency_claimed.emit(claim_window.get_currency_number(),claim_window.get_currency_name())
		_:
			self.visible = false
			window_closed.emit(window_name)

func open_window(window_name):
	make_everything_invisible()
	
	for window in windows:
		if window.name == window_name:
			window.visible = true
			self.visible = true
			window_opened.emit(window.name)
			bounce_window(window)
			
			if window_name == "claim":
				button_claim.visible = true
			if window_name == "dailies":
				if !was_dialogue_already_open:
					await dialogue_player.dialogue_finished
					was_dialogue_already_open = true
					dailies.check_quests()
				else:
					dailies.check_quests()
			if window_name == "login" and !was_login_already_opened:
				await dialogue_player.dialogue_finished
				was_login_already_opened = true
				await login.check_mission().finished
				_give_rewards("freeCurrency","30")
			break

func make_everything_invisible():
	for window in windows:
		if window.visible:
			window.visible = false

func bounce_window(window):
	
	var tween = get_tree().create_tween()
	var start_pos = window.position
	var bounce_up = start_pos - Vector2(0, 20)

	tween.tween_property(window, "position", bounce_up, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(window, "position", start_pos, 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func checkmark_dailies(which_checkmark):
	dailies.check_mission(which_checkmark)

func _give_rewards(name, amount):
	claim_window.prepare_claim(name,amount)
	for window in windows:
		if window.name == "claim":
			window.visible = true
			bounce_window(window)
			button_claim.visible = true
