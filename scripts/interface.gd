extends Control

@export var windows: Control
@export var energy_bar: Control
@export var gatcha : Control
@export var dialogue_player : Control

@export var paid_currency_label: Label
@export var free_currency_label: Label
@export var energy_label: Label

signal button_clicked(button)
signal button_dropped(button)
signal energy_dropped

var buttons := []
var nazwy := []

var main_menu_button: TextureButton
var add_element_button: TextureButton
var catto_pat_button: Button
var back_to_shop_button: TextureButton

signal interface_button_clicked(button)
signal button_returned(button)
signal menu_clicked


# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_button = $MainMenuButton
	add_element_button = $AddElementButton
	catto_pat_button = $petButton
	back_to_shop_button = $BackToShopButton
	
	buttons = get_tree().get_nodes_in_group("mainscreenbutton")
	nazwy = get_tree().get_nodes_in_group("interface_name")
	
	for button in buttons:
		button.visible = false
		print(button.name)
		button.clicked.connect(interface_button_pressed)
	
	hide_back_to_shop()
	make_names_invisible()
		
	main_menu_button.visible = false
	add_element_button.visible = false


func _process(delta):
	pass
	
func make_names_visible():
	for name in nazwy:
		name.visible = true

func make_names_invisible():
	for name in nazwy:
		name.visible = false

func make_button_visible(button, is_drag_preview_there:=true):
	var button_name = button.name
	for right_button in buttons:
		if right_button.name == button_name:
			right_button.visible = true
			break
	if is_drag_preview_there:
		button_dropped.emit(button)
	if button.name == "energy":
		if Flags.get_state_name() == "second_quest":
			energy_bar.visible = true
			energy_dropped.emit()

func return_button(button):
	var button_name = button.name
	for right_button in buttons:
		if right_button.name == button_name:
			right_button.visible = false
			break
	button_returned.emit(button)

func _on_main_menu_button_pressed():
	button_clicked.emit(main_menu_button)
	menu_clicked.emit()


func _on_add_element_button_pressed():
	button_clicked.emit(add_element_button)

func hide_menu():
	main_menu_button.visible = false
	add_element_button.visible = false

func show_menu():
	main_menu_button.visible = true
	add_element_button.visible = true
	
func show_back_to_shop():
	back_to_shop_button.visible = true
	
func hide_back_to_shop():
	back_to_shop_button.visible = false

func _on_pet_button_pressed():
	button_clicked.emit(catto_pat_button)
	
func interface_button_pressed(button):
	print(button.name + " pressed")
	interface_button_clicked.emit(button)
	if !Flags.is_shop_active and !Flags.is_gatcha_active and !Flags.is_choosing_answer:
		if button.name == "gatchaAd":
			gatcha.visible = true
		else:
			windows.open_window(button.name)
			if button.name == "shop" and Flags.get_flag("outfits_lost") and Flags.get_flag("outfits_added") and !Flags.get_flag("outfits_lost_cutscene_done"):
				dialogue_player.play_dialogue("shop_after_disappear")
				Flags.change_flag("outfits_lost_cutscene_done", true)
				await dialogue_player.dialogue_finished

func get_currency(currency_name: String):
	match currency_name:
		"freeCurrency":
			return free_currency_label.text
		"paidCurrency":
			return paid_currency_label.text
		"energy":
			return energy_label.text.substr(0, 1)

func set_currency(currency_name: String, new_value: String):
	match currency_name:
		"freeCurrency":
			free_currency_label.text = new_value
		"paidCurrency":
			paid_currency_label.text = new_value
		"energy":
			energy_label.text = new_value + "/5"
